
#INCLUDE "PROTHEUS.CH"
#INCLUDE "PRTOPDEF.CH"
#INCLUDE "PRTOPDEF.CH"

User Function ACD100M()
//Customização do usuário...

  aadd(aRotina,{'Gerar Ord. Sep.','U_ACD01ORTO' , 0 , 2,0,NIL})
 // Adiciona a opção "Minha Opção" ao menu "Outras Ações"

Return .T. // Permite a exibição da tela de manutenção
/*
Static Function MinhaFuncao()

    // Implemente aqui a lógica da sua função personalizada
  

Return
