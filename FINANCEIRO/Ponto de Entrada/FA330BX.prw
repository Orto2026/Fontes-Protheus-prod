/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA330BX   ³ Autor ³ Mauricio Prado        ³ Data ³ 29/05/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de Entrada na Compensacao CR                         ³±±
±±³          ³ Obs.: baseado no PE SACI008 					              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Prosintese                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FA330BX()

cAlias := GetArea()

Begin Transaction

DbSelectArea("SD2")
DbSetOrder(3)
DbSeek(xFilial("SD2")+SE1->E1_NUM+SE1->E1_PREFIXO)

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(xFilial("SC5")+SD2->D2_PEDIDO)    

dbSelectArea("SF2")
dbSetOrder(1)
dbSeek(SD2->D2_FILIAL+SD2->D2_DOC)
	
	


If SC5->C5_CLASPED == "3" 
	
	DbSelectArea("SE3")
	DbSetOrder(1)
	DbSeek(xFilial("SE3")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA,.F.)

	While !Eof() .and. 	SE3->E3_FILIAL == xFilial("SE3") .AND. SE3->E3_PREFIXO == SE1->E1_PREFIXO;
		.and.	SE3->E3_NUM == SE1->E1_NUM .and. SE3->E3_PARCELA == SE1->E1_PARCELA  
		
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbSeek(xFilial("SE1")+SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO)     
	
	DbSelectArea("SE5")
	DbSetOrder(7)
	DbSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA+SE3->E3_SEQ)
                                                                             

	nBaseCom := SE3->E3_BASE - ((SE5->E5_VALOR-SE5->E5_VLJUROS-SE5->E5_VLMULTA+SE5->E5_VLDESCO)*((SC5->C5_XDESPES+SC5->C5_XDESINS)/SF2->F2_VALBRUT))
	
	nValCom	 := ((nBaseCom * nPComis)/100)	
		
	nPComis  := SE3->E3_PORC
		
	
		
		RecLock("SE3",.F.)

			SE3->E3_BASE := nBaseCom
			SE3->E3_COMIS := nValCom
			SE3->E3_XDESPES := SC5->C5_XDESPES
			SE3->E3_DESINS := SC5->C5_XDESINS

		MsUnLock()
		
		SE3->(DbSkip())
	Enddo
EndIf

End Transaction

RestArea(cAlias)

Return
