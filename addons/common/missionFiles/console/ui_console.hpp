#include "\x\fsh_core\addons\ui\script_RscDialog.hpp"
//#include "\x\fsh_core\addons\ui\script_RscClasses.hpp" <----- ENABLE WHEN IN MOD!

class GVAR(debugConsole) {
	idd = IDC_MAIN;
	movingEnable = false;
	enableSimulation = true;
	objects[] = { };
	onLoad = QUOTE([ARR_1(_this)] call FUNC(consoleInit));
	onUnLoad = QUOTE([ARR_1(_this)] call FUNC(consoleExit));
	class controlsBackground {
		class headerBackground : GVARMAIN(RscText) {
			colorBackground[] = COL_PROFILE;
			sizeEx = 0.032;
			text = "";
			idc = -1;
			moving = false;
			UIPOS(CONSOLE_X1,CONSOLE_HEADER_Y,CONSOLE_X3,CONSOLE_Y1);
		};
		class background : GVARMAIN(RscText) {
			colorBackground[] = {0, 0, 0, 0.7};
			idc = -1;
			UIPOS(CONSOLE_X1,CONSOLE_Y1,CONSOLE_X3,CONSOLE_Y3);
		};
        /*
        class blBox : GVARMAIN(RscText) {
            idc = -1;
            colorBackground[] = {0, 0, 0, 0.2};
            UIPOS(LIST_X2,LIST_Y2,CONSOLE_X2,CONSOLE_Y2);
        };*/
	};

	class controls {
		class header : GVARMAIN(RscText) {
			idc = IDC_MAIN_HEADER;
			colorBackground[] = COL_NONE;
			sizeEx = 0.032;
			text = "Debug console";
			moving = falses;
			UIPOS(CONSOLE_X1,CONSOLE_HEADER_Y,CONSOLE_X3,CONSOLE_Y1);
		};

        class functionSelect : GVARMAIN(RscXListBox) {
            idc = IDC_MAIN_FUNCSELECT;
            onLBSelChanged = QUOTE(_this call FUNC(functionChanged));
            UIPOS(CONSOLE_X1,CONSOLE_Y1,CONSOLE_X2,LIST_Y1);
        };

        class map : GVARMAIN(RscMapControl) {
            idc = IDC_MAIN_MAP;
            onMouseButtonDown = QUOTE(_this call FUNC(mapClicked));
            maxSatelliteAlpha = 0; //0.85;
        	alphaFadeStartScale = 0; //0.35;
        	alphaFadeEndScale = 0; //0.4;
            MAP_TALL;
        };

        class main_list_track_groups : GVARMAIN(RscDropdownMenu) {
            idc = IDC_MAIN_LIST_TRACK_GROUPS;
            onLBSelChanged = QUOTE(_this call FUNC(groupTracking));
            HEADER(0.9,1);
        };
        class main_list_track_groups_header : GVARMAIN(RscText) {
			idc = -1;
			colorBackground[] = COL_NONE;
			sizeEx = 0.032;
			text = "Group Tracking";
			HEADER_T(0.9,1);
		};
        class main_list_track_units : main_list_track_groups {
            idc = IDC_MAIN_LIST_TRACK_UNITS;
            onLBSelChanged = QUOTE(_this call FUNC(unitTracking));
            HEADER(0.8,0.9);
        };
        class main_list_track_units_header : main_list_track_groups_header {
			text = "Unit Tracking";
			HEADER_T(0.8,0.9);
		};
        class main_list_track_players : main_list_track_groups {
            idc = IDC_MAIN_LIST_TRACK_PLAYERS;
            onLBSelChanged = QUOTE(_this call FUNC(playerTracking));
            HEADER(0.7,0.8);
        };
        class main_list_track_players_header : main_list_track_groups_header {
			text = "Player Tracking";
			HEADER_T(0.7,0.8);
		};

        class map_colours : GVARMAIN(RscDropdownMenu) {
            idc = IDC_AI_LIST_COLS;
            onLBSelChanged = QUOTE(_this call FUNC(setColours));
            HEADER(0.55,0.65);
        };
        class map_colours_header : main_list_track_groups_header {
			text = "Colour Scheme";
			HEADER_T(0.55,0.65);
		};


        class main_list_left : GVARMAIN(RscTree) {
            idc = IDC_MAIN_LIST_LEFT;
            onTreeSelChanged = QUOTE(_this call FUNC(TreeSelChanged));
            colorBackground[] = COL_VAR(0.7);
            LIST;
        };


        #include "ui_groups.hpp"


