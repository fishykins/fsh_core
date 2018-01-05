/* ----------------------------------------------------------------------------
Function: FSH_fnc_getWeaponData

Description:

Parameters:


Returns: ARRAY
    0. max damage from single round
    1. Combined damage from every bloody round. Lots of damage

Example:
    (begin example)

    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [
    ["_weapon","",[""]],
    ["_debug", false, [false]]
];

private _data = WEAPON_GNS(_weapon,"data","undefined");
if (!(_data isEqualTo "undefined") && !_debug) exitWith {_data}; _data = [];
//=================================================================================

private _allTypes = [];
{
    _allTypes append (configProperties [_x >> "CfgCompositions" >> "weapons", "count _x > 0",true]);
} forEach [configfile, missionConfigfile];

private _CfgWeapon = configFile >> "CfgWeapons" >> _weapon;
private _magazines = getArray (_CfgWeapon >> "magazines");
private _rounds = [];

private _maxDamage = 0;
private _lethality = 0;
private _highestCal = 0;
private _types = [];

if (_debug) then {diag_log format["_________ WEAPON: %1 _________", _weapon];};
if (_magazines isEqualto []) then {
    //This is anoying- magazines are within sub classes so do the maths.
    private _subClasses = configProperties [_CfgWeapon, "count _x > 0",true];
    {
        _magazines append (getArray (_x >> "magazines"));
    } forEach _subClasses;
};

{
    private _CfgMagazine = configFile >> "CfgMagazines" >> _x;
    private _ammo = getText (_CfgMagazine >> "ammo");
    private _CfgAmmo = configFile >> "CfgAmmo" >> _x;

    _rounds pushBackUnique _ammo;

    private _hit = getNumber (_CfgAmmo >> "hit");
    private _roundCount = getNumber (_CfgMagazine >> "count");
    _lethality = _lethality + (_roundCount * _hit);
} forEach _magazines;

//========================================================================================//
//========================================================================================//
{
    private _CfgAmmo = configFile >> "CfgAmmo" >> _x;
    private _caliber = getNumber (_CfgAmmo >> "caliber");
    private _hit = getNumber (_CfgAmmo >> "hit");
    private _simulation = getText (_CfgAmmo >> "simulation");
    private _usage = getText (_CfgAmmo >> "aiAmmoUsageFlags");

    //private _lockType = getNumber (_CfgAmmo >> "lockType");
    private _irLock = getNumber (_CfgAmmo >> "irLock");
    private _laserLock = getNumber (_CfgAmmo >> "laserLock");
    private _airLock = getNumber (_CfgAmmo >> "airLock");

    private _canLockAir = if (_airLock >= 1) then {1} else {0};
    private _canLockGround = if (_airLock == 1 || _laserLock > 0 || _irLock > 0) then {1} else {0};
    private _canLock = _canLockGround max _canLockAir;


    //run type tests...
    {
        private _className = toLower (getText (_x >> "className"));
        private _UPDATE = "init";

        if (!(_className isEqualTo "")) then {
            private _classSim = getText (_x >> "simulation");

            _UPDATE = format ["%1 checking simulation (%2) is equal to %3", _className, _simulation, _classSim];

            if (_simulation isEqualTo _classSim || _classSim isEqualTo "") then {
                private _calRange = getArray (_x >> "calRange");

                _UPDATE = format ["%1 checking caliber (%2) lies between %3 and %4", _className, _caliber, _calRange select 0, _calRange select 1];

                if (_caliber >= _calRange select 0 && (_caliber <= _calRange select 1 || (_calRange select 1) isEqualTo -1)) then {
                    private _damageRange = getArray (_x >> "damageRange");

                    _UPDATE = format ["%1 checking damage (%2) lies between %3 and %4", _className, _hit, _damageRange select 0, _damageRange select 1];

                    if (_hit >= _damageRange select 0 && (_hit <= _damageRange select 1 || (_damageRange select 1) isEqualTo -1) ) then {
                        private _lockingEnabled = getNumber (_x >> "lockingEnabled");

                        _UPDATE = format ["%1 checking locking (%2) against %3", _className, _canLock, _lockingEnabled];

                        if (_canLock isEqualTo _lockingEnabled || _lockingEnabled isEqualTo -1) then {
                            private _lockAir = getNumber (_x >> "lockAir");

                            _UPDATE = format ["%1 checking air locking (%2) against %3", _className, _canLockAir, _lockAir];

                            if (_canLockAir isEqualTo _lockAir || _lockAir isEqualTo -1) then {
                                private _lockGround = getNumber (_x >> "lockGround");

                                _UPDATE = format ["%1 checking ground locking (%2) against %3", _className, _canLockGround, _lockGround];

                                if (_canLockGround isEqualTo _lockGround || _lockGround isEqualTo -1) then {

                                    private _aiUsage = str (getNumber (_x >> "aiUse"));

                                    _UPDATE = format ["%1 checking aiUse (%3) lies within %2", _className, _usage, _aiUsage];

                                    if (_aiUsage isEqualTo "" || _aiUsage isEqualTo "-1") then {
                                        _types pushBackUnique _className;
                                        _UPDATE = format ["TYPE %1 IS OK!", _className];

                                    } else {
                                        private _result = [_usage, _aiUsage] call CBA_fnc_find;

                                        if (_result >= 0) then {
                                            _types pushBackUnique _className;

                                            _UPDATE = format ["TYPE %1 IS OK!", _className];
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        };

        //diag_log _UPDATE;

    } forEach _allTypes;

    //Output scores, unrelated to types
    _maxDamage = _maxDamage max _hit;
    _highestCal = _highestCal max _caliber;

    if (_debug) then {
        diag_log format["       ____ ammo: %1 ____", _x];
        diag_log format["           caliber: %1", _caliber];
        diag_log format["           hit: %1", _hit];
        diag_log format["           simulation: %1", _simulation];
        diag_log format["           ai uses: %1", _usage];
        //diag_log format["           airLock: %1", _airLock];
        //diag_log format["           laserLock: %1", _laserLock];
        //diag_log format["           irLock: %1", _irLock];
        diag_log format["           lockAir: %1", _canLockAir];
        diag_log format["           lockGround: %1", _canLockGround];
        diag_log format["           canLock: %1", _canLock];
        diag_log format["           Types: %1", _types];


    };

} forEach _rounds;
//========================================================================================//
//========================================================================================//

//Tone down lethality to a more readable number.
_lethality = floor(_lethality/100);

//diag_log format["       %1: %2", configName _CfgWeapons, [_maxDamage,_lethality, _types]];

_data = [_types, _maxDamage, _lethality, _highestCal];
WEAPON_SNS(_weapon,"data",_data);
_data
