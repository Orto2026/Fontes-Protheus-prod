#INCLUDE "rwmake.ch"
#include "TBICONN.CH"
#include "TBICODE.CH"
#include "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATR012	º Autor ³ Claudio Ferreira   º Data ³  20/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Faturamento Geral / Analitico          		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATR012()                                        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString
aOrd := {}
Private CbTxt        	:= ""
cDesc1         			:= "Este programa tem como objetivo imprimir relatorio "
cDesc2         			:= "de acordo com os parametros informados pelo usuario."
cDesc3         			:= "Relatorio de Faturamento Analitico"
cPict          			:= " "
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private limite       	:= 220
Private tamanho      	:= "G"
Private nomeprog     	:= "RFATR012" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        	:= 15
Private aReturn      	:= { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
Private nLastKey     	:= 0
titulo         			:= "Relatorio de Faturamento Analitico "
nLin           			:= 80
Private cbtxt        	:= Space(10)
Private cbcont       	:= 00
Private CONTFL       	:= 01
Private m_pag        	:= 01
imprime        			:= .T.
Private wnrel        	:= "RFATR012" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "SD2"
aRegs   				:= {}
cPerg   				:= "FATR012"
IsDev 					:= .F.
aExcel 					:= {}

Aadd(aRegs,{cPerg,"01","Emissao De          ?","","","mv_ch1","D",08,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Emissao Ate         ?","","","mv_ch2","D",08,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Produto De          ?","","","mv_ch3","C",15,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
Aadd(aRegs,{cPerg,"04","Produto Ate         ?","","","mv_ch4","C",15,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
Aadd(aRegs,{cPerg,"05","Nome do Arquivo     ?","","","mv_ch5","C",20,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Vendedor De          ?","","","mv_ch6","C",06,0,0,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
Aadd(aRegs,{cPerg,"07","Vendedor Ate         ?","","","mv_ch7","C",06,0,0,"G","","Mv_Par07","","","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
Aadd(aRegs,{cPerg,"08","Cliente De           ?","","","mv_ch8","C",06,0,0,"G","","Mv_Par08","","","","","","","","","","","","","","","","","","","","","","","","","","","CLI",""})
Aadd(aRegs,{cPerg,"09","Cliente Ate          ?","","","mv_ch9","C",06,0,0,"G","","Mv_Par09","","","","","","","","","","","","","","","","","","","","","","","","","","","CLI",""})
Aadd(aRegs,{cPerg,"10","Estado De            ?","","","mv_chA","C",02,0,0,"G","","Mv_Par10","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"11","Estado Ate           ?","","","mv_chB","C",02,0,0,"G","","Mv_Par11","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"12","TES Qto Financeiro   ?","","","mv_chC","N",01,0,3,"C","","Mv_Par12","Gera","Gera","Gera","","","Nao Gera","Nao Gera","Nao Gera","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"13","TES Qto Estoque      ?","","","mv_chD","N",01,0,3,"C","","Mv_Par13","Movimenta","Movimenta","Movimenta","","","Não Movimenta","Não Movimenta","Não Movimenta","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"14","Cosidera Devolucoes   ?","","","mv_chE","N",01,0,1,"C","","Mv_Par14","Sim","Si","Yes","","","Não","No","No","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"15","Qual Unidade          ?","","","mv_chF","N",01,0,1,"C","","Mv_Par15","Equipamentos","Equipamentos","Equipamentos","","","Ortopedia","Ortopedia","Ortopedia","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"16","Considera Venda Futura?","","","mv_chG","N",01,0,1,"C","","Mv_Par16","Sim","Si","Yes","","","Não","No","No","","","","","","","","","","","","","","","","","","","",""})


//ValidPerg(aRegs,cPerg)

Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec2	:=""
Cabec1	:=""

wnrel		:= SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)
titulo	:= "Relatorio de Faturamento analitico "
Cabec1  := " Tipo            Pedido  Emissao_PV  Dt. Entrega Vend_1  Vend_2  Vend_3  Vend_4  Nota     Serie  Item  Emissao_NF  Cliente  Loja  Nome                                    Produto        Desc_Prod      "
//           XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                      999.999.999,99      DD/MM/AAAA         DD/MM/AAAA  
//           01234567890123456789012399/99/99994567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345999.999.999,99
//           0         1         2         3         4         5         6         7         8         9        10        11        12        13        14         15        16        17        18        19        20        21        
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP5 IDE            º Data ³  30/09/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local ni
aStru := {}
aAdd(aStru,{"TIPO"					,"C",15,0})
aAdd(aStru,{"PEDIDO"					,"C",06,0})
aAdd(aStru,{"EMISSAO_PV"   		,"D",08,0})
aAdd(aStru,{"DTENTREGA" 	  		,"D",08,0})
aAdd(aStru,{"VEND_1"					,"C",06,0})
aAdd(aStru,{"VEND_2"					,"C",06,0})
aAdd(aStru,{"VEND_3"					,"C",06,0})
aAdd(aStru,{"VEND_4"			  		,"C",06,0})
aAdd(aStru,{"NOTA"					,"C",09,0})
aAdd(aStru,{"SERIE"					,"C",03,0})
aAdd(aStru,{"ITEM"					,"C",03,0})
aAdd(aStru,{"EMISSAO_NF"			,"D",08,0})
aAdd(aStru,{"CLIENTE"				,"C",06,0})
aAdd(aStru,{"LOJA"					,"C",02,0})
aAdd(aStru,{"NOME"					,"C",50,0})
aAdd(aStru,{"PRODUTO"				,"C",15,0})
aAdd(aStru,{"DESC_PROD"				,"C",60,0})
aAdd(aStru,{"QTDE"					,"N",11,2})
aAdd(aStru,{"PRC_UNIT"				,"N",11,2})
aAdd(aStru,{"VLR_TOTAL"				,"N",11,2})
aAdd(aStru,{"VLR_BRUTO"				,"N",11,2})
aAdd(aStru,{"ICMS"					,"N",11,2})
aAdd(aStru,{"IPI"					,"N",11,2})
aAdd(aStru,{"FRETE"					,"N",11,2})
aAdd(aStru,{"PIS"					,"N",11,2})
aAdd(aStru,{"COFINS"				,"N",11,2})
aAdd(aStru,{"CUSTO"					,"N",11,2})
aAdd(aStru,{"GRUPO_PROD"			,"C",06,0})
aAdd(aStru,{"DESC_GRUPO"			,"C",50,2})
aAdd(aStru,{"ANO"					,"C",04,0})
aAdd(aStru,{"MES"					,"C",02,0})
aAdd(aStru,{"COD_ORTO_GRUPO"		,"C",08,0})

cQuery := " SELECT '1-VENDAS' AS TIPO,C5_NUM AS PEDIDO,C5_EMISSAO AS EMISSAO_PV,	C5_XDTENTR AS DTENTREGA, C5_VEND1 AS VEND_1,C5_VEND2 AS VEND_2,C5_VEND3 AS VEND_3, "
cQuery += " C5_VEND4 AS VEND_4 ,D2_DOC AS NOTA,D2_SERIE AS SERIE,D2_ITEM AS ITEM,D2_EMISSAO AS EMISSAO_NF, "
cQuery += " D2_CLIENTE AS CLIENTE,D2_LOJA AS LOJA,A1_NOME AS NOME, A1_EST AS ESTADO,D2_COD AS PRODUTO,B1_DESC AS DESC_PROD,D2_QUANT AS QTDE, "
cQuery += " D2_PRCVEN AS PRC_UNIT,D2_TOTAL AS VLR_TOTAL,D2_VALBRUT AS VLR_BRUTO, D2_CF AS CFOP,D2_LOCAL AS ARMAZEM, "
cQuery += " CASE WHEN D2_VALICM <> 0 THEN ROUND(D2_VALICM,2) ELSE 0 END AS ICMS, "
cQuery += " CASE WHEN D2_VALIPI <> 0 THEN ROUND(D2_VALIPI,2) ELSE 0 END AS IPI,  "
cQuery += " CASE WHEN D2_VALFRE <> 0 THEN ROUND (D2_VALFRE,2) ELSE 0 END  AS FRETE, "
cQuery += " CASE WHEN D2_VALIMP6 <> 0 THEN ROUND(D2_VALIMP6,2) ELSE 0 END AS PIS,"
cQuery += " CASE WHEN D2_VALIMP5 <> 0 THEN ROUND(D2_VALIMP5,2) ELSE 0 END AS COFINS, "
cQuery += " ROUND(D2_CUSTO1,2) AS CUSTO,B1_GRUPO AS GRUPO_PROD,BM_DESC AS DESC_GRUPO,SUBSTRING(D2_EMISSAO,1,4) AS ANO,SUBSTRING(D2_EMISSAO,5,2) AS MES, B1_XCODGRP AS COD_ORTO_GRUPO, "

cQuery += " CASE     WHEN B1_LOCPAD IN ('01','02','03') THEN 'ORTOPEDIA' "
cQuery += "          WHEN B1_LOCPAD IN ('11','12') THEN 'EQUIPAMENTOS'  "
cQuery += "          ELSE 'OUTROS' END AS UNIDADE, "
cQuery += " CASE     WHEN A1_EST = 'EX' THEN 'EXTERNO' "
cQuery += "          ELSE 'INTERNO' END AS MERCADO, "
cQuery += "          (RTRIM(LTRIM(D2_COD))+'-'+RTRIM(LTRIM(B1_DESC))) AS COD_DESC, "
cQuery += "          X5.X5_DESCRI AS REGIAO, "
cQuery += "          COALESCE((SELECT A3_NOME FROM "+RetSqlName("SA3")+" WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND D_E_L_E_T_ = ' ' AND A3_COD = C5_VEND1),'') AS NOMEVEND1, "
cQuery += "          COALESCE((SELECT A3_NOME FROM "+RetSqlName("SA3")+" WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND D_E_L_E_T_ = ' ' AND A3_COD = C5_VEND2),'') AS NOMEVEND2, "
cQuery += "          COALESCE((SELECT A3_NOME FROM "+RetSqlName("SA3")+" WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND D_E_L_E_T_ = ' ' AND A3_COD = C5_VEND3),'') AS NOMEVEND3, "
cQuery += "          COALESCE((SELECT A3_NOME FROM "+RetSqlName("SA3")+" WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND D_E_L_E_T_ = ' ' AND A3_COD = C5_VEND4),'') AS NOMEVEND4, "
cQuery += "          CASE WHEN C5_CLASPED = '1' THEN 'REPOSICAO' "
cQuery += "               WHEN C5_CLASPED = '2' THEN 'CAIXAS' "
cQuery += "               WHEN C5_CLASPED = '3' THEN 'EQUIPAMENTOS' "
cQuery += "               WHEN C5_CLASPED = '4' THEN 'EXPORTACAO' "
cQuery += "               WHEN C5_CLASPED = '5' THEN 'DIVERSOS' 
cQuery += "				  WHEN C5_CLASPED = '6' THEN 'PECAS EQUIP.'
cQuery += "     		  WHEN C5_CLASPED = '7' THEN 'SOB MEDIDA'	
cQuery += "          ELSE 'OUTROS' END AS CLAS_PED, "
cQuery += "          CASE WHEN C5_XTPVEND ='1' THEN 'REPRESENTANTE' "
cQuery += "               WHEN C5_XTPVEND = '2' THEN 'DISTRIBUIDOR' "
cQuery += "               WHEN C5_XTPVEND = '3' THEN 'LICITACAO' "
cQuery += "               WHEN C5_XTPVEND = '4' THEN 'VENDA DIRETA' "
cQuery += "          ELSE 'NAO CLASSIFICADO' END AS TIPO_VENDA "
cQuery += " FROM "
cQuery += RetSqlName("SD2")+" D2 " 
cQuery += "INNER JOIN " + RetSqlName("SC5")+" C5 ON C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5.D_E_L_E_T_ = ' ' AND C5_VEND1 BETWEEN '"+Mv_par06+"' AND '"+Mv_par07+"' "
cQuery += "INNER JOIN " + RetSqlName("SA1")+" A1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND A1.D_E_L_E_T_ = ' ' AND A1_EST BETWEEN '"+Mv_par10+"' AND '"+Mv_par11+"' "
cQuery += "INNER JOIN " + RetSqlName("SB1")+" B1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = D2_COD AND B1.D_E_L_E_T_ = ' ' "
If Mv_par15 == 1
	cQuery += " AND B1_LOCPAD IN ('11','12','14') "
ElseIf Mv_par15 == 2
	cQuery += " AND B1_LOCPAD IN ('01','03','50') "
EndIf
cQuery += "INNER JOIN " + RetSqlName("SF4")+" F4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND F4_CODIGO = D2_TES AND F4.D_E_L_E_T_ = ' ' "
If Mv_Par12 == 1
	cQuery += " AND F4_DUPLIC = 'S' "
ElseIf Mv_Par12 == 2
	cQuery += " AND F4_DUPLIC = 'N' "
EndIf
If Mv_Par13 = 1
	cQuery += " AND F4_ESTOQUE = 'S' "
ElseIf Mv_Par13 = 2
	cQuery += " AND F4_ESTOQUE = 'N' "
EndIf
cQuery += "INNER JOIN " + RetSqlName("SBM")+" BM ON BM_FILIAL = '"+xFilial("SBM")+"' AND BM_GRUPO = B1_GRUPO AND BM.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN " + RetSqlName("SX5")+" X5 ON X5_FILIAL = '"+xFilial("SX5")+"' AND X5_TABELA ='Z1' AND X5_CHAVE = A1.A1_EST AND X5.D_E_L_E_T_ = ' ' "

cQuery += "WHERE  D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery += " AND D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += " AND D2_TIPO = 'N' "
cQuery += " AND D2.D_E_L_E_T_ = ' ' "
cQuery += " AND D2_CLIENTE BETWEEN '"+Mv_par08+"' AND '"+Mv_par09+"' "

If Mv_Par16 == 2
	cQuery += " AND D2_CF NOT IN ('5922','6922') "
EndIf

If Mv_Par14 == 1
	cQuery += "UNION  ALL "  										   

	cQuery += "SELECT '2-DEVOLUCAO' AS TIPO,COALESCE(C5_NUM,' ') AS PEDIDO,COALESCE(C5_EMISSAO,' ') AS EMISSAO_PV,COALESCE(C5_XDTENTR,' ') AS DTENTREGA, "
	cQuery += "COALESCE(C5_VEND1,' ') AS VEND_1,COALESCE(C5_VEND2,' ') AS VEND_2,COALESCE(C5_VEND3,' ') AS VEND_3, "
	cQuery += "COALESCE(C5_VEND4,' ') AS VEND_4,D1_DOC AS NOTA,D1_SERIE AS SERIE,D1_ITEM AS ITEM,D1_DTDIGIT AS EMISSAO_NF, "
	cQuery += "D1_FORNECE AS CLIENTE,D1_LOJA AS LOJA,A1_NOME AS NOME,A1_EST AS ESTADO,D1_COD AS PRODUTO,B1_DESC AS DESC_PROD,ROUND(D1_QUANT,2)*-1 AS QTDE,D1_VUNIT AS PRC_UNIT, "
	cQuery += "CASE WHEN A1_TIPO ='F' THEN (ROUND(D1_TOTAL,2) -ROUND(D1_VALIPI,2)) *-1 ELSE ROUND(D1_TOTAL,2) *-1 END AS VLR_TOTAL, ((ROUND(D1_TOTAL,2) +ROUND(D1_VALIPI,2) + ROUND(D1_DESPESA,2)+ ROUND(D1_VALFRE,2)- ROUND(D1_VALDESC,2)) *-1) AS VRL_BRUTO, D1_CF AS CFOP,D1_LOCAL AS ARMAZEM,D1_VALICM AS ICMS,ROUND(D1_VALIPI,2)*-1 AS IPI, D1_VALFRE AS FRETE, D1_VALIMP6 AS PIS,D1_VALIMP5 AS COFINS,ROUND(D1_CUSTO,2) AS CUSTO, " 
	cQuery += "B1_GRUPO AS GRUPO_PROD,BM_DESC AS DESC_GRUPO,SUBSTRING(D1_DTDIGIT,1,4) AS ANO,SUBSTRING(D1_DTDIGIT,5,2) AS MES, B1_XCODGRP AS COD_ORTO_GRUPO, "

	cQuery += " CASE     WHEN B1_LOCPAD IN ('01','02','03') THEN 'ORTOPEDIA' "
	cQuery += "          WHEN B1_LOCPAD IN ('11','12') THEN 'EQUIPAMENTOS'  "
	cQuery += "          ELSE 'OUTROS' END AS UNIDADE, "
	cQuery += " CASE     WHEN A1_EST = 'EX' THEN 'EXTERNO' "
	cQuery += "          ELSE 'INTERNO' END AS MERCADO, "
	cQuery += "          (RTRIM(LTRIM(D1_COD))+'-'+RTRIM(LTRIM(B1_DESC))) AS COD_DESC, "
	cQuery += "          X5.X5_DESCRI AS REGIAO, "
	cQuery += "          COALESCE((SELECT A3_NOME FROM "+RetSqlName("SA3")+" WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND D_E_L_E_T_ = ' ' AND A3_COD = C5_VEND1),'') AS NOMEVEND1, "
	cQuery += "          COALESCE((SELECT A3_NOME FROM "+RetSqlName("SA3")+" WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND D_E_L_E_T_ = ' ' AND A3_COD = C5_VEND2),'') AS NOMEVEND2, "
	cQuery += "          COALESCE((SELECT A3_NOME FROM "+RetSqlName("SA3")+" WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND D_E_L_E_T_ = ' ' AND A3_COD = C5_VEND3),'') AS NOMEVEND3, "
	cQuery += "          COALESCE((SELECT A3_NOME FROM "+RetSqlName("SA3")+" WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND D_E_L_E_T_ = ' ' AND A3_COD = C5_VEND4),'') AS NOMEVEND4, "
	cQuery += "          CASE WHEN C5_CLASPED = '1' THEN 'REPOSICAO' "
	cQuery += "               WHEN C5_CLASPED = '2' THEN 'CAIXAS' "
	cQuery += "               WHEN C5_CLASPED = '3' THEN 'EQUIPAMENTOS' "
	cQuery += "               WHEN C5_CLASPED = '4' THEN 'EXPORTACAO' "
	cQuery += "               WHEN C5_CLASPED = '5' THEN 'DIVERSOS' 
	cQuery += "				  WHEN C5_CLASPED = '6' THEN 'PECAS EQUIP.'
	cQuery += "     		  WHEN C5_CLASPED = '7' THEN 'SOB MEDIDA'	
	cQuery += "          ELSE 'OUTROS' END AS CLAS_PED, "
	cQuery += "          CASE WHEN C5_XTPVEND ='1' THEN 'REPRESENTANTE' "
	cQuery += "               WHEN C5_XTPVEND = '2' THEN 'DISTRIBUIDOR' "
	cQuery += "               WHEN C5_XTPVEND = '3' THEN 'LICITACAO' "
	cQuery += "               WHEN C5_XTPVEND = '4' THEN 'VENDA DIRETA' "
	cQuery += "          ELSE 'NAO CLASSIFICADO' END AS TIPO_VENDA "
	
	cQuery += " FROM "
	cQuery += RetSqlName("SD1")+" D1 " 
	cQuery += "LEFT OUTER JOIN " + RetSqlName("SD2")+" D2 ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2.D_E_L_E_T_ = ' ' AND D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "

	If Mv_Par16 == 2
		cQuery += " AND D1_CF NOT IN ('5922','6922') "
	EndIf

	cQuery += "LEFT OUTER JOIN " + RetSqlName("SC5")+" C5 ON C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5.D_E_L_E_T_ = ' ' AND C5_VEND1 BETWEEN '"+Mv_par06+"' AND '"+Mv_par07+"'  "
	cQuery += "INNER JOIN " + RetSqlName("SA1")+" A1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = D1_FORNECE AND A1_LOJA = D1_LOJA AND A1.D_E_L_E_T_ = ' '  AND A1_EST BETWEEN '"+Mv_par10+"' AND '"+Mv_par11+"' "
	cQuery += "INNER JOIN " + RetSqlName("SB1")+" B1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = D1_COD AND B1.D_E_L_E_T_ = ' ' "

	If Mv_par15 == 1
		cQuery += " AND B1_LOCPAD IN ('11','12','14') "
	ElseIf Mv_par15 == 2
		cQuery += " AND B1_LOCPAD IN ('01','03','50') "
	EndIf

	cQuery += "INNER JOIN " + RetSqlName("SF4")+" F4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND F4_CODIGO = D1_TES AND F4.D_E_L_E_T_ = ' ' " 
	If Mv_Par12 == 1
		cQuery += " AND F4_DUPLIC = 'S' "
	ElseIf Mv_Par12 == 2
		cQuery += " AND F4_DUPLIC = 'N' "
	EndIf
	If Mv_Par13 = 1
		cQuery += " AND F4_ESTOQUE = 'S' "
	ElseIf Mv_Par13 = 2
		cQuery += " AND F4_ESTOQUE = 'N' "
	EndIf
	cQuery += "INNER JOIN " + RetSqlName("SBM")+" BM ON BM_FILIAL = '"+xFilial("SBM")+"' AND BM_GRUPO = B1_GRUPO AND BM.D_E_L_E_T_ = ' ' " 
	cQuery += "INNER JOIN " + RetSqlName("SX5")+" X5 ON X5_FILIAL = '"+xFilial("SX5")+"' AND X5_TABELA ='Z1' AND X5_CHAVE = A1.A1_EST AND X5.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE  D1_FILIAL = '"+xFilial("SD1")+"' "                            
	cQuery += "AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery += "AND D1_TIPO = 'D' "
	cQuery += "AND D1.D_E_L_E_T_ = ' ' "  
	cQuery += " AND D1_FORNECE BETWEEN '"+Mv_par08+"' AND '"+Mv_par09+"' "


EndIf                                                                                    \
cQuery += "ORDER BY EMISSAO_NF, NOTA, SERIE, ITEM " 

cQuery := ChangeQuery(cQuery)
MEMOWRIT( "RFATR012.SQL", cQuery )

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)


For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('QUERY', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next

_nTot1 := 0
_nTot2 := 0

DbSelectArea("QUERY")
DbGoTop()
While !Eof()

	//Aadd(aExcel, {QUERY->RAZ_SOCIAL,Transform(Alltrim(QUERY->CNPJ),"@R 99.999.999/9999-99"),QUERY->NOTA,QUERY->SERIE,QUERY->PARCELA,QUERY->VALOR,QUERY->EMISSAO,QUERY->VENCTO,QUERY->VENCT_REAL,;
	//QUERY->TOT_RECEB})
	Aadd(aExcel, {QUERY->TIPO,QUERY->PEDIDO,QUERY->EMISSAO_PV,QUERY->DTENTREGA,QUERY->VEND_1,QUERY->VEND_2,QUERY->VEND_3,QUERY->VEND_4,QUERY->NOTA,QUERY->SERIE,QUERY->ITEM,QUERY->EMISSAO_NF,QUERY->CLIENTE,QUERY->LOJA,QUERY->NOME,QUERY->PRODUTO,;
	QUERY->DESC_PROD,QUERY->QTDE,QUERY->PRC_UNIT,QUERY->VLR_TOTAL,QUERY->CFOP,QUERY->VLR_BRUTO,QUERY->ICMS,QUERY->IPI,QUERY->FRETE,QUERY->PIS,QUERY->COFINS,QUERY->CUSTO,QUERY->GRUPO_PROD,QUERY->DESC_GRUPO,QUERY->ANO,QUERY->MES,QUERY->COD_ORTO_GRUPO,;
	QUERY->UNIDADE,QUERY->MERCADO,QUERY->COD_DESC,QUERY->REGIAO,;
	QUERY->NOMEVEND1,QUERY->NOMEVEND2,QUERY->NOMEVEND3,QUERY->NOMEVEND4,QUERY->CLAS_PED, QUERY->TIPO_VENDA})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	EndIf
	
	@ nLin,000 Psay QUERY->TIPO						PICTURE "@"
	@ nLin,017 Psay QUERY->PEDIDO				  		PICTURE "@!"
	@ nLin,025 Psay QUERY->EMISSAO_PV     			PICTURE "@D!"
	@ nLin,037 Psay QUERY->DTENTREGA     			PICTURE "@D!"
	@ nLin,049 Psay QUERY->VEND_1	       			PICTURE "@!"
	@ nLin,056 Psay QUERY->VEND_2      				PICTURE "@!"
	@ nLin,063 Psay QUERY->VEND_3						PICTURE "@D!"
	@ nLin,070 Psay QUERY->VEND_4    				PICTURE "@D!"
	@ nLin,081 Psay QUERY->NOTA						PICTURE "@"
	@ nLin,093 Psay QUERY->SERIE						PICTURE "@!"
	@ nLin,097 Psay QUERY->ITEM						PICTURE "@"
	@ nLin,104 Psay QUERY->EMISSAO_NF				PICTURE "@D!"
	@ nLin,115 Psay QUERY->CLIENTE					PICTURE "@"
	@ nLin,125 Psay QUERY->LOJA						PICTURE "@"
	@ nLin,131 Psay SUBSTRING(QUERY->NOME,1,30)	PICTURE "@"
	@ nLin,170 Psay QUERY->PRODUTO					PICTURE "@"
	@ nLin,185 Psay SUBSTRING(QUERY->DESC_PROD,1,30)					PICTURE "@"
	//@ nLin,215 Psay QUERY->QTDE						PICTURE "@E 999,999,999.99"
	//@ nLin,222 Psay QUERY->PRC_UNIT					PICTURE "@E 999,999,999.99"
	//@ nLin,239 Psay QUERY->VLR_TOTAL				PICTURE "@E 999,999,999.99"
	//@ nLin,253 Psay QUERY->VLR_BRUTO				PICTURE "@E 999,999,999.99"
	
	
	nLin++
	dbSkip()
EndDo

nLin ++


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

If MsgYesNo("Gera Planilha Excel?")
	GeraExcel()
EndIf

If Select("QUERY") >= 0
	DbCloseArea("QUERY")
EndIf

Return()

Static Function GeraExcel()

Local nHandle		:= 0
Local cArquivo		:= ""
Local cDirDocs  	:= MsDocPath()
Local cBarra 		:= If(issrvunix(), "/", "\")
Local cPath		  	:= AllTrim(GetTempPath())
Local cBuffer		:= ""
Local nColuna
Local nLinha

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")
	Return
EndIf

cArquivo 	:= "Rel_Faturamento_Analitico.csv"
nHandle 		:= FCreate(cDirDocs + cBarra + cArquivo)

If nHandle == -1
	MsgStop("A planilha não pode ser exportada.")
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava as linhas da planilha                									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cBuffer := ""
cBuffer	+= ToXlsFormat("TIPO")+";"
cBuffer	+= ToXlsFormat("PEDIDO")+";"
cBuffer	+= ToXlsFormat("EMISSAO_PV")+";"
cBuffer	+= ToXlsFormat("DTENTREGA")+";"
cBuffer	+= ToXlsFormat("VEND_1")+";"
cBuffer	+= ToXlsFormat("VEND_2")+";"
cBuffer	+= ToXlsFormat("VEND_3")+";"
cBuffer	+= ToXlsFormat("VEND_4")+";"
cBuffer	+= ToXlsFormat("NOTA")+";"
cBuffer	+= ToXlsFormat("SERIE")+";"
cBuffer	+= ToXlsFormat("ITEM")+";"
cBuffer	+= ToXlsFormat("EMISSAO_NF")+";"
cBuffer	+= ToXlsFormat("CLIENTE")+";"
cBuffer	+= ToXlsFormat("LOJA")+";"
cBuffer	+= ToXlsFormat("NOME")+";"
cBuffer	+= ToXlsFormat("PRODUTO")+";"
cBuffer	+= ToXlsFormat("DESC_PROD")+";"
cBuffer	+= ToXlsFormat("QTDE")+";"
cBuffer	+= ToXlsFormat("PRC_UNIT")+";"
cBuffer	+= ToXlsFormat("VLR_TOTAL")+";"
cBuffer	+= ToXlsFormat("CFOP")+";"
cBuffer	+= ToXlsFormat("VLR_BRUTO")+";"
cBuffer	+= ToXlsFormat("ICMS")+";"
cBuffer	+= ToXlsFormat("IPI")+";"
cBuffer	+= ToXlsFormat("FRETE")+";"
cBuffer	+= ToXlsFormat("PIS")+";"
cBuffer	+= ToXlsFormat("COFINS")+";"
cBuffer	+= ToXlsFormat("CUSTO")+";"
cBuffer	+= ToXlsFormat("GRUPO_PROD")+";"
cBuffer	+= ToXlsFormat("DESC_GRUPO")+";"
cBuffer	+= ToXlsFormat("ANO")+";"
cBuffer	+= ToXlsFormat("MES")+";"
cBuffer	+= ToXlsFormat("COD_ORTO_GRUPO")+";"
cBuffer	+= ToXlsFormat("UNIDADE")+";"
cBuffer	+= ToXlsFormat("MERCADO")+";"
cBuffer	+= ToXlsFormat("COD_DESCRICAO")+";"
cBuffer	+= ToXlsFormat("REGIAO")+";"
cBuffer	+= ToXlsFormat("NOME_VEND_1")+";"
cBuffer	+= ToXlsFormat("NOME_VEND_2")+";"
cBuffer	+= ToXlsFormat("NOME_VEND_3")+";"
cBuffer	+= ToXlsFormat("NOME_VEND_4")+";"
cBuffer	+= ToXlsFormat("CLASS_PEDIDO")+";"
cBuffer	+= ToXlsFormat("TIPO_VENDA")+";"

FWrite(nHandle, cBuffer)
FWrite(nHandle, CRLF)

cBuffer 	:= ""

ProcRegua(Len(aExcel))

For nLinha := 1 to Len(aExcel)
	
	IncProc("Gerando excel... ")
	
	For nColuna := 1 to Len(aExcel[nLinha])
		If Valtype(aExcel[nLinha,nColuna]) <> "C"
			cBuffer += ToXlsFormat(aExcel[nLinha,nColuna])+";"
		Else
			cBuffer += ToXlsFormat("'"+aExcel[nLinha,nColuna])+";"
		EndIf
	Next nColuna
	FWrite(nHandle, cBuffer)
	FWrite(nHandle, CRLF)
	cBuffer:=""
Next nLinha

FClose(nHandle)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³copia o arquivo do servidor para o remote									   			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CpyS2T(cDirDocs + cBarra + cArquivo, cPath, .T.)
Ferase(cDirDocs + cBarra + cArquivo)
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cPath+cArquivo)
oExcelApp:SetVisible(.T.)

Return()
