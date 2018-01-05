#include "script_component.hpp"

GVAR(cargo_allowNonDBItems) = true;

FUNC(ace_addCargo) = {
    params ["_vehicle","_item"];

    //systemChat format ["%1 is loading %2", _vehicle, _item];

    private _loaded = _vehicle getVariable ["ACE_cargo_loaded", []];
    _loaded pushBack _item;
    _vehicle setVariable ["ACE_cargo_loaded", _loaded, true];

    private _space = [_vehicle] call ace_cargo_fnc_getCargoSpaceLeft;
    private _itemSize = [_item] call ace_cargo_fnc_getSizeItem;
    _vehicle setVariable ["ACE_cargo_space", _space - _itemSize, true];

    if (_item isEqualType objNull) then {
        detach _item;
        _item attachTo [_vehicle,[0,0,-100]];
        ["ACE_common_hideObjectGlobal", [_item, true]] call CBA_fnc_serverEvent;
    };
};

FUNC(ace_cargo_init) = {
    private _object = _this select 0;
    if ((_object getVariable ["ACE_cargo_hasCargo", getNumber (configFile >> "CfgVehicles" >> typeOf _object >> "ACE_cargo_hasCargo")]) != 1) exitWith {};

    //systemChat format ["%1 waiting for Ace to finish init...", _object];

    private _waiting = true;
    private _loops = 0;
    while {_waiting} do {
        sleep 2;
        INC(_loops);
        private _array = _object getVariable ["ACE_cargo_loaded", ""];
        if (IS_ARRAY(_array) || _loops > 10) then {
            _waiting = false;
        };
    };

    //systemChat format ["%1 ace cargo init done", _object];

    private _cargo = _object getVariable [QGVAR(cargo), []];
    _object setVariable ["ACE_cargo_loaded", [], true];
    _object setVariable ["ACE_cargo_space", getNumber (configFile >> "CfgVehicles" >> typeOf _object >> "ACE_cargo_space"), true];
    {[_object, _x] call FUNC(ace_addCargo);} forEach _cargo;
    _object setVariable [QGVAR(postCargoInit), true, true];
};

FUNC(ace_cargo_addSelf) = {
    private _object = _this select 0;
    private _cargo = _this select 1;
    waitUntil {_object getVariable [QGVAR(postCargoInit), false]};

    [_object, _cargo] call FUNC(ace_addCargo);
};
