#INCLUDE "rwmake.ch"
#include "TBICONN.CH"
#include "TBICODE.CH"
#include "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATR03	º Autor ³ Claudio Ferreira   º Data ³  11/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Envio de Clientes (Cobranca de Titulos  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico COMBE                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATR03()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString
aOrd := {}
Private CbTxt        	:= ""
cDesc1         			:= "Este programa tem como objetivo imprimir relatorio "
cDesc2         			:= "de acordo com os parametros informados pelo usuario."
cDesc3         			:= "Relatorio de Envio de Email (Cobranca)"
cPict          			:= " "
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private limite       	:= 220
Private tamanho      	:= "G"
Private nomeprog     	:= "RFATR03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        	:= 15
Private aReturn      	:= { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
Private nLastKey     	:= 0
titulo         			:= "Relatorio de Envio de Email "
nLin           			:= 80
Private cbtxt        	:= Space(10)
Private cbcont       	:= 00
Private CONTFL       	:= 01
Private m_pag        	:= 01
imprime        			:= .T.
Private wnrel        	:= "RFATR03" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "SE1"
aRegs   				:= {}
cPerg   				:= "RFATR03"
IsDev 					:= .F. 
aExcel 					:= {}

Aadd(aRegs,{cPerg,"01","Cliente De  ?","","","mv_ch1","C",06,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Cliente Ate ?","","","mv_ch2","C",06,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Natureza De  ?","","","mv_ch3","C",06,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Natureza Ate ?","","","mv_ch4","C",06,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Titulo De   ?","","","mv_ch5","C",09,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Titulo Ate  ?","","","mv_ch6","C",09,0,0,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Prefixo De  ?","","","mv_ch7","C",02,0,0,"G","","Mv_Par07","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Prefixo Ate ?","","","mv_ch8","C",02,0,0,"G","","Mv_Par08","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
Aadd(aRegs,{cPerg,"09","Emissao De  ?","","","mv_ch9","D",08,0,0,"G","","Mv_Par09","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"10","Emissao Ate ?","","","mv_cha","D",08,0,0,"G","","Mv_Par10","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"11","Vencrea De  ?","","","mv_chb","D",08,0,0,"G","","Mv_Par11","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"12","Vencrea Ate ?","","","mv_chc","D",08,0,0,"G","","Mv_Par12","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"13","Nome do Arquivo    ?","","","mv_chd","C",20,0,0,"G","","Mv_Par13","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,cPerg)      

Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec2	:=""
Cabec1  :="" 

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

titulo         := "Envio de Email (Cobranca) - Emissao Titulos de "+Dtoc(Mv_par09)+" Ate "+Dtoc(Mv_Par10)

	Cabec1  := " Prefixo	  Numero    Parcela	  Tipo	   Cliente	   Loja	  Nome	                                Emissao	      Vencto	          Valor           Natureza   Dias_Atraso"
    //           XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXDD/MM/AAAA   DD/MM/AAAA        999,999,999.99       
    //           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
    //           0         1         2         3         4         5         6         7         8         9        10        11        12            
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
aAdd(aStru,{"PREFIXO"	  		,"C",03,0})
aAdd(aStru,{"NUMERO"				,"C",09,0}) 
aAdd(aStru,{"PARCELA"  	   	,"C",02,0})
aAdd(aStru,{"TIPO"				,"C",03,0})
aAdd(aStru,{"CLIENTE"			,"C",06,0})
aAdd(aStru,{"LOJA"		   	,"C",02,0})
aAdd(aStru,{"NOME"				,"C",40,0})
aAdd(aStru,{"EMISSAO"			,"D",08,0})
aAdd(aStru,{"VENCREA"			,"D",08,0})
aAdd(aStru,{"VALOR"		  		,"N",15,2})

cQuery := "SELECT  "
cQuery += " E1_PREFIXO AS PREFIXO, E1_NUM AS NUMERO, E1_PARCELA AS PARCELA, E1_TIPO AS TIPO, E1_CLIENTE AS CLIENTE, E1_LOJA AS LOJA, E1_NOMCLI AS NOME, "
cQuery += " E1_EMISSAO AS EMISSAO, E1_VENCREA AS VENCREA, E1_VALOR AS VALOR, E1_BAIXA , E1_SALDO ,A1_EMAIL AS EMAIL, E1_NATUREZ AS NATUREZ, " 
cQuery += " CASE  WHEN E1_BAIXA = '' THEN DATEDIFF (DAY, E1_VENCREA, convert(varchar(30),getdate(),102))  END  AS DIAS_ATRASO "
cQuery += " FROM " 
cQuery += RetSqlName( 'SE1' ) + " SE1 "
cQuery += " INNER JOIN SA1010 SA1 ON A1_FILIAL = '"+xFilial("SA1")+"'  AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = '' "   
cQuery += " WHERE " 
cQuery += "  E1_FILIAL = '"+xFilial("SE1")+"' "
cQuery += " AND E1_CLIENTE BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02  + "' "
cQuery += " AND E1_NATUREZ BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04  + "' "
cQuery += " AND E1_NUM BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06  + "' "
cQuery += " AND E1_PREFIXO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08  + "' "
cQuery += " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"'  "  
cQuery += " AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR11)+"' AND '"+DTOS(MV_PAR12)+"'  " 
cQuery += " AND E1_BAIXA = '' "
cQuery += " AND SE1.D_E_L_E_T_ = '' "
cQuery += " ORDER BY E1_CLIENTE " 

cQuery := ChangeQuery(cQuery)
MEMOWRIT( "RFATR03.SQL", cQuery )

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)


For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('QUERY', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next                            


DbSelectArea("QUERY")
DbGoTop()
While !EOF()

aAdd(aStru,{"PREFIXO"	  		,"C",03,0})
aAdd(aStru,{"NUMERO"				,"C",09,0}) 
aAdd(aStru,{"PARCELA"  	   	,"C",02,0})
aAdd(aStru,{"TIPO"				,"C",03,0})
aAdd(aStru,{"CLIENTE"			,"C",06,0})
aAdd(aStru,{"LOJA"		   	,"C",02,0})
aAdd(aStru,{"NOME"				,"C",40,0})
aAdd(aStru,{"EMISSAO"			,"D",08,0})
aAdd(aStru,{"VENCREA"			,"D",08,0})
aAdd(aStru,{"VALOR"		  		,"N",15,2})
aAdd(aStru,{"NATUREZ"			,"C",10,0})
aAdd(aStru,{"DIAS_ATRASO"		,"C",06,0}) 

  		Aadd(aExcel, {QUERY->PREFIXO,QUERY->NUMERO,QUERY->PARCELA,QUERY->TIPO,QUERY->CLIENTE,QUERY->LOJA,QUERY->NOME,QUERY->EMISSAO,;
  		QUERY->VENCREA,QUERY->VALOR,QUERY->NATUREZ,QUERY->DIAS_ATRASO})
  		
  	
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
	
		@ nLin,002 Psay QUERY->PREFIXO	    	PICTURE "@"
		@ nLin,010 Psay QUERY->NUMERO		      PICTURE "@!"
		@ nLin,021 Psay QUERY->PARCELA     		PICTURE "@!"
		@ nLin,030 Psay QUERY->TIPO	       	PICTURE "@!"
		@ nLin,037 Psay QUERY->CLIENTE      	PICTURE "@!"
		@ nLin,046 Psay QUERY->LOJA				PICTURE "@@!"
		@ nLin,052 Psay QUERY->NOME    			PICTURE "@@!"
		@ nLin,088 Psay QUERY->EMISSAO			PICTURE "@D!" 
		@ nLin,101 Psay QUERY->VENCREA			PICTURE "@D!"
		@ nLin,112 Psay QUERY->VALOR		  		PICTURE "@E 999,999,999.99"
		@ nLin,133 Psay QUERY->NATUREZ      	PICTURE "@!"
		@ nLin,148 Psay QUERY->DIAS_ATRASO    	PICTURE "@!"
			
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
   
	cArquivo 	:= +MV_PAR13+".CSV" //"Rel_Fatur_X_Receb.csv"   
	nHandle 		:= FCreate(cDirDocs + cBarra + cArquivo)

If nHandle == -1
	MsgStop("A planilha não pode ser exportada.")
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava as linhas da planilha                									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cBuffer := ""
cBuffer	+= ToXlsFormat("PREFIXO")+";"
cBuffer	+= ToXlsFormat("NUMERO")+";"
cBuffer	+= ToXlsFormat("PARCELA")+";"
cBuffer	+= ToXlsFormat("TIPO")+";"
cBuffer	+= ToXlsFormat("CLIENTE")+";"
cBuffer	+= ToXlsFormat("LOJA")+";"
cBuffer	+= ToXlsFormat("NOME")+";"
cBuffer	+= ToXlsFormat("EMISSAO")+";"
cBuffer	+= ToXlsFormat("VENCRE")+";"
cBuffer	+= ToXlsFormat("VALOR")+";" 
cBuffer	+= ToXlsFormat("NATUREZ")+";"
cBuffer	+= ToXlsFormat("DIAS_ATRASO")+";"

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