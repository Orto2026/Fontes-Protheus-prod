#Include "Protheus.ch"
#Include "FWMVCDef.ch"
#Include "TopConn.ch"
#Include "ParmType.ch"
#Include "RwMake.ch" 
#Include "Totvs.ch"
#Include "FileIo.ch"
#Include "TbiConn.ch"
#Include "Msole.ch"

/*/{Protheus.doc} OPCPA001
	(Programa Conferencia de nota)

	@type User function
	@author Vitor Ribeiro
	@since 22/01/2019

	@return Nil, nulo, não tem retorno.
	/*/
User function OPCPA001()
	
	Local _oBrowse := Nil

	// Instanciamento da Classe de Browse
	_oBrowse := FWMBrowse():New()
	
	// Definição da tabela do Browse inicial 
	_oBrowse:SetAlias("SZH")
	
	// Titulo da Browse
	_oBrowse:SetDescription("Conferencia de nota")

	// Adiciona a coluna com a legenda.
	_oBrowse:AddLegend({|| SZH->ZH_STATUS == "1" },"BR_VERDE","Em aberto")
	_oBrowse:AddLegend({|| SZH->ZH_STATUS == "2" },"BR_AMARELO","Conferência iniciada")
	_oBrowse:AddLegend({|| SZH->ZH_STATUS == "3" },"BR_VERMELHO","Conferência encerrada")

	_oBrowse:SetMenuDef("OPCPA001")
	
	// Ativação da Classe
	_oBrowse:Activate()

Return NIL

/*/{Protheus.doc} MenuDef
	(Contém a definição das operações disponíveis para o modelo de dados (Model))

	@type Static function
	@author Vitor Ribeiro
	@since 22/01/2019

	@return _aRotina, array, retorna os botões da tela
	/*/
Static Function MenuDef()

	Local _aRotina := {}

	ADD OPTION _aRotina Title "Visualizar"  	ACTION "VIEWDEF.OPCPA001"   OPERATION MODEL_OPERATION_VIEW		ACCESS 0
	//ADD OPTION _aRotina Title "Incluir"     	ACTION "VIEWDEF.OPCPA001"	OPERATION MODEL_OPERATION_INSERT	ACCESS 0
	//ADD OPTION _aRotina Title "Alterar"     	ACTION "VIEWDEF.OPCPA001"	OPERATION MODEL_OPERATION_UPDATE	ACCESS 0   
	//ADD OPTION _aRotina Title "Excluir"     	ACTION "VIEWDEF.OPCPA001"	OPERATION MODEL_OPERATION_DELETE	ACCESS 0
	
Return _aRotina

/*/{Protheus.doc} ModelDef
	(Contém a construção e a definição do Model, lembrando que o Modelo de dados (Model) contém as regras de negócio)

	@type Static function
	@author Vitor Ribeiro
	@since 22/01/2019

	@return _oModel, objeto, retorna o modelo
	/*/
