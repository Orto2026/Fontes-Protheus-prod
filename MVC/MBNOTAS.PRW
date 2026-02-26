#Include 'Totvs.ch'
#Include "RwMake.ch"
#Include "Totvs.ch"
#INCLUDE "TOPCONN.CH"
#Include 'FWMVCDef.ch'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºRotina    ³ MBNOTAS    ºAuto ³Samuel Miranda     º Data ³ 26/11/2020   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDescricao ³  Tela em mbrowser para exibir o status das notas fiscais   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function MBNOTAS()
	//Nome da Perguta
	Private cPerg  :="MBNOTAS"
	//Cria as perguntas caso elas não existe,
	ValidPerg()
	//Valida a pergunta
	If !Pergunte(cPerg,.T.)
		Return()
	Endif
	//Chama a função para gerar a tebela temporario.
	//TELAMB()
	FwMsgRun(NIL, {|| TELAMB()}, "Processando", "Coletando os dados...")
Return()

/*---------------------------------------------------------------------*
 | Func:  TELAMB                                                       |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:  Função para Gerar os dados da tabela temporaria              |
 *---------------------------------------------------------------------*/
Static Function TELAMB()
//Variaveis local
	Local aStruct   :={}  //Fields StructaStruct := {}
	Local aColumns  :={}  //Browse Columns
	Local aFilter   :={}  //Filter Array
	Local nX        := 0  //As Numeric //Loop Control
	Local cQryMb    := ""
	//Campos da tabela temporaria para serem exibidos no Browser.
	//AAdd(aStruct,{"UNIDADE"      ,"C", 12 , 00,"UNIDADE"        ,"!@"}) // 01
	AAdd(aStruct,{"NATUREZA"        ,"C", 04 , 00,"NATUREZA"       ,"!@"}) // 01
	AAdd(aStruct,{"NOTA"            ,"C", 09 , 00,"NÚMERO DA NOTA" ,"!@"}) // 02
	AAdd(aStruct,{"SERIE"           ,"C", 01 , 00,"SÉRIE"          ,"!@"}) // 03
	AAdd(aStruct,{"CLIENTE"         ,"C", 12 , 00,"CÓDIGO CLIENTE" ,"!@"}) // 04
	AAdd(aStruct,{"NOMECLI"         ,"C", 70 , 00,"NOME CLIENTE"   ,"!@"}) // 05
	AAdd(aStruct,{"EMISSAO"         ,"D", 10 , 00,"EMISSÃO"        ,"!@"}) // 06
	AAdd(aStruct,{"MES"     	    ,"C", 10 , 00,"MÊS"        	   ,"!@"}) // 07
	AAdd(aStruct,{"ANO"             ,"C", 04 , 00,"ANO"      	   ,"!@"}) // 08
	AAdd(aStruct,{"EXPEDICAO"       ,"D", 10 , 00,"EXPEDIÇÃO"      ,"!@"}) // 09
	AAdd(aStruct,{"VALOR"           ,"C", 15 , 06,"VALOR DA NOTA"  ,"!@"}) // 10
	AAdd(aStruct,{"CONDPAGTO"       ,"C", 20 , 00,"PAGAMENTO"      ,"!@"}) // 11 Codigo da Condição de Pgto
	AAdd(aStruct,{"DESCODPGTO"      ,"C", 30 , 00,"DESCRIÇÃO"      ,"!@"}) // 12 Descrição da Condição de Pgto
	AAdd(aStruct,{"XUNIDADE"        ,"C", 16 , 00,"DIVISÃO    "    ,"!@"}) // 13
	AAdd(aStruct,{"STATUS"       	,"C", 01 , 00,"STATUS DA NF"   ,"!@"}) // 14
	AAdd(aStruct,{"TRANSPORT"       ,"C", 50 , 00,"TRANSPORTADORA" ,"!@"}) // 15
	AAdd(aStruct,{"CHAVE"           ,"C", 40 , 00,"CHAVE DA NF"    ,"!@"}) // 16

	//Set Columns
	aColumns := {}
	//Seta o Filtro
	aFilter  := {}

	For nX := 1 To Len(aStruct)
		//Columns
		AAdd(aColumns,FWBrwColumn():New())
		aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
		aColumns[Len(aColumns)]:SetTitle(aStruct[nX][5])
		aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
		aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
		//aColumns[Len(aColumns)]:SetPicture(PesqPict("SF2",aStruct[nX][6]))
		//Filters
		aAdd(aFilter, {aStruct[nX][1],aStruct[nX][5],aStruct[nX][2],aStruct[nX][3],aStruct[nX][4],aStruct[nX][6]})
	Next nX

	//Instance of Temporary Table
	oTempTable := FWTemporaryTable():New()
	//Set Fields
	oTempTable:SetFields(aStruct)
	//Set Indexes
	oTempTable:AddIndex("INDEX1",{"NOTA"})

	//Cria a tabela temporaria
	oTempTable:Create()
	cAliasTmp  := oTemptable:GetAlias()

	aHeadCols  := {}
	oBrowse    := NIL
	aAccounts  := {}
	cAliasQry  := GetNextAlias()

	//Local _cAlias   := GetNextAlias()
	//BeginSql Alias cAliasQry
	cQryMb := "SELECT "+CHR(13)+CHR(10)
	cQryMb += " SF2.F2_DOC AS NFISCAL,"+CHR(13)+CHR(10)
	cQryMb += " SF2.F2_SERIE AS NSERIE,"+CHR(13)+CHR(10)
	cQryMb += " SF2.F2_CLIENTE AS NCLIENTE,"+CHR(13)+CHR(10)
	cQryMb += " SF2.F2_EMISSAO AS NEMISSAO,"+CHR(13)+CHR(10)
	cQryMb += " SF2.F2_CHVNFE AS NCHAVENF,"+CHR(13)+CHR(10)
	cQryMb += " SF2.F2_VALBRUT AS NVALOR,"+CHR(13)+CHR(10)
	cQryMb += " SF2.F2_XEXPED AS NSTATUS,"+CHR(13)+CHR(10) //
	cQryMb += " SF2.F2_TRANSP AS CODTRANSP,"+CHR(13)+CHR(10)
	cQryMb += " SF2.F2_COND AS NCOND,"+CHR(13)+CHR(10)
	cQryMb += " CASE "+CHR(13)+CHR(10)
	cQryMb += "  WHEN SF2.F2_COND = '1' THEN 'ANTECIPADO' "+CHR(13)+CHR(10)
	cQryMb += "  WHEN SF2.F2_COND <> '001' THEN 'PARCELADO' "+CHR(13)+CHR(10)
	cQryMb += " ELSE 'A VISTA' END AS CONDPAGTO,"+CHR(13)+CHR(10)
	cQryMb += " SA1.A1_NOME AS NOMCLI,"+CHR(13)+CHR(10)
	cQryMb += " SE4.E4_CODIGO AS CONPGTO,"+CHR(13)+CHR(10)//
	cQryMb += " SE4.E4_DESCRI AS DESCOND,"+CHR(13)+CHR(10)//
	cQryMb += " SA1.A1_NATUREZ AS XNATUREZA,"+CHR(13)+CHR(10)
	cQryMb += " CASE "+CHR(13)+CHR(10)
	cQryMb += "   WHEN SA1.A1_XCLIENT ='O' THEN 'ORTOPEDIA' "+CHR(13)+CHR(10)
	cQryMb += "   WHEN SA1.A1_XCLIENT ='E' THEN 'EQUIPAMENTOS'"+CHR(13)+CHR(10)
	cQryMb += "   WHEN SA1.A1_XCLIENT ='A' THEN 'AMBOS' "+CHR(13)+CHR(10)
	cQryMb += " ELSE 'NÃO CLASSIFICADO' END AS XUNIDADE"+CHR(13)+CHR(10)
	cQryMb += "FROM "+CHR(13)+CHR(10)
	cQryMb +=  RetSqlName("SF2")+" SF2 "+CHR(13)+CHR(10) //FROM SF2010 SF2  
	cQryMb += "	INNER JOIN SA1010 SA1 ON SA1.A1_LOJA=SF2.F2_LOJA AND SA1.A1_COD=SF2.F2_CLIENTE AND SA1.D_E_L_E_T_=' '" +CHR(13)+CHR(10)
	cQryMb += " INNER JOIN SE4010 SE4 ON SE4.E4_CODIGO = SF2.F2_COND AND SE4.D_E_L_E_T_='' " +CHR(13)+CHR(10)//
	cQryMb += "WHERE "+CHR(13)+CHR(10)
	cQryMb += " SF2.F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "+CHR(13)+CHR(10)   //BETWEEN '20211101' AND '20490101' AND 
	cQryMb += " SF2.F2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "+CHR(13)+CHR(10) 			
	//Filtro para selecionar a unidade correspodente 
	If MV_PAR05 == 2
		cQryMb += "SA1.A1_XCLIENT = 'E' AND "+CHR(13)+CHR(10) //Uinidade de Equipamentos
	ElseIf  MV_PAR05 == 3
		cQryMb += "SA1.A1_XCLIENT = 'O' AND "+CHR(13)+CHR(10) //Unidadae de Otopedia
	ElseIf MV_PAR05 == 4
		cQryMb += "SA1.A1_XCLIENT = 'A' AND"+CHR(13)+CHR(10)  //Ambus 
	EndIf
	//Filtro para exibir o status da Nota fiscal
	If MV_PAR06 == 2
		cQryMb += "SF2.F2_XEXPED =' ' AND "+CHR(13)+CHR(10) //STATUS,BR_VERDE,Faturada
	ElseIf  MV_PAR06 == 3
		cQryMb += "SF2.F2_XEXPED ='1'  AND"+CHR(13)+CHR(10)  //BR_VERMELHO,Retirado
	ElseIf MV_PAR06 == 4
		cQryMb += "SF2.F2_XEXPED ='2' AND "+CHR(13)+CHR(10) //BR_AMARELO,Aguardando Coleta
	ElseIf MV_PAR06 == 5
		cQryMb += "SF2.F2_XEXPED ='3' AND"+CHR(13)+CHR(10)  //BR_AZUL,NF Entrada
	EndIf
	cQryMb += "SF2.F2_CHVNFE <> ' ' AND " +CHR(13)+CHR(10)
	cQryMb += "SF2.F2_DUPL <> ' ' AND "+CHR(13)+CHR(10)
	cQryMb += "SF2.F2_SERIE = '1' AND"+CHR(13)+CHR(10)
	cQryMb += "SF2.D_E_L_E_T_ = ' '  "+CHR(13)+CHR(10)
	cQryMb += "ORDER BY  NFISCAL"+CHR(13)+CHR(10)
	cQryMb := ChangeQuery(cQryMb)
	//Grava o resultado da query em um arquivo sql
	MemoWrite("MBNOTAS2.SQL", cQryMb )
	//dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQueryNF),"QUERYNF",.T.,.F.)	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryMb),cAliasQry,.T.,.T.)
				
	//nOrder := 01
	DBSelectArea(cAliasTMP)
	(cAliasQry)->(DbGoTop())
	While !(cAliasQry)->(Eof())

		//Add Temporary Table
		If (RecLock(cAliasTMP, .T.))
			//(cAliasTMP)->UNIDADE    := (cAliasQry)->UNIDADECLI
			(cAliasTMP)->NATUREZA   := (cAliasQry)->XNATUREZA // 01 - Codigo da Natureza de Vendaa
			(cAliasTMP)->NOTA       := (cAliasQry)->NFISCAL // 02 - Número da Nota Fiscal
			(cAliasTMP)->SERIE      := (cAliasQry)->NSERIE // 03 - Serie da Nota fiscal
			(cAliasTMP)->CLIENTE    := (cAliasQry)->NCLIENTE // 04 - Codigo do Cliente
			(cAliasTMP)->NOMECLI    := (cAliasQry)->NOMCLI // 05 - Nome do Cliente
			(cAliasTMP)->EMISSAO    := STOD((cAliasQry)->NEMISSAO) // 06 - Data de emissão da Nota Fiscal
			(cAliasTMP)->MES        := Upper(MesExtenso(MONTH(STOD((cAliasQry)->NEMISSAO)))) // 07 - O mes por extenso
			(cAliasTMP)->ANO        := CValToChar(YEAR(STOD((cAliasQry)->NEMISSAO))) // 08 - O ano
			(cAliasTMP)->EXPEDICAO  := STOD(STATUSEXP((cAliasQry)->NFISCAL )) // 09 - Data da Expedição do Material
			(cAliasTMP)->VALOR      := AllTrim(CValToChar(Transform((cAliasQry)->NVALOR,"@E 999,999,999.99"))) // 10 - Valor da Nota Fiscal
			(cAliasTMP)->XUNIDADE   := (cAliasQry)->XUNIDADE // 11 - Divisão
			(cAliasTMP)->CONDPAGTO  := (cAliasQry)->NCOND +" - " + (cAliasQry)->CONDPAGTO // 12 - Codição de Pagamento.
			(cAliasTMP)->DESCODPGTO := Posicione("SE4",1,xFilial("SE4")+(cAliasQry)->NCOND,"E4_DESCRI") // 13 - Descrição da COndição de Pagamento
			(cAliasTMP)->STATUS     := Alltrim((cAliasQry)->NSTATUS )// 14 - Status da Nota Fiscal
			(cAliasTMP)->TRANSPORT  := Posicione("SA4",1,xFilial("SA4")+(cAliasQry)->CODTRANSP,"SA4->A4_NOME") // 15 - Transportadora
			(cAliasTMP)->CHAVE      := (cAliasQry)->NCHAVENF // 16 - Número da Chave da Nota Fiscal
			(cAliasTMP)->(MsUnlock())
		EndIf
		//Passa pro proximo registro da query.
		(cAliasQry)->(DBSkip())
	EndDo

	//Posiciona no primeiro registro da tabela
	(cAliasTMP)->(DbGoTop())

	//Cria o objeto da classe
	oBrowse:= FWMBrowse():New()
	oBrowse:SetDescription("Monitor de Notas Fiscais")
	oBrowse:SetAlias(cAliasTMP) //Temporary Table Alias

	//Permite adicionar legendas no Browse
	oBrowse:AddLegend("Alltrim((cAliasTMP)->STATUS)==''  " ,"BR_VERDE"   ,"    Faturada")
	oBrowse:AddLegend("Alltrim((cAliasTMP)->STATUS)=='1' " ,"BR_VERMELHO","1 - Retirado")
	oBrowse:AddLegend("Alltrim((cAliasTMP)->STATUS)=='2' " ,"BR_AMARELO" ,"2 - Aguardando Coleta")
	oBrowse:AddLegend("Alltrim((cAliasTMP)->STATUS)=='3' " ,"BR_AZUL"    ,"3 - NF Entrada")

	oBrowse:SetTemporary(.T.)   //Using Temporary Table
	oBrowse:SetUseFilter(.T.)   //Using Filter
	oBrowse:OptionReport(.F.)   //Disable Report Print
	oBrowse:SetColumns(aColumns)
	oBrowse:SetFieldFilter(aFilter) //Set Filters
	oBrowse:SetMenuDef("MBNOTAS")   //Seta o Menu de Opçoes.
	//oBrowse:lHeaderClick:=.F.
	//oBrowse:SetLocate()
	oBrowse:Activate(/*oDlg*/) //Caso deseje incluir em um componente de Tela (Dialog, Panel, etc), informar como parâmetro o objeto
	oTempTable:Delete()
