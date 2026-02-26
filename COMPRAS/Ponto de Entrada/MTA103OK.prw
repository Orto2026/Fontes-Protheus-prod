#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MTA103OK บAutor  ณMicrosiga           บ Data ณ  24/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada validacao centro de custo	              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MTA103OK()

Local _aArea	:= GetArea()
Local lRet 		:= .T.

Local nPosTes 	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"})
Local nPosCc  	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_CC"})
Local nPosRat  := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_RATEIO"})
Local I

If cTipo == "N"
	For I := 1 to Len(aCols)
	
		_cTES	:= aCols[I, nPosTes]
		_cCC	:= aCols[I, nPosCc]
		_cRat	:= aCols[I, nPosRat]
	
		If aCols[I,Len(aHeader) + 1 ]
			Loop
		Endif
	
		If Empty(_cCC) .And. Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_DUPLIC") == 'S' .And. _cRat == '2'
			Alert("Favor informar Centro de Custo para o Item "+StrZero(I,4) )
			RestArea(_aArea)
			Return(.F.)
		EndIf
	Next I
EndIf

RestArea(_aArea)

Return(lRet)
