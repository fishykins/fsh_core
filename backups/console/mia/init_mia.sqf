#include "script_component.hpp"

GVAR(miaModes) = [

];

GVAR(modes) pushBack ["MIA",[IDC_MIA_LIST_MAIN],GVAR(miaModes),IDC_MIA_FUNCSELECT];
//[QGVAR(miaMarker), [0,0], "ELLIPSE", [1, 1],"COLOR:","colorOrange"] call CBA_fnc_createMarker;


FUNC(miaListChanged) = {

};


FUNC(miaRefresh) = {
    COMPILE_UI;
    tvClear _ui_mia_list_main;
    {
        GET_MIA(_x);
        private _index = _ui_mia_list_main tvAdd [[], MIA_N];
        private _indexTasksActive = _ui_mia_list_main tvAdd [[_index], "Active Tasks"];
        private _indexTasksUnasigned = _ui_mia_list_main tvAdd [[_index], "Unasigned Tasks"];
        private _indexAreas = _ui_mia_list_main tvAdd [[_index], "Areas"];
        private _indexGroups = _ui_mia_list_main tvAdd [[_index], "Groups"];

        MIA_S(QGVAR(consoleIndex), [_index]);
        //============= TASKS (ACTIVE) =============//
        private _csi = _indexTasksActive;
        {
            private _area = _x;
            private _displayName = _x select 0;
            private _subIndex = _ui_mia_list_main tvAdd [[_index,_csi], _displayName];
            _ui_mia_list_main tvSetData [[_index,_csi,_subIndex], "task"];

        } forEach MIA_G("activeTasks", []);
        //============= TASKS (UNASIGNED) =============//
        _csi = _indexTasksUnasigned;
        {
            private _area = _x;
            private _displayName = _x select 0;
            private _subIndex = _ui_mia_list_main tvAdd [[_index,_csi], _displayName];
            _ui_mia_list_main tvSetData [[_index,_csi,_subIndex], "task"];
        } forEach MIA_G("tasks", []);
        //============= AREAS =============//
        _csi = _indexAreas;
        {
            private _area = _x;
            private _displayName = _x getVariable ["name", str (getPos _x)];
            private _subIndex = _ui_mia_list_main tvAdd [[_index,_csi], _displayName];
            _ui_mia_list_main tvSetData [[_index,_csi,_subIndex], "task"];
        } forEach MIA_G("areas", []);
        //============= GROUPS =============//
        _csi = _indexGroups;
        {
            private _area = _x;
            private _displayName = groupID _x;
            private _subIndex = _ui_mia_list_main tvAdd [[_index,_csi
            ], _displayName];
        } forEach MIA_G("groups", []);

        _ui_mia_list_main tvExpand [_index];

    } forEach GVARMAIN(MIAS);
};
