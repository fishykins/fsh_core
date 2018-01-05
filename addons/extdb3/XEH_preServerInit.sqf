#include "script_component.hpp"

GVAR(persistantPlayers) = false;
GVAR(persistantObjects) = false;

GVAR(pendingTag) = [objNull, false];

FUNC(playerLoop) = COMPILE_FILE(loop_savePlayers);
FUNC(objectLoop) = COMPILE_FILE(loop_saveObjects);

fsh_noSave = false;

FUNC(randomString) = {
    params [
        ["_length", 8, [0]]
    ];

    private _chars = ["1","2","3","4","5","6","7","8","9","0",
                      "a","b","c","d","e","f","g","h","i","j","k","l","m",
                      "n","o","p","q","r","s","t","u","v","w","x","y","z","_"];

    private _string = "";
    for "_i" from 1 to _length do {
        _string = format ["%1%2", _string, selectRandom _chars];
    };
    _string
};


GVAR(vehicleSaveKey) = [12] call FUNC(randomString);
LOG_1("Vehicle saving key: %1", GVAR(vehicleSaveKey));

QGVAR(pendingTag) addPublicVariableEventHandler {
    params ["_var","_data"];
    _data params ["_object","_bool", "_player"];
    LOG_3("Player %1 has sent a pending tag for %2: %3", _player, _object, _bool);
    [_object, _bool] call fsh_fnc_dbTagObject;
};

private _jipHandle = addMissionEventHandler ["PlayerConnected",
{
    params ["_id", "_uid", "_name", "_jip", "_owner"];
	LOG_5("Player connected: %1 (%2). JIP: %4. Allocaded ID: %5",_name, _uid, _jip, _owner);
	
}];

GVAR(objects) = [];
GVAR(objectIds) = [];

call COMPILE_FILE(init_ace_cargo);
