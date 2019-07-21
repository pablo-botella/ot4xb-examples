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


