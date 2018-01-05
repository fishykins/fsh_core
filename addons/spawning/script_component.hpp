#define COMPONENT spawning

#include "\x\fsh_core\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define RECOMPILE recompile = 1
#define MAX_SPAWN 20 //Limit the number of groups each class can spawn

#include "\x\fsh_core\addons\main\script_macros.hpp"

#define SPAWN(_var1)    FUNC(_var1)

#define WTCST_DISTRIBUTOR "distribution"
#define WTD_DLL "distribution"

#define DIAG_DLL(_var1)    diag_log format["%1 -> %2", _var1, (WTCST_DISTRIBUTOR callExtension [_var1)]

#define COMP_SETVARIBLE(_var1,_var2)   _namespace setVariable [format["%1_%2", _displayName, _var1], _var2]
#define COMP_GETVARIBLE(_var1,_var2)   _namespace getVariable [format["%1_%2", _displayName, _var1], _var2]

#define VAR_PUSHBACK(_var1,_var2)      private _temp = _namespace getVariable [_var1, []]; \
_temp pushBack _var2; \
_namespace setVariable [_var1, _temp]

#define BACKWARDS_HANGARS       ["Land_Ss_hangar","Land_Hangar_F"]
#define ROTATE_90               ["Land_WoodenTable_large_F","Land_WoodenTable_small_F"]
#define SAFE_RANGE              1


#define TABLES_SMALL            ["Land_CampingTable_small_F","Land_WoodenTable_small_F"]
#define TABLES_LARGE            ["Land_WoodenTable_large_F","Land_CampingTable_F","Land_TablePlastic_01_F"]
#define COTNAINERS_SMALL        ["Land_PlasticCase_01_small_F","Land_MetalCase_01_small_F"]
#define COTNAINERS_MEDIUM       ["Land_PlasticCase_01_medium_F","Land_CratesPlastic_F"]
#define CONTAINERS_LARGE        ["Land_MetalCase_01_large_F"]
#define BOXES_WOODEN            ["Land_WoodenCrate_01_stack_x3_F","Land_WoodenCrate_01_stack_x5_F"]
#define TOOLS_SMALL             ["Land_Screwdriver_V1_F","Land_Hammer_F","Land_Meter3m_F","Land_MetalWire_F","Land_Screwdriver_V2_F","Land_Wrench_F","Land_File_F","Land_DuctTape_F","Land_ButaneTorch_F","Land_DrillAku_F","Land_Saw_F","Land_Pliers_F","Land_Gloves_F","Land_ButaneCanister_F","Land_Matches_F","Land_MultiMeter_F","Land_Rope_01_F","Land_BaseballMitt_01_F","Land_Football_01_F","Land_DisinfectantSpray_F","Land_Camping_Light_off_F","Land_Tablet_01_F"]
#define TOOLS_LARGE             ["Land_Grinder_F","Land_Shovel_F","Land_CanisterOil_F","Land_Axe_fire_F","Land_Axe_F","Land_Laptop_02_F","Land_ExtensionCord_F","Land_Laptop_unfolded_F","Land_Microwave_01_F","Land_Printer_01_F","Land_SatellitePhone_F","Land_CarBattery_02_F","Land_CarBattery_01_F"]
#define GROUND_ITEMS            ["Land_Bucket_clean_F","Land_Bucket_painted_F","Land_CanisterFuel_F","Land_FireExtinguisher_F","Land_CanisterPlastic_F","Land_GasTank_01_blue_F","Land_GasTank_01_khaki_F","Land_GasTank_01_yellow_F","Land_Bucket_F","Land_WaterCooler_01_new_F"]
#define TROLLEYS_LARGE          ["WaterPump_01_forest_F","WaterPump_01_sand_F","Land_DieselGroundPowerUnit_01_F"]
#define TROLLEYS_SMALL          ["Land_WeldingTrolley_01_F","Land_ToolTrolley_01_F","Land_ToolTrolley_02_F","Land_KartTrolly_01_F","Land_KartStand_01_F","Land_PalletTrolley_01_yellow_F","Land_PalletTrolley_01_khaki_F","Land_EngineCrane_01_F","Land_PressureWasher_01_F"]
#define PORTABLE_LIGHTS         ["Land_PortableLight_single_F","Land_PortableLight_double_F"]
#define CARGO_CONTAINER_SMALL   ["Land_Cargo10_blue_F"]
#define CARGO_CONTAINER_MEDIUM  ["Land_Cargo20_orange_F"]
