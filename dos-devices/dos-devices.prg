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

? ot4xb_hash():sha1("patata")
? len( ot4xb_hash():sha1("patata") )


inkey(0)


return
//-------------------------------------------------------------------------------------------------------------------------
