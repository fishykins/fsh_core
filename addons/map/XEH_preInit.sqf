#include "script_component.hpp"
#define GRID_SIZE 200
SCRIPT(XEH_preInit);

GVAR(uid) = 0;
GVAR(triggerID) = 0;


GVARMAIN(gridSize) = GRID_SIZE;
GVARMAIN(gridPoints) = [GVARMAIN(gridSize),""] call fsh_fnc_worldGrid;

GVAR(gridhzd) = (sqrt ((GVARMAIN(gridSize)^2) + (GVARMAIN(gridSize)^2))) * 1.2;

fshTime = 0;
