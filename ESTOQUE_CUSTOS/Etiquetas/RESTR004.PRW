#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR004 ºAutor  ³Totvs               º Data ³  14/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de para impressao de etiquetas de recebimento       º±±
±±º          ³ de Produtos.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTR004()

Local aSay := {}
Local aButton := {}
Local nOpc := 0
Local cTitulo := "Impressão de etiqueta de Recebimento de Produtos."

Private cDesc1 := "Este programa irá imprimir as etiquetas de Recbto "
Private cDesc2 := "de Produto , em impressora térmica Zebra, "
Private cDesc3 := "conforme os parâmetros definidos pelo usuário."
Private cDesc4 := ""
Private cDesc5 := ""
Private cPerg  := Padr("RESTR004",10)
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
	RptStatus({|lEnd| U_RESTR04Imp(@lEnd)},"Imprimindo, aguarde...")
Endif	

Return()


User Function RESTR04Imp(lEnd)

Local nCopias 		:= 1
Local cImpressora := "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 	:= "0"
Local cFonte1 		:= "020,020"
Local cFonte2 		:= "017,017"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "015,015" 
Local cFonte5 		:= "028,028"
    
//SetRegua(1)
//SB1->(dbSetOrder(1))
//If SB1->(!dbSeek(xFilial("SB1")+mv_par01))
//	APMsgAlert("Produto não localizado no cadastro, verifique.")
//	Return()
//Endif
//IncRegua()
	
MSCBPRINTER(cImpressora,cPorta)	 
MSCBCHKStatus(.F.)

MSCBLOADGRAF("LOGOORTO.GRF")

MSCBBEGIN(nCopias,4)          
                                                
MSCBBOX(01,01,90,55,3)  // Box da Borda
MSCBGRAFIC(04,01,"LOGOORTO")
 //MSCBSAY(04,02,"O.S"				,"N",cTpFonte,cFonte3)
MSCBBOX(19,01,90,11,3)  
 MSCBSAY(30,04,"Etiqueta de Recebimento de Produtos","N",cTpFonte,cFonte5)
MSCBBOX(01,11,90,11,3)
  	
MSCBSAY(02,12,"Produto:   "	  +Alltrim(SD1->D1_COD)				,"N",cTpFonte,cFonte3)
MSCBSAY(35,12,"Dimensoes:    "+Alltrim(Str(SB5->B5_COMPR))+"  X  "+Alltrim(Str(SB5->B5_ESPESS))+"  X  "+Alltrim(Str(SB5->B5_LARG))+"  mm" 	,"N",cTpFonte,cFonte3) 
MSCBSAY(02,15,"Descricao: "	  +Alltrim(Substr(SB1->B1_DESC,1,45)),"N",cTpFonte,cFonte3) 
MSCBSAY(02,18 				  ,Alltrim(Substr(SB1->B1_DESC,46,95)),"N",cTpFonte,cFonte3)
//MSCBSAY(02,18,"Dimensoes:    "		+Alltrim(Str(SB5->B5_COMPR))+"  X  "+Alltrim(Str(SB5->B5_ESPESS))+"  X  "+Alltrim(Str(SB5->B5_LARG))+"  mm" 	,"N",cTpFonte,cFonte3) 

MSCBBOX(01,21,90,21,3)      

 MSCBSAY(02,22,"Fornecedor: "  +Alltrim(SA2->A2_NOME)	,"N",cTpFonte,cFonte3)
 MSCBSAY(02,25,"Pedido:     "  +Alltrim(SD1->D1_PEDIDO)	,"N",cTpFonte,cFonte3)
 MSCBSAY(41,25,"N.F: "         +Alltrim(SD1->D1_DOC)	,"N",cTpFonte,cFonte3)
 MSCBSAY(61,25,"/ "            +Alltrim(SD1->D1_SERIE)	,"N",cTpFonte,cFonte3)
 MSCBSAY(68,25,"Armazem P.C.: "+Posicione("SC7",1,xFilial("SC7")+SD1->D1_PEDIDO,"C7_LOCAL")				,"N",cTpFonte,cFonte3)

 MSCBBOX(01,28,90,28,3)

 MSCBSAY(02,29,"Data: "    +DtoC(SD1->D1_DTDIGIT)+" | "+Time()	,"N",cTpFonte,cFonte3)
 MSCBSAY(41,29,"Qtde: "    +Alltrim(Str(SD1->D1_QUANT))			,"N",cTpFonte,cFonte3)
 MSCBSAY(72,29,"Unidade: " +Alltrim(SB1->B1_UM)					,"N",cTpFonte,cFonte3)        
MSCBBOX(01,32,90,32,3)

 MSCBSAY(02,33,"Certificado: " +Alltrim(SD1->D1_XCERTIF)		,"N",cTpFonte,cFonte3)
 MSCBSAY(02,37,"Corrida:     " +Alltrim(SD1->D1_XCORRID)		,"N",cTpFonte,cFonte3)
 MSCBSAY(61,33,"Lote/ "        									,"N",cTpFonte,cFonte3) 
 MSCBSAY(70,35,				Alltrim(SD1->D1_LOTECTL)			,"N",cTpFonte,cFonte3)
 MSCBSAY(61,36,"NRE: " 											,"N",cTpFonte,cFonte3)
MSCBBOX(60,31,60,41,3)    
 
MSCBBOX(01,41,90,41,3)
	// ALTERADO PARA IDENTIFICAR OS PRODUTOS QUE TEM SIGAQUALITY - SOL. MARCELO BARCELLOS 26/09/17
	If SB1->B1_TIPOCQ == "M"
	MSCBSAY(62,42,"Insp.Qualidade: " 						,"N",cTpFonte,cFonte3)
    Else
	MSCBSAY(62,42,"Insp.Qualidade: Q" 						,"N",cTpFonte,cFonte3)    
    EndIf

MSCBBOX(60,41,90,55,3)

//MSCBSAYBAR(40,41,Alltrim(SB1->B1_CODBAR) ,"N","MB04",8,.F.,.T.,.F.,,3,2,.F.) 
MSCBSAYBAR(04,42,Alltrim(SB1->B1_COD) 			,"N","MB07",8,.F.,.T.,.F.,,3,2,.F.)
MSCBSAYBAR(91,12,Alltrim(SD1->D1_LOTECTL) 		,"B","MB07",8,.F.,.F.,.F.,,2,2,.F.)

		
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

Aadd( aHelpPor, "Informe o codigo do Fornecedor.         " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR004","01","Codigo do Fornecedor ? ","Codigo do Fornecedor ?","Codigo do Fornecedor ? ","mv_cha","C",06,0,0,"G","","SA2","","","mv_par01",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00?.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o Numero da N.F Entrada.        " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR004","02","N.F Entrada ? ","N.F Entrada ?","N.F Entrada ? ","mv_chb","C",10,0,0,"G","","","","","mv_par02",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00402.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a Serie da N.F.        			" )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR004","03","Serie ? ","Serie ?","Serie ? ","mv_chc","C",03,0,0,"G","","","","","mv_par03",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00403.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a quantidade de copias a ser    " )
Aadd( aHelpPor, "impressa.                               " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR004","04","Quantidade Copias ? ","Quantidade Copias ?","Quantidade Copias ? ","mv_chm","N",3,0,0,"G","","","","","mv_par04",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00404.",aHelpPor,aHelpEng,aHelpSpa)

RestArea(aArea)

Return()
