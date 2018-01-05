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

params ["_unit", "_data"];


diag_log "======================= SET PD ===========================";
{
    //diag_log format ["%1: %2 = %3", _forEachIndex, typeName _x, _x];
    if (IS_ARRAY(_x)) then {
        diag_log format ["%1-----------------", _forEachIndex];
        {
            diag_log format ["____%1", _x];
        } forEach _x;
    } else {
        diag_log str _x;
    };
} forEach _data;
diag_log "==========================================================";


_data params [
    ["_pos", getPosATl _unit, [[]], 3],
    ["_dir", getDir _unit, [0]],
    ["_stance", stance _unit, [""]],

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
    ["_aceKeys", [], [[]]]
];

private _allMagazineClasses = getArray (configFile >> "cfgMagazines");
private _customKeys = [];

_unit setPosATL _pos;
_unit setDir _dir;
switch (_stance) do {
    case "PRONE": {_unit switchMove "AidlPpneMstpSnonWnonDnon_AI";};
    case "CROUCH": {_unit switchMove "AmovPknlMstpSrasWrflDnon";};
    case "STAND": {};
};

removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

_unit addBackpack "B_Carryall_Base"; //Creates a dummy backpack for ammo to be chucked into.

{
    _unit linkItem _x;
} forEach _assignedItems;

private _primary = "";
private _secondary = "";
private _handgun = "";

//Add any mags that should be loaded in weapons to the temp backpack
{
    _x params ["_class", "_count", "_ammo", "_container"];

    if (!(_container in ["Uniform", "Vest", "Backpack"])) then {

        //diag_log format["Adding %1 %2 with ammo %3 to container %4",_count, _class, _ammo, _container];

        for "_i" from 1 to _count do {
            _unit addMagazine [_class, _ammo];
        };
    };
} forEach _magazines;

//Add outfit items
_unit forceAddUniform _uniform;
_unit addVest _vest;
_unit addHeadgear _headgear;
_unit addGoggles _goggles;

_backpackWeapons = [];

//WEAPONS
{
    _x params ["_class", "_count", "_attachments", "_container"];

    //diag_log format ["Adding Weapon %1: count = %2, _container = %3, attachments = %4", _class, _count, _container, _attachments];

    switch (_container) do {
        case "primary": {
            _unit addWeapon _class;
            removeAllPrimaryWeaponItems _unit;
            _primary = _class;
            {_unit addPrimaryWeaponItem _x;} forEach _attachments;
        };
        case "secondary": {
            _unit addWeapon _class;
            _secondary = _class;
            {_unit addSecondaryWeaponItem _x;} forEach _attachments;
        };
        case "handgun": {
            _unit addWeapon _class;
            _handgun = _class;
            {_unit addHandgunItem _x;} forEach _attachments;
        };
        case "Backpack": {
            _backpackWeapons pushBack _x;
            //Dont add it yet because we are about to delete this backpack
        };
        case "Vest": {
            for "_i" from 1 to _count do {
                _unit addItemToVest _class;
            };
        };
        case "Uniform": {
            for "_i" from 1 to _count do {
                _unit addItemToUniform _class;
            };
        };
        case "binocular": {_unit addWeapon _class;};
    };
} forEach _weapons;

//ADD REAL BACKPACK!
removeBackpack _unit;
_unit addBackpack _backpack;
clearAllItemsFromBackpack _unit;

//Add qued weapons to backpack
{
    _x params ["_class", "_count", "_attachments", "_container"];
    for "_i" from 1 to _count do {
        _unit addItemToBackpack _class;
    };
} forEach _backpackWeapons;

private _uniform = uniformContainer _unit;
private _vest = vestContainer _unit;
private _backpack = backpackContainer _unit;

//MAGAZINES in containers
{
    _x params ["_class", "_count", "_ammo", "_container"];

    //diag_log format["Adding %1 %2 with ammo %3 to container %4",_count, _class, _ammo, _container];

    switch (_container) do {
        case "Backpack": {
            _backpack addMagazineAmmoCargo [_class, _count, _ammo];
        };
        case "Vest": {
            _vest addMagazineAmmoCargo [_class, _count, _ammo];
        };
        case "Uniform": {
            _uniform addMagazineAmmoCargo [_class, _count, _ammo];
        };
    };
} forEach _magazines;

//ITEMS
{
    _x params ["_class", "_count", "_container"];
    switch (_container) do {
        case "Backpack": {
            for "_i" from 1 to _count do {
                _unit addItemToBackpack _class;
            };
        };
        case "Vest": {
            for "_i" from 1 to _count do {
                _unit addItemToVest _class;
            };
        };
        case "Uniform": {
            for "_i" from 1 to _count do {
                _unit addItemToUniform _class;
            };
        };
    };
} forEach _items;
