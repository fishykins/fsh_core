/* ----------------------------------------------------------------------------
Function:

Description:

Parameters:

Returns:

Example:
    (begin example)

    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

#define OK_LOC_TYPES            ["NameCity", "NameCityCapital", "NameVillage", "NameLocal"]
#define OK_LOC_TYPES_CUP        ["FlatAreaCity", "FlatAreaCitySmall", "Airport", "StrongpointArea", "CityCenter"]
#define XKO(_var1)              _x isKindOf _var1

//proportion of populated garages
#define MOD_GARAGE              0.2
//proportion of populated sheds
#define MOD_SHED                0.2
//trucks per cover
#define MOD_COVER               0.1
//planes per hangar
#define MOD_HANGAR              0.2
//Fuel trucks per station
#define MOD_FUELTRUCKS          0.1
//Number of cars per square km
#define MOD_CARS                1
//Number of boats
#define MOD_BOATS               10

//Chance of cars spawning in the wild (note: this spawn has a high chance of failure so the odds are actually much less)
#define CHANCE_SPAWN_WILD       0.1

#define MIN_COUNT               1
#define MAX_COUNT               30
#define MAX_CARS                150
#define MAX_BOATS               30

private _scriptStartTime = diag_tickTime;

params [
    ["_wlAreas", [], [[]]],
    ["_blAreas", [], [[]]],
    ["_mods", [], [[]]]
];

_mods params [
    ["_carDensity", 1, [0]],
    ["_density", 1, [0]],
    ["_wildDensity", 0.1, [0]]
];


private _checkArea = {
    params ["_pos"];
    private _triggersOk = true;

    if (!(_blAreas isEqualto [])) then {
        //Make sure this area is not in any of the blAreas
        for "_bl" from 0 to (count _blAreas) do {
            if ([_blAreas select _bl, _pos] call BIS_fnc_inTrigger) then {
                _triggersOk = false;
                _bl = count _blAreas;
            };
        };
    };

    if (!_triggersOk) exitWith {false};
    if (_wlAreas isEqualto []) exitWith {true};

    _triggersOk = false;

    //Make sure this area is in atleast one of the wl areas
    for "_wl" from 0 to (count _wlAreas) do {
        if ([_wlAreas select _wl, _pos] call BIS_fnc_inTrigger) then {
            _triggersOk = true;
            _wl = count _wlAreas;
        };
    };

    _triggersOk
};
//======================== VEHICLE PROFILES ======================================//
private _startTime = diag_tickTime;

private _civVehicles = (["CIV_F"] call fsh_fnc_factionVehicles);
private _civCars = [];
private _civTrucks = [];
private _civTrucksFuel = [];
private _civHelis = [];
private _civPlanes = [];
private _civBoats = [];
private _civBikes = [];

{
    private _types = ([_x] call fsh_fnc_getVehicleData) select 0;

    //diag_log format ["%1: %2", _x, _types];

    if ("car" in _types) then {_civCars pushBack _x;};
    if ("helicopter" in _types) then {_civHelis pushBack _x;};
    if ("plane" in _types) then {_civPlanes pushBack _x;};
    if ("quadbike" in _types) then {_civBikes pushBack _x;};
    if (_x isKindOf "Ship") then {_civBoats pushBack _x;};
    if ("truck" in _types) then {
        _civTrucks pushBack _x;
        if ("fuel" in _types) then {_civTrucksFuel pushBack _x;};
    };
} forEach _civVehicles;

systemChat format ["Finished Vehicle profiles: %1", diag_tickTime - _startTime];

//========================== LOCATION PROFILES =====================================//

_startTime = diag_tickTime;

private _buildings = [];
private _allLocations = configProperties [configfile >> "CfgWorlds" >> worldName >> "Names", "count _x > 0", true];
private _locations = [];
private _locTypes = [];

//Filter locations
{
    private _name = configName _x;
    private _type = getText (_x >> "type");
    private _pos = getArray (_x >> "position");
    private _a = getNumber (_x >> "radiusA");
    private _b = getNumber (_x >> "radiusB");
    private _angle = getNumber (_x >> "angle");
    _locTypes pushBackUnique _type;

    private _triggersOk = [_pos] call _checkArea;

    if (_type in OK_LOC_TYPES && _triggersOk) then {
        private _m = [_name,_pos,"ELLIPSE",[_a, _b],"COLOR:","colorGreen","BRUSH:","Border"] call CBA_fnc_createMarker;
        _m setMarkerDir _angle;

        _locations pushBack _m;

        /*
        {
            _buildings pushBackUnique _x;
        } forEach (_pos nearObjects ["building", _a + _b]);
        */

    } else {
        private _m = [_name,_pos,"ELLIPSE",[_a, _b],"COLOR:","colorRed","BRUSH:","Border"] call CBA_fnc_createMarker;
        _m setMarkerDir _angle;
    };
} forEach _allLocations;

