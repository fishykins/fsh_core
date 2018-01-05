#define COMPONENT console

#include "\x\fsh_core\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define RECOMPILE recompile = 1

#include "\x\fsh_core\addons\main\script_macros.hpp"

//================================================================================//
//============================== CONSOLE POSITIONS ===============================//
//================================================================================//

#define CONSOLE_OFFSET_W (safeZoneWAbs * 0.05)
#define CONSOLE_OFFSET_H (safeZoneH * 0.05)
#define TAB_HEIGHT (0.05)
#define HEADER_H (0.08)

#define CONSOLE_W (safeZoneWAbs - (2*CONSOLE_OFFSET_W))
#define CONSOLE_H (safeZoneH - HEADER_H - (2*CONSOLE_OFFSET_H))
#define CONSOLE_X1 (safeZoneXAbs + CONSOLE_OFFSET_W)
#define CONSOLE_X2 (CONSOLE_X1 + (0.2*CONSOLE_W))
#define CONSOLE_X3 (CONSOLE_X1 + CONSOLE_W)
#define CONSOLE_Y1 (safeZoneY + CONSOLE_OFFSET_H + HEADER_H)
#define CONSOLE_Y2 (CONSOLE_Y1 + (0.66*CONSOLE_H))
#define CONSOLE_Y3 (CONSOLE_Y1 + CONSOLE_H)

#define HEADER_TAB_W 0.25
#define CONSOLE_HEADER_Y (CONSOLE_Y1 - HEADER_H)
#define CONSOLE_HEADER_Y1 (CONSOLE_HEADER_Y + (HEADER_H*0.33))
#define CONSOLE_HEADER_Y2 (CONSOLE_HEADER_Y + (HEADER_H*0.66))

#define HEADER(_var1,_var2) UIPOS((CONSOLE_X1 + (CONSOLE_W * _var1)),CONSOLE_HEADER_Y2,(CONSOLE_X1 + (CONSOLE_W * _var2)),CONSOLE_Y1)
#define HEADER_T(_var1,_var2) UIPOS((CONSOLE_X1 + (CONSOLE_W * _var1)),CONSOLE_HEADER_Y,(CONSOLE_X1 + (CONSOLE_W * _var2)),CONSOLE_HEADER_Y2)

#define LIST_Y1       (CONSOLE_Y1 + TAB_HEIGHT)
#define LIST          UIPOS(CONSOLE_X1,LIST_Y1,CONSOLE_X2,CONSOLE_Y3)

#define MAP_X           (CONSOLE_X2)
#define MAP_Y           (CONSOLE_Y1)
#define MAP_W           (CONSOLE_X3 - CONSOLE_X2)
#define MAP_H1          (CONSOLE_Y2 - CONSOLE_Y1)
#define MAP_H2          (CONSOLE_Y3 - CONSOLE_Y1)

#define MAP_SHORT     UIPOS(CONSOLE_X2,CONSOLE_Y1,CONSOLE_X3,CONSOLE_Y2)
#define MAP_TALL      UIPOS(CONSOLE_X2,CONSOLE_Y1,CONSOLE_X3,CONSOLE_Y3)

#define BUTTON_X1 (CONSOLE_X2)
#define BUTTON_X2 (CONSOLE_X3)
#define BUTTON_Y1 (CONSOLE_Y2)
#define BUTTON_Y2 (CONSOLE_Y3)
#define BUTTON_COUNT_W 12
#define BUTTON_COUNT_H 9
#define BUTTON_W ((BUTTON_X2 - BUTTON_X1)/BUTTON_COUNT_W)
#define BUTTON_H ((BUTTON_Y2 - BUTTON_Y1)/BUTTON_COUNT_H)
#define BUTTON_X(_var1)  (BUTTON_X1 + (_var1 * BUTTON_W))
#define BUTTON_Y(_var1)  (BUTTON_Y1 + (_var1 * BUTTON_H))

#define BUTTON_4(_var1,_var2,_var3,_var4)     UIPOS( (BUTTON_X(_var1)), (BUTTON_Y(_var2)), (BUTTON_X(_var3)), (BUTTON_Y(_var4)) )
#define BUTTON(_var1,_var2)     BUTTON_4(_var1,_var2,(_var1+1),(_var2+1))

//================================================================================//
//==================================== IDC =======================================//
//================================================================================//

//-------------MAIN--------------//
//Range: 2560 - 2580

#define IDC_MAIN             2560
#define IDC_MAIN_HEADER      2561
#define IDC_MAIN_FUNCSELECT  2562
#define IDC_MAIN_MAP         2563
#define IDC_MAIN_LIST_LEFT   2564
#define IDC_MAIN_LIST_TRACK_GROUPS  2565
#define IDC_MAIN_LIST_TRACK_UNITS  2566
#define IDC_MAIN_LIST_TRACK_PLAYERS  2567

//-------------GROUP--------------//
//Range: 2581 - 2620