Return

/*---------------------------------------------------------------------*
 | Func:  STATUSEXP                                                    |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:  Função para atribuir o estatus da na tabele temporaria.      |
 *---------------------------------------------------------------------*/
Static Function STATUSEXP(NUMNF)
Local cQuery		    := ""
//Local nStatus			:= ""
Local nExpedicao		:= ""

//Query para selecionar o Pedido
cQuery	:= "SELECT "+CHR(13)+CHR(10)
cQuery	+= " ZWN_NFS,ZWN_STATUS,ZWN_DATEXP  "+CHR(13)+CHR(10)
cQuery	+= "FROM  "+CHR(13)+CHR(10)
cQuery	+= 		RetSqlName("ZWN")+" ZWN "+CHR(13)+CHR(10)
cQuery	+= "WHERE  "+CHR(13)+CHR(10)
cQuery	+= 	" ZWN.ZWN_NFS  LIKE  '%"+NUMNF+"%'
//MemoWrite("COMS998.SQL", cQuery )
If Select("COMS") > 0
	dbSelectArea("COMS")    
	dbCloseArea()
EndIf                                           
dbUseArea( .T.,"TOPCONN",TcGenQry(,,cQuery), "COMS", .T., .T. )
//nStatus := COMS->ZWN_STATUS
nExpedicao := COMS->ZWN_DATEXP
  
