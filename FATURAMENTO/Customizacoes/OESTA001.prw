#Include 'Protheus.ch'
#Include 'RwMake.ch'
#Include 'Totvs.ch'
#Include 'TopConn.ch'

Static _lJob := IsBlind()

Static _aRegistro := {}

/*/{Protheus.doc} OESTA001
	(Função para realizar a liberação de estoque dos pedidos de venda.)

	@type User Function
	@author Vitor Ribeiro
	@since 20/02/2019

    @param a_Param, array, contém as informações do parametro. Utilizado para realizar a rotina automaticamente.

	@return Nil, nulo, não tem retorno.
	/*/
User Function OESTA001(a_Param)

    Local _aArea := GetArea()
    Local _aAreaSC5 := SC5->(GetArea())
    Local _aAreaSC6 := SC6->(GetArea())
    Local _aAreaSC9 := SC9->(GetArea())
    
    Local _lContinua := .T.

    Local _cAlias := ''

    Default a_Param := {}

    DbSelectArea('SC5')     // PEDIDOS DE VENDA
    SC5->(DbSetOrder(1))    // C5_FILIAL+C5_NUM

    DbSelectArea('SC6')     // ITENS DOS PEDIDOS DE VENDA
    SC6->(DbSetOrder(1))    // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO

    DbSelectArea('SC9')     // PEDIDOS LIBERADOS
    SC9->(DbSetOrder(1))    // C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO+C9_BLEST+C9_BLCRED

    // Inicializa variaveis
    _aRegistro := {}

    // Realiza o pergunte
    _lContinua := _fPergunte(a_Param)

    // Se continua
    If _lContinua
        // Executa a query
        _fProcessa({|| _cAlias := _fMakeQry() },'Aguarde...','Buscando dados...')

        // Se não houve resultado
        If (_cAlias)->(Eof())
            _fMsgAlert('Não existe dados para os parâmetros informados!' + CRLF + CRLF + 'Verifique.')
        Else
            // Libera os pedidos
            _fProcessa({|| _fLiberPed(_cAlias) },'Aguarde...','Liberando os pedidos...')
        EndIf

        // Fecha o alias
        (_cAlias)->(DbCloseArea())

        // Se tiver informação e não for job
        If !Empty(_aRegistro) .And. !_lJob
            _fProcessa({|| _fMkScreen() })
        EndIf
    EndIf

    RestArea(_aAreaSC9)
    RestArea(_aAreaSC6)
    RestArea(_aAreaSC5)
    RestArea(_aArea)

Return Nil

/*/{Protheus.doc} _fPergunte
	(Função para montar o pergunte)

	@type Static Function
	@author Vitor Ribeiro
	@since 20/02/2019

    @param a_Param, array, contém as informações do parametro. Utilizado para realizar a rotina automaticamente.

	@return _lContinua, logico, se continua ou não.
	/*/
Static Function _fPergunte(a_Param)
    
    Local _lContinua := .F.

    Local _cPergunte := 'OESTA001'

    Default a_Param := {}

    // Função para ajustar o pergunte
    _fAjustSX1(_cPergunte)

    // Realiza o pergunte
    _lContinua := Pergunte(_cPergunte,Empty(a_Param)) .Or. !Empty(a_Param)

    // Se foi confirmado
    If _lContinua
        // Se foi passa os parametros
        If !Empty(a_Param)
            // Atuliza os MV_PAR's com as informações do parâmetro
            MV_PAR01 := PadR(a_Param[1],Len(MV_PAR01))  // Pedido de ?
            MV_PAR02 := PadR(a_Param[2],Len(MV_PAR02))  // Pedido ate ?
            MV_PAR03 := PadR(a_Param[3],Len(MV_PAR03))  // Cliente de ?
            MV_PAR04 := PadR(a_Param[4],Len(MV_PAR04))  // Cliente ate ?
            MV_PAR05 := a_Param[5]                      // Data de Entrega de ?
            MV_PAR06 := a_Param[6]                      // Data de Entrega ate ?
            MV_PAR07 := PadR(a_Param[7],Len(MV_PAR07))  // Armazem de ?
            MV_PAR08 := PadR(a_Param[8],Len(MV_PAR08))  // Armazem ate ?
            MV_PAR09 := PadR(a_Param[9],Len(MV_PAR09))  // Nao considera o cliente ?
            MV_PAR10 := a_Param[10]                     // Ordem de liberação dos pedidos
        EndIf
    EndIf
    
