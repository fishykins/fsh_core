/* ----------------------------------------------------------------------------
Function: fsh_fnc_getLoadout

Description:
    gets the loadout of a vehicle using the jets pylon system. Will only return weapons that can be changed

Parameters:
    0: object <GROUP>

Returns:
    array of magazines

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [ ["_vehicle", objNull, [objNull]] ];

private _pylons = getPylonMagazines _vehicle;

_pylons
