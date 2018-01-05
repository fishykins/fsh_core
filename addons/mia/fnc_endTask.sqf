/* ----------------------------------------------------------------------------
Description:

Parameters:
    type:
        0: end (any). Removes the task compleatly
        1: failed
        2: succeeded
        3: send back to mia as a canceled task. This will result in the task being re-allocated
        4: end a sub task

Returns:

Examples:

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_object", grpNull, [grpNull, objNull, locationNull, 0]],
    ["_type", 0, [0]]
];

private _group = grpNull;
private _task = locationNull;

if (IS_GROUP(_object)) then {
    _group = _object;
    _task = _group getVariable [QGVAR(task), locationNull];
} else {
    if (IS_INTEGER(_object)) then {
        for [{private _i = 0}, {_i < count GVAR(allTasks)}, {INC(_i)}] do {
            private _tempTask = GVAR(allTasks) select _i;
            private _id = _tempTask getVariable [QGVAR(id), -1];
            if (_id isEqualto _object) then {
                _task = _tempTask;
                _i = count GVAR(allTasks);
            };
        };
    } else {
        _task = _object;
    };
    _group = _task getVariable [QGVAR(group), locationNull];
};


private _exit = _task getVariable [QGVAR(exit), {}];
private _type = _task getVariable [QGVAR(type), "unspesified task"];
private _id = _task getVariable [QGVAR(id), -1];
private _subTasks = _task getVariable [QGVAR(subTasks), []];

if (_id isEqualto -1) exitWith {false};

//Run task exit code
[_task, _type] call _exit;

//Deal with task clearance
_group setVariable [QGVAR(task), locationNull];
_task setVariable [QGVAR(group), grpNull];

switch (_type) do {
    case (1): {
        _task setVariable [QGVAR(status), 1];
        MIA_LOG_2("Task %1 (%2) has failed", _type, _id);
    };
    case (2): {
        _task setVariable [QGVAR(status), 2];
        MIA_LOG_2("Task %1 (%2) has succeeded", _type, _id);
    };
    case (3): {
        _task setVariable [QGVAR(status), 0];
        MIA_LOG_2("Task %1 (%2) has been reasigned", _type, _id);
    };
    case (4): {
        _task setVariable [QGVAR(status), 2];
        MIA_LOG_2("subtask %1 (%2) has been ended", _type, _id);
    };
    default {
        _group setVariable [QGVAR(task), locationNull];
        MIA_LOG_3("Task %1 (%2) has ended with code", _type, _id, _type);
        deleteLocation _task;
    };
};

//Clear all sub tasks from existance
{
    [_x, 4] call fsh_fnc_endTask;
} forEach _subTasks;