        /*
        //====================== MIA ============================//
        class mia_list_main : GVARMAIN(RscTree) {
            idc = IDC_MIA_LIST_MAIN;
            onTreeSelChanged = QUOTE(_this call FUNC(miaListChanged));
            colorBackground[] = COL_VAR(0.7);
            LIST;
        };

        //====================== AI ============================//
        class ai_list_main : GVARMAIN(RscTree) {
            idc = IDC_AI_LIST_MAIN;
            onTreeSelChanged = QUOTE(_this call FUNC(aiChanged));
            colorBackground[] = COL_VAR(0.7);
            LIST;
        };

        class ai_funcSelect : GVARMAIN(RscXListBox) {
            idc = IDC_AI_FUNCSELECT;
            onLBSelChanged = QUOTE(_this call FUNC(subFunctionChanged));
            UIPOS(LIST_X2,LIST_Y2,LIST_X3,LIST_Y3);
        };

        class ai_list_logs : GVARMAIN(RscListBox) {
            idc = IDC_AI_LIST_LOGS;
            onLBSelChanged = QUOTE(_this call FUNC(logChanged));
            UIPOS(LIST_X2,LIST_Y3,LIST_X3,CONSOLE_Y2);
        };

        class ai_list_funcs : ai_list_logs {
            idc = IDC_AI_LIST_FUNCS;
            onLBSelChanged = QUOTE(_this call FUNC(functionListChanged));
        };

        class ai_list_waypts : ai_list_logs {
            idc = IDC_AI_LIST_WAYPTS;
            onLBSelChanged = QUOTE(_this call FUNC(wptListChanged));
        };

        class ai_list_vars : ai_list_logs {
            idc = IDC_AI_LIST_VARS;
            onLBSelChanged = QUOTE(_this call FUNC(varsListChanged));
        };

        class ai_text_logs : GVARMAIN(RscStructuredText) {
            idc = IDC_AI_TEXT_LOGS;
            colorBackground[] = COL_NONE;
            text = "";
            UIPOS(LIST_X3,LIST_Y2,CONSOLE_X2,CONSOLE_Y2);
        };
        class ai_edit: GVARMAIN(RscEdit) {
            idc = IDC_AI_EDIT_FUNCS;
			colorBackground[] = COL_VAR_2(0.2,0.5);
            colorText[] = COL_WHITE;
            colorDisabled[] = COL_AWHITE(1);
            colorSelection[] = COL_AWHITE(1);
			sizeEx = 0.025;
			text = "string";
			onKeyDown = QUOTE(_this call GVAR(aiDebugConsoleTextBox));
            BUTTON_4(0,0,3,1)
		};
        class ai_tracking : GVARMAIN(RscDropdownMenu) {
            idc = IDC_AI_LIST_TRACK;
            onLBSelChanged = QUOTE(_this call FUNC(aiTrackingMarkers));
            BUTTON_4(1,1,3,2);
        };
        class ai_slider_R : GVARMAIN(RscSlider) {
            idc = IDC_AI_SLIDER_R;
            color[] = {1,0,0,1};
            colorActive[] = {1,0,0,1};
            colorDisabled[] = {1,0,0,1};
            BUTTON_4(1,2,3,2.24);
            onSliderPosChanged = QUOTE(_this + [0] call FUNC(sliderColChanged));
        };
        class ai_slider_G : ai_slider_R {
            idc = IDC_AI_SLIDER_G;
            color[] = {0,1,0,1};
            colorActive[] = {0,1,0,1};
            colorDisabled[] = {0,1,0,1};
            BUTTON_4(1,2.25,3,2.49);
            onSliderPosChanged = QUOTE(_this + [1] call FUNC(sliderColChanged));
        };
        class ai_slider_B : ai_slider_R {
            idc = IDC_AI_SLIDER_B;
            color[] = {0,0,1,1};
            colorActive[] = {0,0,1,1};
            colorDisabled[] = {0,0,1,1};
            BUTTON_4(1,2.5,3,2.74);
            onSliderPosChanged = QUOTE(_this + [2] call FUNC(sliderColChanged));
        };
        class ai_slider_A : ai_slider_R {
            idc = IDC_AI_SLIDER_A;
            color[] = COL_WHITE;
            colorActive[] = COL_WHITE;
            colorDisabled[] = COL_WHITE;
            BUTTON_4(1,2.75,3,3);
            onSliderPosChanged = QUOTE(_this + [3] call FUNC(sliderColChanged));
        };

        class ai_button_1 : GVARMAIN(RscButtonMenu) {
            idc = IDC_AI_BUTTON_1;
            colorBackground[] = COL_ABLACK(0.7);
            text = "Execute";
            onButtonClick = QUOTE(call FUNC(executeCommand));
            BUTTON(0,7);
        };
        class ai_button_2 : ai_button_1 {
            idc = IDC_AI_BUTTON_2;
            text = "Rename";
            BUTTON(0,1);
        };
        class ai_button_3 : ai_button_1 {
            idc = IDC_AI_BUTTON_3;
            text = "Default";
            BUTTON(0,2);
            onButtonClick = QUOTE(call FUNC(resetColour));
        };*/
	};
};
