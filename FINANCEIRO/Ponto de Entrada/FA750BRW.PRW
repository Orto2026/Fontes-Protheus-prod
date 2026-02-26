#INCLUDE "PROTHEUS.CH"
/*/{Protheus.doc} FA750BRW
//TODO P.E. utilizado para adicionar itens no Menu da mBrowse no Contas a Pagar
@author Pirolo
@since 02/04/2019
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function FA750BRW()
Local aRotina := {}

//Ao efetuar login no Financeiro este PE é chamado diversas vezes, por este motivo foi add esta proteção.
If IsInCallStack("FINA750")
	//aAdd( aRotina, { '*Ajustar Unid CC' ,'U_ORTF0001("SE2")', 0 , 7 })//29
	aAdd( aRotina, {"*Carrega Cod.Bar.", "U_RFINA03", 0 , 9})	
EndIf

Return aRotina
