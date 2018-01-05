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
if (fsh_noSave || !isServer) exitWith {false};

private _defaultHive = uiNamespace getVariable [QGVAR(objectHive),"default"];
private _defaultWorld = uiNamespace getVariable [QGVAR(objectWorld),worldName];

params [
    ["_object", objNull, [objNull]],
    ["_map", _defaultWorld, [""]],
    ["_hive", _defaultHive , [""]]
];

private _uid = [_object] call fsh_fnc_getObjectUid;
private _tagged = _object getVariable [GVAR(vehicleSaveKey), false];
private _class = typeOf _object;

//A Tagged object cannot be saved- this is to prevent anyone other than the server doing such a thing.
if (!_tagged) exitWith {false};

//LOG_3("Saving object %1: map = %2 hive = %3", _object, _map, _hive);

//Get primary key (will add if none found)
private _pk = [_object, _map, _hive, true] call fsh_fnc_dbFindObject;

//Add save
private _saveId = ([0, FC_SQL_OBJ, "add_object_save", [_pk]] call fsh_fnc_extdb3) select 1 select 0;

//remove previous saves
[0, FC_SQL_OBJ, "remove_object_save", [_pk, _saveId]] call fsh_fnc_extdb3;

//Position
private _pos = getPosAtl _object;
private _params = [
    (_pos select 0) call cba_fnc_floatToString,
    (_pos select 1) call cba_fnc_floatToString,
    (_pos select 2) call cba_fnc_floatToString,
    direction _object,
    damage _object,
    _pk
];

[0, FC_SQL_OBJ, "set_object_position", _params] call fsh_fnc_extdb3;

//hitpoints
private _rawHitpoints = getAllHitPointsDamage _object;
if !(_rawHitpoints isEqualto []) then {
    private _hitPoints = _rawHitpoints call EFUNC(common,mapDamage);
    {
        _params = [_saveId, _pk] + _x;
        [0, FC_SQL_OBJ, "add_object_hitpoint", _params] call fsh_fnc_extdb3;
    } forEach _hitPoints;
};


//items, weapons + mags
private _items = ((getItemCargo _object) call EFUNC(common,mapItems));
private _weapons =((getWeaponCargo _object) call EFUNC(common,mapWeapons));
private _magazines = ((getMagazineCargo _object) call EFUNC(common,mapMagazines));

//Items
{
    [0, FC_SQL_OBJ, "add_object_item", [_pk, _saveId] + _x] call fsh_fnc_extdb3;
} forEach _items;

//Weapons
{
    [0, FC_SQL_OBJ, "add_object_weapon", [_pk, _saveId] + _x] call fsh_fnc_extdb3;
} forEach _weapons;

//Mags
{
    [0, FC_SQL_OBJ, "add_object_magazine", [_pk, _saveId] + _x] call fsh_fnc_extdb3;
} forEach _magazines;

/* ----------------------------------------------------------------------------
                                    ACE3
---------------------------------------------------------------------------- */
//Are we in cargo?
private _cargoObject = attachedTo _object;
private _cargoObjId = -1;

if !(_cargoObject isEqualto objNull) then {
    private _aceCargo = _cargoObject getVariable [QUOTE(TRIPLES(ACE,cargo,loaded)), []];
    if (_object in _aceCargo) then {
        _cargoObjId = [_cargoObject, _map, _hive, false] call fsh_fnc_dbFindObject;
    };
};

//Get our cargo items
private _aceCargo = _object getVariable [QUOTE(TRIPLES(ACE,cargo,loaded)), []];

//virtual objects will be added as is, real world objects will be checked for db entry. If found, this will be referenced.
//set GVAR(cargo_allowNonDBItems) to false and real world objects that are not saved in the DB will NOT be included in the save
{
    private _function = "add_object_ace_cargo_virtual";
    private _params = [_pk, _saveId, _x];

    if (IS_OBJECT(_x)) then {
        _params set [2, typeOf _x];

        private _cargoId = [_x, _map, _hive, false] call fsh_fnc_dbFindObject;

        if !(_cargoId isEqualto -1) then {
            _function = "add_object_ace_cargo";
            _params pushBack _cargoId;
        } else {
            if (!(GVAR(cargo_allowNonDBItems))) then {
                //Objects not saved to the db are blocked!
                _params = [];
            };
        };
    };

    if (!(_params isEqualto [])) then {
        [0, FC_SQL_OBJ, _function, _params] call fsh_fnc_extdb3;
    };
} forEach _aceCargo;

//Set ace table
_params = [
    _cargoObjId,
    _pk
];

//ACE CUSTOM KEYS
private _customKeys = _object getVariable ["ACE_vehiclelock_customKeys", []];
{
    _str = _x splitString "()[]:";
    _str params ["_description","_ammo", "_junk", "_id"];
    systemChat _id;
    [0, FC_SQL_OBJ, "add_object_ace_key", [_pk, _saveId, _id]] call fsh_fnc_extdb3;
} forEach _customKeys;


[0, FC_SQL_OBJ, "set_object_ace", _params] call fsh_fnc_extdb3;

true