//{diag_log _x;} forEach _locTypes;

systemChat format ["Finished location profiles: %1", diag_tickTime - _startTime];

//=========================== BUILDING PROFILES ===================================//

_startTime = diag_tickTime;

//Get map points
private _mapMiddle = [worldSize/2, worldSize/2, 0];

//0.274994 - Malden

private _fuelStations = [];
private _sheds = [];
private _covers = [];
private _hangars = [];
private _piers = [];
private _homeGarages = [];

//CUP

private _Land_Barn_Metal = [];
private _Land_Hangar_2 = [];

//Go through map buildings and sort
{
    //Fuel Stations
    if (getFuelCargo _x > 0) then {
        if ([getPos _x] call _checkArea) then {
            _fuelStations pushBack _x;
        };
    };
    //Hangars
    if (XKO("Land_Ss_hangar") || XKO("Land_TentHangar_V1_F") || XKO("Land_Hangar_F")) then {
        if ([getPos _x] call _checkArea) then {
            _hangars pushBack _x;
        };
    } else {
    //Harbours
    if (XKO("Land_Pier_F") || XKO("Land_nav_pier_m_2")) then {
        if ([getPos _x] call _checkArea) then {
            _piers pushBack _x;
        };
    } else {
    //Industrial Sheds
    if (XKO("Land_i_Shed_Ind_F") || XKO("Land_Hangar_2")) then {
        if ([getPos _x] call _checkArea) then {
            _sheds pushBack _x;
        };
    }  else {
    //Covers
    if (XKO("Land_Shed_Big_F")) then {
        if ([getPos _x] call _checkArea) then {
            _covers pushBack _x;
        };
    } else {
    //Home Garages
    if (XKO("Land_i_Garage_V1_F")) then {
        if ([getPos _x] call _checkArea) then {
            _homeGarages pushBack _x;
        };
    } else {

    //CUP

    //HUGE FUCKING SHED
    if (XKO("Land_Barn_Metal")) then {
        if ([getPos _x] call _checkArea) then {
            _Land_Barn_Metal pushBack _x;
        };
    };



    };};};};};
} forEach (_mapMiddle nearObjects ["building", worldSize]);

LOG_1("Locating all map buildings took %1", (diag_tickTime - _startTime));
systemChat format ["Finished building profiles: %1", diag_tickTime - _startTime];

//====================== CALCULATE CAR POPULATION =======================//

_startTime = diag_tickTime;

if (_wlAreas isEqualto []) then {_wlAreas = [call bis_fnc_worldArea];};

private _totalAreaA = 0;
private _totalAreaB = 0;

{
    private _area = [_x] call CBA_fnc_getArea;

    if !(_area isEqualTo []) then {
        _area params ["_center","_a","_b","_angle","_isRect"];
        _totalAreaA = _totalAreaA + _a;
        _totalAreaB = _totalAreaB + _b;
    };
} forEach _wlAreas;

private _totalArea = (_totalAreaA/1000) * (_totalAreaB/1000);

private _carCount = _totalArea * MOD_CARS * _carDensity;

//hint format ["Car count = %1. End result = %2",_carCount, (_carCount min MAX_CARS) max MIN_COUNT];

_carCount = (_carCount min MAX_CARS) max MIN_COUNT;

systemChat format ["Finished calculations: %1", diag_tickTime - _startTime];

//=======================================================================//
//=========================== START SPAWN ===============================//
//=======================================================================//

_startTime = diag_tickTime;

//Spawn tankers at fuel stations
private _count = (((count _fuelStations) * _density * MOD_FUELTRUCKS) min MAX_COUNT) max MIN_COUNT;
for "_vi" from 1 to 4 do {

    if (_civTrucksFuel isEqualto [] || _fuelStations isEqualto []) exitWith {_vi = 1000;};

    private _class = selectRandom _civTrucksFuel;
    private _pos = getPos (selectRandom _fuelStations);

    [_pos, _class, "colorYellow"] call SPAWN(onRoad);
};

//Spawn planes in hangars
_count = (((count _hangars) * _density * MOD_HANGAR) min MAX_COUNT) max MIN_COUNT;
for "_vi" from 1 to _count do {

    if (_civPlanes isEqualto [] || _hangars isEqualto []) exitWith {_vi = 1000;};

    private _class = selectRandom _civPlanes;
    private _hangar = _hangars deleteAt (floor (random (count _hangars)));
    [_hangar, _class, "ColorPink"] call SPAWN(onHangar);
};

