#include "rwmake.ch"
#include "Protheus.ch" 

User Function BACASC6()

_cPedido := "099778" // INFORMA O NUMERO DO PEDIDO AQUI
_cItem := "01"

dbSelectArea("SC6")
dbSetOrder(0)

Set Filter to C6_NUM == _cPedido

dbGotop()
While !Eof() .And. SC6->C6_NUM == _cPedido
RecLock("SC6",.F.)
SC6->C6_ITEM := _cItem
MsUnlock()
_cItem := Soma1(_cItem,2)
dbSkip()
EndDo

dbSelectArea("SC6")
Set Filter To
dbSetOrder(1)

Return
