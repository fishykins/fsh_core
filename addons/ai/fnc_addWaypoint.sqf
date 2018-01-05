/* ----------------------------------------------------------------------------
Function: fsh_fnc_addWaypoint

Description:
    A function used to add a waypoint to a group.

Parameters:
    - Group (Group or Object)
    - Position (XYZ, Object, Location or Group)

Optional:
    - Radius (Scalar)
    - Waypoint Type (String)
    - Behaviour (String)
    - Combat Mode (String)
    - Speed Mode (String)
    - Formation (String)
    - Code To Execute at Each Waypoint (String)
    - TimeOut at each Waypoint (Array [Min, Med, Max])
    - Waypoint Completion Radius (Scalar)

Example:
    (begin example)
    [this, this, 300, "MOVE", "AWARE", "YELLOW", "FULL", "STAG COLUMN", "this spawn CBA_fnc_searchNearby", [3,6,9]] call fsh_fnc_addWaypoint
    (end)

Returns:
    Waypoint

Author:
    Rommel, Fishy

---------------------------------------------------------------------------- */
#include "script_component.hpp"
#define BASE_TYPES ["MOVE","DESTROY","GETIN","SAD","JOIN","LEADER","GETOUT","CYCLE","LOAD","UNLOAD","TR UNLOAD","HOLD","SENTRY","GUARD","TALK","SCRIPTED","SUPPORT","GETIN NEAREST","DISMISS","LOITER","AND","OR"]

params [
    "_group",
    "_position",
    ["_radius", 0, [0]],
    ["_type", "MOVE", [""]],
    ["_behaviour", "UNCHANGED", [""]],
    ["_combat", "NO CHANGE", [""]],
    ["_speed", "UNCHANGED", [""]],
    ["_formation", "NO CHANGE", [""]],
    ["_onComplete", "", [""]],
    ["_timeout", [0,0,0], [[]], 3],
    ["_compRadius", 0, [0]]
];
_group = _group call CBA_fnc_getGroup;
_position = _position call CBA_fnc_getPos;

private _waypoint = _group addWaypoint [_position, _radius];
if (_type in BASE_TYPES) then {
    _waypoint setWaypointType _type;
} else {
    //could be a custom waypoint, look for it in configs.
    private _folders = configProperties [configfile >> "CfgWaypoints", "count _x > 0", true];
    private ["_i","_j"];
    for "_i" from 0 to (count _folders)-1 do {
        _folder = _folders select _i;
        private _waypointConfigs = configProperties [_folder, "count _x > 0", true];
        for "_j" from 0 to (count _waypointConfigs)-1 do {
            private _config = _waypointConfigs select _j;
            if (!(_config isEqualTo configNull)) then {
                private _cbaType = getText (_config >> "cbaType");
                if (_cbaType isEqualTO _type) then {
                    //This is an exact match, call off the search
                    _waypoint setWaypointType "SCRIPTED";
                    _waypoint setWaypointScript (getText (_config >> "file"));
                    _i = count _folders;
                    _j = count _waypointConfigs;
                } else {
                    private _displayName = getText (_config >> "displayName");
                    if (_displayName isEqualto _type && _cbaType isEqualTo "") then {
                        //No CBA Type included, but the display name matches so use this waypoint. keeps looking for "the one"
                        _waypoint setWaypointType "SCRIPTED";
                        _waypoint setWaypointScript (getText (_config >> "file"));
                    };
                };
            };
        };
    };
};

_waypoint setWaypointBehaviour _behaviour;
_waypoint setWaypointCombatMode _combat;
_waypoint setWaypointSpeed _speed;
_waypoint setWaypointFormation _formation;
_waypoint setWaypointStatements ["TRUE", _onComplete];
_waypoint setWaypointTimeout _timeout;
_waypoint setWaypointCompletionRadius _compRadius;

_waypoint
