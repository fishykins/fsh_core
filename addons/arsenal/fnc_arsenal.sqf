/* ----------------------------------------------------------------------------
Function: FSH_fnc_arsenal

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

if (!(IS_ARRAY(_this))) exitWith {ERROR_1("NOT ARRAY: %1", _this);};

private _exit = false;

params [
    ["_object", "", [objNull]],
    ["_function", "", [""]],
    ["_dataType", "", [""]],
    ["_data", [], ["",[]]],
    ["_global", true, [true]]
];

if (_object isequalTo ObjNull) exitWith {WARNING("no object provided!");};
if (IS_STRING(_data)) then {_data = [_data];};
_function = toLower _function;
_dataType = toLower _dataType;
//==============================================//

switch (_function) do {
    case ("init"): {
        private _bool = (_dataType isEqualto "full");
        private _condition = {_target getVariable [QGVAR(enabled), false]};
        _object setVariable [QGVAR(condition), _condition, true];
        private _nul = ["AmmoboxInit",[_object,_bool,_condition]] spawn BIS_fnc_arsenal;
        _exit = true;
    };
    case ("add");
    case ("remove"): {};
    case ("fill");
    case ("clear"): {
        [_object,_function,_global] call fsh_fnc_arsenalGear;
        _exit = true;
    };
    default {
        WARNING_1("Function %1 unrecognised");
        _exit = true;
    };
};

if (_exit) exitWith {false};
//==============================================//

private _faction = "";

private _allWeapons = [];
private _allitems = [];
private _allMagazines = [];
private _allBackpacks = [];

private _parentWeapons = [];
private _parentMags = [];
private _parentItems = [];
private _parentBackpacks = [];

//==============================================//

switch (_dataType) do {
    case ("faction"): {
        WARNING("function faction depreciated");
        _exit = true;
    };
    case ("items"): {
        //------------------------------------------------------------------------------//
        //-------------------------------- PASSED ITEMS --------------------------------//
        //------------------------------------------------------------------------------//
        _data params [
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
    case ("parents"): {
        //------------------------------------------------------------------------------//
        //----------------------------- PASSED PARENTS ---------------------------------//
        //------------------------------------------------------------------------------//
        _data params [
            ["_weapons", [] ],
            ["_magazines", [] ],
            ["_backpacks", [] ],
            ["_items", [] ]
        ];

        _parentWeapons append _weapons;
        _parentItems append _items;
        _parentMagazines append _magazines;
        _parentBackpacks append _backpacks;
    };
    case ("full"): {
        //------------------------------------------------------------------------------//
        //------------------------------- FULL ARSENAL ---------------------------------//
        //------------------------------------------------------------------------------//
        ["AmmoboxExit",[_object,true]] call BIS_fnc_arsenal;
        ["AmmoboxInit",[_object,true]] call BIS_fnc_arsenal;
        _exit = true;
    };
    default {
        //------------------------------------------------------------------------------//
        //----------------------------- PASSED FACTIONS --------------------------------//
        //------------------------------------------------------------------------------//
        _faction = _dataType;
        private _factionData = FACTION_GNS(_faction,"arsenalData","undefined");
        if (!(_factionData isEqualTo "undefined")) then {
            //This faction has already been done, dont bother running the rest of the code
            [_object,_function,_global,_factionData] call fsh_fnc_arsenalGear;
            _exit = true;
        } else {
            _composition = missionconfigFile >> "CfgCompositions" >> "arsenal" >> _faction;
            if (isClass _composition) then {
                //this faction has an arsenal config- get all the data

                //Get gear from any passed factions within the class.
                private _facts = getArray (_composition >> "factions");
                {
                    private _gear = [_x] call fsh_fnc_factionGear;
                    _gear params ["_weapons","_magazines","_backpacks","_items"];
                    _allWeapons append _weapons;
                    _allitems append _items;
                    _allMagazines append _magazines;
                    _allBackpacks append _backpacks;
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
                //No faction composition found, so grab the gear using drag and drop method
                if ([_faction] call fsh_fnc_isFaction) then {
                    private _gear = [_faction] call fsh_fnc_factionGear;
                    _gear params ["_weapons","_magazines","_backpacks","_items"];
                    _allWeapons append _weapons;
                    _allitems append _items;
                    _allMagazines append _magazines;
                    _allBackpacks append _backpacks;
                } else {
                    WARNING("Datatype does not match any recognised format");
                    _exit = true;
                };
            };
        };
    };
};

if (_exit) exitWith {false};

//------------------------------------------------------------------------------//
//---------------------------- DYNAMIC OBJECTS ---------------------------------//
//------------------------------------------------------------------------------//
//Both "faction" and "parent" use this, so run every time
//======= WEAPONS ========//
if (count (_parentWeapons + _parentItems) > 0) then {
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
private _return = [_allWeapons,_allitems,_allMagazines,_allBackpacks];

if (!(_faction isEqualto "")) then {
    FACTION_SNS(_faction,"arsenalData", _return);
};

[_object,_function,_global,_return] call fsh_fnc_arsenalGear;

_return
