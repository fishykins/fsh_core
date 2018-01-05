/* ----------------------------------------------------------------------------
Function: FSH_fnc_spawnVehicle

Description:
    spawns a vehicle with given paramiters

Parameters:
    1. position- where to spawn <MARKER, OBJECT or posATL> . If Z is more than 5 will attempt to make it fly
    2. vehicle- class to spawn. <STRING or CONFIG>
    3. GROUP, SIDE or BOOL
            GROUP- pre-exsisting group to add crew to. grpNull spawns no crew
            SIDE (INT or STRING or SIDE): side to add vehicle crew to.
            BOOL- if bool of any kind, no crew will be spawned.
    4. SCALAR- direction. Default random
    4. ARRAY- extra params

Extra Params
    "SAFE" turn off damage for five seconds while spawn happens
    "CREW" spawn a crew

Returns:
    config

Example:
    (begin example)

    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
#define FLY_HEIGHT 2
#define SAFE_POS [-1000,-1000,1000]

private TIME_MARKER(_start);

params [
    ["_position","",["",objNull,[]]],
    ["_class","",["",configNull]],
    ["_groupData",false],
    ["_direction",random(360),[0]]
];

if (IS_CONFIG(_class)) then {_class = configName _class;};
if (!(IS_STRING(_class))) exitWith {WARNING_1("failed to spawn '%1', class not valid", _class); [objNull, grpNull]};
_position = [_position] call cba_fnc_getPos;

SWITCH_POS_ATL(_position,[]);
if (_position isEqualTo []) exitWith {WARNING_1("failed to spawn '%1', no position given", _class); [objNull, grpNull]};


private _safeMode = ("safe" in _this);
private _flying = ("FLY" in _this);
private _simple = ("SIMPLE" in _this);

if (_flying) then {_position set [2,50];};



//=====================================================================
//spawn vehicle
private _vehicle = objNull;

if (_simple) then {
    _vehicle = createSimpleObject [_class, SAFE_POS];
    //This object will spawn at model center, so move it up so it sits on the ground
    private _boundingBox = boundingBoxReal _vehicle;
    private _center = boundingCenter _vehicle;
    private _p1 = _boundingBox select 0;
    private _p2 = _boundingBox select 1;
    private _maxHeight = abs ((_p2 select 2) - (_p1 select 2));
    _position set [2, (_position select 2) + (_maxHeight)];

} else {
    if (_position select 2 > FLY_HEIGHT) then {
        private _simulation = getText(configFile >> "CfgVehicles" >> _class >> "simulation");
        switch (tolower _simulation) do {
            case "airplanex";
            case "helicopterrtd";
            case "helicopterx": {
                _vehicle = createVehicle [_class,SAFE_POS,[],0,"FLY"];
                _vehicle flyInHeight (_position select 2);
            };
            default {_vehicle = _class createVehicle SAFE_POS;};
        };
    } else {
        _vehicle = _class createVehicle SAFE_POS;
    };
};

if (isNull _vehicle) exitWith {WARNING_1("failed to spawn '%1', not sure why...", _class); [objNull,grpNull]};

if (_safeMode) then {
    _vehicle allowDamage false;
    private _null = _vehicle spawn {
        sleep 2;
        _this allowDamage true;
    };
};

_vehicle setDir _direction;
_vehicle setPos _position;

/*
//Create a marker if required
if (!(_markerColour isEqualto "none")) then {
    [format ["%1_spawnPos", _vehicle],_position,"ICON",[1,1],"COLOR:",_markerColour,"TYPE:","MIL_DOT"] call CBA_fnc_createMarker;
};
*/

if (_simple) exitWith {[_vehicle, [], grpNull]};
//=====================================================================
//spawn group
private _group = grpNull;
private _crew = [];

if (!(IS_BOOL(_groupData)) && !(_groupData isEqualTo grpNull)) then {
    if (IS_GROUP(_groupData)) then {
        _group = _groupData;
    } else {
        SWITCH_SIDE(_groupData,(side player));
        if (IS_SIDE(_groupData)) then {_group = createGroup _groupData;};
    };
};

if (!(_group IsEqualTo grpNull) && IS_GROUP(_group)) then {
    createVehicleCrew _vehicle;
    _crew = crew _vehicle;
    _crew joinsilent _group;
    _group addVehicle _vehicle;
};

//=====================================================================
[_vehicle,_crew,_group]
