#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//----------------------------------------------------------------------------------------------------------------------
proc main  
local lst  := aSplitTxtLines( cMemoReadEx( "full-list.txt"))
local pt   := "C\-KB\-0011\-\s+.*"
local nn   := len( lst )
local n
local cc   := ""                          


for n := 1 to nn                     
   if lStrWildCmpEx( pt , lst[n] , 0x201 )
     ?  cc += lst[n] + CRLF
   end
next
? lMemoWrite( "salida.txt" , cc )

inkey(0)
return
//----------------------------------------------------------------------------------------------------------------------


