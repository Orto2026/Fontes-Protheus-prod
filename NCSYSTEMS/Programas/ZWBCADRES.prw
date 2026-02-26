#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function ZWBCADRES(_cFilial, _cOrdem, _cOper)

Local	_aArea		:=	GetArea()
//
Private	_aButtons	:=	{}
Private	_oDlg		:=	nil
Private	_oFolder	:=	nil
Private	aSize, aInfo, aPosObj
Private	aObjects	:=	{}
Private	cCadastro	:=	"Resumo da Ordem de Produção"
Private	_aHeadSH6	:=	{}
Private	_aColsSH6	:=	{}
Private	_aHeadZWB	:=	{}
Private	_aColsZWB	:=	{}
Private	_aHeadZWC	:=	{}
Private	_aColsZWC	:=	{}
Private	_aHeadSD3	:=	{}
Private	_aColsSD3	:=	{}
Private	_aCols	:=	{}
//
aadd( _aButtons, { "S4WB005N",	{ || u_ZWBCADRX(_cFilial, _cOrdem, "") },		"Todas Operações", "Todas Operações" } )
aadd( _aButtons, { "S4WB004N",	{ || u_ZWBCADRX(_cFilial, _cOrdem, _cOper) },	"Por Operação", "Por Operação" } )
//
//Busca o cabeçalho dos Apontametos Protheus (SH6)
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SH6")
While !Eof() .and. (X3_ARQUIVO == "SH6")
	If X3Uso(SX3->X3_USADO) .And. (cNivel >= SX3->X3_NIVEL)
		Aadd(_aHeadSH6, {AllTrim(X3Titulo()), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX, SX3->X3_RELACAO, ".T."})		
	EndIf		
	DbSelectArea("SX3")
	DbSkip()
End
//
//Busca o cabeçalho dos Apontametos NC-MES (ZWB)
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("ZWB")
While !Eof() .and. (X3_ARQUIVO == "ZWB")
	If X3Uso(SX3->X3_USADO) .And. (cNivel >= SX3->X3_NIVEL)
		Aadd(_aHeadZWB, {AllTrim(X3Titulo()), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX, SX3->X3_RELACAO, ".T."})		
	EndIf		
	DbSelectArea("SX3")
	DbSkip()
End
//
//Busca o cabeçalho das Requisições/Produções (SD3)
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SD3")
While !Eof() .and. (X3_ARQUIVO == "SD3")
	If X3Uso(SX3->X3_USADO) .And. (cNivel >= SX3->X3_NIVEL)
		Aadd(_aHeadSD3, {AllTrim(X3Titulo()), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX, SX3->X3_RELACAO, ".T."})		
	EndIf		
	DbSelectArea("SX3")
	DbSkip()
End
//
//
//Busca o cabeçalho dos Eventos NC-MES (ZWC)
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("ZWC")
While !Eof() .and. (X3_ARQUIVO == "ZWC")
	If X3Uso(SX3->X3_USADO) .And. (cNivel >= SX3->X3_NIVEL)
		Aadd(_aHeadZWC, {AllTrim(X3Titulo()), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX, SX3->X3_RELACAO, ".T."})		
	EndIf		
	DbSelectArea("SX3")
	DbSkip()
End
//
//Busca as dimensões da tela
aSize := MsAdvSize()
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
aPosObj 	:= MsObjSize( aInfo, aObjects,.T.)
//
DbSelectArea("SC2")
DbSetOrder(1)
DbSeek(_cFilial+_cOrdem)
If Found()
	_aColsSH6	:=	_SH6Dados(_cFilial, _cOrdem, _cOper)
	_aColsZWB	:=	_ZWBDados(_cFilial, _cOrdem, _cOper)
	_aColsSD3	:=	_SD3Dados(_cFilial, _cOrdem, _cOper)
	_aColsZWC	:=	_ZWCDados(_cFilial, _cOrdem, _cOper)
	DEFINE MSDIALOG _oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] of oMainWnd PIXEL
	EnChoice( "SC2",, 2,,,,,aPosObj[1],, 3,,,,,,.F. )
	@ aPosObj[2,1], aPosObj[2,2] FOLDER _oFolder SIZE aPosObj[2,4], aPosObj[2,3]-5 ITEMS "APONTAMENTOS PROTHEUS (SH6)", "APONTAMENTOS NC-MES (ZWB)", "REQUISIÇÕES/PRODUÇÕES (SD3)", "EVENTOS" of _oDlg pixel
	_oGetsh6 := MsNewGetDados():New(0, 0, aPosObj[2,3]-aPosObj[2,1]-10, aPosObj[2,4]-5, 0,,,,,, 999,,,, _oFolder:aDialogs[1], _aHeadSH6, _aColsSH6)
	_oGetzwb := MsNewGetDados():New(0, 0, aPosObj[2,3]-aPosObj[2,1]-10, aPosObj[2,4]-5, 0,,,,,, 999,,,, _oFolder:aDialogs[2], _aHeadZWB, _aColsZWB)
	_oGetsd3 := MsNewGetDados():New(0, 0, aPosObj[2,3]-aPosObj[2,1]-10, aPosObj[2,4]-5, 0,,,,,, 999,,,, _oFolder:aDialogs[3], _aHeadSD3, _aColsSD3)
	_oGetzwc := MsNewGetDados():New(0, 0, aPosObj[2,3]-aPosObj[2,1]-10, aPosObj[2,4]-5, 0,,,,,, 999,,,, _oFolder:aDialogs[4], _aHeadZWC, _aColsZWC)
	ACTIVATE MSDIALOG _oDlg ON INIT (EnchoiceBar(_oDlg, {||_oDlg:End()}, {||_oDlg:End()},, _aButtons)) CENTERED
