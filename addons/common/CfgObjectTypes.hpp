class cfgObjectTypes
{
    class vehicles
    {
        class typeDefault
        {
            scope = 1;
            className = "default";
            editorSubcategory = "";
            typeOf[] = {};
            notTypeOf[] = {};
            weaponsWhitelist[] = {};
            weaponsBlacklist[] = {};
            cargoMin = -1;
            cargoMax = 1000;
            condition = "true";
        };
        class man: typeDefault
        {
            scope = 2;
            className = "man";
            typeOf[] = {"man"};
        };
        class air: typeDefault
        {
            scope = 2;
            className = "air";
            typeOf[] = {"air"};
        };
        class car: typeDefault
        {
            scope = 2;
            className = "car";
            editorSubcategory = "EdSubcat_Cars";
        };
        class boat: typeDefault
        {
            scope = 2;
            className = "boat";
            editorSubcategory = "EdSubcat_Boats";
        };
        class plane: typeDefault
        {
            scope = 2;
            className = "plane";
            editorSubcategory = "EdSubcat_Planes";
        };
        class heli: typeDefault
        {
            scope = 2;
            className = "helicopter";
            editorSubcategory = "EdSubcat_Helicopters";
        };
        class littleBird: typeDefault
        {
            scope = 2;
            className = "littlebird";
            editorSubcategory = "EdSubcat_Helicopters";
            typeOf[] = {"heli_light"};
        };
        class drone: typeDefault
        {
            scope = 2;
            className = "drone";
            editorSubcategory = "EdSubcat_Drones";
        };
        class land: typeDefault
        {
            scope = 2;
            className = "land";
            typeOf[] = {"land"};
            notTypeOf[] = {"man"};
        };
        class static: typeDefault
        {
            scope = 2;
            className = "static";
            editorSubcategory = "EdSubcat_statics";
        };
        class transport_light: typeDefault
        {
            scope = 2;
            className = "lightTransort";
            cargoMin = 2;
            cargoMax = 5;

        };
        class transport_medium: typeDefault
        {
            scope = 2;
            className = "transport";
            cargoMin = 6;
            cargoMax = 9;
        };
        class transport_heavy: typeDefault
        {
            scope = 2;
            className = "trooptransport";
            cargoMin = 10;
        };
        class mortar: typeDefault
        {
            scope = 2;
            className = "mortar";
            weaponsWhitelist[] = {"mortar"};
        };
        class tank: typeDefault
        {
            scope = 2;
            className = "tank";
            editorSubcategory ="EdSubcat_Tanks";
            weaponsWhitelist[] = {"cannon"};
        };
        class artillery: typeDefault
        {
            scope = 2;
            className = "artillery";
            editorSubcategory = "EdSubcat_Artillery";
        };
        class apc: typeDefault
        {
            scope = 2;
            className = "apc";
            editorSubcategory ="EdSubcat_APCs";
        };
        class armed: typeDefault
        {
            scope = 2;
            className = "armed";
            weaponsWhitelist[] = {"gun","missile","rocket","gattling","lmg","hmg","gmg","cannon"};
        };
        class unarmed: typeDefault
        {
            scope = 2;
            className = "unarmed";
            weaponsBlacklist[] = {"gun","missile","rocket","gattling","lmg","hmg","gmg","cannon","bomb"};
        };
        class armed_missiles: typeDefault
        {
            scope = 2;
            className = "missiles";
            weaponsWhitelist[] = {"missile"};
        };
        class armed_bombs: typeDefault
        {
            scope = 2;
            className = "bombs";
            weaponsWhitelist[] = {"bomb"};
        };
        class armed_aa: typeDefault
        {
            scope = 2;
            className = "aa";
            weaponsWhitelist[] = {"aa"};
        };
        class armed_aa2: typeDefault
        {
            scope = 2;
            className = "aa";
            typeOf[] = {"aa"};
        };
    };
    class groups
    {
        class defaultGroup
        {
            scope = 1;
            className = "default";
            displayNameWhite[] = {};
            displayNameBlack[] = {};
            inheritsFrom[] = {};
            vehicles = 1;
            minUnits = 0;
            maxUnits = 100;
        };
        //Group large type
        class infantry: defaultGroup
        {
            scope = 2;
            className = "infantry";
            inheritsFrom[] = {"infantry"};
            vehicles = 0;
        };
        class motorized: defaultGroup
        {
            scope = 2;
            className = "motorized";
            inheritsFrom[] = {"motorized","mounted"};
        };
        class mechanized: defaultGroup
        {
            scope = 2;
            className = "mechanized";
            inheritsFrom[] = {"mechanized"};
        };
        class armored: defaultGroup
        {
            scope = 2;
            className = "armored";
            inheritsFrom[] = {"armored","armor","tank"};
        };
        //Group sizes
        class squad: defaultGroup
        {
            scope = 2;
            className = "squad";
            inheritsFrom[] = {"infantry"};
            minUnits = 6;
            maxUnits = 20;
        };
        class team: defaultGroup
        {
            scope = 2;
            className = "team";
            inheritsFrom[] = {"infantry"};
            minUnits = 3;
            maxUnits = 5;
        };
        class pair: defaultGroup
        {
            scope = 2;
            className = "pair";
            inheritsFrom[] = {"infantry"};
            maxUnits = 2;
        };

        //Group classes
        class patrol: defaultGroup
        {
            scope = 2;
            className = "patrol";
            displayNameWhite[] = {"patrol"};
        };
        class sentry: defaultGroup
        {
            scope = 2;
            className = "sentry";
            displayNameWhite[] = {"sentry"};
        };
        class recon: defaultGroup
        {
            scope = 2;
            className = "recon";
            displayNameWhite[] = {"recon"};
        };
        class sniper: defaultGroup
        {
            scope = 2;
            className = "sniper";
            displayNameWhite[] = {"sniper"};
        };
        class weapon: defaultGroup
        {
            scope = 2;
            className = "weapon";
            displayNameWhite[] = {"weapon"};
        };
    };
};
