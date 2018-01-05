/* ----------------------------------------------------------------------------
Function: FSH_fnc_randomPos

Description:
   
    
Parameters:

    
Example:
    (begin example)

    (end example)
    
Returns:

    
Author:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
SCRIPT(randomPos);
private _initTime = diag_tickTime;

params [
    ["_area", [], ["",objNull,locationNull,[]], 5],
    ["_pointCount", 81, [0]],
    ["_boolArray", false, [false]],
    ["_debug", false, [false]]
];

private _points = [_area, _pointCount] call fsh_fnc_areaPoints;
private _return = []; if (_boolArray) then {_return = [[]];};

if (count _points isEqualTo 0) exitWith {_return}; 



#define INC(_a) 					_a = _a + 1;
#define LEVEL(_var,_a) 			if (_var > _a) then {_var = _a;}
#define STR_LZ 'lz'
#define STR_ADVANCED 'advanced'
#define STR_STRICT 'strict'
#define DEFAULT_POS [-1,-1,-1]

private ['_ret', '_position', '_WL', '_BL', '_searchParams', '_limit', '_areaSize', '_elevationRange', '_edgeDist', '_worldParams', '_flatness', '_buildingDistMin', '_treeDistMin', '_generalParams', '_needLand', '_needWater', '_debug', '_edgeCheck', '_fnc_testMarker', '_passedPos', '_color', '_mrk', '_elevationRangeMin', '_elevationRangeMax', '_absolute_limit', '_WL_Triggers', '_BL_Triggers', '_tempTrigs', '_finalHeight', '_vars', '_varname', '_trig', '_edgeOk','_attempts', '_posOK', '_worldTrig', '_randomWL', '_randomMapPos', '_inMap', '_inTrigger', '_waterDepth', '_isWater', '_terrain_ok', '_inElevationRange', '_elevation_variance', '_nearest_building', '_nearest_tree'];


/*** Params ***/
_WL = [_this,0,[],['',objNull,[]]] call BIS_fnc_param;
_BL = [_this,1,[],['',objNull,[]]] call BIS_fnc_param;

_searchParams = [_this,2,[],[[]]] call BIS_fnc_param;
	_limit = [_searchParams,0,50,[0]] call BIS_fnc_param;
	_areaSize = [_searchParams,1,20,[0]] call BIS_fnc_param;
	_elevationRange = [_searchParams,2,[-10000,10000],[[]],[2]] call BIS_fnc_param;
	_edgeDist = ([_searchParams,3,10000,[0]] call BIS_fnc_param) * -1;
	
	
_worldParams = [_this,3,[],[[]]] call BIS_fnc_param;
	_flatness = [_worldParams,0,50,[0]] call BIS_fnc_param;
	_buildingDistMin = [_worldParams,1,1,[0]] call BIS_fnc_param;
	_treeDistMin = [_worldParams,2,1,[0]] call BIS_fnc_param;
	_rockDistMin = [_worldParams,2,_areaSize,[0]] call BIS_fnc_param;
	_roadDistMin = [_worldParams,2,_areaSize,[0]] call BIS_fnc_param;
	
_generalParams = [_this,4,['land'],[[]]] call BIS_fnc_param;
	_needLand = if ('land' in _generalParams || STR_LZ in _generalParams) then {true} else {false};
	_needWater = if ('water' in _generalParams) then {true} else {false};
	_debug = if ('debug' in _generalParams) then {true} else {false};
	_edgeCheck = if ('edge' in _generalParams) then {true} else {false};
	_param_lz = if (STR_LZ in _generalParams) then {true} else {false};									//Run every loop and return the best LZ
	_param_advanced = if (STR_ADVANCED in _generalParams) then {true} else {false};							//Slower runtime, more accurate
	_param_strict = if (STR_STRICT in _generalParams) then {true} else {false};								//Only return a position that scores 5 or higher (may return null)
	
_full_run = if (_param_lz || _param_advanced) then {true} else {false};	
	
