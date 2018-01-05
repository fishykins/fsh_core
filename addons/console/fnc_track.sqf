/* ----------------------------------------------------------------------------
Function: FSH_fnc_track

Description:

Parameters:

Returns:

Example:
    (begin example)

    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_object", grpNull, [grpNull,objNull]],
    ["_level", 1, [0]],
    ["_colour", [], [[]]]
];

private _done = false;

if (_object isEqualto grpNull) exitWith {false};

private _getUnitEntry = {
    private _unit = _this;
    private _markerID = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "Icon");
    private _text = if (_level >= TRACKING_LEVEL_NAME) then {name _unit} else {""};
    [_unit, _level, _markerID, _text, _colour]
};

if (IS_OBJECT(_object)) then {
    if (count GVARMAIN(trackedObjects) > MAX_TRACK_OBJECTS) exitWith {WARNING_1("Maximum number of tracked objects reached: %1", MAX_TRACK_OBJECTS);};

    private _entry = _object call _getUnitEntry;

    for [{private _iGrps = 0}, {_iGrps < count GVARMAIN(trackedObjects)}, {INC(_iGrps)}] do {
        private _index = GVARMAIN(trackedObjects) select _iGrps;
        if ((_index select 0) isEqualto _object) then {
            //Found this group- now see if we are adding or removing
            if (_level > 0) then {
                GVARMAIN(trackedObjects) set [_iGrps, _entry];
            } else {
                GVARMAIN(trackedObjects) deleteAt _iGrps;
            };

            _iGrps = count GVARMAIN(trackedObjects) + 1;
            _done = true;
        };
    };
    if (!_done && _level > 0) then {
        if (count GVARMAIN(trackedObjects) < MAX_TRACK_OBJECTS) then {
            GVARMAIN(trackedObjects) pushBackUnique _entry;
        } else {
            WARNING_1("Maximum number of tracked objects reached: %1", MAX_TRACK_OBJECTS);
        };
    };
};

if (IS_GROUP(_object)) then {
    private _marker = (([_object] call fsh_fnc_getGroupData) select 0) select 0;
    private _markerID = getText (configfile >> "CfgMarkers" >> _marker >> "Icon");
    private _text = if (_level >= TRACKING_LEVEL_NAME) then {groupID _object} else {""};
    private _subObjects = [];

    //If we have extra tracking- track sub units too.
    if (_level >= TRACKING_LEVEL_UNITS) then {
        private _leader = leader _object;
        {
            private _unitEntry = _x call _getUnitEntry;
            if (_level < TRACKING_LEVEL_UNITS_NAMES) then {
                _unitEntry set [3, ""];
            };
            _subObjects pushBack _unitEntry;
        } forEach ((units _object) - [_leader]);

        if (_level >= TRACKING_LEVEL_UNITS_NAMES) then {
            _text = format["%1 (%2)", _text, name _leader];
        };
    };

    private _entry = [_object, _level, _markerID, _text, _colour, _subObjects];
    private _count = count GVARMAIN(trackedGroups);

    for [{private _iGrps = 0}, {_iGrps < _count}, {INC(_iGrps)}] do {
        private _index = GVARMAIN(trackedGroups) select _iGrps;
        private _compObj = _index select 0;
        if (_object isEqualto _compObj) then {
            //Found this group- now see if we are adding or removing
            diag_log str _index;
            diag_log str _level;
            if (_level > 0) then {
                GVARMAIN(trackedGroups) set [_iGrps, _entry];
            } else {
                GVARMAIN(trackedGroups) deleteAt _iGrps;
            };

            _iGrps = _count;
            _done = true;
        };
    };
    diag_log str _iGrps;
    if (!_done && _level > 0) then {
        if (count GVARMAIN(trackedGroups) < MAX_TRACK_GROUPS) then {
            GVARMAIN(trackedGroups) pushBackUnique _entry;
        } else {
            WARNING_1("Maximum number of tracked groups reached: %1", MAX_TRACK_GROUPS);
        };
    };
};

_object setVariable [QGVARMAIN(trackingLevel), _level, false];

_done
