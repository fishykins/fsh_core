#define DEFAULT_FONT    FONT_DEFAULT
#define DEFAULT_SIZEEX  0.32
#define DEFAULT_POS     x = 0; y = 0; w = 1; h = 1
#define DEFAULT_TEXT    ""
#define DEFAULT_SHADOW  {0, 0, 0, 0.5}

#define FONT_BOLD               "EtelkaMonospaceProBold"
#define FONT_LARGE              "TahomaB"
#define FONT_ITALIC             "Zeppelin33Italic"
#define FONT_NARROW             "EtelkaNarrowMediumPro"
#define FONT_DEFAULT            "PuristaMedium"

#define COL_BLACK               {0, 0, 0, 1}
#define COL_WHITE               {1, 1, 1, 1}
#define COL_YELLOW              {1, 1, 0, 1}
#define COL_NONE                {0, 0, 0, 0}
#define COL_AWHITE(var1)        {0, 0, 0, var1}
#define COL_ABLACK(var1)        {1, 1, 1, var1}
#define COL_VAR(var1)           {var1,var1,var1,var1}
#define COL_VAR_2(var1,var2)    {var1,var1,var1,var2}
//#define COL_APROFILE_B(var1,var2)    {QUOTE((profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843]) + var2), QUOTE((profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019]) + var2), QUOTE((profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862]) + var2), var1}
#define COL_APROFILE(var1)           {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", var1}
#define COL_APROFILE_BRIGHT(var1)    {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843]) * 1.5", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019]) * 1.5", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862]) * 1.5", var1}
#define COL_PROFILE                  COL_APROFILE(1)
#define COL_PROFILE_BRIGHT           COL_APROFILE_BRIGHT(1)

#define UIPOS(var1,var2,var3,var4)    x = var1; y = var2; w = WIDTH(var3,var1); h = HEIGHT(var4,var2)
#define WIDTH(var1,var2)   (var1 - var2)
#define HEIGHT(var1,var2)  WIDTH(var1,var2)

//CT styles

#define CT_STATIC 0
#define CT_BUTTON 1
#define CT_EDIT 2
#define CT_SLIDER 3
#define CT_COMBO 4
#define CT_LISTBOX 5
#define CT_TOOLBOX 6
#define CT_CHECKBOXES 7
#define CT_PROGRESS 8
#define CT_HTML 9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT 11
#define CT_TREE 12
#define CT_STRUCTURED_TEXT 13
#define CT_CONTEXT_MENU 14
#define CT_CONTROLS_GROUP 15
#define CT_SHORTCUTBUTTON 16
#define CT_XKEYDESC 40
#define CT_XBUTTON          41
#define CT_XLISTBOX 42
#define CT_XSLIDER 43
#define CT_XCOMBO 44
#define CT_ANIMATED_TEXTURE 45
#define CT_MENU 46 //Arma 3 (EDEN)
#define CT_MENU_STRIP 47 //Arma 3 (EDEN)
#define CT_CHECKBOX 77 //Arma 3
#define CT_OBJECT 80
#define CT_OBJECT_ZOOM 81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK 98
#define CT_ANIMATED_USER 99
#define CT_MAP 100
#define CT_MAP_MAIN 101
#define CT_LISTNBOX 102
#define CT_ITEMSLOT         103

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0c

#define ST_TYPE           0xF0
#define ST_SINGLE         0
#define ST_MULTI          16
#define ST_TITLE_BAR      32
#define ST_PICTURE        48
#define ST_FRAME          64
#define ST_BACKGROUND     80
#define ST_GROUP_BOX      96
#define ST_GROUP_BOX2     112
#define ST_HUD_BACKGROUND 128
#define ST_TILE_PICTURE   144 //tileH and tileW params required for tiled image
#define ST_WITH_RECT      160
#define ST_LINE           176

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200 // this style works for CT_STATIC in conjunction with ST_MULTI
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           1024

#define SL_TEXTURES       0x10

// progress bar
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

#define FontM             "Zeppelin32" // The standard font in Arma 3 is "PuristaMedium"

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4
