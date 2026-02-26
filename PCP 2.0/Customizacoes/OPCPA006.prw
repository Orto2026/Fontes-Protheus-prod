#Include "Protheus.ch"
#Include "FWMVCDef.ch"
#Include "TopConn.ch"
#Include "ParmType.ch"
#Include "RwMake.ch" 
#Include "Totvs.ch"
#Include "FileIo.ch"
#Include "TbiConn.ch"
#Include "Msole.ch"
 //Parametro do MSExecAuto Opção: 3=Incluir; 4=Alterar; 5=Excluir;
 // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

User Function OPCPAP006()

    Private _cLocProc := ""
	Private _cLocDest := ""
	Private _cEndDest := ""

	//_cLocProcEmp := GetMV("MV_XLCEMPEN",,"91")
	//_cLocProcSld := GetMV("MV_XLCCONSU",,"11")
	//_cLocDest    := SuperGetMv("MV_XLCDEST")//,,"97")
    //_cLocDest    := SuperGetMv("MV_XLCDESTI",,"97")
	//_cEndDest    := SuperGetMv("MV_XENDDEST",,"FABRICA") //   OP          PRODUTO        LOTE    AMZ  QTDE QTDE DTVALID  
	//                    1				02			03	      04 5 6       07		 08        09     10
	//Private nItens := {"39884901001","MP000002","22L000164","10",1,1,"21/10/4845","P1 080103","97","FABRICA"} 
	// P2 020218     {"41208401004","45715208","20G001302","10",11,11,"31/10/2031"} // P2 020218   
	//					op             Pr
	Private nItens := {"41208401004","45715208","21C000967","10",1,1,"20311130","P2 020210","97","FABRICA"} 
	//                                             LOTE=22A000121             END = P2 010501  
	// 	P2 020210                  
	// OP               = 41208401004   - D4_OP  	  // Número da ordem de produção.
	// Produto          = 45715208      - D4_COD 	  // Código identificador do produto junto ao sistema.
	// Armazém          = 10            - D4_LOCAL 	  // Código do Armazem do Empenho do Produto
	// Qtde - Empenho   = 11            - D4_QTDEORI  // Quantidade original de requisiçöes empenhadas.
	// Saldo de Empenho = 11            - D4_QUANT    // Saldo do empenho.
	//Produto = MP000002
	//AMZ = 10
	//Dte Empenho = 29/06/23
	//Qtde Empenho = 0,25
	//Sal. Empenho = 0,25
	//Lote = 20/10/0843  validade = 31/12/49
	EXCLUIEMP(nItens)


Return()

Static Function EXCLUIEMP(nItens)
Local aVetor      := ACLONE( nItens )
Local aEmpen      := {}
Local nOpc        := 3 //Inclusao
Local _cPath      := "LOGS_PROGRAMAS\MsExecAuto\MATA380\"
Local _cNome      := "MATA681_U_" + RetCodUsr() + "_D_" + DToS(dDataBase) + "_H_" + Strtran(SubStr(Time(),1,5),":","")
Local _aMata380   := {}

PRIVATE lMsErroAuto := .F.

// Seta job para empresa e filial desejadas caso não seja chamada via menu do Protheus
//If !(Type("cFilAnt") == "C" .and. TCIsConnected())
//    RPCSetEnv("01","99",,,'PCP') //https://tdn.totvs.com/x/z-xn
//EndIf

//Ord Producao + Produto + Armazem
//D4_FILIAL + D4_OP + D4_COD + D4_LOCAL

/*
aVetor:={   {"D4_OP"      ,"41208401004" ,Nil},;
            {"D4_COD"     ,"45715208",Nil},; //COM O TAMANHO EXATO DO CAMPO
            {"D4_LOCAL"   ,"10"             ,Nil},;
            {"D4_DATA"    ,dDatabase        ,Nil},;
            {"D4_QTDEORI" ,11               ,Nil},;
            {"D4_QUANT"   ,11               ,Nil},;
            {"D4_TRT"     ,"   "            ,Nil},;
            {"D4_QTSEGUM" ,0                ,Nil}}
  */            
            // Inicializa
			_aMata380 := {}

			// Adiciona o produto
			Aadd(_aMata380,{"D4_COD","45715208",Nil})

			// Adiciona o armazem
			Aadd(_aMata380,{"D4_LOCAL","10",Nil})

			// Adiciona a ordem de produção
			Aadd(_aMata380,{"D4_OP","41208401004" ,Nil})

			//MSExecAuto({|x,y| MATA380(x,y)},_aMata380,5)
            /*
			If lMsErroAuto

                Alert("Erro")
				MostraErro(_cPath,_cNome)

				_cMsgErro := MemoRead(_cPath + _cNome)
				//Exit
            Else
                cCod := ""
                cAmz := "10"

                TRANSFEMP()
			EndIf
        */
     TRANSFEMP()
