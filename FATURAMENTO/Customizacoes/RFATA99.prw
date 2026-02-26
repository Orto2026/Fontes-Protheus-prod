#INCLUDE "rwmake.ch"


User Function RFATA99()

Local _cRet 	:= " "
Local _cQuery 	:= ""                       
Local _aArea	:= GetArea()
_cProduto		:= SZ2->Z2_PRODUTO

_cQuery := " SELECT MAX(Z2_REVDESE) AS RET "
_cQuery += " FROM "+RetSqlName("SZ2")+" SZ2 "
_cQuery += " WHERE Z2_FILIAL = '"+xFilial("SZ2")+"' AND Z2_PRODUTO = '"+_cProduto+"' " 
_cQuery += " AND D_E_L_E_T_ = ' ' "

_cQuery := ChangeQuery( _cQuery )

If Select("TRB1") <> 0                                                                             
  dbSelectArea("TRB1")
  dbCloseArea()
EndIf
	
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),'TRB1',.F.,.F.)
	
dbSelectArea('TRB1')
dbGoTop()
While !Eof()
	_cRet := Soma1(TRB1->RET,Len(SZ2->Z2_REVDESE))
	dbSkip()
EndDo
dbCloseArea()

RestArea(_aArea)
Return(_cRet)