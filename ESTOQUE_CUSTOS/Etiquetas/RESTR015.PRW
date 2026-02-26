#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ RESTR015 บAutor  ณClaudio Ferreira    บ Data ณ  07/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de impressao de Controle de Estoque/Clientes        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Ortosintese                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RESTR015()            

Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo 	:= "Impressใo de etiqueta de Controle de Estoque/Clientes."

Private cDesc1 	:= "Este programa irแ imprimir as etiquetas de "
Private cDesc2 	:= "Controle Estoque/Clientes , em impressora t้rmica Zebra, "
Private cDesc3 	:= "conforme os parโmetros definidos pelo usuแrio."
Private cDesc4 	:= ""
Private cDesc5 	:= ""
Private cPerg  	:= Padr("RESTR015",10)
Private lEnd	:= .F.

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
	RptStatus({|lEnd| RESTR15Imp(@lEnd)},"Imprimindo, aguarde...")
Endif	

Return()


Static Function RESTR15Imp(lEnd)

Local nCopias 		:= mv_par05
Local cImpressora := "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 	:= "0"
Local cFonte1 		:= "020,020"
Local cFonte2 		:= "017,017"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "015,015"
Local cFonte5 		:= "028,028"
Local cFonte6 		:= "032,032"
Local cFonte7 		:= "042,042"
Local cFonte8 		:= "048,048"
Local cFonte9 		:= "082,082"  //062

SetRegua(1)

IncRegua()
	
MSCBPRINTER(cImpressora,cPorta)	 
MSCBCHKStatus(.F.)

MSCBLOADGRAF("LOGOORTO.GRF")    

MSCBBEGIN(nCopias,4) 

MSCBGRAFIC(04,01,"LOGOORTO")
MSCBSAY(25,03,"Ortosintese Ind e Com Ltda"											  					,"N",cTpFonte,cFonte8)
MSCBSAY(15,14,"   "				+Alltrim(mv_par01)														,"N",cTpFonte,cFonte9)
MSCBSAY(15,24,"   "				+Alltrim(mv_par02)								  						,"N",cTpFonte,cFonte9)    	                                          
MSCBSAY(20,35,"   "				+Alltrim(mv_par03)								  						,"N",cTpFonte,cFonte7) 
MSCBSAY(20,40,"   " 				+dToc(dDataBase)							  								,"N",cTpFonte,cFonte7) 
MSCBSAY(20,45,"   "	 	 		+Time()											 							,"N",cTpFonte,cFonte7) 
MSCBSAY(60,45,"CAIXA :"	 	 	+Alltrim(mv_par04)							 							,"N",cTpFonte,cFonte7) 														   
		
MSCBEND() 
MSCBCLOSEPRINTER()	
MS_FLUSH() 

Return()


Static Function VerSx1()

Local aArea 	:= GetArea()
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o Nome Cliente.				 " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR015","01","Cliente ? ","Cliente ?","Cliente ? ","mv_cha","C",40,0,0,"G","","","","","mv_par01",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00?.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o Numero do Pedido.       		 " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR015","02","Num. Pedido ? ","Num. Pedido ?","Num. Pedido ? ","mv_chb","C",10,0,0,"G","","","","","mv_par02",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR01502.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o Usuario.				 	     " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR015","03","Usuario ? ","Usuario ?","Usuario ? ","mv_chc","C",30,0,0,"G","","","","","mv_par03",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR01503.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe Caixas.				 	     " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR015","04","Caixas ? ","Caixas ?","Caixas ? ","mv_chd","C",04,0,0,"G","","","","","mv_par04",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR01504.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a Quantidade de Copias.         " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR015","05","Quantidade Copias ? ","Quantidade Copias ?","Quantidade Copias ? ","mv_che","N",10,0,0,"G","","","","","mv_par05",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR01505.",aHelpPor,aHelpEng,aHelpSpa)

RestArea(aArea)

Return()