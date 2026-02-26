#Include 'Protheus.ch'
#Include 'RwMake.ch'
#Include 'Totvs.ch'
#Include 'TopConn.ch'

#Define X_ERRO000   00  // X_MENS000
#Define X_ERRO001   01  // X_MENS001
#Define X_ERRO002   02  // X_MENS002
#Define X_ERRO003   03  // X_MENS003
#Define X_ERRO004   04  // X_MENS004
#Define X_ERRO005   05  // X_MENS005
#Define X_ERRO006   06  // X_MENS006
#Define X_ERRO007   07  // X_MENS007
#Define X_ERRO008   08  // X_MENS008
#Define X_ERRO009   09  // X_MENS009
#Define X_ERRO010   10  // X_MENS010
#Define X_ERRO011   11  // X_MENS011
#Define X_ERRO012   12  // X_MENS012
#Define X_ERRO013   13  // X_MENS013
#Define X_ERRO014   14  // X_MENS014
#Define X_ERRO015   15  // X_MENS015
#Define X_ERRO016   16  // X_MENS016
#Define X_ERRO017   17  // X_MENS017
#Define X_ERRO018   18  // X_MENS018
#Define X_ERRO099   99  // Não foi processado

#Define X_MENS000   'Executado com sucesso'
#Define X_MENS001   'Numero do pedido de venda não informado'
#Define X_MENS002   'Item do pedido de venda não informado'
#Define X_MENS003   'Quantidade a ser liberada não foi informada'
#Define X_MENS004   'Pedido de venda não encontrado'
#Define X_MENS005   'Itens do pedido de venda não encontrado'
#Define X_MENS006   'Registro de liberação do pedido de venda não encontrado'
#Define X_MENS007   'Quantidade a ser liberada informada é maior que a quantidade existente para liberação'
#Define X_MENS008   'Nâo foi possivel bloquear o registro do pedido de venda'
#Define X_MENS009   'Não foi possivel bloquear o registro da liberação do pedido de venda'
#Define X_MENS010   'O fornecedor do pedido de venda não foi encontrado'
#Define X_MENS011   'O cliente do pedido de venda não foi encontrado'
#Define X_MENS012   'O cadastro do produto não foi encontrado'
#Define X_MENS013   'O armazem referente ao produto no item do pedido de venda não foi encontrado'
#Define X_MENS014   'O cadastro do armazem não foi encontrado'
#Define X_MENS015   'Pedido de Venda já possui nota fiscal'
#Define X_MENS016   'A liberação de um pedido rejeitado deve ser efetuada na Liberação Manual de Crédito'
#Define X_MENS017   'Para efetuar a liberação no Estoque é necessário que o pedido esteja liberadono por Crédito'
#Define X_MENS018   'Pedido bloqueado no Credito'

/*/{Protheus.doc} LIBERA_ESTOQUE_CLASS
	(Classe para realizar a liberação de estoque)

	@type Class
	@author Vitor Ribeiro
	@since 20/02/2019

	@return Nil, nulo, não tem retorno.
	/*/
Class LIBERA_ESTOQUE_CLASS
    /*
    Data cPedido as String ReadOnly     // Numero pedido de venda
    Data cItem as String ReadOnly       // Item do pedido de venda
    Data cProduto as String ReadOnly    // Produto do item do pedido de venda
    Data cSequen as String ReadOnly     // Sequencia do item do pedido de venda
    Data cMensagem as String ReadOnly   // Mensagem de execução
    Data nQtdeLiber as Numeric ReadOnly // Quantidade a ser liberada
    Data nCodErro as Numeric ReadOnly   // Codigo do erro
    */

    Data cPedido as String      // Numero pedido de venda
    Data cItem as String        // Item do pedido de venda
    Data cProduto as String     // Produto do item do pedido de venda
    Data cSequen as String      // Sequencia do item do pedido de venda
    Data cMensagem as String    // Mensagem de execução
    Data nQtdeLiber as Numeric  // Quantidade a ser liberada
    Data nCodErro as Numeric    // Codigo do erro

    Method New() Constructor            // Metodo construtor
    Method SetPedido(c_Set)             // Metodo para setar o numero do pedido
    Method GetPedido()                  // Metodo para retornar o numero do pedido de venda
    Method SetItem(c_Set)               // Metodo para setar o item do pedido
    Method GetItem()                    // Metodo para retornar o item do pedido
    Method SetProduto(c_Set)            // Metodo para setar o produto do item do pedido
    Method GetProduto()                 // Metodo para retornar o produto do item do pedido
    Method SetSequen(c_Set)             // Metodo para setar a sequencia de liberação do item do pedido
    Method GetSequen()                  // Metodo para retornar a sequencia de liberação do item do pedido
    Method SetQtdeLiber(n_Set)          // Metodo para setar a quantidade a ser liberada
    Method GetQtdeLiber()               // Metodo para retornar a quantidade a ser liberada
    Method Executar()                   // Metodo para executar a liberação de estoque
    Method Valida()                     // Metodo para validar as informações
    Method GetMensagem()                // Metodo para retornar a mensagem
    Method GetCodErro()                 // Metodo para retornar o codigo do erro

