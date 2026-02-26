#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBIConn.CH"

//FÁBIO A. MICHELON - MICROTRUST
//OBJETIVO: ROTINA DE GERAÇÃO DOS APONTAMENTOS DE PRODUÇÃO

#TRANSLATE	.op			=>	1
#TRANSLATE	.operacao	=>	2
#TRANSLATE	.qtdprod	=>	3
#TRANSLATE	.qtdperd	=>	4
#TRANSLATE	.dtapont	=>	5
#TRANSLATE	.recurso	=>	6
#TRANSLATE	.tmpreal	=>	7
#TRANSLATE	.tmpint	=>	8
#TRANSLATE	.dtini	=>	9
#TRANSLATE	.hrini	=>	10
#TRANSLATE	.dtfim	=>	11
#TRANSLATE	.hrfim	=>	12
#TRANSLATE	.max		=>	12


User Function NUMXMP1(_bAuto)

Default	_bAuto	:=	.f.

Processa({|| _Processa(_bAuto)}, "Gerando os apontamentos de produção ..." )

Return
//
Static Function _Processa(_bAuto)

Local	_aAponts	:=	{}
Local	_aRecnos	:=	{}
Local	_cQuery		:=	""
Local	_aArea		:=	GetArea()
Local	_cRecurso	:=	""
Local	_cErro		:=	""
Local	_CRLF		:=	Chr(13) + Chr(10)
Local	_nLinApt	:=	1
Local	_nMsg		:=	1
Local	_aMsgEstoq	:=	{}
Local	_aMsgAux	:=	{}
Local	_aErrApt	:=	{}
Local	_aErrEst	:=	{}
Local	_nReg		:=	0
Local	_nPos		:=	0
Local	_nQuantOp	:=	0
Local	_cPerg		:=	Padr("NUMXMP1", Len(SX1->X1_GRUPO))
Local	_cTime		:=	Left(Time(), 2) + Substr(Time(), 4, 2) + Right(Time(), 2)
Local	_cChave	:=	DTOS(Date()) + _cTime + RetCodUsr()	+ StrZero(ThreadID(), 6) //8+6+6+6=26
Local	_cTpTempo	:=	Left(SuperGetMv("MX_TPTEMPO", .F., "P"), 1)		//Tipo de Tempo do Apontamento: P=Padrão; R=Real
Local	_nTempoReal	:=	0
Local	_nFatTempo		:=	3600
Local   _nAux  := 0
//
_ValidPerg(_cPerg)
If !_bAuto .and. !Pergunte(_cPerg, .t.)
	Return
Endif
//
_cQuery	:=	" SELECT * "
_cQuery	+=	"   FROM " + RetSqlName( "ZWB" )
_cQuery	+=	"  WHERE D_E_L_E_T_ <> '*' "
If !_bAuto
	_cQuery	+=	"    AND ZWB_TURNO BETWEEN " + AllTrim(Str(mv_par03)) + " AND " + AllTrim(Str(mv_par04)) + " "
	_cQuery	+=	"    AND ZWB_DTFIM BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' "
	_cQuery	+=	"    AND ZWB_MAQ BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' "
	_cQuery	+=	"    AND ZWB_CODPEC BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' "
	_cQuery	+=	"    AND ZWB_OP BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
Else
	_cQuery	+=	"    AND ZWB_DTFIM >= '" + dtos(Date() - 60) + "' "
