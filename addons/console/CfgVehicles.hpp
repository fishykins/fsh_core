class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_Actions {
            class ACE_MainActions {
                class GVAR(console) {
                    displayName = "FSH Console";
                    condition = QUOTE([ARR_1(_player)] call FUNC(consoleEnabled));
                    exceptions[] = {};
                    statement = QUOTE([ARR_1(_target)] call FUNC(openConsole));
                    //statement = "[_this] call fsh_core_ai_aiDebugConsole;";
                };
            };
        };
        class ACE_selfActions {
            class GVAR(console) {
                displayName = "FSH Console";
                condition = QUOTE([player] call FUNC(consoleEnabled));
                exceptions[] = {};
                statement = QUOTE([player] call FUNC(openConsole));
            };
        };
    };
};