EndClass

/*/{Protheus.doc} New
	(Method construtor da classe)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

	@return Self, objeto, retorna o objeto da classe LIBERA_ESTOQUE_CLASS
	/*/
Method New() Class LIBERA_ESTOQUE_CLASS

    Self:cPedido := ''
    Self:cItem := ''
    Self:cMensagem := ''

    Self:nQtdeLiber := 0
    Self:nCodErro := X_ERRO099

Return Self

/*/{Protheus.doc} SetPedido
	(Method para setar o numero do pedido)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

    @param c_Set, caracter, contém o numero do pedido de venda

	@return Nil, nulo, não tem retorno
	/*/
Method SetPedido(c_Set) Class LIBERA_ESTOQUE_CLASS

    Default c_Set := ''

    Self:cPedido := PadR(c_Set,TamSX3('C5_NUM')[1])

Return Nil

/*/{Protheus.doc} GetPedido
	(Method para retornar o numero do pedido de venda)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

	@return cPedido, caracter, contém o numero do pedido
	/*/
Method GetPedido() Class LIBERA_ESTOQUE_CLASS
Return Self:cPedido

/*/{Protheus.doc} SetItem
	(Method para setar o item do pedido)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

    @param c_Set, caracter, contém o item do pedido de venda

	@return Nil, nulo, não tem retorno
	/*/
Method SetItem(c_Set) Class LIBERA_ESTOQUE_CLASS

    Default c_Set := ''

    Self:cItem := PadR(c_Set,TamSX3('C6_ITEM')[1])

Return Nil

/*/{Protheus.doc} GetItem
	(Method para retornar o item do pedido de venda)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

	@return cItem, caracter, contém o item do pedido
	/*/
Method GetItem() Class LIBERA_ESTOQUE_CLASS
Return Self:cItem

/*/{Protheus.doc} SetProduto
	(Method para setar o produto do item do pedido)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

    @param c_Set, caracter, contém o item do pedido de venda

	@return Nil, nulo, não tem retorno
	/*/
Method SetProduto(c_Set) Class LIBERA_ESTOQUE_CLASS

    Default c_Set := ''

    Self:cProduto := PadR(c_Set,TamSX3('C6_PRODUTO')[1])

Return Nil

/*/{Protheus.doc} GetProduto
	(Method para retornar o produto do item do pedido de venda)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

	@return cProduto, caracter, contém o produto item do pedido
	/*/
Method GetProduto() Class LIBERA_ESTOQUE_CLASS
Return Self:cProduto

/*/{Protheus.doc} SetSequen
	(Method para setar a sequencia de liberação do item do pedido)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

    @param c_Set, caracter, contém a sequencia de liberação do item do pedido

	@return Nil, nulo, não tem retorno
	/*/
Method SetSequen(c_Set) Class LIBERA_ESTOQUE_CLASS

    Default c_Set := ''

    Self:cSequen := PadR(c_Set,TamSX3('C9_SEQUEN')[1])

Return Nil

/*/{Protheus.doc} GetSequen
	(Method para retornar a sequencia de liberação do item do pedido)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

	@return cSequen, caracter, contém a sequencia de liberação do item do pedido
	/*/
Method GetSequen() Class LIBERA_ESTOQUE_CLASS
Return Self:cSequen

/*/{Protheus.doc} SetQtdeLiber
	(Method para setar a quantidade a ser liberada)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

    @param n_Set, numerico, contém o quantidade a ser liberada

	@return Nil, nulo, não tem retorno
	/*/
Method SetQtdeLiber(n_Set) Class LIBERA_ESTOQUE_CLASS

    Default n_Set := 0

    Self:nQtdeLiber := n_Set

Return Nil

