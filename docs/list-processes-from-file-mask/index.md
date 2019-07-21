# list-processes-from-file-mask  
 
------ 
 
download: [list-processes-from-file-mask.zip](list-processes-from-file-mask.zip) 
 
 
------ 
          
#list-processes-from-file-mask  
  
----  
  
 
------ 
 
 
[list-processes-from-file-mask.prg](#list-processes-from-file-mask.prg)   
 
[list-processes-from-file-mask.xpj](#list-processes-from-file-mask.xpj)   
 
------ 
 
## list-processes-from-file-mask.prg  
       
``` 
#include "ot4xb.ch"
#include "winbase_constants.ch"
//----------------------------------------------------------------------------------------------------------------------
#define PROCESS_DUP_HANDLE 0x0040
#define PROCESS_QUERY_LIMITED_INFORMATION  0x1000
#define STATUS_INFO_LENGTH_MISMATCH 0xC0000004
#define SystemHandleInformation 16
#define ObjectBasicInformation 0
#define ObjectNameInformation 1
#define ObjectTypeInformation 2




//-------------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//-------------------------------------------------------------------------------------------------------------------------
proc main()
local list := list_proc_ID_with_open_file_block(   {|fnm,pid,fn| must_include_this_file(fnm,pid,fn) } ,;
                                                   {|fn| must_include_this_process( fn)},;
                                                   {|dw|  aScan( {0x0012019F,0x001A019F,0x00120189} , dw ) == 0 }  )
local cc
? "done"
cc := ""
if empty( list )
   ? "empty"
else
   aEval( list , {|e| cc += cPrintf("0x%08.8X",e[1]) + Chr(9) + e[2] + Chr(9) + e[3] + Chr(9) + e[4] + CRLF , QOut( e[1] , " => " , e[2] ) } )
end
lMemoWrite("lista.txt" , cc )
inkey(0)

return           
//-------------------------------------------------------------------------------------------------------------------------
static function must_include_this_file(  file_name_mapped  , pid , file_name ) 
static data_folder := NIL
static data_folder_unmapped := NIL
if data_folder == NIL
   data_folder := cPathAddBackslash( GetEnv("data_folder")  )
   if empty(data_folder)
      data_folder := "*\"
      data_folder_unmapped := "*\"
   else                                
     data_folder_unmapped := apply_device_name_unmap( data_folder , get_disk_to_device_name_map() )
   end
end
if lStrWildCmp( data_folder_unmapped + "*.dbf" , file_name , .T. )
   return .T.
end
if lStrWildCmp( data_folder_unmapped + "*.fpt" , file_name , .T. )
   return .T.
end
if lStrWildCmp( data_folder_unmapped + "*.cdx" , file_name , .T. )
   return .T.
end
return .F.
//-------------------------------------------------------------------------------------------------------------------------
static function must_include_this_process( process_filename )
if lStrWildCmp( "*\arc32.exe" , process_filename , .T. )
   return .T.
end
if lStrWildCmp( "*\alaska\*" , process_filename , .T. )
   return .T.
end      
if lStrWildCmp( "*\myprogram\*" , process_filename , .T. )
   return .T.
end      
return .F.
//-------------------------------------------------------------------------------------------------------------------------
BEGIN STRUCTURE SYSTEM_HANDLE
    MEMBER ULONG ProcessId
    MEMBER BYTE ObjectTypeNumber
    MEMBER BYTE Flags
    MEMBER WORD Handle
    MEMBER POINTER32 Object
    MEMBER DWORD GrantedAccess
END STRUCTURE
//----------------------------------------------------------------------------------------------------------------------
BEGIN STRUCTURE  UNICODE_STRING
  MEMBER WORD Length
  MEMBER WORD MaximumLength
  MEMBER POINTER32 Buffer
END STRUCTURE
//----------------------------------------------------------------------------------------------------------------------
BEGIN STRUCTURE GENERIC_MAPPING
  MEMBER DWORD GenericRead
  MEMBER DWORD GenericWrite
  MEMBER DWORD GenericExecute
  MEMBER DWORD GenericAll
END STRUCTURE
//----------------------------------------------------------------------------------------------------------------------
BEGIN STRUCTURE OBJECT_TYPE_INFORMATION
  MEMBER @ UNICODE_STRING          TypeName
  MEMBER   ULONG                   TotalNumberOfHandles
  MEMBER   ULONG                   TotalNumberOfObjects
  MEMBER   BINSTR           Unused1 SIZE  8*2
  MEMBER   ULONG                   HighWaterNumberOfHandles
  MEMBER   ULONG                   HighWaterNumberOfObjects
  MEMBER   BINSTR           Unused2 SIZE  8*2
  MEMBER   DWORD            InvalidAttributes
  MEMBER @ GENERIC_MAPPING         GenericMapping
  MEMBER   DWORD            ValidAttributes
  MEMBER   BYTE             SecurityRequired
  MEMBER   BYTE             MaintainHandleCount
  MEMBER   WORD                  MaintainTypeList
  MEMBER   DWORD            PoolType
  MEMBER   ULONG                   DefaultPagedPoolCharge
  MEMBER   ULONG                   DefaultNonPagedPoolCharge
END STRUCTURE
//----------------------------------------------------------------------------------------------------------------------
static function get_disk_to_device_name_map(aa)
local buffer  := ChrR(0,1024)
local cb      := @kernel32:QueryDosDeviceA(0,@buffer,len(buffer) )
local n,nn,cc
local lista := Array(0)
cc := cDrives()
nn := len(cc)
aa := Array(nn,2)
for n := 1 to nn
   aa[n][1] := cc[n]
   cb  := @kernel32:QueryDosDeviceA( aa[n][1] + ":" ,@buffer,len(buffer) )
   aa[n][2] :=  Tokenize( TrimZ(left(buffer,cb)) , ";" )
   aeval( aa[n][2] , {|dd| aadd( lista , __anew( cc[n] , dd) ) } )
next
return lista
//----------------------------------------------------------------------------------------------------------------------
function apply_device_name_map( cFile , dm )
local n,nn

nn := len(dm)
for n := 1 to nn
   if lStrWildCmp( dm[n][2] + "\*" , cFile , .T. )
      return ( dm[n][1] + ":" + stuff( cFile,1,len(dm[n][2]),"") )
   end
next
return cFile
//----------------------------------------------------------------------------------------------------------------------
function apply_device_name_unmap( cFile , dm )
local n,nn

nn := len(dm)
for n := 1 to nn
   if lStrWildCmp( dm[n][1] + ":\*" , cFile , .T. )
      return ( dm[n][2] + stuff( cFile,1,2,"") )
   end
next
return cFile
//----------------------------------------------------------------------------------------------------------------------
function list_proc_ID_with_open_file_block(bFilterFileNames , bFilterProccessNames , bFilterGrantedAccess)
local hTargetProcess         := 0
local nFileObjectTypeNumber  := NIL
local device_map             := get_disk_to_device_name_map()
local object_type_info
local object_name_info
local hCurrentProccessHandle      := @kernel32:GetCurrentProcess()
local handle_list_buffer
local cb_handle_list_buffer       := 0x100000
local object_type_info_buffer     := 0
local cb_object_type_info_buffer  := 0x01000
local object_name_info_buffer     := 0
local cb_object_name_info_buffer  := 0x01000
local buffer    := 0
local result := -1
local sh,handle_count,handle_pos, handle_copy
local hso,cb,row
local process_container := _ot4xb_expando_():new()
local process_item,file_name,file_name_mapped,cpi
local file_list := Array(0)

if valtype( bFilterFileNames ) != "B"
   return NIL
end

if valtype( bFilterGrantedAccess ) != "B"
   bFilterGrantedAccess := {|dw|  aScan( {0x0012019F,0x001A019F,0x00120189} , dw ) == 0 }
end   
      
      
      

handle_list_buffer := _xgrab( cb_handle_list_buffer )
while ((result := @ntdll:NtQuerySystemInformation(SystemHandleInformation,handle_list_buffer,cb_handle_list_buffer,0)) ,;
        nOr(result) == nOr(STATUS_INFO_LENGTH_MISMATCH ) )
   _xfree( handle_list_buffer ) ; handle_list_buffer := 0
   cb_handle_list_buffer += cb_handle_list_buffer
   handle_list_buffer := _xgrab( cb_handle_list_buffer )
end
if result < 0
   if lAnd(handle_list_buffer)
      _xfree(handle_list_buffer) ; handle_list_buffer := 0
      return NIL
   end
end
sh := 0
handle_count := PeekDWord(handle_list_buffer,@sh)
hso := SYSTEM_HANDLE():new()
object_type_info_buffer := _xgrab(cb_object_type_info_buffer)
object_type_info := OBJECT_TYPE_INFORMATION():new():_link_(object_type_info_buffer,.F.)

object_name_info_buffer := _xgrab(cb_object_name_info_buffer)
object_name_info := UNICODE_STRING():new():_link_(object_name_info_buffer,.F.)

handle_copy := 0

for handle_pos := 1 to handle_count

    // QQOut(".")
    if( lAnd(hTargetProcess) .and. !(hTargetProcess == -1) )
       @kernel32:CloseHandle( hTargetProcess )
       hTargetProcess := 0
    end
    hTargetProcess := 0

    if( lAnd(handle_copy) .and. !(handle_copy == -1) )
       @kernel32:CloseHandle( handle_copy )
       handle_copy := 0
    end

    hso:_link_( handle_list_buffer + sh , .F.) ; sh += hso:_sizeof_()     
    
    if nFileObjectTypeNumber != NIL
       if !(hso:ObjectTypeNumber == nFileObjectTypeNumber)
          loop
       end
    end
    
       
    if !eval( bFilterGrantedAccess, hso:GrantedAccess)
       loop
    end

    cpi := cPrintf("_p_%08.8X" , hso:ProcessId )
    process_item := process_container:get_prop( cpi )
    if process_item == NIL
       hTargetProcess := @kernel32:OpenProcess( nOr(PROCESS_DUP_HANDLE , PROCESS_QUERY_LIMITED_INFORMATION ), .F., hso:ProcessId  )
       process_item := _ot4xb_expando_():new()
       process_container:set_prop( cpi , process_item )
       process_item:ProcessId := hso:ProcessId
       cb := @psapi:GetProcessImageFileNameA(hTargetProcess,object_name_info_buffer,cb_object_name_info_buffer)
       process_item:process_filename = PeekStr(object_name_info_buffer,0,cb)
       process_item:include_process  := eval( bFilterProccessNames , process_item:process_filename  , hso:ProcessId )
    end
    if !process_item:include_process
       loop
    end
    
    
    handle_copy := 0
    
    if( !(lAnd(hTargetProcess) .and. !(hTargetProcess == -1)) )
       hTargetProcess := @kernel32:OpenProcess( nOr(PROCESS_DUP_HANDLE , PROCESS_QUERY_LIMITED_INFORMATION ), .F., hso:ProcessId  )
    end
    
    if( !(lAnd(hTargetProcess) .and. !(hTargetProcess == -1)) )
       loop
    end

    result := @ntdll:NtDuplicateObject(hTargetProcess,hso:Handle,hCurrentProccessHandle,@handle_copy,0,0,0)
    if result < 0 // have no privileges to duplicate this handle   
       handle_copy := 0
       loop
    end

    if nFileObjectTypeNumber == NIL
       object_type_info:_zeromemory_()
       result := @ntdll:NtQueryObject( handle_copy,ObjectTypeInformation,object_type_info,cb_object_type_info_buffer,0)
       if result < 0 // failed
          loop
       end
       if !( TrimZ(_w2mb( __vstr(PeekStr(object_type_info:TypeName:Buffer,0,object_type_info:TypeName:Length),"") + ChrR(0,16) , 0 , 0, .T. )) == "File" )
          loop
       end
       nFileObjectTypeNumber := hso:ObjectTypeNumber // so next time we no need to do this query
    end

    cb := 0
    object_name_info:_zeromemory_()
    result := @ntdll:NtQueryObject(handle_copy,ObjectNameInformation,object_name_info,cb_object_name_info_buffer,@cb)
    if result == 0
       file_name          := TrimZ(_w2mb( __vstr(PeekStr(object_name_info:Buffer,0,object_name_info:Length),"") + ChrR(0,16) , 0 , 0, .T. ))
       file_name_mapped   := apply_device_name_map(file_name, device_map)
       if eval( bFilterFileNames ,  file_name_mapped  , hso:ProcessId , file_name )
          cpi := cPrintf("_p_%08.8X" , hso:ProcessId )
          aadd( file_list , __anew( hso:ProcessId , process_item:process_filename , file_name_mapped , file_name ) )
       end
    end
next

if( lAnd(handle_copy) .and. !(handle_copy == -1) )
   @kernel32:CloseHandle( handle_copy )
   handle_copy := 0
end
if( lAnd(hTargetProcess) .and. !(hTargetProcess == -1) )
   @kernel32:CloseHandle( hTargetProcess )
   hTargetProcess := 0
end

_xfree( object_type_info_buffer ) ; object_type_info_buffer := 0
_xfree( object_name_info_buffer ) ; object_name_info_buffer := 0
_xfree(handle_list_buffer)        ; handle_list_buffer := 0

return file_list       
``` 
       
------ 
 
------ 
 
## list-processes-from-file-mask.xpj  
       
``` 
[PROJECT]
    COMPILE       = xpp
    OBJ_DIR       = 
    COMPILE_FLAGS = /n /m /w /wi /wl
    DEBUG         = yes
    GUI           = yes
    LINKER        = alink
    LINK_FLAGS    = 
    RC_COMPILE    = arc
    RC_FLAGS      = -v
    PROJECT.XPJ

[PROJECT.XPJ]
    list-processes-from-file-mask.exe
[list-processes-from-file-mask.exe]
list-processes-from-file-mask.prg 
ot4xb.lib 

       
``` 
       
------ 
