#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR026 ºAutor  ³Samuel Mirada		 º Data ³  26/09/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de impressao de Controle de Terceiros               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTR030()            

Local aSay 			:= {}
Local aButton 		:= {}
Local nOpc 			:= 0
Local cTitulo 		:= "Impressão de etiqueta de Controle de terceiros."

Private cDesc1 		:= "Este programa irá imprimir as etiquetas de "
Private cDesc2 		:= "Controle de terceiros , em impressora térmica Zebra, "
Private cDesc3 		:= "conforme os parâmetros definidos pelo usuário."
Private cDesc4 		:= ""
Private cDesc5 		:= "By TI  Ortosintese"
Private cPerg  		:= Padr("RESTR030",10)
Private lEnd 		:= .F.  
Private cCodUser    := RetCodUsr()
Private cNamUser 	:= UsrRetName( cCodUser )//Retorna o nome do Usúario Logado  

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
	RptStatus({|lEnd| RESTR030Imp(@lEnd)},"Imprimindo, aguarde...")
Endif	

Return()

Static Function RESTR030Imp(lEnd)

Local nCopias 		:= mv_par05
Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 		:= "0"
Local cFonte1 		:= "020,020"
Local cFonte2 		:= "017,017"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "015,015"
Local cFonte5 		:= "032,032"
Local cFonte6 		:= "040,040"

DbSelectArea("SC2")
DbSelectArea("SA2")    
SetRegua(1)
SC2->(dbSetOrder(1))                                                                                                                  
If SC2->(!dbSeek(xFilial("SC2")+mv_par01))
	APMsgAlert("PFI não localizado no cadastro, verifique.")
	Return()
Endif
	
IncRegua()
	
MSCBPRINTER(cImpressora,cPorta)	 
MSCBCHKStatus(.F.)

MSCBLOADGRAF("LOG3.GRF")

MSCBBEGIN(nCopias,4) 

MSCBBOX(003,001,099,055,3)  // Box da Borda
MSCBLINEV(058,012,018,3,"B") //vertical do lote
MSCBGRAFIC(08,02,"LOG3")
MSCBLINEV(020,001,012,3,"B") //Linha Vestical 
MSCBSAY(25,05,"ORTOSINTESE IND. E COM. LTDA"										,"N",cTpFonte,cFonte6)
MSCBLINEH(003,012,099,3,"B") //Linha horizontal
MSCBSAY(04,14,"PFI : "					+Alltrim(mv_par01)							,"N",cTpFonte,cFonte5)
MSCBSAY(60,14,"Lote: "					+Alltrim(Upper(SC2->C2_LOTECTL))			,"N",cTpFonte,cFonte5)    	                                          
MSCBLINEH(003,018,099,3,"B") //Linha horizontal
MSCBSAY(04,20,"Produto: "				+Alltrim(Upper(SC2->C2_PRODUTO))			,"N",cTpFonte,cFonte5) 
MSCBLINEH(003,024,099,3,"B") //Linha horizontal
MSCBSAY(04,26,"Descricao: "	  		    +Alltrim(Substr(SC2->C2_XDESC,1,35))	 	,"N",cTpFonte,cFonte5)
MSCBSAY(04,31		 		 		    ,Alltrim(Substr(SC2->C2_XDESC,36,70)) 		,"N",cTpFonte,cFonte5)	 													   
MSCBLINEH(003,035,099,3,"B") //Linha horizontal
MSCBSAY(04,37,"Forn.: "	 	 			+Alltrim(Substr(SA2->A2_NOME,1,35))		,"N",cTpFonte,cFonte5)  
MSCBLINEH(003,041,099,3,"B") //Linha horizontal
MSCBSAY(40,43,"Des. Revis.: "	  		+Alltrim(mv_par02)							,"N",cTpFonte,cFonte5)														   
MSCBSAY(04,43,"Qtd.: "	  			    +Alltrim(mv_par04)					  		,"N",cTpFonte,cFonte5)
MSCBLINEH(003,048,099,3,"B") //Linha horizontal
MSCBSAY(04,50,"Data : " 				+dToc(dDataBase)					   		,"N",cTpFonte,cFonte5)  //SC2->C2_DATPRF
MSCBSAY(40,50,"Emitente : "	 	 		+Alltrim(Upper(cNamUser))					,"N",cTpFonte,cFonte5) 	
		
MSCBEND() 
MSCBCLOSEPRINTER()	
MS_FLUSH() 

Return()

Static Function ValidPerg()
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i,j
Local nTamSX1	:= Len(SX1->X1_GRUPO)
Local aHelp := {}
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("RESTR030",nTamSX1)

Aadd(aRegs,{cPerg,"01","PFI.....? ","PFI ?","PFI ? "											,"mv_cha","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","","",""})
Aadd(aRegs,{cPerg,"02","Des.Revis.....? ","Des.Revis ?","Des.Revis ? "							,"mv_chb","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Fornecedor.....? ","Fornecedor ?","Fornecedor ? "		 				,"mv_chc","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","",""})
Aadd(aRegs,{cPerg,"04","Qtde Informada.....? ","Qtde Informada ?","Qtde Informada ? "			,"mv_chd","C",10,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Quantidade Copias.....? ","Quantidade Copias ?","Quantidade Copias ? "	,"mv_che","N",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

