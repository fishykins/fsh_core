/* ----------------------------------------------------------------------------
Description:
    This function will initiate server side player saving and loading.

Parameters:
    0: session ID: the identifier for this mission.
    1: refresh speed: time in seconds between each save

Returns:
    bool: true if setup ok

Examples:
    ["mission1", 30] call fsh_fnc_persistantPlayers;

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

if (!isServer) exitWith {WARNING("Called server side script on client"); false};

if (GVAR(persistantObjects)) exitWith {WARNING("Already running persistant object scripts"); false};

if (!(uiNamespace getVariable [QGVAR(connected), false])) exitWith {
    WARNING("Cannot start object persistance- no database connection");
    false
};

GVAR(persistantObjects) = true;

params [
    ["_hive", "default", [""]],
    ["_loopTime", 30, [0]]
];

private _map = worldName;

LOG_2("Starting object persistance: map = %1, hive = %2", _map, _hive);

uiNamespace setVariable [QGVAR(objectHive), _hive];
uiNamespace setVariable [QGVAR(objectWorld), _map];


//Get all object ids for this map and hive
private _data = ([0, FC_SQL_OBJ, "get_allObjects", [_map, _hive]] call fsh_fnc_extdb3) select 1;
{
    _x call fsh_fnc_dbSpawnObject;
} forEach _data;

[_loopTime] execFSM QPATHTOF(save_objects.fsm);
