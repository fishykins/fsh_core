/* ----------------------------------------------------------------------------
Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

GVAR(updating) = true;
COMPILE_UI;

private _object = if (GVAR(unit) isEqualto objNull) then {GVAR(group)} else {GVAR(unit)};

//PRIMARY MODE
private _mode = GVAR(mode);
private _allModes = +GVAR(modes);
private _currentMode = _allModes deleteAt _mode;
private _functionControl = _currentMode select 3;
private _ctrlHide = [];
private _ctrlShow = _currentMode select 1;
{
    _ctrlHide append (_x select 1);
    _ctrlHide pushBackUnique (_x select 3);
    {
        _ctrlHide append (_x select 1);
    } forEach (_x select 2);
} forEach _allModes;

//SUB MODE
private _subMode = GVAR(subMode);
if (_subMode >= 0) then {
    private _allSubModes = _currentMode select 2;
    if (GVAR(showSubs)) then {
        private _currentSubMode = _allSubModes deleteAt _subMode;
        _ctrlShow pushBack _functionControl;
        _ctrlShow append (_currentSubMode select 1);
    } else {
        _ctrlHide pushBack _functionControl;
    };
    {_ctrlHide append (_x select 1);} forEach _allSubModes;
};

{
    private _id = _ui DisplayCtrl _x;
    _id ctrlShow false;
} forEach _ctrlHide;

{
    private _id = _ui DisplayCtrl _x;
    _id ctrlShow true;
} forEach _ctrlShow;

//Map
if (GVAR(showSubs)) then {
    _ui_main_map ctrlSetPosition GVAR(mapUiPos);
} else {
    _ui_main_map ctrlSetPosition GVAR(mapUiPosTall);
};
_ui_main_map ctrlCommit 0.05;

//Update commands (this is a set list so doesnt matter)
private _functions = if (GVAR(unit) isEqualto objNull) then {+GVAR(GroupFunctions)} else {+GVAR(unitFunctions)};;
lbClear _ui_ai_list_funcs;
_ui_ai_list_funcs lbSetCurSel -1;
{
    private _index = _ui_ai_list_funcs lbAdd (_x select 0);
    _ui_ai_list_funcs lbSetData [_index, (_x select 1)];
} forEach _functions;

//Update tracking menu selections
private _trackingLevels = if (GVAR(unit) isEqualto objNull) then {+GVAR(groupTrackingModes)} else {+GVAR(unitTrackingModes)};
lbClear _ui_ai_list_track;
{
    _ui_ai_list_track lbAdd _x;
} forEach _trackingLevels;
_ui_ai_list_track lbSetCurSel -1;

//Update Logs
private _logs = _object getVariable [QEGVAR(ai,logs), []];
lbClear _ui_ai_list_logs;
_ui_ai_list_logs lbSetCurSel -1;
_ui_ai_text_logs ctrlSetText "";
{
    private _title = _x select 0;
    private _time = _x select 2;
    _ui_ai_list_logs lbAdd format["%1: %2", _time, _title];
} forEach _logs;

//Update marker tracking settings
private _trackingLevel = _object getVariable [QGVARMAIN(trackingLevel), 0];
_ui_ai_list_track lbSetCurSel _trackingLevel;


//Update colour bars
private _custColour = [_object] call FUNC(getObjectColour);
_ui_ai_slider_R sliderSetPosition (_custColour select 0) * 10;
_ui_ai_slider_G sliderSetPosition (_custColour select 1) * 10;
_ui_ai_slider_B sliderSetPosition (_custColour select 2) * 10;
_ui_ai_slider_A sliderSetPosition (_custColour select 3) * 10;

GVAR(updating) = false;