Return nExpedicao

/*---------------------------------------------------------------------*
 | Func:  NFLEGEND                                                     |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:  Função para exibir a Legenda                                 |
 *---------------------------------------------------------------------*/
User Function NFLEGEND()
    Local a_legenda :={}
    //Monta as cores
    aadd(a_legenda, {"BR_VERDE"   , "    Faturada"})
    aadd(a_legenda, {"BR_VERMELHO", "1 - Retirado"})
    aadd(a_legenda, {"BR_AMARELO" , "2 - Aguardando Coleta"})
    aadd(a_legenda, {"BR_AZUL"    , "3 - NF Entrada"})
	//Monta a legenda da tela
    BrwLegenda("Status do Envio", "Status", a_legenda)
Return

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:  Função com os itens do menu.                                 |
 *---------------------------------------------------------------------*/
Static Function MenuDef()
    //Local _aRotina := FWMvcMenu("MVC001")
    //Variavel com as rotinas do menu.
    Local _aRotina   := {}
    Add OPTION _aRotina TITLE 'Legenda'      ACTION 'U_NFLEGEND' OPERATION 2 ACCESS 0
	Add OPTION _aRotina TITLE 'Parametros'   ACTION 'U_MBREFRESH' OPERATION 3 ACCESS 0
	Add OPTION _aRotina TITLE 'Gerar Excel'  ACTION 'U_RELMBNOTAS' OPERATION 4 ACCESS 0
	    
