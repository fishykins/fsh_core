#include "script_component.hpp"

GET_MIA(_mia);

//Sort all tasks from most to least important
private _tasks = [MIA_G("tasks", []), [], {_x getVariable [QGVAR(priority), -1]},"DESCEND"] call BIS_fnc_sortBy;

//Get MIA groups (random order)
private _groups = [MIA_G("groups", [])] call cba_fnc_shuffle;

//FOREACH _tasks
{
    private _task = _x;
    private _priority = _task getVariable [QGVAR(priority), -1];
    private _status = _task getVariable [QGVAR(status), -1];
    private _taskType = _task getVariable [QGVAR(type), ""];
    private _taskGroup = _task getVariable [QGVAR(group), grpNull];
    private _taskID = _task getVariable [QGVAR(id), grpNull];

    private _rankedGroups = [];

    //If inactive and no group assigned, allocate task to best group
    if (_status isEqualto 0 && _taskGroup isEqualto grpNull) then {

        //Get the profile of an appropriate group
        private _typeBias = configProperties [missionConfigFile >> "CfgCompositions" >> "tasks" >> _taskType, "count _x > 0",true];

        //Get all groups that could potentially do this task
        {
            private _groupTask = _x getVariable [QGVAR(task), locationNull];
            private _grpTaskPriority = _groupTask getVariable [QGVAR(priority), -1];
            if (_priority > _grpTaskPriority) then {

                //This group could take the task, work out its score
                private _score = 100 * (_priority - _grpTaskPriority);
                private _groupData = [_x] call fsh_fnc_getGroupData;

                //Go through each profile and match it against this group
                for [{private _i = 0}, {_i < count _typeBias}, {INC(_i)}] do {
                    private _bias = _typeBias select _i;
                    private _types = if (getNumber (_bias >> "isGroup") isEqualto 1) then {_groupData select 1} else {_groupData select 3};
                    private _wlTypes = getArray (_bias >> "wlTypes");

                    //If we have every white listed type, increase our score acordingly
                    if (count (_wlTypes arrayIntersect _types) isEqualto (count _wlTypes)) then {
                        _score = _score * (getNumber (_bias >> "priority"));
                    } else  {

                        //Does not have required types. If this is a manditory type, set score to 0 and exit.
                        if (getNumber (_bias >> "required") isEqualto 1) then {
                            _score = 0;
                            _i = count _typeBias;
                        };
                    };
                };

                //If score is above 0, it is a viable option so add to the list of potentials
                if (_score > 0) then {
                    _rankedGroups pushBack [_x, _score];
                    [_x, "Task score","_name has been scored %1 for task %2.", _score, _task] call fsh_fnc_aiLog;
                };
            };
        } forEach _groups;

        //Sort all viable groups by their score
        _rankedGroups = [+_rankedGroups, [], {_x select 1},"DESCEND"] call BIS_fnc_sortBy;

        //Now pick the highest scoring group and give them the task
        if (!(_rankedGroups isEqualto [])) then {
            private _group = (_rankedGroups select 0) select 0;

           //Add new task
           [_group, 3] call fsh_fnc_endTask;
           [_group, _task] call fsh_fnc_startTask;

            //Remove group from cache
            REM(_groups, _group);
        };
    };
} forEach _tasks;
