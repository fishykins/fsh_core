/* ----------------------------------------------------------------------------
This is where the majoirty of the console functions are declared.
for tab-spesific stuff, see sepperate init_...

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

GVAR(trackingModes) = ["No Tracking","Default","Selected","Icons","Icons + Names","Units","Units + Names"];
GVAR(colourModes) = ["Side Colours","Custom Colours"];

GVAR(modes) = [];
GVAR(mode) = 0;
GVAR(subMode) = 0;
GVAR(showSubs) = false;
GVAR(trackingMode) = DEFAULT_TRACKINGLEVEL;
GVAR(colourMode) = DEFAULT_COLOURMODE;
GVAR(mapClickType) = 0;

GVAR(groups) = [];
GVAR(objects) = [];

GVAR(drawGroups) = GVAR(groups);
GVAR(drawObjects) = GVAR(objects);

GVAR(group) = grpNull;
GVAR(unit) = objNull;

//=================================================================//
//====================== CONSOLE MAIN FUNCS =======================//
//=================================================================//
FUNC(consoleEnabled) = {true};

FUNC(openConsole) = {
    createDialog QGVAR(debugConsole);
};

FUNC(consoleInit) = COMPILE_FILE(fnc_consoleInit);

FUNC(consoleExit) = {
    GVAR(groups) = [];
    GVAR(group) = grpNull;
    GVAR(unit) = objNull;
    EGVAR(ai,map) = false;
};


GVAR(updating) = false;
FUNC(update) = COMPILE_FILE(fnc_update);
FUNC(refresh) = COMPILE_FILE(fnc_refresh);

//================= MAIN FUNCTION CHANGED (top left) ==============//
FUNC(functionChanged) = {
    GVAR(mode) = _this select 1;
    call FUNC(refresh);
};

//============== SUB FUNCTION CHANGED (middle bottom) =============//
FUNC(subFunctionChanged) = {
    GVAR(subMode) = _this select 1;
    call FUNC(update);
};

//======================== TRACKING MODE ==========================//
FUNC(tracking) = {
    GVAR(trackingMode) = _this select 1;

    call FUNC(refresh);

    GVAR(drawGroups) = GVAR(groups);
    GVAR(drawObjects) = GVAR(objects);

    switch (GVAR(trackingMode)) do {
        case (1): {
            GVAR(drawGroups) = GVARMAIN(trackedGroups);
            GVAR(drawObjects) = GVARMAIN(trackedObjects);
        };
        case (0);
        case (2): {
            GVAR(drawGroups) = [];
            GVAR(drawObjects) = [];
        };
    };

};

//========================== COLOUR MODE ==========================//
FUNC(setColours) = {
    GVAR(colourMode) = _this select 1;
    [-1,GVAR(trackingMode)] call FUNC(tracking);
};
