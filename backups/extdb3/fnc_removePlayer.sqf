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
    ["_removeData", false, [false]]
];

private _inDb = [_uid] call fsh_fnc_playerInDb;
if (!_inDb) exitWith {true};

if (_removeData) then {
    [1, FC_SQL_PD, "player_remove_data", [_uid]] call fsh_fnc_extdb3;
};
[1, FC_SQL_PD, "player_remove_position_all", [_uid]] call fsh_fnc_extdb3;
[1, FC_SQL_PD, "player_remove_gear_all", [_uid]] call fsh_fnc_extdb3;
[1, FC_SQL_PD, "player_remove_health_all", [_uid]] call fsh_fnc_extdb3;
[1, FC_SQL_PD, "player_remove_items_all", [_uid]] call fsh_fnc_extdb3;
[1, FC_SQL_PD, "player_remove_weapons_all", [_uid]] call fsh_fnc_extdb3;
[1, FC_SQL_PD, "player_remove_magazines_all", [_uid]] call fsh_fnc_extdb3;


true
