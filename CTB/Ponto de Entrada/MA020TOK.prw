#INCLUDE "rwmake.ch"
#INCLUDE "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  MA020TOK  ºAutor  ³Thinkfast		    	  º Data ³  12/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava item contabil na inclusao de fornecedores novos       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA020TOK()

Local _aArea		:= GetArea()
Local _aAreaCTD	:= GetArea("CTD")

DbSelectArea("CTD")
DbSetOrder(1) // CTD_FILIAL+CTD_ITEM
	
If !Dbseek(xFilial('CTD')+"F"+M->A2_COD+M->A2_LOJA)
	RecLock("CTD",.T.)
	CTD->CTD_FILIAL	:= xFilial("CTD")
	CTD->CTD_ITEM		:= "F"+M->A2_COD+M->A2_LOJA
	CTD->CTD_CLASSE	:= "2"    	    // ANALITICA
	CTD->CTD_NORMAL	:= "1"  		// TIPO=DESPESA
	CTD->CTD_BLOQ		:= "2"
	CTD->CTD_ITLP		:= "F"+M->A2_COD+M->A2_LOJA
	CTD->CTD_ITSUP		:= "2" 			// DESPESAS 
Else
	RecLock("CTD",.F.)		
EndIf
CTD->CTD_DESC01 := M->A2_NOME

MsUnlock()
		
RestArea(_aAreaCTD)
RestArea(_aArea)

Return(.t.)