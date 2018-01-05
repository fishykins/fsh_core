class FSH_animations {
    class fsh_anim_base {
        type = "base";
        start[] = {};
        statics[] = {};
        loops[] = {};
        end[] = {};
        code = "";
    };
    
    class fsh_anim_sitGround: fsh_anim_base {
        type = "sit";
        start[] = {"SitDown"};
        statics[] = {"amovpsitmstpslowwrfldnon"};
        loops[] = {"AmovPsitMstpSrasWrflDnon_WeaponCheck1","AmovPsitMstpSrasWrflDnon_WeaponCheck2","AmovPsitMstpSnonWnonDnon_smoking"};
        end[] = {"Stand"};
    };
    
    class fsh_anim_workout: fsh_anim_base {
        type = "workout";
        start[] = {"PlayerProne"};
        statics[] = {};
        loops[] = {"AmovPercMstpSnonWnonDnon_exercisePushup"};
        end[] = {"Stand"};
    };
    
    class fsh_anim_talk: fsh_anim_base {
        type = "talk";
        start[] = {"Stand"};
        loops[] = {"acts_StandingSpeakingUnarmed","AmovPercMstpSnonWnonDnon_AmovPercMstpSrasWrflDnon", "AmovPercMstpSlowWrflDnon"};
    };
};