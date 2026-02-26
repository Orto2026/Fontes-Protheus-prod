/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºRotina ³  MT415EFT     ºAutor  ³ Samuel Miranda  º Data ³ 17/06/2020  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDescricao ³ Ponto de entrada para informar se o cliente tem    	    º±±
±±º			debitos em aberto   	 				              º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso    ³ Ortosintese - Comercial						         º±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ	
*/ 

User Function MT415EFT ()
     
     Local aArea        := GetArea()
     Local lRet         := .T.
     Local xCliente     := SCJ->CJ_CLIENTE
     Local cQuery       := ""
     Local dDataBase    := Date()  
     dVcmtReal		    := dDataBase + 5
     
    cQuery := "SELECT"   
    cQuery += "E1_PREFIXO, "
    cQuery += "E1_NUM, "
    cQuery += "E1_CLIENTE, "
    cQuery += "E1_LOJA, "
    cQuery += "E1_NOMCLI,"  
    cQuery += "E1_EMISSAO AS E1_EMISSAO, "
    cQuery += "E1_VENCREA AS E1_VENCREA, "
    cQuery += "E1_VALOR AS E1_VALOR, "
    cQuery += "E1_SALDO"
    cQuery += "FROM"
    cQuery += RetSqlName( 'SE1' ) + " SE1 "
    cQuery += "INNER JOIN SA1010 SA1 ON A1_FILIAL = '  '  AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = ''  "
    cQuery += "WHERE"   
    cQuery += "E1_FILIAL = '01'  AND "
    cQuery += "E1_CLIENTE = '" + xCliente + "'  AND "
    cQuery += "E1_NUM BETWEEN ' ' AND 'ZZZZZZZZZ'  AND "
    cQuery += "E1_PREFIXO BETWEEN ' ' AND 'ZZ'  AND "
    cQuery += "E1_EMISSAO BETWEEN '20140101' AND '20490101'   AND "
    cQuery += "E1_VENCREA < '20200605'  AND "
    cQuery += " E1_VENCREA < '"+(DTOS( dVcmtReal)) +"' AND " 
    cQuery += "E1_SALDO <> 0   AND 
    cQuery += "E1_TIPO NOT IN ('NCC','RA')   AND "
    cQuery += "SE1.D_E_L_E_T_ = ''  "
    cQuery += "ORDER BY E1_CLIENTE "
    cQuery := ChangeQuery( cQuery )

     If ( SELECT("CQRY") ) > 0
          dbSelectArea("CQRY")
          CQRY->(dbCloseArea())
     EndIf   
    //TcQuery cQuery Alias CQRY new
    //DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CQRY",.T.,.T.)
	
	dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),"CQRY", .F., .T.)
	
    nRec	:= 0
	dbSelectArea("CQRY")
	dbGotop()
	CQRY->(dbEval({ || nRec++ },,{||!Eof()} ))
	dbGoTop()

    If nRec > 0
		dbSelectArea("CQRY")
		dbCloseArea()
		Alert("O Cliente possui debitos em aberto." ,"Verifique !")
    EndIf
    //Percorrer os itens     
         
    //CQRY->(dbclosearea())
     If (SELECT("CQRY")) > 0
          CQRY->(dbCloseArea())
     EndIf 
     RestArea(aArea)

Return lRet 