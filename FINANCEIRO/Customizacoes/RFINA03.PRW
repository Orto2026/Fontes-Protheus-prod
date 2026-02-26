#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "tbiconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFINA03  ³ Autor ³ Montes - Thinkfast              ³ Data ³08/03/2023³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Leitura e Gravacao de cod barras em titulos de Ctas.a pagar          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 						                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ HISTORICO DE ATUALIZACOES DA ROTINA ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Desenvolvedor   ³ Data   ³Solic.³ Descricao                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                 ³        ³      ³                                               ³±±
±±³                 ³        ³      ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFINA03()
//Variaveis Locais da Funcao
Private dVencDe	 := dDataBase
Private dVencAt	 := dDataBase+365
Private nCents	    := 0
Private cLindig	 := Space(47)
Private cCodBar	 := Space(47)
Private nValor	 	 := 0
Private odVencDe
Private odVencAt
Private onCents
Private ocLindig
Private ocCodBar
Private onValor

// Variaveis Private da Funcao
Private _oDlg
Private INCLUI := .F.
// Privates das NewGetDados
Private oGet1
Private aCpoGDa       	:= {"E2_FILIAL","E2_PREFIXO","E2_NUM","E2_PARCELA","E2_TIPO","E2_NOMFOR","E2_VENCREA","E2_VALOR","E2_DECRESC","E2_FORNECE"}
Private aHeader      	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader
Private aCols        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols

// Vetor com os campos que poderao ser alterados
Private aAlter       	:= {""}
Private nSuperior    	:= C(046)           // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Private nEsquerda    	:= C(002)           // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Private nInferior    	:= C(218)           // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Private nDireita     	:= C(383)           // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
Private nOpc         	:= GD_INSERT+GD_DELETE+GD_UPDATE
Private cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols
Private cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Private cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.
// Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do
// segundo campo>+..."
Private nFreeze      	:= 000              // Campos estaticos na GetDados.
Private nMax         	:= 000              // Numero maximo de linhas permitidas. Valor padrao 99
Private cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo
Private cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Private cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols
// Objeto no qual a MsNewGetDados sera criada
Private oWnd         	:= _oDlg

Private npFILIAL        := 0
Private npPREFIXO       := 0
Private npNUM           := 0
Private npPARCELA       := 0
Private npTIPO          := 0
Private npFORNECE       := 0

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Captura Codigo de Barras para Titulos a Pagar") FROM C(229),C(201) TO C(666),C(965) PIXEL

// Cria Componentes Padroes do Sistema
@ C(002),C(003) Say "Vencimento de: " Size C(040),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(001),C(045) MsGet odVencDe Var dVencDe Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(002),C(147) Say "Vencimento Ate: " Size C(042),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(001),C(192) MsGet odVencAt Var dVencAt Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(002),C(280) Say "Variacao em Centavos:" Size C(054),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(001),C(340) MsGet onCents Var nCents Picture "@e 999.99" Size C(042),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(018),C(004) Say "Código de Barras:" Size C(038),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(017),C(044) MsGet ocCodBar Var cCodBar Size C(210),C(009) valid RVa01Vlr() COLOR CLR_BLACK PIXEL OF _oDlg
@ C(030),C(004) Say "Linha Digitável:" Size C(038),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(030),C(044) MsGet ocLinDig Var cLinDig Size C(210),C(009) valid RVa02Vlr() COLOR CLR_BLACK PIXEL OF _oDlg
@ C(023),C(280) Say "Valor:" Size C(015),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(023),C(300) MsGet onValor Var nValor Picture "@e 999,999,999.99" Size C(082),C(009) Valid 	RVa01Tit() COLOR CLR_BLACK PIXEL OF _oDlg

