/* ----------------------------------------------------------------------------
Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

COMPILE_UI;
GVAR(showSubs) = false;
GVAR(subMode) = 0;

call FUNC(update);

//Update Groups
tvClear _ui_ai_list_main;
private _allGroups = [];

switch (toLower ((GVAR(modes) select GVAR(mode)) select 0)) do {
    case "linked groups": {
        {
            if ((side _x) isEqualTo (side player)) then {
                _allgroups pushBack _x;
            };
        } forEach allgroups;
    };
    case "all groups": {
        _allGroups = allgroups;
    };
    case "mia": {
        call FUNC(miaRefresh);
        _allGroups = allgroups;
    };
};
GVAR(groups) = [];
{
    private _marker = (([_x] call fsh_fnc_getGroupData) select 0) select 0;
    private _markerID = getText (configfile >> "CfgMarkers" >> _marker >> "Icon");
    private _text = if (GVAR(trackingMode) >= 4) then {groupID _x} else {""};
    private _colour = [_x, GVAR(colourMode)] call FUNC(getObjectColour);
    private _leader = leader _x;
    private _units = units _x;
    private _unitsDraw = [];

    if (GVAR(trackingMode) >= 5) then {
        {
            private _unitMarkerID = getText (configFile >> "CfgVehicles" >> typeOf _x >> "Icon");
            private _unitText = if (GVAR(trackingMode) >= 6) then {name _x} else {""};
            private _unitColour = [0,0,1,0.7];
            _unitsDraw pushBack [_x, GVAR(trackingMode), _unitMarkerID, _unitText];
        } forEach ((units _x) - [_leader]);
    };
    GVAR(groups) pushBack [_x, GVAR(trackingMode), _markerID, _text, [], _unitsDraw, _units];

    //Add to list
    private _index = _ui_ai_list_main tvAdd [[], groupID _x];
    _x setVariable [QGVAR(consoleIndex), [_index], false];
    _ui_ai_list_main tvSetData [[_index], "group"];
    _ui_ai_list_main tvSetColor [[_index], _colour];
    {
        private _subIndex = _ui_ai_list_main tvAdd [[_index], name _x];
        _x setVariable [QGVAR(consoleIndex), [_index,_subIndex], false];
        _ui_ai_list_main tvSetData [[_index,_subIndex], "unit"];
    } forEach _units;
} forEach _allGroups;

//Clear text field
m ctrlSetText "";