Return _aRotina

/*---------------------------------------------------------------------*
/ | Func:  MBREFRESH                                                    |
/ | Autor: Samuel Miranda                                               |
/ | Data:  18/05/2021                                                   |
/ | Desc:  Função Atualizar a FWMbrowser                                |
/ *---------------------------------------------------------------------*/
User Function MBREFRESH()
Local oBrowse := GetObjBrow() //Obtém o ultimo Objeto Browse
//Crias as Perguntas caso elas não existam
ValidPerg()

//Valida a pergunta
If !Pergunte(cPerg,.T.)
	Return()
Endif
//Processa a rotina novamente
FwMsgRun(NIL, {|| TELAMB()}, "Processando", "Coletando os dados...")
oBrowse:Refresh()
oBrowse:setfocus()
Return


/*---------------------------------------------------------------------*
 | Func:  RELMBNOTAS                                                   |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:  Função para gerar o relatorio em excel conforme parametros.  |
 *---------------------------------------------------------------------*/
User Function RELMBNOTAS()
//Variaveis
Local cPerg       := "MBNOTAS"
Private cDrvArq   := ""
Private cQryPlan1 := "QRYPLAN1"
Private nResult   := 0 //Adicionado para trazer a quantodade de registros 
//Crias as Perguntas caso elas não existam
ValidPerg()

