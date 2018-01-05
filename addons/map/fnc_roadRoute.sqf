/* ----------------------------------------------------------------------------
Description:

Parameters:

Returns:

Examples:

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
#define DEFAULT_RANGE 600
#define DEFAULT_LOOPS 3000
#define MAX_RANGE_ATTEMPTS 10;
#define OBJ_STRING(_var1)  format ["%1_%2_%3", _uid, floor ((getPos (_var1)) select 0), floor ((getPos (_var1)) select 1)]

params [
    "_startPos",
    "_endPos",
    ["_loops", DEFAULT_LOOPS, [0]],
    ["_range", DEFAULT_RANGE, [0]],
    ["_bool", false, [true]]
];

private _uid = GVAR(uid); INC(GVAR(uid));
private _ns = [false] call CBA_fnc_createNamespace;

_startingPos = [_startPos] call cba_fnc_getPos;
_endPos = [_endPos] call cba_fnc_getPos;

/*
diag_log "______________________ PATHFINDING ______________________";
private _marker = [format["%1_%2", _endPos select 0, _endPos select 1], _endPos, "ICON",[0.5, 0.5],"COLOR:","colorRed","TYPE:","mil_dot"] call CBA_fnc_createMarker;
*/

_allRoads = [_startingPos nearRoads _range,[],{_x distance _startingPos},"ASCEND"] call BIS_fnc_sortBy;
if (_allRoads isEqualto []) exitWith {
    WARNING_1("No roads found near %1", _startPos);
    []
};

private _open = [_allRoads select 0];
private _closed = [];
private _waypoints = [];


private _getScore = {
	private _p = _this;
	private _g = _p distance _startingPos;
	private _h = _p distance _endPos;
    private _f = _h;
    //Modifiers

    //Return
    _f
};

private _cp = objNull;
private _cpD = 999999;

private _loopCount = 0;
private _atualLoops = 0;
while {_loopCount < _loops && !(_open isEqualto [])} do {
    _open = [_open,[],{_x call _getScore},"ASCEND"] call BIS_fnc_sortBy;
    private _p = _open select 0;
    private _f = _p call _getScore;
    private _ed = _p distance _endPos;
    REM(_open, _p);
    _closed pushBack _p;

    /*
    diag_log format ["Open: %1 Closed: %2. F = %3, ED = %4", count _open, count _closed, _f, _ed];
    private _marker = [OBJ_STRING(_p), getPos _p, "ICON",[0.5, 0.5],"COLOR:","colorBlue","TYPE:","mil_dot","TEXT:", format["%1: f%2", _atualLoops, floor (_f/10)]] call CBA_fnc_createMarker;
    */

    if (_ed < _range) exitWith {
        _loopCount = _loops + 1;
    };

    //Check if closest point
    if (_ed < _cpD) then {
        _cp = _p;
        _cpD = _ed;
    };

    //Connected roads (we include nearRoads as some maps have shit road connections)
    private _connected = ((position _p) nearRoads 10) + roadsConnectedTo _p;

    {
        if (!(_x in _closed)) then {
            //If its already in the open list, see if we have a better path
            if (_x in _open) then {
                //Get current entry data, and see if ours is any better
                private _index = _open find _x;
                private _var = OBJ_STRING(_x);
                private _data = _ns getVariable [_var, [objNull,-1]];
                private _pScore = _data select 1;
                //If we have a better parent, ammend the data
                if (_f < _pScore || _pScore isEqualto -1) then {
                    _ns setVariable [_var, [_p, _f]];
                };
            } else {
                //Not in open list, so add it
                _open pushBack _x;
                private _var = OBJ_STRING(_x);
                _ns setVariable [_var, [_p, _f]];
            };
        };
    } forEach _connected;

    INC(_loopCount);
    INC(_atualLoops);
};

reverse _closed;

if (_closed isEqualto []) exitWith {
    deleteLocation _ns;
    if (_bool) then {false} else {[]};
};

//If we only need to know this route is possible, exit with true!
if (_bool) exitWith {
    deleteLocation _ns;
    true
};

//Pathfinding finished, now get the order. If we didnt find anything near by, go with the closest point
private _lastPoint = if (_loopCount isEqualto _loops) then {_cp} else {_closed select 0};
private _points = [];

_loopCount = 0;
while {_loopCount < _loops && !(_lastPoint isEqualto objNull)} do {
	private _p = _lastPoint;
    private _var = OBJ_STRING(_p);
    private _data = _ns getVariable [_var, [objNull,-1]];
	_lastPoint = _data select 0;
	_points pushBack _p;
    //diag_log format ["_x: %1 _p: %2", _p, _lastPoint, _var];
    INC(_loopCount);
};

reverse _points;

/*
diag_log "_______ RESULTS _________";
diag_log format ["%1 loops run", _atualLoops];
*/

//Now scoop out junctions
{
    _i = _forEachIndex;
    if (count (roadsConnectedTo _x) > 2 || _i isEqualto 0 || _i isEqualto ((count _points) -1)) then {
        //diag_log format ["Waypoint %1: %2", (count _waypoints), (getPos _x)];
        //private _marker = [OBJ_STRING(_x), getPos _x, "ICON",[0.5, 0.5],"COLOR:","colorYellow","TYPE:","mil_dot","TEXT:", str (count _waypoints)] call CBA_fnc_createMarker;
        _waypoints pushBack (getPos _x);
    };
} forEach _points;


deleteLocation _ns;
_waypoints