/*/{Protheus.doc} GetQtdeLiber
	(Method para retornar a quantidade a ser liberada)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

	@return nQtdeLiber, numerico, quantidade a ser liberada
	/*/
Method GetQtdeLiber() Class LIBERA_ESTOQUE_CLASS
Return Self:nQtdeLiber

/*/{Protheus.doc} Executar
	(Metodo para executar a liberação de estoque)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

	@return _lContinua, logico, se executou com sucesso
	/*/
Method Executar() Class LIBERA_ESTOQUE_CLASS

    Local _aArea := GetArea()
    Local _aAreaSA1 := SA1->(GetArea())
    Local _aAreaSA2 := SA2->(GetArea())
    Local _aAreaSB1 := SB1->(GetArea())
    Local _aAreaSB2 := SB2->(GetArea())
    Local _aAreaNNR := NNR->(GetArea())
    Local _aAreaSM2 := SM2->(GetArea())
    Local _aAreaSC5 := SC5->(GetArea())
    Local _aAreaSC6 := SC6->(GetArea())
    Local _aAreaSC9 := SC9->(GetArea())

    Local _lContinua := .F.
    Local _lBloqRes := .F.

    Local _nVlrCred := 0
    Local _nQtdeSbr := 0

    // Status dos Bloqueios do pedido de venda. Se .T. DCF gerado, tem que estornar.
    Private lbloqDCF := !Empty(SC9->C9_BLCRED+SC9->C9_BLEST)

    DbSelectArea('SA1')     // CLIENTES
    SA1->(DbSetOrder(1))    // A1_FILIAL+A1_COD+A1_LOJA

    DbSelectArea('SA2')     // FORNECEDORES
    SA2->(DbSetOrder(1))    // A2_FILIAL+A2_COD+A2_LOJA

    DbSelectArea('SB1')     // DESCRIÇÃO GENÉRICA DO PRODUTO
    SB1->(DbSetOrder(1))    // B1_FILIAL+B1_COD

    DbSelectArea('SB2')     // SALDOS FÍSICO E FINANCEIRO
    SB2->(DbSetOrder(1))    // B2_FILIAL+B2_COD+B2_LOCAL

    DbSelectArea('NNR')     // LOCAIS DE ESTOQUE
    NNR->(DbSetOrder(1))    // NNR_FILIAL+NNR_CODIGO

    DbSelectArea('SM2')     // MOEDAS DO SISTEMA
    SM2->(DbSetOrder(1))    // M2_DATA

    DbSelectArea('SC5')     // PEDIDOS DE VENDA
    SC5->(DbSetOrder(1))    // C5_FILIAL+C5_NUM

    DbSelectArea('SC6')     // ITENS DOS PEDIDOS DE VENDA
    SC6->(DbSetOrder(1))    // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO

    DbSelectArea('SC9')     // PEDIDOS LIBERADOS
    SC9->(DbSetOrder(1))    // C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO+C9_BLEST+C9_BLCRED

    //Valida as informações antes de executar o MATA030
    _lContinua := Self:Valida()

    If _lContinua
        _lBloqRes := GetMv('MV_FTRESBL',,.T.)
        _nVlrCred := 0
        _nQtdeSbr := SC9->C9_QTDLIB - Self:nQtdeLiber

        Begin Transaction
            // Estorna a liberacao atual
            // A460Estorna(lMata410,lAtuEmp,nVlrCred,cTipLib)
            SC9->(A460Estorna(,,@_nVlrCred))

            // Libera novamente de acordo com a opcao do radio selecionada
            // MaLibDoFat(nRegSC6,nQtdaLib,lCredito,lEstoque,lAvCred,lAvEst,lLibPar,lTrfLocal,aEmpenho,bBlock,aEmpPronto,lTrocaLot,lGeraDCF,nVlrCred,nQtdalib2)
            MaLibDoFat(SC6->(RecNo()),@Self:nQtdeLiber,.T.,.T.,.F.,.F.,.F.,.F.,,,,,,@_nVlrCred,)

            If SuperGetMv('MV_GRVBLQ2') .And. _nQtdeSbr > 0
                MaLibDoFat(SC6->(RecNo()),@_nQtdeSbr,.T.,.F.,_lBloqRes,.F.,.F.,.F.,,,,,,@_nVlrCred,)
            EndIf

            SC6->(MaLiberOk({SC9->C9_PEDIDO},.F.))
        End Transaction

        Self:cMensagem := X_MENS000
        Self:nCodErro := X_ERRO000
    EndIf

    RestArea(_aAreaSC9)
    RestArea(_aAreaSC6)
    RestArea(_aAreaSC5)
    RestArea(_aAreaSM2)
    RestArea(_aAreaNNR)
    RestArea(_aAreaSB2)
    RestArea(_aAreaSB1)
    RestArea(_aAreaSA2)
    RestArea(_aAreaSA1)
    RestArea(_aArea)

