#INCLUDE "rwmake.ch"
#include "TBICONN.CH"
#include "TBICODE.CH"
#include "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATR013	º Autor ³ Claudio Ferreira   º Data ³  10/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Notas a Classificar                   		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATR013()                                        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString
aOrd := {}
Private CbTxt        	:= ""
cDesc1         			:= "Este programa tem como objetivo imprimir relatorio "
cDesc2         			:= "de acordo com os parametros informados pelo usuario."
cDesc3         			:= "Relatorio de Notas a Classificar"
cPict          			:= " "
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private limite       	:= 220
Private tamanho      	:= "G"
Private nomeprog     	:= "RFATR013" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        	:= 15
Private aReturn      	:= { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
Private nLastKey     	:= 0
titulo         			:= "Relatorio de Notas a Classificar "
nLin           			:= 80
Private cbtxt        	:= Space(10)
Private cbcont       	:= 00
Private CONTFL       	:= 01
Private m_pag        	:= 01
imprime        			:= .T.
Private wnrel        	:= "RFATR013" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "SZO"
aRegs   				:= {}
cPerg   				:= "FATR013"
IsDev 					:= .F.
aExcel 					:= {}

Aadd(aRegs,{cPerg,"01","Emissao De         ?","","","mv_ch1","D",08,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Emissao Ate        ?","","","mv_ch2","D",08,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Nome do Arquivo    ?","","","mv_ch3","C",20,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,cPerg)

Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec2	:=""
Cabec1	:=""

wnrel		:= SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)
titulo	:= "Relatorio de Notas a Classificar "
Cabec1  := " NFEID                                             NOTA       SERIE     CNPJ               CLI_FOR                                       EMISSAO  "
               
//           XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                      				       DD/MM/AAAA 
//           01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           0         1         2         3         4         5         6         7         8         9        10        11        12        13               
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
aAdd(aStru,{"DOCUM"					,"C",30,0})
aAdd(aStru,{"NFEID"					,"C",50,0})
aAdd(aStru,{"NOTA"   	   		,"C",11,0})
aAdd(aStru,{"SERIE" 	  				,"C",03,0})
aAdd(aStru,{"CNPJ"					,"C",14,0})
aAdd(aStru,{"CLI_FOR"				,"C",40,0})
aAdd(aStru,{"EMISSAO"				,"D",08,0})

cQuery := " SELECT ZO_DOC+ZO_SERIE+ZO_CGC AS DOCUM,ZO_NFEID AS NFEID,ZO_DOC AS NOTA,ZO_SERIE AS SERIE,A2_CGC AS CNPJ, SUBSTRING(A2_NOME,1,40) AS CLI_FOR,ZO_EMISSAO AS EMISSAO"
cQuery += " FROM "  
cQuery += RetSqlName("SZO")+" ZO "
cQuery += " JOIN " + RetSqlName("SA2")+" A2 ON ZO.ZO_FORNEC=A2.A2_COD AND ZO.ZO_LOJA=A2.A2_LOJA "   
cQuery += " WHERE NOT EXISTS ( SELECT F1.F1_DOC,F1.F1_SERIE,F1.F1_FORNECE,F1.F1_LOJA FROM SF1010 F1 WHERE F1.F1_DOC = ZO.ZO_DOC "
cQuery += " AND F1.F1_SERIE = ZO.ZO_SERIE AND F1.F1_FORNECE = ZO.ZO_FORNEC AND F1.F1_LOJA = ZO.ZO_LOJA )  " 
cQuery += " AND ZO.ZO_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "  
cQuery += " AND ZO.D_E_L_E_T_='' AND A2.D_E_L_E_T_='' " 
/*
cQuery += " AND ZO_DOC+ZO_SERIE+ZO_CGC NOT IN ( SELECT F1_DOC+F1_SERIE+A2_CGC " 
cQuery += " FROM " 
cQuery += RetSqlName("SF1")+" SF1 " 
cQuery += " JOIN " + RetSqlName("SA2")+" SA2 ON F1_FORNECE=A2_COD AND F1_LOJA=A2_LOJA "
cQuery += " WHERE F1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND F1_FORNECE<>'003385' " 
cQuery += " SF1.D_E_L_E_T_='' AND SA2.D_E_L_E_T_='' AND F1_EST <>'EX') "
*/
cQuery := ChangeQuery(cQuery)
MEMOWRIT( "RFATR013.SQL", cQuery )

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)


For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('QUERY', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next

DbSelectArea("QUERY")
DbGoTop()
While !Eof()
	
	Aadd(aExcel, {QUERY->NFEID,QUERY->NOTA,QUERY->SERIE,QUERY->CNPJ,QUERY->CLI_FOR,QUERY->EMISSAO})
	
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
	
	//@ nLin,000 Psay QUERY->DOCUM				PICTURE "@"
	@ nLin,000 Psay QUERY->NFEID				PICTURE "@!"
	@ nLin,050 Psay QUERY->NOTA     			PICTURE "@!"
	@ nLin,062 Psay QUERY->SERIE     		PICTURE "@!"
	@ nLin,072 Psay QUERY->CNPJ   	      PICTURE "@!"
	@ nLin,091 Psay QUERY->CLI_FOR    		PICTURE "@!"
	@ nLin,137 Psay QUERY->EMISSAO			PICTURE "@D!"
	
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
Local nColuna	    := 0
Local nLinha        := 0

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")
	Return
EndIf

cArquivo 	:= "Rel_Notas a Classificar.csv"
nHandle 		:= FCreate(cDirDocs + cBarra + cArquivo)

If nHandle == -1
	MsgStop("A planilha não pode ser exportada.")
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava as linhas da planilha                									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cBuffer := ""
cBuffer	+= ToXlsFormat("NFEID")+";"
cBuffer	+= ToXlsFormat("NOTA")+";"
cBuffer	+= ToXlsFormat("SERIE")+";"
cBuffer	+= ToXlsFormat("CNPJ")+";"
cBuffer	+= ToXlsFormat("CLI_FOR")+";"
cBuffer	+= ToXlsFormat("EMISSAO")+";"

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