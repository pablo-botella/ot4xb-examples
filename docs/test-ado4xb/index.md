# test-ado4xb  
 
------ 
 
download: [test-ado4xb.zip](test-ado4xb.zip) 
 
 
------ 
          
 
------ 
 
 
[ado4xb.prg](#ado4xb.prg)   
 
[test-ado4xb.prg](#test-ado4xb.prg)   
 
[test-ado4xb.XPJ](#test-ado4xb.XPJ)   
 
------ 
 
## ado4xb.prg  
       
``` 
#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
#xtranslate SAFE_RELEASE( <v> ) => (<v> := iif(Empty(<v>),0,(IFpQCall(2,"__sl__sl",<v>),0)))
//----------------------------------------------------------------------------------------------------------------------
#xtranslate L(<c>)  => cSzAnsi2Wide(<c>)
//----------------------------------------------------------------------------------------------------------------------
#xcommand   ASSERT <b> , <cc> => ;
             if Empty(<b>) ;
            ;  TlsStackPush(Error():New());
            ;  TlsStackTop():severity := 2;
            ;  TlsStackTop():description := <cc> ;
            ;  TlsStackTop():gencode     := 0    ;
            ;  TlsStackTop():subcode     := -1   ;
            ;  TlsStackTop():subsystem   := "ado4xb";
            ;  TlsStackTop():operation   := ProcName()  ;
            ;  Eval(ErrorBlock(),TlsStackPop()) ;
            ;end
//----------------------------------------------------------------------------------------------------------------------
CLASS ado4xb
EXPORTED:
       // ---------------------------------------------------------------------------------
       VAR m_conn
       VAR m_last_error
       // ---------------------------------------------------------------------------------
INLINE METHOD init()
       local pi := 0
       local nLastError := 0
       ASSERT ( ::m_conn == NIL ) , "Object already initialized"
       nLastError := _dh_CreateObject(L("ADODB.Connection"),0,@pi )
       ASSERT ( nLastError >= 0 ) , "Unable to instantiate ADODB.Connection"
       ::m_conn       := pi
       ::m_last_error := nLastError
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD release()
       SAFE_RELEASE( ::m_conn )
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD open( cString )
       ::m_last_error := _dh_CallMethod(::m_conn, L(".Open(%s)") ,__vstr(cString) )
       return ( ::m_last_error >= 0 )
       // ---------------------------------------------------------------------------------
INLINE METHOD exec( cQuery , aFieldNames)
       local rs    := 0
       aFieldNames := NIL
       ::m_last_error := _dh_GetValue(L("%o"),@rs,::m_conn,L(".Execute(%s)"),__vstr(cQuery) )
       if( ::m_last_error < 0 )
          return NIL
       end
       return ::RsDumpAndRelease(rs , @aFieldNames)
       // ---------------------------------------------------------------------------------
INLINE METHOD RsDumpAndRelease(rs , aFieldNames)
       local result := NIL
       local lEof   := .F.
       local nn,n,p,rec
       aFieldNames := NIL
       if( rs == 0)
          return NIL
       end
       nn := 0
       ::m_last_error := _dh_GetValue(L("%d"),@nn,rs,L(".Fields.Count()"))
       if ::m_last_error >= 0
          aFieldNames := Array(nn)
          for n := 1 to nn
             p := 0
             aFieldNames[n] := ""
             if _dh_GetValue(L("%s"),@p,rs, L(".Fields.Item(%d).Name"), n-1) >= 0
                aFieldNames[n] := cPrintf("%s",p)
                @oleaut32:SysFreeString(p)
             end
          next
          result := Array(0)
          while ( nn > 0 )  .and. (::m_last_error >= 0) .and. ( (::m_last_error := _dh_GetValue(L("%b"),@lEof,rs,L(".EOF")) ) >= 0 ) .and. !lEof
             rec := Array(nn)
             for n := 1 to nn                    
                p := 0
                rec[n] := ""
                if _dh_GetValue(L("%s"),@p,rs, L(".Fields.Item(%d).Value"), n-1) >= 0
                   rec[n] := cPrintf("%s",p)
                   @oleaut32:SysFreeString(p)
                end
             next
             aadd( result , rec )
             ::m_last_error := _dh_CallMethod(rs, L(".MoveNext"))
          end

       end
       SAFE_RELEASE( rs  )
       return result
       // ---------------------------------------------------------------------------------

ENDCLASS
//----------------------------------------------------------------------------------------------------------------------
       
``` 
       
------ 
 
------ 
 
## test-ado4xb.prg  
       
``` 
#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
proc dbesys ; return // no need dbe
//----------------------------------------------------------------------------------------------------------------------
proc main
local ado
SET CHARSET TO ANSI
SET EXACT ON

ado := ado4xb():New()
? ado:m_conn
? ado:open('Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Whales.xls;Extended Properties="Excel 8.0;HDR=Yes;IMEX=0;"')
? ado:exec("SELECT * FROM [Whales$]")
ado:release()
? ado:m_conn
inkey(0)


return
//----------------------------------------------------------------------------------------------------------------------
       
``` 
       
------ 
 
------ 
 
## test-ado4xb.XPJ  
       
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
test-ado4xb.exe

[test-ado4xb.exe]
test-ado4xb.prg    
ado4xb.prg
ot4xb.lib




       
``` 
       
------ 
