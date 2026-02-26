#INCLUDE "rwmake.ch"
#include "TBICONN.CH"
#include "TBICODE.CH"
#include "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ RFATR016 บAutor  ณSamuel Miranda      บ Data ณ  25/05/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de para impressao do relatorio geral de Vendas      บฑฑ
ฑฑบ          ณ 				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Ortosintese  Modulo  SIGAFAT                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RFATR016()                                        
//
// Declaracao de Variaveis
Local ni 				:= 0
Local nColuna			:= 0                                           
Private cString
aOrd := {}
Private CbTxt        	:= ""
cDesc1         			:= "Este programa tem como objetivo imprimir relatorio "
cDesc2         			:= "de acordo com os parametros informados pelo usuario."
cDesc3         			:= "Relatorio de Faturamento Diario"
cPict          			:= " "
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private limite       	:= 220
Private tamanho      	:= "G"
Private nomeprog     	:= "RFATR016" // Coloque aqui o nome do programa para impressao no cabecalho
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
Private wnrel        	:= "RFATR016" // Coloque aqui o nome do arquivo usado para impressao em disco
//Private cString 		:= "SD2" 
Private cTotal				:= 0 
Private cCodUser    		:= RetCodUsr()
Private cNamUser 			:= UsrRetName( cCodUser )//Retorna o nome do us
aRegs   			  		:= {}
cPerg   					:= "RFATR016"
IsDev 				  		:= .F.
aExcel 						:= {}

Pergunte(cPerg,.F.) //Validacao das Perguntas
//
// Monta a interface padrao com o usuario...                           
//
Cabec2	:=""
Cabec1	:=""
wnrel		:= SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)
titulo	:= "Relatorio Geral           Emitido Por: "+cNamUser+""
Cabec1  := "Pedido  Cliente  Emissโo         Produto      Descricao                                                                                                                              Varlor         Armazem     Dta Entraga"
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
//
// Processamento. RPTSTATUS monta janela com a regua de processamento. 
//
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return
//Descrio  Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS 
//monta a janela com a regua de processamento.                                                     
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local ni := 0
Local nColuna := 0
aStru := {}
aAdd(aStru,{"TIPO"		    		,"C",06,0}) //01 
aAdd(aStru,{"PEDIDO"		    	,"C",06,0}) //02 
aAdd(aStru,{"CLASSIF_PEDIDO"		,"C",50,0}) //03 
aAdd(aStru,{"EMISSAO_PV"   			,"D",08,0}) //04 
aAdd(aStru,{"DTENTREGA"   			,"D",08,0}) //05 
aAdd(aStru,{"VEND_1"   			    ,"C",15,0}) //06 
aAdd(aStru,{"VEND_2"   			    ,"C",15,0}) //07 
aAdd(aStru,{"VEND_3"   			    ,"C",15,0}) //08 
aAdd(aStru,{"VEND_4"   			    ,"C",15,0}) //09 
aAdd(aStru,{"NOTA"   			    ,"C",15,0}) //10 
aAdd(aStru,{"SERIE"   			    ,"C",02,0}) //11 
aAdd(aStru,{"ITEM"   			    ,"C",50,0}) //12
aAdd(aStru,{"EMISSAO_NF"   			,"D",08,0}) //13
aAdd(aStru,{"CLIENTE"   			,"C",60,0}) //14 
aAdd(aStru,{"LOJA"   				,"C",15,0}) //15 
aAdd(aStru,{"NOME"   				,"C",60,0}) //16 
aAdd(aStru,{"ESTADO"   				,"C",02,0}) //17 
aAdd(aStru,{"PRODUTO"   			,"C",30,0}) //18  
aAdd(aStru,{"DESC_PROD"   			,"C",60,0}) //19 
aAdd(aStru,{"QTDE"   				,"C",60,0}) //20 
aAdd(aStru,{"PRC_UNIT"   			,"N",10,0}) //21 
aAdd(aStru,{"VLR_BRUTO"   			,"N",10,0}) //22 
aAdd(aStru,{"CFOP"   		   		,"C",04,0}) //23
aAdd(aStru,{"ARMAZEM"   			,"C",10,0}) //24 
  
