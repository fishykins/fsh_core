#include "script_component.hpp"

disableSerialization; 

private _data = _this select 0;
private _ui = _data select 0;
uiNamespace setVariable [QGVAR(debugUI), _ui];

GVAR(map) = true;
GVAR(commandID) = -1;
GVAR(logs) = GVAR(unit) getVariable [QGVAR(logs), []];

private _uiTracking = _ui DisplayCtrl AIDC_FUNC_TRACKING;
private _uiList = _ui DisplayCtrl AIDC_LIST;
private _uiCommands = _ui DisplayCtrl AIDC_FUNC_COMMANDS;
private _uiTitle = _ui DisplayCtrl AIDC_TITLE;
private _uiText = _ui DisplayCtrl AIDC_FUNC_TEXT;

_uiList ctrlShow true;
private _dispName = [str GVAR(unit)] call CBA_fnc_capitalize;
_uiTitle ctrlSetText _dispName;
_uiText ctrlSetText _dispName;

private _trackingLevel = ((group GVAR(unit)) getVariable [QGVAR(trackingLevel), 0]);
_uiTracking lbAdd "Tracking: off";
_uiTracking lbAdd "Tracking: minimal";
_uiTracking lbAdd "Tracking: normal";
_uiTracking lbAdd "Tracking: advanced";
_uiTracking lbAdd "Tracking: full";
_uiTracking lbSetCurSel _trackingLevel;

{
    _uiCommands lbAdd (_x select 0);
} forEach GVAR(commands);

_uiCommands lbSetCurSel 0;

{
    private _title = _x select 0;
    private _time = _x select 2;
    _uiList lbAdd format["%1: %2", _time, _title];
} forEach GVAR(logs);
_uiList lbSetCurSel 0;

GVAR(aiDebugConsole) = true;

[QGVAR(unitMarker), getPos GVAR(unit), "ICON", [1, 1],"COLOR:","colorOrange","TYPE:","mil_dot"] call CBA_fnc_createMarker;
[QGVAR(unitMarkerEvent), [-1000,-1000,0], "ICON", [1, 1],"COLOR:","colorOrange","TYPE:","mil_destroy"] call CBA_fnc_createMarker;

["", (count GVAR(logs)) -1] call GVAR(aiDebugConsoleList);

_null = _this spawn {
    disableSerialization;
    private _ui = uiNamespace getVariable QGVAR(debugUI);
    private _uiList = _ui DisplayCtrl AIDC_LIST;
    private _logCount = count GVAR(logs);
    private _unit = GVAR(unit);
    
    GVAR(logs) = GVAR(unit) getVariable [QGVAR(logs), []];
    GVAR(logID) = GVAR(unit) getVariable [QGVAR(logID), (count GVAR(logs))-1];
   
    call GVAR(aiDebugConsoleRefresh);
    
    while {GVAR(aiDebugConsole)} do {
        GVAR(logs) = GVAR(unit) getVariable [QGVAR(logs), []];
        GVAR(logID) = GVAR(unit) getVariable [QGVAR(logID), (count GVAR(logs))-1];
        
        if (!(count GVAR(logs) isEqualTo _logCount) || !(GVAR(unit) isEqualTo _unit)) then {
            lbClear _uiList;
            {
                private _title = _x select 0;
                private _time = _x select 2;
                _uiList lbAdd format["%1: %2", _time, _title];
            } forEach GVAR(logs);
            _logCount = count GVAR(logs);
            _unit = GVAR(unit);
        };
        if (GVAR(logID) >= 0) then {_uiList lbSetCurSel GVAR(logID);};
        QGVAR(unitMarker) setmarkerPos (getPos GVAR(unit));
        sleep 0.5;
    };

    deleteMarker QGVAR(unitMarker);
    deleteMarker QGVAR(unitMarkerEvent);
};