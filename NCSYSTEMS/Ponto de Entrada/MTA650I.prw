#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA650I   ºAutor  ³Emerson Natali      º Data ³  10/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para replicar o numero do Lote da OP Pai  º±±
±±º          ³ nas Filhas e para trazer tambem a descricao do produto     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ortosintese                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA650I()

Local _aArSC2	:= SC2->(GetArea())
Local _aAreaB1	:= SB1->(GetArea())
Local _cAlmox	:= SC2->C2_LOCAL
Local cEmpAut	:= SC2->C2_XGEREMP
Local _dDatPrf := SToD("")

_aArea  := GetArea()
_lFound := .F.
_cRecno := Recno()
_xDesc  := ""
_cLote  := ""

DbSelectArea("SB1")
DbSetOrder(1)
If DbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
	_xDesc  := SB1->B1_DESC
EndIf

If SC2->C2_LOCAL != "96"
	DbSelectArea("SC2")
	DbSetOrder(1)
	If DbSeek(xFilial("SC2")+SC2->C2_NUM+SC2->C2_ITEM+"001")
		_dDatPrf := SC2->C2_DATPRF
		If !(AllTrim(SC2->C2_LOCAL) $ "11/12") //.Or. SB1->B1_TIPO == 'PI'          // MAURICIO - ALTERADO PARA ATENDER A FABRICA DE EQUIPAMENTO.  TEM QUE GERAR LOTE QUANDO TROCA A SEQUENCIA
			_cLote  := SC2->C2_LOTECTL
		EndIf
		
		//Pirolo - Replica o campo indicador de empenho automatico.
		cEmpAut := SC2->C2_XGEREMP
		_lFound := .T.
	EndIf
EndIf

If SC2->C2_SEQUEN <> "001"  .AND. SC2->C2_LOCAL == "96"
	DbSelectArea("SC2")
	DbSetOrder(1)
	If DbSeek(xFilial("SC2")+SC2->C2_NUM+SC2->C2_ITEM+"001")
		_dDatPrf := SC2->C2_DATPRF
		_cLote  := SC2->C2_LOTECTL
		
		//Pirolo - Replica o campo indicador de empenho automatico.
		cEmpAut := SC2->C2_XGEREMP
	EndIf
	_lFound := .T.
EndIf

If SC2->C2_SEQUEN == "001"  .AND. SC2->C2_LOCAL == "11"
	_dDatPrf := SC2->C2_DATPRF
	_cLote  := SC2->C2_LOTECTL
EndIf

If Empty(_cLote)
	_cLote := U_fGetLot(2,SC2->C2_PRODUTO)
EndIf

RestArea(_aArea)
DbGoto(_cRecno)

If _lFound
	RecLock("SC2",.F.)
	SC2->C2_DATPRF := _dDatPrf
	SC2->C2_LOTECTL := _cLote
	SC2->C2_XDESC   := _xDesc
	SC2->C2_XUSUARI := cUserName 			// MAURICIO 17/07/2018 CHAMADO #  625
	SC2->C2_XGEREMP	:= cEmpAut
	MsUnLock()
EndIf
//
//Microtrust - 24/05/2016
//Objetivo: Atualizar tabela de integração (interface) com o sistema NC-MES
RestArea(_aArea)
If SC2->C2_TPOP <> "P"	//ordens previstas
	MsAguarde({|| u_MPXNUM1( SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD, SC2->C2_PRODUTO, SC2->C2_ROTEIRO, SC2->C2_QUANT, SC2->C2_DATPRI, SC2->C2_DATPRF, "1" ) }, "Atualizando Dados para NC-Systems...")
Endif
RestArea(_aArSC2)
RestArea(_aAreaB1)
RestArea(_aArea)
//---------------------------------------------------------------------------

Return
