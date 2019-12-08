#include "ot4xb.ch"
#include "winsock2_constants.ch"
//----------------------------------------------------------------------------------------------------------------------
#ifndef AI_FILESERVER
#define AI_FILESERVER 0x00040000
#endif
//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//----------------------------------------------------------------------------------------------------------------------
init proc check_ot4xb_version()
if  ot4xb() < "001.006.004.081"
   ? "This example require ot4xb 001.006.004.081 or above"
   inkey(0)
   QUIT
end
return
//----------------------------------------------------------------------------------------------------------------------
proc main( cPath )
local info := host_info( cPath ) 
local cc


cc := info:json_escape_self(0x1000000)      
lMemoWrite( "result.json" , cc )

// lazy display
// remove json encode characters
cc := StrTran( cc , "\\" , "\")
cc := StrTran( cc , '\"' , '"')
cc := StrTran( cc , '\:' , ':')

MsgBox(  cc )



inkey(0)
return
//----------------------------------------------------------------------------------------------------------------------
function host_info( cPath )
local info := _ot4xb_expando_():new()
local s    := wapist_addrinfo():new()
local p_info,buffer,cb,node
local p_next,dw        

info:path := __vstr(cPath,"")
if empty( cPath )
   return info
end

if !lStrWildCmpEx( "^\\\\[^\\]+\\.*" , info:path , 0x201 )
   info:result := .F.
   info:reason := "The provided path have not contain host information"
   return info
end
info:host := tokenize(cPath , "\" )[3]
buffer := ChrR(0,1024)
@ws2_32:["__sl__us__pt"]:WSAStartup( MAKELONG(2,2) , @buffer )


s:ai_flags       := nOr(AI_CANONNAME,AI_ALL,AI_V4MAPPED,AI_NON_AUTHORITATIVE,AI_RETURN_PREFERRED_NAMES,AI_FILESERVER)
s:ai_family      := AF_UNSPEC
s:ai_socktype    := SOCK_STREAM
s:ai_protocol    := IPPROTO_TCP

p_info := 0
dw := @ws2_32:getaddrinfo( info:host,0,s,@p_info)
p_next := 0
if lAnd(info:query_result) 
   info:error_op := "getaddrinfo"
   info:error_code := dw
   info:error_description :=  cFmtSysMsg(dw)
else
   p_next := p_info 
   info:list := Array(0)
end

while lAnd( p_next )
   s:_link_(p_next,.F.)
   p_next := s:ai_next
   node := info:new()
   aadd( info:list , node)      
   if !empty( s:cCanonName )
      node:name := s:cCanonName
   end
   if s:ai_family == AF_UNSPEC
      node:family := "UNSPEC"
   elseif s:ai_family == AF_INET
      node:family := "IPv4"
      cb := 1024
      buffer := ChrR(0,cb) 
      dw :=  @ws2_32:WSAAddressToStringA(s:ai_addr,s:ai_addrlen,0,@buffer,@cb)
      if lAnd( dw )
         node:error_op := "WSAAddressToStringA"
         node:error_code := dw
         node:error_description :=  cFmtSysMsg(dw)
      end
      node:ip_v4 := TrimZ( buffer )
   elseif s:ai_family == AF_INET6
      node:family := "IPv6"
      cb := 1024
      buffer := ChrR(0,cb) 
      dw :=  @ws2_32:WSAAddressToStringA(s:ai_addr,s:ai_addrlen,0,@buffer,@cb)
      if lAnd( dw )
         node:error_op := "WSAAddressToStringA"
         node:error := dw
      end
      node:ip_v6 := TrimZ( buffer )
   elseif s:ai_family == AF_NETBIOS
      node:family := "NETBIOS"
   else
      node:family := "other"
   end
end    
if lAnd( p_info )
   @ws2_32:freeaddrinfo(p_info)
   p_info := 0
end
@ws2_32:WSACleanup()
return info
//----------------------------------------------------------------------------------------------------------------------





