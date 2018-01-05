class Extended_PreInit_EventHandlers {
    class ADDON {
        ServerInit = QUOTE(call COMPILE_FILE(XEH_preServerInit));
        ClientInit = QUOTE(call COMPILE_FILE(XEH_preClientInit));
    };
};

class Extended_pauseMenu_EventHandlers {
    class ADDON {
        opened = QUOTE(call FUNC(pauseMenuOpened));
        closed = QUOTE(call FUNC(pauseMenuOpened));
    };
};
