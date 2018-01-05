/* ----------------------------------------------------------------------------
Function: FSH_fnc_arsenal

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
    ["_object", "", [objNull]],
    ["_function", "", [""]],
    ["_global", true, [true]],
    ["_data", [], [[]] ]
];

_data params [
    ["_allWeapons", [], [[]]],
    ["_allitems", [], [[]]],
    ["_allMagazines", [], [[]]],
    ["_allBackpacks", [], [[]]]
];

private _addAction = _object getVariable [QGVAR(enabled), true];

switch (_function) do {
    case ("add"): {
        [_object,_allWeapons, _global, _addAction] call BIS_fnc_addVirtualWeaponCargo;
        [_object,_allitems, _global, _addAction] call BIS_fnc_addVirtualItemCargo;
        [_object,_allMagazines, _global, _addAction] call BIS_fnc_addVirtualMagazineCargo;
        [_object,_allBackpacks, _global, _addAction] call BIS_fnc_addVirtualBackpackCargo;
    };
    case ("remove"): {
        [_object,_allWeapons, _global] call BIS_fnc_removeVirtualWeaponCargo;
        [_object,_allitems, _global] call BIS_fnc_removeVirtualItemCargo;
        [_object,_allMagazines, _global] call BIS_fnc_removeVirtualMagazineCargo;
        [_object,_allBackpacks, _global] call BIS_fnc_removeVirtualBackpackCargo;
    };
    case ("clear"): {
        _allWeapons = _object call BIS_fnc_getVirtualWeaponCargo;
        _allitems = _object call BIS_fnc_getVirtualItemCargo;
        _allMagazines = _object call BIS_fnc_getVirtualMagazineCargo;
        _allBackpacks = _object call BIS_fnc_getVirtualBackpackCargo;
        [_object,_allWeapons, _global] call BIS_fnc_removeVirtualWeaponCargo;
        [_object,_allitems, _global] call BIS_fnc_removeVirtualItemCargo;
        [_object,_allMagazines, _global] call BIS_fnc_removeVirtualMagazineCargo;
        [_object,_allBackpacks, _global] call BIS_fnc_removeVirtualBackpackCargo;
    };
    default {ERROR("No function passed!");};
};