Return _lContinua

/*/{Protheus.doc} _fAjustSX1
	(Função para ajustar o SX1)

	@type Static Function
	@author Vitor Ribeiro
	@since 20/02/2019

    @param c_Pergunte, caracter, contém o nome do pergunte.

	@return Nil, nulo, não tem retorno
	/*/
Static Function _fAjustSX1(c_Pergunte)

    Local _aArea := GetArea()
    Local _aAreaSX3 := SX3->(GetArea())

    Default c_Pergunte := ''

    DbSelectArea('SX1')     // PERGUNTES
    SX1->(DbSetOrder(1))    // X1_GRUPO+X1_ORDEM

    DbSelectArea('SX3')     // DICIONARIO DE DADOS
    SX3->(DbSetOrder(2))    // X3_CAMPO

    SX3->(DbSeek('C5_NUM'))
    SX3->(_fPutSx1(c_Pergunte,'01','Pedido de ?'                ,'MV_CH1',X3_TIPO   ,X3_TAMANHO ,X3_DECIMAL ,'G','SC5'  ,'MV_PAR01',''              ,''))
    SX3->(_fPutSx1(c_Pergunte,'02','Pedido ate ?'               ,'MV_CH2',X3_TIPO   ,X3_TAMANHO ,X3_DECIMAL ,'G','SC5'  ,'MV_PAR02',''              ,''))

    SX3->(DbSeek('A1_COD'))
    SX3->(_fPutSx1(c_Pergunte,'03','Cliente de ?'               ,'MV_CH3',X3_TIPO   ,X3_TAMANHO ,X3_DECIMAL ,'G','SA1'  ,'MV_PAR03',''              ,''))
    SX3->(_fPutSx1(c_Pergunte,'04','Cliente ate ?'              ,'MV_CH4',X3_TIPO   ,X3_TAMANHO ,X3_DECIMAL ,'G','SA1'  ,'MV_PAR04',''              ,''))

    SX3->(DbSeek('C6_ENTREG'))
    SX3->(_fPutSx1(c_Pergunte,'05','Data de Entrega de ?'       ,'MV_CH5',X3_TIPO   ,X3_TAMANHO ,X3_DECIMAL ,'G',''     ,'MV_PAR05',''              ,''))
    SX3->(_fPutSx1(c_Pergunte,'06','Data de Entrega ate ?'      ,'MV_CH6',X3_TIPO   ,X3_TAMANHO ,X3_DECIMAL ,'G',''     ,'MV_PAR06',''              ,''))

    SX3->(DbSeek('NNR_CODIGO'))
    SX3->(_fPutSx1(c_Pergunte,'07','Armazem de ?'               ,'MV_CH7',X3_TIPO   ,X3_TAMANHO ,X3_DECIMAL ,'G','NNR'  ,'MV_PAR07',''              ,''))
    SX3->(_fPutSx1(c_Pergunte,'08','Armazem ate ?'              ,'MV_CH8',X3_TIPO   ,X3_TAMANHO ,X3_DECIMAL ,'G','NNR'  ,'MV_PAR08',''              ,''))

    SX3->(DbSeek('A1_COD'))
    SX3->(_fPutSx1(c_Pergunte,'09','Nao considera o cliente ?'  ,'MV_CH9',X3_TIPO   ,X3_TAMANHO ,X3_DECIMAL ,'G','SA1'  ,'MV_PAR09',''              ,''))

    _fPutSx1(c_Pergunte,'10','Ordem de liberação dos pedidos'   ,'MV_CHA','N'       ,1          ,0          ,'C',''     ,'MV_PAR10','Numero Pedido' ,'Data de entrega')

    RestArea(_aAreaSX3)
    RestArea(_aArea)

