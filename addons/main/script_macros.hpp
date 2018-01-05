#include "\x\cba\addons\main\script_macros.hpp"
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define QFVAR(var1,var2)                format ["fvar_%1%2", var1, QUOTE(var2)]
#define PUSH_FVAR(var1,var2)            missionNameSpace setVariable [QFVAR(var1,var2), var2, false]
#define PULL_FVAR(var1,var2,var3)       var2 = missionNameSpace getVariable [QFVAR(var1,var2), var3]
#define GET_FVAR(var1,var2,var3)        missionNameSpace getVariable [QFVAR(var1,var2), var3]

#define QPGVAR(var1)  QEGVAR(var1,_uid)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define QNS(var1,var2)     format["%1_%2",var1,var2]

#define FACTION_GNS(var1,var2,var3)      factionNamespace getVariable [QNS(var1,var2), var3]
#define FACTION_SNS(var1,var2,var3)      factionNamespace setVariable [QNS(var1,var2), var3]

#define VEHICLE_GNS(var1,var2,var3)      vehiclesNamespace getVariable [QNS(var1,var2), var3]
#define VEHICLE_SNS(var1,var2,var3)      vehiclesNamespace setVariable [QNS(var1,var2), var3]

#define WEAPON_GNS(var1,var2,var3)      vehiclesNamespace getVariable [QNS(var1,var2), var3]
#define WEAPON_SNS(var1,var2,var3)      vehiclesNamespace setVariable [QNS(var1,var2), var3]

#define GROUP_GNS(var1,var2,var3)        groupNamespace getVariable [QNS(var1,var2), var3]
#define GROUP_SNS(var1,var2,var3)        groupNamespace setVariable [QNS(var1,var2), var3]

#define SPAWN_GNS(var1,var2,var3)        vehiclesNamespace getVariable [QNS(var1,var2), var3]
#define SPAWN_SNS(var1,var2,var3)        vehiclesNamespace setVariable [QNS(var1,var2), var3]

#define FSH_GNS(var1,var2,var3)         GVAR(namespace) getVariable [QNS(var1,var2), var3]
#define FSH_SNS(var1,var2,var3)         GVAR(namespace) setVariable [QNS(var1,var2), var3]

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define SPAWN_MIA(_var1)                private _mia = [false] call CBA_fnc_createNamespace; _mia setName _var1
#define GET_MIA(_var1)                  _mia = [_var1] call fsh_fnc_getMia
#define MIA_G(_var1,_var2)              (_mia getVariable [_var1, _var2])
#define MIA_S(_var1,_var2)              _mia setVariable [_var1, _var2]
#define MIA_PB(_var1,_var2)             private _temp = MIA_G(_var1,[]); _temp pushBack _var2; MIA_S(_var1,_temp)
#define MIA_PBU(_var1,_var2)            private _temp = MIA_G(_var1,[]); _temp pushBackUnique _var2; MIA_S(_var1,_temp)
#define MIA_OBJ_S(_var1,_var2,_var3)          _var1 setVariable [format["%1_%2", MIA_N, _var2], _var3]
#define MIA_OBJ_G(_var1,_var2,_var3)          _var1 getVariable [format["%1_%2", MIA_N, _var2], _var3]
#define MIA_N                           (MIA_G("name","noNameFound"))

//creates a unique var name for mia
#define MIA_VAR(var1)                   format ["fsh_mia_%1_%2", MIA_N, var1]

#define MIA_STR(_str)                   format ["%1: %2", MIA_N, _str]
#define MIA_LOG(_str)                   diag_log MIA_STR(_str)
#define MIA_LOG_1(_str,_var1)           private _strTemp = MIA_STR(_str); diag_log format [_strTemp, _var1]
#define MIA_LOG_2(_str,_var1,_var2)     private _strTemp = MIA_STR(_str); diag_log format [_strTemp, _var1,_var2]
#define MIA_LOG_3(_str,_var1,_var2,_var3)     private _strTemp = MIA_STR(_str); diag_log format [_strTemp, _var1,_var2,_var3]

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TIME_MARKER(var1)               var1 = diag_ticktime;
#define RUN_TIME(var1)                  diag_ticktime - var1


/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define WATER_DEPTH(_var1)  ((AGLToASL ([_var1] call cba_fnc_getPos)) select 2)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define SWITCH_POS_ATL(_var1,_var2) \
    switch (typeName _var1) do { \
        case ("STRING"): {_var1 = getMarkerPos _var1; _var1 set [2,0];}; \
        case ("OBJECT"): {_var1 = getPosATL _var1;}; \
        case ("ARRAY"): {if (count _var1 < 3) then {_var1 set [2,0]};}; \
        default {_var1 = _var2}; \
    }

