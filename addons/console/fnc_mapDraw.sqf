/* ----------------------------------------------------------------------------
Function: FSH_fnc_mapDraw

Description:
    A function to run on each frame and draw icons on given map.
    Ugly and fast

Parameters:
    0: Map control
    1: array of arrays defining groups to draw. Sub array looks like:
        0: group
        1: tracking level (int)
        2: marker path (str)
        3: text
        4: colour
        5: array of sub icons to draw (see bellow format)
        6: all units (reserved by other functions)
    2: array of arrays defining units to draw.
        0: unit
        1: tracking level (int)
        2: marker path (str)
        3: text
        4: colour
Returns:

Example:
    (begin example)
        ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["draw",{[_this select 0, +GVARMAIN(trackedGroups), +GVARMAIN(trackedObjects)] call fsh_fnc_mapDraw}];
    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    "_map",
    "_groups",
    "_units"
];

private _zoom = (ctrlMapScale _map);
private _textSize = TEXT_SIZE_C min TEXT_SIZE_L/_zoom;
private _iconSize = ICON_SIZE_GROUPS_C min ICON_SIZE_GROUPS/_zoom;

private _vehicles = [];

//------ GROUPS -------//
{
    //10 groups- 60 fps. Winner!
    _x params [
        "_object",
        "_level",
        "_markerID",
        "_text",
        ["_colour", [],[[]]],
        ["_subunits",[],[[]]]
    ];

    //-------------------------------------------------------------//
    //-------------------------------------------------------------//

    //10 groups - 40fps.
/*
    private _object = _x select 0;
    private _level = _object getVariable [QGVARMAIN(trackingLevel), 0];
    private _markerID = getText (configfile >> "CfgMarkers" >> ((([_object] call fsh_fnc_getGroupData) select 0) select 0) >> "Icon");
    private _colour = +([_object, GVAR(colourMode)] call FUNC(getObjectColour));
    private _text = if (_level >= TRACKING_LEVEL_NAME) then {groupID _object} else {""};
*/
    //-------------------------------------------------------------//
    //-------------------------------------------------------------//
    private _leader = leader _object;
    private _origin = visiblePosition _leader;
    /*
    private _sx = 0;
    private _xy = 0;
    {
        private _p = visiblePosition _x;
        ADD(_sx, (_p select 0));
        ADD(_sy, (_p select 1));
    } forEach units _object;

    private _c = count (units _object);
    _origin = [_sx/_c,_sy/_c,0];
*/
    _origin set [1, (_origin select 1) +10]; //Move icon up a bit for leaders sake

    if (_colour isEqualto []) then {
        _colour = +([_object, GVAR(colourMode)] call FUNC(getObjectColour));
    };
    if (_object getVariable [QGVAR(selected), false]) then {
        _colour = [(_colour select 0) + 0.2, (_colour select 1) + 0.2, (_colour select 2) + 0.2, 1];
    };

    _map drawIcon [
        _markerID,
        _colour,
        _origin,
        _iconSize,
        _iconSize,
        0,
        _text,
        false,
        _textSize
    ];

    //Draw a line to subunits
    {
        private _pos = visiblePosition (_x select 0);
        _map drawLine [_origin, _pos, _colour];
    } forEach _subunits;
    //_units append _subunits;

    //Draw waypoints, becauase no one likes framerates anyway
    {
        private _pos = getWpPos _x;
        _map drawLine [_origin, _pos, _colour];
        _map drawIcon [QPATHTOF(waypoint.paa),_colour, _pos, _iconSize*0.7,_iconSize*0.7, 0, str (_forEachIndex + 1), false, _textSize*0.7];
        _origin = _pos;
    } forEach (_object call fsh_fnc_getWaypoints);
} forEach _groups;

//------ OBJECTS -------//
{
    _x params [
        "_object",
        "_trackLevel",
        "_markerID",
        "_text",
        ["_colour", [],[[]]]
    ];
    if (_colour isEqualto []) then {
        _colour = [_object, GVAR(colourMode)] call FUNC(getObjectColour);
    };
    if (_object isEqualto (vehicle _object)) then {
        _map drawIcon [
            _markerID,
            _colour,
            visiblePosition _object,
            _iconSize,
            _iconSize,
            direction _object,
            _text,
            false,
            _textSize/2
        ];
    } else {
        _vehicles pushBackunique (vehicle _object);
    };
} forEach _units;

//------ VEHICLES -------//
{
    private _colour = [driver _x, GVAR(colourMode)] call FUNC(getObjectColour);
    private _text = "";
    {
        if (_text isEqualto "") then {
            _text = name _x;
        } else {
            _text = format ["%1, %2", _text, name _x];
        };
    } forEach (crew _x);
    _text splitString " " joinString ", ";
    _map drawIcon [
        getText (configFile/"CfgVehicles"/typeOf _x/"Icon"),
        _colour,
        visiblePosition _x,
        _iconSize,
        _iconSize,
        direction _x,
        _text,
        false,
        _textSize/3
    ];
} forEach _vehicles;

//------ ECLIPSES ------//
/*
{
    _x params [
        "_c",
        "_a",
        "_b",
        "_angle",
        ["_colour", [],[[]]],
        ["_fill", ""]
    ];

    _map drawEllipse [_c, _a, _b, _angle, _colour, _fill];

} forEach _circles;
*/