Endif
_cQuery	+=	"    AND (ZWB_QUANT + ZWB_REJ) > 0 "
_cQuery	+=	"    AND ZWB_STATUS = '0' "
_cQuery	+=	"    AND ZWB_FILIAL = '" + xFilial("ZWB") + "' "
_cQuery	+=	"  ORDER BY ZWB_DTFIM, ZWB_HRFIM, ZWB_OP DESC, ZWB_OPER "
//
TCQuery _cQuery NEW ALIAS "_WB"
DbSelectArea( "_WB" )
DbGoTop()
While !Eof()
	//Verifica se o recurso/máquina está cadastrado para integrar com o sistema NC-MES
	If (SH1 -> (FieldPos("H1_WZINTEG")) > 0) .and. (FBUSCACPO("SH1", 1, xFilial("SH1")+_WB->ZWB_MAQ, "H1_WZINTEG") <> "S")
		DbSelectArea( "_WB" )
		DbSkip()
		Loop
	Endif
	//
	_nPos	:=	0	//aScan(_aAponts, { |x| x[.op]+x[.operacao] == _WB->ZWB_OP+_WB->ZWB_OPER })
	If _nPos > 0
		_aAponts[_nPos, .qtdprod]	+=	(_WB->ZWB_QUANT - _WB->ZWB_REJ)
		_aAponts[_nPos, .qtdperd]	+=	_WB->ZWB_REJ
		_aAponts[_nPos, .tmpreal]	+=	(_WB->ZWB_TMPPRD / _nFatTempo)
		_aAponts[_nPos, .tmpint]		+=	(_WB->ZWB_TMPINT / _nFatTempo)
		If _aAponts[_nPos, .dtapont] < _WB->ZWB_DTFIM
			_aAponts[_nPos, .dtapont]	:=	_WB->ZWB_DTFIM
		Endif
		If _aAponts[_nPos, .dtini] > _WB->ZWB_DTINI
			_aAponts[_nPos, .dtini]	:=	_WB->ZWB_DTINI
			_aAponts[_nPos, .hrini]	:=	Left(_WB->ZWB_HRINI, 5)
		Endif
		If _aAponts[_nPos, .dtfim] < _WB->ZWB_DTFIM
			_aAponts[_nPos, .dtfim]	:=	_WB->ZWB_DTFIM
			_aAponts[_nPos, .hrfim]	:=	Left(_WB->ZWB_HRFIM, 5)
		Endif
	Else
		aadd( _aAponts, Array(.max) )
		_aAponts[Len(_aAponts), .op]		:=	_WB->ZWB_OP
		_aAponts[Len(_aAponts), .operacao]	:=	_WB->ZWB_OPER
		_aAponts[Len(_aAponts), .qtdprod]	:=	(_WB->ZWB_QUANT - _WB->ZWB_REJ) 
		_aAponts[Len(_aAponts), .qtdperd]	:=	_WB->ZWB_REJ
		_aAponts[Len(_aAponts), .dtapont]	:=	_WB->ZWB_DTFIM
		_aAponts[Len(_aAponts), .recurso]	:=	_WB->ZWB_MAQ
		_aAponts[Len(_aAponts), .tmpreal]	:=	(_WB->ZWB_TMPPRD / _nFatTempo)
		_aAponts[Len(_aAponts), .tmpint]	:=	(_WB->ZWB_TMPINT / _nFatTempo)
		_aAponts[Len(_aAponts), .dtini]		:=	_WB->ZWB_DTINI
		_aAponts[Len(_aAponts), .hrini]		:=	Left(_WB->ZWB_HRINI, 5)
		_aAponts[Len(_aAponts), .dtfim]		:=	_WB->ZWB_DTFIM
		_aAponts[Len(_aAponts), .hrfim]		:=	Left(_WB->ZWB_HRFIM, 5)
	Endif
	aadd( _aRecnos, Array(3) )
	_aRecnos[Len(_aRecnos), 1]	:=	_WB->ZWB_OP
	_aRecnos[Len(_aRecnos), 2]	:=	_WB->ZWB_OPER
	_aRecnos[Len(_aRecnos), 3]	:=	_WB->R_E_C_N_O_
	DbSkip()
