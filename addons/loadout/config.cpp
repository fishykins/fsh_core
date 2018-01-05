#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        author = "Fishy";
        name = CSTRING(component);
        url = "";
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"CBA_common"};
        version = VERSION;
        authors[] = {"Fishy"};
    };
};

#include "CfgFunctions.hpp"
#include "CfgEventHandlers.hpp"