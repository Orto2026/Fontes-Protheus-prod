#Include 'Protheus.ch'
#Include 'RwMake.ch' 
#Include 'TopConn.ch' 
#Include 'FWMVCDef.ch'
#Include 'ParmType.ch'
#Include 'FileIo.ch'
#Include 'TbiConn.ch'
#Include 'Msole.ch'

/*/{Protheus.doc} 
Nome Antigo OPCPA001
DESMEOP Obs: Nome alterado por  dia 07/01/2010, pois estava com o mesmo nome da rotida de conferecia de NF 
	(Desmembramento de Ordem de Produção)

	@type User Function
	@author Vitor Ribeiro
	@since 08/02/2019

	@return Nil, nulo, não tem retorno.
	/*/
User function DESMEOP(c_NumOp,c_Item,c_Sequen)

	Local _oBrowse := Nil

	Private _cNumOp := ''
	Private _cItem := ''
	Private _cSequen := ''

	Default c_NumOp := ''
	Default c_Item := ''
	Default c_Sequen := ''

	_cNumOp := c_NumOp
	_cItem := c_Item
	_cSequen := c_Sequen

	// Instanciamento da Classe de Browse
	_oBrowse := FWMBrowse():New()

	// Definição da tabela do Browse inicial 
	_oBrowse:SetAlias('SZ7')

	// Titulo da Browse
	_oBrowse:SetDescription('Desmembramento de Ordem de Produção')

	// Adiciona a coluna com a legenda.
	_oBrowse:AddLegend({|| SZ7->Z7_IMPRESS == '2' },'BR_VERMELHO','Não impresso')
	_oBrowse:AddLegend({|| SZ7->Z7_IMPRESS == '1' },'BR_VERDE','Impresso')

	// Se foi informado filtro
	If !Empty(_cNumOp) .And. !Empty(_cItem) .And. !Empty(_cSequen)
		_oBrowse:SetFilterDefault("SZ7->Z7_NUMOP = '" + _cNumOp + "' .And. SZ7->Z7_ITEM = '" + _cItem + "' .And. SZ7->Z7_SEQUEN = '" + _cSequen + "' ")
	EndIf

	// Seta o menu
	_oBrowse:SetMenuDef('DESMEOP')

	// Ativação da Classe
	_oBrowse:Activate()

Return Nil

/*/{Protheus.doc} MenuDef
	(Contém a definição das operações disponíveis para o modelo de dados (Model))

	@type Static Function
	@author Vitor Ribeiro
	@since 08/02/2019

	@return _aRotina, array, retorna os botões da tela
	/*/
Static Function MenuDef()

	Local _aRotina := {}

	ADD OPTION _aRotina Title 'Visualizar'  ACTION 'VIEWDEF.DESMEOP'			OPERATION MODEL_OPERATION_VIEW		ACCESS 0
	ADD OPTION _aRotina Title 'Desmembrar' 	ACTION 'VIEWDEF.DESMEOP'			OPERATION MODEL_OPERATION_INSERT	ACCESS 0
	ADD OPTION _aRotina Title 'Imprimir' 	ACTION 'U_XTT001A(SZ7->(Recno()))'	OPERATION 1							ACCESS 0
	ADD OPTION _aRotina Title 'Excluir'    	ACTION 'VIEWDEF.DESMEOP'			OPERATION MODEL_OPERATION_DELETE	ACCESS 0
	
Return _aRotina

/*/{Protheus.doc} ModelDef
	(Contém a construção e a definição do Model, lembrando que o Modelo de dados (Model) contém as regras de negócio)

	@type Static Function
	@author Vitor Ribeiro
	@since 08/02/2019

	@return _oModel, objeto, retorna o modelo
	/*/
