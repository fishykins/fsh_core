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
private _types = [];
private _weapons = ([_config] call fsh_fnc_getVehicleWeapons) apply {toLower _x};
private _seats = [_config] call fsh_fnc_getVehicleTransport;
private _parents = ([_config, true] call BIS_fnc_returnParents) apply {toLower _x};
private _maxDamage = 0;
private _lethality = 0;
private _highestCal = 0;
private _weaponTypes = [];
private _hasArtillery = false;

{
    private _data = [_x] call fsh_fnc_getWeaponData;
    _maxDamage = _maxDamage max (_data select 1);
    _highestCal = _highestCal max (_data select 3);
    _lethality = _lethality + (_data select 2);
    {_weaponTypes pushBackUnique _x;} forEach (_data select 0);
} forEach _weapons;

private _punch = if (_lethality > 0) then {floor ((_maxDamage/_lethality)*100)} else {0};


//============== HARDCODED TYPES ==================================================
//Type "artillery"
if (getNumber (_config >> "artilleryScanner") isEqualTo 1) then {_types pushBack "artillery"; _hasArtillery = true;};

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


//================ DYNAMIC TYPES ==================================================

//Go through every type of vehicle and see if we match it's criteria

private _basicTypes = [];
private _allTypes = [];
{
    _basicTypes append (getArray (_x >> "CfgCompositions" >> "vehicles" >> "basicTypes"));
    _allTypes append (configProperties [_x >> "CfgCompositions" >> "vehicles", "count _x > 0",true]);
} forEach [configfile, missionConfigfile];
_basicTypes apply {toLower _x};

//Get all basic types just like that
_types append (_basicTypes arrayIntersect _parents);

//Now go through more complex types and nab them
{
    private _className = toLower (getText (_x >> "className"));

    if (!(_className isEqualTo "")) then {
        //diag_log format["%1: testing...", _className];
        private _wlTypes = getArray (_x >> "wlTypes");
        private _thresholds = getArray (_x >> "thresholdTypes");
        private _threshold = _thresholds select 0;
        if (_threshold < 0 || _threshold > count _wlTypes) then {_threshold = count _wlTypes;};

        if ( (_wlTypes isEqualTo []) || (count (_wlTypes arrayIntersect _parents) >= _threshold) ) then {
            private _blTypes = getArray (_x >> "blTypes");
            private _threshold = _thresholds select 1;
            if (_threshold < 0) then {_threshold = 0};

            if ( (_blTypes isEqualTo []) || (count (_blTypes arrayIntersect _parents) <= _threshold) ) then {
                private _wlWeapons = getArray (_x >> "wlWeapons");
                private _thresholds = getArray (_x >> "thresholdWeapons");
                private _threshold = _thresholds select 0;
                if (_threshold < 0 || _threshold > count _wlWeapons) then {_threshold = count _wlWeapons;};

                //diag_log format ["%1 checking weapons (%4) against wlWeapons (%2): threshhold = %3", _className, _wlWeapons, _threshold, _weaponTypes];

                if ( (_wlWeapons isEqualTo []) || (count (_wlWeapons arrayIntersect _weaponTypes) >= _threshold) ) then {
                    private _blWeapons = getArray (_x >> "blWeapons");
                    private _threshold = _thresholds select 1;
                    if (_threshold < 0) then {_threshold = 0};

                    //diag_log format ["%1 checking weapons (%4) against blWeapons (%2): threshhold = %3", _className, _blWeapons, _threshold, _weaponTypes];

                    if ( (_blWeapons isEqualTo []) || (count (_blWeapons arrayIntersect _weaponTypes) <= _threshold) ) then {
                        private _transport = getArray (_x >> "transport");

                        //diag_log format ["%1 checking seats (%2) lies between %3 and %4", _className, _seats, _transport select 0, _transport select 1];

                        if (_seats >= _transport select 0 && (_seats <= _transport select 1 || (_transport select 1) isEqualTo -1 )) then {
                            private _dmgOutput = getArray (_x >> "damageOutput");

                            //diag_log format ["%1 checking maxdamage (%2) lies between %3 and %4", _className, _maxDamage, _dmgOutput select 0, _dmgOutput select 1];

                            if (_maxDamage >= _dmgOutput select 0 && (_maxDamage <= _dmgOutput select 1 || (_dmgOutput select 1) isEqualTo -1 )) then {
                                //private _lth = getArray (_x >> "lethality");

                                //diag_log format ["%1 checking lethality (%2) lies between %3 and %4", _className, _lethality, _lth select 0, _lth select 1];

                                //if (_lethality >= _lth select 0 && (_lethality <= _lth select 1 || (_lth select 1) isEqualTo -1)) then {
                                    //Top of the mountian, add it
                                    _types pushBackUnique _className;
                                    //diag_log format["%1: CLASS OK! (lethality: %2, maxDamage: %3)", _className, _lethality, _maxDamage];
                                //};
                            };
                        };
                    };
                };
            };
        };
    };
} forEach _allTypes;

//LOG_6("OBJECT %1: %2 seats, lethality %3 and maxDamage %4 (%6). %5", _vehicleClass, _seats, _lethality, _maxDamage, _types, _punch);


_data = [_types, _seats, [_weapons, _weaponTypes], [_lethality, _maxDamage, _punch, _highestCal], _hasArtillery];
VEHICLE_SNS(_vehicleClass,"data",_data); //Log the result for next time
_data
