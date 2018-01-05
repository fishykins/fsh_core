#include "script_component.hpp"

FUNC(pauseMenu) = COMPILE_FILE(XEH_pauseMenu);


private _null = [] spawn {
    disableSerialization;
    while {true} do {
        waitUntil {!isNull findDisplay 49}; // 49 = Esc menu
        ["opened"] call FUNC(pauseMenu);
        waitUntil {isNull findDisplay 49};
        ["closed"] call FUNC(pauseMenu);
    };
};
