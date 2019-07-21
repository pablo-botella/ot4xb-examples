#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
#define TH32CS_SNAPHEAPLIST 0x00000001
#define TH32CS_SNAPPROCESS  0x00000002
#define TH32CS_SNAPTHREAD   0x00000004
#define TH32CS_SNAPMODULE   0x00000008
#define TH32CS_SNAPMODULE32 0x00000010
#define TH32CS_SNAPALL      nOr(TH32CS_SNAPHEAPLIST,TH32CS_SNAPPROCESS,TH32CS_SNAPTHREAD,TH32CS_SNAPMODULE)
#define TH32CS_INHERIT      0x80000000
//-------------------------------------------------------------------------------------------------------------------------
proc appsys();return  
proc dbesys;return
//-------------------------------------------------------------------------------------------------------------------------
proc main()
local aList := aGetProcessList()
if Empty(aList)
   MsgBox( "Empty List" )
else
   DlgABrw( aList,"List All Processes",;
            { "Name                       ","ID       ","Threads","ParentID","PClassBase"})
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

