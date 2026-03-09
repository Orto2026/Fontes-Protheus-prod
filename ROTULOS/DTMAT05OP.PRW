#INCLUDE "PROTHEUS.CH"
#Include "rwmake.Ch"

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºRotina    ³ DTMATR05OP  Miranda     º Data ³ 03/12/2019  º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºDescricao ³ Tela de impressão de etuiquetas apartir da OP              º±±//
//±±º              com o codigo de barras data matrix                       º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±±±±±±±±±±±±±±±±±±±±±          PARAMENTROS            ±±±±±±±±±±±±±±±±±±±±±±//
// _cOP		= Número da Ordem de produção
// _cLang	= Idioma
// _nQtdCop	= Quantidade de Copias
// _nQtEmb	= Quantidade de peção por embalagem
// _dDtFab	= Data da fabricação
// cCHECK_1	= Adicionada a opção para impressão em outro fonte
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//

User Function DTMAT05OP()
//Local _cOP 		:= ""
	Local _cLang		:= ""
//Local _nQtdCop 	:= 0
//Local _nQtEmb 	:= 0
	Local _aCbx 	:= {"1-Português", "2-Inglês", "3-Espanhol"}

	Private _dDtFab	:= nil
//Pega a data base do sistema
	_dDtFab	:= dDatabase
//Pega o numero da Ordem de Produção

