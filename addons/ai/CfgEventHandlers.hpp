class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
        clientInit = QUOTE(call COMPILE_FILE(XEH_preClientInit));
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};


class Extended_InitPost_EventHandlers {
    class CAManBase {
        class GVAR(postInit) {
            init = QUOTE(_this call FUNC(unitInit));
        };
    };
};

class Extended_Killed_EventHandlers {
    class CAManBase {
        class GVAR(killed) {
            killed = QUOTE(_this call FUNC(unitKilled));
        };
    };
};
