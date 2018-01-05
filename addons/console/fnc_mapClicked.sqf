/* ----------------------------------------------------------------------------
Author:
    fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
COMPILE_UI;

params ["_map","_button","_posX","_posY"];
private _pos = _map PosScreenToWorld [_posX, _posY];

if (_button isEqualto 0) then {
    //Left mouse button
    switch (GVAR(mapClickType)) do {
        case (10): {
            //Teleport
            GVAR(unit) setPosATL _pos;
            [GVAR(unit),"Teleported", "_name has been teleported to %1 by _player", mapGridPosition _pos] call fsh_fnc_aiLog;
            hint format ["%1 dropped at %2", GVAR(unit), _pos];
            GVAR(mapClickType) = 0;
        };
        case (11): {
            //Move
            [GVAR(unit), _pos, "AUTO"] call fsh_fnc_doMove;
            hint format["%1 is moving to %2", GVAR(unit), mapGridPosition _pos];
            GVAR(mapClickType) = 0;
        };
        default {
            if (!(GVARMAIN(selectedGroup) isEqualto grpNull)) then {
                hint format ["Snapping to %1", groupID GVARMAIN(selectedGroup), _map];
                _map ctrlMapAnimAdd [MAP_SPEED, MAP_ZOOM, leader GVARMAIN(selectedGroup)];
                ctrlMapAnimCommit _map;
            };
            //systemChat format ["%1 (%3)", _pos, _button, GVAR(mapClickType)];
        };
    };
};
