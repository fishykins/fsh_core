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
#define FLOOR_REDUCTION 0.16

params [
    ["_object","",["",objNull,[]]],
    ["_offset", [0,0,0], [[]]],
    ["_floor", -1, [0]]
];

_offset params [
    ["_ox", 0, [0]],
    ["_oy", 0, [0]],
    ["_oz", 0, [0]]
];

private _boundingBox = boundingBoxReal _object;
private _center = boundingCenter _object;
private _p1 = _boundingBox select 0;
private _p2 = _boundingBox select 1;

private _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
private _maxLength = abs ((_p2 select 1) - (_p1 select 1));
private _maxHeight = abs ((_p2 select 2) - (_p1 select 2));

private _minX = (_p1 select 0) min (_p2 select 0);
private _minY = (_p1 select 1) min (_p2 select 1);
private _minZ = (_p1 select 2) min (_p2 select 2);

//If it is a building, adjust for requested floor
if ((_object isKindOf "Building") && _floor >= 0) then {

    private _floorHeightsTemp = [];
    private _floorHeights = [];

    //Grab all z heights from building possitions.
    {
        _floorHeightsTemp pushBackUnique (((aglToASl _x) select 2) - FLOOR_REDUCTION);
    } forEach (_object buildingPos -1);

    //Get extreme points
    private _min = (selectMin _floorHeightsTemp);
    private _max = (selectMax _floorHeightsTemp);

    _floorHeights pushBack _min;

    //if we have more than one floor, do some fun sums
    if ((_max - _min) > 1) then {
        _floorHeights pushBack _max;

        _floorHeightsTemp = _floorHeightsTemp - _floorHeights;

        //eliminate those "ever so slightly" not equal heights
        for [{private _i = 0}, {_i < count _floorHeightsTemp}, {INC(_i)}] do {
            private _a = _floorHeightsTemp select _i;
            private _unique = true;

            for [{private _j = 0}, {_j < count _floorHeights}, {INC(_j)}] do {
                private _b = _floorHeights select _j;

                if ((abs (_a - _b)) < 1) then {
                    //Basically the same floor- dont add it!
                    _j = count _floorHeightsTemp;
                    _unique = false;
                };
            };

            if (_unique) then {
                _floorHeights pushBackUnique _a;
            };
        };

        //Sort from ground to top floor!
        _floorHeights = [_floorHeights, [], {_x},"ASCEND"] call BIS_fnc_sortBy;

    };

    //Select the floor height from sorted list
    private _floorZ = _floorHeights select (_floor min ((count _floorHeights) -1));
    private _tempPos = (aslToAgl [(getPos _object) select 0,(getPos _object) select 1, _floorZ]);

    //Get a relative z pos for the selected floor so we can alter our offset
    private _relPos = _object worldToModel _tempPos;
    _minZ = _relPos select 2;

    //Alter the offset and maxHeight
    _maxHeight = abs ((_p2 select 2) - _minZ);
};

private _offsetRel = [
    _minX + (_maxWidth * _ox),
    _minY + (_maxLength * _oy),
    _minZ + (_maxHeight * _oz)
];

private _position = _object modelToWorld _offsetRel;

_position
