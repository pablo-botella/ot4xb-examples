# open-file-processes  
 
------ 
 
download: [open-file-processes.zip](open-file-processes.zip) 
 
 
------ 
          
 
------ 
 
 
[DlgABrw.prg](#DlgABrw.prg)   
 
[open-file-processes.prg](#open-file-processes.prg)   
 
[XbpArrayView.prg](#XbpArrayView.prg)   
 
[open-file-processes.xpj](#open-file-processes.xpj)   
 
------ 
 
## DlgABrw.prg  
       
``` 
#pragma Library( "XppUI2.LIB" ) 
#pragma Library( "Adac20b.lib" ) 
#include "Appevent.ch" 
#include "ot4xb.ch" 
// ---------------------------------------------------------------------------
function DlgABrw(aData,cTitle,aHeaders,bOnSelect,bAction)
local oDlg,oDa,oBrw
DEFAULT aData  := {}
DEFAULT cTitle := "---" 
SET CHARSET TO ANSI
oDlg := XbpDialog():new(AppDesktop(),,{100,100}, {600,400},,.F.)
oDa  := oDlg:drawingArea
oDa:ClipChildren := .T.
oDlg:taskList := .T.
oDlg:title    := cTitle
oDlg:close    := {|p1,p2,oo| PostAppEvent(xbeP_Quit,,,oo)} 
oDlg:create()
oBrw := XbpQuickBrowse():New(oDa,,{0,0},oDa:currentSize())
oBrw:dataLink := DacPagedDataStore():New( aData )
if(!Empty(aHeaders))
   oBrw:dataArea:referenceArray := aHeaders
end
oBrw:Create()                                   
if !Empty( bOnSelect ) ; oBrw:ItemSelected := bOnSelect ; end
if( !Empty(aHeaders) ) ; oBrw:SetHeader( aHeaders) ; end
if( !Empty(bAction) ) ; oBrw:keyboard := {|k,uu,s| iif(k == 13,Eval(bAction,s), ) } ; end
oDa:resize := {|p1,p2,oo| oBrw:SetSize(p2) }
SetAppFocus( oBrw )
oBrw:Show()
oDlg:Show()
MsgLoop()
return NIL
//----------------------------------------------------------------------------
static function MsgLoop()
local nEvt,oo,p1,p2          
nEvt := oo := p1 := p2 := NIL
while ( nEvt != xbeP_Quit )
   nEvt := AppEvent(@p1,@p2,@oo )
   oo:HandleEvent(nEvt,p1,p2)
end
return NIL
//----------------------------------------------------------------------------
       
``` 
       
------ 
 
------ 
 
## open-file-processes.prg  
       
``` 
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

       
``` 
       
------ 
 
------ 
 
## XbpArrayView.prg  
       
``` 
#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
#xcommand \<\< <params,...>   => cc += cPrintf(,<params>)
#xcommand \<\<\< <c>   => cc += Var2Char(<c>)
//----------------------------------------------------------------------------------------------------------------------
#include "appevent.ch"
#include "xbp.ch"
#pragma Library( "XppUI2.LIB" )
#pragma Library( "Adac20b.lib" )
//----------------------------------------------------------------------------------------------------------------------
CLASS XbpArrayView FROM XbpDialog
EXPORTED:
       // ---------------------------------------------------------------------------------
       VAR oList
       VAR oView
       VAR hWndHtml
       VAR oXml
       VAR aData
       VAR aHeaders
       VAR bOnRowSelect
       // ---------------------------------------------------------------------------------
INLINE METHOD init(caption)
       local s := Self
       local aPos  := AFill(Array(2),100)
       local aSize := AFill(Array(2),100)
       ::AdjToMonitorWorkArea( @aPos , @aSize )
       ::XbpDialog:init(AppDesktop(),AppDesktop(),aPos,aSize,,.F.)
       ::TaskList := .T.
       DEFAULT caption := ""
       ::title := caption
       delegated_eval( {|| @atl:AtlAxWinInit() } )
       return Self
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD AdjToMonitorWorkArea( aPos , aSize )
       local buffer := ChrR(0,72)
       local rcw,rc
       local lOk
       PokeDWord(@buffer,0,72)
       lOk := ( @user32:GetMonitorInfoA(@user32:MonitorFromWindow(0,1),@buffer) != 0)
       if( lOk )
          rc  := PeekDWord(@buffer,4,4)
          rcw := PeekDword(@buffer,20,4)
          aSize[1] := rcw[3] - rcw[1]
          aSize[2] := rcw[4] - rcw[2]
          aPos[1] := rcw[1]
          aPos[2] :=  (rc[4] - rc[2]) - ( rcw[2] + aSize[2] )
       end
       return lOk
       // ---------------------------------------------------------------------------------
INLINE METHOD create()
       local rccli := AFill(Array(4),0)
       local cc
       ::DrawingArea:clipchildren := .T.
       ::XbpDialog:create()
       @user32:GetClientRect(::GetHWnd(),@rccli)
       ::oList := XbpTreeView():New(Self,Self,{0,rccli[4]/2},{rccli[3],(rccli[4]/2)-2},,.T.)
       ::oList:HasButtons := .T.
       ::oList:HasLines   := .T.
       ::oList := XbpQuickBrowse():New(Self,Self,{0,rccli[4]/2},{rccli[3],(rccli[4]/2)-2},,.T.)
       ::oList:dataLink := DacPagedDataStore():New( ::aData )
       if(!Empty(::aHeaders))
          ::oList:dataArea:referenceArray := ::aHeaders
       end
       ::oList:Create()
       ::oList:ItemSelected := {|aRowCol,uu,s| ::OnSelect( __aPeek( ::aData,s:getdata())  )}

       if( !Empty(::aHeaders) )
          ::oList:SetHeader( ::aHeaders)
       end


       ::DrawingArea:SetPosAndSize({0,0},{rccli[3],rccli[4]/2})
       cc := "about:blank"
       ::hWndHtml := delegated_eval({|| @user32:CreateWindowExA(0,"AtlAxWin",cc,0x50200000,;
                                        0,0,rccli[3],rccli[4]/2,::DrawingArea:GetHWnd(),-1,;
                                        AppInstance(),0) } )

       ::Show()
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD OnSelect( aRow )
       local result := aRow
       if valtype( ::bOnRowSelect ) == "B"
         result := Eval( ::bOnRowSelect , aRow )
       end
       ::SetHtml( cPrintf("<html><body>%s</body></html>", var2Char( result)) )
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD SetHtml( cHtml )
       local pu     := 0
       local pwb    := 0
       local psi    := 0
       local pbody  := 0
       local ps    := 0
       local r
       DEFAULT cHtml := "<html><body></body></html>"
       @atl:AtlAxGetControl(::hWndHtml,@pu)
       r := IFpQCall(0,"__sl__sl__pt_@sl",pu,UuidFromString("D30C1661-CDAF-11D0-8A3E-00C04FC9E26E"),@pwb)
       if r >= 0
          IWebBrowser2_SetHtml( pwb , cHtml )
          IFpQCall(2,"__sl__sl",pwb)
       end
       IFpQCall(2,"__sl__sl",pu)
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD resize()
       local rc := AFill(Array(4),0)
       @user32:GetClientRect(::GetHWnd(),@rc)
       ::oList:SetPosAndSize({0,rc[4]/2},{rc[3],(rc[4]/2)-2})
       ::DrawingArea:SetPosAndSize({0,0},{rc[3],rc[4]/2})
       @user32:GetClientRect(::DrawingArea:GetHWnd(),@rc)
       delegated_eval( {|| @user32:SetWindowPos(::hWndHtml,0,0,0,rc[3],rc[4],0x254)})
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD Run(lMain)
       local nEvt,oo,p1,p2,nMsgExit
       local s := Self
       nEvt := oo := p1 := p2 := NIL
       DEFAULT lMain := .F.
       nMsgExit := xbeP_Close
       if lMain
          s:close  := {|| PostAppEvent( xbeP_Quit,,,s) }
          nMsgExit := xbeP_Close
       end
       while ( nEvt != nMsgExit )
          nEvt := AppEvent(@p1,@p2,@oo )
          oo:HandleEvent(nEvt,p1,p2)
       end
       return NIL
       // ---------------------------------------------------------------------------------
ENDCLASS
//----------------------------------------------------------------------------------------------------------------------
static function IWebBrowser2_WaitReady( pwb , nWait)
local n := 0
local r := 0
local ns := Seconds()
DEFAULT nWait := 1
IFpQCall(56,"__sl__sl_@sl",pwb,@n)
while ( n != 4 )
   if ( Seconds() - ns ) > nWait ; return .F. ; end
   @kernel32:SleepEx(100,0)
   IFpQCall(56,"__sl__sl_@sl",pwb,@n)
end
return ( n == 4 )
//----------------------------------------------------------------------------------------------------------------------
static function IWebBrowser2_SetHtml( pwb , cHtml)
local v_url := ChrR(0,16)
local cFile := cPathCombine(cGetTmpPath(),cUuidCreateName() + ".html")
static cOldFile := NIL
if !empty( cOldFile ) ; FErase(cOldFile) ; end
cOldFile := NIL
@ot4xb:_variant_t_SetString(@v_url,"file://" + cFile)
lMemoWrite(cFile,cHtml)
IFpQCall(52,"__sl__sl__pt__pt__pt__pt__pt",pwb,v_url)
@ot4xb:_variant_t_Clear(@v_url)
cOldFile := cFile
return .T.
//----------------------------------------------------------------------------------------------------------------------
       
``` 
       
------ 
 
------ 
 
## open-file-processes.xpj  
       
``` 
[PROJECT]
    COMPILE       = xpp
    OBJ_DIR       = 
    COMPILE_FLAGS = /n /m /w /wi /wl
    DEBUG         = no
    GUI           = yes
    LINKER        = alink
    LINK_FLAGS    = 
    RC_COMPILE    = arc
    RC_FLAGS      = -v
    PROJECT.XPJ

[PROJECT.XPJ]
    open-file-processes.exe
[open-file-processes.exe]
open-file-processes.prg 
XbpArrayView.prg
ot4xb.lib 

       
``` 
       
------ 
