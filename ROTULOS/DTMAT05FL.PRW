#INCLUDE "PROTHEUS.CH"
#Include "rwmake.Ch"

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Rotina    | DTMAT05FL         | Samuel  Miranda    | Data | 03/12/2019 |±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Descricao | Tela de impressão de etuiquetas PAI /FILHO apartir da OP   |±±//
//±±|              com o codigo de barras data matrix                       |±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//

User Function DTMAT05FL()
	Local _cOP 		:= ""
	Local _cLang	:= ""
	Local _nQtd     := 0
//Local _nQtd2 	:= 0
	Local _aCbx 	:= {"1-Português", "2-Inglês", "3-Espanhol"}
	Private _dDtFab	:= nil

//Variaveis
	Private  lCHECK_1 := .F.
	Private  cCHECK_1 := "ZT231"

	_dDtFab	:= dDatabase
	_cOP := Space(TamSX3("C2_NUM")[1])

	Private oDlg1, oOP, oLang, oQtde,oCheck1, oSair,oDtFab

	DEFINE MSDIALOG oDlg1 TITLE "Impressão de Etiquetas DataMatrix" FROM 200,70 TO 425,450 PIXEL
	@ 003, 4 To 110,190
//@ 003, 4 To 110,187
	@ 010, 10 SAY "Ordem de Produção " 	SIZE 70,50
	@ 030, 10 SAY "Idioma " 			SIZE 50,50
	@ 050, 10 SAY "Qtde. Etiquetas" 	SIZE 50,50
	@ 070, 10 SAY "Data Fabricação "	SIZE 50,50

	@ 010, 060 MSGET oOP VAR _cOP F3 "SC2" PICTURE "@!" ;
		VALID ValidOP(AllTrim(_cOP)) ;
		SIZE 80,7 OF oDlg1 PIXEL

	@ 030, 060 MSCOMBOBOX 	oLang 	VAR _cLang  ITEMS _aCbx SIZE 075, 65 OF oDlg1 PIXEL
	@ 050, 060 MSGET oQtde VAR _nQtd PICTURE "999" SIZE 20,7 WHEN .F. OF oDlg1 PIXEL

	oOP:bLostFocus := {|| AtualizaQtd(AllTrim(_cOP), @_nQtd, oQtde, oDlg1) }


	@ 070, 060 MSGET 		oDtFab	VAR _dDtFab	PICTURE "@D" VALID !Empty(_dDtFab) SIZE 50,7 OF oDlg1 PIXEL
    oDtFab:lActive := .F. //Disabilita a escrita no campo
//Cheque
	oCheck1:= TCheckBox():New(070,120,cCHECK_1,bSETGET(lCHECK_1),oDlg1,215,10,,,,,,,,.T.)
//Bloco de código que será executado quando clicar, com o botão esquerdo do mouse, sobre o objeto.
	oCheck1:bLClicked := {|| TChk(oCheck1,lCHECK_1)}
//@ 090, 050 Button oOK  	Prompt "&Imprimir" 	Size 25, 13 Action ChkOpc(_cOP, _cLang, _nQtd2, _dDtFab, _nQtd) OF oDlg1 PIXEL
	@ 090, 050 Button oOK  	Prompt "&Imprimir" 	Size 25, 13 Action ChkOpc(_cOP, _cLang,_dDtFab, _nQtd,lCHECK_1) OF oDlg1 PIXEL
	@ 090, 110 Button oSair	Prompt "&Sair" 		Size 25, 13 Action Close(oDlg1) OF oDlg1 PIXEL

	@ 100, 143 SAY "By | TI Ortosintese"
	ACTIVATE MSDIALOG oDlg1 CENTERED

	DlgRefresh(oDlg1)

Return

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Rotina    | TChk | Autor| Samuel Miranda          | Data | 03/12/2019  |±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Descricao | Função que irá verificar se houve  modificação o 			|±±//
//±±|                 clique do check                   					|±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
Static Function TChk(oCheck, lCHECK)

	If valType(oCheck) <> "U"
		If oCheck:lModified //Verifica se foi alterado
			If lCHECK == .T.
				msgInfo("Impressora ZT231 selecinada! ")// + oCheck:cTitle + " Estado: "+cValToChar(lCHECK))
			EndiF
		EndIf
	Endif

