// example from: https://docs.microsoft.com/en-us/windows/win32/wnet/enumerating-network-resources
//----------------------------------------------------------------------------------------------------------------------
#include "ot4xb.ch"
#include "WinBase_constants.ch"
#include "WinError_constants.ch"
//----------------------------------------------------------------------------------------------------------------------
// some constants from WinNetWk.ch
#define RESOURCE_CONNECTED                 0x00000001
#define RESOURCE_GLOBALNET                 0x00000002
#define RESOURCE_REMEMBERED                0x00000003
#define RESOURCETYPE_ANY                   0x00000000
#define RESOURCETYPE_DISK                  0x00000001
#define RESOURCETYPE_PRINT                 0x00000002
#define RESOURCEUSAGE_CONNECTABLE          0x00000001
#define RESOURCEUSAGE_CONTAINER            0x00000002
#define RESOURCEDISPLAYTYPE_GENERIC        0x00000000
#define RESOURCEDISPLAYTYPE_DOMAIN         0x00000001
#define RESOURCEDISPLAYTYPE_SERVER         0x00000002
#define RESOURCEDISPLAYTYPE_SHARE          0x00000003
#define RESOURCEDISPLAYTYPE_FILE           0x00000004
#define RESOURCEDISPLAYTYPE_GROUP          0x00000005
#define RESOURCEDISPLAYTYPE_NETWORK        0x00000006
//----------------------------------------------------------------------------------------------------------------------
BEGIN STRUCTURE NETRESOURCEA
    MEMBER DWORD    dwScope
    MEMBER DWORD    dwType
    MEMBER DWORD    dwDisplayType
    MEMBER DWORD    dwUsage
    MEMBER LPSTR    lpLocalName     DYNSZ  cLocalName
    MEMBER LPSTR    lpRemoteName    DYNSZ  cRemoteName
    MEMBER LPSTR    lpComment       DYNSZ  cComment
    MEMBER LPSTR    lpProvider      DYNSZ  cProvider
END STRUCTURE
//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return // no dbe needed on this example
//----------------------------------------------------------------------------------------------------------------------
proc main  
local log_out := ""

if !EnumerateFunc(0 , @log_out )
  ? "Call to EnumerateFunc failed"
end
lMemoWrite(  cPathCombine(cAppPath(),"salida.txt") , log_out )
@shell32: ShellExecuteA(0,"open",cPathCombine(cAppPath(),"salida.txt"),0,0,3)

return
//----------------------------------------------------------------------------------------------------------------------
static function EnumerateFunc(lpnr , log_out)
local dwResult, dwResultEnum
local hEnum := 0
local cbBuffer := 16384   // 16K is a good size
local count_entries := -1      // enumerate all possible entries
local buffer         // pointer to enumerated structures
local i
local net_resource_item := NETRESOURCEA():new()
local net_resource_item_ptr,cc 

? "searching ...."

// Call the WNetOpenEnum function to begin the enumeration.
dwResult = @mpr:WNetOpenEnumA(;
                RESOURCE_GLOBALNET,; // all network resources
                RESOURCETYPE_ANY,;   // all resources
                0,;                  // enumerate all resources
                lpnr,;                // NULL first time the function is called
                @hEnum)              // handle to the resource

if (dwResult != NO_ERROR)
   ? cPrintf(,"WnetOpenEnum failed with error %i" , dwResult )
   return .F.
end

// Call the GlobalAlloc function to allocate resources.
buffer = _xgrab(cbBuffer)



