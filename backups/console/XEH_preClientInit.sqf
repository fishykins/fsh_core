#include "script_component.hpp"


GVARMAIN(trackedGroups) = [];
GVARMAIN(trackedObjects) = [];
GVARMAIN(selectedGroup) = grpNull;
GVAR(waypointPath) = QPATHTOF(waypoint.paa);
GVAR(selectedGroupData) = [];

FUNC(getObjectColour) = COMPILE_FILE(fnc_getObjectColour);
FUNC(mapClicked) = COMPILE_FILE(fnc_mapClicked);

FUNC(mapMousePos) = {
    GVARMAIN(mapMousePos) = (_this select 0) ctrlMapScreenToWorld [_this select 1,_this select 2];
    //hintSilent str GVARMAIN(mapMousePos);
    private _nearest = objNull;
    private _nscore = 1000000;
    private _objects = nearestObjects [GVARMAIN(mapMousePos), ["Man"], 20];
    {
        private _dist = GVARMAIN(mapMousePos) distance (getPos _x);
        if (_dist < _nscore) then {
            _nearest = _x;
            _nscore = _dist;
        };
    } forEach _objects;
    private _group = group _nearest;
    if (_group isEqualto GVARMAIN(selectedGroup)) exitWith {};
    //New Group is selected so put the old one back to normal
    GVARMAIN(selectedGroup) setVariable [QGVAR(selected), false, false];
    GVARMAIN(selectedGroup) = _group;
    GVARMAIN(selectedGroup) setVariable [QGVAR(selected), true, false];
};

FUNC(getWaypoints) = {
    params [
        ["_group",grpNull,[grpnull]],
        ["_number",6,[0]]
    ];
    private _waypoints = [];
    if (_group isequalto grpnull) exitWith {_waypoints};
    private _cwp = currentWaypoint _group;

    {
        private _index = _x select 1;
         //diag_log format["checking %1", _index];
        if (_index >= _cwp) then {_waypoints pushBack _x;};
    } forEach (wayPoints _group);

    _waypoints resize (_number min (count _waypoints));
    _waypoints
};

call COMPILE_FILE(init_console);

call COMPILE_FILE(init_ai);
call COMPILE_FILE(init_mia);
call COMPILE_FILE(init_missionFlow);
