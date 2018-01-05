//Plain text
class GVARMAIN(RscText) : GVARMAIN(RscBase) {
    type = CT_STATIC;
    style = ST_SINGLE;
	shadow = 1;
	colorShadow[] = {0, 0, 0, 0.5};
};

//Structured Text
class GVARMAIN(RscStructuredText) : GVARMAIN(RscBase) {
    type = CT_STRUCTURED_TEXT;
    style = ST_SINGLE;
    size = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    shadow = 1;
    class Attributes {
		font = DEFAULT_FONT;
		color = "#ffffff";
		align = "left";
		shadow = 1;
	};
};

//Picture
class GVARMAIN(RscPicture) : GVARMAIN(RscBase) {
    type = CT_STATIC;
    style = ST_PICTURE;
    shadow = 1;
    colorShadow[] = DEFAULT_SHADOW;
};

//Progress bar
class GVARMAIN(RscProgress) {
	type = CT_PROGRESS;
	style = ST_SINGLE;
	colorFrame[] = COL_BLACK;
	colorBar[] = COL_WHITE;
	texture = "#(argb,8,8,3)color(1,1,1,1)";
    w = 1;
    h = 0.03;
};

//Text field box for inputting
class GVARMAIN(RscEdit) :  GVARMAIN(RscBase) {
    type = CT_EDIT;
	style = ST_LEFT + 0x40;
	shadow = 2;
	colorDisabled[] = COL_AWHITE(0.25);
	autocomplete = false;
	colorSelection[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 1};
	canModify = 1;
};

//Slider bar
class GVARMAIN(RscSlider) {
    type = CT_XSLIDER;
    style = 1024;
    shadow = 2;
    x = 0;
	y = 0;
	h = 0.029412;
	w = 0.400000;
    color[] = COL_AWHITE(0.7);
    colorActive[] = COL_WHITE;
    colorDisabled[] = COL_AWHITE(0.5);
    arrowEmpty = "\A3\ui_f\data\gui\cfg\slider\arrowEmpty_ca.paa";
	arrowFull = "\A3\ui_f\data\gui\cfg\slider\arrowFull_ca.paa";
	border = "\A3\ui_f\data\gui\cfg\slider\border_ca.paa";
	thumb = "\A3\ui_f\data\gui\cfg\slider\thumb_ca.paa";
	soundEnter[] = {"\A3\ui_f\data\sound\onover", 0.09, 1};
	soundPush[] = {"\A3\ui_f\data\sound\new1", 0.0, 0};
	soundClick[] = {"\A3\ui_f\data\sound\onclick", 0.07, 1};
	soundEscape[] = {"\A3\ui_f\data\sound\onescape", 0.09, 1};
};
