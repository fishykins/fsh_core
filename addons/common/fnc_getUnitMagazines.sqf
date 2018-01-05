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
#define ACE_KEY_CLASS   "ACE_key_customKeyMagazine"
#define ACE_KEY_DESCRIPTION     "ACE Vehicle Key"

params ["_unit"];

private _uniform = uniformContainer _unit;
private _vest = vestContainer _unit;
private _backpack = backpackContainer _unit;

private _allMags = magazinesAmmoFull _unit;
private _uniformMags = (getMagazineCargo _uniform) call FUNC(mapMagazines);
private _vestMags = (getMagazineCargo _vest) call FUNC(mapMagazines);
private _backpackMags = (getMagazineCargo _backpack) call FUNC(mapMagazines);
private _magIds = (magazinesDetail _unit);

/*
diag_log format ["-----------------%1---------------------", name _unit];
//{diag_log str _x;} forEach _data;
diag_log str "____ MAGAZINES ______";
{diag_log str _x;} forEach _allMags;
diag_log str "____ UNIFORM MAGS ______";
{diag_log str _x;} forEach _uniformMags;
diag_log str "____ VEST MAGS ______";
{diag_log str _x;} forEach _vestMags;
diag_log str "____ BACKPACK MAGS ______";
{diag_log str _x;} forEach _backpackMags;
diag_log "--------------------------------------------";
*/

private _magazines = [];
private _invalidMags = [];
private _aceKeyLocations = [];

private _addMagazine = {
    params ["_class", "_count", "_ammo", "_container"];
    if (_class isEqualto "classNull") exitWith {false};

    //This checks to see if it is an ace custom key.
    //private _isUnique = configfile >> "CfgMagazines" >> _class >> "ACE_isUnique";
    if (_class isEqualto ACE_KEY_CLASS) exitWith {_aceKeyLocations pushBack _container; false};

    private _added = false;

    for [{private _j = 0}, {_j < count _magazines}, {INC(_j)}] do {
        private _entry = _magazines select _j;
        _entry params ["_eClass","_eCount", "_eAmmo", "_eContainer"];

        if (_eClass isEqualto _class && _eAmmo isEqualto _ammo && _eContainer isEqualto _container) then {
            //These magazines are identical, simply increase the count of the origional.
            _entry set [1, _eCount + _count];
            _magazines set [_j, _entry];
            _j = (count _magazines) + 1;
            _added = true;
        };
    };
    if (!_added) then {
        _magazines pushBack _this;
    };
    true
};


//match up magazines
{
    _x params ["_class","_ammo","_loaded","_type", "_container"];
    private _array = switch (_container) do {
        case "Uniform": {_uniformMags};
        case "Backpack": {_backpackMags};
        case "Vest": {_vestMags};
        default {[]};
    };

    //diag_log format ["%1: %2", _class,_container];

    //Find this mag in container and tick it off
    if (!(_array isEqualto [])) then {

        //diag_log format ["--Looking for class in %1", _array];

        for [{private _i = 0}, {_i < count _array}, {INC(_i)}] do {
            private _entry = _array select _i;
            if ((_entry select 0) isEqualto _class) then {

                //diag_log format ["----%1 has entry: %2", _class, _entry];

                private _count = _entry select 1;
                _count = _count - 1;
                if (_count > 0) then {
                    _array set [_i, [_class, _count]];
                } else {
                    _array set [_i, ["classNull", -1]];
                };

                //diag_log format ["----array now reads %1", _array];
                [_class, 1, _ammo, _container] call _addMagazine;
                _i = (count _array) + 1;
            };
        };
    } else {
        //diag_log "--container not valid";
        _invalidMags pushBack _x;
    };
} forEach _allMags;

/*
diag_log "--------------------------------------------";
diag_log str "____ INVALID ______";
{diag_log str _x;} forEach _invalidMags;
diag_log str "____ UNIFORM MAGS ______";
{diag_log str _x;} forEach _uniformMags;
diag_log str "____ VEST MAGS ______";
{diag_log str _x;} forEach _vestMags;
diag_log str "____ BACKPACK MAGS ______";
{diag_log str _x;} forEach _backpackMags;
diag_log "--------------------------------------------";
*/

//Sort out left over mags
{
    _x params ["_class","_count"];
    [_class, _count, 1, "Uniform"] call _addMagazine;
} forEach _uniformMags;

{
    _x params ["_class","_count"];
    [_class, _count, 1, "Vest"] call _addMagazine;
} forEach _vestMags;

{
    _x params ["_class","_count"];
    [_class, _count, 1, "Backpack"] call _addMagazine;
} forEach _backpackMags;

//Now get any loaded mags
private _weapons = [primaryWeapon _unit, secondaryWeapon _unit, handgunWeapon _unit];
private _muzzles = [];
{
     private _entry = (getArray (configFile >> "CfgWeapons" >> _x >> "muzzles"));
     for [{private _i = 0}, {_i < count _entry}, {INC(_i)}] do {
         private _muzzle = _entry select _i;
         if (_muzzle isEqualto "this") then {
             _entry set [_i, _x];
         };
     };
     _muzzles append _entry;
} forEach _weapons;


{
    _x params ["_class","_ammo","_loaded","_type", "_container"];

    //diag_log format ["%1: %2", _class,_container];

    if (_container in _muzzles) then {
        //diag_log "--primary mag!!!!";
        [_class, 1, _ammo, _container] call _addMagazine;
    };
} forEach _invalidMags;

/*
diag_log "--------------- MAGS -----------------------";
{diag_log str _x;} forEach _magazines;
diag_log "--------------------------------------------";
*/

if (_aceKeyLocations isEqualto [] || "NOACEKEYS" in _this) exitWith {_magazines};
/*------------------------------------------------------------------
                            ACE KEYS
Ace keys are used for locking vehicles. Each key "magazine" has
a uid which allows vehicles to have spesific keys. This function
extracts as much data as possible from each key, and will attempt
to match keys to containers where possible. The exact keys might
get mixed up, but the net result is consitant storage containers
------------------------------------------------------------------*/

for [{private _i = 0}, {_i < count _magIds && !(_aceKeyLocations isequalto [])}, {INC(_i)}] do {
    private _entry = _magIds select _i;
    _str = _entry splitString "()[]:";
    _str params ["_description","_ammo", "_junk", "_id"];

    if (_description isEqualto ACE_KEY_DESCRIPTION) then {
        //This is a valid key- select a container
        private _class = format ["ACE_key_%1", _id];
        private _container = _aceKeyLocations deleteAt 0;
        _magazines pushBack [_class, 1, 1, _container];
    };
};

_magazines
