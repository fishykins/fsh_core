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
#define PLACEHOLDER_CAR "Land_VR_Target_MRAP_01_F"

params [
    ["_vehicle", objNull, [objNull]],
    ["_posGroup", "", [""]],
    ["_wlTypes", [], []],
    ["_blTypes", [], []]
];

private _data = [_vehicle, _wlTypes, _blTypes];

_vehicle setvariable [QGVAR(posGroup), _posGroup, false];
_vehicle setvariable [QGVAR(wlTypes), _wlTypes, false];
_vehicle setvariable [QGVAR(blTypes), _blTypes, false];

private _group = SPAWN_GNS(_posGroup,"placeholders",[]);
_group pushBackUnique _data;
SPAWN_SNS(_posGroup,"placeholders",_group);

true
