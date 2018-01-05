//"Land_i_Shed_Ind_F"
#include "script_component.hpp"
#define RARE   0.8
#define EXCLUSIVE 0.6
#define COMMON 0.4
#define VERY_COMMON 0.2

#define CHECK_DONE      if (_spaces isEqualto []) exitWith {}

params ["_building"];

[format ["%1_shedSpawn", _building], getPos _building,"ICON",[1,1],"COLOR:","ColorKhaki","TYPE:","MIL_DOT"] call CBA_fnc_createMarker;

private _obj = objNull;
private _pos = [];
private _dir = 0;

private _spaces = ["bay1", "bay2", "bay3", "end", "middle", "office"];

private _fillEmpty = {
    params ["_pos", "_bayID"];

    if (!(_bayID in _spaces)) exitWith {};

    switch (floor (random 3)) do {
        case 0: {

            //Table
            _pos = [_building, _pos, 0] call fsh_fnc_getObjectRelPos;
            _dir = (getDir _building) + (selectRandom [0,180]);
            _obj = [_pos, _dir] call SPAWN(table);
        };
        case 1: {
            //Cargo container
            _pos = [_building, _pos, 0] call fsh_fnc_getObjectRelPos;
            _dir = (getDir _building) +selectRandom [0,90,180,270];
            [_pos, selectRandom (CARGO_CONTAINER_SMALL + BOXES_WOODEN), false, _dir,  "SIMPLE"] call FSH_fnc_spawnVehicle;
        };
        case 2: {
            //Trolley
            _pos = [_building, [(_pos select 0) + 0.07 + random 0.05, (_pos select 1) - 0.05 + random 0.1,0], 0] call fsh_fnc_getObjectRelPos;
            _dir = random 360;
            _obj = ([_pos, selectRandom (TROLLEYS_SMALL), false, _dir,  "SIMPLE"] call FSH_fnc_spawnVehicle) select 0;

            //Tool on trolley
            _pos = [_obj, [0.2 + random 0.6,0.2 + random 0.6,1], 0] call fsh_fnc_getObjectRelPos;
            _dir = random 360;
            _obj = ([_pos, selectRandom (TOOLS_SMALL), false, _dir,  "SIMPLE"] call FSH_fnc_spawnVehicle) select 0;
        };
        case 3: {
            //Car
            _pos = [_building, _pos, 0] call fsh_fnc_getObjectRelPos;
            _dir = (getDir _building) +selectRandom [0,180];
            [_pos, selectRandom _civCars, false, _dir] call FSH_fnc_spawnVehicle;
        };
    };

    REM(_spaces, _bayID);
};


//Cars
if (!(_civCars isEqualto []) && Random 1 > EXCLUSIVE && "bay1" in _spaces && "bay2" in _spaces) then {
    for [{private _i = 0.43}, {_i < 0.65}, {_i = _i + 0.09}] do {
        _pos = [_building, [_i, 0.56, 0], 0] call fsh_fnc_getObjectRelPos;
        [_pos, selectRandom _civCars, false, (getDir _building) + selectRandom [0,180]] call FSH_fnc_spawnVehicle;
    };
    _spaces = _spaces - ["bay1","bay2"];
};


//Quadbikes
if (!(_civBikes isEqualto []) && Random 1 > EXCLUSIVE && "bay1" in _spaces) then {
    {
        _pos = [_building, _x select 0, 0] call fsh_fnc_getObjectRelPos;
        _dir = (getDir _building) + (_x select 1);
        [_pos, selectRandom _civBikes, false, _dir] call FSH_fnc_spawnVehicle;
    } forEach [
        [[0.4, 0.53, 0], 40],
        [[0.45, 0.5, 0], 0],
        [[0.5, 0.5, 0], 0]
    ];

    REM(_spaces, "bay1");
};

//Truck at end
if (random 1 > RARE && "end" in _spaces && !(_civTrucks isEqualto [])) then {
    _pos = [_building, [0.9,0.7,0], 0] call fsh_fnc_getObjectRelPos;
    _dir = (getDir _building) + (selectRandom [0,180]);
    [_pos, selectRandom _civTrucks, false, _dir] call FSH_fnc_spawnVehicle;
    REM(_spaces, "end");
};

//Truck down middle
if (!(_civTrucks isEqualto []) && random 1 > RARE && "middle" in _spaces) then {
    _pos = [_building, [0.4 + random 0.2,0.82,0], 0] call fsh_fnc_getObjectRelPos;
    _dir = (getDir _building) + (selectRandom [90,270]);
    [_pos, selectRandom _civTrucks, false, _dir] call FSH_fnc_spawnVehicle;
    REM(_spaces, "middle");
};

//Fill empty bays
{_x call _fillEmpty;} forEach [
    [[0.45,0.5, 0], "bay1"],
    [[0.6,0.5, 0], "bay2"],
    [[0.75,0.5, 0], "bay3"]
];

CHECK_DONE;

//End Cargo container
if (random 1 > EXCLUSIVE && "end" in _spaces) then {
    _pos = [_building, [0.9,0.7,0], 0] call fsh_fnc_getObjectRelPos;
    _dir = (getDir _building) + (selectRandom [90,270]);
    _obj = ([_pos, selectRandom CARGO_CONTAINER_MEDIUM, false, _dir] call FSH_fnc_spawnVehicle) select 0;

    //Put something on top of the cargo container!
    _pos = [_obj, [0.2 +random 0.6,0.2 +random 0.6,0], 0] call fsh_fnc_getObjectRelPos;
    _dir = random 360;
    _obj = ([_pos, selectRandom GROUND_ITEMS, false, _dir, "SIMPLE"] call FSH_fnc_spawnVehicle) select 0;

    REM(_spaces, "end");
};

CHECK_DONE;

//End car
if (random 1 > COMMON && "end" in _spaces && !(_civCars isEqualto [])) then {
    _pos = [_building, [0.9,0.7,0], 0] call fsh_fnc_getObjectRelPos;
    _dir = (getDir _building) + (selectRandom [0,180]);
    [_pos, selectRandom _civCars, false, _dir] call FSH_fnc_spawnVehicle;
    REM(_spaces, "end");
};
