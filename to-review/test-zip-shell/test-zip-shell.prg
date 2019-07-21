#include "ot4xb.ch"
#xtranslate SAFE_RELEASE( <v> ) => (<v> := iif(Empty(<v>),0,(IFpQCall(2,"__sl__sl",<v>),0)))
#xtranslate L(<c>)  => cSzAnsi2Wide(<c>)
//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//----------------------------------------------------------------------------------------------------------------------
proc main                                                 
local cSrcFolder := cPathCombine( cAppPath() , "test")
local cDstZip    := cPathCombine( cAppPath() , "test.zip")
? add_folder_to_zip(cSrcFolder,cDstZip,.T.)
inkey(0)
return 
//----------------------------------------------------------------------------------------------------------------------
function add_folder_to_zip(cSrcFolder,cDstZip,lMove) 
local piShell   := 0
local piSrcFolder  := 0
local piDstFolder  := 0    
local result := -1                                          
DEFAULT lMove := .F.
if !lIsFile(cDstZip)
   lMemoWrite( cDstZip,cHex2Bin("504B0506000000000000000000000000000000000000"))
end
if !lIsFile(cDstZip)
   return .F.
end                  

if ( _dh_CreateObject(L("shell.application"),0,@piShell ) >= 0 )
	if( _dh_GetValue(L("%o"),@piSrcFolder,piShell,L(".NameSpace(%s)"),cSrcFolder) >= 0 )
	   if( _dh_GetValue(L("%o"),@piDstFolder,piShell,L(".NameSpace(%s)"),cDstZip) >= 0 )   
         result := _dh_CallMethod(piDstFolder, L("." + iif(lMove,"Move","Copy") +  "Here(%o,%d)") ,piSrcFolder , 20  )
         SAFE_RELEASE(piDstFolder)
      end
      SAFE_RELEASE(piSrcFolder)
   end
   SAFE_RELEASE(piShell)
end
return (result  >= 0 )
