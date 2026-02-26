#include "rwmake.ch"
//#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"           


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºFun‡"o    ³XANACRITPDº Autor ³ Joao Carlos A.Neto º Data ³     08/03/05º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡"o ³ Executa a analise critica do Pedido de Venda               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Espec¡fico para ORTOSINTESE                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function XANACRITPD() 

Private aOpc1   := {"Sim    ", "Não    "}//,""}
Private nOpc1   := 3
Private aOpc2   := {"Sim    ", "Não    "}//,""}
Private nOpc2   := 3
Private aOpc3   := {"Sim    ", "Não    "}//,""}
Private nOpc3   := 3
Private aOpc4   := {"Sim    ", "Não    "}//,""}
Private nOpc4   := 3
//Private aOpc5   := {"Sim    ", "Não    "," "} 
//Private nOpc5   := 3

@ 45,14 To 420,700 Dialog oDlg1 Title OemToAnsi("Analise Critica do Pedido") //@ 45,14 To 500,700 Dialog oDlg1 Title OemToAnsi("Analise Critica do Pedido")

@ 01,06 To 30,325 Title OemToAnsi("a) Os requisitos estao adequadamente definidos?")
@ 08,12 Radio aOpc1 Var nOpc1

@ 40,06 To 69,325 Title OemToAnsi("b) Os requisitos estao devidamente acordados?")
@ 47,12 Radio aOpc2 Var nOpc2

@ 79,06 To 108,325 Title OemToAnsi("c) Qualquer diferenca entre os requisitos do pedido, e aqueles definidos no orcamento estao resolvidos?")
@ 86,12 Radio aOpc3 Var nOpc3

@ 118,06 To 147,325 Title OemToAnsi("d) Temos capacidade de atender os requisitos especificados?")
@ 125,12 Radio aOpc4 Var nOpc4

//@ 128,06 To 159,300 Title OemToAnsi("e) Sera fabricado conforme sistematica ISO-9000?")
//@ 137,12 Radio aOpc5 Var nOpc5

@ 170 ,06 BmpButton Type 1 Action Autoriza()
@ 170 ,65 BmpButton Type 2 Action Close(oDlg1)

Activate Dialog oDlg1 Centered

Return(.T.)


Static Function Autoriza()
Local _nValiAut := "" //.T.
//Local _nValdOpc := ""

_nValiAut := NValid() 

//Valida a analise Critica do pedido. - Por Samuel Miranda - 25/02/2023
If _nValiAut == .F.//Validação das Perguntas
	//MsgYesNo("Deseja continuar sem verificar o criterio ", "Criterio")
	MsgAlert("Por favor verificar os criterios.","Analise Critica")
	Return()
Endif	

Close(oDlg1)

dbSelectArea("SC5")

M->C5_XOPC1             := IIf(nOpc1==1,"1",IIf(nOpc1==2,"2"," ")) //IIf(Cond=1,Result,IIf(Cond=2,Result2,Result 3))
M->C5_XOPC2             := IIf(nOpc2==1,"1",IIf(nOpc2==2,"2"," ")) //If(nOpc2==1,"1","2")
M->C5_XOPC3             := IIf(nOpc3==1,"1",IIf(nOpc3==2,"2"," ")) //If(nOpc3==1,"1","2")
M->C5_XOPC4             := IIf(nOpc4==1,"1",IIf(nOpc4==2,"2"," ")) //If(nOpc4==1,"1","2")
//M->C5_XOPC5             := If(nOpc5==1,"1","2")

RecLock("SC5",.F.) 
   	SC5->C5_XOPC1		:= M->C5_XOPC1
   	SC5->C5_XOPC2 		:= M->C5_XOPC2
   	SC5->C5_XOPC3		:= M->C5_XOPC3
   	SC5->C5_XOPC4	  	:= M->C5_XOPC4
     //SC5->C5_XOPC5	  	:= M->C5_XOPC5
MsUnlock()
Return()

/*-------------------------------------------------------------*
 | FUNÇÃO.: NValid                                            |
 | Desc: Valida se o Chekbos 9(sim / não)                     |  
 | Auto: Samuel Miranda   				   Data 13/02/2023    | 
 *-------------------------------------------------------------*/
Static Function NValid()
	Local _nChekOpc := .T.
	//Local _ListOpc	:= {"","","",""}

	If nOpc1 == 3
		_nChekOpc := .F.
		//_ListOpc[1]:= "A"
	EndIF
	If nOpc2 == 3
		_nChekOpc := .F.
		//_ListOpc[2]:= "B"
	EndIF
	If nOpc3 == 3
		_nChekOpc := .F.
		//_ListOpc[3]:= "C"
	EndIF
	If nOpc4 == 3
		_nChekOpc := .F.
		//_ListOpc[4]:= "D"
	EndIF
Return(_nChekOpc)
