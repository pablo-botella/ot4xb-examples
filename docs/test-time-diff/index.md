# test-time-diff  
 
------ 
 
download: [test-time-diff.zip](test-time-diff.zip) 
 
 
------ 
          
 
------ 
 
 
[test-time-diff.prg](#test-time-diff.prg)   
 
[test-time-diff.XPJ](#test-time-diff.XPJ)   
 
------ 
 
## test-time-diff.prg  
       
``` 
#include "ot4xb.ch"

//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//----------------------------------------------------------------------------------------------------------------------
proc main                                                 
local t1 , t2 

// "using 8 byte bin string ( 64 bit integer) "
t1 := ChrR(0,8)   ; ft64_setdateTime( @t1 , StoD("20171231") , "23:00" )
t2 := ChrR(0,8)   ; ft64_setdateTime( @t2 , StoD("20180101") , "01:34" )

? ft64_ElapSeconds( t1,t2 )
// ------------------------------------
// "using a FILETIME64 OBJECT"
t1 := FILETIME64():New():setdateTime(StoD("20171231") , "23:00" )
t2 := FILETIME64():New():setdateTime(StoD("20180101") , "01:34" )

? ft64_ElapSeconds( t1,t2 )
// or
? t1:ElapSeconds(t2)                   

inkey(0)
return 




//----------------------------------------------------------------------------------------------------------------------
       
``` 
       
------ 
 
------ 
 
## test-time-diff.XPJ  
       
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
test-time-diff.EXE

[test-time-diff.EXE]
test-time-diff.prg
ot4xb.lib


       
``` 
       
------ 
