/* ----------------------------------------------------------------------------
Function: FSH_fnc_spawnGroup

Description:
    Spawn a group at the given location
    
Parameters:
    POSITION- where to spawn
    GROUP- class of config. Pass an array of units and thats cool too
    SCALAR- direction of group (defualts random)
    SIDE- side on which to spawn (replaces default). accepts side, string or int. "default" uses class side
    
Returns:
    spawned group id
    
Example:
    (begin example)
        //creates an opfor group at players position, facing east. Will be friendly to player
        _group = [getpos player, "OI_reconTeam", 90, side player] call FSH_fnc_spawnGroup   
        
        //creates the same opfor group at marker, facing west. Will be sided with west
        _group2 = ["markerSpawn", configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OI_reconTeam", 270, 1] call FSH_fnc_spawnGroup   
    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
#define LOG(MESSAGE) /* disabled */
#define LOG_1(MESSAGE,ARG1) /* disabled */
#define LOG_2(MESSAGE,ARG1,ARG2) /* disabled */
#define LOG_3(MESSAGE,ARG1,ARG2,ARG3) /* disabled */
#define LOG_4(MESSAGE,ARG1,ARG2,ARG3,ARG4) /* disabled */

params [
    ["_position","",["",objNull,[]]],
    ["_groupID","",[[],0,"",configNull]],
    ["_direction",random(360),[0]],
    ["_side",-1,[1,WEST,""]]
];

SWITCH_POS_ATL(_position,[]);
if (_position isEqualTo []) exitWith {WARNING_1("failed to spawn '%1', no position given", _class); [objNull, grpNull]}; 
//=========================================
private _units = [];
private _ranks = [];
private _skillRange = [];
private _relativePositions = [];
private _defaultSide = 1;

if (IS_ARRAY(_groupID)) then {_units = _groupID;} else {
    if (IS_INTEGER(_groupID)) then {
        for [{_i =0},{_i<_groupID},{INC(_i)}] do {_units pushBack (typeOf player);};
    } else {
        private _config = [_groupID] call fsh_fnc_getGroupConfig;
        private _unitArray = (configProperties [_config, "count _x > 0",true]);
        _defaultSide = getNumber (_config >> "side");
        _units = +_unitArray apply {getText (_x >> "vehicle")};
        _ranks = +_unitArray apply {getText (_x >> "rank")};
        _relativePositions = +_unitArray apply {getArray (_x >> "position")};
        LOG_1("Config units: %1", _units);
    };
};

if (count _units isEqualTO 0 || !(IS_ARRAY(_units))) exitWith {WARNING_1("Unable to spawn group %1", _groupID); objNull};

if (_side isEqualTo -1) then {_side = _defaultSide;};
if (!(IS_SIDE(_side))) then {SWITCH_SIDE(_side,resistance);};


LOG_1("Positon: %1", _position);
LOG_1("_side: %1", _side);

//================================================================================================================================
//================================================================================================================================
//================================================================================================================================
//Start spawning

private _groupBase = createGroup _side;
private _group = createGroup _side;

private _vehicles = [];

for [{_i = 0},{_i < count _units},{INC(_i)}] do {
    private _unitType = _units select _i;
    private _unitSkill = 0.25 + random(0.5);
    private _unitRank = if ((count _ranks) > _i) then {_ranks select _i} else {"PRIVATE"};
    private _unitRelativePos = if ((count _relativePositions) > _i) then {_relativePositions select _i} else {[0,0]};
    
    //Work out the angles
    //private _directAngle = _position getDir _unitDirectPosition;
    private _unitRelativePos = [_unitRelativePos, _direction] call BIS_fnc_rotateVector2D;
    private _unitPosition = [_position, _unitRelativePos] call bis_fnc_vectorAdd;
    
	private _config = configFile >> "CfgVehicles" >> _unitType;
	private _isMan = (getNumber(_config >> "isMan") isEqualTO 1);

	if !(_isMan) then {_vehicles pushBack _unitType};

    //Is this a character or vehicle?
    if (_isMan) then {
        private _unit = _unitType createUnit [_unitPosition, _groupBase, "", _unitSkill, _unitRank];
        LOG_3("Spawning unit %1 with rank %2 and skill %3", _unitType, _unitRank, _unitSkill);
    } else {
        private _vehData = ([_unitPosition, _unitType, _groupBase, _direction] call fsh_fnc_spawnVehicle) select 1;
        LOG_1("Spawning vehicle %1", _vehData);
    };
};

//--- Sort group members by ranks
while {count units _groupBase > 0} do {
	private _maxRank = -1;
	private _unit = objnull;
	{
		_rank = rankid _x;
		if (_rank > _maxRank || (_rank == _maxRank && (group effectivecommander vehicle _unit == _group) && effectivecommander vehicle _x == _x)) then {_maxRank = _rank; _unit = _x;};
	} foreach units _groupBase;
	[_unit] joinsilent _group;
};
_group selectleader (units _group select 0);
deletegroup _groupBase;

//This doesn't work... I blame BIS
_group setFormDir _direction;

_group 