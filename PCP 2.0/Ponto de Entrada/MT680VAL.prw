#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT680VAL ºAutor  ³Raphael Camillo-Demaº Data ³  07/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para validacao do Saldo do PI no SB8 para evitar que o  º±±
±±º          ³ sistema pegue Lotes diferente da OP.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ORTOSINTESE                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT680VAL()

// Nova Validacao: Nao Permitir apontamento da OP com Quantidade Maior que a Tolerancia de Ganho - Tabela SZ4 - Dema - 16/09/2015
// Nova Validacao: Quando o Tipo da Operacao for 01, obrigario informa H6_XOBS e H6_RECURSO for ALM01 - Dema - 16/09/2015
// Nova Validacao: Quando Produto Esteril ou nao Esteril automatizar a Validade do Lote - Dema - 16/09/2015
// Nova Validacao: Checar se o Usuário Loga está amarrado ao Centro de Custo, se nao estiver nao permite apomtamento - Dema - 18/03/2016 - Tabela de Amarracao: PA1
// Novo Item     : Foin incluido um excauto para gravar a quantidade de rótulos a serem impresso. Por Samuel Miranda 28/11/2025

Local _lRet 	:= .T.
Local _aArea	:= GetArea()
Local _aAreaB1	:= SB1->(GetArea())
Local _aAreaB8	:= SB8->(GetArea())
Local _aAreaC2  := SC2->(GetArea())
Local _aAreaH1  := SH1->(GetArea())
Local _aAreaD4  := SD4->(GetArea())
Local _aAreaB2  := SB2->(GetArea())
Local _aAreaDC  := SDC->(GetArea())

Local lAlteraEmp := .F. // Variavel para controlar se altera o Empenho do Produto no Lote - Cesar Arneiro - 03/10/2025
Local _cXNumOP    := "" // Numero da OP
Local _cXItem     := "" // Item OP
Local _cXSeque    := "" // Sequencia OP

_cOP    := M->H6_OP
_cLote  := M->H6_LOTECTL
_nQuat  := M->H6_QTDPROD
_nPerda := M->H6_QTDPERD
_cProd  := M->H6_PRODUTO
_cPT    := M->H6_PT

//Ajusta a data de validade
DbSelectArea("SB1")
SB1->(DbSetOrder(1))

If SB1->(dbSeek(xFilial("SB1")+M->H6_PRODUTO)) 
	M->H6_DTVALID := YearSum(LastDay(dDataBase), Iif(AllTrim(SB1->B1_XSTERI) == "1", 5, 10))  
EndIf
dbSelectArea("SH1")
dbSetOrder(1)
dbSeek(xFilial("SH1")+M->H6_RECURSO)

dbSelectArea("PA1")
dbSetOrder(1)
If dbSeek(xFilial("PA1")+__cUserID) 
	If !(AllTrim(SH1->H1_CCUSTO) $ PA1_CCUSTO) .And. AllTrim(PA1_CCUSTO) <> "TODOS"
		Alert("Usuário não pertence ao Centro de Custo Informado no Apontamento -- IMPOSSIVEL CONTINUAR")
		RestArea(_aAreaH1)
		RestArea(_aArea)
		Return(.F.)
	EndIf