// Chamadas das GetDados do Sistema
MITAGet1()
ocLindig:bKeyDown := {|nKey,nFlag|alert()}
ACTIVATE MSDIALOG _oDlg CENTERED
 
Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³MITAGet1()  ³ Autor ³ Montes - Thinkfast    ³ Data ³08/03/2023³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da GetDados                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao ³ O Objeto oGet1  foi criado como Private no inicio do Fonte   ³±±
±±³           ³ desta forma voce podera trata-lo em qualquer parte do        ³±±
±±³           ³ seu programa:                                                ³±±
±±³           ³                                                              ³±±
±±³           ³ Para acessar o aCols desta MsNewGetDados: oGet1 :aCols[nX,nY]³±±
±±³           ³ Para acessar o aHeader: oGet1 :aHeader[nX,nY]                ³±±
±±³           ³ Para acessar o "n"    : oGet1 :nAT                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MITAGet1()
// Variaveis deste Form
Local nX			:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis da MsNewGetDados()      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Vetor responsavel pela montagem da aHeader
// Carrega aHead
DbSelectArea("SX3")
SX3->(DbSetOrder(2)) // Campo
For nX := 1 to Len(aCpoGDa)
	If SX3->(DbSeek(aCpoGDa[nX]))
		
		Aadd(aHeader,{ AllTrim(X3Titulo()),;
		               SX3->X3_CAMPO	  ,;
		               SX3->X3_PICTURE    ,;
		               SX3->X3_TAMANHO    ,;
		               SX3->X3_DECIMAL    ,;
		               SX3->X3_VALID	  ,;
		               SX3->X3_USADO	  ,;
		               SX3->X3_TIPO	      ,;
		               SX3->X3_F3 		  ,;
		               SX3->X3_CONTEXT    ,;
		               SX3->X3_CBOX	      ,;
		               SX3->X3_RELACAO})

	    If ALLTRIM(SX3->X3_CAMPO) == "E2_FILIAL" 
	       npFILIAL := Len(aHeader)
        ElseIf ALLTRIM(SX3->X3_CAMPO) == "E2_PREFIXO"
           npPREFIXO := Len(aHeader)
        ElseIf ALLTRIM(SX3->X3_CAMPO) == "E2_NUM"
           npNUM := Len(aHeader)
        ElseIf ALLTRIM(SX3->X3_CAMPO) == "E2_PARCELA"
           npPARCELA := Len(aHeader)
        ElseIf ALLTRIM(SX3->X3_CAMPO) == "E2_TIPO"
           npTIPO := Len(aHeader)
		ElseIf ALLTRIM(SX3->X3_CAMPO) == "E2_FORNECE"
           npFORNECE := Len(aHeader)
		EndIf
		
	EndIf
Next nX

// Carregue aqui a Montagem da sua aCol
aAux := {}
For nX := 1 to Len(aCpoGDa)
	If DbSeek(aCpoGDa[nX])
		Aadd(aAux,CriaVar(SX3->X3_CAMPO))
	Endif
Next nX
Aadd(aAux,"")
Aadd(aAux,.F.)
Aadd(aCols,aAux)

oGet1 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinhaOk,cTudoOk,cIniCpos,;
aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHeader,aCols)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()      ³ Autor ³ Montes - Thinkfast    ³ Data ³08/03/2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolução horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor
Do Case
	Case nHRes == 640	//Resolucao 640x480
		nTam *= 0.8
	Case nHRes >= 790 .and.nHRes <= 810 //Resolucao 800x600
		nTam *= 1
	OtherWise			//Resolucao 1024x768 e acima
		nTam *= 1.28
EndCase
If "MP8" $ oApp:cVersion
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para tema "Flat"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)

//Carrega aCols com Resultado do Cabecalho + linha digital e valor
Static Function Rva01Tit()
Local cCampo := ""
Local aAux 	 := {}
Local cQuery
Local cWhere
Local nA

cQuery := "SELECT "
For nA := 1 To Len(aCpoGda)
	cQuery += aCpoGDa[nA] + ","
Next
cQuery += "E2_LINDIG,"
cQuery := SubStr(cQuery,1,Len(cQuery)-1) + " "
cQuery += "FROM " + RetSqlName("SE2") + " "

cWhere := "WHERE E2_FILIAL >= '  ' " //E2_FILIAL = '" + xFilial("SE2") + "' "
cWhere += "AND E2_VENCREA >= '" + Dtos(dVencDe) + "' AND E2_VENCREA <= '" + Dtos(dVencAt) + "' "
cWhere += "AND ( "
cWhere += "(E2_VALOR >= " + Str(nValor-nCents) + " AND E2_VALOR <= " + Str(nValor+nCents) + ") OR ("
If UPPER(TcGetDb()) <> "ORACLE"
//	cWhere += "((E2_VALOR + E2_ACRESC - E2_DECRESC) + 0.01) >= " + Str(nValor-nCents) + " AND (E2_VALOR + E2_ACRESC - E2_DECRESC) <= " + Str(nValor+nCents) + " "
	cWhere += "((E2_SALDO + E2_SDACRES - E2_SDDECRE) + 0.01) >= " + Str(nValor-nCents) + " AND (E2_SALDO + E2_SDACRES - E2_SDDECRE) <= " + Str(nValor+nCents) + " "
