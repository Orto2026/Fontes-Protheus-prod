#INCLUDE "PROTHEUS.ch"
#INCLUDE "TOPCONN.ch"

User Function ZWBDIV()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "DIVERGÊNCIA NA INTEGRAÇÃO DOS APONTAMENTOS"
Local cPict          := ""
Local titulo       := "DIVERGÊNCIA NA INTEGRAÇÃO DOS APONTAMENTOS"
Local nLin         := 80
Local cPerg       := Padr("ZWBDIVREL1", Len(SX1->X1_GRUPO))
Local Cabec1       := SPACE(65)+"QUANTIDADE"+SPACE(5)+"QUANTIDADE"
Local Cabec2       := "ORDEM/OPERAÇÃO"+SPACE(4)+"PRODUTO"+SPACE(10)+"RECURSO"+SPACE(3)+"DATA"+SPACE(17)+"PRODUZIDA"+SPACE(6)+"REJEITADA"+SPACE(1)+"UM"+SPACE(2)+"DESCRIÇÃO DO PRODUTO" 
Local imprime      := .T.

Private aOrd             := {"Produto+Ordem+Operação","Ordem+Operação","Data+Produto"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "ZWBDIV"
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "ZWBDIV"
Private cString := "ZWB"

dbSelectArea("ZWB")
dbSetOrder(1)

_ValidPerg(cPerg)
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif
nTipo := If(aReturn[4]==1,15,18)
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  18/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local 	nOrdem		:=	aReturn[8]
Local	_cQuery	:=	""
Local	_cPictQtde	:=	"@E 999,999.99"
Local	_aErro		:=	{}
Local	_nLinha

_cQuery	:=	" SELECT "
_cQuery	+=	"   ISNULL( CONVERT(VARCHAR(8000), CONVERT(BINARY(8000), ZWB_ERRDET)), ' ') ZWB_ERRDET, " 
_cQuery	+=	" 	 * " 
_cQuery	+=	"   FROM " + RetSqlName( "ZWB" )
_cQuery	+=	"  WHERE D_E_L_E_T_ <> '*' "
_cQuery	+=	"    AND ZWB_DTFIM BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' "
_cQuery	+=	"    AND ZWB_CODPEC BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
_cQuery	+=	"    AND ZWB_MAQ BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
_cQuery	+=	"    AND ZWB_STATUS = '0' AND ZWB_ERRO = 'S' "
_cQuery	+=	"    AND ZWB_FILIAL = '" + xFilial("ZWB") + "' "
If nOrdem == 1		//"Produto+Ordem+Operação"
	_cQuery	+=	"  ORDER BY ZWB_CODPEC, ZWB_OP, ZWB_OPER "
Elseif nOrdem == 2	//"Ordem+Operação"
	_cQuery	+=	"  ORDER BY ZWB_OP, ZWB_OPER "
Elseif nOrdem == 3	//"Data+Produto"
	_cQuery	+=	"  ORDER BY ZWB_DTFIM, ZWB_CODPEC, ZWB_OP, ZWB_OPER "
Else
	_cQuery	+=	"  ORDER BY ZWB_CODPEC, ZWB_OP, ZWB_OPER "
Endif
//
TCQuery _cQuery NEW ALIAS "_WR"
TCSetField("_WR", "ZWB_DTFIM", "D")
DbSelectArea( "_WR" )
SetRegua(RecCount())
dbGoTop()
While !EOF()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nLin > 60
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif
	//
   	@nLin, 000 PSAY AllTrim(_WR->ZWB_OP)+"/"+_WR->ZWB_OPER
   	@nLin, 018 PSAY _WR->ZWB_CODPEC
   	@nLin, 035 PSAY _WR->ZWB_MAQ
   	@nLin, 045 PSAY DTOC(_WR->ZWB_DTFIM)
   	@nLin, 065 PSAY Transform(_WR->ZWB_QUANT, _cPictQtde)
   	@nLin, 080 PSAY Transform(_WR->ZWB_REJ, _cPictQtde)
   	@nLin, 091 PSAY Left(_WR->ZWB_UNID, 2)
   	@nLin, 095 PSAY Left( FBUSCACPO("SB1", 1, xFilial("SB1")+_WR->ZWB_CODPEC, "B1_DESC"), 35 )
   	nLin++
   	//
   	_aErro	:=	_MsgErro(AllTrim(_WR->ZWB_ERRDET), IIf(mv_par07==1, .t., .f.), limite - 5)
   	For _nLinha := 1 to Len(_aErro)
   		If !Empty(_aErro[_nLinha, 1])
	   		@nLin, 005 PSAY Left(_aErro[_nLinha, 1], limite - 5)
		   	nLin++
		   	If nLin > 60
		      	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      	nLin := 9
			   	@nLin, 000 PSAY AllTrim(_WR->ZWB_OP)+"/"+_WR->ZWB_OPER
			   	@nLin, 018 PSAY _WR->ZWB_CODPEC
			   	@nLin, 035 PSAY _WR->ZWB_MAQ
			   	@nLin, 045 PSAY DTOC(_WR->ZWB_DTFIM)
			   	@nLin, 065 PSAY Transform(_WR->ZWB_QUANT, _cPictQtde)
			   	@nLin, 080 PSAY Transform(_WR->ZWB_REJ, _cPictQtde)
			   	@nLin, 091 PSAY Left(_WR->ZWB_UNID, 2)
			   	@nLin, 095 PSAY Left( FBUSCACPO("SB1", 1, xFilial("SB1")+_WR->ZWB_CODPEC, "B1_DESC"), 35 )
			   	nLin++
		   	Endif
		Endif
   	Next
   	//
   	@nLin, 000 PSAY REPLICATE("=", limite) 
   	nLin++
   	//
   	nLin++
	DbSelectArea("_WR")
   	dbSkip()
End
_WR -> ( DbCloseArea() )
DbSelectArea("ZWB")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()

Return
//
Static Function _ValidPerg( cPerg )

local _cAlias := Alias ()
local _aRegs  := {}
local _i      := 0
local _j      := 0

//           GRUPO  ORDEM PERGUNT                           PERSPA                            PERENG                            VARIAVL   TIPO TAM DEC PRESEL GSC  VALID VAR01       DEF01              DEFSPA1            DEFENG1            CNT01 VAR02 DEF02              DEFSPA02           DEFENG02           CNT02 VAR03 DEF03        DEFSPA3      DEFENG3      CNT03 VAR04 DEF04        DEFSPA4      DEFENG4      CNT04 VAR05 DEF05        DEFSPA5      DEFENG5      CNT05 F3     GRPSXG HELP
AADD(_aRegs,{cPerg, "01","Data de: 	", "", "", "mv_ch1", "D", 08, 0,  0,	"G", "",	"mv_par01", "",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"", "", "", "",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	""})
AADD(_aRegs,{cPerg, "02","Data ate: 	", "", "", "mv_ch2", "D", 08, 0,  0,   "G", "",	"mv_par02", "", "",	"",	"",	  "",   "",	"",       "",       "",   "",   "", "", "", "",   "","","","","","","","","","",""})
AADD(_aRegs,{cPerg, "03","Produto de:	", "", "", "mv_ch3", "C", 15, 0,  0,   "G", "",  "mv_par03", "", "", "", "",   "",   "",                	 				"",                "",                "",   "",   "",		   						"",      "",      "",   "",   "",   					"",      "",      "",   "",   "",      "",      "",      "",   "SB1",  ""})
AADD(_aRegs,{cPerg, "04","Produto até:	", "", "", "mv_ch4", "C", 15, 0,  0,   "G", "",  "mv_par04", "", "", "", "",   "",   "",                	 				"",                "",                "",   "",   "",    							"",      "",      "",   "",   "",    					"",      "",      "",   "",   "",      "",      "",      "",   "SB1",  ""})
AADD(_aRegs,{cPerg, "05","Recurso de: 	", "", "", "mv_ch5", "C", 06, 0,  0,   "G", "",  "mv_par05", "", "", "", "",   "",   "",                	 				"",                "",                "",   "",   "",		   						"",      "",      "",   "",   "",   					"",      "",      "",   "",   "",      "",      "",      "",   "SH1",  ""})
AADD(_aRegs,{cPerg, "06","Recurso até:	", "", "", "mv_ch6", "C", 06, 0,  0,   "G", "",	"mv_par06", "", "", "",	"",   "",   "",                	 				"",                "",                "",   "",   "",    							"",      "",      "",   "",   "",    					"",      "",      "",   "",   "",      "",      "",      "",   "SH1",  ""})
AADD(_aRegs,{cPerg, "07","Detalhado:   ", "", "", "mv_ch7", "N", 01,  0,  0,     "C", "",	"mv_par07", "Sim",          "",		 "",		  "",	  "",   "Não",          "",       "",       "",   "",   "", "", "", "",   "","","","","","","","","","",""})

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
Static Function _MsgErro(_cTexto, _bDet, _nTamLin)

Local	_aDados	:=	{}
Local	_cLinha	:=	""
Local _nPos

For _nPos := 1 To Len(_cTexto)
	If (Substr(_cTexto, _nPos, 1) == CHR(13)) .or. (Substr(_cTexto, _nPos, 1) == CHR(10)) .or. (Len(_cLinha) == _nTamLin) 
		aadd(_aDados, {_cLinha})
		_cLinha	:=	""
	Else
		If !_bDet .and. ("_FILIAL" $ _cLinha)
			Exit
		Else
			_cLinha	+=	Substr(_cTexto, _nPos, 1)
		Endif	
	Endif 
Next

Return _aDados
