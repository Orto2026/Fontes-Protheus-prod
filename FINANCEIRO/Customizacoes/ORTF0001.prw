#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} ORTF0001
//TODO Função utilizada para alterar os campos E5_XUNID e E5_CCUSTO.
@author Pirolo
@since 02/04/2019
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function ORTF0001(cTabela)
Local aCmpExib 	:= {}
Local aCmpEdit	:= {}
Local nI		:= 0

If cTabela == "SE5"
	aCmpEdit	:= {"E5_XUNID", "E5_CCC", "E5_CCD", "E5_CCUSTO"}
ElseIf cTabela == "SE2"
	aCmpEdit	:= {"E2_XUNID", "E2_CCC", "E2_CCD", "E2_CCUSTO"}
EndIf

aCmpExib := CarregaCampos(cTabela)

//Se os campos editaveis não forem visiveis, adiciona
For nI := 1 to Len(aCmpEdit)
	If  ASCAN(aCmpExib, { |x| AllTrim(UPPER(x)) == AllTrim(UPPER(aCmpEdit[nI])) }) == 0
		Aadd(aCmpExib, aCmpEdit[nI])
	EndIf
Next nI
	
AxAltera( cTabela, &(cTabela)->(Recno()), 3, aCmpExib, aCmpEdit, , , , , , , , , , .T.)

Return

/*/{Protheus.doc} CarregaCampos
//TODO Pega os campos da tabela informada na SX3 que podem ser exibidos.
@author Pirolo
@since 02/04/2019
@version undefined
@param cTabela, characters, descricao
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function CarregaCampos(cTabela)
Local aRet := {}

DbSelectArea("SX3")
SX3->(DbSetOrder(1))

If SX3->(DbSeek(cTabela))
	While SX3->(!Eof() .AND. X3_ARQUIVO == cTabela)
		If SX3->X3_BROWSE == "S"
			Aadd(aRet, SX3->X3_CAMPO)
		EndIf
		SX3->(DbSkip())
	End
EndIf

Return aRet