Return()

Static Function TRANSFEMP()

    Local aLista := ACLONE(nItens)
	Local _lContinua := .T.

	Local _cDocSD3 := ""
	Local _cTpConv := ""
	//Local _cPath := "LOGS_PROGRAMAS\OPCPA002\MsExecAuto\MATA261\"
	//Local _cNome := "MATA261_U_" + RetCodUsr() + "_D_" + DToS(dDataBase) + "_H_" + Strtran(SubStr(Time(),1,5),":","")

	Local _aMata261 := {}
	Local _aLinha := {}
	//Local _aTransfe := {}

	Local _nCount := 0
	Local _nConversa := 0
	Local _nQtdSegum := 0

	Local _dDataAtu := dDataBase
	Local _dDtVldOri := SToD("")
	Local _dDtVldDes := SToD("")

    DbSelectArea("SB1")     // DESCRIÇÃO GENÉRICA DO PRODUTO
    SB1->(DbSetOrder(1))    // B1_FILIAL+B1_COD

	DbSelectArea("SB2")     // SALDOS FÍSICO E FINANCEIRO
	SB2->(DbSetOrder(1))    // B2_FILIAL+B2_COD+B2_LOCAL

    DbSelectArea("SB8")     // SALDOS POR LOTE
    SB8->(DbSetOrder(1))    // B8_FILIAL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)+B8_LOTECTL+B8_NUMLOTE

    Private lMsErroAuto := .F.
	// Percorre todos os registros
	//For _nCount := 1 To Len(aLista)
		// Se for quantidade total ou parcial
		//If aLista[_nCount][N1_PROCESS] $ "1|2"
			// Inicializa as variaveis
			_aMata261 := {}
			_aLinha := {}

			// Busca o codigo
			_cDocSD3 := GetSxeNum("SD3","D3_DOC") //_fGetCodig("SD3","D3_DOC",2)

			// Adiciona no array
			Aadd(_aMata261,{_cDocSD3,_dDataAtu,Nil})

            //DbSelectArea("SB1")
			SB1->(DbSetOrder(1))	// B1_FILIAL+B1_COD
			SB1->(MsSeek(xFilial("SB1")+aLista[2]))

            //DbSelectArea("SB8")
			SB8->(DbSetOrder(3))	// B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
			If SB8->(DbSeek(xFilial("SB8")+aLista[2]+aLista[4]+aLista[3]))
				_dDtVldOri := SB8->B8_DTVALID
			EndIf

			If SB8->(MsSeek(xFilial("SB8")+aLista[2]+aLista[4]+Alltrim(aLista[3])))
				_dDtVldDes := SB8->B8_DTVALID
			EndIf
            _dDtVldOri  :=TABX(aLista[2],aLista[4],aLista[3])
            _dDtVldDes  :=TABX(aLista[2],aLista[4],aLista[3])

			_cTpConv := SB1->B1_TIPCONV
			_nConversa := SB1->B1_CONV
			
			If _nConversa <> 0     
				_nQtdSegum := IIF(_cTpConv == "M", aLista[5] * _nConversa , aLista[5] / _nConversa)
			Else
				_nQtdSegum := 0
			Endif
			//Autoriza o produto para transferência no armazem destino
			AdeqArmTrnsf(aLista[2], aLista[9])

			// Inclusão da origem do produto
			Aadd(_aLinha,{"D3_COD",SB1->B1_COD,Nil})		// 01 - D3_COD
			Aadd(_aLinha,{"D3_DESCRI",SB1->B1_DESC,Nil})	// 02 - D3_DESCRI
			Aadd(_aLinha,{"D3_UM",SB1->B1_UM,Nil})			// 03 - D3_UM
			Aadd(_aLinha,{"D3_LOCAL",aLista[4],Nil})		// 04 - D3_LOCAL
			Aadd(_aLinha,{"D3_LOCALIZ",aLista[8],Nil})		// 05 - D3_LOCALIZ

			// Inclusão do destino do produto
			Aadd(_aLinha,{"D3_COD",SB1->B1_COD,Nil})		// 06 - D3_COD
			Aadd(_aLinha,{"D3_DESCRI",SB1->B1_DESC,Nil})	// 07 - D3_DESCRI
			Aadd(_aLinha,{"D3_UM",SB1->B1_UM,Nil})			// 08 - D3_UM
			Aadd(_aLinha,{"D3_LOCAL",aLista[9],Nil})		// 09 - D3_LOCAL
			Aadd(_aLinha,{"D3_LOCALIZ",aLista[10],Nil})		// 10 - D3_LOCALIZ
			
            Aadd(_aLinha,{"D3_NUMSERI","",Nil})			    // 11 - D3_NUMSERI
			Aadd(_aLinha,{"D3_LOTECTL",aLista[3],Nil})	    // 12 - D3_LOTECTL
			Aadd(_aLinha,{"D3_NUMLOTE","",Nil})			    // 13 - D3_NUMLOTE
			Aadd(_aLinha,{"D3_DTVALID",_dDtVldOri,Nil})	    // 14 - D3_DTVALID
			Aadd(_aLinha,{"D3_POTENCI",0,Nil})			    // 15 - D3_POTENCI
			Aadd(_aLinha,{"D3_QUANT",aLista[4],Nil})	    // 16 - D3_QUANT
			Aadd(_aLinha,{"D3_QTSEGUM",_nQtdSegum,Nil})	    // 17 - D3_QTSEGUM
			Aadd(_aLinha,{"D3_ESTORNO","",Nil})			    // 18 - D3_ESTORNO
			Aadd(_aLinha,{"D3_NUMSEQ","",Nil})			    // 19 - D3_NUMSEQ
			Aadd(_aLinha,{"D3_LOTECTL",aLista[3],Nil})	    // 20 - D3_LOTECTL
			Aadd(_aLinha,{"D3_DTVALID",_dDtVldDes,Nil})	    // 21 - D3_DTVALID
			Aadd(_aLinha,{"D3_ITEMGRD","",Nil})			    // 22 - D3_ITEMGRD
			
			// Inclui uma linha
			Aadd(_aMata261,_aLinha)

			// Guarda o produto, local origem, endereço origem, lote e sua posição no array
			//Aadd(_aTransfe,{SB1->B1_COD + _aDadosSZS[_nCount][N1_LOCORI] + _aDadosSZS[_nCount][N1_ENDORI] + _aDadosSZS[_nCount][N1_LOTECTL],Len(_aMata261)})

			// Guarda o documento no array
			//_aDadosSZS[_nCount][N1_DOC] := _cDocSD3

			// Volta o indice
			SB8->(DbSetOrder(1))    // B8_FILIAL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)+B8_LOTECTL+B8_NUMLOTE

			// Realiza transferencia de armazem
			//MSExecAuto({|x,y| Mata261(x,y) },_aMata261,3)

			//_lContinua := !lMsErroAuto

            nOpcAuto := 3 // Inclusao

            //MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
            MSExecAuto({|x,y| Mata261(x,y) },_aMata261,3)

			If !lMsErroAuto
			DbSelectArea("SD3")
			SD3->(DbSetOrder(2))//D3_FILIAL, D3_DOC, D3_COD
			
			//Verifica se a transferencia de fato ocorreu, necessário pois o padrão retorna falso positivo caso ocorram problemas de Dt de validade.
			If SD3->(DbSeek(xFilial("SD3")+PADR(_sDocSD3 , TamSX3( "D3_DOC" )[1] )))
				RecLock("SD3", .F.)
					SD3->D3_XOBS := "AUTO EMPENHO"
				SD3->(MsUnlock())
				aRet := {.T., _sDocSD3, cLocDest, cEndDest, nQuant, cLote, cLocOri, cEndOri, {{cEndOri, nQuant, _sDocSD3}}}
			Else
				aRet := {.F., Dtoc(Date())+" "+Time()+" - Transferência não realizada, possivel erro de Data de Validade"}
			EndIf
			
			Else
				cErro:= "Erro na transferencia:"
				//MostraErro()
				cFileLog   := NomeAutoLog()
				cErrorMsg  := ""
			If FILE(cFileLog)
				cErrorMsg := MemoRead(cFileLog)
			EndIf
			
			ConOut("Erro Transf.:"+cErrorMsg)
			cXErr := cErrorMsg
			aRet := {.F., Dtoc(Date())+" "+Time()+" - "+cErrorMsg}
		EndIf

		

            //if lMsErroAuto
            //    MostraErro()
            //    lContinua := .F.
            //else
            //    //
            //    conout("Inclusão de movimentação multipla efetuada com sucesso")
            //    lContinua := .T.
            //EndIf

			//If _lContinua
				// Confirma a numeração
				//SD3->(ConfirmSX8())

				// Grava a observação
				//_fGrvObsD3(_cDocSD3)
			//Else
				// Volta a numeração
				/*
                SD3->(RollBackSX8())

				MostraErro(_cPath,_cNome + "_LOG.log")
				
				MemoWrite(_cPath + _cNome + "_DADOS.log",VarInfo("_aMata261",_aMata261,,.F.))

				_cMsgErro := AllTrim(MemoRead(_cPath + _cNome + "_LOG.log"))
				_cMsgErro += CRLF + CRLF
				_cMsgErro += "Produto: " + AllTrim(_aLinha[01][02]) + CRLF
				_cMsgErro += "Local Origem: " + AllTrim(_aLinha[04][02]) + CRLF
				_cMsgErro += "Endereço Origem: " + AllTrim(_aLinha[05][02]) + CRLF
				_cMsgErro += "Local Destino: " + AllTrim(_aLinha[09][02]) + CRLF
				_cMsgErro += "Endereço Destino: " + AllTrim(_aLinha[10][02]) + CRLF
				_cMsgErro += "Lote: " + AllTrim(_aLinha[12][02]) + CRLF
				_cMsgErro += "Validade Origem: " + DToC(_aLinha[14][02]) + CRLF
				_cMsgErro += "Validade Destino: " + DToC(_aLinha[21][02]) + CRLF
				_cMsgErro += "Quantidade: " + AllTrim(Str(_aLinha[16][02])) + CRLF

				// Sai do laço
				Exit
			EndIf
            */
		//EndIf
	//Next

