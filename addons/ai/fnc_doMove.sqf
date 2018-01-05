/* ----------------------------------------------------------------------------
Function: fsh_fnc_doMove

Description:
    Tasks an individual unit to move to the given position and wait until a new waypoint is set. 

Parameters:
    0: Group <GROUP>
    1: possition to move to, or alternitavely vehicle to mount OR a command <ARRAY, STRING or OBJECT>
        COMMANDS:
        "regroup" - moves back into formation and will not hold position
    2: stance <STRING>
    3: direction to face <NUMBER>
    4: run FSM escape script (only disable if this is a fire and forget) <BOOL> default-true

Returns:
    true <BOOLEAN>

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"


params [
    ["_unit",objNull,[objNull]], 
    ["_position",[],[[],objNull,""]],
    ["_stance","UP",[""]],
    ["_direction",-1,[0]],
    ["_fsm",true,[true]],
    ["_waypointID",-1,[0]]
];

if (_unit isEqualTo objNull) exitWith {false};
if (_position isEqualTO []) exitWith {false};

private _command = "";

if (IS_STRING(_position)) then {_command = toLower _position; _position = getPos _unit};



private _group = group _unit;
private _leader = leader _group;

//Free the unit from any exsisting orders

/*
[_unit] joinSilent grpnull;
[_unit] joinSilent _group;
_group selectLeader _leader;
*/
_unit doFollow _leader;

if (_command isEqualTo "regroup") exitWith {_unit setVariable [QGVAR(canMove), true, true]; true};

//Assign the move order

if (IS_ARRAY(_position)) then {
    _unit doMove _position;
    _unit setUnitPos "AUTO";
} else {
    if (_stance isEqualTo "ACEX_SIT" && !(isNil "acex_sitting_fnc_sit")) then {
        _unit doMove (getPosATL _position);
        _unit setUnitPos "AUTO";
    } else {
        _unit assignAsGunner _position;
        [_unit] orderGetIn true;
    };
};

//Give doMove a unique id, so if a new order is given we can cancel the old one

if (isNil QGVAR(doMoveId)) then {GVAR(doMoveId) = 0;} else {INC(GVAR(doMoveId));};
private _doMoveID = GVAR(doMoveId);
_unit setVariable [QGVAR(doMoveId), _doMoveID, false];
_unit setVariable [QGVAR(canMove), true, true];

//Call the escape fsm
if (_fsm) then {
    [_unit,_position,_stance,_direction,_doMoveID] execFSM GVAR(doMove_fsm);
};

true
