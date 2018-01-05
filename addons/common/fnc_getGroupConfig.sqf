/* ----------------------------------------------------------------------------
Function: FSH_fnc_getGroupConfig

Description:
    returns the config path of the class group
    
Parameters:
    group- STRING
    
Returns:
    config
    
Example:
    (begin example)
        _config = ["BUS_InfSquad"] call FSH_fnc_getGroupConfig;
    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

if (!params [["_class","",["",configNull]]]) exitWith {WARNING("Class not given"); nil};
if (IS_CONFIG(_class)) exitWith {_class};

private _config = GROUP_GNS(_class,"config","undefined");
if (!(_config isEqualTo "undefined")) exitWith {_config}; _config = configNull;
//============================================================================
private _found = false; 

{
    private _configBase = configfile >> "CfgGroups" >> _x;
    private _categories = configProperties [_configBase, "count _x > 0",true];
    {
        private _categories = configProperties [_x, "count _x > 0",true];
        {
            private _groups = (configProperties [_x, "count _x > 0",true]) apply {configname _x};
            if (_class in _groups) exitWith {_found = true; _config = _x >> _class;};
        } forEach _categories;
        if (_found) exitWith {};
    } forEach _categories;
    if (_found) exitWith {};
} forEach ["East", "West", "Indep"];

if (!_found) then {WARNING_1("Group class '%1' not found",_class);};

GROUP_SNS(_class,"config",_config);
_config