//Variaveis
	Public  _nQtdCop := Space(3)
	Public  _nQtEmb  := Space(3)
	Public  _cOP 	 := Space(LEN(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
	Public  oQtde
	Public  oEmb
	Public  oOP

	Private  lRetSenha  := .F.
	Private  lCHECK_1 	:= .F.
	Private  cCHECK_1 	:= "ZT231"
//Variaveis de Objeto
	Private oDlg1,  oLang, oCheck1, oSair, oDtFab  //Private oDlg1, oOP, oLang, oQtde,oEmb,oCheck1, oSair
//Monta a tela
	DEFINE MSDIALOG oDlg1 TITLE "Impressão de Etiquetas DataMatrix" FROM 200,70 TO 425,450 PIXEL
	@ 003, 4 To 110,190
//@ 003, 4 To 110,187
	@ 010, 10 SAY "Ordem de Produção " 	SIZE 70,50
	@ 030, 10 SAY "Idioma " 			SIZE 50,50
	@ 050, 10 SAY "Qtde. Etiquetas" 	SIZE 50,50
	@ 050, 90 SAY "Pcs / Embalagem" 	SIZE 50,50
	@ 070, 10 SAY "Data Fabricação "	SIZE 50,50

//
	@ 010, 060 MSGET 		oOP  	VAR _cOP 		F3 "SC2" PICTURE "@!" VALID ValidOP(_cOP) SIZE 80,7 OF oDlg1 PIXEL
	@ 025, 060 MSCOMBOBOX 	oLang 	VAR _cLang  	ITEMS 	_aCbx 			SIZE 075, 65 	OF oDlg1 PIXEL
	oLang:lActive := .F. //Disabilita a escrita no campo
	@ 050, 060 MSGET 		oQtde	VAR _nQtdCop	PICTURE  "999"  		SIZE 20,7 		OF oDlg1 PIXEL  //When .F.
	oQtde:lActive := .F. //Disabilita a escrita no campo
	@ 050, 140 MSGET 		oEmb	VAR _nQtEmb		PICTURE "999" SIZE 20,7 	OF oDlg1 PIXEL
	oEmb:lActive := .F. //Disabilita a escrita no campo
	@ 070, 060 MSGET 		oDtFab	VAR _dDtFab		PICTURE "@D" VALID !Empty(_dDtFab) SIZE 50,7 OF oDlg1 PIXEL
	oDtFab:lActive := .F. //Disabilita a escrita no campo
//Cheque
	oCheck1:= TCheckBox():New(070,120,cCHECK_1,bSETGET(lCHECK_1),oDlg1,215,10,,,,,,,,.T.)
//Bloco de código que será executado quando clicar, com o botão esquerdo do mouse, sobre o objeto.
	oCheck1:bLClicked := {|| TChk(oCheck1,lCHECK_1)}
//@ 090, 050 Button oOK  	Prompt "&Imprimir" 	Size 25, 13 Action ChkOpc(_cOP, _cLang, _nQtd2, _dDtFab, _nQtd) OF oDlg1 PIXEL
	@ 090, 050 Button oOK  	Prompt "&Imprimir" 	Size 25, 13 Action ChkOpc(_cOP, _cLang,_dDtFab,_nQtEmb,_nQtdCop,lCHECK_1) OF oDlg1 PIXEL
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
				msgInfo("Impressora ZT231 selecinada ")// + oCheck:cTitle + " Estado: "+cValToChar(lCHECK))
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
Static Function ChkOpc(_cNumOP, _cLang,_dDtFab,_nQtEmb,_nQtdCop,lCHECK_1)

	Local cTipProd 	:= ""
	Local cPdSteril := .F.
	Local xt 		:= 0
//Local yt := 0
	Local cVerImp := ""
	Local lOkImp  := .F.
	Local _LOK    := .F.
	Local _nSteril  := .T.
	Private cNumOP  := _cNumOP

	iF _nQtdCop <= 0
		FWAlertWarning("Quantidade de Rotulos não informada.", "A T E N Ç Ã O !")
		Return()
	EndIf

	DbSelectArea("SC2")
	DbSetOrder(1)
	If dbSeek(xFilial("SC2")+(Substr(cNumOP,1,8)+'001'))
		//Atualiza as variaveis
		_nLang 	:= Val(SubStr(_cLang,1,1))  // Trasforma caracter(Númerico) em Número.
		_nQuant := Alltrim(SC2->C2_XQTDROT) // Pega a quantidade de rotulos conforme a quantidade de Peças na OP
		cVerImp := Alltrim(SC2->C2_XIMPROT)

		//Verifica se já foi impresso o rótulo.
		If 	cVerImp == "2" .OR. cVerImp ==""

			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
			cTipProd := SB1->B1_TIPO
			If Alltrim(SB1->B1_XSTERI)=="1"
				cPdSteril := .T.
			EndIf

			//Verifica o fonte de impressão
			If lCHECK_1 == .F.
				//MsgAlert("Teste")
				//Imprimi o rotulo  para conferencia.
				//				      01 		   02			  03		04	     05		06	   07	   08   09
				RptStatus({|lEnd| U_DTR5PRINT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtEmb,_nLang,_dDtFab,dDatabase,1,_nSteril)},"Imprimindo, aguarde...")
				//Após a confirmação, faz a impressão dos rotuloes.
				cMensagem := "Confirma a impressão dos  <strong>Rotulos ?</strong> "
				If MsgNoYes(cMensagem, "A T E N Ç Ã O !")

					//Se for Porduto Steril multiplica a quantidade por 2 e não imprimi as etiquetas de rastriabilidade.
					If cPdSteril
						For xt := 1 to 2
							If xt = 2
								_nSteril := .F.
							EndIF
							//				   01 		   02			  03		04	     05		06		 07		 08	       09
							RptStatus({|lEnd| U_DTR5PRINT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtEmb,_nLang,_dDtFab,dDatabase,_nQtdCop,_nSteril )},"Imprimindo, aguarde...")
						Next xt
					Else
						//				   01 		   02			  03		04	     05		06		 07		 08	       09
						RptStatus({|lEnd| U_DTR5PRINT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtEmb,_nLang,_dDtFab,dDatabase,_nQtdCop,_nSteril )},"Imprimindo, aguarde...")
					EndIf

					lOkImp := .T.
				Else
					lOkImp := .F.
				EndIf

				//Verificar o checkbox para informar o modelo da Impressora.
			ElseIf lCHECK_1 == .T.
				//Imprimi o rotulo  para conferencia.
				RptStatus({|lEnd| U_DTR10PRT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtEmb,_nLang,_dDtFab,dDatabase,1,_nSteril)},"Imprimindo, aguarde...")
				//Após a confirmação, faz a impressão dos rotuloes.
				cMensagem := "Confirma a impressão dos  <strong>Rotulos ?</strong> "
				If MsgNoYes(cMensagem, "A T E N Ç Ã O !")

					//Se for Porduto Steril multiplica a quantidade por 2 e não imprimi as etiquetas de rastriabilidade.
					If cPdSteril
						For xt := 1 to 2
							If xt = 2
								_nSteril := .F.
							EndIF
							//						01 			02				03			04	 05		06		 07		 08	    09
							RptStatus({|lEnd| U_DTR10PRT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtEmb,_nLang,_dDtFab,dDatabase,_nQtdCop,_nSteril )},"Imprimindo, aguarde...")
						Next xt
					Else
						//						01 			02				03			04	 05		06		 07		 08	    09
						RptStatus({|lEnd| U_DTR10PRT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtEmb,_nLang,_dDtFab,dDatabase,_nQtdCop,_nSteril )},"Imprimindo, aguarde...")
					EndIf
					lOkImp := .T.

				Else
					lOkImp := .F.
				EndIf
			EndIf
		ElseIf cVerImp == "1"
			//Faz a autenticação para reimpressão dos rotulos.
			IF !AUTENTIC()
				Return
			Else
				DbSelectArea("SC2")
				DbSetOrder(1)
				If dbSeek(xFilial("SC2")+cNumOP)
					// Posiciona na OP para gravar o Status da impressão
					RecLock("SC2",.F.)
					SC2->C2_XIMPROT  := "2"
					MsUnLock()
				EndIf
				_LOK     := .T.
			Endif
		EndIf
	EndIf

