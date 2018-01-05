class Extended_PreInit_EventHandlers {
    class ADDON {
        ServerInit = QUOTE(call COMPILE_FILE(XEH_preServerInit));
        ClientInit = QUOTE(call COMPILE_FILE(XEH_preClientInit));
    };
};