dwResultEnum := 0
while dwResultEnum != ERROR_NO_MORE_ITEMS
   // Initialize the buffer.
   _bset( buffer, 0 , cbBuffer )

    // Call the WNetEnumResource function to continue  the enumeration.
    dwResultEnum = @mpr:WNetEnumResourceA(hEnum           ,; // resource handle
                                    @count_entries  ,; // defined locally as -1
                                    buffer          ,; // LPNETRESOURCE
                                    @cbBuffer)         // buffer size

   // If the call succeeds, loop through the structures.
   if (dwResultEnum == NO_ERROR)

      for i := 1 to count_entries

         // link the net_resource_item object to the buffer 
         net_resource_item_ptr := buffer +  ((i - 1) * net_resource_item:_sizeof_() )
         net_resource_item:_link_( net_resource_item_ptr  ,  .F. )
          
         // Call an application-defined function to display the contents of the NETRESOURCE structures.
         cc := dump_struct(i, net_resource_item )
         log_out += cc
         ? cc
         

         // If the NETRESOURCE structure represents a container resource, call the EnumerateFunc function recursively.
         if RESOURCEUSAGE_CONTAINER == nAnd( net_resource_item:dwUsage , RESOURCEUSAGE_CONTAINER )
            if ( !EnumerateFunc( net_resource_item_ptr  , @log_out) )
               ? "EnumerateFunc returned FALSE"
            end
         end
      next
    
    
   else
      // Process errors.
      if ( dwResultEnum != ERROR_NO_MORE_ITEMS ) 
         ? cPrintf(,"WNetEnumResource failed with error %i" , dwResultEnum)
      end
      exit
   end
end

_xfree( buffer ) ; buffer := 0
//
// Call WNetCloseEnum to end the enumeration.
//
dwResult = @mpr:WNetCloseEnum(hEnum);

if (dwResult != NO_ERROR) 
   // Process errors.
   ? cPrintf(,"WNetCloseEnum failed with error %i", dwResult)
   return .F.
end

return .T.
//----------------------------------------------------------------------------------------------------------------------
static function dump_struct( i , net_resource_item )
local aak,aal,k,v
local cc := ""


aak := {RESOURCE_CONNECTED,RESOURCE_GLOBALNET,RESOURCE_REMEMBERED}
aal := {"UNKNOWN SCOPE","CONNECTED","GLOBALNET","REMEMBERED"}
k   := net_resource_item:dwScope
v   := aal[ AScan(aak, k) + 1 ]   

cc += cPrintf(,"\r\nNETRESOURCE[%i] Scope:  %i  - %s", i ,k , v )


aak := {RESOURCETYPE_ANY,RESOURCETYPE_DISK,RESOURCETYPE_PRINT}
aal := {"UNKNOWN TYPE","ANY","DISK","PRINT"}
k   := net_resource_item:dwType
v   := aal[ AScan(aak, k) + 1 ]   
cc += cPrintf(,"\r\nNETRESOURCE[%i] Type:  %i  - %s", i ,k , v )


aak := {RESOURCEDISPLAYTYPE_GENERIC,RESOURCEDISPLAYTYPE_DOMAIN,RESOURCEDISPLAYTYPE_SERVER,RESOURCEDISPLAYTYPE_SHARE,RESOURCEDISPLAYTYPE_FILE,RESOURCEDISPLAYTYPE_GROUP,RESOURCEDISPLAYTYPE_NETWORK}
aal := {"UNKNOWN DISPLAYTYPE","GENERIC","DOMAIN","SERVER","SHARE","FILE","GROUP","NETWORK"}
k   := net_resource_item:dwDisplayType
v   := aal[ AScan(aak, k) + 1 ]   
cc += cPrintf(,"\r\nNETRESOURCE[%i] DisplayType:  %i  - %s", i ,k , v )
                                                         
                                                         

cc += cPrintf(,"\r\nNETRESOURCE[%d] Usage: 0x%x = ", i, net_resource_item:dwUsage)
cc += iif( lAnd(net_resource_item:dwUsage , RESOURCEUSAGE_CONNECTABLE) , " connectable ","")
cc += iif( lAnd(net_resource_item:dwUsage , RESOURCEUSAGE_CONTAINER)   , " container "  ,"")


cc +=  cPrintf(,"\r\nNETRESOURCE[%d] Localname: %s", i, net_resource_item:lpLocalName)
cc +=  cPrintf(,"\r\nNETRESOURCE[%d] Remotename: %s", i, net_resource_item:lpRemoteName)
cc +=  cPrintf(,"\r\nNETRESOURCE[%d] Comment: %s", i, net_resource_item:lpComment)
cc +=  cPrintf(,"\r\nNETRESOURCE[%d] Provider: %s", i, net_resource_item:lpProvider)
cc +=  cPrintf(,"\r\n------------------------------------------------------------\r\n")
return cc
//----------------------------------------------------------------------------------------------------------------------
 

