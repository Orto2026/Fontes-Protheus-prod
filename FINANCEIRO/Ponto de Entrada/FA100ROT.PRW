/*/{Protheus.doc} FA100ROT
//TODO Ponto de Entrada para inclusão de botões customizados na EnchoiceBar
@author Pirolo
@since 02/04/2019
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User function FA100ROT()
Local aRotina := aClone(PARAMIXB[1])//Adiciona Rotina Customizada a EnchoiceBar

//Ao efetuar login no Financeiro este PE é chamado diversas vezes, por este motivo foi add esta proteção.
If IsInCallStack("FINA100")
	//aAdd( aRotina, { '*Ajustar Unid CC' ,'U_ORTF0001("SE5")', 0 , 7 }) 29/06/2023
EndIf

Return aRotina
