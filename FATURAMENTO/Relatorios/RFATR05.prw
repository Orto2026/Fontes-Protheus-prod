#INCLUDE "TOTVS.CH"

User Function RFATR05()
Local nRec := 0
Local cQuery     := ""
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Consulta Carteiroa de Pedidios - ORTOSINTESE                      
<Autor> : Raphael Camillo - Dema
<Data> : 12/06/2018
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Faturamento 
<Tipo> (Especificas ) :	 E
<Obs> : Considera todos os Pedidos de vendas - Em Aberto e Faturados conforme Parametro - Exporta EXCEL
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
//Local  mParametros := {}
//Local cPerg	:= "RFATR05A"
//Local aRegs	:= {}

Private cDrvArq  := ""
Private cQryPlan1:= "QRYPLAN1"

ValidPerg()

cQuery += " SELECT 'PEDIDOS' AS TIPO, "
cQuery += "        CASE WHEN C5_CLASPED ='1' THEN 'REPOSI«√O' "
cQuery += "        WHEN C5_CLASPED = '2' THEN 'CAIXAS'  "
cQuery += "        WHEN C5_CLASPED = '3' THEN 'EQUIPAMENTOS'  "
cQuery += "        WHEN C5_CLASPED = '4' THEN 'EXPORTA«√O'  "
cQuery += "        WHEN C5_CLASPED = '5' THEN 'DIVERSOS'  "
cQuery += "        WHEN C5_CLASPED = '6' THEN 'PECAS EQUIP.'  "
cQuery += "        ELSE 'OUTROS' END AS CLASSIFICACAO_PEDIDO,  "
cQuery += "        CASE WHEN C5_XTPVEND ='1' THEN 'REPRESENTANTE' "
cQuery += "        WHEN C5_XTPVEND = '2' THEN 'DISTRIBUIDOR' "
cQuery += "        WHEN C5_XTPVEND = '3' THEN 'LICITACAO' "
cQuery += "        WHEN C5_XTPVEND = '4' THEN 'VENDAS' "
cQuery += "        ELSE '' END AS TIPO_VENDA, "
cQuery += "        CASE WHEN C6_QTDVEN > C6_QTDENT AND C6_BLQ ='' THEN 'EM ABERTO' "
cQuery += "               WHEN C6_QTDVEN = C6_QTDENT  THEN 'FATURADO TOTAL' "
cQuery += "               WHEN C6_QTDVEN > C6_QTDENT AND C6_BLQ <>'' THEN 'FATURADO PARCIAL' "
cQuery += "               WHEN C6_QTDENT = 0 AND C6_BLQ <>'' THEN 'NAO FATURADO' "
cQuery += "          ELSE 'OUTROS' END AS STATUS_PV, "
cQuery += " C5_NUM AS PEDIDO,C5_XOPER AS TIPO_OPERACAO, C5_TIPO AS TIPO_PEDIDO,	C5_CLASPED,C5_EMISSAO AS EMISSAO_PV, C6_ENTREG AS DTENTREGA, C6_XLIBPED AS DTLIB, C5_VEND1 AS VEND_1,C5_VEND2 AS VEND_2,C5_VEND3 AS VEND_3, "
cQuery += " C5_VEND4 AS VEND_4 , C5_CLIENTE AS COD_CLIENTE, C5_LOJACLI AS LOJA,A1_NOME AS NOME, A1_EST AS ESTADO,C6_PRODUTO AS PRODUTO,B1_DESC AS DESC_PROD,C6_QTDVEN AS QTDE_ORIGINAL, C6_QTDENT AS QTDE_ENTREGUE, (C6_QTDVEN - C6_QTDENT) AS QTDE_PENDENTE, B1_TIPO AS TIPO_PRODUTO, "
cQuery += " C6_PRCVEN AS PRC_UNIT, "
cQuery += " CASE     WHEN C5_MOEDA = '1'  THEN ((C6_QTDVEN)*C6_PRCVEN) "
cQuery += "          WHEN C5_MOEDA = '2'  THEN ((C6_QTDVEN)*C6_PRCVEN) * (SELECT M2_MOEDA2 FROM "+RetSqlName('SM2')+" M2 WHERE M2_DATA = C5_EMISSAO AND M2.D_E_L_E_T_ = ' ') "
cQuery += "          ELSE ((C6_QTDVEN)*C6_PRCVEN) END AS VLR_TOTAL, "
cQuery += " CASE     WHEN C5_MOEDA = '1'  THEN ((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) "
cQuery += "          WHEN C5_MOEDA = '2'  THEN ((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) * (SELECT M2_MOEDA2 FROM "+RetSqlName('SM2')+" M2 WHERE M2_DATA = C5_EMISSAO AND M2.D_E_L_E_T_ = ' ') "
cQuery += "          ELSE ((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) END AS VLR_TOTAL_PENDENTE, "
cQuery += "          C5_MOEDA,  C6_CF AS CFOP,C6_LOCAL AS ARMAZEM, B1_GRUPO AS GRUPO_PROD,BM_DESC AS DESC_GRUPO,SUBSTRING(C5_EMISSAO,1,4) AS ANO,SUBSTRING(C5_EMISSAO,5,2) AS MES, B1_XCODGRP AS COD_ORTO_GRUPO, "
cQuery += " CASE     WHEN B1_LOCPAD IN ('01','02','03') THEN 'ORTOPEDIA' "
cQuery += "          WHEN B1_LOCPAD IN ('11','12','14') THEN 'EQUIPAMENTOS'  "
cQuery += "          ELSE 'OUTROS' END AS UNIDADE, "
cQuery += " CASE     WHEN A1_EST = 'EX' THEN 'EXTERNO' "
cQuery += "          ELSE 'INTERNO' END AS MERCADO, "
cQuery += "          (RTRIM(LTRIM(C6_PRODUTO))+'-'+RTRIM(LTRIM(B1_DESC))) AS COD_DESC, "
cQuery += "          X5.X5_DESCRI AS REGIAO, "
cQuery += "          COALESCE((SELECT A3_NOME FROM "+RetSqlName("SA3")+" A3 WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND A3.D_E_L_E_T_ = ' ' AND A3_COD = C5_VEND1),'') AS NOM_VEND_1, "
cQuery += "          COALESCE((SELECT A3_NOME FROM "+RetSqlName("SA3")+" A3 WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND A3.D_E_L_E_T_ = ' ' AND A3_COD = C5_VEND2),'') AS NOM_VEND_2, "
cQuery += "          COALESCE((SELECT A3_NOME FROM "+RetSqlName("SA3")+" A3 WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND A3.D_E_L_E_T_ = ' ' AND A3_COD = C5_VEND3),'') AS NOM_VEND_3, "
cQuery += "          COALESCE((SELECT A3_NOME FROM "+RetSqlName("SA3")+" A3 WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND A3.D_E_L_E_T_ = ' ' AND A3_COD = C5_VEND4),'') AS NOM_VEND_4, "
cQuery += "          COALESCE((SELECT A3_NOME FROM "+RetSqlName("SA3")+" A3 WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND A3.D_E_L_E_T_ = ' ' AND A3_COD = C5_VEND4),'') AS NOM_VEND_4 "
         
cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " INNER JOIN "+RetSqlName("SC5")+" SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC5.D_E_L_E_T_ = ' ' AND C5_TIPO = 'N' AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " //'"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1  ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SF4")+" F4  ON F4_FILIAL = '"+xFilial("SF4")+"' AND F4_CODIGO = C6_TES AND F4.D_E_L_E_T_ = ' ' " 
If cValtoChar(Mv_Par06) == "1"
	cQuery += " AND F4_DUPLIC = 'S' "
ElseIf cValtoChar(Mv_Par06) == "2"
	cQuery += " AND F4_DUPLIC = 'N' "
EndIf
cQuery += " INNER JOIN "+RetSqlName("SBM")+" BM  ON BM_FILIAL = '"+xFilial("SBM")+"' AND BM_GRUPO = B1_GRUPO AND BM.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SX5")+" X5  ON X5_FILIAL = '"+xFilial("SX5")+"' AND X5_TABELA ='Z1' AND X5_CHAVE = SA1.A1_EST "
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.D_E_L_E_T_ = ' ' "

If cValtoChar(Mv_Par03) == "1" //Unidade ( E- Equipamento O - Ortopedia)
	cQuery += " AND C6_LOCAL IN('11','12','14') 
Else
	cQuery += " AND C6_LOCAL = '01' "
