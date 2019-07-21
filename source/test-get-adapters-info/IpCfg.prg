#include "ot4xb.ch"
// ---------------------------------------------------------------------------
#define IPCFG_PERSISTENT_IMPORTS
// ---------------------------------------------------------------------------
// ------------------------------------------------------------------- //
#ifdef IPCFG_PERSISTENT_IMPORTS                                        //
static _oImp_ := NIL                                                   //
// -------------------------------                                     //
init proc _ipcfg__load__imports_()                                     //
_oImp_ := IpCfg_Imports():New()                                        //
return                                                                 //
// -------------------------------                                     //
exit proc _ipcfg__release__imports_()                                  //
_oImp_:Release()                                                       //
_oImp_ := NIL                                                          //
return                                                                 //
// -------------------------------                                     //
#xtranslate IPCFG_LOAD_IMPORTS() =>  _oImp_                            //
#xtranslate IPCFG_RELEASE_IMPORTS( <o> ) => <o> := NIL                 //
// ------------------------------------------------------------------- //
#else                                                                  //
// ------------------------------------------------------------------- //
#xtranslate IPCFG_LOAD_IMPORTS() =>  IpCfg_Imports():New()             //
#xtranslate IPCFG_RELEASE_IMPORTS( <o> ) => <o>:Release() ; <o> := NIL //
#endif                                                                 //
// ------------------------------------------------------------------- //





// ---------------------------------------------------------------------------
#define HKLM  (dwfix( 0x8000,0x0002))
// ---------------------------------------------------------------------------
function _aGetAdapterInfo(lDns,lAlias)
local oImp := IPCFG_LOAD_IMPORTS()
local aRet := {}
local pBuffer  := 0
local pSize,nSize
local oAdapter := IP_ADAPTER_INFO():New()
local nError
local oInfo
local pia
local hKey,cKey,cKPrefix,pValue,pName,nShift
local oIp
local nAdapters := 0

DEFAULT lAlias := .F.
DEFAULT lDns   := .F.
if ( oImp:hIpHlp == 0 )
   IPCFG_RELEASE_IMPORTS( oImp ) 
   return NIL  // iphlpapi.dll not available in Win 95
end
if ( oImp:fp_GetPerAdapterInfo == 0 ) // Not Available in Win9x
   lDns := .F.
end

nSize     := 512
pBuffer   := _xgrab( nSize  ) // Allocate memory
nError    := oImp:GetAdaptersInfo(pBuffer,@nSize)

if ( nError == 111 ) // ERROR_BUFFER_OVERFLOW
   _xfree( pBuffer ); pBuffer := _xgrab(nSize)
   nError  := oImp:GetAdaptersInfo(pBuffer,@nSize)
end

if ( nError != 0 )
   _xfree( pBuffer )
   IPCFG_RELEASE_IMPORTS( oImp ) 
   if( nError == 232 ) // ERROR_NO_DATA
      return {}
   end
   return nError // NIL
end
pia  := pBuffer
while ( pia != 0 )
   oAdapter:_link_(pia,.F.)
   aAdd( aRet , TIPAdapterInfo__Init(oImp,oAdapter,lAlias,lDns) )
   pia := oAdapter:_Next
end
_xfree( pBuffer )
IPCFG_RELEASE_IMPORTS( oImp ) 
return aRet
// ---------------------------------------------------------------------------
static function TIPAdapterInfo__cAdapterTypeToName( nType )
static acTypes := {"","OTHER","ETHERNET","TOKENRING ",;
                  "FDDI","PPP","LOOPBACK","SLIP"}
static anTypes := {1,6,9,15,23,24,28}
return acTypes[(aScan(anTypes,nType)+1)]
// ---------------------------------------------------------------------------
static function TIPAdapterInfo__Init(oImp,oAdapter,lAlias,lDns)
local oo := TIPAdapterInfo():New()
oo:nComboIndex   := oAdapter:ComboIndex
oo:cAdapterName  := oAdapter:AdapterName
if lAlias
   oo:cAdapterAlias := TIPAdapterInfo__cGetAliasName_( oImp , oo:cAdapterName )
else
   oo:cAdapterAlias := ""
