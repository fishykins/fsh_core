/* ----------------------------------------------------------------------------
Function: FSH_fnc_isFaction

Description:
    returns condition of faction string
    
Parameters:
    STRING- faction class name

Returns:
    bool
    
Example:
    (begin example)
        _status = ["BLU_F"] call FSH_fnc_isFaction //returns true
    (end example)

Author:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_faction", "", [""]]
];

if (_faction isEqualTo "") exitWith {WARNING("faction not given")};

private _defined = FACTION_GNS(_faction,"defined",-1);
if (_defined isEqualTO 0) exitWith {false};
if (_defined > 0) exitWith {true};

//Not defined yet, so check
private _config = configfile >> "CfgFactionClasses" >> _faction;
if (IS_CONFIG(_config)) exitWith {FACTION_SNS(_faction,"defined",1); true};
FACTION_GNS(_faction,"defined",0);
false 