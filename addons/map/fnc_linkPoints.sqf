/* ----------------------------------------------------------------------------
Function: FSH_fnc_linkPoints

Description:
    Function that will find the best possible path between passed points.
    If no start position is supplied, the start position will also be calculated

Parameters:

Example:
    (begin example)

    (end example)

Returns:

Author:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
#define MAX_TRIES 50
SCRIPT(linkPoints);

params [
    ["_allPoints", [], [[]]],
    ["_startPos", [], [[]]],
    ["_limmiter", MAX_TRIES, [0]]
];

if (_allPoints isEqualto []) exitWith {[]};

private _startingPoint = _startPos;
private _points = + _allPoints;

//If no starting position is passed, find the best point to start from
if (_startPos isEqualto []) then {
    //Find most extreem point

    /*
    private _maxDists = []; _maxDists resize (count _allPoints); _maxDists = _maxDists apply {999999};

    for [{private _i = 0}, {_i < count _allPoints}, {INC(_i)}] do {
        private _iPos = _allPoints select _i;
        private _iMaxDist = _maxDists select _i;

        for [{private _j = _i + 1}, {_j < count _allPoints}, {INC(_j)}] do {
            private _jPos = _allPoints select _j;
            private _jMaxDist = _maxDists select _j;
            private _dist = _iPos distance _jPos;
            _maxDists set [_i, _iMaxDist min _dist];
            _maxDists set [_j, _jMaxDist min _dist];
        };
    };

    private _startingPointIndex = 0;
    private _maxDistBest = -1;

    {
        if (_x > _maxDistBest) then {
            _startingPointIndex = _forEachIndex;
            _maxDistBest = _x;
        };
    } forEach _maxDists;

    _startingPoint = _points deleteAt _startingPointIndex;
    */

    private _startingPointIndex = 0;
    private _eX = 0;
    private _eY = 0;
    private _c = count _allPoints;
    {
        _eX = _eX + (_x select 0);
        _eY = _eY + (_x select 1);
    } forEach _allPoints;

    private _aPos = [_eX/_c, _eY/_c];
    private _furthestPos = [];
    private _furthestDist = 0;

    {
        private _dist = _aPos distance _x;
        if (_dist > _furthestDist) then {
            _furthestDist = _dist;
            _startingPointIndex = _forEachIndex;
        };
    } forEach _allPoints;

    _startingPoint = _points deleteAt _startingPointIndex;
    /*
    diag_log "==================================== LINK POINTS =========================================";
    for [{private _i = 0}, {_i < count _allPoints}, {INC(_i)}] do {
        private _point = _allPoints select _i;
        private _score = _maxDists select _i;
        diag_log format [":: Point %1 (%2) has score %3 ::", _i, _point, _score];
    };
    diag_log format ["Starting point: %1", _startingPoint];
    diag_log format ["other points: %1", _points];
    */
};


//Calculate path based on score
private _order = [_startingPoint];
private _runTimes = 0;

while {_runTimes < _limmiter && count _points > 0} do {
    private _pos = _order select ((count _order) - 1);
    private _bestScore = 999999;
    private _bestPosIndex = -1;
    private _bestPos = [];
    {
        private _score = (_pos distance _x);
        if (_score < _bestScore) then {
            _bestPos = _x;
            _bestScore = _score;
            _bestPosIndex = _forEachIndex;
        };
    } forEach _points;
    _order pushBack (_points deleteAt _bestPosIndex);
    INC(_runTimes);
};

//diag_log format ["Order: %1", _order];
_order
