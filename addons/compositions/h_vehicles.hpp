

class vehicles
{
    //These are types that already exsist, we are just choosing the ones that are most valid
    baseTypes[] = {"air","man"};
    hardCodedTypes[] = {"artillery","support","fuel","repair","ammo"}; //This doesnt do anything, just nice to have

    class baseType
    {
        className = "";
        wlTypes[] = {};                 //Requred parent classes
        blTypes[] = {};                 //Not allowed parent classes
        wlWeapons[] = {};               //Required weapons
        blWeapons[] = {};               //weapons vehicle must not have
        transport[] = {-1,-1};          //The range of passanger (ie non functional) seats this vehicle must possess
        damageOutput[] = {-1,-1};       //The range in which the most powerful weapon must sit
        thresholdTypes[] = {-1,-1};     //How many matches required to pass. default is 100% match
        thresholdWeapons[] = {-1,-1};   //element 0 is white list, 1 is blacklist.
    };

    class CfgMovement
    {
        switch = 1;
        kindOf = "any";
        baseTypes[] = {"helicopter","plane","ship","staticweapon"}; //these are checked AFTER classes
        class truck : baseType
        {
            className = "truck";
            wlTypes[] = {"truck_01_base_f","truck_02_base_f","truck_f","rhs_truck"};
            blTypes[] = {"wheeled_apc_f"};
            thresholdTypes[] = {1,0};
        };
        class tank : baseType
        {
            className = "tank";
            wlTypes[] = {"tank"};
            wlWeapons[] = {"cannon"};
            transport[] = {0,6};
        };
        class ifv : baseType
        {
            className = "ifv";
            transport[] = {6,-1};
            wlTypes[] = {"tank","wheeled_apc_f","apc_tracked_01_base_f","apc_tracked_02_base_f","apc_tracked_03_base_f"};
            wlWeapons[] = {"lightcannon","minicannon"};
            thresholdTypes[] = {1,0};
            thresholdWeapons[] = {1,-1};
        };
        class apc : ifv
        {
            className = "apc";
            wlWeapons[] = {};
            blWeapons[] = {"lightcannon","minicannon"};
            transport[] = {6,-1};
        };
        class quadbike : baseType
        {
            className = "quadbike";
            wlTypes[] = {"quadbike_01_base_f"};
        };
        class car : baseType
        {
            className = "car";
            wlTypes[] = {"car"};
            blTypes[] = {"truck_01_base_f","truck_02_base_f","truck_f","rhs_truck","quadbike_01_base_f","wheeled_apc_f","kart_01_base_f"};
        };
        class kart : baseType
        {
            className = "kart";
            wlTypes[] = {"kart_01_base_f"};
        };
    };

    class CfgFunctionality
    {
        switch = 0;
        kindOf = "any";
        baseTypes[] = {};
        class armed : baseType
        {
            className = "armed";
            damageOutput[] = {10,-1};
        }
        class transport : baseType
        {
            className = "transport";
            transport[] = {4,-1};
            blTypes[] = {"tank"};
        };
    };

    class cfgWheeltype
    {
        kindOf = "land";
        switch = 1;
        class wheeled : baseType
        {
            className = "wheeled";
            wlTypes[] = {"car","wheeled_apc_f"};
            thresholdTypes[] = {1,0};
        };
        class tracked : baseType
        {
            className = "tracked";
            wlTypes[] = {"tank"};
        };
    };

    class CfgWeaponry
    {
        switch = 0;
        kindOf = "any";
        baseTypes[] = {};
        class airAA : baseType
        {
            className = "aa";
            wlTypes[] = {"air"};
            wlWeapons[] = {"aa","missile"};
            blWeapons[] = {}; //"ag","ap","rocket"
        };
        class airAT : airAA
        {
            className = "at";
            wlWeapons[] = {"ag","at","missile"};
            thresholdWeapons[] = {2,0};
        };
        class groundAA : baseType
        {
            className = "aa";
            blTypes[] = {"air"};
            wlWeapons[] = {"missile","aa"};
        };
        class groundAT : groundAA
        {
            className = "at";
            wlWeapons[] = {"missile","at"};
        };
        class launcher : baseType
        {
            className = "at";
            blTypes[] = {"air"};
            wlWeapons[] = {"missile","rocket"};
            thresholdWeapons[] = {1,0};
        };
    };

    class CfgAirClasses
    {
        switch = 1;
        kindOf = "air";
        baseTypes[] = {};
        class airMR : baseType
        {
            className = "multirole";
            wlWeapons[] = {"ag","ap","aa","at","rocket","missile"};
            blWeapons[] = {};
            thresholdWeapons[] = {5,0};
        };
        class airCAS : baseType
        {
            className = "cas";
            wlWeapons[] = {"ag","ap","rocket"};
            blWeapons[] = {"missile"};
            thresholdWeapons[] = {2,0};
        };
        class airGS : baseType
        {
            className = "ground_suppression";
            wlWeapons[] = {"rocket","gun"};
            blWeapons[] = {"missile","ag","aa","at"};
        };
        class airCS : baseType
        {
            className = "close_support";
            wlWeapons[] = {"missile","at","ag","ap"};
            blWeapons[] = {"rocket","aa"};
        };
    }

};
