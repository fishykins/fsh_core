class CfgPatches {
    class fsh_test {
        author = "Fishy";
        name = "test";
        url = "";
        units[] = {};
        weapons[] = {};
        requiredVersion = 0.1;
        requiredAddons[] = {};
        version = 1;
        authors[] = {"Fishy"};
    };
};

class CfgFunctions
{
    class FSH
    {
        class test
        {
            class test
            {
                description = "Automatically switches the map texture off";
                file = "x\fsh_core\addons\test\fnc_test.sqf";
                recompile = 1;
            };
        };
    };
};