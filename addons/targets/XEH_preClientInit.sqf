#include "script_component.hpp"

GVAR(showTargetHits) = false;
GVAR(impactTracers) = false;
GVAR(targetViewRange) = DEFAULT_VIEWRANGE;


FUNC(checkTarget) = {hint "looks ok to me";};

FUNC(targetHudInit) = {
    disableSerialization;
    private _ui = (_this select 0) select 0;
    uiNamespace setVariable [QGVAR(console), _ui];
};

FUNC(targetHudExit) = {

};

FUNC(targetHit) = {
    disableSerialization;

    if (!GVAR(showTargetHits)) exitWith {};

    (_this select 0) params ["_object","_shooter","_bullet","_position","_velocity","_ammo","_direction"];
    _position = ASLToAGL _position;
    private _offset = _object worldToModel _position;
    private _speed = sqrt ( (_velocity select 0)^2 + (_velocity select 1)^2 + (_velocity select 2)^2 );
    private _model = getText (configFile >> "CfgVehicles" >> typeOf _object >> "model");



    //Save basic data to target
    _object setVariable [QGVAR(lastHit), _position, false];
    _object setVariable [QGVAR(lastShooter), _shooter, false];

    //Work out how big the hud can be, based on distance to target
    private _mod = (GVAR(targetViewRange) / (player distance _object)) min 1;

    //Display the hud if allowed
    if (_shooter isEqualto player && _mod > 0.1) then {
        cutRsc [QGVAR(targetHitMarker),"PLAIN"];
        private _ui = uiNamespace getVariable [QGVAR(console), -1];
        private _ctrlTarget = _ui displayCtrl IDC_OBJECT_TARGET;
        private _ctrlPointer = _ui displayCtrl IDC_OBJECT_POINTER;

        private _scale = HUD_SCALE * _mod;
        private _targetModelOffset = (getArray (configFile >> "CfgVehicles" >> typeOf _object >> "targetModelOffset")) apply {_x * _scale};

        _ctrlTarget ctrlSetModel _model;
        _ctrlTarget ctrlSetPosition ((ctrlPosition _ctrlTarget) vectorAdd _targetModelOffset);
        _ctrlTarget ctrlSetModelScale _scale;

        private _x = (_offset select 0) * (_scale * 2);
        private _y = 0;
        private _z = 0 - ((_offset select 2) * (_scale * 2.2));
        private _pointerPos = ctrlPosition _ctrlTarget vectorAdd [_x, _y, _z];

        _ctrlPointer ctrlSetPosition _pointerPos;
        _ctrlPointer ctrlSetModelScale _scale;

        hintSilent format ["Scale: %1", _scale];
    };


    //Display a physical marker on the target
    if (_object getVariable ["fsh_showHits", false] || GVAR(impactTracers)) then {
        _pointer = "Sign_Sphere10cm_F" createVehicleLocal _position;
        _pointer attachTo [_object, _offset];
        private _red = random 1;
        private _green = random 1;
        private _blue = random 1;
        _pointer setObjectTexture [0,format["#(argb,8,8,3)color(%1,%2,%3,1.0,ca)", _red, _green, _blue]];
        _pointer spawn {
        	sleep 3;
        	deleteVehicle _this;
        };
    };

    //hintSilent format ["Z Offset: %1, poinerPos: %2, _targetModelOffset: %3", _offset select 2, _pointerPos select 2, _targetModelOffset];
};
