#INCLUDE "Acda100.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "DBTREE.CH"
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ºRotina    | ACDSEP01    ºAuto ³Samuel Miranda     º Data ³  03/10/2021 º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ºDescricao | Gera uma relação em excel dos itens para separação.        º±±
//±±º                                     							    	º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ºUso       | Especifico Ortosintese                                     º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

User Function ACDSEP01() //ACDSEP01

	Private cPerg		:= "ACDSEP"
	Private cDrvArq  	:= ""
	Private cQryPlan1	:= "QRYPLAN1"

	ValidPerg()                                                 '

//CriaSx1(cPerg)
	If !Pergunte(cPerg,.T.)
		Return()
	EndIf

	MsAguarde({|| MontaQry() },"Aguarde","Selecionando Dados...",.F.)

//Cria XML e abre EXCEL
	MsAguarde({|| GeraXml() },"Aguarde","Transferindo dados para o EXCEL",.T.)
//Processa({|| MontaCom()})

Return()


Static Function MontaQry()
//Monta a query 
	Local cQuery     := ""

	cQuery := " SELECT DISTINCT				"+CHR(13)+CHR(10)
	cQuery += "CB7.CB7_CLIENT AS CODCLI,	"+CHR(13)+CHR(10)
	cQuery += "SC5.C5_XNREDUZ AS NOMCLI,"+CHR(13)+CHR(10)
	cQuery += "CB8.CB8_PEDIDO AS NUMPED,"+CHR(13)+CHR(10)
	cQuery += "CB8.CB8_PROD AS CODPRO,"+CHR(13)+CHR(10)
	cQuery += "CB8.CB8_ITEM AS ITEM,"+CHR(13)+CHR(10)
	cQuery += "CB8.CB8_SEQUEN AS SEQUENCIA,"+CHR(13)+CHR(10)
	cQuery += "CB8.CB8_LOCAL AS ARMAZEM,"+CHR(13)+CHR(10)
	cQuery += "CB8.CB8_LCALIZ AS PROEND,"+CHR(13)+CHR(10)
	cQuery += "CB8.CB8_LOTECT AS PROLOTE,"+CHR(13)+CHR(10)
	cQuery += "CB8.CB8_QTDORI AS QTDEORI,"+CHR(13)+CHR(10)
	cQuery += "CB8.CB8_SALDOS AS PROSALDO,"+CHR(13)+CHR(10)
	cQuery += "CB8.CB8_SALDOE AS SALDOEST,"+CHR(13)+CHR(10)
	cQuery += "CB7.CB7_ORDSEP AS ORDSEP,"+CHR(13)+CHR(10)
	cQuery += "CB7.CB7_NOTA AS NUMNF,"+CHR(13)+CHR(10)
	cQuery += "CB7.CB7_DTEMIS AS EMISSAO,"+CHR(13)+CHR(10)
	cQuery += "CB7.CB7_STATUS AS STATUSB7
	cQuery += " FROM "+RetSqlName("CB7")+" CB7 "
	cQuery += " INNER JOIN "+RetSqlName("CB8")+" CB8 ON CB8.CB8_ORDSEP = CB7.CB7_ORDSEP AND CB8.CB8_LOCAL = CB7.CB7_LOCAL AND CB8.D_E_L_E_T_= ' ' "+CHR(13)+CHR(10)
	cQuery += " INNER JOIN "+RetSqlName("SC5")+" SC5  ON SC5.C5_NUM = CB8.CB8_PEDIDO AND CB8.CB8_LOCAL = SC5.C5_LOJACLI AND SC5.D_E_L_E_T_= ' ' "+CHR(13)+CHR(10)
	cQuery += " WHERE  "+CHR(13)+CHR(10)
	cQuery += " CB7.CB7_CLIENT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "+CHR(13)+CHR(10)
	cQuery += " AND CB7.CB7_ORDSEP BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+CHR(13)+CHR(10)
	cQuery += " AND CB7.CB7_DTEMIS BETWEEN '"+Dtos(MV_PAR05)+"' AND '"+Dtos(MV_PAR06)+"' "+CHR(13)+CHR(10)
	cQuery += " AND CB7.CB7_STATUS <> '2' AND CB7.CB7_STATUS <> '9' " +CHR(13)+CHR(10)
	cQuery += "  ORDER BY  CB7.CB7_CLIENT" +CHR(13)+CHR(10)
	dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery ), "QRY" , .T. , .F. )


//TCSetField("QUERY","ENTRADA","D",8,0)
Return()

