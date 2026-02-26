#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR033 ºAutor  ³Samuel Mirada		 º Data ³  26/09/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de impressao de Controle de Terceiros               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTR033()
Local ni            
Local aSay 			:= {}
Local aButton 		:= {}
Local cFornedor		:= {}
Local cPdCompra		:= {}
Local nOpc 			:= 0
Local cTitulo 		:= "Impressão de etiqueta de Controle de terceiros."

Private cDesc1 		:= "Este programa irá imprimir as etiquetas de "
Private cDesc2 		:= "Controle de Fornecedores , em impressora térmica Zebra, "
Private cDesc3 		:= "conforme os parâmetros definidos pelo usuário."
Private cDesc4 		:= ""
Private cDesc5 		:= "By TI  Ortosintese"
Private cPerg  		:= Padr("RESTR033",10)
Private lEnd 		:= .F.  

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
	RptStatus({|lEnd| U_RESTRImp(@lEnd,mv_par01,mv_par02,mv_par03)},"Imprimindo, aguarde...")
Endif	

Return()

User Function RESTRImp(lEnd,mv_par01,mv_par02,mv_par03)
// _cNf 	:= Número da Nota Fiscal
// _cPed 	:= Número do Pedido 
// _nQtdR 	:= Número de Copias
Local ni
Local nCopias 		:= mv_par03
Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 		:= "0"
Local cFonte1 		:= "015,015"
Local cFonte2 		:= "017,017"
Local cFonte3 		:= "020,020"
Local cFonte4 		:= "024,024"
Local cFonte5 		:= "060,060"
Local cFonte6 		:= "090,090"
Local aArea 		:= GetArea()
Local aQry	 		:= {}
Local nCampos		:= {}
Local cQuery		:=""
Local cQuery2		:=""
Private cCodUser    := RetCodUsr()
Private cNamUser 	:= UsrRetName( cCodUser )//Retorna o nome do Usúario Logado  

	cQuery := "SELECT " + CHR(13)+CHR(10)
	cQuery += "A2_COD," + CHR(13)+CHR(10)
	cQuery += "A2_NOME," + CHR(13)+CHR(10)
	cQuery += "A2_NREDUZ," + CHR(13)+CHR(10)
	cQuery += "F2_CLIENTE," + CHR(13)+CHR(10)
	cQuery += "F2_CLIENT," + CHR(13)+CHR(10)
	cQuery += "F2_DOC " + CHR(13)+CHR(10)
	cQuery += "FROM " + CHR(13)+CHR(10)
	cQuery += RetSqlName('SF2010') + " SF2 " + CHR(13)+CHR(10)
	cQuery += " INNER JOIN SA2010 SA2 ON A2_COD = F2_CLIENTE " + CHR(13)+CHR(10)
	cQuery += " WHERE  " + CHR(13)+CHR(10)
	cQuery += "F2_TIPO='B' " + CHR(13)+CHR(10)
	cQuery += "AND SF2.F2_FILIAL ='01'" + CHR(13)+CHR(10)
	cQuery += "AND SF2.D_E_L_E_T_ =' ' " + CHR(13)+CHR(10)
	cQuery += "AND SA2.D_E_L_E_T_ =' ' " + CHR(13)+CHR(10)
	cQuery += "AND F2_DOC='"+mv_par01+"'" + CHR(13)+CHR(10)
	cQuery := ChangeQuery(cQuery) 
	MEMOWRIT( "RESTR033.SQL", cQuery ) 
	
  	//Executando consulta
	TCQuery cQuery New Alias "QRY"

SetRegua(1)	

cQuery2 :="SELECT DISTINCT C7_NUM,"+ CHR(13)+CHR(10)
cQuery2 +="C7_NUMSC" + CHR(13)+CHR(10)
cQuery2 += "FROM " + CHR(13)+CHR(10)
cQuery2 += RetSqlName('SC7010') + " SC7 " + CHR(13)+CHR(10)
cQuery2 += " WHERE  " + CHR(13)+CHR(10) 
cQuery2 += " C7_NUM = '"+mv_par02+"' " + CHR(13)+CHR(10)       
// IN ('000106','000105','004004') "  + CHR(13)+CHR(10)   

