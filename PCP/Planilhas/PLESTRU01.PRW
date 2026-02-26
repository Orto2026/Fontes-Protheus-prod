#Include 'Totvs.ch'
#Include "RwMake.ch"
#Include "Totvs.ch"
#INCLUDE "TOPCONN.CH"  

 
User Function PLESTRU01()
//Variaveis local
Local aStruct   :={}  //Fields StructaStruct := {}
Local aColumns  :={}  //Browse Columns
Local aFilter   :={}  //Filter Array
Local nX        := 0  //As Numeric //Loop Control
Local cQuery := " "
//Local PRODUCAO_MESES := 1

//AAdd(aStruct,{"CODIGO"          ,"C", 12 , 00,"CODIGO"          ,"!@"})     // 1
AAdd(aStruct,{"PRODUTO"  , "C", 10, 00, "PRODUTO"        , "!@"})
AAdd(aStruct,{"NIVEL"    , "N", 06, 00, "NIVEL"          , "@E 9999"})
AAdd(aStruct,{"PRODUTO2" , "C", 15, 00, "PRODUTO2"       , "!@"})
AAdd(aStruct,{"DESCPROD" , "C", 70, 00, "DESCRIÇÃO PRODUTO" , "!@"})
AAdd(aStruct,{"DESCPRO2" , "C", 70, 00, "DESCRIÇÃO PRODUTO"   , "!@"})
AAdd(aStruct,{"COMPONET" , "C", 20, 00, "COMPONENTE"     , "!@"})
AAdd(aStruct,{"DESCCOMP" , "C", 70, 00, "DESCRIÇÃO COMPONENTE", "!@"})
AAdd(aStruct,{"QUANTIDE" , "N", 20, 06, "QUANTIDADE"     , ""})
//AAdd(aStruct,{"NIVEL"    , "N", 06, 00, "NIVEL"          , "@R 9999"}) @E 99,999,999.999999
AAdd(aStruct,{"QTDSC"    , "N", 25, 06, "QTD_SC"         , ""})
AAdd(aStruct,{"QTDPDCMP" , "N", 25, 06, "QTD_PD_COMPRA"  , ""})
AAdd(aStruct,{"QTDOP"    , "N", 25, 06, "QTD_OP"         , ""})
AAdd(aStruct,{"QTDESTQE" , "N", 25, 06, "QTD_ESTOQUE"    , ""})
AAdd(aStruct,{"QTINSPCAO", "N", 25, 06, "QTD_INSPECAO"   , ""})
AAdd(aStruct,{"QTENDECAR", "N", 25, 06, "QTD_ENDEREÇAR"  , ""})
AAdd(aStruct,{"QTEMPHADA", "N", 25, 06, "QTD_EMPENHADA"  , ""})

    aColumns := {}
    aFilter  := {}
    For nX := 1 To Len(aStruct)
        //Columns
        AAdd(aColumns,FWBrwColumn():New())
        aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
        aColumns[Len(aColumns)]:SetTitle(aStruct[nX][5])
        aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
        aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
        //aColumns[Len(aColumns)]:SetPicture(PesqPict("CT1",aStruct[nX][1]))
        //Filters
        aAdd(aFilter, {aStruct[nX][1],aStruct[nX][5],aStruct[nX][2],aStruct[nX][3],aStruct[nX][4],aStruct[nX][6]})
    Next nX
 
    //Instance of Temporary Table
    oTempTable := FWTemporaryTable():New()
    //Set Fields
    oTempTable:SetFields(aStruct)
    //Set Indexes
    oTempTable:AddIndex("INDEX1",{"PRODUTO"})
   
    //Create
    oTempTable:Create()
    cAliasTmp := oTemptable:GetAlias()
 
    aHeadCols := {}
    oBrowse    := NIL
    aAccounts := {}
    //cAliasQry := GetNextAlias()

	//cQuery := "SELECT " + CHR(13)+CHR(10)
	cQuery := "  WITH TREE (PRODUTO, PRODUTO2, DESC_PRODUTO, COMPONENTE, DESC_COMPONENTE, QUANTIDADE, ARMAZEM, NIVEL) AS  " + CHR(13)+CHR(10)
    cQuery += " ( SELECT         " + CHR(13)+CHR(10)
    cQuery += "   SG1.G1_COD	 " + CHR(13)+CHR(10)
    cQuery += " , SG1.G1_COD     " + CHR(13)+CHR(10)
    cQuery += " , SB1.B1_DESC    " + CHR(13)+CHR(10)
    cQuery += " , SG1.G1_COMP    " + CHR(13)+CHR(10)
    cQuery += " , B1.B1_DESC     " + CHR(13)+CHR(10)
    cQuery += " , SG1.G1_QUANT   " + CHR(13)+CHR(10)
    cQuery += " , B1.B1_LOCPAD   " + CHR(13)+CHR(10)
    cQuery += " , 0 AS NIVEL     " + CHR(13)+CHR(10)
    cQuery += 	"FROM "+CHR(13)+CHR(10)
    //FROM SG1010 (NOLOCK)
    cQuery += RetSqlName("SG1")+" SG1  (NOLOCK) "+CHR(13)+CHR(10)
    cQuery += "INNER JOIN SB1010 SB1 ON SG1.G1_COD = SB1.B1_COD AND SB1.B1_FILIAL = '' AND SB1.D_E_L_E_T_ = '' " + CHR(13)+CHR(10)
    cQuery += "INNER JOIN SB1010 B1  ON B1.B1_COD = SG1.G1_COMP AND B1.B1_FILIAL = '' AND B1.D_E_L_E_T_ = '' " + CHR(13)+CHR(10)
    cQuery += "WHERE " + CHR(13)+CHR(10)
    cQuery += " G1_COMP NOT LIKE 'BN%'           " + CHR(13)+CHR(10)
    cQuery += " AND SG1.D_E_L_E_T_ = ''          " + CHR(13)+CHR(10)
    cQuery += " AND SG1.G1_FILIAL = ''           " + CHR(13)+CHR(10)
    cQuery += " AND SB1.B1_LOCPAD IN ('01', '10')" + CHR(13)+CHR(10)
    cQuery += " AND SB1.B1_MSBLQL = 2            " + CHR(13)+CHR(10)
    cQuery += "UNION ALL " + CHR(13)+CHR(10)
    cQuery += "  SELECT                 " + CHR(13)+CHR(10)
    cQuery += "   TREE.PRODUTO          " + CHR(13)+CHR(10)
    cQuery += "   , SG1.G1_COD          " + CHR(13)+CHR(10)
    cQuery += "   , TREE.DESC_PRODUTO   " + CHR(13)+CHR(10)
    cQuery += "   , SG1.G1_COMP         " + CHR(13)+CHR(10)
    cQuery += "   , B1.B1_DESC          " + CHR(13)+CHR(10)
    cQuery += "   , SG1.G1_QUANT        " + CHR(13)+CHR(10)
    cQuery += "   , B1.B1_LOCPAD        " + CHR(13)+CHR(10)
    cQuery += "   , TREE.NIVEL + 1      " + CHR(13)+CHR(10)
    cQuery += "FROM "+CHR(13)+CHR(10)
    // 	FROM SG1010 (NOLOCK)
    cQuery += RetSqlName("SG1")+" SG1  (NOLOCK)"+CHR(13)+CHR(10)
    cQuery += "  INNER JOIN SB1010 SB1 (NOLOCK) ON SG1.G1_COD = SB1.B1_COD AND SB1.B1_FILIAL = '' AND SB1.D_E_L_E_T_ = '' "+CHR(13)+CHR(10)
    cQuery += "  INNER JOIN TREE ON TREE.COMPONENTE = SG1.G1_COD "+CHR(13)+CHR(10)
    cQuery += "  INNER JOIN SB1010 B1 (NOLOCK) ON B1.B1_COD = SG1.G1_COMP AND B1.B1_FILIAL = '' AND B1.D_E_L_E_T_ = '' "+CHR(13)+CHR(10)
    cQuery += "  WHERE SG1.G1_COMP NOT LIKE 'BN%' AND SG1.D_E_L_E_T_ = '' AND SG1.G1_FILIAL = '') "+CHR(13)+CHR(10)

    cQuery += " SELECT DISTINCT PRODUTO, PRODUTO2, DESC_PRODUTO, COMPONENTE, DESC_COMPONENTE, QUANTIDADE, NIVEL, "+CHR(13)+CHR(10)
    cQuery += " (SELECT SUM(C1.C1_QUANT - C1.C1_QUJE) FROM SC1010 C1 (NOLOCK) WHERE C1.D_E_L_E_T_='' AND C1.C1_QUJE < C1.C1_QUANT AND C1.C1_RESIDUO <> 'S' AND C1.C1_PRODUTO = COMPONENTE) AS QTD_SC, "+CHR(13)+CHR(10)
    cQuery += " (SELECT SUM(SC7.C7_QUANT - SC7.C7_QUJE) FROM SC7010 SC7 (NOLOCK) WHERE SC7.D_E_L_E_T_='' AND SC7.C7_PRODUTO = COMPONENTE AND (SC7.C7_QUANT - SC7.C7_QUJE > 0) AND SC7.C7_RESIDUO<>'S') AS QTD_PD_COMPRA, "+CHR(13)+CHR(10)
    cQuery += " COALESCE((SELECT SUM(SC2.C2_QUANT - SC2.C2_QUJE - SC2.C2_PERDA) FROM SC2010 SC2 (NOLOCK) WHERE SC2.C2_PRODUTO = COMPONENTE AND SC2.C2_DATRF='' AND SC2.C2_LOCAL='10' AND SC2.D_E_L_E_T_='' AND SC2.C2_STATUS IN ('N', '')), 0) AS QTD_OP, "+CHR(13)+CHR(10)
    cQuery += " COALESCE((SELECT SUM(BF.BF_QUANT - BF.BF_EMPENHO) FROM SBF010 BF (NOLOCK) WHERE BF.BF_PRODUTO = COMPONENTE AND BF.BF_LOCAL = '10' AND BF.D_E_L_E_T_ = ''), 0) AS QTD_ESTOQUE, "+CHR(13)+CHR(10)
    cQuery += " COALESCE((SELECT SUM(SBF.BF_QUANT - SBF.BF_EMPENHO) FROM SBF010 SBF (NOLOCK) WHERE SBF.BF_PRODUTO = COMPONENTE AND SBF.BF_LOCAL = '98' AND SBF.D_E_L_E_T_ = ''), 0) AS QTD_INSPECAO, "+CHR(13)+CHR(10)
    cQuery += " (SELECT SUM(DA_SALDO) FROM SDA010  DA (NOLOCK) WHERE DA.DA_PRODUTO = COMPONENTE AND DA.DA_SALDO <> 0 AND DA.D_E_L_E_T_ = '' AND DA.DA_LOCAL = '10') AS QTD_ENDERECAR, "+CHR(13)+CHR(10)
    cQuery += " (SELECT SUM(D4_QUANT) FROM SD4010 SDA (NOLOCK) WHERE SDA.D4_COD = COMPONENTE AND SDA.D4_LOTECTL = '' AND SDA.D_E_L_E_T_ = '' AND SDA.D4_LOCAL = '10') AS QTD_EMPENHADA "+CHR(13)+CHR(10)
    cQuery += " FROM TREE "+CHR(13)+CHR(10)
    cQuery += " WHERE ARMAZEM = '10' "+CHR(13)+CHR(10)
    //ORDER BY PRODUTO, COMPONENTE
	//cQuery := ChangeQuery(cQuery)
  
	MemoWrite("LOGS_PROGRAMAS\PCP\PLESTRU01.SQL", cQuery )	

	dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery ), "cAliasQry" , .T. , .F. )	
	dbSelectArea( "cAliasQry" )
	dbGotop()
 
    DBSelectArea(cAliasTMP)
    cAliasQry->(DbGoTop())
    While !cAliasQry->(Eof())
        //Add Temporary Table
        If (RecLock(cAliasTMP, .T.))
           
            (cAliasTMP)->PRODUTO   := cAliasQry->PRODUTO
            (cAliasTMP)->NIVEL     := cAliasQry->NIVEL
            (cAliasTMP)->PRODUTO2  := cAliasQry->PRODUTO2
            (cAliasTMP)->DESCPROD  := cAliasQry->DESC_PRODUTO
            (cAliasTMP)->DESCPRO2  := cAliasQry->DESC_PRODUTO
            (cAliasTMP)->COMPONET  := cAliasQry->COMPONENTE
            (cAliasTMP)->DESCCOMP  := cAliasQry->DESC_COMPONENTE
            (cAliasTMP)->QUANTIDE  := cAliasQry->QUANTIDADE
            //(cAliasTMP)->NIVEL     := cAliasQry->NIVEL
            (cAliasTMP)->QTDSC     := cAliasQry->QTD_SC
            (cAliasTMP)->QTDPDCMP  := cAliasQry->QTD_PD_COMPRA
            (cAliasTMP)->QTDOP     := cAliasQry->QTD_OP
            (cAliasTMP)->QTDESTQE  := cAliasQry->QTD_ESTOQUE
            (cAliasTMP)->QTINSPCAO := cAliasQry->QTD_INSPECAO
            (cAliasTMP)->QTENDECAR := cAliasQry->QTD_ENDERECAR
            (cAliasTMP)->QTEMPHADA := cAliasQry->QTD_EMPENHADA
            (cAliasTMP)->(MsUnlock())
        EndIf
        
        cAliasQry->(DBSkip())
    EndDo
 
    (cAliasTMP)->(DbGoTop())
 
    oBrowse:= FWMBrowse():New()
    oBrowse:SetDescription("Planila de Estruturas")

    oBrowse:SetAlias(cAliasTMP) //Temporary Table Alias
    oBrowse:SetTemporary(.T.) //Using Temporary Table
    oBrowse:SetUseFilter(.T.) //Using Filter
    oBrowse:OptionReport(.F.) //Disable Report Print
    oBrowse:SetColumns(aColumns)
    oBrowse:SetFieldFilter(aFilter) //Set Filters

    oBrowse:Activate(/*oDlg*/) //Caso deseje incluir em um componente de Tela (Dialog, Panel, etc), informar como parâmetro o objeto
 
    oFWFilter := oBrowse:FWFilter()
    oFWFilter:DisableSave(.T.) //Disable Save Button
 
    //Delete Temporary Table
    oTempTable:Delete()

    //oBrw1:Forcerefresh() 
    //SYSREFRESH() 