//Valida a pergunta
If !Pergunte(cPerg,.T.)
	Return()
EndIf
//Aciona a query para montar o relatorio
FwMsgRun(NIL, {|| MontaQry()}, "Processando", "Coletando dados...")

//Cria XML e abre EXCEL
FwMsgRun(NIL, {|| GeraXml()}, "Processando", "Transferindo "+CValToChar(nResult) +" registros para o EXCEL...")

Return

/*---------------------------------------------------------------------*
 | Func:  MontaQry                                                     |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:  Função para Monta a query conforme parametrose gera os dados.|
 *---------------------------------------------------------------------*/
Static Function MontaQry()
//Variaveis
Local cQueryExcel     := ""
//Variavel para o proximo Alias.
cAliasExcel  := GetNextAlias()

	//Local _cAlias   := GetNextAlias()
	//BeginSql Alias cAliasQry
	cQueryExcel := "SELECT "+CHR(13)+CHR(10)
	cQueryExcel += " SF2.F2_DOC AS NFISCAL,"+CHR(13)+CHR(10)
	cQueryExcel += " SF2.F2_SERIE AS NSERIE,"+CHR(13)+CHR(10)
	cQueryExcel += " SF2.F2_CLIENTE AS CODCLI,"+CHR(13)+CHR(10)
	cQueryExcel += " SF2.F2_EMISSAO AS NEMISSAO,"+CHR(13)+CHR(10)
	cQueryExcel += " SF2.F2_CHVNFE AS NCHAVENF,"+CHR(13)+CHR(10)
	cQueryExcel += " SF2.F2_VALBRUT AS NVALOR,"+CHR(13)+CHR(10)
	cQueryExcel += " SF2.F2_XEXPED AS NSTATUS,"+CHR(13)+CHR(10)
	cQueryExcel += " SF2.F2_COND AS NCOND,"+CHR(13)+CHR(10)
	cQueryExcel += " CASE "+CHR(13)+CHR(10)
	cQueryExcel += "  WHEN SF2.F2_COND = '1' THEN 'ANTECIPADO' "+CHR(13)+CHR(10)
	cQueryExcel += "  WHEN SF2.F2_COND <> '001' THEN 'PARCELADO' "+CHR(13)+CHR(10)
	cQueryExcel += " ELSE 'A VISTA' END AS CONDPAGTO,"+CHR(13)+CHR(10)
	cQueryExcel += " SA1.A1_NOME AS NOMECLI,"+CHR(13)+CHR(10)
	cQueryExcel += " SE4.E4_CODIGO AS CONPGTO,"+CHR(13)+CHR(10)
	cQueryExcel += " SE4.E4_DESCRI AS DESCOND,"+CHR(13)+CHR(10)
	cQueryExcel += " SA1.A1_NATUREZ AS XNATUREZA,"+CHR(13)+CHR(10)
	cQueryExcel += " CASE "+CHR(13)+CHR(10)
	cQueryExcel += "   WHEN SA1.A1_XCLIENT ='O' THEN 'ORTOPEDIA' "+CHR(13)+CHR(10)
	cQueryExcel += "   WHEN SA1.A1_XCLIENT ='E' THEN 'EQUIPAMENTOS'"+CHR(13)+CHR(10)
	cQueryExcel += "   WHEN SA1.A1_XCLIENT ='A' THEN 'AMBOS' "+CHR(13)+CHR(10)
	cQueryExcel += " ELSE 'NÃO CLASSIFICADO' END AS XUNIDADE"+CHR(13)+CHR(10)
	cQueryExcel += "FROM "+CHR(13)+CHR(10)
	cQueryExcel +=  RetSqlName("SF2")+" SF2 "+CHR(13)+CHR(10) //FROM SF2010 SF2  
	cQueryExcel += "   INNER JOIN SA1010 SA1 ON SA1.A1_LOJA=SF2.F2_LOJA AND SA1.A1_COD=SF2.F2_CLIENTE AND SA1.D_E_L_E_T_=' '" +CHR(13)+CHR(10)
	cQueryExcel += "   INNER JOIN SE4010 SE4 ON SE4.E4_CODIGO = SF2.F2_COND AND SE4.D_E_L_E_T_=' ' " +CHR(13)+CHR(10)
	cQueryExcel += "WHERE "+CHR(13)+CHR(10)
	cQueryExcel += " SF2.F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "+CHR(13)+CHR(10)   //BETWEEN '20211101' AND '20490101' AND 
	cQueryExcel += " SF2.F2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "+CHR(13)+CHR(10) 			
	//Filtro para selecionar a unidade correspodente 
	If MV_PAR05 == 2
		cQueryExcel += "SA1.A1_XCLIENT = 'E' AND "+CHR(13)+CHR(10) //Uinidade de Equipamentos
	ElseIf  MV_PAR05 == 3
		cQueryExcel += "SA1.A1_XCLIENT = 'O' AND "+CHR(13)+CHR(10) //Unidadae de Otopedia
	ElseIf MV_PAR05 == 4
		cQueryExcel += "SA1.A1_XCLIENT = 'A' AND"+CHR(13)+CHR(10)  //Ambus 
	EndIf
	//Filtro para exibir o status da Nota fiscal
	If MV_PAR06 == 2
		cQueryExcel += "SF2.F2_XEXPED =' ' AND "+CHR(13)+CHR(10) //STATUS,BR_VERDE,Faturada
	ElseIf  MV_PAR06 == 3
		cQueryExcel += "SF2.F2_XEXPED ='1'  AND"+CHR(13)+CHR(10)  //BR_VERMELHO,Retirado
	ElseIf MV_PAR06 == 4
		cQueryExcel += "SF2.F2_XEXPED ='2' AND "+CHR(13)+CHR(10) //BR_AMARELO,Aguardando Coleta
	ElseIf MV_PAR06 == 5
		cQueryExcel += "SF2.F2_XEXPED ='3' AND"+CHR(13)+CHR(10)  //BR_AZUL,NF Entrada
	EndIf
	cQueryExcel += "SF2.F2_CHVNFE <> ' ' AND " +CHR(13)+CHR(10)
	cQueryExcel += "SF2.F2_DUPL <> ' ' AND "+CHR(13)+CHR(10)
	cQueryExcel += "SF2.F2_SERIE = '1' AND"+CHR(13)+CHR(10)
	cQueryExcel += "SF2.D_E_L_E_T_ = ' '  "+CHR(13)+CHR(10)
	cQueryExcel += "ORDER BY  NFISCAL"+CHR(13)+CHR(10)
	cQueryExcel := ChangeQuery(cQueryExcel)
	//Grava o resultado da query em um arquivo sql
	MemoWrite("MBNOTAS2Excel.SQL", cQueryExcel )

	DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQueryExcel),"QUERY",.T.,.F.)
	QUERY->(dbEval({ || nResult++ },,{||!Eof()} ))

