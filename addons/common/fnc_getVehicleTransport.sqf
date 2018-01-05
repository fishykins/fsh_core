/* ----------------------------------------------------------------------------
Function: FSH_fnc_getVehicleTransport

Description:
    
Parameters:
    Vehicle- OBJECT, ClASS or CONFIG
    
Returns:
    number of all cargo spaces in vehicle
    
Example:
    (begin example)
        _allSpaces = [vehicle player] call FSH_fnc_getVehicleTransport;
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

_vehicle = configName _config;

private _cargoSpace = getNumber (_config >> 'transportSoldier');
private _turrets = configProperties [_config >> "Turrets", "true", true];

{
    private _isPersonTurret = getNumber (_x >> 'isPersonTurret');
    if (_isPersonTurret > 0) then {
        INC(_cargoSpace);
    };
} forEach _turrets;

_cargoSpace 