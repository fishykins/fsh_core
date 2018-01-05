#include "script_component.hpp"
SCRIPT(XEH_preInit);

//Misc
SPAWN(object) = COMPILE_FILE(templates\object);
SPAWN(onRoad) = COMPILE_FILE(templates\onRoad);
SPAWN(onHangar) = COMPILE_FILE(templates\onHangar);


SPAWN(shed) = COMPILE_FILE(templates\shed);
SPAWN(garage) = COMPILE_FILE(templates\garage);
SPAWN(cupWarehouse) = COMPILE_FILE(templates\cupWarehouse);

SPAWN(table) = COMPILE_FILE(templates\table);
