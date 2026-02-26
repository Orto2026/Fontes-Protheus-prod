#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ M460MKB  ³ Autor ³ Raphael Proto - Dema   ³ Data ³ 03/10/16 ³±±
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

User Function M460MKB()

Local _cRet := ""

_aArea := GetArea()
_aAreaSC5 := SC5->(GetArea())   


If !(SC5->C5_TIPO $ "DB")
	_cRet := "POSICIONE('SA1',1,xFilial('SA1')+SC9->C9_CLIENTE+SC9->C9_LOJA,'A1_MSBLQL') <> '1'"
Else
	_cRet := "POSICIONE('SA2',1,xFilial('SA2')+SC9->C9_CLIENTE+SC9->C9_LOJA,'A2_MSBLQL') <> '1'"
EndIf

_cRet += ".And. (SC5->C5_CLASPED$'12'.And.Posicione('SB1',1,xFilial('SB1')+SC9->C9_PRODUTO,'B1_XBLOQ') $ '2/ ' .Or. SC5->C5_CLASPED=='4' .And. Posicione('SB1',1,xFilial('SB1')+SC9->C9_PRODUTO,'B1_XBLOQ')#'1/ ' )"

//_cRet += ".And. POSICIONE('SA1',1,xFilial('SA1')+SC9->C9_CLIENTE+SC9->C9_LOJA,'A1_XQUALIF') <> '1'" // Leonardo 17/04/2022
//_cRet += ".And. POSICIONE('SA1',1,xFilial('SA1')+SC9->C9_CLIENTE+SC9->C9_LOJA,'A1_XCLIENT') $ 'OA'" // Leonardo 17/04/2022

RestArea(_aAreaSC5)
RestArea(_aArea)

Return(_cRet)