Return Nil

/*/{Protheus.doc} _fPutSx1
	(Função para gravar o SX1)

	@type Static Function
	@author Vitor Ribeiro
	@since 20/02/2019

    @param c_Grupo, caracter, X1_GRUPO
    @param c_Ordem, caracter, X1_ORDEM
    @param c_Pergunt, caracter, X1_PERGUNT
    @param c_Variavl, caracter, X1_VARIAVL
    @param c_Tipo, caracter, X1_TIPO
    @param n_Tamanho, X1_TAMANHO
    @param n_Decimal, X1_DECIMAL
    @param c_Gsc, caracter, X1_GSC
    @param c_F3, caracter, X1_F3
    @param c_Var01, caracter, X1_VAR01
    @param c_Def01, caracter, X1_DEF01
    @param c_Def02, caracter, X1_DEF02
    
	@return Nil, nulo, não tem retorno
	/*/
Static Function _fPutSx1(c_Grupo,c_Ordem,c_Pergunt,c_Variavl,c_Tipo,n_Tamanho,n_Decimal,c_Gsc,c_F3,c_Var01,c_Def01,c_Def02)

    Local _lNotFound := .F.

    Default c_Grupo := ''
    Default c_Ordem := ''
    Default c_Pergunt := ''
    Default c_Variavl := ''
    Default c_Tipo := ''
    Default c_Gsc := ''
    Default c_F3 := ''
    Default c_Var01 := ''
    Default c_Def01 := ''
    Default c_Def02 := ''
    
    Default n_Tamanho := 0
    Default n_Decimal := 0

    If !Empty(c_Grupo) .And. !Empty(c_Ordem)
        _lNotFound := !SX1->(DbSeek(PadR(c_Grupo,Len(X1_GRUPO))+PadR(c_Ordem,Len(X1_ORDEM))))

        // Inclui ou altera o registro
        RecLock('SX1',_lNotFound)
            SX1->X1_GRUPO := c_Grupo
            SX1->X1_ORDEM := c_Ordem
            SX1->X1_PERGUNT := c_Pergunt
            SX1->X1_PERSPA := c_Pergunt
            SX1->X1_PERENG := c_Pergunt
            SX1->X1_VARIAVL := c_Variavl
            SX1->X1_TIPO := c_Tipo
            SX1->X1_TAMANHO := n_Tamanho
            SX1->X1_DECIMAL := n_Decimal
            SX1->X1_GSC := c_Gsc
            SX1->X1_F3 := c_F3
            SX1->X1_VAR01 := c_Var01
            SX1->X1_DEF01 := c_Def01
            SX1->X1_DEFSPA1 := c_Def01
            SX1->X1_DEFENG1 := c_Def01
            SX1->X1_DEF02 := c_Def02
            SX1->X1_DEFSPA2 := c_Def02
            SX1->X1_DEFENG2 := c_Def02
        SX1->(MsUnLock())
    EndIf

Return Nil

/*/{Protheus.doc} _fMakeQry
	(Função para montar a query principal)

	@type Static Function
	@author Vitor Ribeiro
	@since 20/02/2019

	@return _cAlias, caracter, retorna o alias da query
	/*/
