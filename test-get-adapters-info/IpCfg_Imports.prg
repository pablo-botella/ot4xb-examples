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

