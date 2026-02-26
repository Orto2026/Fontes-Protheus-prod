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

/*/****************************************************************************
Narques - 12/01/2026
Fonte atual (verf. com Pedro / Ivan)



/*/******************************************************************************


User Function DTMAT05OP()	
Local _cOP 		:= ""
Local _cLang	:= ""
Local _nQtdCop 	:= 1
Local _nQtEmb 	:= 0
Local _aCbx 	:= {"1-Português", "2-Inglês", "3-Espanhol"}
Local _dDtFab	:= nil
//Pega a data base do sistema
_dDtFab	:= dDatabase
//Pega o numero da Ordem de Produção
_cOP 	:= Space(LEN(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))

//Variaveis
Private  lCHECK_1 := .F.
Private  cCHECK_1 := "ZT231"

//Variaveis de Objeto
Private oDlg1, oOP, oLang, oQtde,oEmb,oCheck1, oSair 

ALERT(' PONTO DE PARADA 01 ...')


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
@ 025, 060 MSCOMBOBOX 	oLang 	VAR _cLang  	ITEMS 	_aCbx SIZE 075, 65 	OF oDlg1 PIXEL
@ 050, 060 MSGET 		oQtde	VAR _nQtdCop	PICTURE "999" SIZE 20,7 	OF oDlg1 PIXEL
@ 050, 140 MSGET 		oEmb	VAR _nQtEmb		PICTURE "999" SIZE 20,7 	OF oDlg1 PIXEL
@ 070, 060 MSGET 		oDtFab	VAR _dDtFab		PICTURE "@D" VALID !Empty(_dDtFab) SIZE 50,7 OF oDlg1 PIXEL
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

Local cTipProd := ""
Local cPdSteril := .F.
Local xt := 0
Local yt := 0

DbSelectArea("SC2")
DbSetOrder(1)
If dbSeek(xFilial("SC2")+(Substr(_cNumOP,1,8)+'001'))
	//Atualiza as variaveis
	_nLang := Val(SubStr(_cLang,1,1)) // Trasforma caracter(Númerico) em Número.
	_nQuant := SC2->C2_QUANT    	  // Pega a quantidade de rotulos conforme a quantidade de Peças na OP

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
	cTipProd := SB1->B1_TIPO
	If SB1->B1_XSTERI=="2"
		cPdSteril := .T.
	EndIf

	//Verifica o fonte de impressão
	If lCHECK_1 == .F.
		For xt := 1 to _nQtdCop
			//Ajuste inclido por  : Samuel miranda dia 30/12/2025 para impressão das etiquesta de rastriabilidade.
			iF Alltrim(SB1->B1_XSTERI)="2"
				//For yt := 1 to 2	  //        01           02              03       04     05      06      07     08    
    			 RptStatus({|lEnd| U_DTR5PRINT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtEmb,_nLang,_dDtFab,dDatabase,yt)},"Imprimindo, aguarde...")
				//Next yt  //                   (lEnd,  _cProd,           _cLote,_nQuant,_nLang,_dFabric,_dDtEmis,_nCop,nvz,nTru)
			 Else					 //        01           02              03       04     05      06      07      08 09  
				//Ajuste inclido por  : Samuel miranda dia 30/12/2025 para impressão das etiquesta de rastriabilidade.
				For yt := 1 to 2	  //        01           02              03       04     05      06      07     08  
				 RptStatus({|lEnd| U_DTR5PRINT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtEmb,_nLang,_dDtFab,dDatabase,yt)},"Imprimindo, aguarde...")
				Next yt
			EndIf
		Next xt
	 ElseIf lCHECK_1 == .T.	
		//RptStatus({|lEnd| U_DTR10PRT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtEmb,_nLang,_dDtFab,dDatabase,_nQtdCop)},"Imprimindo, aguarde...")
		//For yt := 1 to 2	    //        01           02              03       04     05      06      07     08  
		//	RptStatus({|lEnd| U_DTR10PRT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtEmb,_nLang,_dDtFab,dDatabase,yt)},"Imprimindo, aguarde...")
		//Next yt
		For xt := 1 to _nQtdCop  //-> Imprime para conferência.
			//Ajuste inclido por  : Samuel miranda dia 30/12/2025 para impressão das etiquesta de rastriabilidade.
			iF Alltrim(SB1->B1_XSTERI)="2"
				//For yt := 1 to 2	  //        01           02              03       04     05      06      07     08    
    			 RptStatus({|lEnd| U_DTR5PRINT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtEmb,_nLang,_dDtFab,dDatabase,yt)},"Imprimindo, aguarde...")
				//Next yt  //                   (lEnd,  _cProd,           _cLote,_nQuant,_nLang,_dFabric,_dDtEmis,_nCop,nvz,nTru)
			 Else					 //        01           02              03       04     05      06      07      08 09  
				//Ajuste inclido por  : Samuel miranda dia 30/12/2025 para impressão das etiquesta de rastriabilidade.
				For yt := 1 to 2	  //        01           02              03       04     05      06      07     08  
				 RptStatus({|lEnd| U_DTR5PRINT(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtEmb,_nLang,_dDtFab,dDatabase,yt)},"Imprimindo, aguarde...")
				Next yt
			EndIf
		Next xt
	EndIf
EndIf

//Atualiza as variaveis
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
