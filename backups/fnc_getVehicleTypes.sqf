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
private _vehicleSubCat = getText (_config >> "editorSubcategory");

/*private PULL_FVAR(_vehicleClass,_types,"undefined");*/
private _types = VEHICLE_GNS(_vehicleClass,"types","undefined");
if (!(_types isEqualTo "undefined")) exitWith {_types}; _types = [];
//=================================================================================
private _weapons = ([_config] call fsh_fnc_getVehicleWeapons) apply {toLower _x};
private _seats = [_config] call fsh_fnc_getVehicleTransport;
private _parents = ([_config,true] call BIS_fnc_returnParents) apply {toLower _x};
private _turrets = [_config] call BIS_fnc_returnVehicleTurrets;

//Go through every type of vehicle and see if we match it's criteria

private _allTypes = configProperties [missionConfigFile >> "CfgCompositions" >> "vehicles", "(getNumber(_x >> 'scope')) isEqualTo 2", true];
_allTypes append (configProperties [ConfigFile >> "CfgCompositions" >> "vehicles", "(getNumber(_x >> 'scope')) isEqualTo 2", true]);

_filter = {
    private _arrayStrings = _this select 0;
    private _arrayFilters = _this select 1;
    private _filterReturn = false;
    for [{private _i=0}, {_i < (count _arrayStrings)}, {INC(_i)}] do {
        private _string = _arrayStrings select _i;;
        for [{private _j=0}, {_j < (count _arrayFilters)}, {INC(_j)}] do {
            private _filter = _arrayFilters select _j;
            private _filterPos = [_string, _filter] call cba_fnc_find;
            if (!(_filterPos isEqualTo -1)) then {
                _i = count _arrayStrings;
                _j = count _arrayFilters;
                _filterReturn = true;
            };
        };
    };
    _filterReturn
};

{
    private _tName = toLower (getText (_x >> "className"));
    private _editorSubcategory = getText (_x >> "editorSubcategory");
    private _tTypeOf = getArray (_x >> "typeOf");
    private _tNotTypeOf = getArray (_x >> "notTypeOf");
    private _tWeaponsWhite = getArray (_x >> "weaponsWhitelist");
    private _tWeaponsBlack = getArray (_x >> "weaponsBlacklist");
    private _tCargoMin = getNumber (_x >> "cargoMin");
    private _tCargoMax = getNumber (_x >> "cargoMax");

    //Checks
    private _passedTypeOf = true;
    private _passedNotTypeOf = true;
    private _passedWeaponsWhite = true;
    private _passedWeaponsBlack = true;
    private _passedSeats = false;
    private _passedEditorSubcategory = true;

    if (!(_editorSubcategory isEqualTO "")) then {
        if (!(_vehicleSubCat isEqualTo _editorSubcategory)) then {_passedEditorSubcategory = false;};
    };

    if (_seats >= _tCargoMin && _seats <= _tCargoMax) then {_passedSeats = true;};

    if (count _tTypeOf > 0) then {
        if (!([_parents, _tTypeOf] call _filter)) then {_passedTypeOf = false;};
    };

    if (count _tNotTypeOf > 0) then {
        if ([_parents, _tNotTypeOf] call _filter) then {_passedNotTypeOf = false;};
    };

    if (count _tWeaponsWhite > 0) then {
        if (!([_weapons, _tWeaponsWhite] call _filter)) then {_passedWeaponsWhite = false;};
    };
    if (count _tWeaponsBlack > 0) then {
        if ([_weapons, _tWeaponsBlack] call _filter) then {_passedWeaponsBlack = false;};
    };
    //diag_log format["Results %1:", _tName];
    //diag_log format["weaponsWhite = %1, weaponsBlack = %2 seats = %3", _passedWeaponsWhite, _passedWeaponsBlack, _passedSeats];
    //diag_log format["TypeOf = %1, notTypeOf = %2", _passedTypeOf, _passedNotTypeOf];
    if (_passedEditorSubcategory && _passedSeats && _passedWeaponsWhite && _passedWeaponsBlack && _passedTypeOf && _passedNotTypeOf) then {_types pushBackUnique _tName;};

} forEach _allTypes;

/*PUSH_FVAR(_vehicleClass,_types);*/
VEHICLE_SNS(_vehicleClass,"types",_types);
_types
