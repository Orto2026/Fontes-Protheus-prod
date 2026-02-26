#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"  


/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦ Função   ¦ RESTR036 ¦ Autor ¦ Samuel Miranda      ¦ Data ¦ 04/02/2019 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Rotina de impressao de etiquetas de Saparação .            ¦¦¦
¦¦¦				de Produtos no almoxarifado via PFI.                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦ Especifico Ortosintese  					                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
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

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦ Função   ¦ RESTR36Imp ¦ Autor ¦ Samuel Miranda    ¦ Data ¦ 06/06/2025 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Função de impressão da etiqueta.                           ¦¦¦
¦¦¦Parametro ¦ 	Número da Ordem de Produção.                              ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/ 
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
Local nx            := 0
Local cAmzOrig 		:= ""
Local cEndOrig 		:= ""
Local nConSult 		:= .F.
//Local nOrigem       := nCemp
Private cDadosEmp  := {}
Private nSeqEmp    := {}
//Default nOrigem := .F.
xCol := 04 //Coluna
yLin := 03 //Linha

	//Valida a quantidade de empenhos
	nConSult := NSECSZS(nOP)

    SetRegua(1)
	cQuery := "SELECT " + CHR(13)+CHR(10)
	cQuery += "SD4.D4_COD AS CODIGO,"     + CHR(13)+CHR(10)
	cQuery += "SD4.D4_LOCAL AS ARM,"      + CHR(13)+CHR(10)
	cQuery += "SD4.D4_QTDEORI AS QTDE,"   + CHR(13)+CHR(10)
	cQuery += "SD4.D4_QUANT AS QTDE2,"    + CHR(13)+CHR(10)
	cQuery += "SD4.D4_QTSEGUM AS QT2UN,"  + CHR(13)+CHR(10)
	cQuery += "SD4.D4_LOTECTL AS LOTE,"   + CHR(13)+CHR(10)
	cQuery += "SC2.C2_LOTECTL AS LOTEOP," + CHR(13)+CHR(10)
	cQuery += "SC2.C2_PRODUTO AS PRODOP," + CHR(13)+CHR(10)
	cQuery += "SC2.C2_XDESC AS DESCOP,"   + CHR(13)+CHR(10)
	cQuery += "SC2.C2_QUANT AS QTDEOP,"   + CHR(13)+CHR(10)
	cQuery += "SB1.B1_DESC AS DESCRICAO," + CHR(13)+CHR(10)
	cQuery += "SB1.B1_UM AS UNIDADE,"     + CHR(13)+CHR(10)
	cQuery += "SB1.B1_SEGUM AS UNIDADE2," + CHR(13)+CHR(10)
	cQuery += "SZS.ZS_LOTECTL AS NLOTE, " + CHR(13)+CHR(10)
	cQuery += "SZS.ZS_LOCORI AS AMZORI, " + CHR(13)+CHR(10)
	cQuery += "SZS.ZS_ENDORI AS ENDORIG " + CHR(13)+CHR(10)
	cQuery += "FROM " + CHR(13)+CHR(10)
	cQuery += RetSqlName('SD4010') + " SD4 " + CHR(13)+CHR(10)
	cQuery += " INNER JOIN SB1010 SB1 ON SD4.D4_COD =  SB1.B1_COD AND SB1.D_E_L_E_T_ = ''  " + CHR(13)+CHR(10)
	cQuery += " INNER JOIN SC2010 SC2 ON SC2.C2_FILIAL = SD4.D4_FILIAL AND SC2.D_E_L_E_T_ ='' AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN = SD4.D4_OP AND SD4.D4_PRODUTO=SC2.C2_PRODUTO " + CHR(13)+CHR(10)
	iF nConSult == .F.
		//cQuery += " INNER JOIN SZS010 SZS ON SZS.ZS_OP = SD4.D4_OP AND SZS.ZS_LOTECTL=SD4.D4_LOTECTL AND SZS.ZS_PRODUTO=SD4.D4_COD  AND SZS.D_E_L_E_T_='' " + CHR(13)+CHR(10)
		cQuery += " INNER JOIN SZS010 SZS ON SZS.ZS_OP = SD4.D4_OP AND SZS.ZS_LOTECTL=SD4.D4_LOTECTL AND SZS.D_E_L_E_T_='' " + CHR(13)+CHR(10)
	  Else
		//cQuery += " INNER JOIN SZS010 SZS ON SZS.ZS_OP = SD4.D4_OP AND SZS.ZS_LOTECTL=SD4.D4_LOTECTL AND SZS.ZS_PRODUTO=SD4.D4_COD AND SZS.ZS_SEQUENC=D4_TRT AND SZS.D_E_L_E_T_='' " + CHR(13)+CHR(10)
		cQuery += " INNER JOIN SZS010 SZS ON SZS.ZS_OP = SD4.D4_OP AND SZS.ZS_LOTECTL=SD4.D4_LOTECTL AND SZS.ZS_SEQUENC=D4_TRT AND SZS.D_E_L_E_T_='' " + CHR(13)+CHR(10)
	EndIf
	cQuery += " WHERE  " + CHR(13)+CHR(10)
	cQuery += "SD4.D4_FILIAL = '01' " + CHR(13)+CHR(10)
	cQuery += "AND SD4.D_E_L_E_T_ = '' " + CHR(13)+CHR(10)
	cQuery += "AND SD4.D4_OP='"+ nOP +"'  " + CHR(13)+CHR(10)
	cQuery += "ORDER BY D4_COD " + CHR(13)+CHR(10)
	MemoWrite("RESTR036.SQL", cQuery )
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery ), "QRY" , .T. , .F. )	
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
		
		MSCBBOX(002,002,100,056,7)// Box da Borda																					
			MSCBSAY(xCol+20	,yLin+1 ,"ETIQUETA DE SEPARAÇÃO"								   ,"N",cTpFonte,cFonte6)
			MSCBSAY(xCol	,yLin+5	,"PFI: " 	  + Alltrim(cValToChar(nOP))				   ,"N",cTpFonte,cFonte5)
			MSCBSAY(xCol+40	,yLin+5	,"Lote PFI: " + Alltrim(Upper(cValtochar(QRY->LOTEOP)))	   ,"N",cTpFonte,cFonte5)
			MSCBSAY(xCol	,yLin+10,"Cod: " 	  + Alltrim(QRY->PRODOP)					   ,"N",cTpFonte,cFonte5)
			MSCBSAY(xCol+75	,yLin+05,"Qtde: " 	  + AllTrim(Transform(QRY->QTDEOP,"@E 99999")) ,"N",cTpFonte,cFonte5)
			MSCBSAY(xCol	,yLin+15 ,""		  + Alltrim(Substr(QRY->DESCOP,1,42)) 	       ,"N",cTpFonte,cFonte5) //Alltrim(Substr(SBE->BE_DESCRIC,1,35))	
			MSCBSAY(xCol	,yLin+20 ,""		  + Alltrim(Substr(QRY->DESCOP,43,42))         ,"N",cTpFonte,cFonte5)
			MSCBLINEH(002,27,100,7,"B") //Linha horizontal
			MSCBSAY(xCol	,yLin+27 ,"Produto : "+ Alltrim(QRY->CODIGO)					   ,"N",cTpFonte,cFonte5)
			MSCBSAY(xCol+58	,yLin+27 ,"Lote : "	  + Alltrim(Upper(QRY->LOTE))				   ,"N",cTpFonte,cFonte5) 
			MSCBSAY(xCol-1	,yLin+29 ,replicate("..",56)									   ,"N",cTpFonte,cFonte3)
			MSCBSAY(xCol	,yLin+32 ,""		  + Alltrim(Substr(cTexto1,1,50))  	           ,"N",cTpFonte,cFonte5) //Alltrim(Substr(SBE->BE_DESCRIC,1,35))	
			MSCBSAY(xCol	,yLin+37 ,""		  + Alltrim(Substr(cTexto1,51,50)) 	           ,"N",cTpFonte,cFonte5)
			MSCBSAY(xCol-1	,yLin+40 ,replicate("..",55)									   ,"N",cTpFonte,cFonte3)
			MSCBSAY(xCol	,yLin+43 ,"Amz. Orig.: "+Alltrim(QRY->AMZORI)					   ,"N",cTpFonte,cFonte5)	
			MSCBSAY(xCol+35	,yLin+43 ,"End. Orig.: " +Alltrim(QRY->ENDORIG) 	 			   ,"N",cTpFonte,cFonte5)
			MSCBSAY(xCol	,yLin+48 ,"Qtda: "	  + Transform (QRY->QTDE,"@E 999.99")		   ,"N",cTpFonte,cFonte5)	
			MSCBSAY(xCol+22	,yLin+48 ,"" 		  + Alltrim(Upper(QRY->UNIDADE))			   ,"N",cTpFonte,cFonte5)
			MSCBSAY(xCol+47	,yLin+48 ,"Qtda 2a: " + Transform(QRY->QT2UN,"@E 999.99")		   ,"N",cTpFonte,cFonte5)
			MSCBSAY(xCol+77	,yLin+48 ,""		  + Alltrim(Upper(QRY->UNIDADE2))			   ,"N",cTpFonte,cFonte5)
			MSCBSAY(xCol-1	,yLin+45 ,replicate("..",56)									   ,"N",cTpFonte,cFonte3)
		MSCBEND()
		MSCBCLOSEPRINTER()
		MS_FLUSH()
	//Next nx
	QRY->(dbskip()) //dbSkip()
