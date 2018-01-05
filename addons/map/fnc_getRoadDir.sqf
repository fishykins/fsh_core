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
//#include "script_component.hpp"

params [
    ["_road", objNull, [objNull]]
];

if (_road isEqualto objNull) exitWith {-1};

private _connected = roadsConnectedTo _road;
private _a = getPos _road;
private _b = getPos _road;
private _c = count _connected;

if (_c >= 1) then {
    _b = getPos (_connected select 0);

    if (_c >= 2) then {
        _a = getPos (_connected  select ((count _connected) - 1));
    };
};

(_a getDir _b)
