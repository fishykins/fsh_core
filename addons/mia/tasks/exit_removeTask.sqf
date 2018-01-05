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

GET_MIA(_mia);

private _taskData = ["", 0, []];

_group setVariable [format["%1_task", MIA_N], _taskData];

[_group, "Task Completed","_name has successfully completed their designated task. "] call fsh_fnc_aiLog;

//[_mia, _group] call FUNC(clearGroupTask);
