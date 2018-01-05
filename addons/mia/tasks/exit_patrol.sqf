/* ----------------------------------------------------------------------------
Description:

Parameters:

Returns:

Examples:

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params ["_leader"];

private _group = (group _leader);
private _mia = _group getVariable [QGVAR(commandGroup), locationNull];
private _area = _group getVariable [QGVAR(area), locationNull];
private _awareness = _area getVariable ["awareness", 0];

GET_MIA(_mia);

private _taskData = ["", 0, []];

_group setVariable [format["%1_task", MIA_N], _taskData];

[_group, "Patrol Completed","_name has finished patrolling"] call fsh_fnc_aiLog;

_area setVariable ["awareness", _awareness - 1];

//[_mia, _group] call FUNC(clearGroupTask);
