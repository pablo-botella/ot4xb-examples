# memory_status  
 
------ 
 
download: [memory_status.zip](memory_status.zip) 
 
 
------ 
          
#memory_status                  
  
----  
  
 
------ 
 
 
[memory_status.prg](#memory_status.prg)   
 
[memory_status.XPJ](#memory_status.XPJ)   
 
------ 
 
## memory_status.prg  
       
``` 
#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
#xcommand MEMBER DWORDLONG <cm> => MEMBER DWORD64   <cm> 
//----------------------------------------------------------------------------------------------------------------------
#xcommand PROPERTY DOUBLE <nd> IS UINT64 MEMBER <uq>   =>;
          INLINE ACCESS ASSIGN METHOD <nd>(v) ;
          ; if( PCount() > 0 ) ;
          ; ::<uq> := Double2ULongLong( v )  ;
          ;   return v ;
          ; end ;
          ;return ULongLong2Double( ::<uq>)
//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//----------------------------------------------------------------------------------------------------------------------
proc main            

? MEMORYSTATUSEX():new():global():cPrint()

inkey(0)
return
//----------------------------------------------------------------------------------------------------------------------
CLASS MEMORYSTATUSEX FROM MEMORYSTATUSEX_st
EXPORTED:
      // ---------------------------------------------------------------------------------
INLINE CLASS METHOD InitClass ; return Self
      // ---------------------------------------------------------------------------------
PROPERTY DOUBLE nTotalPhys            IS UINT64 MEMBER ullTotalPhys           
PROPERTY DOUBLE nAvailPhys            IS UINT64 MEMBER ullAvailPhys           
PROPERTY DOUBLE nTotalPageFile        IS UINT64 MEMBER ullTotalPageFile       
PROPERTY DOUBLE nAvailPageFile        IS UINT64 MEMBER ullAvailPageFile       
PROPERTY DOUBLE nTotalVirtual         IS UINT64 MEMBER ullTotalVirtual        
PROPERTY DOUBLE nAvailVirtual         IS UINT64 MEMBER ullAvailVirtual        
PROPERTY DOUBLE nAvailExtendedVirtual IS UINT64 MEMBER ullAvailExtendedVirtual

      // ---------------------------------------------------------------------------------
INLINE METHOD global()
       ::dwLength := ::_sizeof_()
       if !@kernel32:["__bo__pt"]:GlobalMemoryStatusEx(Self)
         ::_zeromemory_()
       end
       return Self
       
      // ---------------------------------------------------------------------------------
INLINE METHOD cPrint()
       local cc := ""
       cc += cPrintf(, "There is  %i percent of memory in use.\n"       ,  ::dwMemoryLoad         )
       cc += cPrintf(, "There are %.2f total KB of physical memory.\n"   ,, ::nTotalPhys            / 1024 )
       cc += cPrintf(, "There are %.2f free  KB of physical memory.\n"   ,, ::nAvailPhys            / 1024 )
       cc += cPrintf(, "There are %.2f total KB of paging file.\n"       ,, ::nTotalPageFile        / 1024 )
       cc += cPrintf(, "There are %.2f free  KB of paging file.\n"       ,, ::nAvailPageFile        / 1024 )
       cc += cPrintf(, "There are %.2f total KB of virtual memory.\n"    ,, ::nTotalVirtual         / 1024 )
       cc += cPrintf(, "There are %.2f free  KB of virtual memory.\n"    ,, ::nAvailVirtual         / 1024 )
       cc += cPrintf(, "There are %.2f free  KB of extended memory.\n"   ,, ::nAvailExtendedVirtual  / 1024 )
       return cc
      // ---------------------------------------------------------------------------------

ENDCLASS
//----------------------------------------------------------------------------------------------------------------------
BEGIN STRUCTURE MEMORYSTATUSEX_st
  MEMBER DWORD         dwLength
  MEMBER DWORD         dwMemoryLoad
  MEMBER DWORDLONG ullTotalPhys           
  MEMBER DWORDLONG ullAvailPhys           
  MEMBER DWORDLONG ullTotalPageFile       
  MEMBER DWORDLONG ullAvailPageFile       
  MEMBER DWORDLONG ullTotalVirtual        
  MEMBER DWORDLONG ullAvailVirtual        
  MEMBER DWORDLONG ullAvailExtendedVirtual
END STRUCTURE
       
``` 
       
------ 
 
------ 
 
## memory_status.XPJ  
       
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
memory_status.exe

[memory_status.exe]
memory_status.prg
ot4xb.lib




       
``` 
       
------ 
