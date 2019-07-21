# dos-devices  
 
------ 
 
download: [dos-devices.zip](dos-devices.zip) 
 
 
------ 
          
 
------ 
 
 
[dos-devices.prg](#dos-devices.prg)   
 
[dos-devices.xpj](#dos-devices.xpj)   
 
------ 
 
## dos-devices.prg  
       
``` 
#include "ot4xb.ch"        
proc dbesys;return
//-------------------------------------------------------------------------------------------------------------------------
proc main()   
local buffer  := ChrR(0,1024)
local cb      := @kernel32:QueryDosDeviceA(0,@buffer,len(buffer) )
local n,nn,cc,aa
cc := cDrives()
nn := len(cc)
aa := Array(nn,2)
for n := 1 to nn 
   aa[n][1] := cc[n] + ":"
   cb  := @kernel32:QueryDosDeviceA( aa[n][1] ,@buffer,len(buffer) ) 
   aa[n][2] :=  Tokenize( TrimZ(left(buffer,cb)) , ";" )
next
aEval( aa , {|dd| QOut( dd[1] , "  => " , dd[2] ) } )


inkey(0)


return
//-------------------------------------------------------------------------------------------------------------------------
       
``` 
       
------ 
 
------ 
 
## dos-devices.xpj  
       
``` 
[PROJECT]
    COMPILE       = xpp
    OBJ_DIR       = 
    COMPILE_FLAGS = /n /m /w /wi /wl
    DEBUG         = no
    GUI           = yes
    LINKER        = alink
    LINK_FLAGS    = 
    RC_COMPILE    = arc
    RC_FLAGS      = -v
    PROJECT.XPJ

[PROJECT.XPJ]
    dos-devices.exe
[dos-devices.exe]
dos-devices.prg 
ot4xb.lib 

       
``` 
       
------ 
