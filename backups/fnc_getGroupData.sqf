/* ----------------------------------------------------------------------------
Function: FSH_fnc_getGroupData

Description:
    returns useful data about the given group (see returns).

Parameters:
    group- can be unit, group, config name, or config.

Returns:
    0. Array of marker details
    1. Side (numerical)
    2. Array of group types
    3. Number of units in group
    4. Vehicle types in group

Example:
    (begin example)
        _data = [configGroup] call FSH_fnc_getGroupData;
    (end example)

Authors:
    Fishy
---------------------------------------------------------------------------- */
#include "script_component.hpp"
private _startTime = diag_tickTime;
params [
    ["_data", grpNull, ["",grpNull,objNull,configNull]]
];

//-----------Return params-------------
private _marker = "n_unknown";
private _markerPrefix = "n";
private _markerSuffix = 'unknown';
private _markerColor = "colorGUER";
private _side = civilian;
private _groupTypes = [];
//-------------------------------------
private _units = [];
private _infantry = [];
private _vehicles = [];
private _vehicleParents = [];
private _vehicleCount = 0;
private _hasArtillery = 0;

if (_data isEqualTo grpNull) exitWith {[[_marker,_markerColor], _side, _groupTypes]};

//===============================================================================
//===============================================================================

if (IS_OBJECT(_data) || IS_GROUP(_data)) then {
    private _group = [_data] call cba_fnc_getGroup;
    private _leader = leader _group;
    _units = units _group;
    _side = side _leader;
    {
        private _unit = _x;
        if (vehicle _unit != _unit) then {
            _vehicles pushBackUnique (typeof (vehicle _unit));
        } else {
            _infantry pushBack (typeof (vehicle _unit));
        };
    } forEach _units;

    _units apply {typeOf _x};

} else {
    private _groupConfig = [_data] call fsh_fnc_getGroupConfig;
    _side = getNumber (_groupConfig >> "side");
    private _unitArray = configProperties [_groupConfig, "count _x > 0", true];
    {
        private _vehicle = getText(_x >> "vehicle");
        private _vehicleConfig = [_vehicle] call CBA_fnc_getObjectConfig;
        _units pushBack _vehicle;
        private _isMan = getNumber (_vehicleConfig >> "isMan");
        if (!(_isMan isEqualto 1)) then {
            _vehicles pushBackUnique _vehicle;
            INC(_vehicleCount);
        } else {
            _infantry pushBack _vehicle;
        };
    } forEach _unitArray;

    SWITCH_SIDE(_side,civilian);
};

{
    private _config = [_x] call cba_fnc_getObjectConfig;
    if (getNumber (_config >> "artilleryScanner") isEqualTo 1) then {_hasArtillery = 1;};
    private _parents = ([_config,true] call BIS_fnc_returnParents) apply {toLower _x};
    {
        _vehicleParents pushBackUnique _x;
    } forEach _parents;
} forEach _vehicles;

//===============================================================================
//===============================================================================
private _markerScore = -1; //The score for current marker detailis. Allows for overwriting

//Function to call if type requirements are passed.
private _passed = {
    private _catMarkerPriority = getNumber (_cfg >> "markerPriority");
    if (_catMarkerPriority >= _markerScore) then {
        private _catMarkerPrefix = getText (_cfg >> "markerPrefix");
        private _catMarkerSufix = getText (_cfg >> "markerSuffix");
        private _catMarkerColor = getText (_cfg >> "markerColor");
        _markerScore = _catMarkerPriority;
        if (!(_catMarkerPrefix isEqualTo "")) then {_markerPrefix = _catMarkerPrefix;};
        if (!(_catMarkerSufix isEqualTo "")) then {_markerSuffix = _catMarkerSufix;};
        if (!(_catMarkerColor isEqualTo "")) then {_markerColor = _catMarkerColor;};
    };
    _groupTypes pushBackUnique (getText (_cfg >> "typename"));
    if (_switch > 0) then {_ci = count _subCats;};
};

private _cats = [];
{
    _cats append (configProperties [_x >> "CfgCompositions" >> "groups", "count _x > 0",true]);
} forEach [configfile, missionConfigfile];



