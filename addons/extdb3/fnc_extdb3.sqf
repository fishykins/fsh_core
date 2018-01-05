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
    "_callType",
    "_id",
    "_function",
    ["_params", [], [[]]],
    ["_bugFix", false, [false]]
];

_queryArray = [_callType, _id, _function] + _params;
private _query = _queryArray joinString ":";

//diag_log format["[EXTDB3 CALL]: %1", _query];

private _return = call compile ("extDB3" callExtension _query);
if (_bugFix) then {
    call compile ("extDB3" callExtension format["1:%1:preparedStatement_bugfix", FC_SQL]);
};

if (isNil "_return") exitWith {true};

if (_return select 1 isEqualto 0) then {
    ERROR_2("Function %1 returned error: %2", _function, _return select 2);
};

_return