EndIf

If cValtoChar(Mv_Par04) == "1" //Status do Pedido (1 - Aberto ou 2 - todos)
	cQuery += " AND C6_QTDVEN <> C6_QTDENT AND C6_BLQ = ' ' " 
EndIf
cQuery += "AND C5_CLASPED = '"+cValtoChar(MV_PAR07)+"'   " //ClassificaÁ„o do pedido- Incluido Por Samuel Miranda 21/02/2024
cQuery += " ORDER BY C5_NUM "

MEMOWRIT( "RFATR05.SQL", cQuery )   
dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery ), "QUERY" , .T. , .F. )

TCSetField("QUERY","EMISSAO_PV","D",8,0)
TCSetField("QUERY","DTENTREGA","D",8,0)
TCSetField("QUERY","DTLIB","D",8,0)

dbSelectArea( "QUERY" )
dbGotop()
QUERY->(dbEval({ || nRec++ },,{||!Eof()} ))
dbGoTop()

If nRec == 0
	dbSelectArea("QUERY")
	dbCloseArea()
	FWAlertInfo( "Nenhum registro foi encontrado", 'A T E N « √ O ' )
	Return()
EndIf   


//Criando/Carregando TRBo
//MsAguarde({|| MontaQry() },"Aguarde","Selecionando Dados...",.F.)

//If FwMsgRun(NIL, {|| MontaQry()}, "Processando", "Coletando os dados...")= .F.
//	Alert("Nenhum registro foi encontrado.","Verifique os par‚metros")
//	Return()
//EndIF
//Cria XML e abre EXCEL
//MsAguarde({|| GeraXml() },"Aguarde","Transferindo dados para o EXCEL",.T.)
FwMsgRun(NIL, {|| GeraXml()}, "Aguarde...", "Transferindo dados para o EXCEL..")

Return



///*/
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//<Descricao> : Gera XML
//<Data> : 14/02/2014
//<Parametros> : Nenhum
//<Retorno> : Nenhum
//<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : E
//<Autor> : Eduardo Fernandes
//<Obs> :
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//*/
Static Function GeraXml()

Local cArquivo		:= AllTrim(Mv_Par05)+".xml"
Local cDirDocs		:= MsDocPath()
Local oExcelApp	:= Nil
Local cPath			:= AllTrim(GetTempPath())
Local oExcel		:= FWMSEXCEL():New()
Local cPlan1, cTab11

cPlan1 := "Pedidos"
cTab11 := cPlan1

oExcel:SetHeaderBold(.T.)
oExcel:SetFrColorHeader("#363636")
oExcel:SetBgColorHeader("#EE9572")
oExcel:SetLineFrColor("#000000")
oExcel:Set2LineFrColor("#000000")
oExcel:SetLineBgColor("#FFFFFF")
oExcel:Set2LineBgColor("#FFFFFF")

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Sheet Pedidos                           ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

oExcel:AddWorkSheet(cPlan1)
oExcel:AddTable(cPlan1,cTab11)

