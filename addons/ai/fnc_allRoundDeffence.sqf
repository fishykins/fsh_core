/* ----------------------------------------------------------------------------
Function: fsh_fnc_allRoundDeffence

Description:
    Tasks given group to form an all round deffence until a waypoint is added

Parameters:
    0: Group <GROUP>
    1: possition <ARRAY>

Returns:
    true <BOOLEAN>

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_group",grpNull,[objNull,grpNull]], 
    ["_position",[],[[],objNull,grpNull,""]]
];

_group = [_group] call cba_fnc_getGroup;

if (_group isEqualTo grpNull) exitWith {};

if (_position isEqualTo []) then {_position = _group;};
_position = [_position] call CBA_fnc_getPos;

private _units = units _group;

private _cx = X(_position);
private _cy = Y(_position);
private _radius = 1 + (count _units);
private _incriment = 360/(count _units);

private _i = _incriment;
{
    /*
	private _a = _radius * (cos _i);
	private _o = _radius * (sin _i);
	private _nx = _cx + _o;
	private _ny = _cy + _a;
	private _pos = [_nx, _ny];
    */
    private _pos = _position getPos [_radius, _i];
	[_x,_pos,"MIDDLE",_i] call fsh_fnc_doMove;
	ADD(_i,_incriment);
} forEach _units;