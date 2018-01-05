#include "script_component.hpp"

GVAR(pendingTag) = [objNull, false];

FUNC(pauseMenuOpened) = {hint "opened!";};
FUNC(pauseMenuClosed) = {hint "closed!";};

FUNC(helloWorld) = {hint "helloWorld";};


FUNC(canMark) = {(_this select 0) getVariable [QGVAR(hasMarkMenu), true]};
FUNC(mark) = {
    params ["_object"];

    if (_object getVariable [QGVAR(vehicleSaveKey), false]) then {
        hint "Object is marked as faction";
    } else {
        if (_object getVariable [QGVARMAIN(isTrash), false]) then {
            hint "Object is marked as trash";
        } else {
            hint "Object is marked as public";
        };
    };
};
FUNC(markFaction) = {
    params ["_object"];
    [_object, true] call fsh_fnc_dbTagObject;
    _object setVariable [QGVARMAIN(isTrash), false, true];
    Hint "Object marked as Faction";
};

FUNC(markPublic) = {
    params ["_object"];
    [_object, false] call fsh_fnc_dbTagObject;
    _object setVariable [QGVARMAIN(isTrash), false, true];
    Hint "Object marked as Public";
};

FUNC(markTrash) = {
    params ["_object"];
    [_object, false] call fsh_fnc_dbTagObject;
    _object setVariable [QGVARMAIN(isTrash), true, true];
    Hint "Object marked as Trash";
};
