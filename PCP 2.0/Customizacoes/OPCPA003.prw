#Include "Protheus.ch"
#Include "FWMVCDef.ch"
#Include "TopConn.ch"
#Include "ParmType.ch"
#Include "RwMake.ch" 
#Include "Totvs.ch"
#Include "FileIo.ch"
#Include "TbiConn.ch"
#Include "Msole.ch"
#Include "OPCPA002.ch"

#Define TYPE_MODEL	01
#Define TYPE_VIEW	02

// Definição dos campos do cabeçalho
#Define W_SZS_CAB {"ZS_FILIAL","ZS_ID","ZS_TIPPROC","ZS_OP","ZS_PRODOP","ZS_DESCOP","ZS_QTDEOP","ZS_USER","ZS_DATA","ZS_HORA"}

/*/{Protheus.doc} OPCPA003
	(Tela de auto empenho)

	@type User Function
	@author Vitor Ribeiro
	@since 02/03/2020

	@param c_Filtra, caracter, contém a expressão do filtro

	@return Nil, nulo, não tem retorno.

    @Obs MVC modelo 2

    Explicação do nome do fonte OPCPA003
        O...: Nome da empresa - Ortosintese
        PCP.: Sigla do modulo - Planej.Contr.Produção
        A...: Atualização
        002.: Numero sequencial
	/*/
User Function OPCPA003(c_Filtra)
	
	Local _oBrowse := Nil

    Private _cDescript := ""

	Default c_Filtra := ""

    DbSelectArea("SZS")     // LOG DE AUTO EMPENHOS
    SZS->(DbSetOrder(1))    // ZS_FILIAL+ZS_ID

    // Retorna o nome da tabela
    _cDescript := FwSX2Util():GetX2Name("SZS")

	// Instanciamento da Classe de Browse
	_oBrowse := FWMBrowse():New()
	
	// Definição da tabela do Browse inicial 
	_oBrowse:SetAlias("SZS")
	
	// Titulo da Browse
	_oBrowse:SetDescription(_cDescript)

	// Adiciona a coluna com a legenda.
	_oBrowse:AddLegend({|| Empty(SZS->ZS_TIPPROC) },"BR_PRETO","Processo realizado pelo modelo antigo")
	_oBrowse:AddLegend({|| SZS->ZS_TIPPROC == "P" },"BR_AZUL","Auto empenho para produção")
	_oBrowse:AddLegend({|| SZS->ZS_TIPPROC == "D" },"BR_VERMELHO","Devolvido estoque empenhado")

	If !Empty(c_Filtra)
		_oBrowse:SetFilterDefault(c_Filtra)
	EndIf

	// Define o menu
    _oBrowse:SetMenuDef("OPCPA003")
	
	// Ativação da Classe
	_oBrowse:Activate()

	/*
		Treicho incluído para que o compilador não avise das funções do MVC que não são chamadas
	 */
	If .F.
		MenuDef()
		ModelDef()
		ViewDef()
		_FCOMMIT()
	EndIf

Return NIL

/*/{Protheus.doc} MenuDef
	(Contém as informações do Menu)

	@type Static Function
	@author Vitor Ribeiro
	@since 02/03/2020

	@return Nil, nulo, não tem retorno.
	/*/
Static Function MenuDef()

	Local _aRotina := {}
	Local nx  := 0 // Por Samuel mirnada 04112021
	// Configiração para impressão de OP conforme solicitação Chamado numero  12739 el Miranda 24/06/2021
	Private _aGrpUser  := UsrRetGrp(RetCodUsr()) //Pega grupos do usuário
	//Private _IdGrpUser := UsrRetGrp(RetCodUsr())[1]

	ADD OPTION _aRotina Title "Visualizar"	 		ACTION "VIEWDEF.OPCPA003"				OPERATION MODEL_OPERATION_VIEW		ACCESS 0
	ADD OPTION _aRotina Title "Simular"				ACTION "U_PP002A01(1)"					OPERATION MODEL_OPERATION_INSERT    ACCESS 0
	ADD OPTION _aRotina Title "Empenhar"			ACTION "U_PP002A01(2)"					OPERATION MODEL_OPERATION_INSERT    ACCESS 0
	ADD OPTION _aRotina Title "Devolver"			ACTION "U_PP002A01(3)"					OPERATION MODEL_OPERATION_UPDATE    ACCESS 0
	// Verifica se o Usuário logado  pertence ao grupos de acesso |Poda 24/06/2021
	For nx := 1 to Len(_aGrpUser)
	  _IdGrpUser := UsrRetGrp(RetCodUsr())[nx]
		If _IdGrpUser $ "000007/000000"
			ADD OPTION _aRotina Title "PFI Equipamentos"	ACTION "U_xMTR797Z(4)"			OPERATION MODEL_OPERATION_VIEW		ACCESS 0 // Por Samuel mirnada 04112021
			//ADD OPTION _aRotina Title "PFI Equipamentos"	ACTION "U_xMTR797Z(4)"			OPERATION MODEL_OPERATION_VIEW		ACCESS 0
		EndIf
	Next nx
	//ADD OPTION _aRotina Title "Relatório de Log's"	ACTION "U_PP002A01(4)"				OPERATION MODEL_OPERATION_VIEW		ACCESS 0
	ADD OPTION _aRotina Title "Imprimir"			ACTION "U_RORTF005(SZS->ZS_ID, .T.)"	OPERATION MODEL_OPERATION_VIEW		ACCESS 0
	
Return _aRotina

/*/{Protheus.doc} ModelDef
	(Contém a construção e a definição do Model, lembrando que o Modelo de dados (Model) contém as regras de negócio)

	@type Static function
	@author Vitor Ribeiro
	@since 02/03/2020

	@return _oModel, objeto, retorna o modelo
	/*/
Static Function ModelDef()

	Local _oModel := Nil
	Local _oStrCab := Nil
	Local _oStrSZS := Nil

	Local _bCommit := {|| }

    _oStrCab := _fMkStrut(TYPE_MODEL,W_SZS_CAB,"SZS",_cDescript)
	_oStrSZS := FWFormStruct(1,"SZS")
	_oStrSZS:AddField("","","ZS_LEGENDA","C",50,0,Nil,Nil,Nil,Nil,{|| _fGetLegen(SZS->ZS_PROCESS) },Nil,Nil,.T.)

    //_bCommit := {|_oModel| _fCommit(_oModel) }
	
	//Criando o FormModel, adicionando o Cabeçalho e Grid
	_oModel := MPFormModel():New("U_OPCPA003",,,_bCommit) 
	
    // Adiciona o cabecalho
    _oModel:AddFields("MODEL_CAB",,_oStrCab)

	// Adicona os itens
    _oModel:AddGrid("MODEL_SZS","MODEL_CAB",_oStrSZS)
	
	_oModel:SetRelation("MODEL_SZS",{{"ZS_FILIAL","XFILIAL('SZS')"},{"ZS_ID","ZS_ID"}},SZS->(IndexKey(1)))

	_oModel:GetModel("MODEL_SZS"):SetUniqueLine({"ZS_ID"})

    _oModel:GetModel("MODEL_SZS"):SetDescription("Itens")
	
Return _oModel

/*/{Protheus.doc} _fMkStrut
	(Função para montar a estrutura da grid)

	@type Static Function
	@author Vitor Ribeiro
	@since 02/03/2020

	@param n_Type, numerico, contém o tipo que deverá retornar a estrutura (1=Tipo Model | 2=Tipo View)
    @param a_Cpos, array, contém os campos
    @param c_Tabela, caracter, contém a tabela
    @param c_Descript, caracter, contém a descrição da tabela

	@return _oStruct, objeto, retorna a estrutura da model ou da view
	/*/
Static Function _fMkStrut(n_Type,a_Cpos,c_Tabela,c_Descript)

	Local _oStruct := Nil

	Local _aEstrut := {}
	
	Local _nCount := 0
	
	Default n_Type := 1 // 1=Tipo Model | 2=Tipo View

    Default a_Cpos := {}

    Default c_Tabela := ""
    Default c_Descript := ""

	// Busca os campos do cabeçalho
	_aEstrut := _fGetCpos(a_Cpos,n_Type)

	If n_Type == 1
		// Classe responsável por representar uma estrutura de dados para um submodelo do Model
		_oStruct := FWFormModelStruct():New()

	    // Se foi informado a tabela
        If !Empty(c_Tabela)
            //Adiciona a tabela na estrutura temporária
	        _oStruct:AddTable(c_Tabela,a_Cpos,c_Descript)
        EndIf

		For _nCount := 1 To Len(_aEstrut)
			/*
				**Estrutura do campo tipo Model**
				[01] C Titulo do campo
				[02] C Descrição do campo
				[03] C identificador (ID) do Field
				[04] C Tipo do campo
				[05] N Tamanho do campo
				[06] N Decimal do campo
				[07] B Code-block de validação do campo
				[08] B Code-block de validação When do campo
				[09] A Lista de valores permitido do campo
				[10] L Indica se o campo tem preenchimento obrigatório
				[11] B Code-block de inicializacao do campo
				[12] L Indica se trata de um campo chave
				[13] L Indica se o campo pode receber valor em uma operação de update.
				[14] L Indica se o campo é virtual
                [15] C Valid do usuário em formato texto e sem alteração, usado para se criar o aHeader de compatibilidade
			*/
				_oStruct:AddField(;
					_aEstrut[_nCount][01],;
					_aEstrut[_nCount][02],;
					_aEstrut[_nCount][03],;
					_aEstrut[_nCount][04],;
					_aEstrut[_nCount][05],;
					_aEstrut[_nCount][06],;
					_aEstrut[_nCount][07],;
					_aEstrut[_nCount][08],;
					_aEstrut[_nCount][09],;
					_aEstrut[_nCount][10],;
					_aEstrut[_nCount][11],;
					_aEstrut[_nCount][12],;
					_aEstrut[_nCount][13],;
					_aEstrut[_nCount][14],;
					_aEstrut[_nCount][15];
				)
		Next
	Else
		// Classe responsável por representar uma estrutura de dados para um formulário do tipo FormGrid ou FormField do View.
		_oStruct := FWFormViewStruct():New()

		For _nCount := 1 To Len(_aEstrut)
			/*
				**Estrutura do campo tipo View**
				[01] C Nome do Campo
				[02] C Ordem
				[03] C Titulo do campo
				[04] C Descrição do campo
				[05] A Array com Help
				[06] C Tipo do campo
				[07] C Picture
				[08] B Bloco de Picture Var
				[09] C Consulta F3
				[10] L Indica se o campo é evitável
				[11] C Pasta do campo
				[12] C Agrupamento do campo
				[13] A Lista de valores permitido do campo (Combo)
				[14] N Tamanho Maximo da maior opção do combo
				[15] C Inicializador de Browse
				[16] L Indica se o campo é virtual
				[17] C Picture Variável
                [18] L Se verdadeiro, indica pulo de linha após o campo	
                [19] N Largura fixa da apresentação do campo
			*/
			_oStruct:AddField(;
				_aEstrut[_nCount][01],;
				_aEstrut[_nCount][02],;
				_aEstrut[_nCount][03],;
				_aEstrut[_nCount][04],;
				_aEstrut[_nCount][05],;
				_aEstrut[_nCount][06],;
				_aEstrut[_nCount][07],;
				_aEstrut[_nCount][08],;
				_aEstrut[_nCount][09],;
				_aEstrut[_nCount][10],;
				_aEstrut[_nCount][11],;
				_aEstrut[_nCount][12],;
				_aEstrut[_nCount][13],;
				_aEstrut[_nCount][14],;
				_aEstrut[_nCount][15],;
				_aEstrut[_nCount][16],;
				_aEstrut[_nCount][17],;
				_aEstrut[_nCount][18],;
				_aEstrut[_nCount][19];
			)
		Next
	EndIf