Enddo
	QRY->(DbcloseArea()) //
Return()

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦ Função   ¦ DOCSZS ¦ Autor ¦ Samuel Miranda       ¦ Data ¦ 06/06/2025 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Pegar as informaçoes de armazem e endereço de Origem.      ¦¦¦
¦¦¦Retorna   ¦ 					                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/ 
Static Function DOCSZS(nOP)
	Local _cAlias := GetNextAlias()
	BeginSql Alias _cAlias
		//Executa a consulta no banco de dados (query em sql) //,ZS_LOCORI,ZS_ENDORI
		SELECT 
		SZS.ZS_PRODUTO,
		SZS.ZS_LOTECTL AS NLOTE,
		SZS.ZS_LOCORI AS AMZORI,
		SZS.ZS_ENDORI AS ENDORIG
		FROM %Table:SZS% SZS (NOLOCK)
		WHERE
		SZS.ZS_OP=%Exp:nOP% AND SZS.%NotDel%
	EndSql
	// Enquanto não for final de arquivo
	While (_cAlias)->(!Eof())
		aAdd(cDadosEmp,{(_cAlias)->NLOTE,(_cAlias)->AMZORI,(_cAlias)->ENDORIG})
		(_cAlias)->(DbSkip())
	EndDo
	(_cAlias)->(DbCloseArea())