Return()

/*---------------------------------------------------------------------*
 | Func:  GeraXml                                                      |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:  Gera o arquivo excel conforme paratros informado na Query    |
 *---------------------------------------------------------------------*/
Static Function GeraXml()
Local cNTime    := StrTran(Time(),":","")
Local cArquivo  := "MBNOTAS_"+cNTime+".xml
Local cDirDocs  := MsDocPath()
Local oExcelApp := Nil
Local cPath     := AllTrim(GetTempPath())
Local oExcel    := FWMSEXCEL():New()
Local cPlan1, cTab11
Local cStatusNF := ""
Local cCodPgto  := ""
Local cDescPgto :=""

cPlan1 := "MONITOR DE NOTAS "
cTab11 := cPlan1

oExcel:SetHeaderBold(.T.) 
oExcel:SetFrColorHeader("#363636")
oExcel:SetBgColorHeader("#EE9572")
oExcel:SetLineFrColor("#000000")
oExcel:Set2LineFrColor("#000000")
oExcel:SetLineBgColor("#FFFFFF")
oExcel:Set2LineBgColor("#FFFFFF")

oExcel:AddWorkSheet(cPlan1)
oExcel:AddTable(cPlan1,cTab11)
// 1 = Modo Texto
// 2 = Valor sem R$
// 3 = Valor com R$
If Select("QUERY") > 0
	//cWorkSheet, cTable, cColumm, nAlign, nFormat ,lTotal
	oExcel:AddColumn(cPlan1 ,cTab11, "NATUREZA" 	,1 ,1 ,.F.) // 01 - Natureza
	oExcel:AddColumn(cPlan1 ,cTab11, "NOTA" 		,1 ,1 ,.F.) // 02 - Numero da Nota fiscal
	oExcel:AddColumn(cPlan1 ,cTab11, "SERIE" 		,1 ,1 ,.F.) // 03 - Serie da Nota Fiscal
	oExcel:AddColumn(cPlan1 ,cTab11, "COD CLIENTE" 	,1 ,1 ,.F.) // 04 - Codigo do Cliente
	oExcel:AddColumn(cPlan1 ,cTab11, "NOMECLI" 		,1 ,1 ,.F.) // 05 - Nome do Cliente
	oExcel:AddColumn(cPlan1 ,cTab11, "EMISSAO" 		,1 ,1 ,.F.) // 06 - Data de Emissão da Nota
	oExcel:AddColumn(cPlan1 ,cTab11, "MES" 			,1 ,1 ,.F.) // 07 - Mes
	oExcel:AddColumn(cPlan1 ,cTab11, "ANO" 			,1 ,1 ,.F.) // 08 - Ano
	oExcel:AddColumn(cPlan1 ,cTab11, "EXPEDICAO" 	,1 ,1 ,.F.) // 09 - Data da Expedição da Nota
	oExcel:AddColumn(cPlan1 ,cTab11, "VALOR" 		,3 ,3 ,.F.) // 10 - Valor da Nota
	oExcel:AddColumn(cPlan1 ,cTab11, "CODPGTO" 		,1 ,1 ,.F.) // 11 - Codigo da Condição de Pagamento
	oExcel:AddColumn(cPlan1 ,cTab11, "DESCRIÇÃO" 	,1 ,1 ,.F.) // 12 - Descrição da Condição de pagamento
	oExcel:AddColumn(cPlan1 ,cTab11, "DIVISÃO" 		,1 ,1 ,.F.) // 13 - Divisão 
	oExcel:AddColumn(cPlan1 ,cTab11, "STATUS DA NF" ,1 ,1 ,.F.) // 14 - Statua da Nota
