#include "\x\fsh_core\addons\ui\script_RscDialog.hpp"
#include "\x\fsh_core\addons\ui\script_RscClasses.hpp"

#define CONSOLE_X 0
#define CONSOLE_Y 0
#define CONSOLE_W 1
#define CONSOLE_H 1


#define LIST_W CONSOLE_W/3
#define LIST 					x = CONSOLE_X;		y = CONSOLE_Y; 	w = LIST_W; h = CONSOLE_H

#define DATA_X  (CONSOLE_X + LIST_W)
#define DATA_W  (CONSOLE_W - (DATA_X))

#define BUTTON_H CONSOLE_W/24
#define BUTTON_W (DATA_W/5)

#define MAP_W

#define FUNCTION_Y ((CONSOLE_H/2) - BUTTON_H)

class GVAR(aiDebugConsole) {
	idd = AIDC; // set to -1, because we don't require a unique ID
	movingEnable = true; // the dialog can be moved with the mouse (see "moving" below)
	enableSimulation = true; // freeze the game
	objects[] = { }; // no objects needed
	onLoad = QUOTE([ARR_1(_this)] call GVAR(aiDebugConsoleInit));
	onUnLoad = QUOTE([ARR_1(_this)] call GVAR(aiDebugConsoleExit));
	class controlsBackground {
		class background_topbar : GVARMAIN(RscText) {
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
			sizeEx = 0.032;
			text = "";
			idc = -1;
			moving = true;
			x = CONSOLE_X;
			y = CONSOLE_Y-BUTTON_H;
			w = CONSOLE_W;
			h = BUTTON_H;
		};
		class background_main : GVARMAIN(RscText) {
			colorBackground[] = {0, 0, 0, 0.7};
			idc = -1;
			x = CONSOLE_X;
			y = CONSOLE_Y;
			w = CONSOLE_W;
			h = CONSOLE_H;
		};
	};

	class controls {
		class title : GVARMAIN(RscText) {
			idc = AIDC_TITLE;
			//colorBackground[] = {0, 0,0, 0};
			sizeEx = 0.032;
			text = "Debug console";
			moving = true;
			x = CONSOLE_X + (BUTTON_W);
			y = CONSOLE_Y - BUTTON_H;
			w = CONSOLE_W - (2*BUTTON_W);
			h = BUTTON_H;
		};
        class list : GVARMAIN(RscListBox) {
			idc = AIDC_LIST;
			text = "";
			sizeEx = 0.028;
			onLBSelChanged = QUOTE(_this call GVAR(aiDebugConsoleList));
			LIST;
		};
        ///////////////////////////////////////////////////////////
        class data_title : GVARMAIN(RscText) {
			idc = AIDC_DATA_TITLE;
			//colorBackground[] = {0, 0,0, 0};
			sizeEx = 0.032;
			text = "debug message";
			moving = false;
			x = DATA_X;
			y = CONSOLE_Y;
			w = DATA_W;
			h = BUTTON_H;
		};
        class data_time : data_title {
			idc = AIDC_DATA_TIME;
			sizeEx = 0.032;
			text = "Time Logged: goon o'clock";
			y = CONSOLE_Y + (1*BUTTON_H);
			h = BUTTON_H;
		};
        class data_entry : data_title {
			idc = AIDC_DATA_ENTRY;
			sizeEx = 0.032;
			text = "Debug message";
			y = CONSOLE_Y + (2*BUTTON_H);
			h = (CONSOLE_H/2) - (2*BUTTON_H);
		};
        class data_map: GVARMAIN(RscMapControl) {
            idc = AIDC_MAP;
            onMouseButtonDown = QUOTE(_this call GVAR(aiDebugConsoleMap));
            x = DATA_X;
            w = DATA_W;
            y = CONSOLE_H/2;
            h = CONSOLE_H/2;
		};
        ///////////////////////////////////////////////////////////
        class functions_trackingMenu: GVARMAIN(RscDropdownMenu) {
            idc = AIDC_FUNC_TRACKING;
            text = "tracking";
            onLBSelChanged = QUOTE(_this call GVAR(aiDebugConsoleTracking));
            x = DATA_X;
            w = BUTTON_W*1.5;
            y = FUNCTION_Y;
            h = BUTTON_H;
		};
        class functions_commandMenu: GVARMAIN(RscDropdownMenu) {
            idc = AIDC_FUNC_COMMANDS;
			text = "do action";
			onLBSelChanged = QUOTE(_this call GVAR(aiDebugConsoleChangeCommand));
            x = DATA_X + (1.5*BUTTON_W);
            w = BUTTON_W;
            y = FUNCTION_Y;
            h = BUTTON_H;
		};
        class functions_doCommand: GVARMAIN(RscButtonMenu) {
            idc = -1;
			colorBackground[] = {1, 1, 1, 0.9};
			sizeEx = 0.55;
			text = "do action";
			onButtonClick = QUOTE(_this call GVAR(aiDebugConsoleDoCommand));
            x = DATA_X + (2.5*BUTTON_W);
            w = BUTTON_W;
            y = FUNCTION_Y;
            h = BUTTON_H;
		};
        class functions_textBox: GVARMAIN(RscEdit) {
            idc = AIDC_FUNC_TEXT;
			colorBackground[] = {1, 1, 1, 0.9};
			sizeEx = 0.025;
			text = "name";
			onKeyDown = QUOTE(_this call GVAR(aiDebugConsoleTextBox));
            x = DATA_X + (3.5*BUTTON_W);
            w = BUTTON_W*1.5;
            y = FUNCTION_Y;
            h = BUTTON_H;
		};
	};
};
