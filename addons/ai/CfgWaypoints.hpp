
class CfgWaypoints 
{
    class FSH 
    {
        displayName = "FSH";
        class fsh_Task_Garrison 
        {
            displayName = "GARRISON"; 
            displayNameDebug = "FSH_Task_Garrison";
            file = QPATHTOF(wp_garrison.sqf);
            icon = "\a3\3den\Data\CfgWaypoints\getInNearest_ca.paa";
            cbaType = "FSH GARRISON";
        };
        class fsh_Task_atEase 
        {
            displayName = "AT EASE"; 
            displayNameDebug = "FSH_Task_atEase";
            file = QPATHTOF(wp_atEase.sqf);
            icon = "\a3\3den\Data\CfgWaypoints\getInNearest_ca.paa";
            cbaType = "FSH ATEASE";
        };
        class fsh_Task_ard 
        {
            displayName = "All Round Deffence"; 
            displayNameDebug = "FSH_Task_ard";
            file = QPATHTOF(wp_allRoundDeffence.sqf);
            icon = "\a3\3den\Data\CfgWaypoints\getInNearest_ca.paa";
            cbaType = "FSH ARD";
        };
    };
};