//========================================================================================================
if (_debug) then {
	_fnc_testMarker = 
	{
		_passedPos = _this select 0;
		_color = [_this,1,'colorRed',['']] call BIS_fnc_param;
		_text = str ([_this,2,0,[0]] call BIS_fnc_param);

		_mrk = createMarker [(format['%1_%2_g',_passedPos,random(999999)]), _passedPos];
		_mrk setMarkerColor (_color);
		_mrk setmarkerType 'mil_dot';
		//_mrk setMarkerBrush 'Solid';
		//_mrk setMarkerShape 'ELLIPSE';
		//_mrk setMarkerSize [4,4];
		_mrk setMarkerText _text;
	};
};
	
/*** Others ***/
_elevationRangeMin = [_elevationRange,0,-10000,[0]] call BIS_fnc_param;
_elevationRangeMax = [_elevationRange,1, 10000,[0]] call BIS_fnc_param;
_absolute_limit = 200;
_WL_Triggers = [];
_BL_Triggers = [];
_tempTrigs = [];
_finalHeight = 0;



/******************
***  Sort Lists ***
******************/

_vars = ['WL','BL'];
{
	_varname = _vars select _forEachIndex;
	{

		switch (typeName _x) do {
			//Markers
			case ('STRING'): {
				_trig = [objNull, _x] call BIS_fnc_triggerToMarker;
				call compile format ['_%1_Triggers set [count _%1_Triggers, _trig]',_varname];
				_tempTrigs set [count _tempTrigs, _trig];
			};
			//Triggers
			case ('OBJECT'): {
				if (_x isKindOf 'EmptyDetector') then {
					call compile format ['_%1_Triggers set [count _%1_Triggers, _x]',_varname];
				};
			};
			//[pos, radius]
			case ('ARRAY'): {
				_trig = createTrigger['EmptyDetector',(_x select 0)];
				_trig setTriggerArea[(_x select 1), (_x select 1), 0, false];
				call compile format ['_%1_Triggers set [count _%1_Triggers, _trig]',_varname];
				_tempTrigs set [count _tempTrigs, _trig];
			};
			//default { //handle error msg// };
		};

	} forEach _x;
} forEach [_WL,_BL];

/**********************
***  Find position  ***
**********************/
_attempts = 0;
_posOK = false;
_pos_array = [];


//create backup trigger that is the whole world
_worldTrig = call BIS_fnc_worldArea;