Return
/*

    BeginSql Alias cAliasQry
                WITH TREE (PRODUTO, PRODUTO2, DESC_PRODUTO, COMPONENTE, DESC_COMPONENTE, QUANTIDADE, ARMAZEM, NIVEL) AS 
                ( SELECT
            		SG1010.G1_COD	
            		, SG1010.G1_COD
            		, SB1010.B1_DESC
            		, SG1010.G1_COMP
            		, B1.B1_DESC
            		, SG1010.G1_QUANT
            		, B1.B1_LOCPAD
            		, 0 AS NIVEL
            	FROM SG1010 (NOLOCK)
            		INNER JOIN SB1010 (NOLOCK) ON SG1010.G1_COD = SB1010.B1_COD AND SB1010.B1_FILIAL = '' AND SB1010.D_E_L_E_T_ = ''
            		INNER JOIN SB1010 B1 (NOLOCK) ON B1.B1_COD = SG1010.G1_COMP AND B1.B1_FILIAL = '' AND B1.D_E_L_E_T_ = ''
            	WHERE
            		G1_COMP NOT LIKE 'BN%'
            		AND SG1010.D_E_L_E_T_ = ''
            		AND SG1010.G1_FILIAL = ''
            		AND SB1010.B1_LOCPAD IN ('01', '10')
            		AND SB1010.B1_MSBLQL = 2
            	UNION ALL
            	SELECT
            		TREE.PRODUTO
            		, SG1010.G1_COD
            		, TREE.DESC_PRODUTO
            		, SG1010.G1_COMP
            		, B1.B1_DESC
            		, SG1010.G1_QUANT
            		, B1.B1_LOCPAD
            		, TREE.NIVEL + 1
            	FROM SG1010 (NOLOCK)
            		INNER JOIN SB1010 (NOLOCK) ON SG1010.G1_COD = SB1010.B1_COD AND SB1010.B1_FILIAL = '' AND SB1010.D_E_L_E_T_ = ''
            		INNER JOIN TREE ON TREE.COMPONENTE = G1_COD
            		INNER JOIN SB1010 B1 (NOLOCK) ON B1.B1_COD = SG1010.G1_COMP AND B1.B1_FILIAL = '' AND B1.D_E_L_E_T_ = ''
            	WHERE
            		SG1010.G1_COMP NOT LIKE 'BN%'
            		AND SG1010.D_E_L_E_T_ = ''
            		AND SG1010.G1_FILIAL = ''
            )
            SELECT DISTINCT PRODUTO, PRODUTO2, DESC_PRODUTO, COMPONENTE, DESC_COMPONENTE, QUANTIDADE, NIVEL,
            (SELECT SUM(C1_QUANT - C1_QUJE) FROM SC1010 C1 (NOLOCK) WHERE C1.D_E_L_E_T_='' AND C1_QUJE < C1_QUANT AND C1_RESIDUO <> 'S' AND C1_PRODUTO = COMPONENTE) AS QTD_SC,
            (SELECT SUM(C7_QUANT - C7_QUJE) FROM SC7010 (NOLOCK) WHERE D_E_L_E_T_='' AND C7_PRODUTO = COMPONENTE AND (C7_QUANT - C7_QUJE > 0) AND C7_RESIDUO<>'S') AS QTD_PD_COMPRA,
            COALESCE((SELECT SUM(C2_QUANT - C2_QUJE - C2_PERDA) FROM SC2010 (NOLOCK) WHERE C2_PRODUTO = COMPONENTE AND C2_DATRF='' AND C2_LOCAL='10' AND D_E_L_E_T_='' AND C2_STATUS IN ('N', '')), 0) AS QTD_OP,
            COALESCE((SELECT SUM(BF_QUANT - BF_EMPENHO) FROM SBF010 (NOLOCK) WHERE BF_PRODUTO = COMPONENTE AND BF_LOCAL = '10' AND D_E_L_E_T_ = ''), 0) AS QTD_ESTOQUE,
            COALESCE((SELECT SUM(BF_QUANT - BF_EMPENHO) FROM SBF010 (NOLOCK) WHERE BF_PRODUTO = COMPONENTE AND BF_LOCAL = '98' AND D_E_L_E_T_ = ''), 0) AS QTD_INSPECAO,
            (SELECT SUM(DA_SALDO) FROM SDA010 (NOLOCK) WHERE DA_PRODUTO = COMPONENTE AND DA_SALDO <> 0 AND D_E_L_E_T_ = '' AND DA_LOCAL = '10') AS QTD_ENDERECAR,
            (SELECT SUM(D4_QUANT) FROM SD4010 (NOLOCK) WHERE D4_COD = COMPONENTE AND D4_LOTECTL = '' AND D_E_L_E_T_ = '' AND D4_LOCAL = '10') AS QTD_EMPENHADA
            FROM TREE
            WHERE ARMAZEM = '10'
            //ORDER BY PRODUTO, COMPONENTE
          
	EndSql
*/