EndIf
//Seleciona o Alias
dbSelectArea("QUERY")
DbGoTop()
While QUERY->(!Eof())
	MES := Upper(MesExtenso(MONTH(STOD(QUERY->NEMISSAO))))
	ANO := CValToChar(YEAR(STOD(QUERY->NEMISSAO))) //STOD(STATUSEXP(QUERY->NFISCAL)) 
	If QUERY->NSTATUS == " "
		cStatusNF := "FATURADO"  //STATUS,BR_VERDE,Faturada
	ElseIf  QUERY->NSTATUS =='1'
		cStatusNF := "RETIRADO" //BR_VERMELHO,Retirado
	ElseIf QUERY->NSTATUS =='2'
		cStatusNF := "AGUARDANDO COLEA" //BR_AMARELO,Aguardando Coleta
	ElseIf QUERY->NSTATUS =='3'
		cStatusNF := "NF DE ENTRADA" //BR_AZUL,NF Entrada
	EndIF
	cCodPgto := QUERY->NCOND + " - " + QUERY->CONDPAGTO
	cDescPgto := Posicione("SE4",1,xFilial("SE4")+QUERY->NCOND,"E4_DESCRI")
	QUERY->(oExcel:AddRow(cPlan1,cTab11,{QUERY->XNATUREZA,; // 01 - Natureza// 01 - Natureza
										 QUERY->NFISCAL,;   // 02 - Numero da Nota fiscal// 02 - Número da Nota Fiscal
										 QUERY->NSERIE,;    // 03 - Serie da Nota Fiscal// 03 - Serie da Nota fiscal
										 QUERY->CODCLI,;   	// 04 - Codigo do Cliente// 04 - Codigo do Cliente NCLIENTE
										 QUERY->NOMECLI,; 	// 05 - Nome do Cliente// 05 - Nome do Cliente NCLIENTE
										 STOD(QUERY->NEMISSAO),;  // 06 - Data de Emissão da Nota// 06 - Data de emissão da Not NCHAVENF
										 MES,; 				// 07 - Mes// 07 - Mes
										 ANO,;      		// 08 - Ano// 08 - Ano
										 QUERY->(STOD(STATUSEXP(QUERY->NFISCAL))),;	// 09 - Data da Expedição da Nota// 09 - Data da Expedição da Nota
										 QUERY->NVALOR,;	// 10 - Valor da Nota AllTrim(CValToChar(Transform(QUERY->NVALOR,"@E 999,999,999.99")))
										 cCodPgto ,;   	    // 11 - Codigo da Condição de Pagamento// 10 - (cAliasQry)->NCOND +" - " + (cAliasQry)->CONDPAGTO // 12 - Codição de Pagamento.
										 cDescPgto,;	    // 12 - Descrição da Condição de pagamento// 11 -   // 13 - Descrição da COndição de Pagamento
										 QUERY->XUNIDADE,; 	// 13 - Divisão 
										 cStatusNF})) 	    // 14 - Statua da Nota
		
	QUERY->(DBSkip())