while {!_posOK && _attempts < _limit && _attempts < _absolute_limit} do {

	if ((count _WL_Triggers) > 0) then {
		_randomWL = (_WL_Triggers select (floor (random (count _WL_Triggers))));
	} else {
		_randomWL = _worldTrig;
	};

	_randomMapPos = _randomWL call BIS_fnc_randomPosTrigger;
	
	if (_debug) then {
		//[_randomMapPos,'ColorRed'] call _fnc_testMarker;
		diag_log '------------------';
		diag_log format['attempt : %1',_attempts];
	};
	_pos_score = 0;
	_inMap = [_worldTrig, +_randomMapPos] call BIS_fnc_inTrigger;
	if (_debug) then {diag_log format['in map : %1',_inMap];};
	if (_inMap) then {
		_inTrigger = [_randomWL, +_randomMapPos] call BIS_fnc_inTrigger;
		
		_edgeOk = false;
		if (_edgeCheck) then {
			if (([_randomWL, +_randomMapPos, true] call BIS_fnc_inTrigger) > _edgeDist) then {
				_edgeOk = true;
			};
		} else {
			_edgeOk = true;
		};
		
			
		
		
		if (_debug) then {diag_log format['in trigger : %1',_inTrigger];};
		if (_inTrigger && _edgeOk) then {
			_waterDepth = [_randomMapPos] call mia_fnc_getWaterDepth;
			_isWater = if (_waterDepth < 0) then {true} else {false};
			_terrain_ok = false;
			if (_needWater && _isWater) then {_terrain_ok = true;};
			if (_needLand && !_isWater) then {_terrain_ok = true;};
			if (!_needLand && !_needWater) then {_terrain_ok = true;};
			if (_debug) then {diag_log format['_terrain_ok : %1',_terrain_ok];};
			if (_terrain_ok) then {
			
				_nearest_building = _randomMapPos distance (nearestBuilding _randomMapPos);
				
				INC(_pos_score);
				_data = [_randomMapPos,_pos_score,_nearest_building]; // 1- is correctly land/water (depending on what was asked)
				
				
				_inElevationRange = if ((_waterDepth > _elevationRangeMin) && (_waterDepth < _elevationRangeMax)) then {true} else {false};
				if (_debug) then {diag_log format['_inElevationRange : %1',_inElevationRange];};
				if (_inElevationRange) then {

					INC(_pos_score);
					_data = [_randomMapPos,_pos_score, _nearest_building]; // 2- within elevation range
				
					if (_debug) then {diag_log format['_nearest_building : %1, needed >= %2',_nearest_building, _buildingDistMin];};
					if (_nearest_building >= _buildingDistMin) then {
					
						_nearest_tree = [[_randomMapPos, _treeDistMin * 10, false] call mia_fnc_getTrees,1,_treeDistMin * 10,[0]] call BIS_fnc_param;
						
				
						INC(_pos_score);
						_data = [_randomMapPos,_pos_score,_nearest_building, _nearest_tree]; // 3- ok for near buildings

						if (_debug) then {diag_log format['_nearest_tree : %1, needed >= %2',_nearest_tree, _treeDistMin];};
						if (_nearest_tree >= _treeDistMin) then {
											
							_nearest_rock = [[_randomMapPos, _areaSize *5, false] call mia_fnc_getRocks,1,_areaSize *5,[0]] call BIS_fnc_param;
							INC(_pos_score);
							_data = [_randomMapPos,_pos_score,_nearest_building,_nearest_tree,_nearest_rock]; // 4- this position ok for trees
							
							if (_debug) then {diag_log format['_nearest_rock : %1, needed <= %2',_nearest_rock, _flatness];};
							if (_nearest_rock > _rockDistMin) then {
							
								_elevation_variance = [_randomMapPos, _areaSize] call mia_fnc_getElevationVariance;
								
								INC(_pos_score);
								_data = [_randomMapPos,_pos_score,_nearest_building,_nearest_tree, _elevation_variance, _nearest_rock]; // 5- ok for rocks
								
								if (_debug) then {diag_log format['_elevation_variance : %1, needed <= %2',_elevation_variance, _flatness];};
								if (_elevation_variance <= _flatness && _nearest_rock > _areaSize *1.5) then {
								
									_nearest_road = 999999;
									{
										_dist = _randomMapPos distance (getPos _x);
										if (_dist <_nearest_road) then {_nearest_road = _dist;};
									} forEach (_randomMapPos nearRoads 100);

									INC(_pos_score);
									_data = [_randomMapPos,_pos_score,_nearest_building,_nearest_tree, _elevation_variance, _nearest_rock, _elevation_variance,_nearest_road]; // 6- ok for elevation
									
									if (_nearest_road > _roadDistMin) then {
										
										INC(_pos_score);
										
										if (!_full_run) then {
											_posOK = true;
											if (_debug) then {
												[_randomMapPos,'ColorGreen',_pos_score] call _fnc_testMarker;
												diag_log format['Position %1 ok, attempt no %2',_randomMapPos,_attempts];
											};
										};
									};
								};
							};
						};
					};
				};
				_pos_array pushBack _data;
			};
		};
	};
	
	if (_debug && !_posOK) then {
		[_randomMapPos,'ColorRed',_pos_score] call _fnc_testMarker;
	};
	
	_attempts = _attempts + 1;
};