If Select("QUERY") > 0
			//cWorkSheet,cTable ,cColumm	,nAlign	,nFormat	,lTotal
	oExcel:AddColumn(cPlan1		,cTab11	,"Tipo"						,1		,1			,.F.	) //01
	oExcel:AddColumn(cPlan1		,cTab11	,"ClassificaÁ„o do Pedido"  ,1		,1			,.F.	) //02
	oExcel:AddColumn(cPlan1		,cTab11	,"Tipo de Venda"  			,1		,1			,.F.	) //03
	oExcel:AddColumn(cPlan1		,cTab11	,"Status do Pedido"			,1		,1			,.F.	) //04
	oExcel:AddColumn(cPlan1		,cTab11	,"Numero do Pedido"			,1		,1			,.F.	) //05
	oExcel:AddColumn(cPlan1		,cTab11	,"Data Emissao"				,1		,1			,.F.	) //06
	oExcel:AddColumn(cPlan1		,cTab11	,"Data Entrega"				,1		,1			,.F.	) //07
	oExcel:AddColumn(cPlan1		,cTab11	,"Data Liberacao"			,1		,1			,.F.	) //08
	oExcel:AddColumn(cPlan1		,cTab11	,"Vendedor 1"				,1		,1			,.F.	) //09
	oExcel:AddColumn(cPlan1		,cTab11	,"Nome Vend 1"				,1		,1			,.F.	) //10
	oExcel:AddColumn(cPlan1		,cTab11	,"Vendedor 2"				,1		,1			,.F.	) //11
	oExcel:AddColumn(cPlan1		,cTab11	,"Nome Vend 2"				,1		,1			,.F.	) //12
	oExcel:AddColumn(cPlan1		,cTab11	,"Vendedor 2"				,1		,1			,.F.	) //13
	oExcel:AddColumn(cPlan1		,cTab11	,"Nome Vend 3"				,1		,1			,.F.	) //14
	oExcel:AddColumn(cPlan1		,cTab11	,"Vendedor 4"				,1		,1			,.F.	) //15
	oExcel:AddColumn(cPlan1		,cTab11	,"Nome Vend 4"				,1		,1			,.F.	) //16

	oExcel:AddColumn(cPlan1		,cTab11	,"Cliente"					,1		,1			,.F.	) //17
	oExcel:AddColumn(cPlan1		,cTab11	,"Loja"						,1		,1			,.F.	) //18
	oExcel:AddColumn(cPlan1		,cTab11	,"Raz„o Social"				,1		,1			,.F.	) //19
	oExcel:AddColumn(cPlan1		,cTab11	,"Estado"					,1		,1			,.F.	) //20
	oExcel:AddColumn(cPlan1		,cTab11	,"Regi„o"					,1		,1			,.F.	) //21
	oExcel:AddColumn(cPlan1		,cTab11	,"Mercado"					,1		,1			,.F.	) //22

	oExcel:AddColumn(cPlan1		,cTab11	,"Produto"					,1		,1			,.F.	) //23
	oExcel:AddColumn(cPlan1		,cTab11	,"DescriÁao"				,1		,1			,.F.	) //24
	oExcel:AddColumn(cPlan1		,cTab11	,"Tipo Produto"				,1		,1			,.F.	) //25
	oExcel:AddColumn(cPlan1		,cTab11	,"Grupo"					,1		,1			,.F.	) //26
	oExcel:AddColumn(cPlan1		,cTab11	,"DescriÁ„o Grupo"			,1		,1			,.F.	) //27
	oExcel:AddColumn(cPlan1		,cTab11	,"Armazem"					,1		,1			,.F.	) //28
	oExcel:AddColumn(cPlan1		,cTab11	,"Cfop"						,1		,1			,.F.	) //29

	oExcel:AddColumn(cPlan1		,cTab11	,"Qtde Original"			,3		,2			,.F.	) //30
	oExcel:AddColumn(cPlan1		,cTab11	,"Qtde Entregue"			,3		,2			,.F.	) //31
	oExcel:AddColumn(cPlan1		,cTab11	,"Qtde Pendente"			,3		,2			,.F.	) //32

	oExcel:AddColumn(cPlan1		,cTab11	,"PreÁo Unit·rio"			,3		,3			,.F.	) //33
	oExcel:AddColumn(cPlan1		,cTab11	,"Valor Total"				,3		,3			,.F.	) //34
	oExcel:AddColumn(cPlan1		,cTab11	,"Valor Total Pendente"		,3		,3			,.F.	) //35

	oExcel:AddColumn(cPlan1		,cTab11	,"Ano"						,1		,1			,.F.	) //36
	oExcel:AddColumn(cPlan1		,cTab11	,"MÍs"						,1		,1			,.F.	) //37
	
	oExcel:AddColumn(cPlan1		,cTab11	,"Cod Orto Grupo"			,1		,1			,.F.	) //38
	oExcel:AddColumn(cPlan1		,cTab11	,"Unidade"					,1		,1			,.F.	) //39
	oExcel:AddColumn(cPlan1		,cTab11	,"Tipo Operacao"			,1		,1			,.F.	) //40    
	oExcel:AddColumn(cPlan1		,cTab11	,"Tipo Pedido"				,1		,1			,.F.	) //41

