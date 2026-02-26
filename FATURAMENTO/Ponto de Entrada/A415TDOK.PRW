#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºRotina ³  A415TDOK      ºAutor  ³ Samuel Miranda  º Data ³ 09/10/2019  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDescricao ³ Ponto de entrada para 									  º±±
±±º			   gravar o valor do desconto 	 							  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso    ³ Ortosintese - Comercial						                  º±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ	
*/ 
User Function A415TDOK()

Local lRet 		:= .T.                     
Local nReg 		:= 0
Local aAreaTmp1	:= TMP1->(GetArea())
Local aArea   	:= GetArea()
Local nTotVal 	:= 0
Local nTotDesc	:= 0

// Soma o os valores e os descontos, mostrando-os na tela?
dbSelectArea("TMP1")
dbGotop()
While ( !Eof() )
	If ( !TMP1->CK_FLAG )
		nTotVal  += TMP1->CK_VALOR
		If (TMP1->CK_PRUNIT > TMP1->CK_PRCVEN)
			nTotDesc += A410Arred((TMP1->CK_PRUNIT * TMP1->CK_QTDVEN),"CK_VALOR") - A410Arred((TMP1->CK_PRCVEN * TMP1->CK_QTDVEN),"CK_VALOR")
		Else
			nTotDesc += TMP1->CK_VALDESC
		EndIf
	EndIf
	dbSelectArea("TMP1")
	dbSkip()
EndDo
	nTotDesc += M->CJ_DESCONT
	nTotVal  -= M->CJ_DESCONT
	//Adiciona o valor da variavel de desconto no campo CJ_XTOTDES
	M->CJ_XTOTDES := nTotDesc

RestArea(aArea)
Return (lRet)

