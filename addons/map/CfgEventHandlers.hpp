class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
        serverInit = QUOTE(call COMPILE_FILE(XEH_preServerInit));
        clientInit = QUOTE(call COMPILE_FILE(XEH_preClientInit));
    };
};
