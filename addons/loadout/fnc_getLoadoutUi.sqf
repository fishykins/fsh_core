/* ----------------------------------------------------------------------------
Function: fsh_fnc_getLoadoutUi

Description:
    gets the vehicles loadout ui data.

Parameters:
    0: object or class

Returns:
    0. string- ui image
    1. array for all weapon positions

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [ 
    ["_vehicle", objNull, [objNull, ""]] 
];

if (IS_OBJECT(_vehicle)) then {_vehicle = typeOf _vehicle;};

private _image = getText (configfile >> "CfgVehicles" >> _vehicle >> "Components" >> "TransportPylonsComponent" >> "UIPicture");
private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> typeOf _vehicle >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]);