Return _oStruct

/*/{Protheus.doc} _fGetCpos
	(Função para buscar a estrutura dos campos da grid)

	@type Static Function
	@author Vitor Ribeiro
	@since 02/03/2020

    @param a_Cpos, array, contém os campos
	@param n_Type, numerico, contém o tipo que deverá retornar a estrutura (1=Tipo Model | 2=Tipo View)

	@return _aEstrut, array, contém a estrutura dos campos
	/*/
Static Function _fGetCpos(a_Cpos,n_Type)

	Local _aEstrut := {}

	Local _nCount := 0
    Local _nPosicao := 0

	Local _cValid := ""
	Local _cVldUser := ""

	Local _bValid := {|| }

	Default a_Cpos := {}
	
	Default n_Type := 0

    For _nCount := 1 To Len(a_Cpos)
        // Monta a estrutura
        _nPosicao := AddEstrut(@_aEstrut,n_Type)

        If n_Type == 1
			_cValid := GetSX3Cache(a_Cpos[_nCount],"X3_VALID")
			_cVldUser := GetSX3Cache(a_Cpos[_nCount],"X3_VLDUSER")

			If !Empty(_cValid) .And. !Empty(_cVldUser)
				_bValid := &("{|| (" + AllTrim(_cValid) + ") .And. (" + AllTrim(_cVldUser) + ")}")
			Else
				_bValid := &("{|| (" + AllTrim(_cValid) + AllTrim(_cVldUser) + ")}")
			EndIf

			_aEstrut[_nPosicao][01] := FwX3Titulo(a_Cpos[_nCount])
			_aEstrut[_nPosicao][02] := FwSx3Util():GetDescription(a_Cpos[_nCount])
			_aEstrut[_nPosicao][03] := a_Cpos[_nCount]
			_aEstrut[_nPosicao][04] := FwSx3Util():GetFieldType(a_Cpos[_nCount])
			_aEstrut[_nPosicao][05] := GetSX3Cache(a_Cpos[_nCount],"X3_TAMANHO")
			_aEstrut[_nPosicao][06] := GetSX3Cache(a_Cpos[_nCount],"X3_DECIMAL")
			_aEstrut[_nPosicao][07] := _bValid
			_aEstrut[_nPosicao][08] := &("{|| " + GetSX3Cache(a_Cpos[_nCount],"X3_WHEN") + " }")
			_aEstrut[_nPosicao][11] := FwBuildFeature(STRUCT_FEATURE_INIPAD,GetSX3Cache(a_Cpos[_nCount],"X3_RELACAO"))
			_aEstrut[_nPosicao][14] := GetSX3Cache(a_Cpos[_nCount],"X3_CONTEXT") == "V"
		Else
			_aEstrut[_nPosicao][01] := a_Cpos[_nCount]
			_aEstrut[_nPosicao][02] := StrZero(_nPosicao,2)
			_aEstrut[_nPosicao][03] := FwX3Titulo(a_Cpos[_nCount])
			_aEstrut[_nPosicao][04] := FwSx3Util():GetDescription(a_Cpos[_nCount])
			_aEstrut[_nPosicao][06] := FwSx3Util():GetFieldType(a_Cpos[_nCount])
			_aEstrut[_nPosicao][07] := AllTrim(GetSX3Cache(a_Cpos[_nCount],"X3_PICTURE"))
			_aEstrut[_nPosicao][09] := GetSX3Cache(a_Cpos[_nCount],"X3_F3")
			_aEstrut[_nPosicao][13] := Separa(AllTrim(GetSX3Cache(a_Cpos[_nCount],"X3_CBOX")),";")
			_aEstrut[_nPosicao][15] := GetSX3Cache(a_Cpos[_nCount],"X3_INIBRW")
			_aEstrut[_nPosicao][16] := GetSX3Cache(a_Cpos[_nCount],"X3_CONTEXT") == "V"
		EndIf
    Next

Return _aEstrut

/*/{Protheus.doc} AddEstrut
	(Função para adicionar campos no array.)

	@type Static Function
	@author Vitor Ribeiro
	@since 02/03/2020

	@param a_Estrut, array, contem a estrutura do msmget.
	@param n_Type, numerico, contém o tipo que deverá retornar a estrutura (1=Tipo Model | 2=Tipo View)

	@return nPosicao, numerico, retorna a posição do array.
	/*/
Static Function AddEstrut(a_Estrut,n_Type)
	
	Local nPosicao := 0 
	
	Default a_Estrut := {}

	Default n_Type := 0
	
	Aadd(a_Estrut,{})
	nPosicao := Len(a_Estrut)
	
	If n_Type == 1
		Aadd(a_Estrut[nPosicao],"")		// [01] C Titulo do campo
		Aadd(a_Estrut[nPosicao],"")		// [02] C Descrição do campo
		Aadd(a_Estrut[nPosicao],"")		// [03] C identificador (ID) do Field
		Aadd(a_Estrut[nPosicao],"")		// [04] C Tipo do campo
		Aadd(a_Estrut[nPosicao],0)		// [05] N Tamanho do campo
		Aadd(a_Estrut[nPosicao],0)		// [06] N Decimal do campo
		Aadd(a_Estrut[nPosicao],{|| })	// [07] B Code-block de validação do campo
		Aadd(a_Estrut[nPosicao],{|| })	// [08] B Code-block de validação When do campo
		Aadd(a_Estrut[nPosicao],{ })	// [09] A Lista de valores permitido do campo
		Aadd(a_Estrut[nPosicao],.F.)	// [10] L Indica se o campo tem preenchimento obrigatório
		Aadd(a_Estrut[nPosicao],{|| })	// [11] B Code-block de inicializacao do campo
		Aadd(a_Estrut[nPosicao],.F.)	// [12] L Indica se trata de um campo chave
		Aadd(a_Estrut[nPosicao],.F.)	// [13] L Indica se o campo pode receber valor em uma operação de update.
		Aadd(a_Estrut[nPosicao],.F.)	// [14] L Indica se o campo é virtual
		Aadd(a_Estrut[nPosicao],"")		// [15] C Valid do usuário em formato texto e sem alteração, usado para se criar o aHeader de compatibilidade
	Else
		Aadd(a_Estrut[nPosicao],"")		// [01] C Nome do Campo
		Aadd(a_Estrut[nPosicao],"")		// [02] C Ordem
		Aadd(a_Estrut[nPosicao],"")		// [03] C Titulo do campo
		Aadd(a_Estrut[nPosicao],"")		// [04] C Descrição do campo
		Aadd(a_Estrut[nPosicao],{})		// [05] A Array com Help
		Aadd(a_Estrut[nPosicao],"")		// [06] C Tipo do campo
		Aadd(a_Estrut[nPosicao],"")		// [07] C Picture
		Aadd(a_Estrut[nPosicao],{|| })	// [08] B Bloco de Picture Var
		Aadd(a_Estrut[nPosicao],"")		// [09] C Consulta F3
		Aadd(a_Estrut[nPosicao],.F.)	// [10] L Indica se o campo é evitável
		Aadd(a_Estrut[nPosicao],"")		// [11] C Pasta do campo
		Aadd(a_Estrut[nPosicao],"")		// [12] C Agrupamento do campo
		Aadd(a_Estrut[nPosicao],{})		// [13] A Lista de valores permitido do campo (Combo)
		Aadd(a_Estrut[nPosicao],0)		// [14] N Tamanho Maximo da maior opção do combo
		Aadd(a_Estrut[nPosicao],"")		// [15] C Inicializador de Browse
		Aadd(a_Estrut[nPosicao],.F.)	// [16] L Indica se o campo é virtual
		Aadd(a_Estrut[nPosicao],"")		// [17] C Picture Variável
		Aadd(a_Estrut[nPosicao],.F.)	// [18] L Se verdadeiro, indica pulo de linha após o campo	
		Aadd(a_Estrut[nPosicao],0)		// [19] N Largura fixa da apresentação do campo
	EndIf

Return nPosicao

Static Function _fGetLegen(c_Process)

	Local _cLegenda := ""

	Default c_Process := ""

	If c_Process == "1"
		_cLegenda := "BR_VERDE"
	ElseIf c_Process == "2"
		_cLegenda := "BR_AZUL"
	ElseIf c_Process == "3"
		_cLegenda := "BR_VERMELHO"
	ElseIf c_Process == "4"
		_cLegenda := "BR_PINK"
	ElseIf c_Process == "5"
		_cLegenda := "BR_AMARELO"
	Else
		_cLegenda := "BR_PRETO"
	EndIf

Return _cLegenda

/*/{Protheus.doc} ViewDef
	(Contém a construção e definição da View, ou seja, será a construção da interface)

	@type Static Function
	@author Vitor Ribeiro
	@since 02/03/2020

	@return _oView, objeto, retorna a view
	/*/
Static Function ViewDef()

	Local _oView := Nil
	Local _oModel := Nil
	Local _oStrCab := Nil
	Local _oStrSZS := Nil

    Local _nCount := 0
	
	// Funcao que retorna um objeto de model de determinado fonte.
	_oModel := FWLoadModel("OPCPA003")

	// Função fornece o objeto com as estruturas de metadado do dicionário de dados, utilizadas pelas classes Model e View.
	_oStrCab := _fMkStrut(TYPE_VIEW,W_SZS_CAB)
	_oStrSZS := FWFormStruct(2,"SZS")
	_oStrSZS:AddField("ZS_LEGENDA","00","","",{"Legenda"},"C","@BMP",Nil,"",.T.,Nil,Nil,Nil,Nil,Nil,.T.,Nil,Nil)

	// Remove os campos de Filial e Tabela da Grid
    For _nCount := 1 To Len(W_SZS_CAB)
	    _oStrSZS:RemoveField(W_SZS_CAB[_nCount])
    Next

	//Criando a view que será o retorno da função e setando o modelo da rotina
	_oView := FWFormView():New()
	_oView:SetModel(_oModel)
	_oView:AddField("VIEW_CAB",_oStrCab,"MODEL_CAB")
	_oView:AddGrid("VIEW_SZS",_oStrSZS,"MODEL_SZS")
	
	//Setando o dimensionamento de tamanho
	_oView:CreateHorizontalBox("BOXTAB",30)
	_oView:CreateHorizontalBox("BOXITEM",70)
	
	//Amarrando a view com as box
	_oView:SetOwnerView("VIEW_CAB","BOXTAB")
	_oView:SetOwnerView("VIEW_SZS","BOXITEM")
	
	//Habilitando título
	_oView:EnableTitleView("VIEW_CAB","Cabeçalho - " + _cDescript)
	_oView:EnableTitleView("VIEW_SZS","Itens - " + _cDescript)
	
	//Tratativa padrão para fechar a tela
	_oView:SetCloseOnOk({||.T.})
	
	_oView:AddUserButton("Legenda","",{|| _fLegenda() })

Return _oView

/*/{Protheus.doc} _fLegenda
	(Função para mostrar as legendas)

	@type Static Function
	@author Vitor Ribeiro
	@since 09/03/2020

    @return Nil, nulo, não tem retorno.
	/*/
Static Function _fLegenda()

	Local _aLegenda := {}
	
	Aadd(_aLegenda,{"BR_VERDE","1=Qtde Total"})
	Aadd(_aLegenda,{"BR_AZUL","2=Qtde Parcial"})
	Aadd(_aLegenda,{"BR_VERMELHO","3=Sem Estoque"})
	Aadd(_aLegenda,{"BR_PINK","4=Sem estoque total para lote"})
	Aadd(_aLegenda,{"BR_AMARELO","5=Sem controle de rastro ou endereço"})
	Aadd(_aLegenda,{"BR_PRETO","Processo realizado pelo modelo antigo"})

	BrwLegenda("Legenda",,_aLegenda)
	
