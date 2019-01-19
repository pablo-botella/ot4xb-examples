#include "ot4xb.ch"
#xtranslate EXPANDO_FORMAT_DEBUG                  => 1
#xtranslate EXPANDO_FORMAT_PRETTY                 => 0x01000000
#xtranslate EXPANDO_FORMAT_ND_PRECISSION( <x> )   => nLShift( nAnd( <x> , 0x0F ) , 16 )
#xtranslate EXPANDO_FORMAT_ND_FIXED               => 0x00100000
#xtranslate EXPANDO_FORMAT_ND_MINIMAL             => 0x00200000
//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//----------------------------------------------------------------------------------------------------------------------
proc main
local oo := _ot4xb_expando_():new()
local aa := Array(132)

if ( ot4xb() < "001.006.004.070" )  
   ?  "this test will crash with ot4xb  < 001.006.004.070"
   inkey(0)
   return
end

oo:uno    := cnt1()
oo:dos    := { cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() }
oo:tres   := { cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() }
oo:cuatro := { cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() }
oo:cinco  := { cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() }
oo:seis   := { cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() }
oo:siete  := { cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() }
oo:ocho   := { cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() }
oo:nueve  := { cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() }
oo:diez   := { cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() }
oo:once   := { cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() }
oo:doce   := { cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() , cnt1() }



aa[  1] := nOr(                                                                                                                   ) 
aa[  2] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED                                         ) 
aa[  3] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 01 )  ) 
aa[  4] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 02 )  ) 
aa[  5] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 03 )  ) 
aa[  6] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 04 )  ) 
aa[  7] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 05 )  ) 
aa[  8] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 06 )  ) 
aa[  9] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 07 )  ) 
aa[ 10] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 08 )  ) 
aa[ 11] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 09 )  ) 
aa[ 12] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 10 )  ) 
aa[ 13] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 11 )  ) 
aa[ 14] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 12 )  ) 
aa[ 15] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 13 )  ) 
aa[ 16] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 14 )  ) 
aa[ 17] := nOr(                                                   EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 15 )  ) 
aa[ 18] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL                                       ) 
aa[ 19] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 01 )  ) 
aa[ 20] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 02 )  ) 
aa[ 21] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 03 )  ) 
aa[ 22] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 04 )  ) 
aa[ 23] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 05 )  ) 
aa[ 24] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 06 )  ) 
aa[ 25] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 07 )  ) 
aa[ 26] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 08 )  ) 
aa[ 27] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 09 )  ) 
aa[ 28] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 10 )  ) 
aa[ 29] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 11 )  ) 
aa[ 30] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 12 )  ) 
aa[ 31] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 13 )  ) 
aa[ 32] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 14 )  ) 
aa[ 33] := nOr(                                                   EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 15 )  ) 
aa[ 34] := nOr(                        	EXPANDO_FORMAT_PRETTY                                                                    ) 
aa[ 35] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED                                         ) 
aa[ 36] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 01 )  ) 
aa[ 37] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 02 )  ) 
aa[ 38] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 03 )  ) 
aa[ 39] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 04 )  ) 
aa[ 40] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 05 )  ) 
aa[ 41] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 06 )  ) 
aa[ 42] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 07 )  ) 
aa[ 43] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 08 )  ) 
aa[ 44] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 09 )  ) 
aa[ 45] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 10 )  ) 
aa[ 46] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 11 )  ) 
aa[ 47] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 12 )  ) 
aa[ 48] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 13 )  ) 
aa[ 49] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 14 )  ) 
aa[ 50] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 15 )  ) 
aa[ 51] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL                                       ) 
aa[ 52] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 01 )  ) 
aa[ 53] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 02 )  ) 
aa[ 54] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 03 )  ) 
aa[ 55] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 04 )  ) 
aa[ 56] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 05 )  ) 
aa[ 57] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 06 )  ) 
aa[ 58] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 07 )  ) 
aa[ 59] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 08 )  ) 
aa[ 60] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 09 )  ) 
aa[ 61] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 10 )  ) 
aa[ 62] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 11 )  ) 
aa[ 63] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 12 )  ) 
aa[ 64] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 13 )  ) 
aa[ 65] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 14 )  ) 
aa[ 66] := nOr(                        	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 15 )  ) 
aa[ 67] := nOr( EXPANDO_FORMAT_DEBUG   	                                                                                         ) 
aa[ 68] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED                                         ) 
aa[ 69] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 01 )  ) 
aa[ 70] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 02 )  ) 
aa[ 71] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 03 )  ) 
aa[ 72] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 04 )  ) 
aa[ 73] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 05 )  ) 
aa[ 74] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 06 )  ) 
aa[ 75] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 07 )  ) 
aa[ 76] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 08 )  ) 
aa[ 77] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 09 )  ) 
aa[ 78] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 10 )  ) 
aa[ 79] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 11 )  ) 
aa[ 80] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 12 )  ) 
aa[ 81] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 13 )  ) 
aa[ 82] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 14 )  ) 
aa[ 83] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 15 )  ) 
aa[ 84] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL ,                                     ) 
aa[ 85] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 01 )  ) 
aa[ 86] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 02 )  ) 
aa[ 87] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 03 )  ) 
aa[ 88] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 04 )  ) 
aa[ 89] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 05 )  ) 
aa[ 90] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 06 )  ) 
aa[ 91] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 07 )  ) 
aa[ 92] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 08 )  ) 
aa[ 93] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 09 )  ) 
aa[ 94] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 10 )  ) 
aa[ 95] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 11 )  ) 
aa[ 96] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 12 )  ) 
aa[ 97] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 13 )  ) 
aa[ 98] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 14 )  ) 
aa[ 99] := nOr( EXPANDO_FORMAT_DEBUG , 	                         EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 15 )  )         
aa[100] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY                                                                    ) 
aa[101] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED                                         ) 
aa[102] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 01 )  ) 
aa[103] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 02 )  ) 
aa[104] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 03 )  ) 
aa[105] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 04 )  ) 
aa[106] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 05 )  ) 
aa[107] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 06 )  ) 
aa[108] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 07 )  ) 
aa[109] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 08 )  ) 
aa[110] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 09 )  ) 
aa[111] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 10 )  ) 
aa[112] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 11 )  ) 
aa[113] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 12 )  ) 
aa[114] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 13 )  ) 
aa[115] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 14 )  ) 
aa[116] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_FIXED   , EXPANDO_FORMAT_ND_PRECISSION( 15 )  ) 
aa[117] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL                                       ) 
aa[118] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 01 )  ) 
aa[119] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 02 )  ) 
aa[120] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 03 )  ) 
aa[121] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 04 )  ) 
aa[122] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 05 )  ) 
aa[123] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 06 )  ) 
aa[124] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 07 )  ) 
aa[125] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 08 )  ) 
aa[126] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 09 )  ) 
aa[127] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 10 )  ) 
aa[128] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 11 )  ) 
aa[129] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 12 )  ) 
aa[130] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 13 )  ) 
aa[131] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 14 )  ) 
aa[132] := nOr( EXPANDO_FORMAT_DEBUG , 	EXPANDO_FORMAT_PRETTY  , EXPANDO_FORMAT_ND_MINIMAL , EXPANDO_FORMAT_ND_PRECISSION( 15 )  )
lMakePath( cPathCombine(cAppPath(),"salida"))
aeval(aa , {|flags| QOut( lMemoWrite( flag2name(flags),   oo:json_escape_self(flags) ) , "   " , flag2name(flags) ) } )
? "done"
inkey(0)
   
