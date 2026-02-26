User Function MA650TOK

Local lRet := .T.

Local _aArea  	:= GetArea()
Local _aAreaC2	:= SC2->(GetArea())
Local _aAreaB1	:= SB1->(GetArea())


_cOPC	  := M->C2_OPC
M->C2_XOPC  := _cOPC

If Inclui
	dbSelectArea("SC2")
	dbSetOrder(12)
		If dbSeek(xFilial("SC2")+M->C2_LOTECTL)
			Aviso("Atenção !","Lote informado já existe na base de dados. Verifique o Lote: "+M->C2_LOTECTL,{"Ok"})
			lRet := .F.
		EndIf
	//Por samuel Miranda dia 09/12/2021
	DbSelectArea("SB1")
	SB1->(dbSetOrder(1)) //B1_FILIAL + B1_COD
	If SB1->(DBSeek(xFilial("SB1")+Alltrim(M->C2_PRODUTO)) .AND. SB1->B1_XDESCEN ="1")
	
		Alert("Produto descontinudo","A T E N Ç Ã O")
		lRet := .F. 
	
	EndIf	

	//Por Mauricio Prado dia 19/10/2023
	DbSelectArea("SG1")
	SG1->(dbSetOrder(1)) //G1_FILIAL + G1_COD
	If !DBSeek(xFilial("SG1")+Alltrim(M->C2_PRODUTO))
	
		Alert("Produto sem estrutura","A T E N Ç Ã O")
		lRet := .F. 
	
	EndIf

endif
/*
If !       
	lRet := .F.
EndIf
*/

RestArea(_aArea)
RestArea(_aAreaC2)
RestArea(_aAreaB1)

Return(lRet)
