#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
proc dbesys;return
//----------------------------------------------------------------------------------------------------------------------
proc main()
local mask := getenv( "test-recurse-dir-file-mask" ) 
local root := getenv( "test-recurse-dir-root-folder" ) 
local log  := getenv( "test-recurse-dir-log-file" ) 
local cc 

if empty(mask) 
   mask := "*.*"
end
if empty( root)
   root :=  ot4xb_curdir()
end

if empty( log )
   log  :=  cPathCombine( cAppPath() , "test-recurse-dir.log" )
end               
               
cc := recurse_directory( root , mask )
lMemoWrite( log , cc )

inkey(0)
return
//----------------------------------------------------------------------------------------------------------------------
function recurse_directory( root , mask )
local fd := WIN32_FIND_DATA():new()
local cargo     := _var2con({""})
local cb        := _var2con( {|lp,fld,pf|   fd:_link_(pf,.F.) ,on_recurse_directory_item(lp,fld,fd) } )
local result    := _var2con(NIL)
                                                                                               
@ot4xb:ot4xb_recurse_dir_ex(root,mask,nGetProcAddress("ot4xb","ot4xb_recurse_dir_item_codeblock"),{cb,cargo,result} , 0x10001 )

cargo     := _conRelease( cargo   ) 
cb        := _conRelease( cb      ) 
result    := _conRelease( result  ) 
return cargo[1]
// -----------------------------------------------------------------------------------------------------------------
function on_recurse_directory_item( cargo,folder,fd) 
local fqfn := cPathCombine(folder,fd:cFileName)
? fqfn
cargo[1] += fqfn + CRLF
return .F.