Return _lContinua

/*/{Protheus.doc} Valida
	(Method para validar as informações)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

	@return _lContinua, logico, se foi validado ou não.
	/*/
Method Valida() Class LIBERA_ESTOQUE_CLASS

    Local _lContinua := .F.

    If Empty(Self:cPedido)
        Self:cMensagem := X_MENS001
        Self:nCodErro := X_ERRO001
    ElseIf Empty(Self:cItem)
        Self:cMensagem := X_MENS002
        Self:nCodErro := X_ERRO002
    ElseIf Empty(Self:nQtdeLiber)
        Self:cMensagem := X_MENS003
        Self:nCodErro := X_ERRO003
    ElseIf !SC5->(DbSeek(xFilial('SC5')+Self:cPedido))
        Self:cMensagem := X_MENS004
        Self:nCodErro := X_ERRO004
    ElseIf !SC6->(DbSeek(xFilial('SC6')+Self:cPedido+Self:cItem+Self:cProduto))
        Self:cMensagem := X_MENS005
        Self:nCodErro := X_ERRO005
    ElseIf !SC9->(DbSeek(xFilial('SC9')+Self:cPedido+Self:cItem+Self:cSequen+Self:cProduto))
        Self:cMensagem := X_MENS006
        Self:nCodErro := X_ERRO006
    ElseIf SC9->C9_QTDLIB < Self:nQtdeLiber
        Self:cMensagem := X_MENS007
        Self:nCodErro := X_ERRO007
    ElseIf !SoftLock("SC5")
        Self:cMensagem := X_MENS008
        Self:nCodErro := X_ERRO008
    ElseIf !SoftLock("SC9")
        Self:cMensagem := X_MENS009
        Self:nCodErro := X_ERRO009
    ElseIf SC5->C5_TIPO $ "DB" .And. !SA2->(DbSeek(xFilial('SA2')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
        Self:cMensagem := X_MENS010
        Self:nCodErro := X_ERRO010
    ElseIf !(SC5->C5_TIPO $ "DB") .And. !SA1->(DbSeek(xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
        Self:cMensagem := X_MENS011
        Self:nCodErro := X_ERRO011
    ElseIf !SB1->(DbSeek(xFilial('SB1')+SC9->C9_PRODUTO))
        Self:cMensagem := X_MENS012
        Self:nCodErro := X_ERRO012
    ElseIf !SB2->(DbSeek(xFilial('SB2')+SC6->C6_PRODUTO+SC6->C6_LOCAL))
        Self:cMensagem := X_MENS013
        Self:nCodErro := X_ERRO013
    ElseIf !NNR->(DbSeek(xFilial('NNR')+SC6->C6_LOCAL))
        Self:cMensagem := X_MENS014
        Self:nCodErro := X_ERRO014
    ElseIf SC9->C9_BLCRED == "10" .AND. SC9->C9_BLEST == "10"
        Self:cMensagem := X_MENS015
        Self:nCodErro := X_ERRO015
    ElseIf !Empty(SC9->C9_BLCRED)
        If SC9->C9_BLCRED == "09"
            Self:cMensagem := X_MENS016
            Self:nCodErro := X_ERRO016
        Else
            Self:cMensagem := X_MENS017
            Self:nCodErro := X_ERRO017
        EndIf
    ElseIf !Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)
        Self:cMensagem := X_MENS018
        Self:nCodErro := X_ERRO018
    Else
        SM2->(DbSeek(dDataBase,.T.))

        _lContinua := .T.
    EndIf

Return _lContinua

/*/{Protheus.doc} GetMensagem
	(Method para recuperar a mensagem)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

	@return cMensagem, caracter, mensagem
	/*/
Method GetMensagem() Class LIBERA_ESTOQUE_CLASS
Return Self:cMensagem

/*/{Protheus.doc} GetCodErro
	(Method para recuperar o valor do atributo nCodErro)

	@type Method
	@author Vitor Ribeiro
	@since 20/02/2019

	@return nCodErro, numerico, numero do erro ocorrido
	/*/
Method GetCodErro() Class LIBERA_ESTOQUE_CLASS
Return Self:nCodErro
