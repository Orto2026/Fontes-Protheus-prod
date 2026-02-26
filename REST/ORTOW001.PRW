#include 'totvs.ch'
#include 'restful.ch'

#DEFINE QRY           "CONSULTA_BD"
//TODO APLICAR EM BASE REAL

WSRESTFUL Consultas DESCRIPTION 'API consulta de entidades' FORMAT APPLICATION_JSON
    /*/{Protheus.doc} 
	Web service responsável por viabilizar consultas de tabelas e inclusao de pedidos pelo e-commerce da Ortosíntese
	@type function
	@version 1.0
	@author George Allan
	@since 07/10/2020
    /*/    
	WSDATA cTabela      As Character
	WSDATA cCampos      AS Character
	WSDATA cParametros  As Character
	WSDATA cQuery       As Character
	WSDATA cPagina      As Character
	WSDATA cTamPagina   As Character
	WSDATA cCodCli      As Character
	WSDATA cLojCli      As Character
	WSDATA cError       As Character

	WSMETHOD GET  simples             DESCRIPTION 'ConsultaSimples'                 WSSYNTAX '/Consultas{cTabela}'              PRODUCES APPLICATION_JSON
	WSMETHOD POST simplesPost         DESCRIPTION 'ConsultaSimplesPost'             WSSYNTAX '/Consultas/simplespost'           PRODUCES APPLICATION_JSON
	WSMETHOD PUT  inclusaoPedido      DESCRIPTION 'Inclusion de pedidos de venda'   WSSYNTAX '/Consultas/inclusaoPedido'        PRODUCES APPLICATION_JSON
ENDWSRESTFUL

WSMETHOD PUT inclusaoPedido WSRESTFUL Consultas
    /*/{Protheus.doc} 
Método WS para inclusão de pedido de venda
@type function
@version 1.0
@author George Allan
@since 07/10/2020
    /*/

Local lRet  := .T.
local i
Local aArea := GetArea()
Local aCabec
Local aItens
Local aLinha

Local oJson
Local oSC6

Local cJson     := Self:GetContent()


Local nX


Private lMsErroAuto     := .F.
Private lMsHelpAuto     := .T.
Private lAutoErrNoFile  := .T.

//Self:SetContentType("application/json; utf-8")
Self:SetContentType("application/json")



oJson       := JsonObject():New()
cMsgErro    := ValidSC5SC6(cJson)

if empty(cMsgErro)
	//CONOUT('ENTROU NO IF')
	oJson:FromJson(cJson)
	aCabec  := {}
	aItens  := {}

	aCamposSC5 := StrToKArr(getInfoJson(oJson, "SC5_ORDEM"), ',')

	aCamposSC6 := StrToKArr(getInfoJson(oJson, "SC6_ORDEM"), ',')
	//CONOUT("TEMOS " + cValToChar(len(aCamposSC5)) + " campos no SC5")
	//CONOUT("TEMOS " + cValToChar(len(aCamposSC6)) + " campos no SC6")
	for i:= 1 to len(aCamposSC5)
		cCampo  := AllTrim(aCamposSC5[i])
		//CONOUT('ENTROU NO FOR DO C5')
		if left(cCampo, 2) == 'C5'
			//CONOUT('PREENCHEU O ACABEC')
			aAdd(aCabec,{cCampo, getInfoJson(oJson, cCampo)           ,       NIL})
		endif
	next

	oSC6  := oJson:GetJsonObject('SC6')
	For nX  := 1 To Len(oSC6)
		aLinha  := {}
		aAdd(aLinha,{"C6_ITEM",     StrZero(nX,2)                     ,       NIL})
		for i:= 1 to len(aCamposSC6)
			cCampo  := AllTrim(aCamposSC6[i])
			if left(cCampo, 2) == 'C6'
				//CONOUT('PREENCHEU OS ITENS')
				aAdd(aLinha,{cCampo, getInfoJson(oSC6[nX], cCampo)       ,       NIL})
			endif
		next
		aAdd(aItens,aLinha)
	Next nX
	//CONOUT('VAI RODAR O EXECAUTO')
	//Chama a inclusão automática de pedido de venda
	MsExecAuto({|x, y, z| MATA410(x, y, z)},aCabec,aItens,3)

	//Se houve erro, gera um arquivo de log dentro do diretório da protheus data
	IF lMsErroAuto
		//CONOUT('DEU PAU NO EXECAUTO')
		cErro:= ''
		aLog := GetAutoGRLog()
		for i:= 1 to len(aLog)
			//conout(cErro+=aLog[i]+chr(10)+chr(13))
		next
		SetRestFault(500, EncodeUTF8(cErro))
		lRet    := .F.
	ELSE
		//CONOUT('DEU CERTO O EXECAUTO')
		cJsonRet    := '{"Pedido gerado com sucesso":"'+ SC5->C5_NUM +'"}'
		Self:SetResponse(EncodeUTF8(cJsonRet))
	EndIF
