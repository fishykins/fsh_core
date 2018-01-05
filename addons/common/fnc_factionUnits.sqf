/* ----------------------------------------------------------------------------
Function: FSH_fnc_factionUnits

Description:
    Get all assosiated units for given faction

Parameters:
    String- faction name

Returns:
    array of vehicle configs

Example:
    (begin example)
        _units = [1] FSH_fnc_factionUnits
    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_faction", "", [""]]
];

if (!([_faction] call fsh_fnc_isFaction)) exitWith {WARNING("Invalid faction"); false};

private _units = FACTION_GNS(_faction,"units","undefined");
if (!(_units isEqualTo "undefined")) exitWith {_units}; _units = [];
//=======================================================================================
private  _config = configfile >> "cfgVehicles";

for [{private _i=0}, {_i<(count _config)}, {_i=_i+1}] do
{
    private _unit = _config select _i;
    if (isClass _unit) then {
        private _scope = getNumber (_unit >> "scope");
        if (_scope >= 2) then {
            private _isMan = getNumber (_unit >> "isMan");
            if (_isMan > 0) then {
                private _unitFaction = getText (_unit >> "faction");
                if (tolower (_unitFaction) isEqualTo (tolower _faction)) then {
                    _units pushBack (configName _unit);
                };
            };
        };
    };
};

/*PUSH_FVAR(_faction,_units);*/

FACTION_SNS(_faction,"vehicles",_units);
_units
