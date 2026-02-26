#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MA415BUT ³ Autor ³ Raphael Camillo - Dema³ Data ³ 02/04/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Adciona Botons na Enchoice da tela Orcamento de Vendas     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA415BUT()

Local aButtonsAtu := {}

aadd(aButtonsAtu,{"BMPDEL",{|| U_xExpStru("O")},"Exp. Estrutura","Exp. Estrutura"})

Return(aButtonsAtu)

User Function xExpStru()

dbSelectArea("TMP1")
_nRegAtu := Recno()

dbSelectArea("SG1")
dbSetOrder(1)
If !dbSeek(xFilial("SG1")+TMP1->CK_PRODUTO)
	Alert("Esse Produto nao contem estrutura cadastrada...")
Else
	_cCodigo	:= TMP1->CK_PRODUTO
	_CodTab		:= M->CJ_TABELA  //Pega o codigo da tabela na memoria -- Samuel Miranda 08/04/2020
	_cMoeda		:= M->CJ_MOEDA   //Pega o codigo da moeda na memoria -- Samuel Miranda 08/04/2020
	While !Eof() .And. SG1->G1_COD == _cCodigo
	
		RecLock("TMP1",.T.)
//		TMP1->CK_FILIAL	:= xFilial("SCK")
		TMP1->CK_ITEM		:= StrZero(RECNO(),Len(CK_ITEM))
		TMP1->CK_PRODUTO	:= SG1->G1_COMP
		TMP1->CK_UM			:= Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_UM")
		TMP1->CK_QTDVEN		:= SG1->G1_QUANT
		TMP1->CK_PRCVEN		= Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_PRV1")
		
		If TMP1->CK_PRCVEN == 0
			// Adicionado para pegar o valor da Tabela de preço -- Samuel Miranda 08/04/2020
			DbSelectArea("DA1")
			DA1->(dbSetOrder(2))
			If !Empty(_CodTab)  
				iF DA1->(dbSeek(xFilial("DA1")+TMP1->CK_PRODUTO+_CodTab)) = .T. .AND. DA1->DA1_MOEDA = _cMoeda  
					
					TMP1->CK_PRCVEN	 := DA1->DA1_PRCVEN	
				Else 
					TMP1->CK_PRCVEN	 := 1
				EndIf
			EndIf	
			//TMP1->CK_PRCVEN	:= 1
		EndIf
		TMP1->CK_OPER		:= M->CJ_XOPER
		TMP1->CK_VALOR		:= TMP1->CK_QTDVEN * TMP1->CK_PRCVEN    
		TMP1->CK_XCLASPD	:= M->CJ_XCLASPD //Por Samuel Miranda 20190417
		TMP1->CK_ENTREG		:= M->CJ_XDTENTR //Por Samuel Miranda 20190417
		TMP1->CK_TES		:= MaTesInt(2,M->CJ_XOPER,M->CJ_CLIENTE,M->CJ_LOJA,"C",TMP1->CK_PRODUTO,"CK_TES")
		TMP1->CK_LOCAL		:= Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_LOCPAD")
		TMP1->CK_DESCRI		:= Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_DESC")
		TMP1->CK_FILVEN		:= cFilAnt
		TMP1->CK_FILENT		:= cFilAnt
		TMP1->CK_DT1VEN		:= dDataBase
		TMP1->CK_TPPROD		:= "1"
		TMP1->CK_FLAG		:= .F.
		MsUnlock()
		
		dbSelectArea("SG1")
		dbSkip()
	EndDo

	dbSelectArea("TMP1")
	dbGoto(_nRegAtu)
	RecLock("TMP1",.F.)
	TMP1->CK_FLAG := .T.
	MsUnlock()
	dbGotop()

EndIf
nBRLIN := RecCount()
dbGotop()
oGetDad:Refresh(.T.)
oGetDad:ALASTEDIT[1] 	:= nBRLIN
oGetDad:NCOUNT 			:= RecCount()
oGetDad:LDELETA 			:= .F.

Return()
