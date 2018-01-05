class CfgVehicles {

    class Static;

    class TargetBase : Static {
        XEH_ENABLED;
        targetModelOffset[] = {0,0,0};
    };

    class TargetP_Inf_F : TargetBase {
        XEH_ENABLED;
        targetModelOffset[] = {0,0,0};
    };

    class TargetStatic_ACR : TargetBase {
        XEH_ENABLED;
        targetModelOffset[] = {0,0,0.6};
    };

    class Land_Target_Oval_F : TargetBase {
        XEH_ENABLED;
        targetModelOffset[] = {0,0,0};
    };
};
