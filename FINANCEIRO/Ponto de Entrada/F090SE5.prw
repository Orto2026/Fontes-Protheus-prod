User Function F090SE5()

Local 	a_AreaATU := GetArea() 
Local 	a_AreaSE2 := SE2->(GetArea())
Local aRecno := ParamIxb[1]
Local nCntFor :=0 

dbSelectArea("SE5")
DbSetOrder(1)

For nCntFor := 1 to Len(aRecno)
SE5->(dbGoto(aRecno[nCntFor]))

//MSGAlert("Titulo posicionado na SE5 Filial:" + SE5->e5_filial + Chr(13)+Chr(10) + ", Data,"+ DtOC(SE5->e5_data) + Chr(13)+Chr(10) + ", Tipo," + SE5->e5_tipo + Chr(13)+Chr(10) + ", Moeda" + SE5->e5_moeda + Chr(13)+Chr(10) + ", Valor," + str(SE5->e5_valor ) + Chr(13)+Chr(10) + ", Natureza," + SE5->e5_natureza + Chr(13)+Chr(10) + ", Numero do cheque," + SE5->e5_numcheq + Chr(13)+Chr(10) + ", Documento," + SE5->e5_documen ) 

dbSelectArea("SE2")
dbSetOrder(1)
dbSeek(xFilial("SE2")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)

//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA                                                                                               

Reclock("SE5",.F.)
SE5->E5_XUNID :=  SE2->E2_XUNID
SE5->E5_CCD   :=  SE2->E2_CCD 
MsUnlock()

Next nCntFor

RestArea(a_AreaATU)                
RestArea(a_AreaSE2)

Return
