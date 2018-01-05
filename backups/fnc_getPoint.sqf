/* ----------------------------------------------------------------------------
Function: fsh_fnc_getPoint

Description:
    returns the point from passed position and direction using basic trig.

Parameters:
    0: possition <ARRAY>
    1: direction <NUMBER>
    2: distance <NUMBER>

Returns:
    position <ARRAY>

Author:
    fishy
---------------------------------------------------------------------------- */
params [
    ["_position",[],[[],objNull,grpNull,""]], 
    ["_direction",0,[1]],
    ["_radius",1,[1]]
];

_position = [_position] call CBA_fnc_getPos;

private _x1 = _position select 0;
private _y1 = _position select 1;

private _a = _radius * (cos _direction);
private _o = _radius * (sin _direction);
private _x2 = _x1 + _o;
private _y2 = _y1 + _a;

[_x2, _y2, 0]