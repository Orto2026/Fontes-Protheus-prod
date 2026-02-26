#include "protheus.ch"

 

USER FUNCTION mBrwSX5()

 

LOCAL cAlias := "SX5"

 

PRIVATE cCadastro := "Cadastro de Servicos"

PRIVATE aRotina     := { }

 

AADD(aRotina, { "Pesquisar"		, "AxPesqui", 0, 1 })

AADD(aRotina, { "Visualizar"	, "AxVisual"  , 0, 2 })

AADD(aRotina, { "Incluir"      	, "AxInclui"   , 0, 3 })

AADD(aRotina, { "Alterar"     	, "AxAltera"  , 0, 4 })

AADD(aRotina, { "Excluir"     	, "AxDeleta" , 0, 5 })

 

dbSelectArea(cAlias)

dbSetOrder(1)

SET FILTER TO X5_TABELA = '60'

mBrowse(6, 1, 22, 75, cAlias)  

RETURN NIL