else
	//CONOUT('RETORNA O ERRO NO SETRESTFAULT')
	SetRestFault(500, EncodeUTF8(cMsgErro))
	lRet    := .F.
endif
RestArea(aArea)
FreeObj(oJson)

Return(lRet)

WSMETHOD GET simples WSRECEIVE cTabela WSRESTFUL Consultas
    /*/{Protheus.doc} 
Método para consulta genérica de tabelas do Protheus
@type function
@version 1.0
@author George Allan
@since 07/10/2020
    /*/
Local lRet      := .T.
//local cResult   := ''
self:SetResponse(EncodeUTF8("MÉTODO DESABILITADO"))
    /*conout('ANTES DA CONSULTA')
    cResult := consulta(self:cTabela, self:cCampos, self:cParametros, self:cQuery, self:cPagina, self:cTamPagina)
    //conout('DEPOIS DA CONSULTA')
    //conout(cResult)
    Self:SetResponse(cResult)*/
Return(lRet)

WSMETHOD POST simplesPost WSRECEIVE WSRESTFUL Consultas
    /*/{Protheus.doc} 
    Método para consulta genérica de tabelas do Protheus. Eu fiz por post pois o get não estava funcionando bem quando utilizávamos % em filtros do tipo 'like' do SQL
    @type function
    @version 1.0
    @author George Allan
    @since 07/10/2020
    /*/
    local lRet               := .T.
    local cJson              := Self:GetContent()
    local oJson              := JsonObject():New()
    local cTabelasPermitidas := Alltrim(SuperGetMV("UF_WSTABEL" , .F., "*"))
    local cError

    Self:SetContentType("application/json")
    
    cError  := oJson:FromJson(cJson)
 
    if !Empty(cError)
        cMensagem   := 'Parser Json Error:' + cError + chr(13) + chr(10) + 'JSON:' + cJson
        SetRestFault(500,EncodeUTF8(cMensagem))
        lRet    := .F.
    elseif AllTrim(cTabelasPermitidas) <> '*' .AND. !(AllTrim(self:cTabela) $ cTabelasPermitidas)
        cMensagem   := 'A tabela ' + self:cTabela + ' não pode ser consultada por este WS, para liberaçao altere o parametro: UF_WSTABEL'
        SetRestFault(500,EncodeUTF8(cMensagem))
        lRet    := .F.
    else
        if validaParametros(oJson, @self, oJson:GetJsonObject("cTabela"))
            if !empty(self:cTabela)
                cResult := consulta(self:cTabela, self:cCampos, self:cParametros, self:cQuery, self:cPagina, self:cTamPagina)
            else
                cResult := pendenciaFinanceira(self:cCodCli, self:cLojCli)
            endif
            Self:SetResponse(cResult)
        else
            SetRestFault(500,EncodeUTF8(self:cError))
            lRet    := .F.
        endif
    EndIf
    FreeObj(oJson)
Return(lRet)