Static Function _fMakeQry()

    Local _cNfiscal := ''
    Local _cOrder := ''
    Local _cAlias := ''

    Local _nT_BLEST := ''

    _cNfiscal := Space(TamSX3('C9_NFISCAL')[1])

    _nT_BLEST := TamSX3('C9_BLEST')[1]

    _cOrder := '%' 
    
    If MV_PAR10 == 2
    	_cOrder += 'SC6.C6_ENTREG,'
    ElseIf MV_PAR10 == 3
    	_cOrder += 'SC6.C6_XLIBPED,'
    EndIf
    
    _cOrder += 'SC6.C6_NUM, SC6.C6_PRODUTO, SC6.C6_LOCAL%'
    
    _cAlias := GetNextAlias()

    BeginSql Alias _cAlias
        SELECT 
             SC9.C9_FILIAL
            ,SC9.C9_PEDIDO
            ,SC9.C9_ITEM
            ,SB1.R_E_C_N_O_ SB1_REC
            ,SC9.R_E_C_N_O_ SC9_REC
            ,SC5.R_E_C_N_O_ SC5_REC
            ,SC6.R_E_C_N_O_ SC6_REC
        FROM %Table:SC9% SC9

        INNER JOIN %Table:SB1% SB1 ON
            SB1.%NotDel%
            AND SB1.B1_FILIAL = %xFilial:SB1%
            AND SB1.B1_COD = SC9.C9_PRODUTO

        INNER JOIN %Table:SC5% SC5 ON
            SC5.%NotDel%
            AND SC5.C5_FILIAL = %xFilial:SC5%
            AND SC5.C5_NUM = SC9.C9_PEDIDO

        INNER JOIN %Table:SC6% SC6 ON
            SC6.%NotDel%
            AND SC6.C6_FILIAL = %xFilial:SC6%
            AND SC6.C6_NUM = SC9.C9_PEDIDO
            AND SC6.C6_ITEM = SC9.C9_ITEM
            AND SC6.C6_PRODUTO = SC9.C9_PRODUTO
            AND SC6.C6_ENTREG >= %Exp:DToS(MV_PAR05)%
            AND SC6.C6_ENTREG <= %Exp:DToS(MV_PAR06)%
            AND SC6.C6_LOCAL >= %Exp:MV_PAR07%
            AND SC6.C6_LOCAL <= %Exp:MV_PAR08%

        WHERE 
            SC9.%NotDel%
            AND SC9.C9_FILIAL = %xFilial:SC9%
            AND SC9.C9_PEDIDO >= %Exp:MV_PAR01%
            AND SC9.C9_PEDIDO <= %Exp:MV_PAR02%
            AND SC9.C9_CLIENTE >= %Exp:MV_PAR03%
            AND SC9.C9_CLIENTE <= %Exp:MV_PAR04%
            AND SC9.C9_CLIENTE <> %Exp:MV_PAR09%
            AND SC9.C9_NFISCAL = %Exp:_cNfiscal%
            AND SC9.C9_BLEST <> %Exp:Space(_nT_BLEST)%
            AND SC9.C9_BLEST <> %Exp:PadR('10',_nT_BLEST)%
            AND SC9.C9_BLEST <> %Exp:PadR('ZZ',_nT_BLEST)%

        ORDER BY
            %Exp:_cOrder%
	EndSql
    MemoWrite("LOGS_PROGRAMAS\OPCPA002\OESTA001.sql",GetLastQuery()[2])

Return _cAlias

/*/{Protheus.doc} _fProcessa
	(Função para realizar um processamento via bloco de code.)

	@type Static Function
	@author Vitor Ribeiro
	@since 20/02/2019

	@return b_Code, bloco de codigo, bloco a ser executado.

    @obs Se for job, não será utilizado a função Processa.
	/*/
Static Function _fProcessa(b_Code,c_Titulo,c_Mensagem)

    Default b_Code := {|| }

    // Se for job
    If _lJob
        ConOut('(OESTA001.PRW) INICIO DATA: ' + DToC(Date()) + ' HORA: ' + Time() + ' - ' + c_Titulo + ' - ' + c_Mensagem)
        Eval(b_Code)
        ConOut('(OESTA001.PRW) FINAL DATA: ' + DToC(Date()) + ' HORA: ' + Time() + ' - ' + c_Titulo + ' - ' + c_Mensagem)
    Else
        Processa(b_Code,c_Titulo,c_Mensagem,.F.)
    EndIf

Return Nil

/*/{Protheus.doc} _fMsgAlert
	(Função para executar a função MsgAlert.)

	@type Static Function
	@author Vitor Ribeiro
	@since 20/02/2019

    @param c_Mensagem, caracter, contém a mensagem a ser exibida

	@return Nil, nulo, não tem retorno.

    @obs Se for job, a mensagem será gravada no log.
	/*/