TCQuery cQuery2 New Alias "QRY2"
	//Percorrendo os registros
	While ! QRY2->(EoF())
		aAdd(aQry,{	C7_NUM,C7_NUMSC})
		//nSequen++
		QRY2->(DbSkip())
	EndDo
DbSelectArea("QRY")
IncRegua() 


	MSCBPRINTER(cImpressora,cPorta)	 
	MSCBCHKSTATUS(.F.)     
	MSCBLOADGRAF("LOG3.GRF")
	MSCBBEGIN(nCopias,4) 
	
	MSCBBOX(003,001,099,055,3)  // Box da Borda
	//MSCBLINEV(058,012,018,3,"B") //vertical do lote
	MSCBGRAFIC(05,02,"LOG3")
	MSCBLINEV(14,001,012,3,"B") //Linha Vestical 
	MSCBSAY(28,02,"ORTOSINTESE IND. E COM. LTDA"      						,"N",cTpFonte,cFonte4)
	//MSCBSAY(21,04,"Ortosintese Ind e Com Ltda"								,"N",cTpFonte,cFonte8)//Nome da Enpresa
	MSCBSAY(19,05,"RUA PROF. AFFONSO JOSE FIORAVANTE,63 CITY EMPRESARIAL, JARAGUA "	,"N",cTpFonte,cFonte2)//Nome da Enpresa
	MSCBSAY(17,08,"CEP 02998-010 SÃO PAULO - SP FONE:(11)3948-4000 - FAX:(11)3948-4010"	,"N",cTpFonte,cFonte2)//Nome da Enpresa
	//MSCBSAY(15,11,"Fone:(0xx11)3948-4000 - Fax:(0xx11)3948-4010"	  		,"N",cTpFonte,cFonte3)//Nome da Enpresa		
	//
	MSCBLINEH(003,012,099,3,"B") //Linha horizontal
	
	//MSCBSAY(03,13,+ ALLTRIM(A2_NREDUZ)	,"N",cTpFonte,cFonte6)
	MSCBSAY(03,13,+ Alltrim(Substr(A2_NREDUZ,1,22))	,"N",cTpFonte,cFonte5)
	
	MSCBLINEH(003,023,099,3,"B") //Linha horizontal
	
	MSCBSAY(04,24,"PEDIDO DE COMPRA "	,"N",cTpFonte,cFonte3)
	MSCBSAY(04,27,+ ALLTRIM(aQry[1,1])	,"N",cTpFonte,cFonte5)
	
	MSCBSAY(50,24,"SOLITAÇÃO DE COMPRA "	,"N",cTpFonte,cFonte3)
	MSCBSAY(50,27,+ ALLTRIM(aQry[1,2])	,"N",cTpFonte,cFonte5)
	
	MSCBLINEH(003,035,099,3,"B") //Linha horizontal
	MSCBSAY(04,36,"NOTA FISCAL "		,"N",cTpFonte,cFonte3)
	MSCBSAY(04,39,+ ALLTRIM(F2_DOC)		,"N",cTpFonte,cFonte5)
	//MSCBSAY(05,13,aQry[3,2] ,"N",cTpFonte,cFonte6)
		
	MSCBLINEH(003,050,099,3,"B") //Linha horizontal
	MSCBSAY(04,52,"Data : " 				+dToc(dDataBase)						,"N",cTpFonte,cFonte4)  //SC2->C2_DATPRF
	MSCBSAY(40,52,"Emitente : "	 	 		+Alltrim(Upper(cNamUser))				,"N",cTpFonte,cFonte4) 	
		
	QRY->(DbCloseArea())
	MSCBEND()
	MSCBCLOSEPRINTER()
	MS_FLUSH()

Return()

Static Function ValidPerg()
Local ni
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i,j
Local nTamSX1	:= Len(SX1->X1_GRUPO)
Local aHelp := {}
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("RESTR033",nTamSX1)

Aadd(aRegs,{cPerg,"01","Nota Fiscal.....? ","Nota Fiscal.....?","Nota Fiscal.....? "		    ,"mv_cha","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SF2","","","","",""})
Aadd(aRegs,{cPerg,"02","Nº. PD Compra.....? ","Nº. PD Compra.....?","Nº. PD Compra.....? "		,"mv_chb","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","","",""})
Aadd(aRegs,{cPerg,"03","Quantidade Copias.....? ","Quantidade Copias ?","Quantidade Copias ? "	,"mv_chc","N",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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