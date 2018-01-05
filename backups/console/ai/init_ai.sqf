#include "script_component.hpp"

call COMPILE_FILE(init_aiButtons);

GVAR(aiModes) = [
    ["Functions",[IDC_AI_LIST_FUNCS,IDC_AI_EDIT_FUNCS,IDC_AI_BUTTON_1,IDC_AI_BUTTON_2,IDC_AI_BUTTON_3,IDC_AI_LIST_TRACK,IDC_AI_SLIDER_R,IDC_AI_SLIDER_G,IDC_AI_SLIDER_B,IDC_AI_SLIDER_A]],
    ["Logs",[IDC_AI_LIST_LOGS,IDC_AI_TEXT_LOGS]],
    ["Variables",[IDC_AI_LIST_VARS]],
    ["Waypoints",[IDC_AI_LIST_WAYPTS]]
];

GVAR(modes) pushBack ["Linked groups",[IDC_AI_LIST_MAIN],GVAR(aiModes),IDC_AI_FUNCSELECT];
GVAR(modes) pushBack ["All Groups",[IDC_AI_LIST_MAIN],GVAR(aiModes),IDC_AI_FUNCSELECT];

GVAR(unitFunctions) = [
    ["Regroup", QUOTE(call FUNC(regroup))],
    ["Move", QUOTE(call FUNC(doMove))],
    ["Teleport", QUOTE(call FUNC(teleport))],
    ["Heal", QUOTE(call FUNC(heal))],
    ["Immortal", QUOTE(call FUNC(immortal))],
    ["Mortal", QUOTE(call FUNC(mortal))],
    ["Kill", QUOTE(call FUNC(kill))]
];

GVAR(groupFunctions) = [
    ["Apply tracking", QUOTE(call FUNC(applyTrackingToUnits))],
    ["Link colour", QUOTE(call FUNC(linkGroupColours))],
    ["Unlink colour", QUOTE(call FUNC(unlinkGroupColours))],
    ["Show waypoints", QUOTE(call FUNC(showWaypoints))]
];

GVAR(unitTrackingModes) = ["No Tracking","Icon", "Icon + Name"];
GVAR(groupTrackingModes) = ["No Tracking", "Icon", "Icon + Name", "Units", "Units + Names"];

GVAR(lastListIndex) = -5;
GVAR(logSelected) = 0;
[QGVAR(marker), [0,0], "ICON", [1, 1],"COLOR:","colorOrange","TYPE:","mil_dot"] call CBA_fnc_createMarker;
[QGVAR(logMarker), [-1000,-1000,0], "ICON", [1, 1],"COLOR:","colorOrange","TYPE:","mil_destroy"] call CBA_fnc_createMarker;


//=================================================================//
//================= AI LIST (left column) ALTERED =================//
//=================================================================//
FUNC(aiChanged) = {
    COMPILE_UI;

    private _index = _this select 1;
    if (_index isEqualto []) exitWith {};

    GVAR(logSelected) = -3;

    _index params [["_groupIndex",0],["_unitIndex",0]];

    if (GVAR(lastListIndex) isEqualto _index) exitWith {
        //Unselect
        GVAR(showSubs) = false;
        GVAR(unit) = objNull;
        GVAR(group) = grpNull;
        GVAR(lastListIndex) = -1;
        _ui_ai_list_main tvSetCurSel [-1];
        if (GVAR(trackingMode) isEqualto 2) then {
            GVAR(drawGroups) = [];
            GVAR(drawObjects) =[];
        };
        call FUNC(update);
    };
    private _groupArray = GVAR(groups) select _groupIndex;
    private _group = _groupArray select 0;
    private _units = _groupArray select TRACK_I_UNITS;
    if (count _index >= 2) then {
        //-------------------- NEW UNIT SELECTED ---------------------//
        private _unit = _units select _unitIndex;
       GVAR(logs) = _unit getVariable [QEGVAR(ai,logs), []];
        //Snap map to unit
        _ui_main_map ctrlMapAnimAdd [MAP_SPEED, MAP_ZOOM, _unit];

        if (GVAR(subMode) < 0) then {GVAR(subMode) = 0;};
        GVAR(unit) = _unit;
        GVAR(group) = grpNull;
    } else {
        //-------------------- NEW GROUP SELECTED ---------------------//
        private _unit = leader _group;
        GVAR(logs) = _group getVariable [QEGVAR(ai,logs), []];

        //Snap map to leader
        _ui_main_map ctrlMapAnimAdd [MAP_SPEED, MAP_ZOOM, _unit];

        GVAR(unit) = objNull;
        GVAR(group) = _group;
    };

    //If "draw selected" is running, draw this object
    if (GVAR(trackingMode) isEqualto 2) then {
        if (!(GVAR(group) isEqualto grpNull)) then {
            //GROUP
            private _marker = (([GVAR(group)] call fsh_fnc_getGroupData) select 0) select 0;
            private _markerID = getText (configfile >> "CfgMarkers" >> _marker >> "Icon");
            private _text = groupID GVAR(group);
            private _colour = [0,1,1,0.7];
            private _leader = leader GVAR(group);
            private _units = units GVAR(group);
            private _unitsDraw = [];
            {
                private _unitMarkerID = getText (configFile >> "CfgVehicles" >> typeOf _x >> "Icon");
                private _unitText = name _x;
                private _unitColour = [1,0,1,0.7];
                _unitsDraw pushBack [_x, GVAR(trackingMode), _unitMarkerID, _unitText, _unitColour];
            } forEach (_units - [_leader]);
            GVAR(drawGroups) = [ [GVAR(group), 2, _markerID, _text, _colour, _unitsDraw] ];
            GVAR(drawObjects) = [];
        } else {
            //UNIT
            private _unitMarkerID = getText (configFile >> "CfgVehicles" >> typeOf GVAR(unit) >> "Icon");
            private _unitText = name GVAR(unit);
            private _unitColour = [1,0,1,0.7];
            GVAR(drawGroups) = [];
            GVAR(drawObjects) =[ [GVAR(unit), GVAR(trackingMode), _unitMarkerID, _unitText, _unitColour] ];
        };

    };


    ctrlMapAnimCommit _ui_main_map;
    GVAR(showSubs) = true;
    GVAR(lastListIndex) = _index;
    call FUNC(update);
};

//=================================================================//
//======================= LOG CHANGED (AI) ========================//
//=================================================================//
FUNC(logChanged) = {
    private _index = _this select 1;
    if (_index < 0) exitWith {};

    if (_index isEqualto GVAR(logSelected)) exitWith {
        //Unselect log
        COMPILE_UI;
        _ui_ai_text_logs ctrlSetText "";
        QGVAR(logMarker) setMarkerPos [-1000,-1000];
        GVAR(logSelected) = -2;
        _ui_ai_list_logs lbSetCurSel -1;
    };

    GVAR(logSelected) = _index;
    if (count GVAR(logs) > GVAR(logSelected)) then {
        COMPILE_UI;

        private _log = GVAR(logs) select GVAR(logSelected);
        private _text = _log select 1;
        private _pos = _log select 3;
        _ui_ai_text_logs ctrlSetText _text;
        QGVAR(logMarker) setMarkerPos _pos;
    };
};
