/* ----------------------------------------------------------------------------
Function: FSH_fnc_spawnAny

Description:
    Spawn the given thing, be it object or group.
    
Parameters:
    POSITION- where to spawn
    THING- what to spawn. Can be config, interger or array.
    SIDE- side on which to spawn (replaces default). accepts side, string or int. "default" uses class side
    SCALAR- direction of group (defualts random)
    
Returns:
    spawned group id
    
Example:
    (begin example)
        //creates an opfor group at players position, facing east. Will be friendly to player
        _group = [getpos player, "OI_reconTeam", side player, 90] call FSH_fnc_spawnAny   
        
        //creates the same opfor group at marker, facing west. Will be sided with west
        _group2 = ["markerSpawn", configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OI_reconTeam", 1, 270] call FSH_fnc_spawnAny   
    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
    
params [
    ["_position","",["",objNull,[]]],
    ["_thing","",[[],0,"",configNull]],
    ["_side",1,[1,WEST,""]],
    ["_direction",random(360),[0]]
];

//=========================================
//All we are going to do is find out if this is veh or grp. Leave sorting of params to the child functions
private _function = "group";

if (IS_CONFIG(_thing)) then {
    private _configSplit = [str _thing, "/"] call CBA_fnc_split;
    if (count _configSplit > 0) then {
        private _parent = toLower (_configSplit select 1);
        if (_parent isEqualTo "cfgvehicles") then {_function = "vehicle";};
    };
};

if (IS_STRING(_thing)) then {
    private _config = configFile >> "CfgVehicles" >> _thing;
    if (IS_CONFIG(_config)) then {_function = "vehicle";};
};

if (_function isEqualTo "group") exitWith {_this call fsh_fnc_spawnGroup};

_this call fsh_fnc_spawnVehicle 