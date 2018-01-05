#include "script_component.hpp"

GVAR(persistantPlayers) = false;
GVAR(saveId) = 0;
GVAR(session) = floor (random (999999));

FUNC(playerLoop) = COMPILE_FILE(fnc_serverPlayerLoop);
FUNC(loadPlayer) = COMPILE_FILE(fnc_loadPlayer);
FUNC(savePlayer) = COMPILE_FILE(fnc_savePlayer);
