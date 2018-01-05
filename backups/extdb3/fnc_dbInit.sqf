/* ----------------------------------------------------------------------------
Description:
    This function will initiate the database and load any protocols.
    If locking is enabled, a random password is generated and saved to ui.

Parameters:
    0: server id. The header name in extdb3-conf.ini
    1: array of protocols.
        0: handle name
        1: file name (located in sql_custom). Include .ini on the end!
    2: bool: lock db (default false)

Returns:
    bool: true if database setup ok

Examples:
    ["test", [["goon", "test.ini"]], true] call fsh_fnc_dbInit;

Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"

if (!isServer) exitWith {WARNING("Called server side script on client"); false};

params [
    ["_server", "server", [""]],
    ["_protocols", [], [[]]],
    ["_lock", false, [false]],
    ["_forceRun", false, [false]]
];

private _lastCall = uiNamespace getVariable [QGVAR(params), []];
if (_lastCall isEqualto _this && !_forceRun) exitWith {LOG("extDB3 params are unchanged: skipping settup"); true};

uiNamespace setVariable [QGVAR(params), _this];

private _password = uiNamespace getVariable [QGVAR(password), str (floor(random 999999))];
uiNamespace setVariable [QGVAR(password), _password];

if (_lock) then {
    call compile ("extDB3" callExtension format["9:UNLOCK:%1", _password]);
    LOG_1("db unlocking");
};

//Reset the database
"extDB3" callExtension "9:RESET";

// extDB3 Version Check
private _result = "extDB3" callExtension "9:VERSION";
LOG_1("extDB3 version: %1", _result);

if (_result isEqualto "") exitWith {ERROR("Failed to Load extDB3 extention"); false};
if ((parseNumber _result) < 1.026) exitWith {ERROR("extDB3 version 1.026 or Higher Required"); false};

// extDB3 Connect to Database
_result = call compile ("extDB3" callExtension format["9:ADD_DATABASE:%1", _server]);
if (_result select 0 isEqualTo 0) exitWith {ERROR_1("extDB3: Error Failed to Connect to Database: %1", _result); false};
LOG("Connected to Database");
uiNamespace setVariable [QGVAR(connected), true];
// extDB3 Load Protocols
//Include predefined protocols
_predef = [
    [FC_SQL, FC_SQL_INI],
    [FC_SQL_PD, FC_SQL_PD_INI]
];
_protocols append _predef;
{
    _x params [
        ["_id", "DEFAULT", [""]],
        ["_file", "DEFAULT.ini", [""]]
    ];
    _result = call compile ("extDB3" callExtension format["9:ADD_DATABASE_PROTOCOL:%1:SQL_CUSTOM:%2:%3", _server, _id, _file]);
    if ((_result select 0) isEqualTo 0) then {
        WARNING_2("Failed to load protocol %1, %2", _id, _file);
    } else {
        LOG_1("Initalized SQL_CUSTOM Protocol %1", _id);
    };
} forEach _protocols;



// extDB3 Lock
if (_lock) then {
    call compile ("extDB3" callExtension format["9:LOCK:%1", _password]);
    LOG_1("extDB3 locked with code %1", _password);
};
