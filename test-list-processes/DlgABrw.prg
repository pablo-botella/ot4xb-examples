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
