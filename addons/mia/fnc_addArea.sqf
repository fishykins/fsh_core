/* ----------------------------------------------------------------------------
Description:

Parameters:

Returns:

Examples:

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
#define NO_POINTS 32
#define GROUND_HEIGHT 1.5
#define MIN_BLD_DIST 25
#define NUMB_PERIM_PATROLS 2
#define PATROL_WAYPOINT_COUNT 5

params [
    ["_name","",[""]],
    ["_zRef", [], ["",objNull,locationNull,[]], 5],
    ["_displayName","",[""]]
];

private _area = [_zRef] call CBA_fnc_getArea; // [center, a, b, angle, isRectangle]
_area params [
    "_areaPos",
    "_areaSizeA",
    "_areaSizeB",
    "_areaDirection",
    "_isRectangle"
];

GET_MIA(_name);

if (_displayName isEqualto "") then {
    private _index = MIA_G("areaIndex", 0);
    _displayName = format ["Area %1", _index];
    INC(_index);
    MIA_S("areaIndex", _index);
};

//Create a trigger that will represent this area
private _trigger = createTrigger ["EmptyDetector", _areaPos, false];
_trigger setTriggerArea [_areaSizeA, _areaSizeB, _areaDirection, _isRectangle];
_trigger setVariable ["owner", _mia];
_trigger setVariable ["area", _area];
_trigger setVariable ["name", _displayName];

//===================================================================================//
//=================================== ANALYSIS ======================================//
//===================================================================================//

//Find all buildings that can be entered
private _buildings = [];
private _houses = _areaPos nearObjects ["Building", _areaSizeA + _areaSizeB];
{
    if ([_trigger, _x] call BIS_fnc_inTrigger) then {
        private _positions = count (_x buildingPos -1);
        if (!(_positions isEqualto 0)) then {
            _buildings pushBackUnique _x;
        };
    };
} forEach _houses;
_trigger setVariable ["buildings", _buildings];

//find the most central building
private _Ex = 0;
private _Ey = 0;
private _bldCt = count _buildings;
{
    private _pos = getPos _x;
    _Ex = _Ex + (_pos select 0);
    _Ey = _Ey + (_pos select 1);
} forEach _buildings;

private _averageBldPos = [_Ex/_bldCt,_Ey/_bldCt];
private _centralBuilding = objNull;
private _bestDist = 999999;
{
    private _dist = (getPos _x) distance _averageBldPos;
    if (_dist < _bestDist) then {
        _bestDist = _dist;
        _centralBuilding = _x;
    };
} forEach _buildings;
_trigger setVariable ["centralBuilding", _centralBuilding];

//Find all Roads in area
private _allRoads = _areaPos nearRoads (_areaSizeA + _areaSizeB);
private _roadObjs = [];
private _roads = [];
private _junctions = [];
private _edgeRoads = [];

{
    if ([_trigger, _x] call BIS_fnc_inTrigger) then {
        _roadObjs pushBackUnique _x;
    };
} forEach _allRoads;

//Analyse each road segment
{
    private _connectedRoads = roadsConnectedTo _x;
    if (count _connectedRoads > 2) then {
        _junctions pushback _x;
    };
    for [{private _i = 0}, {_i < count _connectedRoads}, {INC(_i)}] do {
        private _cr = _connectedRoads select _i;
        if (!(_cr in _roadObjs)) then {
            //Conected road is not in trigger: must be edge road
            _edgeRoads pushBack _x;
            _i = 99;
        };
    };
    _roads pushBack _x;
} forEach _roadObjs;

//Break the area down into points and find the point with best visibilty
private _allPoints = [_trigger, NO_POINTS] call fsh_fnc_areaPoints;
private _points = [];
private _scoreVisibility = []; _scoreVisibility resize (count _allPoints); _scoreVisibility = _scoreVisibility apply {0};
private _scoreHeight = []; _scoreHeight resize (count _allPoints); _scoreHeight = _scoreHeight apply {0};

for [{private _i = 0}, {_i < count _allPoints}, {INC(_i)}] do {
    private _posI = _allPoints select _i; _posI set [2, GROUND_HEIGHT]; //x meters off the ground
    private _scoreI = _scoreVisibility select _i;
    private _posOk = true;

    //Get a height
    private _posASL = ATLtoASL [_posI select 0, _posI select 1, 0];
    private _heightASL = _posASL select 2;
    _scoreHeight set [_i, _heightASL];

    //Do comparisons against other points
    for [{private _j = _i + 1}, {_j < count _allPoints}, {INC(_j)}] do {
        private _posJ = _allPoints select _j; _posJ set [2, GROUND_HEIGHT]; //x meters off the ground
        private _terrainIntersects = terrainIntersectASL [_posI,_posJ];
        //Get a score from 0-1 of the visibity
        private _lineOfSight = [objNull, "VIEW"] checkVisibility [AGLtoASL _posI, AGLtoASL _posJ];

        //Add a score

        private _scoreJ = _scoreVisibility select _j;
        ADD(_scoreI,_lineOfSight);
        ADD(_scoreJ,_lineOfSight);
        _scoreVisibility set [_j, _scoreJ];

        //diag_log format["%1 -> %2: los = %3, I = %4, J = %5", _i, _j, _lineOfSight, _scoreI, _scoreJ];

    };

    _scoreVisibility set [_i, _scoreI];

    //Final score
    private _score = floor (_heightASL * (0.5 + _scoreI) * 0.2);

    //Check building proximity.
    for [{private _bldI = 0}, {_bldI < count _buildings}, {INC(_bldI)}] do {
        private _dist = (getPos (_buildings select _bldI)) distance2D _posI;
        if (_dist < MIN_BLD_DIST) then {
            _bldI = count _buildings;
            _posOk = false;
        };
    };

    //If not near a building, add to avalible points
    if (_posOk) then {
        _points pushBack [_posI, _score];
        //diag_log format["%1: los = %2, height = %3, final score = %4", _i, _scoreI, _heightASL, _score];
    };
};

_points = [_points,[],{_x select 1},"DESCEND"] call BIS_fnc_sortBy;


//------------- PATROL ROUTES -----------------//
private _patrols = [];

//High visibilty Patrol
private _tempPoints = +_points;
private _patrolPoints = [];
for [{private _i = 0}, {_i < PATROL_WAYPOINT_COUNT && _i < count _tempPoints}, {INC(_i)}] do {
    private _entry = (_tempPoints deleteAt 0);
    _patrolPoints pushBack (_entry select 0);
};
_patrolPoints = [+_patrolPoints] call fsh_fnc_linkPoints;
_patrols pushBack ["open", _patrolPoints];

//Low vis partrol
private _tempPoints = [+_points,[],{_x select 1},"ASCEND"] call BIS_fnc_sortBy;
private _patrolPoints = [];
for [{private _i = 0}, {_i < PATROL_WAYPOINT_COUNT && _i < count _tempPoints}, {INC(_i)}] do {
    private _entry = (_tempPoints deleteAt 0);
    _patrolPoints pushBack (_entry select 0);
};
_patrolPoints = [+_patrolPoints] call fsh_fnc_linkPoints;
_patrols pushBack ["low", _patrolPoints];

//Roads
_patrolPoints = [];
_tempPoints = [+_junctions,[],{count (roadsConnectedTo _x)},"DESCEND"] call BIS_fnc_sortBy;
_tempPoints append _edgeRoads;
_tempPoints resize (PATROL_WAYPOINT_COUNT min (count _tempPoints));
{
    _patrolPoints pushBack (getPos _x);
} forEach _tempPoints;
_patrolPoints = [+_patrolPoints] call fsh_fnc_linkPoints;
_patrols pushBack ["roads", _patrolPoints];

//Valley patrol
_tempPoints = [+_points,[],{((_x select 0) select 2)},"ASCEND"] call BIS_fnc_sortBy;
private _firstPoint = _tempPoints select 0;
private _lastPoint = _tempPoints select ((count _tempPoints) -1);
_patrolPoints = [_firstPoint select 0, _lastPoint select 0, [_area], [0.3], [0, 1000], 200, "DESABUG"] call fsh_fnc_getPath;
//_patrols pushBack ["Valley", _patrolPoints];


//------------- ROUTES TO OTHER AREAS -----------------//

//Set nearest grid to friendly
{
    if ([_trigger, _x] call BIS_fnc_inTrigger) then {
        _x setVariable [MIA_VAR("owner"), 1];
        MIA_PB("activeGrids", _x);
    };
} forEach (nearestLocations [_areaPos, ["fsh_gridLoc"], _areaSizeA + _areaSizeB]);


//Update variables
_trigger setVariable ["roads", _roads];
_trigger setVariable ["junctions", _junctions];
_trigger setVariable ["edgeRoads", _edgeRoads];
_trigger setVariable ["terrainPoints", _points];
_trigger setVariable ["patrolRoutes", _patrols];

//===================================================================================//
//===================================== EXIT ========================================//
//===================================================================================//
MIA_PB("areas",_trigger);
true
