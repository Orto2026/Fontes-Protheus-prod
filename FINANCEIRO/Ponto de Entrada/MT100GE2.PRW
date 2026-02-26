#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ MT100GE2 ³ Autores ³ Montes - Thinkfast     ³ Data ³08/03/2023³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ PE na gravação do titulo do contas a pagar (SE2)              ³±±
±±³           ³ -> Depois que confirmar a gravação da nota entrada ira abrir  ³±±
±±³           ³    uma tela com opção de adcionar codigo de barras            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alteração ³                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT100GE2()

Local aArea    := GetArea()    //Guarda na memoria antes de executar rotina
Local aAreaSE2 := SE2->(GetArea()) // Guarda na memoria antes de executar rotina
Local aAreaSD1 := GetArea("SD1")
Local aAreaSC7 := GetArea("SC7")
//Local aTitAtual   := PARAMIXB[1]
//Local nOpc        := IIF(IsInCallStack("MATA103"),PARAMIXB[2],1)
//Local aHeadSE2    := PARAMIXB[3]
//Local aParcelas   := ParamIXB[5]
//Local nP          := ParamIXB[4]

//Ponto de Entrada atualizar Centro de Custo no Financeiro 
SD1->(DbSelectArea("SD1"))
SD1->(DbSetOrder(1))
SD1->(DbGotop())
SD1->(DbSeek(xFilial("SD1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)) )
DbSelectArea("SC7")
DbSetOrder(1)

If Empty(SD1->D1_CC)
	If DbSeek(xFilial("SD1") + SD1->D1_PEDIDO)
		
		SE2->(RecLock("SE2"))
		SE2->E2_CCD := SC7->C7_CC
		SE2->(MsUnLock())
		
	Endif
Else
	SE2->(RecLock("SE2"))
	SE2->E2_CCD := SD1->D1_CC
	SE2->(MsUnLock())	
Endif
//final do PE



Private _oDlg				// Dialog Principal
Private oFolder
Private oEdit1,oEdit2,oEdit3,oEdit4,oEdit5,oEdit6,oEdit7,oEdit7b,oEdit8,oEdit9,oEdit10,oEdit11,oEdit12,oEdit13,oEdit14,oEdit15,oEdit16,oEdit17,oEdit18,oEdit19,oEdit20

Private M->E2_FORMPAG := SE2->E2_FORMPAG //Space(TAMSX3("E2_FORMPAG")[1])
Private M->E2_CODBAR  := PADR(SE2->E2_CODBAR,MAX(TAMSX3("E2_CODBAR")[1],TAMSX3("E2_LINDIG")[1])+1)  //Space(TAMSX3("E2_CODBAR")[1])
Private M->E2_LINDIG  := PADR(SE2->E2_LINDIG,MAX(TAMSX3("E2_CODBAR")[1],TAMSX3("E2_LINDIG")[1])+1)
Private M->E2_HIST	  := SE2->E2_HIST    //Space(TAMSX3("E2_HIST")[1])
Private M->E2_VALOR   := SE2->E2_VALOR
Private M->E2_IRRF    := SE2->E2_IRRF  
Private M->E2_XCDARF  := IIF(SE2->(FIELDPOS("E2_XCDARF"))>0,SE2->E2_XCDARF,"") //Código da Receita do Tributo
//Private M->E2_XPERAPU := IIF(SE2->(FIELDPOS("E2_XPERAPU"))>0,SE2->E2_XPERAPU,"") //Período de Apuração
//Private M->E2_XREFDAR := IIF(SE2->(FIELDPOS("E2_XREFDAR"))>0,SE2->E2_XREFDAR,"") //Número de Referência
Private M->E2_XCOMPGP := IIF(SE2->(FIELDPOS("E2_XCOMPGP"))>0,SE2->E2_XCOMPGP,"") //Mês e ano de competência  - MM/AAAA
Private M->E2_MULTA   := SE2->E2_MULTA
Private M->E2_JUROS   := SE2->E2_JUROS
Private lOk      	    := .F.
Private _cModLib	    := "01/03/05/30/31/41/43/99/11/13/16/17/18/22" //Modelos de Pagamentos habilitados
Private cCodBar       := SPACE(51) 

If SE2->(FIELDPOS("E2_XCDARF"))>0 .And. EMPTY(M->E2_XCDARF) .And. !EMPTY(SE2->E2_CODRET)
   M->E2_XCDARF := PADR(SE2->E2_CODRET,LEN(M->E2_XCDARF))
EndIf

If IsInCallStack("GPEM670") //Origem da Folha de Pagamento

	SE2->E2_FORMPAG := IIf(!Empty(M->E2_FORMPAG),"99",M->E2_FORMPAG)
	SE2->E2_CODBAR  := M->E2_CODBAR
	SE2->E2_LINDIG  := M->E2_LINDIG
	SE2->E2_HIST    := M->E2_HIST

ElseIf SE2->E2_TIPO $ "NF /DP /FT /BOL/TX /DH /"

   dbSelectArea("SA2")
   dbSetOrder(1)
   dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
   dbSelectArea("SE2")

   Private M->A2_BANCO   := SA2->A2_BANCO
   Private M->A2_AGENCIA := SA2->A2_AGENCIA
   Private M->A2_NUMCON  := SA2->A2_NUMCON
   Private M->A2_DVCTA   := SA2->A2_DVCTA

   DEFINE MSDIALOG _oDlg TITLE "Informe os dados complementares da parcela" FROM C(300),C(230) TO C(529),C(805) PIXEL

   @ C(006),C(004) Say "Parcela"         Size C(037),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
   @ C(006),C(115) Say "Vencimento"      Size C(037),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
   @ C(021),C(004) Say "Valor"           Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF _oDlg
   @ C(021),C(116) Say "Modelo"          Size C(037),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
   @ C(036),C(003) Say "Tipo de Pagto"   Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF _oDlg
   @ C(036),C(116) Say "Historico"       Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF _oDlg

   @ C(005),C(045) MsGet oEdit1 Var SE2->E2_PARCELA Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg WHEN .F.
   @ C(005),C(163) MsGet oEdit2 Var SE2->E2_VENCTO  Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg WHEN .F.
   @ C(020),C(045) MsGet oEdit3 Var SE2->E2_VALOR   Size C(060),C(009) COLOR CLR_BLACK PICTURE PesqPict("SE2","E2_VALOR") PIXEL OF _oDlg WHEN .F.
   @ C(024),C(162) MsGet oEdit4 Var M->E2_FORMPAG   Size C(020),C(009) COLOR CLR_BLACK PICTURE VALID (!EMPTY(M->E2_FORMPAG) .And. Existcpo("SX5","58"+M->E2_FORMPAG) .And. CheckMP(M->E2_FORMPAG)) F3 "58 " PIXEL OF _oDlg
   @ C(036),C(162) MsGet oEdit6 Var M->E2_HIST      Size C(100),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
                                 
   //TFolder(): New ( [ nTop], [ nLeft], [ aPrompts], [ aDialogs], [ oWnd], [ nOption], [ nClrFore], [ nClrBack], [ lPixel], [ uParam10], [ nWidth], [ nHeight], [ cMsg], [ uParam14] ) --> oObjeto
   oFolder := TFolder():New(C(054),C(001),{"Codigo de Barras","Conta para credito","DARF","GPS","GARE ICMS SP"},,_oDlg,,,,.T.,,C(280),C(048))
   oFolder:aEnable(1,(Alltrim(M->E2_FORMPAG)$"30/31/11/13"))
   oFolder:aEnable(2,(Alltrim(M->E2_FORMPAG)$"01/03/05/41/43/99"))
   oFolder:aEnable(3,(Alltrim(M->E2_FORMPAG)$"16/18"))
   oFolder:aEnable(4,(Alltrim(M->E2_FORMPAG)$"17"))
   oFolder:aEnable(5,(Alltrim(M->E2_FORMPAG)$"22"))
   oFolder:SetOption(1)
   
   //Codigo de Barras
   @ C(003),C(003) Say "Cod. Barra"       Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[1] 
   @ C(003),C(045) MsGet oEdit7 Var M->E2_CODBAR  Valid ValCodBar(M->E2_FORMPAG) Size C(120),C(009) WHEN .F. COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[1] 

   @ C(018),C(003) Say "Linha digitável"       Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[1]
   @ C(018),C(045) MsGet oEdit7b Var M->E2_LINDIG  Valid ValCodBar(M->E2_LINDIG) Size C(120),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[1] 

   //Dados bancarios do beneficiario
   @ C(003),C(003) Say "Banco (*) :"      Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[2]
   @ C(003),C(045) MsGet oEdit8 Var M->A2_BANCO  Picture "@!" Valid (/*oEdit9:SetFocus()*/,.T.) Size C(010),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[2]

   @ C(003),C(103) Say "Agencia (*) :"    Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[2]
   @ C(003),C(145) MsGet oEdit9 Var M->A2_AGENCIA  Picture "@!" Valid (/*oEdit10:SetFocus()*/,.T.) Size C(020),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[2]

   @ C(018),C(003) Say "Conta (*) :"      Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[2]
   @ C(018),C(045) MsGet oEdit10 Var M->A2_NUMCON  Picture "@!" Valid (/*oEdit11:SetFocus()*/,.T.) Size C(050),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[2]

   @ C(018),C(103) Say "Dig.Cta. (*):"    Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[2]
   @ C(018),C(145) MsGet oEdit11 Var M->A2_DVCTA  Picture "@!" Valid .T. Size C(050),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[2]
                                                                            
   //DARF
   @ C(003),C(003) Say "Cod.Receita (*) :"  Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[3]
   @ C(003),C(045) MsGet oEdit12 Var M->E2_XCDARF  Picture "@!" Valid (.T.) Size C(010),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[3]

   //@ C(003),C(103) Say "Period.Apur.(*) :"  Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[3]
   //@ C(003),C(145) MsGet oEdit13 Var M->E2_XPERAPU  Picture "@D" Valid (.T.) Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[3]

   //@ C(018),C(003) Say "Num.Referen.(*) :"  Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[3]
   //@ C(018),C(045) MsGet oEdit14 Var M->E2_XREFDAR  Picture "@X" Valid (.T.) Size C(050),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[3]
   
   @ C(003),C(203) Say "Multa (*) :"  Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[3]
   @ C(003),C(240) MsGet oEdit15 Var M->E2_MULTA  Picture "@E 999,999,999.99" Valid (.T.) When SE2->E2_ACRESC > 0 Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[3]

   @ C(018),C(203) Say "Juros (*) :"  Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[3]
   @ C(018),C(240) MsGet oEdit16 Var M->E2_JUROS  Picture "@E 999,999,999.99" Valid (.T.) When SE2->E2_ACRESC > 0 Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[3]

   //GPS
   @ C(003),C(003) Say "Cod.Receita (*) :"  Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[4]
   @ C(003),C(045) MsGet oEdit17 Var M->E2_XCDARF  Picture "@!" Valid (.T.) Size C(010),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[4]

   @ C(018),C(003) Say "Mes Compet. (*) :"  Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[4]
   @ C(018),C(045) MsGet oEdit18 Var M->E2_XCOMPGP  Picture "@R 99/9999" Valid (.T.) Size C(050),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[4]

   @ C(003),C(103) Say "Outra Entid.(*) :"  Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[4]
   @ C(003),C(145) MsGet oEdit19 Var M->E2_MULTA    Picture "@E 999,999,999.99" Valid (.T.) Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[4]

   @ C(018),C(103) Say "Atual.Monet.(*) :"  Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[4]
   @ C(018),C(145) MsGet oEdit20 Var M->E2_JUROS    Picture "@E 999,999,999.99" Valid (.T.) Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[4]
   
   //GARE ICMS SP 
   @ C(003),C(003) Say "Cod.Receita (*) :"  Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[5]
   @ C(003),C(045) MsGet oEdit21 Var M->E2_XCDARF  Picture "@!" Valid (.T.) Size C(010),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[5]

   @ C(018),C(003) Say "Mes Compet. (*) :"  Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[5]
   @ C(018),C(045) MsGet oEdit22 Var M->E2_XCOMPGP  Picture "@R 99/9999" Valid (.T.) Size C(050),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[5]

   @ C(003),C(103) Say "Multa (*) :"  Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[5]
   @ C(003),C(145) MsGet oEdit23 Var M->E2_MULTA  Picture "@E 999,999,999.99" Valid (.T.) When SE2->E2_ACRESC > 0 Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[5]

   @ C(018),C(103) Say "Juros (*) :"  Size C(037),C(008) COLOR CLR_BLUE  PIXEL OF oFolder:aDialogs[5]
   @ C(018),C(145) MsGet oEdit24 Var M->E2_JUROS  Picture "@E 999,999,999.99" Valid (.T.) When SE2->E2_ACRESC > 0 Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oFolder:aDialogs[5]

   DEFINE SBUTTON FROM C(008),C(257) TYPE 1 ENABLE OF _oDlg ACTION (lOk := .T. , _oDlg:End())
   DEFINE SBUTTON FROM C(027),C(258) TYPE 2 ENABLE OF _oDlg ACTION If(MsgYesNo("Confirma sair sem gravar?"),_oDlg:End(),)

   ACTIVATE MSDIALOG _oDlg CENTERED

   If lOk
		If IsInCallStack("U_F050INC") .Or. IsInCallStack("U_F050ALT")
			RecLock("SE2",.F.)
		EndIf
		SE2->E2_FORMPAG := M->E2_FORMPAG 
		SE2->E2_CODBAR  := M->E2_CODBAR
		SE2->E2_LINDIG  := M->E2_LINDIG
		SE2->E2_HIST    := M->E2_HIST
		If SE2->(FIELDPOS("E2_XCDARF")) > 0 
			SE2->E2_XCDARF := M->E2_XCDARF //Código da Receita do Tributo
      EndIf
      If SE2->(FIELDPOS("E2_XCOMPGP")) > 0
			SE2->E2_XCOMPGP := M->E2_XCOMPGP //Mês e ano de competência  - MM/AAAA
      EndIf            
      If SE2->(FIELDPOS("E2_XPERAPU")) > 0
			SE2->E2_XPERAPU := M->E2_XPERAPU //Período de Apuração
		EndIf
      If SE2->(FIELDPOS("E2_XREFDAR")) > 0
			SE2->E2_XREFDAR := M->E2_XREFDAR //Número de Referência
		EndIf
		SE2->E2_MULTA   := M->E2_MULTA
		SE2->E2_JUROS   := M->E2_JUROS

		If Alltrim(M->E2_FORMPAG)$"01/03/05/41/43/99"
			SE2->E2_FORBCO   := M->A2_BANCO
			SE2->E2_FORAGE   := M->A2_AGENCIA
			SE2->E2_FORCTA   := M->A2_CONTA
			SE2->E2_FCTADV   := M->A2_DVCTA
      EndIf

		If IsInCallStack("U_F050INC") .Or. IsInCallStack("U_F050ALT")
			MsUnLock()
		EndIf
      
		If Alltrim(M->E2_FORMPAG)$"01/03/05/41/43/99" .And. SA2->(!EOF())
			dbSelectArea("SA2")
			RecLock("SA2",.F.)
			SA2->A2_BANCO   := M->A2_BANCO
			SA2->A2_AGENCIA := M->A2_AGENCIA
			SA2->A2_CONTA   := M->A2_CONTA
			SA2->A2_DVCTA   := M->A2_DVCTA
			SA2->(MsUnLock())
			dbSelectArea("SE2")
		EndIf
	EndIf
EndIf

SE2->(RestArea(aAreaSE2))
RestArea(aAreaSC7)
RestArea(aAreaSD1)
RestArea(aArea)            

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CheckMP  º Autor ³ Montes - Way2      º Data ³ 07/06/2021  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Modalidade de Pagamento digitada                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CheckMP(_cModPag)

Local acbrowold    := acbrowse

Private _aArea	    := GetArea()
Private _aArSA2    := SA2->(GetArea())
Private _lRet	    := .T.
Private _cBanco    := ""      
Private nLimMaxDOC := 4999.00 // limite máximo para DOC
                 
_cModPag := PADR(_cModPag,2)

If Empty(_cModPag)
	
   MsgBox(" Informe um modelo de pagamento válido! ","Erro","INFO")
   _lRet := .F.
	
Else
	
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA))
	
	_cBanco := SA2->A2_BANCO
	
	If Empty(_cBanco) .And. _cModPag $ "01/03/05/41/43" // TEF,DOC,TED
		
	    MsgBox("Nao informado dados bancarios para pagamento deste fornecedor.!","Aviso","INFO")
		//If MsgBox(" Nao existe Banco cadastrado para este fornecedor. Deseja alterar cadastro? ","Banco Não Cadastrado","YESNO")
		//	
		//	dbSelectArea("SA2")
		//	AxAltera("SA2",SA2->(Recno()),4)
		//	_lRet := .F.
		//Else
		//	_lRet := .F.
		//EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Compara Banco Informado Na Dialog Com Dados Obtidos No Cadastro Do Fornecedor                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _cModPag $ "03" //DOC
	
	If SE2->E2_SALDO > nLimMaxDoc
	   MsgBox(" Para Valores Maiores Que R$ "+alltrim(TRANSFORM(nLimMaxDOC,"@e 99,999.99"))+" utilize a Modalidade 'TED'! ","Erro Modalidade De Pgto","ALERT")
	   _lRet := .F.
	EndIf

EndIf

If _lRet .And. !Upper(_cModPag) $ _cModLib

	_lRet := .F.

EndIf

RestArea(_aArSA2)
RestArea(_aArea)

acbrowse := acbrowold

/*
Opções do sistema Protheus (Tabela 58)
01-CREDITO EM CONTA CORRENTE  (SEG
03-DOC
05-CREDITO EM CONTA POUPANCA
11-Pagamento de Contas e Tributos com Códigos de Barras
16-PAGAMENTO DE TRIBUTOS - DARF NORMAL (A IMPLANTAR)
17-PAGAMENTO DE TRIBUTOS - GPS (A IMPLANTAR)
18-PAGAMENTO DE TRIBUTOS - DARF SIMPLES (A IMPLANTAR)
21-PAGAMENTO DE TRIBUTOS - DARJ (A IMPLANTAR)
22-PAGAMENTO DE TRIBUTOS - GARE ICMS SP
30-PAGAMENTO DE TITULOS EM COBRANCA NO MESMO BANCO (ITAU/BB)
31-PAGAMENTO DE TITULOS EM OUTRO BANCO
35-PAGAMENTO DE TRIBUTOS - FGTS - GFIP (VERIFICAR LAYOUT COM BB - PELO MANUAL NÃO ESTA HOMOLOGADO OU VERIFICAR UTILIZACAO DO SEGMENTO W1)
41-TED - OUTRO TITULAR
43-TED - MESMO TITULAR
*/
nFolder := 0
If _cModPag $ "30/31/11/13"
   nFolder := 1
ElseIf _cModPag $ "01/03/05/41/43/99"
   nFolder := 2
ElseIf _cModPag $ "16/18"
   nFolder := 3
ElseIf _cModPag $ "17"
   nFolder := 4
ElseIf _cModPag $ "22"
   nFolder := 5
EndIf
oFolder:aEnable(1,(nFolder = 1)) 
oFolder:aEnable(2,(nFolder = 2)) 
oFolder:aEnable(3,(nFolder = 3)) 
oFolder:aEnable(4,(nFolder = 4)) 
oFolder:aEnable(5,(nFolder = 5)) 
oFolder:SetOption(nFolder)
oFolder:Refresh()

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ValCodBar³ Autores ³ Montes - ThinkFast     ³ Data ³08/03/2023³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³Valida campo de Codigo de Barras                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValCodBar(cModelo)

Local aArea      := GetArea()
Local nTamCpo    := MAX(TAMSX3("E2_CODBAR")[1],TAMSX3("E2_LINDIG")[1])+1
Local lRet       := .F.
Local cCODBARANT := M->E2_CODBAR
Local cLINDIGANT := M->E2_LINDIG

If "E2_LINDIG"$ReadVar()
   M->E2_CODBAR := M->E2_LINDIG
EndIf 

M->E2_CODBAR := PADR(U_VLRCODBAR(),nTamCpo)
M->E2_LINDIG := PADR(U_TRFCODBAR(),nTamCpo)
oEdit7:Refresh()
oEdit7b:Refresh()

If !(lRet := U_VALCOD1())
   M->E2_CODBAR := cCODBARANT
   M->E2_LINDIG := cLINDIGANT
EndIf

RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Montes                 ³ Data ³07/06/2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)
