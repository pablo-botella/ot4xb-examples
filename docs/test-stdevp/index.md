# test-stdevp  
 
------ 
 
download: [test-stdevp.zip](test-stdevp.zip) 
 
 
------ 
          
 
------ 
 
 
[test-stdevp.prg](#test-stdevp.prg)   
 
[test-stdevp.XPJ](#test-stdevp.XPJ)   
 
------ 
 
## test-stdevp.prg  
       
``` 
#include "ot4xb.ch"
#include "winbase_constants.ch"
//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//----------------------------------------------------------------------------------------------------------------------
function stdevp()
local np := PCount()
local n,t,v
local series := @ot4xb:list_of_float_double_t_new(0,0) 
for n := 1 to np
   v := PValue(n)
   t := Valtype(v)
   if t == 'A'
      aeval(v , {|_e| @ot4xb:[__f8__pt__f8]:list_of_float_double_t_add( series , __vnum(_e,0) ) } )
   elseif t == 'C' .or. t == 'M'
       @ot4xb:list_of_float_double_t_add_list( series, v , nOr(len(v/8)) )
   else
       @ot4xb:[__f8__pt__f8]:list_of_float_double_t_add( series ,__vnum(v,0) )
   end
next
v := @ot4xb:[__f8__pt__sl__sl]:list_of_float_double_t_calculate_population_standard_deviation(series,0,-1)
@ot4xb:list_of_float_double_t_destroy(series)
return v
//----------------------------------------------------------------------------------------------------------------------
proc main                                                 

? cPrintf("%.08f",,stdevp( 82 , 233.9041113 ))

inkey(0)
                                         
return 

//----------------------------------------------------------------------------------------------------------------------
       
``` 
       
------ 
 
------ 
 
## test-stdevp.XPJ  
       
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
test-stdevp.exe

[test-stdevp.exe]
test-stdevp.prg
ot4xb.lib


       
``` 
       
------ 
