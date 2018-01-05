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
    ["_task", locationNull, [locationNull, objNull]]
];

private _id = _task getVariable [QGVAR(id), _params];
private _group = _task getVariable [QGVAR(group), _params];
private _params = _task getVariable [QGVAR(params), _params];
private _mia = _task getVariable [QGVAR(mia), ""];
GET_MIA(_mia);

_params params [
    ["_route", ["", []], [[]], 2],
    ["_area", objNull, [objnull, locationNull]]
];

_groupID = groupID _group;
_task setVariable [QGVAR(area), _area];

//MIA_LOG_1("%1 starting a patrol", _groupID);
[_group, "Patrol","_name is patroling route %1. This is task id %2", _route select 0, _id] call fsh_fnc_aiLog;

private _points = _route select 1;

//Pick a direction
if (random 1 > 0.5) then {
    reverse _points;
};

//Find starting point
private _wpStartIndex = 0;
private _closestPointDist = 99999;
{
    private _dist = _x distance (leader _group);
    if (_dist < _closestPointDist) then {
        _closestPointDist = _dist;
        _wpStartIndex = _forEachIndex;
    };
} forEach _points;

private _cutPoints = _points select [_wpStartIndex, (count _points) - _wpStartIndex];
_cutPoints append (_points select [0, _wpStartIndex]);
//Add a return point
private _startPos = _cutPoints select 0;
_cutPoints pushBack _startPos;

//Create a transport task if too far to walk
private _dist = (leader _group) distance2D _startPos;
private _tranTask = locationNull;

if (_dist > 500) then {
    private _taskType = "transport";
    private _taskPriority = 5;
    private _taskParams = [_group, _startPos];
    private _taskData = [_taskType, _taskPriority, _taskParams];
    _tranTask = [_mia, _taskData, _task] call FUNC(addTask);
    _task setVariable [QGVAR(subTasks), [_tranTask]];
    _task setVariable [QGVAR(transportTask), _tranTask];
};

//Create waypoint data
private _waypoints = [];
{
    private _wpData = [_group, getPos (leader _group), 5, "MOVE"];
    _wpData set [1, _x];
    _wpData set [2, 5];
    _wpData set [3, "MOVE"];
    _waypoints pushBack _wpData;
} forEach _cutPoints;

//Add waypoints
{
    if (_forEachIndex isEqualto 0) then {
        if (!(_tranTask isEqualto locationNull)) then {
            private _tranTaskID = _tranTask getVariable [QGVAR(id), -1];
            private _onDone = format ["[%1, 4] call fsh_fnc_endTask", _tranTaskID];
            _x set [8, _onDone];
        };
    };
    if (_forEachIndex isEqualto (count _waypoints) -1) then {
        //Last waypoint
        private _onDone = format ["[%1, 2] call fsh_fnc_endTask", _id];
        _x set [8, _onDone];
    };
    _x call fsh_fnc_addWaypoint;
} forEach _waypoints;
