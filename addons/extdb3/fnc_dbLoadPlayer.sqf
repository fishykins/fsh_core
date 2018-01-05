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
    ["_unit", player, [objNull,""]],
    ["_map", uiNamespace getVariable [QGVAR(worldID), "default"], [""]],
    ["_hive", uiNamespace getVariable [QGVAR(sessionID), "default"], [""]]
];


//Get player id

private _uid = if (IS_STRING(_unit)) then {_unit} else {getPlayerUID _unit};
private _playerPk = ([_uid, _map, _hive] call fsh_fnc_dbFindPlayer) select 0;

if (_playerPk isEqualto -1) exitWith {WARNING_1("Player %1 not in database!", _uid); []};

//Get Position
private _posData = [0, FC_SQL_PD, "get_player_position", [_playerPk]] call fsh_fnc_extdb3;
if (_posData select 0 isEqualto 0) exitWith {ERROR_1("Could not retreive position data: %1", (_posData select 1)); []};

private _result = _posData select 1 select 0;
_result params ["_x","_y", "_z", "_dir","_stance"];
if (!(_x isEqualtype 0)) then {_x = parseNumber _x;};
if (!(_y isEqualtype 0)) then {_y = parseNumber _y;};
if (!(_z isEqualtype 0)) then {_z = parseNumber _z;};
if (!(_dir isEqualtype 0)) then {_dir = parseNumber _z;};

private _pos = [_x,_y,_z];

//Get Gear
private _gearData = ([0, FC_SQL_PD, "get_player_gear", [_playerPk]] call fsh_fnc_extdb3) select 1;

(_gearData select 0) params [
    ["_uniform", ""],
    ["_vest", ""],
    ["_backpack", ""],
    ["_headgear", ""],
    ["_goggles", ""],
    ["_assignedItems", [], [[]]],
    ["_currentWeapon", ""]
 ];

//Get items, mags and weapons
private _weapons = ([0, FC_SQL_PD, "get_player_weapons", [_playerPk]] call fsh_fnc_extdb3) select 1;
private _items = ([0, FC_SQL_PD, "get_player_items", [_playerPk]] call fsh_fnc_extdb3) select 1;
private _magazines = ([0, FC_SQL_PD, "get_player_magazines", [_playerPk]] call fsh_fnc_extdb3) select 1;
private _aceKeys = [];

[
    _pos,
    _dir,
    _stance,

    0,
    1,
    0,
    [],

    _uniform,
    _vest,
    _backpack,
    _headgear,
    _goggles,
    _assignedItems,
    _currentWeapon,

    _weapons,
    _items,
    _magazines,
    _aceKeys
]
