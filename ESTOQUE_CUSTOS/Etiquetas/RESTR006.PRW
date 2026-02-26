#INCLUDE "PROTHEUS.CH"
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR006 ºAutor Reivis. Samuel Mirandaº Data ³  24/02/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de impressao de etiquetas de identificacao          º±±
±±º          ³ de Produtos Intermediarios.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function RESTR006()

Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo 	:= "Impressão de etiqueta de Identificacao de Produtos."

Private cDesc1 := "Este programa irá imprimir as etiquetas de "
Private cDesc2 := "Identificacao de Produto , em impressora térmica Zebra, "
Private cDesc3 := "conforme os parâmetros definidos pelo usuário."
Private cDesc4 := ""
Private cDesc5 := ""
Private cPerg  := Padr("RESTR006A",10)
Private lEnd   := .F.

ValidPerg()

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
	RptStatus({|lEnd| U_RESTR06Imp(@lEnd)},"Imprimindo, aguarde...")
Endif

Return()

User Function RESTR06Imp(lEnd)

Local nCopias 		:= mv_par05 //Val(alltrim(mv_par05))
Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 		:= "0"
//Local cFonte1 		:= "020,020"
//Local cFonte2 		:= "017,017"
//Local cFonte3 		:= "024,024"
//Local cFonte4 		:= "015,015"
Local cFonte5 		:= "026,026"
Local cFonte6 		:= "028,028"

Private cCodUser    	:= RetCodUsr()
Private cNamUser 		:= UsrRetName( cCodUser )//Retorna o nome do us

xCol := 04 //Valor da Coluna
yLin := 04 //Valor da Linha

SetRegua(1)
SB1->(dbSetOrder(1))
If SB1->(!dbSeek(xFilial("SB1")+mv_par01))
	APMsgAlert("Produto não localizado no cadastro, verifique.")
	Return()
Endif
IncRegua()

MSCBPRINTER(cImpressora,cPorta)
MSCBCHKStatus(.F.)
MSCBLOADGRAF("ORTO.GRF")
MSCBBEGIN(nCopias,4)

	MSCBBOX(xCol-2,yLin,90,53,5)  // Box da Borda
	MSCBGRAFIC(xCol,yLin+1,"ORTO")
	MSCBSAY(xCol+16,yLin+2,"ETIQUETA DE IDENTIFICACAO DE PRODUTOS"						,"N",cTpFonte,cFonte6)
	If SB1->B1_TIPO =="PA"
		MSCBSAY(xCol+29,yLin+6,"( PA ) PRODUTO ACABADO"							  		,"N",cTpFonte,cFonte6)
		Else
		MSCBSAY(xCol+29,yLin+6,"( SA ) SEMI-ACABADO"							  		,"N",cTpFonte,cFonte6)
	EndIf
	MSCBLINEH(xCol-2,yLin+10,90,2,"B") //horizontal
	MSCBSAY(xCol-1, yLin+11	,"PRODUTO: "   +Alltrim(mv_par01)							,"N",cTpFonte,cFonte5)
	MSCBSAY(xCol+46,yLin+11	,"LOTE: "	   +Alltrim(Upper(mv_par02))					,"N",cTpFonte,cFonte5)
	MSCBSAY(xCol-1, yLin+16	,"DESCRICAO: " +Alltrim(Substr(SB1->B1_DESC,1,35))		   	,"N",cTpFonte,cFonte5)
	MSCBSAY(xCol,   yLin+20	,Alltrim(Substr(SB1->B1_DESC,36,70))		   				,"N",cTpFonte,cFonte5)
	MSCBSAY(xCol-1, yLin+24	,"ARM: "	   +Alltrim(mv_par06)							,"N",cTpFonte,cFonte5)// Por samuel Miranda 18/04/2021
	MSCBSAY(xCol+18,yLin+24	,"QUANT: "	   +alltrim(mv_par03)+" "+Alltrim(SB1->B1_UM)	,"N",cTpFonte,cFonte5)
	MSCBSAY(xCol+47,yLin+24	,+time()													,"N",cTpFonte,cFonte5)
	MSCBSAY(xCol+47,yLin+29	,+Alltrim(Upper(cNamUser))									,"N",cTpFonte,cFonte5)	
	MSCBSAY(xCol-1, yLin+29	,"DATA ENTRADA: "+dToc(mv_par04)							,"N",cTpFonte,cFonte5)
	If SB1->B1_TIPO =="PA"
		MSCBSAYBAR(xCol,yLin+32,Alltrim(SB1->B1_CODBAR),"N","MB07",8,.F.,.T.,.F.,,3,2,.F.)
		Else
		MSCBSAYBAR(xCol,yLin+36,Alltrim(Upper(mv_par01)),"N","MB07",8,.F.,.T.,.F.,,3,2,.F.)
	EndIf
	MSCBSAYBAR(xCol+87,yLin+5,Alltrim(Upper(mv_par02)) ,"B","MB07",8,.F.,.F.,.F.,,2,2,.F.) //"C",8.36,.F.,.T.,.F.,,2,1

MSCBEND()
MSCBCLOSEPRINTER()
MS_FLUSH()

Return()

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³VALIDPERG ºAutor  ³SAMUEL MIRNDA    	 º Data ³  24/02/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±              Criar as Perguntas caso elas não existam.                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function ValidPerg()
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i,j
Local nTamSX1	:= Len(SX1->X1_GRUPO)
//Local aHelp 	:= {}
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("RESTR006A",nTamSX1)

Aadd(aRegs,{cPerg,"01","Codigo do Produto..........?","Codigo do Produto..........?","Codigo do Produto............?","mv_cha","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})
Aadd(aRegs,{cPerg,"02","Lote.......................?","Lote.......................?","Lote.........................?","mv_chb","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

Aadd(aRegs,{cPerg,"03","Quantidade.................?","Quantidade..................?","Quantidade...................?","mv_chc","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Data da Entrada............?","Data da Entrada.............?","Data da Entrada..............?","mv_chd","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

Aadd(aRegs,{cPerg,"05","Quantidade Copias..........?","Quantidade Copias..........?","Quantidade Copias.............?","mv_che","N",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Armazém Padrão.............?","NArmazém Padrão............?","Armazém Padrão................?","mv_chf","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()               
	Endif
Next i

dbSelectArea(_sAlias)

Return()



/*

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

PutSx1("RESTR006","01","Codigo do Produto ? ","Codigo do Produto ?","Codigo do Produto ? ","mv_cha","C",15,0,0,"G","","SB1","","","mv_par01",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00?.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o lote do produto.              " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR006","02","Lote ? ","Lote ?","Lote ? ","mv_chb","C",10,0,0,"G","","","","","mv_par02",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00602.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a Quantidade do produto.        " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR006","03","Quantidade ? ","Quantidade ?","Quantidade.? ","mv_chc","N",10,2,0,"G","","","","","mv_par03",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00603.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a Data de Entrada do produto.   " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR006","04","Dta. Entrada ? ","Dta. Entrada ?","Dta. Entrada ? ","mv_chd","D",8,0,0,"G","","","","","mv_par04",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00604.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a Quantidade de Copias.         " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR006","05","Quantidade Copias ? ","Quantidade Copias ?","Quantidade Copias ? ","mv_chc","N",10,0,0,"G","","","","","mv_par05",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00605.",aHelpPor,aHelpEng,aHelpSpa)

RestArea(aArea)

Return()
*/
