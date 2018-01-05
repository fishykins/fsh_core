#include "script_component.hpp"

private _object = _this select 0;
private _eh = _this select 1;
private _animations = _object getVariable ["fsh_animations",[[],[],[],[]]];

_animStart = _animations select 0;
_animStatic = _animations select 1;
_animLoop = _animations select 2;
_animEnd = _animations select 3;

if (!(_animEnd isEqualTo [])) then {
    _object playActionNow  (selectRandom _animEnd);
    _object setVariable ["fsh_animDone", false, false];
    _object addEventHandler ["AnimDone", {
        private _object = (_this select 0);
        {_object enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"] ;
        _object removeEventHandler ["AnimDone", _thisEventHandler];  
    }];
} else {
    _object setVariable ["fsh_animDone", true, false];
    {_object enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"] ;
};

if (_eh >= 0) then {_object removeEventHandler ["AnimDone", _eh];};

_object setVariable ["fsh_animating", false, false];
