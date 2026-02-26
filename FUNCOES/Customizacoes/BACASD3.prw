#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BACASD3  ºAutor  ³Raphael Camillo-Demaº Data ³  29/10/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Baca para criar Saldo no SD3 para excluit nota fiscal.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BACASD3()
Local aCab   := {}
Local aItens := {}

aRegs := {}
cPerg := Padr("BACASD3",Len(SX1->X1_GRUPO))

aAdd(aRegs,{cPerg,"01","Nota Fiscal      ?","","","mv_ch1","C",09,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Serie            ?","","","mv_ch2","C",03,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Tipo da Nota     ?","","","mv_ch3","N",01,00,0,"C","","mv_par03","Entrada","","","","","Saida","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Tipo do Movimento?","","","mv_ch4","N",01,00,0,"C","","mv_par03","Entrada","","","","","Saida","","","","","","","","","","","","","","","","","","","","","","","",""})
ValidPerg(aRegs, cPerg)

If !Pergunte(cPerg,.T.)
	Return()
EndIf

lMsErroAuto := .F.
_lOK := .F.

If Mv_Par03 == 2
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+Mv_Par01+Mv_Par02)
	_cChv1 := "SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE" 
	_cChv2 := "xFilial('SD2')+MV_PAR01+MV_PAR02"
Else
	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(xFilial("SD1")+Mv_Par01+Mv_Par02)
	_cChv1 := "SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE"
	_cChv2 := "xFilial('SD1')+MV_PAR01+MV_PAR02"
EndIf

While &_cChv1 == &_cChv2
	
	_cAlias	:= Alias()
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+IIF(Mv_Par03==2,SD2->D2_COD,SD1->D1_COD) )

	If (Len(aCab) == 0)
		aCab:= {;
		{"D3_TM"			,IIF(Mv_Par04==2,"501","001"),NIL},;
		{"D3_EMISSAO"	,IIF(Mv_Par03==2,SD2->D2_EMISSAO,SD1->D1_DTDIGIT),NIL},;
		{"D3_CC"			,"",NIL}}
	EndIf
	
	_cEnder := IIF(Mv_Par03==2,SB1->B1_XLOCALI	,SD1->D1_ENDER)
	If Mv_Par04 == 2 .And. Mv_Par03 == 1
		_cEnder := SD1->D1_ENDER
	EndIf
	
	aAdd(aItens,{ 	;
		{"D3_COD"		,IIF(Mv_Par03==2,SD2->D2_COD			,SD1->D1_COD)		,	NIL},;
		{"D3_UM"			,IIF(Mv_Par03==2,SD2->D2_UM			,SD1->D1_UM)		,	NIL},;
		{"D3_LOCAL"		,IIF(Mv_Par03==2,SD2->D2_LOCAL		,SD1->D1_LOCAL)	,	NIL},;
		{"D3_QUANT"		,IIF(Mv_Par03==2,SD2->D2_QUANT		,SD1->D1_QUANT)	,	NIL},;
		{"D3_DTVALID"	,IIF(Mv_Par03==2,SD2->D2_DTVALID	,SD1->D1_DTVALID)	,	Nil},;
		{"D3_LOTECTL"	,IIF(Mv_Par03==2,SD2->D2_LOTECTL	,SD1->D1_LOTECTL)	,	Nil},;
		{"D3_NUMLOTE"	,IIF(Mv_Par03==2,SD2->D2_NUMLOTE	,SD1->D1_NUMLOTE)	,	Nil},;
		{"D3_LOCALIZ"	,_cEnder																,	Nil},;
		{"D3_XMOTIVO"	,IIF(Mv_Par03==2,SB1->B1_XLOCALI	,SD1->D1_ENDER)	,	Nil}})			

	dbSelectArea(_cAlias)
	dbSkip()
EndDo

If (Len(aItens) > 0)

	MSExecAuto({|x,y,z| mata241(x,y,z)},aCab,aItens,3) //Inclusao
	
	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
		Return
	Else 
		Aviso("Atencao","Gerado a Movimento Interno. Doc "+SD3->D3_DOC+CHR(13)+CHR(10)+"Em seguida sera feito o Endereçamento... ",{"Ok"})
		_lOK := .T.
	EndIf
EndIf

aCab 		:= {}  
aItens	:= {}