// Query SQL
cQuery :="SELECT"+CHR(13)+CHR(10)
cQuery +="'1-VENDAS' AS TIPO,"+CHR(13)+CHR(10)
cQuery +="C5_NUM AS PEDIDO, "+CHR(13)+CHR(10)
cQuery +="C5_CLASPED AS CLASSIF_PEDIDO, "+CHR(13)+CHR(10)
cQuery +="C5_EMISSAO AS EMISSAO_PV,"+CHR(13)+CHR(10)
cQuery +="C5_XDTENTR AS DTENTREGA, "+CHR(13)+CHR(10)
cQuery +="C5_VEND1 AS VEND_1,"+CHR(13)+CHR(10)
cQuery +="C5_VEND2 AS VEND_2,"+CHR(13)+CHR(10)
cQuery +="C5_VEND3 AS VEND_3, "+CHR(13)+CHR(10)
cQuery +="C5_VEND4 AS VEND_4,"+CHR(13)+CHR(10)
cQuery +="D2_DOC AS NOTA,"+CHR(13)+CHR(10)
cQuery +="D2_SERIE AS SERIE,"+CHR(13)+CHR(10)
cQuery +="D2_ITEM AS ITEM,"+CHR(13)+CHR(10)
cQuery +="D2_EMISSAO AS EMISSAO_NF, "+CHR(13)+CHR(10)
cQuery +="D2_CLIENTE AS CLIENTE,"+CHR(13)+CHR(10)
cQuery +="D2_LOJA AS LOJA,"+CHR(13)+CHR(10)
cQuery +="A1_NOME AS NOME,"+CHR(13)+CHR(10)
cQuery +="A1_EST AS ESTADO,"+CHR(13)+CHR(10)
cQuery +="D2_COD AS PRODUTO,"+CHR(13)+CHR(10)
cQuery +="B1_DESC AS DESC_PROD,"+CHR(13)+CHR(10)
cQuery +="D2_QUANT AS QTDE,"+CHR(13)+CHR(10) 
cQuery +="D2_PRCVEN AS PRC_UNIT,"+CHR(13)+CHR(10)
cQuery +="D2_TOTAL AS VLR_TOTAL,"+CHR(13)+CHR(10)
cQuery +="D2_VALBRUT AS VLR_BRUTO,"+CHR(13)+CHR(10)
cQuery +="D2_CF AS CFOP,"+CHR(13)+CHR(10)
cQuery +="D2_LOCAL AS ARMAZEM,"+CHR(13)+CHR(10) 
cQuery +="CASE WHEN D2_VALICM <> 0 THEN ROUND(D2_VALICM,2) ELSE 0 END AS ICMS,"+CHR(13)+CHR(10) 
cQuery +="CASE WHEN D2_VALIPI <> 0 THEN ROUND(D2_VALIPI,2) ELSE 0 END AS IPI,"+CHR(13)+CHR(10) 
cQuery +="CASE WHEN D2_VALFRE <> 0 THEN ROUND (D2_VALFRE,2) ELSE 0 END  AS FRETE,"+CHR(13)+CHR(10) 
cQuery +="CASE WHEN D2_VALIMP6 <> 0 THEN ROUND(D2_VALIMP6,2) ELSE 0 END AS PIS,"+CHR(13)+CHR(10)
cQuery +="CASE WHEN D2_VALIMP5 <> 0 THEN ROUND(D2_VALIMP5,2) ELSE 0 END AS COFINS,"+CHR(13)+CHR(10)
cQuery +="ROUND(D2_CUSTO1,2) AS CUSTO,B1_GRUPO AS GRUPO_PROD,BM_DESC AS DESC_GRUPO,SUBSTRING(D2_EMISSAO,1,4) AS ANO,SUBSTRING(D2_EMISSAO,5,2) AS MES, B1_XCODGRP AS COD_ORTO_GRUPO,"+CHR(13)+CHR(10)
cQuery +="CASE     WHEN B1_LOCPAD IN ('01','02','03') THEN 'ORTOPEDIA' "+CHR(13)+CHR(10)
cQuery +=" WHEN B1_LOCPAD IN ('11','12') THEN 'EQUIPAMENTOS'"+CHR(13)+CHR(10)  
cQuery +="ELSE 'OUTROS' END AS UNIDADE,"+CHR(13)+CHR(10) 
cQuery +="CASE     WHEN A1_EST = 'EX' THEN 'EXTERNO'"+CHR(13)+CHR(10) 
cQuery +="ELSE 'INTERNO' END AS MERCADO "+CHR(13)+CHR(10)
cQuery +="FROM"+CHR(13)+CHR(10) 
cQuery += 	RetSqlName( 'SD2' ) + " D2 "+CHR(13)+CHR(10)
cQuery +=	"INNER JOIN SC5010 C5 ON C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery +=	"INNER JOIN SA1010 A1 ON A1_FILIAL = '' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND A1.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery +=	"INNER JOIN SB1010 B1 ON B1_FILIAL = '' AND B1_COD = D2_COD AND B1.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery +=	"INNER JOIN SF4010 F4 ON F4_FILIAL = '' AND F4_CODIGO = D2_TES AND F4.D_E_L_E_T_ = ' ' AND F4_DUPLIC = 'S' "+CHR(13)+CHR(10)
cQuery +=	"INNER JOIN SBM010 BM ON BM_FILIAL = '' AND BM_GRUPO = B1_GRUPO AND BM.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery +=	"WHERE D2_FILIAL = '01' "+CHR(13)+CHR(10)
cQuery +=	"AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' 
cQuery +=	"AND D2.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery +=	"AND D2_TIPO IN ('N','C','P')  "+CHR(13)+CHR(10) //AND B1_LOCPAD IN ('11','12')
cQuery +=	"AND D2_CLIENTE BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"' "+CHR(13)+CHR(10)//POR CLIENTE
cQuery +=	"AND D2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "+CHR(13)+CHR(10)// POR CODIGO DO PRODUTO 
cQuery +=	"UNION  ALL "+CHR(13)+CHR(10)  
cQuery +=	"SELECT '2-DEVOLUCAO' AS TIPO,COALESCE(C5_NUM,' ') AS PEDIDO,COALESCE(C5_CLASPED,' '),COALESCE(C5_EMISSAO,' ') AS EMISSAO_PV,COALESCE(C5_XDTENTR,' ') AS DTENTREGA,"+CHR(13)+CHR(10)
cQuery +=	"COALESCE(C5_VEND1,' ') AS VEND_1,COALESCE(C5_VEND2,' ') AS VEND_2,COALESCE(C5_VEND3,' ') AS VEND_3, "+CHR(13)+CHR(10)
cQuery +=	"COALESCE(C5_VEND4,' ') AS VEND_4,D1_DOC AS NOTA,D1_SERIE AS SERIE,D1_ITEM AS ITEM,D1_DTDIGIT AS EMISSAO_NF, "+CHR(13)+CHR(10)
cQuery +=	"D1_FORNECE AS CLIENTE,D1_LOJA AS LOJA,A1_NOME AS NOME,A1_EST AS ESTADO,D1_COD AS PRODUTO,B1_DESC AS DESC_PROD,ROUND(D1_QUANT,2)*-1 AS QTDE,D1_VUNIT AS PRC_UNIT, "+CHR(13)+CHR(10)
cQuery +=	"CASE WHEN A1_TIPO ='F' THEN (ROUND(D1_TOTAL,2) -ROUND(D1_VALIPI,2)) *-1 ELSE ROUND(D1_TOTAL,2) *-1 END AS VLR_TOTAL,"+CHR(13)+CHR(10)
//CASE WHEN A1_TIPO ='F' THEN ((ROUND(D1_TOTAL,2)) *-1) ELSE ((ROUND(D1_TOTAL,2) +ROUND(D1_VALIPI,2)) *-1) END AS VRL_BRUTO,
cQuery +=	"((ROUND(D1_TOTAL,2) +ROUND(D1_VALIPI,2) + ROUND(D1_DESPESA,2)+ ROUND(D1_VALFRE,2)- ROUND(D1_VALDESC,2)) *-1) AS VRL_BRUTO,"+CHR(13)+CHR(10)
cQuery +=	"D1_CF AS CFOP,D1_LOCAL AS ARMAZEM,D1_VALICM AS ICMS,ROUND(D1_VALIPI,2)*-1 AS IPI, D1_VALFRE AS FRETE, D1_VALIMP6 AS PIS,D1_VALIMP5 AS COFINS,ROUND(D1_CUSTO,2) AS CUSTO, "+CHR(13)+CHR(10)
cQuery +=	"B1_GRUPO AS GRUPO_PROD,BM_DESC AS DESC_GRUPO,SUBSTRING(D1_DTDIGIT,1,4) AS ANO,SUBSTRING(D1_DTDIGIT,5,2) AS MES, B1_XCODGRP AS COD_ORTO_GRUPO ,"+CHR(13)+CHR(10)
cQuery +=	"CASE     WHEN B1_LOCPAD IN ('01','02','03') THEN 'ORTOPEDIA'"+CHR(13)+CHR(10)
cQuery +=	"         WHEN B1_LOCPAD IN ('11','12') THEN 'EQUIPAMENTOS'  "+CHR(13)+CHR(10)
cQuery +=	"         ELSE 'OUTROS' END AS UNIDADE  ,"+CHR(13)+CHR(10)
cQuery +=	"CASE     WHEN A1_EST = 'EX' THEN 'EXTERNO'"+CHR(13)+CHR(10)
cQuery +=	"         ELSE 'INTERNO' END AS MERCADO "+CHR(13)+CHR(10)
cQuery +="FROM"+CHR(13)+CHR(10) 
cQuery += 	RetSqlName( 'SD1' ) + " D1 "+CHR(13)+CHR(10)
cQuery +="LEFT OUTER JOIN SD2010 D2 ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery +=" LEFT OUTER JOIN SC5010 C5 ON C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery +=" INNER JOIN SA1010 A1 ON A1_FILIAL = '' AND A1_COD = D1_FORNECE AND A1_LOJA = D1_LOJA AND A1.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery +="INNER JOIN SB1010 B1 ON B1_FILIAL = '' AND B1_COD = D1_COD AND B1.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery +="INNER JOIN SF4010 F4 ON F4_FILIAL = '' AND F4_CODIGO = D1_TES AND F4.D_E_L_E_T_ = ' ' AND F4_DUPLIC = 'S' "+CHR(13)+CHR(10)
cQuery +="INNER JOIN SBM010 BM ON BM_FILIAL = '' AND BM_GRUPO = B1_GRUPO AND BM.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery +="WHERE  D1_FILIAL = '01' "+CHR(13)+CHR(10)
cQuery +="AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'" +CHR(13)+CHR(10)
cQuery +="AND D1_TIPO = 'D' "+CHR(13)+CHR(10)
cQuery +="AND D1.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
//cQuery +="AND B1_LOCPAD IN ('11','12')"+CHR(13)+CHR(10)
cQuery +=	"AND D2_TIPO IN ('N','C','P')  "+CHR(13)+CHR(10) //AND B1_LOCPAD IN ('11','12')
cQuery +=	"AND D2_CLIENTE BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"' "+CHR(13)+CHR(10)//POR CLIENTE
cQuery +=	"AND D2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "+CHR(13)+CHR(10)// POR CODIGO DO PRODUTO 
cQuery +="ORDER BY EMISSAO_NF, NOTA, SERIE, ITEM "+CHR(13)+CHR(10)
cQuery := ChangeQuery(cQuery) 