return
//----------------------------------------------------------------------------------------------------------------------
static function flag2name(n)    
local fn := cPrintf("%08.8X",n)

if lAnd(n, EXPANDO_FORMAT_ND_FIXED) 
   fn += "-fixed"       
   if lAnd( n , 0x000F0000 )
      fn += cPrintf( "-%i" , nAnd( nRShift(n,16) , 0x0F) ) 
   end
elseif lAnd(n, EXPANDO_FORMAT_ND_MINIMAL) 
   fn += "-minimal"       
   if lAnd( n , 0x000F0000 )
      fn += cPrintf( "-%i" , nAnd( nRShift(n,16) , 0x0F) ) 
   end
end    
if lAnd(n, EXPANDO_FORMAT_DEBUG) 
   fn += "-debug"
end
if lAnd(n, EXPANDO_FORMAT_PRETTY) 
   fn += "-pretty"
end
fn += ".json"
return cPathCombine( cAppPath() , "salida" , fn)
//----------------------------------------------------------------------------------------------------------------------
static function cnt1(o)
DEFAULT o := _ot4xb_expando_():new()
o:v01 := 100
o:v02 := 10.001
o:v03 := 1024.987239872346
o:v04 := 10.1
o:v05 := 10.12
o:v06 := 10.123
o:v07 := 10.1234
o:v08 := 10.12345
o:v09 := date() +1
o:v10 := date() +10
o:v11 := date() +12
o:v12 := 1
o:v13 := replicate( "this is a long string " , 124 )
o:v14 := 25
o:v15 := 300
o:v16 := .F.
o:v17 := NIL
return o
//----------------------------------------------------------------------------------------------------------------------