Return Nil

/*/{Protheus.doc} _fCommit
	(Funcao de gravacao dos dados, chamada no final, no momento da confirmacao do modelo)

	@type Static Function
	@author Vitor Ribeiro
	@since 02/03/2020

    @param o_Model, objeto, contém o modelo de dados

	@return .T., logico, retorna verdadeiro
	/*/
Static Function _fCommit(o_Model)

	Local _oMdlSZS := Nil

	Default o_Model := Nil

	_oMdlSZS := o_Model:GetModel("MODEL_SZS")

	Begin Transaction

		FwFormCommit(_oMdlSZS)

	End Transaction

Return .T.

User Function PP002A01(n_Opcao)

	Private _cCodigoId := ""
	Private _cOrdemPrd := ""
	Private _cMsgErro := ""
	Private _cNumOpDe := ""
	//Private _cNumOpAte := "" // Alterado pra Fazer uma OP por vez por: SAMUEL 23122020
	Private _cProdDe := ""
	Private _cProdAte := ""

	Default n_Opcao := 0

	_cCodigoId := SZS->ZS_ID
	_cOrdemPrd := SZS->ZS_OP

	// Se for simular ou processar
	If n_Opcao == 1 .Or. n_Opcao == 2
		// Realiza o pergunte
		If _fPergunte()
			// Realiza o processamento
			Processa({|| _fExecProd(n_Opcao) },"Aguarde...","Analisando o processamento para produção...",.F.)
		EndIf
	ElseIf n_Opcao == 3	// Se for devolver

		If MsgNoYes("Deseja devolver os produtos não utilizados para o estoque?","Atenção")
			// Realiza o processamento
			Processa({|| _fExecDevo() },"Aguarde...","Analisando o processamento para produção...",.F.)
		EndIf

	EndIf

Return Nil

Static Function _fPergunte()

	Local _lContinua := .F.

    DbSelectArea("SB1")     // DESCRIÇÃO GENÉRICA DO PRODUTO
    SB1->(DbSetOrder(1))    // B1_FILIAL+B1_COD

	DbSelectArea("SB2")     // SALDOS FÍSICO E FINANCEIRO
	SB2->(DbSetOrder(1))    // B2_FILIAL+B2_COD+B2_LOCAL

    DbSelectArea("SB8")     // SALDOS POR LOTE
    SB8->(DbSetOrder(1))    // B8_FILIAL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)+B8_LOTECTL+B8_NUMLOTE

	// Enquanto o pergunte for confirma	
	While Pergunte("NEWAUTEMP1",.T.) // Alterado pra Fazer uma OP por vez por: SAMUEL 23122020 antes NEWAUTEMPE
		_cNumOpDe  := MV_PAR01
	//  _cNumOpAte := MV_PAR02 // Alterado pra Fazer uma OP por vez por: SAMUEL 23122020
		_cProdDe   := MV_PAR02
		_cProdAte  := MV_PAR03

		// Alterado pra Fazer uma OP por vez por: SAMUEL 23122020
		// Se não foi informado o numero da op até
		//If Empty(_cNumOpAte)
		//	MsgAlert("O campo 'Ordem de producao ate' não foi informado! Verifique.","Atenção")
		//Else
			// Se não foi informado o numero da op até
			If Empty(_cProdAte)
				MsgAlert("O campo 'Produto ate' não foi informado! Verifique.","Atenção")
			Else
				_lContinua := .T.
				Exit
			EndIf
		//EndIf
	EndDo

Return _lContinua