EndIf

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial("SD4")+_cOP)
While !Eof() .And. SD4->D4_FILIAL == xFilial("SD4") .And. SD4->D4_OP == _cOP
  
	// ALTERADO POR MAURICIO 06/06/2017. NA TABELA SD4 O LOTE ESTAVA EM BRANCO. COMECOU A TROCAR OS LOTES.
	// ALTERADO POR MAURICIO 17/11/2017. INCLUIDO SD4->D4_QUANT == 0 POIS NAO ESTAVA DEIXANDO APONTAR PI QUE USOU ROTINA DE BN	 
  	If SD4->D4_QUANT == 0 .And. Empty(SD4->D4_LOTECTL)
  	   dbSkip()
  	   Loop
  	EndIf
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+SD4->D4_COD) .And. SB1->B1_TIPO == "PI" .And. SD4->D4_LOCAL != "96"
		_cUmProd := SB1->B1_UM
		dbSelectArea("SB8")
		dbSetOrder(3)
		_cLoteD4 := IIF(Empty(SD4->D4_LOTECTL),_cLote,SD4->D4_LOTECTL)
		If dbSeek(xFilial("SB8")+SD4->D4_COD+SD4->D4_LOCAL+_cLoteD4) // Era _cLote, porem se mudar o Lote na Hora do empenho da erro pois nao havera saldo e da erro - DEMA 05/07/2017
			If SB8->B8_SALDO < _nQuat //  ALTERADO MAURICIO 15/07/14  //SD4->D4_QTDEORI PARA _nQuat. ESTA DANDO PROBLEMA QUANTO A OP TINHA PERDA.SB8->B8_SALDO-SB8->B8_EMPENHO ALTERADO PARA SB8->B8_SALDO
				
				If SD4->D4_QUANT > 0 // ALTERADO MAURICIO 10/12/2020 PARA NÃO VERIFICAR QUANDO O EMPENHO DO PI ESTA ZERADO. FOI ZERADO PELA ROTINA DE BENFICIAMENTO
					Aviso("Atencao!!!","Produto "+Alltrim(SD4->D4_COD)+" sem Saldo no Lote "+_cLoteD4,{"OK"},1)
					_lRet := .F.
					lAlteraEmp := .T. // Se nao tiver saldo, nao altera o empenho - Cesar Arneiro - 03/10/2025
				EndIf
				//_lRet := .T.  // ALTERADO MAURICIO 28/10/21 DAVA A MENSAGEM, MAS SE SAISSE POR SALVAR, APONTAVA A OP.
			EndIf
			
			// Eliminei o Else e coloquei o lAlteraEmp na condição do If, para garantir que só vai alterar o empenho se tiver saldo e se o empenho ainda não tiver sido utilizado - Cesar Arneiro - 03/10/2025
			If !lAlteraEmp .And. Empty(SD4->D4_LOTECTL)
				dbSelectArea("SD4")
				RecLock("SD4",.F.)
				SD4->D4_LOTECTL := _cLote
			
				MsUnlock()
				
				dbSelectArea("SB8")
				RecLock("SB8",.F.)
				SB8->B8_EMPENHO += SD4->D4_QUANT	// Era D4_QTDORI, troquei para D4_QUANT, para empenhar apenas o saldo do empenho no lote - Cesar Arneiro - 03/10/2025
				MsUnlock()
				
				dbSelectArea("SB2")
				dbSetOrder(1)
				If dbSeek(xFilial("SB2")+SD4->D4_COD+SD4->D4_LOCAL)
					//RecLock("SB2",.F.)	// Comentado por Cesar Arneiro - 03/10/2025 - Não precisa aumentar o empenho do produto na SB2, pois o material já estava empenhado
					//SB2->B2_QEMP += SD4->D4_QTDEORI
					//MsUnlock()
				EndIf					
			EndIf		
		 Else
			Aviso("Atencao!!!","Produto "+Alltrim(SD4->D4_COD)+" sem Saldo no Lote "+_cLoteD4,{"OK"},1)
			_lRet := .F.
			
		EndIf
	EndIf

	dbSelectArea("SD4")
	dbSkip()
EndDo

If dbSeek(xFilial("SB1")+M->H6_PRODUTO) .And. SB1->B1_TIPO $ "PA/PI" .And. LEN(ALLTRIM(M->H6_LOTECTL))==7   
	If AllTrim(SB1->B1_XSTERI) <> "1"
		M->H6_DTVALID := YearSum(LastDay(dDataBase), 10)//Ctod("31/12/49")
	/* 18/12/2018 - RETIRADO POR MAURICIO DEVIDO A PROBLEMA DE DIVERGENCIA VALIDADE SISTEMA X VALIDADE ROTULO. O USUARIO IRA INFORMAR A VALIDADE MANUAL
	Else
		M->H6_DTVALID := (dDataBase+1)+(365*5)   
	*/	
	EndIf
EndIf

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±| Adiocinado por: Samuel Miranda               - 28/11/2025  |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±³Descrição | Gravar a quantidade de Rótulos a serem impresso |±±												
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//Adiocinado por Samuel Miranda - 28/11/2025 - Para gravar a quantidade de Rótulos a serem impresso.
If _lRet  
	//Forço a gravação somento no produto PA
	_cXNumOP    := (SubStr(_cOP,1,6)) // Numero da OP
	_cXItem     := (SubStr(_cOP,7,2)) // Item OP
	_cXSeque    := "001" // (SubStr(_cOP,9,3)) // Sequencia OP                                   
	DbSelectArea("SC2")
	DbSetOrder(1)
	if Alltrim(_cOp) == _cXNumOP + _cXItem + _cXSeque
		//If dbSeek(xFilial("SC2")+(Substr(_cOP,1,8)+'001'))
		If MsSeek(xFilial("SC2")+ _cXNumOP + _cXItem + _cXSeque)
			//If dbSeek(xFilial("SC2")+_cOP)
			// Posiciona na OP para gravar a quantidade apontada.
			RecLock("SC2",.F.)
			SC2->C2_XQTDROT := CValToChar(_nQuat)
			MsUnLock()
		EndIf
	EndIf
EndIf
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
RestArea(_aAreaB2)
RestArea(_aAreaD4)
RestArea(_aAreaH1)
RestArea(_aAreaC2)
RestArea(_aAreaB8)
RestArea(_aAreaB1)
RestArea(_aAreaDC)
RestArea(_aArea)

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Funcao   ³xBscFatDB ºAutor  ³Raphael Camillo-Demaº Data ³  21/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca Faturamento de produto BN da OP e Seu respectivo     º±±
±±º          ³ Retorno - Busca Tambem Faturamento do Servido              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ORTOSINTESE                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xBscFatDB( _cOp, _cProd, _cLote) 

Local _aArea	:= GetArea()
Local _lRet 	:= .T.
Local _cQuery 	:= ""
Local _lTemFat := .F.   
Local _lTemRet := .F.

