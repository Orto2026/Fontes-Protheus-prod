#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Ponto Entr³ ME4_COND ³ Autor ³ Raphael Camillo Proto ³ Data ³ 10/08/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ PE Para Definir a NOVA CONDICAO DE PAGTO DO FATURAMENTO    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico P/ TESTE                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ME4_COND()

Local aRet 		:= {SE4->E4_CODIGO, SE4->E4_COND, SE4->E4_TIPO, SE4->E4_DDD, SE4->E4_IPI, SE4->E4_SOLID}
Local _nValBrut := SF2->F2_VALBRUT
Local _cNewCond	:= ""
Local _aArea	:= GetArea()
Local _aAreaE4	:= SE4->(GetArea())

dbSelectArea("PA5")
dbGotop()
While !Eof() 

	If PA5->PA5_ATIVO == "N"
		dbSkip()
		LOOP
	EndIf
		
	If _nValBrut >= PA5->PA5_VALDE .And. _nValBrut <= PA5->PA5_VALATE
		_cNewCond := PA5->PA5_COND
		EXIT
	EndIf
	
	dbSkip()
EndDo

If !Empty(_cNewCond)
	dbSelectArea("SE4")
	dbSetOrder(1)
	dbSeek(xFilial("SE4")+_cNewCond)
	aRet := {SE4->E4_CODIGO, SE4->E4_COND, SE4->E4_TIPO, SE4->E4_DDD, SE4->E4_IPI, SE4->E4_SOLID}
EndIf

RestArea(_aAreaE4)
RestArea(_aArea)

Return(aRet)
