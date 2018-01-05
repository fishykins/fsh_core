/* ----------------------------------------------------------------------------
Function: fsh_fnc_atEase

Description:
    Tasks given group to act "casual" until further orders are given.

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
    ["_position",[],[[],objNull,grpNull,""]],
    ["_radius",25,[0]]
];

_group = [_group] call cba_fnc_getGroup;

if (_group isEqualTo grpNull) exitWith {};

if (_position isEqualTo []) then {_position = _group;};
_position = [_position] call CBA_fnc_getPos;

private _units = units _group;
private _leader = leader _group;

//////////////////////////////////////////////////////////////

_group setBehaviour  "CARELESS";

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
private _allObjects = nearestObjects [_position, ["ThingX"], _radius]; 
private _nearestBuilding = nearestBuilding _position;
private _foliage = nearestTerrainObjects [_position, ["Tree","Bush"], _radius, false];
private _rocks = nearestTerrainObjects [_position, ["ROCKS","ROCK"], _radius, false];
private _roads = _position nearRoads _radius;


//Find all chairs that can be sat on. This will only work if ACEX is running.
private _chairs = [];
{
    private _isChair = getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "acex_sitting_canSit");
    if (_isChair isEqualTO 1) then {
        _chairs pushBack _x;
    };
} forEach _allObjects;

//Pick three locations to loiter: A building, a rock, and a plant. 

private _loiterPositions = [];
_loiterPositions pushBack ([_nearestBuilding, 8] call CBA_fnc_randPos);
_loiterPositions pushBack (getPos (selectRandom _foliage));
_loiterPositions pushBack (getPos (selectRandom _rocks));

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

private "_i";
for "_i" from 0 to (count _units)-1 do {
    private _unit = _units select _i;
    
    // if there are any sittable objects, sit on them
    if (count _chairs > 0 && random(1) > 0.5) then {
        private _chair = selectRandom _chairs;
        _chairs = _chairs - [_chair];
        [_unit, getPos _chair, "SIT"] call fsh_fnc_doMove;
    } else {
        //Otherwise, do nothing
        private _loiterPos = [selectRandom _loiterPositions, 5] call CBA_fnc_randPos;
        [_unit, _loiterPos, "SIT"] call fsh_fnc_doMove;
        [_unit,"At Ease","%name is going to relax at %1", _loiterPos] call fsh_fnc_aiLog;
    };
};


//[str _chair, getPos _chair, "ICON", [1, 1],"TYPE:","mil_dot"] call CBA_fnc_createMarker;