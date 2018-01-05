#include "script_component.hpp"

params [
    "_pos",
    "_class",
    ["_colour", "colorBlue", [""]],
    ["_distance", 50, [0]]
];

private _object = objNull;

private _nearRoads = (_pos nearRoads _distance) select {(position _x) distance (nearestBuilding (position _x)) > 9 && (count (roadsConnectedTo _x)) isEqualto 2};

if (!(_nearRoads isEqualto [])) then {
    private _road = selectRandom _nearRoads;

    [format ["%1_%2_guide", _class, _pos],getPos _road,"ICON",[0.3,0.3],"COLOR:",_colour,"TYPE:","MIL_DOT"] call CBA_fnc_createMarker;

    private _roadDir = [_road] call fsh_fnc_getRoadDir;
    private _offset = 5 + random(2);

    //This only works on old maps- vanilla a3 roads dont have a direction?!
    //private _pos = _road getRelPos [selectRandom [0 - _offset, _offset], selectRandom [-90, 90]];
    private _pos = _road getPos [selectRandom [-_offset, _offset], _roadDir + (selectRandom [-90, 90])];

    //(_pos isFlatEmpty [SAFE_RANGE, -1, -1, -1, -1, false, _road]) isEqualTo []

    private _nearestObjects = (nearestTerrainObjects [_pos, ["Tree","FENCE", "WALL", "BUILDING"], 5]);

    if (_nearestObjects isEqualto []) exitWith {

        //No obstructions- spawn vehicle!
        _object = ([_pos, _class, false, _roadDir] call FSH_fnc_spawnVehicle) select 0;
        private _m = [format ["%1_%2", _class, _pos],_pos,"ICON",[1,1],"COLOR:",_colour,"TYPE:","MIL_DOT"] call CBA_fnc_createMarker;
    };

    //Failed!
    [format ["%1_%2", _class, _pos],_pos,"ICON",[0.75,0.75],"COLOR:","colorRed","TYPE:","MIL_DOT"] call CBA_fnc_createMarker;
};

_object
