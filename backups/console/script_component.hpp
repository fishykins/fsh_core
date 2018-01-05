#define COMPONENT console

#include "\x\fsh_core\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define RECOMPILE recompile = 1

#include "\x\fsh_core\addons\main\script_macros.hpp"


#define IDC_MAIN             2569
#define IDC_MAIN_HEADER      2570
#define IDC_MAIN_FUNCSELECT  2571
#define IDC_MAIN_MAP         2572
#define IDC_MAIN_LIST_TRACK  2573
#define IDC_AI_LIST_MAIN     2574
#define IDC_AI_LIST_FUNCS    2575
#define IDC_AI_LIST_VARS     2576
#define IDC_AI_LIST_WAYPTS   2577
#define IDC_AI_LIST_LOGS     2578
#define IDC_AI_TEXT_LOGS     2579
#define IDC_AI_EDIT_FUNCS    2580
#define IDC_AI_FUNCSELECT    2581
#define IDC_AI_BUTTON_1      2582
#define IDC_AI_BUTTON_2      2583
#define IDC_AI_BUTTON_3      2584
#define IDC_AI_BUTTON_4      2585
#define IDC_AI_BUTTON_5      2586
#define IDC_AI_BUTTON_6      2587
#define IDC_AI_BUTTON_7      2588
#define IDC_AI_BUTTON_8      2589
#define IDC_AI_LIST_TRACK    2590
#define IDC_AI_LIST_COLS     2591
#define IDC_AI_SLIDER_R      2592
#define IDC_AI_SLIDER_G      2593
#define IDC_AI_SLIDER_B      2594
#define IDC_AI_SLIDER_A      2595
#define IDC_AI_LIST_ACC      2596

#define IDC_MIA_LIST_MAIN    2610
#define IDC_MIA_FUNCSELECT   2611
#define IDC_MIA_             2612
//#define IDC_MIA_


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
#define MAX_TRACK_GROUPS 20
#define MAX_TRACK_OBJECTS 30

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

#define UI_VARIABLES \
    private _ui_mia_list_main = _ui DisplayCtrl IDC_MIA_LIST_MAIN; \
    private _ui_ai_list_main = _ui DisplayCtrl IDC_AI_LIST_MAIN; \
    private _ui_ai_list_logs = _ui DisplayCtrl IDC_AI_LIST_LOGS; \
    private _ui_ai_list_funcs = _ui DisplayCtrl IDC_AI_LIST_FUNCS; \
    private _ui_ai_list_vars = _ui DisplayCtrl IDC_AI_LIST_VARS; \
    private _ui_ai_list_waypts = _ui DisplayCtrl IDC_AI_LIST_WAYPTS; \
    private _ui_ai_list_track = _ui DisplayCtrl IDC_AI_LIST_TRACK; \
    private _ui_ai_list_cols = _ui DisplayCtrl IDC_AI_LIST_COLS; \
    private _ui_ai_funcSelect = _ui DisplayCtrl IDC_AI_FUNCSELECT; \
    private _ui_ai_text_logs = _ui DisplayCtrl IDC_AI_TEXT_LOGS; \
    private _ui_ai_slider_R = _ui DisplayCtrl IDC_AI_SLIDER_R; \
    private _ui_ai_slider_G = _ui DisplayCtrl IDC_AI_SLIDER_G; \
    private _ui_ai_slider_B = _ui DisplayCtrl IDC_AI_SLIDER_B; \
    private _ui_ai_slider_A = _ui DisplayCtrl IDC_AI_SLIDER_A; \
    private _ui_main_funcSelect = _ui DisplayCtrl IDC_MAIN_FUNCSELECT; \
    private _ui_main_list_track = _ui DisplayCtrl IDC_MAIN_LIST_TRACK; \
    private _ui_main_map = _ui DisplayCtrl IDC_MAIN_MAP