Static Function ModelDef()

	Local _oStruSZH := Nil
	Local _oStruSZI := Nil
	Local _oStruSZJ := Nil
    Local _oStruSZK := Nil
	Local _oModel := NIL

	Local _bPost := {|| }
	Local _bCommit := {|| }

	_oStruSZH := FWFormStruct(1,"SZH")
	_oStruSZI := FWFormStruct(1,"SZI")
	_oStruSZJ := FWFormStruct(1,"SZJ")
    _oStruSZK := FWFormStruct(1,"SZK")

	_oModel := MPFormModel():New("U_OPCPA001",,_bPost,_bCommit)

	_oModel:AddFields("MODEL_SZH",,_oStruSZH)
	
	_oModel:SetPrimaryKey({"ZH_FILIAL","ZH_CODIGO"})
	
	_oModel:AddGrid("MODEL_SZI","MODEL_SZH",_oStruSZI)
	_oModel:AddGrid("MODEL_SZJ","MODEL_SZH",_oStruSZJ)
    _oModel:AddGrid("MODEL_SZK","MODEL_SZH",_oStruSZK)

	_oModel:SetRelation("MODEL_SZI",{{"ZI_FILIAL","XFILIAL('SZH')"},{"ZI_COD_SZH","ZH_CODIGO"}},SZI->(IndexKey(1)))
	_oModel:SetRelation("MODEL_SZJ",{{"ZJ_FILIAL","XFILIAL('SZJ')"},{"ZJ_COD_SZH","ZH_CODIGO"}},SZJ->(IndexKey(1)))
    _oModel:SetRelation("MODEL_SZK",{{"ZK_FILIAL","XFILIAL('SZK')"},{"ZK_COD_SZH","ZH_CODIGO"}},SZK->(IndexKey(1)))
	
	_oModel:GetModel("MODEL_SZI"):SetUniqueLine({"ZI_FILIAL","ZI_COD_SZH","ZI_SEQUEN"})
	_oModel:GetModel("MODEL_SZJ"):SetUniqueLine({"ZJ_FILIAL","ZJ_COD_SZH","ZJ_SEQUEN"})
    _oModel:GetModel("MODEL_SZK"):SetUniqueLine({"ZK_FILIAL","ZK_COD_SZH","ZK_SEQUEN"})

	_oModel:SetOnDemand(.F.)
	
Return _oModel

/*/{Protheus.doc} ViewDef
	(Contém a construção e definição da View, ou seja, será a construção da interface)

	@type Static function
	@author Vitor Ribeiro
	@since 22/01/2019

	@return _oView, objeto, retorna a view
	/*/
Static Function ViewDef()

	Local _oView := Nil
	Local _oModel := Nil
	Local _oStruSZH := Nil
	Local _oStruSZI := Nil
	Local _oStruSZJ := Nil
    Local _oStruSZK := Nil

	// Funcao que retorna um objeto de model de determinado fonte.
	_oModel := FWLoadModel("OPCPA001")

	// Função fornece o objeto com as estruturas de metadado do dicionário de dados, utilizadas pelas classes Model e View.
	_oStruSZH := FWFormStruct(2,"SZH")
	_oStruSZI := FWFormStruct(2,"SZI")
	_oStruSZJ := FWFormStruct(2,"SZJ")
    _oStruSZK := FWFormStruct(2,"SZK")

	// Fornece uma interface gráfica para um model
	_oView := FWFormView():New()
	
	// Set o Model que esse view ira ultilizar
	_oView:SetModel(_oModel)
	
	// Adiciona ao view um formulário do tipo FormFields
	_oView:AddField("VIEW_SZH",_oStruSZH,"MODEL_SZH")

	// Adiciona ao view um formulário do tipo FWFormGrid.
	_oView:AddGrid("VIEW_SZI",_oStruSZI,"MODEL_SZI")
	_oView:AddGrid("VIEW_SZJ",_oStruSZJ,"MODEL_SZJ")
    _oView:AddGrid("VIEW_SZK",_oStruSZK,"MODEL_SZK")

	// Seta itens da tabela como auto incremento
	_oView:AddIncrementField("VIEW_SZI","ZI_ITEM")
	_oView:AddIncrementField("VIEW_SZJ","ZJ_ITEM")
    _oView:AddIncrementField("VIEW_SZK","ZK_ITEM")
	
	// Inicializa as boxes para exibição
	_oView:CreateHorizontalBox("BOXTAB",60)
	_oView:CreateHorizontalBox("BOXITEM",40)
	
	// Cria um folder
	_oView:CreateFolder("FOLDER","BOXITEM")

	// Aciona os folders
	_oView:AddSheet("FOLDER","ABA1","NOTAS PARA CONFERENCIA")
	_oView:AddSheet("FOLDER","ABA2","ITENS PARA CONFERENCIA")
    _oView:AddSheet("FOLDER","ABA3","ITENS CONFERIDOS")

	// Inicializa as boxes para exibição
	_oView:CreateHorizontalBox("BOX_SZI",100,,,"FOLDER","ABA1")
	_oView:CreateHorizontalBox("BOX_SZJ",100,,,"FOLDER","ABA2")
    _oView:CreateHorizontalBox("BOX_SZK",100,,,"FOLDER","ABA3")

	//Vincula os objetos da view
	_oView:SetOwnerView("VIEW_SZH","BOXTAB")
	_oView:SetOwnerView("VIEW_SZI","BOX_SZI")
	_oView:SetOwnerView("VIEW_SZJ","BOX_SZJ")
    _oView:SetOwnerView("VIEW_SZK","BOX_SZK")

