/* ----------------------------------------------------------------------------
This is where the majoirty of the console functions are declared.
for tab-spesific stuff, see sepperate init_...

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

GVARMAIN(trackedGroups) = [];
GVARMAIN(trackedObjects) = [];
GVARMAIN(trackedEllipses) = [];
GVARMAIN(selectedGroup) = grpNull;
GVARMAIN(selected) = objNull;

//Display modes
GVAR(colourModes) = ["Side","Custom"];
GVAR(tmGroups) = ["Off", "Icons", "Icons + ID", "Icons + ID + Units"];
GVAR(tmUnits) = ["Off", "Icons", "Icons + Names"];
GVAR(groupTracking) = profileNamespace getVariable [QGVAR(groupTracking), 0];
GVAR(unitTracking) = profileNamespace getVariable [QGVAR(unitTracking), 0];
GVAR(playerTracking) = profileNamespace getVariable [QGVAR(playerTracking), 0];

GVAR(tempMarkers) = [];
GVAR(tempTracked) = [];

GVAR(modes) = []; //Left tabs
GVAR(subModes) = []; //Bottom tabs
GVAR(mode) = 0;
GVAR(subMode) = -1;
GVAR(showSubs) = false;
GVAR(trackingMode) = DEFAULT_TRACKINGLEVEL;
GVAR(colourMode) = DEFAULT_COLOURMODE;
GVAR(mapClickType) = 0;
GVAR(updating) = false;
GVAR(listGroups) = [];

GVAR(groups) = [];
GVAR(objects) = [];

GVAR(group) = grpNull;
GVAR(unit) = objNull;
GVAR(selected) = objNull;

GVAR(selectedGroupData) = [];

//=================================================================//
//====================== CONSOLE MAIN FUNCS =======================//
//=================================================================//
FUNC(getObjectColour) = COMPILE_FILE(fnc_getObjectColour);
FUNC(mapClicked) = COMPILE_FILE(fnc_mapClicked);
FUNC(mapMousePos) = COMPILE_FILE(fnc_mapMousePos);
FUNC(consoleEnabled) = {true};
FUNC(openConsole) = {createDialog QGVAR(debugConsole);};
FUNC(consoleInit) = COMPILE_FILE(fnc_consoleInit);

FUNC(consoleExit) = {
    GVAR(groups) = [];
    GVAR(group) = grpNull;
    GVAR(unit) = objNull;
    EGVAR(ai,map) = false;
    {deleteMarker _x;} forEach GVAR(allMarkers);
    call FUNC(clearTemp);
};



FUNC(update) = COMPILE_FILE(fnc_update);
FUNC(refresh) = COMPILE_FILE(fnc_refresh);

//================= MAIN FUNCTION CHANGED (top left) ==============//
FUNC(functionChanged) = {
    GVAR(mode) = _this select 1;
    call FUNC(refresh);
};

//================= MAIN TREE CHANGED (left list) ==============//
FUNC(TreeSelChanged) = {
    COMPILE_UI;
    private _index = _this select 1;
    private _data = _ui_main_list_left tvData _index;
    GVAR(subMode) = -1;
    for [{private _sfI = 0}, {_sfI < count GVAR(subModes)}, {INC(_sfI)}] do {
        private _entry = GVAR(subModes) select _sfI;
        if ((_entry select 0) isEqualto _data) then {
            GVAR(subMode) = _sfI;
            _sfI = (count GVAR(subModes+1));
        };
    };
    //Clear temp markers
    call FUNC(clearTemp);
    //Find correct mode
    _this call FUNC(subModeChanged);
};

FUNC(subModeChanged) = {
    COMPILE_UI;
    private _modes = +GVAR(subModes);
    private _mode = GVAR(subMode);
    private _entry = [];
    private _ctrlShow = [];
    private _ctrlHide = [];
    if (_mode >= 0 && _mode < (count _modes)) then {
         _entry = _modes deleteAt _mode;
        _ctrlShow = _entry select 1;
        private _fnc_refresh = _entry select 2;

        //Call the refresh function
        _this call _fnc_refresh;
    };

    {
        _x params ["_name", "_controls"];
        _ctrlHide append _controls;
    } forEach _modes;

    {
        private _id = _ui DisplayCtrl _x;
        _id ctrlShow false;
    } forEach _ctrlHide;

    {
        private _id = _ui DisplayCtrl _x;
        _id ctrlShow true;
    } forEach _ctrlShow;

    //hint format ["%3 (%4): %1, %2", _ctrlShow, _ctrlHide, _entry, _mode];
    _ui_main_map ctrlSetPosition (if (_ctrlShow isequalto []) then {[MAP_X, MAP_Y, MAP_W, MAP_H2]} else {[MAP_X, MAP_Y, MAP_W, MAP_H1]});
    _ui_main_map ctrlCommit 0.2;
};

FUNC(clearTemp) = {
    {
        deleteMarker _x;
    } forEach GVAR(tempMarkers);
    {
        [_x, 0] call fsh_fnc_track;
    } forEach GVAR(tempTracked);

    GVAR(tempTracked) = [];
    GVAR(tempMarkers) = [];
};

//============== SUB FUNCTION CHANGED (middle bottom) =============//
FUNC(subFunctionChanged) = {
    GVAR(subMode) = _this select 1;
    call FUNC(update);
};

//======================== TRACKING MODE ==========================//
FUNC(track) = {
    params ["_level","_array",["_groupCalledFunc", false, [false]], ["_save", true, [false]] ];
    {
        private _trackingDefault = _x getVariable [QGVAR(trackingDefault), true];
        if (_trackingDefault) then {
            if (IS_GROUP(_x) || _groupCalledFunc) then {
                [_x, _level] call fsh_fnc_track;
            } else {
                //Group settings take priority over global
                private _groupUnitTracking = (group _x) getVariable [QGVAR(unitTrackingLevel), -1];
                if (_groupUnitTracking isEqualto -1 || _groupUnitTracking isEqualto (count GVAR(tmUnits))) then {
                    [_x, _level] call fsh_fnc_track;
                };
            };

        };
    } forEach _array;
    if (_save) then {saveProfileNamespace;};
};

FUNC(groupTracking) = {
    params ["_ctrl", "_level", ["_save", true, [false]]];
    GVAR(groupTracking) = _level;
    profileNamespace setVariable [QGVAR(groupTracking), _level];
    [GVAR(groupTracking), allGroups, false, _save] call FUNC(track);
};

FUNC(unitTracking) = {
    params ["_ctrl", "_level", ["_save", true, [false]]];
    GVAR(unitTracking) = _level;
    profileNamespace setVariable [QGVAR(unitTracking), _level];
    [GVAR(unitTracking), allUnits - allPlayers, false, _save] call FUNC(track);
};

FUNC(playerTracking) = {
    params ["_ctrl", "_level", ["_save", true, [false]]];
    GVAR(playerTracking) = _level;
    profileNamespace setVariable [QGVAR(playerTracking), _level];
    [GVAR(playerTracking), allPlayers, false, _save] call FUNC(track);
};

[-1, GVAR(groupTracking), false] call FUNC(groupTracking);
[-1, GVAR(unitTracking), false] call FUNC(unitTracking);
[-1, GVAR(playerTracking), true] call FUNC(playerTracking);

//========================== COLOUR MODE ==========================//
FUNC(setColours) = {
    GVAR(colourMode) = _this select 1;
    //[-1,GVAR(trackingMode)] call FUNC(tracking);
};
