#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR036 ºAutor  ³Samuel Miranda      º Data ³  04/02/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de impressao de etiquetas de Saparação 		        º±±
±±º          ³ de Produtos no almoxarifado via PFI.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESTR036()

Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo 	:= "Impressão de etiqueta de Separação "

Private cDesc1 	:= "Este programa irá imprimir as etiquetas de "
Private cDesc2 	:= "Separação de Produto , em impressora térmica Zebra, "
Private cDesc3 	:= "conforme os parâmetros definidos pelo usuário."
Private cDesc4 	:= ""
Private cDesc5 	:= ""
Private cDesc6 	:= "By TI Ortosintese"
Private cPerg  	:= Padr("RESTR036",10)
Private lEnd 	:= .F.

ValidPerg()

If !Pergunte(cPerg,.T.)
	Return()
Endif

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )
aAdd( aSay, cDesc6 )

aAdd( aButton, { 5, .T., { || Pergunte( cPerg, .T. )  } } )
aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch()            } } )

FormBatch( cTitulo, aSay, aButton )

If nOpc == 1
	RptStatus({|lEnd| U_RESTR36Imp(@lEnd,mv_par01)},"Imprimindo, aguarde...")
Endif

Return()


User Function RESTR36Imp(lEnd,nOP)
// nOP := Numero da OP
Local nCopias 		:= 1	//mv_par05
Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local nRec			:= 0
Local cTpFonte 		:= "0"
Local cFonte1 		:= "020,020"
Local cFonte2 		:= "017,017"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "030,030"
Local cFonte5 		:= "032,032"
Local cFonte6 		:= "038,038"
xCol := 04 //Coluna
yLin := 03 //Linha

SetRegua(1)

	cQuery := "SELECT " + CHR(13)+CHR(10)
	cQuery += "D4_COD AS CODIGO," + CHR(13)+CHR(10)
	cQuery += "D4_LOCAL AS ARM," + CHR(13)+CHR(10)
	cQuery += "D4_QTDEORI AS QTDE," + CHR(13)+CHR(10)
	cQuery += "D4_QUANT AS QTDE2," + CHR(13)+CHR(10)
	cQuery += "D4_QTSEGUM AS QT2UN," + CHR(13)+CHR(10)
	cQuery += "D4_LOTECTL AS LOTE," + CHR(13)+CHR(10)
	cQuery += "C2_LOTECTL AS LOTEOP," + CHR(13)+CHR(10)
	cQuery += "C2_PRODUTO AS PRODOP," + CHR(13)+CHR(10)
	cQuery += "C2_XDESC  AS DESCOP," + CHR(13)+CHR(10)
	cQuery += "C2_QUANT AS QTDEOP," + CHR(13)+CHR(10)
	cQuery += "B1_DESC AS DESCRICAO," + CHR(13)+CHR(10)
	cQuery += "B1_UM AS UNIDADE," + CHR(13)+CHR(10)
	cQuery += "B1_SEGUM AS UNIDADE2" + CHR(13)+CHR(10)
	cQuery += "FROM " + CHR(13)+CHR(10)
	cQuery += RetSqlName('SD4010') + " SD4 " + CHR(13)+CHR(10)
	cQuery += " INNER JOIN SB1010 SB1 ON D4_COD =  B1_COD " + CHR(13)+CHR(10)	
	cQuery += " INNER JOIN SC2010 SC2 ON C2_FILIAL = D4_FILIAL and SC2.D_E_L_E_T_ ='' AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN = SD4.D4_OP " + CHR(13)+CHR(10)
	cQuery += " WHERE  " + CHR(13)+CHR(10)
	cQuery += "SD4.D4_FILIAL = '01' " + CHR(13)+CHR(10)
	cQuery += "AND SD4.D_E_L_E_T_ = '' " + CHR(13)+CHR(10)
	cQuery += "AND D4_OP='"+ nOP +"'  " + CHR(13)+CHR(10)
	cQuery += "ORDER BY D4_COD " + CHR(13)+CHR(10)
	
	cQuery := ChangeQuery(cQuery)
	
		MemoWrite("RESTR036.SQL", cQuery )

		If Select("QRY") > 0
			dbSelectArea("QRY")
			dbCloseArea()
		EndIf

		dbUseArea( .T. , "TOPCONN" , TcGenQry( ,, cQuery ), "QRY" , .T. , .F. )

	
	dbSelectArea("QRY")
	dbGotop()
	QRY->(dbEval({ || nRec++ },,{||!Eof()} ))
	dbGoTop()
		
