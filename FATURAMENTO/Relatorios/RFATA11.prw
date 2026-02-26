#Include "Protheus.Ch"
#Include "rwmake.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATA11  ³ Autor ³ Joao Caros A.Neto     ³ Data ³ 28/05/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Conferencia do material retirado no balcao        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATA11()

Private oDlg, oSenha, oNome, oVale, oCli, oCapt, oClos
Private _Vale := Space(TAMSX3("F2_CHVNFE")[1])

DEFINE MSDIALOG oDlg TITLE "Conferencia Balcao" FROM 200,70 TO 400,500 PIXEL
//@ 200,70 To 400,450 Dialog oDlg Title OemToAnsi("Conferencia Balcao")
@ 3,4 To 75,210

@ 15,10  SAY "Numero da NF-e " SIZE 100,7

@  15,70 MSGET oVale  VAR _Vale PICTURE "@!"   Valid RFAVale(_Vale) F3 "SF2X"  SIZE 100,7 OF oDlg PIXEL

@  80,140 Button oCapt Prompt "Ok" Size 20,13 Action { || Close(oDlg), Captura(oDlg) }  OF oDlg PIXEL
@  80,175 Button oClos Prompt "Sair" Size 25,13 Action Close(oDlg) OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFAVALE  ³ Autor ³ Joao Caros A.Neto     ³ Data ³ 28/05/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida numero do vale digitado                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RFAVALE(cVale)
cArea := GetArea()
lRet := .T.
DbSelectArea("SF2")
If Len(AllTrim(cVale)) == 44
	DbOrderNickName("CHAVENFE")
	If !DbSeek(xFilial("SF2")+AllTrim(cVale),.F.) // Procura Pela Chave da Nf-e
		DbSetOrder(1)
		If !DbSeek(xFilial("SF2")+SubStr(cVale,1,12),.F.) // Procura pelo Nnumero da NF (F2_DOC+F2_SERIE)
			cTit	:= "NF-e Invalida"
			aOpc:= {"Fechar"}
			cMsg:= "NF-e nao esta cadastrada no sistema, digite novamente ou acione o suporte"
			nOpc:= Aviso(cTit,cMsg,aOpc)
			lRet := .F.
		EndIf
	Endif
Else
	DbSetOrder(1)
	If !DbSeek(xFilial("SF2")+SubStr(cVale,1,12),.F.) // Procura pelo Nnumero da NF (F2_DOC+F2_SERIE)
		cTit	:= "NF-e Invalida"
		aOpc:= {"Fechar"}
		cMsg:= "NF-e nao esta cadastrada no sistema, digite novamente ou acione o suporte"
		nOpc:= Aviso(cTit,cMsg,aOpc)
		lRet := .F.
	EndIf
EndIf

DlgRefresh(oDlg)
RestArea(cArea)
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CAPTURA  ³ Autor ³ Joao Caros A.Neto     ³ Data ³ 28/05/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Abre tela de captura dos materais via coletor               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CAPTURA()

Local aCampos := {}
AADD(aCampos,{ "NOTA"   	, "C",TAMSX3("F2_DOC")[1]		,TAMSX3("F2_DOC")[2] 	, "@!" } )
AADD(aCampos,{ "SERIE"  	, "C",TAMSX3("F2_SERIE")[1]	,TAMSX3("F2_SERIE")[2] 	, "@!" } )
AADD(aCampos,{ "PRODUTO"   , "C",TAMSX3("B1_COD")[1]		,TAMSX3("B1_COD")[2]		, "@!" } )
AADD(aCampos,{ "LOTE"   	, "C",TAMSX3("D2_LOTECTL")[1]	,TAMSX3("D2_LOTECTL")[2], "@!" } )
AADD(aCampos,{ "QUANT"     , "N",TAMSX3("D2_QUANT")[1]	,TAMSX3("D2_QUANT")[2]	, "@E 999999.99" } )

cArq := CriaTrab(aCampos,.t.)
dbUseArea(.T.,,cArq,"TRB",.F.,.F.)

cInd := CriaTrab(NIL,.F.)
cChave := "NOTA+SERIE+PRODUTO+LOTE"
IndRegua("TRB",cInd,cChave,,,"Selecionando registros")

dbClearIndex()
dbSetIndex(cInd + OrdBagExt())

