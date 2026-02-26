#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE2.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTA265I   บAutor  ณMicrosiga           บ Data ณ  07/15/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada no Final do Enderecamento para emissao    บฑฑ
ฑฑบ          ณ de Etiqueta de Produto para Produtos TIPO "SA" OU "PA"     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MTA265I()

Local _aArea   := GetArea()
Local _aAreaB1 := SB1->(GetArea())
//Local _nQtde    := ""
Private _nQtd  := 1

dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+SDA->DA_PRODUTO) .And. B1_TIPO $ "SA/BN" .And. B1_LOCPAD !='01'// Leonardo 
	If MsgYesNo("Deseja Imprimir Etiqueta para o Produto: "+SDA->DA_PRODUTO)
	//Chama tela para a coleta da quantidade a ser impresso // Por Samuel Miranda 15/04/2021
	RTELA01(_nQtd)
	   Mv_par01 := SDA->DA_PRODUTO
	   Mv_Par02 := SDA->DA_LOTECTL
	   Mv_Par03 :=Alltrim(Str(SDA->DA_QTDORI)) //Alterado por samuel Miranda 22/02/2021
	   Mv_Par04 := SDA->DA_DATA
	   Mv_Par05 := _nQtd // Por Samuel Miranda 15/04/2021
	   Mv_Par06 := SDA->DA_LOCAL
	   RptStatus({|lEnd| U_RESTR06Imp(@lEnd)},"Imprimindo, aguarde...")
	EndIf
EndIf

dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+SDA->DA_PRODUTO) .And. B1_TIPO == "PA" .And. SDA->DA_ORIGEM = "SD3" .And. B1_LOCPAD !='01' //Leonardo
	If MsgYesNo("Deseja Imprimir Etiqueta para o Produto: "+SDA->DA_PRODUTO)
	RTELA01(_nQtd)
	   Mv_par01 := SDA->DA_PRODUTO
	   Mv_Par02 := SDA->DA_LOTECTL
	   Mv_Par03 :=Alltrim(Str(SDA->DA_QTDORI)) //Alterado por samuel Miranda 22/02/2021
	   //Mv_Par03 := SDA->DA_QTDORI
	   Mv_Par04 := SDA->DA_DATA
	   Mv_Par05 := _nQtd
	    Mv_Par06 := SDA->DA_LOCAL
	   RptStatus({|lEnd| U_RESTR06Imp(@lEnd)},"Imprimindo, aguarde...")
	EndIf
EndIf

/*
If AllTrim(SDA->DA_LOCAL) $ "01/10"
	// Envia E-mail para o usuario pre definido que foi efetuado um enderecamento 
	SENDMAIL()
EndIf
*/

RestArea(_aAreaB1)
RestArea(_aArea)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ SENDMAIL ณ Autor ณ                       ณ Data ณ          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriฦo ณ Rotina de Envio de E-mail                                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Especifico ORTOSINTESE                                     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function SENDMAIL()
Local oProcess, oHtml
Local _lOk   := .F.
Local _cErro := ""
Local _nTent := 0

_cEmail 		:= "leandro@ortosintese.com.br;alessandra@ortosintese.com.br;andreia.pcp@ortosintese.com.br;edna.exp@ortosintese.com.br;ernani@ortosintese.com.br;fernando.nascimento@ortosintese.com.br"
oProcess 		:= TWFProcess():New( "000003", "Produto Enderecado" )
oProcess 		:NewTask( "Clientes" , "\WORKFLOW\ORTO\RMANA04.HTM")
oHtml    		:= oProcess:oHTML
oHtml:ValByName( "cDate"	, dDatabase 				)
oHtml:ValByName( "cProd"   	, AllTrim(SDA->DA_PRODUTO)	)
oHtml:ValByName( "cLocal"   , SDA->DA_LOCAL				)

oProcess:cSubject		:= 'Armaz้m '+AllTrim(SDA->DA_LOCAL)+' Produto '+AllTrim(SDA->DA_PRODUTO)+' Quantidade '+STR(SDA->DA_QTDORI,11,2)+' KG '
oProcess:cTo     		:= _cEmail
oProcess:cBody			:= "produto Endere็ado "
oProcess:Start()

Return

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RTELA01   บAutor  Samuel Miranda         บ Data ณ  15/04/21บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para captura da quantidade de etiquetas a ser impressa บฑฑ
ฑฑบ          ณ 														      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function RTELA01()

Private oDlg1, oQtde, oSair

DEFINE MSDIALOG oDlg1 TITLE "Quantidade a ser Impresso" FROM 070,20 TO 170,312 PIXEL
//@ 067, 020 To 169,312
@ 015, 005 SAY OemToAnsi("Digite a ser Impresso !") SIZE 80,8
@ 015, 085  MSGET oQtde	VAR _nQtd	PICTURE "999" SIZE 30,7 OF oDlg1 PIXEL
@ 030, 106 Button oOK  	Prompt "Imprimir" 	Size 25, 13 Action Close(oDlg1) OF oDlg1 PIXEL
@ 030, 055 Button oSair	Prompt "Sair" 		Size 25, 13 Action Close(oDlg1) OF oDlg1 PIXEL

ACTIVATE MSDIALOG oDlg1 CENTERED

Return(_nQtd) 