Static Function _fMsgAlert(c_Mensagem)

    Default c_Mensagem := ''

    If !Empty(c_Mensagem)
        // Se for job
        If _lJob
            // Grava a mensagem no log
            ConOut('(OESTA001.PRW) DATA: ' + DToC(Date()) + ' HORA: ' + Time() + ' - ' + c_Mensagem)
        Else
            MsgAlert(c_Mensagem,'Atenção')
        EndIf
    EndIf

Return Nil

/*/{Protheus.doc} _fLiberPed
	(Função para liberar pedido.)

	@type Static Function
	@author Vitor Ribeiro
	@since 20/02/2019

    @param c_Alias, caracter, contém o alias da query

	@return Nil, nulo, não tem retorno.
	/*/
Static Function _fLiberPed(c_Alias)

    Local _oLibera := Nil

    Local _nTotalSql := 0
    Local _nSaldo := 0
    Local _nQtdLiber := 0
    Local _nPosicao := 0

    Default c_Alias := ''

    // Inicializa o objeto da alteração
    _oLibera := Libera_Estoque_Class():New()

    // Conta todos os registros
    _nTotalSql := fConta(c_Alias)

    // Seta a regua
    fProcRegua(_nTotalSql)
    
    // Enquanto houver registros
    While (c_Alias)->(!Eof())
        // Posiciona no cadastro do produto
        SB1->(DbGoTo((c_Alias)->SB1_REC))

        // Posiciona no pedido
        SC5->(DbGoTo((c_Alias)->SC5_REC))

        // Posiciona no item do pedido
        SC6->(DbGoTo((c_Alias)->SC6_REC))

        // Posiciona na liberação do pedido
        SC9->(DbGoTo((c_Alias)->SC9_REC))

        _fIncProc('Liberando o pedido ' + SC5->C5_NUM + '... Falta ' + AllTrim(Str(_nTotalSql)) + ' registros...')

        // Diminui um registro
        _nTotalSql--
                
        // Busca o saldo
        _nSaldo := _fGetSaldo(SB1->B1_RASTRO,SB1->B1_LOCALIZ,SC9->C9_PRODUTO,SC9->C9_LOCAL)

        // Se tiver saldo
        If _nSaldo > 0
            // Se tiver mais saldo que a quantidade a ser liberada
            If _nSaldo > SC9->C9_QTDLIB
                // Libera toda a quantidade
                _nQtdLiber := SC9->C9_QTDLIB
            Else
                // Libera a quantidade que possui em saldo
                _nQtdLiber := _nSaldo
            EndIf

            // Seta o numero do pedido
            _oLibera:SetPedido(SC9->C9_PEDIDO)

            // Seta o item do pedido
            _oLibera:SetItem(SC9->C9_ITEM)

            // Seta o produto do pedido
            _oLibera:SetProduto(SC9->C9_PRODUTO)

            // Seta a sequencia de liberação do item do pedido
            _oLibera:SetSequen(SC9->C9_SEQUEN)

            // Seta a quantidade a ser liberada
            _oLibera:SetQtdeLiber(_nQtdLiber)

            // Executa a liberação
            If _oLibera:Executar()
                _fAddReg('Liberado: ' + AllTrim(Str(_oLibera:GetCodErro())) + ' - ' + _oLibera:GetMensagem())
            Else
                _fAddReg('Codigo do erro: ' + AllTrim(Str(_oLibera:GetCodErro())) + ' - ' + _oLibera:GetMensagem())
            EndIf
        Else
            _fAddReg('Sem saldo!')
        EndIf

        // Vai para o proximo registro
        (c_Alias)->(DbSkip())
    EndDo

Return Nil

/*/{Protheus.doc} fConta
	(Função para contar registros em um alias)

	@type Static Function
	@author Vitor Ribeiro
	@since 20/02/2019

    @param c_Alias, caracter, alias do arquivo

	@return _nTotal, numerico, retorna o total de registros do arquivo.
	/*/
