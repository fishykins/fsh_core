//Script that finds the best spot for the requested search
//returns pos ASL
#include "..\..\macros.hpp"

_position = [_this,0,[0,0,0],[[]]] call BIS_fnc_param;		   
_radius_params = [_this,1,[200,5],[[]]] call BIS_fnc_param;	
	_radius = [_radius_params,0,0,[-1]] call BIS_fnc_param;		
	_min_radius = [_radius_params,1,0,[-1]] call BIS_fnc_param;	
_params = [_this,2,[],[[]]] call BIS_fnc_param;	


_debug = PASS_PARAM('debug',_params);
_los_needed = PASS_PARAM('los',_params);													//LOS     	If true, a line of sight is needed from the random pos to the given position. 
_sniper_height = if ('sniper' in _params) then {1;} else {5;};  							//sniper		gives a slightly more accurate LOS reading
_hidden_needed = if ('hidden' in _params) then {_sniper_height = 20; true} else {false};		//hidden		If true, must be hidden from the given position (will also override sniper command)
_allow_buildings = PASS_PARAM('buildings',_params);										//buildings	If true, allows the inclusion of building positions in search
_noTerrain = PASS_PARAM('noTerrain',_params);												//noTerrain	If true, will not search terrain positions (will return nothing if buildings not enabled)

_best_pos_building = [0,0,-100];
_best_pos_terrain = [0,0,-100];

if (_allow_buildings) then {/////////////////// BUILDINGS ////////////////////////////////////////////////////////


_buildings = nearestObjects [_position, ["House", "Building","Land_TTowerBig_2_F"], _radius];
_building_score_array = [];

{
	_bld = _x;
	_bld_pss = [_bld] call mia_fnc_getBuildingPositions;
	if (count _bld_pss > 0) then {
		_best_pos = ([_bld_pss,[],{Z(_x)},"DESCEND"] call BIS_fnc_sortBy) select 0;
		_best_posASL = AGLToASL _best_pos;
		if (_debug) then {
			_height = floor (_best_posASL select 2);
			[_best_pos, 'colorYellow', str (_height), 15] call mia_fnc_debugMarker;
		};
		_building_score_array pushback [_bld,_best_posASL];
	};
} forEach _buildings;

_best_pos_building = ([_building_score_array,[],{(_x select 1) select 2},"DESCEND"] call BIS_fnc_sortBy) select 0;
	


};if (!_noTerrain) then {/////////////////////// TERRAIN //////////////////////////////////////////////////////////

_max_tries = _radius/1.5;
if (_max_tries <100) then {_max_tries = 100;};
_tries = 0;
_best_score = -1000;



_trig = createTrigger["EmptyDetector",(_position)];
_trig setTriggerArea[_radius, _radius, 0, false];

while {_tries < _max_tries} do {
	_score = 0;
	_cur_loc = [_trig] call BIS_fnc_randomPosTrigger;
	_height = [_cur_loc] call mia_fnc_getWaterDepth;
	_pos_a = [_cur_loc select 0, _cur_loc select 1, _height + _sniper_height ];
	_pos_b = [_position select 0, _position select 1, ([_position] call mia_fnc_getWaterDepth) + _sniper_height ];
	_los = !(terrainIntersectASL [_pos_a, _pos_b]); 
	_los_objects = !(lineIntersects [_pos_a, _pos_b]);
	
	_los_test = if ( (_los_needed && _los && _los_objects) or !_los_needed ) then {true;} else {false;};
	_hidden_test = if ( (_hidden_needed && !_los) or !_hidden_needed ) then {true;} else {false;};
	_min_dist_test = if (_pos_a distance _pos_b > _min_radius) then {true;} else {false;};
	
	_passed = if (_los_test && _min_dist_test && _hidden_test) then {true;} else {false;}; 
	_score = _score + _height;
	
	if (_debug) then {
		[_cur_loc, 'colorGreen', str (floor _score), 15] call mia_fnc_debugMarker;
	};
	
	if (_score > _best_score && _passed) then {
		_best_score = _score; 
		_cur_loc set [2, _height];
		_best_pos_terrain = _cur_loc;
	};
	
	_tries = _tries + 1;
	};

deleteVehicle _trig;

};////////////////////////////////////////////////////////////////////////////////////////
_return = if ((_best_pos_building select 1) select 2 > Z(_best_pos_terrain)) then {_best_pos_building select 0} else {_best_pos_terrain};

_return 