End
_WB -> ( DbCloseArea() )
RestArea(_aArea)
//
//realizar o apontamento
If Len(_aAponts) > 0
	//u_ShowArray(_aAponts)
	ProcRegua( Len(_aAponts) )
	Conout( "[NUMXMP1]:Iniciando processo de Apontamento NC-MES X Protheus ... " )
	DbSelectArea( "SC2" )
	DbSetOrder(1)
	DbSelectArea( "SG2" )
	DbSetOrder(1)
	For _nLinApt := 1 To Len(_aAponts)
		IncProc()
		_cErro	:=	""
		//
		DbSelectArea( "SC2" )
		DbSeek( xFilial("SC2")+_aAponts[_nLinApt, .op] )
		If Found()
			_cProduto	:= 	sc2 -> c2_produto
			_cRoteiro 	:= 	IIf (empty (sc2->c2_roteiro), "01", sc2 -> c2_roteiro)
			_nQuantOp	:=	sc2 -> c2_quant
			_cErro		:=	_InclApont( _aAponts[_nLinApt, .op], _cProduto, _cRoteiro, _aAponts[_nLinApt, .operacao], _cRecurso, _aAponts[_nLinApt, .qtdprod], _aAponts[_nLinApt, .qtdperd], SC2->C2_LOCAL, _cChave, _cTpTempo, _aAponts[_nLinApt, .tmpreal], _aAponts[_nLinApt, .tmpint], stod(_aAponts[_nLinApt, .dtini]), _aAponts[_nLinApt, .hrini], stod(_aAponts[_nLinApt, .dtfim]), _aAponts[_nLinApt, .hrfim], _bAuto )
		Else
			_cErro	+=	Space(2) + "Ordem de Produção não encontrada."
		Endif
		//verifica se houve erro
		If Empty(_cErro)
			_cRecnos	:=	""
			For _nAux := 1 To Len(_aRecnos)
				If (_aRecnos[_nAux, 1] == _aAponts[_nLinApt, .op]) .and. (_aRecnos[_nAux, 2] == _aAponts[_nLinApt, .operacao])
					_cRecnos	+=	AllTrim(Str(_aRecnos[_nAux, 3])) + ","
				Endif
			Next
			If !Empty(_cRecnos)
				_cRecnos	:=	Left(_cRecnos, Len(_cRecnos) - 1)
				_cQuery	:=	" UPDATE " + RetSqlName( "ZWB" )
				_cQuery	+=	"    SET ZWB_STATUS = '1', ZWB_ERRO = 'N', ZWB_MENSAG = ' ' "
				If ZWB -> (FieldPos("ZWB_CHAVE")) > 0
					_cQuery	+=	" , ZWB_CHAVE = '" + _cChave + "' "
				Endif
				If ZWB -> (FieldPos("ZWB_ERRDET")) > 0
					_cQuery	+=	" , ZWB_ERRDET = NULL "
				Endif
				_cQuery	+=	"  WHERE R_E_C_N_O_ IN (" + _cRecnos + ") "
				TCSqlExec( _cQuery )
			Endif
		Else
			//erros de apontamento
			_cRecnos	:=	""
			For _nAux := 1 To Len(_aRecnos)
				If (_aRecnos[_nAux, 1] == _aAponts[_nLinApt, .op]) .and. (_aRecnos[_nAux, 2] == _aAponts[_nLinApt, .operacao])
					_cRecnos	+=	AllTrim(Str(_aRecnos[_nAux, 3])) + ","
				Endif
			Next
			If !Empty(_cRecnos)
				_cRecnos	:=	Left(_cRecnos, Len(_cRecnos) - 1)
				_cQuery	:=	" UPDATE " + RetSqlName( "ZWB" )
				If _bAuto
					_cQuery	+=	"    SET ZWB_STATUS = '1', "
				Else
					_cQuery	+=	"    SET ZWB_STATUS = '0', "
				Endif
				_cQuery	+=	"    ZWB_ERRO = 'S', ZWB_MENSAG = '" + _ErroDescr(Substr(_cErro, 3, TAMSX3("ZWB_MENSAG")[1])) + "' "
				If ZWB -> (FieldPos("ZWB_CHAVE")) > 0
					_cQuery	+=	" , ZWB_CHAVE = ' ' "
				Endif
				If ZWB -> (FieldPos("ZWB_ERRDET")) > 0
					_cQuery	+=	" , ZWB_ERRDET = '" + _cErro + "' "
				Endif
				_cQuery	+=	"  WHERE R_E_C_N_O_ IN (" + _cRecnos + ") "
				TCSqlExec( _cQuery )
			Endif
			If "ESTOQUE" $ Upper(_cErro)
				aadd( _aErrEst, { _aAponts[_nLinApt, .op], Left(_cErro, 2),	_cRecurso,;
				Transform(_aAponts[_nLinApt, .Qtdprod], PesqPictQT("H6_QTDPROD")),;
				Transform(_aAponts[_nLinApt, .Qtdperd], PesqPictQT("H6_QTDPROD")),;
				Substr(_cErro, 3, Len(_cErro)),;
				Transform(_nQuantOp, PesqPictQT("C2_QUANT")) })
			Else
				aadd( _aErrApt, { _aAponts[_nLinApt, .op], Left(_cErro, 2),	_cRecurso,;
				Transform(_aAponts[_nLinApt, .Qtdprod], PesqPictQT("H6_QTDPROD")),;
				Transform(_aAponts[_nLinApt, .Qtdperd], PesqPictQT("H6_QTDPROD")),;
				Substr(_cErro, 3, Len(_cErro)),;
				Transform(_nQuantOp, PesqPictQT("C2_QUANT")) })
			Endif
		Endif
	Next _nLinApt
	Conout( "[NUMXMP1]:Terminado processo de Apontamento NC-MES X Protheus." )
