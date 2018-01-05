/* ----------------------------------------------------------------------------
Function: FSH_fnc_factionGear

Description:
    Get all assosiated gear for given faction. Takes bloody ages

Parameters:
    String- faction name

Returns:
    array of vehicle configs

Example:
    (begin example)
        _data = ["Blu_f"] call FSH_fnc_factionVehicles;
    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_faction", "", [""]]
];

if (!([_faction] call fsh_fnc_isFaction)) exitWith {WARNING("Invalid faction"); false};

private _data = FACTION_GNS(_faction,"gear","undefined");
if (!(_data isEqualTo "undefined")) exitWith {_data}; _data = [];
//=======================================================================================
private _weapons = [];
private _magazines = [];
private _items = [];
private _backpacks = [];

//=======================================================================================
private _rawWeapons = [];
private _rawGear = [];
private _factionUnits = [_faction] call fsh_fnc_factionUnits;
{
    private _cfg = configFile >> "cfgVehicles" >> _x;
    private _unitWeapons = getArray (_cfg >> "weapons");
    private _unitLinkedItems = getArray (_cfg >> "linkedItems");
    private _unitMagazines = getArray (_cfg >> "magazines");

    {_weapons pushBackUnique _x;} forEach _unitWeapons;
    {_items pushBackUnique _x;} forEach _unitLinkedItems;
    _items pushBackUnique (getText (_cfg >> "uniformClass") );
    {_magazines pushBackUnique _x;} forEach _unitMagazines;
    _backpacks pushBackUnique (getText (_cfg >> "backpack"));

} forEach _factionUnits;

_data = [_weapons, _magazines, _backpacks, _items];

FACTION_SNS(_faction,"gear",_data);
_data
