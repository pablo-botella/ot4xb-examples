# test-view-pdf  
 
------ 
 
download: [test-view-pdf.zip](test-view-pdf.zip) 
 
 
------ 
          
#test-view-pdf                  
  
----  
  
 
------ 
 
 
[install_createwindowex_hook.prg](#install_createwindowex_hook.prg)   
 
[test-view-pdf.prg](#test-view-pdf.prg)   
 
[XbpViewPdf.prg](#XbpViewPdf.prg)   
 
[test-view-pdf.xpj](#test-view-pdf.xpj)   
 
------ 
 
## install_createwindowex_hook.prg  
       
``` 
#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
function install_createwindowex_hook( )
static rrr := NIL
if rrr != NIL ; return NIL ;end
rrr := @ot4xb:_ot4xb_hook_func_in_mod_( nLoadLibrary("xpprt1"),;
                                        "user32.dll",;
                                        "CreateWindowExA",;
                                        @ot4xb:_ot4xb_hook_createwindowex_(-1) )

rrr := @ot4xb:_ot4xb_hook_func_in_mod_( nLoadLibrary("xppui1"),;
                                        "user32.dll",;
                                        "CreateWindowExA",;
                                        @ot4xb:_ot4xb_hook_createwindowex_(-1) )
return NIL

//----------------------------------------------------------------------------------------------------------------------
        
``` 
       
------ 
 
------ 
 
## test-view-pdf.prg  
       
``` 
#pragma Library( "XppUI2.LIB" ) 
#pragma Library( "Adac20b.lib" ) 
#include "Appevent.ch" 
#include "ot4xb.ch" 
// ---------------------------------------------------------------------------
proc appsys ; return // not needed for this test
proc dbesys ; return
//----------------------------------------------------------------------------------------------------------------------
proc main( cFileName ) 
local oDlg,oDa,oPdf
SET CHARSET TO ANSI
oDlg := XbpDialog():new(AppDesktop(),,{100,100}, {600,400},,.F.)
oDa  := oDlg:drawingArea
oDa:ClipChildren := .T.
oDlg:taskList := .T.
oDlg:title    := "Test View PDF"
oDlg:close    := {|p1,p2,oo| PostAppEvent(xbeP_Quit,,,oo)} 
oDlg:create()
oPdf := XbpViewPdf():New(oDa,,{0,0},oDa:currentSize())
oPdf:Create()                                   
oDa:resize := {|p1,p2,oo| oPdf:SetSize(p2) }
SetAppFocus( oPdf )

DEFAULT cFilename := cPathCombine(cAppPath() , "test.pdf" )    

if !empty( cFilename )
   oPdf:LoadFile( cFileName )
end   

oPdf:Show()
oDlg:Show()
MsgLoop()
return 
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
 
## XbpViewPdf.prg  
       
``` 
#define _OT4XB_MAP_WAPIST_FUNC_
#include "ot4xb.ch"
#include "WinBase_constants.ch"
#include "WinUser_constants.ch"
#include "appevent.ch"
#pragma Library( "xppui2.lib" )
#include "xbp.ch"
//----------------------------------------------------------------------------------------------------------------------
#xtranslate IWebBrowser2_uuidof()      => UuidFromString("D30C1661-CDAF-11d0-8A3E-00C04FC9E26E")
#xtranslate IWebBrowser2_Navigate2( <pt>, [<p,...>])                  => IFpQCall(52,"__sl__sl__pt__pt__pt__pt__pt",<pt>[,<p>])
//----------------------------------------------------------------------------------------------------------------------
CLASS XbpViewPdf FROM XbpSle
EXPORTED:
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD initclass()
       install_createwindowex_hook()
       delegated_eval( {|| @atl:AtlAxWinInit() } )
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD Create(p1,p2,p3,p4,p5,p6)
       local con := _var2con(Self)
       ::clipchildren := .T.
       ::XbpPartHandler:SetName(0)
       delegated_eval( {|| ::__create_internal__(p1,p2,p3,p4,p5,p6)     })
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD __create_internal__(p1,p2,p3,p4,p5,p6)
       local con := _var2con(Self)
       @ot4xb:_ot4xb_hook_createwindowex_(con) 
       ::XbpSle:Create(p1,p2,p3,p4,p5,p6)
       @ot4xb:_ot4xb_hook_createwindowex_(0)   
       _conRelease(con)                        
       con := 0
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD Configure(p1,p2,p3,p4,p5,p6)
       local con := _var2con(Self)
       ::clipchildren := .T.
       ::XbpPartHandler:SetName("")
       delegated_eval( {|| ::__configure_internal__(p1,p2,p3,p4,p5,p6)     })
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD __configure_internal__(p1,p2,p3,p4,p5,p6)
       local con := _var2con(Self)
       @ot4xb:_ot4xb_hook_createwindowex_(con) 
       ::XbpSle:configure(p1,p2,p3,p4,p5,p6)
       @ot4xb:_ot4xb_hook_createwindowex_(0)   
       _conRelease(con)                        
       con := 0
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD createwindowex_hook(dwExStyle,pCls,pText,dwStyle,x,y,cx,cy,hParent,hMenu,hInstance,lp )
       return @user32:CreateWindowExA( dwExStyle,"AtlAxWin","about:blank",dwStyle,x,y,cx,cy,hParent,hMenu,AppInstance(),lp)
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD atl_get_wb2_interface(hWnd)
       local result := NIL
       local pUnk   := 0
       local pwb    := 0
       result := @atl:AtlAxGetControl(hWnd,@pUnk)
       if result < 0 ; return NIL ; end
       result := IFpQCall( 0,"__sl__sl__pt_@sl",pUnk,IWebBrowser2_uuidof(),@pwb )
       IFpQCall( 2,"__sl__sl",pUnk); pUnk := 0
       if result < 0 ; return NIL ; end
       return pwb
       // ---------------------------------------------------------------------------------
INLINE METHOD LoadFile( cFileName )
       local hWnd := ::GetHWnd()
       delegated_eval( {|| ::__load_file_internal__( hWnd , cFileName ) } )
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD __load_file_internal__( hWnd,cFileName )       
       local pUnk   := 0
       local pwb    := 0
       local result := 0
       local vtUrl,vtFlags,vtTarget,vtPost,vtHeaders

       result := @atl:AtlAxGetControl(hWnd,@pUnk)
       if result < 0 ; return NIL ; end
       result := IFpQCall( 0,"__sl__sl__pt_@sl",pUnk,IWebBrowser2_uuidof(),@pwb )
       IFpQCall( 2,"__sl__sl",pUnk); pUnk := 0
       if result < 0 ; return NIL ; end
       
       
       vtUrl := vtFlags := vtTarget := vtPost := vtHeaders := __vtEmpty__
       @ot4xb:_variant_t_SetString(@vtUrl,"file://" + __vstr( cFileName,"") )
       @ot4xb:_variant_t_Set_I4(@vtFlags,0)
       
       result := IWebBrowser2_Navigate2(pwb,vtUrl,vtFlags,vtTarget,vtPost,vtHeaders)
       IFpQCall( 2,"__sl__sl",pwb); pwb := 0

       @ot4xb:_variant_t_Clear( @vtUrl     )
       @ot4xb:_variant_t_Clear( @vtFlags   )
       @ot4xb:_variant_t_Clear( @vtTarget  )
       @ot4xb:_variant_t_Clear( @vtPost    )
       @ot4xb:_variant_t_Clear( @vtHeaders )
       return NIL
       // ---------------------------------------------------------------------------------


ENDCLASS
//----------------------------------------------------------------------------------------------------------------------
       
``` 
       
------ 
 
------ 
 
## test-view-pdf.xpj  
       
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
    test-view-pdf.exe
[test-view-pdf.exe]
test-view-pdf.prg                   
XbpViewPdf.prg
install_createwindowex_hook.prg
ot4xb.lib 

       
``` 
       
------ 
