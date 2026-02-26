#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA410T   ºAutor  ³DEMA                º Data ³  16/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada a Apos a Gravacao do Pedido de Vendas     º±±
±±º          ³ Grava os Dados do Pedido de Vendas para a geracao de Relat.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 - Especifico ORTOSINTESE                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA410T()
aArea := GetArea()

_aAreaC6 := SC6->(GetArea())
_aAreaDC := SDC->(GetArea())
_aAreaC2 := SC2->(GetArea())

If AllTrim(FUNNAME())=="MATA410"  .And. (Inclui .Or. Altera) .And. !(SC5->C5_TIPO $ "D/B")
	U_XANACRITPD()
EndIf

_aAreaSC9 := GetArea("SC9")
dbSelectArea("SC9")
dbSetOrder(1)
dbSeek(SC5->C5_FILIAL+SC5->C5_NUM)
While !Eof() .And. SC5->C5_FILIAL == SC9->C9_FILIAL .And. SC5->C5_NUM == SC9->C9_PEDIDO
	RecLock("SC9",.F.)
	SC9->C9_XENTREG := Posicione("SC6",1,SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_PRODUTO),"C6_ENTREG")
	SC9->C9_CLASPED := Posicione("SC6",1,SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_PRODUTO),"C6_CLASPED")
	SC9->C9_XOBSEST := Posicione("SC6",1,SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_PRODUTO),"C6_XOBSEST")
	SC9->C9_XEMISSA := Posicione("SC5",1,SC9->(C9_FILIAL+C9_PEDIDO),"C5_EMISSAO")
	//MsgAlert("MTA410T")
	MsUnlock()
	dbSelectArea("SC9")
	dbSkip()
EndDo

// RETIRADO A PEDIDO DE UBIRATAN/LEONARDO
/*
If SC5->C5_VEND1 != ""
	RecLock("SC5",.F.)
	_nComis1 := 0
	_nComis1 := Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_COMIS")
	SC5->C5_COMIS1 :=  _nComis1
	MsUnlock()
EndIf

If SC5->C5_VEND2 != ""
	RecLock("SC5",.F.)
	_nComis2 := 0
	_nComis2 := Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_COMIS")
	SC5->C5_COMIS2 :=  _nComis2
	MsUnlock()
EndIf

If SC5->C5_VEND3 != ""
	RecLock("SC5",.F.)
	_nComis3 := 0
	_nComis3 := Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND3,"A3_COMIS")
	SC5->C5_COMIS3 :=  _nComis3
	MsUnlock()
EndIf

If SC5->C5_VEND4 != ""
	RecLock("SC5",.F.)
	_nComis4 := 0
	_nComis4 := Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND4,"A3_COMIS")
	SC5->C5_COMIS4 :=  _nComis4
	MsUnlock()
EndIf

If SC5->C5_VEND5 != ""
	RecLock("SC5",.F.)
	_nComis5 := 0
	_nComis5 := Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND5,"A3_COMIS")
	SC5->C5_COMIS5 :=  _nComis5
	MsUnlock()
EndIf
*/

If AllTrim(SC5->C5_TIPO) == "B"
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(SC5->(C5_FILIAL+C5_NUM))
	While !Eof() .And. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)

		RecLock("SC6",.F.)
		dbSelectArea("SDC")
		dbSelectArea(1) // DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI
		If dbSeek(SC6->(C6_FILIAL+C6_PRODUTO+C6_LOCAL+"SC2"+C6_NUM)) 
			dbSelectArea("SC2")
			dbSetOrder(1)
			dbSeek(SC6->C6_FILIAL+SDC->DC_OP)
			If !(AllTrim(SC2->SC2_LOTECTL) $ SC6->C6_XDESCRI)
				SC6->C6_XDESCRI :=  AllTrim(SC6->C6_XDESCRI)+" - LT: "+SC2->SC2_LOTECTL
			EndIf
			
			If !(SDC->DC_OP $ SC6->C6_XDESCRI)
				SC6->C6_XDESCRI :=  AllTrim(SC6->C6_XDESCRI)+" - OP: "+SDC->DC_OP
			EndIf
		EndIf

		dbSelectArea("SC6")
		MsUnlock()

		dbSkip()
	EndDo
EndIf

//  RETIRADO A PEDIDO DE LEONARDO/GISELI/CRISTINA
/*     
If AllTrim(SC5->C5_TIPO) == "N"
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(SC5->(C5_FILIAL+C5_NUM))
	While !Eof() .And. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)

		RecLock("SC6",.F.)
		SC6->C6_ENTREG :=  U_XCALCDATA(SC6->C6_PRODUTO,SC5->C5_EMISSAO)
		

		dbSelectArea("SC6")
		MsUnlock()

		dbSkip()
	EndDo
EndIf
*/    
/*
If AllTrim(SC5->C5_TIPO) == "N"
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(SC5->(C5_FILIAL+C5_NUM))
	
	If Empty(SC6->C6_XLIBPED) 
	
	While !Eof() .And. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)

		RecLock("SC6",.F.)
		SC6->C6_XLIBPED :=  DDATABASE
		

		dbSelectArea("SC6")
		MsUnlock()

		dbSkip()
	EndDo
	End
EndIf
 */
// A PEDIDO DE NARDY E KALIANE PARA GRAVAR TIPO DO PEDIDO CORRETO NO ITENS - MAURICIO 10/12/2020
 If AllTrim(SC5->C5_TIPO) == "N"
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(SC5->(C5_FILIAL+C5_NUM))
	
	
	While !Eof() .And. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)

		RecLock("SC6",.F.)
		SC6->C6_CLASPED :=  SC5->C5_CLASPED
		
		dbSelectArea("SC6")
		MsUnlock()

		dbSkip()
	EndDo
	
EndIf

RestArea(_aAreaC6)
RestArea(_aAreaDC)
RestArea(_aAreaC2)
RestArea(_aAreaSC9)
RestArea(aArea)

Return()