Return 


Static Function PegaDtValid(cProd, cLote, cLocal)
Local cQry		:= ""
Local cTMPAlia	:= GetNextAlias()
Local dRet		:= CTOD("")

cQry	:= "SELECT B8_DTVALID                      "+CRLF
cQry	+= "FROM "+RetSqlName("SB8")+"             "+CRLF 
cQry	+= "WHERE B8_FILIAL = '"+xFilial("SB8")+"' "+CRLF
cQry	+= "AND   B8_PRODUTO = '"+cProd+"'         "+CRLF
cQry	+= "AND   B8_LOTECTL = '"+cLote+"'         "+CRLF
cQry	+= "AND	  D_E_L_E_T_ <> '*'                "+CRLF
cQry	+= "AND   B8_LOCAL = '"+cLocal+"'          "+CRLF
cQry	+= "AND   B8_SALDO > 0                     "

//Executa a query
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTMPAlia,.T.,.T.)

If (cTMPAlia)->(!Eof())
	dRet := STOD((cTMPAlia)->B8_DTVALID)
EndIf

(cTMPAlia)->(DbCloseArea())

Return dRet


Static Function AdeqArmTrnsf(cProd, cLocal)

DbSelectArea("SB2")
SB2->(DbSetOrder(1))

If SB2->(!DbSeek(xFilial("SB2")+cProd+cLocal))
	RecLock("SB2", .T.)
		SB2->B2_FILIAL	:= xFilial("SB2")
		SB2->B2_COD		:= cProd
		SB2->B2_LOCAL	:= cLocal
	SB2->(MsUnlock())