Endif
RestArea(_aArea)

Return
//
Static Function _SH6Dados(_cFilial, _cOrdem, _cOper)
Local nX
Local	_aArea	:=	GetArea()

_aColsSH6	:=	{}
DbSelectArea("SH6")
DbSetOrder(1)
DbSeek(_cFilial+_cOrdem)
While !Eof() .and. (H6_FILIAL+H6_OP == _cFilial+_cOrdem)
	If !Empty(_cOper) .and. (SH6->H6_OPERAC <> _cOper)
		DbSelectArea("SH6")
		DbSkip()
		Loop
	Endif
	Aadd(_aColsSH6, Array(Len(_aHeadSH6) + 1))
	For nX := 1 To Len(_aHeadSH6)
		If _aHeadSH6[nX, 10] <>  "V"
			_aColsSH6[Len(_aColsSH6), nX] := SH6->( FieldGet(FieldPos(_aHeadSH6[nX, 2])) )
		Else
			_aColsSH6[Len(_aColsSH6), nX] := IIf(_aHeadSH6[nX, 8] == "N", 0, "")
		Endif 	
	Next nX
	_aColsSH6[Len(_aColsSH6), Len(_aHeadSH6) + 1]	:= .F.
	DbSelectArea("SH6")
	DbSkip()
End
If Len(_aColsSH6) <= 0
	Aadd(_aColsSH6, Array(Len(_aHeadSH6) + 1))
	For nX := 1 To Len(_aHeadSH6)
		_aColsSH6[Len(_aColsSH6), nX] := IIf(_aHeadSH6[nX, 8] == "N", 0, "")
	Next nX
	_aColsSH6[Len(_aColsSH6), Len(_aHeadSH6) + 1]	:= .F.
Endif
RestArea(_aArea)

Return _aColsSH6
//
Static Function _ZWBDados(_cFilial, _cOrdem, _cOper)

Local	_aArea	:=	GetArea()
Local nX

_aColsZWB	:=	{}
DbSelectArea("ZWB")
DbSetOrder(1)
DbSeek(_cFilial+_cOrdem)
While !Eof() .and. (ZWB_FILIAL+ZWB_OP == _cFilial+_cOrdem)
	If !Empty(_cOper) .and. (ZWB->ZWB_OPER <> _cOper)
		DbSelectArea("ZWB")
		DbSkip()
		Loop
	Endif
	Aadd(_aColsZWB, Array(Len(_aHeadZWB) + 1))
	For nX := 1 To Len(_aHeadZWB)
		If _aHeadZWB[nX, 10] <>  "V"
			_aColsZWB[Len(_aColsZWB), nX] := ZWB->( FieldGet(FieldPos(_aHeadZWB[nX, 2])) )
		Else
			_aColsZWB[Len(_aColsZWB), nX] := IIf(_aHeadZWB[nX, 8] == "N", 0, "")
		Endif 	
	Next nX
	_aColsZWB[Len(_aColsZWB), Len(_aHeadZWB) + 1]	:= .F.
	DbSelectArea("ZWB")
	DbSkip()
End
If Len(_aColsZWB) <= 0
	Aadd(_aColsZWB, Array(Len(_aHeadZWB) + 1))
	For nX := 1 To Len(_aHeadZWB)
		_aColsZWB[Len(_aColsZWB), nX] := IIf(_aHeadZWB[nX, 8] == "N", 0, "")
	Next nX
	_aColsZWB[Len(_aColsZWB), Len(_aHeadZWB) + 1]	:= .F.
Endif
RestArea(_aArea)

Return _aColsZWB
//
Static Function _SD3Dados(_cFilial, _cOrdem, _cOper)

Local	_aArea	:=	GetArea()
Local	_cQuery	:=	""
Local nX := 0

