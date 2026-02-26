#include "totvs.ch"


User /*/{Protheus.doc} AXCADSA1
    (long_description)
    @type  Function
    @author user
    @since 27/08/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xCadSa1()

     Local cVlAlt := 'U_VLDALT(M->A1_CGC,nOpc)'
     local cVldExc:= 'U_VLDEXC'

    private cString:='SA1'

    dbselectarea(cString)
    dbselectorder(1)    //A1_FILIAL+A1_COD+A1_LOJA, o certo a se fazer

    aXCadastro(cString,"Cadastro de Cliente ADVPL",/*cVldExc*/,cVlAlt)
return()

User Function cVlAlt(cCNPJ,nOpc)
  
  local lRet := .T. //TRUE
  local aArea:=  getarea()

  default cCNPJ := ''
  default nOpc  := 1 



  if nOpc == 4 //opçao de alteração 
       if empty(alltrim(cCNPJ)) // verifica se o CNPJ/CPF esta em branco.
         MsgInfo (' Não possivel alteração no formulario pois o campo CNPJ/CPF esta em branco')
         lRet := .F.
  endif

 restarea(aArea)

 
return(lRet)


User Function cVldExc()
  
  local lRet := .T. //TRUE
  local aArea:=  getarea()

  
  default nOpc  := 1 

  dbselectarea('SC5')
  dbselectorder(3)//C5_FILIAL+C5_CLIENTES+C5_LOJACLI+C5_NUM
  

  if msseek(xFilial('SC5')+SA1->A1_COD+A1_LOJA, .T.)
       
         MsgInfo (' Não possivel excluir cadastro pois existem pedidos de venda para esse cliente')
         lRet := .F.
  endif

 restarea(aArea)

 
return(lRet)
