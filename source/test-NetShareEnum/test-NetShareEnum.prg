#include "ot4xb.ch"              
#include "WinError_constants.ch"
//----------------------------------------------------------------------------------------------------------------------
#xcommand  \<\<   <params,...> => QqOut( __logout("salida.txt" , CRLF,<params>)  )
#xcommand  \<\<\< <params,...> => QqOut( __logout("salida.txt" , <params>)       )
//----------------------------------------------------------------------------------------------------------------------
 BEGIN STRUCTURE SHARE_INFO_502
  MEMBER @ UNICODEDYNSTR      shi502_netname
  MEMBER DWORD                shi502_type
  MEMBER @ UNICODEDYNSTR      shi502_remark
  MEMBER DWORD                shi502_permissions
  MEMBER DWORD                shi502_max_uses
  MEMBER DWORD                shi502_current_uses
  MEMBER @ UNICODEDYNSTR      shi502_path
  MEMBER @ UNICODEDYNSTR      shi502_passwd
  MEMBER DWORD                shi502_reserved
  MEMBER POINTER32            shi502_security_descriptor
END STRUCTURE

//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//----------------------------------------------------------------------------------------------------------------------
function __logout( fn )
local np := PCount()
local n
local cc := ""
if np > 1
   for n := 2 to np
      cc += var2char( PValue(n) )
   next
end
if !empty(fn)
   lMemoWrite(fn,cc,.T.)
end
return cc
//----------------------------------------------------------------------------------------------------------------------
proc main( cServer )
local buffer
local si := SHARE_INFO_502():new()
local result
local entries_read,total_entries,resume_handle,n       
local max_prefered_len := -1

lMemoWrite("salida.txt","")

if empty( cServer )
   ? "Usage: NetShareEnum <servername>"
   inkey(0)
   return
end
<<  PadR("SHARE",20)                                                                               
<<< " | " , PadR( "LOCAL PATH" , 30 )
<<< " | " , "USAGE   "
<<< " | " , "DESCRIPTOR"             
<< Replicate( "-" , 79 )

 // Call the NetShareEnum function; specify level 502.
   
result := NIL
entries_read  := 0
total_entries := 0
resume_handle := 0    
buffer := 0
while ( ( result == NIL ) .or. ( result == ERROR_MORE_DATA ) )       

   buffer := 0
   result := @Netapi32:["__slc_sw__sl_@ul__sl_@ul_@ul_@ul"]:NetShareEnum(cServer, 502,@buffer,max_prefered_len,@entries_read,@total_entries,@resume_handle)
   if (result == ERROR_SUCCESS) .or. (result == ERROR_MORE_DATA)
      si:_link_( buffer	, .F. )
      // Loop through the entries print retrieved data.
      for n := 1 to entries_read
         <<  PadR(si:shi502_netname:cStr,20) 
         <<< " | " , PadR( si:shi502_path:cStr , 30 )
         <<< " | " , cPrintf("%8.8i",si:shi502_current_uses) 
         <<< " | " , iif( @advapi32:["__bo__pt"]:IsValidSecurityDescriptor(si:shi502_security_descriptor) , "Yes" , "No " )
         GwstArrayNext( si ) // link to next element in the array
      next
      @Netapi32:NetApiBufferFree( buffer )  // Free the allocated buffer.
      buffer := 0
   else 
      ? "Error: " , result
      ? cFmtSysMsg( result )
   end
   // Continue to call NetShareEnum while there are more entries. 
end   
<<  ""
? "press a key to exit ... "
inkey(0)
@shell32: ShellExecuteA(0,"open",cPathCombine(cAppPath(),"salida.txt"),0,0,3)
return