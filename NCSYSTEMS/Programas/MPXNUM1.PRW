#INCLUDE "protheus.ch"
#INCLUDE "TOPCONN.CH"

//FÁBIO A. MICHELON - MICROTRUST - 20/09/2014
//OBJETIVO:	EXPORTA E ATUALIZA DADOS DA TABELA DE INTERFACE DO PROTHEUS PARA O NC-SYSTEMS

User Function MPXNUM1(_cOp, _cProduto, _cRoteiro, _nQuant, _dDataIni, _dDataFim, _cAcao)

Local _aArea  	:= 	GetArea()
Local _aArSC2	:=	SC2 -> ( GetArea() )	
Local _aAreaSG2 :=	SG2->(GetArea())
Local _nLotePad, _nHoraInt, _nTempoMin, _nTempoSeg
Local _cNumero, _cItem, _bApaga
Local _cOpIni, _cOpFin
Local _cDescricao	:=	Left(FBuscaCpo( "SB1", 1, xFilial("SB1") + _cProduto, "B1_DESC" ), 45)
Local _nTamDec	:=	TAMSX3("ZWA_PLTMUN")[2]
Local _ix := 0	

If Empty( _cRoteiro )
	_cRoteiro	:=	FBuscaCpo( "SB1", 1, xFilial("SB1") + _cProduto, "B1_OPERPAD" )
	If Empty( _cRoteiro )
		_cRoteiro := "01"
	EndIf
Endif
//
If _cAcao == "3"	//exclusão
	_aOpDep	:=	{}
	If Substr(_cOp, 9, 3) == "001"
		_cOpIni	:=	Substr(_cOp, 1, 8) + "001    "
		_cOpFin	:=	Substr(_cOp, 1, 8) + "ZZZZZZZ"
	Else
		_cOpIni	:=	_cOp + "  "
		_cOpFin	:=	_cOp + "ZZ"
		DbSelectArea( "SC2" )
		DbSetOrder(1)
		DbSeek( xFilial("SC2") + Substr(_cOpIni, 1, 13) )
		While !Eof() .and. (C2_FILIAL+C2_NUM+C2_ITEM == xFilial("SC2")+Substr(_cOpIni, 1, 8))
			If SC2->C2_SEQPAI == Substr(_cOpIni, 9, 3)
				aadd( _aOpDep, {SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD} )
			Endif
			DbSelectArea( "SC2" )
			DbSkip()
		End
	Endif
	DbSelectArea( "ZWA" )
	DbSetOrder(1)
	DbSeek( xFilial("ZWA") + _cOpIni, .T. )
	While !Eof() .and. (ZWA_FILIAL+ZWA_OP+ZWA_OPER <= xFilial("ZWA") + _cOpFin)
		RecLock( "ZWA", .f. )
		ZWA_ACAO	:=	"3"
		MsUnLock()
		DbSelectArea( "ZWA" )
		DbSkip()
	End
	//atualiza op's filhas 
	If Len(_aOpDep) > 0
		For _ix := 1 To Len( _aOpDep )
			_cOpIni	:=	_aOpDep[_ix, 1] + "  "
			_cOpFin	:=	_aOpDep[_ix, 1] + "ZZ"
			DbSelectArea( "ZWA" )
			DbSetOrder(1)
			DbSeek( xFilial("ZWA") + _cOpIni, .T. )
			While !Eof() .and. (ZWA_FILIAL+ZWA_OP+ZWA_OPER <= xFilial("ZWA") + _cOpFin)
				RecLock( "ZWA", .f. )
				ZWA_ACAO	:=	"3"
				MsUnLock()
				DbSelectArea("ZWA")
				DbSkip()
			End
		Next _ix
	Endif
	//---------------------
Else
	//alteração de OP considerando possível modificação de ROTEIRO
	If _cAcao == "2"
		DbSelectArea( "ZWA" )
		DbSetOrder(1)
		DbSeek( xFilial("ZWA") + _cOp, .T. )
		While !Eof() .and. (ZWA_FILIAL+ZWA_OP+ZWA_OPER <= xFilial("ZWA") + _cOp)
			RecLock( "ZWA", .f. )
			ZWA_ACAO	:=	"3"
			MsUnLock()
			DbSelectArea("ZWA")
			DbSkip()
		End
	Endif
	//--------------------------------
	DbSelectArea("SH1")
	DbSetOrder(1)
	DbSelectArea("SG2")
	DbSetOrder(1)
	DbSeek(xFilial("SG2")+_cProduto+_cRoteiro)
	Do While !Eof() .and. (xFilial("SG2")+_cProduto+_cRoteiro == SG2->G2_FILIAL+SG2->G2_PRODUTO+SG2->G2_CODIGO)
		//*** Verifica se o recurso possui integração ativada ***
		DbSelectArea("SH1")
		If (SH1 -> (FieldPos("H1_WZINTEG")) > 0)
			DbSeek(xFilial("SH1")+SG2->G2_RECURSO)
			If Found() .and. (SH1->H1_WZINTEG <> "S")
				DbSelectArea("SG2")
				DbSkip()
				Loop
			Endif
		Endif 
		DbSelectArea("SG2")
		//*** ----------------------------------------------- ***
		_nLotePad  	:= iif(SG2->G2_LOTEPAD==0,1,SG2->G2_LOTEPAD)
		_nTempoSeg 	:= (( (Int(SG2->G2_TEMPAD) * 3600) + (Mod(SG2->G2_TEMPAD, 1) * 100 * 60) ) / _nLotePad)
		//_nTempoSeg 	:= ((SG2->G2_TEMPAD * 3600) / _nLotePad)
		//
		DbSelectArea("ZWA")
		DbSetOrder(1)
		DbSeek( xFilial("ZWA") + _cOp + SG2->G2_OPERAC )
		If Found()	//alteração
			If ZWA->ZWA_ACAO == "3"
				_cAcao	:=	"1"
			Else
				_cAcao	:=	"2"
			Endif
			RecLock("ZWA", .F.)
		Else			//inclusão
			_cAcao	:=	"1"
			RecLock("ZWA", .T.)
		Endif
		ZWA_FILIAL		:= xFilial("ZWA")
		ZWA_OP			:=	_cOp
		ZWA_OPER		:=	SG2->G2_OPERAC
		ZWA_CODPEC		:=	_cProduto
		ZWA_DESCRI		:=	_cDescricao
		ZWA_MAQ		:=	SG2->G2_RECURSO
		ZWA_PLDTIN		:=	_dDataIni
		ZWA_PLDTFI		:=	_dDataFim
		ZWA_PLQTY		:=	_nQuant
		ZWA_CYCQTY		:=	1
		ZWA_PLTMUN		:=	Round(_nTempoSeg, _nTamDec)
		ZWA_PLTMST		:=	Round(SG2->G2_SETUP * 3600, _nTamDec)
		ZWA_ACAO		:=	_cAcao		//1-Inclusão; 2-Alteração; 3-Exclusão
		ZWA_STATUS		:=	"0"			//0-Não Processado; 1-Processado
		MsUnLock()
		DbSelectArea("SG2")
		DbSkip()
	EndDo
Endif
RestArea(_aAreaSG2)
RestArea(_aArSC2)
RestArea(_aArea)

Return