Static Function fConta(c_Alias)

    Local _nTotal := 0

    Default c_Alias := ""
    
    // Se não for final de arquivo
    If (c_Alias)->(!Eof())
        // Vai para o primeiro registro
        (c_Alias)->(DbGoTop())

        // Conta todos os registros
        _nTotal := Contar(c_Alias,"!Eof()")

        // Vai para o primeiro registro
        (c_Alias)->(DbGoTop())
    EndIf

Return _nTotal

/*/{Protheus.doc} fProcRegua
	(Função para executar a procRegua.)

	@type Static Function
	@author Vitor Ribeiro
	@since 20/02/2019

    @param n_Quant, numerico, total de registros para ser processado

	@return Nil, nulo, não tem retorno.
	/*/
Static Function fProcRegua(n_Quant)

    Default n_Quant := 0

    If _lJob
        ConOut('(OESTA001.PRW) DATA: ' + DToC(Date()) + ' HORA: ' + Time() + ' - Quantidade de registro para ser liberado: ' + AllTrim(Str(n_Quant)))
    Else
        ProcRegua(n_Quant)
    EndIf

Return Nil

/*/{Protheus.doc} _fIncProc
	(Função para executar a IncProc.)

	@type Static Function
	@author Vitor Ribeiro
	@since 20/02/2019

    @param c_Mensagem, caracter, mensagem para a incproc

	@return Nil, nulo, não tem retorno.
	/*/
Static Function _fIncProc(c_Mensagem)

    Default c_Mensagem := ''

    If _lJob
        ConOut(c_Mensagem)
    Else
        IncProc(c_Mensagem)
        ProcessMessages()
    EndIf

Return Nil

/*/{Protheus.doc} _fGetSaldo
	(Função para buscar o saldo de um produto.)

	@type Static Function
	@author Vitor Ribeiro
	@since 20/02/2019

    @param c_Rastro, caracter, se o produto utiliza rastro (B1_RASTRO)
    @param c_Localiz, caracter, se o produto utiliza endereço (B1_LOCALIZ)
    @param c_Produto, caracter, codigo do produto.
    @param c_Local, caracter, codigo do armazem.

	@return _nSaldo, numerico, retorna o saldo do produto.
	/*/
Static Function _fGetSaldo(c_Rastro,c_Localiz,c_Produto,c_Local)

    Local _cAlias := ''

    Local _nSaldo := 0

    Default c_Rastro := ''
    Default c_Localiz := ''
    Default c_Produto := ''
    Default c_Local := ''

    _cAlias := GetNextAlias()

    If c_Localiz == 'S'   // Se tiver endereço

        BeginSql Alias _cAlias
            SELECT 
                SUM(SBF.BF_QUANT - SBF.BF_EMPENHO) SALDO 
            FROM %Table:SBF% SBF 

            WHERE 
                SBF.%NotDel%
                AND SBF.BF_FILIAL = %xFilial:SB8%
                AND SBF.BF_PRODUTO = %Exp:c_Produto%
                AND SBF.BF_LOCAL = %Exp:c_Local%
        EndSql

    ElseIf c_Rastro == 'L' .And. c_Localiz == 'N'  // Se for rastreado por lote

        BeginSql Alias _cAlias
            SELECT 
                SUM(SB8.B8_SALDO - SB8.B8_EMPENHO) SALDO 
            FROM %Table:SB8% SB8 

            WHERE 
                SB8.%NotDel%
                AND SB8.B8_FILIAL = %xFilial:SB8%
                AND SB8.B8_PRODUTO = %Exp:c_Produto%
                AND SB8.B8_LOCAL = %Exp:c_Local%
        EndSql

    Else

        BeginSql Alias _cAlias
            SELECT 
                SUM(SB2.B2_QATU - SB2.B2_RESERVA) SALDO 
            FROM %Table:SB2% SB2

            WHERE 
                SB2.%NotDel%
                AND SB2.B2_FILIAL = %xFilial:SB2%
                AND SB2.B2_COD = %Exp:c_Produto%
                AND SB2.B2_LOCAL = %Exp:c_Local%
        EndSql

    EndIf

    // Se trouxe informação
    If (_cAlias)->(!Eof())
        _nSaldo := (_cAlias)->SALDO
    EndIf

    // Fecha o alias
    (_cAlias)->(DbCloseArea())

