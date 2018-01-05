GVAR(groupLogSelected) = -1;

FUNC(sm_grpRefresh) = {
    COMPILE_UI;
    params ["_ctrl","_index"];
    private _groupIndex = _ctrl tvValue _index;
    //GVAR(group) = GVAR(listGroups) select _groupIndex;
    GVAR(selected) = GVAR(listGroups) select _groupIndex;
    _ui_group_text_header ctrlSetText (groupID GVAR(selected));
    GVAR(selectedLogs) = GVAR(selected) getVariable [QEGVAR(ai,logs), []];

    //TRACKING MODES GROUP
    lbClear _ui_group_list_tracking;
    {
        _ui_group_list_tracking lbAdd _x;
    } forEach (GVAR(tmGroups) + ["Default"]);
    private _trackingDefault = GVAR(selected) getVariable [QGVAR(trackingDefault), true];
    _ui_group_list_tracking lbSetCurSel (if (_trackingDefault) then {count GVAR(tmGroups)} else {GVAR(selected) getVariable [QGVARMAIN(trackingLevel), 0]});

    //TRACKING MODES (units)
    lbClear _ui_group_list_trackingUnits;
    {
        _ui_group_list_trackingUnits lbAdd _x;
    } forEach (GVAR(tmUnits) + ["Default"]);
    private _groupUnitTracking = GVAR(selected) getVariable [QGVAR(unitTrackingLevel), count GVAR(tmUnits)];
    _ui_group_list_trackingUnits lbSetCurSel _groupUnitTracking;

    //LOGS
    lbClear _ui_group_list_logs;
    {
        private _title = _x select 0;
        private _time = _x select 2;
        _ui_group_list_logs lbAdd format["%1: %2", _time, _title];
    } forEach GVAR(selectedLogs);
    GVAR(groupLogSelected) = -2;
    _ui_group_list_logs lbSetCurSel (count GVAR(selectedLogs)) -1;

    //Sliders
    //Update colour bars
    private _custColour = [GVAR(selected)] call FUNC(getObjectColour);
    _ui_group_slider_r sliderSetPosition (_custColour select 0) * 10;
    _ui_group_slider_g sliderSetPosition (_custColour select 1) * 10;
    _ui_group_slider_b sliderSetPosition (_custColour select 2) * 10;
    //_ui_ai_slider_A sliderSetPosition (_custColour select 3) * 10;

    //Temporary Tracking, ONLY IF NOT TRACKING
    //[GVAR(selected), 1, [1,1,0,1]] call fsh_fnc_track;
    //GVAR(tempTracked) pushBackUnique GVAR(selected);
};

FUNC(groupLogChanged) = {
    private _index = _this select 1;
    COMPILE_UI;
    if (_index < 0) exitWith {{_x ctrlSetText "";} forEach [_ui_group_text_log, _ui_group_text_logtitle, _ui_group_text_logTime];};

    if (_index isEqualto GVAR(groupLogSelected)) exitWith {
        //Unselect log
        //{_x ctrlSetText "";} forEach [_ui_group_text_log, _ui_group_text_logtitle, _ui_group_text_logTime];
        deleteMarker QGVAR(logMarker);
        GVAR(groupLogSelected) = -2;
        _ui_group_list_logs lbSetCurSel -1;
    };

    GVAR(groupLogSelected) = _index;
    if (count GVAR(selectedLogs) > GVAR(groupLogSelected)) then {
        private _log = GVAR(selectedLogs) select GVAR(groupLogSelected);
        _log params [
            "_title",
            "_text",
            "_time",
            "_pos"
        ];
        _ui_group_text_log ctrlSetText _text;
        _ui_group_text_logtitle ctrlSetText _title;
        _ui_group_text_logTime ctrlSetText _time;
        deleteMarker QGVAR(logMarker);
        GVAR(tempMarkers) pushBack ([QGVAR(logMarker), _pos, "ICON", [1, 1],"COLOR:","colorOrange","TYPE:","mil_destroy"] call CBA_fnc_createMarker);
    };
};

FUNC(sm_trackGroup) = {
    private _tracking = _this select 1;
    private _default = false;
    if (_tracking isEqualto (count GVAR(tmGroups)) ) then {
        //Default Mode
        _default = true;
        _tracking = GVAR(groupTracking);
    };

    private _trackingCurrent = GVAR(selected) getVariable [QGVARMAIN(trackingLevel), count GVAR(tmGroups)];
    if (_tracking isEqualto _trackingCurrent) exitWith {};

    [GVAR(selected), _tracking] call fsh_fnc_track;
    GVAR(selected) setVariable [QGVAR(trackingDefault), _default, false];
};

FUNC(sm_trackUnits) = {
    private _tracking = _this select 1;
    private _trackingSet = _tracking;
    if (_tracking isEqualto (count GVAR(tmUnits)) ) then {
        //Default Mode
        _tracking = GVAR(unitTracking);
        _trackingSet = nil;
    };
    [_tracking, (units GVAR(selected)), true] call FUNC(track);
    GVAR(selected) setVariable [QGVAR(unitTrackingLevel), _trackingSet, false];
};

GVAR(subModes) pushBack [
    "group",
    [   IDC_GROUP_TEXT_HEADER,
        IDC_GROUP_LIST_LOGS,IDC_GROUP_TEXT_LOG,IDC_GROUP_TEXT_LOGTIME,IDC_GROUP_TEXT_LOGTITLE,
        IDC_GROUP_TEXT_NAMEEDIT,IDC_GROUP_EDIT_NAME,
        IDC_GROUP_TEXT_TRACKINGMODE,IDC_GROUP_LIST_TRACKING,
        IDC_GROUP_TEXT_TRACKINGMODEUNITS,IDC_GROUP_LIST_TRACKINGUNITS,
        IDC_GROUP_TEXT_COLOUR,IDC_GROUP_SLIDER_R,IDC_GROUP_SLIDER_G,IDC_GROUP_SLIDER_B
    ],
    FUNC(sm_grpRefresh)
];