If _lOK
	
	Pergunte(cPerg,.F.)
	_cDocSD3 := SD3->D3_DOC

	dbSelectArea("SDA")
	dbSetOrder(2)
	dbSeek(xFilial("SDA")+_cDocSD3)
	While !Eof() .And. SDA->DA_DOC == _cDocSD3

		_nRegSDA := Recno()
		
		dbSelectArea("SD3")
		dbSetOrder(8)
		dbSeek(SDA->(DA_FILIAL+DA_DOC+DA_NUMSEQ))
		
		_cEnder := Alltrim(SD3->D3_XMOTIVO)
		_cEnder := If(!Empty(_cEnder),_cEnder,BscEndNF(Mv_Par01, Mv_Par02, Mv_Par03, SDA->DA_PRODUTO, SDA->DA_QTDORI))
		
		IncProc("Enderecando produto "+SDA->DA_PRODUTO+"...")
		cItem := Item(SDA->DA_LOCAL,SDA->DA_NUMSEQ,SDA->DA_PRODUTO)
		
		aCAB  := {	{"DA_PRODUTO",SDA->DA_PRODUTO 	, nil},;
						{"DA_LOCAL"  ,SDA->DA_LOCAL 		, nil},;
						{"DA_NUMSEQ" ,SDA->DA_NUMSEQ		, nil},;
						{"DA_DOC"    ,SDA->DA_DOC 			, nil}}
		
		aITENS:= {{	{"DB_ITEM"   ,cItem          	, nil},;
						{"DB_LOCALIZ",_cEnder			, nil},;
						{"DB_QUANT"  ,SDA->DA_SALDO 	, nil},;
						{"DB_DATA"   ,SDA->DA_DATA 	, nil}}}     
		
		lMSHelpAuto := .T.
		lMSErroAuto := .F.
		msExecAuto({|x,y|mata265(x,y)},aCab,aItens)
		lMSHelpAuto := .F.
		If lMSErroAuto
			Aviso("Atencao","Erro ao Endereçar o Movimento Interno. Doc "+SD3->D3_DOC,{"Ok"})
			MostraErro()
			Exit
		EndIf
		
		dbSelectArea("SDA")
		dbSetOrder(2)
		dbGoto(_nRegSDA)
		dbSkip()
	EndDo
EndIf
Aviso("Finalizdo","Rotina finalizada, favor verificar o Doc "+SD3->D3_DOC,{"Ok"})
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³   Ietm   ºAutor  ³Microsiga           º Data ³  29/10/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca o Proximo Item a Enderecar                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BIO2                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Item(cLocal,cNumSeq,cProduto)
Local cItem     := ""
SDB->(DbSetOrder(1))
If SDB->(MsSeek(xFilial("SDB")+cProduto+cLocal+cNumSeq))
	While SDB->(!EOF() .and. xFilial("SDB")+cProduto+cLocal+cNumSeq ==;
		DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ)
		cItem := SDB->DB_ITEM
		SDB->(dbSkip())
	Enddo
	cItem := StrZero(val(cItem)+1,4)
Else
	cItem := "0001"
EndIf

Return cItem

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BscEndNF ºAutor  ³Microsiga           º Data ³  29/10/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca o Endereco da Nota de Entrada                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BIO2                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BscEndNF(cNota, cSerie, nTipo, cProduto, nQtdOri)

Local _cQuery 
Local _cRet := ""

If nTipo == 1
	_cQuery := " SELECT D1_ENDER "
	_cQuery += " FROM "+RetSqlName("SD1")
	_cQuery += " WHERE D1_FILIAL = '"+xFilial("SD1")+"' "
	_cQuery += " AND D1_DOC = '"+cNota+"' "  
	_cQuery += " AND D1_SERIE = '"+cSerie+"' "  
	_cQuery += " AND D1_COD = '"+cProduto+"' "  
	_cQuery += " AND D1_QUANT = '"+AllTrim(Str(nQtdOri,12,0))+"' "
	_cQuery += " AND D_E_L_E_T_ = ' '"

	_cQuery := ChangeQuery(_cQuery)
	MEMOWRIT( "BACASD3.SQL", _cQuery )

	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'QUERY', .F., .T.)
	
	dbSelectArea("QUERY")
	dbGotop()
	While !Eof()
		_cRet := QUERY->D1_ENDER
		dbSkip()
	EndDo
	dbCloseArea()
EndIf

Return(_cRet)	