Return _nSaldo

/*/{Protheus.doc} _fAddReg
	(Função para adicionar informação no array _aRegistro.)

	@type Static Function
	@author Vitor Ribeiro
	@since 20/02/2019

    @param c_Mensagem, caracter, mensagem referente a liberação.

	@return _nSaldo, numerico, retorna o saldo do produto.
	/*/
Static Function _fAddReg(c_Mensagem)

    Default c_Mensagem := ''

    Aadd(_aRegistro,{})
    _nPosicao := Len(_aRegistro)

    Aadd(_aRegistro[_nPosicao],StrZero(_nPosicao,4))
    Aadd(_aRegistro[_nPosicao],SC9->C9_PEDIDO)
    Aadd(_aRegistro[_nPosicao],SC9->C9_CLIENTE)
    Aadd(_aRegistro[_nPosicao],SC9->C9_ITEM)
    Aadd(_aRegistro[_nPosicao],SC9->C9_PRODUTO)
    Aadd(_aRegistro[_nPosicao],SC9->C9_LOCAL)
    Aadd(_aRegistro[_nPosicao],SC9->C9_LOTECTL)
    Aadd(_aRegistro[_nPosicao],c_Mensagem)

Return Nil

/*/{Protheus.doc} _fMkScreen
	(Função para montar uma tela)

	@type Static Function
	@author Vitor Ribeiro
	@since 20/02/2019

	@return Nil, nulo, não tem retorno.
	/*/
Static Function _fMkScreen()

    Local _aCoors := {}
	
	Local _bConfirma := {|| _oDialog:End() }
	Local _bCancela := {|| _oDialog:End() }
	
	Local _oDialog := Nil
	
	Private _oBrowse := Nil

    Private _aCols := {}

	_aCoors := FWGetDialogSize()

    _aCols := _aRegistro

    Define MsDialog _oDialog From _aCoors[1],_aCoors[2] To _aCoors[3],_aCoors[4] Pixel Title 'Lista de pedidos não liberados / liberados'

        //Criacao do browse com as alçadas
        _oBrowse := FWFormBrowse():New()
        _oBrowse:DisableDetails()
        _oBrowse:SetOwner(_oDialog)
        _oBrowse:SetDescription('Lista de pedidos não liberados / liberados')
        _oBrowse:SetDataArray()
        _oBrowse:SetArray(_aCols)
        _oBrowse:SetColumns(DataTelas(_fGetHeade()))
        _oBrowse:DisableConfig()
        _oBrowse:Activate()

    Activate MsDialog _oDialog On Init EnchoiceBar(_oDialog,_bConfirma,_bCancela,,{}) Centered

Return Nil

/*/{Protheus.doc} _fGetHeade
	(Função para montar o header do browser.)

	@type Static Function
	@author Vitor Ribeiro
	@since 20/02/2019

	@return _aHeader, array, contem o header.
	/*/
Static Function _fGetHeade()

    Local _aTamanho := {}
    Local _aHeader := {}

    Aadd(_aHeader,{'G_ORDEM',{'Ordem','C',4,0,'@!'}})

    _aTamanho := TamSX3('C9_PEDIDO')
    Aadd(_aHeader,{'G_PEDIDO',{'Pedido',_aTamanho[3],_aTamanho[2],_aTamanho[1],'@!'}})

    _aTamanho := TamSX3('C9_CLIENTE')
    Aadd(_aHeader,{'G_CLIENTE',{'Cliente',_aTamanho[3],_aTamanho[2],_aTamanho[1],'@!'}})

    _aTamanho := TamSX3('C9_ITEM')
    Aadd(_aHeader,{'G_ITEM',{'Item do pedido',_aTamanho[3],_aTamanho[2],_aTamanho[1],'@D'}})

    _aTamanho := TamSX3('C9_PRODUTO')
    Aadd(_aHeader,{'G_PRODUTO',{'Produto',_aTamanho[3],_aTamanho[2],_aTamanho[1],'@!'}})

    _aTamanho := TamSX3('C9_LOCAL')
    Aadd(_aHeader,{'G_LOCAL',{'Armazem',_aTamanho[3],_aTamanho[2],_aTamanho[1],'@!'}})

    _aTamanho := TamSX3('C9_LOTECTL')
    Aadd(_aHeader,{'G_LOTECTL',{'Lote',_aTamanho[3],_aTamanho[2],_aTamanho[1],'@!'}})

    Aadd(_aHeader,{'G_MENSAGEM',{'Mensagem','C',80,0,'@!'}})

