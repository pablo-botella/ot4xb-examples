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
