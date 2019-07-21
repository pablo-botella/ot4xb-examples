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

