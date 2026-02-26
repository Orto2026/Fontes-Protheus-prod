#INCLUDE "PROTHEUS.CH"
#Include "rwmake.Ch"

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºRotina    ³ DTMAT03     ºAuto ³Samuel Miranda     º Data ³ 03/12/2019  º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºDescricao ³ Tela de impressão de etuiquetas apartir da OP              º±±//
//±±º              com o codigo de barras Datamatrix                        º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±±±±±±±±±±±±±±±±±±±±±          PARAMENTROS            ±±±±±±±±±±±±±±±±±±±±±±//
// _cOP		= Número da Ordem de produção
// _cLang	= Idioma
// _nQtdCop	= Quantidade de Copias
// _nQtEmb	= Quantidade de peção por embalagem
// _dDtFab	= Data da fabricação
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//

User Function DTMAT03()	
Local _cOP 		:= ""
Local _cLang	:= ""
Local _nQtdCop 	:= 1
Local _nQtEmb 	:= 0
Local _aCbx 	:= {"1-Português", "2-Inglês", "3-Espanhol"}
Local _dDtFab	:= nil

//Local _nQtd3	:= 1
//RpcSetType(3)
//RpcSetEnv("01", "01")

_dDtFab	:= dDatabase
_cOP 	:= Space(LEN(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))

Private oDlg1, oOP, oLang, oQtde,oEmb, oSair

DEFINE MSDIALOG oDlg1 TITLE "Impressão de Etiquetas DataMatrix" FROM 200,70 TO 425,450 PIXEL
@ 003, 4 To 110,190
//@ 003, 4 To 110,187
@ 010, 10 SAY "Ordem de Produção " 	SIZE 70,50
@ 030, 10 SAY "Idioma " 			SIZE 50,50
@ 050, 10 SAY "Qtde. Etiquetas" 	SIZE 50,50 			
@ 050, 90 SAY "Pcs / Embalagem" 	SIZE 50,50
@ 070, 10 SAY "Data Fabricação "	SIZE 50,50

@ 010, 060 MSGET 		oOP  	VAR _cOP 		F3 "SC2" PICTURE "@!" VALID ValidOP(_cOP) SIZE 80,7 OF oDlg1 PIXEL
@ 025, 060 MSCOMBOBOX 	oLang 	VAR _cLang  	ITEMS 	_aCbx SIZE 075, 65 	OF oDlg1 PIXEL
@ 050, 060 MSGET 		oQtde	VAR _nQtdCop	PICTURE "999" SIZE 20,7 	OF oDlg1 PIXEL
@ 050, 140 MSGET 		oEmb	VAR _nQtEmb		PICTURE "999" SIZE 20,7 	OF oDlg1 PIXEL
@ 070, 060 MSGET 		oDtFab	VAR _dDtFab		PICTURE "@D" VALID !Empty(_dDtFab) SIZE 60,7 OF oDlg1 PIXEL

//@ 090, 050 Button oOK  	Prompt "&Imprimir" 	Size 25, 13 Action ChkOpc(_cOP, _cLang, _nQtd2, _dDtFab, _nQtd) OF oDlg1 PIXEL
@ 090, 050 Button oOK  	Prompt "&Imprimir" 	Size 25, 13 Action ChkOpc(_cOP, _cLang,_dDtFab,_nQtEmb,_nQtdCop) OF oDlg1 PIXEL
@ 090, 110 Button oSair	Prompt "&Sair" 		Size 25, 13 Action Close(oDlg1) OF oDlg1 PIXEL

@ 100, 145 SAY "By | TI Ortosintese"
ACTIVATE MSDIALOG oDlg1 CENTERED

DlgRefresh(oDlg1)

Return

//Rotina que dispara a impressão das etiquetas conforme parametros indicados pelo cliente.
Static Function ChkOpc(_cNumOP, _cLang,_dDtFab,_nQtEmb,_nQtdCop)

dbSelectArea("SC2")
dbSetOrder(1)
If dbSeek(xFilial("SC2")+(Substr(_cNumOP,1,8)+'001'))

	_nLang := Val(SubStr(_cLang,1,1)) // Trasforma caracter(Númerico) em Número.
	_nQuant := SC2->C2_QUANT    	  // Pega a quantidade de rotulos conforme a quantidade de Peças na OP

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
	//If FieldPos("B1_XQTETIQ") <> 0
		//dbSelectArea("SB5")
		//dbSetOrder(1)
		//If dbSeek(xFilial("SB5")+SB1->B1_COD)
			//_nQtdEmb := SB5->B5_QEI
		//Else
			//_nQtdEmb := 1
		//EndIf
	//EndIf
	//_nQtdEmb := SB1->B1_XQE
    	RptStatus({|lEnd| U_DT03PRINT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtEmb,_nLang,_dDtFab,dDatabase,_nQtdCop,)},"Imprimindo, aguarde...")
EndIf


//_nLang := Val(SubStr(_cLang,1,1))

//RptStatus({|lEnd| U_DT03PRINT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtEmb,_nLang,_dDtFab,dDatabase,_nQtdCop,)},"Imprimindo, aguarde...")

_cOP     := Space(LEN(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
_nLang   := 1
_nQtd    := 1
_nQtdEmb := 0

Return()

//Verifica se a OP é valida
Static Function ValidOP(_cNumOP)
	
	If Empty(_cNumOP)
		Return(.T.)
	EndIf

	dbSelectArea("SC2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SC2")+(Substr(_cNumOP,1,8)+'001'))
		Alert("Ordem de Produçao nao Encontrada...")
		Return(.F.)
	EndIf

Return(.T.)