Static Function ModelDef()

	Local _oStruSZ7 := Nil
	Local _oModel := NIL

	_oStruSZ7 := FWFormStruct(1,'SZ7')

	// Se foi informado filtro
	If !Empty(_cNumOp) .And. !Empty(_cItem) .And. !Empty(_cSequen)
		// Altera a propriedade when dos campos da SZJ
		_oStruSZ7:SetProperty('Z7_NUMOP',MODEL_FIELD_WHEN,{|| .F. })
		_oStruSZ7:SetProperty('Z7_ITEM',MODEL_FIELD_WHEN,{|| .F. })
		_oStruSZ7:SetProperty('Z7_SEQUEN',MODEL_FIELD_WHEN,{|| .F. })

		// Inicializa com o numero da op posicionada
		_oStruSZ7:SetProperty('Z7_NUMOP',MODEL_FIELD_INIT,{|| _cNumOp })
		_oStruSZ7:SetProperty('Z7_ITEM',MODEL_FIELD_INIT,{|| _cItem })
		_oStruSZ7:SetProperty('Z7_SEQUEN',MODEL_FIELD_INIT,{|| _cSequen })
	EndIf

	_oModel := MPFormModel():New('U_DESMEOP')

    _oModel:AddFields('MODEL_SZ7',,_oStruSZ7)
	_oModel:SetPrimaryKey({'Z7_FILIAL','Z7_NUMOP','Z7_ITEM','Z7_SEQUEN','Z7_BARRA'})

	// Se foi informado filtro
	If !Empty(_cNumOp) .And. !Empty(_cItem) .And. !Empty(_cSequen)
		_oModel:SetActivate({|| U_XTT002A('Z7_NUMOP') .And. U_XTT002A('Z7_ITEM') .And. U_XTT002A('Z7_SEQUEN') })
	EndIf
	
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
	Local _oStruSZ7 := Nil

	// Funcao que retorna um objeto de model de determinado fonte.
	_oModel := FWLoadModel('DESMEOP')

	// Função fornece o objeto com as estruturas de metadado do dicionário de dados, utilizadas pelas classes Model e View.
	_oStruSZ7 := FWFormStruct(2,'SZ7')

	// Fornece uma interface gráfica para um model
	_oView := FWFormView():New()

	// Set o Model que esse view ira ultilizar
	_oView:SetModel(_oModel)

	// Adiciona ao view um formulário do tipo FormFields
	_oView:AddField('VIEW_SZ7',_oStruSZ7,'MODEL_SZ7')

	// Inicializa as boxes para exibição
	_oView:CreateHorizontalBox('TABELA',100)

	// Vincula os objetos da view
	_oView:SetOwnerView('VIEW_SZ7','TABELA')

	// Metodo que seta um Code-block para ser avaliado antes de se ativar o View
	_oView:SetViewCanActivate({|_oModel| _fViewCanA(_oModel) })

Return _oView

/*/{Protheus.doc} _fViewCanA
	(Função para verificar se a view pode ser ativada)

	@type User function
	@author Vitor Ribeiro
	@since 22/01/2019

	@return _lAtivada, logico, se a view pode ser ativada
	/*/
Static Function _fViewCanA(o_Model)

	Local _lAtivada := .T.

	Default o_Model := Nil

	// Pega a operação
	_nOper := o_Model:GetOperation()

	// Se for exclusão
	If _nOper == MODEL_OPERATION_DELETE
		// Se estiver impresso
		If SZ7->Z7_IMPRESS == '1'
			MsgAlert('O desmembramento da OP [' + SZ7->(Z7_NUMOP+Z7_ITEM+Z7_SEQUEN)  + '/' + SZ7->Z7_BARRA + '] já foi impresso!' + CRLF + CRLF + 'Não será permitido a exclusão do mesmo.','Atenção')
			_lAtivada := .F.
		EndIf
	EndIf

Return _lAtivada

Static _nQuantSC2 := 0
Static _nQuantSZ7 := 0

/*/{Protheus.doc} XTT002A

Nome Antigo  PP001A01
XTT002A Obs: Nome alterado por  dia 07/01/2010, pois estava com o mesmo nome da rotida de conferecia de NF
	(Função para validar os campos)

	@type User function
	@author Vitor Ribeiro
	@since 22/01/2019

	@return _lValida, logico, se foi validado ou não
	/*/
