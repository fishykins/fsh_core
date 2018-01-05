/* ----------------------------------------------------------------------------
Function: FSH_fnc_arsenalController

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

params [
    ["_object", "", [objNull]],
    ["_function", "", [""]],
    ["_data", "", ["",[]]]
];

if (_object isequalTo ObjNull) exitWith {WARNING("no object provided!");};
_function = toLower _function;
if (IS_STRING(_data)) then {_data = [_data];};
//==============================================//
switch (_function) do {
    case ("init"): {
        private _actionInit = ["fshArsenal","Arsenal","",{},{true},{},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction;
        private _actionMods = ["fshArsenalMods","Modules","",{[_target] call fsh_core_arsenal_fnc_open;},{(_target getVariable [QGVAR(enabled), DEFAULT_ENABLED])},{},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction;
        private _actionOn = ["fshArsenalOn","Enable","",{[_target, true] call FUNC(enable);},{!(_target getVariable [QGVAR(enabled), DEFAULT_ENABLED])},{},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction;
        private _actionOff = ["fshArsenalOff","Disable","",{[_target, false] call FUNC(enable);},{(_target getVariable [QGVAR(enabled), DEFAULT_ENABLED])},{},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction;

        [_object, 0, [], _actionInit] call ace_interact_menu_fnc_addActionToObject;
        [_object, 0, ["fshArsenal"], _actionMods] call ace_interact_menu_fnc_addActionToObject;
        [_object, 0, ["fshArsenal"], _actionOn] call ace_interact_menu_fnc_addActionToObject;
        [_object, 0, ["fshArsenal"], _actionOff] call ace_interact_menu_fnc_addActionToObject;
    };
    case ("add"): {
        private _dynamicFields = _object getVariable [QGVAR(dynamicFields), []];
        _dynamicFields pushBackUnique _data;
        _object setVariable [QGVAR(dynamicFields), _dynamicFields];
    };
    case ("remove"): {
        private _dynamicFields = _object getVariable [QGVAR(dynamicFields), []];
        _dynamicFields = _dynamicFields - [_data];
        _object setVariable [QGVAR(dynamicFields), _dynamicFields];
    };
    case ("link"): {
        private _links = _object getVariable [QGVAR(links), []];
        {_links pushBackUnique _x} forEach _data;
        _object setVariable [QGVAR(links), _links];
    };
    case ("unlink"): {
        private _links = _object getVariable [QGVAR(links), []];
        _links = _links - _data;
        _object setVariable [QGVAR(links), _links];
    };
};
