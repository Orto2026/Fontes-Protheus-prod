#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'TOPCONN.CH'
#INCLUDE "PROTHEUS.CH"
/*/{Protheus.doc} M521DNFS
//TODO Descrição auto-gerada.
@author Pirolo
@since 16/05/2019
@return return, return_description
/*/
User function M521DNFS
Local aAreaSC9 	:= SC9->(GetArea())
Local aAreaSC6 	:= SC6->(GetArea())
Local cQry		:= ""

DbSelectArea("SC6")
SC6->(DbSetOrder(1))//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO

If SC6->(DbSeek(xFilial("SC6")+SC9->(C9_PEDIDO+C9_ITEM+C9_PRODUTO))) .AND. Empty(SC9->C9_XLIBPED)
	cQry := "Update "+RetSqlName("SC9")+"           		"+CRLF
	cQry += "set C9_XLIBPED = '"+DTOS(SC6->C6_XLIBPED)+"' 	"+CRLF
	cQry += "WHERE C9_PEDIDO = '"+SC9->C9_PEDIDO+"' 		"+CRLF
	cQry += "AND   C9_FILIAL = '"+SC9->C9_FILIAL+"' 		"+CRLF
	cQry += "AND   D_E_L_E_T_ <> '*'                		"+CRLF
	cQry += "AND   C9_XLIBPED = ''                  		"+CRLF
	cQry += "AND   C9_DATALIB = '"+dtos(date())+"'  		"
	
	TCSQLExec(cQry)
EndIf

RestArea(aAreaSC9)
RestArea(aAreaSC6)
Return
