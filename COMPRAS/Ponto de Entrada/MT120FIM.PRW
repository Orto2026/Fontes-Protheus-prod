#INCLUDE 'PROTHEUS.CH'

/*/------------------------------------------------------------------------------//
 {Protheus.doc} MT120FIM

LOCALIZAÇÃO: O ponto se encontra no final da função A120PEDIDO

@sample	Nenhum		
@return	Nenhum
@author	Raphael - Dema
@since		13/11/2018
@version	12.0

//------------------------------------------------------------------------------/*/
User Function MT120FIM()

Local nOpcao		:= PARAMIXB[1]	// Opção Escolhida pelo usuario 
Local ca120num		:= PARAMIXB[2]	// Numero do Pedido de Compras
Local nOpcA			:= PARAMIXB[3]	// Indica se a ação foi Cancelada = 0  ou Confirmada = 1

LOCAL aArea			:= GetArea()
LOCAL aAreaSC7		:= SC7->( GetArea() )
LOCAL aAreaSC2		:= SC2->( GetArea() ) 
LOCAL aAreaSD4		:= SD4->( GetArea() )
LOCAL aItens		:= {}
LOCAL aCabec		:= {}
Local aLinha		:= {}
Local _cItem		:= ""
Local _cProduto	:= ""
Local _cLote		:= ""
Local _cLocal		:= ""
Local _cPedido		:= ""
Local _cTes			:= ""
Local _nPreco		:= 0
Local _nValor		:= 0

If nOpcA == 1 .And. ( nOpcao == 3 .Or. nOpcao == 9 )

	_cItem := StrZero(0, Len(SC6->C6_ITEM) )

	DbSelectArea("SC7")
	dbSetOrder(1)
	If dbSeek(xFilial("SC7")+ca120num) .And. SC7->C7_XPV == "S"
		While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+ca120num
	
			aLinha 		:= {}
			_cItem 		:= Soma1(_cItem, Len(SC6->C6_ITEM) )
			//_cProduto	:= Posicione("SC2",1,xFilial("SC2")+SC7->C7_OP,"C2_PRODUTO")
			_cProduto	:= Posicione("SD4",2,xFilial("SD4")+SC7->C7_OP,"D4_COD")
			_cLote		:= Posicione("SC2",1,xFilial("SC2")+SC7->C7_OP,"C2_LOTECTL")
			_cLocal		:= Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_LOCPAD")
			
			_nPreco		:= Posicione("DA1",1,xFIlial("DA1")+Padr("007",Len(SC5->C5_TABELA))+_cProduto,"DA1_PRCVEN")
			If _nPreco == 0
				_nPreco := 1
			EndIf

			_nValor		:= Round( (_nPreco*SC7->C7_QUANT),2)

			_cTes 		:= MaTesInt( 2, "06", SC7->C7_FORNECE, SC7->C7_LOJA, "F", _cProduto, , "F" )			
			If Empty(_cTes)
				_cTes := "700"
			EndIf
				
			aAdd(aLinha,{"C6_FILIAL" 	, cFilAnt			,Nil})
			aAdd(aLinha,{"C6_ITEM"   	, _cItem				,Nil})
			aAdd(aLinha,{"C6_PRODUTO"	, _cProduto			,Nil})
			aAdd(aLinha,{"C6_LOCAL"  	, _cLocal			,Nil})
			aAdd(aLinha,{"C6_OPER"  	, "06"				,Nil})
			aAdd(aLinha,{"C6_QTDVEN" 	, SC7->C7_QUANT	,Nil})
			aAdd(aLinha,{"C6_PRCVEN" 	, _nPreco			,Nil})
			aAdd(aLinha,{"C6_VALOR" 	, _nValor			,Nil})
			aAdd(aLinha,{"C6_TES" 		, _cTes				,Nil})
//			aAdd(aLinha,{"C6_QTDLIB" 	, SC7->C7_QUANT	,Nil})
//			If Rastro(_cProduto, "L")
//				aAdd(aLinha,{"C6_LOTECTL" , _cLote		,Nil})
//			EndIf
		 	
			aAdd(aItens,aLinha)
	         
			dbSelectArea("SC7")
			DbSkip()
		EndDo
	
		If Len(aItens) > 0
			
	   DbSelectArea("SC7")
	   dbSetOrder(1)
	   dbSeek(xFilial("SC7")+ca120num)      
	
			_cPedido:= GetSxeNum("SC5","C5_NUM")
			RollBackSxE()
			
			aAdd(aCabec,{"C5_FILIAL" 	, cFilAnt			,Nil})
			aAdd(aCabec,{"C5_NUM"   	, _cPedido			,Nil})
			aAdd(aCabec,{"C5_TIPO" 		, "B"					,Nil})
			aAdd(aCabec,{"C5_CLIENTE"	, SC7->C7_FORNECE	,Nil})
			aAdd(aCabec,{"C5_CLIENT"	, SC7->C7_FORNECE	,Nil})
			aAdd(aCabec,{"C5_LOJACLI"	, SC7->C7_LOJA		,Nil})
			aAdd(aCabec,{"C5_LOJAENT"	, SC7->C7_LOJA		,Nil})
			aAdd(aCabec,{"C5_CONDPAG"	, "001"				,Nil})   
			aAdd(aCabec,{"C5_TABELA"	, "007"				,Nil})   
			aAdd(aCabec,{"C5_XOPER" 	, "06"				,Nil})   
			aAdd(aCabec,{"C5_XMODFR"	, "4"					,Nil})   
			aAdd(aCabec,{"C5_CLASPED"	, "5"					,Nil})   
			aAdd(aCabec,{"C5_XMOEDA"	, "1"					,Nil})   
			aAdd(aCabec,{"C5_VEND1"		, "000001"			,Nil})   
			aAdd(aCabec,{"C5_XDTENTR"	, dDataBase			,Nil})   
				
			lMsErroAuto := .F.
			lMsHelpAuto := .F.
			Begin Transaction
				
				MsAguarde( {|| MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItens,3) }, "Criando PV - "+_cPedido )
							
				If lMsErroAuto
					MostraErro()
					RollBackSxE()
					DisarmTransaction()
				Else
					ConfirmSX8()
					dbCommitAll()
				EndIf
				aCabec	:= {}
				aItens	:= {}
			End Transaction
		EndIf
	EndIf
EndIf		

RestArea(aAreaSC2)
RestArea(aAreaSC7)
RestArea(aAreaSD4)
RestArea(aArea)

Return