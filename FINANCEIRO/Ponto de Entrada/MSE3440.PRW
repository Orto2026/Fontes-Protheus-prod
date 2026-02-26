/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MSE3440   ³ Autor ³ Mauricio Prado        ³ Data ³29/05/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de Entrada na rotina de Recalculo das comissoes      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Prosintese                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MSE3440()

local areaSD2 := SD2->(getarea())
local areaSC5 := SC5->(getarea())
local areaSF2 := SF2->(getarea())
local areaSE1 := SE1->(getarea())
local areaSE5 := SE5->(getarea())
local areaSC6 := SC6->(getarea())

Local nPComis := 0
Local nTotalPed := 0             
//Local nPAdm := 0

 	nPComis	:= SE3->E3_PORC
	
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(SE3->E3_FILIAL+SE3->E3_NUM+SE3->E3_PREFIXO)
	
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(SD2->D2_FILIAL+SD2->D2_PEDIDO) 
	
	dbSelectArea("SF2")
	dbSetOrder(1)
	dbSeek(SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE)
	
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbSeek(xFilial("SE1")+SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO)     
	
	DbSelectArea("SE5")
	DbSetOrder(7)
	DbSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA+SE3->E3_SEQ)

	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(SD2->D2_FILIAL+SD2->D2_PEDIDO)

	If SC5->C5_NOTA != SE1->E1_NUM .AND. SC5->C5_CLASPED $ "3/6"

		While !Eof() .And. SC6->C6_FILIAL+SC6->C6_NUM == SD2->D2_FILIAL+SD2->D2_PEDIDO // verificar residuo
			nTotalPed += SC6->C6_VALOR	
			dbSkip()
		Enddo
		
		nBaseCom := SE3->E3_BASE - (SE3->E3_BASE*((SC5->C5_XDESPES+SC5->C5_XDESINS)/nTotalPed))

		SE3->E3_XBAIXA := (SE5->E5_VALOR-SE5->E5_VLJUROS-SE5->E5_VLMULTA+SE5->E5_VLDESCO)
		SE3->E3_XPERC  := ((SC5->C5_XDESPES+SC5->C5_XDESINS)/nTotalPed)
		SE3->E3_XDESCON:= (SE3->E3_BASE*((SC5->C5_XDESPES+SC5->C5_XDESINS)/nTotalPed))
		SE3->E3_XVALPED:= nTotalPed

	else
		
		nBaseCom := SE3->E3_BASE - ((SE3->E3_BASE)*((SC5->C5_XDESPES+SC5->C5_XDESINS)/SF2->F2_VALBRUT))
		
		SE3->E3_XBAIXA := (SE5->E5_VALOR-SE5->E5_VLJUROS-SE5->E5_VLMULTA+SE5->E5_VLDESCO)
		SE3->E3_XPERC  := ((SC5->C5_XDESPES+SC5->C5_XDESINS)/SF2->F2_VALBRUT)
		SE3->E3_XDESCON:= (SE3->E3_BASE*((SC5->C5_XDESPES+SC5->C5_XDESINS)/SF2->F2_VALBRUT))
		SE3->E3_XVALPED:= SF2->F2_VALBRUT

	endIf
*/
	nValCom	 := ((nBaseCom * nPComis)/100)				
	
	SE3->E3_BASE   := nBaseCom
	SE3->E3_COMIS  := nValCom
	SE3->E3_PORC   := nPComis
	SE3->E3_XDESPES:= SC5->C5_XDESPES
	SE3->E3_DESINS := SC5->C5_XDESINS
	

	nTotalPed := 0


RestArea(areaSD2)  
RestArea(areaSC5)
RestArea(areaSF2)
RestArea(areaSE1)
RestArea(areaSE5)
RestArea(areaSC6)

Return