Static Function ValidSC5SC6(cJson)
    /*/{Protheus.doc} ValidSC5SC6
    Função auxiliar que valida se o JSON passado para criação do pedido de venda tem as características mínimas para ser processado pelo Protheus
    @type function
    @version 1.0
    @author George Allan
    @since 07/10/2020
    @param cJson, character, json de entrada 
    @return character, retorna a mensagem de erro (se houver), caso nao haja entao retorna vazio
    /*/
    local oJson     := JsonObject():New()
    local cError    := oJson:FromJson(cJson)

    local cResult   := ''

    SA1->(dbSetOrder(1))    
    if empty(cResult) .AND. !Empty(cError)
        //conout('ERRO PARSE')
        cResult := 'Parser Json Error:' + cError
    endIf
    
    if empty(cResult) .AND. !(SA1->(dbSeek(FWxFilial("SA1")+PadR(oJson:GetJsonObject('C5_CLIENTE'),TamSX3("C5_CLIENTE")[1])+PadR(oJson:GetJsonObject('C5_LOJACLI'),TamSX3("C5_LOJACLI")[1]))))
        //conout('CLIENTE NÃO ENCONTRADO')
        cResult := 'Não encontramos o cliente'
    endif
    
    if empty(cResult) .AND. empty(getInfoJson(oJson, "SC5_ORDEM"))
        //conout('CAMPO SC5_ORDEM')
        cResult :=  'POR FAVOR INFORME A PROPRIEDADE ORDEM NO JSON PARA DEFINIR A ORDEM DOS CAMPOS A SEREM INCLUIDOS NO SC5, COLOQUE OS CAMPOS SEPARADOS POR VÍRGULA, DESTA FORMA: "SC5_ORDEM": "C5_TIPO, C5_CLIENTE, C5_ETC"'
    endif
    
    if empty(cResult) .AND. empty(getInfoJson(oJson, "SC6"))
        //conout('CAMPO SC6')
        cResult :=  'POR FAVOR INFORME OS ITENS(SC6)'
    endif

    if empty(cResult) .AND. empty(getInfoJson(oJson, "SC6_ORDEM"))
        //conout('CAMPO SC6ORDEM')
        cResult :=  'POR FAVOR INFORME A PROPRIEDADE ORDEM NO JSON PARA DEFINIR A ORDEM DOS CAMPOS A SEREM INCLUIDOS NO SC6, COLOQUE OS CAMPOS SEPARADOS POR VÍRGULA, DESTA FORMA: "SC6_ORDEM": "C6_PRODUTO, C6_ETC"'
    endif

    //conout('TERMINOU A VALIDACAO COM ' + cResult)
return cResult

Static Function getInfoJson(oJson, cCampo)
    /*/{Protheus.doc} getInfoJson
    Funcao auxiliar que pega a informacao que esta no JSON e a retorna. Fiz isto para evitar no fonte principal ficar pesquisando dentro do JSON, ou seja, esta funcao basicamente facilita o acesso às chaves do json
    @type function
    @version 1.0
    @author George Allan
    @since 07/10/2020
    @param oJson, object, Objeto json
    @param cCampo, character, Qual chave do JSON deve ser retornada
    @return X, Conteudo, independentemente do tipo
    /*/
    local xResult
    //cResult := oJson:GetJsonObject(cCampo)
    xResult := oJSON[cCampo]
    //conout(cCampo + ' TIPO ' + valtype(xResult))
    if GetSx3Cache(cCampo, "X3_TIPO") == 'D'
        xResult := STOD(xResult)
    endif
return xResult

Static Function validaParametros(oJson, self, cTabela)
    /*/{Protheus.doc} validaParametros
    Funcao auxiliar que faz uma validacao previa dos parametros do ws de consulta de tabelas e tambem ja coloca os valores do json em propriedades do objeto, para ficar mais facil a manipulacao no fonte
    @type function
    @version 1.0
    @author George Allan
    @since 07/10/2020
    @param oJson, object, Objeto JSON
    @param self, object, Objeto WS
    @param cTabela, character, Parametro tabela, este parametro eu utilizei para diferenciar a chamada do metodo quando eh query completa (cTabela ficaria vazio) ou quando o usuario quer fazer a consulta por tabela (passando campos, tabela e parametros)
    @return logical, Retorna true ou false
    /*/
    local lResult       := .T.
    local cPodeQuery := Alltrim(SuperGetMV("UF_WSQUERY" , .F., "S"))

    if !empty(cTabela)
        self:cTabela        := oJson:GetJsonObject("cTabela")
        self:cCampos        := oJson:GetJsonObject("cCampos")
        self:cParametros    := oJson:GetJsonObject("cParametros")
        self:cQuery         := oJson:GetJsonObject("cQuery")
        self:cPagina        := oJson:GetJsonObject("cPagina")
        self:cTamPagina     := oJson:GetJsonObject("cTamPagina")
    else
        self:cCodCli        := oJson:GetJsonObject("cCodCli")
        self:cLojCli        := oJson:GetJsonObject("cLojCli")
        SA1->(dbSetOrder(1))// filial + cod + loja
        if !SA1->(dbSeek(xFilial('SA1')+self:cCodCli+self:cLojCli))
            lResult := .F.
            self:cError := 'CLIENTE NÃO ENCONTRADO NA BASE DE DADOS'
        endif
    endif
    if !empty(self:cQuery) .AND. cPodeQuery <> 'S'
        lResult := .F.
        self:cError := 'Não é permitido o uso de Query. Ative o parametro UF_WSQUERY para S para poder utilizá-las.'
    endif
