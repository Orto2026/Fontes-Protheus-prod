#Include 'Protheus.ch'
#Include 'RwMake.ch'
#Include 'Totvs.ch'

/*/{Protheus.doc} MA455MNU
	(Ponto de entrada para incluir botão na tela de liberação de estoque.)

	@type User Function
	@author Vitor Ribeiro
	@since 20/02/2019

	@return .T., logico, retorna true
	/*/
User Function MA455MNU()

    Aadd(aRotina,{'Lib Est-Orto','U_OESTA001()',0,1})
	Aadd(aRotina,{'PackList','U_RELPKLIST()',0,1}) //Samuel Miranda 20/08/2020
Return .T.