Static Function _fExecProd(n_Opcao)

	Local _aDadosOP := {}
	Local _aDadosEst := {}

	Local _nCount := 0
	Local _nCount2 := 0
	Local _nCount3 := 0
	Local _nPosicao1 := 0
	Local _nPosicao2 := 0
	Local _nSequenci := 0
	Local _nQtde1 := 0
	Local _nQtde2 := 0
	Local _nQtdeSoli := 0
	Local _nQtdeEmpe := 0
	Local _nSeqSD4 := 0

	Local _cProcess := ""

	Local _lAtendLot := .F.
	Local _lImprimir := .F.
	Local _lTranfere := .F.

	Private _cLocProc := ""
	Private _cLocDest := ""
	Private _cEndDest := ""

	Private _aDadosSZS := {}

	Default n_Opcao := 0

	_cLocProcEmp := GetMV("MV_XLCEMPEN",,"91")
	_cLocProcSld := GetMV("MV_XLCCONSU",,"11")
	_cLocDest    := GetMV("MV_XLCDESTI",,"96")
	_cEndDest    := GetMV("MV_XENDDEST",,"FABRICA")

	// Retorna os dados dos itens da OP
	_aDadosOP := _fMakeQry(1)

	// Se não retornou dados
	If Empty(_aDadosOP)
		MsgAlert("Não existe dados para os parâmetros informados!" + CRLF + CRLF + "Verifique.")
	Else
		// Retorna os dados do estoque
		_aDadosEst := _fMakeQry(2)

		// Percorre todos os itens da OP
		For _nCount := 1 To Len(_aDadosOP)
			_lAtendLot := .F.

			// Verifica se o produto tem estoque
			_nPosicao1 := Ascan(_aDadosEst,{|x| x[N2_PRODUTO] == _aDadosOP[_nCount][2] })

			// Se não encontrou o produto
			If _nPosicao1 < 1
				// Se não tiver controle de lote ou rastro
				//If _aDadosOP[_nCount][6] <> "L" .Or. _aDadosOP[_nCount][7] <> "S"
				If _aDadosOP[_nCount][5] <> "L" .Or. _aDadosOP[_nCount][6] <> "S"
					// 5 - Sem controle de rastro ou endereço
					_cProcess := "5"
					_nQtdeEmpe := 0
				Else
					// 3 - Sem estoque
					_cProcess := "3"
					_nQtdeEmpe := 0
				EndIf

				// 15/06/2020
				IF _aDadosOP[_nCount][12]=="S"
					_cProcess := "6"
					_nQtdeEmpe := 0
				EndIf

			Else
				// Se tiver saldo total para consumir
				If _aDadosEst[_nPosicao1][N2_QUANTID] >= _aDadosOP[_nCount][4]
					// 1 - Total
					_cProcess := "1"
					_nQtdeEmpe := _aDadosOP[_nCount][4]
					_lTranfere := .T.

					// Diminui o estoque do array
					_aDadosEst[_nPosicao1][N2_QUANTID] -= _aDadosOP[_nCount][4]
				Else
					// Se for lote unico
					If _aDadosOP[_nCount][7] == "S"
						// Adiciona a posicição
						_nCount2 := _nPosicao1 + 1

						// Enquanto o contador for menor ou igual ao array do estoque e o produto da posicição for o mesmo do produto do contador
						While _nCount2 <= Len(_aDadosEst) .And. _aDadosEst[_nPosicao1][N2_PRODUTO] == _aDadosEst[_nCount2][N2_PRODUTO]

							// Se tiver saldo total para consumir
							If _aDadosEst[_nCount2][N2_QUANTID] >= _aDadosOP[_nCount][4]
								// Guarda a posição
								_nPosicao1 := _nCount2

								// Atende o lote unico
								_lAtendLot := .T.

								// Sai do laço
								Exit
							EndIf

							// Adiciona no contador
							_nCount2++
						EndDo

						// Atende o lote
						If _lAtendLot
							// 1 - Total
							_cProcess := "1"
							_nQtdeEmpe := _aDadosOP[_nCount][4]
							_lTranfere := .T.

							// Diminui o estoque do array
							_aDadosEst[_nPosicao1][N2_QUANTID] -= _aDadosOP[_nCount][4]
						Else
							// 4 - Sem estoque total para lote
							_cProcess := "4"
							_nQtdeEmpe := 0
						EndIf
					Else
						// 2 - Parcial
						_cProcess := "2"
						_nQtdeEmpe := 0
						_lTranfere := .T.
					EndIf
				EndIf
			EndIf

			// Se não for parcial
			If _cProcess <> "2"
				// Adiciona uma linha no array com os dados a serem processados
				_nPosicao2 := _fAdiciona()

				// Adiciona 1 na sequencia
				_nSequenci++
				//Verifica se é um item duplicado e adiciona o valor a sequencia
				If _aDadosOP[_nCount][13]=='S'
					_nSequenci := _nSeqOp(_aDadosOP[_nCount][01],_aDadosOP[_nCount][02]) //samuel
				
					If _nSequenci <= 0
						_nSequenci := 1
					EndIf
					//Adiciona o S ao array _aDadosSZS
					_aDadosSZS[_nPosicao2][18] := "S"
				Endif

				// N1_TIPPROC	01 - Tipo Process
				_aDadosSZS[_nPosicao2][N1_TIPPROC] := "P"

				// N1_OP		02 - Ord Producao
				_aDadosSZS[_nPosicao2][N1_OP] := _aDadosOP[_nCount][01]

				// N1_PROCESS	03 - Processa
				_aDadosSZS[_nPosicao2][N1_PROCESS] := _cProcess

				// N1_SEQUENC	04 - Sequencia
				_aDadosSZS[_nPosicao2][N1_SEQUENC] := StrZero(_nSequenci,3)

				// N1_PRODUTO	05 - Produto
				_aDadosSZS[_nPosicao2][N1_PRODUTO] := _aDadosOP[_nCount][02]

				// N1_QTDSOLI	06 - Qtde Solicit
				_aDadosSZS[_nPosicao2][N1_QTDSOLI] := _aDadosOP[_nCount][04]

				// N1_QUANT		07 - Qtde Empenho
				_aDadosSZS[_nPosicao2][N1_QUANT] := _nQtdeEmpe

				If _nPosicao1 > 0
					// N1_LOCORI	08 - Local Orig
					_aDadosSZS[_nPosicao2][N1_LOCORI] := _aDadosEst[_nPosicao1][N2_ARMAZEM]
					
					// N1_ENDORI	09 - Endereco Ori
					_aDadosSZS[_nPosicao2][N1_ENDORI] := _aDadosEst[_nPosicao1][N2_LOCALIZ]

					// N1_LOCDES	10 - Local Dest
					_aDadosSZS[_nPosicao2][N1_LOCDES] := _cLocDest

					// N1_LOCALIZ	11 - End. Destino
					_aDadosSZS[_nPosicao2][N1_LOCALIZ] := _cEndDest

					// N1_LOTECTL	12 - Lote
					_aDadosSZS[_nPosicao2][N1_LOTECTL] := _aDadosEst[_nPosicao1][N2_LOTECTL]
				EndIf

				// N1_DOC		13 - Doc Transf
				_aDadosSZS[_nPosicao2][N1_DOC] := ""

				// N1_NEWSD4	14 - Se precisa criar um novo SD4
				_aDadosSZS[_nPosicao2][N1_NEWSD4] := .F.

				// N1_RECSD4	15 - Recno da SD4
				_aDadosSZS[_nPosicao2][N1_RECSD4] := _aDadosOP[_nCount][10]
			Else
				// Zera as variaveis
				_nQtde1 := 0
				_nCount3 := 0

				// Adiciona a posicição
				_nCount2 := _nPosicao1

				// Enquanto o contador for menor ou igual ao array do estoque e o produto da posicição for o mesmo do produto do contador
				While _nCount2 <= Len(_aDadosEst) .And. _aDadosEst[_nPosicao1][N2_PRODUTO] == _aDadosEst[_nCount2][N2_PRODUTO]
					// Soma a quantidade
					_nQtde1 += _aDadosEst[_nCount2][N2_QUANTID]

					// Soma a quantidade
					_nCount3++

					// Se tiver saldo total para consumir
					If _nQtde1 >= _aDadosOP[_nCount][4]
						Exit
					EndIf

					// Adiciona no contador
					_nCount2++
				EndDo

				// Adiciona a quantidade necessaria
				_nQtde1 := _aDadosOP[_nCount][04]

				_nSeqSD4 := IIf(_nCount3 > _nCount2,1,0)

				For _nCount2 := 1 To _nCount3
					// Se quantidade necessaria for maior ou igual a quantidade do estoque
					If _nQtde1 >= _aDadosEst[(_nPosicao1-1)+_nCount2][N2_QUANTID]
						// Se a quantidade em estoque for diferente de zero
						If _aDadosEst[(_nPosicao1-1)+_nCount2][N2_QUANTID] <> 0
							// Adiciona a quantidade
							_nQtde2 := _aDadosEst[(_nPosicao1-1)+_nCount2][N2_QUANTID]

							// Zero a quantidade
							_aDadosEst[(_nPosicao1-1)+_nCount2][N2_QUANTID] := 0

							// Se for a ultima volta
							If _nCount2 == _nCount3
								// 2 - Parcial
								_cProcess := "2"
								_nQtdeSoli := _nQtde1
								_lTranfere := .T.
							Else
								// 1 - Total
								_cProcess := "1"
								_nQtdeSoli := _nQtde2
								_lTranfere := .T.
							EndIf
						Else
							// 3 - Sem estoque
							_cProcess := "3"
							_nQtde2 := 0
							_nQtdeSoli := _nQtde1
						EndIf
					Else
						// Adiciona a quantidade
						_nQtde2 := _nQtde1
						_nQtdeSoli := _nQtde1

						// Subtrai a quantidade utilizada
						_aDadosEst[(_nPosicao1-1)+_nCount2][N2_QUANTID] += _nQtde1

						// 1 - Total
						_cProcess := "1"
						_lTranfere := .T.
					EndIf

					// Subtrai a quantidade
					_nQtde1 -= _nQtde2

					// Adiciona uma linha no array com os dados a serem processados
					_nPosicao2 := _fAdiciona()

					// Adiciona 1 na sequencia
					_nSequenci++
					
					//Verifica se é um item duplicado e adiciona o valor a sequencia
					If _aDadosOP[_nCount][13]=='S'
					
						_nSequenci := _nSeqOp(_aDadosOP[_nCount][01],_aDadosOP[_nCount][02]) //samuel
						If _nSequenci <= 0
							_nSequenci := 1
						EndIf

						//Adiciona o S ao array 
						_aDadosSZS[_nPosicao2][18] := "S"
					Endif

					// N1_TIPPROC	01 - Tipo Process
					_aDadosSZS[_nPosicao2][N1_TIPPROC] := "P"

					// N1_OP		02 - Ord Producao
					_aDadosSZS[_nPosicao2][N1_OP] := _aDadosOP[_nCount][01]

					// N1_PROCESS	03 - Processa
					_aDadosSZS[_nPosicao2][N1_PROCESS] := _cProcess

					// N1_SEQUENC	04 - Sequencia
					_aDadosSZS[_nPosicao2][N1_SEQUENC] := StrZero(_nSequenci,3)

					// N1_PRODUTO	05 - Produto
					_aDadosSZS[_nPosicao2][N1_PRODUTO] := _aDadosOP[_nCount][02]

					// N1_QTDSOLI	06 - Qtde Solicit
					_aDadosSZS[_nPosicao2][N1_QTDSOLI] := _nQtdeSoli

					// N1_QUANT		07 - Qtde Empenho
					_aDadosSZS[_nPosicao2][N1_QUANT] := _nQtde2

					// N1_LOCORI	08 - Local Orig
					_aDadosSZS[_nPosicao2][N1_LOCORI] := _aDadosEst[(_nPosicao1-1)+_nCount2][N2_ARMAZEM]

					// N1_ENDORI	09 - Endereco Ori
					_aDadosSZS[_nPosicao2][N1_ENDORI] := _aDadosEst[(_nPosicao1-1)+_nCount2][N2_LOCALIZ]

					// N1_LOCDES	10 - Local Dest
					_aDadosSZS[_nPosicao2][N1_LOCDES] := _cLocDest

					// N1_LOCALIZ	11 - End. Destino
					_aDadosSZS[_nPosicao2][N1_LOCALIZ] := _cEndDest

					// N1_LOTECTL	12 - Lote
					_aDadosSZS[_nPosicao2][N1_LOTECTL] := _aDadosEst[(_nPosicao1-1)+_nCount2][N2_LOTECTL]

					// N1_DOC		13 - Doc Transf
					_aDadosSZS[_nPosicao2][N1_DOC] := ""

					// Se foi adicionado linha
					If _nCount2 > 1
						// N1_NEWSD4	14 - Se precisa criar um novo SD4
						_aDadosSZS[_nPosicao2][N1_NEWSD4] := .T.

						// N1_RECSD4	15 - Recno da SD4
						_aDadosSZS[_nPosicao2][N1_RECSD4] := 0
					Else
						// N1_NEWSD4	14 - Se precisa criar um novo SD4
						_aDadosSZS[_nPosicao2][N1_NEWSD4] := .F.

						// N1_RECSD4	15 - Recno da SD4
						_aDadosSZS[_nPosicao2][N1_RECSD4] := _aDadosOP[_nCount][10]

						
					EndIf

					// Verifica se ja existe SD4 com mesmo Produto e Lote
					If !Empty( _aDadosEst[(_nPosicao1-1)+_nCount2][N2_LOTECTL] )
						dbSelectArea("SD4")
						dbSetOrder(1)

						If dbSeek(xFilial("SD4")+_aDadosOP[_nCount][02]+_aDadosOP[_nCount][01]+Space(Len(SD4->D4_TRT))+_aDadosEst[(_nPosicao1-1)+_nCount2][N2_LOTECTL]) 
							_cTRT := "   "
							While !Eof() .And. SD4->(D4_FILIAL+D4_COD+D4_OP) == xFilial("SD4")+_aDadosOP[_nCount][02]+_aDadosOP[_nCount][01]
								If SD4->D4_LOTECTL == _aDadosEst[(_nPosicao1-1)+_nCount2][N2_LOTECTL]
									_cTRT := Soma1(_cTRT)
									
								EndIf
								dbSkip()
							EndDo
							If !Empty( _aDadosEst[(_nPosicao1-1)+_nCount2][N2_LOTECTL] )
								_aDadosSZS[_nPosicao2][N1_TRTSD4] := _cTRT
								_cTRT := ""
								
							EndIf
						EndIf
					EndIf
				Next
			EndIf

			// Se ainda tiver mais uma posição e for uma op diferente
			If _nCount < Len(_aDadosOP) .And. _aDadosOP[_nCount][1] <> _aDadosOP[_nCount+1][1]
				// zera a sequencia
				_nSequenci := 0
			EndIf
		Next

		For _nCount := 1 To Len(_aDadosSZS)
			// Se ainda não for a ultima linha
			If _nCount < Len(_aDadosSZS)
				// Se o proximo produto for o mesmo produto
				If _aDadosSZS[_nCount][N1_PRODUTO] == _aDadosSZS[_nCount+1][N1_PRODUTO] .And. _aDadosSZS[_nCount][N1_LOTECTL] == _aDadosSZS[_nCount+1][N1_LOTECTL]

					If Empty(_aDadosSZS[_nCount][N1_TRTSD4])
						_aDadosSZS[_nCount][N1_TRTSD4] := StrZero(1,3)
					EndIf

					If Empty(_aDadosSZS[_nCount+1][N1_TRTSD4])
						_aDadosSZS[_nCount+1][N1_TRTSD4] := Soma1(_aDadosSZS[_nCount][N1_TRTSD4])
					EndIf
				EndIf
			EndIf
		Next

		// Se for impressão
		If n_Opcao == 1
			_lImprimir := .T.
		Else
			_lImprimir := MsgYesNo("Deseja imprimir o relatório de log's antes do processamento?","Atenção")
		EndIf

		// Se imprime
		If _lImprimir
			// Imprimi analise
			U_OPCPR002(_aDadosSZS,_aDadosEst)
		EndIf

		// Se for processamento
		If n_Opcao == 2
			// Realiza o processamento
			_fProcessa(_lTranfere)
		EndIf
	EndIf

Return Nil

