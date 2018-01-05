#include "\x\fsh_core\addons\ui\script_RscDialog.hpp"

class GVARMAIN(RscBase) {
    idc = -1;
    type = CT_STATIC;
    style = ST_SINGLE;
    DEFAULT_POS;
    sizeEx="(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    text = DEFAULT_TEXT;
    font = DEFAULT_FONT;
    colorText[] = COL_WHITE;
    colorBackground[] = COL_VAR_2(0.2,0.5);
    colorBorder[] = COL_WHITE; // Frame color
};

#include "RscCommon.hpp"
#include "RscButtons.hpp"
#include "RscLists.hpp"
#include "RscMap.hpp"
