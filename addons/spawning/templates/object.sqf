#include "script_component.hpp"

params [
    "_parentObj",
    "_class",
    ["_Offset", [0,0,0], [[]]],
    ["_relDir", 0, [0]],
    ["_simple", false, [false]],
    ["_colour", "none", [""]]

];

private _pos = _parentObj modelToWorld _Offset;
private _isSimple = if (_simple) then {"SIMPLE"} else {""};

private _object = ([_pos, _class, false, getDir _building + _relDir, _isSimple] call FSH_fnc_spawnVehicle) select 0;

if (_colour isEqualto "none") exitWith {_object};

[format ["%1_%2", _class, _pos],_pos,"ICON",[1,1],"COLOR:",_colour,"TYPE:","MIL_DOT"] call CBA_fnc_createMarker;

_object
