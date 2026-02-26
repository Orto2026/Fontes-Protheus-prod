#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR005 ºRevis.  ³Samuel Miranda     º Data ³  18/03/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para impressao de etiquetas de Produtos             º±±
±±º                                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTR005()

Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo 	:= "Impressão de etiqueta de Codigo de Produtos."

Private cDesc1 	:= "Este programa irá imprimir de Codigo "
Private cDesc2 	:= "de Produto , em impressora térmica Zebra, "
Private cDesc3 	:= "conforme os parâmetros definidos pelo usuário."
Private cDesc4 	:= ""
Private cDesc5 	:= ""
Private cPerg  	:= Padr("RESTR005",10)
Private lEnd 	:= .F.

VerSX1()

If !Pergunte(cPerg,.T.)
	Return()
Endif	

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )

aAdd( aButton, { 5, .T., { || Pergunte( cPerg, .T. )  } } )
aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch()            } } )

FormBatch( cTitulo, aSay, aButton )

If nOpc == 1
	RptStatus({|lEnd| RESTR05Imp(@lEnd)},"Imprimindo, aguarde...")
Endif	

Return()


Static Function RESTR05Imp(lEnd)

Local nCopias 		:= mv_par02
Local cImpressora := "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 	:= "0"
Local cFonte1 		:= "020,020"
Local cFonte2 		:= "017,017"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "015,015"
Local cFonte5 		:= "028,028"
Local cFonte6 		:= "032,032"
xCol := 02 //Valor da Coluna
yLin := 02 //Valor da Linha]

SetRegua(1)
dbSelectArea("SB1")
SB1->(dbSetOrder(1))
If SB1->(!dbSeek(xFilial("SB1")+mv_par01))
	APMsgAlert("Produto não localizado no cadastro, verifique.")
	Return()
Endif
IncRegua()
	
MSCBPRINTER(cImpressora,cPorta)	 
MSCBCHKStatus(.F.)
MSCBBEGIN(nCopias,4)           
		MSCBBOX(002,002,085,050,8)// Box da Borda
		MSCBSAY(xCol+35	,yLin+2,"DESCRICAO"									,"N",cTpFonte,cFonte5)
		MSCBSAY(xCol+2		,yLin+7,Alltrim(Substr(SB1->B1_DESC,1,31))	,"N",cTpFonte,cFonte6)
		MSCBSAY(xCol+2		,yLin+12,Alltrim(Substr(SB1->B1_DESC,32,70)),"N",cTpFonte,cFonte6)
		MSCBLINEH(003,22,084,5,"B") //Linha horizontal
		MSCBSAY(xCol+35	,yLin+22,"REFERENCIA"								,"N",cTpFonte,cFonte5)
		//MSCBLINEH(003,28,099,5,"B") //Linha horizontal		
		MSCBSAY(xCol+37	,yLin+28," "      +Alltrim(mv_par01)			,"N",cTpFonte,cFonte6)
		MSCBLINEH(003,34,084,5,"B") //Linha horizontal
		MSCBSAYBAR(xCol+4	,yLin+35,Alltrim(Upper(mv_par01)) 				,"N","MB07",8,.F.,.T.,.F.,,3,2,.F.)																				
MSCBEND() 
MSCBCLOSEPRINTER()	
MS_FLUSH()             

Return()


Static Function VerSx1()

Local aArea := GetArea()
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o codigo do produto.            " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR005","01","Codigo do Produto ? ","Codigo do Produto ?","Codigo do Produto ? ","mv_cha","C",15,0,0,"G","","SB1","","","mv_par01",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00?.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}


Aadd( aHelpPor, "Informe a quantidade de copias a ser    " )
Aadd( aHelpPor, "impressa.                               " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR005","02","Quantidade Copias ? ","Quantidade Copias ?","Quantidade Copias ? ","mv_chm","N",3,0,0,"G","","","","","mv_par02",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00502.",aHelpPor,aHelpEng,aHelpSpa)

RestArea(aArea)

Return()