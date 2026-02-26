#INCLUDE "TOTVS.CH"

User Function RCOMR04()
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Consulta Compras 
<Autor> : Raphael Camillo - Dema
<Data> : 06/03/2018
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Compras
<Tipo> (Especificas ) :	 E
<Obs> : 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local cPerg	:= "RCOMR04"

Private cDrvArq  := ""
Private cQryPlan1:= "QRYPLAN1"

//CriaSx1(cPerg)

If !Pergunte(cPerg,.T.)
	Return()
EndIf

MsAguarde({|| MontaQry() },"Aguarde","Selecionando Dados...",.F.)

//Cria XML e abre EXCEL
MsAguarde({|| GeraXml() },"Aguarde","Transferindo dados para o EXCEL",.T.)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Monta Query temporaria dos registros SD1/SD2 conforme parametros
<Autor> : Dema
<Data> : 06/03/2018
<Parametros> : Nil
<Retorno> : NIL
<Processo> : Nenhum
<Tipo> (Especificas ) : E
<Obs> :
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Static Function MontaQry()

Local cQuery     := ""

cQuery += " SELECT D1_COD AS CODIGO_PRODUTO, B1_DESC AS DESCRICAO_PRODUTO, B1_TIPO AS TIPO_PRODUTO, D1_QUANT AS QUANTIDADE, D1_VUNIT AS VALOR_UNITARIO, D1_TOTAL AS VALOR_TOTAL, D1_SERIE AS SERIE_NOTA, D1_DOC AS NOTA_FISCAL, D1_FORNECE AS CODIGO_FORNECEDOR, D1_LOJA AS LOJA_FORNECEDOR, A2_NREDUZ AS NOME_FORNECEDOR, D1_DTDIGIT AS DATA_EMISSAO, SUBSTRING(D1_DTDIGIT,1,4) AS ANO,SUBSTRING(D1_DTDIGIT,5,2) AS MES "
cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND D1_COD = B1_COD AND SB1.D_E_L_E_T_ = ' '  "
If Mv_Par03 == 1
	cQuery += " AND SB1.B1_LOCPAD IN ('11','96') "   
EndIf	
If Mv_Par03 == 2
	cQuery += " AND SB1.B1_LOCPAD IN ('10','97') "
EndIf
If Mv_Par03 == 3
	cQuery += " AND SB1.B1_LOCPAD IN ('10','97','11','96') "
EndIf
cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_FILIAL = '"+xFilial("SA2")+"' AND D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ' '  "
cQuery += " INNER JOIN "+RetSqlName("Sf4")+" SF4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND D1_TES = F4_CODIGO AND SF4.F4_DUPLIC ='S' AND SF4.D_E_L_E_T_ = ' ' "
cQuery += " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' 
cQuery += " AND D1_DTDIGIT BETWEEN '"+Dtos(Mv_Par01)+"' AND '"+Dtos(Mv_Par02)+"' "
cQuery += " AND D1_COD BETWEEN '"+Mv_par04+"' AND '"+Mv_Par05+"' "
cQuery += " AND D1_FORNECE BETWEEN '"+Mv_par06+"' AND '"+Mv_Par07+"' "
cQuery += " AND SD1.D_E_L_E_T_ = ' ' "

cQuery += " UNION ALL "

cQuery += " SELECT D2_COD, B1_DESC, B1_TIPO, (D2_QUANT * -1), D2_PRCVEN, (D2_TOTAL * -1), D2_SERIE, D2_DOC, D2_CLIENTE, D2_LOJA , A2_NREDUZ, "
cQuery += " D2_EMISSAO, SUBSTRING(D2_DTDIGIT,1,4) AS ANO, SUBSTRING(D2_DTDIGIT,5,2) AS MES "
cQuery += " FROM "+RetSqlName("SD2")+" SD2 "
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ' ' "
If Mv_Par03 == 1
	cQuery += " AND SB1.B1_LOCPAD IN ('11','96') "   
EndIf	
If Mv_Par03 == 2
	cQuery += " AND SB1.B1_LOCPAD IN ('10','97') "
EndIf
If Mv_Par03 == 3
	cQuery += " AND SB1.B1_LOCPAD IN ('10','97','11','96') "