Else
	Conout( "[NUMXMP1]:Sem Apontamentos NC-MES X Protheus - ZWB SEM REGISTROS" )
Endif

Return

//rotina que efetua o apontamento da operação
Static Function _InclApont( _cOp, _cProduto, _cRoteiro, _cOperacao, _cRecurso, _nQtdProd, _nQtdPerd, _cLocal, _cChave, _cTpTempo, _nTempoReal, _nTempoInt, _dDtIni, _cHrIni, _dDtFim, _cHrFim, _bAuto )

Local	_cErro		:=	""
Local	_aAutoSH6 	:= {}
Local	_nLotePad 	:=	1
Local	_nTempo 	:=	1
Local	_cMens		:=	""
Local	_cArqErro	:=	""
Local	_nAuxPerd	:=	_nQtdPerd
Local	_aTimeEnd	:=	{}
Default	_bAuto	:=	.f.

//*** Tratamento para quantidade perdida ***
//_nQtdPerd	:=	0
// -----------------------------------------
//
DbSelectArea( "SG2" )
DbSeek( xfilial("SG2")+_cProduto+_cRoteiro+_cOperacao )
If Found()
	//
	//*** Tratamento para o Tipo de Tempo (P=Padrão ou R=Real)
	If _cTpTempo <> "P"	//Tempo Real
		_nTempo	:=	_nTempoReal
	Else					//Tempo Padrão
		_nLotePad = iif (sg2 -> g2_lotepad == 0, 1, sg2 -> g2_lotepad)
		_nTempo := (sg2 -> g2_tempad / _nLotePad)
		If (sg2 -> g2_tpoper == "1") .or. Empty (sg2 -> g2_tpoper)
			_nTempo *= (_nQtdProd+_nQtdPerd)
		Endif
	Endif
	If _nTempo < HoraToInt ("00:01")
		_nTempo := HoraToInt ("00:01")  // Pelo menos 1 minuto
		_aTimeEnd	:=	fSomaHora (_dDtIni, _cHrIni, 0.017)
		_dDtFim		:=	_aTimeEnd[1]
		_cHrFim		:=	_aTimeEnd[2]
	Endif
	// ------------------------------------------------------------------
	//
	_aAutoSH6 := {}
	aAdd(_aAutoSH6,{"H6_OP"     , _cOp           , NIL})
	aAdd(_aAutoSH6,{"H6_PRODUTO", _cProduto       , NIL})
	aAdd(_aAutoSH6,{"H6_OPERAC" , sg2 -> g2_operac, NIL})
	aAdd(_aAutoSH6,{"H6_DTAPONT", dDataBase       , NIL})
	aAdd(_aAutoSH6,{"H6_DTPROD",  dDataBase       , NIL})
	aAdd(_aAutoSH6,{"H6_DATAINI", _dDtIni       , NIL})
	aAdd(_aAutoSH6,{"H6_HORAINI", _cHrIni       , NIL})
	aAdd(_aAutoSH6,{"H6_DATAFIN", _dDtFim       , NIL})
	aAdd(_aAutoSH6,{"H6_HORAFIN", _cHrFim       , NIL})
	//aAdd(_aAutoSH6,{"H6_TEMPO",   IntToHora (_nTempo, 3)       , NIL})
	aAdd(_aAutoSH6,{"H6_QTDPROD", _nQtdProd       , NIL})
	aAdd(_aAutoSH6,{"H6_QTDPERD", _nQtdPerd       , NIL})
	aAdd(_aAutoSH6,{"H6_OPERADO", "AUTO-NC-MES"       , NIL})
	aAdd(_aAutoSH6,{"H6_LOCAL",   _cLocal       , NIL})
	If _cRecurso <> nil
		aAdd(_aAutoSH6,{"H6_RECURSO" , _cRecurso, NIL})
	Endif
	If SH6 -> (FieldPos("H6_WZCHAVE")) > 0
		aAdd(_aAutoSH6,{"H6_WZCHAVE" , _cChave, NIL})
	Endif
	If SH6 -> (FieldPos("H6_WZPERDA")) > 0
		aAdd(_aAutoSH6,{"H6_WZPERDA" , _nAuxPerd, NIL})
	Endif
	If SH6 -> (FieldPos("H6_WZHRINT")) > 0
		aAdd(_aAutoSH6,{"H6_WZHRINT" , IntToHora(_nTempoInt, 3), NIL})
	Endif
	// PARA NAO USAR TABELA T4K - MAURICIO PRADO 02/09/21
		aAdd(_aAutoSH6,{"H6_XLOG"  ,U_XORTF001()				, NIL})
		aAdd(_aAutoSH6,{"PENDENTE"  ,"1"						, NIL})
		
	//
	_aAutoSH6 := aclone (U_OrdAuto (_aAutoSH6))	// Ordena array cfe. ordem dos campos no SX3 para evitar dor de cabeca com validacoes e gatilhos.
	lMSErroAuto := .F.
	msExecAuto({|x,y|MATA681(x,y)},_aAutoSH6)
	If lmserroauto
		_cArqErro	:=	GetSrvProfString("Startpath","") + nomeautolog()
		_cErro	:=	MemoRead(_cArqErro)
		_cMens	:=	"Ordem de Produção: " + AllTrim(_cOp) + " - Operação: " + AllTrim(sg2 -> g2_operac) + chr(13) + chr(10)
		_cMens	+=	"Produto: " + AllTrim(_cProduto) + " - " + AllTrim(FBUSCACPO("SB1", 1, xFilial("SB1")+_cProduto, "B1_DESC")) + chr(13) + chr(10) + chr(13) + chr(10)
		If !_bAuto
			/*
			If Aviso("ERRO NO APONTAMENTO:",  _cMens, {"Sair", "DETALHES"}) == 2
				MostraErro()
			Endif
			*/
		Endif
		Conout("[NUXMP1/ERRO NO APONTAMENTO]: " + _cMens + _cErro)
	Else
		Conout("[NUXMP1]:    Apontada O.P. - " + AllTrim(_cOp) + "/" + AllTrim(sg2 -> g2_operac) )
	EndIf