Static Function _fMakeQry(n_Opcao)

	Local _cAlias := GetNextAlias()
	Local _cWhere := ""

	Local _aDados := {}

	Local _nPosicao := 0

	Default n_Opcao := 0

	If n_Opcao == 1 .Or. n_Opcao == 2
		_cWhere := " AND SD4.D4_LOTECTL = ' ' "
		_cWhere += " AND SD4.D4_LOCAL = '" + _cLocProcEmp + "' "
		_cWhere += " AND SD4.D4_QUANT > 0 "
		_cWhere := "%" + _cWhere + "%"
	EndIf

	If n_Opcao == 1
		BeginSql Alias _cAlias
			COLUMN DATA AS DATE

			SELECT
				 SD4.D4_OP OP
				,SD4.D4_COD PRODUTO
				,SD4.D4_XEMPD4 EMPMULT //SAMUEL 
				,SB1.B1_DESC DESCRICAO
				,SB1.B1_UM UNIDADE
				,SD4.D4_QUANT QUANT
				,SB1.B1_RASTRO RASTRO
				,SB1.B1_LOCALIZ ENDERECO
				,SB1.B1_LOTEUNI LOTEUNI
				,SD4.D4_LOCAL ARMAZEM
				,SD4.D4_DATA DATA
				,SD4.R_E_C_N_O_ AS SD4_RECNO
				,SB1.B1_FANTASM PDFANTASMA     //SAMUEL 15/06/2020 [12]
			FROM %Table:SD4% SD4 (NOLOCK)

			INNER JOIN %Table:SB1% SB1 (NOLOCK) ON
				SB1.%NotDel%
				AND SB1.B1_FILIAL = %xFilial:SB1%
				AND SB1.B1_COD = SD4.D4_COD

			INNER JOIN %Table:SC2% SC2 (NOLOCK) ON
				SC2.%NotDel%
				AND SC2.C2_FILIAL = %xFilial:SC2%
				AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN = SD4.D4_OP
				AND SC2.C2_DATRF = ''
				AND SC2.C2_XGEREMP = 'S'

			WHERE
				SD4.D4_FILIAL = %xFilial:SD4%
				AND SD4.D4_OP = %Exp:_cNumOpDe%
				//AND SD4.D4_OP <= %Exp:_cNumOpAte%  // Alterado pra Fazer uma OP por vez por: SAMUEL 23122020 
				AND SD4.D4_COD >= %Exp:_cProdDe%
				AND SD4.D4_COD <= %Exp:_cProdAte%
				AND SD4.%NotDel%
				%Exp:_cWhere%

			ORDER BY
				 SD4.D4_OP
				,SD4.D4_COD
		EndSql

		MemoWrite("LOGS_PROGRAMAS\OPCPA003\QUERY_ALTER.sql",GetLastQuery()[2])

		// Enquanto não for final de arquivo
		While (_cAlias)->(!Eof())
			// Adiciona uma linha no array
			Aadd(_aDados,{})
			_nPosicao := Len(_aDados)

			// 01 - OP
			Aadd(_aDados[_nPosicao],(_cAlias)->OP)

			// 02 - Produto
			Aadd(_aDados[_nPosicao],(_cAlias)->PRODUTO)

			// 03 - Descricao
			Aadd(_aDados[_nPosicao],(_cAlias)->DESCRICAO)

			// 04 - Quantidade
			Aadd(_aDados[_nPosicao],(_cAlias)->QUANT)

			// 05 - Possui rastro
			Aadd(_aDados[_nPosicao],(_cAlias)->RASTRO)

			// 06 - Possui endereco
			Aadd(_aDados[_nPosicao],(_cAlias)->ENDERECO)

			// 07 - Lote unico
			Aadd(_aDados[_nPosicao],(_cAlias)->LOTEUNI)

			// 08 - Armazem
			Aadd(_aDados[_nPosicao],(_cAlias)->ARMAZEM)

			// 09 - Data
			Aadd(_aDados[_nPosicao],(_cAlias)->DATA)

			// 10 - Recno
			Aadd(_aDados[_nPosicao],(_cAlias)->SD4_RECNO)

			// 11 - Unidade
			Aadd(_aDados[_nPosicao],(_cAlias)->UNIDADE)

			// 12 - Produto Fantasma
			Aadd(_aDados[_nPosicao],(_cAlias)->PDFANTASMA) //Samuel Mirnda

			// 13 - Produto Fantasma
			Aadd(_aDados[_nPosicao],(_cAlias)->EMPMULT) //Samuel Mirnda

			SB2->(DbSetOrder(1))    // B2_FILIAL+B2_COD+B2_LOCAL
			If !SB2->(DbSeek(xFilial("SB2")+(_cAlias)->PRODUTO+_cLocDest))
				// Cria o armazem caso não exista
				CriaSB2((_cAlias)->PRODUTO,_cLocDest)
			EndIf

			// Vai para o proximo registro
			(_cAlias)->(DbSkip())
		EndDo

		// Encerra o alias
		(_cAlias)->(DbCloseArea())
	
	ElseIf n_Opcao == 2
		BeginSql Alias _cAlias
			COLUMN DATA_LOTE AS DATE
			COLUMN DATA_VALID AS DATE

			SELECT 
				 SB8.B8_PRODUTO PRODUTO
				,SB1.B1_DESC DESCRICAO
				,SB8.B8_LOCAL ARMAZEM
				,SBF.BF_LOCALIZ ENDERECO
				,SB8.B8_LOTECTL LOTE
				,(SBF.BF_QUANT - SBF.BF_EMPENHO) SALDO_EST
				,SB8.B8_DATA DATA_LOTE
				,SB8.B8_DTVALID DATA_VALID
				,(SBF.BF_QUANT - SBF.BF_EMPENHO) SALDO_DISP
			FROM %Table:SB8% SB8 (NOLOCK)

			INNER JOIN %Table:SB1% SB1 (NOLOCK) ON
				SB1.%NotDel%
				AND SB1.B1_FILIAL = %xFilial:SB1%
				AND SB1.B1_COD = SB8.B8_PRODUTO

			INNER JOIN %Table:SBF% SBF (NOLOCK) ON
				SBF.%NotDel%
				AND SBF.BF_FILIAL = %xFilial:SBF%
				AND SBF.BF_PRODUTO = SB8.B8_PRODUTO
				AND SBF.BF_LOCAL = SB8.B8_LOCAL
				AND SBF.BF_LOTECTL = SB8.B8_LOTECTL
				AND (SBF.BF_QUANT - SBF.BF_EMPENHO) > 0
				
			INNER JOIN (
				SELECT DISTINCT
					SD4.D4_COD
				FROM %Table:SD4% SD4 (NOLOCK)
				
				WHERE
					SD4.D4_FILIAL = %xFilial:SD4%
					AND SD4.D4_OP >= %Exp:_cNumOpDe%
					//AND SD4.D4_OP <= %Exp:_cNumOpAte% // Alterado pra Fazer uma OP por vez por: SAMUEL 23122020
					AND SD4.D4_COD >= %Exp:_cProdDe%
					AND SD4.D4_COD <= %Exp:_cProdAte%
					AND SD4.%NotDel%
					%Exp:_cWhere%
			) SD4 ON
				SD4.D4_COD = SB8.B8_PRODUTO

			WHERE
				SB8.%NotDel%
				AND SB8.B8_FILIAL = %xFilial:SB8%
				AND SB8.B8_LOCAL = %Exp:_cLocProcSld%
				AND SB8.B8_DTVALID >= %Exp:dDataBase%
				AND (SB8.B8_SALDO - SB8.B8_EMPENHO) > 0
				
			ORDER BY
				 SB8.B8_PRODUTO
				,SB8.B8_LOTECTL
				,SB8.B8_DATA
		EndSql

		MemoWrite("LOGS_PROGRAMAS\OPCPA003\QUERY_alt.sql",GetLastQuery()[2])

		// Enquanto não for final de arquivo
		While (_cAlias)->(!Eof())
			// Adiciona uma linha no array
			Aadd(_aDados,{})
			_nPosicao := Len(_aDados)

			// N2_PRODUTO	01 - Produto
			Aadd(_aDados[_nPosicao],(_cAlias)->PRODUTO)

			// N2_DESCRIC 	02 - Descricao
			Aadd(_aDados[_nPosicao],(_cAlias)->DESCRICAO)

			// N2_QUANTID	03 - Saldo em estoque
			Aadd(_aDados[_nPosicao],(_cAlias)->SALDO_EST)

			// N2_ARMAZEM	04 - Armazem
			Aadd(_aDados[_nPosicao],(_cAlias)->ARMAZEM)

			// N2_LOCALIZ	05 - Endereço
			Aadd(_aDados[_nPosicao],(_cAlias)->ENDERECO)

			// N2_LOTECTL	06 - Lote
			Aadd(_aDados[_nPosicao],(_cAlias)->LOTE)

			// N2_DATA		07 - Data do lote
			Aadd(_aDados[_nPosicao],(_cAlias)->DATA_LOTE)

			// N2_DTVALID	08 - Data de validade do lote
			Aadd(_aDados[_nPosicao],(_cAlias)->DATA_VALID)

			// N2_SALDATU	09 - Saldo disponivel
			Aadd(_aDados[_nPosicao],(_cAlias)->SALDO_DISP)

			// Vai para o proximo registro
			(_cAlias)->(DbSkip())
		EndDo

		// Encerra o alias
		(_cAlias)->(DbCloseArea())

	ElseIf n_Opcao == 3
		BeginSql Alias _cAlias
			SELECT 
				 SZS.ZS_TIPPROC
				,SZS.ZS_OP
				,SZS.ZS_PROCESS
				,SZS.ZS_SEQUENC
				,SZS.ZS_PRODUTO
				,SZS.ZS_QTDSOLI
				,SZS.ZS_QUANT
				,SZS.ZS_LOCORI
				,SZS.ZS_ENDORI
				,SZS.ZS_LOCDES
				,SZS.ZS_LOCALIZ
				,SZS.ZS_LOTECTL
				,SZS.ZS_DOC
				,SZS.R_E_C_N_O_ RECNO_SZS
			FROM %Table:SZS% SZS

			WHERE
				SZS.%NotDel%
				AND SZS.ZS_FILIAL = %xFilial:SZS%
				//AND SZS.ZS_ID = %Exp:_cCodigoId%
				AND SZS.ZS_OP = %Exp:_cOrdemPrd%
				AND(SZS.ZS_PROCESS = '1'
				OR  SZS.ZS_PROCESS = '2')
		EndSql

		MemoWrite("LOGS_PROGRAMAS\OPCPA003\QUERY_3.sql",GetLastQuery()[2])

		// Enquanto não for final de arquivo
		While (_cAlias)->(!Eof())
			SD4->(DbSetOrder(2))	// D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
			If SD4->(DbSeek(xFilial("SD4")+PadR((_cAlias)->ZS_OP,TamSX3("D4_OP")[1])+(_cAlias)->ZS_PRODUTO+(_cAlias)->ZS_LOCDES))
				// Enquanto não for final de arquivo e for o mesmo registro
				While SD4->(!Eof()) .And. SD4->(D4_FILIAL+D4_OP+D4_COD+D4_LOCAL) == xFilial("SD4")+PadR((_cAlias)->ZS_OP,TamSX3("D4_OP")[1])+(_cAlias)->ZS_PRODUTO+(_cAlias)->ZS_LOCDES
					// Se for o mesmo lote e a mesma quantidade original
					If SD4->D4_LOTECTL == (_cAlias)->ZS_LOTECTL .And. (_cAlias)->ZS_QUANT == SD4->D4_QTDEORI .And. SD4->D4_QUANT > 0
						// Verifica se o recno já está no array
						_nPosicao := Ascan(_aDadosSZS,{|x| x[N1_RECSD4] == SD4->(Recno()) })

						// Se não achar
						If _nPosicao < 1
							// Adiciona mais uma linha
							_nPosicao := _fAdiciona()

							// N1_TIPPROC	01 - Tipo Process
							_aDadosSZS[_nPosicao][N1_TIPPROC] := (_cAlias)->ZS_TIPPROC

							// N1_OP		02 - Ord Producao
							_aDadosSZS[_nPosicao][N1_OP] := (_cAlias)->ZS_OP

							// N1_PROCESS	03 - Processa
							_aDadosSZS[_nPosicao][N1_PROCESS] := (_cAlias)->ZS_PROCESS

							// N1_SEQUENC	04 - Sequencia
							_aDadosSZS[_nPosicao][N1_SEQUENC] := (_cAlias)->ZS_SEQUENC

							// N1_PRODUTO	05 - Produto
							_aDadosSZS[_nPosicao][N1_PRODUTO] := (_cAlias)->ZS_PRODUTO

							// N1_QTDSOLI	06 - Qtde Solicit
							_aDadosSZS[_nPosicao][N1_QTDSOLI] := (_cAlias)->ZS_QTDSOLI

							// N1_QUANT		07 - Qtde Empenho
							_aDadosSZS[_nPosicao][N1_QUANT] := SD4->D4_QUANT

							// N1_LOCORI	08 - Local Orig
							_aDadosSZS[_nPosicao][N1_LOCORI] := (_cAlias)->ZS_LOCDES

							// N1_ENDORI	09 - Endereco Ori
							_aDadosSZS[_nPosicao][N1_ENDORI] := (_cAlias)->ZS_LOCALIZ

							// N1_LOCDES	10 - Local Dest
							_aDadosSZS[_nPosicao][N1_LOCDES] := (_cAlias)->ZS_LOCORI

							// N1_LOCALIZ	11 - End. Destino
							_aDadosSZS[_nPosicao][N1_LOCALIZ] := (_cAlias)->ZS_ENDORI

							// N1_LOTECTL	12 - Lote
							_aDadosSZS[_nPosicao][N1_LOTECTL] := (_cAlias)->ZS_LOTECTL

							// N1_DOC		13 - Doc Transf
							_aDadosSZS[_nPosicao][N1_DOC] := (_cAlias)->ZS_DOC
							
							// N1_RECSD4	15 - Recno da SD4
							_aDadosSZS[_nPosicao][N1_RECSD4] := SD4->(Recno())

							// N1_RECSZS	17 - Recno da SZS
							_aDadosSZS[_nPosicao][N1_RECSZS] := (_cAlias)->RECNO_SZS

							//Adicionando ao array _aDadosSZS uma posição a mais
							_aDadosSZS[_nPosicao][18] := SD4->D4_XEMPD4
						EndIF
					EndIf

					SD4->(DbSkip())
				EndDo
			EndIf

			// Vai para o proximo registro
			(_cAlias)->(DbSkip())
		EndDo

		// Encerra o alias
		(_cAlias)->(DbCloseArea())

	EndIf

Return _aDados