Else
//	cWhere += "(E2_VALOR + E2_ACRESC - E2_DECRESC)  >= " + Str(nValor-nCents) + " AND (E2_VALOR + E2_ACRESC - E2_DECRESC) <= " + Str(nValor+nCents) + " "
	cWhere += "((E2_SALDO + E2_SDACRES - E2_SDDECRE) + 0.01) >= " + Str(nValor-nCents) + " AND (E2_SALDO + E2_SDACRES - E2_SDDECRE) <= " + Str(nValor+nCents) + " "
EndIf
cWhere += ")) "
cWhere += "AND E2_SALDO > 0 "
cWhere += "AND D_E_L_E_T_ <> '*' "

TcQuery cQuery+cWhere New Alias "QE2"
TcSetField("QE2","E2_VENCREA","D")

//MemoWrite("\query\rfina03.sql",cQuery+cWhere)

DbSelectArea("QE2")
DbGotop()

cExisLinDig := ""

aCols := {}
While !Eof()

	If !EMPTY(cLinDig) .And. RTRIM(QE2->E2_LINDIG) == RTRIM(cLinDig)
	   cExisLinDig := QE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
	Else
	   aAux 	:= {}
	   For nA := 1 to Len(aHeader)
		   cCampo := AllTrim(aHeader[nA,2])
		   Aadd(aAux,&cCampo)
	   Next
	   Aadd(aAux,.F.)
	   Aadd(aCols,aAux)
	EndIf
	
	dbSelectArea("QE2")
	dbSkip()
EndDo
QE2->(dbCloseArea())

If !EMPTY(cExisLinDig )
	Alert("Codigo de Barras ja presente no titulo: " + cExisLinDig)
	LimpaCpos()
	QE2->(dbCloseArea())
	Return
EndIf

oGet1 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinhaOk,cTudoOk,cIniCpos,;
aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHeader,aCols)
oGet1:oBrowse:Refresh()
oGet1:oBrowse:blDblClick := {|| RV01AT() }
oGet1:oBrowse:SetFocus()
Return(.T.)

//Atribui Valor do Código de Barras ao Campo nValor
Static Function RVa01Vlr()
Local cA , cB , cC , cD , cE , cF , cG , cH
If !Empty(cCodBar)
    /*
	Tratamento de codigo de barra de arrecadação 
	Fonte: http://wiki.biserp.com.br/index.php/Especifica%C3%A7%C3%A3o_de_Guias_e_Boletos#C.C3.B3digo_de_Barras_de_Arrecada.C3.A7.C3.A3o
	*/ 
    If LEN(RTRIM(cCodBar)) == 44 .And. LEFT(cCodBar,1) == "8" //Impostos e concessionarias
		cA		:= SubStr(cCodBar,1,11)
		cB		:= SubStr(cCodBar,12,11)
		cC		:= SubStr(cCodBar,23,11)
		cD		:= SubStr(cCodBar,34,11)
        cLinDig := PADR(cA + Modu10(cA) + cB + Modu10(cB) + cC + Modu10(cC) + cD + Modu10(cD),LEN(SE2->E2_LINDIG)) 
		nValor  := Val(SubStr(cCodBar,06,10))/100
    Else
		cA		:= SubStr(cCodBar,1,3)
		cB		:= SubStr(cCodBar,4,1)
		cF 	    := Modu10( Substr(cCodBar,1,4) + Substr(cCodBar,20,5) )
		cG 	    := Modu10( Substr(cCodBar,25,10) )
		cH 	    := Modu10( Substr(cCodBar,35,10) )
		cC		:= SubStr(cCodBar,20,5) + cF + SubStr(cCodBar,25,10) + cG + SubStr(cCodBar,35,10) + cH
		cD		:= SubStr(cCodBar,5,1)
		cE		:= SubStr(cCodBar,6,14)
		cLinDig := PADR(cA + cB + cC + cD + cE,LEN(SE2->E2_LINDIG))
		nValor  := Val(SubStr(cCodBar,10,10))/100
	EndIf
EndIf
Return(.t.)

//Atribui Valor da Linha Digital ao Campo nValor
Static Function RVa02Vlr()
Local cA , cB , cC , cD , cE
If !Empty(cLinDig)

	cLinDig := ALLTRIM(cLinDig)
	cLinDig := STRTRAN(cLinDig," ","")
	cLinDig := STRTRAN(cLinDig,".","")
	cLinDig := STRTRAN(cLinDig,"-","")
	cLinDig := STRTRAN(cLinDig,"/","")
	cLinDig := PADR(cLinDig,LEN(SE2->E2_LINDIG))

    If LEN(RTRIM(cLinDig)) = 48 //Impostos 
		cA		:= SubStr(cLinDig,1,11)
		cB		:= SubStr(cLinDig,13,11)
		cC		:= SubStr(cLinDig,25,11)
		cD		:= SubStr(cLinDig,37,11)
		cCodBar := PADR(cA + cB + cC + cD,LEN(SE2->E2_CODBAR)) 
		nValor  := Val(SubStr(cCodBar,06,10))/100   
    Else
		cA		:= SubStr(cLinDig,1,3)
		cB		:= SubStr(cLinDig,4,1)
		cC		:= SubStr(cLinDig,5,5) + SubStr(cLinDig,11,10) + SubStr(cLinDig,22,10)
		cD		:= SubStr(cLinDig,33,1)
		cE	    := StrZero(Val(SubStr(cLinDig,34,14)),14)
		cCodBar := PADR(cA + cB + cD + cE + cC,LEN(SE2->E2_CODBAR))
		nValor  := Val(SubStr(cLinDig,38,10))/100
	EndIf