Return(cDadosEmp)

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦ Função   ¦ NSECSZS ¦ Autor ¦ Samuel Miranda       ¦ Data ¦ 12/11/2025 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦Função para verificar a quantidade de linhas no apontamento.¦¦¦
¦¦¦Retorna   ¦ 					                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/ 
Static Function NSECSZS(nOP)
	Local _cAliasD4 := GetNextAlias()
	Local nVConsolt := .F.
	Local nRegs := 0
	BeginSql Alias _cAliasD4
		//Executa a consulta no banco de dados (query em sql) //,ZS_LOCORI,ZS_ENDORI
		SELECT 
		SD4.D4_TRT AS ND4TRT
		FROM %Table:SD4% SD4 (NOLOCK)
		WHERE
		SD4.D4_OP=%Exp:nOP% AND SD4.D4_TRT <>'' AND SD4.%NotDel%
	EndSql
	DbSelectArea(_cAliasD4)
	DbGotop()

	Do While !Eof()
		nRegs++
		dbSkip()
	Enddo
	If nRegs > 1
		nVConsolt := .T.
	Else
		nVConsolt := .F.
	EndIf

	(_cAliasD4)->(DbCloseArea())

Return(nVConsolt)

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
Local aRegs		:= {}
Local i 		:= 0
Local j			:= 0
Local nTamSX1	:= Len(SX1->X1_GRUPO)
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 			:= PADR("RESTR036",nTamSX1)

Aadd(aRegs,{cPerg,"01","PFI...................? ","PFI...............?","PFI...............?","mv_cha","C",11,0, 0,"G","","mv_par01","", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
Aadd(aRegs,{cPerg,"02","Fornecedor............? ","Fornecedor........?","Fornecedor........?","mv_chb","C",25,0, 0,"G","","mv_par02","", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

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

Return()