Return _oView

User Function PP001A01(c_Campo,l_Memory)

    Local _xRetorno := Nil

    Default c_Campo := ""

    Default l_Memory := .F.

    If c_Campo == "ZH_USRCRI"
        If l_Memory
            _xRetorno := UsrRetName(M->ZH_IDCRI)
        Else
            _xRetorno := UsrRetName(SZH->ZH_IDCRI)
        EndIf
    ElseIf c_Campo == "ZH_USRINI"
        If l_Memory
            _xRetorno := UsrRetName(M->ZH_IDINI)
        Else
            _xRetorno := UsrRetName(SZH->ZH_IDINI)
        EndIf
    ElseIf c_Campo == "ZH_USRFIN"
        If l_Memory
            _xRetorno := UsrRetName(M->ZH_IDFIN)
        Else
            _xRetorno := UsrRetName(SZH->ZH_IDFIN)
        EndIf
    ElseIf c_Campo == "ZI_NOME"
        If SZI->((ZI_TIPOMOV == "E" .And. !(ZI_TIPO $ "B|D")) .Or. (ZI_TIPOMOV == "S" .And. ZI_TIPO $ "B|D"))
            If l_Memory
                _xRetorno := Posicione("SA2",1,xFilial("SA2")+M->(ZI_CLIEFOR+ZI_LOJA),"A2_NOME")
            Else
                _xRetorno := Posicione("SA2",1,xFilial("SA2")+SZI->(ZI_CLIEFOR+ZI_LOJA),"A2_NOME")
            EndIf
        Else
            If l_Memory
                _xRetorno := Posicione("SA1",1,xFilial("SA1")+M->(ZI_CLIEFOR+ZI_LOJA),"A1_NOME")
            Else
                _xRetorno := Posicione("SA1",1,xFilial("SA1")+SZI->(ZI_CLIEFOR+ZI_LOJA),"A1_NOME")
            EndIf
        EndIf
    ElseIf c_Campo == "ZI_USRCONF"
        If l_Memory
            _xRetorno := UsrRetName(M->ZI_IDCONF)
        Else
            _xRetorno := UsrRetName(SZI->ZI_IDCONF)
        EndIf
    ElseIf c_Campo == "ZJ_DESPROD"
        If l_Memory
            _xRetorno := Posicione("SB1",1,xFilial("SB1")+M->ZJ_CODPROD,"B1_DESC")
        Else
            _xRetorno := Posicione("SB1",1,xFilial("SB1")+SZJ->ZJ_CODPROD,"B1_DESC")
        EndIf
    ElseIf c_Campo == "ZK_DESPROD"
        If l_Memory
            _xRetorno := Posicione("SB1",1,xFilial("SB1")+M->ZK_CODPROD,"B1_DESC")
        Else
            _xRetorno := Posicione("SB1",1,xFilial("SB1")+SZK->ZK_CODPROD,"B1_DESC")
        EndIf
    ElseIf c_Campo == "ZK_USRCONF"
        If l_Memory
            _xRetorno := UsrRetName(M->ZK_IDCONF)
        Else
            _xRetorno := UsrRetName(SZK->ZK_IDCONF)
        EndIf
    EndIf

Return _xRetorno