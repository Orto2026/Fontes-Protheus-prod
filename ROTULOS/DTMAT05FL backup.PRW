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
	Local _nQtd := 1
//Local _nQtd2 	:= 0
	Local _aCbx 	:= {"1-Português", "2-Inglês", "3-Espanhol"}
	Local _dDtFab	:= nil

//Variaveis
	Private  lCHECK_1 := .F.
	Private  cCHECK_1 := "ZT231"

	_dDtFab	:= dDatabase
	_cOP := Space(TamSX3("C2_NUM")[1])

	Private oDlg1, oOP, oLang, oQtde,oCheck1, oSair

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
Static Function ChkOpc(_cNumOP, _cLang,_dDtFab, _nQtd,lCHECK_1)
	Local nI := 0
	Local _nQtdEmb := 0
	Local xt := 0
	Local cKey := ""

	DbSelectArea("SC2")
	DbSetOrder(1)

	cKey := MontaChaveOP(_cNumOP)

	If DbSeek(xFilial("SC2") + cKey)

		_nLang := Val(SubStr(_cLang,1,1))

		_nQuant := SC2->C2_QUANT
		dbSelectArea("SB1")
		dbSetOrder(1)

		DbSelectArea("SZQ")
		SZQ->(DbSetOrder(1))

		//Local lImpPai := .F.  //Alteração para excluir a rastreabilidade do segundo pai\\



		For nI := 1 to _nQtd
			//Pega a quantidade de impressões necessarias
			nQtdImp := POSICIONE( "SB1", 1, xFilial("SB1")+SC2->C2_PRODUTO, "B1_XQTETIQ" )

			//Proteção para o caso de não existir o produto cadastrado
			nQtdImp	:= Iif(ValType(nQtdImp)=="N" .AND. nQtdImp > 0, nQtdImp, 1)

			//PEGA A QUANTIDADE DE EMBALAGENS
			_nQtdEmb := POSICIONE( "SB1", 1, xFilial("SB1")+SC2->C2_PRODUTO, "B1_XQE" )
			_nQtdEmb := Iif(_nQtdEmb == 0, 1, _nQtdEmb)

			//Imprime o produto pai

			If lCHECK_1 == .F.
				///Ajuste inclido por  : Samuel miranda dia 29/10/2025 para impressão das etiquesta de rastriabilidade.
				For xt := 1 to nQtdImp //         01          02               03         04      05     06       07    08
					RptStatus({|lEnd| U_TFLPRT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtdEmb,_nLang,_dDtFab,dDatabase,xt)},"Imprimindo, aguarde...")
				Next xt
			ElseIf lCHECK_1 == .T.
				//Ajuste inclido por  : Samuel miranda dia 29/10/2025 para impressão das etiquesta de rastriabilidade.
				For xt := 1 to nQtdImp //         01          02               03         04      05     06       07    08
					RptStatus({|lEnd| U_TFLPRT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtdEmb,_nLang,_dDtFab,dDatabase,xt)},"Imprimindo, aguarde...")
				Next xt
			EndIf

	
			//Verificar se possui produtos filhos e imprime
			If SZQ->(DbSeek(xFilial("SZQ")+AllTrim(SC2->C2_PRODUTO)))
				While SZQ->(!Eof() .AND. AllTrim(ZQ_PRODPAI) == AllTrim(SC2->C2_PRODUTO))
					If SZQ->ZQ_ATIVO == "S"

						//Pega a quantidade de impressões necessarias
						nQtdImp := POSICIONE( "SB1", 1, xFilial("SB1")+SZQ->ZQ_PRODFIL, "B1_XQTETIQ" )

						//Proteção para o caso de não existir o produto cadastrado
						nQtdImp	:= Iif(ValType(nQtdImp)=="N" .AND. nQtdImp > 0, nQtdImp, 1)

						//PEGA A QUANTIDADE DE EMBALAGENS
						_nQtdEmb := POSICIONE( "SB1", 1, xFilial("SB1")+SZQ->ZQ_PRODFIL, "B1_XQE")
						_nQtdEmb := Iif(_nQtdEmb == 0, 1, _nQtdEmb)



						If lCHECK_1 == .F.
							//     01      02			03				04		05		06		07		08
							RptStatus({|lEnd| U_DTR5PRINT(.F.,SZQ->ZQ_PRODFIL,SC2->C2_LOTECTL,_nQtdEmb,_nLang,_dDtFab,dDatabase,nQtdImp, .t. )},"Imprimindo a filha, aguarde...")

						ElseIf lCHECK_1 == .T.	      //  01      02			03				04		05		06		07		08
							RptStatus({|lEnd| U_DTR10PRT(.F.,SZQ->ZQ_PRODFIL,SC2->C2_LOTECTL,_nQtdEmb,_nLang,_dDtFab,dDatabase,nQtdImp, .t. )},"Imprimindo a filha, aguarde...")
						EndIf
						//RptStatus({|lEnd| U_DTR5PRINT(.F., SZQ->ZQ_PRODFIL, SC2->C2_LOTECTL, _nQtdEmb,_nLang,_dDtFab, dDatabase, nQtdImp)},"Imprimindo etiquetas filhas, aguarde...")
						//	mv_par01,	mv_par02,		mv_par03, mv_par04,	mv_par05,	mv_par06,	mv_par07,
					endif									//   Codigo, 	lote,			PcsEbale, Idioma,	DTFabi,		DTesteril,	QtdeRto

					SZQ->(DbSkip())
				End
			EndIf

			cMensagem := "Confirma a impressão dos  <strong>Rotulos ?</strong> "
			If MsgNoYes(cMensagem, "A T E N Ç Ã O !")
				//Verificar se possui produtos filhos e imprime

				dbSelectArea("SC2")
				dbSetOrder(1)
				dbSeek(xFilial("SC2")+(Substr(_cNumOP,1,8)+'001'))

				dbSelectArea("SB1")
				dbSetOrder(1)

				DbSelectArea("SZQ")
				SZQ->(DbSetOrder(1))
				SZQ->(dbGotop())

				//Pega a quantidade de impressões necessarias
				nQtdImp := POSICIONE( "SB1", 1, xFilial("SB1")+SC2->C2_PRODUTO, "B1_XQTETIQ" )

				//Proteção para o caso de não existir o produto cadastrado
				nQtdImp	:= Iif(ValType(nQtdImp)=="N" .AND. nQtdImp > 0, nQtdImp, 1)

				//PEGA A QUANTIDADE DE EMBALAGENS
				_nQtdEmb := POSICIONE( "SB1", 1, xFilial("SB1")+SC2->C2_PRODUTO, "B1_XQE" )
				_nQtdEmb := Iif(_nQtdEmb == 0, 1, _nQtdEmb)



				If lCHECK_1 == .F.
					///Ajuste inclido por  : Samuel miranda dia 29/10/2025 para impressão das etiquesta de rastriabilidade.
					For xt := 1 to nQtdImp //         01          02               03         04      05     06       07    08
						RptStatus({|lEnd| U_TFLPRT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtdEmb,_nLang,_dDtFab,dDatabase,xt)},"Imprimindo, aguarde...")
					Next xt
				ElseIf lCHECK_1 == .T.
					//Ajuste inclido por  : Samuel miranda dia 29/10/2025 para impressão das etiquesta de rastriabilidade.
					For xt := 1 to nQtdImp //         01          02               03         04      05     06       07    08
						RptStatus({|lEnd| U_TFLPRT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtdEmb,_nLang,_dDtFab,dDatabase,xt)},"Imprimindo, aguarde...")
					Next xt
				EndIf

				If SZQ->(DbSeek(xFilial("SZQ")+AllTrim(SC2->C2_PRODUTO)))
					While SZQ->(!Eof() .AND. AllTrim(ZQ_PRODPAI) == AllTrim(SC2->C2_PRODUTO))
						If SZQ->ZQ_ATIVO == "S"

							//Pega a quantidade de impressões necessarias
							nQtdImp := POSICIONE( "SB1", 1, xFilial("SB1")+SZQ->ZQ_PRODFIL, "B1_XQTETIQ" )

							//Proteção para o caso de não existir o produto cadastrado
							nQtdImp	:= Iif(ValType(nQtdImp)=="N" .AND. nQtdImp > 0, nQtdImp, 1)

							//PEGA A QUANTIDADE DE EMBALAGENS
							_nQtdEmb := POSICIONE( "SB1", 1, xFilial("SB1")+SZQ->ZQ_PRODFIL, "B1_XQE")
							_nQtdEmb := Iif(_nQtdEmb == 0, 1, _nQtdEmb)



							If lCHECK_1 == .F.
								//     01      02			03				04		05		06		07		08
								RptStatus({|lEnd| U_DTR5PRINT(.F.,SZQ->ZQ_PRODFIL,SC2->C2_LOTECTL,_nQtdEmb,_nLang,_dDtFab,dDatabase,nQtdImp, .t. )},"Imprimindo a filha, aguarde...")

							ElseIf lCHECK_1 == .T.	      //  01      02			03				04		05		06		07		08
								RptStatus({|lEnd| U_DTR10PRT(.F.,SZQ->ZQ_PRODFIL,SC2->C2_LOTECTL,_nQtdEmb,_nLang,_dDtFab,dDatabase,nQtdImp, .t. )},"Imprimindo a filha, aguarde...")
							EndIf
							//RptStatus({|lEnd| U_DTR5PRINT(.F., SZQ->ZQ_PRODFIL, SC2->C2_LOTECTL, _nQtdEmb,_nLang,_dDtFab, dDatabase, nQtdImp)},"Imprimindo etiquetas filhas, aguarde...")
							//	mv_par01,	mv_par02,		mv_par03, mv_par04,	mv_par05,	mv_par06,	mv_par07,
						endif									//   Codigo, 	lote,			PcsEbale, Idioma,	DTFabi,		DTesteril,	QtdeRto

						SZQ->(DbSkip())
					End
				EndIf
			endif
		Next nI
	EndIf

	_cOP := Space(TamSX3("C2_NUM")[1])

	_nLang	:= 1
	_nQtd 	:= 1

Return()

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Rotina   | ChkOpc | Autor| pED         | Data | 03/12/2019  |±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Descricao | Rotina que dispara a impressão das etiquetas conforme 		|±±//
//±±|            parametros indicados pelo cliente.                			|±±//
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

Return .T.





