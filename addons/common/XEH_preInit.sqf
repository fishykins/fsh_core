#include "script_component.hpp"
SCRIPT(XEH_preInit);

fshNamesspace = [false] call cba_fnc_createNamespace;
vehiclesNamespace = [false] call cba_fnc_createNamespace;
factionNamespace = [false] call cba_fnc_createNamespace;
groupNamespace = [false] call cba_fnc_createNamespace;
fshNamesspace setName "fshNamesspace";
vehiclesNamespace setName "vehiclesNamespace";
factionNamespace setName "factionNamespace";
groupNamespace setName "groupNamespace";


GVARMAIN(session) = floor (random (999999));
GVAR(objectUID) = 0;

fsh_doMove_count = 0;

FUNC(mapItems) = {
    private _return = [];
    params ["_itemArray", "_countArray"];
    for [{private _i = 0}, {_i < count _itemArray}, {INC(_i)}] do {
        private _class = _itemArray select _i;
        private _count = _countArray select _i;
        _return pushBack [_class, _count];
    };
    _return
};

FUNC(mapWeapons) = {
    private _return = [];
    params ["_itemArray", "_countArray"];
    for [{private _i = 0}, {_i < count _itemArray}, {INC(_i)}] do {
        private _class = _itemArray select _i;
        private _count = _countArray select _i;
        _return pushBack [_class, _count];
    };
    _return
};

FUNC(mapMagazines) = {
    private _return = [];
    params ["_itemArray", "_countArray"];
    for [{private _i = 0}, {_i < count _itemArray}, {INC(_i)}] do {
        private _class = _itemArray select _i;
        private _count = _countArray select _i;
        _return pushBack [_class, _count];
    };
    _return
};

FUNC(mapDamage) = {
    private _return = [];
    params ["_hitpoints", "_selections", "_damageArray"];
    for [{private _i = 0}, {_i < count _hitpoints}, {INC(_i)}] do {
        private _class = _hitpoints select _i;
        private _damage = _damageArray select _i;
        if (!(_class isEqualto "")) then {
            _return pushBack [_class, _damage];
        };
    };
    _return
};