_Produto	:= Space(TAMSX3("B1_COD")[1])
_Descri 	:= Space(TAMSX3("B1_DESC")[1])
_Lote		:= Space(TAMSX3("D2_LOTECTL")[1])
_Quant	:= 1

DEFINE MSDIALOG oDlg1 TITLE "Coleta de materiais" FROM 200,70 TO 400,450 PIXEL
@ 3,4 To 75,180
@ 10,10 SAY "Produto " 		SIZE 70,50
@ 25,10 SAY "Descricao " 	SIZE 80,50
@ 40,10 SAY "Lote " 			SIZE 70,50
@ 55,10 SAY "Quantidade " 	SIZE 80,50

@ 10,40 MSGET oProd VAR _Produto F3 "SB1" PICTURE "@!" VALID Empty( _Produto ) .or. RFAProd(_Produto);
WHEN _Descri := Iif( !Empty( _Produto ), SB1->B1_DESC, Space(30)) ;
SIZE 70,7 OF oDlg1 PIXEL

@ 25,40 MSGET oDesc VAR _Descri Picture "@!" When .F.  SIZE 100,7 OF oDlg1 PIXEL
@ 40,40 MSGET oLote VAR _Lote PICTURE "@!"  VALID !Empty(_Lote) SIZE 70,7 OF oDlg1 PIXEL
@ 55,40 MSGET oQuant VAR _Quant PICTURE "999999.99" SIZE 70,7 OF oDlg1 PIXEL

@ 80,060 Button oGrava Prompt "Ok" Size 20,13 Action RFAGrava(oDlg1) OF oDlg1 PIXEL
@ 80,092 Button oVerif Prompt "Verifica NF-e" Size 55,13 Action Processa( { || Close(oDlg1), RFACRITICA() } ) OF oDlg1 PIXEL
@ 80,150 Button oSair Prompt "Sair" Size 25,13 Action Close(oDlg1) OF oDlg1 PIXEL
ACTIVATE MSDIALOG oDlg1 CENTERED

If File(cArq+".dbf")
	DbSelectArea("TRB")
	DbCloseArea()
	FErase(cArq+".dbf")
	FErase(cArq+".cdx")
	FErase(cArq+".idx")
Endif

_Vale := Space(TAMSX3("F2_CHVNFE")[1])

DlgRefresh(oDlg)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFAPROD  ³ Autor ³ Joao Caros A.Neto     ³ Data ³ 28/05/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida Produto digitado                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RFAPROD(cProduto)
cArea := GetArea()
lRet := .T.

If Empty(cProduto)
	oVerif:SetFocus()
	Return(lRet)
Endif
DbSelectArea("SB1")
DbSetOrder(5)
If !DbSeek(xFilial("SB1")+cProduto,.F.)
	dbSetOrder(1)
	If !DbSeek(xFilial("SB1")+cProduto,.F.)
		cTit	:= "Produto Invalido"
		aOpc:= {"Fechar"}
		cMsg:= "Produto nao cadastrado no sistema, digite novamente ou acione o suporte"
		nOpc:= Aviso(cTit,cMsg,aOpc)
		lRet := .F.
	EndIf
Else
	_Produto := SB1->B1_COD
	_Descri 	:= SB1->B1_DESC
Endif
DlgRefresh(oDlg1)
RestArea(cArea)

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFAGRAVA ³ Autor ³ Joao Caros A.Neto     ³ Data ³ 28/05/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava Dados coletados em arquivos de trabalho para          ³±±
±±³          ³posterios veirficacao                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RFAGRAVA()

cArea := GetArea()

If !Empty(_Produto)
	DbSelectArea("TRB")
	If !DbSeek(SF2->(F2_DOC+F2_SERIE)+_Produto+_Lote,.F.)
		RecLock("TRB",.T.)
		TRB->NOTA  		:= SF2->F2_DOC
		TRB->SERIE  	:= SF2->F2_SERIE
		TRB->PRODUTO	:= _Produto
		TRB->LOTE		:= _Lote
		TRB->QUANT		:= _Quant
		MsUnLock()
	Else
		RecLock("TRB",.F.)
		TRB->QUANT		:= TRB->QUANT + _Quant
		MsUnLock()
	Endif
Endif
If !Empty(_Produto)
	oProd:SetFocus()
