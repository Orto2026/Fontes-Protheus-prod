#INCLUDE "rwmake.ch"
#include "TBICONN.CH"
#include "TBICODE.CH"
#include "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATR04	º Autor ³ Claudio Ferreira   º Data ³  02/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Conferencia de Frete						  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATR04()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString
aOrd := {}
Private CbTxt        	:= ""
cDesc1         			:= "Este programa tem como objetivo imprimir relatorio "
cDesc2         			:= "de acordo com os parametros informados pelo usuario."
cDesc3         			:= "Relatorio de Conferencia de Frete"
cPict          			:= " "
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private limite       	:= 220
Private tamanho      	:= "G"
Private nomeprog     	:= "RFATR04" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        	:= 15
Private aReturn      	:= { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
Private nLastKey     	:= 0
titulo         			:= "Relatorio de Conferencia de Frete "
nLin           			:= 80
Private cbtxt        	:= Space(10)
Private cbcont       	:= 00
Private CONTFL       	:= 01
Private m_pag        	:= 01
imprime        			:= .T.
Private wnrel        	:= "RFATR04" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "SF2"
aRegs   				:= {}
cPerg   				:= "RFATR04"
IsDev 					:= .F. 
aExcel 					:= {}

Aadd(aRegs,{cPerg,"01","Cliente De  ?","","","mv_ch1","C",06,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Cliente Ate ?","","","mv_ch2","C",06,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Emissao De  ?","","","mv_ch3","D",08,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Emissao Ate ?","","","mv_ch4","D",08,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Nome do Arquivo    ?","","","mv_ch5","C",20,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,cPerg)

Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec2	:=""
Cabec1  :="" 

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

titulo         := "Conferencia de Frete Periodo de "+Dtoc(Mv_par03)+" Ate "+Dtoc(Mv_Par04)

	Cabec1  := " Nota	          Serie  Emissao	        Cliente	   Nome	   							     				                                                                   Frete"
    //          XXXXXXXXXXXXXXXXXXXXXXDD/MM/AAAAXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX999,999,999.99       
    //          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
    //          0         1         2         3         4         5         6         7         8         9
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
Local ni := 0
aStru := {}
aAdd(aStru,{"NOTA"		  		,"C",09,0})
aAdd(aStru,{"SERIE"				,"C",03,0}) 
aAdd(aStru,{"EMISSAO"			,"D",08,0})
aAdd(aStru,{"CLIENTE"	  		,"C",06,0})
aAdd(aStru,{"NOME"		  		,"C",40,0})
aAdd(aStru,{"FRETE"		  		,"N",15,2}) 

cQuery := "SELECT  "
cQuery += " F2_DOC NOTA ,F2_SERIE SERIE,F2_EMISSAO EMISSAO,F2_CLIENTE CLIENTE, A1_NOME NOME,F2_FRETE FRETE  "
cQuery += " FROM " 
cQuery += RetSqlName( 'SF2' ) + " SF2 "
cQuery += " INNER JOIN SA1010 SA1 ON A1_FILIAL = '"+xFilial("SA1")+"'  AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND SA1.D_E_L_E_T_ = '' "   
cQuery += " WHERE " 
cQuery += "  F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery += " AND F2_CLIENTE BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02  + "' "
cQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'  "  
cQuery += " AND F2_FRETE <> 0 AND SF2.D_E_L_E_T_ = '' "
cQuery += " ORDER BY F2_CLIENTE " 

cQuery := ChangeQuery(cQuery)
MEMOWRIT( "RFATR04.SQL", cQuery )

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)

_nTotal := 0

For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('QUERY', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next                            


DbSelectArea("QUERY")
DbGoTop()
While !EOF()

aAdd(aStru,{"NOTA"		  		,"C",09,0})
aAdd(aStru,{"SERIE"				,"C",03,0}) 
aAdd(aStru,{"EMISSAO"			,"D",08,0})
aAdd(aStru,{"CLIENTE"	  		,"C",06,0})
aAdd(aStru,{"NOME"		  		,"C",40,0})
aAdd(aStru,{"FRETE"		  		,"N",15,2})  

  		Aadd(aExcel, {QUERY->NOTA,QUERY->SERIE,QUERY->EMISSAO,QUERY->CLIENTE,QUERY->NOME,QUERY->FRETE})
  		
  	
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
	
		@ nLin,001 Psay QUERY->NOTA		    	PICTURE "@"
		@ nLin,015 Psay QUERY->SERIE		    PICTURE "@!"
		@ nLin,022 Psay QUERY->EMISSAO     		PICTURE "D!"
		@ nLin,037 Psay QUERY->CLIENTE	     	PICTURE "@!"
		@ nLin,047 Psay QUERY->NOME 		    PICTURE "@!"
		@ nLin,120 Psay QUERY->FRETE			PICTURE "@E 999,999,999.99"
		
		_nTotal += QUERY->FRETE	
			
	nLin++

	dbSkip()
EndDo

nLin ++
@ nLin,000 Psay "Total Geral " 
@ nLin,120 Psay 	_nTotal				PICTURE "@E 999,999,999.99"

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

Return(Nil)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna ambiente original³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea(cLAlias)

Return(Nil)

Static Function GeraExcel()

Local nHandle		:= 0
Local cArquivo		:= ""
Local cDirDocs  	:= MsDocPath()
Local cBarra 		:= If(issrvunix(), "/", "\")
Local cPath		  	:= AllTrim(GetTempPath())
Local cBuffer		:= ""
Local nColuna	    := 0
Local nLinha	    := 0

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")
	Return
EndIf
   
	cArquivo 	:= +MV_PAR05+".CSV" //"Rel_Fatur_X_Receb.csv"   
	nHandle 		:= FCreate(cDirDocs + cBarra + cArquivo)

If nHandle == -1
	MsgStop("A planilha não pode ser exportada.")
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava as linhas da planilha                									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cBuffer := ""
cBuffer	+= ToXlsFormat("NOTA")+";"
cBuffer	+= ToXlsFormat("SERIE")+";"
cBuffer	+= ToXlsFormat("EMISSAO")+";"
cBuffer	+= ToXlsFormat("CLIENTE")+";"
cBuffer	+= ToXlsFormat("NOME")+";"
cBuffer	+= ToXlsFormat("FRETE")+";"

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