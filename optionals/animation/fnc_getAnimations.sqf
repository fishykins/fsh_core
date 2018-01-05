/* ----------------------------------------------------------------------------
Function: fsh_fnc_getAnimations

Description:
    returns animations for given type

Parameters:


Returns:


Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_animationType","",[""]]
];

_animationType = toLower _animationType;

if (_animationType isEqualTO "") exitWith {[[],[],[],[]]};

//private _config = selectRandom (configProperties [configfile >> "FSH_animations", format["getText (_x >> 'Type') isEqualTo (str %1)", _animationType], true]);
private _configs = configProperties [configfile >> "FSH_animations", "count _x > 0", true];
//systemChat format["configs: %1", _configs];

private _validConfigs = [];

{
    if (getText (_x >> "type") isEqualTo _animationType) then {_validConfigs pushBack _x;};
} forEach _configs;

//systemChat format["valid configs: %1", _validConfigs];

if (_validConfigs isequalTo []) exitWith {
    [[],[],[],[]]
};

private _config = selectRandom _validConfigs;

//systemChat format["config: %1", _config];

private _start = getArray (_config >> "start");
private _statics = getArray (_config >> "statics");
private _loops = getArray (_config >> "loops");
private _end = getArray (_config >> "end");

[_start,_statics, _loops, _end]