IncRegua()	

	If nRec == 0
		dbSelectArea("QRY")
		dbCloseArea()
		Alert("PFI não contem itens." ,"Verifique !")
		Return()
	Endif
		
	dbSelectArea("QRY")
	dbGotop()
	
	While !QRY->(Eof())
		 
	MSCBPRINTER(cImpressora,cPorta)
	MSCBCHKStatus(.F.)
	MSCBBEGIN(nCopias,4)
	
	cTexto1 := Alltrim(QRY->DESCRICAO)
	//cTexto1 := strtran(cFrase,"$","")
	//cTexto1 := Alltrim(StrTran((cTexto1),"Ø",chr(65533)))           
	cTexto1 := StrTran(cTexto1,"º","§") 
	cTexto1 := StrTran(cTexto1,"°","§") 
	cTexto1 := StrTran(cTexto1,"ý","Ø")
	cTexto1 := StrTran(cTexto1,"ï","Ø")

	MSCBBOX(002,002,100,056,8)// Box da Borda																					
		MSCBSAY(xCol+20	,yLin+1  ,"ETIQUETA DE SEPARAÇÃO"													,"N",cTpFonte,cFonte6)
		//MSCBSAY(xCol-2	,yLin+2	 ,replicate("..",56)															,"N",cTpFonte,cFonte3)	
	   /*
		MSCBSAY(xCol		,yLin+5	,"PFI: " 		+ Alltrim(nOP)												,"N",cTpFonte,cFonte5)
		MSCBSAY(xCol+47	,yLin+5	,"Lote PFI: " + Alltrim(Upper(QRY->LOTEOP))					  		,"N",cTpFonte,cFonte5)
		MSCBSAY(xCol		,yLin+10 ,"Cod: " 		+ Alltrim(QRY->PRODOP)									,"N",cTpFonte,cFonte5)
		MSCBSAY(xCol+52	,yLin+10 ,"Qtde: " 		+ AllTrim(Transform(QRY->QTDEOP,"@E 99999"))	,"N",cTpFonte,cFonte5)
		MSCBSAY(xCol		,yLin+15 ,""				+ Alltrim(Substr(QRY->DESCOP,1,42))  				,"N",cTpFonte,cFonte5) //Alltrim(Substr(SBE->BE_DESCRIC,1,35))	
		MSCBSAY(xCol		,yLin+20 ,""				+ Alltrim(Substr(QRY->DESCOP,43,42)) 				,"N",cTpFonte,cFonte5)
		*/
		MSCBSAY(xCol		,yLin+5	,"PFI: " 		+ Alltrim(nOP)												,"N",cTpFonte,cFonte5)
		MSCBSAY(xCol+40	,yLin+5	,"Lote PFI: "  + Alltrim(Upper(QRY->LOTEOP))						,"N",cTpFonte,cFonte5)
		MSCBSAY(xCol		,yLin+10 ,"Cod: " 		+ Alltrim(QRY->PRODOP)						  			,"N",cTpFonte,cFonte5)
		MSCBSAY(xCol+75	,yLin+05 ,"Qtde: " 		+ AllTrim(Transform(QRY->QTDEOP,"@E 99999"))	,"N",cTpFonte,cFonte5)
		MSCBSAY(xCol+40 ,yLin+10 ,"Forn.: " + AllTrim( Upper( IIf(Type("mv_par02")=="C", mv_par02, "") ) ),"N",cTpFonte,cFonte5) //Mudança feita Por Pedro 02/02/2026
		//MSCBSAY(xCol+40	,yLin+10 ,"Forn.: " 		+ AllTrim(upper(mv_par02))								,"N",cTpFonte,cFonte5)//mv_par01  //antigo
		MSCBSAY(xCol		,yLin+15 ,""				+ Alltrim(Substr(QRY->DESCOP,1,42))  				,"N",cTpFonte,cFonte5) //Alltrim(Substr(SBE->BE_DESCRIC,1,35))	
		MSCBSAY(xCol		,yLin+20 ,""				+ Alltrim(Substr(QRY->DESCOP,43,42)) 		  		,"N",cTpFonte,cFonte5)
		MSCBLINEH(002,27,100,10,"B") //Linha horizontal
		MSCBSAY(xCol		,yLin+27 ,"Produto : " 	+ Alltrim(QRY->CODIGO)									,"N",cTpFonte,cFonte5)
		MSCBSAY(xCol+58	,yLin+27 ,"Lote : "		+ Alltrim(Upper(QRY->LOTE))				  			,"N",cTpFonte,cFonte5) 
		MSCBSAY(xCol-1		,yLin+29 ,replicate("..",56)															,"N",cTpFonte,cFonte3)
		MSCBSAY(xCol		,yLin+32 ,""				+ Alltrim(Substr(cTexto1,1,50))  					,"N",cTpFonte,cFonte5) //Alltrim(Substr(SBE->BE_DESCRIC,1,35))	
		MSCBSAY(xCol		,yLin+37 ,""				+ Alltrim(Substr(cTexto1,51,50)) 			  		,"N",cTpFonte,cFonte5)
		MSCBSAY(xCol-1		,yLin+40 ,replicate("..",55)										  					,"N",cTpFonte,cFonte3)
		MSCBSAY(xCol		,yLin+43 ,"Qtda: "		+ Transform (QRY->QTDE,"@E 999.99")					,"N",cTpFonte,cFonte5)	
		MSCBSAY(xCol+22	,yLin+43 ,"" 				+ Alltrim(Upper(QRY->UNIDADE))				  		,"N",cTpFonte,cFonte5)
		MSCBSAY(xCol+47	,yLin+43 ,"Qtda 2a: "	+ Transform(QRY->QT2UN,"@E 999.99")			  		,"N",cTpFonte,cFonte5)
		MSCBSAY(xCol+77	,yLin+43 ,""				+ Alltrim(Upper(QRY->UNIDADE2))						,"N",cTpFonte,cFonte5)
		MSCBSAY(xCol-1	   ,yLin+45 ,replicate("..",56)										  					,"N",cTpFonte,cFonte3)
		MSCBSAY(xCol		,yLin+48 ,"PEDIDO :"												  						,"N",cTpFonte,cFonte5)	
		MSCBSAY(xCol+52	,yLin+48 ,"NF :"													  						,"N",cTpFonte,cFonte5)	
		                                                                          			
	MSCBEND()
	MSCBCLOSEPRINTER()
	MS_FLUSH()
	
	QRY->(dbskip()) //dbSkip()
Enddo

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ VALIDPERG | ºAutor  ³SAMUEL MIRNDA    º Data ³  04/02/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±              Criar as Perguntas caso elas não existam.                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg()
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i,j
Local nTamSX1	:= Len(SX1->X1_GRUPO)
Local aHelp := {}
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("RESTR036",nTamSX1)

Aadd(aRegs,{cPerg,"01","PFI...................? ","PFI...............?","PFI...............?","mv_cha","C",11,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SD4","","","","",""})
Aadd(aRegs,{cPerg,"02","Fornecedor............? ","Fornecedor........?","Fornecedor........?","mv_chb","C",25,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//Aadd(aRegs,{cPerg,"02","Quantidade Copias.....? ","Quantidade Copias ?","Quantidade Copias ?","mv_chb","N",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