Static Function _fAdiciona()

	Local _nPosicao := 0

	Aadd(_aDadosSZS,{})
	_nPosicao := Len(_aDadosSZS)

	// N1_TIPPROC	01 - Tipo Process
	Aadd(_aDadosSZS[_nPosicao],"")

	// N1_OP		02 - Ord Producao
	Aadd(_aDadosSZS[_nPosicao],"")

	// N1_PROCESS	03 - Processa
	Aadd(_aDadosSZS[_nPosicao],"")

	// N1_SEQUENC	04 - Sequencia
	Aadd(_aDadosSZS[_nPosicao],"")

	// N1_PRODUTO	05 - Produto
	Aadd(_aDadosSZS[_nPosicao],"")

	// N1_QTDSOLI	06 - Qtde Solicit
	Aadd(_aDadosSZS[_nPosicao],0)

	// N1_QUANT		07 - Qtde Empenho
	Aadd(_aDadosSZS[_nPosicao],"")

	// N1_LOCORI	08 - Local Orig
	Aadd(_aDadosSZS[_nPosicao],"")

	// N1_ENDORI	09 - Endereco Ori
	Aadd(_aDadosSZS[_nPosicao],"")

	// N1_LOCDES	10 - Local Dest
	Aadd(_aDadosSZS[_nPosicao],"")

	// N1_LOCALIZ	11 - End. Destino
	Aadd(_aDadosSZS[_nPosicao],"")

	// N1_LOTECTL	12 - Lote
	Aadd(_aDadosSZS[_nPosicao],"")

	// N1_DOC		13 - Doc Transf
	Aadd(_aDadosSZS[_nPosicao],"")

	// N1_NEWSD4	14 - Se precisa criar um novo SD4
	Aadd(_aDadosSZS[_nPosicao],.F.)

	// N1_RECSD4	15 - Recno da SD4
	Aadd(_aDadosSZS[_nPosicao],0)

	// N1_TRTSD4	16 - Sequencia da estrutura
	Aadd(_aDadosSZS[_nPosicao],"")

	// N1_RECSZS	17 - Recno da SZS
	Aadd(_aDadosSZS[_nPosicao],0)
	
	//Adicionando ao array _aDadosSZS uma posição a mais 18
	Aadd(_aDadosSZS[_nPosicao],"")

Return _nPosicao

Static Function _fProcessa(l_Tranfere)

	Local _lContinua := .T.

	Private lMsErroAuto := .F.
	Private lMSHelpAuto := .T.

	Default l_Tranfere := .F.

	// Se não transferiu nada
	If l_Tranfere
		ProcRegua(4)
	Else
		ProcRegua(1)
		_lContinua := MsgNoYes("Não foi gerado nenhuma transferência para os dados informados, porém é possível gravar o log com os motivos." + CRLF + CRLF + "Deseja gravar os log's?","Atenção")
	EndIf

	Begin Transaction
		// Possui transferencia
		If l_Tranfere
			IncProc("Processando a transferencia dos produtos...")
			ProcessMessages()

			// Função para Excluir os empenhos
			_lContinua := _fExcEmpe()

			If _lContinua
				// Função para transferir os produtos
				_lContinua := _fTransfer()
			EndIf

			// Se conseguiu transferir com sucesso
			If _lContinua
				IncProc("Processando o empenho dos produtos...")
				ProcessMessages()

				// Função para empenhar os produtos
				_lContinua := _fEmpenho(.T.)
			EndIf
		EndIf

		// Se conseguiu empenhar com sucesso
		If _lContinua
			IncProc("Processando a gravação do log...")
			ProcessMessages()

			// Função para gravar a SZS
			_lContinua := _fGravaSZS()
		EndIf

		// Se ocorreu algum erro
		If !_lContinua
			// Desarma a transação
			DisarmTransaction()
		EndIf
	End Transaction

	If _lContinua
		MsgAlert("Empenho realizado com sucesso!","Atenção")
	Else
		Alert("Não foi possivel realizar o empenho!","Atenção")

		If SUBSTR(_cMsgErro,1,15) =="AJUDA:BLQINVENT"
			Alert("Bloqueio Inventario!","Atenção")	
		EndIf

		If SUBSTR(_cMsgErro,1,16) =="AJUDA:A241PROFAN"
			Alert("Produto Fantasma!","Atenção")	
		EndIf

		If !Empty(_cMsgErro)
			Aviso("Observação do empenho",_cMsgErro,{"OK"},3)
		EndIf
	EndIf

Return Nil

Static Function _fExcEmpe()

	Local _lContinua := .T.

	Local _aMata380 := {}

	Local _nCount := 0

	Local _cPath := "LOGS_PROGRAMAS\OPCPA003\MsExecAuto\MATA380\"
	Local _cNome := "LOG_EXCLUIR_MATA380_U_" + RetCodUsr() + "_D_" + DToS(dDataBase) + "_H_" + Strtran(SubStr(Time(),1,5),":","") + ".log"

	// Percorre todos os registros
	For _nCount := 1 To Len(_aDadosSZS)
		// Se for quantidade total ou parcial e for alteração do SD4
		If _aDadosSZS[_nCount][N1_PROCESS] $ "1|2" .And. !_aDadosSZS[_nCount][N1_NEWSD4]
			// Posiciona no registro do SD4
			SD4->(DbGoTo(_aDadosSZS[_nCount][N1_RECSD4]))
			
			// Grava o Armazem do empenho original - MAURICIO 14/08/22 - DEVIDO A ERRO DE CHAVE DE PESQUISA. ESTAVA TRAZENDO ARMAZEM 11. QUANDO DEVERIA TRAZER 91
			_cLOCEMP := SD4->D4_LOCAL
			
			// Inicializa
			_aMata380 := {}

			// Adiciona o produto
			Aadd(_aMata380,{"D4_COD",_aDadosSZS[_nCount][N1_PRODUTO],Nil})

			// Adiciona o armazem
			//Aadd(_aMata380,{"D4_LOCAL",_aDadosSZS[_nCount][N1_LOCORI],Nil})  - MAURICIO 14/08/22 - DEVIDO A ERRO DE CHAVE DE PESQUISA. ESTAVA TRAZENDO ARMAZEM 11. QUANDO DEVERIA TRAZER 91
			Aadd(_aMata380,{"D4_LOCAL",_cLOCEMP,Nil})

			// Adiciona a ordem de produção
			Aadd(_aMata380,{"D4_OP",_aDadosSZS[_nCount][N1_OP],Nil})

			MSExecAuto({|x,y| Mata380(x,y)},_aMata380,5)

			_lContinua := !lMsErroAuto

			If !_lContinua
				MostraErro(_cPath,_cNome)

				_cMsgErro := MemoRead(_cPath + _cNome)
				Exit
			EndIf
		EndIf
	Next

Return _lContinua

Static Function _fTransfer()

	Local _lContinua := .T.

	Local _cDocSD3 := ""
	Local _cTpConv := ""
	Local _cPath := "LOGS_PROGRAMAS\OPCPA003\MsExecAuto\MATA261\"
	Local _cNome := "MATA261_U_" + RetCodUsr() + "_D_" + DToS(dDataBase) + "_H_" + Strtran(SubStr(Time(),1,5),":","")

	Local _aMata261 := {}
	Local _aLinha := {}
	Local _aTransfe := {}

	Local _nCount := 0
	Local _nConversa := 0
	Local _nQtdSegum := 0

	Local _dDataAtu := dDataBase
	Local _dDtVldOri := SToD("")
	Local _dDtVldDes := SToD("")

	// Percorre todos os registros
	For _nCount := 1 To Len(_aDadosSZS)
		// Se for quantidade total ou parcial
		If _aDadosSZS[_nCount][N1_PROCESS] $ "1|2"
			// Inicializa as variaveis
			_aMata261 := {}
			_aLinha := {}

			// Busca o codigo
			_cDocSD3 := _fGetCodig("SD3","D3_DOC",2)

			// Adiciona no array
			Aadd(_aMata261,{_cDocSD3,_dDataAtu,Nil})

			SB1->(DbSetOrder(1))	// B1_FILIAL+B1_COD
			SB1->(DbSeek(xFilial("SB1")+_aDadosSZS[_nCount][N1_PRODUTO]))

			SB8->(DbSetOrder(3))	// B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
			If SB8->(DbSeek(xFilial("SB8")+_aDadosSZS[_nCount][N1_PRODUTO]+_aDadosSZS[_nCount][N1_LOCORI]+_aDadosSZS[_nCount][N1_LOTECTL]))
				_dDtVldOri := SB8->B8_DTVALID
			EndIf

			If SB8->(DbSeek(xFilial("SB8")+_aDadosSZS[_nCount][N1_PRODUTO]+_aDadosSZS[_nCount][N1_LOCDES]+_aDadosSZS[_nCount][N1_LOTECTL]))
				_dDtVldDes := SB8->B8_DTVALID
			EndIf

			_cTpConv := SB1->B1_TIPCONV
			_nConversa := SB1->B1_CONV
			
			If _nConversa <> 0     
				_nQtdSegum := IIF(_cTpConv == "M", _aDadosSZS[_nCount][N1_QUANT] * _nConversa , _aDadosSZS[_nCount][N1_QUANT] / _nConversa)
			Else
				_nQtdSegum := 0
			Endif

			// Inclusão da origem do produto
			Aadd(_aLinha,{"D3_COD",SB1->B1_COD,Nil})							// 01 - D3_COD
			Aadd(_aLinha,{"D3_DESCRI",SB1->B1_DESC,Nil})						// 02 - D3_DESCRI
			Aadd(_aLinha,{"D3_UM",SB1->B1_UM,Nil})								// 03 - D3_UM
			Aadd(_aLinha,{"D3_LOCAL",_aDadosSZS[_nCount][N1_LOCORI],Nil})		// 04 - D3_LOCAL
			Aadd(_aLinha,{"D3_LOCALIZ",_aDadosSZS[_nCount][N1_ENDORI],Nil})		// 05 - D3_LOCALIZ

			// Inclusão do destino do produto
			Aadd(_aLinha,{"D3_COD",SB1->B1_COD,Nil})							// 06 - D3_COD
			Aadd(_aLinha,{"D3_DESCRI",SB1->B1_DESC,Nil})						// 07 - D3_DESCRI
			Aadd(_aLinha,{"D3_UM",SB1->B1_UM,Nil})								// 08 - D3_UM
			Aadd(_aLinha,{"D3_LOCAL",_aDadosSZS[_nCount][N1_LOCDES],Nil})		// 09 - D3_LOCAL
			Aadd(_aLinha,{"D3_LOCALIZ",_aDadosSZS[_nCount][N1_LOCALIZ],Nil})	// 10 - D3_LOCALIZ
			Aadd(_aLinha,{"D3_NUMSERI","",Nil})									// 11 - D3_NUMSERI
			Aadd(_aLinha,{"D3_LOTECTL",_aDadosSZS[_nCount][N1_LOTECTL],Nil})	// 12 - D3_LOTECTL
			Aadd(_aLinha,{"D3_NUMLOTE","",Nil})									// 13 - D3_NUMLOTE
			Aadd(_aLinha,{"D3_DTVALID",_dDtVldOri,Nil})							// 14 - D3_DTVALID
			Aadd(_aLinha,{"D3_POTENCI",0,Nil})									// 15 - D3_POTENCI
			Aadd(_aLinha,{"D3_QUANT",_aDadosSZS[_nCount][N1_QUANT],Nil})		// 16 - D3_QUANT
			Aadd(_aLinha,{"D3_QTSEGUM",_nQtdSegum,Nil})							// 17 - D3_QTSEGUM
			Aadd(_aLinha,{"D3_ESTORNO","",Nil})									// 18 - D3_ESTORNO
			Aadd(_aLinha,{"D3_NUMSEQ","",Nil})									// 19 - D3_NUMSEQ
			Aadd(_aLinha,{"D3_LOTECTL",_aDadosSZS[_nCount][N1_LOTECTL],Nil})	// 20 - D3_LOTECTL
			Aadd(_aLinha,{"D3_DTVALID",_dDtVldDes,Nil})							// 21 - D3_DTVALID
			Aadd(_aLinha,{"D3_ITEMGRD","",Nil})									// 22 - D3_ITEMGRD
			
			// Inclui uma linha
			Aadd(_aMata261,_aLinha)

			// Guarda o produto, local origem, endereço origem, lote e sua posição no array
			Aadd(_aTransfe,{SB1->B1_COD + _aDadosSZS[_nCount][N1_LOCORI] + _aDadosSZS[_nCount][N1_ENDORI] + _aDadosSZS[_nCount][N1_LOTECTL],Len(_aMata261)})

			// Guarda o documento no array
			_aDadosSZS[_nCount][N1_DOC] := _cDocSD3

			// Volta o indice
			SB8->(DbSetOrder(1))    // B8_FILIAL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)+B8_LOTECTL+B8_NUMLOTE

			// Realiza transferencia de armazem
			MSExecAuto({|x,y| Mata261(x,y) },_aMata261,3)

			_lContinua := !lMsErroAuto

			If _lContinua
				// Confirma a numeração
				SD3->(ConfirmSX8())

				// Grava a observação
				_fGrvObsD3(_cDocSD3)
			Else
				// Volta a numeração
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
		EndIf
	Next