end
oo:cDescription         := oAdapter:Description
oo:cMacAddress          := cBin2Hex( Left( oAdapter:Address,;
                                          oAdapter:AddressLength ) )
oo:nIndex               := oAdapter:Index
oo:nType                := oAdapter:Type
oo:cType                := TIPAdapterInfo__cAdapterTypeToName( oo:nType )
oo:lDHCPEnabled         := oAdapter:DhcpEnabled
oo:oIpList              := TIPAdapterInfo__GetIpObjects( oImp ,;
                            oAdapter:IpAddressList:_addressof_() )
oo:aIPList              := TIPAdapterInfo__aGetIpList_( oo:oIpList )
oo:oGateway             := TIPAdapterInfo__GetIpObjects( oImp , ;
                            oAdapter:GatewayList:_addressof_() )
oo:oDhcpServer          := TIPAdapterInfo__GetIpObjects( oImp , ;
                            oAdapter:DhcpServer:_addressof_() )
oo:lHaveWins            := oAdapter:HaveWins
oo:oPrimaryWinsServer   := TIPAdapterInfo__GetIpObjects( oImp ,;
                            oAdapter:PrimaryWinsServer:_addressof_() )
oo:oSecondaryWinsServer := TIPAdapterInfo__GetIpObjects( oImp ,;
                            oAdapter:SecondaryWinsServer:_addressof_() )
oo:nLeaseObtained       := oAdapter:LeaseObtained
oo:nLeaseExpires        := oAdapter:LeaseExpires
if lDns
   TIPAdapterInfo__AddPerAdapterInfo(oImp,oo)
end
return oo
// ---------------------------------------------------------------------------
static function TIPAdapterInfo__cGetAliasName_( oImp , cName)
local cKey   := "SYSTEM\CurrentControlSet\Control\Network\" +;
                "{4D36E972-E325-11CE-BFC1-08002BE10318}\" + ;
                 cName + "\Connection"
local hKey   := 0
local nLen   := 512
local cValue := Chrr(0,nLen+1)
if ( oImp:RegOpenKeyEx( HKLM ,cKey,0,1,@hKey) == 0 )
   if ( oImp:RegQueryValueEx(hKey,"Name",0,0,@cValue,@nLen) != 0 )
      cValue := ""
   end
  oImp:RegCloseKey(hKey)
end
return TrimZ(cValue)
// ---------------------------------------------------------------------------
static function TIPAdapterInfo__GetIpObjects( oImp , pIpList )
local oIP     := IP_ADDR_STRING():New()
local oFirst, oo
if pIpList == 0 ; return NIL ; end

oFirst := oo := TIPList():New()

while pIpList != 0
   oIp:_link_(pIpList,.F.)
   oo:cIP         := TrimZ( oIp:IpAddress )
   oo:nIP         := oImp:inet_addr( oIp:_addressof_("IpAddress") )
   oo:cMask       := TrimZ( oIp:IpMask )
   oo:nMask       := oImp:inet_addr( oIp:_addressof_("IpMask") )
   oo:nContext    := oIp:Context
   pIpList        :=  oIp:_Next
   if( pIpList != 0 )
      oo:oNext := TIPList():New()
   end
   oo := oo:oNext
end
return oFirst
// ---------------------------------------------------------------------------
static function TIPAdapterInfo__aGetIpList_( oIpList )
local aList := {}
local oo := oIpList

while oo != NIL
   aAdd( aList , oo:cIp )
   oo := oo:oNext
end
return aList
// ---------------------------------------------------------------------------
static function TIPAdapterInfo__AddPerAdapterInfo(oImp,oInfo)
local nIndex  := oInfo:nIndex
local nSize   := 512
local pBuffer := _xgrab( nSize )
local oPer
local nError  := oImp:GetPerAdapterInfo(nIndex,pBuffer,@nSize)

if ( nError == 111 ) // ERROR_BUFFER_OVERFLOW
   _xfree( pBuffer ); pBuffer := _xgrab(nSize)
   nError := oImp:GetPerAdapterInfo((nIndex),pBuffer,@nSize)
