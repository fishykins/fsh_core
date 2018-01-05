#include "script_component.hpp"

GVAR(arsenalEnabled) = true;

FUNC(open) = {
    params ["_object"];
    GVAR(object) = _object;
    createDialog QGVAR(RscArsenal);
};

FUNC(init) = {
    disableSerialization;
    private _ui = _this select 0;
    uiNamespace setVariable [QGVAR(arsenal), _ui];
    call FUNC(pullGVARS);
    GVAR(initActive) = GVAR(activeFields);
    call FUNC(refresh);
};

FUNC(exit) = {
    private _nul = [] spawn {
        call FUNC(pullGVARS);
        //If nothing has changed, dont bother updating
        //if (GVAR(initActive) isEqualto GVAR(activeFields)) exitWith {hint "no change";};
        hint "updating...";
        //Clear old stuff out
        {
            [_x,"clear",true] call fsh_fnc_arsenalGear;
            systemChat format["%1 cleared of all objects...", _x];
        } forEach GVAR(links);
        sleep 1.5;
        //re-add each class
        {
            _obj = _x;
            {
                _x params [
                    ["_dispName", "", [""]],
                    ["_dataType", "", [""]],
                    ["_data", "", ["",[]]]
                ];
                [_obj,"add",_dataType,_data,true] call fsh_fnc_arsenal;
            } forEach GVAR(activeFields);

            systemChat format["%1 refreshed", _x];
        } forEach GVAR(links);
        GVAR(object) = objNull;
        GVAR(initActive) = "";
        hint "";
    };
};

FUNC(listLeft) = {
    call FUNC(pullGVARS);
    private _index = _this select 1;
    private _selection = GVAR(dynamicFields) select _index;

    GVAR(activeFields) pushBackUnique _selection;
    GVAR(dynamicFields) = GVAR(dynamicFields) - [_selection];

    call FUNC(pushGVARS);
    call FUNC(refresh);
};

FUNC(listRight) = {
    call FUNC(pullGVARS);
    private _index = _this select 1;
    private _selection = GVAR(activeFields) select _index;

    GVAR(dynamicFields) pushBackUnique _selection;
    GVAR(activeFields) = GVAR(activeFields) - [_selection];

    call FUNC(pushGVARS);
    call FUNC(refresh);
};

FUNC(pullGVARS) = {
    GVAR(dynamicFields) = GVAR(object) getVariable [QGVAR(dynamicFields), []];
    GVAR(activeFields) = GVAR(object) getVariable [QGVAR(activeFields), []];
    GVAR(links) = GVAR(object) getVariable [QGVAR(links), []];
};

FUNC(pushGVARS) = {
    GVAR(object) setVariable [QGVAR(dynamicFields), GVAR(dynamicFields)];
    GVAR(object) setVariable [QGVAR(activeFields), GVAR(activeFields)];
};

FUNC(refresh) = {
    private _ui = uiNamespace getVariable [QGVAR(arsenal), -1];
    private _links = GVAR(object) getVariable [QGVAR(links), []];
    GVAR(dynamicFields) = GVAR(object) getVariable [QGVAR(dynamicFields), []];
    GVAR(activeFields) = GVAR(object) getVariable [QGVAR(activeFields), []];

    private _uiListLeft = _ui DisplayCtrl IDC_LIST_LEFT;
    private _uiListRight = _ui DisplayCtrl IDC_LIST_RIGHT;

    lbClear _uiListLeft;
    lbClear _uiListRight;

    {
        private _displayName = _x select 0;
        _uiListLeft lbAdd format["%1", _displayName];
    } forEach GVAR(dynamicFields);

    {
        private _displayName = _x select 0;
        _uiListRight lbAdd format["%1", _displayName];
    } forEach GVAR(activeFields);

    //_uiListLeft lbSetCurSel -1;
    //_uiListRight lbSetCurSel -1;
};

FUNC(enable) = {
    params ["_controller","_enabled"];
    _controller setVariable [QGVAR(enabled), _enabled, true];
    private _links = _controller getVariable [QGVAR(links), []];
    private _activeFields = _controller getVariable [QGVAR(activeFields), []];
    {
        _x setVariable [QGVAR(enabled), _enabled, true];
        [_x,[], true, _enabled] call BIS_fnc_addVirtualItemCargo;

        if (!_enabled) then {
            [_x,"clear",true] call fsh_fnc_arsenalGear;
            systemChat format["%1 disabled", _x];
        } else {
            _obj = _x;
            {
                _x params [
                    ["_dispName", "", [""]],
                    ["_dataType", "", [""]],
                    ["_data", "", ["",[]]]
                ];
                [_obj,"add",_dataType,_data,true] call fsh_fnc_arsenal;
            } forEach _activeFields;
            systemChat format["%1 enabled", _x];
        };
    } forEach _links;


};