User Function XTT002A(c_Campo)

	Local _aArea := GetArea()
	Local _aAreaSZ7 := SZ7->(GetArea())
	Local _aAreaSC2 := SC2->(GetArea())
	Local _aAreaSH6 := SH6->(GetArea())

	Local _lValida := .T.

	Local _cBarra := ''
	Local _cMensagem := ''
	Local _cSolucao := ''
	Local _cImpress := ''
	Local _cOperaca := ''
	Local _cRecurso := ''
	Local _cNomeRec := ''

	Local _oView := Nil
	Local _oModel := Nil
	Local _oMdlSZ7 := Nil

	Default c_Campo := StrTran(ReadVar(),'M->','')

	DbSelectArea('SZ7')		// DESMEMBRAMENTO ORDEM PRODUCAO
	SZ7->(DbSetOrder(1))	// Z7_FILIAL+Z7_NUMOP+Z7_ITEM+Z7_SEQUEN+Z7_BARRA+Z7_PRODUTO

	DbSelectArea('SC2')		// ORDENS DE PRODUÇÃO
	SC2->(DbSetOrder(1))	// C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
	
	DbSelectArea('SH6')		// MOVIMENTAÇÃO DA PRODUÇÃO
	SH6->(DbSetOrder(1))	// H6_FILIAL+H6_OP+H6_PRODUTO+H6_OPERAC+H6_SEQ+DTOS(H6_DATAINI)+H6_HORAINI+DTOS(H6_DATAFIN)+H6_HORAFIN

	DbSelectArea('SH1')		// RECURSOS
	SH1->(DbSetOrder(1))	// H1_FILIAL+H1_CODIGO

	// Pega a view ativa
	_oView := FWViewActive()

	// Pega o modelo ativo
	_oModel := FWModelActive()

	// Carrega os modelos especificos
	_oMdlSZ7 := _oModel:GetModel('MODEL_SZ7')

	// Se for os campo de numero da op, item e sequencia
	If c_Campo $ 'Z7_NUMOP|Z7_ITEM|Z7_SEQUEN'
		// Inicializa a barra
		_cBarra := '0'
		_cImpress := ''
		_cOperaca := ''
		_cRecurso := ''
		_cNomeRec := ''
		_nQuantSC2 := 0
		_nQuantSZ7 := 0

		_oMdlSZ7:SetValue('Z7_PRODUTO','')
		_oMdlSZ7:SetValue('Z7_BARRA','')
		_oMdlSZ7:SetValue('Z7_OPERAC','')
		_oMdlSZ7:SetValue('Z7_RECURSO','')
		_oMdlSZ7:SetValue('Z7_NOMEREC','')

		If c_Campo == 'Z7_NUMOP'
			_oMdlSZ7:SetValue('Z7_ITEM','')
		EndIf

		If c_Campo $ 'Z7_NUMOP|Z7_ITEM'
			_oMdlSZ7:SetValue('Z7_SEQUEN','')
		EndIf

		// Pesquisa a ordem de produção
		If SC2->(DbSeek(xFilial('SC2')+AllTrim(_oMdlSZ7:GetValue('Z7_NUMOP'))+AllTrim(_oMdlSZ7:GetValue('Z7_ITEM'))+AllTrim(_oMdlSZ7:GetValue('Z7_SEQUEN'))))
			// Se o campo do numero da op, item e sequencia estiver preenchido
			If !Empty(_oMdlSZ7:GetValue('Z7_NUMOP')) .And. !Empty(_oMdlSZ7:GetValue('Z7_ITEM')) .And. !Empty(_oMdlSZ7:GetValue('Z7_SEQUEN'))
				// Guarda a quantidade da ordem de produção
				_nQuantSC2 := SC2->C2_QUANT

				// Adiciona o produto
				_oMdlSZ7:SetValue('Z7_PRODUTO',SC2->C2_PRODUTO)

				// Pesquisa o desmembramento
				If SZ7->(DbSeek(xFilial('SZ7')+SC2->(+C2_NUM+C2_ITEM+C2_SEQUEN)))
					// Percorre os desmembramentos
					While SZ7->(!Eof()) .And. xFilial('SZ7')+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) == SZ7->(Z7_FILIAL+Z7_NUMOP+Z7_ITEM+Z7_SEQUEN)
						// Guarda a impressao
						_cImpress := SZ7->Z7_IMPRESS

						// Guarda a barra
						_cBarra := SZ7->Z7_BARRA

						// Soma a quantidade
						_nQuantSZ7 += SZ7->Z7_QUANT

						// Vai para o proximo registro
						SZ7->(DbSkip())
					EndDo
				EndIf

				// Se o ultimo desmembramento já foi impresso
				If _cImpress <> '2'
					// Adiciona o produto
					_oMdlSZ7:SetValue('Z7_BARRA',PadL(Soma1(_cBarra),TamSx3('Z7_BARRA')[1],'0'))

					// Pesquisa o apontamento
					If SH6->(DbSeek(xFilial('SH6')+SC2->(+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD+C2_PRODUTO)))
						// Percorre todos os apontamentos
						While SH6->(!Eof()) .And. xFilial('SH6')+SC2->(+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD+C2_PRODUTO) == SH6->(H6_FILIAL+H6_OP+H6_PRODUTO)
							// Guarda a operação
							_cOperaca := SH6->H6_OPERAC

							// Guarda o recurso
							_cRecurso := SH6->H6_RECURSO

							// Vai para o proximo registro
							SH6->(DbSkip())
						EndDo
					EndIf

					// Se o recurso estiver preenchido, pesquisa sua descrição
					If !Empty(_cRecurso) .And. SH1->(DbSeek(xFilial('SH1')+_cRecurso))
						// Guarda o nome do recurso
						_cNomeRec := SH1->H1_DESCRI
					EndIf

					// Adiciona a operação
					_oMdlSZ7:SetValue('Z7_OPERAC',_cOperaca)
					_oMdlSZ7:SetValue('Z7_RECURSO',_cRecurso)
					_oMdlSZ7:SetValue('Z7_NOMEREC',_cNomeRec)
				Else
					_cMensagem := 'Essa op possui um desmembramento sem impressão.'
					_cSolucao := 'Imprima ou exclua o desmembramento anterior antes de prosseguir.'
					_lValida := .F.
				EndIf
			EndIf
		Else
			_cMensagem := 'A ordem de produção informada não foi encontrada.'
			_cSolucao := 'Informe uma ordem de produção existente.'
			_lValida := .F.
		EndIf
		
	ElseIf c_Campo $ 'Z7_QUANT'

		// Se algum dos campos de numero da op, item e sequencia não estiver preenchido
		If Empty(_oMdlSZ7:GetValue('Z7_NUMOP')) .Or. Empty(_oMdlSZ7:GetValue('Z7_ITEM')) .Or. Empty(_oMdlSZ7:GetValue('Z7_SEQUEN'))
			_cMensagem := 'O numero da op, item e sequencia não foi informado.'
			_cSolucao := 'Informe a ordem de produção primeiro.'
			_lValida := .F.
		ElseIf (_nQuantSZ7 + _oMdlSZ7:GetValue('Z7_QUANT')) >= _nQuantSC2	// Se quantidade informada nas ordens com barra, mais o informado no campo, for maior ou igual a ordem de produção
			_cMensagem := 'A quantidade informada mais a quantidade já desmembrada, não pode ser maior ou igual a quantidade da OP.'

			// Se a quantidade da op menos a quantidade já desmembrada for maior que zero
			If (_nQuantSC2 - _nQuantSZ7) > 0
				_cSolucao := 'Informe um quantidade maior ou igual a ' + AllTrim(Str((_nQuantSC2 - _nQuantSZ7 - 1))) + '.'
			Else
				_cSolucao := 'Nâo é mais possivel desmembrar essa ordem de produção.'
			EndIf

			_lValida := .F.
		EndIf

	EndIf

	// Se não foi validado
	If !_lValida
		Help(,,'Help (U_XTT002A)',,_cMensagem,1,0,,,,,.F.,{_cSolucao})
	ElseIf !Empty(_cMensagem)
		MsgAlert(_cMensagem,'Atenção')
	EndIf

	RestArea(_aAreaSH6)
	RestArea(_aAreaSC2)
	RestArea(_aAreaSZ7)
	RestArea(_aArea)

