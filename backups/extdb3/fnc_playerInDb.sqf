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
    "_uid",
    ["_map", "any", [""]],
    ["_session", "any", [""]]
];

private _callerID = [_uid, _map, _session];

private _inDb = false;

if (_map isEqualto "any" && _session isEqualto "any") then {
    //Does player have ANY data?
    private _result = [0, FC_SQL_PD, "player_get_name", [_uid]] call fsh_fnc_extdb3;
    _inDb = (!(_result select 1 isEqualto []));
} else {
    //Map spesific- get a position.
    private _result = [0, FC_SQL_PD, "player_get_position", _callerID] call fsh_fnc_extdb3;
    _inDb = (!(_result select 1 isEqualto []));
};

_inDb
