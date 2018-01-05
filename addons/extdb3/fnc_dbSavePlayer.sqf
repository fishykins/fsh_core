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
if (fsh_noSave) exitWith {false};

params [
    ["_unit", player, [objNull,""]],
    ["_map", uiNamespace getVariable [QGVAR(worldID), worldName], [""]],
    ["_hive", uiNamespace getVariable [QGVAR(sessionID), "default"], [""]],
    ["_data", "noData", [[],""]],
    ["_bootstrap", false, [false]]
];

private _uid = if (IS_STRING(_unit)) then {_unit} else {getPlayerUID _unit};

//If no data passed and we have an object, auto grab data
if (IS_STRING(_data)) then {
    _data = [];
    if (IS_OBJECT(_unit)) then {
        _data = [_unit] call fsh_fnc_getPlayerData;
    };
};

private _profilePk = -1;
private _playerPk = -1;

_data params [
    ["_pos", [-1000,-1000,0], [[]], 3],
    ["_dir", 0, [0]],
    ["_stance", "0", [""]],

    ["_damage", 0, [0]],
    ["_oxygen", 0, [0]],
    ["_bleeding", 0, [0]],
    ["_hitpoints", [], [[]]],

    ["_uniform", "", [""]],
    ["_vest", "", [""]],
    ["_backpack", "", [""]],
    ["_headgear", "", [""]],
    ["_goggles", "", [""]],
    ["_assignedItems", [], [[]]],
    ["_currentWeapon", "", [""]],

    ["_weapons", [], [[]]],
    ["_items", [], [[]]],
    ["_magazines", [], [[]]],
    ["_aceKeys", [], [[]]],

    ["_name", "nameAny", [""]]
];

//Get our player id
private _playerPk = ([_uid, _map, _hive, _name, true] call fsh_fnc_dbFindPlayer) select 0;

//Position
private _params = [
    (_pos select 0) call cba_fnc_floatToString,
    (_pos select 1) call cba_fnc_floatToString,
    (_pos select 2) call cba_fnc_floatToString,
    _dir,
    _stance,
    _playerPk
];

[1, FC_SQL_PD, "set_player_position", _params] call fsh_fnc_extdb3;

//Health
_params = [
    _damage,
    _oxygen,
    _bleeding
];

{_params pushBack (_x select 1)} forEach _hitpoints;
_params pushBack _playerPk;

[1, FC_SQL_PD, "set_player_health", _params] call fsh_fnc_extdb3;

//Basic Gear
_params = [
    _uniform,
    _vest,
    _backpack,
    _headgear,
    _goggles,
    _assignedItems,
    _currentWeapon,
    _playerPk
];

[1, FC_SQL_PD, "set_player_gear", _params] call fsh_fnc_extdb3;

//Add save
private _saveId = ([0, FC_SQL_PD, "add_player_save", [_playerPk]] call fsh_fnc_extdb3) select 1 select 0;

//Clear items from previous saves
[0, FC_SQL_PD, "remove_player_save", [_playerPk, _saveId]] call fsh_fnc_extdb3;

//Waits until all items have been removed before continuing

//Items
{
    [0, FC_SQL_PD, "add_player_item", [_playerPk, _saveId] + _x] call fsh_fnc_extdb3;
} forEach _items;

//Weapons
{
    [0, FC_SQL_PD, "add_player_weapon", [_playerPk, _saveId] + _x] call fsh_fnc_extdb3;
} forEach _weapons;

//Mags
{
    [0, FC_SQL_PD, "add_player_magazine", [_playerPk, _saveId] + _x] call fsh_fnc_extdb3;
} forEach _magazines;

//Ace keys
{
    [0, FC_SQL_PD, "add_player_ace_key", [_playerPk, _saveId, _x]] call fsh_fnc_extdb3;
} forEach _aceKeys;


if (!_bootstrap || !(IS_OBJECT(_unit))) exitWith {true};

//For debugging purposes load data and compare.

private _loadData = [_unit, _map, _hive] call fsh_fnc_dbLoadPlayer;

for [{private _i = 0}, {_i < count _loadData}, {INC(_i)}] do {
    private _a = _data select _i;
    private _b = _loadData select _i;
    if (!(_a isEqualto _b)) then {
        WARNING_2("%1: Ellement %2 is not consistent:", _uid, _i);
        WARNING_1("      Save: %1", _a);
        WARNING_1("      Load: %1", _b);
    };
};

true