#define IDC_GROUP_TEXT_HEADER   2581
#define IDC_GROUP_TEXT_LOG      2582
#define IDC_GROUP_TEXT_LOGTIME  2583
#define IDC_GROUP_TEXT_LOGTITLE  2584
#define IDC_GROUP_LIST_LOGS     2585
#define IDC_GROUP_LIST_WAYPOINTS 2586
#define IDC_GROUP_LIST_ACTIONS 2587
#define IDC_GROUP_SLIDER_R 2588
#define IDC_GROUP_SLIDER_G 2589
#define IDC_GROUP_SLIDER_B 2590
#define IDC_GROUP_EDIT_NAME 2591
#define IDC_GROUP_BUTTON_NAME 2592
#define IDC_GROUP_LIST_TRACKING 2593
#define IDC_GROUP_TEXT_NAMEEDIT 2594
#define IDC_GROUP_TEXT_COLOUR 2595
#define IDC_GROUP_TEXT_TRACKINGMODE 2596
#define IDC_GROUP_TEXT_TRACKINGMODEUNITS 2597
#define IDC_GROUP_LIST_TRACKINGUNITS 2598

//================================================================================//
//================================================================================//

#define MAP_SPEED 0.2
#define MAP_ZOOM 0.05
#define COL_ABLUE(_var1) [0,0.2,0.8,_var1]
#define COL_BLUE COL_ABLUE(1)
#define ICON_SIZE_GROUPS 4
#define ICON_SIZE_GROUPS_C 40
#define TEXT_SIZE_C 0.1
#define TEXT_SIZE_L 0.01
#define TEXT_SIZE_S 0.001

#define TRACKING_LEVEL_NAME 2
#define TRACKING_LEVEL_UNITS 3
#define TRACKING_LEVEL_UNITS_NAMES 4
#define TRACKING_LEVEL_WAYPOINTS 5

/*-----------------------------------------------------------------
MAX_TRACK_GROUPS defines the number of groups we can monitor
at a time. This limmit is enforced by fnc_track- if "trackedGroups"
is messed with this will not prevent stupid numbers of draws happening
------------------------------------------------------------------*/
#define MAX_TRACK_GROUPS 30
#define MAX_TRACK_OBJECTS 150

/*-----------------------------------------------------------------
INDEX IDS for TRACKING ARRAYS
------------------------------------------------------------------*/
#define TRACK_I_NAME 0
#define TRACK_I_LVL 1
#define TRACK_I_MRK 2
#define TRACK_I_TXT 3
#define TRACK_I_COL 4
#define TRACK_I_UNITS_DRAW 5
#define TRACK_I_UNITS 6

#define DEFAULT_ENABLED true
#define DEFAULT_TRACKINGLEVEL 3
#define DEFAULT_COLOURMODE 1

#define COMPILE_UI disableSerialization; \
    private _ui = uiNamespace getVariable [QGVAR(console), -1]; \
    UI_VARIABLES

#define UI_MAIN_VARIABLES \
    private _ui_main_list_track_groups = _ui DisplayCtrl IDC_MAIN_LIST_TRACK_GROUPS; \
    private _ui_main_list_track_units = _ui DisplayCtrl IDC_MAIN_LIST_TRACK_UNITS; \
    private _ui_main_list_track_players = _ui DisplayCtrl IDC_MAIN_LIST_TRACK_PLAYERS; \
    private _ui_main_funcSelect = _ui DisplayCtrl IDC_MAIN_FUNCSELECT; \
    private _ui_main_list_track = _ui DisplayCtrl IDC_MAIN_LIST_TRACK; \
    private _ui_main_list_left = _ui DisplayCtrl IDC_MAIN_LIST_LEFT; \
    private _ui_main_map = _ui DisplayCtrl IDC_MAIN_MAP

#define UI_GROUP_VARIABLES \
    private _ui_group_text_header = _ui DisplayCtrl IDC_GROUP_TEXT_HEADER; \
    private _ui_group_text_log = _ui DisplayCtrl IDC_GROUP_TEXT_LOG; \
    private _ui_group_text_logtitle = _ui DisplayCtrl IDC_GROUP_TEXT_LOGTITLE; \
    private _ui_group_text_logTime = _ui DisplayCtrl IDC_GROUP_TEXT_LOGTIME; \
    private _ui_group_list_tracking = _ui DisplayCtrl IDC_GROUP_LIST_TRACKING; \
    private _ui_group_list_trackingUnits = _ui DisplayCtrl IDC_GROUP_LIST_TRACKINGUNITS; \
    private _ui_group_list_logs = _ui DisplayCtrl IDC_GROUP_LIST_LOGS; \
    private _ui_group_slider_r = _ui DisplayCtrl IDC_GROUP_SLIDER_R; \
    private _ui_group_slider_g = _ui DisplayCtrl IDC_GROUP_SLIDER_G; \
    private _ui_group_slider_b = _ui DisplayCtrl IDC_GROUP_SLIDER_B

#define UI_VARIABLES \
    UI_MAIN_VARIABLES; \
    UI_GROUP_VARIABLES
