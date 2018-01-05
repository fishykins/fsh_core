/* ----------------------------------------------------------------------------
Description:

Parameters:

Returns:

Examples:

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_task", locationNull, [locationNull, objNull]]
];

private _id = _task getVariable [QGVAR(id), _params];
private _group = _task getVariable [QGVAR(group), _params];
private _params = _task getVariable [QGVAR(params), _params];
private _mia = _task getVariable [QGVAR(mia), ""];
GET_MIA(_mia);

_params params [
    ["_transGroup", grpNull, [grpNull]],
    ["_dropOff", [], [[]] ]
];

[_group, "Transport","%1 needs a lift to %2", groupID _transGroup, _dropOff] call fsh_fnc_aiLog;

private _leader = leader _transGroup;
private _pickup = getPos _leader;

private _wp = [_group, _pickup, 0, "MOVE"] call fsh_fnc_addWaypoint;
private _wpLoad = [_group, _pickup, 0, "LOAD"] call fsh_fnc_addWaypoint;

//Calculate travel route
private _points = []; //[_pickup, _dropOff, 50000, 200] call fsh_fnc_roadRoute;
{
    private _wp = [_group, _x, 0, "MOVE"] call fsh_fnc_addWaypoint;
} forEach _points;

private _wpDrop = [_group, _dropOff, 5, "TR UNLOAD"] call fsh_fnc_addWaypoint;

//private _wpGetIn = [_transGroup, _pickup, 0, "GETIN"] call fsh_fnc_addWaypoint;
//private _wpGetOut = [_transGroup, _dropOff, 0, "GETOUT"] call fsh_fnc_addWaypoint;

private _wpGetIn = _transGroup addWaypoint [_pickup, 0, 1, "GETIN"]; _wpGetIn setWaypointType "GETIN";
private _wpGetOut = _transGroup addWaypoint [_dropOff, 0, 2, "GETOUT"]; _wpGetOut setWaypointType "GETOUT";


private _onDone = format ["[%1, 2] call fsh_fnc_endTask", _id];
_wpDrop setWaypointStatements ["TRUE", _onDone];

//_transGroup setCurrentWaypoint _wpGetIn;

_wpGetIn synchronizeWaypoint [_wpLoad];
_wpGetOut synchronizeWaypoint [_wpDrop];
