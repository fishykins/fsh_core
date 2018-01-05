class RscTitles
{
	class GVAR(targetHitMarker)
	{
		idd = IDC_HUD;
		duration = 3;
        onLoad = QUOTE([ARR_1(_this)] call FUNC(targetHudInit));
    	onUnLoad = QUOTE([ARR_1(_this)] call FUNC(targetHudExit));

		class Objects
		{
			class targetObject
			{
                idc = IDC_OBJECT_TARGET;
    			type = 82;
				style = 0;
    			model = "\A3\Structures_F\Training\Target_PopUp_F.p3d";

                scale = HUD_SCALE;
    			direction[] = {0.2,0,1}; // {0.2,0,1}
    			up[] = {0,1,0};
    			x = 0.669062 * safezoneW + safezoneX;
    			y = 0.3 * safezoneH + safezoneY; //0.01 * safezoneH + safezoneY;
    			z = 0.2;
    			xBack = 0.85 * safezoneW + safezoneX;
    			yBack = 0.45 * safezoneH + safezoneY;
    			zBack = 0.6;
    			inBack = 1;
    			enableZoom = 0;
    			zoomDuration = 0.001;
			};

            class pointer : targetObject
			{
                idc = IDC_OBJECT_POINTER;
                type = 82;
				style = 0;
    			model = "\A3\Structures_F_Heli\VR\Helpers\Sign_sphere10cm_F.p3d";
                onObjectMoved = "systemChat str (ctrlPosition (_this select 0))";
			};
		};
	};
};
