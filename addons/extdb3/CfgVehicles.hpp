class CfgVehicles {

    class ThingX;
    class ReammoBox_F : ThingX {
        class ACE_Actions {
            class ACE_MainActions {
                class GVAR(mark) {
                    displayName = "Mark";
                    condition = QUOTE([_target] call FUNC(canMark));
                    statement = QUOTE([_target] call FUNC(mark));

                    class GVAR(markFaction) {
                        displayName = "Faction";
                        condition = "true";
                        statement = QUOTE([_target] call FUNC(markFaction));
                    };

                    class GVAR(markPublic) {
                        displayName = "Public";
                        condition = "true";
                        statement = QUOTE([_target] call FUNC(markPublic));
                    };

                    class GVAR(markTrash) {
                        displayName = "Trash";
                        condition = "true";
                        statement = QUOTE([_target] call FUNC(markTrash));
                    };
                };
            };
        };
    };
};
