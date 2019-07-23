# xml-tree-view  
 
------ 
 
download: [xml-tree-view.zip](xml-tree-view.zip) 
 
 
------ 
 
A simple test using the  xmllite.dll winapi component \( TestXmlLite.prg \)


------ 
 
xml-tree-view
  
----  
In this example we are populating an XbpTreeView with the nodes of an xml file and using an html window to display the node properties.
Here we using a bidimensional array to hold all the items, that we using later to populate the tree view control.
  
 
------ 
 
 
[TestXmlLite.prg](#TestXmlLite.prg)   
 
[TXmlArray.prg](#TXmlArray.prg)   
 
[XbpXmlArrayView.prg](#XbpXmlArrayView.prg)   
 
[XmlLite.prg](#XmlLite.prg)   
 
[xml-tree-view.xpj](#xml-tree-view.xpj)   
 
------ 
 
## TestXmlLite.prg  
 
``` 
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
 
``` 
 
------ 
 
------ 
 
## TXmlArray.prg  
 
``` 
#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
#xtranslate _assert_m_(<b>,<n>,<cc>) => ;
             if !(<b>) ;
            ;  TlsStackPush(Error():New());
            ;  TlsStackTop():severity := 2;
            ;  TlsStackTop():description := <cc> ;
            ;  TlsStackTop():gencode     := 0    ;
            ;  TlsStackTop():subcode     := <n>  ;
            ;  TlsStackTop():subsystem   := ::ClassName() ;
            ;  TlsStackTop():operation   := ::ProcName()  ;
            ;  Eval(ErrorBlock(),TlsStackPop()) ;
            ;end
//----------------------------------------------------------------------------------------------------------------------
CLASS TXmlArray
EXPORTED:
       // ---------------------------------------------------------------------------------
       VAR aXml
       // ---------------------------------------------------------------------------------
INLINE METHOD init( aXml )
       ::aXml := aXml
       return Self
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD FromFile( cFile )
       local oStm := TXmlReader():CreateStreamFromFile( cFile )     
       local eb,oXml
       if oStm == NIL ; return NIL ; end
       // eb   := ErrorBlock( {|e| Break(e) } )
       BEGIN SEQUENCE 
          oXml := ::New()
          oXml:_parse_xml_( oStm )
       END SEQUENCE         
       // ErrorBlock(eb)
       oStm:Release()
       return oXml
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD FromString( cXmlStr )
       local oStm := TXmlReader():CreateStreamFromString( cXmlStr )
       local eb,oXml        
       
       if oStm == NIL ; return NIL ; end
       // eb   := ErrorBlock( {|e| Break(e) } )
       BEGIN SEQUENCE 
          oXml := ::New()
          oXml:_parse_xml_( oStm )
       END SEQUENCE         
       // ErrorBlock(eb)
       oStm:Release()
       return oXml
       // ---------------------------------------------------------------------------------
INLINE METHOD _parse_xml_attributes_( oXml )
       local aAttrib := Array(0)
       local lFound  := oXml:MoveToFirstAttribute()
       local aa
       while lFound
          aa := Array(3)
          aa[1] := oXml:GetPrefix()
          aa[2] := oXml:GetLocalName()
          aa[3] := oXml:GetValue()   
          aadd( aAttrib,aa)
          lFound := oXml:MoveToNextAttribute()
       end
       return aAttrib
       // ---------------------------------------------------------------------------------
INLINE METHOD _parse_xml_( oInput )
       local nt  := NIL
       local oXml
       local ccp := ""
       local aa,cc,nn
       local nItemCount := 0  
       ::aXml := Array(0)
       _assert_m_(Valtype(oInput) == "O",-1,"Invalid Param")
       oXml := TXmlReader():CreateXmlReader()
       _assert_m_(Valtype(oXml) == "O",-1,"Unable to create the XmlReader")
       BEGIN SEQUENCE
       if oXml:SetInput( oInput )
          while ( (nt := oXml:Read()) != NIL ) 
             if nt ==  oXml:XmlNodeType_Element
                nItemCount++                                   
                nn := oXml:GetDepth()
                ccp := Left(ccp,nn*4)
                aa := Array(5)    
                aa[1] := ccp
                aa[2] := oXml:GetPrefix()
                aa[3] := oXml:GetLocalName()
                aa[4] := ::_parse_xml_attributes_( oXml )
                aa[5] := ""     
                aadd( ::aXml , aa )
                ccp += __i32(nItemCount)
             elseif (nt == oXml:XmlNodeType_Text) .or. (nt == oXml:XmlNodeType_CDATA)
                if nItemCount > 0       
                   cc := oXml:GetValue()
                   if cc != NIL
                      ::aXml[nItemCount][5] += cc
                   end
                end 
             end
          end
       end
       END SEQUENCE
       oXml:Release()
       return NIL
       // ---------------------------------------------------------------------------------
ENDCLASS
//----------------------------------------------------------------------------------------------------------------------
 
``` 
 
------ 
 
------ 
 
## XbpXmlArrayView.prg  
 
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
       static lWorking := .F.
       if !lWorking
       	  lWorking := .T.
          @user32:GetClientRect(::GetHWnd(),@rc)
          ::oTree:SetPosAndSize({0,rc[4]/2},{rc[3],(rc[4]/2)-2})
          ::DrawingArea:SetPosAndSize({0,0},{rc[3],rc[4]/2})
          @user32:GetClientRect(::DrawingArea:GetHWnd(),@rc)
          delegated_eval( {|| @user32:SetWindowPos(::hWndHtml,0,0,0,rc[3],rc[4],0x254) , lWorking := .F.})
       end
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
 
``` 
 
------ 
 
------ 
 
## XmlLite.prg  
 
``` 
#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
#xtranslate _assert_m_(<b>,<n>,<cc>) => ;
             if !(<b>) ;
            ;  TlsStackPush(Error():New());
            ;  TlsStackTop():severity := 2;
            ;  TlsStackTop():description := <cc> ;
            ;  TlsStackTop():gencode     := 0    ;
            ;  TlsStackTop():subcode     := <n>  ;
            ;  TlsStackTop():subsystem   := ::ClassName() ;
            ;  TlsStackTop():operation   := ::ProcName()  ;
            ;  Eval(ErrorBlock(),TlsStackPop()) ;
            ;end
//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
#xtranslate IXmlReader_QueryInterface( <pt>, [<params,...>]) =>   IFpQCall(0,"__sl__sl__pt_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_AddRef( <pt>)                         =>   IFpQCall(1,"__sl__sl",<pt>)
#xtranslate IXmlReader_Release(<pt>)                         =>   IFpQCall(2,"__sl__sl",<pt>)
#xtranslate IXmlReader_SetInput( <pt>, [<params,...>]) =>         IFpQCall(3,"__sl__sl__pt",<pt> [,<params>] )
#xtranslate IXmlReader_GetProperty( <pt>, [<params,...>]) =>      IFpQCall(4,"__sl__sl__sl_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_SetProperty( <pt>, [<params,...>]) =>      IFpQCall(5,"__sl__sl__pt",<pt> [,<params>] )
#xtranslate IXmlReader_Read( <pt>, [<params,...>]) =>             IFpQCall(6,"__sl__sl_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_GetNodeType( <pt>, [<params,...>]) =>      IFpQCall(7,"__sl__sl_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_MoveToFirstAttribute( <pt>) =>             IFpQCall(8,"__sl__sl",<pt>)
#xtranslate IXmlReader_MoveToNextAttribute( <pt>) =>              IFpQCall(9,"__sl__sl",<pt>)
#xtranslate IXmlReader_MoveToAttributeByName(<pt>,[<params,...>]) => IFpQCall(10,"__sl__slc_swc_sw",<pt> [,<params>] )
#xtranslate IXmlReader_MoveToElement( <pt>) =>                    IFpQCall(11,"__sl__sl",<pt>)
#xtranslate IXmlReader_GetQualifiedName( <pt>, [<params,...>]) => IFpQCall(12,"__sl__sl_@sl_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_GetNamespaceUri( <pt>, [<params,...>]) =>  IFpQCall(13,"__sl__sl_@sl_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_GetLocalName( <pt>, [<params,...>]) =>     IFpQCall(14,"__sl__sl_@sl_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_GetPrefix( <pt>, [<params,...>]) =>        IFpQCall(15,"__sl__sl_@sl_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_GetValue( <pt>, [<params,...>]) =>         IFpQCall(16,"__sl__sl_@sl_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_ReadValueChunk( <pt>, [<params,...>]) =>   IFpQCall(17,"__sl__sl__pt__sl_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_GetBaseUri( <pt>, [<params,...>]) =>       IFpQCall(18,"__sl__sl_@sl_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_IsDefault( <pt>) =>                        IFpQCall(19,"__bo__sl",<pt>)
#xtranslate IXmlReader_IsEmptyElement( <pt>) =>                   IFpQCall(20,"__bo__sl",<pt>)
#xtranslate IXmlReader_GetLineNumber( <pt>, [<params,...>]) =>    IFpQCall(21,"__sl__sl_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_GetLinePosition( <pt>, [<params,...>]) =>  IFpQCall(22,"__sl__sl_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_GetAttributeCount(<pt>, [<params,...>]) => IFpQCall(23,"__sl__sl_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_GetDepth( <pt>, [<params,...>]) =>         IFpQCall(24,"__sl__sl_@sl",<pt> [,<params>] )
#xtranslate IXmlReader_IsEOF( <pt>) =>                            IFpQCall(25,"__bo__sl",<pt>)
//----------------------------------------------------------------------------------------------------------------------
CLASS TXmlLite_Constants
EXPORTED:
       // ---------------------------------------------------------------------------------
CLASS PROPERTY  XmlConformanceLevel_Auto     IS CONSTANT 0
CLASS PROPERTY  XmlConformanceLevel_Document IS CONSTANT 1
CLASS PROPERTY  XmlConformanceLevel_Fragment IS CONSTANT 2
       // ---------------------------------------------------------------------------------
CLASS PROPERTY  XmlNodeType_None                    IS CONSTANT  0
CLASS PROPERTY  XmlNodeType_Element                 IS CONSTANT  1
CLASS PROPERTY  XmlNodeType_Attribute               IS CONSTANT  2
CLASS PROPERTY  XmlNodeType_Text                    IS CONSTANT  3
CLASS PROPERTY  XmlNodeType_CDATA                   IS CONSTANT  4
CLASS PROPERTY  XmlNodeType_ProcessingInstruction   IS CONSTANT  7
CLASS PROPERTY  XmlNodeType_Comment                 IS CONSTANT  8
CLASS PROPERTY  XmlNodeType_DocumentType            IS CONSTANT 10
CLASS PROPERTY  XmlNodeType_Whitespace              IS CONSTANT 13
CLASS PROPERTY  XmlNodeType_EndElement              IS CONSTANT 15
CLASS PROPERTY  XmlNodeType_XmlDeclaration          IS CONSTANT 17
       // ---------------------------------------------------------------------------------
CLASS PROPERTY DtdProcessing_Prohibit   IS CONSTANT 0
CLASS PROPERTY DtdProcessing_Parse      IS CONSTANT 1
//----------------------------------------------------------------------------------------------------------------------
CLASS PROPERTY XmlReadState_Initial       IS CONSTANT 0
CLASS PROPERTY XmlReadState_Interactive   IS CONSTANT 1
CLASS PROPERTY XmlReadState_Error         IS CONSTANT 2
CLASS PROPERTY XmlReadState_EndOfFile     IS CONSTANT 3
CLASS PROPERTY XmlReadState_Closed        IS CONSTANT 4
//----------------------------------------------------------------------------------------------------------------------
CLASS PROPERTY XmlReaderProperty_MultiLanguage       IS CONSTANT 0
CLASS PROPERTY XmlReaderProperty_ConformanceLevel    IS CONSTANT 1
CLASS PROPERTY XmlReaderProperty_RandomAccess        IS CONSTANT 2
CLASS PROPERTY XmlReaderProperty_XmlResolver         IS CONSTANT 3
CLASS PROPERTY XmlReaderProperty_DtdProcessing       IS CONSTANT 4
CLASS PROPERTY XmlReaderProperty_ReadState           IS CONSTANT 5
CLASS PROPERTY XmlReaderProperty_MaxElementDepth     IS CONSTANT 6
CLASS PROPERTY XmlReaderProperty_MaxEntityExpansion  IS CONSTANT 7
//----------------------------------------------------------------------------------------------------------------------
CLASS PROPERTY XmlStandalone_Omit   IS CONSTANT 0
CLASS PROPERTY XmlStandalone_Yes    IS CONSTANT 1
CLASS PROPERTY XmlStandalone_No     IS CONSTANT 2
       // ---------------------------------------------------------------------------------
ENDCLASS
//----------------------------------------------------------------------------------------------------------------------
CLASS TXmlReader FROM TXmlLite_Constants
EXPORTED:
VAR _pi_
VAR nLastError
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD UuidOf() ; return UuidFromString("7279FC81-709D-4095-B63D-69FE4B0D9030")
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD CreateXmlReader(nErrCode) 
       local s  := Self
       local pi := 0
       nErrCode := @XmlLite:CreateXmlReader(s:UuidOf(),@pi,0)
       if nErrCode == 0
          return s:New( pi )
       end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD CreateStreamFromFile( cFile , nErrCode )     
       local p := 0   
       local o := NIL
       DEFAULT cFile := 0
       nErrCode := @shlwapi:SHCreateStreamOnFileA(cFile,0,@p)
       if nErrCode == 0
          o := ot4xb_IStream():New()
          o:_link_(p,.F.)
       end
       return o
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD CreateStreamFromString( cXmlStr )     
       local p := 0   
       local o := NIL
       _assert_m_( Valtype(cXmlStr) == "C",-1,"Invalid Param")
       p := @ot4xb:str2istream( cXmlStr , Len( cXmlStr) )
       if !Empty(p)
          o := ot4xb_IStream():New()
          o:_link_(p,.F.)
       end
       return o
       // ---------------------------------------------------------------------------------
INLINE METHOD init( pIXmlReader )
       _assert_m_( Double2Long( pIXmlReader ) != 0,-1, "Invalid param")
       ::_pi_ := pIXmlReader
       ::nLastError := 0
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD QueryInterface( iid,p)
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_QueryInterface(::_pi_,iid,@p)
       return ::nLastError
       // ---------------------------------------------------------------------------------
INLINE METHOD AddRef()
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_AddRef(::_pi_)
       return ::nLastError
       // ---------------------------------------------------------------------------------
INLINE METHOD Release()
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_Release(::_pi_)
       return ::nLastError
       // ---------------------------------------------------------------------------------
INLINE METHOD _prop_( k,v,b )
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       if b
          ::nLastError := IXmlReader_SetProperty(::_pi_,k, v)
          return NIL
       end
       ::nLastError := IXmlReader_GetProperty(::_pi_,k, @v)
       if( ::nLastError == 0 ) ; return v ; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE ACCESS ASSIGN METHOD MultiLanguage(v)      ; return ::_prop_(0,v,PCount() > 0)
INLINE ACCESS ASSIGN METHOD ConformanceLevel(v)   ; return ::_prop_(1,v,PCount() > 0)
INLINE ACCESS ASSIGN METHOD RandomAccess(v)       ; return ::_prop_(2,v,PCount() > 0)
INLINE ACCESS ASSIGN METHOD XmlResolver(v)        ; return ::_prop_(3,v,PCount() > 0)
INLINE ACCESS ASSIGN METHOD DtdProcessing(v)      ; return ::_prop_(4,v,PCount() > 0)
INLINE ACCESS ASSIGN METHOD ReadState(v)          ; return ::_prop_(5,v,PCount() > 0)
INLINE ACCESS ASSIGN METHOD MaxElementDepth(v)    ; return ::_prop_(6,v,PCount() > 0)
INLINE ACCESS ASSIGN METHOD MaxEntityExpansion(v) ; return ::_prop_(7,v,PCount() > 0)
       // ---------------------------------------------------------------------------------
INLINE METHOD IsEof()
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := 0
       return IXmlReader_IsEOF(::_pi_)
       // ---------------------------------------------------------------------------------
INLINE METHOD IsDefault()
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := 0
       return IXmlReader_IsDefault(::_pi_)
       // ---------------------------------------------------------------------------------
INLINE METHOD IsEmptyElement()
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := 0
       return IXmlReader_IsEmptyElement(::_pi_)
       // ---------------------------------------------------------------------------------
INLINE METHOD Read()
       local nNodeType := 0
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_Read( ::_pi_,@nNodeType)
       if ::nLastError == 0 ; return nNodeType ; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD GetNodeType()
       local nNodeType := NIL
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_GetNodeType( ::_pi_,@nNodeType)
       if ::nLastError == 0 ; return nNodeType ; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD MoveToFirstAttribute()
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_MoveToFirstAttribute( ::_pi_)
       if ::nLastError == 0 ; return .T. ; end
       return .F.
       // ---------------------------------------------------------------------------------
INLINE METHOD MoveToNextAttribute()
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_MoveToNextAttribute( ::_pi_)
       if ::nLastError == 0 ; return .T. ; end
       return .F.
       // ---------------------------------------------------------------------------------
INLINE METHOD MoveToAttributeByName(cLocalName,cNamespace)
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_MoveToAttributeByName(::_pi_,cLocalName,cNamespace)
       if ::nLastError == 0 ; return .T. ; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD MoveToElement()
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_MoveToElement( ::_pi_)
       if ::nLastError == 0 ; return .T. ; end
       return .F.
       // ---------------------------------------------------------------------------------
INLINE METHOD GetQualifiedName()
       local pw := 0
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_GetQualifiedName( ::_pi_,@pw )
       if( ::nLastError == 0 ) ; return PeekStr(pw,,-3) ; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD GetNamespaceUri()
       local pw := 0
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_GetNamespaceUri( ::_pi_,@pw)
       if( ::nLastError == 0 ) ; return PeekStr(pw,,-3) ; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD GetLocalName()
       local pw := 0
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_GetLocalName( ::_pi_,@pw)
       if( ::nLastError == 0 ) ; return PeekStr(pw,,-3) ; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD GetPrefix()
       local pw := 0
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_GetPrefix( ::_pi_,@pw)
       if( ::nLastError == 0 ) ; return PeekStr(pw,,-3) ; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD GetValue()
       local pw := 0
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_GetValue( ::_pi_,@pw)
       if( ::nLastError == 0 ) ; return PeekStr(pw,,-3) ; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD ReadValueChunk(nMaxRead)
       local nn := 0
       local cc := NIL
       local pw := 0
       DEFAULT nMaxRead := 1024
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       pw := _xgrab( (nMaxRead * 2) + 2 )
       ::nLastError := IXmlReader_ReadValueChunk( ::_pi_,pw,nMaxRead,@nn)
       if( ::nLastError == 0 ) ; cc := PeekStr(pw,,-3) ; end
       _xfree(pw)
       return cc
       // ---------------------------------------------------------------------------------
INLINE METHOD GetBaseUri()
       local pw := 0
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_GetBaseUri( ::_pi_,@pw)
       if( ::nLastError == 0 ) ; return PeekStr(pw,,-3) ; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD GetLineNumber()
       local n := 0
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_GetLineNumber( ::_pi_,@n)
       if ::nLastError == 0 ; return n; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD GetLinePosition()
       local n := 0
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_GetLinePosition( ::_pi_,@n)
       if ::nLastError == 0 ; return n; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD GetAttributeCount()
       local n := 0
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_GetAttributeCount(::_pi_,@n)
       if ::nLastError == 0 ; return n; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD GetDepth()
       local n := 0
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_GetDepth( ::_pi_,@n)
       if ::nLastError == 0 ; return n; end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD SetInput(p)
       local n := 0
       _assert_m_( !Empty(::_pi_),-2, "Object not properly initialized")
       ::nLastError := IXmlReader_SetInput( ::_pi_,p)
       return (::nLastError == 0 )
       // ---------------------------------------------------------------------------------
ENDCLASS
//----------------------------------------------------------------------------------------------------------------------


 
``` 
 
------ 
 
------ 
 
## xml-tree-view.xpj  
 
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
xml-tree-view.exe
[xml-tree-view.exe]
TestXmlLite.prg
XmlLite.prg
TXmlArray.prg
XbpXmlArrayView.prg
ot4xb.lib 

 
``` 
 
------ 
