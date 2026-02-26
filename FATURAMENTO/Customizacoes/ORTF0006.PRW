
/*/{Protheus.doc} Ortf0006
//TODO Retorno do campo virtual C9_XNREDUZ.
@author Pirolo
@since 23/04/2019
@version undefined
@return return, return_description
/*/
User Function Ortf0006()
Local aAreaSC5 	:= SC5->(GetArea())
Local aAreaSC9 	:= SC9->(GetArea())
Local cRet 		:= POSICIONE("SA1",1,XFILIAL("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA,"A1_NREDUZ")

DbSelectArea("SC5")
SC5->(DbSetOrder(1))

If SC5->(DbSeek(SC9->(C9_FILIAL+C9_PEDIDO)))
	
	If SC5->C5_TIPO == "B"
		cRet := POSICIONE("SA2",1,xFilial("SA2")+SC9->(C9_CLIENTE+C9_LOJA),"A2_NREDUZ")		
	EndIf

EndIf

RestArea(aAreaSC5)
RestArea(aAreaSC9)
Return cRet