EndIf
Return(.t.)


//Grava CodBar e LinDig e Dispara Gatilho pertinentes a mesma.
Static Function RV01AT()
Local cSql
Local k 	 := oGet1:nAt
Local nLinha := 0
Local lOk  	 := .F.

// nao executar quando nao encontrar ocorrencias
If empty(oGet1:aCols) .or. empty(oGet1:aCols[1,npNUM])
    MsgAlert("Não foram encontrados titulos que atendam as condições de filtro.",funname())
    LimpaCpos()
	return
EndIf

// validar para gravar o que nao estiver deletado
For k := 1 to len(oGet1:aCols)
	If !oGet1:aCols[k,len(aCols[k])]  // verifica se esta deletado
		
		If lOk
			MsgAlert("Existe mais de um titulo ativo, delete os títulos deixando apenas o titulo relacionado ao boleto ativo.",funname())
			return()
		Else
			lOk  	:= .T.
			nLinha  := k
		EndIf
		
	EndIf
Next

If !lOk
	MsgAlert("Para confirmar o processo é necessário que o título relacionado ao boleto fique ativo (não deletado).",funname())
	return()
EndIf

cSql := "UPDATE " + RetSqlName("SE2") + " SET "
cSql += "E2_LINDIG = '" + cLindig + "', "
cSql += "E2_CODBAR = '" + cCodBar + "', "
cSql += "E2_FORMPAG = '31' "
cSql += "WHERE E2_FILIAL = '" 	+ oGet1:aCols[nLinha,npFILIAL] + "' "
cSql += "AND E2_PREFIXO = '" 	+ oGet1:aCols[nLinha,npPREFIXO] + "' "
cSql += "AND E2_NUM = '" 		+ oGet1:aCols[nLinha,npNUM] + "' "
cSql += "AND E2_PARCELA = '" 	+ oGet1:aCols[nLinha,npPARCELA] + "' "
cSql += "AND E2_TIPO = '" 		+ oGet1:aCols[nLinha,npTIPO] + "' "
cSql += "AND E2_FORNECE = '" 	+ oGet1:aCols[nLinha,npFORNECE] + "' "
cSql += "AND D_E_L_E_T_ <> '*' "
nStatus := TcSqlExec(cSql)

If nStatus <> 0 
	MsgAlert("Erro ao atualizar o titulo:"+TCSqlError(),funname())
	return
EndIf

LimpaCpos()

Return

//Limpa Campos
Static Function LimpaCpos()
nValor	:= 0
cLindig := Space(47)
cCodBar	:= Space(47)
aCols	:= {}
oGet1   := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinhaOk,cTudoOk,cIniCpos,;
aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHeader,aCols)
ocLindig:Refresh()
onValor:Refresh()
oGet1:oBrowse:Refresh()
oGet1:oBrowse:blDblClick := {|| RV01AT() }
ocCodBar:SetFocus()
Return

/******************************************************************************************************************/
Static Function Modu10(cLinha)
/******************************************************************************************************************/
Local nSoma := 0
Local nResto
Local nCont
Local cDigRet
Local nResult
Local lDobra := .f.
Local cValor
Local nAux

For nCont := Len(cLinha) To 1 Step -1
	lDobra := !lDobra
	
	If lDobra
		cValor := AllTrim(Str(Val(Substr(cLinha, nCont, 1)) * 2))
	Else
		cValor := AllTrim(Str(Val(Substr(cLinha, nCont, 1))))
	EndIf
	
	For nAux := 1 To Len(cValor)
		nSoma += Val(Substr(cValor, nAux, 1))
	Next n
Next nCont

nResto := MOD(nSoma, 10)

nResult := 10 - nResto

If nResult == 10
	cDigRet := "0"
Else
	cDigRet := StrZero(10 - nResto, 1)
EndIf

Return cDigRet
