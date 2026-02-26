#INCLUDE "rwmake.ch"
#include "TBICONN.CH"
#include "TBICODE.CH"
#include "PROTHEUS.CH"          

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCOMR03	º Autor ³ Claudio Ferreira   º Data ³  21/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Pedido de Compra por Comprador        		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico ORTOSINTESE                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCOMR03()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString
aOrd := {}
Private CbTxt        	:= ""
cDesc1         			:= "Este programa tem como objetivo imprimir relatorio "
cDesc2         			:= "de acordo com os parametros informados pelo usuario."
cDesc3         			:= "Relatorio de Pedido de Compras por Comprador"
cPict          			:= " "
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private limite       	:= 220
Private tamanho      	:= "G"
Private nomeprog     	:= "RCOMR03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        	:= 15
Private aReturn      	:= { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
Private nLastKey     	:= 0
titulo         			:= "Relatorio de Pedido de Compras x Comprador"
nLin           			:= 80
Private cbtxt        	:= Space(10)
Private cbcont       	:= 00
Private CONTFL       	:= 01
Private m_pag        	:= 01
imprime        			:= .T.
Private wnrel        	:= "RCOMR03" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "SC7"
aRegs   				:= {}
cPerg   				:= "RCOMR03"
IsDev 					:= .F. 
aExcel 					:= {}

Aadd(aRegs,{cPerg,"01","Data Inicial       ?","","","mv_ch1","D",08,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data Final         ?","","","mv_ch2","D",08,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Fornecedor De      ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","   ","   ","   ","","","   ","   ","   ","","","      ","    ","     ","","","","","","","","","","","","SA2","",})
Aadd(aRegs,{cPerg,"04","Fornecedor Ate     ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","   ","   ","   ","","","   ","   ","   ","","","      ","    ","     ","","","","","","","","","","","","SA2","",}) 
Aadd(aRegs,{cPerg,"05","Pedido De          ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","   ","   ","   ","","","   ","   ","   ","","","      ","    ","     ","","","","","","","","","","","","SC7","",})
Aadd(aRegs,{cPerg,"06","Pedido Ate         ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","   ","   ","   ","","","   ","   ","   ","","","      ","    ","     ","","","","","","","","","","","","SC7","",})
Aadd(aRegs,{cPerg,"07","Nome do Arquivo    ?","","","mv_ch7","C",20,0,0,"G","","Mv_Par07","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"09","Armazem De         ?","","","mv_ch9","C",2,0,0,"G","","mv_Par08","   ","   ","   ","","","   ","   ","   ","","","      ","    ","     ","","","","","","","","","","","","","",})
Aadd(aRegs,{cPerg,"10","Armazem Ate        ?","","","mv_ch10","C",2,0,0,"G","","mv_Par09","   ","   ","   ","","","   ","   ","   ","","","      ","    ","     ","","","","","","","","","","","","","",})
Aadd(aRegs,{cPerg,"11","Centro de Custo De ?","","","mv_ch11","C",09,0,0,"G","","mv_Par11","   ","   ","   ","","","   ","   ","   ","","","      ","    ","     ","","","","","","","","","","","","CTT","",})
Aadd(aRegs,{cPerg,"12","Centro de Custo Ate?","","","mv_ch12","C",09,0,0,"G","","mv_Par12","   ","   ","   ","","","   ","   ","   ","","","      ","    ","     ","","","","","","","","","","","","CTT","",})
Aadd(aRegs,{cPerg,"13","Usuario            ?","","","mv_ch13","C",06,0,0,"G","","mv_Par13","   ","   ","   ","","","   ","   ","   ","","","      ","    ","     ","","","","","","","","","","","","USR","",})



ValidPerg(aRegs,cPerg)

Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec2	:=""
Cabec1  :="" 

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

titulo         := "Pedido de Compras por Comprador" 

Cabec1 := "Emissao     Pedido  Item Produto           Descricao                                                    Nome Fornec.                                 Qtde Pedida    Qtde Entregue    Valor          Total       Comprador" 
    //     99/99/99 123456 123456789012345 12345678901234567890123456789012345678901234567890123467890                                                            999.999.999,99      999.999.999,99  999.999.999,99  999.999.999,99 123456 
	//     1234567891001234156789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890      7    15       23                                              65        74               90               106        116 
	//     1         12             25    30                48                         					    098     106                                        148                 168                 189                 208                 228
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
aAdd(aStru,{"ITEM"  			  	    	,"C",03,0})
aAdd(aStru,{"PRODUTO"					,"C",15,0})
aAdd(aStru,{"DESCRI"						,"C",60,0})
aAdd(aStru,{"FORNECE"					,"C",06,0})
aAdd(aStru,{"NOME"						,"C",50,0})
aAdd(aStru,{"QUANT"						,"N",15,2})
aAdd(aStru,{"QUJE"						,"C",15,2})
aAdd(aStru,{"PRECO"		 		 	 	,"N",15,2})
aAdd(aStru,{"TOTAL"						,"N",15,2})
aAdd(aStru,{"XCOMPR"					,"C",30,0})
//aAdd(aStru,{"SOLICIT"					,"C",15,0})

cQuery := " SELECT "
cQuery += " C7_EMISSAO AS EMISSAO,C7_NUM AS NUMERO,C7_ITEM AS ITEM, C7_PRODUTO AS PRODUTO, C7_DESCRI AS DESCRI, C7_FORNECE AS FORNECE, SUBSTRING(A2_NOME,1,45) AS NOME, "
If MV_PAR08 = 1
			cQuery		+= 		"C7_QUANT QUANT, "+CHR(13)+CHR(10)     
			cQuery		+= 		"C7_PRECO PRECO, "+CHR(13)+CHR(10)    
	Else
  			cQuery		+= 		"C7_QTSEGUM  QUANT, "+CHR(13)+CHR(10)
  			cQuery		+= 		"C7_XPRECO PRECO, "+CHR(13)+CHR(10)
EndIf
//cQuery += " CASE WHEN C7_QTSEGUM > 0 THEN C7_QTSEGUM ELSE C7_QUANT END QUANT, C7_QUJE AS QUJE, "
//cQuery += " CASE WHEN C7_XPRECO >  0 THEN C7_XPRECO  ELSE C7_PRECO END PRECO, "
cQuery += " C7_TOTAL AS TOTAL, C7_XCOMPR AS XCOMPR, C7_QUJE AS QUJE, C7_USER "
cQuery += " FROM "
cQuery += RetSqlName("SC7")+" SC7 " 
cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ = '' " 
cQuery += " WHERE "
cQuery += " C7_EMISSAO BETWEEN '"+Dtos(Mv_Par01)+"' AND '"+Dtos(MV_PAR02)+"' "
cQuery += " AND C7_FORNECE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04  + "' "
cQuery += " AND C7_NUM BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06  + "' " 
cQuery += " AND C7_LOCAL BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10  + "' " 
cQuery += " AND C7_CC BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12  + "' " 
cQuery += " AND SC7.D_E_L_E_T_ = '' " 
If !Empty(Mv_Par13) // Parametro Novo - 26/09/2017 -- Imprime apenas usuario selecionado
	cQuery += " AND SC7.C7_USER  = '"+Mv_Par13+"' "
EndIf

cQuery := ChangeQuery(cQuery)

MEMOWRIT( "RCOMR03.SQL", cQuery )

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)


For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('QUERY', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next                            

_nQuant := 0
_nPreco := 0
_nTotal := 0
_nQuje  := 0

DbSelectArea("QUERY")
DbGoTop()
While !EOF()

aAdd(aStru,{"EMISSAO"					,"D",08,0})
aAdd(aStru,{"NUMERO"						,"C",06,0}) 
aAdd(aStru,{"ITEM"  			  	    	,"C",03,0})
aAdd(aStru,{"PRODUTO"					,"C",15,0})
aAdd(aStru,{"DESCRI"						,"C",60,0})
aAdd(aStru,{"FORNECE"					,"C",06,0})
aAdd(aStru,{"NOME"						,"C",50,0})
aAdd(aStru,{"QUANT"						,"N",15,2})
aAdd(aStru,{"QUJE"						,"C",15,2})
aAdd(aStru,{"PRECO"		 		 	 	,"N",15,2})
aAdd(aStru,{"TOTAL"						,"N",15,2})
aAdd(aStru,{"XCOMPR"					,"C",30,0})
//aAdd(aStru,{"SOLICIT"					,"C",15,0})
 

  		Aadd(aExcel, {QUERY->EMISSAO,QUERY->NUMERO,QUERY->ITEM,QUERY->PRODUTO,QUERY->DESCRI,QUERY->FORNECE,QUERY->NOME,QUERY->QUANT,;
  		QUERY->QUJE,QUERY->PRECO,QUERY->TOTAL,QUERY->XCOMPR})
  		
  	
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
		@ nLin,020 Psay QUERY->ITEM		      PICTURE "@!"
		@ nLin,025 Psay QUERY->PRODUTO       	PICTURE "@!"
		@ nLin,043 Psay QUERY->DESCRI      		PICTURE "@!"
		//@ nLin,096 Psay QUERY->FORNECE			PICTURE "@!"
		@ nLin,104 Psay QUERY->NOME	    		PICTURE "@!"
		@ nLin,143 Psay QUERY->QUANT				PICTURE "@E 999,999,999.99"
		@ nLin,158 Psay QUERY->QUJE		   	PICTURE "@E 999,999,999.99"
		@ nLin,173 Psay QUERY->PRECO	   		PICTURE "@E 999,999,999.99"
		@ nLin,189 Psay QUERY->TOTAL	   		PICTURE "@E 999,999,999.99"
		@ nLin,210 Psay USRFULLNAME(C7_USER)   			PICTURE "@!"
/*	If QUERY->XCOMPR  == "1"
	  		@ nLin,209 Psay "Debora"   			
		ElseIf QUERY->XCOMPR  == "2"
	  		@ nLin,209 Psay "Maria Rosa"
		ElseIf QUERY->XCOMPR  == "3"
	  		@ nLin,209 Psay "Marta"
		ElseIf QUERY->XCOMPR  == "4"
	  		@ nLin,209 Psay "Marcos"
		ElseIf QUERY->XCOMPR  == "5"
	  		@ nLin,209 Psay "Daiane"
		ElseIf QUERY->XCOMPR  == "6"
	  		@ nLin,209 Psay "Elenice"
		ElseIf QUERY->XCOMPR  == "7"
	  		@ nLin,209 Psay "Fabiano"
	EndIf
		
  */		
		_nQuant += QUERY->QUANT
		_nPreco += QUERY->PRECO
		_nTotal += QUERY->TOTAL
		_nQuje += QUERY->QUJE
		
	nLin++	
	dbSkip()
EndDo

nLin ++

@ nLin, 000 PSAY "Total Geral "

	@ nLin, 142 PSAY _nQuant 			PICTURE "@E 999,999,999.99"
	@ nLin, 157 PSAY _nQuje 			PICTURE "@E 999,999,999.99"
	@ nLin, 172 PSAY _nPreco 			PICTURE "@E 999,999,999.99"
	@ nLin, 188 PSAY _nTotal 			PICTURE "@E 999,999,999.99"
	

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

Local nColuna
Local nLinha
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
   
	cArquivo 	:= +MV_PAR07+".CSV" //"Rel_Fatur_X_Receb.csv"   
	nHandle 		:= FCreate(cDirDocs + cBarra + cArquivo)

If nHandle == -1
	MsgStop("A planilha não pode ser exportada.")
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava as linhas da planilha                									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cBuffer := ""
cBuffer	+= ToXlsFormat("EMISSAO")+";"
cBuffer	+= ToXlsFormat("NUMERO")+";"
cBuffer	+= ToXlsFormat("ITEM")+";"
cBuffer	+= ToXlsFormat("PRODUTO")+";"
cBuffer	+= ToXlsFormat("DESCRI")+";"
cBuffer	+= ToXlsFormat("FORNECE")+";"
cBuffer	+= ToXlsFormat("NOME")+";"
cBuffer	+= ToXlsFormat("QUANT")+";"
cBuffer	+= ToXlsFormat("QUJE")+";"
cBuffer	+= ToXlsFormat("PRECO")+";" 
cBuffer	+= ToXlsFormat("TOTAL")+";"
cBuffer	+= ToXlsFormat("XCOMPR")+";"

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