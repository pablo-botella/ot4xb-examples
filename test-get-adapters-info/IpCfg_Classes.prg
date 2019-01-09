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

