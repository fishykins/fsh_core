disabledAI = true;
enableDebugConsole = 2;
briefing = 0;

onLoadName = "M I A";
onLoadMission = "";
//loadScreen = "SIG\images\SIG_Logo_Large_01.png";
Author = "Fishy";

// Respawn type, see the table below
respawn = 3;
respawnDialog = 1;
respawnDelay = 2;
respawnVehicleDelay = 2;
respawnTemplatesWest[] = {"MenuInventory","MenuPosition"};
respawnTemplatesGuer[] = {"MenuInventory","MenuPosition"};
respawnTemplatesEast[] = {"MenuInventory","MenuPosition"};
respawnOnStart = 0;
#include "CfgRespawnInventory.hpp"
#include "CfgRoles.hpp"


class Header
{
	gameType = TEST MISSION; //game type
	minPlayers = 0; //min # of players the mission supports
	maxPlayers = 2; //max # of players the mission supports
	//playerCountMultipleOf = 1; //OFP:Elite option.
};


#include "ui\config.hpp"
#include "mia\config.hpp"
#include "compositions\CfgCompositions.hpp"
#include "console\config.hpp"
#include "targets\config.hpp"