Return _aHeader

/*/{Protheus.doc} DataTelas
    (Função para adicionar uma coluna no Browse em tempo de execução. )

	@type Static Function
    @Author Vitor Ribeiro
    @since 02/01/2019

    @param a_Campos, array, campos que serão utilizados nas browser.

    @Return _aColumns, array, multidimensional contendo objetos da FWBrwColumn.
    /*/
Static Function DataTelas(a_Campos)

	Local _nCount := 0
	
	Local _oColuna := Nil

	Local _aColumns := {}

	Default a_Campos := {}	
	
	If !Empty(a_Campos)
		SX3->(DbSetOrder(2))	// X3_CAMPO
	
		For _nCount := 1 To Len(a_Campos)
			If SX3->(DbSeek(a_Campos[_nCount][1])) .And. Empty(a_Campos[_nCount][2])
				SetPrvt(AllTrim(SX3->X3_CAMPO))
				
				_oColuna := FWBrwColumn():New()				// Cria objeto
				_oColuna:SetEdit(.F.)       				// Indica se <E9> editavel
				_oColuna:SetTitle(SX3->X3_TITULO)			// Define titulo
				_oColuna:SetType(SX3->X3_TIPO)				// Define tipo
			 	_oColuna:SetSize(SX3->X3_TAMANHO)			// Define tamanho
                _oColuna:SetDecimal(SX3->X3_DECIMAL)		// Define tamanho
				_oColuna:SetPicture(SX3->X3_PICTURE)		// Define picture
				_oColuna:SetAlign(AlignTipo(SX3->X3_TIPO))// Define alinhamento				
				_oColuna:SetData(&( '{|| _aCols[_oBrowse:At()][' + Alltrim(Str(_nCount)) + '] }' ))
				
				Aadd(_aColumns,_oColuna)
			Else
				SetPrvt(AllTrim(a_Campos[_nCount][1]))
				
				_oColuna := FWBrwColumn():New()							// Cria objeto
				_oColuna:SetEdit(.F.)       							// Indica se <E9> editavel
				_oColuna:SetTitle(a_Campos[_nCount][2][1])				// Define titulo
				_oColuna:SetType(a_Campos[_nCount][2][2])				// Define tipo
			 	_oColuna:SetSize(a_Campos[_nCount][2][3])				// Define tamanho
                _oColuna:SetDecimal(a_Campos[_nCount][2][4])			// Define tamanho
				_oColuna:SetPicture(a_Campos[_nCount][2][5])			// Define picture
				_oColuna:SetAlign(AlignTipo(a_Campos[_nCount][2][2]))	// Define alinhamento				
				_oColuna:SetData(&( '{|| _aCols[_oBrowse:At()][' + Alltrim(Str(_nCount)) + '] }' ))
				
				Aadd(_aColumns,_oColuna)
			EndIf
		Next _nCount
	EndIf

Return _aColumns

/*/{Protheus.doc} AlignTipo
    (Função para retornar o alinhamento de campos conforme seu tipo. )

	@type Static Function
    @Author Vitor Ribeiro
    @since 02/01/2019

    @param c_Tipo, caracter, tipo do campo.

    @Return _cAlign, caracter, contem o alinhamento.
    /*/
Static Function AlignTipo(c_Tipo)

	Local _cAlign := ''
	
	Default c_Tipo := ''

	If c_Tipo == 'N'
		_cAlign := 'RIGHT'
	ElseIf c_Tipo == 'D'
		_cAlign := 'CENTER'
	Else
		_cAlign := 'LEFT'
	EndIf
	
Return _cAlign
