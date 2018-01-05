/* ----------------------------------------------------------------------------
Function: fsh_fnc_addObjectMenu

Description:
    Adds an ACE interaction menu to this vehicle, allowing a player to mark the vehicle for saving/forgetting.

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
    ["_object", objNull, [objNull]],
    ["_isAdding", true, [false]]
];

_object setVariable [QGVAR(hasMarkMenu), _isAdding, true];
