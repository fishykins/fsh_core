/* ----------------------------------------------------------------------------
Called when a new primary tab is selected or a hard reset is needed.

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

COMPILE_UI;

private _mode = GVAR(mode);
private _allModes = +GVAR(modes);
private _currentMode = _allModes deleteAt _mode;

_currentMode params [
    ["_displayName", "", [""]],
    ["_ctrlShow", [], [[]]],
    ["_refresh", {}, [{}]],
    ["_update", {}, [{}]]
];

private _ctrlHide = [];

{
    _ctrlHide append (_x select 1);
} forEach _allModes;


{
    private _id = _ui DisplayCtrl _x;
    _id ctrlShow false;
} forEach _ctrlHide;

{
    private _id = _ui DisplayCtrl _x;
    _id ctrlShow true;
} forEach _ctrlShow;

call _refresh;
call FUNC(update);