//Spawn cargo truck under cover
_count = (((count _covers) * _density * MOD_COVER) min MAX_COUNT) max MIN_COUNT;
for "_vi" from 1 to _count do {

    if (_civTrucks isEqualto [] || _covers isEqualto []) exitWith {_vi = 1000;};

    private _class = selectRandom _civTrucks;
    private _cover = _covers deleteAt (floor (random (count _covers)));
    [_cover, _class, "ColorBrown", 4] call SPAWN(onHangar);
};

//Spawn stuff in sheds
_count = (((count _sheds) * _density * MOD_SHED) min MAX_COUNT) max MIN_COUNT;
for "_vi" from 1 to _count do {

    if (_sheds isEqualto []) exitWith {_vi = 1000;};

    private _building = _sheds deleteAt (floor (random (count _sheds)));
    if (_building isKindOf "Land_Hangar_2") then {
        [_building] call SPAWN(cupWarehouse);
    } else {
        [_building] call SPAWN(shed);
    };

};

//Spawn stuff in garages
_count = (((count _homeGarages) * _density * MOD_GARAGE) min MAX_COUNT) max MIN_COUNT;
for "_vi" from 1 to _count do {

    if (_homeGarages isEqualto []) exitWith {_vi = 1000;};

    private _building = _homeGarages deleteAt (floor (random (count _homeGarages)));

    [_building] call SPAWN(garage);
};


private _townCount = (_carCount * _wildDensity) max MIN_COUNT;
private _wildCount = _carCount - _townCount;

//City cars
private _carsSpawned = 0;
private _maxTries = (_townCount * 2) max 40;
for [{private _i = 0}, {_i < _maxTries && _carsSpawned < _townCount}, {INC(_i)}] do {
    private _class = selectRandom _civCars;
    private _loc = selectRandom _locations;
    private _pos = [_loc] call CBA_fnc_randPosArea;

    private _obj = [_pos, _class, "colorGreen"] call SPAWN(onRoad);
    if (!(_obj isEqualto objNull)) then {INC(_carsSpawned);};
};

//Wild Cars
_carsSpawned = 0 - (_townCount - _carsSpawned); //Get any leftovers from above

_maxTries = (_wildCount * 2) max 40;
for [{private _i = 0}, {_i < _maxTries && _carsSpawned < _wildCount}, {INC(_i)}] do {
    private _class = selectRandom _civCars;

    private _pos = [selectRandom _wlAreas] call CBA_fnc_randPosArea;
    private _obj = objNull;

    //Mainly spawn on road, but just occationally spawn totally randomly
    if (random 1 > CHANCE_SPAWN_WILD) then {
        _obj = [_pos, _class, "colorIndependent", 100] call SPAWN(onRoad);
    } else {
        _pos set [2, 0];
        private _waterDepth = (atlToAsl _pos) select 2;
        private _nearestObjects = (nearestTerrainObjects [_pos, ["Tree","FENCE", "WALL", "BUILDING"], 7]);

        if (_waterDepth > 0 && _nearestObjects isEqualto []) then {
            _obj = ([_pos, _class] call FSH_fnc_spawnVehicle) select 0;
            [format ["%1_%2", _class, _pos],_pos,"ICON",[1,1],"COLOR:","ColorBrown","TYPE:","MIL_DOT"] call CBA_fnc_createMarker;
        } else {
            //[format ["%1_%2", _class, _pos],_pos,"ICON",[0.7,0.7],"COLOR:","ColorRed","TYPE:","MIL_DOT"] call CBA_fnc_createMarker;
        };
    };


    if (!(_obj isEqualto objNull)) then {INC(_carsSpawned);};
};

//Spawn boats
_count = (MOD_BOATS * _density) min MAX_BOATS;
for "_vi" from 1 to _count do {

    if (_civBoats isEqualto [] || _piers isEqualto []) exitWith {_vi = 1000;};

    private _class = selectRandom _civBoats;
    private _pos = getPos (selectRandom _piers);

    for "_vib" from 1 to 10 do {

        //Pick a random point and set it to ground level
        private _posR = [_pos,100] call CBA_fnc_randPos; _posR set [2, 0];

        //convert to sea level and if negative - its in water
        private _waterDepth = (atlToAsl _posR) select 2;

        if (_waterDepth < -4) then {
            _vib = 100;
            _pos = aslToAtl [_posR select 0, _posR select 1, 0];
            [_pos, _class] call FSH_fnc_spawnVehicle;
            [format ["%1_%2", _class, _pos],_pos,"ICON",[1,1],"COLOR:","ColorBlue","TYPE:","MIL_DOT"] call CBA_fnc_createMarker;
        };
    };
};


LOG_1("AMBIENT SPAWN TOOK %1", (diag_tickTime - _scriptStartTime));
systemChat format ["Finished spawns: %1", diag_tickTime - _startTime];