Return .T.

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Rotina   | ChkOpc | Autor| Samuel Miranda         | Data | 03/12/2019  |±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Descricao | Rotina que dispara a impressão das etiquetas conforme 		|±±//
//±±|            parametros indicados pelo cliente.                			|±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
Static Function ChkOpc(_cNumOP, _cLang, _dDtFab, _nQtd, lCHECK_1)

    Local nI         := 0
    Local xt         := 0
    Local nQtdImpPai := 0
    Local nQtdEmbPai := 0
    Local cMensagem  := ""
    Local nLang      := 1
    Local cKeySeek   := ""

    Local cProdPai   := ""
    Local cLotePai   := ""

    Local nQtdImpFil := 0
    Local nQtdEmbFil := 0
    Local cProdFil   := ""

    // idioma
    If Empty(AllTrim(_cLang))
        nLang := 1
    Else
        nLang := Val(SubStr(_cLang,1,1))
        If nLang <= 0
            nLang := 1
        EndIf
    EndIf

    // busca OP na SC2
    DbSelectArea("SC2")
    DbSetOrder(1)
    cKeySeek := xFilial("SC2") + MontaChaveOP(_cNumOP)

    If !DbSeek(cKeySeek)
        MsgStop("OP não encontrada na SC2. Chave: " + cKeySeek)
        Return .F.
    EndIf

    // congela dados do pai 
    cProdPai := AllTrim(SC2->C2_PRODUTO)
    cLotePai := AllTrim(SC2->C2_LOTECTL)

    // calcula dados do PAI 1x
    DbSelectArea("SB1")
    DbSetOrder(1)

    nQtdImpPai := POSICIONE("SB1", 1, xFilial("SB1") + cProdPai, "B1_XQTETIQ")
    nQtdImpPai := Iif(ValType(nQtdImpPai) == "N" .AND. nQtdImpPai > 0, nQtdImpPai, 1)

    nQtdEmbPai := POSICIONE("SB1", 1, xFilial("SB1") + cProdPai, "B1_XQE")
    nQtdEmbPai := Iif(nQtdEmbPai == 0, 1, nQtdEmbPai)

    // =================================
    // 1) AMOSTRA: PAI + FILHOS (1 peça)
    // ==================================

    // imprime PAI (amostra)
    For xt := 1 To nQtdImpPai
        RptStatus({|lEnd| U_TFLPRT(.F., cProdPai, cLotePai, nQtdEmbPai, nLang, _dDtFab, dDatabase, xt)}, ;
                  "Imprimindo PAI (amostra), aguarde...")
    Next xt

    // imprime FILHOS (amostra)
    DbSelectArea("SZQ")
    SZQ->(DbSetOrder(1))

    If SZQ->(DbSeek(xFilial("SZQ") + cProdPai))
        While SZQ->(!Eof() .AND. AllTrim(SZQ->ZQ_PRODPAI) == cProdPai)

            If SZQ->ZQ_ATIVO == "S"

                cProdFil := AllTrim(SZQ->ZQ_PRODFIL)

                DbSelectArea("SB1")
                DbSetOrder(1)

                nQtdImpFil := POSICIONE("SB1", 1, xFilial("SB1") + cProdFil, "B1_XQTETIQ")
                nQtdImpFil := Iif(ValType(nQtdImpFil) == "N" .AND. nQtdImpFil > 0, nQtdImpFil, 1)

                nQtdEmbFil := POSICIONE("SB1", 1, xFilial("SB1") + cProdFil, "B1_XQE")
                nQtdEmbFil := Iif(nQtdEmbFil == 0, 1, nQtdEmbFil)

                If lCHECK_1 == .F.
                    RptStatus({|lEnd| U_DTR5PRINT(.F., cProdFil, cLotePai, nQtdEmbFil, nLang, _dDtFab, dDatabase, nQtdImpFil, .T.)}, ;
                              "Imprimindo FILHO (amostra), aguarde...")
                Else
                    RptStatus({|lEnd| U_DTR10PRT(.F., cProdFil, cLotePai, nQtdEmbFil, nLang, _dDtFab, dDatabase, nQtdImpFil, .T.)}, ;
                              "Imprimindo FILHO (amostra), aguarde...")
                EndIf

            EndIf

            DbSelectArea("SZQ")
            SZQ->(DbSkip())
        EndDo
    EndIf

    // ===============================================
    // 2) Pergunta 1x        Pedro Simões 12/02/2026
    // ================================================
    cMensagem := "Confirma a impressão dos <strong>Rótulos?</strong>"
    If !MsgNoYes(cMensagem, "A T E N Ç Ã O !")
        Return .T.
    EndIf

    // ===================================================================
    // 3) Imprime o Restante    Pedro Simões 12/02/2026
    // ===================================================================
   If _nQtd >= 1

    For nI := 2 To (_nQtd + 1)  // +1 
        // imprime PAI
        For xt := 1 To nQtdImpPai
            RptStatus({|lEnd| U_TFLPRT(.F., cProdPai, cLotePai, nQtdEmbPai, nLang, _dDtFab, dDatabase, xt)}, ;
                      "Imprimindo PAI, aguarde...")
        Next xt

        // imprime FILHOS
        DbSelectArea("SZQ")
        SZQ->(DbSetOrder(1))

        If SZQ->(DbSeek(xFilial("SZQ") + cProdPai))
            While SZQ->(!Eof() .AND. AllTrim(SZQ->ZQ_PRODPAI) == cProdPai)

                If SZQ->ZQ_ATIVO == "S"

                    cProdFil := AllTrim(SZQ->ZQ_PRODFIL)

                    DbSelectArea("SB1")
                    DbSetOrder(1)

                    nQtdImpFil := POSICIONE("SB1", 1, xFilial("SB1") + cProdFil, "B1_XQTETIQ")
                    nQtdImpFil := Iif(ValType(nQtdImpFil) == "N" .AND. nQtdImpFil > 0, nQtdImpFil, 1)

                    nQtdEmbFil := POSICIONE("SB1", 1, xFilial("SB1") + cProdFil, "B1_XQE")
                    nQtdEmbFil := Iif(nQtdEmbFil == 0, 1, nQtdEmbFil)

                    If lCHECK_1 == .F.
                        RptStatus({|lEnd| U_DTR5PRINT(.F., cProdFil, cLotePai, nQtdEmbFil, nLang, _dDtFab, dDatabase, nQtdImpFil, .T.)}, ;
                                  "Imprimindo FILHO, aguarde...")
                    Else
                        RptStatus({|lEnd| U_DTR10PRT(.F., cProdFil, cLotePai, nQtdEmbFil, nLang, _dDtFab, dDatabase, nQtdImpFil, .T.)}, ;
                                  "Imprimindo FILHO, aguarde...")
                    EndIf

                EndIf

                DbSelectArea("SZQ")
                SZQ->(DbSkip())
            EndDo
        EndIf

    Next nI

