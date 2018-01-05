/* ----------------------------------------------------------------------------
Function:

Description:
    A function to mark an object for databasing. If called by client, data will be passed on to server who will execute the command.

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
    ["_object", objNull, [objNull]],
    ["_bool", true, [false]]
];

if (!isServer) exitWith {
    GVAR(pendingTag) = [_object,_bool, player];
    publicVariableServer QGVAR(pendingTag);
    GVAR(pendingTag) = [objNull, false];
    false
};

if (_object isEqualto objNull) exitWith {false};

_object setVariable [GVAR(vehicleSaveKey), _bool, true];

LOG_2("%1 has been tagged: %2", _object, _bool);

true
