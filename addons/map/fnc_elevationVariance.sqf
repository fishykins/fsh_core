/* ----------------------------------------------------------------------------
Function: FSH_fnc_elevationVariance
Description:
    returns the height variation within a given area

Parameters:
    1. Area to sample <AREA>
    2. Number of samples to use (higher values take longer but are more accurate) <INTEGER> defaults to 81
    3. Debug mode (draw markers on map). <BOOL>

Example:
    (begin example)
        _points = [[getPos player, 100, 100, 0, false], 100] call fsh_fnc_elevationVariance;
        //Will sample a circle around player with radius 100 meters.
    (end example)

Returns:
    Array- [Lowest point, highest point, average height ASL]

Author:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
SCRIPT(elevationVariance);
private _initTime = diag_tickTime;

params [
    ["_area", [], ["",objNull,locationNull,[]], 5],
    ["_pointCount", 81, [0]],
    ["_debug", false, [false]]
];

private _points = [_area, _pointCount] call fsh_fnc_areaPoints;

if (count _points isEqualTo 0) exitWith {[[],-1,[]]};

private _pointLowest = [];
private _pointHighest = [];
private _pointLowestZ = 1000000;
private _pointHighestZ = -1000000;

private _sum = 0;

{
    private _height = (ATLToASL _x) select 2;
    _x set [2, _height];
    ADD(_sum, _height);
    if (_height > _pointHighestZ) then {_pointHighestZ = _height; _pointLowest = _x;};
    if (_height < _pointLowestZ) then {_pointLowestZ = _height; _pointHighest = _x;};
    if (_debug) then {
       [str _x, _x, "ICON", [1,1],"TYPE:","mil_dot"] call CBA_fnc_createMarker; (str _x) setMarkerText str (_height);
    };
} forEach _points;

private _average = _sum/(count _points);
private _range = _pointHighestZ - _pointLowestZ;

if (_debug) then {
    hint format ["Time: %1, lowest point = %2, highest point = %3 with average %4", diag_tickTime - _initTime, _pointLowest, _pointHighest, _average];
    (str _pointHighest) setMarkerColor "colorRed";
    (str _pointLowest) setMarkerColor "colorBlue";
};

[_pointLowest, _pointHighest, _average, _range]
