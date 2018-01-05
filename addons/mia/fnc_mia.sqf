/* ----------------------------------------------------------------------------
Function: fsh_fnc_mia

Description:

Parameters:

Returns:

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_miaName","",["",objNull]],
    ["_function","",[""]]
];

private _output = +_this;
REM(_output, _function);

switch (_function) do {
    case "init": {_output call FUNC(init);};
    case "addGroup": {_output call FUNC(addGroup);};
    case "addArea": {_output call FUNC(addArea);};
};