//Adiocinado por Samuel Miranda - 28/11/2025 - Posiciona na OP para gravar o Status da impressão
	If lOkImp
		DbSelectArea("SC2")
		DbSetOrder(1)
		If dbSeek(xFilial("SC2")+cNumOP)
			// Posiciona na OP para gravar o Status da impressão
			RecLock("SC2",.F.)
			SC2->C2_XIMPROT  := "1"
			MsUnLock()
		EndIf
		_cOP     := Space(LEN(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
		_nLang   := 1
		_nQtdCop := Space(3)
		_nQtEmb  := Space(3)
		oQtde:Refresh()
		oEmb:Refresh()
		//oOP:Refresh()
		oQtde:lActive := .F. //Disabilita a escrita no campo
		oDtFab:lActive := .F. //Disabilita a escrita no campo
		oOP:SetFocus() //Setfocus()
	EndIf

//Atualiza as variaveis
	If !_LOK
		//variaveis
		_cOP     := Space(LEN(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
		_nLang   := 1
		_nQtdEmb := Space(3)
		_nQtdCop := Space(3)
		oQtde:Refresh()
		oEmb:Refresh()
		oOP:Refresh()
		oOP:SetFocus() //Setfocus()
	Else
		oQtde:lActive := .T. //Disabilita a escrita no campo
		oDtFab:lActive := .T. //Disabilita a escrita no campo
	EndIf
Return()


//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Rotina    | VALIDOP | Autor| Samuel Miranda       | Data | 26/12/2025  |±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Descricao | Verifica se a OP é valida.				 		        	|±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//Verifica se a OP é valida
Static Function ValidOP(_cNumOP)//_cOP,oQtde,oEmb)
	Local  nNumOP 	:= _cNumOP //+ (Substr(nNumOP,1,8)+'001')

	Local _cXNumOP  := (SubStr(_cOP,1,6)) // Numero da OP
	Local _cXItem   := (SubStr(_cOP,7,2)) // Item OP
	Local _cXSeque  := (SubStr(_cNumOP,9,3)) // Sequencia OP
	//Local _cXSeque  := "001" // (SubStr(_cOP,9,3)) // Sequencia OP
	//Local cMsg 		:= ""
	If Empty(nNumOP)
		Return(.T.)
	EndIf
	//Seleciona o Alias
	DbSelectArea("SB1")
	DbSetOrder(1) //B1_FILIAL + B1_COD  ->Codigo

	DbSelectArea("SC2")
	DbSetOrder(1)
	//If _cXSeque <>"001"          //!(SC2->(dbSeek(xFilial("SC2") + nNumOP)))   //!dbSeek(xFilial("SC2")+(Substr(nNumOP,1,8)+'001'))
	//	//Alert("Ordem de Produçao nao Encontrada...")
	//	cMsg := '<b>Por favor verifique sequencia da Ord. de Produção!</b>'
	//	cMsg += '<br>'
	//	cMsg += '<b></b>'
	//	FWAlertError( cMsg, 'A T E N Ç Ã O !')
	//	Return(.F.)
	//EndIf
	//If dbSeek(xFilial("SC2")+(Substr(nNumOP,1,8)+'001'))
	If dbSeek(xFilial("SC2")+nNumOP)
		//Quantidade de Rótulos a serem impresso
		_nQtdCop := Val(SC2->C2_XQTDROT)

		If _cXSeque <>"001"
			DbSeek(xFilial("SC2")+_cXNumOP +_cXItem + "001")
			_nQtEmb  := Posicione("SB1", 1, xFilial("SB1") + SC2->C2_PRODUTO, "B1_XQE")
		Else
			_nQtEmb  := Posicione("SB1", 1, xFilial("SB1") + SC2->C2_PRODUTO, "B1_XQE")
		EndIF

		// Atualiza a data de fabricação
		_dDtFab := U_GetDtPrd(_cOP)
		//_dDtFab := U_GetDtPrd(SC2->(C2_NUM + C2_ITEM + C2_SEQUEN))
		oDtFab:Refresh()

		//Atualiza as variaveis
		oQtde:Refresh()
		oEmb:Refresh()
	EndIf
Return(.T.)


Static Function AUTENTIC()

	Local oButton1
	Local oButton2

	Local oSay1
	Local oSay2
	Local aItems := {'Falha na Impressora','Etiqueta Borrada','Etiqueta Rasgada','Embalagem Danificada','Selo Indicador de Esterilização'}

	Private  _cSPass  := Space(10)
	Private  cSenhAce := "203140"
	Static oDlgSenha

	DEFINE MSDIALOG oDlgSenha TITLE "Liberação de Reimpressão de Rotulos" FROM 000, 000  TO 240, 300 COLORS 0, 16777215 PIXEL
	//Define o Radio inicial
	nRadio := 0
	@ 010, 010 SAY oSay2 PROMPT "INFORME A SENHA!" SIZE 117, 007 OF oDlgSenha COLORS 0, 16777215 PIXEL
	@ 017, 010 MSGET oGet1 VAR _cSPass SIZE 060, 010 OF oDlgSenha COLORS 0, 16777215 PASSWORD PIXEL

	@ 035, 010 SAY oSay1 PROMPT "MOTIVO DA REIMPRESSÃO" SIZE 082, 007 OF oDlgSenha COLORS 0, 16777215 PIXEL
	oRadio := TRadMenu():New (42,10,aItems,,oDlgSenha,,,,,,,,100,12,,,,.T.)
	oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}

	@ 095, 037 BUTTON oButton1 PROMPT "&Ok"   SIZE 037, 012 ACTION fOK()  OF oDlgSenha PIXEL
	@ 095, 092 BUTTON oButton2 PROMPT "&Sair" SIZE 037, 012 ACTION Close(oDlgSenha) OF oDlgSenha PIXEL

	// O parâmetro 'u' dentro do bloco contém o novo valor selecionado
	//oRadio:bChange := {|| MsgInfo("Você selecionou o item: " + cValToChar(nRadio)) }
	ACTIVATE MSDIALOG oDlgSenha CENTERED

Return(lRetSenha)


Static Function fOK()
	Local _cPastaLog   := "\logs_etiquetas\" //cPastaErro := "\x_logs\"
	Local _cLocal    := "\logs_etiquetas\"+"_D_"+ DToS(dDataBase) + "_H_" + Strtran(SubStr(Time(),1,5),":","")+".txt"

	iF nRadio = 0
		FWAlertInfo("O motivo deve ser informado !", "A T E N Ç Ã O !")
		Return()
	EndIf

	If ALLTRIM(_cSPass)<> cSenhAce
		MsgStop("Senha não Confere !!!")
		_cSPass  := Space(10)
		dlgRefresh(oDlgSenha)
	Else
		Do Case //
		Case nRadio == 1
			_cMotivo :="Falha na Impressora"
		Case nRadio == 2
			_cMotivo :="Etiqueta Borrada"
		Case nRadio == 3
			_cMotivo :="Etiqueta Rasgada"
		Case nRadio == 4
			_cMotivo :="Embalagem Danificada"
		Case nRadio == 5
			_cMotivo :="Selo Indicador de Esterilização"
		EndCase

		If !ExistDir(_cPastaLog)
			MakeDir(_cPastaLog)
		EndIf
		//Grava o Log no diretorio informado
		MemoWrite(_cLocal, _cMotivo)

		lRetSenha  := .T.
		oOP:SetFocus() //Setfocus()
		Close(oDlgSenha)
	Endif
Return

Static Function ALTEROT()


Return()



//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Rotina    | AUTENTIC | Autor| Samuel Miranda      | Data | 26/12/2025  |±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Descricao | Libera a reimpressão dos Rotulos.				 			|±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
/*
Static Function AUTENTIC()
	Private cSenha   := Space(10)         
	Private cSenhAce := "123"
	@ 067,020 To 169,312 Dialog Senhadlg Title OemToAnsi("Liberação de Reimpressão")
	@ 010,005 Say OemToAnsi("Informe a senha para a Reimpressão !") Size 100,8
	@ 020,050 Get cSenha Size 50,10 Password
	@ 037,106 BmpButton Type 1 Action fOK()
	@ 037,055 BmpButton Type 2 Action Close(Senhadlg)
	Activate Dialog Senhadlg CENTERED
Return(lRetSenha)  

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Rotina    | FOK	  | Autor| Samuel Miranda      | Data | 26/12/2025  |±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Descricao | Valida a senha Digidata.						 			|±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//

Static Function fOK()

	If ALLTRIM(cSenha)<> cSenhAce
		MsgStop("Senha não Confere !!!")
		cSenha  := Space(10)
		dlgRefresh(Senhadlg)
	Else
	lRetSenha  := .T.
	oOP:SetFocus() //Setfocus()
	Close(Senhadlg)
	Endif
Return
*/






User Function GetDtPrd(cNumOP)

	Local dDataPro := CToD("  /  /  ")

	If Select("tProd") > 0
		tProd->(dbCloseArea())
	EndIf

	BeginSQL Alias "tProd"
		SELECT MAX(H6_DTAPONT) MAXDT
		FROM %table:SH6%
		WHERE   H6_FILIAL = %xFilial:SH6%
			AND H6_OP     = %Exp:cNumOP%
			AND RTRIM(H6_RECURSO) IN ('ROT01','EROT')
			//AND H6_ROTEIRO = ''
			AND %notDel%
	EndSQL

	tProd->(dbGoTop())
	If !tProd->(Eof())
		dDataPro := SToD(tProd->MAXDT)
	EndIf

	tProd->(dbCloseArea())

Return dDataPro
