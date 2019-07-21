#include "ot4xb.ch"
proc main 
local cRegExp := "(?:.*\.xpj)|(?:.*\.prg)|(?:.*\.ch)$"
// local cRegExp := "^(?:.*\.prg)|(?:.*\.xpj)$"
local aFiles := Array(0)
local b := {|fd,cPath| aadd( aFiles , cPathCombine(cPath,fd:cFileName)) , qout(cPathCombine(cPath,fd:cFileName)) }
local aFolders,nCount

aFolders := get_array_of_hd_root()
// aFolders := {"S:\","C:\"}      
? aFolders
? "press a key to continue ..."
inkey(0)

nCount := TraverseFolders(aFolders,cRegExp,b) 

? nCount  , " files"
inkey(0)

return
//----------------------------------------------------------------------------------------------------------------------
static function get_array_of_hd_root() // this function is so weak as not checking is a device is a subst 
local aHD      := Array(0) 
local aDrives  := ADrives()
local n,nn
nn := len(aDrives)
aeval( ADrives() , {|_c| n := nGetDriveType(_c) , iif( n==3 .or. n == 4 , aadd(aa,_c) ,)} )
return aa
//----------------------------------------------------------------------------------------------------------------------

function TraverseFolders( aFolder , cRegExp , bAction , uCargo,lCancel) 
local nFound := 0
local stk,fd,re,cFolder,lFound


DEFAULT lCancel := .F.

if Valtype(aFolder) != "A" ; return -1 ; end
if Valtype(bAction) != "B" ; return -1 ; end
if Empty(aFolder) ; return 0 ; end
if Empty(__vstr(cRegExp,"") )   ; return 0 ; end   

stk  := TGXbStack():New() 
fd   := WIN32_FIND_DATA():New()  
re   := _rgx():new( __vstr(cRegExp,".*") , "gim"   )  
aeval( aFolder , {|_c| stk:add(_c)} )
while (!lCancel) .and. ( stk:count() > 0 )
   cFolder := stk:pop()
   lFound := fd:FindFirst(cPathCombine(cFolder,"*.*"))
   while lFound
      if fd:lDirectory 
         if !(("|" + fd:cFileName + "|") $ "|.||..|")
            stk:push( cPathCombine( cFolder , fd:cFileName ) )
         end
      elseif re:test( fd:cFileName ) .or. re:test( fd:cAlternateFileName )
         nFound++
         eval(bAction,fd,cFolder,@uCargo)
      end
      if lCancel ; EXIT ; end
      lFound := fd:FindNext()
   end
   fd:FindClose() 
end
stk:destroy()
re:destroy()
return nFound
//----------------------------------------------------------------------------------------------------------------------


   














    