EndIf

Return

Static Function TABX(_Prod,_cLocal,_ncLote)
Local _nQuery :=""
Local _nAlias := GetNextAlias()
Local _cDate  :=""


_nQuery := "SELECT " +CHR(13)+CHR(10)
_nQuery += "SB8.B8_PRODUTO," +CHR(13)+CHR(10)
_nQuery += "SB8.B8_LOCAL, " +CHR(13)+CHR(10)
_nQuery += "SB8.B8_SALDO," +CHR(13)+CHR(10)
_nQuery += "SB8.B8_SALDO2," +CHR(13)+CHR(10)
_nQuery += "SB8.B8_LOTECTL," +CHR(13)+CHR(10)
_nQuery += "SB8.B8_DTVALID " +CHR(13)+CHR(10)
_nQuery	+= "FROM "+CHR(13)+CHR(10)
_nQuery	+= RetSqlName("SB8")+"  SB8  "+CHR(13)+CHR(10)
_nQuery	+= "WHERE "+CHR(13)+CHR(10)
_nQuery += "SB8.B8_PRODUTO='"+_Prod+"' AND  " +CHR(13)+CHR(10)
_nQuery += "SB8.B8_LOCAL='"+_cLocal+"' AND  " +CHR(13)+CHR(10)
_nQuery += "SB8.B8_LOTECTL='"+_ncLote+"' AND " +CHR(13)+CHR(10)
_nQuery += "SB8.D_E_L_E_T_=''" +CHR(13)+CHR(10)
_nQuery := ChangeQuery(_nQuery)

