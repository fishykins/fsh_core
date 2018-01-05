/* ----------------------------------------------------------------------------
Description:

Parameters:

Returns:

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_name","",[""]]
];

//Check name is valid and unique
private _nsc = _name call fsh_fnc_getMia;
if (!(_nsc isEqualto objNull)) exitWith {false};

//Create MIA
SPAWN_MIA(_name);
private _uid = GVAR(miaID); INC(GVAR(miaID));

//Create a link from the name to the object
GVAR(namespace) setVariable [_name, _mia];

//Add to list
private _array = +GVARMAIN(MIAS);
_array pushBackUnique _mia;
GVARMAIN(MIAS) = +_array;

//Setup values
MIA_S("name", _name);
MIA_S("uid", _uid);
MIA_S("isMIA", true);
MIA_S("area", []);
MIA_S("groups", []);
MIA_S("areaIndex", 0);
MIA_S("activeGrids", []);

[_mia] execFSM FUNC(miaFSM);

_mia