return lResult

Static Function consulta(cTabela, cCampos, cParametros, cQuery, cPagina, cTamPagina)
    /*/{Protheus.doc} consulta
    Esta funcao eh quem monta a query e faz a consulta e o retorno dos dados que estão no Protheus
    @type function
    @version 1.0
    @author George Allan
    @since 07/10/2020
    @param cTabela, character, Qual tabela será pesquisada
    @param cCampos, character, Campos que serão retornados
    @param cParametros, character, Parametros que serao utilizados para filtrar a tabela
    @param cQuery, character, Query de consulta a ser feita no banco. 
    @param cPagina, character, Página de retorno dos dados. 
    @param cTamPagina, character, Tamanho da página de retorno. O padrão são 50 registros
    @return character, retorna o JSON com o retorno da query montada
    /*/
    local cResult            := ''
    
    cTabela                  := iif(empty(cTabela)       , ''    , cTabela       )
    cCampos                  := iif(empty(cCampos)       , ' * ' , cCampos       )
    cParametros              := iif(empty(cParametros)   , '   ' , cParametros   )
    cQuery                   := iif(empty(cQuery)        , ''    , cQuery        )
    cPagina                  := iif(empty(cPagina)       , '1'   , cPagina       )
    cTamPagina               := iif(empty(cTamPagina)    , '50'  , cTamPagina    )

    if empty(cQuery)
        cQuery  += " SELECT "
        cQuery  += cCampos
        cQuery  += " FROM "
        
        if len(AllTrim(cTabela)) == 3
            cQuery  += retSqlName(cTabela)
        else
            cQuery  += cTabela
        endif

        if !empty(cParametros)
            cQuery  += " WHERE D_E_L_E_T_ <> '*' AND "
            cQuery  += cParametros
        endif
    endif

    if Select(QRY) > 0
    	(QRY)->(DbCloseArea())
    endIf

    //conout(cQuery)
    
    DBUseArea(.T., "TOPCONN", TCGenQry2(NIL,NIL,cQuery, {  } ), QRY, .F., .T. )
    
    cResult := aliasToJson(QRY, cPagina, cTamPagina)
    
    if Select(QRY) > 0
    	(QRY)->(DbCloseArea())
    endIf
return cResult

Static Function pendenciaFinanceira(cCodCli, cLojCli)
    /*/{Protheus.doc} pendenciaFinanceira
    Esta consulta verifica no SE1 se o cliente tem algum titulo em aberto, e retorna a quantidade de dias do titulo que esta há mais tempo aberto
    @type function
    @version 1.0
    @author George Allan
    @since 07/10/2020
    @param cCodCli, character, Codigo do cliente
    @param cLojCli, character, Loja do cliente
    @return character, Retorna o JSON com a quantidade de dias
    /*/
    local cResult       := ''
    local cQuery        := ''
    local cDiasAtraso   := Alltrim(SuperGetMV("UF_WSDATR" , .F., "10"))
    local oJSON         := JSONObject():New()
 
    cQuery  += " SELECT MAX(DATEDIFF(day, E1_VENCTO, convert(varchar(8),getdate(),112))) AS DIAS_ATRASO FROM " + RetSqlName('SE1')
    cQuery  += " WHERE DATEDIFF(day, E1_VENCTO, convert(varchar(8),getdate(),112)) > " + cDiasAtraso
    cQuery  += " AND D_E_L_E_T_ <> '*' AND E1_CLIENTE + E1_LOJA = '" + Padr(cCodCli, TamSX3("A1_COD")[1]) + Padr(cLojCli, TamSX3("A1_LOJA")[1]) + "' "
    cQuery  += " AND E1_SALDO > 0 "

    if Select(QRY) > 0
    	(QRY)->(DbCloseArea())
    endIf
    DBUseArea(.T., "TOPCONN", TCGenQry2(NIL,NIL,cQuery, {  } ), QRY, .F., .T. )

    oJSON['maiorAtraso' ] := '0'

    if !(QRY)->(EOF())
        oJSON['maiorAtraso' ] := cValToChar((QRY)->DIAS_ATRASO)
    endif 

    cResult := oJson:toJSON()
    if Select(QRY) > 0
    	(QRY)->(DbCloseArea())
    endIf    
