/* ----------------------------------------------------------------------------
Function: fsh_fnc_animate

Description:
    Animates the given obeject

Parameters:
    0: object to animate <OBJECT>
    1: animation to use <TEXT>
    2: force animation <BOOLEAN>

Returns:
    true <BOOLEAN>

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_object",objNull,[objNull]], 
    ["_animationType","",[""]],
    ["_duration",-1,[0]]
];

if (_object isEqualTo objNull) exitWith {false};
if (_animationType isEqualTo "" || (toLower _animationType) isEqualTo "stop") exitWith {null = [_object,-1] spawn COMPILE_FILE(script_animationEnd); true};

private _animations = [_animationType] call fsh_fnc_getAnimations;

if (_animations isEqualTO [[],[],[],[]]) exitWith {null = [_object,-1] spawn COMPILE_FILE(script_animationEnd); true};

_animStart = _animations select 0;
_animStatic = _animations select 1;
_animLoop = _animations select 2;
_animEnd = _animations select 3;


_object setVariable ["fsh_animEnded", false, false];
_object setVariable ["fsh_animPos", position _object, false];
_object setVariable ["fsh_animations", _animations, false];
_object setVariable ["fsh_animationDuration", _duration, false];
_object setVariable ["fsh_animating", true, false];

{_object disableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];


if (!(_animStart isEqualTo [])) then {
    _object playActionNow  (selectRandom _animStart);
    _object setVariable ["fsh_animDone", false, false];
} else {
    _object setVariable ["fsh_animDone", true, false];
};
    
private _eh =_object addEventHandler ["AnimDone",
    {
        (_this select 0) setVariable ["fsh_animDone", true, false];
    }
];

if (!("NOLOOP" in _this)) then {
    null = [_object,_eh] spawn COMPILE_FILE(script_animationLoop);
};

true 