FUNC(sm_areaRefresh) = {
    params ["_ctrl","_index"];
    private _areaIndex = _ctrl tvValue _index;
    GVAR(selected) = GVAR(listAreas) select _areaIndex;
    private _area = GVAR(selected) getVariable ["area", []];
    _area params [
        "_areaPos",
        "_areaSizeA",
        "_areaSizeB",
        "_areaDirection",
        "_isRectangle"
    ];

    //Create Markers
    private _style = if (_isRectangle) then {"RECTANGLE"} else {"ELLIPSE"};
    [QGVAR(areaPerimiter),_areaPos,_style,[_areaSizeA, _areaSizeB],"COLOR:","colorOrange","BRUSH:","Border"] call CBA_fnc_createMarker;
    QGVAR(areaPerimiter) setMarkerDir _areaDirection;
    GVAR(tempMarkers) pushBack QGVAR(areaPerimiter);
};


FUNC(sm_areaRefreshPoints) = {
    _this call FUNC(sm_areaRefresh);
    private _positions = GVAR(selected) getVariable ["terrainPoints", []];
    {
        _x params [
            ["_pos", []],
            ["_score", 0]
        ];

        private _text = format ["%1: %2", _forEachIndex, _score];
        private _colour = "colorRed";
        if (_score > 100) then {_colour = "colorOrange";};
        if (_score > 200) then {_colour = "colorYellow";};
        if (_score > 300) then {_colour = "colorBlue";};
        if (_score > 400) then {_colour = "colorGreen";};


        private _marker = [str _pos, _pos, "ICON",[0.5, 0.5],"COLOR:",_colour,"TYPE:","mil_dot","TEXT:", _text] call CBA_fnc_createMarker;
        GVAR(tempMarkers) pushBack _marker;

    } forEach _positions;
};

FUNC(sm_areaRefreshRoads) = {
    _this call FUNC(sm_areaRefresh);
    private _junctions = GVAR(selected) getVariable ["junctions", []];
    private _edges = GVAR(selected) getVariable ["edgeRoads", []];
    {
        private _marker = [str _x, getPos _x, "ICON",[1, 1],"COLOR:", "colorBlue","TYPE:","mil_dot"] call CBA_fnc_createMarker;
        GVAR(tempMarkers) pushBack _marker;
    } forEach _junctions;
    {
        private _marker = [str _x, getPos _x, "ICON",[1, 1],"COLOR:", "colorRed","TYPE:","mil_dot"] call CBA_fnc_createMarker;
        GVAR(tempMarkers) pushBack _marker;
    } forEach _edges;
};

FUNC(sm_areaRefreshBuildings) = {
    _this call FUNC(sm_areaRefresh);
    private _buildings = GVAR(selected) getVariable ["buildings", []];
    private _centralBuilding = GVAR(selected) getVariable ["centralBuilding", objNull];
    {
        //[str _x,getPos _x,"RECTANGLE",[2, 2],"COLOR:","colorOrange","BRUSH:","Border"] call CBA_fnc_createMarker;
        [_x, 1, [0,0,0,1]] call fsh_fnc_track;
        GVAR(tempTracked) pushBackUnique _x;
    } forEach _buildings;

    [_centralBuilding, 1, [1,1,0,1]] call fsh_fnc_track;
    GVAR(tempTracked) pushBackUnique _centralBuilding;
};

FUNC(sm_areaRefreshPatrolRoutes) = {

    params ["_ctrl","_index"];
    private _index = _ctrl tvValue _index;
    private _route = GVAR(patrolRoutes) select _index;
    _route params ["_name","_points"];
    {
        private _text = str _forEachIndex;
        private _marker = [format ["%1_%2", _name, _x], _x, "ICON",[1, 1],"COLOR:", "colorBlue","TYPE:","mil_dot","TEXT:", _text] call CBA_fnc_createMarker;
        GVAR(tempMarkers) pushBack _marker;
    } forEach _points;
};

GVAR(subModes) pushBack ["area",[],FUNC(sm_areaRefresh)];
GVAR(subModes) pushBack ["area_pts",[],FUNC(sm_areaRefreshPoints)];
GVAR(subModes) pushBack ["area_blds",[],FUNC(sm_areaRefreshBuildings)];
GVAR(subModes) pushBack ["area_roads",[],FUNC(sm_areaRefreshRoads)];
GVAR(subModes) pushBack ["area_patrolroute",[],FUNC(sm_areaRefreshPatrolRoutes)];
