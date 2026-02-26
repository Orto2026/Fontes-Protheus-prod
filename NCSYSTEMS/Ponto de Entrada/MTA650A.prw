#INCLUDE "Protheus.ch"

//FÁBIO A. MICHELON - MICROTRUST - 20/09/2014
//OBJETIVO:	EXPORTA E ATUALIZA DADOS DA TABELA DE INTERFACE DO PROTHEUS PARA O NC-SYSTEMS

User Function MTA650A()

Local _aArea  	:= 	GetArea()
Local _aArSC2	:=	SC2 -> ( GetArea() )	
Local _cNum	:=	SC2->C2_NUM
Local _cItem	:=	SC2->C2_ITEM
Local cEmpAut	:= 	SC2->C2_XGEREMP

If SC2->C2_TPOP <> "P"	//ordens previstas
	MsAguarde({|| u_MPXNUM1( SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD, SC2->C2_PRODUTO, SC2->C2_ROTEIRO, SC2->C2_QUANT, SC2->C2_DATPRI, SC2->C2_DATPRF, "2" ) }, "Atualizando Dados para NC-Systems...")
	DbSelectArea( "SC2" )
	DbSetOrder(1)
	DbSeek( xFilial("SC2") + _cNum + _cItem, .T. )
	
	cEmpAut	:= 	SC2->C2_XGEREMP
	
	While !Eof() .and. (C2_FILIAL+C2_NUM+C2_ITEM == xFilial("SC2")+_cNum +_cItem)
		MsAguarde({|| u_MPXNUM1( SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD, SC2->C2_PRODUTO, SC2->C2_ROTEIRO, SC2->C2_QUANT, SC2->C2_DATPRI, SC2->C2_DATPRF, "2" ) }, "Atualizando Dados para Numericon...")
		
		RecLock("SC2", .F.)
			C2_XGEREMP := cEmpAut
		SC2->(MsUnlock())
		
		DbSelectArea( "SC2" )
		DbSkip()
	End
Endif
RestArea(_aArSC2)
RestArea(_aArea)

Return
