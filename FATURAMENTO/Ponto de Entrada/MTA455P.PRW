#include "rwmake.ch"
/*/{Protheus.doc} MTA455P
//TODO 	VALIDA LIBERACAO DE ESTOQUE - Executado apos liberacao do estoque, e impede a liberacao dependendo do retorno.
 		Valida se existe uma ordem de separação, se existir não permite a liberação.
@author Pirolo
@since 13/08/2019
@return lRet, Variavel logica, sendo: .T. Libera o item normalmente - .F. Impede a liberacao do item
@see http://tdn.totvs.com/pages/releaseview.action?pageId=6784411
/*/
User Function MTA455P()

Local lRet := .T.
Local aAreaCB8 := CB8->(GetArea())

//Abre a tabela de Itens da Ordem de Separação
DbSelectArea("CB8")
CB8->(DbSetOrder(2)) //CB8_FILIAL+CB8_PEDIDO+CB8_ITEM+CB8_SEQUEN+CB8_PROD
	If !RetCodUsr() $ SuperGetMv("MV_XUSRLIB")
		//Pesquisa na tabela Ordem de Separaçao
		lRet := !CB8->(DbSeek(SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO)))
		
		If !lRet
			MsgInfo ( "Pedido possui ordem de separação, não é possivel efetuar uma nova liberação.", "Ordem de Separação" )
		EndIf
		
   EndIf
RestArea(aAreaCB8)
Return lRet
