_null = _this spawn {
    sleep 1;
    params ["_group", "_position"];
    [_group, _position] call fsh_fnc_atEase;
};