Return _lContinua

Static Function _fGrvObsD3(c_DocSD3)

	Local _aArea := GetArea()
	Local _aAreaSD3 := SD3->(GetArea())

	Default c_DocSD3 := ""

	DbSelectArea("SD3")		// MOVIMENTAÇÕES INTERNAS
	SD3->(DbSetOrder(2))	// D3_FILIAL+D3_DOC+D3_COD

	// Posiciona no registro de transferencia
	If SD3->(DbSeek(xFilial("SD3")+c_DocSD3))
		// Enquanto for o mesmo documento
		While SD3->(!Eof()) .And. xFilial("SD3")+c_DocSD3 == SD3->(D3_FILIAL+D3_DOC)
			RecLock("SD3",.F.)
				SD3->D3_XOBS := "AUTO EMPENHO"
			SD3->(MsUnLock())
			SD3->(DbSkip())
		EndDo
	EndIf

	RestArea(_aAreaSD3)
	RestArea(_aArea)

Return Nil

Static Function _fEmpenho(l_Empenhar)

	Local _lContinua := .T.

	Local _aMata380 := {}

	Local _nCount := 0

	Local _cPath := "LOGS_PROGRAMAS\OPCPA003\MsExecAuto\MATA380\"
	Local _cNome := "LOG_EMPENHAR_MATA380_U_" + RetCodUsr() + "_D_" + DToS(dDataBase) + "_H_" + Strtran(SubStr(Time(),1,5),":","") + ".log"

	Default l_Empenhar := .T.

	// Percorre todos os registros
	For _nCount := 1 To Len(_aDadosSZS)
		// Se for quantidade total ou parcial
		If _aDadosSZS[_nCount][N1_PROCESS] $ "1|2"
			// Posiciona no registro do SD4
			SD4->(DbGoTo(_aDadosSZS[_nCount][N1_RECSD4]))

			// Inicializa
			_aMata380 := {}

			// Adiciona o produto
			Aadd(_aMata380,{"D4_COD",_aDadosSZS[_nCount][N1_PRODUTO],Nil})

			If l_Empenhar
				// Adiciona o armazem
				Aadd(_aMata380,{"D4_LOCAL",_aDadosSZS[_nCount][N1_LOCDES],Nil})
			Else
				// Adiciona o armazem
				Aadd(_aMata380,{"D4_LOCAL",_aDadosSZS[_nCount][N1_LOCORI],Nil})
			EndIf

			// Adiciona a ordem de produção
			Aadd(_aMata380,{"D4_OP",_aDadosSZS[_nCount][N1_OP],Nil})

			// Adiciona a data
			Aadd(_aMata380,{"D4_DATA",dDataBase,Nil})

			If l_Empenhar
				// Adiciona a quantidade origem
				Aadd(_aMata380,{"D4_QTDEORI",_aDadosSZS[_nCount][N1_QUANT],Nil})
			Else
				// Adiciona a quantidade origem
				Aadd(_aMata380,{"D4_QTDEORI",_aDadosSZS[_nCount][N1_QTDSOLI],Nil})
			EndIf


			// Adiciona a quantidade
			Aadd(_aMata380,{"D4_QUANT",_aDadosSZS[_nCount][N1_QUANT],Nil})

			If l_Empenhar
				// Adiciona o lote
				Aadd(_aMata380,{"D4_LOTECTL",_aDadosSZS[_nCount][N1_LOTECTL],Nil})
			EndIf

			// Se a sequencia estiver preenchida
			If !Empty(_aDadosSZS[_nCount][N1_TRTSD4]) .And. !Empty(_aDadosSZS[_nCount][N1_LOTECTL])
				// Adiciona o lote
				Aadd(_aMata380,{"D4_TRT",_aDadosSZS[_nCount][N1_TRTSD4],Nil})
			Else

			 If _aDadosSZS[_nCount][18]=='S'
			 	Aadd(_aMata380,{"D4_TRT",_aDadosSZS[_nCount][4],Nil})
			 End

			EndIf
			

			// Executa a rotina MATA380
			MSExecAuto({|x,y| Mata380(x,y)},_aMata380,3)

			_lContinua := !lMsErroAuto

			If !_lContinua
				MostraErro(_cPath,_cNome)

				_cMsgErro := MemoRead(_cPath + _cNome)
				Exit
			Else
				// Se a quantidade for menor que a quantidade solicitada
				If _aDadosSZS[_nCount][N1_QUANT] < _aDadosSZS[_nCount][N1_QTDSOLI]
					// Inicializa
					_aMata380 := {}

					// Adiciona o produto
					Aadd(_aMata380,{"D4_COD",_aDadosSZS[_nCount][N1_PRODUTO],Nil})

					// Adiciona o armazem _aDadosSZS[_nCount][N1_LOCORI] MAURICIO 07/11/2021 - TESTE ARMAZEM 91
					Aadd(_aMata380,{"D4_LOCAL",_cLocProcEmp,Nil})

					// Adiciona a ordem de produção
					Aadd(_aMata380,{"D4_OP",_aDadosSZS[_nCount][N1_OP],Nil})

					// Adiciona a data
					Aadd(_aMata380,{"D4_DATA",dDataBase,Nil})

					// Adiciona a quantidade origem
					Aadd(_aMata380,{"D4_QTDEORI",_aDadosSZS[_nCount][N1_QTDSOLI] - _aDadosSZS[_nCount][N1_QUANT],Nil})

					// Adiciona a quantidade
					Aadd(_aMata380,{"D4_QUANT",_aDadosSZS[_nCount][N1_QTDSOLI] - _aDadosSZS[_nCount][N1_QUANT],Nil})

					// Se a sequencia estiver preenchida
					If !Empty(_aDadosSZS[_nCount][N1_TRTSD4]) .And. !Empty(_aDadosSZS[_nCount][N1_LOTECTL])
						// Adiciona o lote
						//Aadd(_aMata380,{"D4_TRT",_aDadosSZS[_nCount][N1_TRTSD4],Nil})
					Else
					//Força a inclusão do número da sequenciranda 08122021
						If _aDadosSZS[_nCount][18]=='S'
							Aadd(_aMata380,{"D4_TRT",_aDadosSZS[_nCount][4],Nil})
						End
					EndIf

					// Executa a rotina MATA380
					MSExecAuto({|x,y| Mata380(x,y)},_aMata380,3)

					_lContinua := !lMsErroAuto

					If !_lContinua
						MostraErro(_cPath,_cNome)

						_cMsgErro := MemoRead(_cPath + _cNome)
						Exit
					EndIf
				EndIf
			EndIf
		EndIf
	Next

Return _lContinua

Static Function _fGravaSZS()

	Local _lContinua := .F.

	Local _cId := ""
	Local _cOp := ""
	Local _cTime := Time()

	Local _dData := Date()

	Local _oModel := Nil
	Local _oModelCAB := Nil
	Local _oModelSZS := Nil

	Local _nCount := 0

	For _nCount := 1 To Len(_aDadosSZS)

		If Empty(_cOp) .Or. _cOp <> _aDadosSZS[_nCount][N1_OP]
			// Busca o ID
			_cId := _fGetCodig("SZS","ZS_ID",1)
		EndIf

		_oModel := FWLoadModel("OPCPA003")
		_oModel:SetOperation(MODEL_OPERATION_INSERT)
		_oModel:Activate()

		_oModelCAB := _oModel:GetModel("MODEL_CAB")
		_oModelCAB:LoadValue("ZS_FILIAL",xFilial("SZS"))
		_oModelCAB:LoadValue("ZS_ID",_cId)
		_oModelCAB:LoadValue("ZS_TIPPROC",_aDadosSZS[_nCount][N1_TIPPROC])
		_oModelCAB:LoadValue("ZS_OP",AllTrim(_aDadosSZS[_nCount][N1_OP]))
		_oModelCAB:LoadValue("ZS_USER",cUserName)
		_oModelCAB:LoadValue("ZS_DATA",_dData)
		_oModelCAB:LoadValue("ZS_HORA",_cTime)

		_oModelSZS := _oModel:GetModel("MODEL_SZS")
		_oModelSZS:AddLine()
		_oModelSZS:LoadValue("ZS_FILIAL",xFilial("SZS"))
		_oModelSZS:LoadValue("ZS_ID",_cId)
		_oModelSZS:LoadValue("ZS_TIPPROC",_aDadosSZS[_nCount][N1_TIPPROC])
		_oModelSZS:LoadValue("ZS_OP",AllTrim(_aDadosSZS[_nCount][N1_OP]))
		_oModelSZS:LoadValue("ZS_USER",cUserName)
		_oModelSZS:LoadValue("ZS_DATA",_dData)
		_oModelSZS:LoadValue("ZS_HORA",_cTime)
		_oModelSZS:LoadValue("ZS_PROCESS",_aDadosSZS[_nCount][N1_PROCESS])
		_oModelSZS:LoadValue("ZS_SEQUENC",_aDadosSZS[_nCount][N1_SEQUENC])
		_oModelSZS:LoadValue("ZS_PRODUTO",_aDadosSZS[_nCount][N1_PRODUTO])
		_oModelSZS:LoadValue("ZS_QTDSOLI",_aDadosSZS[_nCount][N1_QTDSOLI])
		_oModelSZS:LoadValue("ZS_QUANT",_aDadosSZS[_nCount][N1_QUANT])
		_oModelSZS:LoadValue("ZS_LOCORI",_aDadosSZS[_nCount][N1_LOCORI])
		_oModelSZS:LoadValue("ZS_ENDORI",_aDadosSZS[_nCount][N1_ENDORI])
		_oModelSZS:LoadValue("ZS_LOCDES",_aDadosSZS[_nCount][N1_LOCDES])
		_oModelSZS:LoadValue("ZS_LOCALIZ",_aDadosSZS[_nCount][N1_LOCALIZ])
		_oModelSZS:LoadValue("ZS_LOTECTL",_aDadosSZS[_nCount][N1_LOTECTL])
		_oModelSZS:LoadValue("ZS_DOC",_aDadosSZS[_nCount][N1_DOC])

		// Grava alteração
		_lContinua := FwFormCommit(_oModel)

		If _lContinua
			// Confirma o codigo
			SZS->(ConfirmSX8())
		Else
			// retorna o codigo
			SZS->(RollBackSX8())
			Exit
		EndIf

		// Guarda o numero da OP
		_cOp := _aDadosSZS[_nCount][N1_OP]
	Next

