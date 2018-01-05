//Universal scroll bar used by several lists
class GVARMAIN(ScrollBar) {
    width = 0; // width of ScrollBar
    height = 0; // height of ScrollBar
    scrollSpeed = 0.01; // scroll speed of ScrollBar
    color[]= COL_AWHITE(0.6);
    colorActive[]= COL_WHITE;
    colorDisabled[]= COL_AWHITE(0.3);
    thumb="\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
    arrowFull="\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
    arrowEmpty="\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
    border="\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
};

//Plain list
class GVARMAIN(RscListBox) : GVARMAIN(RscBase) {
	type = CT_LISTBOX;
	style = ST_LEFT;
	rowHeight = 0.04;
	colorText[] = COL_WHITE;
	colorScrollbar[] = COL_WHITE;
	colorSelect[] = COL_WHITE;
	colorSelect2[] = COL_WHITE;
	colorSelectBackground[] = COL_APROFILE(1);
	colorSelectBackground2[] = COL_APROFILE(1);
	maxHistoryDelay = 1.0;
	soundSelect[] = {"",0.1,1};
	period = 1;
	colorDisabled[] = COL_AWHITE(0.3);
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
	arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
	arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
	shadow = 0;
	class ScrollBar : GVARMAIN(ScrollBar) {
        shadow = 0;
    };
	class ListScrollBar {};
};
    
//List box with side options
class GVARMAIN(RscListNBox) : GVARMAIN(RscBase) { 
    type= CT_LISTNBOX;
	style= ST_MULTI;
	shadow=0;
	color[]= COL_VAR_2(0.95, 1);
	colorText[]= COL_WHITE;
	colorDisabled[]=COL_AWHITE(0.25);
	colorScrollbar[]=COL_VAR_2(0.95,1);
	colorSelect[]=COL_BLACK;
	colorSelect2[]=COL_BLACK;
	colorSelectBackground[]=COL_VAR_2(0.95,1);
	colorSelectBackground2[]=COL_AWHITE(0.5);
	period=1.2;
	soundSelect[]={"",0.1,1};
	rowHeight=0.04;
	autoScrollRewind=0;
	autoScrollSpeed=-1;
	autoScrollDelay=5;
	maxHistoryDelay=1;
	drawSideArrows=0;
	idcLeft=-1;
	idcRight=-1;
	class ScrollBar : GVARMAIN(ScrollBar) {};
    class ListScrollBar {};
};

//Drop down box
class GVARMAIN(RscDropdownMenu) : GVARMAIN(RscBase) { 
	type = CT_COMBO;
	style = ST_LEFT;
	colorSelect[] = COL_WHITE;
	colorBackground[] = COL_VAR_2(0.2,1);
	colorSelectBackground[] = COL_BLACK;
	colorScrollbar[] = COL_VAR_2(0.8, 1);
	arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa";
	arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
	rowHeight = 0.06;
	wholeHeight = 0.45;
	color[] = COL_ABLACK(0.6);
	colorActive[] = COL_WHITE;
	colorDisabled[] = COL_AWHITE(0.3);
	soundSelect[] = {"\ca\ui\data\sound\new1", 0.09, 1};
	soundExpand[] = {"\ca\ui\data\sound\new1", 0.09, 1};
	soundCollapse[] = {"\ca\ui\data\sound\new1", 0.09, 1};
	maxHistoryDelay = 1.0;
    class ComboScrollBar {};
	class ScrollBar : GVARMAIN(ScrollBar) {};
};

//Single box with side arrows
class GVARMAIN(RscXListBox) : GVARMAIN(RscBase) { 
    idc = CT_XLISTBOX; // Control identification (without it, the control won't be displayed)
    type = CT_XLISTBOX; // Type is 42
    style = SL_HORZ + ST_CENTER + LB_TEXTURES; // Style
    default = 0; // Control selected by default (only one within a display can be used)
    blinkingPeriod = 0; // Time in which control will fade out and back in. Use 0 to disable the effect.
    color[] = COL_WHITE; // Arrow color
    colorActive[] = COL_PROFILE; // Selected arrow color
    shadow = 0; // Shadow (0 - none, 1 - N/A, 2 - black outline)
    colorText[] = {1,1,1,1}; // Text color
    colorSelect[] = {1,0.5,0,1}; // Selected text color
    colorDisabled[] = {1,1,1,0.5}; // Disabled text color
    tooltip = ""; // Tooltip text
    tooltipColorShade[] = COL_BLACK; // Tooltip background color
    tooltipColorText[] = COL_WHITE; // Tooltip text color
    tooltipColorBox[] = COL_WHITE; // Tooltip frame color

    arrowEmpty = "\A3\ui_f\data\gui\cfg\slider\arrowEmpty_ca.paa"; // Arrow
    arrowFull = "\A3\ui_f\data\gui\cfg\slider\arrowFull_ca.paa"; // Arrow when clicked on
    border = "\A3\ui_f\data\gui\cfg\slider\border_ca.paa"; // Fill texture
    soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1}; // Sound played when an item is selected
};

//Mother flipping trees
class GVARMAIN(RscTree) : GVARMAIN(RscBase) { 
    type = CT_TREE; // Type is 12
    style = ST_LEFT; // Style
    blinkingPeriod = 0; // Time in which control will fade out and back in. Use 0 to disable the effect.
    colorSelect[] = COL_APROFILE(1); // Selected item fill color (when multiselectEnabled is 0)
    colorMarked[] = COL_APROFILE(0.5); // Marked item fill color (when multiselectEnabled is 1)
    colorPicture[] = COL_NONE;
	colorPictureSelected[] = COL_NONE;
	colorPictureDisabled[] = COL_NONE;
	colorPictureRight[] = COL_NONE;
	colorPictureRightSelected[] = COL_NONE;
	colorPictureRightDisabled[] = COL_NONE;
    colorMarkedSelected[] = COL_APROFILE(1); // Selected item fill color (when multiselectEnabled is 1)
    shadow = 1; // Shadow (0 - none, 1 - N/A, 2 - black outline)
    colorSelectText[] = COL_WHITE; // Selected text color (when multiselectEnabled is 0)
    colorMarkedText[] = COL_WHITE; // Selected text color (when multiselectEnabled is 1)
    tooltip = ""; // Tooltip text
    tooltipColorShade[] = COL_BLACK; // Tooltip background color
    tooltipColorText[] = COL_WHITE; // Tooltip text color
    tooltipColorBox[] = COL_WHITE; // Tooltip frame color
    multiselectEnabled = 1; // Allow selecting multiple items while holding Ctrl or Shift
    expandOnDoubleclick = 1; // Expand/collapse item upon double-click
    hiddenTexture = "A3\ui_f\data\gui\rsccommon\rsctree\hiddenTexture_ca.paa"; // Expand icon
    expandedTexture = "A3\ui_f\data\gui\rsccommon\rsctree\expandedTexture_ca.paa"; // Collapse icon
    maxHistoryDelay = 1; // Time since last keyboard type search to reset it
    class ScrollBar : GVARMAIN(ScrollBar) {};
    colorDisabled[] = COL_NONE; // Does nothing, but must be present, otherwise an error is shown
    colorArrow[] = COL_NONE; // Does nothing, but must be present, otherwise an error is shown
};