//if we dont have a perfect result, pick the best one
_pos_array = [_pos_array,[],{_x select 1},"DESCEND"] call BIS_fnc_sortBy;
_best_poses = [];
_score = 0;
if (count _pos_array > 0 && !_posOK) then {
	if (_debug) then {diag_log '===============';};
	_best_pos = [_pos_array,0,[],[[]]] call BIS_fnc_param;
	_best_pos_score = [_best_pos,1,1,[0]] call BIS_fnc_param;
	
	{
		_score = [_x,1,1,[0]] call BIS_fnc_param;
		if (_score >= _best_pos_score) then {_best_poses pushBack _x;};
	} forEach _pos_array;
	if (_debug) then {diag_log format['Highest score found: %1. %2 cases',_best_pos_score, count _best_poses];};
	
	//now we have all positions that scored equally highest. 
	//Find the best result we can
	
	if ((_best_pos_score == 1 || _best_pos_score == 2)  && !_param_strict) then {
		//low scores all round- find position away from buildings
		_best_poses = [_best_poses,[],{[_x,2,10000,[0]] call BIS_fnc_param},"ASCEND"] call BIS_fnc_sortBy;
		_winner = _best_poses select 0;
		_randomMapPos =  [_winner,0,[-1,-1,-1],[[]]] call BIS_fnc_param;
		_score =  [_winner,2,-1,[0]] call BIS_fnc_param;
		if (_debug) then {diag_log format['Best building dist: %1',_score];};
		_posOK = true;
	};	
	
	if (_best_pos_score == 3 && !_param_strict) then {
		//Scored well on buildings but not on trees. Find best tree dist
		_best_poses = [_best_poses,[],{[_x,3,10000,[0]] call BIS_fnc_param},"ASCEND"] call BIS_fnc_sortBy;
		_winner = _best_poses select 0;
		_randomMapPos =  [_winner,0,[-1,-1,-1],[[]]] call BIS_fnc_param;
		_score =  [_winner,3,-1,[0]] call BIS_fnc_param;
		if (_debug) then {diag_log format['Best tree dist: %1',_score];};
		_posOK = true;
	};	
	
	if (_best_pos_score == 4 && !_param_strict) then {
		//Scored well on buildings and trees but not on rocks
		_best_poses = [_best_poses,[],{[_x,4,10000,[0]] call BIS_fnc_param},"ASCEND"] call BIS_fnc_sortBy;
		_winner = _best_poses select 0;
		_randomMapPos =  [_winner,0,[-1,-1,-1],[[]]] call BIS_fnc_param;
		_score =  [_winner,4,-1,[0]] call BIS_fnc_param;
		if (_debug) then {diag_log format['Best rock dist: %1',_score];};
		_posOK = true;
	};	
	
	if (_best_pos_score == 5 && !_param_strict) then {
		//Scored well on buildings, trees and rocks, but not on elevation
		_best_poses = [_best_poses,[],{[_x,5,10000,[0]] call BIS_fnc_param},"ASCEND"] call BIS_fnc_sortBy;
		_winner = _best_poses select 0;
		_randomMapPos =  [_winner,0,[-1,-1,-1],[[]]] call BIS_fnc_param;
		_score =  [_winner,4,-1,[0]] call BIS_fnc_param;
		if (_debug) then {diag_log format['Best elevation: %1',_score];};
		_posOK = true;
	};	
	
	
	if (_best_pos_score >= 6) then {
		//Scored well all round, pick according to any paramiters (default is furthest away from a road)
		_best_poses = [_best_poses,[],{[_x,6,10000,[0]] call BIS_fnc_param},"ASCEND"] call BIS_fnc_sortBy;
		_winner = _best_poses select 0;
		if (_param_lz) then {
			//We want an open space, so add all dists together and find the highest scorer
			_array_scores = [];
			{
				_x_pos = _x select 0;
				_buil_dist = [_x,2,10000,[0]] call BIS_fnc_param;		LEVEL(_buil_dist, 60);
				_tree_dist = [_x,3,10000,[0]] call BIS_fnc_param;		LEVEL(_tree_dist, 60);
				_rock_dist = [_x,4,10000,[0]] call BIS_fnc_param;		LEVEL(_rock_dist, 15);	//Dont use it anyway so just here for show
				_elevation = [_x,5,10000,[0]] call BIS_fnc_param;		
				_road_dist = [_x,6,10000,[0]] call BIS_fnc_param;		LEVEL(_road_dist, 30);
				_score = _buil_dist + _tree_dist + _road_dist;
				_array_scores pushBack [_x_pos, _score];
			} forEach _best_poses;
			_array_scores = [_array_scores,[],{[_x,1,10000,[0]] call BIS_fnc_param},"DESCEND"] call BIS_fnc_sortBy;
			_winner = _array_scores select 0;
			if (_debug) then {diag_log format['Best LZ score: %1',_score];};
		};
		
		
		_randomMapPos =  [_winner,0,[-1,-1,-1],[[]]] call BIS_fnc_param;
		_posOK = true;
	};	
};





//Clean up
{
	deleteVehicle _x;
} forEach _tempTrigs;

if (!_posOK) then {
	_randomMapPos = DEFAULT_POS;
	_msg = format['attempts to find a position exceeded %1, please reasses your areas', _limit];
	diag_log _msg;
};

_randomMapPos 
