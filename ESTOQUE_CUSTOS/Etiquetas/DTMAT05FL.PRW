#INCLUDE "PROTHEUS.CH"
#Include "rwmake.Ch"

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºRotina    ³ MATR05OP     ºAuto ³Samuel Miranda    º Data ³ 03/12/2019 º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºDescricao ³ Tela de impressão de etuiquetas PAI /FILHO apartir da OP   º±±//
//±±º              com o codigo de barras data matrix                       º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//

User Function DTMAT05FL()	
Local _cOP 		:= ""
Local _cLang	:= ""
Local _nQtd 	:= 1
//Local _nQtd2 	:= 0
Local _aCbx 	:= {"1-Português", "2-Inglês", "3-Espanhol"}
Local _dDtFab	:= nil

//Local _nQtd3	:= 1
//RpcSetType(3)
//RpcSetEnv("01", "01")

_dDtFab	:= dDatabase
_cOP 	:= Space(LEN(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))

Private oDlg1, oOP, oLang, oQtde, oSair

DEFINE MSDIALOG oDlg1 TITLE "Impressão de Etiquetas DataMatrix" FROM 200,70 TO 425,450 PIXEL
@ 003, 4 To 110,190
//@ 003, 4 To 110,187
@ 010, 10 SAY "Ordem de Produção " 	SIZE 70,50
@ 030, 10 SAY "Idioma " 			SIZE 50,50
@ 050, 10 SAY "Qtde. Etiquetas" 	SIZE 50,50
@ 070, 10 SAY "Data Fabricação "	SIZE 50,50

@ 010, 060 MSGET 		oOP  	VAR _cOP 	F3 "SC2" PICTURE "@!" VALID ValidOP(_cOP) SIZE 80,7 OF oDlg1 PIXEL
@ 030, 060 MSCOMBOBOX 	oLang 	VAR _cLang  ITEMS _aCbx SIZE 075, 65 OF oDlg1 PIXEL
@ 050, 060 MSGET 		oQtde	VAR _nQtd	PICTURE "999" SIZE 20,7 OF oDlg1 PIXEL
@ 070, 060 MSGET 		oDtFab	VAR _dDtFab	PICTURE "@D" VALID !Empty(_dDtFab) SIZE 60,7 OF oDlg1 PIXEL

//@ 090, 050 Button oOK  	Prompt "&Imprimir" 	Size 25, 13 Action ChkOpc(_cOP, _cLang, _nQtd2, _dDtFab, _NQTD) OF oDlg1 PIXEL
@ 090, 050 Button oOK  	Prompt "&Imprimir" 	Size 25, 13 Action ChkOpc(_cOP, _cLang,_dDtFab, _nQtd) OF oDlg1 PIXEL
@ 090, 110 Button oSair	Prompt "&Sair" 		Size 25, 13 Action Close(oDlg1) OF oDlg1 PIXEL

@ 100, 145 SAY "By | TI Ortosintese"
ACTIVATE MSDIALOG oDlg1 CENTERED

DlgRefresh(oDlg1)

Return

//Rotina que dispara a impressão das etiquetas conforme parametros indicados pelo cliente.
Static Function ChkOpc(_cNumOP, _cLang,_dDtFab, _nQtd)
Local nI := 0

dbSelectArea("SC2")
dbSetOrder(1)
If dbSeek(xFilial("SC2")+(Substr(_cNumOP,1,8)+'001'))

	_nLang := Val(SubStr(_cLang,1,1))
	
	_nQuant := SC2->C2_QUANT
	dbSelectArea("SB1")
	dbSetOrder(1)

	DbSelectArea("SZQ")
	SZQ->(DbSetOrder(1))
    
    For nI := 1 to _nQtd
    	//Pega a quantidade de impressões necessarias
    	nQtdImp := POSICIONE( "SB1", 1, xFilial("SB1")+SC2->C2_PRODUTO, "B1_XQTETIQ" )
    	
    	//Proteção para o caso de não existir o produto cadastrado
    	nQtdImp	:= Iif(ValType(nQtdImp)=="N" .AND. nQtdImp > 0, nQtdImp, 1)
    	
    	//PEGA A QUANTIDADE DE EMBALAGENS
    	_nQtdEmb := POSICIONE( "SB1", 1, xFilial("SB1")+SC2->C2_PRODUTO, "B1_XQE" )
    	_nQtdEmb := Iif(_nQtdEmb == 0, 1, _nQtdEmb)
    	
    	
    	//Imprime o produto pai
    	 RptStatus({|lEnd| U_DTR5PRINT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtdEmb,_nLang,_dDtFab,dDatabase,nQtdImp,)},"Imprimindo, aguarde...")
    	//RptStatus({|lEnd| U_DT03FIL(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL, _nQtdEmb,_nLang, "",_dDtFab,dDatabase, nQtdImp/*_nQtd*/, .T.)},"Imprimindo, aguarde...")

    	//Verificar se possui produtos filhos e imprime
		If SZQ->(DbSeek(xFilial("SZQ")+SC2->C2_PRODUTO))
			While SZQ->(!Eof() .AND. AllTrim(ZQ_PRODPAI) == AllTrim(SC2->C2_PRODUTO))
				If SZQ->ZQ_ATIVO == "S"
				
			    	//Pega a quantidade de impressões necessarias
					nQtdImp := POSICIONE( "SB1", 1, xFilial("SB1")+SZQ->ZQ_PRODFIL, "B1_XQTETIQ" )
					
					//Proteção para o caso de não existir o produto cadastrado
					nQtdImp	:= Iif(ValType(nQtdImp)=="N" .AND. nQtdImp > 0, nQtdImp, 1)

			    	//PEGA A QUANTIDADE DE EMBALAGENS
			    	_nQtdEmb := POSICIONE( "SB1", 1, xFilial("SB1")+SZQ->ZQ_PRODFIL, "B1_XQE")
			    	_nQtdEmb := Iif(_nQtdEmb == 0, 1, _nQtdEmb)
			    		    	
					RptStatus({|lEnd| U_DTR5PRINT(.F., SZQ->ZQ_PRODFIL, SC2->C2_LOTECTL, _nQtdEmb,_nLang,_dDtFab, dDatabase, nQtdImp)},"Imprimindo etiquetas filhas, aguarde...")
														//	mv_par01,	mv_par02,		mv_par03, mv_par04,	mv_par05,	mv_par06,	mv_par07,
														//   Codigo, 	lote,			PcsEbale, Idioma,	DTFabi,		DTesteril,	QtdeRto
				EndIf		
				SZQ->(DbSkip())
			End
		EndIf
    Next nI
EndIf

_cOP 	:= Space(LEN(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
_nLang	:= 1
_nQtd 	:= 1

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