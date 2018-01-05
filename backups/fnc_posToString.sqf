/* ----------------------------------------------------------------------------
Function: FSH_fnc_posToString (DEPRECIATED)
Description:
    Turns a position into a string of the defined length. 
Parameters:
    POSITION- can be either object, array (2d or 3d) or string. 
    NUMBER- how many figures are required
Example:
    (begin example)
    _sixfigure = [[0,1,2], 6] call FSH_fnc_posToString // = "000001"
    (end example)
Returns:
    STRING
Author:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
#define DEFAULT_TRIM 3
private ["_xGrid","_yGrid","_xGridNew","_yGridNew","_trim","_return"];
params [["_location",player],["_figures",DEFAULT_TRIM*2]];


/*
if (_location isEqualType objNull) then {
    _location = getPos _location;
} else {
    if (_location isEqualType "") then {
        _location = getMarkerPos _location;
    };
};

if (!(_location isEqualType [])) exitWith {
    WARNING_1('location cannot be found',_location);
    ""
};

_trim = floor (_figures/2);
if (_trim < DEFAULT_TRIM) then {_trim = DEFAULT_TRIM;};

_xGrid = floor((_location select 0)/100);
_yGrid = floor((_location select 1)/100);

_xGridNew = [_xGrid, _trim] call CBA_fnc_formatNumber;
_yGridNew =[_yGrid, _trim] call CBA_fnc_formatNumber;

_return = format['%1%2', _xGridnew, _yGridnew];
_return */

(mapGridPosition _location)