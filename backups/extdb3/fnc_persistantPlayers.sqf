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

if (GVAR(persistantPlayers)) exitWith {WARNING("Already running persistant player scripts"); false};

LOG("Starting player persistance...");
GVAR(persistantPlayers) = true;

params [
    ["_session", "default", [""]],
    ["_loopTime", 30, [0]]
];

if (!(uiNamespace getVariable [QGVAR(connected), false])) exitWith {
    WARNING("Cannot start- no database connection");
    false
};

private _world = worldName;

uiNamespace setVariable [QGVAR(sessionID), _session];
uiNamespace setVariable [QGVAR(worldID), _world];

//Get all connected players yet to be loaded
{
    //if (!(_x getVariable [QGVAR(loaded), false])) then {
        private _uid = getPlayerUID _x;
        private _data = [_uid, _world, _session] call fsh_fnc_loadPlayer;
        [_x,_data] call fsh_fnc_setPlayerData;
    //};
} forEach allPlayers;

//TODO- JIP


[_loopTime] execFSM QPATHTOF(serverLoop.fsm);
