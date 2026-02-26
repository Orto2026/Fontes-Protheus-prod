#Include "PROTHEUS.Ch"
#Include "rwmake.ch"
#define STR0001  "Este programa ira gerar um arquivo Excel,"
#define STR0002  "Conforme os parametros definidos pelo    "
#define STR0003  "Usuario, Mapa de Movimentacao "

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RESTR01  บ Autor ณMauricio Prado      บ Data ณ  19/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de arquivo Excel contendo informacoes dos          บฑฑ
ฑฑบ          ณ PICK-LIST ( Sepacacao de material)          					  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico ORTOSINTESE       		                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RESTR003()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nLinha
Local cDesc1		:= STR0001
Local cDesc2		:= STR0002
Local cDesc3		:= STR0003
Local nLinha

Private  cPerg := Padr("RESTR003",Len(SX1->X1_GRUPO)) 
aRegs		:= {}
aExcel	:= {}

aAdd(aRegs,{cPerg,"01","Filial De                ?"," "," ","mv_ch1","C",02,0,0,"G","","mv_par01"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ",""," ","",""})
aAdd(aRegs,{cPerg,"02","Filial Ate               ?"," "," ","mv_ch2","C",02,0,0,"G","","mv_par02"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ",""," ","",""})
aAdd(aRegs,{cPerg,"03","Data Liberacao De        ?"," "," ","mv_ch3","D",08,0,1,"G","","mv_par03"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","",""})
aAdd(aRegs,{cPerg,"04","Data Liberacao Ate       ?"," "," ","mv_ch4","D",08,0,1,"G","","mv_par04"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","",""})
aAdd(aRegs,{cPerg,"05","Local De                 ?"," "," ","mv_ch5","C",02,0,1,"G","","mv_par05"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","",""})
aAdd(aRegs,{cPerg,"06","Local Ate				     ?"," "," ","mv_ch6","C",02,0,1,"G","","mv_par06"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","",""})
aAdd(aRegs,{cPerg,"07","Tab Preco				     ?"," "," ","mv_ch7","C",03,0,1,"G","","mv_par07"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","DA0","",""})
aadd(aRegs,{cPerg,"08","Nome do Arquivo          ?"," "," ","mv_ch8","C",20,0,0,"G","","mv_Par08"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","",""})
aAdd(aRegs,{cPerg,"09","Data Entrega De          ?"," "," ","mv_ch9","D",08,0,1,"G","","mv_par09"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","",""})
aAdd(aRegs,{cPerg,"10","Data Entrega Ate         ?"," "," ","mv_ch10","D",08,0,1,"G","","mv_par10"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","",""})
aAdd(aRegs,{cPerg,"11","Identificador            ?"," "," ","mv_ch11","C",10,0,1,"G","","mv_par11"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","",""})


ValidPerg(aRegs, cPerg)

Pergunte(cPerg,.F.)

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Geracao de Relatorio( Fiscal ) - Excel")
@ 02,10 TO 080,190
@ 10,018 Say STR0001
@ 18,018 Say STR0002
@ 26,018 Say STR0003

@ 50,070 BMPBUTTON TYPE 01 ACTION Processa({|| GeraXls() },"Processando Dados...")
@ 50,100 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 50,130 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.t.)

Activate Dialog oLeTxt Centered

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณ GeraXls  บAutor  ณMicrosiga           บ Data ณ  03/26/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Prepara Dados para geracao do XLS                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P10                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraXLS()

Local nColuna
Local nLinha

Close(oLeTxt)


cQuery := "SELECT C9_PRODUTO AS PRODUTO,DC_QUANT AS QUANTIDADE,C9_LOTECTL AS LOTE,DC_LOCALIZ AS ENDERECO,(SELECT B1_DESC FROM SB1010 WHERE B1_FILIAL ='' AND D_E_L_E_T_ ='' AND B1_COD = C9_PRODUTO) AS DESCRICAO,"
cQuery += "(SELECT A1_NREDUZ FROM SA1010 WHERE A1_FILIAL ='' AND D_E_L_E_T_ ='' AND A1_COD = C9_CLIENTE) AS CLIENTE,"
cQuery += "C9_PEDIDO AS PEDIDO,(C6_PRCVEN * DC_QUANT) AS PRECO,SC6.C6_ENTREG AS ENTREGA,SC9.C9_DATALIB AS LIBERACAO, (SELECT C5_EMISSAO FROM SC5010 WHERE C5_FILIAL = C6_FILIAL AND D_E_L_E_T_ ='' AND C5_NUM = C6_NUM) AS EMISSAO, "
cQuery += "CASE WHEN (SELECT C5_CLASPED FROM SC5010 WHERE C5_FILIAL = C6_FILIAL AND D_E_L_E_T_ ='' AND C5_NUM = C6_NUM) =  '1' THEN 'INTERNO' "
cQuery += "WHEN (SELECT C5_CLASPED FROM SC5010 WHERE C5_FILIAL = C6_FILIAL AND D_E_L_E_T_ ='' AND C5_NUM = C6_NUM) =  '2' THEN 'CAIXAS' "
cQuery += "WHEN (SELECT C5_CLASPED FROM SC5010 WHERE C5_FILIAL = C6_FILIAL AND D_E_L_E_T_ ='' AND C5_NUM = C6_NUM) =  '4' THEN 'EXPORTACAO' "
cQuery += "ELSE 'OUTROS' END TIPO, "
cQuery += "C9_MSIDENT AS IDENT "
cQuery += "FROM SC9010 SC9 "
cQuery += "INNER JOIN SDC010 SDC ON C9_PEDIDO = DC_PEDIDO AND C9_ITEM = DC_ITEM AND C9_SEQUEN = DC_SEQ AND SDC.D_E_L_E_T_ ='' AND C9_PRODUTO = DC_PRODUTO "
cQuery += "INNER JOIN SC6010 SC6 ON C9_PEDIDO = C6_NUM AND C9_ITEM = C6_ITEM AND SC6.D_E_L_E_T_ ='' AND C9_PRODUTO = C6_PRODUTO "
cQuery += "WHERE C9_FILIAL BETWEEN '"+Mv_Par01+"' AND '"+Mv_Par02+"' AND SC9.D_E_L_E_T_ =''  AND C9_BLEST <>'02' AND C9_NFISCAL ='' AND C9_DATALIB BETWEEN '"+Dtos(Mv_Par03)+"' AND '"+Dtos(Mv_Par04)+"' AND C9_LOCAL BETWEEN '"+Mv_Par05+"' AND '"+Mv_Par06+"' AND SC6.C6_ENTREG BETWEEN '"+Dtos(Mv_Par09)+"' AND '"+Dtos(Mv_Par10)+"' AND C9_MSIDENT > '"+Mv_Par11+"'"

cQuery := ChangeQuery(cQuery)
MemoWrite("RESTR003.SQL", cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)
TcSetField("QUERY","ENTREGA"			,"D",08,0)
TcSetField("QUERY","LIBERACAO"			,"D",08,0)
TcSetField("QUERY","EMISSAO"			,"D",08,0)  


_aExcel 		:= {}
_nSaldoI 	:= 0
_nSldAtu 	:= 0
DbSelectArea("QUERY")
ProcRegua(RecCount())
DbGoTop()
While !Eof()

	IncProc("Processando Pick List: "+QUERY->PEDIDO)
	
	aAdd(_aExcel, {QUERY->PRODUTO,QUERY->QUANTIDADE,QUERY->LOTE,QUERY->ENDERECO,QUERY->DESCRICAO,QUERY->CLIENTE,QUERY->PEDIDO,QUERY->PRECO,QUERY->ENTREGA,QUERY->LIBERACAO,QUERY->EMISSAO,QUERY->TIPO,QUERY->IDENT})

	dbSelectArea("QUERY")
	dbSkip()
EndDo

DbSelectArea("QUERY")
dbCloseArea()

If Len(_aExcel) > 0
	GeraExcel()
Else
	Alert("Sem dados para gerar a planilha!!!")
EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณ GeraExcelบAutor  ณMicrosiga           บ Data ณ  03/26/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Planilha de Excel                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P10                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraExcel()
Local nLinha
Local nHandle		:= 0
Local cArquivo		:= ""
Local cDirDocs  	:= MsDocPath()
Local cBarra 		:= If(issrvunix(), "/", "\")
Local cPath		  	:= AllTrim(GetTempPath())
Local cBuffer		:= ""
Local nColuna

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")
	Return
EndIf

cArquivo 	:= AllTrim(MV_PAR08)+".CSV"
nHandle 		:= FCreate(cDirDocs + cBarra + cArquivo)

If nHandle == -1
	MsgStop("A planilha nใo pode ser exportada.")
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGrava as linhas da planilha                									           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// PRODUTO,QUANTIDADE,LOTE,ENDEREวO,DESCRIวรO,CLIENTE,PEDIDO,PRECO,ENTREGA,LIBERACAO,EMISSAO    


cBuffer 	:= ""
cBuffer	+= ToXlsFormat("PRODUTO")+";"
cBuffer	+= ToXlsFormat("QUANTIDADE")+";"
cBuffer	+= ToXlsFormat("LOTE")+";"
cBuffer	+= ToXlsFormat("ENDERECO")+";"
cBuffer	+= ToXlsFormat("DESCRICAO")+";"
cBuffer	+= ToXlsFormat("CLIENTE")+";"
cBuffer	+= ToXlsFormat("PEDIDO")+";"
cBuffer	+= ToXlsFormat("PRECO")+";"
cBuffer	+= ToXlsFormat("ENTREGA")+";"
cBuffer	+= ToXlsFormat("LIBERACAO")+";"
cBuffer	+= ToXlsFormat("EMISSAO")+";" 
cBuffer	+= ToXlsFormat("TIPO")+";"
cBuffer	+= ToXlsFormat("IDENT")+";"
FWrite(nHandle, cBuffer)
FWrite(nHandle, CRLF)

cBuffer 	:= ""
ProcRegua(Len(_aExcel))
For nLinha := 1 to Len(_aExcel)
	
	IncProc("Gerando excel... ")
	
	For nColuna := 1 to Len(_aExcel[nLinha])
		If Valtype(_aExcel[nLinha,nColuna]) <> "C"
			cBuffer += ToXlsFormat(_aExcel[nLinha,nColuna])+";"
		Else
			cBuffer += ToXlsFormat("'"+_aExcel[nLinha,nColuna])+";" // CARACTER ESPECIAL PARA TEXTO //incluido asp no dia 22/09/15 por samuel na base teste
		EndIf
	Next nColuna
	FWrite(nHandle, cBuffer)
	FWrite(nHandle, CRLF)
	cBuffer:=""
Next nLinha

FClose(nHandle)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณcopia o arquivo do servidor para o remote									   			  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CpyS2T(cDirDocs + cBarra + cArquivo, cPath, .T.)
Ferase(cDirDocs + cBarra + cArquivo)
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cPath+cArquivo)
oExcelApp:SetVisible(.T.)

Return()