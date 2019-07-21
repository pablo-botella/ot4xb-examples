#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
proc main       
local ose := TShellExecuteInfo():new()  
local nKey
ose:lMaskNoCloseProcess := .T.
ose:cVerb := "edit"     
ose:nShow := ose:swShowNormal                       
ose:cFile := cPathCombine( cAppPath() , "readme.txt")
lMemoWrite( ose:cFile , "" , .T.) 
ose:cDirectory := cAppPath()     
? "launch the application: "
if ose:start()
   ?? "ok"              
   ? "wait for termination. Space Bar = abandone. esc = kill"    
   while !ose:wait( 1000 )
      nKey := inkey(.3)
      if nKey == 27
         ose:kill()
         ? " we killed the app"
         exit
      elseif nKey == 32
         ? " we abandoned the app"
         exit
      end
   end
   if !( nKey == 27 .or. nKey == 32)
      ? " looks like ithave finished"
   end
else
  ?? " fail launching the app"
end
ose:release()
? "press any key to close this box"
inkey(0)
return