MEMOWRIT( "RFATR016.SQL", cQuery )  

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
	//Arrei Com dado para ser omportador para o excel
	Aadd(aExcel,{QUERY->TIPO,QUERY->PEDIDO,QUERY->CLASSIF_PEDIDO,QUERY->EMISSAO_PV, QUERY->DTENTREGA,QUERY->VEND_1, QUERY->VEND_2,QUERY->VEND_3, QUERY->VEND_4,QUERY->NOTA,QUERY->SERIE,QUERY->ITEM,QUERY->EMISSAO_NF, QUERY->CLIENTE,QUERY->LOJA,QUERY->NOME,  QUERY->ESTADO,QUERY->PRODUTO,QUERY->DESC_PROD,QUERY->QTDE,QUERY->PRC_UNIT,QUERY->VLR_BRUTO,QUERY->CFOP,QUERY->ARMAZEM })
	
	// Verifica o cancelamento pelo usuario...                             
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	// Impressao do cabecalho do relatorio. . .                            
	If nLin > 60 // Salto de Pgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	EndIf
	
	//Dados a serem impressas 
	@ nLin,000 Psay QUERY->PEDIDO									PICTURE "@"
	@ nLin,008 Psay QUERY->CLIENTE				  					PICTURE "@!"
	@ nLin,017 Psay QUERY->EMISSAO_PV	     						PICTURE "@D!" 
	@ nLin,030 Psay QUERY->PRODUTO									PICTURE "@"
	//@ nLin,027 Psay QUERY->ITEM									PICTURE "@"
	@ nLin,045 Psay QUERY->DESC_PROD	     						PICTURE "@!"
	//@ nLin,050 Psay QUERY->DESC_PROD								PICTURE "@!"PRC_UNIT
	//@ nLin,100 Psay QUERY->PRC_UNIT	      						PICTURE "@E 999,999,999.99"
	//@ nLin,117 Psay QUERY->QTDE									PICTURE "@!"
	//@ nLin,135 Psay SUBSTRING(QUERY->MERCADO,1,3)					PICTURE "@!"
	//@ nLin,135 Psay QUERY->PRODUTO								PICTURE "@"
	@ nLin,175 Psay QUERY->VLR_BRUTO 	      						PICTURE "@E 999,999,999.99"
	//@ nLin,146 Psay QUERY->SERIE									PICTURE "@!"
	//@ nLin,160 Psay QUERY->ITEM									PICTURE "@"
	//@ nLin,183 Psay QUERY->DTENTREGA								PICTURE "@D!"
	//@ nLin,196 Psay SUBSTRING(QUERY->CARACTERISTICA_1,1,15)		PICTURE "@"
	@ nLin,200 Psay QUERY->ARMAZEM									PICTURE "@" 
	@ nLin,211 Psay QUERY->DTENTREGA								PICTURE "@D!"
   //@ nLin,216 Psay SUBSTRING(QUERY->CARACTERISTICA_1,1,15)		PICTURE "@"
   
	nLin++ 
 	cTotal += VLR_BRUTO 
	dbSkip() 
 