{
    private _subCats = configProperties [_x, "count _x > 0",true];
    private _switch = getNumber (_x >> "switch");
    for [{private _ci = 0}, {_ci < count _subCats}, {INC(_ci)}] do {
    //---------------------------------------------------------------------------
    //------------------------Go through each cfg--------------------------------
    //---------------------------------------------------------------------------
        private _cfg = _subCats select _ci;
        private _catSide = getNumber (_cfg >> "side");
        //Check to see if side spesific- if so, just check this and move on.
        if (_catSide >= 0) then {
            SWITCH_SIDE(_catSide,resistance);
            if (_catSide isEqualTo _side) then {
                call _passed;
            };
        } else {
            //NOT A SIDE RELATED CHECK
            private _infState = getNumber (_cfg >> "infantry");
            private _vehState = getNumber (_cfg >> "vehicles");
            if (
            (
                (_infState isEqualTo 0 && count _infantry isEqualTo 0) ||
                (_infState isEqualTo 1) ||
                (_infState isEqualTo 2 && count _infantry > 0)
            ) && (
                (_vehState isEqualTo 0 && count _vehicles isEqualTo 0) ||
                (_vehState isEqualTo 1) ||
                (_vehState isEqualTo 2 && count _vehicles > 0)
            )
            ) then {
                //Right infantry and vehicle settup!
                private _min = getNumber (_cfg >> "min");
                private _max = getNumber (_cfg >> "max");
                if (count _infantry >= _min && count _infantry <= _max) then {
                    private _requiresArt = getNumber (_cfg >> "isArtillery");
                    if (_hasArtillery >= _requiresArt) then {
                        private _parent = getText (_cfg >> "vehicleParent");
                        //If we have vehicles, make sure that they are of the correct kind
                        if (count _vehicles > 0 && !(_parent isEqualTo "")) then {
                            if (_parent in _vehicleParents) then {
                                call _passed;
                            };
                        } else {
                            //NO VEHICLE REQUIREMENTS NEEDED
                            call _passed;
                        };
                    };
                };
            };
        };
    };
    //---------------------------------------------------------------------------
    //---------------------------------------------------------------------------
} forEach _cats;

/*

switch (_side) do {
    case west: {_markerPrefix = "b";_markerColor = "colorWest";};
    case east: {_markerPrefix = "o";_markerColor = "colorEast";};
};

//---------- INFANRTY ------------

if (count _infantry > 0) then {
    _markerSuffix = MARKER_SQUAD;
    _groupTypes pushBackUnique TYPE_INFANTRY;

    if (count _infantry <= COUNT_TEAM) then {
        if (count _infantry <= COUNT_PAIR) then {
            _markerSuffix = MARKER_PAIR;
            _groupTypes pushBackUnique TYPE_INF_PAIR;
        } else {
            _markerSuffix = MARKER_TEAM;
            _groupTypes pushBackUnique TYPE_INF_TEAM;
        };
    } else {
        _groupTypes pushBackUnique TYPE_INF_SQUAD;
    };
};


//---------- VEHICLES ------------
{
    private _vehicle = _x;
    private _config = [_vehicle] call cba_fnc_getObjectConfig;
    private _parents = ([_config,true] call BIS_fnc_returnParents) apply {toLower _x};
    private _artillery = getNumber (_config >> "artilleryScanner");

    //HAS INFANTRY
    if (count _infantry > 0) then {
        //Mechanized
        if ("tank" in _parents) then {
            _markerSuffix = MARKER_MECHANIZED;
            _groupTypes pushBackUnique TYPE_MECHANIZED;
        };
        //Motorized
        if ("car" in _parents) then {
            _markerSuffix = MARKER_MOTORIZED;
            _groupTypes pushBackUnique TYPE_MOTORIZED;
        };
    } else {
    //NO INFANTRY
        //Armored
        if ("tank" in _parents) then {
            _markerSuffix = MARKER_ARMOR;
            _groupTypes pushBackUnique TYPE_ARMOR;
        };
    };

    //NON-SPESIFIC
    //Air
    if ("air" in _parents) then {
        _markerSuffix = MARKER_AIR;
        _groupTypes pushBackUnique TYPE_AIR;
    };
    //Artillery
    if (_artillery isEqualTo 1) then {
        _markerSuffix = MARKER_ARTILLERY;
        _groupTypes pushBackUnique TYPE_ARTILLERY;
    };
} forEach _vehicles;
*/
//------------ EXIT --------------

_marker = format['%1_%2', _markerPrefix, _markerSuffix];
private _endTime = diag_tickTime - _startTime;
//LOG_2("group %1 took %2 to profile", _data, _endTime);
[[_marker,_markerColor], _side, _groupTypes, count _units, _vehicles]
