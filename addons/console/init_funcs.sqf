#include "script_component.hpp"

FUNC(teleport) = {
    GVAR(mapClickType) = 10;
    hint "Left click on map to teleport unit";
};

FUNC(doMove) = {
    GVAR(mapClickType) = 11;
    hint "Left click on map to select target location";
};

FUNC(regroup) = {
    hint "Regrouping";
    [GVAR(unit), "regroup"] call fsh_fnc_doMove;
};

FUNC(kill) = {
    GVAR(unit) setDamage 1;
    hint "He's dead dave";
};

FUNC(heal) = {
    GVAR(unit) setDamage 0;
    hint "healed";
    [GVAR(unit),"Healed", "_name has been healed by _player"] call fsh_fnc_aiLog;
};

FUNC(immortal)  ={
    GVAR(unit) allowDamage false;
    [GVAR(unit),"Immortal", "_name has been made immortal by _player"] call fsh_fnc_aiLog;
    hint "God mode activated";
};

FUNC(mortal) = {
    GVAR(unit) allowDamage true;
    [GVAR(unit),"Mortal", "_name has been made mortal by _player"] call fsh_fnc_aiLog;
    hint "God mode de-activated";
};

FUNC(aiTrackingMarkers) = {
    if (GVAR(updating)) exitWith {};
    private _object = if (GVAR(unit) isEqualto objNull) then {GVAR(group)} else {GVAR(unit)};
    [_object, _this select 1] call fsh_fnc_track;
    //hint format ["%1 is tracking at level %2", _object, _this select 1];
};

FUNC(executeCommand) = {
    COMPILE_UI;
    private _object = if (GVAR(unit) isEqualto objNull) then {GVAR(group)} else {GVAR(unit)};
    private _index = lbCurSel _ui_ai_list_funcs;
    private _function = compile (_ui_ai_list_funcs lbData _index);
    call _function;
    //hint format["index = %1, function = %2", _index, _function];
};

FUNC(sliderColChanged) = {
    params ["_cotrol","_amount","_index"];
    private _object = GVAR(selected);
    private _colour = ([_object, 1] call FUNC(getObjectColour));
    //private _trackingLevel = _object getVariable [QGVARMAIN(trackingLevel), 0];
    _colour set [_index, _amount/10];
    [_object, _colour] call FUNC(setColour);
};

FUNC(resetColour) = {
    private _object = if (GVAR(unit) isEqualto objNull) then {GVAR(group)} else {GVAR(unit)};
    [_object,[]] call FUNC(setColours);
    hint "Colour reset";
    //call FUNC(refresh);
};

FUNC(applyTrackingToUnits) = {
    private _trackingLevel = GVAR(group) getVariable [QGVARMAIN(trackingLevel), 0];
    {
        [_x, _trackingLevel] call fsh_fnc_track;
    } forEach (units GVAR(group) - [leader GVAR(group)]);
    hint "units tracking updated";
};

FUNC(linkGroupColours) = {
    private _colour = GVAR(group) call FUNC(getObjectColour);
    {
        _x setVariable [QGVAR(colour), _colour, false];
    } forEach (units GVAR(group));
    hint "group colour linked";
};

FUNC(unlinkGroupColours) = {
    {
        _x setVariable [QGVAR(colour), [], false];
    } forEach (units GVAR(group));
    hint "group colour unlinked";
};

FUNC(applyColourToUnits) = {
    private _colour = GVAR(group) call FUNC(getObjectColour);
    {
        _x setVariable [QGVAR(colour), _colour, false];
    } forEach (units GVAR(group) - [leader GVAR(group)]);
    hint "units tracking updated";
};

FUNC(showWaypoints) = {
    hint "Waypoints will now show for this group";
};

FUNC(setColour) = {
    params [
        "_object",
        ["_colour", [1,1,1,1], [], 4]
    ];
    //hintsilent format ["%1 setting colour: %2", _object, _colour];
    _object setVariable [QGVAR(colour), _colour];
    private _index = _object getVariable [QGVAR(consoleIndex), []];
    if (!(_index isEqualTO [])) then {
        COMPILE_UI;
        _ui_main_list_left tvSetColor [_index, _colour];
    };
};
