#INCLUDE "PROTHEUS.CH" 
#INCLUDE "rwmake.ch"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR024 ºAutor  ³Samuel Miranda		 º Data ³  25/05/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de impressao de Controle do Almoxarifado            º±±
±±º          ³ Equipamentos                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTR024()            

Local aSay 	   		:= {}
Local aButton 		:= {}
Local nOpc 	   		:= 0
Local cTitulo 		:= "Impressão de etiqueta do Almoxarifado."

Private cDesc1 		:= "Este programa irá imprimir as etiquetas de "
Private cDesc2 		:= "Controle do Almoxarifado, em impressora térmica Zebra, "
Private cDesc3 		:= "conforme os parâmetros definidos pelo usuário."
Private cDesc4 		:= ""
Private cDesc5 		:= "By TI Ortosintese"
Private cPerg  		:= Padr("RESTR024",10)
Private lEnd 		:= .F.  
Private cCodUser    := RetCodUsr()
Private cNamUser 	:= UsrRetName( cCodUser )//Retorna o nome do us  


Pergunte(cPerg,.F.) //Validacao das Perguntas

// Monta a interface padrao com o usuario...
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
	RptStatus({|lEnd| RESTR24Imp(@lEnd)},"Imprimindo, aguarde...")
Endif	

Return()

Static Function RESTR24Imp(lEnd)

Local nCopias 		:= mv_par03  //Pega a quantidade de copias informada no paramentro 03
Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 		:= "0"
Local cFonte1 		:= "020,020"
Local cFonte2 		:= "017,017"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "015,015"
Local cFonte5 		:= "028,028"
Local cFonte6 		:= "032,032"

DbSelectArea("SC2")
DbSelectArea("SA2")    
SetRegua(1)
SC2->(dbSetOrder(1)) //C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN                                                                                                               
If SC2->(!dbSeek(xFilial("SC2")+mv_par01))
	APMsgAlert("PFI não localizado no cadastro, verifique.")
	Return()
Endif
IncRegua()

cTexto1 :=SC2->C2_XDESC


cTexto1 := Alltrim(StrTran(Alltrim(cTexto1),"Ø",chr(65533)))           
cTexto1 := Alltrim(StrTran(Alltrim(cTexto1),"º","§")) 
cTexto1 := Alltrim(StrTran(Alltrim(cTexto1),"°","§")) 
cTexto1 := Alltrim(StrTran(Alltrim(cTexto1),"ï",chr(65533)))
cTexto1 := Alltrim(StrTran(Alltrim(cTexto1),"ï","Ø")) 


	
MSCBPRINTER(cImpressora,cPorta)	 
MSCBCHKStatus(.F.)
MSCBLOADGRAF("ORTO.GRF")    
MSCBBEGIN(nCopias,4) 
//MSCBBOX(003,002,098,080) // Box das bordas laterais	
	MSCBBOX(003,001,099,055,3)  // Box da Borda
	MSCBGRAFIC(06,02,"ORTO") //Imprime o Logotipo
	MSCBSAY(32,04,"ORTOSINTESE  IND. & COM. Ltda"									,"N",cTpFonte,cFonte6) 
	MSCBBOX(003,011,099,011,3) 
	MSCBLINEV(020,001,011,3,"B")//Linha vertical do Logo
	MSCBLINEV(058,011,04,3,"B") //Linha vertical do lote
	MSCBSAY(04,14,"PFI  : "			 		+Alltrim(mv_par01)						,"N",cTpFonte,cFonte6)
	MSCBLINEH(003,018,099,3,"B") //horizontal
	MSCBSAY(60,14,"Lote : "					+Alltrim(Upper(SC2->C2_LOTECTL))		,"N",cTpFonte,cFonte6)   	                                          
	MSCBSAY(04,20,"Produto : "				+Alltrim(Upper(SC2->C2_PRODUTO))		,"N",cTpFonte,cFonte6) 
	MSCBLINEH(003,024,099,3,"B") //horizontal
	MSCBSAY(04,26,"Descricao : "	  		+Alltrim(Substr(SC2->C2_XDESC,1,35))	,"N",cTpFonte,cFonte6)
	MSCBSAY(04,31		 		 		    ,Alltrim(Substr(SC2->C2_XDESC,36,70))	,"N",cTpFonte,cFonte6)	 													   
	MSCBLINEH(003,035,099,3,"B") //horizontal
	MSCBSAY(04,37,"Situação : "	 	 		+Alltrim(Upper(mv_par02))				,"N",cTpFonte,cFonte6)
	MSCBLINEH(003,041,099,3,"B") //horizontal
	MSCBSAY(04,43,"Qtd.: "	  			    +Alltrim(mv_par04)					  	,"N",cTpFonte,cFonte5)
	MSCBSAY(50,43,"Data : " 				+dToc(dDataBase)					   	,"N",cTpFonte,cFonte5)  //SC2->C2_DATPRF
	MSCBLINEH(003,048,099,3,"B") //Linha horizontal
	MSCBSAY(04,50,"SEPARADOR : "	 	 											,"N",cTpFonte,cFonte5) 
	MSCBSAY(50,50,"RECEBEDOR : "	 	 											,"N",cTpFonte,cFonte5) 		
																   		
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
cPerg := PADR("RESTR024",nTamSX1)

Aadd(aRegs,{cPerg,"01","PFI...............?","PFI...............?","PFI...............?"		,"mv_cha","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","","",""})
Aadd(aRegs,{cPerg,"02","Situação..........?","Situação..........?","Situação..........?"		,"mv_chb","C",35,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Quantidade Copias.?","Quantidade Copias.?","Quantidade Copias.? "		,"mv_chc","N",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