EndIf
cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_FILIAL = '"+xFilial("SA2")+"' AND D2_CLIENTE = A2_COD AND D2_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SF4")+" SF4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND D2_TES = F4_CODIGO AND SF4.F4_DUPLIC ='S' AND SF4.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SD1")+" SD1 ON SD1.D1_FILIAL = SD2.D2_FILIAL AND SD1.D1_DOC =  SD2.D2_NFORI AND SD1.D1_SERIE = SD2.D2_SERIORI AND SD1.D1_ITEM = SD2.D2_ITEMORI AND SD1.D1_FORNECE = SD2.D2_CLIENTE AND SD1.D1_LOJA = SD2.D2_LOJA "
cQuery += " AND SD1.D1_EMISSAO BETWEEN '"+Dtos(Mv_Par01)+"' AND '"+Dtos(Mv_Par02)+"' "
cQuery += " WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery += " AND D2_COD BETWEEN '"+Mv_par04+"' AND '"+Mv_Par05+"' "
cQuery += " AND D1_FORNECE BETWEEN '"+Mv_par06+"' AND '"+Mv_Par07+"' "
cQuery += " AND SD2.D_E_L_E_T_ = ' '  "

cQuery += " ORDER BY 1 "

dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery ), "QUERY" , .T. , .F. )

TCSetField("QUERY","ENTRADA","D",8,0)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Gera XML
<Data> : 14/02/2014
<Parametros> : Nenhum
<Retorno> : Nenhum
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : E
<Autor> : Eduardo Fernandes
<Obs> :
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Static Function GeraXml()

Local cArquivo		:= AllTrim(Mv_Par08)+".xml"
Local cDirDocs		:= MsDocPath()
Local oExcelApp	:= Nil
Local cPath			:= AllTrim(GetTempPath())
Local oExcel		:= FWMSEXCEL():New()
Local cPlan1, cTab11

cPlan1 := "Compras"
cTab11 := cPlan1

oExcel:SetHeaderBold(.T.)
oExcel:SetFrColorHeader("#363636")
oExcel:SetBgColorHeader("#EE9572")
oExcel:SetLineFrColor("#000000")
oExcel:Set2LineFrColor("#000000")
oExcel:SetLineBgColor("#FFFFFF")
oExcel:Set2LineBgColor("#FFFFFF")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Sheet Compras          	                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oExcel:AddWorkSheet(cPlan1)
oExcel:AddTable(cPlan1,cTab11)

If Select("QUERY") > 0
	//cWorkSheet,cTable ,cColumm	,nAlign	,nFormat	,lTotal
	oExcel:AddColumn(cPlan1		,cTab11	,"Produto"			,1		,1			,.F.	) //01
	oExcel:AddColumn(cPlan1		,cTab11	,"Descrição"   		,1		,1			,.F.	) //02
	oExcel:AddColumn(cPlan1		,cTab11	,"Tipo"  			,1		,1			,.F.	) //03
	oExcel:AddColumn(cPlan1		,cTab11	,"Quantidade"		,3		,1			,.F.	) //04
	oExcel:AddColumn(cPlan1		,cTab11	,"Preço Unitário"	,3		,3			,.F.	) //05
	oExcel:AddColumn(cPlan1		,cTab11	,"Valor Total"		,3		,3			,.F.	) //06
	oExcel:AddColumn(cPlan1		,cTab11	,"Série da Nota"	,1		,1			,.F.	) //07
	oExcel:AddColumn(cPlan1		,cTab11	,"Nota Fiscal"		,1		,1			,.F.	) //08
	oExcel:AddColumn(cPlan1		,cTab11	,"Fornecedor"		,1		,1			,.F.	) //09
	oExcel:AddColumn(cPlan1		,cTab11	,"Loja"	  			,1		,1			,.F.	) //10
	oExcel:AddColumn(cPlan1		,cTab11	,"Nome"				,1		,1			,.F.	) //11
	oExcel:AddColumn(cPlan1		,cTab11	,"Data Emissao"		,1		,1			,.F.	) //12
	oExcel:AddColumn(cPlan1		,cTab11	,"Ano"				,1		,1			,.F.	) //13
	oExcel:AddColumn(cPlan1		,cTab11	,"Mês"				,1		,1			,.F.	) //14
EndIf

dbSelectArea("QUERY")
DbGoTop()
While !Eof()

	QUERY->(oExcel:AddRow(cPlan1,cTab11,{CODIGO_PRODUTO, DESCRICAO_PRODUTO, TIPO_PRODUTO, QUANTIDADE, VALOR_UNITARIO, VALOR_TOTAL, SERIE_NOTA, NOTA_FISCAL, CODIGO_FORNECEDOR, LOJA_FORNECEDOR, NOME_FORNECEDOR, DATA_EMISSAO, ANO, MES}))
	
	dbSkip()
