/* ----------------------------------------------------------------------------
Function: FSH_fnc_trackGroup

Description:
    starts tracking this group on the map

Parameters:
    GROUP- the group to track
    INT- level of detail to show.

Returns:
    nil

Example:
    (begin example)

    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
#define MOUSE_DISTANCE 20
#define DETAIL_NAME 2
#define DETAIL_FIRSTWAYPOINT 3
#define DETAIL_FULL 4
#define ICON_UNIT "mil_dot"

private _null = _this spawn {
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    params [
        ["_group",grpNull,[grpNull,objNull]],
        ["_trackingDetail",2,[0]]
    ];

    _group = [_group] call cba_fnc_getGroup;
    private _groupID = str _group; //A permenant id so when the groups id changes we can still refference stuff
    if (!(IS_GROUP(_group))) exitWith {nil};

    _group setVariable [QGVAR(trackingLevel), _trackingDetail, false];
    private _groupTracking = _group getVariable [QGVAR(isTracking), false];
    if (_groupTracking) exitWith {nil};
    //-----------------------------------------------------------------------------

    _group setVariable [QGVAR(isTracking), true, false];

    private _units = units _group;
    private _leader = leader _group;
    private _subordiantes = _units - [_leader];
    private _unitsAlive = count _units;
    private _side = side _leader;

    private _markerData = ([_group] call fsh_fnc_getGroupData) select 0;
    private _markerColor = _markerData select 1;
    private _markerType = _markerData select 0;
    ///////////////////////////////////////////////////////

    private _allMarkers = [];
    private _waypointMarkers = [];

    {
        private _marker = ([str _x, getPos _x, "ICON", [1, 1],"TYPE:",ICON_UNIT,"COLOR:",_markerColor] call CBA_fnc_createMarker);
        private _markerLine = ([format["%1_line",_x], getPos _x, "RECTANGLE", [0.1, 10],"COLOR:",_markerColor] call CBA_fnc_createMarker);
        _allMarkers pushBack _marker;
        _allMarkers pushBack _markerLine;
        _x setVariable ["mia_trackGroup_markers", [_marker, _markerLine], false];
    } forEach _units;

    private "_i";
    for "_i" from 0 to 10 do {
        private _waypointmarker = format["%1_wp_%2",_groupID, _i];
        private _waypointmarkerLine = format["%1_wp_%2_line",_groupID, _i];

        _waypointMarkers pushBack ([_waypointmarker, [0,0], "ICON", [1,1],"COLOR:","colorBlack","TYPE:","mil_destroy"] call CBA_fnc_createMarker);
        _waypointMarkers pushBack ([_waypointmarkerLine, [0,0], "RECTANGLE", [1,1],"COLOR:","colorBlack"] call CBA_fnc_createMarker);
    };

    if (isNil "fsh_mousePos") then {
        fsh_mousePos = [0,0];
        _null = [] spawn {
            waitUntil {!(isNull (findDisplay 12))};
            _index = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler [
                "MouseMoving", {
                    fsh_mousePos = (_this select 0) ctrlMapScreenToWorld [_this select 1,_this select 2];
                }
            ];
        };
    };

    ///////////////////////////////////////////////////////
    //                    Start Loop                     //
    ///////////////////////////////////////////////////////

    while {_unitsAlive > 0 && _trackingDetail > 0} do {
        private _sleepTime = 2;
        if (visibleMap || GVAR(map)) then {
            _units = units _group;
            _leader = leader _group;
            _subordiantes = _units - [_leader];
            _unitsAlive = count _units;
            _trackingDetail = _group getVariable [QGVAR(trackingLevel), 0];
            _sleepTime = 1;

            private _alpha = 0.5;
            private _text = ""; if (_trackingDetail >= DETAIL_NAME) then {_text = groupId _group};

            //Waypoints
            _currentWaypoint = currentWaypoint _group;
            _allWaypoints = count (wayPoints _group);

            if (fsh_mousePos distance2D getPos _leader < MOUSE_DISTANCE || _trackingDetail >= DETAIL_FULL) then {
                //Moused over so draw lots of info
                _sleepTime = 0.05;
                _alpha = 1;
                _text = groupId _group;

                {
                    if (alive _x) then {
                        if (driver (vehicle _x) == _x) then {
                            private _unitMarkers = _x getVariable ["mia_trackGroup_markers", ["",""]];
                            private _marker = (_unitMarkers select 0);
                            private _line = (_unitMarkers select 1);
                            _marker setmarkerPos (getPos _x);
                            _marker setmarkerAlpha _alpha;

                            _line setmarkerAlpha _alpha;
                            _posX = ((getPos (_leader) select 0) + (getPos (_x) select 0))/2;
                            _posY = ((getPos (_leader) select 1) + (getPos (_x) select 1))/2;
                            _line setmarkerPos [_posX, _posY];
                            _line setMarkerDir (_x getDir _leader);
                            _line setMarkerSize [0.1,(_x distance2D _leader)/2];
                        };
                    } else {deleteMarker (str _x)};
                } forEach _subordiantes;

                //Waypoint markers
                private _j = 0;

                if !(_currentWaypoint >= _allWaypoints) then {
                    for [{private _i = _currentWaypoint},{_i < _allWaypoints},{INC(_i); INC(_j)}] do {
                        private _waypointmarker = format["%1_wp_%2",_groupID, _j];
                        private _waypointmarkerLine = format["%1_wp_%2_line",_groupID, _j];

                        private _lineStartPos = getPos _leader;
                        private _waypointPos = getWPPos [_group,_i];
                        if (_i > _currentWaypoint) then {_lineStartPos = getWPPos [_group,_i -1];};

                        _waypointmarker setMarkerPos _waypointPos;
                        _waypointmarker setMarkerText waypointType [_group,_i];
                        _waypointmarker setMarkerAlpha _alpha;

                        _waypointmarkerLine setMarkerPos [((_waypointPos select 0) + (_lineStartPos select 0))/2,((_waypointPos select 1) + (_lineStartPos select 1))/2];
                        _waypointmarkerLine setMarkerSize [0.5,(_lineStartPos distance2D _waypointPos)/2];
                        _waypointmarkerLine setMarkerDir (_lineStartPos getDir _waypointPos);
                        _waypointmarkerLine setMarkerAlpha _alpha;
                    };
                };
            } else {
                //Not selected so only draw basic info
                {
                    private _unitMarkers = _x getVariable ["mia_trackGroup_markers", ["",""]];
                    private _marker = (_unitMarkers select 0);
                    private _line = (_unitMarkers select 1);
                    if (alive _x) then {
                        _marker setmarkerAlpha 0;
                        _line setmarkerAlpha 0;
                    } else {
                        deleteMarker _marker;
                        deletemarker _line;
                    };
                } forEach _subordiantes;

                {
                    _x setMarkerAlpha 0;
                } forEach _waypointMarkers;

                //Draw the first waypoint marker
                if (_trackingDetail >= DETAIL_FIRSTWAYPOINT && _currentWaypoint >= _allWaypoints && _allWaypoints > 0) then {
                    private _waypointmarker = format["%1_wp_0",_groupID];
                    private _waypointmarkerLine = format["%1_wp_0_line",_groupID];

                    private _lineStartPos = getPos _leader;
                    private _waypointPos = getWPPos [_group,_currentWaypoint];

                    _waypointmarker setMarkerPos _waypointPos;
                    _waypointmarker setMarkerText waypointType [_group,_currentWaypoint];
                    _waypointmarker setMarkerAlpha _alpha;

                    _waypointmarkerLine setMarkerPos [((_waypointPos select 0) + (_lineStartPos select 0))/2,((_waypointPos select 1) + (_lineStartPos select 1))/2];
                    _waypointmarkerLine setMarkerSize [0.5,(_lineStartPos distance2D _waypointPos)/2];
                    _waypointmarkerLine setMarkerDir (_lineStartPos getDir _waypointPos);
                    _waypointmarkerLine setMarkerAlpha _alpha;
                };
            };

            private _unitMarkers = _leader getVariable ["mia_trackGroup_markers", ["",""]];
            private _marker = (_unitMarkers select 0);
            private _line = (_unitMarkers select 1);
            _marker setmarkerPos getPos _leader;
            _marker setmarkerType _markerType;
            _marker setmarkerAlpha _alpha;
            _marker setmarkerText _text;
            _line setMarkerAlpha 0;
        };
        sleep _sleepTime;
    };

    ///////////////////////////////////////////////////////
    //                     End Loop                      //
    ///////////////////////////////////////////////////////
    _group setVariable [QGVAR(isTracking), false, false];

    {
        deleteMarker _x;
    } forEach _allMarkers;

    {
        deleteMarker _x;
    } forEach _waypointMarkers;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
};

true
