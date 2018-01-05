#include "\x\fsh_core\addons\ui\script_RscDialog.hpp"
#include "\x\fsh_core\addons\ui\script_RscClasses.hpp"
//====================================================================================//
//====================================================================================//

#define UI_SIZE 0.7

//====================================================================================//
//====================================================================================//

#define SCREEN_X1      (0.35 * UI_SIZE)
#define SCREEN_X2      (1 - SCREEN_X1)
#define SCREEN_Y1      (0.2 * UI_SIZE)
#define SCREEN_Y2      (1 - SCREEN_Y1)

#define SCREEN_XMID     (SCREEN_X1 + ((SCREEN_X2-SCREEN_X1)*0.5))
#define SCREEN_YMID     (SCREEN_Y1 + ((SCREEN_Y2-SCREEN_Y1)*0.2))

//====================================================================================//
//====================================================================================//

class GVAR(RscArsenal) {
	idd = UI_FPOD;
	movingEnable = true;
	enableSimulation = true;
	objects[] = {};
	onLoad = QUOTE(_this call FUNC(init));
	onUnLoad = QUOTE(_this call FUNC(exit));

	class controlsBackground  {
        class background : GVARMAIN(RscText) {
            idc = -1;
            colorBackground[] = COL_ABLACK(0.7);
            text = "";
            UIPOS(SCREEN_X1,SCREEN_Y1,SCREEN_X2,SCREEN_Y2);
        };
	};
	class controls {
        class headerLeft : GVARMAIN(RscText) {
            idc = -1;
            font = "EtelkaNarrowMediumPro";
            sizeEx = 0.053;
            colorBackground[] = COL_ABLACK(0.3);
            colorText[] = COL_WHITE;
            style = ST_CENTER;
            text = "Inactive";
            UIPOS(SCREEN_X1,SCREEN_Y1,SCREEN_XMID,SCREEN_YMID);
        };

        class headerRight : headerLeft {
            idc = -1;
            text = "Active";
            UIPOS(SCREEN_XMID,SCREEN_Y1,SCREEN_X2,SCREEN_YMID);
        };
        //============================= LISTS =======================================//
        class listLeft : GVARMAIN(RscListBox) {
			idc = IDC_LIST_LEFT;
            style = ST_LEFT;
			text = "";
			sizeEx = 0.042;
            rowHeight=0.07;
            font = FONT_LARGE;
			onLBSelChanged = QUOTE(_this call FUNC(listLeft));
			UIPOS(SCREEN_X1,SCREEN_YMID,SCREEN_XMID,SCREEN_Y2);
		};
        class listRight : listLeft {
			idc = IDC_LIST_RIGHT;
            style = ST_LEFT;
			onLBSelChanged = QUOTE(_this call FUNC(listRight));
			UIPOS(SCREEN_XMID,SCREEN_YMID,SCREEN_X2,SCREEN_Y2);
		};
	};
};
