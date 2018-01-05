#include "script_component.hpp"

GVARMAIN(mapMousePos) = (_this select 0) ctrlMapScreenToWorld [_this select 1,_this select 2];
//hintSilent str GVARMAIN(mapMousePos);
private _nearest = objNull;
private _nscore = 1000000;
private _objects = nearestObjects [GVARMAIN(mapMousePos), ["Man"], 20];
{
    private _dist = GVARMAIN(mapMousePos) distance (getPos _x);
    if (_dist < _nscore) then {
        _nearest = _x;
        _nscore = _dist;
    };
} forEach _objects;
private _group = group _nearest;
if (_group isEqualto GVARMAIN(selectedGroup)) exitWith {};
//New Group is selected so put the old one back to normal
GVARMAIN(selectedGroup) setVariable [QGVAR(selected), false, false];
GVARMAIN(selectedGroup) = _group;
GVARMAIN(selectedGroup) setVariable [QGVAR(selected), true, false];