end
if ( nError == 0 )
   oPer := IP_PER_ADAPTER_INFO():New()
   oPer:_link_(pBuffer,.F.)
   oInfo:lAutoIpEnabled := oPer:AutoconfigEnabled
   oInfo:lAutoIpActive  := oPer:AutoconfigActive
   oInfo:oDNS := TIPAdapterInfo__GetIpObjects( oImp ,;
                  oPer:DnsServerList:_addressof_() )
end
_xfree( pBuffer )
return NIL
// ---------------------------------------------------------------------------
function _aGetTcpTable( lSort)
local oImp := IPCFG_LOAD_IMPORTS()
local nSize    := 1024
local pBuffer  := _xgrab(nSize)
local nShift   := 0
local nError   := 0
local nItems,n,aRet,oo,aRow
local aStatus := {"CLOSED","LISTEN","SYN_SENT","SYN_RCVD","ESTAB","FIN_WAIT1",;
                  "FIN_WAIT2","CLOSE_WAIT","CLOSING","LAST_ACK","TIME_WAIT",;
                  "DELETE_TCB"}
                                  
if ( oImp:hIpHlp == 0 )
   IPCFG_RELEASE_IMPORTS( oImp ) 
   return NIL  // iphlpapi.dll not available in Win 95
end

DEFAULT lSort := .F.

nError := oImp:GetTcpTable(pBuffer,@nSize,lSort)
if ( nError == 111 ) // ERROR_BUFFER_OVERFLOW
   _xfree( pBuffer ); pBuffer := _xgrab(nSize)
   nError := oImp:GetTcpTable(pBuffer,@nSize,lSort)
end
if ( nError == 0 ) 
   nItems := PeekDWord( pBuffer , @nShift )
   aRet := Array(nItems)
   for n := 1 to nItems
      aRow := PeekDWord( pBuffer , @nShift , 5 ) 
      oo   := TMibTcpRow():New()
      oo:nStatus      := aRow[1]
      oo:cStatus      := iif( (oo:nStatus > 0) .and. (oo:nStatus < 13),;
                              aStatus[oo:nStatus] , "?" )
      oo:nLocalIP     := aRow[2]
      oo:cLocalIP     := PeekStr(oImp:inet_ntoa(oo:nLocalIP),,-1)
      oo:nLocalPort   := whlByteRev(aRow[3])
      oo:nRemoteIP    := aRow[4]
      oo:cRemoteIP    := PeekStr(oImp:inet_ntoa(oo:nRemoteIP),,-1)
      oo:nRemotePort  := whlByteRev(aRow[5])
      aRet[n] := oo
   next
end
_xfree( pBuffer )
IPCFG_RELEASE_IMPORTS( oImp ) 
return aRet
// ---------------------------------------------------------------------------
function _aGetUdpTable( lSort)
local oImp := IPCFG_LOAD_IMPORTS()
local nSize    := 1024
local pBuffer  := _xgrab(nSize)
local nShift   := 0
local nError   := 0
local nItems,n,aRet,oo
                                  
if ( oImp:hIpHlp == 0 )
   IPCFG_RELEASE_IMPORTS( oImp ) 
   return NIL  // iphlpapi.dll not available in Win 95
end

DEFAULT lSort := .F.

nError := oImp:GetUdpTable(pBuffer,@nSize,lSort)
if ( nError == 111 ) // ERROR_BUFFER_OVERFLOW
   _xfree( pBuffer ); pBuffer := _xgrab(nSize)
   nError := oImp:GetUdpTable(pBuffer,@nSize,lSort)
end
if ( nError == 0 ) 
   nItems := PeekDWord( pBuffer , @nShift )
   aRet := Array(nItems)
   for n := 1 to nItems
      oo   := TMibUdpRow():New()
      oo:nLocalIP     := PeekDWord( pBuffer , @nShift ) 
      oo:cLocalIP     := PeekStr(oImp:inet_ntoa(oo:nLocalIP),,-1)
      oo:nLocalPort   := whlByteRev( PeekDWord( pBuffer , @nShift ) )
      aRet[n] := oo
   next
end
_xfree( pBuffer )
IPCFG_RELEASE_IMPORTS( oImp ) 
return aRet
// ---------------------------------------------------------------------------
