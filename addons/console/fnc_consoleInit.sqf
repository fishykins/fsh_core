/* ----------------------------------------------------------------------------
Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

EGVAR(ai,map) = true;
GVAR(subMode) = -1;

disableSerialization;
private _ui = (_this select 0) select 0;
uiNamespace setVariable [QGVAR(console), _ui];
UI_VARIABLES;

//Markers
GVAR(allMarkers) = [];

//main function tab
{
    private _displayName = _x select 0;
    _ui_main_funcSelect lbAdd _displayName;
} forEach GVAR(modes);
_ui_main_funcSelect lbSetCurSel GVAR(mode);

//================================ TRACKING LISTS ===================================//
//Console GROUP Tracking settings
{
    _ui_main_list_track_groups lbAdd _x;
} forEach GVAR(tmGroups);
_ui_main_list_track_groups lbSetCurSel GVAR(groupTracking);
//Console UNIT Tracking settings
{
    _ui_main_list_track_units lbAdd _x;
    _ui_main_list_track_players lbAdd _x;
} forEach GVAR(tmUnits);
_ui_main_list_track_units lbSetCurSel GVAR(unitTracking);
_ui_main_list_track_players lbSetCurSel GVAR(playerTracking);

//Console Colour settings
{
    _ui_ai_list_cols lbAdd _x;
} forEach GVAR(colourModes);
_ui_ai_list_cols lbSetCurSel GVAR(colourMode);

[-1, []] call FUNC(subModeChanged);

_ui_main_map ctrlAddEventHandler ["draw",{[_this select 0, +GVARMAIN(trackedGroups), +GVARMAIN(trackedObjects)] call fsh_fnc_mapDraw}];
_ui_main_map ctrlAddEventHandler ["MouseMoving", FUNC(mapMousePos)];
