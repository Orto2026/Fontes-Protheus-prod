/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT110LOK ºAutor  ³  Mauricio Prado	 º Data ³  18/10/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada na linha do Solict de Compras para obrigarº±±
±±º          ³ usuario a digitar o numero da OP para produtos BN		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ortositese                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT110LOK()
Local _aArea    := GetArea()//samuel
Local _aAreaSB1 := SB1->(GetArea())//samuel
Local nPosPrd	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'}) 
Local nPosOp	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_OP'})
Local nPosDel	:= aCols[n][Len(aHeader)+1] //samuel
Local cProd		:= aCols[n][nPosPrd]
Local cOp		:= aCols[n][nPosOp]
Local lRet		:= .T.
//Local I

If Substr(cProd,1,2) == 'BN' .And.  Empty(cOp)
	Alert("Para produtos tipo BN deve ser digitado o numero da OP")
	lRet := .F.
EndIf

// Verifica se o produto esta com status de Descontinuado. Por - Samuel Miranda 23/06/2021 para atender chamado numero  12785
If nPosDel <> .T.
	DbSelectArea("SB1")
	SB1->(dbSetOrder(1)) //B1_FILIAL + B1_COD
		If SB1->(DBSeek(xFilial("SB1")+cProd) .AND. SB1->B1_XDESCEN ="1")
		Aviso("Atenção !","Produto descontinuado! ",{"Ok"})
		lRet := .F. 
		RunTrigger(2,n,Nil,,"C1_PRODUTO")  
	EndIf
EndIf

//Comentado por Wagner Alves em 18/10/2018, pois nao se aplica no cliente - chamados 2546 e 2576
/*       
For I := 1 to Len(aCols)
	
	If !aCols[I,Len(aHeader)+1] .And. I <> n .And. cProd == aCols[I][nPosPrd]
		Alert("O Produto Digitado ja foi informado nesta Solicitação - Item: "+StrZero(I,3))
		lRet := .F.
		Exit
	EndIf
Next I
*/
RestArea(_aAreaSB1)//samuel
RestArea(_aArea)//samuel

Return(lRet) 
