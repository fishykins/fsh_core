/* ----------------------------------------------------------------------------
Function: FSH_fnc_getGroupData

Description:
    returns useful data about the given group (see returns).

Parameters:
    group- can be unit, group, config name, or config.

Returns:
    0. Array of marker details
    1. Side (numerical)
    2. Array of group types
    3. Number of units in group
    4. Vehicle types in group

Example:
    (begin example)
        _data = [configGroup] call FSH_fnc_getGroupData;
    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
private _startTime = diag_tickTime;
params [
    ["_data", grpNull, ["",grpNull,objNull,configNull]]
];
private _exit = false;
//-----------Return params-------------
private _marker = "n_unknown";
private _markerPrefix = "n";
private _markerSuffix = 'unknown';
private _markerColor = "colorGUER";
private _markerScore = -1; //The score for current marker detailis. Allows for overwriting
private _side = civilian;
private _groupTypes = [];
private _return = [[_marker,_markerColor], _side, _groupTypes];
//-------------------------------------
private _group = grpnull;
private _units = [];
private _vehicles = [];
private _unitTypes = [];
private _vehicleParents = [];
private _vehicleCount = 0;
private _hasArtillery = 0;
private _allTypes = [];

if (_data isEqualTo grpNull) exitWith {_return};

//=================================================================================
//=========================== GATHER INFO ON VEHICLE ==============================
//=================================================================================

if (IS_OBJECT(_data) || IS_GROUP(_data)) then {
    _group = [_data] call cba_fnc_getGroup;

    private _nsEntry = _group getVariable [QGVAR(types), "undefined"];
    if (!(_nsEntry isEqualTo "undefined")) exitWith {_exit = true; _return = _nsEntry;};

    private _leader = leader _group;
    _units = units _group;
    _side = side _leader;
    {
        //private _vehicle = vehicle _x;
        //private _Role = (assignedVehicleRole _x);
        private _vehicle = assignedVehicle _x;


        //Only add vehicle if unit is not a passanger
        if (_vehicle isEqualto objNull || !((driver _vehicle) isEqualto _x)) then {
            private _types = (([_x] call fsh_fnc_getVehicleData) select 0);
            _unitTypes pushBack _types;
            {_allTypes pushBackUnique _x;} forEach _types;
        } else {

            if (! (_vehicle in _vehicles)) then {
                _vehicles pushBackunique _vehicle;
                private _types = (([_vehicle] call fsh_fnc_getVehicleData) select 0);
                _unitTypes pushBack _types;
                {_allTypes pushBackUnique _x;} forEach _types;
            };
        };
    } forEach _units;

    _units apply {typeOf _x};

} else {
    private _nsEntry = GROUP_GNS(_data,"types","undefined");
    if (!(_nsEntry isEqualTo "undefined")) exitWith {_exit = true; _return = _nsEntry;};

    private _groupConfig = [_data] call fsh_fnc_getGroupConfig;
    _side = getNumber (_groupConfig >> "side");
    private _unitArray = configProperties [_groupConfig, "count _x > 0", true];
    {
        private _vehicle = getText(_x >> "vehicle");
        private _vehicleConfig = [_vehicle] call CBA_fnc_getObjectConfig;
        _units pushBack _vehicle;
        private _types = (([_vehicleConfig] call fsh_fnc_getVehicleData) select 0);
        _unitTypes pushBack _types;
        {_allTypes pushBackUnique _x;} forEach _types;
    } forEach _unitArray;

    SWITCH_SIDE(_side,civilian);
};

if (_exit) exitWith {_return};

//==========================================================================================
//=================================== DEFINE CHECKS ========================================
//==========================================================================================
#define CALL_NEXT   INC(_runningPos); if (_runningPos < count _runningOrder) then  {call (_runningOrder select _runningPos);} else {call _passed;}
//Function to call if type requirements are passed.
private _passed = {
    private _catMarkerPriority = getNumber (_cfg >> "markerPriority");
    if (_catMarkerPriority >= _markerScore) then {
        private _catMarkerPrefix = getText (_cfg >> "markerPrefix");
        private _catMarkerSufix = getText (_cfg >> "markerSuffix");
        private _catMarkerColor = getText (_cfg >> "markerColor");
        _markerScore = _catMarkerPriority;
        if (!(_catMarkerPrefix isEqualTo "")) then {_markerPrefix = _catMarkerPrefix;};
        if (!(_catMarkerSufix isEqualTo "")) then {_markerSuffix = _catMarkerSufix;};
        if (!(_catMarkerColor isEqualTo "")) then {_markerColor = _catMarkerColor;};
    };
    private _typeName = getText (_cfg >> "typename");
    if (!(_typeName isequalto "")) then {
        _groupTypes pushBackUnique _typeName;
    };

    if (_switch > 0) then {_ci = count _subCats;};
};

private _checkSide = {
    private _catSide = getNumber (_cfg >> "side");
    //Check to see if side spesific- if so, just check this and move on.
    if (_catSide >= 0) then {
        SWITCH_SIDE(_catSide,resistance);
        if (_catSide isEqualTo _side) then {
            call _passed;
        };
    } else {
        CALL_NEXT;
    };
};

private _checkCount = {
    private _count = getArray (_cfg >> "count");
    if ((count _units >= _count select 0) && (_count select 1 < 0 || _count select 1 >= count _units)) then {
        CALL_NEXT;
    };
};

private _checkWlTypes = {
    private _wlTypes = getArray (_cfg >> "wlTypes");
    if (_wlTypes isEqualto []) then {
        CALL_NEXT;
    } else {
        private _threshold = (getArray (_cfg >> "thresholdTypes")) select 0;
        if (_threshold < 0 || _threshold > count _wlTypes) then {_threshold = count _wlTypes;};
        if (count (_wlTypes arrayIntersect _allTypes) >= _threshold) then {
            CALL_NEXT;
        };
    };
};

private _checkBlTypes = {
    private _blTypes = getArray (_cfg >> "blTypes");
    if (_blTypes isEqualto []) then {
        CALL_NEXT;
    } else {
        private _threshold = ((getArray (_cfg >> "thresholdTypes")) select 1) max 0;
        if (count (_blTypes arrayIntersect _allTypes) <= _threshold) then {
            CALL_NEXT;
        };
    };
};

//Checks spesific class types, such as "Man" and "apc" for mechanized infantry
private _checkSubs = {
    private _children = configProperties [_cfg, "count _x > 0",true];
    if (_children isEqualto []) then {
        CALL_NEXT;
    } else {
        //Check each subtype.
        private _score = 0;
        {
            call _checkSubWlTypes;
        } forEach _children;
        if (_score isequalto (count _children)) then {
            CALL_NEXT;
        };
    };
};


private _checkSubWlTypes = {
    private _wlTypes = getArray (_x >> "wlTypes");
    if (_wlTypes isEqualto []) then {
        INC(_score);
    } else {
        private _threshold = (getArray (_x >> "thresholdTypes")) select 0;
        private _countRange = getArray (_x >> "count");
        private _count = 0;
        if (_threshold < 0 || _threshold > count _wlTypes) then {_threshold = count _wlTypes;};
        //Check against every unit
        {
            if (count (_wlTypes arrayIntersect _x) >= _threshold) then {
                //This vehicle has the required types, so increase the count
                INC(_count);
            };
        } forEach _unitTypes;
        //Check that we have the right count
        if (_countRange select 0 <= _count && (_countRange select 1 >= _count || (_countRange select 1) isequalto -1)) then {
            INC(_score);
        };
    };
};


//==========================================================================================
//===================================== RUN CHECKS =========================================
//==========================================================================================

private _runningOrder = [_checkSide, _checkCount, _checkWlTypes, _checkBlTypes, _checkSubs];

private _runningPos = 0;

private _cats = [];
{
    _cats append (configProperties [_x >> "CfgCompositions" >> "groups", "count _x > 0",true]);
} forEach [configfile, missionConfigfile];

{
    private _subCats = configProperties [_x, "count _x > 0",true];
    private _switch = getNumber (_x >> "switch");
    for [{private _ci = 0}, {_ci < count _subCats}, {INC(_ci)}] do {
    //---------------------------------------------------------------------------
    //------------------------Go through each cfg--------------------------------
    //---------------------------------------------------------------------------
        _runningPos = 0;
        private _cfg = _subCats select _ci;
        private _catSide = getNumber (_cfg >> "side");
        //Check to see if side spesific- if so, just check this and move on.
        call (_runningOrder select _runningPos);
    };
    //---------------------------------------------------------------------------
    //---------------------------------------------------------------------------
} forEach _cats;

//------------ EXIT --------------

_marker = format['%1_%2', _markerPrefix, _markerSuffix];
private _endTime = diag_tickTime - _startTime;
//LOG_2("group %1 took %2 to profile", _data, _endTime);
_return = [[_marker,_markerColor], _groupTypes, _unitTypes, _allTypes];

if (_group isEqualto grpNull) then {
    GROUP_SNS(_data,"types",_return); //Log the result for next time
} else {
    _group setVariable [QGVAR(types), "undefined", true];
};

_return
