#define COMPONENT animation

#include "\x\fsh_core\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define RECOMPILE recompile = 1

#include "\x\fsh_core\addons\main\script_macros.hpp"

#define END_MOVE (_animations select (_phases+1) )

#define UNPACK_ANIMS(_var1) \
    private _animsStart = _var1 select 0; \
    private _animsStart2 = _var1 select 1; \
    private _animsLoop = _var1 select 2; \
    private _animsEnd = _var1 select 3; \
    private _animsEnd2 = _var1 select 4;
    
#define ANIMATE(_var1,_var2) _var1 playMoveNow (_var2); _var1 setVariable ["fsh_animDone", false, false]