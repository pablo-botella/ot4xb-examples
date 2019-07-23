#include "ot4xb.ch"  
#include "appevent.ch"  
#include "xbp.ch"  
//----------------------------------------------------------------------------------------------------------------------
proc dbesys ; return 
proc appsys ; return
//----------------------------------------------------------------------------------------------------------------------
proc main( cFile )       
local oXml,oDlg
DEFAULT cFile := "wishcollector.xml"
oXml := TXmlArray():FromFile( cFile )             
oDlg := XbpXmlArrayView():New("Testing xmllite.dll"):Create()
oDlg:SetData(oXml)   
oDlg:ExpandAll()
SetAppFocus(oDlg:oTree)
oDlg:Run(.T.)
return
