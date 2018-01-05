/* ----------------------------------------------------------------------------
Function: FSH_fnc_getFactions

Description:
    Gets a list of all factions for given side
    
Parameters:
    INT- side you wish to find (<0 returns all)

Returns:
    ARRAY of factions
    
Example:
    (begin example)
        _factions = [1] call fsh_fnc_getFactions //returns all sides WEST
    (end example)

Author:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
#define SIDE_WIDTH 7

params [
    ["_side", -1, [0]]
];

if (_side >SIDE_WIDTH || _side <-1) exitWith {WARNING("Side not given")};

if (IsNil QGVAR(factions)) then {
    //We have not compiled a list yet, so do it now
    private _factions = []; _factions resize (SIDE_WIDTH + 1);
    private  _config = configfile >> "CfgFactionClasses";
    GVARMAIN(allFactions) = [];
    GVARMAIN(factions) = _factions apply {[]};
    
    for [{private _i=0}, {_i<(count _config)}, {_i=_i+1}] do
    {
        private _faction = _config select _i;
        if (isClass _faction) then {
            private _factionSide = getNumber (_faction >> 'side');
            if (!isNil "_factionSide" && _factionSide >= 0) then {
                GVARMAIN(allFactions) pushBack (configName _faction); 
                (GVARMAIN(factions) select _factionSide) pushBack (configName _faction);
                FACTION_SNS(_faction,"defined",1);
            };
        };
    };
};



if (_side < 0) then {GVARMAIN(allFactions)} else {(GVARMAIN(factions) select _side)};