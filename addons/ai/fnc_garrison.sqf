/* ----------------------------------------------------------------------------
Function: fsh_fnc_garrison

Description:
    Tasks given group to garrison buildings and static weapons

Parameters:
    0: Group <GROUP>
    1: possition <ARRAY>

Returns:
    true <BOOLEAN>

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
#define POP_RAND(array) (array deleteAt floor random count array)

params [
    ["_group",grpNull,[objNull,grpNull]], 
    ["_position",[],[[],objNull,grpNull,""]],
    ["_waypointID", -1, [0]]
];

_group = [_group] call cba_fnc_getGroup;

if (_group isEqualTo grpNull) exitWith {};
if ([_group] call fsh_fnc_isMoving) exitWith {systemChat "cant garrison- moving";};

if (count _position isEqualTo []) then {_position = _group;};
_position = [_position] call CBA_fnc_getPos;

private _staticWeapons = _position nearObjects ["StaticWeapon", 50] select {_x emptyPositions "gunner" > 0};
private _buildings = (_position nearObjects ["Building", 50]) apply {_x buildingPos -1} select {count _x > 0};

{
    if (count _staticWeapons > 0 && {random 1 < 0.31}) then {
        private _static = (_staticWeapons deleteAt 0);
        [_x, _static,"GUNNER"] call fsh_fnc_doMove;
    } else {
        if (count _buildings > 0 && {random 1 < 0.93}) then {
            private _building = selectRandom _buildings;
            private _position = POP_RAND(_building);

            // if building positions are all taken, remove from possible buildings
            if (_building isEqualTo []) then {
                _buildings = _buildings select {count _x > 0};
            };

            // doMoveAndStay
            [_x, _position,"UP"] call fsh_fnc_doMove;
        };
    };
} forEach units _group;
