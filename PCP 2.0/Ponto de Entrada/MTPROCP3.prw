#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTPROCP3 º Autor ³ AP6 IDE            º Data ³  11/04/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada no Momento da Montagem da Tela de saldo   º±±
±±º          ³ a devolver em 3o                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ORTOSINTESE                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MTPROCP3()

Local _lRet 	:=  .T.
Local _cAlias 	:= PARAMIXB[1]
Local _cLote	:= (_cAlias)->LOTECTL
Local _aArea	:= GetArea()
Local _aAreaD2	:= SD2->(GetArea())
Local _aAreaDC	:= SDC->(GetArea())
Local _cProd	:= GdFieldGet("D1_COD")
Local _cLocal	:= GdFieldGet("D1_LOCAL")
Local _cOP		:= GdFieldGet("D1_OP")
Local _nRegD2	:= (_cAlias)->SD2RECNO

If AllTrim(Funname()) $ "MATA103/XMLNFE" .And. !Empty(_cOp)
	_lRet :=  .F.	
	dbSelectArea("SD2")
	dbGoto(_nRegD2)
	
	dbSelectArea("SDC")
	dbSetOrder(1)
	//DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI
	If dbSeek(xFilial("SDC")+_cProd+_cLocal+Padr("SC2",Len(SDC->DC_ORIGEM))+SD2->D2_PEDIDO+SD2->D2_ITEM) .And. AllTrim(SDC->DC_OP) == AllTrim(_cOP)
		_lRet :=  .T.
	EndIf

EndIf

RestArea(_aAreaDC)
RestArea(_aAreaD2)
RestArea(_aArea)
Return(_lRet)