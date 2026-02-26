#include "Protheus.ch"

//FÁBIO A. MICHELON - MICROTRUST - 20/09/2014
//OBJETIVO:	EXPORTA E ATUALIZA DADOS DA TABELA DE INTERFACE DO PROTHEUS PARA O NC-SYSTEMS

User Function MTA650E()

Local _aArea  	:= 	GetArea()
Local _aArSC2	:=	SC2 -> ( GetArea() )	

If SC2->C2_TPOP <> "P"
	MsAguarde({|| u_MPXNUM1( SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD, SC2->C2_PRODUTO, SC2->C2_ROTEIRO, SC2->C2_QUANT, SC2->C2_DATPRI, SC2->C2_DATPRF, "3" ) }, "Atualizando Dados para NC-Systems...")
Endif
RestArea(_aArSC2)
RestArea(_aArea)

Return .T.
