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
    "_uid",
    ["_map", "any", [""]],
    ["_hive", "default", [""]],
    ["_name", "nameAny", [""]],
    ["_autoAdd", false, [false]]
];

private _profileIndex = -1;
private _sessionIndex = -1;

//Get player primary key
private _sessionData = [0, FC_SQL_PD, "get_player_id", [_uid, _map, _hive]] call fsh_fnc_extdb3;

//Get profile primary key
private _profileData = [0, FC_SQL_PD, "get_player_profile", [_uid]] call fsh_fnc_extdb3;

//diag_log format ["Session data: %1", _sessionData];
//diag_log format ["Profile data: %1", _profileData];

if (_profileData select 1 isEqualto []) then {

    //Set profile data to -1
    _profileIndex = -1;

    //If autoAdd, create
    if (_autoAdd) then {
        _profileData = ([0, FC_SQL_PD, "add_player_profile", [_uid,_name]] call fsh_fnc_extdb3);

        //diag_log format ["added profile: %1", _profileData];

        _profileIndex = _profileData select 1 select 0;
    };
} else {
    _profileIndex = _profileData select 1 select 0 select 0;
};


//Check session id
if (_sessionData select 1 isEqualto []) then {

    //No player id found- if autoAdd then add it, otherwise return -1
    _sessionIndex = -1;

    if (_autoAdd && _profileIndex != -1) then {
        //Create player in DB
        _sessionData = ([0, FC_SQL_PD, "add_player_id", [_profileIndex,_map,_hive]] call fsh_fnc_extdb3);

        //diag_log format ["added player: %1", _sessionData];

        _sessionIndex = _sessionData select 1 select 0;

        //Create table entries
        [0, FC_SQL_PD, "add_player_position", [_sessionIndex]] call fsh_fnc_extdb3;
        [0, FC_SQL_PD, "add_player_health", [_sessionIndex]] call fsh_fnc_extdb3;
        [0, FC_SQL_PD, "add_player_gear", [_sessionIndex]] call fsh_fnc_extdb3;
    };
} else {
    _sessionIndex = _sessionData select 1 select 0 select 0;
};



//Return [player id, profile id]
[_sessionIndex, _profileIndex]
