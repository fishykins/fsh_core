/* ----------------------------------------------------------------------------
Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

EGVAR(ai,map) = true;
disableSerialization;
private _ui = (_this select 0) select 0;
uiNamespace setVariable [QGVAR(console), _ui];
UI_VARIABLES;

//main function tab
{
    private _displayName = _x select 0;
    _ui_main_funcSelect lbAdd _displayName;
} forEach GVAR(modes);
_ui_main_funcSelect lbSetCurSel GVAR(mode);

//AI functions tab
{
    private _displayName = _x select 0;
    _ui_ai_funcSelect lbAdd _displayName;
} forEach GVAR(aiModes);
_ui_ai_funcSelect lbSetCurSel GVAR(subMode);

//Console Tracking settings
{
    _ui_main_list_track lbAdd _x;
} forEach GVAR(trackingModes);
_ui_main_list_track lbSetCurSel GVAR(trackingMode);

//Console Colour settings
{
    _ui_ai_list_cols lbAdd _x;
} forEach GVAR(colourModes);
_ui_ai_list_cols lbSetCurSel GVAR(colourMode);


//Grab any positions we may nead
GVAR(mapUiPos) = ctrlPosition _ui_main_map;
GVAR(mapUiPosTall) = +GVAR(mapUiPos);

private _logPos = ctrlPosition _ui_ai_text_logs;
private _mapheight = (_logPos select 1) - (GVAR(mapUiPos) select 1) + (_logPos select 3);
GVAR(mapUiPosTall) set [3, _mapheight];

_ui_main_map ctrlAddEventHandler ["draw",{[_this select 0, +GVAR(drawGroups), +GVAR(drawObjects)] call fsh_fnc_mapDraw}];
_ui_main_map ctrlAddEventHandler ["MouseMoving", FUNC(mapMousePos)];
