# test-MessageBoxA  
 
------ 
 
download: [test-MessageBoxA.zip](test-MessageBoxA.zip) 
 
 
------ 
          
#test-MessageBoxA               
  
----  
  
 
------ 
 
 
[test-MessageBoxA.prg](#test-MessageBoxA.prg)   
 
[test-MessageBoxA.XPJ](#test-MessageBoxA.XPJ)   
 
------ 
 
## test-MessageBoxA.prg  
       
``` 
#include "ot4xb.ch"
#include "winbase_constants.ch"
#include "winuser_constants.ch"
//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//----------------------------------------------------------------------------------------------------------------------
proc main                                                 

? @user32:MessageBoxA( 0 , "Testing MessageBoxA " , "Title of the window",nOr(MB_ICONASTERISK , MB_SYSTEMMODAL ))
while inkey(0) != 27
   ? "press space to show the MessageBoxA or exc to exit or any other key to loop"
   if LastKey() == 32
   	  ? @user32:MessageBoxA( 0 , "Text of the Box" , "Title of the window",nOr(MB_ICONASTERISK , MB_SYSTEMMODAL ))
   end
end
return 
//----------------------------------------------------------------------------------------------------------------------

                         
       
``` 
       
------ 
 
------ 
 
## test-MessageBoxA.XPJ  
       
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
test-MessageBoxA.exe

[test-MessageBoxA.exe]
test-MessageBoxA.prg
ot4xb.lib




       
``` 
       
------ 