Else
	_cErro	:=	Upper("Operação não cadastrada.")
	_cMens	:=	"Ordem de Produção: " + AllTrim(_cOp) + " - Operação: " + AllTrim(_cOperacao) + chr(13) + chr(10)
	_cMens	+=	"Produto: " + AllTrim(_cProduto) + " - " + AllTrim(FBUSCACPO("SB1", 1, xFilial("SB1")+_cProduto, "B1_DESC")) + chr(13) + chr(10)
	_cMens	+=	"Motivo: OPERAÇÃO NÃO CADASTRADA"
	/*
	If !_bAuto
		Aviso("ERRO NO APONTAMENTO",  _cMens, {"OK"})
	Endif
	*/
	Conout("[NUXMP1/ERRO NO APONTAMENTO]: " + _cMens + _cErro)
Endif

Return (_cMens + _cErro)	//_cErro
//
Static Function _ErroDescr(_cErro)

Local	_cTexto	:=	""
Local	_nPos

For _nPos := 1 To Len(_cErro)
	If (Substr(_cErro, _nPos, 1) <> CHR(13)) .and. (Substr(_cErro, _nPos, 1) <> CHR(10))
		_cTexto	+=	Substr(_cErro, _nPos, 1)
	Else
		_cTexto	+=	" "
	Endif
