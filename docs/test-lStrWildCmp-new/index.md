# test-lStrWildCmp-new  
 
------ 
 
download: [test-lStrWildCmp-new.zip](test-lStrWildCmp-new.zip) 
 
 
------ 
          
#test-lStrWildCmp-new           
  
----  
  
 
------ 
 
 
[test-lStrWildCmp-new.prg](#test-lStrWildCmp-new.prg)   
 
[test-lStrWildCmp-new.xpj](#test-lStrWildCmp-new.xpj)   
 
------ 
 
## test-lStrWildCmp-new.prg  
       
``` 
#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
#xcommand \<\< <exp> => QOut( <(exp)> , <exp> )
//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//-------------------------------------------------------------------------------------------------------------------------
proc main()     
SetMode( 40 , 128) 
<< lStrWildCmp( "pata*" , "Patata" , .F. )
<< lStrWildCmp( "pata*" , "Patata" , .T. )
<< lStrWildCmp( "pata*" , "Patata" , 0 )
<< lStrWildCmp( "pata*" , "Patata" , 1 )
<< lStrWildCmp( "pata*" , "Patata" , 2 )
<< lStrWildCmp( "pata*" , "Patata" , 3 )


<< lStrWildCmp( {"pita*","pota*" ,"peta*" ,"pata*" ,"pa*"}  , "Patata" , .F. )
<< lStrWildCmp( {"pita*","pota*" ,"peta*" ,"pata*" ,"pa*"}  , "Patata" , .T. )
<< lStrWildCmp( {"pita*","pota*" ,"peta*" ,"pata*" ,"pa*"}  , "Patata" , 0 )
<< lStrWildCmp( {"pita*","pota*" ,"peta*" ,"pata*" ,"pa*"}  , "Patata" , 1 )
<< lStrWildCmp( {"pita*","pota*" ,"peta*" ,"pata*" ,"pa*"}  , "Patata" , 2 )
<< lStrWildCmp( {"pita*","pota*" ,"peta*" ,"pata*" ,"pa*"}  , "Patata" , 3 )
<< lStrWildCmp( {"pita*","pota*" ,"peta*" ,"pata*" ,"pa*"}  , "Patata" , 7 )
<< lStrWildCmp( {"pita*","pota*" ,"peta*" ,"pata*" ,"pa*","pita*","pota*" ,"peta*"}  , "Patata" , 7 )
inkey(0)
return        
``` 
       
------ 
 
------ 
 
## test-lStrWildCmp-new.xpj  
       
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
    test-lStrWildCmp-new.exe
[test-lStrWildCmp-new.exe]
test-lStrWildCmp-new.prg 
ot4xb.lib 

       
``` 
       
------ 
