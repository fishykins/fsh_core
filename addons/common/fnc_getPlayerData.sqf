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

private _aceKeys = [];
{
    _str = _x splitString "()[]:";
    _str params ["_description","_ammo", "_junk", "_id"];
    if (_description isEqualto ACE_KEY_DESCRIPTION) then {
        _aceKeys pushBack _id;
    };
} forEach (magazinesDetail _unit);


private _data = [
	getPosAtl _unit,
    getDir _unit,
    stance _unit,

    damage _unit,
    getOxygenRemaining _unit,
	getBleedingRemaining _unit,
    (getAllHitPointsDamage _unit) call FUNC(mapDamage),

    uniform _unit,
    vest _unit,
    backpack _unit,
    headgear _unit,
    goggles _unit,
	assignedItems _unit,
	currentWeapon _unit,

    [_unit] call fsh_fnc_getUnitWeapons,
    [_unit] call fsh_fnc_getUnitItems,
    [_unit,"NOACEKEYS"] call fsh_fnc_getUnitMagazines,
    _aceKeys,

    name _unit
];

/*
diag_log "======================= GET PD ===========================";
{
    //diag_log format ["%1: %2 = %3", _forEachIndex, typeName _x, _x];
    diag_log str _x;
} forEach _data;
diag_log "==========================================================";
*/

_data