EndIf

Return .T.
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Rotina   | ChkOpc | Autor| Pedro Simões         | Data | 12/02/2026  |±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Descricao | Função que puxa a quantidade dos campos            		|±±//
//±±|                                                           			|±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//

Static Function AtualizaQtd(cNumOP, nQtd, oQtde, oDlg)
	Local nVal := 1
	Local cKey := ""

	cNumOP := AllTrim(cNumOP)
	If Empty(cNumOP)
		Return .T.
	EndIf

	DbSelectArea("SC2")
	DbSetOrder(1)

	cKey := MontaChaveOP(cNumOP)

	If !DbSeek(xFilial("SC2") + cKey)
		Return .F.
	EndIf

	nVal := SC2->C2_XQTDROT
	If ValType(nVal) <> "N"
		nVal := Val(AllTrim(cValToChar(nVal)))
	EndIf
	If nVal <= 0
		nVal := 1
	EndIf

	nQtd := nVal

	If ValType(oQtde) == "O"
		oQtde:VarPut(nVal)
		oQtde:Refresh()
	EndIf

	If ValType(oDlg) == "O"
		DlgRefresh(oDlg)
	EndIf

Return .T.




Static Function MontaChaveOP(cNumOP)
	Local nTamNum  := TamSX3("C2_NUM")[1]
	Local nTamItem := TamSX3("C2_ITEM")[1]
	Local nTamSeq  := TamSX3("C2_SEQUEN")[1]

	cNumOP := AllTrim(cNumOP)

Return PadR(SubStr(cNumOP,1,nTamNum), nTamNum) + ;
		PadL("1", nTamItem, "0") + ;
		PadL("1", nTamSeq , "0")




//Verifica se a OP é valida
Static Function ValidOP(cNumOP)
	Local cKey := ""

	cNumOP := AllTrim(cNumOP)
	If Empty(cNumOP)
		Return .T.
	EndIf

	DbSelectArea("SC2")
	DbSetOrder(1)

	cKey := MontaChaveOP(cNumOP)

	If !DbSeek(xFilial("SC2") + cKey)
		Alert("Ordem de Produção não encontrada...")
		Return .F.
	EndIf

		// Atualiza a data de fabricação
		_dDtFab := U_GetDtPrd(SC2->(C2_NUM + C2_ITEM + C2_SEQUEN))
		oDtFab:Refresh()

Return .T.





