GVAR(miaModes) = [

];

//[QGVAR(miaMarker), [0,0], "ELLIPSE", [1, 1],"COLOR:","colorOrange"] call CBA_fnc_createMarker;

FUNC(miaRefresh) = {
    COMPILE_UI;
    GVAR(listMias) = [];
    GVAR(listGroups) = [];
    GVAR(listAreas) = [];
    GVAR(patrolRoutes) = [];

    tvClear _ui_main_list_left;

    {
        GET_MIA(_x);
        private _listIndex = GVAR(listMias) pushBack _x;
        private _index = _ui_main_list_left tvAdd [[], MIA_N];
        private _indexTasksActive = _ui_main_list_left tvAdd [[_index], "Active Tasks"];
        private _indexTasksUnasigned = _ui_main_list_left tvAdd [[_index], "Unasigned Tasks"];
        private _indexTasksFinished = _ui_main_list_left tvAdd [[_index], "Completed Tasks"];
        private _indexAreas = _ui_main_list_left tvAdd [[_index], "Areas"];
        private _indexGroups = _ui_main_list_left tvAdd [[_index], "Groups"];
        _ui_main_list_left tvSetData [[_index], "mia"];
        _ui_main_list_left tvSetValue [[_index], _listIndex];
        _ui_main_list_left tvSetData [[_index,_indexTasksActive], "header_task_active"];
        _ui_main_list_left tvSetData [[_index,_indexTasksUnasigned], "header_task_inactive"];
        _ui_main_list_left tvSetData [[_index,_indexAreas], "header_areas"];
        _ui_main_list_left tvSetData [[_index,_indexGroups], "header_groups"];

        MIA_S(QGVAR(consoleIndex), [_index]);
        //============= TASKS =============//
        private _csi = -1;
        {
            private _task = _x;
            private _id = _task getVariable [QEGVAR(mia,id), -1];
            private _type = _task getVariable [QEGVAR(mia,type), "unspesified task"];
            private _staus = _task getVariable [QEGVAR(mia,status), -1];
            private _displayName = format ["%1 (%2)", _type, _id];

            _csi = switch (_staus) do {
                case 0: {_indexTasksUnasigned};
                case 1: {_indexTasksActive};
                case 2; case 3: {_indexTasksFinished};
                default {-1};
            };
            if (!(_csi isEqualto -1)) then {
                private _subIndex = _ui_main_list_left tvAdd [[_index,_csi], _displayName];
                _ui_main_list_left tvSetData [[_index,_csi,_subIndex], "task"];
            };
        } forEach MIA_G("tasks", []);

        //============= AREAS =============//
        _csi = _indexAreas;
        {
            private _area = _x;
            private _areaIndex = GVAR(listAreas) pushBack _area;
            private _displayName = _x getVariable ["name", str (getPos _x)];
            private _subIndex = _ui_main_list_left tvAdd [[_index,_csi], _displayName];
            private _xIndex = [_index,_csi,_subIndex];
            _ui_main_list_left tvSetData [_xIndex, "area"];
            _ui_main_list_left tvSetValue [_xIndex, _areaIndex];

            //Add terrain points
            _subIndex = _ui_main_list_left tvAdd [_xIndex, "Points"];
            _ui_main_list_left tvSetData [_xIndex + [_subIndex], "area_pts"];
            _ui_main_list_left tvSetValue [_xIndex + [_subIndex], _areaIndex];

            //Add buildings
            _subIndex = _ui_main_list_left tvAdd [_xIndex, "Buildings"];
            private _bldIndex = +_xIndex + [_subIndex];
            _ui_main_list_left tvSetData [_bldIndex, "area_blds"];
            _ui_main_list_left tvSetValue [_bldIndex, _areaIndex];

            //Add Roads
            _subIndex = _ui_main_list_left tvAdd [_xIndex, "Roads"];
            _ui_main_list_left tvSetData [_xIndex + [_subIndex], "area_roads"];
            _ui_main_list_left tvSetValue [_xIndex + [_subIndex], _areaIndex];

            //Add patrol routes
            _subIndex = _ui_main_list_left tvAdd [_xIndex, "Patrol Routes"];
            private _yIndex = _xIndex + [_subIndex];
            _ui_main_list_left tvSetData [_yIndex, "area"];
            _ui_main_list_left tvSetValue [_yIndex, _areaIndex];
            {
                private _partolRouteIndex = GVAR(patrolRoutes) pushBack _x;
                _subIndex = _ui_main_list_left tvAdd [_yIndex, _x select 0];
                _ui_main_list_left tvSetData [_yIndex + [_subIndex], "area_patrolroute"];
                _ui_main_list_left tvSetValue [_yIndex + [_subIndex], _partolRouteIndex];
            } forEach (_area getVariable ["patrolRoutes", []]);

        } forEach MIA_G("areas", []);
        //============= GROUPS =============//
        _csi = _indexGroups;
        {
            private _groupIndex = GVAR(listGroups) pushBack _x;
            private _displayName = groupID _x;
            private _subIndex = _ui_main_list_left tvAdd [[_index,_csi], _displayName];
            private _colour = ([_x, 1] call FUNC(getObjectColour));
            _ui_main_list_left tvSetData [[_index,_csi,_subIndex], "group"];
            _ui_main_list_left tvSetValue [[_index,_csi,_subIndex], _groupIndex];
            _ui_main_list_left tvSetColor [[_index,_csi,_subIndex], _colour];
            _x setVariable [QGVAR(consoleIndex), [_index,_csi,_subIndex], false];
        } forEach MIA_G("groups", []);

        _ui_main_list_left tvExpand [_index];

    } forEach GVARMAIN(MIAS);
};

FUNC(miaUpdate) = {};

GVAR(modes) pushBack ["MIA",[IDC_MIA_LIST_MAIN], FUNC(miaRefresh), FUNC(miaUpdate)];
