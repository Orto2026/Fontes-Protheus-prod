#INCLUDE 'TOTVS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE "RWMAKE.CH"
 
User Function MTA650POK()
Local cAlias := PARAMIXB[1]
Local cMarca := PARAMIXB[2]
Local aArea  := (cAlias)->(GetArea()) //Guarda a area corrente
 
MsgInfo('Este Ponto de Entrada será executado antes da geração das OPs e PVs !!!')
 
dbSelectArea(cAlias)
(cAlias)->(dbSetOrder(1))
If (cAlias)->(dbSeek(xFilial(cAlias)))
    While !Eof() .And. SC6->C6_FILIAL == xFilial(cAlias)
        If SC6->C6_OK = cMarca
            MsgInfo('O Item '+SC6->C6_ITEM+' do pedido de Vendas ' +SC6->C6_NUM+ ' foi marcado para gerar Ordem de Produção!!!')
        EndIf
        (cAlias)->(dbSkip())
    EndDo
EndIf
(cAlias)->(dbCloseArea())
 
RestArea(aArea) //Restaura a area guardada
Return( .T. )
