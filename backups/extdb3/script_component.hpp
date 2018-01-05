#define COMPONENT extdb3

#include "\x\fsh_core\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define RECOMPILE recompile = 1

#include "\x\fsh_core\addons\main\script_macros.hpp"

#define FC_SQL "FSH_CORE_SQL"
#define FC_SQL_INI "fsh_core_main.ini"
#define FC_SQL_PD "FSH_CORE_PLAYERDATA"
#define FC_SQL_PD_INI "fsh_core_playerData.ini"

#define EXTDB3_CALL(_var1,_var2)                           (call compile ("extDB3" callExtension format["0:%1:%2", _var1, _var2]))
#define EXTDB3_CALL_1(_var1,_var2,_var3)                   (call compile ("extDB3" callExtension format["0:%1:%2:%3", _var1, _var2, _var3]))
#define EXTDB3_CALL_2(_var1,_var2,_var3,_var4)             (call compile ("extDB3" callExtension format["0:%1:%2:%3:%4", _var1, _var2, _var3, _var4]))
#define EXTDB3_CALL_3(_var1,_var2,_var3,_var4,_var5)       (call compile ("extDB3" callExtension format["0:%1:%2:%3:%4:%5", _var1, _var2, _var3, _var4, _var5]))


#define EXTDB3_PLAYER_CALL(_var1)                           EXTDB3_CALL(FC_SQL_PD, _var1)
#define EXTDB3_PLAYER_CALL_1(_var1,_var2)                   EXTDB3_CALL(FC_SQL_PD, _var1,_var2)
#define EXTDB3_PLAYER_CALL_2(_var1,_var2,_var3)             EXTDB3_CALL(FC_SQL_PD, _var1,_var2,_var3)
#define EXTDB3_PLAYER_CALL_3(_var1,_var2,_var3,_var4)       EXTDB3_CALL(FC_SQL_PD, _var1,_var2,_var3,_var4)
