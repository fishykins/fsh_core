/* ----------------------------------------------------------------------------
Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

GVAR(updating) = true;
COMPILE_UI;


//Hide tabs from non selected modes
private _mode = GVAR(mode);
private _allModes = +GVAR(modes);
private _currentMode = _allModes deleteAt _mode;

_currentMode params [
    ["_displayName", "", [""]],
    ["_ctrlShow", [], [[]]],
    ["_refresh", {}, [{}]],
    ["_update", {}, [{}]]
];

call _update;
