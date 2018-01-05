/* ----------------------------------------------------------------------------
Description:

Parameters:

Returns:

Examples:

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_group", grpNull, [grpnull]],
    ["_task", locationNull, [locationNull, objNull] ]
];

private _type = _task getVariable [QGVAR(type), "none"];
private _id = _task getVariable [QGVAR(id), -1];
private _mia = _task getVariable [QGVAR(mia), ""];
private _params = _task getVariable [QGVAR(params), []];
private _init = _task getVariable [QGVAR(init), {}];

//Store data
_group setVariable [QGVAR(task), _task];
_task setVariable [QGVAR(group), _group];
_task setVariable [QGVAR(status), 1];

//run init code
[_task] call _init;

//exit
MIA_LOG_3("%1 has taken on task %2 (%3)", groupID _group, _type, _id);
true
