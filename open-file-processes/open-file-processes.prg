#include "ot4xb.ch"        
#include "toolhelp32_constants.ch"
//----------------------------------------------------------------------------------------------------------------------
#define PROCESS_DUP_HANDLE 0x0040
#define STATUS_INFO_LENGTH_MISMATCH 0xC0000004
#define SystemHandleInformation 16
#define ObjectBasicInformation 0
#define ObjectNameInformation 1
#define ObjectTypeInformation 2




//-------------------------------------------------------------------------------------------------------------------------
proc appsys();return  
proc dbesys;return
//-------------------------------------------------------------------------------------------------------------------------
proc main()
local aList := aGetProcessList() 
local oDlg
                                   
if Empty(aList)
   MsgBox( "Empty List" )
else

oDlg := XbpArrayView():New("List All Processes")
oDlg:aData  := aList    
oDlg:aHeaders := { "Name                       ","ID       ","Threads","ParentID","PClassBase"}
oDlg:bOnRowSelect := {|aRow| ListProcessFiles( __apeek(aRow,2) )   }

oDlg:Create()
SetAppFocus(oDlg:oList)
oDlg:Run(.T.)
end
return
//-------------------------------------------------------------------------------------------------------------------------
static function aGetProcessList()
local aList := {}
local hps := @kernel32:CreateToolhelp32Snapshot( TH32CS_SNAPPROCESS, 0 )
local pe  := PROCESSENTRY32():New()
local lLoop, aa

if hps == -1 ; return NIL ; end  // to-do: put some err handling here
pe:dwSize = pe:_sizeof_()

lLoop := ( @kernel32:Process32First(hps,pe) != 0 )
while lLoop    
   aa    := Array(5)
   aa[1] := pe:szExeFile
   aa[2] := pe:th32ProcessID
   aa[3] := pe:cntThreads
   aa[4] := pe:th32ParentProcessID
   aa[5] := pe:pcPriClassBase
   aadd( aList , aa )  
   lLoop := ( @kernel32:Process32Next(hps,pe) != 0 )
end
@kernel32:CloseHandle( hps)
return aList
//----------------------------------------------------------------------------------------------------------------------
BEGIN STRUCTURE PROCESSENTRY32
   MEMBER DWORD  dwSize
   MEMBER DWORD  cntUsage
   MEMBER DWORD  th32ProcessID
   MEMBER HANDLE th32DefaultHeapID
   MEMBER DWORD  th32ModuleID
   MEMBER DWORD  cntThreads
   MEMBER DWORD  th32ParentProcessID
   MEMBER LONG   pcPriClassBase
   MEMBER DWORD  dwFlags
   MEMBER SZSTR  szExeFile SIZE 260
END STRUCTURE
//----------------------------------------------------------------------------------------------------------------------
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
      return ( dm[n][1] + ":\" + stuff( cFile,1,len(dm[n][2]),"") )
   end
next
return cFile
//----------------------------------------------------------------------------------------------------------------------    
//----------------------------------------------------------------------------------------------------------------------   
static function ListProcessFiles( pid  )               
local device_map := get_disk_to_device_name_map() 
local file_list              := Array(0)
local hCurrentProccessHandle := @kernel32:GetCurrentProcess()
local hProc           
local handle_list_buffer         := 0
local cb_handle_list_buffer      := 0x100000
local object_type_info
local object_type_info_buffer    := 0
local cb_object_type_info_buffer := 0x01000
local object_name_info_buffer    := 0
local cb_object_name_info_buffer := 0x01000
local object_name_info
local buffer    := 0
local result := -1   
local sh,handle_count,handle,handle_pos, handle_copy
local hso,cb,row

if Empty(pid)
   return NIL
end
hProc := @kernel32:OpenProcess(PROCESS_DUP_HANDLE, .F.,nOr(pid) )   

if !lAnd( hProc )
   return NIL
end

handle_list_buffer := _xgrab( cb_handle_list_buffer )
while ((result := @ntdll:NtQuerySystemInformation(SystemHandleInformation,handle_list_buffer,cb_handle_list_buffer,0)) ,;
        nOr(result) == nOr(STATUS_INFO_LENGTH_MISMATCH ) )
   _xfree( handle_list_buffer ) ; handle_list_buffer := 0   
   cb_handle_list_buffer += cb_handle_list_buffer
   handle_list_buffer := _xgrab( cb_handle_list_buffer )
end
if result < 0
   @kernel32:CloseHandle( hProc )
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
    
    row := Array( 5 )         
    row[1] := pid

    if( lAnd(handle_copy) .and. !(handle_copy == -1) )
       @kernel32:CloseHandle( handle_copy )
       handle_copy := 0
    end
    hso:_link_( handle_list_buffer + sh , .F.) ; sh += hso:_sizeof_()
    row[2] := hso:ObjectTypeNumber
    if hso:ProcessId != pid
       loop
    end                 
    // if hso:GrantedAccess == 0x0012019F 
    //    loop
    // end
    
    if hso:GrantedAccess == 0x001A019F 
       loop
    end                                
    
    
    
    // if( ( hso:GrantedAccess < 0x0012019F ) .or. ;
    //     (hso:GrantedAccess == 0x001A019F ) .or. ;
    //     (hso:GrantedAccess == 0x00120189 ) .or. ;
    //     (hso:GrantedAccess == 0x00100000 ) .or. ;
    //     (hso:GrantedAccess == 0x700a9e13 )      )
    //    loop
    // end    
    
    handle_copy := 0
    result := @ntdll:NtDuplicateObject(hProc,hso:Handle,hCurrentProccessHandle,@handle_copy,0,0,0)
    if result < 0 // have no privileges to duplicate this handle
       loop
    end  
    object_type_info:_zeromemory_()
    result := @ntdll:NtQueryObject( handle_copy,ObjectTypeInformation,object_type_info,cb_object_type_info_buffer,0)
    if result < 0 // failed
       loop
    end  
    
    
    row[3] := TrimZ(_w2mb( __vstr(PeekStr(object_type_info:TypeName:Buffer,0,object_type_info:TypeName:Length),"") + ChrR(0,16) , 0 , 0, .T. ))
    
    if row[3] != "File"
       loop
    end
  
    cb := 0   
    object_name_info:_zeromemory_()
    result := @ntdll:NtQueryObject(handle_copy,ObjectNameInformation,object_name_info,cb_object_name_info_buffer,@cb)

    if result == 0
       row[4] := TrimZ(_w2mb( __vstr(PeekStr(object_name_info:Buffer,0,object_name_info:Length),"") + ChrR(0,16) , 0 , 0, .T. ))
       row[5] := apply_device_name_map( row[4] , device_map)
    end
    aadd( file_list , row )
next    

if( lAnd(handle_copy) .and. !(handle_copy == -1) )
   @kernel32:CloseHandle( handle_copy )
   handle_copy := 0
end                                               

@kernel32:CloseHandle( hProc ) ; hProc := 0

_xfree( object_type_info_buffer ) ; object_type_info_buffer := 0
_xfree( object_name_info_buffer ) ; object_name_info_buffer := 0
_xfree(handle_list_buffer)        ; handle_list_buffer := 0

return file_list

