#INCLUDE "Protheus.CH"
#INCLUDE "TopConn.CH"
#INCLUDE "RwMake.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BACA002  ºAutor  ³Microsiga           º Data ³  01/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Baca Para Quebrar o SC9 em 02 Registros, sendo o 1o com a  º±±
±±º          ³ Qtde disponivel no estoque e o 2o com o saldo Restante     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ORTOSINTESE                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BACA002()

Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo	:= "Nova Liberação do Estoque - Automática"
Local aRegs		:= {}
Local cPerg		:= "BACA002"

Private cDesc1	:= "Este programa irá efetuar a liberação do estoque dos protdutos bloqueados  "
Private cDesc2	:= "conforme saldo em estoque - (Liberação Parcial) "
Private cDesc3	:= " "
Private cDesc4	:= " "
Private cDesc5	:= " "
Private lEnd 	:= .F.

Public lEnt450QRY 	:= .F. // Variavel Publica para Ser Usada no PE MT450QRY -- Não Excluir jamais - Dema - 05/07/2017
Public _cAtuCont 		:= Space(2)
Public _cCodCliOrto	:= Space(6)

aAdd(aRegs,{cPerg,"01","Pedido Inicial     ?","","","mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Pedido Final       ?","","","mv_ch2","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Cliente Ininial    ?","","","mv_ch3","C",06,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Cliente Final      ?","","","mv_ch4","C",06,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Entrega Inicial    ?","","","mv_ch5","D",08,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Entrega Final      ?","","","mv_ch6","D",08,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

aAdd(aRegs,{cPerg,"07","Armazem a Liberar   ?","","","mv_ch7","C",02,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Exceto Clientes     ?","","","mv_ch8","C",70,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aRegs, cPerg)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )

aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch()            } } )
aAdd( aButton, { 5, .T., { || Pergunte("BACA002",.T.) } } )

FormBatch( cTitulo, aSay, aButton )

If nOpc == 1
	Pergunte("BACA002",.F.)
	Processa({|lEnd| ProcLibEst(@lEnd)},"Efetuando Liberação, aguarde...")
Endif	

Return()


Static Function ProcLibEst()

Local nX     		:= 0
Local aArray		:= {}
Local cDoc			:= ""
Local cQuery		:= ""
Local aCabEnd		:= {}
Local aItensEnd	:= {}
Local nNewQtd1		:= 0
Local nNewQtd2		:= 0
Local aCampos 		:= {}
Local _nCount

lMsErroAuto		:= .F.

cQuery := " SELECT C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_PRODUTO, C9_LOCAL, C9_QTDLIB, C9_SEQUEN, C9.R_E_C_N_O_ AS REG "
cQuery += " FROM "+RetSqlName("SC9")+" C9 "
cQuery += " INNER JOIN "+RetSqlName("SB2")+" B2 ON B2_FILIAL = C9_FILIAL AND B2_COD = C9_PRODUTO AND B2_LOCAL = C9_LOCAL AND B2.D_E_L_E_T_ = ' ' AND (B2_QATU-B2_RESERVA) > 0 "
cQuery += " WHERE C9_FILIAL = '"+xFilial("SC9")+"' "
cQuery += " AND C9_PEDIDO BETWEEN '"+Mv_Par01+"' AND '"+Mv_Par02+"' "
cQuery += " AND C9_CLIENTE BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"' "
cQuery += " AND C9_BLCRED = ' ' "
cQuery += " AND C9_BLEST NOT IN ('10',' ') "
cQuery += " AND C9.D_E_L_E_T_ = ' ' "
cQuery += " AND (C9_XENTREG = '       ' OR C9_XENTREG BETWEEN '"+Dtos(Mv_Par05)+"' AND '"+Dtos(Mv_Par06)+"') "

If !Empty(Mv_Par07)
	cQuery += " AND C9_LOCAL = '"+Mv_Par07+"' "
EndIf

If !Empty(Mv_Par08)
	_cClientes := AllTrim(Mv_Par08)
	_cClientes := StrTran(_cClientes,",","','")
	_cClientes := StrTran(_cClientes,"/","','")
	_cClientes := StrTran(_cClientes,"-","','")
	_cClientes := StrTran(_cClientes,";","','")
	_cClientes := StrTran(_cClientes,".","','")

	cQuery += " AND C9_CLIENTE NOT IN ('"+_cClientes+"') "
EndIf

cQuery += " ORDER BY C9_FILIAL, C9_XENTREG, C9_PEDIDO, C9_ITEM "

ChangeQuery( cQuery )

MemoWrite("BACA002.SQL",cQuery)

If Select("QUERY") > 0
	dbCloseArea()
EndIf 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QUERY",.T.,.T.)

dbSelectArea("QUERY")
dbGotop()
While !Eof()

	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(QUERY->(C9_FILIAL+C9_PRODUTO+C9_LOCAL))
	
	If QUERY->C9_QTDLIB <= (SB2->B2_QATU-SB2->B2_RESERVA-SB2->B2_QACLASS-SB2->B2_QEMP)
		xLibPed("SC9",QUERY->REG, QUERY->C9_PEDIDO)
	ElseIf QUERY->C9_QTDLIB > (SB2->B2_QATU-SB2->B2_RESERVA-SB2->B2_QACLASS-SB2->B2_QEMP) .And. (SB2->B2_QATU-SB2->B2_RESERVA-SB2->B2_QACLASS-SB2->B2_QEMP) <> 0
		nNewQtd1		:= (SB2->B2_QATU-SB2->B2_RESERVA-SB2->B2_QACLASS) // Nova Qtde a Liberar
		nNewQtd2		:= QUERY->C9_QTDLIB - nNewQtd1 // Novo Saldo Bloqueado
		_cSeqC9		:= xBscMaxSeq(QUERY->C9_FILIAL, QUERY->C9_PEDIDO, QUERY->C9_ITEM)  //Soma1(QUERY->C9_SEQUEN)
		                                                                  
		dbSelectArea("SC9")
		dbGoto(QUERY->REG)
	
		aCampos := {}
		For _nCount := 1 TO FCOUNT()
			AADD(aCampos, { FIELDNAME(_nCount), FIELDGET(_nCount) } )
		Next

		Begin Transaction
		RecLock("SC9",.T.)
		SC9->C9_SEQUEN := _cSeqC9
		SC9->C9_QTDLIB := nNewQtd2
		For _nCount := 1 TO LEN(aCampos)
			nPos := FIELDPOS(aCampos[_nCount,1])
			If nPos > 0 .And. !(AllTrim(aCampos[_nCount,1]) $ "C9_SEQUEN/C9_QTDLIB")
				FIELDPUT(nPos,aCampos[_nCount,2])
			EndIf
		Next
		MsUnlock()
      End Transaction 
      
		dbGoto(QUERY->REG)
		RecLock("SC9",.F.)
		SC9->C9_QTDLIB := nNewQtd1
		MsUnlock()
		
		xLibPed("SC9",QUERY->REG, QUERY->C9_PEDIDO)

	EndIf
	
	dbSelectARea("QUERY")
	dbSkip()

EndDo

dbSelectARea("QUERY")
dbCloseArea()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ xLibPed  ºAutor  ³Microsiga           º Data ³  01/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Chama a rotina de liberacao Automatica do estoque apos a   º±±
±±º          ³ Duplicacao da Linha do SC9                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ORTOSINTESE                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xLibPed(cAlias, nReg, cPedido)

nOpcA := 1

Pergunte("LIBAT2",.F.)

dbSelectArea(cAlias)
dbSetOrder(1)

MV_PAR01 := cPedido
MV_PAR02 := cPedido
MV_PAR03 := "      "
MV_PAR04 := "ZZZZZZ"
MV_PAR05 := Ctod("01/01/01")
MV_PAR06 := Ctod("31/12/49")
MV_PAR07 := 1

Processa({|lEnd| Ma450Processa("SC9",.F.,.T.,@lEnd,Nil,MV_PAR07==2)},,,.T.)    

Return(.T.)

Static Function xBscMaxSeq(_cFilial, _cPedido, _cItem)
Local _cRet		:= QUERY->C9_SEQUEN
Local _cQuery 	:= ""
Local _cArea	:= Alias()

_cQuery := " SELECT MAX(C9_SEQUEN) SEQ "
_cQuery += " FROM "+RetSqlName("SC9")+" C9 "
_cQuery += " WHERE C9_FILIAL = '"+_cFilial+"' "
_cQuery += " AND C9_PEDIDO = '"+_cPedido+"' " 
_cQuery += " AND C9_ITEM = '"+_cItem+"' "
_cQuery += " AND C9.D_E_L_E_T_ = ' ' "

ChangeQuery( _cQuery )

MemoWrite("BACA002A.SQL",_cQuery)

If Select("TRB1") > 0
	dbCloseArea()
EndIf 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB1",.T.,.T.)

dbSelectArea("TRB1")
dbGotop()
While !Eof()
	_cRet := TRB1->SEQ
	dbSkip()
EndDo

dbCloseArea()
_cRet := Soma1(_cRet)

dbSelectArea(_cArea)

Return(_cRet)