Next

Return _cTexto
//
Static Function _ValidPerg( cPerg )

local _cAlias := Alias ()
local _aRegs  := {}
local _i      := 0
local _j      := 0

//           GRUPO  ORDEM PERGUNT                           PERSPA                            PERENG                            VARIAVL   TIPO TAM DEC PRESEL GSC  VALID VAR01       DEF01              DEFSPA1            DEFENG1            CNT01 VAR02 DEF02              DEFSPA02           DEFENG02           CNT02 VAR03 DEF03        DEFSPA3      DEFENG3      CNT03 VAR04 DEF04        DEFSPA4      DEFENG4      CNT04 VAR05 DEF05        DEFSPA5      DEFENG5      CNT05 F3     GRPSXG HELP
AADD(_aRegs,{cPerg, "01","Data de: 	", "", "", "mv_ch1", "D", 08, 0,  0,	"G", "",	"mv_par01", "",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"", "", "", "",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	""})
AADD(_aRegs,{cPerg, "02","Data ate: 	", "", "", "mv_ch2", "D", 08, 0,  0,   "G", "",	"mv_par02", "", "",	"",	"",	  "",   "",	"",       "",       "",   "",   "", "", "", "",   "","","","","","","","","","",""})
AADD(_aRegs,{cPerg, "03","Turno de:	", "", "", "mv_ch3", "N", 06, 0,  0,   "G", "",    "mv_par03", "", "", "", "",   "",   "", "",                "",                "",   "",   "",		   						"",      "",      "",   "",   "",   					"",      "",      "",   "",   "",      "",      "",      "",   "",  ""})
AADD(_aRegs,{cPerg, "04","Turno até:	", "", "", "mv_ch4", "N", 06, 0,  0,   "G", "",    "mv_par04", "", "", "", "",   "",   "", "",                "",                "",   "",   "",    							"",      "",      "",   "",   "",    					"",      "",      "",   "",   "",      "",      "",      "",   "",  ""})
AADD(_aRegs,{cPerg, "05","Ordem de Produção de:	", "", "", "mv_ch5", "C", 13, 0,  0,   "G", "",    "mv_par05", "", "", "", "",   "",   "", "",                "",                "",   "",   "",		   						"",      "",      "",   "",   "",   					"",      "",      "",   "",   "",      "",      "",      "",   "SC2",  ""})
AADD(_aRegs,{cPerg, "06","Ordem de Produção até:	", "", "", "mv_ch6", "C", 13, 0,  0,   "G", "",    "mv_par06", "", "", "", "",   "",   "", "",                "",                "",   "",   "",    							"",      "",      "",   "",   "",    					"",      "",      "",   "",   "",      "",      "",      "",   "SC2",  ""})
AADD(_aRegs,{cPerg, "07","Produto de:	", "", "", "mv_ch7", "C", 15, 0,  0,   "G", "",    "mv_par07", "", "", "", "",   "",   "",                	 				"",                "",                "",   "",   "",		   						"",      "",      "",   "",   "",   					"",      "",      "",   "",   "",      "",      "",      "",   "SB1",  ""})
AADD(_aRegs,{cPerg, "08","Produto até:	", "", "", "mv_ch8", "C", 15, 0,  0,   "G", "",    "mv_par08", "", "", "", "",   "",   "",                	 				"",                "",                "",   "",   "",    							"",      "",      "",   "",   "",    					"",      "",      "",   "",   "",      "",      "",      "",   "SB1",  ""})
AADD(_aRegs,{cPerg, "09","Recurso de: 	", "", "", "mv_ch9", "C", 06, 0,  0,   "G", "",    "mv_par09", "", "", "", "",   "",   "",                	 				"",                "",                "",   "",   "",		   						"",      "",      "",   "",   "",   					"",      "",      "",   "",   "",      "",      "",      "",   "SH1",  ""})
AADD(_aRegs,{cPerg, "10","Recurso até:	", "", "", "mv_cha", "C", 06, 0,  0,   "G", "",	"mv_par10", "", "", "",	"",   "",   "",                	 				"",                "",                "",   "",   "",    							"",      "",      "",   "",   "",    					"",      "",      "",   "",   "",      "",      "",      "",   "SH1",  ""})

