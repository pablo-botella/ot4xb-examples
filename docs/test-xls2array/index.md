# test-xls2array  
 
------ 
 
download: [test-xls2array.zip](test-xls2array.zip) 
 
 
------ 
          
 
------ 
 
 
[test-xls2array.prg](#test-xls2array.prg)   
 
[xls2array.prg](#xls2array.prg)   
 
[test-xls2array.xpj](#test-xls2array.xpj)   
 
------ 
 
## test-xls2array.prg  
       
``` 
#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
proc main( cFile )       
local n := Seconds()
DEFAULT cFile := cPathCombine(cAppPath(),"test.xlsx")
SetMode( 30,100)
? xls2array( cFile )
? Seconds() - n
inkey(0)
return
//----------------------------------------------------------------------------------------------------------------------
       
``` 
       
------ 
 
------ 
 
## xls2array.prg  
       
``` 
#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
#xtranslate SAFE_RELEASE( <v> ) => (<v> := iif(Empty(<v>),0,(IFpQCall(2,"__sl__sl",<v>),0)))
//----------------------------------------------------------------------------------------------------------------------
#xtranslate L(<c>)  => cSzAnsi2Wide(<c>)
//----------------------------------------------------------------------------------------------------------------------
function xls2array( cXls )
local piApp   := 0
local piWb    := 0
local piRg    := 0
local result  := NIL
local vt      := __vtEmpty__
if ( _dh_CreateObject(L("Excel.Application"),0,@piApp ) >= 0 )
	if( _dh_GetValue(L("%o"),@piWb,piApp,L(".Workbooks.Open(%s)"),cXls) >= 0 )
	   if( _dh_GetValue(L("%v"),@vt,piWb,L(".Worksheets(%d).UsedRange.Value"),1) >= 0 )
         result := _conRelease( @ot4xb:_variant_t_VT_ARRAY_2d2con(vt) )
         @ot4xb:_variant_t_Clear(@vt)
      end
      SAFE_RELEASE(piWb)
   end
    _dh_CallMethod(piApp, L(".Quit()") )
   SAFE_RELEASE(piApp)
end
return result
//----------------------------------------------------------------------------------------------------------------------
       
``` 
       
------ 
 
------ 
 
## test-xls2array.xpj  
       
``` 

[PROJECT]
    COMPILE       = xpp
    COMPILE_FLAGS = /n /m /w /p /wi /wl
    DEBUG         = no
    GUI           = yes
    OBJ_DIR       =
    LINKER        = alink
    LINK_FLAGS    =
    RC_COMPILE    = arc
    RC_FLAGS      = /v /x:.\res
    PROJECT.XPJ


[PROJECT.XPJ]
    test-xls2array.exe

[test-xls2array.exe]
 test-xls2array.prg
 xls2array.prg     
 ot4xb.lib
 
       
``` 
       
------ 
