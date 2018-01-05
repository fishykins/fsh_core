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

    class USA_navy_uniforms : base
    {
        displayName = "PMC Uniforms";
        factions[] = {};
        class objects
        {
            uniforms[] = {
                "TRYK_C_AOR2_T","TRYK_DMARPAT_T","TRYK_U_B_BLKBLK_combatUniform",
                "TRYK_U_B_ARO1_combatUniform","TRYK_U_B_ARO1R_CombatUniform","TRYK_U_B_ARO1_CBR_CombatUniform","TRYK_U_B_ARO1_CBR_R_combatUniform",
                "TRYK_U_B_ARO1_GR_combatUniform","TRYK_U_B_ARO1_GR_R_combatUniform","TRYK_U_B_ARO1_GRY_combatUniform","TRYK_U_B_ARO1_GRY_R_combatUniform",
                "TRYK_U_B_AOR2_combatUniform","TRYK_U_B_AOR2R_combatUniform","TRYK_U_B_AOR2_OD_combatUniform","TRYK_U_B_AOR2_OD_R_combatUniform",
                "TRYK_U_B_AOR2_GRY_CombatUniform","TRYK_U_B_AOR2_GRY_R_combatUniform"
            };

            headgear[] = {"TRYK_H_Booniehat_AOR1","TRYK_H_Booniehat_AOR2"};
        };
    };

    class USA_navy_tacticalGear : base
    {
        displayName = "PMC Tactical Gear";
        factions[] = {};
        class objects
        {
            vests[] = {
                "VSM_CarrierRig_Operator_AOR1","VSM_CarrierRig_Gunner_AOR1","VSM_FAPC_MG_AOR1","VSM_FAPC_Operator_AOR1","VSM_LBT6094_MG_AOR1","VSM_LBT6094_operator_AOR1","VSM_RAV_MG_AOR1","VSM_RAV_Operator_AOR1"
            };
            headgear[] = {
                "VSM_Mich2000_2_aor1","VSM_Mich2000_AOR1","VSM_OPS_aor1"
            };
        };
    };


    class pmc_uniforms : base
    {
        displayName = "PMC Uniforms";
        factions[] = {};
        class objects
        {
            uniforms[] = {"TRYK_T_BLK_PAD","TRYK_T_OD_PAD","TRYK_T_TAN_PAD","TRYK_U_B_BLOD_T","TRYK_U_B_BLTAN_T",
                "TRYK_U_PAD_J_blk","TRYK_T_camo_3CBG","TRYK_T_camo_wood","TRYK_U_B_OD_OD_CombatUniform","TRYK_U_B_OD_OD_R_CombatUniform",
                "TRYK_T_camo_tan","TRYK_T_camo_wood","TRYK_U_B_TANTAN_combatUniform","TRYK_U_B_TANTAN_R_combatUniform",
                "TRYK_U_taki_BL","TRYK_U_taki_coy","TRYK_U_taki_wh","TRYK_U_taki_BLK","TRYK_U_B_OD_BLK","TRYK_U_B_OD_BLK_2","TRYK_U_B_ODTAN",
                "TRYK_U_B_ODTAN_Tshirt","TRYK_U_B_sage_Tshirt","TRYK_U_B_BLKBLK_combatUniform","TRYK_U_B_snowT",
                "TRYK_U_hood_nc","TRYK_U_hood_mc","TRYK_pad_hood_odBK","TRYK_U_nohoodPcu_gry","TRYK_U_Bts_PCUODs",
                "TRYK_U_B_BLK_OD_Rollup_CombatUniform","TRYK_U_B_BLK_tan_Rollup_CombatUniform","TRYK_U_B_Sage_T",
                "UK3CB_BAF_U_JumperUniform_Plain"
            };
            headgear[] = {"TRYK_H_EARMUFF","TRYK_H_headset2",
                "TRYK_H_headsetcap","TRYK_H_headsetcap_blk","TRYK_H_headsetcap_od","TRYK_H_woolhat","TRYK_H_woolhat_cu",
                "TRYK_H_woolhat_cw","TRYK_H_woolhat_br","TRYK_H_woolhat_tan","TRYK_H_woolhat_wh","TRYK_H_woolhat_nv",
                "VSM_FullShemagh_Tan","VSM_FullShemagh_OD","VSM_FullShemagh_OD_pattern","VSM_FullShemagh_Tan_pattern",
                "H_Booniehat_khk","H_Booniehat_khk_hs","H_Booniehat_mcamo","H_Booniehat_oli","H_Booniehat_tan",
                "H_Cap_headphones","H_Cap_red","H_Cap_oli","H_Cap_oli_hs","H_Cap_grn","H_Cap_blu","H_Cap_bi","H_Cap_tan",
                "H_Watchcap_blk","H_Watchcap_cbr","H_Watchcap_camo","H_Watchcap_khk"
            };
            miscItems[] = {
                "G_Spectacles","G_Spectacles_Tinted","G_Squares",
                "TRYK_shemagh_MESH_nv","TRYK_shemagh_G_nv","TRYK_shemagh_tan_nv",
                "G_Shades_Black","G_Shades_Green","G_Shades_Blue","G_Shades_Red",
                "G_Sport_Red","G_Sport_Blackyellow","G_Sport_BlackWhite","G_Sport_Blackred","G_Sport_Checkered","G_Sport_Greenblack"
            };
        };
    };

    class pmc_tacticalGear : base
    {
        displayName = "PMC Tactical Gear";
        factions[] = {};
        class objects
        {
            vests[] = {
                "VSM_CarrierRig_Operator_OGA","VSM_CarrierRig_Gunner_OGA","VSM_FAPC_MG_OGA","VSM_FAPC_Operator_OGA","VSM_LBT6094_MG_OGA","VSM_LBT6094_operator_OGA","VSM_RAV_MG_OGA","VSM_RAV_Operator_OGA",
                "VSM_CarrierRig_Operator_OGA_OD","VSM_CarrierRig_Gunner_OGA_OD","VSM_FAPC_MG_OGA_OD","VSM_FAPC_Operator_OGA_OD","VSM_LBT6094_MG_OGA_OD","VSM_LBT6094_operator_OGA_OD","VSM_RAV_MG_OGA_OD","VSM_RAV_Operator_OGA_OD",
                "VSM_LBT1961_Black","VSM_LBT1961_CB","VSM_LBT1961_GRN","VSM_LBT1961_OGA_OD",
                "VSM_MBSS_BLK","VSM_MBSS_CB","VSM_MBSS_GREEN","VSM_MBSS_TAN",
                "VSM_MBSS_PACA","VSM_MBSS_PACA_BLK","VSM_MBSS_PACA_CB","VSM_MBSS_PACA_TAN"
            };
            headgear[] = {
                "VSM_Mich2000_2_OGA","VSM_Mich2000_OGA","VSM_OPS_OGA",
                "VSM_Mich2000_2_OGA_OD","VSM_Mich2000_OGA_OD","VSM_OPS_OGA_OD",
                "VSM_OPS","VSM_Tan_spray_OPS","VSM_oga_OPS",
                "VSM_OPS_2_multicam","VSM_black_OPS_2","VSM_MulticamTropic_OPS_2","VSM_OGA_OD_OPS_2","VSM_OD_spray_OPS_2",
                "TRYK_H_ghillie_over","TRYK_H_ghillie_top","TRYK_H_ghillie_top_headless","TRYK_H_ghillie_top_headless3",
                "TRYK_H_ghillie_over_green","TRYK_H_ghillie_top_green","TRYK_H_ghillie_top_headless_green",
                "H_helmetB","H_helmetB_camo","H_helmetB_desert","H_helmetB_grass","H_helmetB_sand","H_helmetB_snakeskin",
                "H_helmetCrew_I"
            };
            miscItems[] = {
                "TRYK_H_ghillie_top_headless3glass",
                "G_Balaclava_blk","G_Balaclava_lowprofile","G_Balaclava_oli","G_Balaclava_combat",
                "G_Balaclava_TI_blk_F","G_Balaclava_TI_G_blk_F","G_Balaclava_TI_tna_F","G_Balaclava_TI_G_tna_F",
                "G_Bandanna_tan","G_Bandanna_aviator","G_Bandanna_beast","G_Bandanna_blk","G_Bandanna_khk","G_Bandanna_oli","G_Bandanna_shades","G_Bandanna_sport",
                "G_lowprofile","G_Combat","G_Tactical_Clear","G_Tactical_Black","G_Combat_Goggles_tna_F"
            };
        };
    };

    class gen_rifles : base
    {
        displayName = "5.56 Rifles";
        class objects
        {
            miscItems[] = {
                "SMA_BARSKA","SMA_CMORE","SMA_CMOREGRN","SMA_AIMPOINT_GLARE","SMA_AIMPOINT",
                "UK3CB_BAF_Kite","UK3CB_BAF_Eotech","UK3CB_BAF_Flashlight_L131A1","UK3CB_BAF_MaxiKite","UK3CB_BAF_SUIT",
                "rhsusf_acc_eotech_xps3"
            };
        };
        class objectParents
        {
            weapons[] = {
                "rhs_weap_m4_Base","SMA_556_RIFLEBASE","UK3CB_BAF_L85A2","hlc_acr556_base","hlc_ar15_base","hlc_G36_base","UK3CB_BAF_L119_Base"
            };
            miscItems[] = {
                "SMA_ELCAN_SPECTER","sma_spitfire_01_black","sma_spitfire_01_sc_black","sma_spitfire_03_black","SMA_eotech552","SMA_eotech","SMA_eotech_G","SMA_MICRO_T2",
                "UK3CB_BAF_SUSAT","UK3CB_BAF_TA31F",
                "RKSL_optic_LDS","RKSL_optic_RMR_HG","RKSL_optic_RMR_MS19",
                "rhsusf_acc_ACOG","rhsusf_acc_anpeq15","rhsusf_acc_ELCAN","rhsusf_acc_compm4","rhsusf_acc_muzzleFlash_SF3P556","rhsusf_acc_rotex_mp7",
                "rhsusf_acc_SpecterDR",
                "muzzle_snds_H","acc_pointer_IR"
            };
        };
    };

    class gen_dmrs : base
    {
        displayName = "DMR Rifles";
        class objects
        {
            miscItems[] = {
                "rhsusf_acc_anpas13gv1","rhsusf_acc_LEUPOLDMK4","UK3CB_BAF_Kite","UK3CB_BAF_MaxiKite"
            };
        };
        class objectParents
        {
            weapons[] = {
                "SMA_762_RIFLEBASE","rhs_weap_m14ebrri","UK3CB_BAF_L129A1"
            };
            miscItems[] = {
                "UK3CB_BAF_TA648","UK3CB_BAF_TA648",,"RKSL_optic_PMII_312","RKSL_optic_PMII_525",
                "rhsusf_acc_LEUPOLDMK4_2"
            };
        };
    };

    class gen_snipers : gen_dmrs
    {
        displayName = "Snipers";
        class objects : objects {};
        class objectParents : objectParents
        {
            weapons[] = {
                "hlc_AWC_base","rhs_weap_M107_Base_F","rhs_weap_XM2010_Base_F","UK3CB_BAF_L115_Base","srifle_GM6_F"
            };
        };
    };



//,"rhs_weap_m24sws"
};
