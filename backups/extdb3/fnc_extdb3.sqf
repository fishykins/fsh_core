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
//#include "script_component.hpp"

params [
    "_callType",
    "_id",
    "_function",
    ["_params", [], [[]]]
];

_queryArray = [_callType, _id, _function] + _params;
private _query = _queryArray joinString ":";

//diag_log format["[EXTDB3 CALL]: %1", _query];

private _return = call compile ("extDB3" callExtension _query);

if (isNil "_return") exitWith {true};

_return
