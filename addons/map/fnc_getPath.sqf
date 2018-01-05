/* ----------------------------------------------------------------------------
Function: FSH_fnc_findPath
Description:
    Gets path from A to B, avoiding given triggers

Parameters:
    ARRAY- start position
    ARRAY- end position
    ARRAY- Blacklists: can contain triggers, pos arrays (2d or 3d) and markers.
    NUMBER- size of virtual grid. Larger grid is less accurate but more cpu friendly
    NUMBER- Maximum number of loops to run.
    ARRAY- Various commands that can be passed

Commands:
    'advanced'  Once a path has been found, go back and try and cut corners
    'debug'     Draw markers on the map to visualise the path
    'noWater'   Water is considered blacklist
    'noLand'
    'truePath'

Example:
    (begin example)

    (end example)
Returns:
    STRING

Author:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

private TIME_MARKER(_start);

private _uid = GVAR(uid); INC(GVAR(uid));

params [
    "_startPos",
    "_endPos",
    ["_blAreasZ", [], [[]]],
    ["_modifiersMultiply", [], [[]]],
    ["_modifiers", [], [[]]],
    ["_runTimesMax", 800, [0]]
];

_modifiersMultiply params [
    ["_modBl", 10, [0]],
    ["_modWater", 1, [0]]
];

_modifiers params [
    ["_modSlope", 0, [0]],
    ["_modAltitude", 0, [0]]
];

private _noWater = ("NOWATER" in _this);
private _flat = ("FLAT" in _this);
private _noLand = ("NOLAND" in _this);
private _bool = ("BOOL" in _this);
private _debug = ("DEBUG" in _this);
private _range = GVAR(gridhzd);

_startingPos = [_startPos] call cba_fnc_getPos;
_endPos = [_endPos] call cba_fnc_getPos;

private _blAreas = [];
if (!(_modBl isEqualto 1)) then {
    {
        _blAreas pushBack ([_x] call cba_fnc_getArea);
    } forEach _blAreasZ;
};



/* ----------------------------------------------------------------------------
SCORE FUNCTION
---------------------------------------------------------------------------- */

private _getScore = {
    private _p = _this;
    private _pPos = (locationPosition _p);
    private _f = _p getVariable [QPGVAR(f), -1];
    if (!(_f isEqualto -1)) exitWith {_f};
    private _pp = _p getVariable [QPGVAR(p), locationNull];
	private _g = _pPos distance _startingPos;
	private _h = _pPos distance _endPos;
    _f = _g + _h;
    //Modifiers

    //-----ADDITION------//

    //Terrain slope
    if (_modSlope > 0) then {
        //private _n =  ((surfaceNormal _pPos) apply {abs _x}); _n resize 2; _n = 1 + (selectMax _n);
        private _n = _p getVariable [QGVAR(elevationVariance), 0];
        _f = _f + (_n * _modSlope);
    };

    //Altitude
    if (_modAltitude > 0) then {
        private _n1 = _p getVariable [QGVAR(averageHeight), 0];
        private _n2 = _pp getVariable [QGVAR(averageHeight), 0];
        private _n = abs (_n2 - _n1);
        _f = _f + (_n * _modAltitude);
    };


    //----MULTIPLIERS----//

    //Black list areas
    {
        private _inBl = [_x, _pPos] call BIS_fnc_inTrigger;
        if (_inBl) then {
            _f = _f * _modBl;
        };
    } forEach _blAreas;

    //Water
    private _wd = (atlToAsl _pPos) select 2;
    if (_wd < 0) then {_f = _f * _modWater};


    //Return
    _p setVariable [QPGVAR(f), _f];
    _f
};

/* ----------------------------------------------------------------------------
MAIN LOOP
---------------------------------------------------------------------------- */

private _open = [nearestLocation [_startingPos, "fsh_gridLoc"]];
private _closed = [];

private _cp = locationNull;
private _cpD = 999999;

//Main Loop
private _i = 0;
private _rt = 0;
while {_i < _runTimesMax && !(_open isEqualto [])} do {
    _open = [_open,[],{_x call _getScore},"ASCEND"] call BIS_fnc_sortBy;
    private _p = _open select 0;
    private _f = _p call _getScore;
    private _ed = _p distance _endPos;
    REM(_open, _p);
    _closed pushBack _p;

    if (false) then {
        diag_log format ["Open: %1 Closed: %2. F = %3, ED = %4", count _open, count _closed, _f, _ed];
        private _marker = [str _p, locationPosition _p, "ICON",[0.5, 0.5],"COLOR:","colorBlue","TYPE:","mil_dot","TEXT:", format["%1: f%2", _rt, floor (_f/10)]] call CBA_fnc_createMarker;
    };

    //If within range of destination, end
    if (_ed < _range) exitWith {
        _i = _runTimesMax + 1;
    };

    //Check if closest point
    if (_ed < _cpD) then {
        _cp = _p;
        _cpD = _ed;
    };

    private _connected = _p getVariable [QGVAR(linked), []];
    {
        if (!(_x in _closed)) then {
            //If its already in the open list, see if we have a better path
            if (_x in _open) then {
                //check current parent and replace if better route
                private _pScore = _x getVariable [QPGVAR(pf), 999999];
                //If we have a better parent, ammend the data
                if (_f < _pScore) then {
                    _x setVariable [QPGVAR(p), _p];
                    _x setVariable [QPGVAR(pf), _f];
                };
            } else {
                //Not in open list, so add it
                _open pushBack _x;
                _x setVariable [QPGVAR(p), _p];
                _x setVariable [QPGVAR(pf), _f];
            };
        };
    } forEach _connected;

    INC(_i);
    INC(_rt);
};

/* ----------------------------------------------------------------------------
STRUCTURE RESULTS
---------------------------------------------------------------------------- */
reverse _closed;

if (_closed isEqualto []) exitWith {
    if (_bool) then {false} else {[]};
};

//If we only need to know this route is possible, exit with true!
if (_bool) exitWith {true};

//Pathfinding finished, now get the order. If we didnt find anything near by, go with the closest point
private _lastPoint = if (_i isEqualto _runTimesMax) then {_cp} else {_closed select 0};
private _points = [];

_i = 0;
while {_i < (_runTimesMax/2) && !(_lastPoint isEqualto locationNull)} do {
	private _p = _lastPoint;
	_lastPoint = _p getVariable [QPGVAR(p), locationNull];
	_points pushBack (locationPosition _p);
    INC(_i);
};

reverse _points;

if (_debug) then {
    {
        private _marker = [str _x, _x, "ICON",[0.5, 0.5],"COLOR:","colorGreen","TYPE:","mil_triangle","TEXT:", str _forEachIndex] call CBA_fnc_createMarker;
    } forEach _points;

};

private _runTime = RUN_TIME(_start);
ADD(fshTime, _runTime);
LOG_3("found %1 waypoints in %2 loops, taking %2 ticks", (count _points), _rt, _runTime);

_points
