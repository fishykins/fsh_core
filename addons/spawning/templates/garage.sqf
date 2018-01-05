//"Land_i_Garage_V1_F"
#include "script_component.hpp"
#define RARE   0.8
#define EXCLUSIVE 0.6
#define COMMON 0
#define VERY_COMMON 0.2

params ["_building"];

private _bldDir = getdir _building;

[format ["%1_garageSpawn", _building], getPos _building,"ICON",[1,1],"COLOR:","ColorYellow","TYPE:","MIL_DOT"] call CBA_fnc_createMarker;

private _class = "";
private _obj = objNull;
private _pos = [];
private _dir = 0;

//Car
if (Random 1 > COMMON && !(_civCars isEqualto [])) then {
    _class = selectRandom (_civCars + _civBikes);
    _pos = [_building, [0.5, 0.5, 0], 0] call fsh_fnc_getObjectRelPos;
    [_pos, _class, false, _bldDir + selectRandom [90,270]] call FSH_fnc_spawnVehicle;
};

//Table
_pos = [_building, [0.75, 0.4, 0], 0] call fsh_fnc_getObjectRelPos;
_dir = _bldDir + (selectRandom [90,270]);
_obj = [_pos, _dir] call SPAWN(table);
