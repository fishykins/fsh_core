#include "script_component.hpp"

params [
    "_building",
    "_class",
    ["_colour", "colorBlue", [""]],
    ["_offset", 0, [0]]
];

private _pos = _building getRelPos [_offset, 0]; _pos set [2, 0.3];
private _dir = getDir _building;

if (typeof _building in BACKWARDS_HANGARS) then {_dir = _dir + 180;};

if ((_pos isFlatEmpty [SAFE_RANGE, -1, -1, -1, -1, false, _building]) isEqualTo []) exitWith {
    [format ["%1_%2", _class, _pos],_pos,"ICON",[0.75,0.75],"COLOR:","colorRed","TYPE:","MIL_DOT"] call CBA_fnc_createMarker;
};

_object = ([_pos, _class, false, _dir] call FSH_fnc_spawnVehicle) select 0;

[format ["%1_%2", _class, _pos],_pos,"ICON",[1,1],"COLOR:",_colour,"TYPE:","MIL_DOT"] call CBA_fnc_createMarker;

_object
