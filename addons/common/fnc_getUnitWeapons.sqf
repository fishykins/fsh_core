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

params ["_unit"];

private _weapons = [];
private _addWeapon = {
    params ["_class","_count", "_attachments", "_container"];
    if (_class isEqualto "") exitWith {false};
    _weapons pushBack [_class, _count, _attachments, _container];
    true
};

private _uniform = uniformContainer _unit;
private _vest = vestContainer _unit;
private _backpack = backpackContainer _unit;

private _uniformWeapons = (getWeaponCargo _uniform) call FUNC(mapWeapons);
private _vestWeapons = (getWeaponCargo _vest) call FUNC(mapWeapons);
private _backpackWeapons = (getWeaponCargo _backpack) call FUNC(mapWeapons);

private _types = [
    ["Uniform", _uniformWeapons],
    ["Vest", _vestWeapons],
    ["Backpack", _backpackWeapons]
];

{
    _x params ["_container","_array"];
    {
        _x params ["_class", "_count"];
        [_class, _count, [], _container] call _addWeapon;
    } forEach _array;
} forEach _types;

//Grab current weapons
_types = [
    ["primary", primaryWeapon _unit, primaryWeaponItems _unit],
    ["secondary", secondaryWeapon _unit, secondaryWeaponItems _unit],
    ["handgun", handgunWeapon _unit, handgunItems _unit],
    ["binocular", binocular _unit, []]
];

{
    _x params ["_container","_weapon", "_attachments"];
    [_weapon, 1, _attachments, _container] call _addWeapon;
} forEach _types;

/*
diag_log "--------------- WEAPONS --------------------";
{diag_log str _x} forEach _weapons;
diag_log "--------------------------------------------";
*/

_weapons