#define SWITCH_SIDE(_var1,_var2) \
    if (!(IS_SIDE(_var1))) then { \
        switch (_var1) do { \
            case (0); case (east); case ("EAST"); case ("OPFOR"): {_var1 = east}; \
            case (1); case (west); case ("WEST"); case ("BLUFOR"): {_var1 = west}; \
            case (2); case (resistance); case ("INDI"); case ("GUER"): {_var1 = resistance}; \
            default {_var1 = _var2}; \
        }; \
    }

#define SWITCH_SIDE_INT(_var1,_var2) \
    if (!(IS_NUMBER(_var1))) then { \
        switch (_var1) do { \
            case (0); case (east); case ("EAST"); case ("OPFOR"): {_var1 = 0}; \
            case (1); case (west); case ("WEST"); case ("BLUFOR"): {_var1 = 1}; \
            case (2); case (resistance); case ("INDI"); case ("GUER"): {_var1 = 2}; \
            default {_var1 = _var2}; \
        }; \
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define X(A)							[A,0,-1,[0]] call BIS_fnc_param
#define Y(A)							[A,1,-1,[0]] call BIS_fnc_param
#define Z(A)							[A,2,-1,[0]] call BIS_fnc_param
#define DIST_X(A,B) 					abs ((A select 0) - (B select 0))
#define DIST_Y(A,B) 					abs ((A select 1) - (B select 1))
#define DIST_M(A,B) 					(abs ((A select 0) - (B select 0))) + (abs ((A select 1) - (B select 1)))
#define PASS_PARAM(_par,_arr)			if (_par in _arr) then {true} else {false}
#define PASS_PARAM_I(_parStr,_parArr)	if (_parStr in _parArr) then {false} else {true}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define SIDE_ALPHA 0.8
#define COL_WEST [0,0.3,0.7, SIDE_ALPHA]
#define COL_EAST [1,0,0, SIDE_ALPHA]
#define COL_GUER [0,0.7,0.3, SIDE_ALPHA]
#define COL_CIV [0.5,0,0.5, SIDE_ALPHA]
#define COL_SELECTED [1,1,0,1]

#define MAP_SPEED 0.2
#define MAP_ZOOM 0.05
#define COL_ABLUE(_var1) [0,0.2,0.8,_var1]
#define COL_BLUE COL_ABLUE(1)
#define ICON_SIZE_GROUPS 4
#define ICON_SIZE_GROUPS_C 40
#define TEXT_SIZE_C 0.1
#define TEXT_SIZE_L 0.01
#define TEXT_SIZE_S 0.001

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef DEBUG_MODE_FULL
    #define conBeep() "debug_console" callExtension ("A")
    #define conClear() "debug_console" callExtension ("C")
    #define conClose() "debug_console" callExtension ("X")
    #define conWhite(_msg) "debug_console" callExtension (_msg + "#1110")
    #define conWhiteTime(_msg) "debug_console" callExtension (_msg + "#1111")
    #define conRed(_msg) "debug_console" callExtension (_msg + "#1000")
    #define conRedTime(_msg) "debug_console" callExtension (_msg + "#1001")
    #define conGreen(_msg) "debug_console" callExtension (_msg + "#0100")
    #define conGreenTime(_msg) "debug_console" callExtension (_msg + "#0101")
    #define conBlue(_msg) "debug_console" callExtension (_msg + "#0010")
    #define conBlueTime(_msg) "debug_console" callExtension (_msg + "#0011")
    #define conYellow(_msg) "debug_console" callExtension (_msg + "#1100")
    #define conYellowTime(_msg) "debug_console" callExtension (_msg + "#1101")
    #define conPurple(_msg) "debug_console" callExtension (_msg + "#1010")
    #define conPurpleTime(_msg) "debug_console" callExtension (_msg + "#1011")
    #define conCyan(_msg) "debug_console" callExtension (_msg + "#0110")
    #define conCyanTime(_msg) "debug_console" callExtension (_msg + "#0111")
    #define conFile(_msg) "debug_console" callExtension (_msg + "~0000")
    #define conFileTime(_msg) "debug_console" callExtension (_msg + "~0001")
#else
    #define conBeep() doNothing = true
    #define conClear() doNothing = true
    #define conClose() doNothing = true
    #define conWhite(_msg) doNothing = true
    #define conWhiteTime(_msg) doNothing = true
    #define conRed(_msg) doNothing = true
    #define conRedTime(_msg) doNothing = true
    #define conGreen(_msg) doNothing = true
    #define conGreenTime(_msg) doNothing = true
    #define conBlue(_msg) doNothing = true
    #define conBlueTime(_msg) doNothing = true
    #define conYellow(_msg) doNothing = true
    #define conYellowTime(_msg) doNothing = true
    #define conPurple(_msg) doNothing = true
    #define conPurpleTime(_msg) doNothing = true
    #define conCyan(_msg) doNothing = true
    #define conCyanTime(_msg) doNothing = true
    #define conFile(_msg) doNothing = true
    #define conFileTime(_msg) doNothing = true
#endif
