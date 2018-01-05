/* ----------------------------------------------------------------------------
Description:

Parameters:

Returns:

Examples:

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
private TIME_MARKER(_start);

//GVARMAIN(gridPoints) = []; if (!(GVARMAIN(gridPoints) isEqualto [])) exitWith {GVARMAIN(gridPoints)};

private _gridPoints = [];

_debug = ("DEBUG" in _this);

params [
    ["_gridSize", GVARMAIN(gridSize), [0]]
];

private _a = _gridSize/2;
private _b = _gridSize/2;
private _w = worldSize;
private _h = worldSize;
private _d = (sqrt (((2*_a)^2) + ((2*_b)^2))) * 1.2;

private _spawnPoint = {
    params ["_x","_y"];
    private _pos = [_x, _y];
    private _t = createLocation ["fsh_gridLoc", _pos, _a, _b]; _t setRectangular true;
    _t setName format ["grid_%1", count GVARMAIN(gridPoints)];
    //private _t = createTrigger ["EmptyDetector", _pos, false]; _t setTriggerArea [_a, _b, 0, true]; _t setVariable [QGVAR(isGrid), true];
    _gridPoints pushBackUnique _t;
    if (_debug) then {
        private _id = format ["fsh_core_trigger_%1", GVAR(triggerID)]; INC(GVAR(triggerID));
        private _marker =  [_id, _pos, "RECTANGLE",[_a, _b],"COLOR:","colorBlue"] call CBA_fnc_createMarker;
        _marker setMarkerAlpha (0.15 + random 0.1);
    };
    _t
};


private _linkPoints = {
    params ["_t1","_t2"];
    if (_t1 isEqualto _t2) exitWith {};
    private _l1 = _t1 getVariable [QGVAR(linked), []];
    private _l2 = _t2 getVariable [QGVAR(linked), []];
    _l1 pushBackUnique _t2;
    _l2 pushBackUnique _t1;
    _t1 setVariable [QGVAR(linked), _l1];
    _t2 setVariable [QGVAR(linked), _l2];
};


//Spawn all points

for [{private _x = _a}, {_x < _w}, {ADD(_x,(2*_a))}] do {
    for [{private _y = _b}, {_y < _h}, {ADD(_y,(2*_b))}] do {
        private _t = [_x,_y] call _spawnPoint;

        //Link to all near points
        {[_t,_x] call _linkPoints} forEach nearestLocations [[_x,_y], ["fsh_gridLoc"], _d];

        //Calculate flat value
        private _ed = [_t, 8] call fsh_fnc_elevationVariance;
        _t setVariable [QGVAR(elevationVariance), _ed select 3];
        _t setVariable [QGVAR(averageHeight), _ed select 2];
    };
};

private _runTime = RUN_TIME(_start);
ADD(fshTime, _runTime);
LOG_2("Spawned %1 grids, taking %2 ticks", (count _gridPoints), _runTime);
_gridPoints
