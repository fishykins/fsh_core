#include "script_component.hpp"

GVARMAIN(MIAS) = [];
GVAR(miaID) = 0;
GVAR(taskID) = 0;
GVAR(allTasks) = [];
GVAR(namespace) = [false] call CBA_fnc_createNamespace;

FUNC(addArea) = COMPILE_FILE(fnc_addArea);
FUNC(addGroup) = COMPILE_FILE(fnc_addGroup);
FUNC(addTask) = COMPILE_FILE(fnc_addTask);
FUNC(init) = COMPILE_FILE(fnc_init);
FUNC(miaFSM) = QPATHTOF(mia.fsm);
FUNC(startTask) = COMPILE_FILE(fnc_startTask);


call COMPILE_FILE(nodes\init_nodes);
