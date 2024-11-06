#define _OT4XB_MAP_WAPIST_FUNC_
#include "ot4xb.ch"
#include "winuser_constants.ch"
//----------------------------------------------------------------------------------------------------------------------
proc dbesys; return
//----------------------------------------------------------------------------------------------------------------------
proc main( cDir )
local odc := TNotifyDirectoryChanges():New()  
odc:b_on_post_notyfy := {|reason,name,base | Qout( reason,"|",name,"|","|",base ) }
odc:Start()
DEFAULT cDir := cAppPath()
? odc:Add( cDir ,0x11F,.T.)
while inkey(0) != 27 ; end
? "Stopping ... "
odc:Stop()
while ! odc:Wait(.5)   
   ?? "."
   if inkey(.5) == 27 ; exit ; end
end
 odc:Destroy()  
? "press a key to exit .... "
while inkey(0) != 27 ; end

return
//----------------------------------------------------------------------------------------------------------------------



        
                                                           