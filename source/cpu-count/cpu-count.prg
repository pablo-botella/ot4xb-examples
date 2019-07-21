#include "ot4xb.ch"
#include "winbase_constants.ch"
//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//----------------------------------------------------------------------------------------------------------------------
proc main                                                 
local n,nn,dwp,dws,result,hProcess
nn := wapist_SYSTEM_INFO():new():dwNumberOfProcessors
dwp := 0 
dws := 0                                       

? cPrintf(,"wapist_SYSTEM_INFO():new():dwActiveProcessorMask  := 0x%08.8X", wapist_SYSTEM_INFO():new():dwActiveProcessorMask )

hProcess := @kernel32:OpenProcess(0x1F0FFF,0, @kernel32:GetCurrentProcessId() )



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
   ? "press <esc> to close ..."
while inkey(0) != 27
end


@kernel32:CloseHandle( hProcess)
hProcess := -1                        

return 

//----------------------------------------------------------------------------------------------------------------------
