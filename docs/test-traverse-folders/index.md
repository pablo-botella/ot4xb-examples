# test-traverse-folders  
 
------ 
 
download: [test-traverse-folders.zip](test-traverse-folders.zip) 
 
 
------ 
          
 
------ 
 
 
[test-traverse-folders.prg](#test-traverse-folders.prg)   
 
[test-traverse-folders.XPJ](#test-traverse-folders.XPJ)   
 
------ 
 
## test-traverse-folders.prg  
       
``` 
#include "ot4xb.ch"
proc main 
local cRegExp := "(?:.*\.xpj)|(?:.*\.prg)|(?:.*\.ch)$"

local aFiles := Array(0)
local b := {|fd,cPath| aadd( aFiles , cPathCombine(cPath,fd:cFileName)) , qout(cPathCombine(cPath,fd:cFileName)) }
local aFolders,nCount

aFolders := __anew( cPathGetRoot(cAppPath()))
? aFolders


nCount := TraverseFolders( aFolders ,cRegExp,b) 

? nCount  , " files"
inkey(0)

return
//----------------------------------------------------------------------------------------------------------------------
static function get_array_of_hd_root() // this function is so weak as not checking is a device is a subst 
local aHD      := Array(0) 
local n
aeval( ADrives() , {|_c| n := nGetDriveType(_c) , iif( n==3 .or. n == 4 , aadd(aHD,_c) ,)} )
return aHD
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


   














           
``` 
       
------ 
 
------ 
 
## test-traverse-folders.XPJ  
       
``` 
[PROJECT]
    COMPILE       = xpp  /w /wi /wl /wu  /p /n /m
    COMPILE_FLAGS = 
    DEBUG         = no
    GUI           = yes
    LINKER        = alink
    LINK_FLAGS    =
    RC_COMPILE    = arc
    RC_FLAGS      = -v
    project.xpj

[project.xpj]
test-traverse-folders.exe

[test-traverse-folders.exe]
test-traverse-folders.prg
ot4xb.lib




       
``` 
       
------ 
