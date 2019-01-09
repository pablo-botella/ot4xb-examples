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