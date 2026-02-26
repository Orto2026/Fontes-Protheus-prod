#INCLUDE "Protheus.CH"
#INCLUDE "TopConn.CH"
#INCLUDE "RwMake.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BACA001  บAutor  ณMicrosiga           บ Data ณ  01/30/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Baca Para Tranferir produtos fracionados para outro armazemบฑฑ
ฑฑบ          ณ evitando o faturamento de cx quebraba                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function BACA001()

Local aSay := {}
Local aButton := {}
Local nOpc := 0
Local cTitulo := "Transferencia de Produtos Fracionados"

Private cDesc1 := "Este programa irแ gerar transferencias automแticas dos  "
Private cDesc2 := "produtos cujo as quantidades estejam fracionadas no "
Private cDesc3 := "estoque - usando como base a tabela SB5 "
Private cDesc4 := ""
Private cDesc5 := ""
Private lEnd := .F.

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )

aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch()            } } )

FormBatch( cTitulo, aSay, aButton )

If nOpc == 1
	Processa({|lEnd| ProcTransf(@lEnd)},"Gerando Transferencias, aguarde...")
Endif	

Return()


Static Function ProcTransf()

Local nX     		:= 0
Local aArray		:= {}
Local cDoc			:= ""
Local cQuery		:= ""
Local aCabEnd		:= {}
Local aItensEnd	:= {}

lMsErroAuto		:= .F.

cQuery := " SELECT * "
cQuery += " FROM "
cQuery += RetSqlName("SB8")
cQuery += " WHERE "
cQuery += " 1 = 1 "
cQuery += " AND D_E_L_E_T_ = ' ' "

cQuery := " SELECT "
cQuery += " PRODUTO, B1_DESC, B1_UM, B8_LOCAL, LOTE, SBLOTE, VALIDADE, QTDE, B5_QEI, MODULO, BF_LOCALIZ ENDERECO, BF_QUANT, B8_EMPENHO "
cQuery += " FROM "+RetSqlName("SBF")+" SBF "
cQuery += " INNER JOIN ( "
cQuery += "     SELECT B8_PRODUTO AS PRODUTO, B1_DESC, B1_UM, B8_LOCAL, B8_LOTECTL AS LOTE, B8_NUMLOTE AS SBLOTE, B8_DTVALID AS VALIDADE, "
cQuery += "     B8_SALDO AS QTDE, B8_EMPENHO, B5_QEI, "
cQuery += "     CAST((B8_SALDO-B8_EMPENHO) AS int) % CAST((B5_QEI) AS INT) AS MODULO "
cQuery += "     FROM "+RetSqlName("SB8")+" SB8 "
cQuery += "     INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = B8_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "     INNER JOIN "+RetSqlName("SB5")+" SB5 ON B5_FILIAL = B1_FILIAL AND B5_COD = B1_COD AND B5_QIE <> 0 AND SB5.D_E_L_E_T_ = ' ' "
cQuery += " 	WHERE B8_FILIAL = '"+xFilial("SB8")+"' "
cQuery += " 	AND B8_LOCAL = '01' "
cQuery += " 	AND B8_SALDO <> 0 "
cQuery += " 	AND SB8.D_E_L_E_T_ = ' ' "
cQuery += " 	GROUP BY B8_PRODUTO, B1_DESC, B1_UM, B8_LOCAL, B8_LOTECTL, B8_NUMLOTE, B8_DTVALID, B8_SALDO, B8_EMPENHO, B5_QEI "
cQuery += " 	HAVING (CAST((B8_SALDO-B8_EMPENHO) AS int) % CAST((B5_QEI) AS INT)) <>  0 ) TRB ON TRB.PRODUTO = BF_PRODUTO AND TRB.LOTE = BF_LOTECTL "
cQuery += " WHERE BF_FILIAL = '"+xFilial("SBF")+"' "
cQuery += " AND BF_LOCAL = '01' "
cQuery += " AND SBF.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY PRODUTO, LOTE, ENDERECO "

