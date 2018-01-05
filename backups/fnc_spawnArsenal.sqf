/* ----------------------------------------------------------------------------
Function: FSH_fnc_spawnArsenal

Description:
    Adds Virtual Arsenal to an obejct. Can do fun things, based on faction.

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
    ["_object", "", [objNull]],
    ["_gear", [], [[],true, ""]],
    ["_factions", [], ["",[]]],
    ["_gearParents", [], ["",[]]]
];

if (_object isequalTo ObjNull) exitWith {WARNING("no object provided!");};

if (IS_STRING(_gear)) then {
    _factions = [_gear];
    _gear = [];
};
//if they have passed a bool, spawn it empty/full and run away giggling.
if (IS_BOOL(_gear)) exitWith {
    if (!(_object getVariable [QGVAR(vaInit), false])) then {
        private _nul = ["AmmoboxInit",[_object,_gear,{true}]] spawn BIS_fnc_arsenal;
        _object setVariable [QGVAR(vaInit), true, false];
    };
    true
};

if (IS_STRING(_gearParents)) then {_gearParents = [_gearParents];};
if (IS_STRING(_factions)) then {_factions = [_factions];};

//==============================================//

if (!(_object getVariable [QGVAR(vaInit), false])) then {
    private _nul = ["AmmoboxInit",[_object,false,{true}]] spawn BIS_fnc_arsenal;
    _object setVariable [QGVAR(vaInit), true, false];
};

//==============================================//

private _allFactions = [];
private _allWeapons = [];
private _allitems = [];
private _allMagazines = [];
private _allBackpacks = [];

private _parentWeapons = [];
private _parentMags = [];
private _parentItems = [];
private _parentBackpacks = [];

//------------------------------------------------------------------------------//
//------------------------------ PASSED GEAR------------------------------------//
//------------------------------------------------------------------------------//
//Add passed gear if there is any
if (!(_gear isEqualto [])) then {
    _gear params [
        ["_weapons", [] ],
        ["_magazines", [] ],
        ["_backpacks", [] ],
        ["_items", [] ]
    ];

    _allWeapons append _weapons;
    _allitems append _items;
    _allMagazines append _magazines;
    _allBackpacks append _backpacks;
};

//------------------------------------------------------------------------------//
//------------------------------- FACTIONS -------------------------------------//
//------------------------------------------------------------------------------//
//We can also add gear for entier factions, because we good like that
{
    _paramFaction = _x;
    _composition = missionconfigFile >> "CfgCompositions" >> "arsenal" >> _paramFaction;
    if (isClass _composition) then {
        //this faction has an arsenal config- get all the data
        private _facts = getArray (_composition >> "factions");
        {
            _allFactions pushBackUnique _x;
        } forEach _facts;

        //MAGIC CLASSES THAT INCLUDE CHILDREN
        private _config = _composition >> "objectParents";
        _parentWeapons append (getArray (_config >> "weapons"));
        _parentMags append (getArray (_config >> "magazines"));
        _parentBackpacks append (getArray (_config >> "backpacks"));
        _parentItems append (getArray (_config >> "uniforms"));
        _parentItems append (getArray (_config >> "vests"));
        _parentItems append (getArray (_config >> "headgear"));
        _parentItems append (getArray (_config >> "miscItems"));

        //SIMPLE CLASSES THAT ONLY ADD THEMSELVES
        _config = _composition >> "objects";
        _allWeapons append (getArray (_config >> "weapons"));
        _allMagazines append (getArray (_config >> "magazines"));
        _allBackpacks append (getArray (_config >> "backpacks"));
        _allitems append (getArray (_config >> "uniforms"));
        _allitems append (getArray (_config >> "vests"));
        _allitems append (getArray (_config >> "headgear"));
        _allitems append (getArray (_config >> "miscItems"));

    } else {
        _allFactions pushBackUnique _paramFaction;
    };
} forEach _factions;

{
    private _gear = [_x] call fsh_fnc_factionGear;
    _gear params ["_weapons","_magazines","_backpacks","_items"];
    _allWeapons append _weapons;
    _allitems append _items;
    _allMagazines append _magazines;
    _allBackpacks append _backpacks;
} forEach _allFactions;

//------------------------------------------------------------------------------//
//---------------------------- DYNAMIC OBJECTS ---------------------------------//
//------------------------------------------------------------------------------//
//======= WEAPONS ========//
if (count (_parentWeapons append _parentItems) > 0) then {
    _parentWeapons = _parentWeapons apply {tolower _x};
    _parentItems = _parentItems apply {tolower _x};

    private  _config = configfile >> "cfgWeapons";

    for [{private _i=0}, {_i<(count _config)}, {_i=_i+1}] do
    {
        private _wpn = _config select _i;
        if (isClass _wpn) then {
            private _scope = getNumber (_wpn >> "scope");
            if (_scope >=2 ) then {
                private _config = ([_wpn, true] call BIS_fnc_returnParents) apply {toLower _x};
                if (count (_parentItems arrayIntersect _config) > 0) then {
                    _allitems pushBackUnique (configName _wpn);
                } else {
                    if (count (_parentWeapons arrayIntersect _config) > 0) then {
                        _allWeapons pushBackUnique (configName _wpn);
                    };
                };
            };
        };
    };
};
//======= MAGAZINES ========//
if (count _parentMags > 0) then {
    _parentMags = _parentMags apply {tolower _x};

    private  _config = configfile >> "cfgMagazines";

    for [{private _i=0}, {_i<(count _config)}, {_i=_i+1}] do
    {
        private _mag = _config select _i;
        if (isClass _mag) then {
            private _scope = getNumber (_mag >> "scope");
            if (_scope >=2 ) then {
                private _config = ([_mag, true] call BIS_fnc_returnParents) apply {toLower _x};
                if (count (_parentMags arrayIntersect _config) > 0) then {
                    _allMagazines pushBackUnique (configName _mag);
                };
            };
        };
    };
};

//======= VEHICLES ========//
if (count _parentBackpacks > 0) then {
    _parentBackpacks = _parentBackpacks apply {tolower _x};

    private  _config = configfile >> "cfgVehicles";

    for [{private _i=0}, {_i<(count _config)}, {_i=_i+1}] do
    {
        private _pack = _config select _i;
        if (isClass _pack) then {
            private _scope = getNumber (_pack >> "scope");
            if (_scope >=2 ) then {
                private _config = ([_pack, true] call BIS_fnc_returnParents) apply {toLower _x};
                if (count (_parentMags arrayIntersect _config) > 0) then {
                    _allBackpacks pushBackUnique (configName _pack);
                };
            };
        };
    };
};
//------------------------------------------------------------------------------//
//--------------------------------- PROCESS ------------------------------------//
//------------------------------------------------------------------------------//

[_object,_allWeapons] call BIS_fnc_addVirtualWeaponCargo;
[_object,_allitems] call BIS_fnc_addVirtualItemCargo;
[_object,_allMagazines] call BIS_fnc_addVirtualMagazineCargo;
[_object,_allBackpacks] call BIS_fnc_addVirtualBackpackCargo;

true
