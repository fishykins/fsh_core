private ['_intersects', '_ii', '_point_a', '_point_b','_triggers','_bool','_interval_check','_collision_points'];
#define INC(_a) _a = _a + 1
_point_a = [_this, 0, [],[[]]] call BIS_fnc_param;
_point_b = [_this, 1, [],[[]]] call BIS_fnc_param;
_triggers = [_this, 2, [],[[]]] call BIS_fnc_param;
_interval_check = [_this, 3, 100,[0]] call BIS_fnc_param;
_bool = [_this, 4, true,[true]] call BIS_fnc_param;
_ret = -1;

if (count _point_a == 0 || count _point_b == 0) exitWith {
	_ret = if (_bool) then {false} else {-1};
	_ret
};


_cur_dist_x = 0;
_dist_x = _point_a distance _point_b;
_dir_x = _point_a getDir _point_b;
_ii = 0;
_intersects = false;
_collision_points = 0;

while {_cur_dist_x < _dist_x && _ii < 100} do {
	INC(_ii);
	_cur_pos_x = [_point_a,_dir_x,_cur_dist_x] call get_point;
	{
		_inRedZone = [_x, +_cur_pos_x] call BIS_fnc_inTrigger;
		if (_inRedZone) then {
			_intersects = true;
			INC(_collision_points);
		};
	} forEach _triggers;
	_cur_dist_x = _cur_dist_x + _interval_check;
	if (_intersects && _bool) then {_ii = 10000;};
};

_ret = if (_bool) then {_intersects} else {_collision_points};
_ret 