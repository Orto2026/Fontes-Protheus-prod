/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA650EMP  ºAutor  ³Microsiga           º Data ³  12/15/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para Apagar os Empenhos dos produtos BN (Ex Fantasmas)  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ORTOSINTESE                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/        

User Function MA650EMP()

Local aArea 	:= GetArea()
Local aAreaB1 	:= SB1->(GetArea())
Local aAreaB2	:= SB2->(GetArea())
Local aAreaB8 	:= SB8->(GetArea())
Local I
Local _aEmbs
Local cOp

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial("SD4")+SD4->D4_OP)

cOp 	:= SD4->D4_OP
_aEmbs 	:= {}

While !EoF() .AND. SD4->D4_OP == cOp
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SD4->D4_COD)

	If AllTrim(SB1->B1_TIPO) == "BN" .And. AllTrim(SB1->B1_LOCPAD) $ "96/97" 
		dbSelectArea("SB2") 
		dbSetOrder(1) // B2_FILIAL+B2_COD+B2_LOCAL
		If dbSeek(SD4->(D4_FILIAL+D4_COD+D4_LOCAL))
			Reclock("SB2",.F.)
			SB2->B2_QEMP -= SD4->D4_QUANT
			MsUnlock()
		EndIf
		
		dbSelectArea("SD4")
		RecLock("SD4",.F.)
		DbDelete()
		MsUnLock()
	EndIf

	If AllTrim(SB1->B1_TIPO) == "EM"
		If !Empty(SD4->D4_LOTECTL)
			dbSelectArea("SB8")
			dbSetOrder(3) // B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
			If dbSeek(SD4->(D4_FILIAL+D4_COD+D4_LOCAL+D4_LOTECTL))
				Reclock("SB8",.F.)
				SB8->B8_EMPENHO -= SD4->D4_QUANT
				MsUnlock()
			EndIf
		EndIf
		dbSelectArea("SD4")
		_nPos := aScan( _aEmbs, {|x| AllTrim(x[1]) == AllTrim(D4_COD) })
		If _nPos <> 0
			_aEmbs[_nPos,2] += D4_QUANT
		Else
			aAdd( _aEmbs, {D4_COD, D4_QUANT, D4_LOCAL, D4_OP, D4_DATA, D4_OPORIG, D4_PRODUTO, D4_ROTEIRO, D4_OPERAC} )
		EndIf
		RecLock("SD4",.F.)
//		SD4->D4_LOTECTL	:= ""
//		SD4->D4_DTVALID	:= Ctod("  /  /  ")
		DbDelete()
		MsUnlock()
	EndIf
	
	dbSelectArea("SD4")
	dbSkip()
EndDo

If Len(_aEmbs) > 0
	For I := 1 to Len(_aEmbs)
		dbSelectArea("SD4")
		RecLock("SD4",.T.)
		SD4->D4_FILIAL		:= xFilial("SD4")
		SD4->D4_COD			:= _aEmbs[I,1]
		SD4->D4_QUANT		:= _aEmbs[I,2]
		SD4->D4_QTDEORI		:= _aEmbs[I,2]
		SD4->D4_LOCAL		:= _aEmbs[I,3]
		SD4->D4_OP			:= _aEmbs[I,4]
		SD4->D4_DATA		:= _aEmbs[I,5]
		SD4->D4_OPORIG		:= _aEmbs[I,6]
		SD4->D4_PRODUTO		:= _aEmbs[I,7]
		SD4->D4_ROTEIRO		:= _aEmbs[I,8]
		SD4->D4_OPERAC		:= _aEmbs[I,9]
		MsUnlock()
	Next I
EndIf

RestArea(aAreaB8)
RestArea(aAreaB2)
RestArea(aAreaB1)
RestArea(aArea)
          
Return Nil 