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

params [
    ["_uid", "", [""]],
    ["_world", worldName, [""]],
    ["_session", uiNamespace getVariable [QGVAR(sessionID), "default"], [""]],
    ["_name", "", [""]]
];

private _callerID = [_uid, _world, _session];

//Add session spesific data
LOG_1("Adding player %1 to DB session", _uid);
[1, FC_SQL_PD, "player_add_position", _callerID] call fsh_fnc_extdb3;
[1, FC_SQL_PD, "player_add_health", _callerID] call fsh_fnc_extdb3;
[1, FC_SQL_PD, "player_add_gear", _callerID] call fsh_fnc_extdb3;

private _return = [0, FC_SQL_PD, "player_get_name", [_uid]] call fsh_fnc_extdb3;
if (_return select 1 isEqualto []) then {
    //Add global player data too
    [1, FC_SQL_PD, "player_add_data", [_uid, _name]] call fsh_fnc_extdb3;
};
