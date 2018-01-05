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

if (!isServer) exitWith {};

params [
    ["_pk", -1, [1]]
];

private _idData = [0, FC_SQL_OBJ, "get_object_id", [_pk]] call fsh_fnc_extdb3;
if (_idData select 0 isEqualto 0) exitWith {ERROR_1("Could not retreive object id: %1", (_idData select 1)); []};
_idData = _idData select 1 select 0;

private _posData = [0, FC_SQL_OBJ, "get_object_position", [_pk]] call fsh_fnc_extdb3;
if (_posData select 0 isEqualto 0) exitWith {ERROR_1("Could not retreive position data: %1", (_posData select 1)); []};
_posData = _posData select 1 select 0;

private _hitpointData = [0, FC_SQL_OBJ, "get_object_hitpoints", [_pk]] call fsh_fnc_extdb3;
if (_hitpointData select 0 isEqualto 0) exitWith {ERROR_1("Could not retreive hitpoint data: %1", (_hitpointData select 1)); []};
_hitpointData = _hitpointData select 1;

private _uid = _idData select 0;
private _class = _idData select 1;
private _pos = [_posData select 0, _posData select 1, _posData select 2];
private _dir = _posData select 3;
private _damage = _posData select 4;

private _objectData = [_pos, _class, false, _dir] call fsh_fnc_spawnvehicle;
private _object = _objectData select 0;

//Set it's ID to the saved one so it will save to correct place
_object setVariable [QGVARMAIN(uid), _uid, true];
private _oai = GVAR(objectIds) pushBackUnique _pk;
GVAR(objects) set [_oai, _object];

//Tag object so it will auto save.
[_object, true] call fsh_fnc_dbTagObject;

//remove all contents
clearItemCargoGlobal _object;
clearWeaponCargoGlobal _object;
clearMagazineCargoGlobal _object;

//Get items
private _itemData = [0, FC_SQL_OBJ, "get_object_items", [_pk]] call fsh_fnc_extdb3;
private _weaponData = [0, FC_SQL_OBJ, "get_object_weapons", [_pk]] call fsh_fnc_extdb3;
private _magazineData = [0, FC_SQL_OBJ, "get_object_magazines", [_pk]] call fsh_fnc_extdb3;

//Add items
{_object addItemCargoGlobal _x;} forEach (_itemData select 1);
{_object addWeaponCargoGlobal _x;} forEach (_weaponData select 1);
{_object addMagazineCargoGlobal _x;} forEach (_magazineData select 1);

//Set Damage
{_object setHitPointDamage _x;} forEach _hitpointData;

/* ----------------------------------------------------------------------------
                                    ACE3
---------------------------------------------------------------------------- */

//General ace data
private _aceData = [0, FC_SQL_OBJ, "get_object_ace", [_pk]] call fsh_fnc_extdb3;
if (_aceData select 0 isEqualto 0) exitWith {[]};
_aceData = _aceData select 1 select 0;

_aceData params [
    ["_loadedIn", -1, [0]]
];

//--------------------- LOGIC FOR CARGO --------------------//

private _aceCargo = ([0, FC_SQL_OBJ, "get_object_ace_cargo", [_pk]] call fsh_fnc_extdb3) select 1;

private _cargo = [];
//Load all ace cargo that has aready been spawned
{
    _x params ["_cargoPk","_cargoClass"];

    if (IS_NUMBER(_cargoPk)) then {
        //This is a real object- track down and load!
        private _index = GVAR(objectIds) find _cargoPk;

        //If index found, it has spawned already so we must add it
        if !(_index isEqualto -1) then {
            private _child = GVAR(objects) select _index;
            _cargo pushBack _child;
        };
    } else {
        //Just a virtual item, add it
        _cargo pushBack _cargoClass;
    };
} forEach _aceCargo;

_object setVariable [QGVAR(cargo), _cargo];

//--------------------- LOGIC FOR IF WE ARE THE CARGO --------------------//

//Load into container if it has already spawned
if !(_loadedIn isEqualto -1) then {
    private _index = GVAR(objectIds) find _loadedIn;

    //If index found, it has spawned already so we must add ourselves
    if (_index >= 0) then {
        private _parent = GVAR(objects) select _index;
        private _null = [_parent,_object] spawn FUNC(ace_cargo_addSelf);
    };
};

//SPAWN a wait loop that will re-initialize the cargo of this object once ace init has finished
private _null = [_object] spawn FUNC(ace_cargo_init);

true
