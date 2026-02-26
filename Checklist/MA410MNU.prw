

/*/{Protheus.doc} MA410MNU
Função criada para adicionar o fonte imprimir relatório 
no botão Outras açõesna tela de Pedido de Venda
@type Ponto de Entrada Padrão do botão Outras 
ações da tela de Pedido de Venda
@version 12.1.2210 
@author Rodolfo Santos
@since 15/01/2024
/*/
USER FUNCTION MA410MNU()

aadd(aRotina,{'Relatório','u_FATOR01' , 0 , 2,0,NIL})

RETURN Nil