Static Function GeraXml()

	Local cArquivo		:= "Separacao.xml"//AllTrim(Mv_Par08)+".xml"
	Local cDirDocs		:= MsDocPath()
	Local oExcelApp		:= Nil
	Local cPath			:= AllTrim(GetTempPath())
	Local oExcel		:= FWMSEXCEL():New()
	Local cPlan1, c
	Local cPlan1, cDadosTab

	cPlan1 := "PLANILHA SEPARAÇÃO DE PEDIDOS"
	cDadosTab := cPlan1

	oExcel:SetHeaderBold(.T.)
	oExcel:SetFrColorHeader("#363636")
	oExcel:SetBgColorHeader("#EE9572")
	oExcel:SetLineFrColor("#000000")
	oExcel:Set2LineFrColor("#000000")
	oExcel:SetLineBgColor("#FFFFFF")
	oExcel:Set2LineBgColor("#FFFFFF")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Sheet Separação de Pedidos              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oExcel:AddWorkSheet(cPlan1)
	oExcel:AddTable(cPlan1,cDadosTab)

	If Select("QRY") > 0
		//cWorkSheet,cTable ,cColumm	,nAlign	,nFormat	,lTotal
		oExcel:AddColumn(cPlan1	,cDadosTab,"CODCLI"	,1		,1			,.F.	) //01
		oExcel:AddColumn(cPlan1	,cDadosTab,"NOMCLI" ,1		,1			,.F.	) //02
		oExcel:AddColumn(cPlan1	,cDadosTab,"NUMPED"  ,1		,1			,.F.	) //03
		oExcel:AddColumn(cPlan1	,cDadosTab,"CODPRO" ,1		,1			,.F.	) //04
		oExcel:AddColumn(cPlan1	,cDadosTab,"ITEM"	,1		,1			,.F.	) //05
		oExcel:AddColumn(cPlan1	,cDadosTab,"SEQUENCIA",1	,1			,.F.	) //06
		oExcel:AddColumn(cPlan1	,cDadosTab,"ARMAZEM",1		,1			,.F.	) //07
		oExcel:AddColumn(cPlan1	,cDadosTab,"PROEND"	,1		,1			,.F.	) //08
		oExcel:AddColumn(cPlan1	,cDadosTab,"PROLOTE",1		,1			,.F.	) //09
		oExcel:AddColumn(cPlan1	,cDadosTab,"QTDEORI",1		,1			,.F.	) //10
		oExcel:AddColumn(cPlan1	,cDadosTab,"PROSALDO",1		,1			,.F.	) //11
		oExcel:AddColumn(cPlan1	,cDadosTab,"SALDOEST",1		,1			,.F.	) //12
		oExcel:AddColumn(cPlan1	,cDadosTab,"ORDSEP"	 ,1		,1			,.F.	) //13
		oExcel:AddColumn(cPlan1	,cDadosTab,"NUMNF"	 ,1		,1			,.F.	) //14
		oExcel:AddColumn(cPlan1	,cDadosTab,"EMISSAO" ,1		,1			,.F.	) //15

	EndIf

	dbSelectArea("QRY")
	DbGoTop()
	While !Eof()
		//			1			1			3			4			5			6				7
		QRY->(oExcel:AddRow(cPlan1,cDadosTab,{QRY->CODCLI,QRY->NOMCLI, QRY->NUMPED, QRY->CODPRO,  QRY->ITEM,    QRY->SEQUENCIA,QRY->ARMAZEM,;
			QRY->PROEND,QRY->PROLOTE,QRY->QTDEORI,QRY->PROSALDO,QRY->SALDOEST,QRY->ORDSEP,   QRY->NUMNF,QRY->EMISSAO}))

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
		MsgAlert("Não existem dados a serem informados")
	EndIf

Return




Static Function ValidPerg()
	Local _sAlias	:= Alias()
	Local aRegs		:= {}
	Local i,j
	Local nTamSX1	:= Len(SX1->X1_GRUPO)
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg 			:= PADR("ACDSEP",nTamSX1)

	Aadd(aRegs,{cPerg,"01","Cliente de !      "	,"Cliente de  !     ","Cliente de !      ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	Aadd(aRegs,{cPerg,"02","Cliente Ate !     "	,"Cliente ate !     ","Cliente ate !     ","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	Aadd(aRegs,{cPerg,"03","Separação de !    "	,"Separação de !    ","Separação de !    ","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
	Aadd(aRegs,{cPerg,"04","Separação Ate !   "	,"Separação ate !   ","Separação ate !   ","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
	Aadd(aRegs,{cPerg,"05","Emissão de !      "	,"Emissão de !      ","Emissão de !      ","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"06","Emissão Ate !     "	,"Emissão ate !     ","Emissão ate !     ","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//Aadd(aRegs,{cPerg,"07","Numero de Copias !"	,"Numero de Copias !","Numero de Copias !","mv_ch7","N",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})


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
