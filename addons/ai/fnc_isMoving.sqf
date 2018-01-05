/* ----------------------------------------------------------------------------
Function: fsh_fnc_isMoving

Description:
    returns if group has unfinished waypoints or not

Parameters:
    0: Group <GROUP>

Returns:
    <BOOLEAN>

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_group",grpNull,[objNull,grpNull]]
];

_group = [_group] call cba_fnc_getGroup;

//Waypoints
private _currentWaypoint = currentWaypoint _group;
private _allWaypoints = count (wayPoints _group);

if !(_currentWaypoint >= _allWaypoints) exitWith {true};

false