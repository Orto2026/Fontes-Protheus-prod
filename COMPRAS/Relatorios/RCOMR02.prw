#INCLUDE "rwmake.ch"
#include "TBICONN.CH"
#include "TBICODE.CH"
#include "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCOMR02	º Autor ³ Claudio Ferreira   º Data ³  03/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Solicitacao de Compras              		     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico ORTOSINTESE                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCOMR02()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString
aOrd := {}
Private CbTxt        	:= ""
cDesc1         			:= "Este programa tem como objetivo imprimir relatorio "
cDesc2         			:= "de acordo com os parametros informados pelo usuario."
cDesc3         			:= "Relatorio de Solicitacao de Compras"
cPict          			:= " "
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private limite       	:= 220
Private tamanho      	:= "G"
Private nomeprog     	:= "RCOMR02" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        	:= 15
Private aReturn      	:= { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
Private nLastKey     	:= 0
titulo         			:= "Relatorio de Solicitacao de Compras "
nLin           			:= 80
Private cbtxt        	:= Space(10)
Private cbcont       	:= 00
Private CONTFL       	:= 01
Private m_pag        	:= 01
imprime        			:= .T.
Private wnrel        	:= "RCOMR02" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "SC1"
aRegs   				:= {}
cPerg   				:= "RCOMR02"
IsDev 					:= .F. 
aExcel 					:= {}

Aadd(aRegs,{cPerg,"01","Data Inicial       ?","","","mv_ch1","D",08,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data Final         ?","","","mv_ch2","D",08,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
Aadd(aRegs,{cPerg,"03","Solicitacao De     ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","   ","   ","   ","","","   ","   ","   ","","","      ","    ","     ","","","","","","","","","","","","SC1","",})
Aadd(aRegs,{cPerg,"04","Solicitacao Ate    ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","   ","   ","   ","","","   ","   ","   ","","","      ","    ","     ","","","","","","","","","","","","SC1","",})
Aadd(aRegs,{cPerg,"05","Cod Comprador De   ?","","","mv_ch5","C",03,0,0,"G","","mv_par05","   ","   ","   ","","","   ","   ","   ","","","      ","    ","     ","","","","","","","","","","","","SY1","",})
Aadd(aRegs,{cPerg,"06","Cod Comprador Ate  ?","","","mv_ch6","C",03,0,0,"G","","mv_par06","   ","   ","   ","","","   ","   ","   ","","","      ","    ","     ","","","","","","","","","","","","SY1","",})
//Aadd(aRegs,{cPerg,"05","Nome do Arquivo    ?","","","mv_ch5","C",20,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,cPerg)

Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec2	:=""
Cabec1  :="" 

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

titulo         := "Solicitacao de Compras "+Mv_par03+" Ate "+Mv_Par04

Cabec1 := "Emissao     Numero Produto         Descricao                                                              Qtde          UM Armaz Previsao     Observacao                                     Solicitante     Comprador"
    //     99/99/99 123456 123456789012345 12345678901234567890123456789012345678901234567890123467890 999.999.999,99 12 12    99/99/99   1234567890123456789012345678901234567890 1232456789012345 
	//     123456789100123415678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789      7    15       23                                              65        74               90               106        116 
	//     10     15               31                                                          91            105108   113        126                                      166
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
aAdd(aStru,{"EMISSAO"					,"D",08,0})
aAdd(aStru,{"NUMERO"						,"C",06,0}) 
aAdd(aStru,{"PRODUTO"  			  	   ,"C",15,0})
aAdd(aStru,{"DESCRI"						,"C",60,0})
aAdd(aStru,{"QUANT"						,"N",15,2})
aAdd(aStru,{"UM"		 		 	 		,"C",02,0})
aAdd(aStru,{"ARMAZ"						,"C",02,0})
aAdd(aStru,{"DATPRF"						,"D",08,0})
aAdd(aStru,{"OBSERV"						,"C",30,0})
aAdd(aStru,{"SOLICIT"					,"C",15,0})
aAdd(aStru,{"CODCOMP"					,"C",03,0})
aAdd(aStru,{"NOMECOMP"					,"C",50,0})

cQuery := " SELECT "
cQuery += " C1_EMISSAO EMISSAO, C1_NUM NUMERO, C1_PRODUTO PRODUTO, C1_DESCRI DESCRI, C1_QUANT QUANT, C1_UM UM, C1_LOCAL ARMAZ, "
cQuery += " C1_DATPRF DATPRF, C1_OBS OBSERV, C1_SOLICIT SOLICIT , C1_CODCOMP CODCOMP, Y1_NOME NOMECOMP" 
cQuery += " FROM "
cQuery += RetSqlName("SC1")+" SC1 "
cQuery += " INNER JOIN " + RetSqlName("SY1") + " SY1 ON Y1_FILIAL = '"+xFilial("SY1")+"' AND Y1_COD = C1_CODCOMP AND SY1.D_E_L_E_T_ = '' "
cQuery += " WHERE "
cQuery += " C1_EMISSAO BETWEEN '"+Dtos(Mv_Par01)+"' AND '"+Dtos(MV_PAR02)+"' "
cQuery += " AND C1_NUM BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04  + "' "
cQuery += " AND C1_CODCOMP BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06  + "' "
cQuery += " AND SC1.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)

MEMOWRIT( "RCOMR02.SQL", cQuery )

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
While !EOF()

aAdd(aStru,{"EMISSAO"					,"D",08,0})
aAdd(aStru,{"NUMERO"						,"C",06,0}) 
aAdd(aStru,{"PRODUTO"  			  	   ,"C",15,0})
aAdd(aStru,{"DESCRI"						,"C",60,0})
aAdd(aStru,{"QUANT"						,"N",15,2})
aAdd(aStru,{"UM"		 		 	 		,"C",02,0})
aAdd(aStru,{"ARMAZ"						,"C",02,0})
aAdd(aStru,{"DATPRF"						,"D",08,0})
aAdd(aStru,{"OBSERV"						,"C",30,0})
aAdd(aStru,{"SOLICIT"					,"C",15,0})
aAdd(aStru,{"CODCOMP"					,"C",03,0})
aAdd(aStru,{"NOMECOMP"					,"C",50,0})
 

  		Aadd(aExcel, {QUERY->EMISSAO,QUERY->NUMERO,QUERY->PRODUTO,QUERY->DESCRI,QUERY->QUANT,QUERY->UM,QUERY->ARMAZ,QUERY->DATPRF,;
  		QUERY->OBSERV,QUERY->SOLICIT,QUERY->CODCOMP,QUERY->NOMECOMP})
  		
  	
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
  		
		@ nLin,000 Psay QUERY->EMISSAO	    	PICTURE "@D!"
		@ nLin,012 Psay QUERY->NUMERO		    	PICTURE "@!"
		@ nLin,019 Psay QUERY->PRODUTO      	PICTURE "@!"
		@ nLin,034 Psay QUERY->DESCRI       	PICTURE "@!"
		@ nLin,096 Psay QUERY->QUANT      		PICTURE "@E 999,999,999.99"
		@ nLin,120 Psay QUERY->UM					PICTURE "@!"
		@ nLin,124 Psay QUERY->ARMAZ    			PICTURE "@!"
		@ nLin,129 Psay QUERY->DATPRF				PICTURE "@D!"
		@ nLin,142 Psay QUERY->OBSERV   			PICTURE "@!"
		@ nLin,190 Psay QUERY->SOLICIT   		PICTURE "@!"
		@ nLin,206 Psay QUERY->NOMECOMP   		PICTURE "@!"
		
		
		_nTot1 += QUERY->QUANT
		
	nLin++	
	dbSkip()
EndDo

nLin ++

@ nLin, 000 PSAY "Total Geral "

	@ nLin, 096 PSAY _nTot1 			PICTURE "@E 999,999,999.99"
	

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

//If MsgYesNo("Gera Planilha Excel?")
//	GeraExcel()
//EndIf 

//If Select("QUERY") >= 0 
//	DbCloseArea("QUERY")
//EndIf  

Return(Nil)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna ambiente original³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//DbSelectArea(cLAlias)

//Return(Nil)

//Static Function GeraExcel()

//Local nHandle		:= 0
//Local cArquivo		:= ""
//Local cDirDocs  	:= MsDocPath()
//Local cBarra 		:= If(issrvunix(), "/", "\")
//Local cPath		  	:= AllTrim(GetTempPath())
//Local cBuffer		:= ""

//If !ApOleClient("MsExcel")
//	MsgStop("Microsoft Excel nao instalado.")
//	Return
//EndIf
   
	//cArquivo 	:= +MV_PAR05+".CSV" //"Rel_Fatur_X_Receb.csv"   
	//nHandle 		:= FCreate(cDirDocs + cBarra + cArquivo)

//If nHandle == -1
//	MsgStop("A planilha não pode ser exportada.")
//	Return
//EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava as linhas da planilha                									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//cBuffer := ""
//cBuffer	+= ToXlsFormat("EMISSAO")+";"
//cBuffer	+= ToXlsFormat("NUMERO")+";"
//cBuffer	+= ToXlsFormat("PRODUTO")+";"
//cBuffer	+= ToXlsFormat("DESCRI")+";"
//cBuffer	+= ToXlsFormat("QUANT")+";"
//cBuffer	+= ToXlsFormat("UM")+";"
//cBuffer	+= ToXlsFormat("ARMAZ")+";"
//cBuffer	+= ToXlsFormat("DATPRF")+";"
//cBuffer	+= ToXlsFormat("OBSERV")+";"
//cBuffer	+= ToXlsFormat("SOLICIT")+";"

//FWrite(nHandle, cBuffer)
//FWrite(nHandle, CRLF)

//cBuffer 	:= ""

//ProcRegua(Len(aExcel))

//For nLinha := 1 to Len(aExcel)

//	IncProc("Gerando excel... ")

//	For nColuna := 1 to Len(aExcel[nLinha])
//		If Valtype(aExcel[nLinha,nColuna]) <> "C"
//			cBuffer += ToXlsFormat(aExcel[nLinha,nColuna])+";"
//		Else
//			cBuffer += ToXlsFormat("'"+aExcel[nLinha,nColuna])+";"
//		EndIf
//	Next nColuna
//	FWrite(nHandle, cBuffer)
//	FWrite(nHandle, CRLF)
//	cBuffer:=""
//Next nLinha

//FClose(nHandle)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³copia o arquivo do servidor para o remote									   			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	CpyS2T(cDirDocs + cBarra + cArquivo, cPath, .T.)
//	Ferase(cDirDocs + cBarra + cArquivo)
//	oExcelApp := MsExcel():New()
//	oExcelApp:WorkBooks:Open(cPath+cArquivo)
//	oExcelApp:SetVisible(.T.)

Return()