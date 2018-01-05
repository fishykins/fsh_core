#include "script_component.hpp"

private _object = _this select 0;
private _animations = _object getVariable ["fsh_animations",[[],[],[],[]]];
private _maxDuration = _object getVariable ["fsh_animationDuration",0];

_animStart = _animations select 0;
_animStatic = _animations select 1;
_animLoop = _animations select 2;
_animEnd = _animations select 3;


private _loops = 0;
private _static = false;
private _animNew = "";
private _duration = 0;

while {_object getVariable ["fsh_animating", false]} do {
    if (_static) then {
        if (_static && random (5) > 4) then {
            _object setVariable ["fsh_animDone", true, false];
        };
    };
    
    if(_object getVariable ["fsh_animDone", false]) then
    {   
        if (!(_animStatic isEqualTo []) && !_static) then {
            _animNew =  (selectRandom _animStatic);
            _static = true;
        } else {
            _animNew = selectRandom _animLoop;
            _static = false;
        };
        _object switchMove _animNew;
        _object setVariable ["fsh_animDone", false, false];
        systemChat format["%1 doing %2", _object, _animNew];
    };
    INC(_duration);
    
    if (_duration >= _maxDuration && _maxDuration > 0) then {_object setVariable ["fsh_animating", false, false];};
    
    sleep 1;
};

[_object,_this select 1] call COMPILE_FILE(script_animationEnd);

