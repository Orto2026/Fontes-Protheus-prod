

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Função   ³ ACDA30VE  ³ Autor ³ samuel Miranda    ³ Data ³ 12/01/2022  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Descrição ³ Ponto de entrada não criar metre 						  ³±±
±±³ de inventrario de em endereço bloqueado                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function ACDA30VE()
Local _aArea 	:= GetArea()
Local _aAreaSBE := SBE->(GetArea())
Local lRet:= .T.

// CustomizaÃ§Ãµes do usuÃ¡rio
dbSelectArea("SBE")
dbSetOrder(1)

	If dbSeek(xFilial("SBE")+SBE->BE_LOCAL+SBE->BE_LOCALIZ) .AND. SBE->BE_MSBLQL == '1' 
		//_eNdereco := SBE->BE_LOCALIZ	
		//cMsg := 'O Endereço    '
		//cMsg += '<b>' + _eNdereco+"  Está bloqueado."+'</b>'
		//cMsg += '<br>'
		//cMsg +='      '
		//FWAlertInfo( cMsg, 'A T E N Ç Ã O' )	
		//MsgAlert(cText, cTitle)
		lRet:= .F.
	EndIf

RestArea(_aAreaSBE)
RestArea(_aArea)

Return (lRet)