EndDo
//Fecha o alias
QUERY->(dbCloseArea())

If !Empty(oExcel:aWorkSheet)
	oExcel:Activate()
	oExcel:GetXMLFile(cDirDocs+"\"+cArquivo)
	
	CpyS2T(cDirDocs+"\"+cArquivo,cPath)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()
Else
	MsgAlert("Não existem dados a serem exibidos.")
EndIf

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Função    ValidPerg   ³ Rev.  ³ Samuel Miranda	     ³ Data ³ 06/05/21³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descrição ³ Cria os perguntes caso ele não exetam 		              ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function ValidPerg()
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i,j
Local nTamSX1	:= Len(SX1->X1_GRUPO)
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 			:= PADR("MBNOTAS",nTamSX1)

Aadd(aRegs,{cPerg,"01","Emissao de  !"	,"Emissao de  !","Emissao de  !" ,"mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
Aadd(aRegs,{cPerg,"02","Emissao Ate !"	,"Emissao ate !","Emissao ate !" ,"mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
Aadd(aRegs,{cPerg,"03","Cliente de  !"	,"Cliente de  !","Cliente de  !" ,"mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
Aadd(aRegs,{cPerg,"04","Cliente Ate !"	,"Cliente ate !","Cliente ate !" ,"mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
Aadd(aRegs,{cPerg,"05","Unidade     !"	,"Unidade     !","Unidade     !" ,"mv_ch5","N",06,0,0,"C","","mv_par05","Todos","Todos","Todos","","","Equipamentos","Equipamentos","Equipamentos","","","Ortopedia","Ortopedia","Ortopedia","","","Ambos","Ambos","Ambos","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Status      !"	,"Status      !","Status      !" ,"mv_ch3","N",01,0,0,"C","","mv_par06","Todos","Todos","Todos","","","Faturado","Faturado","Faturado","","","Retirado","Retirado","Retirado","","","Aguard. Coleta","Aguard. Coleta","Aguard. Coleta","","","NF Entrada","NF Entrada","NF Entrada","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()            
	Endif
Next i

dbSelectArea(_sAlias)

Return()


/*
oBrw1:oBrowse:SetArray( aCoBrw1 )
oBrw1:aCols := aCoBrw1
oBrw1:oBrowse:Refresh(.t.)
oBrw1:Forcerefresh() 


/*
 Local cAliasstatus

 cAliasstatus := GetNextAlias()
    BeginSql Alias cAliasQry
   
        SELECT 
              SELECT ZWN_NFS,ZWN_STATUS FROM ZWN010 ZWN (NOLOCK)  //FROM  SF2010 SF2 (NOLOCK) 
            WHERE  ZWN.D_E_L_E_T_=''  AND ZWN.ZWN_NFS IN ""
	EndSql
*/	

/*
    oBrowse:AddLegend("ZWN_STATUS=='1' ","RED","Retirado")
    oBrowse:AddLegend("ZWN_STATUS=='2' ","YELLOW","Aguardando Coleta")
    oBrowse:AddLegend("ZWN_STATUS=='3' ","BLUE","NF Entrada")
    02 	GRAY 	BR_CINZA
    03 	GREEN 	BR_VERDE
    04 	RED 	BR_VERMELHO
    05 	BROWN 	BR_MARROM
    06 	BLUE 	BR_AZUL
    07 	YELLOW 	BR_AMARELO
    08 	BLACK 	BR_PRETO
    09 	PINK 	BR_PINK
    10 	F12_MARR 	BR_VIOLETA
    11 	ORANGE 	BR_PRETO_0
    12 	LIGHTBLU 	BR_PRETO_1
    */    
