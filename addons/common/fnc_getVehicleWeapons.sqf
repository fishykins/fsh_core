/* ----------------------------------------------------------------------------
Function: FSH_fnc_getVehicleWeapons

Description:
    
Parameters:
    Vehicle- OBJECT, ClASS or CONFIG
    
Returns:
    array of all valid vehicle types. 
    
Example:
    (begin example)
        _types = [vehicle player] call FSH_fnc_getVehicleWeapons;
    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_vehicle",objNull,[objnull, configfile, ""]]
];

private _config = _vehicle;

if (!IS_CONFIG(_vehicle)) then {
    _config = [_vehicle] call cba_fnc_getObjectConfig; 
};

if (isNil "_config" || !(IS_CONFIG(_config))) exitWith {WARNING("Config not found"); nil};

private _weapons = getArray (_config >> "weapons");
private _turrets = configProperties [_config >> "Turrets", "true", true];
{_weapons append (getArray (_x >> "weapons"));} forEach _turrets;

_weapons 