EndDo 
 	nLin += 3
   @ nLin,185 Psay "VALOR TOTAL R$ "
	@ nLin,200 Psay  cTotal	      						 		PICTURE "@E 999,999,999.99"
nLin ++

// Finaliza a execucao do relatorio...                                 
SET DEVICE TO SCREEN

// Se impressao em disco, chama o gerenciador de impressao...          
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

If MsgYesNo("Deseja Gera Planilha Excel?")
	GeraExcel()
EndIf

If Select("QUERY") >= 0
	DbCloseArea("QUERY")
EndIf

Return()

Static Function GeraExcel()
Local nLinha		:= 0
Local nColuna		:= 0
Local nHandle		:= 0
Local cArquivo		:= ""
Local cDirDocs  	:= MsDocPath()
Local cBarra 		:= If(issrvunix(), "/", "\")
Local cPath		  	:= AllTrim(GetTempPath())
Local cBuffer		:= ""

//Mesagem se nao tiver excel na maquina
If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")
	Return
EndIf

cArquivo 	:= "Relatorio_Geral.csv"
nHandle 		:= FCreate(cDirDocs + cBarra + cArquivo)

If nHandle == -1
	MsgStop("A planilha nใo pode ser exportada.")
	Return
EndIf
//
//Grava as linhas da planilha                									           
cBuffer := ""
cBuffer	+= ToXlsFormat("TIPO")+";"
cBuffer	+= ToXlsFormat("PEDIDO")+";"
cBuffer	+= ToXlsFormat("CLASSIF_PEDIDO")+";"
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
cBuffer	+= ToXlsFormat("ESTADO")+";"
cBuffer	+= ToXlsFormat("PRODUTO")+";"
cBuffer	+= ToXlsFormat("DESC_PROD")+";"
cBuffer	+= ToXlsFormat("QTDE")+";"
cBuffer	+= ToXlsFormat("PRC_UNIT")+";"
cBuffer	+= ToXlsFormat("VLR_BRUTO")+";"
cBuffer	+= ToXlsFormat("CFOP")+";"
cBuffer	+= ToXlsFormat("ARMAZEM")+";"

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
//
//copia o arquivo do servidor para o remote									   			  
CpyS2T(cDirDocs + cBarra + cArquivo, cPath, .T.)
Ferase(cDirDocs + cBarra + cArquivo)
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cPath+cArquivo)
oExcelApp:SetVisible(.T.)

Return()