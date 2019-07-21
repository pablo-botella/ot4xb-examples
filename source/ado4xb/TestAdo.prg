#include "ot4xb.ch"
//----------------------------------------------------------------------------------------------------------------------
proc dbesys ; return // no need dbe
//----------------------------------------------------------------------------------------------------------------------
proc main
local ado
SET CHARSET TO ANSI
SET EXACT ON

ado := ado4xb():New()
? ado:m_conn
? ado:open('Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Whales.xls;Extended Properties="Excel 8.0;HDR=Yes;IMEX=0;"')
? ado:exec("SELECT * FROM [Whales$]")
ado:release()
? ado:m_conn
inkey(0)


return
//----------------------------------------------------------------------------------------------------------------------
