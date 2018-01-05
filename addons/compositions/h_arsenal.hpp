class arsenal
{
    class base
    {
        displayName = "";
        factions[] = {}; //Any items used by infantry in this faction will be auto added
        class objects //This is where you put straight up object classes, plain and simple.
        {
            weapons[] = {};
            uniforms[] = {};
            vests[] = {};
            backpacks[] = {};
            headgear[] = {};
            magazines[] = {};
            miscItems[] = {};
        };
        class objectParents //Any objects beloning to these parents will be added.
        {
            weapons[] = {};
            uniforms[] = {};
            vests[] = {};
            backpacks[] = {};
            headgear[] = {};
            magazines[] = {};
            miscItems[] = {};
        };
    };

    class UK3CB_BAF_Faction_Army_Desert : base
    {
        displayName = "British Army (Desert)";
        factions[] = {"UK3CB_BAF_Faction_Army_Desert"};
        class objects
        {
            weapons[] = {};
            uniforms[] = {"UK3CB_BAF_U_Smock_DDPM"};
            vests[] = {"UK3CB_BAF_V_Osprey_DDPM1","UK3CB_BAF_V_Osprey_DDPM2","UK3CB_BAF_V_Osprey_DDPM3","UK3CB_BAF_V_Osprey_DDPM4","UK3CB_BAF_V_Osprey_DDPM5","UK3CB_BAF_V_Osprey_DDPM6","UK3CB_BAF_V_Osprey_DDPM7","UK3CB_BAF_V_Osprey_DDPM8","UK3CB_BAF_V_Osprey_DDPM9","UK3CB_BAF_V_PLCE_Webbing_DDPM","UK3CB_BAF_V_PLCE_Webbing_Plate_DDPM"};
            backpacks[] = {"UK3CB_BAF_B_Bergen_DDPM_JTAC_A","UK3CB_BAF_B_Bergen_DDPM_JTAC_H_A","UK3CB_BAF_B_Bergen_DDPM_Rifleman_A","UK3CB_BAF_B_Bergen_DDPM_Rifleman_B","UK3CB_BAF_B_Bergen_DDPM_SL_A"};
            headgear[] = {"UK3CB_BAF_H_Mk6_DDPM_A","UK3CB_BAF_H_Mk6_DDPM_B","UK3CB_BAF_H_Mk6_DDPM_C","UK3CB_BAF_H_Mk6_DDPM_D","UK3CB_BAF_H_Mk6_DDPM_E","UK3CB_BAF_H_Mk6_DDPM_F","UK3CB_BAF_H_CrewHelmet_DDPM_ESS_A","UK3CB_BAF_H_CrewHelmet_DDPM_A","UK3CB_BAF_H_Boonie_DDPM","UK3CB_BAF_H_Mk7_HiVis"};
            magazines[] = {};
            miscItems[] = {};
        };
        class objectParents
        {
            weapons[] = {};
            uniforms[] = {};
            vests[] = {};
            backpacks[] = {};
            headgear[] = {"UK3CB_BAF_H_Beret_Base","UK3CB_BAF_H_Beret_PRR_Over_Base","UK3CB_BAF_H_Beret_PRR_Base"};
            magazines[] = {};
            miscItems[] = {"ACE_ItemCore"};
        };
    };

    class BAF_DDPM : UK3CB_BAF_Faction_Army_Desert {};

    class BAF_training : base
    {
        class objects
        {
            weapons[] = {"UK3CB_BAF_L98A2"};
            uniforms[] = {"UK3CB_BAF_U_CombatUniform_DDPM_ShortSleeve","UK3CB_BAF_U_CombatUniform_DDPM","UK3CB_BAF_U_Smock_DDPM"};
            vests[] = {"UK3CB_BAF_V_Osprey_DDPM1"};
            magazines[] = {"UK3CB_BAF_556_30Rnd_Blank"};
        };
        class objectParents
        {
            headgear[] = {"UK3CB_BAF_H_Beret_Base","UK3CB_BAF_H_Beret_PRR_Over_Base","UK3CB_BAF_H_Beret_PRR_Base"};
            miscItems[] = {"UK3CB_BAF_BFA_L85","ACE_ItemCore"};
        };
    };

    class BAF_support : base
    {
        class objects
        {
            uniforms[] = {"UK3CB_BAF_U_CrewmanCoveralls_RTR","UK3CB_BAF_U_JumperUniform_MTP"};
            vests[] = {"UK3CB_BAF_V_HiVis"};
            headGear[] = {"UK3CB_BAF_H_Mk7_HiVis","UK3CB_BAF_H_Beret_REng"};
        };
    };
};
