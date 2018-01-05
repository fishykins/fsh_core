/* ----------------------------------------------------------------------------
Function: FSH_fnc_spawnCompany

Description:
    spawns a company, based on the cost value passed

Parameters:
    0. area- where to spawn this company
    1. array of factions OR faction- faction(s) to use. If array:
        0. primary faction
        1. armor
        2. airforce
    2. cost- how much dosh we have to play with
    3. purchasing class- see notes
    4. init statement for each group

Returns:
    1. array of groups spawned
    2. total cost of company

Example:
    (begin example)

    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
#define GROUP_TRACKING_LEVEL 0

private TIME_MARKER(_start);

params [
    ["_zRef", [], ["",objNull,locationNull,[]]],
    ["_factions", "", ["",[]]],
    ["_gdp", 100, [0]],
    ["_purchaseClass", "", [""]]
];

private _debug = ("DEBUG" in _this);

private _area = [_zRef] call CBA_fnc_getArea; _area resize 5;
private _namespace = call cba_fnc_createNamespace;
private _startingFunds = _gdp;
private _spawnedGroups = [];

if (_debug) then {
    diag_log "________________________________________shedjsdjrj_________________________________________";
    diag_log str _zRef;
    diag_log str _area;
};



//Turn faction list into array
if (IS_STRING(_factions)) then {_factions = [_factions];};

//Extract faction details
private _defFaction = _factions select 0;
if (_defFaction isEqualto "" || !([_defFaction] call fsh_fnc_isFaction)) exitWith {WARNING_1("Cannot spawn company- faction %1 is not valid", _defFaction);};

_factions params [
    ["_factionPrimary", "", [""]],
    ["_factionArmor", _defFaction, [""]],
    ["_factionAir", _defFaction, [""]]
];

diag_log format["PRIMARY FACTION: %1", _factionPrimary];

private _side = getNumber (configfile >> "CfgFactionClasses"  >> _factionPrimary >> "side");
SWITCH_SIDE(_side,resistance);

private _classConfig = missionConfigFile >> "CfgCompositions" >> "company" >> _purchaseClass;
private _groupTypes = configProperties [_classConfig, "count _x > 0",true];
private _displayName = getText (_classConfig >> "displayName");
private _distribution = getText (_classConfig >> "distribution");

private _factionGroups = [_factionPrimary] call FSH_fnc_factionGroups;
private _factionVehicles = [_factionPrimary] call FSH_fnc_factionVehicles;

//This faction has no groups so its probably not worth doing these checks. Glad we had this talk though
if (count _factionGroups isEqualTo 0) exitWith {[[],_gdp]};

private _grpswh = [];
private _shoppingList = [];

_namespace setVariable ["groupTypes", []];
_namespace setVariable ["area", _area];
_namespace setVariable ["funds", _gdp];

/* ----------------------------------------------------------------------------
Start the distribution of GDP
---------------------------------------------------------------------------- */
private _result = [];
WTD_DLL callExtension ["clear", []];

//Add every group type to distributor.
{
    private _className = getText (_x >> "displayName");
    private _weight = getNumber (_x >> "weight");
    private _cost = getNumber (_x >> "cost");
    WTD_DLL callExtension ["add", [_className, _weight, _cost]];
} forEach _groupTypes;

//------------ CLASS LEVEL DISTRIBUTION --------------//

if (_distribution isEqualTo "ballanced") then {
    _gdp = (WTD_DLL callExtension ["ballance", [_gdp]]) select 1; //Evenly distribute funds according to weight.
};
_gdp = (WTD_DLL callExtension ["stack", [_gdp]]) select 1; //use remaining funds to stack weight

//Return each fund allocation and free up distributor.
{
    private _className = getText (_x >> "displayName");
    _result = WTD_DLL callExtension ["pull", [_className]];
    private _count = _result select 1;
    if (_debug) then {diag_log format["%1 -> %2", _className, _count];};
    _namespace setVariable [format["%1_%2", _displayName, _className], _count];
} forEach _groupTypes;

WTD_DLL callExtension ["clear", []];

_namespace setVariable ["companyClasses", []];
{
    private _className = getText (_x >> "displayName");
    private _cost = getNumber (_x >> "cost");
    private _count = _namespace getVariable [format["%1_%2", _displayName, _className], 0];

    private _classFunds = _count * _cost;
    [_x, _factionGroups, _factionVehicles, _namespace, _displayName, _classFunds] call fsh_fnc_groupProfiler;
} forEach _groupTypes;

//------------ FLAT DISTRIBUTION --------------//

_groupTypes = _namespace getVariable ["companyClasses", []];
_gdp = _namespace getVariable ["funds", -1];
if (_debug) then {diag_log format["Funds left after primary distribution: %1", _gdp];};

WTD_DLL callExtension ["clear", []];
{
    WTD_DLL callExtension ["add", _x];
} forEach _groupTypes;

_gdp = (WTD_DLL callExtension ["ballance", [_gdp]]) select 1;
_gdp = (WTD_DLL callExtension ["stack", [_gdp]]) select 1;

if (_debug) then {diag_log format["Funds left after secondary distribution: %1", _gdp];};
/* ----------------------------------------------------------------------------
We have run every iteration of distribution, now spawn each group.
---------------------------------------------------------------------------- */
private _gdp = _startingFunds;

//Do a final pull on class, then spawn.
{
    private _displayName = _x select 0;
    private _currentCount = COMP_GETVARIBLE("groupCount", 0);
    private _pullCount = (WTD_DLL callExtension ["pull", [_displayName]]) select 1;
    private _count = (_currentCount + _pullCount) min MAX_SPAWN; //Limmit the spawning process incase of extreem numbers
    COMP_SETVARIBLE("groupCount", _count);
    if (_debug) then {diag_log format ["============ %1 ============", _displayName];};

    if (_count > 0) then {
        private _classGroups = COMP_GETVARIBLE("groups", []);
        private _classVehicles = COMP_GETVARIBLE("vehicles", []);
        private _cost = COMP_GETVARIBLE("cost", 1);
        private _childName = COMP_GETVARIBLE("childName", _displayName);
        private _classDisplayName = COMP_GETVARIBLE("displayName", _displayName);
        private _totalCost = _cost * _count;

        //--------------------------- SPAWN ---------------------------------------------//
        for [{private _iGroup = 0}, {_iGroup < _count}, {INC(_iGroup)}] do {
           private _position = [_area] call CBA_fnc_randPosArea;
           private _group = grpNull;
           if (_classVehicles isEqualTo []) then { //If we have groups, spawn one of those
               _group = [_position, selectRandom _classGroups] call FSH_fnc_spawnGroup;
           } else { //Spawn a vehicle
               _group = createGroup [_side, true];
               [_position, selectRandom _classVehicles, _group] call FSH_fnc_spawnVehicle;
           };
           _grpName = format["%1 %2",_classDisplayName, _iGroup + 1]; _grpName = [_grpName] call CBA_fnc_capitalize;
           _group setGroupId [_grpName];
           _spawnedGroups pushBack _group;

           //[_group, GROUP_TRACKING_LEVEL] call fsh_fnc_track;
        };
        //Cost it up
        _gdp = _gdp - _totalCost;
        if (_debug) then {diag_log format["bought %2 %1 for a cost of %3", _displayName, _count, _totalCost];};
    };
} forEach _groupTypes;

diag_log format["Funds left: %1", _gdp];
deleteLocation _namespace;

[_spawnedGroups, _gdp]
