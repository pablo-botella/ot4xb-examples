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

