#include "script_component.hpp"

#include "sm_group.sqf";
#include "sm_area.sqf";

FUNC(sm_miaRefresh) = {
    params ["_ctrl","_index"];
    private _miaIndex = _ctrl tvValue _index;
    GVAR(selected) = GVAR(listMias) select _miaIndex;
    GET_MIA(GVAR(selected));
    private _uid = MIA_G("uid", -1);

    {
        private _name = format ["%1_%2", _x, _forEachIndex];
        private _status = _x getVariable [MIA_VAR("owner"), 0];
        private _color = switch (_status) do {
            case 0: {"ColorEAST"};
            case 1: {"ColorWEST"};
            default {"ColorGrey"};
        };
        private _alpha = 0.25 + (random (0.05));
        private _size = size _x;
        private _m = [_name, getPos _x, "RECTANGLE", _size,"COLOR:",_color] call CBA_fnc_createMarker;
        _m setMarkerAlpha _alpha;
        GVAR(tempMarkers) pushBack _m;
    } forEach GVARMAIN(gridPoints);
};

GVAR(subModes) pushBack ["mia",[],FUNC(sm_miaRefresh)];
