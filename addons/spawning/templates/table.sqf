#include "script_component.hpp"
#define RARE   0.8
#define EXCLUSIVE 0.6
#define COMMON 0.5
#define VERY_COMMON 0.3

params ["_pos","_dir"];

private _tablePositions = [];

for "_x" from 0.2 to 0.8 step 0.2 do {
    for "_y" from 0.2 to 0.8 step 0.2 do {
        _tablePositions pushBack [_x, _y, 1];
    };
};

//LOG_1("table positions: %1", _tablePositions);

private _class = selectRandom TABLES_LARGE;
private _relPos = [];

if (_class in ROTATE_90) then {_dir = _dir + (selectRandom [90,270]);};

_table = ([_pos, _class, false, _dir, "SIMPLE"] call FSH_fnc_spawnVehicle) select 0;

//Small ammo crate
if ((random 1) > RARE) then {
    _relPos = _tablePositions deleteAt (floor (random (count _tablePositions)));
    _pos = [_table, _relPos, 0] call fsh_fnc_getObjectRelPos;
    [_pos, selectRandom COTNAINERS_SMALL, false, (getDir _table) + 90] call FSH_fnc_spawnVehicle;
};

//Big object
if ((random 1) > EXCLUSIVE) then {
    _relPos = _tablePositions deleteAt (floor (random (count _tablePositions)));
    _pos = [_table, _relPos, 0] call fsh_fnc_getObjectRelPos;
    [_pos, selectRandom TOOLS_LARGE, false, random(360), "SIMPLE"] call FSH_fnc_spawnVehicle;
};


//Couple of small objects
for "_so" from 1 to ((floor (random 4)) min (count _tablePositions)) do {
    _relPos = _tablePositions deleteAt (floor (random (count _tablePositions)));
    _pos = [_table, _relPos, 0] call fsh_fnc_getObjectRelPos;
    [_pos, selectRandom TOOLS_SMALL, false, random(360), "SIMPLE"] call FSH_fnc_spawnVehicle;
};
