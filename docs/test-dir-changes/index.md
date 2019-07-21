# test-dir-changes  
 
------ 
 
download: [test-dir-changes.zip](test-dir-changes.zip) 
 
 
------ 
          
#test-dir-changes               
  
----  
  
 
------ 
 
 
[test-dir-changes.prg](#test-dir-changes.prg)   
 
[TNotifyDirectoryChanges.prg](#TNotifyDirectoryChanges.prg)   
 
[test-dir-changes.xpj](#test-dir-changes.xpj)   
 
------ 
 
## test-dir-changes.prg  
       
``` 
#define _OT4XB_MAP_WAPIST_FUNC_
#include "ot4xb.ch"
#include "winuser_constants.ch"
//----------------------------------------------------------------------------------------------------------------------
proc dbesys; return
//----------------------------------------------------------------------------------------------------------------------
proc main( cDir )
local odc := TNotifyDirectoryChanges():New()
odc:Start()
DEFAULT cDir := cAppPath()
? odc:Add( cDir ,,.T.)
while inkey(0) != 27 ; end
? "Stopping ... "
odc:Stop()
while ! odc:Wait(.5)   
   ?? "."
   if inkey(.5) == 27 ; exit ; end
end
 odc:Destroy()  
? "press a key to exit .... "
while inkey(0) != 27 ; end

return
//----------------------------------------------------------------------------------------------------------------------



                                                           
                                                                  
``` 
       
------ 
 
------ 
 
## TNotifyDirectoryChanges.prg  
       
``` 
#define _OT4XB_MAP_WAPIST_FUNC_
#include "ot4xb.ch"
#include "winbase_constants.ch"
#include "winuser_constants.ch"
#include "ot4xb_mini_rt_asm.ch"
#include "WinError_constants.ch"
//----------------------------------------------------------------------------------------------------------------------
#xtranslate _assert_m_(<b>,<n>,<cc>) => ;
             if !(<b>) ;
            ;  TlsStackPush(Error():New());
            ;  TlsStackTop():severity := 2;
            ;  TlsStackTop():description := <cc> ;
            ;  TlsStackTop():gencode     := 0    ;
            ;  TlsStackTop():subcode     := <n>  ;
            ;  TlsStackTop():subsystem   := ::ClassName() ;
            ;  TlsStackTop():operation   := ProcName()  ;
            ;  Eval(ErrorBlock(),TlsStackPop()) ;
            ;end
//----------------------------------------------------------------------------------------------------------------------
static _psz_callback_ := NIL
//----------------------------------------------------------------------------------------------------------------------
CLASS TNotifyDirectoryChanges FROM Thread
EXPORTED:
       // ---------------------------------------------------------------------------------
       VAR thread_handle
       VAR thread_loop
       VAR pdw_outstanding_requests
       VAR worker_list
       // ---------------------------------------------------------------------------------
INLINE METHOD init()
       ::Thread:init()
       ::thread_handle := @ot4xb:["__sl__xb"]:_ot4xb_ThreadObject2hThread(Self)
       ::pdw_outstanding_requests := @ot4xb:ot4xb_interlocked_alloc()
       ::worker_list := Array(0)
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD Destroy()
       if ::pdw_outstanding_requests != NIL
          @ot4xb:ot4xb_interlocked_free(::pdw_outstanding_requests)
          ::pdw_outstanding_requests := NIL
       end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD Start()
       ::Thread:SetInterval(NIL)
       return ::Thread:Start()
       // ---------------------------------------------------------------------------------
INLINE METHOD Execute()
       ::thread_loop := .T.
       while ::thread_loop ; @kernel32:SleepEx(-1,1) ; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD Stop()
       ot4xb_apc_post_cb_h( ::thread_handle , {|| ::thread_loop := .F. } )
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD Wait(nSeconds)
       DEFAULT nSeconds := .5
       if ::ThreadId == ThreadId() ; return .F. ; end
       if nSeconds < 0.5 ; nSeconds := 0.5 ; end
       return ThreadWaitAll({Self},  nSeconds * 100 )
       // ---------------------------------------------------------------------------------
INLINE METHOD PostCB(b)
       local np := PCount()
       local ap := Array(np+1)
       local n,result
       if Valtype(b) != "B"
          return .F.
       end
       if Empty( ::thread_handle )
          return .F.
       end
       ap[1] := ::thread_handle
       for n := 1 to np
          ap[n+1] := PValue(n)
       next
       result := .F.
       lCallFuncPa("ot4xb_apc_post_cb_h", ap , @result)
       return result
       // ---------------------------------------------------------------------------------
INLINE METHOD IncrementOutstandingRequests()
       if ::pdw_outstanding_requests != 0
          @kernel32:InterlockedIncrement(::pdw_outstanding_requests)
       end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD DecrementOutstandingRequests()
       if ::pdw_outstanding_requests != 0
          @kernel32:InterlockedDecrement(::pdw_outstanding_requests)
       end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE ACCESS METHOD nOutstandingRequests() ; return PeekDWord(::pdw_outstanding_requests)
       // ---------------------------------------------------------------------------------
INLINE METHOD Add( directory_name, watch_flags , b_watch_subtree , buffer_size )
       local item := TNotifyDirectoryChanges_item_():New(Self, directory_name, watch_flags , b_watch_subtree , buffer_size  )
       return !(item:directory_handle == NIL)
       // ---------------------------------------------------------------------------------
INLINE METHOD RequestTermination()
       local cb := {|e| e:request_termination() }
       ::PostCB({|| AEval( ::worker_list , cb ) } )
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD PostNotify(reason,name)
       local cReason := "Unknown Reason:"
       if reason == 1; cReason := "Added       :"
       elseif reason == 2; cReason := "Removed     :"
       elseif reason == 3; cReason := "Modified    :"
       elseif reason == 4; cReason := "Renamed Old :"
       elseif reason == 5; cReason := "Renamed New :"
       end
       ? cPrintf("%s[%s]",cReason , name )
       return NIL
       // ---------------------------------------------------------------------------------
ENDCLASS
//----------------------------------------------------------------------------------------------------------------------
static CLASS TNotifyDirectoryChanges_item_
EXPORTED:
       // ---------------------------------------------------------------------------------
       VAR server
       VAR buffer_size
       VAR directory_name
       VAR directory_handle
       VAR ovl
       VAR current_buffer
       VAR next_buffer
       VAR cbk
       VAR watch_flags
       VAR b_watch_subtree
       VAR last_error
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD initclass
       _psz_callback_ := _xgrab("_callback_")
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD init( server , directory_name, watch_flags , b_watch_subtree , buffer_size )
       _assert_m_( Valtype(server) == "O", -1 , "1st param must be a TNotifyDirectoryChanges object")
       ::server := server
       // 64 Kb probably will be a good choice
       DEFAULT buffer_size :=  64 * 1024
       _assert_m_( (buffer_size > 16383) .and. (buffer_size < 65537),-1,"Invalid buffer size. must be in the 16Kb - 48Kb range")
       _assert_m_( (nAnd(buffer_size,15) == 0),-1,"Invalid buffer size. must be multiple of 16")
       ::buffer_size := buffer_size
       _assert_m_( !Empty(directory_name),-1,"Invalid directory name")
       ::directory_name := directory_name
       ::directory_handle := @kernel32:CreateFileA( ::directory_name,;
                                                    FILE_LIST_DIRECTORY,;
		                                              nOr(FILE_SHARE_READ,FILE_SHARE_WRITE,FILE_SHARE_DELETE),;
		                                              0,OPEN_EXISTING,;
		                                              nOr(FILE_FLAG_BACKUP_SEMANTICS,FILE_FLAG_OVERLAPPED),0)
       ::last_error := 0

       if ::directory_handle == -1
          ::directory_handle := NIL
          ::last_error := nFpGetLastError()
       else
          ::ovl := _xgrab(32)
          ::current_buffer := _xgrab( ::buffer_size )
          ::next_buffer    := _xgrab( ::buffer_size )
          ::cbk            := ::_create_callback_()

          DEFAULT watch_flags := nOr(FILE_NOTIFY_CHANGE_LAST_WRITE,FILE_NOTIFY_CHANGE_CREATION,FILE_NOTIFY_CHANGE_FILE_NAME)
          ::watch_flags := watch_flags
          DEFAULT b_watch_subtree := .F.
          ::b_watch_subtree := b_watch_subtree
          ::last_error := 0
          ::server:PostCB( {|| ::start() } )
       end
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD Start()
       ::last_error := ::begin_read()
       if ::begin_read() != 0
          ::server:IncrementOutstandingRequests()
          aadd(::server:worker_list,Self)
       else
          ::destroy()
       end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD request_termination()
       if ::directory_handle != NIL
		   @kernel32:CancelIo(::directory_handle)
		 end
		 return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD Destroy()
       local nn
       if !Empty(::ovl)    ; _xfree( ::ovl ) ; ::ovl := NIL ; end
       if !Empty(::current_buffer)    ; _xfree( ::current_buffer ) ; ::current_buffer := NIL ; end
       if !Empty(::next_buffer)       ; _xfree( ::next_buffer )    ; ::next_buffer := NIL    ; end
       if !Empty(::cbk ) ; ::_destroy_callback_(::cbk) ; ::cbk := NIL ; end
       if( ::directory_handle != NIL ) ; @kernel32:CloseHandle( ::directory_handle ) ; ::directory_handle := NIL ; end
       nn := AScan( ::server:worker_list , Self )
       if nn > 0
          ::server:worker_list[nn] := NIL
       end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD swap_buffers()
       local p := ::current_buffer
       ::current_buffer := ::next_buffer
       ::next_buffer := p
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD _create_callback_()
       local p__cmcv :=  nGetProcAddress(gethot4xb(),"?_conMCallVoid@@YAXPAUMomHandleEntry@@PADJJJ@Z")
       local pSelf   :=  _var2con( Self )
       local __asm__ := ""
       local n,p
       __asm __stdcall_prolog_(0)
       __asm mov  eax , arg 3
       __asm push eax
       __asm mov  eax , arg 2
       __asm push eax
       __asm mov  eax , arg 1
       __asm push eax
       __asm push dword _psz_callback_
       __asm push dword pSelf
       __asm __call__cdecl( p__cmcv , 5 )
       __asm __stdcall_epilog_( 3 )
       // store and make the callback
       n := Len(__asm__)
       p := _xgrab( nOr(n,15) + 1 + 16)
       PokeStr(p,16,__asm__)
       PokeDWord(p,0,n)
       PokeDWord(p,8,pSelf)
       @kernel32:VirtualProtect(p+16,n,64,p+12)
       return p+16
       // ---------------------------------------------------------------------------------
INLINE METHOD _destroy_callback_(cbk)
       local p
       if Empty(cbk) ; return NIL ; end
       p := cbk-16
       _conRelease( PeekDWord(p,8) )
       @kernel32:VirtualProtect(p+16,PeekDWord(p),PeekDWord(p,12),p+12)
       _xfree(p)
       cbk := 0
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD _callback_(error_code,bytes_transfered,ovl)
       if( error_code == ERROR_OPERATION_ABORTED )
          ::Destroy()
          ::server:DecrementOutstandingRequests()
          return NIL
       end
       if bytes_transfered == 0 ; return NIL ; end
       _assert_m_(  bytes_transfered >= 14,-1, cPrintf("bytes_transfered (%i) < 14",bytes_transfered ) )
       ::swap_buffers()
       ::begin_read()
       ::process_buffer()
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD process_buffer()
       local p := ::current_buffer
       local ah

       while( p != 0 )
          ah := PeekDWord(p,,3)
          ::server:PostNotify(ah[2], cSzWide2Ansi(PeekStr(p,12,ah[3]) + ChrR(0,2)) )
          p := iif( ah[1] > 0, p+ah[1],0)
       end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD begin_read()
       local cbr := 0
       _bset(::ovl,0,32)
       return @kernel32:ReadDirectoryChangesW( ::directory_handle,::next_buffer,::buffer_size,;
                                               ::b_watch_subtree,::watch_flags,@cbr,::ovl,::cbk)
       // ---------------------------------------------------------------------------------
ENDCLASS


       
``` 
       
------ 
 
------ 
 
## test-dir-changes.xpj  
       
``` 

[PROJECT]
    COMPILE       = xpp
    COMPILE_FLAGS = /n /m /w /p
    DEBUG         = no
    GUI           = yes
    OBJ_DIR       =
    LINKER        = alink
    LINK_FLAGS    =
    RC_COMPILE    = arc
    RC_FLAGS      = /v
    PROJECT.XPJ


[PROJECT.XPJ]
    test-dir-changes.exe

[test-dir-changes.exe]
 test-dir-changes.prg
 TNotifyDirectoryChanges.prg
 ot4xb.lib

       
``` 
       
------ 
