#define COST_INF_SQUAD 50
#define COST_INF_TEAM 30
#define COST_INF_SENTRY 22

class company {
    class baseGroup {
        isGroup = 1;
        isObject = 0;
        displayName = "";
        distribution = "ballanced"; //"ballanced": funds will be allocated evenly according to weight. "stacked": the best possible weight, at the cost of very uneven distribution
        cost = 1; //Unit cost per. set to -1 for non-purchasable, or 1 if is parent class
        weight = 1; //How desirable this group will be. Higher values = more desirable and likely to be bought. 0 will never be bought
        preDefinedGroups[] = {};
        wlTypes[] = {};   //See cfgObjectTypes for more info.
        blTypes[] = {};
    };

    class baseVehicle {
        isGroup = 0;
        isObject = 1;
        displayName = "";
        distribution = "ballanced"; //"ballanced": funds will be allocated evenly according to weight. "stacked": the best possible weight, at the cost of very uneven distribution
        cost = 1; //Unit cost per. set to -1 for non-purchasable, or 1 if is parent class
        weight = 1; //How desirable this group will be. Higher values = more desirable and likely to be bought. 0 will never be bought
        preDefinedObjects[] = {};
        wlTypes[] = {};
        blTypes[] = {};
    }


    class standard {
        displayName = "basic";
        description = "A basic company, focusing on infantry. Good for small ocupied towns";
        distribution = "ballanced";

        class infantryGroups : baseGroup {
            displayName = "infantry";
            weight = 1;
            cost = 50;
            wlTypes[] = {"infantry"};

            class squad : baseGroup {
                displayName = "squad";
                cost = COST_INF_SQUAD;
                weight = 2;
                wlTypes[] = {"squad"};
            };
            class team : squad {
                displayName = "team";
                cost = COST_INF_TEAM;
                weight = 3;
                wlTypes[] = {"team"};
            };
            class sentry : squad {
                displayName = "sentry";
                cost = COST_INF_SENTRY;
                weight = 4;
                wlTypes[] = {"sentry"};
            };
        };
        class vehicleGroups : baseGroup {
            displayName = "vehicle groups";
            distribution = "stacked";
            weight = 4;
            cost = 100;
            blTypes[] = {"infantry"};

            class mechanized : baseGroup {
                displayName = "mech squad";
                weight = 9;
                cost = 150;
                wlTypes[] = {"mechanized","squad"};
            };

            class motorized : baseGroup {
                displayName = "motor team";
                weight = 15;
                cost = 100;
                wlTypes[] = {"motorized","team"};
            };
        };
        class vehicles : baseVehicle {
            displayName = "vehicles";
            weight = 6;
            cost = 300;
            class helicopter : baseVehicle {
                displayName = "chopper";
                cost = 300;
                weight = 10;
                wlTypes[] = {"helicopter","transport"};
                blTypes[] = {"armed"};
            };
            class tank : baseVehicle {
                displayName = "tank";
                cost = 300;
                weight = 9;
                wlTypes[] = {"tank"};
            };
        };
    };

    //SMALL TOWN OCCUPATION
    class smallTown {
        displayName = "town";
        description = "A basic company, focusing on infantry. Good for small ocupied towns";
        distribution = "ballanced";

        class infantryGroups : baseGroup {
            displayName = "infantry";
            weight = 1;
            cost = 50;
            wlTypes[] = {"infantry"};

            class squad : baseGroup {
                displayName = "squad";
                cost = COST_INF_SQUAD;
                weight = 2;
                wlTypes[] = {"squad"};
            };
            class team : squad {
                displayName = "team";
                cost = COST_INF_TEAM;
                weight = 4;
                wlTypes[] = {"team"};
            };
            class sentry : squad {
                displayName = "sentry";
                cost = COST_INF_SENTRY;
                weight = 8;
                wlTypes[] = {"sentry"};
            };
        };
        class vehicleGroups : baseGroup {
            displayName = "vehicle groups";
            distribution = "stacked";
            weight = 4;
            cost = 100;
            blTypes[] = {"infantry"};

            class mechanized : baseGroup {
                displayName = "mech squad";
                weight = 9;
                cost = 150;
                wlTypes[] = {"mechanized","squad"};
            };

            class motorized : baseGroup {
                displayName = "motor team";
                weight = 15;
                cost = 100;
                wlTypes[] = {"motorized","team"};
            };
        };
        class vehicles : baseVehicle {
            displayName = "vehicles";
            weight = 6;
            cost = 100;
            class transportTruck : baseVehicle {
                displayName = "truck";
                cost = 100;
                weight = 8;
                wlTypes[] = {"truck","transport"};
            };
        };
    };
};
