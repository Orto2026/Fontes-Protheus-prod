#Include "Protheus.ch"
#Include "RwMake.ch"

/*/{Protheus.doc} A650OPI
	(Ponto de entrada para verifica necessidade de geração da OP)

	@type User Function
	@author Vitor Ribeiro
	@since 02/01/2019

	@return _lGera, logico, se gera op filho ou não.

    @obs 
        PARAMIXB -> contém a linha do acols

        Link do tdn:
        https://tdn.totvs.com/pages/releaseview.action?pageId=287058438        
	/*/
User Function A650OPI()

    Local _aArea := GetArea()
    Local _aAreaSB1 := SB1->(GetArea())

    Local _nLinha := PARAMIXB

    Local _cProduto := aCols[_nLinha][1]
    Local _cTipProd := GetMv("MV_XTPPROD",,"PI")

    Local _lGera := .T.

    DbSelectArea("SB1")     // DESCRIÇÃO GENÉRICA DO PRODUTO
    SB1->(DbSetOrder(1))    // B1_FILIAL+B1_COD

    // Encontra o produto
    If SB1->(DbSeek(xFilial("SB1")+_cProduto))
        // Verifica se o tipo do produto está no parâmetro
        If AllTrim(RetFldProd(SB1->B1_COD,"B1_TIPO")) $ _cTipProd
            _lGera := .T.
        Else
            _lGera := .F.
        EndIF
    EndIf

    RestArea(_aAreaSB1)
    RestArea(_aArea)

Return _lGera