TCQuery _nQuery New Alias (_nAlias)
    _cDate := (_nAlias)->B8_DTVALID
Return(_cDate)



/*
Static Function TRANSFEMP()
//User Function MyMata261()
Local aAuto := {}
Local aItem := {}
Local aLinha := {}
Local aLista := ACLONE(nItens)
//Local 
/*
É necessario que:
O parametro MV_LOCALIZ = S
O produto com codigo PA001 tenha controle de endereco ativo
O armazem padrao definido no produto deve ter 2 endereços: ENDER01 e ENDER02
Saldo inicial igual ou superior a 1
E este saldo deve ser enderecçado ao ENDER01
*/
//Local aLista := {'45715208'} //Os produtos a serem utilizados
/*
Local nX        := 0
Local nOpcAuto  := 0
Local cDocumen  := ""
Local lContinua := .T.

Private lMsErroAuto := .F.

//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "EST" TABLES "SB1", "SD3"

//
conout("Exemplo de inclusão de movimentação multipla")

//Cabecalho a Incluir
cDocumen := GetSxeNum("SD3","D3_DOC")
aadd(aAuto,{cDocumen,dDataBase}) //Cabecalho

//Itens a Incluir
aItem := {}

for nX := 1 to 1//len(aLista) //step 2
    aLinha := {}
    //Origem
    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))  
    SB1->(DbSeek(xFilial("SB1")+PadR(aLista[2], tamsx3('D3_COD') [1])))
    //SB2->(DbSetOrder(1))    // B2_FILIAL+B2_COD+B2_LOCAL
    //If !SB2->(DbSeek(xFilial("SB2")+(Alltrim(aLista[2]))+_cLocDest))
    //    // Cria o armazem caso não exista
    //    CriaSB2((Alltrim(aLista[2])),_cLocDest)
    //EndIf

    // Inclusão da origem do produto
    aadd(aLinha, {"D3_COD"    , Alltrim(aLista[2]), Nil}) // 01 - D3_COD  // 'Prod.Orig.'
    aadd(aLinha, {"D3_DESCRI" , SB1->B1_DESC      , Nil}) // 02 - D3_DESCRI // 'Desc.Orig.'
    aadd(aLinha, {"D3_UM"     , SB1->B1_UM        , Nil}) // 03 - D3_UM    // 'UM Orig.'
    aadd(aLinha, {"D3_LOCAL"  , SB1->B1_LOCPAD    , Nil}) // 04 - D3_LOCAL  // 'Almox Orig.'
    aadd(aLinha, {"D3_LOCALIZ", Alltrim(aLista[8]), Nil}) // 05 - D3_LOCALIZ  // 'Localiz.Orig.'                         //PadR("P2 020218", tamsx3('D3_LOCALIZ') [1])
 
    //Destino
    SB1->(DbSeek(xFilial("SB1")+PadR(aLista[2], tamsx3('D3_COD') [1])))
    // Inclusão do destino do produto
    aadd(aLinha, {"D3_COD"    , Alltrim(aLista[2]), Nil}) // 06 - D3_COD - // 'Prod.Destino'
    aadd(aLinha, {"D3_DESCRI" , SB1->B1_DESC      , Nil}) // 07 - D3_DESCRI -// 'Desc.Destino'
    aadd(aLinha, {"D3_UM"     , SB1->B1_UM        , Nil}) // 08 - D3_UM      // 'UM Destino'
    aadd(aLinha, {"D3_LOCAL"  , "97"              , Nil}) // 09 - D3_LOCAL -// 'Almox Destino' //armazem destino
    aadd(aLinha, {"D3_LOCALIZ", "FABRICA"         , Nil}) // 10 - D3_LOCALIZ  // 'Localiz.Destino'  -  Informar endereÃ§o destino    //Alltrim(PadR("FABRICA", tamsx3('D3_LOCALIZ') [1]))
    
     // Outras informações da transferencia
    aadd(aLinha, {"D3_NUMSERI", ""                , Nil}) // 11 - D3_NUMSERI // 'N£mero Serie'
    aadd(aLinha, {"D3_LOTECTL", Alltrim(aLista[3]), Nil}) // 12 - D3_LOTECTL // 'Lote'
    aadd(aLinha, {"D3_NUMLOTE", ""                , Nil}) // 13 - D3_NUMLOTE  // 'Sub-Lote'
    aadd(aLinha, {"D3_DTVALID", aLista[7]         , Nil}) // 14 - D3_DTVALID // 'Validade'
    aadd(aLinha, {"D3_POTENCI", 0                 , Nil}) // 15 - D3_POTENCI // 'Potencia'
    aadd(aLinha, {"D3_QUANT"  , aLista[5]         , Nil}) // 16 - D3_QUANT  // 'Quantidade'
    aadd(aLinha, {"D3_QTSEGUM", ""                , Nil}) // 17 - D3_QTSEGUM // 'Qt 2aUM'
    aadd(aLinha, {"D3_ESTORNO", ""                , Nil}) // 18 - D3_ESTORNO // 'Estornado'
    aadd(aLinha, {"D3_NUMSEQ" , ""                , Nil}) // 19 - D3_NUMSEQ // 'Sequencia'
    aadd(aLinha, {"D3_LOTECTL", aLista[3]         , Nil}) // 20 - D3_LOTECTL // Lote
    aadd(aLinha, {"D3_DTVALID", aLista[7]         , Nil}) // 21 - D3_DTVALID // 'Validade Destino'
    aadd(aLinha, {"D3_ITEMGRD", ""                , Nil}) // 22 - D3_ITEMGRD
   
    aAdd(aAuto,aLinha)
Next nX

//DbSelectArea("SB2")
//SB2->(DbSetOrder(1))    // B2_FILIAL+B2_COD+B2_LOCAL
//If !SB2->(DbSeek(xFilial("SB2")+Alltrim(aLista[2])+"97"))
//    // Cria o armazem caso não exista
//    CriaSB2(Alltrim(aLista[2]),"97")
//EndIf

nOpcAuto := 3 // Inclusao

MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)

if lMsErroAuto
    MostraErro()
    lContinua := .F.
else
    //
    conout("Inclusão de movimentação multipla efetuada com sucesso")
    lContinua := .T.
EndIf

conout("Finalizado a inclusão de movimentação multipla")


Return

   





 /*
    aadd(aLinha,{"ITEM",'00'+cvaltochar(nX),Nil})
    aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //Cod Produto origem
    aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto origem
    aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem
    aadd(aLinha,{"D3_LOCAL", SB1->B1_LOCPAD, Nil}) //armazem origem
    aadd(aLinha,{"D3_LOCALIZ", PadR("ENDER01", tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereço origem
    */


 /*
    aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil})       //cod produto destino
    aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil})   //descr produto destino
    aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil})         //unidade medida destino
    aadd(aLinha,{"D3_LOCAL", SB1->B1_LOCPAD, Nil}) //armazem destino
    aadd(aLinha,{"D3_LOCALIZ", PadR("ENDER02", tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereÃ§o destino
    
    aadd(aLinha, {"D3_NUMSERI", "", Nil}) //Numero serie
    aadd(aLinha, {"D3_LOTECTL", Alltrim(aLista[nx][3]), Nil}) //Lote Origem
    aadd(aLinha, {"D3_NUMLOTE", "", Nil}) //sublote origem
    aadd(aLinha, {"D3_DTVALID", '', Nil}) //data validade
    aadd(aLinha, {"D3_POTENCI", 0 , Nil}) // Potencia
    aadd(aLinha, {"D3_QUANT"  ,  Alltrim(aLista[nx][5]) , Nil}) //Quantidade
    aadd(aLinha, {"D3_QTSEGUM", 0 , Nil}) //Seg unidade medida
    aadd(aLinha, {"D3_ESTORNO", "", Nil}) //Estorno
    aadd(aLinha, {"D3_NUMSEQ" , "", Nil}) // Numero sequencia D3_NUMSEQ
    
    aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
    aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino
    aadd(aLinha,{"D3_DTVALID", '', Nil}) //validade lote destino
    aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade
    
    aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
    aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino
    */

    /*
If lContinua

    //
    conout("Exemplo de estorno de movimentação multipla baseado na inclusão do movimentação multipla anterior")

    lMsErroAuto := .F.
    for nX := 1 to len(aLista) step 2
    
        //-- Preenchimento dos campos
        aAuto := {}
        aadd(aAuto,{"D3_DOC", cDocumen, Nil})
        aadd(aAuto,{"D3_COD", aLista[nX], Nil})
        
        DbSelectArea("SD3")
        DbSetOrder(2)
        DbSeek(xFilial("SD3")+cDocumen+aLista[nX])
    
        //-- Teste de Estorno
        nOpcAuto := 6 // Estornar
        MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
        
        If lMsErroAuto
            MostraErro()
        Else
            conout("Estorno de movimentação multipla efetuada com sucesso")
        EndIf

    Next nX
    conout("Finalizado a estorno de movimentação multipla")
EndIf


   a_Auto	:= {}
			AADD(a_Auto,{"",dDataBase})

			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+ZFC->ZFC_PROD)
			a_Item	:= {}

			AADD(a_Item,SB1->B1_COD)  						//D3_COD
			AADD(a_Item,SB1->B1_DESC)     					//D3_DESCRI
			AADD(a_Item,SB1->B1_UM)  							//D3_UM

			If	Empty(c_LocOri)
				c_LocOri := ZFC->ZFC_LOCORI
			Endif

			AADD(a_Item,c_LocOri)     					//D3_LOCAL
			AADD(a_Item,CriaVar("D3_LOCALIZ"))	//D3_LOCALIZ
			AADD(a_Item,SB1->B1_COD)  			//D3_COD
			AADD(a_Item,SB1->B1_DESC)     		//D3_DESCRI
			AADD(a_Item,SB1->B1_UM)  							//D3_UM
			AADD(a_Item,c_Almox)  								//D3_LOCAL
			AADD(a_Item,CriaVar("D3_LOCALIZ",.F.))										//D3_LOCALIZ
			AADD(a_Item,CriaVar("D3_NUMSERI",.F.))          							//D3_NUMSERI
			AADD(a_Item,CriaVar("D3_LOTECTL",.F.))										//D3_LOTECTL
			AADD(a_Item,CriaVar("D3_NUMLOTE",.F.))         							//D3_NUMLOTE
			AADD(a_Item,CriaVar("D3_DTVALID",.F.))						//D3_DTVALID
			AADD(a_Item,CriaVar("D3_POTENCI",.F.))										//D3_POTENCI
			AADD(a_Item,ZFC->ZFC_QATEND)							//D3_QUANT
			AADD(a_Item,CriaVar("D3_QTSEGUM",.F.))										//D3_QTSEGUM
			AADD(a_Item,CriaVar("D3_ESTORNO",.F.))   									//D3_ESTORNO
			AADD(a_Item,CriaVar("D3_NUMSEQ",.F.))         							//D3_NUMSEQ
			AADD(a_Item,CriaVar("D3_LOTECTL",.F.))										//D3_LOTECTL
			AADD(a_Item,CriaVar("D3_DTVALID",.F.))						//D3_DTVALID
			AADD(a_Item,CriaVar("D3_ITEMGRD",.F.))										//D3_ITEMGRD
//			AADD(a_Item,CriaVar("D3_IDDCF",.F.))										//D3_IDDCF
			AADD(a_Item,CriaVar("D3_OBSERVA",.F.))										//D3_OBSERVA
			AADD(a_Item,CriaVar("D3_HISTOR",.F.))										//D3_OBSERVA

			AADD(a_Auto,a_Item)

			MSExecAuto({|x,y| mata261(x,y)},a_Auto,c_Opc)

*/
//RESET ENVIRONMENT

