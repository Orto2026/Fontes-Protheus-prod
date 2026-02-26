#include "rwmake.ch"
#INCLUDE "MATA410.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"       
#INCLUDE "FWADAPTEREAI.CH"     
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "CRMDEF.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ExecBlock ³ EFATAXX  ³ Autor ³ Raphael Camillo Proto ³ Data ³ 28/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza os Campos TES conforme Regra do Tes Inteligente   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gatilho do Pedido de Venda Espec¡fico P/ ORTOSINTESE       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function EFATAXX()

Local _aAlias		:= GetArea()
Local _nC6Tes		:= 0
Local _xReturn 	    := Space(15)
Local _cTes			:= Space(3)
//Local _cCodTrib	:= ""


If Alltrim(SX7->X7_CAMPO) == "C6_PRODUTO"
	
	_nPProd		:= aScan(aHeader,{|x|Alltrim(x[2])=="C6_PRODUTO"})	
	_xReturn	:= If( TYPE('M->C6_PRODUTO')<> "U",M->C6_PRODUTO,aCols[n,_nPProd])
	_nC6Tes		:= aScan(aHeader,{|x|Alltrim(x[2])=="C6_TES"})
	_cTes		:= aCols[n,_nC6Tes]
	//_cLoja		:= M->C5_LOJACLI
	
	_cTes := MaTesInt( 2, M->C5_XOPER, M->C5_CLIENTE, M->C5_LOJACLI, "C", Alltrim(_xReturn), , M->C5_TIPOCLI ) // Obs: só funciona quando a operação M->C5_XOPER= 01
	
	// Iniciio Por Samuel Mirada -> 27/05/2021
	//Após a Atualização de Lib, a Função (MatesInt) passou a apresentar error
	//Como solução preventiva foi colocado um IF Para seleção direto na Tabela SFM
	If Empty(_cTes)

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+_xReturn)
		_cCodTrib := SB1->B1_GRTRIB                           
	
		dbSelectArea("SFM")
		dbSetOrder(1)
		dbSeek(xFilial("SFM")+M->C5_XOPER)
		While !Eof() .And. SFM->FM_TIPO == M->C5_XOPER
			If Empty(SFM->FM_GRPROD)
				_cTes	:= SFM->FM_TS
				Exit
			EndIf
				
			If AllTrim(SFM->FM_GRPROD) == AllTrim(_cCodTrib)
				_cTes	:= SFM->FM_TS
				Exit
			EndIf
			dbSkip()
		EndDo
	Endif // Fim Por Samuel Mirada -> 27/05/2021

	aCols[n,_nC6Tes] := _cTes
	
	RunTrigger(2,n,Nil,,"C6_TES")
	a410multt("C6_TES",_cTes)
	
	
ElseIf AllTrim(SX7->X7_CAMPO) == "CK_PRODUTO"   
	_xReturn 	:= M->CK_PRODUTO
	
	//TMP1->CK_TES := _cTes
	TMP1->CK_TES := MaTesInt( 2, M->CJ_XOPER, M->CJ_CLIENTE, M->CJ_LOJA, "C", Alltrim(_xReturn), , M->CJ_TIPOCLI )
	// INSERIDO PARA TRATA O CAMPO SITUAÇÃO TRIBUTARIA
	TMP1->CK_CLASFIS := SB1->B1_ORIGEM+Posicione("SF4",1,xFilial("SF4")+TMP1->CK_TES,"F4_SITTRIB")
	
	RunTrigger(2,TMP1->(RECNO()),Nil,,"CK_TES")
		
	
	
EndIf
RestArea(_aAlias)

Return(_xReturn)

User Function EFATAXXA()
//Não aplicar o gatilho se chamado pelos fontes de transferências
Return !IsInCallStack("A310Proc") .AND. !IsInCallStack("U_ORTF0010")  .AND. !IsInCallStack("U_Ortf0009")


/*
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+_xReturn)
	_cCodTrib := SB1->B1_GRTRIB                           
	
	dbSelectArea("SFM")
	dbSetOrder(1)
	dbSeek(xFilial("SFM")+M->C5_XOPER)
	While !Eof() .And. SFM->FM_TIPO == M->C5_XOPER
		If Empty(SFM->FM_GRPROD)
			_cTes	:= SFM->FM_TS
			Exit
		EndIf
			
		If AllTrim(SFM->FM_GRPROD) == AllTrim(_cCodTrib)
			_cTes	:= SFM->FM_TS
			Exit
		EndIf
		dbSkip()
	EndDo
	*/

/*
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+TMP1->CK_PRODUTO)
	_cCodTrib := SB1->B1_GRTRIB                           
	
	dbSelectArea("SFM")
	dbSetOrder(1)
	dbSeek(xFilial("SFM")+M->CJ_XOPER)
	While !Eof() .And. SFM->FM_TIPO == M->CJ_XOPER
		If Empty(SFM->FM_GRPROD)
			_cTes	:= SFM->FM_TS
			Exit
		EndIf
			
		If AllTrim(SFM->FM_GRPROD) == AllTrim(_cCodTrib)
			_cTes	:= SFM->FM_TS
			Exit
		EndIf
		dbSkip()
	EndDo
	*/


	/* DESABILITADO DEMA - 14/11/2017 -- USANDO A FUNCAO DO TES INTELIGENTE
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+_xReturn)
	_cCodTrib := SB1->B1_GRTRIB
	
	dbSelectArea("SFM")
	dbSetOrder(1)
	dbSeek(xFilial("SFM")+M->C5_XOPER)
	While !Eof() .And. SFM->FM_TIPO == M->C5_XOPER
		If Empty(SFM->FM_GRPROD) 	// .AND. SA1->A1_SUFRAMA = ""              // aguardando Fernanda criar TES suframa e grupos ZFx
			_cTes	:= SFM->FM_TS
			Exit
		EndIf
	
		If AllTrim(SFM->FM_GRPROD) == AllTrim(_cCodTrib) 	// .AND. SA1->A1_SUFRAMA = ""
			_cTes	:= SFM->FM_TS
			Exit
		EndIf

//		If AllTrim(SFM->FM_GRTRIB) == "ZF1" .AND. !Empty(SA1->A1_SUFRAMA)
//			_cTes	:= SFM->FM_TS
//			Exit
//		EndIf

		dbSkip()
	EndDo

*/
