/* ----------------------------------------------------------------------------
Function: FSH_fnc_factionUnits

Description:


Parameters:
    0: Object or Group
    1: Int.
        1 = get custom colour, or side if none found.
        0 = get side colour.

Returns:
    colour in array format

Example:
    (begin example)
        _units = [1] FSH_fnc_factionUnits
    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
#define RETURN_COLOUR if (!(_colour isEqualto [])) exitWith {_colour}

params [
    ["_object", objNull, [objNull,grpNull]],
    ["_colourMode", 1, [0]]
];
if (_object isEqualto objNull || _object isEqualto grpNull) exitWith {[1,1,1,1]};
private _colour = [];

//check for custom colour if allowed
if (_colourMode > 0) then {
    _colour = _object getVariable [QGVAR(colour), [] ];
};
RETURN_COLOUR;

//check for side colour
//private _colour = _object getVariable [QGVAR(sideColour), [] ];
//RETURN_COLOUR;

//calculate side colour
_colour = switch (side _object) do {
    case west: {COL_WEST};
    case east: {COL_EAST};
    case resistance: {COL_GUER};
    default {COL_CIV};
};
_object setVariable [QGVAR(sideColour), _colour, false];
RETURN_COLOUR;

_colour = [0.3 + random(0.7),0.3 + random(0.7),0.3 + random(0.7),0.8];

_colour