Endif

_Produto	:= Space(TAMSX3("B1_COD")[1])
_Descri 	:= Space(TAMSX3("B1_DESC")[1])
_Lote		:= Space(TAMSX3("D2_LOTECTL")[1])
_Quant	:= 1

DlgRefresh(oDlg1)
RestArea(cArea)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RFACRITICA³ Autor ³ Joao Caros A.Neto     ³ Data ³ 28/05/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Confronta dadoss coletados em arquivos de trabalho para     ³±±
±±³          ³posterios veirficacao                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RFACRITICA()

cArea := GetArea()

aVale			:= {}
aProduto		:= {}
aQtdColeta	:= {}
aQtdVale		:= {}
aQtdStru		:= {}
aLtColeta	:= {}
aLtVale		:= {}
aCritica		:= {}
aCritica1	:= {}
aChave		:= {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Analisa Divergencias Partindo do Arquivo de Coleta                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SD2")
cIndex1 := CriaTrab(nil,.f.)
cChave  := "D2_FILIAL+D2_DOC+D2_SERIE+D2_COD+D2_LOTECTL"
IndRegua("SD2",cIndex1,cChave,,,OemToAnsi("Selecionando Registros..."))
DbGotop()

DbSelectArea("TRB")
DbGotop()
ProcRegua(RecCount())

While !Eof()
	
	IncProc("Analisando coleta")
	
	DbSelectArea("SD2")
	If !DbSeek(xFilial("SD2")+TRB->NOTA+TRB->SERIE+TRB->PRODUTO+TRB->LOTE,.F.)
		AAdd(aVale     , TRB->NOTA+"-"+TRB->SERIE)
		AAdd(aProduto  , TRB->PRODUTO)
		AAdd(aQtdColeta, TRB->QUANT)
		AAdd(aQtdVale  , 0)
		AAdd(aQtdStru  , 0)
		AAdd(aLtColeta , TRB->LOTE)
		AAdd(aLtVale   , "")
		AAdd(aCritica  , "Produto e/ou Lote nao existe na NF")
		AAdd(aCritica1 , "")
		AADD(aChave    , TRB->PRODUTO+TRB->LOTE)
	Else
		_nQtdNF := 0 // Soma itens da Nota Caso tenha 02 itens igual na mesma nota (NOTA+SERIE+PRODUTO+LOTE)
		While !Eof() .And. xFilial("SD2")+TRB->NOTA+TRB->SERIE+TRB->PRODUTO+TRB->LOTE ==;
							SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_COD+D2_LOTECTL)
			_nQtdNF += SD2->D2_QUANT
			dbSkip()
		EndDo

		If Round(TRB->QUANT,2) <> Round(_nQtdNF,2)
			AAdd(aVale	   , TRB->NOTA+"-"+TRB->SERIE)
			AAdd(aProduto  , TRB->PRODUTO)
			AAdd(aQtdColeta, TRB->QUANT)
			AAdd(aQtdVale  , _nQtdNF)
			AAdd(aQtdStru  , 0)
			AAdd(aLtColeta , TRB->LOTE)
			AAdd(aLtVale   , SD2->D2_LOTECTL)
			AAdd(aCritica  , "Diverg quant Coletada e NF-e")
			AAdd(aCritica1 , "")
			AAdd(aChave    , TRB->PRODUTO+TRB->LOTE)
		Endif
	Endif
	DbSelectArea("TRB")
	DbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Analisa Divergencias Partindo do Arquivo de Pedido de Venda         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("TRB")
DbGotop()
ProcRegua(RecCount())

DbSelectArea("SD2")
DbGotop()
DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
While !Eof() .and. xFilial("SD2") == SD2->D2_FILIAL .and. SD2->D2_DOC == SF2->F2_DOC .AND. SD2->D2_SERIE == SF2->F2_SERIE
	
	IncProc("Analisando coleta")
	
	DbSelectArea("TRB")
	If !DbSeek(SD2->(D2_DOC+D2_SERIE+D2_COD+D2_LOTECTL),.F.)
		AAdd(aVale     , SD2->D2_DOC+"-"+SD2->D2_SERIE)
		AAdd(aProduto  , SD2->D2_COD)
		AAdd(aQtdVale  , SD2->D2_QUANT)
		AAdd(aQtdColeta, 0)
		AAdd(aQtdStru  , 0)
		AAdd(aLtColeta , " ")
		AAdd(aLtVale   , SD2->D2_LOTECTL)
		AAdd(aCritica  , "Produto nao coletado")
		AAdd(aCritica1 , "")
		AADD(aChave    , SD2->D2_COD+SD2->D2_LOTECTL)
	Endif
	DbSelectArea("SD2")
	DbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Analisa Divergencias Entre Vale e Estrutura dos itens que nao possuem RASTREABILIDADE  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aNum	:= {}
