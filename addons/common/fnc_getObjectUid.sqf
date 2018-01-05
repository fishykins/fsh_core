/* ----------------------------------------------------------------------------
Function:

Description:

Parameters:

Returns:

Example:
    (begin example)

    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"


params [
    ["_object", objNull, [objNull]]
];

if (_object isEqualto objNull) exitWith {""};

//Get uid for object
private _uid = _object getVariable [QGVARMAIN(uid), -1];

//If found, exit
if (!(_uid isequalto -1)) exitWith {_uid};

//Generate new uid
private _class = typeOf _object;
_uid = format ["%1_%2_%3", GVARMAIN(session), _class, GVAR(objectUID)];
_object setVariable [QGVARMAIN(uid), _uid];
INC(GVAR(objectUID));

_uid