_aColsSD3	:=	{}
DbSelectArea("SH6")
DbSetOrder(1)
DbSeek(_cFilial+_cOrdem)
While !Eof() .and. (H6_FILIAL+H6_OP == _cFilial+_cOrdem)
	If !Empty(_cOper) .and. (SH6->H6_OPERAC <> _cOper)
		DbSelectArea("SH6")
		DbSkip()
		Loop
	Endif
	//
	_cQuery	:=	"SELECT * FROM " + RetSqlName("SD3")
	_cQuery	+=	" WHERE D_E_L_E_T_ = ' ' "
	_cQuery	+=	"   AND D3_IDENT = '" + SH6->H6_IDENT + "' "
	_cQuery	+=	"   AND D3_ESTORNO <> 'S'
	_cQuery	+=	"   AND D3_OP = '" + SH6->H6_OP + "' "
	_cQuery	+=	"   AND D3_FILIAL = '" + SH6->H6_FILIAL + "' "
	_cQuery	+=	" ORDER BY D3_TM, D3_COD "
	TCQuery _cQuery NEW ALIAS "_D3"
	DbSelectArea("_D3")
	DbGoTop()
	While !Eof()
		Aadd(_aColsSD3, Array(Len(_aHeadSD3) + 1))
		For nX := 1 To Len(_aHeadSD3)
			If _aHeadSD3[nX, 10] <> "V"
				_aColsSD3[Len(_aColsSD3), nX] := _D3->( FieldGet(FieldPos(_aHeadSD3[nX, 2])) ) 
			Else
				_aColsSD3[Len(_aColsSD3), nX] := IIf(_aHeadSD3[nX, 8] == "N", 0, "")
			Endif 	
		Next nX
		_aColsSD3[Len(_aColsSD3), Len(_aHeadSD3) + 1]	:= .F.
		DbSelectArea("_D3")
		DbSkip()
	End
	_D3 -> ( DbCloseArea() )
	//
	DbSelectArea("SH6")
	DbSkip()
End
If Len(_aColsSD3) <= 0
	Aadd(_aColsSD3, Array(Len(_aHeadSD3) + 1))
	For nX := 1 To Len(_aHeadSD3)
		_aColsSD3[Len(_aColsSD3), nX] := IIf(_aHeadSD3[nX, 8] == "N", 0, "")
	Next nX
	_aColsSD3[Len(_aColsSD3), Len(_aHeadSD3) + 1]	:= .F.
Endif
RestArea(_aArea)

Return _aColsSD3
//
Static Function _ZWCDados(_cFilial, _cOrdem, _cOper)

Local	_aArea	:=	GetArea()
Local nX := 0


_aColsZWC	:=	{}
DbSelectArea("ZWC")
DbSetOrder(1)
DbSelectArea("ZWB")
DbSetOrder(1)
DbSeek(_cFilial+_cOrdem)
While !Eof() .and. (ZWB_FILIAL+ZWB_OP == _cFilial+_cOrdem)
	If !Empty(_cOper) .and. (ZWB->ZWB_OPER <> _cOper)
		DbSelectArea("ZWB")
		DbSkip()
		Loop
	Endif
	//
	DbSelectArea("ZWC")
	DbSeek(_cFilial+_cOrdem)
	While !Eof() .and. (ZWC_FILIAL+ZWC_OP == _cFilial+_cOrdem)
		If !Empty(_cOper) .and. (ZWC->ZWC_OPER <> _cOper)
			DbSelectArea("ZWC")
			DbSkip()
			Loop
		Endif
		If ZWC->ZWC_ID <> ZWB->ZWB_ID
			DbSelectArea("ZWC")
			DbSkip()
			Loop
		Endif
		//
		Aadd(_aColsZWC, Array(Len(_aHeadZWC) + 1))
		For nX := 1 To Len(_aHeadZWC)
			If _aHeadZWC[nX, 10] <>  "V"
				_aColsZWC[Len(_aColsZWC), nX] := ZWC->( FieldGet(FieldPos(_aHeadZWC[nX, 2])) )
			Else
				_aColsZWC[Len(_aColsZWC), nX] := IIf(_aHeadZWC[nX, 8] == "N", 0, "")
			Endif 	
		Next nX
		_aColsZWC[Len(_aColsZWC), Len(_aHeadZWC) + 1]	:= .F.
		DbSelectArea("ZWC")
		DbSkip()
	End
	//
	DbSelectArea("ZWB")
	DbSkip()
End
If Len(_aColsZWC) <= 0
	Aadd(_aColsZWC, Array(Len(_aHeadZWC) + 1))
	For nX := 1 To Len(_aHeadZWC)
		_aColsZWC[Len(_aColsZWC), nX] := IIf(_aHeadZWC[nX, 8] == "N", 0, "")
	Next nX
	_aColsZWC[Len(_aColsZWC), Len(_aHeadZWC) + 1]	:= .F.
Endif
RestArea(_aArea)

Return _aColsZWC
//
User Function ZWBCADRX(_cFilial, _cOrdem, _cOper)

Local	_aArea	:=	GetArea()

_oDlg:End()
u_ZWBCADRES(_cFilial, _cOrdem, _cOper)
RestArea(_aArea)

Return
