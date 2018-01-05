/* ----------------------------------------------------------------------------
Description:

Parameters:

Returns:

Examples:

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_name","",[""]],
    ["_groups",[],[[],grpnull]]
];

if (!(IS_ARRAY(_groups))) then {_groups = [_groups];};

GET_MIA(_name);

{
    if (IS_GROUP(_x)) then {
        MIA_PBU("groups",_x);
        [_x, "Company","_name has been assigned to company %1.", MIA_N] call fsh_fnc_aiLog;
        _x setVariable [QGVAR(commandGroup), _mia];
    };
} forEach _groups;

true
