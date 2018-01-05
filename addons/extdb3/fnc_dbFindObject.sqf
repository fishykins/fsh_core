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

params [
    ["_object", objNull, [objNull]],
    ["_map", "any", [""]],
    ["_hive", "default", [""]],
    ["_autoAdd", false, [false]]
];

private _uid = [_object] call fsh_fnc_getObjectUid;
private _class = typeOf _object;

private _objectIndex = -1;

//Get object primary key
private _objectData = [0, FC_SQL_OBJ, "get_object_pk", [_uid,_class,_map,_hive]] call fsh_fnc_extdb3;

if (_objectData select 1 isEqualto []) then {

    //If autoAdd, create
    if (_autoAdd) then {
        _objectData = ([0, FC_SQL_OBJ, "add_object_id", [_uid,_class,_map,_hive]] call fsh_fnc_extdb3);
        _objectIndex = _objectData select 1 select 0;

        [0, FC_SQL_OBJ, "add_object_position", [_objectIndex]] call fsh_fnc_extdb3;
        [0, FC_SQL_OBJ, "add_object_ace", [_objectIndex]] call fsh_fnc_extdb3;
    };
} else {
    _objectIndex = _objectData select 1 select 0 select 0;
};

_objectIndex
