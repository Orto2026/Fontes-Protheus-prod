#include "rwmake.ch"
#include "protheus.ch"

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ Q215TDOK   ¦ Autor ¦ Samuel Miranda    ¦ Data ¦ 08.05.2024 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Ponto de entrea para bloquear a opção de zerar             ¦¦¦
¦¦¦ *          o empenhos da Ordem de Produção                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/ 

User Function Q215TDOK()
    Local aArea := GetArea()
    Local aAreaQPL := QPL->(GetArea())
    Local lRet := .T.
     
    //lRet := MsgYesNo("Deseja continuar?", "Atenção")
     MsgInfo("Aqui!")
    //IF QPL->QPL_APROVA = ‘‘ // ou if empty(PL->QPL_APROVA)
    //    lRet:=.F.
    //ENDIF

    RestArea(aAreaQPL)
    RestArea(aArea)
Return lRet
