/* ----------------------------------------------------------------------------
Function: FSH_fnc_getVehicleTypes

Description:
    returns a list of types that this vehicle adheres to

Parameters:
    Vehicle- OBJECT, STRING or CONFIG

Returns:
    array of all valid vehicle types.

Example:
    (begin example)
        _types = [vehicle player] call fsh_fnc_getVehicleTypes;
    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_vehicle",objNull,[objnull, configfile, ""]]
];

private _config = _vehicle;

if (!IS_CONFIG(_vehicle)) then {
    _config = [_vehicle] call cba_fnc_getObjectConfig;
};

if (isNil "_config" || !(IS_CONFIG(_config))) exitWith {WARNING("Config not found"); nil};

private _vehicleClass = configName (_config);

private _data = VEHICLE_GNS(_vehicleClass,"data","undefined");
if (!(_data isEqualTo "undefined")) exitWith {_data}; _data = [];

//=================================================================================
//=========================== GATHER INFO ON VEHICLE ==============================
//=================================================================================
private _types = [];
private _weapons = ([_config] call fsh_fnc_getVehicleWeapons) apply {toLower _x};
private _seats = [_config] call fsh_fnc_getVehicleTransport;
private _parents = ([_config, true] call BIS_fnc_returnParents) apply {toLower _x};
private _maxDamage = 0;
private _highestCal = 0;
private _weaponTypes = [];

{
    private _data = [_x] call fsh_fnc_getWeaponData;
    _maxDamage = _maxDamage max (_data select 1);
    _highestCal = _highestCal max (_data select 3);
    {_weaponTypes pushBackUnique _x;} forEach (_data select 0);
} forEach _weapons;


//=================================================================================
//============================== HARD CODED TYPES =================================
//=================================================================================
//Type "artillery"
if (getNumber (_config >> "artilleryScanner") isEqualTo 1) then {_types pushBack "artillery";};

//Type "support". Checks vanilla AND ACE
private _supportAmmo = getNumber (_config >> "transportAmmo");
private _supportFuel = getNumber (_config >> "transportFuel");
private _supportRepair = getNumber (_config >> "transportRepair");
private _aceCanRepair = getNumber (_config >> "ace_repair_canRepair");
private _aceFuelCargo = getNumber (_config >> "ace_refuel_fuelCargo");
if ((_supportAmmo + _supportFuel + _supportRepair + _aceCanRepair + _aceFuelCargo) > 0) then {
    _types pushBack "support";
    if (_supportAmmo > 0) then {_types pushBack "ammo";};
    if (_supportFuel + _aceFuelCargo > 0) then {_types pushBack "fuel";};
    if (_supportRepair + _aceCanRepair > 0) then {_types pushBack "repair";};
    //MEDICAL GOES HERE
};

//==========================================================================================
//=================================== DEFINE CHECKS ========================================
//==========================================================================================
//These functions should only be getting data from composition class.
#define CALL_NEXT   INC(_runningPos); if (_runningPos < count _runningOrder) then  {call (_runningOrder select _runningPos);} else {call _passed;}

#define IF_CANLOG  if (isNil "fsh_sdbpn")

_passed = {
    _types pushBackUnique _className;
    if (_switch > 0) then {
        _ci = count _subCats;
        _baseTypeCount = 0; //Stops checking of default types
    };
};

_checkClassName = {
    if (!(_className isEqualTo "")) then {
        CALL_NEXT;
    };
};

_checkWlTypes = {
    private _wlTypes = getArray (_cfg >> "wlTypes");
    if (_wlTypes isEqualTo []) then {
        CALL_NEXT;
    } else {
        private _threshold = ((getArray (_cfg >> "thresholdTypes")) select 0);
        if (_threshold < 0 || _threshold > count _wlTypes) then {_threshold = count _wlTypes;};
        if (count (_wlTypes arrayIntersect _parents) >= _threshold) then {
            CALL_NEXT;
        };
    };
};

_checkBlTypes = {
    private _blTypes = getArray (_cfg >> "blTypes");
    if (_blTypes isEqualTo []) then {
        CALL_NEXT;
    } else {
        private _threshold = ((getArray (_cfg >> "thresholdTypes")) select 1) max 0;
        if (count (_blTypes arrayIntersect _parents) <= _threshold) then {
            CALL_NEXT;
        };
    };
};

_checkWlWeapons = {
    private _wlWeapons = getArray (_cfg >> "wlWeapons");
    if (_wlWeapons isEqualTo []) then {
        CALL_NEXT;
    } else {
        private _threshold = (getArray (_cfg >> "thresholdWeapons")) select 0;
        if (_threshold < 0 || _threshold > count _wlWeapons) then {_threshold = count _wlWeapons;};
        if (count (_wlWeapons arrayIntersect _weaponTypes) >= _threshold) then {
            CALL_NEXT;
        };
    };
};

_checkBlWeapons = {
    private _blWeapons = getArray (_cfg >> "blWeapons");
    if (_wlWeapons isEqualTo []) then {
        CALL_NEXT;
    } else {
        private _threshold = ((getArray (_cfg >> "thresholdWeapons")) select 1) max 0;
        if (count (_blWeapons arrayIntersect _weaponTypes) <= _threshold) then {
            CALL_NEXT;
        };
    };
};

_checkSeats = {
    private _transport = getArray (_cfg >> "transport");
    if (_transport isEqualTo [-1,-1]) then {
        CALL_NEXT;
    } else {
        if (_seats >= _transport select 0 && (_seats <= _transport select 1 || _transport select 1 isEqualTo -1) ) then {
            CALL_NEXT;
        };
    };
};

_checkDamage = {
    private _dmgOutput = getArray (_cfg >> "damageOutput");
    if (_dmgOutput isEqualTo [-1,-1]) then {
        CALL_NEXT;
    } else {
        if ( _maxDamage >= (_dmgOutput select 0) && (_maxDamage <= (_dmgOutput select 1) || (_dmgOutput select 1) isEqualto -1 ) ) then {
            CALL_NEXT;
        };
    };
};


//==========================================================================================
//===================================== RUN CHECKS =========================================
//==========================================================================================

private _runningOrder = [_checkClassName, _checkWlTypes, _checkBlTypes, _checkWlWeapons, _checkBlWeapons, _checkSeats, _checkDamage];

private _runningPos = 0;

//Go through every type of vehicle and see if we match it's criteria
private _cats = [];
private _baseTypes = [];
private _allTypes = [];
{
    _baseTypes append (getArray (_x >> "CfgCompositions" >> "vehicles" >> "baseTypes"));
    _cats append (configProperties [_x >> "CfgCompositions" >> "vehicles", "count _x > 0",true]);
} forEach [configfile, missionConfigfile];

//Base types are nice and easy to find
_types append (_baseTypes arrayIntersect _parents);

//==========================================================================================

{
    private _subCats = configProperties [_x, "count _x > 0",true];
    private _kindOf = getText (_x >> "kindOf");
    if (count _subCats > 0 && (_kindOf isEqualto "any" || _kindOf in _parents) ) then {
        private _switch = getNumber (_x >> "switch");
        private _baseTypes = getArray (_x >> "baseTypes");
        private _baseTypeCount = count _baseTypes;
        //---------------------- CLASS CHECKIING ------------------------//
        for [{private _ci = 0}, {_ci < count _subCats}, {INC(_ci)}] do {
             private _cfg = _subCats select _ci;
             private _className = toLower (getText (_cfg >> "className"));

             _runningPos = 0;
             call (_runningOrder select _runningPos);

        };
        //------------------ BASE CLASS CHECKIING ----------------------//
        for [{private _ci = 0}, {_ci < _baseTypeCount}, {INC(_ci)}] do {
             private _className = _baseTypes select _ci;

             if (_className in _parents) then {
                 call _passed;
             };
        };
    };
} forEach _cats;

//==========================================================================================

_data = [_types, _weapons, _weaponTypes, [_maxDamage, _highestCal, _seats]];
VEHICLE_SNS(_vehicleClass,"data",_data); //Log the result for next time
_data
