#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        author = "Fishy";
        name = CSTRING(component);
        url = "";
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"CBA_xeh","A3_Data_F","A3_Characters_F","A3_Air_F","A3_Armor_F","A3_Boat_F","A3_Soft_F","A3_Air_F_Heli_Heli_Transport_04","A3_Characters_F_exp"};
        version = VERSION;
        authors[] = {"Fishy"};
    };
};

#include "CfgFunctions.hpp"
#include "CfgEventHandlers.hpp"
//#include "CfgRscTitles.hpp"  
#include "CfgVehicles.hpp"
#include "ui_targets.hpp"
