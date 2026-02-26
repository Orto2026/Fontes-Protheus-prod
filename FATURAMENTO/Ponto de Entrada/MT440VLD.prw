#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT440VLD  บ Autor ณ AP6 IDE            บ Data ณ  07/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada para estornar os SC9 antes de nova libera บฑฑ
ฑฑบ          ณ cao para poder criar Liberacoes por Qyde em  Estoque       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MT440VLD

Local _aArea := GetArea()

If GetMv("MV_AVALEST") == 1

	_cQuery := " SELECT C9_PEDIDO, C9_ITEM "
	_cQuery += " FROM "
	_cQuery +=  RetSqlName("SC9") + " SC9 "
	_cQuery += " INNER JOIN "+RetSqlName("SC6") + " SC6 "
	_cQuery += " ON C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO AND C6_ITEM = C9_ITEM AND SC6.D_E_L_E_T_ = ' ' AND C6_ENTREG BETWEEN '"+Dtos(MV_PAR06)+"' AND '"+Dtos(MV_PAR07)+"' "
	_cQuery += 	" WHERE C9_FILIAL = '"+xFilial("SC9")+"' "
	_cQuery += " AND C9_PEDIDO BETWEEN '"+Mv_Par02+"' AND '"+Mv_Par03+"' "
	_cQuery += " AND C9_CLIENTE BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
	_cQuery += " AND C9_BLEST <> ' ' AND C9_BLEST <> '10' "
	_cQuery += " AND C9_LOCAL = '01' "
	_cQuery += " AND SC9.D_E_L_E_T_ = ' ' "
	
	_cQuery += " AND NOT EXISTS ( "
	_cQuery += "     SELECT 1 "
	_cQuery += "     FROM "
	_cQuery +=  RetSqlName("SC9") + " A "
	_cQuery += "     WHERE A.C9_FILIAL  = SC9.C9_FILIAL  "
	_cQuery += "     AND A.C9_PEDIDO  = SC9.C9_PEDIDO "
	_cQuery += "     AND A.C9_ITEM = SC9.C9_ITEM "
	_cQuery += "     AND A.D_E_L_E_T_ = ' ' "
	_cQuery += "     AND A.C9_BLEST = ' ' ) "
	
	_cQuery := ChangeQuery( _cQuery )
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"QUERY", .F., .T.)
	
	dbSelectArea("QUERY")
	dbGotop()
	While !Eof()

		dbSelectArea("SC9")
		dbSetOrder(1)
		If MsSeek(xFilial("SC9")+QUERY->C9_PEDIDO+QUERY->C9_ITEM)
			SC9->(a460Estorna())
		Endif
	
		dbSelectArea("QUERY")
		dbSkip()
	EndDo

	dbCloseArea()	
EndIf

RestArea(_aArea)

Return(.T.)