DbSelectArea ("SX1")
DbSetOrder (1)
For _i := 1 to Len (_aRegs)
	If ! DbSeek (cPerg + _aRegs [_i, 2])
		RecLock ("SX1", .T.)
	else
		RecLock ("SX1", .F.)
	endif
	For _j := 1 to FCount ()
		If _j <= Len (_aRegs [_i]) .and. left (fieldname (_j), 6) != "X1_CNT" .and. fieldname (_j) != "X1_PRESEL"
			FieldPut (_j, _aRegs [_i, _j])
		Endif
	Next
	MsUnlock ()
Next

// Deleta do SX1 as perguntas que nao constam em _aRegs
DbSeek (cPerg, .T.)
do while ! eof () .and. x1_grupo == cPerg
	if ascan (_aRegs, {|_aVal| _aVal [2] == sx1 -> x1_ordem}) == 0
		reclock ("SX1", .F.)
		dbdelete ()
		msunlock ()
	endif
	dbskip ()
enddo
DbSelectArea (_cAlias)

Return
//
// Descricao.: Funcao que recebe uma data e hora e soma determinada quantidade de horas.
// Parametros: 1 - Data de inicio (formato data)
//             2 - Hora de inicio (formato HH:MM)
//             3 - Quant. de horas a somar (centesimal. Ex.: 1.5 = 01:30h)
// Retorno...: array: {Data final (formato data), Hora final (formato HH:MM)}
Static Function fSomaHora (_dDataIni, _sHoraIni, _nHoras)

local _dDataFim := _dDataIni
local _sHoraFim := ""
local _nDias    := 0

   // Se informada quantidade negativa de horas, calcula retroativamente.
if _nHoras < 0

      // Desconta os dias (a cada 24 horas)
	do while _nHoras < -24
		_dDataFim --
		_nHoras += 24
	enddo

  // Verifica se, descontando as horas do horario de inicio, fica abaixo de meia-noite.
	if HoraToInt (_sHoraIni) < abs (_nHoras)
		_dDataFim --
		_sHoraFim = IntToHora (24 - abs (_nHoras) + HoraToInt (_sHoraIni))
	else
		_sHoraFim = IntToHora (HoraToInt (_sHoraIni) - abs (_nHoras))
	endif

else

      // Soma os dias (a cada 24 horas)
	do while _nHoras > 24
		_dDataFim ++
		_nHoras -= 24
	enddo

  // Verifica se somando as horas com o horario de inicio, passa de meia-noite.
	_nPassa24 = HoraToInt (_sHoraIni) + _nHoras - 24
	if _nPassa24 > 0
		_dDataFim ++
		_sHoraFim = IntToHora (_nPassa24)
	else
		_sHoraFim = IntToHora (HoraToInt (_sHoraIni) + _nHoras)
	endif
   endif

return {_dDataFim, _sHoraFim}
