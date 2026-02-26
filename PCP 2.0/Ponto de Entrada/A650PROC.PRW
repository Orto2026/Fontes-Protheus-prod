#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A650PROC ºAutor  ³Raphael Camillo-Demaº Data ³  11/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para replicar o numero do Lote da OP Pai  º±±
±±º          ³ nas Filhas e para trazer tambem a descricao do produto     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ortosintese                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A650PROC()
Local _aArea  	:= GetArea()
Local _aAreaC2	:= SC2->(GetArea())
Local _aAreaPK	:= QPK->(GetArea())
Local _cOP	    := SC2->C2_NUM
//Local _cRoTro   := ""

dbSelectArea("QPK")
dbSetOrder(1)

DbSelectArea("SC2")
DbSetOrder(1)
DbSeek(xFilial("SC2")+_cOP)

While !Eof() .And. _cOP == SC2->C2_NUM
	_cLote  := SC2->C2_LOTECTL
	//_nRoteiro	:= Alltrim(SC2->C2_ROTEIRO) //Por samuel
	dbSelectArea("QPK")
	If dbSeek(SC2->C2_FILIAL+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
		RecLock("QPK",.F.)
		QPK->QPK_LOTE := _cLote
		//QPK->QPK_XROTE := _nRoteiro
		MsUnlock()
	EndIf
	dbSelectArea("SC2")
	dbSkip()
EndDo

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//Incluido - Por Samuel Miranda 29/04/2024 - Para replicar o Roteiro de Produção.
//Chama a função para para replicar o roteiro de produção
GRVROTER(_cOP) //Grava o Roteiro
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//


RestArea(_aAreaC2)
RestArea(_aAreaPK)
RestArea(_aArea)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Função    | GRVROTER  | Autor  | Samuel Miranda	   | Data | 29/04/2024|±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Desc.     | Replica o Roteiro da Ordem Pai pára as Ordens Filhas		  |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Paramentros : _cOP (Numero da Ordem de Produção)                       |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function GRVROTER(_cOP)
//Variaveis
Local _aArea  	:= GetArea()
Local _aAreaC2	:= SC2->(GetArea())
Local _aAreaB1	:= SB1->(GetArea())
Local _nOP 		:= Alltrim(_cOP) //Número da Ordem de Produção
Local _nLote 	:= ""

	//Seta o Alias 
	DbSelectArea("SC2")
	DbSetOrder(1)
	DbSeek(xFilial("SC2")+_nOP)//Posiciona na Ordem de Produção
	
	DbSelectArea("SB1")
	DbSetOrder(1)

	_nLote  	:= SC2->C2_LOTECTL // Número do lote da OP Pai
	//_nRoteiro	:= Alltrim(SC2->C2_ROTEIRO) //Número do Roteiro da OP Pai
	//Entra no laço e replica o codigo do roteiro nas ordens de produção
	While !Eof() .And. _cOP == SC2->C2_NUM .And. _nLote == SC2->C2_LOTECTL
		// Posiciona SB1 para referencia de validação de produto bloqueado.
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
		_nRoteiro := SB1->B1_OPERPAD
		//Posiciona na OP
		If dbSeek(SC2->C2_FILIAL+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
			RecLock("SC2",.F.)
				SC2->C2_ROTEIRO := _nRoteiro //Seta o codigo do Roteiro
			MsUnlock()
		EndIf
		dbSelectArea("SC2")
		dbSkip()
	EndDo

RestArea(_aAreaC2)
RestArea(_aAreaB1)
RestArea(_aArea)
Return()
