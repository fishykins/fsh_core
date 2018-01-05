class Extended_PreInit_EventHandlers {
    class ADDON {
        clientInit = QUOTE(call COMPILE_FILE(XEH_preClientInit));
        serverInit = QUOTE(call COMPILE_FILE(XEH_preServerInit));
    };
};


class Extended_HitPart_EventHandlers {
    class TargetBase {

        class ADDON {
            hitPart = QUOTE(_this call FUNC(targetHit));
        };
    };


};
