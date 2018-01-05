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
    ["_mia",objNull,[objNull, "",locationNull]],
    ["_taskData", [], [[]]],
    ["_parentTask",locationNull,[objNull, locationNull]]
];

_taskData params [
    ["_type","",[""]],
    ["_priority", 1, [0]],
    ["_params",[],[[]] ]
];

/* ----------------------------------------------------------------------------
TASK STATUS
    0: inactive
    1: active
    2: success
    3: failed
    4: canceled
---------------------------------------------------------------------------- */
_taskStatus = 0;

//Get our namespace
GET_MIA(_mia);

//Get unique task id
private _taskID = GVAR(taskID);
INC(GVAR(taskID));

//Get the task from config
private _config = missionConfigFile >> "CfgCompositions" >> "tasks" >> _type;
private _init = (getText (_config >> "init"));
private _exit = (getText (_config >> "exit"));

//Create code
_init = compile format ["_this call %1", _init];
_exit = compile format ["_this call %1", _exit];


//Add the task
private _task = [false] call CBA_fnc_createNamespace;
_task setName format ["%1_%2", _type, _taskID];
_task setVariable [QGVAR(id), _taskID];
_task setVariable [QGVAR(type), _type];
_task setVariable [QGVAR(priority), _priority];
_task setVariable [QGVAR(status), _taskStatus];
_task setVariable [QGVAR(group), grpNull];
_task setVariable [QGVAR(mia), _mia];
_task setVariable [QGVAR(params), _params];
_task setVariable [QGVAR(init), _init];
_task setVariable [QGVAR(exit), _exit];
_task setVariable [QGVAR(parent), _parentTask];

MIA_PB("tasks", _task);
if (!(_parentTask isEqualto locationNull)) then {
    MIA_LOG_3("Added subtask %1 (%2) to %3", _type, _taskID, name _parentTask);
} else {
    MIA_LOG_2("Added task %1 (%2)", _type, _taskID);
};

GVAR(allTasks) pushBackUnique _task;

_task
