class groups_text_header : GVARMAIN(RscText) {
    idc = IDC_GROUP_TEXT_HEADER;
    sizeEx = 0.032;
    text = "Group name";
    BUTTON_4(0,0,2,1);
};

class groups_list_logs : GVARMAIN(RscListBox) {
    idc = IDC_GROUP_LIST_LOGS;
    onLBSelChanged = QUOTE(_this call FUNC(groupLogChanged));
    BUTTON_4(0,1,2,9);
};

//LOGS

class groups_text_logTitle : GVARMAIN(RscText) {
    idc = IDC_GROUP_TEXT_LOGTITLE;
    text = "Title";
    BUTTON_4(2,0,4,1);
};

class groups_text_logTime : GVARMAIN(RscText) {
    idc = IDC_GROUP_TEXT_LOGTIME;
    text = "0:00";
    BUTTON_4(4,0,5,1);
};

class groups_text_log : GVARMAIN(RscStructuredText) {
    idc = IDC_GROUP_TEXT_LOG;
    text = "mary had a little lamb its fleece was white as snow";
    BUTTON_4(2,1,5,9);
};

//EDITS

#define EDSEC_X1 10
#define EDSEC_X2 11
#define EDSEC_X3 12

class groups_text_nameEdit : GVARMAIN(RscText) {
    idc = IDC_GROUP_TEXT_NAMEEDIT;
    text = "Set Name";
    BUTTON_4(EDSEC_X1,0,EDSEC_X3,0.5);
};


class group_edit_name: GVARMAIN(RscEdit) {
    idc = IDC_GROUP_EDIT_NAME;
    colorBackground[] = COL_VAR_2(0.2,0.5);
    colorText[] = COL_WHITE;
    colorDisabled[] = COL_AWHITE(1);
    colorSelection[] = COL_AWHITE(1);
    sizeEx = 0.025;
    text = "edit";
    onKeyDown = QUOTE(_this call GVAR(aiDebugConsoleTextBox));
    BUTTON_4(EDSEC_X1,0.5,EDSEC_X3,1.5);
};

class groups_text_trackingmode : groups_text_nameEdit {
    idc = IDC_GROUP_TEXT_TRACKINGMODE;
    text = "Tracking Mode";
    BUTTON_4(EDSEC_X1,2,EDSEC_X3,2.5);
};

class groups_list_trackingMode : GVARMAIN(RscDropdownMenu) {
    idc = IDC_GROUP_LIST_TRACKING;
    onLBSelChanged = QUOTE(_this call FUNC(sm_trackGroup));
    BUTTON_4(EDSEC_X1,2.5,EDSEC_X3,3.25);
};

class groups_text_trackingmodeUnits : groups_text_nameEdit {
    idc = IDC_GROUP_TEXT_TRACKINGMODEUNITS;
    text = "Units";
    BUTTON_4(EDSEC_X1,3.5,EDSEC_X3,4);
};

class groups_list_trackingModeUnits : GVARMAIN(RscDropdownMenu) {
    idc = IDC_GROUP_LIST_TRACKINGUNITS;
    onLBSelChanged = QUOTE(_this call FUNC(sm_trackUnits));
    BUTTON_4(EDSEC_X1,4,EDSEC_X3,4.75);
};

class groups_text_colour : groups_text_nameEdit {
    idc = IDC_GROUP_TEXT_COLOUR;
    text = "Group Colour";
    BUTTON_4(EDSEC_X1,6,EDSEC_X3,6.5);
};
class main_slider_R : GVARMAIN(RscSlider) {
    idc = IDC_GROUP_SLIDER_R;
    color[] = {1,0,0,1};
    colorActive[] = {1,0,0,1};
    colorDisabled[] = {1,0,0,1};
    onSliderPosChanged = QUOTE(_this + [0] call FUNC(sliderColChanged));
    BUTTON_4(EDSEC_X1,7,EDSEC_X3,7.32);
};
class main_slider_G : main_slider_R {
    idc = IDC_GROUP_SLIDER_G;
    color[] = {0,1,0,1};
    colorActive[] = {0,1,0,1};
    colorDisabled[] = {0,1,0,1};
    onSliderPosChanged = QUOTE(_this + [1] call FUNC(sliderColChanged));
    BUTTON_4(EDSEC_X1,7.33,EDSEC_X3,7.65);
};
class main_slider_B : main_slider_R {
    idc = IDC_GROUP_SLIDER_B;
    color[] = {0,0,1,1};
    colorActive[] = {0,0,1,1};
    colorDisabled[] = {0,0,1,1};
    onSliderPosChanged = QUOTE(_this + [2] call FUNC(sliderColChanged));
    BUTTON_4(EDSEC_X1,7.66,EDSEC_X3,8);
};