aProd	:= {}
aQtdVen	:= {}
aQtdStr	:= {}
aCrit	:= {}
aChave1	:= {}

If Len(aVale) == 0
	MsgInfo("Coleta realizada com sucesso, nao ha divergencias")
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Critica                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RFAReport() } )
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAREPORT º Autor ³ Joao Carlos A.Neto º Data ³  30/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao das divergencia entre a coleta e o vale          º±±
±±º          ³ dos implantes estereis                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RFAReport()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Analise dos materiais coletados"
Local cPict          := ""
Local titulo       	:= "Analise dos materiais coletados"
Local nLin         	:= 80

//                     0         1         2         3         4         5         6         7         8         9         100       110       120       130
//                     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
Local Cabec1       := "Nota Fiscal"
Local Cabec2       := "Produto          Descricao                       Qt Coleta    Qt NF-e   Lt Coleta   Lt NF-e     Critica

Local imprime      	:= .T.
Local aOrd 				:= {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite			:= 132
Private tamanho		:= "M"
Private nomeprog		:= "RFATA11"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RFATA11"
Private cString 		:= "SD2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  30/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao das divergencia entre a coleta e o vale          º±±
±±º          ³ dos implantes estereis                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local i
Local nOrdem
Local _nX
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(Len(aVale))
If Len(aVale) > 0
	For i := 1 to Len(aVale)
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		If dbSeek(xFilial("SB1")+aProduto[i],.F.)
			If B1_RASTRO == "L"
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao do cabecalho do relatorio. . .                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nLin > 55
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
					nLin++
					@ nLin,00 PSAY "Numero da NF-e: "+ aVale[i]
					nLin++
				Endif
				
				@ nLin,00 PSAY aProduto[i]
				@ nLin,17 PSAY Left(Posicione("SB1",1,xFilial("SB1")+aProduto[i],"B1_DESC"),30)
				@ nLin,49 PSAY Transform(aQtdColeta[i],"@e 999999.99")
				@ nLin,60 PSAY Transform(aQtdVale[i],"@e 999999.99")
				@ nLin,73 PSAY aLtColeta[i]
				@ nLin,85 PSAY aLtVale[i]
				For _nX := 1 To Len(AllTrim(aCritica[i])) Step 21
					If _nX > 21
						nLin++
					EndIf
					@ nLin,096 PSAY SubStr(aCritica[i],_nX,21)
				Next _nX
				If !Empty(aCritica1[i])
					nLin++
					@ nLin,096 PSAY aCritica1[i]
				Endif
				nLin++
			Endif
		Endif
	Next
Endif

//                     0         1         2         3         4         5         6         7         8         9         100       110       120       130
//                     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
Cabec1       := "Nota Fiscal"
Cabec2       := "Produto          Descricao                              Qtd NF-e   Qt Estru   Critica"
nLin := 80
SetRegua(Len(aNum))
i:=1
For i := 1 to Len(aNum)
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	If dbSeek(xFilial("SB1")+aProd[i],.F.)
		If SB1->B1_RASTRO <> "L" .and. SB1->B1_TIPO <> "CX"
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nLin > 55
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
				nLin++
				@ nLin,00 PSAY "Numero da NF-e: "+ aNum[i]
				nLin++
			Endif
			
			@ nLin,00 PSAY aProd[i]
			@ nLin,17 PSAY Left(Posicione("SB1",1,xFilial("SB1")+aProd[i],"B1_DESC"),30)
			@ nLin,49 PSAY Transform(aQtdVen[i],"@e 999999.99")
			@ nLin,60 PSAY Transform(aQtdStr[i],"@e 999999.99")
			@ nLin,72 PSAY aCrit[i]
			nLin++
		Endif
	Endif
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
