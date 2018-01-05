class groups
{
    class baseType
    {
        typeName = "";
        markerPrefix = "";
        markerSuffix = "";
        markerColor = "";
        markerPriority = 0;
        side = -1; //Side group must belong to
        faction = "";
        wlTypes[] = {};
        blTypes[] = {};
        count[] = {-1,-1};              //Number of units required
        thresholdTypes[] = {-1,-1};     //How many matches required to pass. default is 100% match
    };

    class cfgSide
    {
        switch = 1;
        class west : baseType
        {
            side = 1;
            markerPrefix = "b";
            markerColor = "colorWest";
        };
        class east : baseType
        {
            side = 0;
            markerPrefix = "o";
            markerColor = "colorEast";
        };
    };

    class cfgType
    {
        switch = 1;

        class motorized : baseType
        {
            typeName = "motorized";
            markerSuffix = "motor_inf";
            markerPriority = 1;
            blTypes[] = {"tracked"};

            class infantrySub : baseType
            {
                wlTypes[] = {"man"};
                count[] = {1,-1};
            };
            class car : baseType
            {
                wlTypes[] = {"car","truck","wheeled"};
                count[] = {1,-1};
                thresholdTypes[] = {2,-1};

            };
        };
        class mechanized : baseType
        {
            typeName = "mechanized";
            markerSuffix = "mech_inf";
            markerPriority = 1;
            blTypes[] = {"car"};

            class infantrySub : baseType
            {
                wlTypes[] = {"man"};
                count[] = {1,-1};
            };
            class apc : baseType
            {
                wlTypes[] = {"apc","ifv"};
                thresholdTypes[] = {1,-1};
                count[] = {1,-1};
            };
        };

        class air : baseType
        {
            typeName = "air";
            markerSuffix = "air";
            markerPriority = 1;
            wlTypes[] = {"air"};
        };
        class armor : baseType
        {
            typeName = "armor";
            markerSuffix = "armor";
            markerPriority = 1;
            wlTypes[] = {"tank","apc","ifv"};
            blTypes[] = {"man"};
            thresholdTypes[] = {1,0}; //Only needs one of the whitlisted
        };
        class infantry : baseType
        {
            typeName = "infantry";
            wlTypes[] = {"man"};
        };
    };

    class CfgSize //Engine will pick ONE of the classes from here.
    {
        switch = 1;
        class squad : baseType
        {
            typeName = "squad";
            markerSuffix = "inf";
            count[] = {6,20};
        };
        class team : baseType
        {
            typeName = "team";
            markerSuffix = "recon";
            count[] = {3,5};
        };
        class sentry : baseType
        {
            typeName = "sentry";
            markerSuffix = "unknown";
            count[] = {2,2};
        };
    };

    class cfgOther
    {
        switch = 0;
        class artillery : baseType
        {
            typeName = "artillery";
            markerSuffix = "art";
            markerPriority = 2;
            wlTypes[] = {"artillery"};
        };
    };
};
