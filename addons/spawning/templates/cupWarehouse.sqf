//"Land_i_Shed_Ind_F"
#include "script_component.hpp"
#define RARE   0.8
#define EXCLUSIVE 0.6
#define COMMON 0.4
#define VERY_COMMON 0.2

#define CHECK_DONE      if (_spaces isEqualto []) exitWith {}

params ["_building"];

private _buildingPositions = [];

for "_x" from 0.2 to 0.8 step 0.2 do {
    for "_y" from 0.2 to 0.8 step 0.2 do {
        _buildingPositions pushBack [_x, _y, 0];
    };
};


[format ["%1_shedSpawn", _building], getPos _building,"ICON",[1,1],"COLOR:","ColorKhaki","TYPE:","MIL_DOT"] call CBA_fnc_createMarker;

private _obj = objNull;
private _pos = [];
private _dir = 0;

while {!(_buildingPositions isEqualto [])} do {
    private _relPos = _buildingPositions deleteAt (floor (random (count _buildingPositions)));

    switch (floor (random 3)) do {
        case 0: {

            //Table
            _pos = [_building, _relPos, 0] call fsh_fnc_getObjectRelPos;
            _dir = (getDir _building) + (selectRandom [0,90,180,270]);
            _obj = [_pos, _dir] call SPAWN(table);
        };
        case 1: {
            //Cargo container
            _pos = [_building, _relPos, 0] call fsh_fnc_getObjectRelPos;
            _dir = (getDir _building) +selectRandom [0,90,180,270];
            [_pos, selectRandom (CARGO_CONTAINER_SMALL + BOXES_WOODEN), false, _dir,  "SIMPLE"] call FSH_fnc_spawnVehicle;
        };
        case 2: {
            //Car
            _pos = [_building, _relPos, 0] call fsh_fnc_getObjectRelPos;
            _dir = (getDir _building) +selectRandom [0,90,180,270];
            [_pos, selectRandom _civCars, false, _dir] call FSH_fnc_spawnVehicle;
        };
    };
};
