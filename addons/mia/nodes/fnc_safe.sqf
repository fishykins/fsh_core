#include "script_component.hpp"

private _areas = MIA_G("areas", []);
private _groups = MIA_G("groups", []);

{
    private _awareness = _x getVariable ["awareness", 0];
    //private _workload = _x getVariable ["workload", 0];

    if (_awareness < 2) then {
        //This area is not yet fully surveyed.
        _x setVariable ["awareness", _awareness + 1];

        //Setup the task
        private _patrolRoutes = _x getVariable ["patrolRoutes", []];

        if (!(_patrolRoutes isEqualto [])) then {
            private _taskType = "patrol";
            private _taskPriority = 2;
            private _taskParams = [(selectRandom _patrolRoutes), _x];
            private _task = [_taskType, _taskPriority, _taskParams];

            [_mia, _task] call FUNC(addTask);
        };
    };
} forEach _areas;

{
    
} forEach GVARMAIN(gridPoints);
