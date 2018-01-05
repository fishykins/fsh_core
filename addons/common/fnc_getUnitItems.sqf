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

private _items = [];
private _addItem = {
    _items pushBack _this;
};

private _uniform = uniformContainer _unit;
private _vest = vestContainer _unit;
private _backpack = backpackContainer _unit;

private _uniformItems = (getItemCargo _uniform) call FUNC(mapItems);
private _vestItems = (getItemCargo _vest) call FUNC(mapItems);
private _backpackItems = (getItemCargo _backpack) call FUNC(mapItems);

private _types = [
    ["Uniform", _uniformItems],
    ["Vest", _vestItems],
    ["Backpack", _backpackItems]
];

{
    _x params ["_container","_array"];
    {
        _x params ["_class", "_count"];
        [_class, _count, _container] call _addItem;
    } forEach _array;
} forEach _types;

/*
diag_log "---------------- ITEMS ---------------------";
{diag_log str _x} forEach _items;
diag_log "--------------------------------------------";
*/

_items
