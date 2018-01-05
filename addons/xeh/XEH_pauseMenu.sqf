#include "script_component.hpp"
#define MENU (findDisplay 49)

disableSerialization;

private _type = _this select 0;

private _config = configfile >> "Extended_pauseMenu_EventHandlers";
private _missionConfig = MissionConfigFile >> "Extended_pauseMenu_EventHandlers";

private _allAddons = configProperties [_config, "count _x > 0",true];
_allAddons append (configProperties [_missionConfig, "count _x > 0",true]);


{
    private _code = getText (_x >> _type);
    if (!(_code isEqualto "")) then {
        call compile _code;
    };
} forEach _allAddons;
