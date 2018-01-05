/* ----------------------------------------------------------------------------
Function: FSH_fnc_factionVehicles

Description:
    Get all assosiated vehicles for given faction

Parameters:
    String- faction name

Returns:
    array of vehicle configs

Example:
    (begin example)
        _vehicles = ["Blu_f"] call FSH_fnc_factionVehicles;
    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_faction", "", [""]],
    ["_type", "vehicles", [""]]
];

if (!([_faction] call fsh_fnc_isFaction)) exitWith {WARNING("Invalid faction"); false};

private _vehicles = FACTION_GNS(_faction,"vehicles","undefined");
if (!(_vehicles isEqualTo "undefined")) exitWith {_vehicles}; _vehicles = [];
//=======================================================================================
private  _config = configfile >> "cfgVehicles";

for [{private _i=0}, {_i<(count _config)}, {_i=_i+1}] do
{
    private _vehicle = _config select _i;
    if (isClass _vehicle) then {
        private _vehicleFaction = getText (_vehicle >> "faction");
        if ((toLower _vehicleFaction) isEqualTo (toLower _faction)) then {
            private _vehicleCrew = getText (_vehicle >> "crew");
            private _vehicleScope = getNumber (_vehicle >> "scope");
            if (!(_vehicleCrew isEqualTo "Civilian") && _vehicleScope isEqualTo 2) then {
                //private _vehicleName = getText (_vehicle >> "displayName");
                _vehicles pushBackUnique (configName _vehicle);
            };
        };
    };
};

/*PUSH_FVAR(_faction,_vehicles);*/

FACTION_SNS(_faction,"vehicles",_vehicles);
_vehicles