EndIf

dbSelectArea("QUERY")
DbGoTop()
While !Eof()
	
	QUERY->(oExcel:AddRow(cPlan1,cTab11,{;
	TIPO,;
	CLASSIFICACAO_PEDIDO,;
	TIPO_VENDA,;
	STATUS_PV,;
	PEDIDO,;
	EMISSAO_PV,; 
	DTENTREGA,;
	DTLIB,;
	VEND_1,;
	NOM_VEND_1,;
	VEND_2,;
	NOM_VEND_2,;
	VEND_3,;
	NOM_VEND_3,;
	VEND_4,;
	NOM_VEND_4,;
	COD_CLIENTE,; 
	LOJA,; 
	NOME,;
	ESTADO,;
	REGIAO,;
	MERCADO,;
	PRODUTO,; 
	DESC_PROD,; 
	TIPO_PRODUTO,; 
	GRUPO_PROD,; 
	DESC_GRUPO,; 
	ARMAZEM,; 
	CFOP,;
	QTDE_ORIGINAL,; 
	QTDE_ENTREGUE,; 
	QTDE_PENDENTE,;
	PRC_UNIT,;
	VLR_TOTAL,;
	VLR_TOTAL_PENDENTE,;
	ANO,;
	MES,;
	COD_ORTO_GRUPO,; 
	UNIDADE,;
	TIPO_OPERACAO,; 
	TIPO_PEDIDO;
   	}))
	
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
	MsgAlert("N„o existem titulos para os parametros informados")
EndIf

Return




Static Function ValidPerg()

Local aPergs      := {}
Local aRet        := {}
//Local cCodCliDe   := Space(TamSX3( 'A1_COD' )[01])
//Local cCodCliAt   := Space(TamSX3( 'A1_COD' )[01])
Local dDataDe     := FirstDate()
Local dDataAt     := LastDate(Date())
//Local nOrdemDe    := Space(TamSX3( 'CB7_ORDSEP' )[01])
//Local nOrdemAt    := Space(TamSX3( 'CB7_ORDSEP' )[01]) //
//Local nNFDe       := Space(TamSX3( 'CB7_NOTA' )[01])
//Local nNFAt       := Space(TamSX3( 'CB7_NOTA' )[01]) //
//Local cSegto      := Space(20)
//Local nClasPed  := 1
local aClassifiq   := {"1=Reposicao","2=Caixas","3=Equipamentos","4=Exportacao","5=Diversos","6=Pecas Equip","7=Sob Medida" }
local aComboUnidade   := {"1=Equipamentos","2=Ortopedia"}
local aComboStatu   := {"1=Em Aberto","2=Todos"}
Local aNome := "RELATORIO"
Local aTipoSaida := {"1=Gera","2=Nao Gera","3=Ambos"}
DEFAULT lCanSave := .T.
DEFAULT lUserSave := .T.
aadd(aPergs, {01, "Data Inicial"       		,dDataDe,"",".T.","","",80,.F.})
aadd(aPergs, {01, "Data Final"         		,dDataAt,"",".T.","","",80,.F.})
aadd(aPergs, {02, "Unidade"            		,		  1,aComboUnidade,80,"",.F.})
aadd(aPergs, {02, "Status do Pedido"   		,		  1,aComboStatu,80,"",.F.})
aadd(aPergs, {01, "Nome do Arquivo "   		, 	  aNome,"",".T.","","",80,.F.})
aadd(aPergs, {02, "TES Qto Financeiro" 		, 		 1,aTipoSaida,80,"", .F.}) 
aadd(aPergs, {02, "ClassificaÁ„o Pedido" 	,        1,aClassifiq,80,"", .F.}) 

If ParamBox(aPergs ,"Informe os par‚metros",aRet,,,,,,,,lCanSave,lUserSave,)
EndIf

Return(aRet)
