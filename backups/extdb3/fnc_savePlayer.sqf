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
//if (true) exitWith {};

params [
    ["_uid", "", [""]],
    ["_world", uiNamespace getVariable [QGVAR(worldID), "default"], [""]],
    ["_session", uiNamespace getVariable [QGVAR(sessionID), "default"], [""]],
    ["_data", [], [[]]]
];

INC(GVAR(session));
INC(GVAR(saveId));
private _saveId = format ["%1_%2", GVAR(session),GVAR(saveId)];

private _callerID = [_uid, _world, _session];
private _callerIDS = _callerID + [_saveId];

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

    ["_name", "nameAny", [""]]
];

_strPosX = (_pos select 0) call cba_fnc_floatToString;
_strPosY = (_pos select 1) call cba_fnc_floatToString;
_strPosZ = (_pos select 2) call cba_fnc_floatToString;

private _inDb = _callerID call fsh_fnc_playerInDb;
if (!_inDb) then {
    [_uid, _world, _session, _name] call fsh_fnc_addPlayer;
};



//Position
private _params = [
    _strPosX,
    _strPosY,
    _strPosZ,
    _dir,
    _stance,
    _saveId
];

[1, FC_SQL_PD, "player_set_position", _params + _callerID] call fsh_fnc_extdb3;

//Basic Gear
_params = [
    _uniform,
    _vest,
    _backpack,
    _headgear,
    _goggles,
    _assignedItems,
    _currentWeapon,
    _saveId
];
[1, FC_SQL_PD, "player_set_gear", _params + _callerID] call fsh_fnc_extdb3;

//Clear items from previous saves
[0, FC_SQL_PD, "player_remove_weapons_oldSave", _callerIDS] call fsh_fnc_extdb3;
[0, FC_SQL_PD, "player_remove_magazines_oldSave", _callerIDS] call fsh_fnc_extdb3;
[0, FC_SQL_PD, "player_remove_items_oldSave", _callerIDS] call fsh_fnc_extdb3;
//Waits until all items have been removed before continuing

//Items
{
    [1, FC_SQL_PD, "player_add_item", _callerIDS + _x] call fsh_fnc_extdb3;
} forEach _items;

//Weapons
{
    [1, FC_SQL_PD, "player_add_weapon", _callerIDS + _x] call fsh_fnc_extdb3;
} forEach _weapons;

//Mags
{
    [1, FC_SQL_PD, "player_add_magazine", _callerIDS + _x] call fsh_fnc_extdb3;
} forEach _magazines;

//Health
private _healthValues = [_damage, _oxygen, _bleeding];
{_healthValues pushBack (_x select 1)} forEach _hitpoints;
_healthValues pushBack _saveId;
[1, FC_SQL_PD, "player_set_health", _healthValues + _callerID] call fsh_fnc_extdb3;

true
