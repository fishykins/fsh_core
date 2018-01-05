class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class ArgumentsBaseUnits;
        class ModuleDescription;
    };

    class FSH_ModuleAmbientVehicles: Module_F {
        scope = 2;
        displayName = "Ambient Vehicles";
        author = "Fishy";
        vehicleClass = "Modules";
        category = "FSH_modules";
        function = "fsh_fnc_ambientVehicles";
        functionPriority = 1;
        isGlobal = 0;
        isTriggerActivated = 0;
        isDisposable = 0;
        is3DEN = 0;

        class Arguments: ArgumentsBaseUnits {
            class arg1 {
                displayName = "Arg 1 disp name";
                description = "description";
                typeName = "STRING";
                class values {
                    class var1 {
                        name = "var1";
                        value = "";
                        default = 1;
                    };
                    class var2 {
                        name = "var2";
                        value = "OBJECT";
                    };
                };
            };

            class arg2 {
                displayName = "Arg 2 disp name";
                description = "description";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };

        class ModuleDescription: ModuleDescription {
            description = "description goes here";
            sync[] = {"LocationArea_F"};

            class LocationArea_F {
                position = 0;
                optional = 0;
                duplicate = 1;
                synced[] = {"Anything"};
            };
        };
    };
};