ChangeQuery( cQuery )

If Select("QUERY") > 0
	dbCloseArea()
EndIf 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QUERY",.T.,.T.)

TcSetField("QUERY" ,"VALIDADE", "D", 8, 0)

dbSelectArea("QUERY")
ProcRegua(5000)
dbGotop()
While !Eof()

	IncProc("Processaondo Produto: "+QUERY->PRODUTO)

	If (len(aArray) == 0)
		// --> Carrega array contendo as informacoes do cabecalho para tranferencia.
   	cDoc:= CriaVar("D3_DOC")
	   aArray := {}
   	aAdd(aArray,{cDoc, dDataBase })
	Endif
	_nQtdTransf := QUERY->MODULO
	If _nQtdTransf == 0
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SB2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SB2")+QUERY->PRODUTO+"05")
		CriaSB2(QUERY->PRODUTO,"05")
	EndIf
	
	dbSelectArea("SBE")
	dbSetOrder(1)
	If !dbSeek(xFilial("SBE")+"05"+QUERY->ENDERECO)
		RecLock("SBE",.T.)
		SBE->BE_FILIAL 	:= xFilial("SBE")
		SBE->BE_LOCAL  	:= "05"
		SBE->BE_LOCALIZ 	:= QUERY->ENDERECO
		SBE->BE_DESCRIC 	:= QUERY->ENDERECO
		SBE->BE_PRIOR		:= "ZZZ"
		MsUnlock()
	EndIf

	// --> Carrega array contendo as informacoes do item a ser transferido.

	aAdd(aArray, { QUERY->PRODUTO,;                 // --> 01 Produto Origem
		QUERY->B1_DESC,;                             // --> 02 Descricao
		QUERY->B1_UM,;                               // --> 03 Unidade Medida
		QUERY->B8_LOCAL,;                            // --> 04 Local Origem // Era Fixo 02 , porem comecou a Faturar or POTIM
		QUERY->ENDERECO,;                           	// --> 05 Endereco Origem
		QUERY->PRODUTO,;                           	// --> 06 Produto Destino
		QUERY->B1_DESC,;   									// --> 07 Descricao
		QUERY->B1_UM,;    									// --> 08 Unidade Medida
		"05",;                                     	// --> 09 Local Destino // Era Fixo 02 , porem comecou a Faturar or POTIM
		QUERY->ENDERECO,;                           	// --> 10 Endereco Destino
		Criavar("D3_NUMSERI",.F.) ,;                	// --> 11 Numero de Serie
		QUERY->LOTE,;                               	// --> 12 Lote Origem
		QUERY->SBLOTE,;                             	// --> 13 Sub-Lote Origem
		QUERY->VALIDADE,;                           	// --> 14 Vald. Lote Origem
		Criavar("D3_POTENCI",.F.) ,;                	// --> 15 Potencia
		_nQtdTransf,;                              	// --> 16 Quantidade
		0 ,;                                        	// --> 17 Quantid. na 2a.UM
		Criavar("D3_ESTORNO",.F.) ,;                	// --> 18 Estorno
		Criavar("D3_NUMSEQ",.F.) ,;                 	// --> 19 Numero Sequencia
		QUERY->LOTE,;                               	// --> 20 Lote Destino
		QUERY->VALIDADE,;                           	// --> 21 Vald.Lote Destino
		Space(3) })												// --> 22 Item Grade

	If (Len(aArray) > 0)
	   // --> Chamada da funcao automatica.
   	MSExecAuto({|x,y| MATA261(x,y)},aArray,3)

	   If lMsErroAuto
   	   MostraErro("\ERRO\","Erro_TM_"+AllTrim(QUERY->PRODUTO)+"_"+AllTrim(QUERY->LOTE)+"_"+AllTrim(QUERY->ENDERECO)+".LOG")
	  	   DisarmTransaction()
		EndIf		
	  Endif

	aArray 	:= {}

	dbSelectARea("QUERY")
	dbSkip()
EndDo

dbCloseArea()

Return()