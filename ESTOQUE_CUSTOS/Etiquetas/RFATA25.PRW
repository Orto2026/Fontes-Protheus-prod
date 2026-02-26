#Include "Protheus.Ch"
#Include "rwmake.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATA25  ³ Autor ³Samuel Mirada			  ³ Data ³ 03/08/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Impressao de Etiqueta atraves da leitura da OP   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATA25()	

Private oDlg1, oOP, oLang, oQtde, oSair

_cOP 	:= Space(LEN(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
_cLang	:= ""
_nQtd 	:= 1
_nQtd2 	:= 0
_nQtd3	:= 1
_aCbx 	:= {"1-Português", "2-Inglês", "3-Espanhol"}
_dDtFab	:= dDatabase

DEFINE MSDIALOG oDlg1 TITLE "Impressão de Etiquetas" FROM 200,70 TO 500,450 PIXEL
@ 003, 4 To 150,190
@ 010, 10 SAY "Ordem de Produção " 	SIZE 70,50
@ 030, 10 SAY "Idioma " 				SIZE 50,50
@ 050, 10 SAY "Qtde. Rotulos" 				SIZE 50,50
@ 070, 10 SAY "Pcs / Embalagem "			SIZE 50,50
@ 090, 10 SAY "Data Fabricação "			SIZE 50,50
//@ 090, 10 SAY "Qtde Etq. Filhas"			SIZE 50,50 // Retirado por Samuel Mirnada 20190607 a pedido da Lullis do Depto. Assunt. Regurlatorios 
//@ 110

@ 010, 60 MSGET 		oOP  	VAR _cOP 	F3 "SC2" PICTURE "@!" VALID ValidOP(_cOP) SIZE 80,7 OF oDlg1 PIXEL
@ 030, 60 MSCOMBOBOX 	oLang 	VAR _cLang  ITEMS _aCbx SIZE 075, 65 OF oDlg1 PIXEL
@ 050, 60 MSGET 		oQtde	VAR _nQtd	PICTURE "999" SIZE 20,7 OF oDlg1 PIXEL
@ 070, 60 MSGET 		oQtde2	VAR _nQtd2	PICTURE "999" SIZE 20,7 OF oDlg1 PIXEL 
@ 090, 60 MSGET 		oDtFab	VAR _dDtFab	PICTURE "@D" VALID !Empty(_dDtFab) SIZE 60,7 OF oDlg1 PIXEL
//@ 090, 60 MSGET 		oQtde3	VAR _nQtd3	PICTURE "999" SIZE 20,7 OF oDlg1 PIXEL      // Retirado por Samuel Mirnada 20190607 a pedido da Lullis do Depto. Assunt. Regurlatorios 
// @ 110,

@ 130, 050 Button oOK  	Prompt "Imprimir" 	Size 25, 13 Action ChkOpc(_cOP) OF oDlg1 PIXEL
@ 130, 150 Button oSair	Prompt "Sair" 		Size 25, 13 Action Close(oDlg1) OF oDlg1 PIXEL

ACTIVATE MSDIALOG oDlg1 CENTERED

DlgRefresh(oDlg1)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º  Funcao  ³ ValidOP  ºAutor  ³Microsiga           º Data ³  26/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a OP Scaneada e Imprime a Etiqueta                  º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º  Funcao  ³ ChkOpc   ºAutor  ³Microsiga           º Data ³  03/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa a Impressao da Etiqueta                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ChkOpc(_cNumOP)

dbSelectArea("SC2")
dbSetOrder(1)
If dbSeek(xFilial("SC2")+(Substr(_cNumOP,1,8)+'001'))

	_nLang := Val(SubStr(_cLang,1,1))
	
	_nQuant := SC2->C2_QUANT
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
	If FieldPos("B1_XQTETIQ") <> 0
		dbSelectArea("SB5")
		dbSetOrder(1)
		If dbSeek(xFilial("SB5")+SB1->B1_COD)
			_nQtdEmb := SB5->B5_QEI
		Else
			_nQtdEmb := 1
		EndIf
	EndIf

	If _nQtd2 <> 0
		_nQtdEmb := _nQtd2
	EndIf
    
	//RptStatus({|lEnd| U_REST11Imp(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtdEmb,"",_dDtFab,dDatabase,_nQtd,_nLang)},"Imprimindo, aguarde...")
	RptStatus({|lEnd| U_RESTR25Imp(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtdEmb,"",_dDtFab,dDatabase,_nQtd,_nLang, .T., _nQtd3)},"Imprimindo, aguarde...")
	//RptStatus({|lEnd| U_RESTR25Fil(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL,_nQtdEmb,"",_dDtFab,dDatabase,_nQtd,_nLang)},"Imprimindo etiquetas filhas, aguarde...")
EndIf

_cOP 		:= Space(LEN(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
_nLang	:= 1
_nQtd 	:= 1

Return()