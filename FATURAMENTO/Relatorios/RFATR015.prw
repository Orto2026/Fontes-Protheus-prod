#INCLUDE "rwmake.ch"
#include "TBICONN.CH"
#include "TBICODE.CH"
#include "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"  

/*/

Programa   RFATR012	 Autor  Claudio Ferreira    Data   20/01/15   

Descricao  Relatorio de Faturamento Geral / Analitico          		  

Uso        Especifico Ortosintese                                     

/*/
User Function RFATR015()                                        

//
// Declaracao de Variaveis                                             
//

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
Private nomeprog     	:= "RFATR015" // Coloque aqui o nome do programa para impressao no cabecalho
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
Private wnrel        	:= "RFATR015" // Coloque aqui o nome do arquivo usado para impressao em disco
//Private cString 		:= "SD2" 
Private cTotal				:= 0 
Private cCodUser    		:= RetCodUsr()
Private cNamUser 			:= UsrRetName( cCodUser )//Retorna o nome do us
aRegs   			  			:= {}
cPerg   						:= "RFATR015"
IsDev 				  		:= .F.
aExcel 						:= {}

Aadd(aRegs,{cPerg,"01","Emissao De         ?","","","mv_ch1","D",08,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Emissao Ate        ?","","","mv_ch2","D",08,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Produto De         ?","","","mv_ch3","C",15,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
Aadd(aRegs,{cPerg,"04","Produto Ate        ?","","","mv_ch4","C",15,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
//Aadd(aRegs,{cPerg,"05","Nome do Arquivo    ?","","","mv_ch5","C",20,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"06","Vendedor De         ?","","","mv_ch6","C",06,0,0,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
//Aadd(aRegs,{cPerg,"07","Vendedor Ate        ?","","","mv_ch7","C",06,0,0,"G","","Mv_Par07","","","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
Aadd(aRegs,{cPerg,"05","Cliente De          ?","","","mv_ch5","C",06,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","","CLI",""})
Aadd(aRegs,{cPerg,"06","Cliente Ate         ?","","","mv_ch6","C",06,0,0,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","","","CLI",""})
//Aadd(aRegs,{cPerg,"10","Mercado            ?","","","mv_chA","C",02,0,0,"G","","Mv_Par7","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"11","Estado Ate          ?","","","mv_chB","C",02,0,0,"G","","Mv_Par11","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"12","TES Qto Financeiro  ?","","","mv_chC","N",01,0,3,"C","","Mv_Par12","Gera","Gera","Gera","","","Nao Gera","Nao Gera","Nao Gera","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"13","TES Qto Financeiro  ?","","","mv_chD","N",01,0,3,"C","","Mv_Par13","Movimenta","Movimenta","Movimenta","","","No Movimenta","No Movimenta","No Movimenta","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"14","Cosidera Devolucoes  ?","","","mv_chE","N",01,0,1,"C","","Mv_Par14","Sim","Si","Yes","","","No","No","No","","","","","","","","","","","","","","","","","","","",""})


ValidPerg(aRegs,cPerg)

Pergunte(cPerg,.F.)
//
// Monta a interface padrao com o usuario...                           
//
Cabec2	:=""
Cabec1	:=""

wnrel		:= SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)
titulo	:= "Relatorio de Vendas       Emitido Por: "+cNamUser+""
Cabec1  := "Pedido  Cliente             Emissao     Produto  Descricao                                               Valor      Classif_Pedido    Unidade    Segmento       Classe                  Sistema           Materia_Prima   "
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

/*/



//Funo    RUNREPORT  Autor  AP5 IDE             Data   30/09/02   

//Descrio  Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS 
      //     monta a janela com a regua de processamento.               

//Uso        Programa principal                                         



/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local ni

aStru := {}
aAdd(aStru,{"PEDIDO"		    			,"C",06,0}) //01 
aAdd(aStru,{"CODCLI"		    			,"C",06,0}) //01
aAdd(aStru,{"CLIENTE"					,"C",08,0}) //02
aAdd(aStru,{"EMISSAO"   				,"D",08,0}) //03
aAdd(aStru,{"PRODUTO"					,"C",15,0}) //04
aAdd(aStru,{"DESCRICAO"					,"C",60,0}) //05
aAdd(aStru,{"VALOR"						,"N",11,2}) //06
aAdd(aStru,{"CLASSIF_PEDIDO"			,"C",50,0}) //07
aAdd(aStru,{"MERCADO"					,"C",40,0}) //08
aAdd(aStru,{"UNIDADE"					,"C",60,0}) //09
aAdd(aStru,{"SEGMENTO"					,"C",80,0}) //10
aAdd(aStru,{"CLASSE"			 			,"C",120,0}) //11
aAdd(aStru,{"SISTEMA"					,"C",140,0}) //12
aAdd(aStru,{"CARACTERISTICA_1"		,"C",160,0}) //13
aAdd(aStru,{"MATEIRA_PRIMA"			,"C",180,0}) //14
aAdd(aStru,{"CARACTERISTICA_2"		,"C",200,0}) //15

cQuery :="SELECT"+CHR(13)+CHR(10)
cQuery +=	"C5_NUM AS PEDIDO,"+CHR(13)+CHR(10)
cQuery +=	"A1_COD AS CODCLI,"+CHR(13)+CHR(10)
cQuery +=	"A1_NREDUZ AS CLIENTE,"+CHR(13)+CHR(10)
cQuery +=	"C5_EMISSAO AS EMISSAO,"+CHR(13)+CHR(10)
cQuery +=	"C6_PRODUTO AS PRODUTO,"+CHR(13)+CHR(10)
cQuery +=	"B1_DESC AS DESCRICAO,"+CHR(13)+CHR(10)
cQuery +=	"C6_VALOR AS VALOR,"+CHR(13)+CHR(10)
cQuery +="CASE  WHEN C5_CLASPED = '1' THEN 'MERCADO INTERNO'"+CHR(13)+CHR(10)
cQuery +=	"WHEN C5_CLASPED = '2' THEN 'CAIXAS'"+CHR(13)+CHR(10)
cQuery +=	"WHEN C5_CLASPED = '3' THEN 'EQUIPAMENTOS'" +CHR(13)+CHR(10)
cQuery +=	"WHEN C5_CLASPED = '4' THEN 'EXPORTACAO'"+CHR(13)+CHR(10)
cQuery +=	"WHEN C5_CLASPED = '5' THEN 'DIVERSOS'"+CHR(13)+CHR(10)
cQuery +=	"WHEN C5_CLASPED = '6' THEN 'PECAS EQUIPAMENTOS'"+CHR(13)+CHR(10)
cQuery +=	"ELSE 'OUTROS' END AS CLASSIFICAO_PEDIDO,"+CHR(13)+CHR(10)
cQuery +=	"CASE WHEN A1_EST = 'EX' THEN 'EXTERNO'"+CHR(13)+CHR(10)
cQuery +=	"ELSE 'INTERNO' END AS MERCADO,"+CHR(13)+CHR(10)
cQuery +=	"SZA.ZA_DESC AS UNIDADE,"+CHR(13)+CHR(10)  
cQuery +=	"SZB.ZB_DESC AS SEGMENTO,"+CHR(13)+CHR(10)    
cQuery +=	"SZC.ZC_DESC AS CLASSE," +CHR(13)+CHR(10)    
cQuery +=	"SZD.ZD_DESC AS SISTEMA,"+CHR(13)+CHR(10)     
cQuery +=	"SZE.ZE_DESC AS CARACTERISTICA_1," +CHR(13)+CHR(10)    
cQuery +=	"SZF.ZF_DESC AS MATERIA_PRIMA, " +CHR(13)+CHR(10)  
cQuery +=	"SZG.ZG_DESC AS CARACTERISTICA_2"+CHR(13)+CHR(10)
cQuery +="FROM"+CHR(13)+CHR(10) // SC6010 SC6 "  
cQuery += 	RetSqlName( 'SC6' ) + " SC6 "+CHR(13)+CHR(10)
cQuery +=	"INNER JOIN " + RetSqlName("SC5") + " SC5 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM"+CHR(13)+CHR(10)
cQuery +=	"INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_FILIAL ='' AND A1_COD = C5_CLIENTE AND A1_LOJA = SC5.C5_LOJACLI"+CHR(13)+CHR(10)
cQuery +=	"INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL ='' AND C6_PRODUTO = B1_COD"+CHR(13)+CHR(10)
cQuery +=	"INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL ='' AND F4_CODIGO = C6_TES"+CHR(13)+CHR(10)
cQuery +=	"LEFT JOIN " + RetSqlName("SZA") + " SZA ON B1_XUNIDAD = ZA_COD"+CHR(13)+CHR(10)
cQuery +=	"LEFT JOIN " + RetSqlName("SZB") + " SZB ON B1_XSEGMEN = ZB_COD"+CHR(13)+CHR(10)
cQuery +=	"LEFT JOIN " + RetSqlName("SZC") + " SZC ON B1_XCLASSE = ZC_COD"+CHR(13)+CHR(10)
cQuery +=	"LEFT JOIN " + RetSqlName("SZD") + " SZD ON B1_XSISTEM = ZD_COD"+CHR(13)+CHR(10)
cQuery +=	"LEFT JOIN " + RetSqlName("SZE") + " SZE ON B1_XCARAC1 = ZE_COD"+CHR(13)+CHR(10)
cQuery +=	"LEFT JOIN " + RetSqlName("SZF") + " SZF ON B1_XMP = ZF_COD"+CHR(13)+CHR(10)
cQuery +=	"LEFT JOIN " + RetSqlName("SZG") + " SZG ON B1_XCARAC2 = ZG_COD"+CHR(13)+CHR(10)
cQuery +="WHERE SC6.C6_FILIAL ='01' AND"+CHR(13)+CHR(10)
cQuery +=	"SC6.D_E_L_E_T_ ='' AND"+CHR(13)+CHR(10)
cQuery +=	"SC5.D_E_L_E_T_ ='' AND"+CHR(13)+CHR(10)
cQuery +=	"SA1.D_E_L_E_T_ ='' AND"+CHR(13)+CHR(10)
cQuery +=	"SB1.D_E_L_E_T_ ='' AND"+CHR(13)+CHR(10)
cQuery +=	"SF4.D_E_L_E_T_ ='' AND"+CHR(13)+CHR(10)
cQuery +=	"SZA.D_E_L_E_T_ ='' AND"+CHR(13)+CHR(10)
cQuery +=	"SZB.D_E_L_E_T_ ='' AND"+CHR(13)+CHR(10)
cQuery +=	"SZC.D_E_L_E_T_ ='' AND"+CHR(13)+CHR(10)
cQuery +=	"SZD.D_E_L_E_T_ ='' AND"+CHR(13)+CHR(10)
cQuery +=	"SZE.D_E_L_E_T_ ='' AND"+CHR(13)+CHR(10)
cQuery +=	"SZF.D_E_L_E_T_ ='' AND"+CHR(13)+CHR(10)
cQuery +=	"SZG.D_E_L_E_T_ ='' AND"+CHR(13)+CHR(10)
cQuery +=	"C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND"+CHR(13)+CHR(10) 
cQuery +=	"C6_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND"+CHR(13)+CHR(10)
cQuery +=	"A1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND"+CHR(13)+CHR(10)
//cQuery +=	"C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND"+CHR(13)+CHR(10)
//cQuery +=	"C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND"+CHR(13)+CHR(10)
//cQuery +=	"C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND"+CHR(13)+CHR(10)
//cQuery +=	"C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND"+CHR(13)+CHR(10)
//cQuery +=	"C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND"+CHR(13)+CHR(10)
//cQuery +=	"C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND"+CHR(13)+CHR(10)
cQuery +=	"F4_DUPLIC ='S'"+CHR(13)+CHR(10)

cQuery := ChangeQuery(cQuery)
MEMOWRIT( "RFATR015.SQL", cQuery )  

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
	
	//Aadd(aExcel, {QUERY->PEDIDO,QUERY->CLIENTE,QUERY->EMISSAO,QUERY->PRODUTO,QUERY->DESCRICAO,QUERY->VALOR,QUERY->CLASSIFICAO_PEDIDO,QUERY->MERCADO,QUERY->UNIDADE,QUERY->SEGMENTO,QUERY->CLASSE,QUERY->SISTEMA,QUERY->CARACTERISTICA_1,QUERY->MATERIA_PRIMA,QUERY->CARACTERISTICA_2}) 
	
  //	Aadd(aExcel,{QUERY->PEDIDO,QUERY->CLIENTE,QUERY->EMISSAO,QUERY->PRODUTO,QUERY->DESCRICAO,QUERY->VALOR,QUERY->CLASSIFICAO_PEDIDO,QUERY->MERCADO,QUERY->UNIDADE,QUERY->SEGMENTO,QUERY->CLASSE,QUERY->SISTEMA,QUERY->CARACTERISTICA_1,QUERY->MATERIA_PRIMA,QUERY->CARACTERISTICA_2})
	
  	Aadd(aExcel,{QUERY->PEDIDO,QUERY->CLIENTE,QUERY->EMISSAO,QUERY->PRODUTO,QUERY->DESCRICAO,QUERY->VALOR,QUERY->CLASSIFICAO_PEDIDO,QUERY->MERCADO,QUERY->UNIDADE,QUERY->SEGMENTO,QUERY->CLASSE,QUERY->SISTEMA,QUERY->CARACTERISTICA_1,QUERY->MATERIA_PRIMA,QUERY->CARACTERISTICA_2})
	
	//
	// Verifica o cancelamento pelo usuario...                             
	//
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//
	// Impressao do cabecalho do relatorio. . .                            
	//
	
	If nLin > 60 // Salto de Pgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	EndIf
	
	@ nLin,000 Psay QUERY->PEDIDO											PICTURE "@"
	@ nLin,008 Psay QUERY->CLIENTE				  						PICTURE "@!"
	@ nLin,028 Psay QUERY->EMISSAO	     								PICTURE "@D!"
	@ nLin,040 Psay QUERY->PRODUTO	     								PICTURE "@!"
	@ nLin,050 Psay QUERY->DESCRICAO								 		PICTURE "@!"
	@ nLin,100 Psay QUERY->VALOR	      						 		PICTURE "@E 999,999,999.99"
	@ nLin,117 Psay QUERY->CLASSIFICAO_PEDID					 		PICTURE "@!"
	//@ nLin,135 Psay SUBSTRING(QUERY->MERCADO,1,3)					PICTURE "@!"
	@ nLin,135 Psay SUBSTRING(QUERY->UNIDADE,1,5)					PICTURE "@"
	@ nLin,146 Psay SUBSTRING(QUERY->SEGMENTO	,1,15)				PICTURE "@!"
	@ nLin,160 Psay SUBSTRING(QUERY->CLASSE,1,15)					PICTURE "@"
	@ nLin,183 Psay SUBSTRING(QUERY->SISTEMA,1,15)						PICTURE "@!"
	//@ nLin,196 Psay SUBSTRING(QUERY->CARACTERISTICA_1,1,15)		PICTURE "@"
	@ nLin,200 Psay SUBSTRING(QUERY->MATERIA_PRIMA,1,15)			PICTURE "@"
   //@ nLin,216 Psay SUBSTRING(QUERY->CARACTERISTICA_1,1,15)		PICTURE "@"


	nLin++ 
 	cTotal += VALOR 
	dbSkip() 
 

EndDo 
 	nLin += 3
   @ nLin,185 Psay "VALOR TOTAL R$ "
	@ nLin,200 Psay  cTotal	      						 		PICTURE "@E 999,999,999.99"
nLin ++


//
// Finaliza a execucao do relatorio...                                 
//

SET DEVICE TO SCREEN

//
// Se impressao em disco, chama o gerenciador de impressao...          
//

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
Local nLinha		:= 0
Local nColuna		:= 0
Local nHandle		:= 0
Local cArquivo		:= ""
Local cDirDocs  	:= MsDocPath()
Local cBarra 		:= If(issrvunix(), "/", "\")
Local cPath		  	:= AllTrim(GetTempPath())
Local cBuffer		:= ""

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")
	Return
EndIf

cArquivo 	:= "Relatorio_Vendas.csv"
nHandle 		:= FCreate(cDirDocs + cBarra + cArquivo)

If nHandle == -1
	MsgStop("A planilha no pode ser exportada.")
	Return
EndIf

//
//Grava as linhas da planilha                									           
//

cBuffer := ""
cBuffer	+= ToXlsFormat("PEDIDO")+";"
cBuffer	+= ToXlsFormat("CLIENTE")+";"
cBuffer	+= ToXlsFormat("EMISSAO")+";"
cBuffer	+= ToXlsFormat("PRODUTO")+";"
cBuffer	+= ToXlsFormat("DESCRICAO")+";"
cBuffer	+= ToXlsFormat("VALOR")+";"
cBuffer	+= ToXlsFormat("CLASSIFICAO_PEDID")+";"
cBuffer	+= ToXlsFormat("MERCADO")+";"
cBuffer	+= ToXlsFormat("UNIDADE")+";"
cBuffer	+= ToXlsFormat("SEGMENTO")+";"
cBuffer	+= ToXlsFormat("CLASSE")+";"
cBuffer	+= ToXlsFormat("SISTEMA")+";"
cBuffer	+= ToXlsFormat("CARACTERISTICA_1")+";"
cBuffer	+= ToXlsFormat("MATERIA_PRIMA")+";"
cBuffer	+= ToXlsFormat("CARACTERISTICA_2")+";"


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
//

CpyS2T(cDirDocs + cBarra + cArquivo, cPath, .T.)
Ferase(cDirDocs + cBarra + cArquivo)
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cPath+cArquivo)
oExcelApp:SetVisible(.T.)

Return()