Return _lValida

/*/{Protheus.doc} XTT001A PP001A02
	(Função para realizar a impressão do desmembramento da op)

	XTT001A

Nome Antigo  PP001A02
XTT001A Obs: Nome alterado por  dia 07/01/2010, pois estava com o mesmo nome da rotida de conferecia de NF

	@type User function
	@author Vitor Ribeiro
	@since 22/01/2019

	@param n_RecnoSZ7, numerico, recno da tabelz SZ7

	@return Nil, nulo, não tem retorno.
	/*/
User Function XTT001A(n_RecnoSZ7)

	Local _cMensagem := ''

	Local _oModel := ''

	Default n_RecnoSZ7 := 0

	// Se foi informado o recno
	If !Empty(n_RecnoSZ7)
		// Posiciona no registro
		SZ7->(DbGoTo(n_RecnoSZ7))

		// Se conseguiu posicionar
		If SZ7->(!Eof())
			// Se não foi impresso ainda
			If SZ7->Z7_IMPRESS == '2'
				_cMensagem := 'Essa rotina realizará a impressão do desmembramento da OP [' + SZ7->(Z7_NUMOP+Z7_ITEM+Z7_SEQUEN) + '/' + SZ7->Z7_BARRA + '].' + CRLF
				_cMensagem += 'Após sua impressão, esse desmembramento não poderá ser excluído!' + CRLF + CRLF
				_cMensagem += 'Deseja continuar?'
			Else
				_cMensagem := 'Deseja reimprimir o desmembramento da OP [' + SZ7->(Z7_NUMOP+Z7_ITEM+Z7_SEQUEN) + '/' + SZ7->Z7_BARRA + ']?'
			EndIf

			If MsgNoYes(_cMensagem,'Atenção')
				// Se não foi impresso
				If SZ7->Z7_IMPRESS == '2'
					_oModel := FWLoadModel('DESMEOP')
					_oModel:SetOperation(MODEL_OPERATION_UPDATE)
					_oModel:Activate()
					_oModel:LoadValue('MODEL_SZ7','Z7_IMPRESS','1')

					// Grava alteração
					FwFormCommit(_oModel)
				EndIf
				
				// Realiza a impressão da OP
				_fImpress()
			EndIf
		EndIf

	EndIf

