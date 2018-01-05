//Sub function of spawn company. Should not be called by anything else as impropper use will result in a system meltdown
#include "script_component.hpp"

params ["_config","_parentGroups","_parentVehicles","_namespace","_parentName","_funds"];

private _debug = ("DEBUG" in _this);

private  _childName = configName _config; // getText (_config >> "displayName");
private _displayName = format["%1_%2", _parentName, _childName];

if (_displayName isEqualTo "") exitWith {};

private _classDisplayName = getText (_config >> "displayName");
private _cost = getNumber (_config >> "cost");
private _weight = getNumber (_config >> "weight");
private _wlTypes = getArray (_config >> "wlTypes");
private _blTypes = getArray (_config >> "blTypes");
private _children = configProperties [_config, "count _x > 0",true];
private _distribution = getText (_classConfig >> "distribution");
private _isGroup = getNumber (_config >> "isGroup");
private _isObject = getNumber (_config >> "isObject");


if (_debug) then {
    diag_log format ["============================ %1 ===============================", _displayName];
    diag_log format ["funds: %1", _funds];
    diag_log format ["children count: %1", _children];
};

private _classGroups = [];
private _classVehicles = [];

//Find all groups
if (_isGroup isEqualTo 1) then {
    {
        if (_wlTypes isEqualTo [] && _blTypes isEqualTo []) then {
            _classGroups pushBack _x;
        } else {
            private _data = [_x] call fsh_fnc_getGroupData;
            private _types = _data select 1;

            if (count (_types arrayIntersect _wlTypes) >= count _wlTypes || count _wlTypes isEqualTo 0) then {
                //Check against blacklist
                if (count (_types arrayIntersect _blTypes) == 0 || count _blTypes isEqualTo 0) then {
                    _classGroups pushBack _x;
                    //diag_log str (configName _x);
                };
            };
        };
    } forEach _parentGroups;
};

//Find all vehicles
if (_isObject isEqualTo 1) then {
    {
        if (count _wlTypes isEqualTo 0 && count _blTypes isEqualTo 0) then {
            _classVehicles pushBack _x;
        } else {
            private _vehTypes = ([_x] call fsh_fnc_getVehicleData) select 0; //Returns all vehicle types, lowercase.
            //Check to make sure we dont have any bared types
            if (count (_vehTypes arrayIntersect _blTypes) == 0 || count _blTypes isEqualTo 0) then {
                //Check to make sure we have all required types
                if (count (_vehTypes arrayIntersect _wlTypes) >= count _wlTypes || count _wlTypes isEqualTo 0) then {
                    _classVehicles pushBack _x;
                };
            };
        };
    } forEach _parentVehicles;
};

//Log results
COMP_SETVARIBLE("groups", _classGroups);
COMP_SETVARIBLE("vehicles", _classVehicles);
COMP_SETVARIBLE("cost", _cost);
COMP_SETVARIBLE("weight", _weight);
COMP_SETVARIBLE("childName", _childName);
COMP_SETVARIBLE("displayName", _classDisplayName);
VAR_PUSHBACK("groupTypes", _displayName); //Array of all classes

//Check we have groups. If not, exit- our funds will be reclaimed later on
if (_classGroups isEqualto [] && _isGroup isEqualTo 1 && _isObject isEqualTo 0) exitWith {
    WARNING_1("No groups found for %1", _displayName);
};

if (_classVehicles isEqualto [] && _isObject isEqualTo 1 && _isGroup isEqualTo 0) exitWith {
    WARNING_1("No vehicles found for %1", _displayName);
};

/* ----------------------------------------------------------------------------
If we have children, give them all the funds and iterate
---------------------------------------------------------------------------- */
if (_debug) then {diag_log str _children;};

if (count _children > 0) then {
    //Clear the calculator
    WTD_DLL callExtension ["clear", []];



    //Add every group type to objCounter.
    {
        private _classDispName = configName _x;
        private _weight = getNumber (_x >> "weight");
        private _classCost = getNumber (_x >> "cost");
        WTD_DLL callExtension ["add", [_classDispName,_weight,_classCost]];
    } forEach _children;

    //Run distributor with our given funds
    if (_distribution isEqualTo "ballanced") then {
        _funds = (WTD_DLL callExtension ["ballance", [_funds]]) select 1; //Evenly distribute funds according to weight.
    };
    _funds = (WTD_DLL callExtension ["stack", [_funds]]) select 1; //use remaining funds to stack weight

    //Start up each class thread and allocate funds
    {
        private _classDispName = configName _x;
        private _classCost = getNumber (_x >> "cost");
        private _count = (WTD_DLL callExtension ["pull", [_classDispName]]) select 1;
        private _classFunds = _count * _classCost;
        [_x, _classGroups, _classVehicles, _namespace, _displayName, _classFunds] call fsh_fnc_groupProfiler;
    } forEach _children;
} else {
/* ----------------------------------------------------------------------------
No children, so tally up our count and log
---------------------------------------------------------------------------- */
    //Log this class for later, so we can do one huge stack at the end.
    private _ret = [_displayName, _weight, _cost];
    VAR_PUSHBACK("companyClasses", _ret);

    private _groupCount = floor(_funds / _cost);
    COMP_SETVARIBLE("groupCount", _groupCount);

    private _temp = _namespace getVariable ["funds", 0];
    _temp = _temp - _funds;
    _namespace setVariable ["funds", _temp]; //This is only virtual money, it will be re-calculated after distribution.
};