EndDo
dbCloseArea()

If !Empty(oExcel:aWorkSheet)
	oExcel:Activate()
	oExcel:GetXMLFile(cDirDocs+"\"+cArquivo)
	
	CpyS2T(cDirDocs+"\"+cArquivo,cPath)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()
Else
	MsgAlert("Não existem titulos para os parametros informados")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CriaSX1   ³ Rev.  ³ Wagner Gomes Costa    ³ Data ³14.08.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria uma janela contendo a legenda da mBrowse              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Osteolink                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1(cPerg)

Local aArea	:= GetArea()

Local aP:= {}
Local i:= 0
Local cSeq
Local cMvCh
Local cMvPar
Local aHelp:= {}
//   01		02		03		04		05	   06   07    08           09		  10		11		12		13		   14		  15		16		  17
// cGrupo cOrdem cPergunt cPerSpa cPerEng cVar cTipo nTamanho [ nDecimal ] [ nPresel ] cGSC [ cValid ] [ cF3 ] [ cGrpSxg ] [ cPyme ] [ cVar01 ] [ cDef01 ] [ cDefSpa1 ] [ cDefEng1 ] [ cCnt01 ] [ cDef02 ] [ cDefSpa2 ] [ cDefEng2 ] [ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] [ cDef04 ] [ cDefSpa4 ] [ cDefEng4 ] [ cDef05 ] [ cDefSpa5 ] [ cDefEng5 ] [ aHelpPor ] [ aHelpEng ] [ aHelpSpa ] [ cHelp ] )
aAdd(aP,{"Emissao de"                	,"D", 08,0,"G","",""		,""           	,""             ,""            ,"",""})
aAdd(aP,{"Emissao ate"               	,"D", 08,0,"G","",""		,""           	,""             ,""            ,"",""})
aAdd(aP,{"Unidade        "            	,"N", 01,0,"C","",""   		,"Equipamentos"	,"Ortopedia"    ,"Ambos"       ,"",""})
aAdd(aP,{"Produto de"                 	,"C", 15,0,"G","","SB1"		,""           	,""             ,""            ,"",""})
aAdd(aP,{"Produto ate"                	,"C", 15,0,"G","","SB1"		,""           	,""             ,""            ,"",""})
aAdd(aP,{"Fornecedor de"                ,"C", 06,0,"G","","SA2"	,""           	,""             ,""            ,"",""})
aAdd(aP,{"Fornecedor ate"               ,"C", 06,0,"G","","SA2"	,""           	,""             ,""            ,"",""})
aAdd(aP,{"Nome do Arquivo "          	 ,"C", 20,0,"G","",""		,""           	,""             ,""            ,"",""})

aAdd(aHelp,{"Informe a Data de Emissao  ","inicial para a seleção dos dados"})
aAdd(aHelp,{"Informe a Data de Emissao  ","final para a seleção dos dados"})
aAdd(aHelp,{"Informe a Unidade" ,"a ser impressas."})
aAdd(aHelp,{"Informe o Código do Produto ","inicial para a seleção dos dados"})
aAdd(aHelp,{"Informe o Código do Produto ","Final para a seleção dos dados"})
aAdd(aHelp,{"Informe o Código do Fornecedor ","inicial para a seleção dos dados"})
aAdd(aHelp,{"Informe o Código do Fornecedor ","Final para a seleção dos dados"})
aAdd(aHelp,{"Informe o nome do Arquivo","a ser criado."})

_aParm := aClone(aP)

For i:=1 To Len(aP)
	cSeq   := StrZero(i,2,0)
	
	cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
	PutSx1(cPerg,;
	cSeq,;
	aP[i,1],aP[i,1],aP[i,1],;
	cMvCh,;
	aP[i,2],;
	aP[i,3],;
	aP[i,4],;
	0,;
	aP[i,5],;
	aP[i,6],;
	aP[i,7],;
	"",;
	"",;
	cMvPar,;
	aP[i,8],aP[i,8],aP[i,8],;
	"",;
	aP[i,9],aP[i,9],aP[i,9],;
	aP[i,10],aP[i,10],aP[i,10],;
	aP[i,11],aP[i,11],aP[i,11],;
	aP[i,12],aP[i,12],aP[i,12],;
	aHelp[i],;
	{},;
	"")
Next i

RestArea(aArea)

Return()