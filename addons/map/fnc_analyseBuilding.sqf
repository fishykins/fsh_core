/* ----------------------------------------------------------------------------
Function: FSH_fnc_areaAnalysis
Description:
    Looks at an area and surveys it for interesting positions, buildings etc.

Parameters:

Example:
    (begin example)

    (end example)

Returns:

Author:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
#define BUILDING_RADIUS 200
#define TERRAIN_POINTS 8
#define I_ROADS 0
#define I_LOS 1

SCRIPT(analyseBuilding);

params [
    ["_building", objNull, [objNull]]
];


private _xData = _building getVariable [QGVAR(data), []];
if (!(_xData isEqualto [])) exitWith {_xData};

private _bldPos = getPos _building; _bldPos set [2, 2];
_xData = [BUILDING_RADIUS, 0];

//Nearby roads
private _closestRoad = -1;
private _nRoads = _house nearRoads BUILDING_RADIUS;
private _nRoad = ([_nRoads,[],{_building distance2D _x},"ASCEND"] call BIS_fnc_sortBy) select 0;
_xData set [I_ROADS, _x distance _nRoad];

//View
private _losScore = 0;

private _area = [_bldPos, BUILDING_RADIUS, BUILDING_RADIUS, 0, false];
private _points = [_area, TERRAIN_POINTS] call fsh_fnc_areaPoints;

{
    private _lineOfSight = [_building, "VIEW"] checkVisibility [AGLtoASL _bldPos, AGLtoASL _x];
    _losScore = _losScore + _lineOfSight;
} forEach _points;

_xData set [I_LOS, _losScore];

//Military?

//EXIT
_building setVariable [QGVAR(data), _xData, false];
_xData
