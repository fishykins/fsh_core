enableSaving [false, false];

ACE_maxWeightDrag = 200000;
ACE_maxWeightCarry = 150000;

["database1", [], false, true] call fsh_fnc_dbInit;

fsh_noSave = false;
["test", 60] call fsh_fnc_persistantPlayers;
["test", 60] call fsh_fnc_persistantObjects;

//private _null = [[],[island],[0.2, 1,0.5]] call fsh_fnc_spawnAmbientWorld;
[true, false, 10] call fsh_fnc_showTargetHits;


setPlayerRespawnTime 5;

{
    [west, _x] call BIS_fnc_addRespawnInventory;
} forEach ["baf_rifleman","baf_heli","baf_eng"];


// Adds action to check external fuel levels on tanks.  Will be a sub action of the previous action.
_action = ["CheckExtTank","Check External Tank","",{hint format ["Ext Tank: %1", 5]},{true}] call ace_interact_menu_fnc_createAction;
["Tank_F", 0, ["ACE_MainActions", "CheckFuel"], _action, true] call ace_interact_menu_fnc_addActionToClass;


/*
_allFactions = [1] call fsh_fnc_getFactions;

//"BWA3_Faction"
//"UK3CB_BAF_Faction_Army_Desert"
//"Blu_f"
//"rhs_faction_usarmy_d" MURCA
//"rhs_faction_msv"
//"rhs_faction_vdv" -> best russian
//"rhs_faction_tv" -> tanks :)

private _faction = "rhs_faction_usarmy_d"; //selectRandom _allFactions;
_factionVehicles = ([_faction] call fsh_fnc_factionVehicles);
_factionGroups = [_faction] call fsh_fnc_factionGroups;

private _groups = ([spawnZone, _faction, 400, "smallTown"] call fsh_fnc_spawnCompany) select 0;

private _miaName = "bilbo";
[_miaName, "init"] call fsh_fnc_mia;
[_miaName, "addGroup", _groups] call fsh_fnc_mia;
[_miaName, "addArea", trigger2] call fsh_fnc_mia;
[_miaName, "addArea", trigger1] call fsh_fnc_mia;
*/

/*
[box_1,"init","empty","true"] call fsh_fnc_arsenal;
[box2,"init","empty","true"] call fsh_fnc_arsenal;
[box3,"init","empty","true"] call fsh_fnc_arsenal;

[keyboard,"init"] call fsh_fnc_arsenalController; //Adds the settings dialog to keyboard
[keyboard, "link",[box1,box2,box3]] call fsh_fnc_arsenalController; //Links keyboad to boxes
[keyboard,"add",["DDPM","BAF_DDPM"]] call fsh_fnc_arsenalController; //adds dynamic options to settings
[keyboard,"add",["Support","BAF_support"]] call fsh_fnc_arsenalController; //adds dynamic options to settings
[keyboard,"add",["Training","BAF_training"]] call fsh_fnc_arsenalController; //adds dynamic options to settings
[keyboard,"add",["NATO","blu_f"]] call fsh_fnc_arsenalController; //adds dynamic options to settings
[keyboard,"add",["Civies","CIV_F"]] call fsh_fnc_arsenalController; //adds dynamic options to settings
[keyboard,"add",["USA","rhs_faction_usarmy_d"]] call fsh_fnc_arsenalController; //adds dynamic options to settings
[keyboard,"add",["Deutch","BWA3_Faction"]] call fsh_fnc_arsenalController; //adds dynamic options to settings
["compound",_factionVehicles] call fsh_fnc_spawnDynamic;
*/


null = [] spawn {
    waitUntil {!(isNull player)};

    (group player) setGroupId ["Team Goons"];
};
