#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ M410PVNF ³ Autor ³ Raphael Proto - Dema   ³ Data ³ 03/10/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Ponto de Entrada validar a geracao da Nota Fsical           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Obs       ³ - Deve retornar um condicao em String que sera executada    ³±±
±±³          ³ como macro, se a execucao rerorno .T. continua o Processo   ³±±
±±³          ³ caso contratio não gera a Nota Fiscal                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ EspecIfico para ORTOSINTESE                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M410PVNF()
Local _lRet := .T.

_aArea 		:= GetArea()
_aAreaSC6	:= SC6->(GetArea())
_aAreaSB1	:= SB1->(GetArea())

If !(SC5->C5_TIPO $ "DB")
	If POSICIONE('SA1',1,xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),'A1_MSBLQL') == '1'
		Alert("Cliente Bloqueado, Impossivel Continuar!!!!")
		Return(.F.)
	elseif POSICIONE('SA1',1,xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),'A1_XQUALIF') == '2'
		Alert("Cliente não Qualificado! Verificar com a Qualidade/Assuntos Regulatórios.")
		Return(.F.)
	EndIf
Else
	If POSICIONE('SA2',1,xFilial('SA2')+SC5->(C5_CLIENTE+C5_LOJACLI),'A2_MSBLQL') == '1'
		Alert("Fornecedor Bloqueado, Impossivel Continuar!!!!")
		Return(.F.)
	EndIf
EndIf

dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(SC5->(C5_FILIAL+C5_NUM))
While !Eof() .And. SC5->(C5_FILIAL+C5_NUM) == SC6->(C6_FILIAL+C6_NUM)

	If SC6->C6_QTDENT >= SC6->C6_QTDVEN .Or. !Empty(SC6->C6_BLQ) .Or. !Empty(SC6->C6_NOTA)
		dbSkip()
		Loop
	EndIf

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)

	If (SC5->C5_CLASPED $ '12' .And. SB1->B1_XBLOQ $ '13') .Or. (SC5->C5_CLASPED == '4' .And. SB1->B1_XBLOQ $ '2/3')
		Alert("Produto Bloqueado para o Mercado, Impossivel Continuar!!!!")
		_lRet := .F.
		Exit
	EndIf
	
	dbSelectArea("SC6")
	dbSKip()
EndDo

RestArea(_aAreaSC6)
RestArea(_aAreaSB1)
RestArea(_aArea)

Return(_lRet)



