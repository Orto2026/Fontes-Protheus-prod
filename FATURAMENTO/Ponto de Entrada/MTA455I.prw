#include "rwmake.ch" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³ MTA455I  ³ Autor ³ Raphael Camillo - Dema ³ Data ³ 25.01.14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de entrada da Liberacao de Estoque manual. Esta sendo ³±±
±±³          ³ utilizado p/ gravar Log qdo Liberado Manualmente.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Invocado  ³ Libercao de Estoque - MATA455 - Faturamento                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Ortosintese                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MTA455I() 

_aArea := GetArea()
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O nome do Log sera LBME + Empresa + Filial. Ex: LBME0109   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cNameArq := "LBME"+SM0->M0_CODIGO+SM0->M0_CODFIL

_cAlias := Alias()
dbSelectArea("SX2")
dbSeek("SX5")
dbSelectArea(_cAlias)

_cArqLog  := AllTrim(SX2->X2_PATH)
_cArqLog  := _cArqLog  + If(Substr(_cArqLog,Len(_cArqLog),1) != "\","\","")
_cArqLog  := _cArqLog + Trim(_cNameArq)+".LOG"

nCont := 0
While .t.
  If File(_cArqLog)
     _nHdlLog := FOpen(_cArqLog,2+64)
  Else
     _nHdlLog := MSFCreate(_cArqLog,0)
     Fclose(_nHdlLog)
     _nHdlLog := FOpen(_cArqLog,2+64)
  EndIf
  IF _nHdlLog < 0
     nCont:=nCont+1
     IF nCont > 2
        FINAL("Problemas com arq.LOG Liberacao Estoque Manual")
     Endif
     Inkey(2)
     Loop
  Else
     Exit
  Endif
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravar o arquivo de Log.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FSeek(_nHdlLog,0,2)
_xBuffer := "Data: "+Dtoc(Date())+" - Hora: "+ Time()+" - Usuar:" + Subs(cUsuario,7,15)+" - Ped."+SC6->C6_NUM+" - Prod: "+SC6->C6_PRODUTO+" - Lc: "+SC6->C6_LOCAL+" - Estq.SB2: "+Str(SB2->B2_QATU,13,2)+" - Res: "+Str(SB2->B2_RESERVA,13,2)+" - Qtd Lib Ped: "+Str(SC9->C9_QTDLIB,13,2)
_xBuffer := _xBuffer + CHR(13)+CHR(10)
FWrite(_nHdlLog,_xBuffer,Len(_xBuffer))
*/
_aAreaSC9 := SC9->(GetArea())
                  
dbSelectArea("SC9")
dbSetOrder(1)
dbSeek(SC6->C6_FILIAL+SC6->C6_NUM)

While !Eof() .And. SC6->C6_FILIAL == SC9->C9_FILIAL .And. SC6->C6_NUM == SC9->C9_PEDIDO
RecLock("SC9",.F.)
SC9->C9_XLIBMAN := "S"
SC9->C9_XUSRLIB := cUserName
SC9->C9_XENTREG := Posicione("SC6",1,SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_PRODUTO),"C6_ENTREG")
SC9->C9_CLASPED := Posicione("SC6",1,SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_PRODUTO),"C6_CLASPED")
SC9->C9_XOBSEST := Posicione("SC6",1,SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_PRODUTO),"C6_XOBSEST")
SC9->C9_XEMISSA := Posicione("SC5",1,SC9->(C9_FILIAL+C9_PEDIDO),"C5_EMISSAO")
MsUnlock()
	dbSelectArea("SC9")
	dbSkip()
EndDo

RestArea(_aAreaSC9)
RestArea(_aArea)

Return