Local _cNota	:= ""
Local _cSerie	:= ""
Local _cTipo	:= ""
Local _cCliente:= ""
Local _cLoja	:= ""
Local _nQuant	:= 0

_cQuery := " SELECT D4_COD, D4_OP, D4_LOTECTL, D4_QUANT, D4_QTDEORI, D4_DATA, DC_PEDIDO, C5_NOTA, C5_SERIE, C5_CLIENTE, C5_LOJACLI, C5_TIPO "
_cQuery += " FROM "+RetSqlName("SD4")+" D4 "
_cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = D4_COD AND B1.D_E_L_E_T_ = ' ' AND B1_TIPO = 'BN' "
_cQuery += " INNER JOIN "+RetSqlName("SDC")+" DC ON DC_FILIAL = D4_FILIAL AND DC_PRODUTO = D4_COD AND DC_LOTECTL = D4_LOTECTL AND DC_LOCAL = D4_LOCAL AND DC_OP = D4_OP AND DC.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C5_FILIAL = D4_FILIAL AND C5_NUM = DC_PEDIDO AND C5.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN "+RetSqlName("SC6")+" C6 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6.D_E_L_E_T_ = ' ' AND C6_PRODUTO = D4_COD AND C6_LOTECTL = D4_LOTECTL AND C6_QTDVEN = D4_QTDEORI "
_cQuery += " WHERE D4_FILIAL = '"+xFilial("SD4")+"' AND D4_OP = '"+_cOp+"' AND D4_COD = '"+_cProd+"' AND D4.D_E_L_E_T_ = ' ' AND D4_LOTECTL = '"+_cLote+"' "

_cQuery := ChangeQuery( _cQuery )

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)

dbSelectArea("QUERY")
dbGotop()
While !Eof() 
	If !Empty(QUERY->C5_NOTA)	
		_cNota	:= QUERY->C5_NOTA
		_cSerie	:= QUERY->C5_SERIE
		_cTipo	:= QUERY->C5_TIPO
		_cCliente:= QUERY->C5_CLIENTE
		_cLoja	:= QUERY->C5_LOJACLI
		_nQuant	:= QUERY->D4_QTDEORI
		
		_lTemFat  := .T. 
		Exit
	EndIf
	dbSkip()
EndDo
     
dbCloseArea()

If !Empty(_cNota)
	_cQuery := " SELECT SUM(D1_QUANT) AS D1_QUANT "
	_cQuery += " FROM " + RetSqlName("SD1") + " D1 "
	_cQuery += " WHERE D1_FILIAL = '"+xFilial("SD1")+"' AND D1_NFORI = '"+_cNota+"' AND D1_SERIORI = '"+_cSerie+"' "
	_cQuery += " AND D1_FORNECE = '"+_cCliente+"' AND D1_LOJA = '"+_cLoja+"' AND D1.D_E_L_E_T_ = ' ' "
	_cQuery += " AND D1_COD = '"+_cProd+"' AND D1_LOTECTL = '"+_cLote+"' AND D1_OP = '"+_cOp+"' "


	_cQuery := ChangeQuery( _cQuery )

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)

	dbSelectArea("QUERY")
	dbGotop()
	While !Eof()
		If _nQuant >= QUERY->D1_QUANT .And. QUERY->D1_QUANT > 0   // MAURICIO PARA ACEITAR QUANTIDADE MENOR QUE O EMPENHO NOTAS DE DEVOLUCAO DE MATERIA PRIMA PARCIAL
			_lTemRet := .T.
			Exit
		Endif
		dbSkip()
	EndDo

	dbCloseArea()
EndIf
                                
If _lTemFat <> _lTemRet .And. GETMV("MV_XMT680V")  // MAURICIO INCLUIDO PARA DESTRAVAR ROTINA
	_lRet := .F.
ElseIf _lTemFat .And. _lTemRet
	_lRet := .T.
ElseIf _lTemFat .And. GETMV("MV_XMT680V") // Parametro criado para Ativa ou desativar trava (.T. ou .F.)
	_lRet := .F.
	//Caso tenha Remessa e Retorno, Verifica se o Servico ja foi faturado.
	//Caso nao tenha sido faturado ainda nao permite encerrar a OP

	_cQuery := " SELECT D1_QUANT "
	_cQuery += " FROM " + RetSqlName("SD1") + " D1 "
	_cQuery += " INNER JOIN "+RetSqlName("SF4")+" F4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND F4_CODIGO = D1_TES AND F4.D_E_L_E_T_ = ' ' AND F4_DUPLIC = 'S' "
	_cQuery += " WHERE D1_FILIAL = '"+xFilial("SD1")+"' AND D1_OP = '"+_cOP+"' AND D1.D_E_L_E_T_ = ' ' "

	_cQuery := ChangeQuery( _cQuery )

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)

	dbSelectArea("QUERY")
	dbGotop()
	While !Eof()
		_lRet := .T.
		dbSkip()
	EndDo

	dbCloseArea()
EndIf

RestArea(_aArea)
Return(_lRet)
