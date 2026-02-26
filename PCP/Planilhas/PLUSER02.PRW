#Include 'Totvs.ch'
#Include "RwMake.ch"
#Include "Totvs.ch"
#INCLUDE "TOPCONN.CH"  

 
User Function PLUSER02()
    //Variaveis local
    Local aStruct   :={}     //Fields StructaStruct := {}
    Local aColumns  :={}  //Browse Columns
    Local aFilter   :={}  //Filter Array
    Local nX        := 0     //As Numeric //Loop Control
	//Local PRODUCAO_MESES := 1
    Local CMMDE  := Dtos(Date()+243) //"20200926"
    Local CMMATE := Dtos(Date())     // "20210126"
    Local cUserName :=""
    Private cCodUser    := RetCodUsr()
    Private cNamUser 	:= UsrRetName( cCodUser )//Retorna o nome do us  


    If cCodUser ="000012"
        cUserName :="03"
    Elseif cCodUser ="000029"
        cUserName :="04"
    Elseif cCodUser ="000559"
        cUserName :="02"
    EndIf
    // 000012 -> Alessandra
    // 000029 -> Edna
    // 000561 ->Isis

    /*
    WHEN '01' THEN 'ERNANI'
    WHEN '02' THEN 'ISIS'
    WHEN '03' THEN 'ALESSANDRA'
    WHEN '04' THEN 'EDNA'
    WHEN '05' THEN 'ANDREIA'

    */
 
    AAdd(aStruct,{"CODIGO"          ,"C", 12 , 00,"CODIGO"          ,"!@"})         // 1
    AAdd(aStruct,{"DESCRICAO"       ,"C", 70 , 00,"DESCRICAO"       ,"!@"})         // 2
    AAdd(aStruct,{"RESPON"          ,"C", 10 , 00,"RESPONSAVÉL"     ,"!@"})         // 3
    AAdd(aStruct,{"TIPO	"           ,"C", 04 , 00,"TIPO	"           ,"!@"})         // 4
    AAdd(aStruct,{"GRUPO"           ,"C", 12 , 00,"GRUPO"           ,"!@"})         // 5
    AAdd(aStruct,{"QTSTOQUE"        ,"N", 15 , 02,"QTDE ESTOQUE"    ,"@R 9999"})    // 6
    AAdd(aStruct,{"QTENDE"          ,"N", 15 , 02,"QTDE ENDEREÇAR"  ,"@R 9999"})	// 7
    AAdd(aStruct,{"QTDPV	"       ,"N", 15 , 02,"QTDE PD VENDA"   ,"@R 9999"})    // 8
    AAdd(aStruct,{"QTDEOP	"       ,"N", 15 , 02,"QTD_OPS	"       ,"@R 9999"})    // 9
    AAdd(aStruct,{"TOTAL"           ,"N", 15 , 02,"TOTAL"           ,"@R 9999"})    //10
    AAdd(aStruct,{"CMM"             ,"N", 15 , 02,"CMM"             ,"@R 9999"})    //11
    AAdd(aStruct,{"PROGRAMAR"       ,"N", 15 , 02,"PROGRAMAR"       ,"@R 9999"})    //12
    AAdd(aStruct,{"PTPEDIDO"        ,"N", 15 , 02,"PONTO PEDIDO"    ,"@R 9999"})    //13
    AAdd(aStruct,{"ESTMAX"          ,"N", 15 , 02,"ESTOQUE MAX"     ,"@R 9999"})    //14
    AAdd(aStruct,{"LOTMIN"          ,"N", 15 , 02,"LOTE MIN"        ,"@R 9999"})    //15 
    AAdd(aStruct,{"NUM_OPS	"       ,"N", 15 , 02,"NUM_OPS	"       ,"@R 9999"})    //16
    AAdd(aStruct,{"QTD_OPS	"       ,"N", 15 , 02,"QTD_OPS	"       ,"@R 9999"})    //17
    AAdd(aStruct,{"FAT_2017	"       ,"N", 15 , 02,"FAT_2017	"       ,"@R 9999"})    //18
    AAdd(aStruct,{"FAT_2018	"       ,"N", 15 , 02,"FAT_2018	"       ,"@R 9999"})    //19
    AAdd(aStruct,{"FAT_2019	"       ,"N", 15 , 02,"FAT_2019	"       ,"@R 9999"})    //20
    AAdd(aStruct,{"FAT_2020	"       ,"N", 15 , 02,"FAT_2020	"       ,"@R 9999"})    //21
    AAdd(aStruct,{"FAT_2021	"       ,"N", 15 , 02,"FAT_2021"        ,"@R 9999"})    //22

   
    /*
        CODIGO	                CODIGO	
        DESCRICAO	            DESCRICAO	
        RESPONSAVEL	            RESPONSAVEL	
        TIPO	                TIPO	
        GRUPO	                GRUPO	
        QTD_ESTOQUE	            QTD_ESTOQUE	
        QTD_ENDERECAR	        QTD_ENDERECAR	
        QTD_PV	                QTD_PV	
        QTD_OP	                QTD_OP	
        TOTAL	                TOTAL	
        CMM	                    CMM	
        PROGRAMAR	            PROGRAMAR	
        PONTO_PEDIDO	        PONTO_PEDIDO	
        ESTQ_MAX	            ESTQ_MAX	
        LOTE_MIN	            LOTE_MIN	
        NUM_OPS	                NUM_OPS	
        QTD_OPS	                QTD_OPS	
        FAT_2017	            FAT_2017	
        FAT_2018	            FAT_2018	
        FAT_2019	            FAT_2019	
        FAT_2020	            FAT_2020	
        FAT_2021                FAT_2021
    */
   
    //Set Columns
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
    oTempTable:AddIndex("INDEX1",{"CODIGO"})
   
    //Create
    oTempTable:Create()
    cAliasTmp := oTemptable:GetAlias()
 
    aHeadCols := {}
    oBrowse    := NIL
    aAccounts := {}
    cAliasQry := GetNextAlias()

    //Local _cAlias   := GetNextAlias()

		BeginSql Alias cAliasQry
        /*
        

        */

          SELECT 
                 CODIGO
                ,DESCRICAO
                ,TIPO
                ,GRUPO
                ,PONTO_PEDIDO
                ,ESTQ_MAX
                ,LOTE_MIN
                ,QTD_ESTOQUE
                ,RESPONSAVEL
                ,QTD_PV
                ,QTD_OP
                ,QTD_ENDERECAR	
                ,CMM
                ,FAT_2017
                ,FAT_2018	
                ,FAT_2019	
                ,FAT_2020	
                ,FAT_2021
                ,QTD_ESTOQUE + QTD_ENDERECAR + QTD_OP - QTD_PV AS TOTAL
                ,CASE LOTE_MIN WHEN '0' THEN '0' ELSE FLOOR((ESTQ_MAX - (QTD_ESTOQUE + QTD_ENDERECAR + QTD_OP - QTD_PV))/LOTE_MIN) END AS NUM_OPS
                ,CASE LOTE_MIN WHEN '0' THEN '0' ELSE FLOOR((ESTQ_MAX - (QTD_ESTOQUE + QTD_ENDERECAR + QTD_OP - QTD_PV))/LOTE_MIN) END * LOTE_MIN AS QTD_OPS
                , (CMM * 1) - (QTD_ESTOQUE + QTD_ENDERECAR + QTD_OP - QTD_PV) AS PROGRAMAR
            FROM (
                SELECT
                    REPLACE(B1_COD, ' ', '') AS CODIGO,
                    B1_DESC AS DESCRICAO,
                    B1_TIPO AS TIPO,
                    B1_GRUPO AS GRUPO,
                    B1_EMIN AS PONTO_PEDIDO,
                    B1_EMAX AS ESTQ_MAX,
                    B1_LM AS LOTE_MIN,
                    COALESCE((SELECT SUM(BF_QUANT - BF_EMPENHO) FROM %Table:SBF% SBF (NOLOCK) WHERE  SBF.BF_FILIAL = '01' AND SBF.BF_PRODUTO = B1_COD AND SBF.BF_LOCAL = '01'), 0) AS QTD_ESTOQUE,
                    COALESCE((SELECT SUM(C2_QUANT - C2_QUJE - C2_PERDA) FROM %Table:SC2% SC2 (NOLOCK) WHERE  SC2.C2_FILIAL = '01' AND SC2.C2_PRODUTO = B1_COD AND SC2.C2_DATRF='' AND SC2.C2_LOCAL='01' AND SC2.D_E_L_E_T_='' AND SC2.C2_STATUS IN ('N', '')), 0) AS QTD_OP,
                    CASE B1_XRESP
                        WHEN '01' THEN 'ERNANI'
                        WHEN '02' THEN 'ISIS'
                        WHEN '03' THEN 'ALESSANDRA'
                        WHEN '04' THEN 'EDNA'
                        WHEN '05' THEN 'ANDREIA'
                    END AS RESPONSAVEL,
                    COALESCE(
                    (SELECT SUM(C6_QTDVEN - C6_QTDENT) FROM %Table:SC6% SC6 (NOLOCK) INNER JOIN %Table:SC5% SC5 (NOLOCK) ON SC6.C6_NUM = SC5.C5_NUM AND SC5.C5_FILIAL = '01' 
                    WHERE  
                    SC6.C6_FILIAL = '01' AND SC6.C6_PRODUTO = B1_COD AND SC6.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' AND SC6.C6_BLQ <> 'R' AND 
                    SC6.C6_QTDENT < SC6.C6_QTDVEN AND SC5.C5_LIBEROK = 'S' AND ((SC6.C6_TES LIKE '5%') OR (SC6.C6_TES IN ('701', '702', '703')))) - COALESCE((SELECT SUM(C9_QTDLIB) 
                    FROM %Table:SC9% SC9 (NOLOCK) INNER JOIN %Table:SC6% SC6B ON SC6B.C6_NUM = SC9.C9_PEDIDO AND SC6B.C6_PRODUTO = SC9.C9_PRODUTO AND SC6B.C6_ITEM = SC9.C9_ITEM AND SC6B.D_E_L_E_T_ = '' 
                    INNER JOIN %Table:SC5% SC5B (NOLOCK) ON SC5B.D_E_L_E_T_ = '' AND C9_PEDIDO = C5_NUM AND C5_LIBEROK = 'S' WHERE  SC9.C9_FILIAL = '01' AND SC9.C9_PRODUTO=B1_COD AND SC9.D_E_L_E_T_='' 
                    AND SC9.C9_LOTECTL<>'' AND SC9.C9_NFISCAL='' AND ((SC6B.C6_TES LIKE '5%') OR (SC6B.C6_TES IN ('701','702','703')))), 0), 0) AS QTD_PV,

                    (SELECT COALESCE(SUM(DA_SALDO), 0) FROM %Table:SDA% SDA (NOLOCK) WHERE  SDA.DA_FILIAL = '01' AND SDA.DA_PRODUTO = B1_COD AND SDA.DA_SALDO <> 0 AND D_E_L_E_T_ = '' AND SDA.DA_LOCAL = B1_LOCPAD) AS QTD_ENDERECAR,
                    COALESCE((SELECT (SUM(D2_QUANT)) FROM %Table:SD2% SD2 (NOLOCK) INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.F4_FILIAL = '' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' WHERE  SD2.D2_FILIAL = '01' AND SD2.D2_COD=B1_COD AND SD2.D2_TIPO IN ('N','C','P') AND SD2.D_E_L_E_T_='' AND SD2.D2_EMISSAO BETWEEN '20160101' AND '20161231'), 0) AS FAT_2017,
                    COALESCE((SELECT (SUM(D2_QUANT)) FROM %Table:SD2% SD2 (NOLOCK) INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.F4_FILIAL = '' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' WHERE  SD2.D2_FILIAL = '01' AND SD2.D2_COD=B1_COD AND SD2.D2_TIPO IN ('N','C','P') AND SD2.D_E_L_E_T_='' AND SD2.D2_EMISSAO BETWEEN '20170101' AND '20171231'), 0) AS FAT_2018,
                    COALESCE((SELECT (SUM(D2_QUANT)) FROM %Table:SD2% SD2 (NOLOCK) INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.F4_FILIAL = '' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' WHERE  SD2.D2_FILIAL = '01' AND SD2.D2_COD=B1_COD AND SD2.D2_TIPO IN ('N','C','P') AND SD2.D_E_L_E_T_='' AND SD2.D2_EMISSAO BETWEEN '20180101' AND '20181231'), 0) AS FAT_2019,
                    COALESCE((SELECT (SUM(D2_QUANT)) FROM %Table:SD2% SD2 (NOLOCK) INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.F4_FILIAL = '' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' WHERE  SD2.D2_FILIAL = '01' AND SD2.D2_COD=B1_COD AND SD2.D2_TIPO IN ('N','C','P') AND SD2.D_E_L_E_T_='' AND SD2.D2_EMISSAO BETWEEN '20190101' AND '20191231'), 0) AS FAT_2020,
                    COALESCE((SELECT (SUM(D2_QUANT)) FROM %Table:SD2% SD2 (NOLOCK) INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SF4.F4_FILIAL = '' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' WHERE  SD2.D2_FILIAL = '01' AND SD2.D2_COD=B1_COD AND SD2.D2_TIPO IN ('N','C','P') AND SD2.D_E_L_E_T_='' AND SD2.D2_EMISSAO BETWEEN '20200101' AND '20201231'), 0) AS FAT_2021,
                    COALESCE((SELECT SUM(C6_QTDVEN) / 4 FROM %Table:SC6% SC6 (NOLOCK) JOIN  %Table:SC5% SC5 (NOLOCK) ON SC6.C6_NUM = SC5.C5_NUM WHERE  SC6.D_E_L_E_T_ = '' AND C6_PRODUTO = B1_COD AND C5_TIPO = 'N' AND SC6.C6_BLQ <> 'R' AND ((SC6.C6_TES LIKE '5%') OR (SC6.C6_TES IN ('701', '702', '703'))) AND SC5.C5_EMISSAO BETWEEN "CMMDE" AND "CMMATE"), 0) AS CMM
                FROM %Table:SB1%  SB1 (NOLOCK)
                //WHERE
                WHERE
                    SB1.D_E_L_E_T_ = ''
                    AND SB1.B1_FILIAL = ''
                    AND (SB1.B1_TIPO='PA')
                    AND (SB1.B1_LOCPAD='01')
                    AND (SB1.B1_XRESP=%Exp:cUserName%)
                    AND SB1.B1_MSBLQL IN ('0', '2')
            ) AS RESULTSET
            ORDER BY CODIGO
		EndSql

		MemoWrite("LOGS_PROGRAMAS\PCP\PRODUTOS.sql",GetLastQuery()[2])
 
    //nOrder := 01
 
    DBSelectArea(cAliasTMP)
    (cAliasQry)->(DbGoTop())
    While !(cAliasQry)->(Eof())
        //Add Temporary Table
        If (RecLock(cAliasTMP, .T.))
        
            (cAliasTMP)->CODIGO    := (cAliasQry)->CODIGO               // 1
            (cAliasTMP)->DESCRICAO := (cAliasQry)->DESCRICAO            // 2
            (cAliasTMP)->RESPON    := (cAliasQry)->RESPONSAVEL          // 3
            (cAliasTMP)->TIPO      := (cAliasQry)->TIPO                 // 4
            (cAliasTMP)->GRUPO     := (cAliasQry)->GRUPO                // 5
            (cAliasTMP)->QTSTOQUE  := (cAliasQry)->QTD_ESTOQUE          // 6
            (cAliasTMP)->QTENDE    := (cAliasQry)->QTD_ENDERECAR        // 7
            (cAliasTMP)->QTDPV     := (cAliasQry)->QTD_PV               // 8
            (cAliasTMP)->QTDEOP    := (cAliasQry)->QTD_OP               // 9
            (cAliasTMP)->TOTAL     := (cAliasQry)->TOTAL                //10
            (cAliasTMP)->CMM       := (cAliasQry)->CMM                  //11
            (cAliasTMP)->PROGRAMAR := (cAliasQry)->PROGRAMAR            //12
            (cAliasTMP)->PTPEDIDO  := (cAliasQry)->PONTO_PEDIDO         //13
            (cAliasTMP)->ESTMAX    := (cAliasQry)->ESTQ_MAX             //14
            (cAliasTMP)->LOTMIN    := (cAliasQry)->LOTE_MIN             //15
            (cAliasTMP)->NUM_OPS   := (cAliasQry)->NUM_OPS              //16
            (cAliasTMP)->QTD_OPS   := (cAliasQry)->QTD_OPS              //17
            (cAliasTMP)->FAT_2017  := (cAliasQry)->FAT_2017             //18
            (cAliasTMP)->FAT_2018  := (cAliasQry)->FAT_2018             //19
            (cAliasTMP)->FAT_2019  := (cAliasQry)->FAT_2019             //20
            (cAliasTMP)->FAT_2020  := (cAliasQry)->FAT_2020             //21
            (cAliasTMP)->FAT_2021  := (cAliasQry)->FAT_2021             //22
      
            (cAliasTMP)->(MsUnlock())
        EndIf
        
        (cAliasQry)->(DBSkip())
    EndDo
 
    (cAliasTMP)->(DbGoTop())
 
    oBrowse:= FWMBrowse():New()
    oBrowse:SetDescription("Planila de Produtos   "+alltrim(Upper(cNamUser)))

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
Return
