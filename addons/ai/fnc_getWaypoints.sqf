#include "script_component.hpp"

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
