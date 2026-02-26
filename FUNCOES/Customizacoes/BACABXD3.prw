#INCLUDE "rwmake.ch"
#include "TBICONN.CH"
#include "TBICODE.CH"
#include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BACABXD3 ºAutor  ³Raphael Camillo-Demaº Data ³  18/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Baca para Baixar Saldos do Estoque de um determinado       º±±
±±º          ³ Produto x Armazem                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ORTOSINTESE                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BACABXD3()

aRegs := {}
cPerg := Padr("BACABXD3",Len(SX1->X1_GRUPO))

aAdd(aRegs,{cPerg,"01","Produto De ?","","","mv_ch1","C",15,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Produto Ate?","","","mv_ch2","C",15,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Armazem    ?","","","mv_ch3","C",02,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
ValidPerg(aRegs, cPerg)

If !Pergunte(cPerg,.T.)
	Return()
EndIf

Processa({|| BAIXAD3() })

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BACAGTRF ºAutor  ³Raphael Camillo Demaº Data ³  30/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a Transferencia entre os Armazens 01 e do Pedido    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BAIXAD3()

Local aCab 		:= {}
Local aItens 	:= {}
Local _cQuery	:= ""

_cQuery := " "
_cQuery += " SELECT BF_PRODUTO, B1_UM, BF_LOCAL, B8_DTVALID, BF_LOTECTL, BF_LOCALIZ, BF_NUMLOTE, (BF_QUANT - BF_EMPENHO) SALDO "
_cQuery += " FROM "+RetSqlName("SBF")+ " SBF "  
_cQuery += " INNER JOIN "+RetSqlName("SB8")+" SB8 ON B8_FILIAL = BF_FILIAL AND B8_PRODUTO = BF_PRODUTO AND B8_LOCAL = BF_LOCAL "
_cQuery += " AND B8_LOTECTL = BF_LOTECTL AND SB8.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = BF_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
_cQuery += " WHERE BF_FILIAL = '"+xFilial("SBF")+"' "
_cQuery += " AND SBF.D_E_L_E_T_ = ' ' "
_cQuery += " AND BF_LOCAL = '"+Mv_Par03+"' "
_cQuery += " AND (BF_QUANT - BF_EMPENHO) > 0 "
_cQuery += " AND BF_PRODUTO BETWEEN '"+Mv_Par01+"' AND '"+Mv_Par02+"' "

_cQuery := ChangeQuery( _cQuery )

MEMOWRIT( FunName()+".SQL", _cQuery )

If Select("QUERY") > 0
	dbSelectArea("QUERY")
	dbCloseArea()
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'QUERY', .F., .T.)

TCSetField('QUERY', "B8_DTVALID", "D",8,0)

lMsErroAuto		:= .F.
dbSelectArea("QUERY")
ProcRegua(RecCount())
dbGotop()
While !Eof()

	IncProc("Selecionando Produto "+QUERY->BF_PRODUTO)

	dbSelectArea("SBE")
	dbSetOrder(1)
	If !dbSeek(xFilial("SBE")+QUERY->BF_LOCAL+QUERY->BF_LOCALIZ)
		RecLock("SBE",.T.)
		SBE->BE_FILIAL 	:= xFilial("SBE")
		SBE->BE_LOCAL  	:= QUERY->BF_LOCAL
		SBE->BE_LOCALIZ 	:= QUERY->BF_LOCALIZ
		SBE->BE_DESCRIC 	:= QUERY->BF_LOCALIZ
		SBE->BE_PRIOR		:= "ZZZ"
		MsUnlock()
	EndIf

	If (Len(aCab) == 0)
		aCab:= {;
		{"D3_TM"			,"501"		,NIL},;
		{"D3_EMISSAO"	,dDatabase	,NIL},;
		{"D3_CC"			,""			,NIL}}
	EndIf
	
	aAdd(aItens,{ 	;
	{"D3_COD"    ,QUERY->BF_PRODUTO	,NIL},;
	{"D3_UM"     ,QUERY->B1_UM			,NIL},;
	{"D3_LOCAL"  ,QUERY->BF_LOCAL		,NIL},;
	{"D3_QUANT"  ,QUERY->SALDO			,NIL},;
	{"D3_DTVALID",QUERY->B8_DTVALID	,Nil},;
	{"D3_LOTECTL",QUERY->BF_LOTECTL	,Nil},;
	{"D3_NUMLOTE",QUERY->BF_NUMLOTE	,Nil},;
	{"D3_LOCALIZ",QUERY->BF_LOCALIZ	,Nil}})
	
	dbSelectArea("QUERY")
	dbSkip()
EndDo

If (Len(aItens) > 0)

	LjMsgRun("Gerando Internos Mod.2 ...","",{||MSExecAuto({|x,y,z| mata241(x,y,z)},aCab,aItens,3)}) // Inclusao
	
	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
		Return
	Else
		Aviso("Atencao","Gerado a Movimento Interno. Doc "+SD3->D3_DOC,{"Ok"})
	EndIf
Else
	Aviso("Atencao","Produtos sem Saldo a Transferir ",{"Ok"})
EndIf

Return()