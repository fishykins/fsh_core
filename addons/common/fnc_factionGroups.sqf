/* ----------------------------------------------------------------------------
Function: FSH_fnc_factionGroups

Description:
    Get all assosiated groups for given faction
    
Parameters:
    STRING- faction name
    
Returns:
    array of group configs
    
Example:
    (begin example)
        _groups = ["BLU_F"] call FSH_fnc_factionGroups
    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_faction", "", [""]]
];

if (!([_faction] call fsh_fnc_isFaction)) exitWith {WARNING("Invalid faction"); false};

private _groups = FACTION_GNS(_faction,"groups","undefined");
if (!(_groups isEqualTo "undefined")) exitWith {_groups}; _groups = [];
//=======================================================================================
private _config = configfile >> "CfgFactionClasses"  >> _faction;
private _side = getNumber (_config >> "side");
private _altname = getText (_config >> "displayName");

private _sideStr = "";
switch (_side) do {
    case (0): {_sideStr = "East"};
    case (1): {_sideStr = "West"};
    case (2): {_sideStr = "Indep"};
    default {_sideStr = ""};
};

if (_sideStr isEqualTo "") exitWith {PUSH_FVAR(_faction,_groups); []};

private _configGroups = configfile >> "CfgGroups" >> _sideStr >> _faction;
private _configGroupsAlt = configfile >> "CfgGroups" >> _sideStr >> _altname;


private _factionCategories = configProperties [_configGroups, "count _x > 0",true];
_factionCategories append configProperties [_configGroupsAlt, "count _x > 0",true];

{
    _groups append (configProperties [_x, "count _x > 0",true]);
} forEach _factionCategories;

FACTION_SNS(_faction,"groups",_groups);

_groups
