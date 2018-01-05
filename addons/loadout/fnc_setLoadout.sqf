/* ----------------------------------------------------------------------------
Function: fsh_fnc_setLoadout

Description:
    sets the loadout of a vehicle using the jets pylon system.

Parameters:
    0: object <GROUP>

Returns:
    array of magazines

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [ 
    ["_vehicle", objNull, [objNull]],
    ["_loadout", [], [[]]]
];

private _pylons = PASTEHERE;
private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> typeOf _vehicle >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};
private _nonPylonWeapons = [];
{ _nonPylonWeapons append getArray (_x >> "weapons") } forEach ([_vehicle, configNull] call BIS_fnc_getTurrets);
{ _vehicle removeWeaponGlobal _x } forEach ((weapons _vehicle) - _nonPylonWeapons);
{ _vehicle setPylonLoadOut [_forEachIndex + 1, _x, true, _pylonPaths select _forEachIndex] } forEach _pylons;