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


