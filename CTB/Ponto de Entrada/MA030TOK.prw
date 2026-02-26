#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA030TOK  ºAutor  ³Thinkfast'''''''''  º Data ³  11/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava item contabil na inclusao de clientes novos			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA030TOK()

Local _aArea		:= GetArea()
Local _aAreaCTD	:= GetArea("CTD")

If Empty(M->A1_CGC) .And. M->A1_EST <> "EX"
	Aviso("Atencao","Informa o CNPJ do Cliente!!!",{"OK"},1,"CNPJ Obrigatório!")
	Return(.F.)
EndIf

DbSelectArea("CTD")
DbSetOrder(1) // CTD_FILIAL+CTD_ITEM
	
If !Dbseek(xFilial('CTD')+"C"+M->A1_COD+M->A1_LOJA)
	RecLock("CTD",.T.)
	CTD->CTD_FILIAL	:= xFilial("CTD")
	CTD->CTD_ITEM		:= "C"+M->A1_COD+M->A1_LOJA
	CTD->CTD_CLASSE	:= "2"    	    // ANALITICA
	CTD->CTD_NORMAL	:= "2"  		// TIPO=RECEITA
	CTD->CTD_ITLP		:= "C"+M->A1_COD+M->A1_LOJA
	CTD->CTD_BLOQ 		:= "2"
	CTD->CTD_ITSUP		:= "1" 			// RECEITAS
Else
	RecLock("CTD",.F.)
EndIf

CTD->CTD_DESC01 := M->A1_NOME

MsUnlock()
		
RestArea(_aAreaCTD)
RestArea(_aArea)

Return(.T.)