return cResult

User Function TesteChamada()
    /*/{Protheus.doc} TesteChamada
    Funcao auxiliar apenas para testes internos
    @type function
    @version 1.0
    @author George Allan
    @since 07/10/2020
    @return character, retorno
    /*/
    cResult := consulta('SA1', 'A1_COD', "A1_COD>'0'")
    

    /*

    oJSON := JSONObject():New()
    oJSON['nome' ] := 'Diego'
    oJSON['cursos'] := { }

    aAdd( oJSON['cursos'], JSONObject():New() )
    oJSON['cursos'][ 1 ]['nome'] := 'ADVPL'
    oJSON['cursos'][ 1 ]['nota'] := 10

    aAdd( oJSON['cursos'], JSONObject():New() )
    oJSON['cursos'][ 2 ]['nome'] := 'Rest'
    oJSON['cursos'][ 2 ]['nota'] := 10

    conout(replicate('-', 30))
    conout(oJson:toJSON())
    conout(replicate('-', 30))
    */


return cResult

Static Function aliasToJson(cAlias, cPagina, cTamPagina)
    /*/{Protheus.doc} aliasToJson
	Funcao auxiliar que transforma registros de uma tabela/alias em JSON
	@type function
	@version 1.0
	@author George Allan
	@since 07/10/2020
	@param cAlias, character, Alias da tabela
	@param cPagina, character, Pagina a ser retornada
	@param cTamPagina, character, Tamanho da pagina
	@return character, retorna o JSON
    /*/
	local cResult   := ''
	local nCount    := 0
	local oJSON     := JSONObject():New()
	local nPagina   := val(cPagina)
	local nTamPagina:= val(cTamPagina)
	oJson[cAlias]   := {}
	(cAlias)->(dbGoTop())
	//conout('vai entrar no while')

	if nPagina > 1
		(cAlias)->(dbSkip(nTamPagina*(nPagina-1)))
	endif

	//conout(cValToChar(nCount))
	//conout(cValToChar(nTamPagina))
	//conout(cValToChar((cAlias)->(EOF())))
	while !(cAlias)->(EOF()) .AND. nCount < nTamPagina
		//conout('entrou no while')
		nCount++
		aAdd( oJSON[cAlias], RegToJson(cAlias, .F.) )

		(cAlias)->(dbSkip())
		//conout(oJson:toJson())
	enddo

	oJson['hasNext']    := !(cAlias)->(EOF())

	cResult := oJson:toJSON()

return cResult

Static Function RegToJson(cAlias, lJson)
    /*/{Protheus.doc} RegToJson
	Funcao auxiliar que transforma UM registro em JSON
	@type function
	@version 1.0
	@author George Allan
	@since 07/10/2020
	@param cAlias, character, Alias a ser transformado
	@param lJson, logical, Indica se o retorno eh para ser json ou objeto
	@return variadic, Retorna o json ou objeto
    /*/
	local xResult

	local oJSON := JSONObject():New()
	local i
	default lJson   := .T.

	dbSelectArea(cAlias)

	for i:= 1 to (cAlias)->(Fcount())
		oJson[(cAlias)->(Field(i))]   := (cAlias)->&(Field(i))
	next

	if lJson
		xResult := oJson:toJSON()
	else
		xResult := oJson
	endif

return xResult
