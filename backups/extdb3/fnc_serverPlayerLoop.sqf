/* ----------------------------------------------------------------------------
Function:

Description:

Parameters:

Returns:

Example:
    (begin example)

    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"


if (!GVAR(persistantPlayers)) exitWith {WARNING("Persistant players loop has been terminated"); false};

//Save all players
{
    private _uid = getPlayerUID _x;
    private _world = uiNamespace getVariable [QGVAR(worldID), worldName];
    private _session = uiNamespace getVariable [QGVAR(sessionID), "default"];
    private _data = [_x] call fsh_fnc_getPlayerData;
    [_uid, _world, _session, _data] call fsh_fnc_savePlayer;
} forEach allPlayers;

true
