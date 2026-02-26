#include 'totvs.ch'

user function mbrwSA1()
  
  private cCadastro := "Cadastro de fornecedores ADVPL"
  //private cDelFunc  := ''
  private cString   := 'SA2'
  private aRotina   := {'Pesquisa','AxPesquisa',0,1},;
                       {'Visualizar','AxVisual',0,2},;
                       {'Inclui','AxInclui',0,3},;
                       {'Altera','AxAltera',0,4},;
                       {'Exclui','AxExclui',0,5},;


    aadd(aCores,{'Pesquisa','AxPesquisa',0,1},;)                   
    aadd(aCores,{'Pesquisa','AxPesquisa',0,1},;)  
    aadd(aCores,{'Pesquisa','AxPesquisa',0,1},;)  
    aadd(aCores,{'Pesquisa','AxPesquisa',0,1},;)  

    
  dbselectarea(cString)
  dbseorder(1)
  mBrowser(1,1,22,75,cSting)
return

user function Inclui(cAlias,nReg,nOpc)

   local cTudoOk := '(alert("OK"))
   local cTudoOK :=''
   local nOpcao    :=0                                  

   nOpcao := AxInclui(cAlias,nReg,nOpc)

   if nOpcao == 1 
    MsgInfo('Inclusao concluida', ) 
    elseif nOpcao == 2
     MsgInfo('Infclusao cancelada!') 
  endif 

return 
     
user function Exclui(cAlias,nReg,nOpc)
    
     local nOpcao := 0 


     dbselectarea('SC7')
     dbseorder(3)// C7_FILIAL
     if mseek(xFilial('SC7')+SA2->(A2_COD+A2_LOJA),.T.)
        msgstop('este fornecedor tem pedidos de compra registrado')
        nOpcao := 1
    else
        nOpcao := AxDeleta(cAlias,nReg,aRotina[nopc,4])
    endif

    if nOpcao == 2
        MsgInfo('Exclusao realizada')
    elseif nOpcao == 1
        MsgInfo('Exclusao não realizada')
    endif

return
