#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR014 ºAutor  ³Claudio Ferreira    º Data ³  14/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de impressao de Controle de Terceiros               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTR014()            

Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo := "Impressão de etiqueta de Controle de terceiros."

Private cDesc1 := "Este programa irá imprimir as etiquetas de "
Private cDesc2 := "Controle de terceiros , em impressora térmica Zebra, "
Private cDesc3 := "conforme os parâmetros definidos pelo usuário."
Private cDesc4 := ""
Private cDesc5 := ""
Private cPerg  := Padr("RESTR014",10)
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
	RptStatus({|lEnd| RESTR14Imp(@lEnd)},"Imprimindo, aguarde...")
Endif	

Return()


Static Function RESTR14Imp(lEnd)

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

DbSelectArea("SC2")
DbSelectArea("SA2")    
SetRegua(1)
SC2->(dbSetOrder(1)) //C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD                                                                                                                   
If SC2->(!dbSeek(xFilial("SC2")+mv_par01))
	APMsgAlert("PFI não localizado no cadastro, verifique.")
	Return()
Endif
//While !Eof() .And. SC2->C2_FILIAL+SC2->C2_NUM == xFilial("SC2")+MV_PAR01	
IncRegua()
	
MSCBPRINTER(cImpressora,cPorta)	 
MSCBCHKStatus(.F.)

MSCBLOADGRAF("ORTO.GRF")    

MSCBBEGIN(nCopias,4) 

MSCBGRAFIC(04,01,"ORTO")
MSCBSAY(25,03,"Ortosintese Ind e Com Ltda"											  										,"N",cTpFonte,cFonte6)
MSCBSAY(04,14,"PFI n.: "				+Alltrim(mv_par01)																	,"N",cTpFonte,cFonte6)
MSCBSAY(60,14,"Lote: "					+Alltrim(Upper(SC2->C2_LOTECTL))				  								,"N",cTpFonte,cFonte6)    	                                          
MSCBSAY(04,20,"Produto: "				+Alltrim(Upper(SC2->C2_PRODUTO))				  								,"N",cTpFonte,cFonte6) 
MSCBSAY(04,26,"Descricao: "	  		+Alltrim(Substr(SC2->C2_XDESC,1,35))	   	  								,"N",cTpFonte,cFonte6)
MSCBSAY(04,31		 		 			   ,Alltrim(Substr(SC2->C2_XDESC,36,70))		  									,"N",cTpFonte,cFonte6)	 													   
MSCBSAY(04,37,"Forn.:"	 	 			+Alltrim(Substr(SA2->A2_NOME,1,35))		  									,"N",cTpFonte,cFonte6)  
MSCBSAY(40,43,"Des. Revis.: "	  		+Alltrim(mv_par02)																	,"N",cTpFonte,cFonte6)														   
MSCBSAY(04,43,"Qtd.: "	  			    +Alltrim(Str(mv_par06))					  									,"N",cTpFonte,cFonte6)
MSCBSAY(04,49,"Data:" 					+dToc(dDataBase)							  								  			,"N",cTpFonte,cFonte6)  //SC2->C2_DATPRF
MSCBSAY(40,49,"Emitente:"	 	 		+Alltrim(mv_par04)								 									,"N",cTpFonte,cFonte6) 														   

													   
		
MSCBEND() 
MSCBCLOSEPRINTER()	
MS_FLUSH() 

//DbSelectArea("SC2")
//dbSkip()
//Enddo	            

Return()


Static Function VerSx1()

Local aArea := GetArea()
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o Numero PFI.				     " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR014","01","PFI ? ","PFI ?","PFI ? ","mv_cha","C",11,0,0,"G","","SC2","","","mv_par01",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00?.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o Des. Revisao.         		 " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR014","02","Des.Revis ? ","Des.Revis ?","Des.Revis ? ","mv_chb","C",15,0,0,"G","","","","","mv_par02",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR01402.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o Forn.				 	    " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR014","03","Forn ? ","Forn ?","Forn ? ","mv_chc","C",06,0,0,"G","","SA2","","","mv_par03",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR01403.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o Emitente.				     " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR014","04","Emitente ? ","Emitente ?","Emitente ? ","mv_chd","C",15,0,0,"G","","","","","mv_par04",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR01404.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a Quantidade de Copias.         " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR014","05","Quantidade Copias ? ","Quantidade Copias ?","Quantidade Copias ? ","mv_che","N",10,0,0,"G","","","","","mv_par05",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR01405.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a Quantidade do PFI.            " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR014","06","Quantidade PFI ? ","Quantidade PFI ?","Quantidade PFI ? ","mv_chf","N",10,0,0,"G","","","","","mv_par06",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR01406.",aHelpPor,aHelpEng,aHelpSpa)


RestArea(aArea)

Return()