#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//----------------------------------------------------------------------------------------------------------------------
proc main        
if ot4xb() >= "001.006.004.076"
    ? "ft64_getts(,,1)        : " , ft64_getts(,,1)         
    ? "ft64_getts(,,0x0C01)   : " , ft64_getts(,,0x0C01)    
    ? "ft64_getts(,,0x0E01)   : " , ft64_getts(,,0x0E01)    
    ? "ft64_getts(,,0x0F01)   : " , ft64_getts(,,0x0F01)    
    ? "ft64_getts(,,0x1701)   : " , ft64_getts(,,0x1701)    
    ? "ft64_getts(,,2)        : " , ft64_getts(,,2)         
    ? "ft64_getts(,,0x0C02)   : " , ft64_getts(,,0x0C02)    
    ? "ft64_getts(,,0x0E02)   : " , ft64_getts(,,0x0E02)    
    ? "ft64_getts(,,0x0F02)   : " , ft64_getts(,,0x0F02)    
    ? "ft64_getts(,,0x1702)   : " , ft64_getts(,,0x1702)    
else
	  ? "3rd param flags for current systemtime (2) or local time (1) "
	  ? "was implemented on ot4xb ver. 001.006.004.076"
	  ? "current is:" , ot4xb()
end
inkey(0)
return
//----------------------------------------------------------------------------------------------------------------------


