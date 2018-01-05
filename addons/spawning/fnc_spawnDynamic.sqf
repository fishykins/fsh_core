/* ----------------------------------------------------------------------------
Function:

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
    ["_spawnTemplates", [], [[],""]],
    ["_vehicleTypes", [], ["",[]]],
    ["_remove", true, [false]]
];

private _spawnGroup = "";

if (IS_STRING(_spawnTemplates)) then {
    _spawnGroup = _spawnTemplates;
    _spawnTemplates = SPAWN_GNS(_spawnGroup,"placeholders",[]);
};

if (IS_STRING(_vehicleTypes)) then {_vehicleTypes = [_vehicleTypes];};
if (_vehicleTypes isEqualto []) exitWith {WARNING("No vehicle types given");};

private _failed = [];
private _vehicles = [];
private _groupReturn = [];

{
    private _entry = _x;
    _entry params [
        ["_placeholder", objNull, [objNull]],
        ["_wlTypes", [], [[]]],
        ["_blTypes", [], [[]]]
    ];
    private _posUsed = _placeholder getVariable [QGVAR(posUsed), false];
    private _vehicleType = "";
    private _vehicle = objNull;

    if (!(isNull _placeholder) && !_posUsed) then {
        if (count (_wlTypes + _blTypes) > 0) then {
            private _wlVehicles = [];
            {
                private _types = ([_x] call fsh_fnc_getVehicleData) select 0;
                if (count (_types arrayIntersect _wlTypes) isequalto (count _wlTypes) &&  (_types arrayIntersect _blTypes) isEqualto []) then {
                    _wlVehicles pushBackunique _x;
                };
            } forEach _vehicleTypes;
            if (!(_wlVehicles isequalto [])) then {
                _vehicleType = selectRandom _wlVehicles;
            };
        } else {
            _vehicleType = selectRandom _vehicleTypes;
        };
        if (!(_vehicleType isEqualto "")) then {
            private _position = getPosATL _placeholder;
            private _direction = getDir _placeholder;
            _vehicle = ([_position,_vehicleType,grpNull,_direction] call fsh_fnc_spawnVehicle) select 0;
        };
    };

    if (isNull _vehicle) then {
        _failed pushBack _entry;
    } else {
        _vehicles pushBack _vehicle;
        _placeholder setVariable [QGVAR(posUsed), true, true];
        if (_remove) then {deleteVehicle _placeholder;} else {_groupReturn pushBack _entry;};
    };
} forEach _spawnTemplates;

if (!(_spawnGroup isEqualto "")) then {
    SPAWN_SNS(_spawnGroup,"placeholders",(_failed + _groupReturn));
};


[_vehicles,_failed]
