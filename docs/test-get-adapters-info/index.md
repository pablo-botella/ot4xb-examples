# test-get-adapters-info  
 
------ 
 
download: [test-get-adapters-info.zip](test-get-adapters-info.zip) 
 
 
------ 
          
#test-get-adapters-info         
  
----  
  
 
------ 
 
 
[IpCfg.prg](#IpCfg.prg)   
 
[IpCfg_Classes.prg](#IpCfg_Classes.prg)   
 
[IpCfg_Imports.prg](#IpCfg_Imports.prg)   
 
[IpCfg_Structs.prg](#IpCfg_Structs.prg)   
 
[test-get-adapters-info.prg](#test-get-adapters-info.prg)   
 
[test-get-adapters-info.xpj](#test-get-adapters-info.xpj)   
 
------ 
 
## IpCfg.prg  
       
``` 
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
       
``` 
       
------ 
 
------ 
 
## IpCfg_Classes.prg  
       
``` 
#include "ot4xb.ch"
// ---------------------------------------------------------------------------
CLASS TIPAdapterInfo
EXPORTED:
VAR nComboIndex
VAR cAdapterName
VAR cAdapterAlias
VAR cDescription
VAR cMacAddress
VAR nIndex
VAR nType
VAR cType
VAR lDHCPEnabled
VAR aIPList
VAR oIpList
VAR oGateway
VAR oDhcpServer
VAR lHaveWins
VAR oPrimaryWinsServer
VAR oSecondaryWinsServer
VAR nLeaseObtained
VAR nLeaseExpires
VAR lAutoIpEnabled
VAR lAutoIpActive
VAR oDNS
ENDCLASS
// ---------------------------------------------------------------------------
CLASS TIPList
EXPORTED:
VAR oNext
VAR cIP
VAR nIP
VAR cMask
VAR nMask
VAR nContext
ENDCLASS
// ---------------------------------------------------------------------------
CLASS TMibTcpRow
EXPORTED:
VAR nStatus
VAR cStatus
VAR nLocalIP
VAR cLocalIP
VAR nLocalPort
VAR nRemoteIP
VAR cRemoteIP
VAR nRemotePort
ENDCLASS
// ---------------------------------------------------------------------------
CLASS TMibUdpRow
EXPORTED:
VAR nLocalIP
VAR cLocalIP
VAR nLocalPort
ENDCLASS
// ---------------------------------------------------------------------------

       
``` 
       
------ 
 
------ 
 
## IpCfg_Imports.prg  
       
``` 
#include "ot4xb.ch"
// ---------------------------------------------------------------------------
CLASS IpCfg_Imports
   EXPORTED:
   VAR hIpHlp // iphlpapi.dll
   VAR fp_GetAdaptersInfo
   VAR fp_GetPerAdapterInfo
   VAR fp_GetTcpTable
   VAR fp_GetUdpTable
   
   VAR hAdv // ADVAPI32.DLL
   VAR fp_RegCloseKey
   VAR fp_RegOpenKeyEx     // RegOpenKeyExA
   VAR fp_RegQueryValueEx  // RegQueryValueExA
   
   VAR hWs // Ws2_32.dll
   VAR fp_inet_addr
   VAR fp_inet_ntoa
       // --------------------------------------------------------------------
INLINE METHOD Release()
       if !Empty(::hIpHlp) ; DllUnLoad( ::hIpHlp ) ; end
       if !Empty(::hAdv  ) ; DllUnLoad( ::hAdv   ) ; end
       if !Empty(::hWs   ) ; DllUnLoad( ::hWs    ) ; end
       ::hIpHlp := ::hAdv := ::hWs  := 0
       ::fp_GetAdaptersInfo    := 0
       ::fp_GetPerAdapterInfo  := 0
       ::fp_GetTcpTable        := 0
       ::fp_GetUdpTable        := 0
       ::fp_RegCloseKey        := 0
       ::fp_RegOpenKeyEx       := 0
       ::fp_RegQueryValueEx    := 0
       ::fp_inet_addr          := 0
       ::fp_inet_ntoa          := 0
       return NIL
       // --------------------------------------------------------------------
INLINE METHOD init()
       ::Release()
       ::hIpHlp := DllLoad("iphlpapi.dll")
       ::fp_GetAdaptersInfo    := nGetProcAddress(::hIpHlp,"GetAdaptersInfo"  )
       ::fp_GetPerAdapterInfo  := nGetProcAddress(::hIpHlp,"GetPerAdapterInfo")
       ::fp_GetTcpTable        := nGetProcAddress(::hIpHlp,"GetTcpTable")
       ::fp_GetUdpTable        := nGetProcAddress(::hIpHlp,"GetUdpTable")
       
       ::hAdv := DllLoad( "ADVAPI32.DLL" )
       ::fp_RegCloseKey     := nGetProcAddress( ::hAdv , "RegCloseKey")
       ::fp_RegOpenKeyEx    := nGetProcAddress( ::hAdv , "RegOpenKeyExA")
       ::fp_RegQueryValueEx := nGetProcAddress( ::hAdv , "RegQueryValueExA")
       
       ::hWs := DllLoad("Ws2_32.dll")
       ::fp_inet_addr  := nGetProcAddress( ::hWs , "inet_addr" )
       ::fp_inet_ntoa  := nGetProcAddress( ::hWs , "inet_ntoa" )
       return Self
       // --------------------------------------------------------------------
INLINE METHOD GetAdaptersInfo( pInfo , pOutBuffLen )
       return nFpCall( ::fp_GetAdaptersInfo , pInfo  , @pOutBuffLen )
       // --------------------------------------------------------------------
INLINE METHOD GetPerAdapterInfo( nIndex , pPerInfo , nLen )
       return nFpCall( ::fp_GetPerAdapterInfo , nIndex , pPerInfo , @nLen)
       // --------------------------------------------------------------------
INLINE METHOD GetTcpTable(pBuffer,nSize,lSort)
       return nFpCall( ::fp_GetTcpTable ,pBuffer,@nSize,lSort)
       // --------------------------------------------------------------------
INLINE METHOD GetUdpTable(pBuffer,nSize,lSort)
       return nFpCall( ::fp_GetUdpTable ,pBuffer,@nSize,lSort)
       // --------------------------------------------------------------------
INLINE METHOD RegCloseKey( hKey )
       return nFpCall( ::fp_RegCloseKey , hKey )
       // --------------------------------------------------------------------
INLINE METHOD RegOpenKeyEx(hKey, cSubKey , nOptions, nAccess , pKey )
       return nFpCall(::fp_RegOpenKeyEx,hKey,cSubKey,nOptions,nAccess,@pKey )
       // --------------------------------------------------------------------
INLINE METHOD RegQueryValueEx( hKey , cName , pReserved ,nType , cBuffer , nLen )
       return nFpCall(::fp_RegQueryValueEx,hKey , cName ,0,@nType , @cBuffer , @nLen )
       // --------------------------------------------------------------------
INLINE METHOD inet_addr( cIp )
       return nFpCall( ::fp_inet_addr , cIp )
       // --------------------------------------------------------------------
INLINE METHOD inet_ntoa( nInAddr ) 
       return nFpCall( ::fp_inet_ntoa , nInAddr )
       // --------------------------------------------------------------------
ENDCLASS
// ---------------------------------------------------------------------------

       
``` 
       
------ 
 
------ 
 
## IpCfg_Structs.prg  
       
``` 
#include "ot4xb.ch"
// ---------------------------------------------------------------------------
BEGIN STRUCTURE IP_ADDR_STRING
   MEMBER POINTER32            _Next
   MEMBER BINSTR IpAddress     SIZE 16
   MEMBER BINSTR IpMask        SIZE 16
   MEMBER DWORD  Context
END STRUCTURE
// ---------------------------------------------------------------------------
BEGIN STRUCTURE IP_ADAPTER_INFO
   MEMBER POINTER32           _Next
   MEMBER DWORD               ComboIndex
   MEMBER SZSTR               AdapterName SIZE 260
   MEMBER SZSTR               Description SIZE 132
   MEMBER UINT                AddressLength
   MEMBER BINSTR              Address SIZE 8
   MEMBER DWORD               Index
   MEMBER UINT                Type
   MEMBER BOOL                DhcpEnabled
   MEMBER POINTER32           CurrentIpAddress
   MEMBER @ IP_ADDR_STRING    IpAddressList
   MEMBER @ IP_ADDR_STRING    GatewayList
   MEMBER @ IP_ADDR_STRING    DhcpServer
   MEMBER BOOL                HaveWins
   MEMBER @ IP_ADDR_STRING    PrimaryWinsServer
   MEMBER @ IP_ADDR_STRING    SecondaryWinsServer
   MEMBER DWORD               LeaseObtained
   MEMBER DWORD               LeaseExpires
END STRUCTURE
// ---------------------------------------------------------------------------
BEGIN STRUCTURE IP_PER_ADAPTER_INFO
   MEMBER UINT             AutoconfigEnabled
   MEMBER UINT             AutoconfigActive
   MEMBER POINTER32        CurrentDnsServer
   MEMBER @ IP_ADDR_STRING DnsServerList
END STRUCTURE
// ---------------------------------------------------------------------------

       
``` 
       
------ 
 
------ 
 
## test-get-adapters-info.prg  
       
``` 
#include "ot4xb.ch"
//-------------------------------------------------------------------------------------------------------------------------
#xcommand ? <str> [, <strN> ] => _cBuffer_ += Chr(13) + Chr(10) + Var2Char(<str>) [ + Var2Char(<strN>) ]
#xcommand ?? <str> [, <strN> ] => _cBuffer_ += Var2Char(<str>) [ + Var2Char(<strN>) ]
//-------------------------------------------------------------------------------------------------------------------------
static _cBuffer_ := ""
//-------------------------------------------------------------------------------------------------------------------------
proc appsys ; return
proc dbesys ; return
//-------------------------------------------------------------------------------------------------------------------------
function main()                     
 aEval(_aGetAdapterInfo(.T.,.T.), {|o| DisplayAdapter(o) } ) 
 ? "-----------------------------------------------------------------"
 //aEval(_aGetTcpTable(.t.)       , {|o| DisplayTcpConnection(o)})
 ?"-----------------------------------------------------------------"
 //aEval(_aGetUdpTable(.t.)       , {|o| DisplayUdpConnection(o)})
 ?"-----------------------------------------------------------------"
 Memowrit("TestNCfg.txt",_cBuffer_)
 RUN "START /MAX TestNCfg.txt"
return NIL
//-------------------------------------------------------------------------------------------------------------------------
function DisplayAdapter(o)
?"nCb       : "; ?? o:nComboIndex
?"cName     : "; ?? o:cAdapterName
?"cAlias    : "; ?? o:cAdapterAlias
?"cDescript : "; ?? o:cDescription
?"cMac      : "; ?? o:cMacAddress
?"nIndex    : "; ?? StrTrim(o:nIndex)
?"nType     : "; ?? StrTrim(o:nType)
?"cType     : "; ?? o:cType
?"DHCP?     : "; ?? iif(o:lDHCPEnabled,"YES","NO")
?"aIPList   : "; ?? o:aIPList
?"oIpList   : "; DisplayIpList( o:oIpList )
?"oGateway  : "; DisplayIpList( o:oGateway)
?"oDhcp     : "; DisplayIpList( o:oDhcpServer)
?"Wins?     : "; ?? iif(o:lHaveWins,"YES","NO")
?"Wins1     : "; DisplayIpList(o:oPrimaryWinsServer)
?"Wins2     : "; DisplayIpList(o:oSecondaryWinsServer)
?"nLObtained: "; ?? o:nLeaseObtained
?"nLExpires : "; ?? o:nLeaseExpires                   
?"DNS       : "; DisplayIpList(o:oDNS)
?"-----------------------------------------------------------------"
return NIL
//-------------------------------------------------------------------------------------------------------------------------
function DisplayIpList(o)
if o == NIL ; return NIL; end
?? "cIP    : " ; ?? o:cIp
? Space(12)
?? "nIP    : " ; ?? StrTrim(o:nIp)
? Space(12)
?? "cMask  : " ; ?? o:cMask
? Space(12)
?? "nMask  : " ; ?? StrTrim(o:nMask)
? Space(12)
?? "Context: " ; ?? StrTrim(o:nContext)
? Space(12)
return DisplayIpList(o:oNext)
//-------------------------------------------------------------------------------------------------------------------------
function DisplayTcpConnection(o)
?" TCP Local " + PadR(o:cLocalIP+":"+StrTrim(o:nLocalPort),25)
??"Remote " + PadR(o:cRemoteIP+":"+StrTrim(o:nRemotePort),25)
?? " Status: " + o:cStatus
Return(NIL)
//-------------------------------------------------------------------------------------------------------------------------
function DisplayUdpConnection(o)
?" UDP " + PadR(o:cLocalIP+":"+StrTrim(o:nLocalPort),25)
Return(NIL)
//-------------------------------------------------------------------------------------------------------------------------


       
``` 
       
------ 
 
------ 
 
## test-get-adapters-info.xpj  
       
``` 
[PROJECT]
    COMPILE       = xpp
    OBJ_DIR       = 
    COMPILE_FLAGS = /n /m /w /wi /wl /p
    DEBUG         = no
    GUI           = yes
    LINKER        = alink
    LINK_FLAGS    = 
    RC_COMPILE    = arc
    RC_FLAGS      = -v
    PROJECT.XPJ

[PROJECT.XPJ]
IpCfg.dll
test-get-adapters-info.exe

[IpCfg.dll]
IpCfg.prg
IpCfg_Classes.prg
IpCfg_Imports.prg
IpCfg_Structs.prg
ot4xb.lib
            
            
[test-get-adapters-info.exe]
test-get-adapters-info.prg
IpCfg.lib
ot4xb.lib
       
``` 
       
------ 
