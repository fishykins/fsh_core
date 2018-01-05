#include "script_component.hpp"

//Unit init
FUNC(unitInit) = {
    private _unit = _this select 0;
    if (leader (group _unit) isEqualto _unit) then {
        [group _unit,"Group Init", "_name has spawned under the command of some random goon"] call fsh_fnc_aiLog;
    };
    [_unit,"Unit Init", "_name has spawned, wide-eyed and full of childish glee"] call fsh_fnc_aiLog;
};

//Unit killed
FUNC(unitKilled) = {
    private _unit = _this select 0;
    [_unit,"Death", "_name has hoofed it."] call fsh_fnc_aiLog;
};

GVAR(doMove_fsm) = QPATHTOF(doMove.fsm);

call COMPILE_FILE(init_debugConsole);
