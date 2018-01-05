/* ----------------------------------------------------------------------------
Function: FSH_fnc_areaPoints
Description:
    returns an array of points within the area. useful for analytical functions, or just drawing pretty shapes
Parameters:
    
Example:
    (begin example)
        _points = [[getPos player, 100, 100, 0, false], 32] call fsh_fnc_areaPoints;
    (end example)
    
Returns:
    NUMBER
    
Author:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
SCRIPT(areaPoints);

params [
    ["_zRef", [], ["",objNull,locationNull,[]], 5],
    ["_pointCount", 16, [0]]
];
private _area = [_zRef] call CBA_fnc_getArea;

if (_area isEqualTo [] || _pointCount isEqualTo 0) exitWith {[]};

_area params ["_center","_a","_b","_angle","_isRect"];
_center = [_center] call cba_fnc_getPos;

private _points = [];

if (_isRect) then {
    private _baseVar = sqrt (_pointCount);
    private _aMin = 0 - _a;
    private _bMin = 0 - _b;

    private "_i";
    private "_k";
    
    for "_i" from 0 to _baseVar do {
        private _a2 = _aMin + (2*((_a/_baseVar) * _i));
        for "_j" from 0 to _baseVar do {
            private _b2 = _bMin + (2*((_b/_baseVar) * _j));
            private _posVector = [[_a2, _b2, 0], -_angle] call BIS_fnc_rotateVector2D;
            private _pos = _center vectorAdd _posVector;
            _points pushBack _pos;
        };
    };
} else {    
    private _baseVar = floor (sqrt (_pointCount/2));
 
    // Generate point on circle of R=1
    
    private "_i";
    private "_k";
    for "_i" from 1 to _baseVar do {
        private _rho = (_i/_baseVar);
        private _rotTimes = _baseVar + (2*_i);
        for "_j" from 1 to _rotTimes do {
            private _phi = 360 * (_j/_rotTimes);
            // Scale circle to dimensions of the ellipse
            private _x = sqrt(1) * cos(_phi);
            private _y = sqrt(1) * sin(_phi);
            private _posVector = [[_x * _a * _rho, _y * _b * _rho, 0], -_angle] call BIS_fnc_rotateVector2D;
            private _pos = _center vectorAdd _posVector;
            _points pushBack _pos;
        };
    };
};

/*
{
    [str _x, _x, "ICON", [1,1],"COLOR:","colorRed","TYPE:","mil_dot"] call CBA_fnc_createMarker;
} forEach _points;*/

_points 