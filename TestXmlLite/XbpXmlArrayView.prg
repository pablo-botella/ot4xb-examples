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
CLASS XbpXmlArrayView FROM XbpDialog
EXPORTED:
       // ---------------------------------------------------------------------------------
       VAR oTree
       VAR oView
       VAR hWndHtml
       VAR oXml     
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
       ::oTree := XbpTreeView():New(Self,Self,{0,rccli[4]/2},{rccli[3],(rccli[4]/2)-2},,.T.)
       ::oTree:HasButtons := .T.
       ::oTree:HasLines   := .T.
       ::oTree:Create()
       ::DrawingArea:SetPosAndSize({0,0},{rccli[3],rccli[4]/2})
       cc := "about:blank"
       ::hWndHtml := delegated_eval({|| @user32:CreateWindowExA(0,"AtlAxWin",cc,0x50200000,;
                                        0,0,rccli[3],rccli[4]/2,::DrawingArea:GetHWnd(),-1,;
                                        AppInstance(),0) } )
       ::oTree:ItemMarked := {|oItem| ::OnItemMarked(oItem:GetData() )}
       ::Show()                   
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD OnItemMarked(nItem)
       return ::SetHtml( cPrintf("<html><body>%s</body></html>",::DumpItem(nItem)) )
       // ---------------------------------------------------------------------------------
INLINE METHOD DumpItem(nItem)
       local cHtml := ""
       local aXml
       if ::oXml == NIL ; return "" ; end
       aXml := ::oXml:aXml
       if( Empty( aXml ) ) ; return "" ; end
       if( Empty( nItem ) ) ; return "" ; end
       if( nItem > Len(aXml) ) ; return "" ; end
       return ::DumpNode(aXml[nItem])
       // ---------------------------------------------------------------------------------
INLINE METHOD DumpNode(aNode)
       local n,nn,aa
       local cc := "" 
       << "<div style=\qwidth:100%%;background-color:#FFFF20; color:#000000; font:bold 14 Verdana;padding:10px;\q>"
       if !Empty( aNode[2] ) ; <<< aNode[2] + ":" ; end
       <<< aNode[3]
       << "</div>"
       if !Empty( aNode[5] )
          << "<div style=\qwidth:100%%;background-color:#C0C0C0; color:#000000; font:bold 12 Verdana;padding:10px;\q>"
          <<< aNode[5]
          << "</div>"
       end
       nn := Len( aNode[4] )
       aa := aNode[4]
       if nn > 0
          << "<div style=\qwidth:100%%;background-color:#FFFFFF; color:#000000;"
          << " font:bold 10 Verdana;padding:10px; border-bottom: solid 1px #FF0000; \q>"
          << "Attributes:</div>"
          << "<table width=\q100%%\q>"
          for n := 1 to nn
             << "<tr><td>"
             if !Empty( aa[n][1] ) ; <<< aa[n][1] + ":" ; end
             <<< aa[n][2]
             << "</td><td>"
             <<< iif(Empty(aa[n][3]),"",aa[n][3])
             << "</td></tr>"
          next
          << "</table>"
       end
       return cc

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
       ::oTree:SetPosAndSize({0,rc[4]/2},{rc[3],(rc[4]/2)-2})
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
INLINE METHOD SetData( oXml )
       local stk
       local nn
       local n,nDepth,oItem,cc
       local aXml,oXbp
       ::oXml := oXml
       if oXml == NIL ; return NIL ; end
       stk := TGXbStack():New()
       aXml := ::oXml:aXml
       nn  := Len( aXml )
       oXbp := ::oTree
       for n := 1 to nn
          nDepth := nRShift(Len( aXml[n][1] ) , 2 )
          while nDepth < stk:count() ; stk:pop() ; end
          oItem := iif( nDepth > 0 , stk:head() , oXbp:rootItem )
          oItem := oItem:addItem( aXml[n][3] )
          if oItem != NIL
             stk:push( oItem )
             oItem:SetData(n)
          end
       next
       stk:destroy()
       ::oTree:RootItem:Expand(.T.)
       ::oTree:InvalidateRect()

       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD ExpandAll()
       @user32:PostMessageA(::oTree:GetHWnd(),0x100,0x6A,0)
       @user32:PostMessageA(::oTree:GetHWnd(),0x100,0x22,0)
       @user32:PostMessageA(::oTree:GetHWnd(),0x100,0x24,0)
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
