#include "ot4xb.ch"
#include "winbase_constants.ch"
//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//----------------------------------------------------------------------------------------------------------------------
proc main                                                 
local n,nn,dwp,dws,result,hProcess , cc
nn := wapist_SYSTEM_INFO():new():dwNumberOfProcessors
dwp := 0 
dws := 0                                       

? cPrintf(,"wapist_SYSTEM_INFO():new():dwActiveProcessorMask  := 0x%08.8X", wapist_SYSTEM_INFO():new():dwActiveProcessorMask )

hProcess := @kernel32:OpenProcess(0x1F0FFF,0, @kernel32:GetCurrentProcessId() )

while inkey(0) != 27


   @kernel32:GetProcessAffinityMask( hProcess , @dwp,@dws)
   ? cPrintf(,"nn := %i\r\ndwp: 0x%08.8X\r\ndws: 0x%08.8X\r\n",nn,dwp,dws )
   for n := 1 to 32
      if lDwBitOnOff(dws,n)      
         nn := 0 ; lDwBitOnOff(@nn,n,.T.)      
         ? cPrintf(,"bit: %i mask: 0x%08.8X",n,nn)
         result := @kernel32:SetProcessAffinityMask(hProcess,nn)
         @kernel32:GetProcessAffinityMask( hProcess ,@dwp,@dws)
         ?? cPrintf(,"  result: %i mask: 0x%08.8X",result,dwp)
      end
   next          
end


? cPrintf( "%.*f",7,NIL,123456)
? cPrintf( "%.*f",6,NIL,123456)
? cPrintf( "%.*f",5,NIL,123456)     
? cPrintf( "%.*f",4,NIL,123456)
? cPrintf( "%.*f",3,NIL,123456)
? cPrintf( "%.*f",2,NIL,123456)
? cPrintf( "%.*f",1,NIL,123456)
? cPrintf( "%.*f",0,NIL,123456)

@kernel32:CloseHandle( hProcess)
hProcess := -1                        
cc := '{'
for n := 0 to 255   
    if n % 8 == 0
       cc += CRLF
    end
    cc += cPrintf( "%3i," , Peekbyte( _mb2mb(Chr(n),1252,850) ) ) 

next
lMemoWrite( "salida.txt" , cc )











inkey(0)
                                         
return 

//----------------------------------------------------------------------------------------------------------------------