Return _lContinua

/*/{Protheus.doc} _fGtCodSZS
	(Função para buscar o proximo registro da SZS)

	@type Static Function
	@author Vitor Ribeiro
	@since 09/03/2020

	@param c_Tabela, caracter, contém a tabela
	@param c_Campo, caracter, contém o campo
	@param n_Order, numerico, contém a ordem do indice

	@return _cCodigo, caracter, retornar o codigo da SZS.
	/*/
Static Function _fGetCodig(c_Tabela,c_Campo,n_Order)

    Local _cCodigo := ""

	Default c_Tabela := ""
	Default c_Campo := ""

	Default n_Order := 0
	
	While Empty(_cCodigo)
        // Pega o proximo numero
        _cCodigo := GetSxENum(c_Tabela,c_Campo,1)

		// Pesquisa o codigo para ver se já existe o mesmo
        (c_Tabela)->(DbSetOrder(n_Order))
        If (c_Tabela)->(DbSeek(xFilial(c_Tabela)+_cCodigo))
            // Confirma o codigo
            (c_Tabela)->(ConfirmSX8())
            _cCodigo := ""
        EndIf
	EndDo

Return _cCodigo

Static Function _fExecDevo()

	Local _aArea := GetArea()
	Local _aAreaSZS := SZS->(GetArea())

	Local _lContinua := .F.

	Local _nCount := 0
	Local _nPosicao := 0

	Private _aDadosSZS := {}
	Private _aDadosSD4 := {}

	Private lMsErroAuto := .F.
	Private lMSHelpAuto := .T.

	DbSelectArea("SD4")		// REQUISIÇÕES EMPENHADAS
	SD4->(DbSetOrder(2))	// D4_FILIAL+D4_OP+D4_COD+D4_LOCAL

	// Retorna os dados dos itens da OP
	_fMakeQry(3)

	If Empty(_aDadosSZS)
		MsgAlert("As quantidades já foram consumidas, por isso não podem mais ser devolvidas." + CRLF + CRLF + "Verifique.")
	Else
		For _nCount := 1 To Len(_aDadosSZS)
			// Se ainda não for a ultima linha
			If _nCount < Len(_aDadosSZS)
				// Se o proximo produto for o mesmo produto
				If _aDadosSZS[_nCount][N1_PRODUTO] == _aDadosSZS[_nCount+1][N1_PRODUTO]

					If Empty(_aDadosSZS[_nCount][N1_TRTSD4])
						_aDadosSZS[_nCount][N1_TRTSD4] := StrZero(1,3)
					EndIf

					If Empty(_aDadosSZS[_nCount+1][N1_TRTSD4])
						_aDadosSZS[_nCount+1][N1_TRTSD4] := Soma1(_aDadosSZS[_nCount][N1_TRTSD4])
					EndIf
				EndIf
			EndIf
		Next

		SD4->(DbSetOrder(2))	// D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
		If SD4->(DbSeek(xFilial("SD4")+_cOrdemPrd))
			// Enquanto for a mesma ordem de produção
			While SD4->(!Eof()) .And. xFilial("SD4")+_cOrdemPrd == SD4->D4_FILIAL+AllTrim(SD4->D4_OP)
				// Busca o recno no array
				_nPosicao := Ascan(_aDadosSZS,{|x| x[N1_RECSD4] == SD4->(Recno()) })

				// Se não encontrou o recno
				If _nPosicao < 1
					Aadd(_aDadosSD4,{0,{}})
					_nPosicao := Len(_aDadosSD4)

					_aDadosSD4[_nPosicao][1] := SD4->(Recno())

					// Adiciona o produto
					Aadd(_aDadosSD4[_nPosicao][2],{"D4_COD",SD4->D4_COD,Nil})

					// Adiciona o armazem
					Aadd(_aDadosSD4[_nPosicao][2],{"D4_LOCAL",SD4->D4_LOCAL,Nil})

					// Adiciona a ordem de produção
					Aadd(_aDadosSD4[_nPosicao][2],{"D4_OP",SD4->D4_OP,Nil})

					// Adiciona a data
					Aadd(_aDadosSD4[_nPosicao][2],{"D4_DATA",dDataBase,Nil})

					// Adiciona a quantidade origem
					Aadd(_aDadosSD4[_nPosicao][2],{"D4_QTDEORI",SD4->D4_QTDEORI,Nil})

					// Adiciona a quantidade
					Aadd(_aDadosSD4[_nPosicao][2],{"D4_QUANT",SD4->D4_QUANT,Nil})

					If !Empty(SD4->D4_LOTECTL)
						// Adiciona o lote
						Aadd(_aDadosSD4[_nPosicao][2],{"D4_LOTECTL",SD4->D4_LOTECTL,Nil})
					EndIf

					// Se a sequencia estiver preenchida
					If !Empty(SD4->D4_TRT) .And. !Empty(SD4->D4_LOTECTL)
						// Adiciona o lote
						Aadd(_aDadosSD4[_nPosicao][2],{"D4_TRT",SD4->D4_TRT,Nil})
					EndIf
				EndIf

				// Vai para o proximo registro
				SD4->(DbSkip())
			EndDo
		EndIf

		Begin Transaction
			// Função para Excluir os empenhos
			_lContinua := _fExcEmpe()

			If _lContinua
				// Função para excluir todos os empenhos da ordem de produção
				_lContinua := _fExcAllEm()
			EndIf

			If _lContinua
				// Função para transferir os produtos
				_lContinua := _fTransfer()
			EndIf

			// Se conseguiu transferir com sucesso
			If _lContinua
				// Função para empenhar os produtos
			//	_lContinua := _fEmpenho(.F.)
			EndIf

			// Se conseguiu transferir com sucesso
			If _lContinua
				// Função para gravar a SZS
				_fGrvDevol()
			EndIf

			// Se ocorreu algum erro
			If !_lContinua
				// Desarma a transação
				DisarmTransaction()
			EndIf
		End Transaction

		If _lContinua
			_fExcluOP(_cOrdemPrd)
			MsgAlert("Devolução realizada com sucesso!","Atenção")
		Else
			Alert("Não foi possivel realizar a devolução!","Atenção")
		EndIf

	EndIf

	RestArea(_aAreaSZS)
	RestArea(_aArea)

Return Nil

Static Function _fExcAllEm()

	Local _lContinua := .T.

	Local _nCount := 0

	Local _cPath := "LOGS_PROGRAMAS\OPCPA003\MsExecAuto\MATA380\"
	Local _cNome := "LOG_EXCLUIR_ALL_MATA380_U_" + RetCodUsr() + "_D_" + DToS(dDataBase) + "_H_" + Strtran(SubStr(Time(),1,5),":","") + ".log"

	// Percorre todos os registros
	For _nCount := 1 To Len(_aDadosSD4)
		// Posiciona no registro do SD4
		SD4->(DbGoTo(_aDadosSD4[_nCount][1]))

		// Executa a rotina MATA380 para excluir o registro
		MSExecAuto({|x,y| Mata380(x,y)},_aDadosSD4[_nCount][2],5)

		_lContinua := !lMsErroAuto

		If !_lContinua
			MostraErro(_cPath,_cNome)

			_cMsgErro := MemoRead(_cPath + _cNome)
			Exit
		EndIf
	Next

Return _lContinua

Static Function _fGrvDevol()
	
	Local _nPosicao := 0

	SZS->(DbSetOrder(1))    // ZS_FILIAL+ZS_ID
	SZS->(DbSeek(xFilial("SZS")+_cCodigoId))	
    _cNumOPDev := SZS->ZS_OP

	SZS->(DbSetOrder(2))    // ZS_FILIAL+ZS_OP
	SZS->(DbSeek(xFilial("SZS")+_cNumOPDev))

	// Enquanto não for final de arquivo e for o mesmo ID
    //While SZS->(!Eof()) .And. xFilial("SZS")+_cCodigoId == SZS->(ZS_FILIAL+ZS_ID)
	// Alterado para fazer por OP - MAURICIO 21/12/2020

	While SZS->(!Eof()) .And. xFilial("SZS")+_cNumOPDev == SZS->(ZS_FILIAL+ZS_OP)
		// Busca o registro no array
		_nPosicao := Ascan(_aDadosSZS,{|x| x[N1_RECSZS] == SZS->(Recno()) })

		RecLock("SZS",.F.)
			SZS->ZS_TIPPROC := "D"
			SZS->ZS_ESTORNO := "S"
 			// Se encontrou o registro
			If _nPosicao > 0
				SZS->ZS_QTDDEVO := _aDadosSZS[_nPosicao][N1_QUANT]
				SZS->ZS_DOCDEVO := _aDadosSZS[_nPosicao][N1_DOC]
			EndIf
		SZS->(MsUnLock())

		// Vai para o proximo registro
		SZS->(DbSkip())
	EndDo

Return Nil

Static Function _fExcluOP(_cNumOP)

    Local _cNumSC2 := SubStr(_cNumOP,1,6)
    Local _cItem := SubStr(_cNumOP,7,2)
    Local _cSequen := SubStr(_cNumOP,9,3)

    Local _aMata650 := {}

    Local _lContinua := .T.

    Private lMsErroAuto := .F.  // Variavel usada para o retorno da MsExecAuto

	Aadd(_aMata650,{"C2_NUM",_cNumSC2,Nil})
	Aadd(_aMata650,{"C2_ITEM",_cItem,Nil})
	Aadd(_aMata650,{"C2_SEQUEN",_cSequen,Nil})
 
    // Executa o MATA650
    MSExecAuto({|x,y| MATA650(x,y) },_aMata650,5)

    // Se gerou algum erro
    If lMsErroAuto
        // Guarda o erro
        MostraErro()
    Else
        _lContinua := .T.
    EndIf

Return _lContinua

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Função    |  _nSeqOp   | Miranda     | Data   08/12/21   º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Desc.: Faz a busca da proxima sequencia   SD4.D4_TRT                   º±±
//±±                                                                        º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

Static Function _nSeqOp(_nOP,_nCodPro)
Local _xNOp := ""

	cQryOP	:="SELECT MAX(D4_TRT) AS NSEQOP "+CHR(13)+CHR(10)
    cQryOP 	+="FROM "+CHR(13)+CHR(10)
    cQryOP 	+=RetSqlName("SD4")+" SD4 "+CHR(13)+CHR(10)
    cQryOP 	+="WHERE  "+CHR(13)+CHR(10)
    cQryOP 	+="D4_OP ='"+AllTrim(_nOP)+"' AND "+CHR(13)+CHR(10)
	cQryOP 	+="D4_COD ='"+AllTrim(_nCodPro)+"' AND "+CHR(13)+CHR(10)
	cQryOP 	+="D4_TRT <>'' AND D_E_L_E_T_='' "+CHR(13)+CHR(10)
    cQryOP  := ChangeQuery(cQryOP)
    //Grava o resultado da Query
   	MEMOWRIT( "XORTOP.SQL", cQryOP ) 
	//Executa a Query
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQryOP),"QRY",.T.,.F. )	
	//
	If Val(QRY->NSEQOP) > 0 
		_xNOp := Val(QRY->NSEQOP) + 1
	Else
		_xNop := 0
	EndIf
	//Fecha o alias
	QRY->(DbClosearea()) 

Return(_xNOp)
