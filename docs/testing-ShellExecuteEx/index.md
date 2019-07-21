# testing-ShellExecuteEx  
 
------ 
 
download: [testing-ShellExecuteEx.zip](testing-ShellExecuteEx.zip) 
 
 
------ 
          


#Probando
- first
- second
- third
```
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla
Esto es codigo fuente blablablablablabla

```

 
------ 
 
 
[testing-ShellExecuteEx.prg](#testing-ShellExecuteEx.prg)   
 
[TShellExecuteinfo.prg](#TShellExecuteinfo.prg)   
 
[testing-ShellExecuteEx.XPJ](#testing-ShellExecuteEx.XPJ)   
 
------ 
 
## testing-ShellExecuteEx.prg  
       
``` 
#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
proc main       
local ose := TShellExecuteInfo():new()  
local nKey
ose:lMaskNoCloseProcess := .T.
ose:cVerb := "edit"     
ose:nShow := ose:swShowNormal                       
ose:cFile := cPathCombine( cAppPath() , "readme.txt")
lMemoWrite( ose:cFile , "" , .T.) 
ose:cDirectory := cAppPath()     
? "launch the application: "
if ose:start()
   ?? "ok"              
   ? "wait for termination. Space Bar = abandone. esc = kill"    
   while !ose:wait( 1000 )
      nKey := inkey(.3)
      if nKey == 27
         ose:kill()
         ? " we killed the app"
         exit
      elseif nKey == 32
         ? " we abandoned the app"
         exit
      end
   end
   if !( nKey == 27 .or. nKey == 32)
      ? " looks like ithave finished"
   end
else
  ?? " fail launching the app"
end
ose:release()
? "press any key to close this box"
inkey(0)
return       
``` 
       
------ 
 
------ 
 
## TShellExecuteinfo.prg  
       
``` 
#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
BEGIN STRUCTURE SHELLEXECUTEINFO_st
  MEMBER DWORD      cbSize
  MEMBER ULONG      fMask
  MEMBER HWND       hwnd
  MEMBER LPSTR      lpVerb       DYNSZ cVerb
  MEMBER LPSTR      lpFile       DYNSZ cFile
  MEMBER LPSTR      lpParameters DYNSZ cParameters
  MEMBER LPSTR      lpDirectory  DYNSZ cDirectory
  MEMBER int        nShow
  MEMBER DWORD      hInstApp
  MEMBER POINTER32  lpIDList
  MEMBER LPSTR      lpClass        DYNSZ cClass
  MEMBER HANDLE     hkeyClass
  MEMBER DWORD      dwHotKey
  BEGIN UNION
    MEMBER HANDLE hIcon
    MEMBER HANDLE hMonitor
  END UNION
  MEMBER HANDLE           hProcess
END STRUCTURE
//----------------------------------------------------------------------------------------------------------------------
CLASS TShellExecuteInfo FROM SHELLEXECUTEINFO_st
EXPORTED:
       // ---------------------------------------------------------------------------------
       VAR lKeepDynamicStrings
       // ---------------------------------------------------------------------------------

PROPERTY  lMaskDefault              IS MASK 0x00000000  OF fMask
PROPERTY  lMaskClassname            IS MASK 0x00000001  OF fMask
PROPERTY  lMaskClasskey             IS MASK 0x00000003  OF fMask
PROPERTY  lMaskIdlist               IS MASK 0x00000004  OF fMask
PROPERTY  lMaskInvokeidlist         IS MASK 0x0000000C  OF fMask
PROPERTY  lMaskIcon                 IS MASK 0x00000010  OF fMask
PROPERTY  lMaskHotkey               IS MASK 0x00000020  OF fMask
PROPERTY  lMaskNoCloseProcess       IS MASK 0x00000040  OF fMask
PROPERTY  lMaskConnectNetDrv        IS MASK 0x00000080  OF fMask
PROPERTY  lMaskNoAsync              IS MASK 0x00000100  OF fMask
PROPERTY  lMaskFlagDdeWait          IS MASK 0x00000100  OF fMask
PROPERTY  lMaskDoEnvSubst           IS MASK 0x00000200  OF fMask
PROPERTY  lMaskFlagNoUi             IS MASK 0x00000400  OF fMask
PROPERTY  lMaskUnicode              IS MASK 0x00004000  OF fMask
PROPERTY  lMaskNoConsole            IS MASK 0x00008000  OF fMask
PROPERTY  lMaskAsyncOk              IS MASK 0x00100000  OF fMask
PROPERTY  lMaskNoqueryClassStore    IS MASK 0x01000000  OF fMask
PROPERTY  lMaskHMonitor             IS MASK 0x00200000  OF fMask
PROPERTY  lMaskNoZoneChecks         IS MASK 0x00800000  OF fMask
PROPERTY  lMaskWaitForInputIdle     IS MASK 0x02000000  OF fMask
PROPERTY  lMaskFlagLogUsage         IS MASK 0x04000000  OF fMask
PROPERTY  lMaskFlagHinstIsSite      IS MASK 0x08000000  OF fMask
       // ---------------------------------------------------------------------------------
PROPERTY swHide             IS CONSTANT 0
PROPERTY swShowNormal       IS CONSTANT 1
PROPERTY swNormal           IS CONSTANT 1
PROPERTY swShowMinimized    IS CONSTANT 2
PROPERTY swShowMaximized    IS CONSTANT 3
PROPERTY swMaximize         IS CONSTANT 3
PROPERTY swShowNoActivate   IS CONSTANT 4
PROPERTY swShow             IS CONSTANT 5
PROPERTY swMinimize         IS CONSTANT 6
PROPERTY swShowMinNoActive  IS CONSTANT 7
PROPERTY swShowNA           IS CONSTANT 8
PROPERTY swRestore          IS CONSTANT 9
PROPERTY swShowDefault      IS CONSTANT 10
PROPERTY swForceMinimize    IS CONSTANT 11
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD initclass; return Self // gwst inheritances requiring an initclass methods even if doing nothing
       // ---------------------------------------------------------------------------------
INLINE METHOD init()
       ::_gwst_()
       ::lKeepDynamicStrings := .F.
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD start()
       local result
       ::cbSize := ::_sizeof_()
       result := @shell32:["__bo__pt"]:ShellExecuteExA( Self ) 
       return result
       // ---------------------------------------------------------------------------------
INLINE METHOD Wait( nMilliseconds) // lComplete | NIL on error // only if flag lMaskNoCloseProcess was set before start
       local oStartTime
       local dw := 0
       local nn := 0
       oStartTime := FileTime64():New():Now()
       DEFAULT nMilliseconds := 0
       if Empty( ::hProcess ) ; return NIL ; end   
       while .T.
          dw := @kernel32:WaitForSingleObjectEx( ::hProcess , nMilliseconds - nn , .T.)
          if dw == 0 ; return .T. ; end  // object is signaled
          if dw == 0x102 ; return .F. ; end // WAIT_TIMEOUT
          if dw == 0x80  ; return NIL ; end // WAIT_ABANDONED // must never happen
          if dw == 0xC0  // WAIT_IO_COMPLETION
             if nMilliSeconds > 0
                nn := oStartTime:ElapMilliSeconds()
                if nn >= nMilliseconds ; return .F. ; end  // timeout
             end
          else
             return NIL  // WAIT_FAILED
          end
       end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD Kill(nExitCode)
       DEFAULT nExitCode := -1
       if Empty( ::hProcess ) ; return NIL ; end
       if !Empty(::wait(0)) ; return .T. ; end
       return !Empty(@kernel32:TerminateProcess(::hProcess , nExitCode ))
       // ---------------------------------------------------------------------------------
INLINE METHOD Release()
       if ::lMaskNoCloseProcess .and. !lAnd( ::hProcess) ; @kernel32:CloseHandle( ::hProcess) ; end
       ::hProcess := 0
       ::cVerb := ::cFile := ::cParameters := ::cDirectory := ::cClass := NIL
       return Self    

ENDCLASS
//----------------------------------------------------------------------------------------------------------------------
 


       
``` 
       
------ 
 
------ 
 
## testing-ShellExecuteEx.XPJ  
       
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
testing-ShellExecuteEx.exe

[testing-ShellExecuteEx.exe]
testing-ShellExecuteEx.prg               
TShellExecuteInfo.prg
ot4xb.lib




       
``` 
       
------ 
