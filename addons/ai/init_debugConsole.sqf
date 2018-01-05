#include "script_component.hpp"
#define UI_DATA(_var) (_this select  _var)

GVAR(commands) = [
    ["Regroup", QUOTE(call GVAR(aiDebugConsoleRegroup))],
    ["Move", QUOTE(call GVAR(aiDebugConsoleMove))],
    ["Teleport", QUOTE(call GVAR(aiDebugConsoleTeleport))],
    ["Heal", QUOTE(GVAR(unit) setDamage 0)],
    ["Immortal", QUOTE(GVAR(unit) allowDamage false)],
    ["Mortal", QUOTE(GVAR(unit) allowDamage true)],
    ["Kill", QUOTE(call GVAR(aiDebugConsoleKill))]
];

GVAR(map) = false;
GVAR(aiDebugConsole) = false;
GVAR(teleport) = false;
GVAR(xMove) = false;
GVAR(commandID) = -1;



//UI master commands
GVAR(canDebugAi) =  {true}; 
GVAR(aiDebugConsoleOpen) = {GVAR(unit) = _this select 0; createDialog QGVAR(aiDebugConsole);};
GVAR(aiDebugConsoleInit) = COMPILE_FILE(fnc_aiDebugConsole);
GVAR(aiDebugConsoleExit) = {GVAR(MAP) = false;GVAR(aiDebugConsole) = false;};


//Onscreen buttons
GVAR(aiDebugConsoleTracking) = {[GVAR(unit),UI_DATA(1)] call fsh_fnc_trackGroup;};
GVAR(aiDebugConsoleChangeCommand) = {GVAR(commandID) = UI_DATA(1);};

GVAR(aiDebugConsoleDoCommand) = {
    if (GVAR(commandID) >= 0) then {
        private _command = GVAR(commands) select GVAR(commandID);
        call compile (_command select 1);
    };
};

GVAR(aiDebugConsoleList) = {
    GVAR(logID) = _this select 1;
    if (GVAR(logID) >= 0) then {
        GVAR(unit) setVariable [QGVAR(logID), GVAR(logID), false];
        call GVAR(aiDebugConsoleRefresh);
    };
};

GVAR(aiDebugConsoleTextBox) = {
    if (_this select 1 isEqualTo 28) then {
        private _ui = uiNamespace getVariable QGVAR(debugUI);
        private _uiTextBox = _ui DisplayCtrl AIDC_FUNC_TEXT; 
        private _text = ctrlText _uiTextBox;
        private _oldName = str GVAR(unit);
        GVAR(unit) setVehicleVarName _text;
        [GVAR(unit),"Name Changed", "%1 has changed name to %name", _oldName] call fsh_fnc_aiLog;
        call GVAR(aiDebugConsoleRefresh);
    };
};

//Command functions
GVAR(aiDebugConsoleRefresh) = {
    private _ui = uiNamespace getVariable QGVAR(debugUI);
    private _uiTitle = _ui DisplayCtrl AIDC_TITLE; 
    private _uiDataTitle = _ui DisplayCtrl AIDC_DATA_TITLE; 
    private _uiDataTime = _ui DisplayCtrl AIDC_DATA_TIME; 
    private _uiDataEntry = _ui DisplayCtrl AIDC_DATA_ENTRY; 
    private _uiTextBox = _ui DisplayCtrl AIDC_FUNC_TEXT; 
    private _uiList = _ui DisplayCtrl AIDC_LIST;

    private _dispName = [str GVAR(unit)] call CBA_fnc_capitalize;
    _dispName = format["%1 (%2)", name GVAR(unit), _dispName];
    _uiTitle ctrlSetText _dispName;
    
    if (GVAR(logID) >= 0) then {
        private _log = GVAR(logs) select GVAR(logID);
        _uiDataTitle ctrlSetText (_log select 0);
        _uiDataEntry ctrlSetText (_log select 1);
        _uiDataTime ctrlSetText format["%1", _log select 2];
        QGVAR(unitMarkerEvent) setmarkerPos (_log select 3);
    } else {
        _uiDataTitle ctrlSetText "";
        _uiDataEntry ctrlSetText "";
        _uiDataTime ctrlSetText "";
    };
    QGVAR(unitMarker) setmarkerPos (getPos GVAR(unit));
};

GVAR(aiDebugConsoleMove) = {GVAR(xMove) = true; GVAR(teleport) = false; hint "left click on the map with the move location, right click to cancel";};
GVAR(aiDebugConsoleTeleport) = {GVAR(teleport) = true; hint "left click on the map to teleport, right click to cancel";};
GVAR(aiDebugConsoleKill) = {GVAR(unit) setDamage 1;};
GVAR(aiDebugConsoleRegroup) = {hint "Regrouping"; [GVAR(unit), "regroup"] call fsh_fnc_doMove;};

GVAR(aiDebugConsoleMap) = {
    disableSerialization; 
    private _ui = uiNamespace getVariable QGVAR(debugUI);
    private _button = UI_DATA(1);
    private _localPos = [UI_DATA(2),UI_DATA(3)];
    //_localPos = uiNamespace getVariable QGVAR(mousepos);
    private _uiMap = _ui DisplayCtrl AIDC_MAP; 
    _WorldCoord = _uiMap PosScreenToWorld _localPos;
    if (_button isEqualTO 0) then {
        if (GVAR(teleport)) then {
            GVAR(teleport) = false;
            GVAR(unit) setPos _WorldCoord;
            [GVAR(unit),"Teleported", "%name has been teleported to %1", mapGridPosition _WorldCoord] call fsh_fnc_aiLog;
        } else {
            if (GVAR(xMove)) then {
                GVAR(xMove) = false;
                [GVAR(unit), _WorldCoord, "AUTO"] call fsh_fnc_doMove;
                hint format["%1 is moving to %2", GVAR(unit), mapGridPosition _WorldCoord];
            } else {
                private _nearestUnit = nearestObject [_WorldCoord, "man"];
                GVAR(unit) = _nearestUnit;
                call GVAR(aiDebugConsoleRefresh);
            };
        };
    };
        
    if (_button isEqualTO 1) then {GVAR(teleport) = false; GVAR(xMove) = false;};
    //hintSilent format["%1 -> %2 (%3 %4)", _localPos, _WorldCoord,_ui, _uiMap];
};