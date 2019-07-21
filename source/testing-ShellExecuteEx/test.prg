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
? "lanzamos la aplicacion: "
if ose:start()
   ?? "ok"              
   ? "Esperamos a que termine. Space Bar = abandone. esc = kill"    
   while !ose:wait( 1000 )
      nKey := inkey(.3)
      if nKey == 27
         ose:kill()
         ? " lo hemos matao"
         exit
      elseif nKey == 32
         ? " lo abandonamos"
         exit
      end
   end
   if !( nKey == 27 .or. nKey == 32)
      ? " parece que ha terminado"
   end
else
  ?? " fallo al ejecutarse"
end
ose:release()
? "dale a alguna tecla para salir"
inkey(0)
return