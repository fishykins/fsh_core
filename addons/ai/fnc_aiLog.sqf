/* ----------------------------------------------------------------------------
Function: fsh_fnc_aiLog

Description:
    Logs the given data to an ai. Meant for debugging purposes

Parameters:
    0: unit <OBJECT>
    1: log title <STRING>
    1: log text <STRING>
    formatting params

Example:
    <begin example>
        [player, "_name Moving to position %1", [0,0,0]] call fsh_fnc_aiLog;
    <end example>

Returns:
    true <BOOLEAN>

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_unit",objNull,[objNull,grpNull]],
    ["_logTitle","",[""]],
    ["_logString","",[""]]
];

private _nameFormatted = [str _unit] call CBA_fnc_capitalize;
_logString = [_logString, "_name", _nameFormatted] call CBA_fnc_replace;
_logString = [_logString, "_time", str CBA_missionTime] call CBA_fnc_replace;
_logString = [_logString, "_player", name player] call CBA_fnc_replace;

_logTitle = [_logTitle] call CBA_fnc_capitalize;


private _unitLogs = _unit getVariable [QGVAR(logs), []];

private _formatParams = [] + _this;
_formatParams deleteRange [0,3];

private _title = [_logTitle];
private _string = [_logString];

{
    _title pushBack _x;
    _string pushBack _x;
} forEach _formatParams;

private _time = [CBA_missionTime, "H:MM:SS"] call CBA_fnc_formatElapsedTime;
private _position = [];
if (IS_GROUP(_unit)) then {
    _position = getPosASL (leader _unit);
} else {
    _position = getPosASL _unit;
};
private _data = [format _title, format _string, _time, _position];

_unitLogs pushBack _data;

_unit setVariable [QGVAR(logs), _unitLogs, true];

true