Return Nil

/*/{Protheus.doc} _fImpress
	(Função para realizar a impressão da OP)

	@type User function
	@author Vitor Ribeiro
	@since 22/01/2019

	@return Nil, nulo, não tem retorno.
	/*/
Static Function _fImpress()

	Pergunte("MTR797",.F.)

	MV_PAR01 := SZ7->(Z7_NUMOP+Z7_ITEM)+PadL('1',TamSx3('Z7_SEQUEN')[1],'0')+Space(TamSx3('C2_ITEMGRD')[1])	// Da O.P. ?
	MV_PAR02 := SZ7->(Z7_NUMOP+Z7_ITEM)+Replicate('9',TamSx3('Z7_SEQUEN')[1])+Space(TamSx3('C2_ITEMGRD')[1])	// Ate a O.P. ?
	MV_PAR03 := SToD('20000101')	// Da data ?
	MV_PAR04 := SToD('20491231')	// Ate a data ?
	MV_PAR05 := 1					// Roteiro de Operacoes ? - 1=Sim;2=Nao
	MV_PAR06 := 1					// Imprime Cod. Barras ? - 1=Sim;2=Nao
	MV_PAR07 := 2					// Descricao Produto ? - 1=Descr.Cient.;2=Descr.Generica;3=Pedido Venda;
	MV_PAR08 := 1					// Impr. Op Encerrada ? - 1=Sim;2=Nao
	MV_PAR09 := 2					// Impr. Por Ordem de ? - 1=Codigo;2=Sequencia
	MV_PAR10 := 1					// Considera Ops ? - 1=Fimes;2=Previstas;3=Ambas
	MV_PAR11 := 1					// Item Neg. na Estrut ? - 1=Imprim;2=Nao imprime
	MV_PAR12 := 1					// Imprime Lote/S.Lote ? - 1=Sim;2=Nao
	MV_PAR13 := 1					// Imprime Ordem Inversa? - 1=Sim;2=Nao
	MV_PAR14 := 2					// Considera Usuario Inclusao? - 1=Sim;2=Nao

	// Ordens de Producao
	U_xMTR797X(SZ7->(Recno()))

Return Nil
