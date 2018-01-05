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


if (!GVAR(persistantObjects)) exitWith {WARNING("Persistant object loop has been terminated"); false};

//Save all cars
{
    [_x] call fsh_fnc_dbSaveObject;
} forEach (allMissionObjects "");
true
