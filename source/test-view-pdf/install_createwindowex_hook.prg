#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
function install_createwindowex_hook( )
static rrr := NIL
if rrr != NIL ; return NIL ;end
rrr := @ot4xb:_ot4xb_hook_func_in_mod_( nLoadLibrary("xpprt1"),;
                                        "user32.dll",;
                                        "CreateWindowExA",;
                                        @ot4xb:_ot4xb_hook_createwindowex_(-1) )

rrr := @ot4xb:_ot4xb_hook_func_in_mod_( nLoadLibrary("xppui1"),;
                                        "user32.dll",;
                                        "CreateWindowExA",;
                                        @ot4xb:_ot4xb_hook_createwindowex_(-1) )
return NIL

//----------------------------------------------------------------------------------------------------------------------
 