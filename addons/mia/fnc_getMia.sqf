/* ----------------------------------------------------------------------------
Description:

Parameters:

Returns:

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_name","",["",locationNull,objNull]]
];

private _isMia = false;
private _return = objNull;

if (IS_LOCATION(_name)) then {
    _isMia = _name getVariable ["isMIA", false];
    if (_isMia) then {_return = _name;};
} else {
    _return = GVAR(namespace) getVariable [_name, objNull];
};

_return
