#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR007 ºRevisado ³Samuel Miranda    º Data ³  11/003/19  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de impressao de etiquetas de identificacao          º±±
±±º          ³ de Enderecos de Produtos.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTR007()

Local aSay := {}
Local aButton := {}
Local nOpc := 0
Local cTitulo := "Impressão de etiqueta de Identificacao de Enderecos."

Private cDesc1 := "Este programa irá imprimir as etiquetas de "
Private cDesc2 := "Identificacao de Produto , em impressora térmica Zebra, "
Private cDesc3 := "conforme os parâmetros definidos pelo usuário."
Private cDesc4 := ""
Private cDesc5 := ""
Private cPerg  := Padr("RESTR007",10)
Private lEnd := .F.

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
	RptStatus({|lEnd| RESTR07Imp(@lEnd)},"Imprimindo, aguarde...")
Endif	

Return()


Static Function RESTR07Imp(lEnd)

Local nCopias 		:= mv_par03
Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 		:= "0"
Local cFonte1 		:= "020,020"
Local cFonte2 		:= "017,017"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "015,015"
Local cFonte5 		:= "028,028"
Local cFonte6 		:= "032,032"

xCol := 04 //Valor da Coluna
yLin := 06 //Valor da Linha
 
SetRegua(1)
SBE->(dbSetOrder(1))
If SBE->(!dbSeek(xFilial("SBE")+mv_par01+mv_par02))
	APMsgAlert("Endereco não localizado no cadastro, verifique.")
	Return()
Endif
IncRegua()
MSCBPRINTER(cImpressora,cPorta)	 
MSCBCHKStatus(.F.)
	//MSCBLOADGRAF("ORTO.GRF")//Removido a pedido do Colaborador João isaias, Por Samuel Miranda 11/03/2019    
	MSCBBEGIN(nCopias,4) 
	MSCBBOX(02,05,82,35)  // Box da Borda //Comentado em 13/09/2022 Leonardo
	MSCBSAY(xCol,	yLin+1,"ETIQUETA DE IDENTIFICACAO DE ENDERECO"				,"N",cTpFonte,cFonte5) 
	MSCBSAY(xCol,	yLin+5,"LOCAL: "	+Alltrim(mv_par01)						,"N",cTpFonte,cFonte5)
	MSCBSAY(xCol+20,yLin+5,"ENDERECO: "	+Alltrim(mv_par02)						,"N",cTpFonte,cFonte5)  	                                          
	MSCBSAY(xCol,	yLin+9,"DESCRICAO: "+Alltrim(Substr(SBE->BE_DESCRIC,1,35))	,"N",cTpFonte,cFonte5)														   
	MSCBSAY(xCol,	yLin+12 			,Alltrim(Substr(SBE->BE_DESCRIC,36,70))	,"N",cTpFonte,cFonte5)
	//MSCBBOX(02,37,95,37,3)
	//MSCBSAYBAR(xCol+2,yLin+15,Alltrim(Upper(mv_par01))+Alltrim(Upper(mv_par02)) ,"N","MB07",8,.F.,.T.,.F.,,3,2,.F.)
	MSCBSAYBAR(xCol+2,yLin+15,Alltrim(Upper(mv_par01))+Alltrim(Upper(mv_par02)) ,"N","C",8.40,.F.,.T.,.F.,,2,1,.F.,.F.,,.T.) 	 		
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

Aadd( aHelpPor, "Informe o Local do Endereco Produto.    " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR007","01","Local ? ","Local ?","Local ? ","mv_cha","C",02,0,0,"G","","","","","mv_par01",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00?.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o Endereco do Produto.          " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR007","02","Endereco ? ","Endereco ?","Endereco ? ","mv_chb","C",15,0,0,"G","","","","","mv_par02",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00702.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a Quantidade de Copias.         " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR007","03","Quantidade Copias ? ","Quantidade Copias ?","Quantidade Copias ? ","mv_chc","N",10,0,0,"G","","","","","mv_par03",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00703.",aHelpPor,aHelpEng,aHelpSpa)

RestArea(aArea)

Return()
