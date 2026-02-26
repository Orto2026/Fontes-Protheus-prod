

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºRotina ³  MT120LOK      ºAutor  ³ Samuel Miranda  º Data ³ 15/06/2021  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Descricao | Ponto de entrada  responsável pela validação de cada linha º±±
++   da GetDados do Pedido de Compras                               	  º±±
±±º			    							                              º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso    ³ Ortosintese - Comercial						                  º±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/ 

User Function  MT120LOK()

Local nPosPrd := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRODUTO' })
Local nPosOp  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_OP' })
//Local nPosItem := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEM' })
Local _nProdt := Alltrim(aCols[n][nPosPrd])
Local _nOp := Alltrim(aCols[n][nPosOp])
Local lValido := .T.

//Seleciona a Tabela de produtos, para verificar se o produto esta ou não descontinuado. //Por Samuel Miranda
DbSelectArea("SB1")
SB1->(dbSetOrder(1)) //B1_FILIAL + B1_COD  (Indice 1 da tabela de PRODUTOS)
If SB1->(DBSeek(xFilial("SB1")+_nProdt) .AND. SB1->B1_XDESCEN =="1")
    //Mensagem ao usuário informando que o produto encontra-se descontinuado.
    Aviso("Atenção !","Produto :"+_nProdt+"  Descontinuado! ",{"Ok"})
    lValido := .F.   
EndIf

If SB1->(DBSeek(xFilial("SB1")+_nProdt) .AND. SB1->B1_TIPO =="BN" .AND. Empty(_nOp))
    //Mensagem ao usuário informando que o produto encontra-se descontinuado.
    Aviso("Atenção !","Produto :"+_nProdt+"  Informe o campo OP! ",{"Ok"})
    lValido := .F.   
EndIf

Return(lValido) 

/*
dbSelectArea('SC7')
dbSetOrder(4)
If MsSeek(xFilial('SC7')+aCols[n][nPosPrd]+cA120Num+aCols[n][nPosItem])     
    If (C7_QUJE > 0) .Or. (C7_RESIDUO == 'S') .Or. (C7_QTDACLA > 0)          
    lValido := .F.     
    EndIf
EndIf 
*/
