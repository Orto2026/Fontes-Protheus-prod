#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'TOPCONN.CH'
#INCLUDE "PROTHEUS.CH"

Static cLocProc := SuperGetMV("MV_XLCCONSU",.F.,"11")
Static cLocDest	:= ""
Static cEndDest	:= ""
Static lSimula	:= .F.
Static lExibMsg := .T.
Static cId		:= ""
STATIC aErro	:= {}
//Habilita a tecla F12 para que o usuário ative e desative a simulação
//SetKey( VK_F12, { || MsgInfo( Iif(lSimula, "Simulação desabilitada, as informações SERÃO efetivadas.", "Simulação habilitada, as informações NÃO SERÃO efetivadas.") ), lSimula := !lSimula } )

//Habilita a tecla F11 para que o usuário ative e desative a exibição de mensagens
//SetKey( VK_F11, { || MsgInfo( Iif(lExibMsg, "Exibição de mensagens desabilitada.", "Exibição de mensagens habilitada.") ), lExibMsg := !lExibMsg } )

/*/{Protheus.doc} ORTF0004
//TODO Rotina de processamento do Empenho de OP Automatico e Transferência.
@author Pirolo
@since 04/04/2019
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function ORTF0004()
Local cQry		:= ""
Local cTMPAlia	:= GetNextAlias()
Local aEmpenho	:= {}

//RpcSetType(3)
//RpcSetEnv("01", "01")

cLocProc	:= SuperGetMV("MV_XLCCONSU",.F.,"10")
cLocDest	:= SuperGetMV("MV_XLCDESTI",.F.,"97")
cEndDest	:= SuperGetMV("MV_XENDDEST",.F.,"FABRICA")

//Solicita os filtro de processamento
If Pergunte("AUTOEMPENH", .T.)
	cQry := MontaQuery(MV_PAR01, MV_PAR02, MV_PAR03, MV_PAR04, MV_PAR05)
	
	//Zera a variavel de ID do Processamento
	cId	 := ""
	
	//Executa a query
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTMPAlia,.T.,.T.)
	
	//Se retornou dados, efetua analise
	If (cTMPAlia)->(Eof())
		MsgAlert("Não foram encontrados empenhos com as condições informadas.", "Empenhos não encontrados.")
	Else

		//Analisa empenhos
		Processa( {|| aEmpenho := U_AnEmpAut(cTMPAlia) }, "Aguarde...", "Analisando empenhos pendentes...",.F.)
				
		//Gera Relatório de Processamento
		If !Empty(aEmpenho)
			Processa( {|| U_RORTF005(cId) }, "Aguarde...", "Efetuando os empenhos possiveis...",.F.)
		Else
			MsgAlert("Nenhum item processado", "Alerta")
		EndIf
		
	EndIf
	
	//Fecha o Alias
	(cTMPAlia)->(DbCloseArea())
EndIf

Return

/*/{Protheus.doc} MontaQuery
//TODO Monta a string da query com as OPs a serem processadas.
@author Bruno
@since 04/04/2019
@version undefined
@return return, return_description
/*/
Static Function MontaQuery(dDataDe, dDataAte, cOpDe, cProdDe, cProdAte)
Local cQry	:= ""
Local cCond	:= ""

cQry	:= "SELECT B.*, B.R_E_C_N_O_ AS RECN								"+CRLF 
cQry	+= "FROM "+RetSqlName("SC2")+" A									"+CRLF					
cQry	+= "		INNER JOIN "+RetSqlName("SD4")+" B						"+CRLF
cQry	+= "			ON(    B.D4_FILIAL	= A.C2_FILIAL					"+CRLF
cQry	+= "			   AND B.D4_OP		= A.C2_NUM+A.C2_ITEM+C2_SEQUEN	"+CRLF
cQry	+= "			   AND A.D_E_L_E_T_	= ' '							"+CRLF
cQry	+= "			   AND B.D_E_L_E_T_	= ' ')							"+CRLF
cQry	+= "WHERE	A.C2_FILIAL   = '"+xFilial("SC2")+"'					"+CRLF
cQry	+= "AND		A.C2_DATRF 	  = ''										"+CRLF
cQry	+= "AND		A.C2_XGEREMP  = 'S'										"+CRLF
//cQry	+= "AND		A.C2_EMISSAO >= '20180101'								"+CRLF
//cQry	+= "AND		A.C2_EMISSAO <= '20190101'								"+CRLF
//cQry	+= "AND		B.D4_QUANT    < B.D4_QTDEORI							"+CRLF
cQry	+= "AND		B.D4_LOTECTL  = ' '										"+CRLF
//cQry	+= "AND		B.D4_OP       = '25715701001   '						"+CRLF
//Adiciona Filtro por data de empenho
If !Empty(dDataDe)
	cQry	+= "AND		B.D4_DATA >= '"+Dtos(dDataDe)+"' "+CRLF
EndIf
If !Empty(dDataAte)
	cQry	+= "AND		B.D4_DATA <= '"+Dtos(dDataAte)+"' "+CRLF
EndIf

//Adiciona filtro por OP
//cCond	:= "AND		B.D4_OP = '"+cOpDe+"' "+CRLF

//Para teste.
/*
cCond := "AND B.D4_OP IN "
cCond += "('26725201001', '26725701001', '26734801001', '26734901001', '26735701001', '26736901001', '26737201001', '26755101001', '26758201001', '26765101001', "+CRLF
cCond += "'26767901004', '26772701001', '26808801001', '26825001001', '26825101001', '26825201001', '26857201001', '26858801001', '26862401001', '26862601001',  "+CRLF
cCond += "'26862701001', '26863101001', '26863501001', '26873701001', '26874101001', '26895201001', '26897601004', '26904201001', '26905301001', '26905401001',  "+CRLF
cCond += "'26953601001', '26953801001', '26961801001', '26970901001', '27043001001', '27059701001', '27074301001', '27088301004', '27111901001', '27117301001',  "+CRLF
cCond += "'27127301001', '27132101001', '27134801001', '27149201001', '27159501001', '27168001001', '27195301001', '27208801001', '27212901010', '27225001001',  "+CRLF
cCond += "'27225901001', '27238201001', '27244801001', '27248701001', '27249701001', '27259701001', '27274601001', '27279701001', '27280201001', '27280301001',  "+CRLF
cCond += "'27280401001', '27280501001', '27280601001', '27280801001', '27280901002', '27281101001', '27281401001', '27281501001', '27281701001', '27281801001',  "+CRLF
cCond += "'27282001001', '27282101001', '27282301001', '27282401001', '27282501001', '27282801001', '27283101001', '27283201001', '27283301001', '27283401001',  "+CRLF
cCond += "'27283501001', '27301801001', '27303901001', '27308201001', '27309601001', '27310101001', '27310201001', '27310401001', '27310701001', '27311301004',  "+CRLF
cCond += "'27311401001', '27311501001', '27311601001', '27311701001', '27311801001', '27312001001', '27312101001', '27312201001', '27312401001', '27313201001',  "+CRLF
cCond += "'27313501001', '27313601001', '27313701001', '27315501001', '27315701001', '27316101001', '27326201001', '27336301002', '27336601001', '27345201001',  "+CRLF
cCond += "'27346701001', '27346801001', '27347001001', '27347101001', '27350301004', '27351301003', '27351401001', '27354201001', '27354301001')                 "+CRLF

*/
//Add para teste, remover antes de colocar em produção.
cQry	+= cCond 

//Adiciona filtro por OP
If !Empty(cProdDe)
	cQry	+= "AND		B.D4_COD >= '"+cProdDe+"' "+CRLF
EndIf
If !Empty(cProdAte)
	cQry	+= "AND		B.D4_COD <= '"+cProdAte+"' "+CRLF
EndIf

//Ordena para que sejam priorizados os empenhos mais antigos.
cQry	+= "ORDER BY D4_DATA	"+CRLF

cQry := ChangeQuery(cQry)

Return cQry

/*/{Protheus.doc} 'AnEmpAut'
//TODO Processa a query verificando se existem empenhos que possam ser atendidos.
@author Pirolo
@since 09/04/2019
@version version
parametersSection
@return return, return_description
/*/
User Function AnEmpAut(cAlias)
Local aSalAtu	:= {}
Local aRet		:= {}
Local nQtdNec	:= 0
Local cProd		:= 0
Local cOP		:= 0
Local aAux		:= {}
Local nCount	:= 0

//Posiciona no primeiro registro da query
(cAlias)->(DbGoTop())

//Verifica a qtde de registros
Count to nCount

//Reposiciona no primeiro registro
(cAlias)->(DbGoTop())

//Carrega a regua
ProcRegua(nCount)

//Percorre o resultado da query
While (cAlias)->(!Eof())
	cProd 	:= (cAlias)->D4_COD
	cOp		:= (cAlias)->D4_OP
	nRecn	:= (cAlias)->RECN
	BEGIN TRANSACTION
	
	//Atualiza barra de processamento
	IncProc("Analisando empenhos pendentes..."+CRLF+"OP: "+AllTrim(cOp)+" / "+"Produto: "+AllTrim(cProd))
	
	//Chama a CalcEst para verificar o estoque do produto
	aSalAtu := CalculaEstoque(cProd)
	
	//Se existe saldo do produto, efetua a transferência
	If Len(aSalAtu[2]) > 0
		//Verifica a qtde de empenho pendente
		nQtdNec	:= (cAlias)->D4_QTDEORI//-(cAlias)->D4_QUANT
		
		//Efetua a transferência possivel
		aTrnsf := TransfProd(aSalAtu, cLocProc, cLocDest, nQtdNec)
		
		//Verifica se ocorreu alguma transferência com sucesso e realiza o empenho.
		If aTrnsf[2] > 0
			aAux := EfetuaEmpenhos(cProd, cOp, nRecn, aTrnsf)
			
			If !aAux[1]
				DisarmTransaction()
			Else
				Aadd(aRet, aAux)
				GravaSZS(aAux)
			EndIf
		EndIf
	EndIf
	
	//Se estiver em modo simulação, disarma a transação sempre para que os dados não sejam efetivados.
	If lSimula
		DisarmTransaction()
	EndIf
	
	END TRANSACTION
	
	(cAlias)->(DbSkip())
End

Return aRet

/*/{Protheus.doc} CalculaEstoque
//TODO Descrição auto-gerada.
@author Pirolo
@since 11/04/2019
@version undefined
@return AEst, Array com produto na primeira posição e um array com a composição do estoque na segunda
/*/
Static Function CalculaEstoque(cProd)
Local nSaldoEs	:= 0
Local aEst		:= {cProd, {}}
Local aTrnsf	:= {}
	
DbSelectArea("SB1")
SB1->(DbSetOrder(1))

If SB1->(DbSeek(xFilial("SB1")+cProd))
	
	If SB1->B1_RASTRO == "L" .AND. SB1->B1_LOCALIZ == "S" //LOCALIZ - Controla Endereçamento de estoque
		
		//Saldos por endereço
		DbSelectArea("SBF")
		SBF->(DbSetOrder(2))//BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_NUMLOTE+BF_PRIOR+BF_LOCALIZ+BF_NUMSERI
		
		If SBF->(DbSeek(xFilial("SBF")+cProd+cLocProc))
			While SBF->(!Eof() .AND. xFilial("SBF")+cProd+cLocProc == BF_FILIAL+BF_PRODUTO+BF_LOCAL)
				//Qtd Estoque = Saldo - Empenhos
				nSaldoEs	:= SBF->(BF_QUANT-BF_EMPENHO)
				
				//Se possuir saldo, adiciona 
				If nSaldoEs > 0
					Aadd(aEst[2], {xFilial("SBF"), cLocProc, SBF->BF_LOTECTL, SBF->BF_LOCALIZ, SBF->BF_QUANT, SBF->BF_EMPENHO, nSaldoEs})
				EndIf
				
				SBF->(DbSkip())
			End
		EndIf

	EndIf
EndIf

Return aEst

/*/{Protheus.doc} TransfProd
//TODO Efetua a transferencia dos produtos.
@author Pirolo
@since 11/04/2019
@version undefined
@param aSalAtu, array, descricao
@param cLocDe, characters, descricao
@param cLocPara, characters, descricao
@param nQtdNec, numeric, descricao
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function TransfProd(aSalAtu, cLocDe, cLocPara, nQtdNec)
Local nAtend	:= 0
Local nQtdTrns	:= 0
Local nQtdSldE	:= 0
Local nI		:= 0
Local cProd		:= aSalAtu[1]
Local aAtend	:= {cProd, 0, {}}
Local aAux		:= {}
Local cLote		:= ""
Local cEndOrig	:= ""

//Percorre o array de saldo para transferir o que for necessário
For nI := 1 to Len(aSalAtu[2])
	//Saldo em estoque
	nQtdSldE 	:= aSalAtu[2][nI][7]
	cLote		:= aSalAtu[2][nI][3]
	cEndOrig	:= aSalAtu[2][nI][4]
	
	//Se o saldo em estoque for menor que o 
	nQtdTrns := Iif(nQtdNec > nQtdSldE .AND. nQtdSldE > 0, nQtdSldE, nQtdNec)
	
	//Autoriza o produto para transferência no armazem destino
	AdeqArmTrnsf(cProd, cLocPara)
	
	//Adiciona o resultado das transferências no array de log
	aAux := U_ORTF004B(cProd, cLote, nQtdTrns, cLocDe, cEndOrig, cLocPara, cEndDest)
	
	//Se transferiu com sucesso
	If aAux[1]
		//Totaliza as transferências
		aAtend[2] 	+= nQtdTrns
		
		//Controla o saldo restante necessário
		nQtdNec 	-= nQtdTrns
	EndIf
	
	Aadd(aAtend[3], aAux)
	
	//Se atendeu a qtde necessária, sai do For
	If nQtdNec == 0
		exit
	EndIf
Next nI

Return aAtend

/*/{Protheus.doc} ORTF004B
//TODO Descrição auto-gerada.
@author Bruno
@since 11/04/2019
@version undefined
@param cProd, characters, descricao
@param cLote, characters, descricao
@param nQuant, numeric, descricao
@param cLocOri, characters, descricao
@param cEndOri, characters, descricao
@param cLocDest, characters, descricao
@param cEndDest, characters, descricao
@param cXErr, characters, descricao
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function ORTF004B(cProd, cLote, nQuant, cLocOri, cEndOri, cLocDest, cEndDest , cXErr )
Local cAlias	:= ALIAS()
Local aAuto 	:= {}
Local aItem 	:= {}
Local _sDocSD3	:= ""
Local nI		:= 0
Local aRet		:= {}
Local dDtVldOr	:= nil
Local dDtVldDe	:= nil

Private lMsErroAuto := .F.
Private lMSHelpAuto := .T.

For nI := 1 to 4
	_sDocSD3	:= PROXNUM(.F.) // funcao que VERIFICA o mv_docseq
	
	//Pega o numero do Doc
	If GetMV("MV_DOCSEQ") <> _sDocSD3 
	   PutMV("MV_DOCSEQ",_sDocSD3) 
	   
	   //Sai do for porque já conseguiu pegar numero
	   exit
	EndIf 
Next nI

If !Empty(_sDocSD3)
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+ cProd , .f. ))
	
	cDescri := SB1->B1_DESC
	cUM		:= SB1->B1_UM
	
	If SB1->B1_RASTRO <> "L"
	   cLote := ""
	Endif
	
	If SB1->B1_LOCALIZ <> "S"
	   cEndOri := ""
	   cEndDest := ""
	ENDIF
	
	//Cabecalho a Incluir
	aAuto := {}
	aadd(aAuto,{_sDocSD3,dDataBase, nil})
	
	//Cabecalho
	//Itens a Incluir
	
	// Origem
	aadd(aitem,cProd	)
	aadd(aItem,cDescri	)
	aadd(aItem,cUM		)
	aadd(aItem,cLocOri	)
	aadd(aItem,cEndOri	)
	
	// Destino
	aadd(aitem,cProd	)
	aadd(aItem,cDescri	)
	aadd(aItem,cUM		)
	aadd(aItem,cLocDest )
	aadd(aItem,cEndDest )
	          
	//ACRESCENTADO 29/10/15
	cTpConv    := SB1->B1_TIPCONV //Posicione("SB1",1,XFILIAL("SB1")+cProd,"B1_TIPCONV") 
	nConversao := SB1->B1_CONV    //POSICIONE("SB1",1,XFILIAL("SB1")+cProd,"B1_CONV")          
	
	If nConversao <> 0     
		nQtdSegum := IIF(cTpConv == "M", nQuant * nConversao,nQuant / nConversao)
	else
		nQtdSegum := 0
	endif
	
	dDtVldOr := PegaDtValid(cProd, cLote, cLocOri)
	dDtVldDe := PegaDtValid(cProd, cLote, cLocDest)
	
	dDtVldDe := Iif(Empty(dDtVldDe), dDtVldOr, dDtVldDe)
	// Geral
	aadd(aItem,""				)
	aadd(aItem,cLote			) //D3_LOTECTL
	aadd(aItem,""				) //D3_NUMLOTE
	aadd(aItem, dDtVldOr		) //D3_DTVALID B8_FILIAL, B8_PRODUTO, B8_LOTECTL, B8_NUMLOTE, B8_DTVALID
	aadd(aItem,0				) //D3_POTENCI
	aadd(aItem,nQuant			)
	aadd(aItem,nQtdSegum		) //D3_QTDSEGUM
	aadd(aItem,""				) //D3_EXTORNO
	aadd(aItem,""				) //D3_NUMSEQ
	aadd(aItem,cLote			) //D3_LOTECTL
	aadd(aItem,dDtVldDe			) //D3_DTVALID
	aadd(aItem,""				) //D3_ITEMGRD
	aadd(aItem,""				) //D3_OBSERVA
	aadd(aItem,"EMPENHA AUTO"	) //D3_XOBS

	aadd(aAuto,aItem)
	    
	lMsErroAuto := .f.   
	cErrorMsg := ""
	
	MSExecAuto({|x,y| mata261(x,y)},aAuto,3)
	
	If !lMsErroAuto
		DbSelectArea("SD3")
		SD3->(DbSetOrder(2))//D3_FILIAL, D3_DOC, D3_COD
		
		//Verifica se a transferencia de fato ocorreu, necessário pois o padrão retorna falso positivo caso ocorram problemas de Dt de validade.
		If SD3->(DbSeek(xFilial("SD3")+PADR(_sDocSD3 , TamSX3( "D3_DOC" )[1] )))
			RecLock("SD3", .F.)
				SD3->D3_XOBS := "AUTO EMPENHO"
			SD3->(MsUnlock())
			aRet := {.T., _sDocSD3, cLocDest, cEndDest, nQuant, cLote, cLocOri, cEndOri, {{cEndOri, nQuant, _sDocSD3}}}
		Else
			aRet := {.F., Dtoc(Date())+" "+Time()+" - Transferência não realizada, possivel erro de Data de Validade"}
		EndIf
		
	Else
		cErro:= "Erro na transferencia:"
		//MostraErro()
		cFileLog   := NomeAutoLog()
		cErrorMsg  := ""
		If FILE(cFileLog)
			cErrorMsg := MemoRead(cFileLog)
		EndIf
		
		ConOut("Erro Transf.:"+cErrorMsg)
		cXErr := cErrorMsg
		aRet := {.F., Dtoc(Date())+" "+Time()+" - "+cErrorMsg}
	EndIf
	 
EndIf

RETURN aRet

/*/{Protheus.doc} AdeqArmTrnsf
//TODO Rotina que verifica se o produto esta liberado para transferência no armazem informado e libera se necessário
@author Pirolo
@since 11/04/2019
@version undefined
@param cProd, characters, descricao
@param cLocal, characters, descricao
@return return, return_description
/*/
Static Function AdeqArmTrnsf(cProd, cLocal)

DbSelectArea("SB2")
SB2->(DbSetOrder(1))

If SB2->(!DbSeek(xFilial("SB2")+cProd+cLocal))
	RecLock("SB2", .T.)
		SB2->B2_FILIAL	:= xFilial("SB2")
		SB2->B2_COD		:= cProd
		SB2->B2_LOCAL	:= cLocal
	SB2->(MsUnlock())
EndIf

Return

/*/{Protheus.doc}EfetuaEmpenhos
//TODO Efetua os empenhos dos produtos transferidos
@author Pirolo
@since 11/04/2019
@version version
parametersSection
@return return, return_description
/*/
Static Function EfetuaEmpenhos(cProd, cOp, nRecn, aTrnsf)
Local aEmp			:= {.T., cOp, cProd, nRecn,  {}}
Local nI			:= 0
Local nQtdOrig		:= 0
Local aVetor		:= {}
Local aAux			:= {}
Local lParcial		:= .F.
Private lMsErroAuto := .F.
Private lMSHelpAuto := .T.

//Abre a tabela de Empenhos
DbSelectArea("SD4")

//Posiciona no Empenho pendente
SD4->(DbGoTo(nRecn))

//Guarda a qtde necessária
nQtdOrig := SD4->D4_QTDEORI

//Totaliza o array de transferencias
aTrnsf[3] := TotalizaTrans(aTrnsf[3])

//Percorre os produtos transferidos e realiza o empenho
For nI := 1 to Len(aTrnsf[3])
	//Verifica se a transferência ocorreu com sucesso
	If aTrnsf[3,nI, 1]
		//***********REMOVER DEPOIS DOS TESTES - utilizado para testar empenho parcial
		//aTrnsf[3,nI,5] := 1
		
		If aTrnsf[3,nI,5] == nQtdOrig
			//Se atende 100%, já realiza o empenho.
			aVetor:={   {"D4_COD"     ,SD4->D4_COD			,Nil},;
						{"D4_LOCAL"   ,cLocDest		   		,Nil},;
						{"D4_LOTECTL" ,aTrnsf[3,nI,6]		,Nil},;
						{"D4_OP"      ,SD4->D4_OP			,Nil},;
						{"D4_DATA"    ,Date() 		    	,Nil},;
						{"D4_QUANT"   ,aTrnsf[3,nI,5]		,Nil},;
						{"D4_QTDEORI" ,aTrnsf[3,nI,5]		,Nil} }
			lParcial := .F.
		Else
			//Se atende parcial, deve primeiro alterar as quantidades, 
			//após a alteração um novo execauto será efetuado para realizar o empenho de fato.
			aVetor:={   {"D4_COD"     ,SD4->D4_COD			,Nil},;
						{"D4_OP"      ,SD4->D4_OP			,Nil},;
						{"D4_QUANT"   ,aTrnsf[3,nI,5]		,Nil},;
						{"D4_QTDEORI" ,aTrnsf[3,nI,5]		,Nil} }
			lParcial	:= .T.
		EndIf
		
		//Altera Empenho
		lMsErroAuto := .F.
		lMSHelpAuto := .T.
		
		//Executa a alteração
		MSExecAuto({|x,y| mata380(x,y)},aVetor,4)
		lMSHelpAuto := .F.
		
		If !lMsErroAuto
			//Atualiza o saldo pendente
			nQtdOrig -= aTrnsf[3,nI,5]
			
			//Tratamento para quando for atendido parcialmente
			If lParcial
				//Efetiva o empenho no lote e quantidade transferida
				aVetor :={	{"D4_COD"     ,SD4->D4_COD			,Nil},;
							{"D4_LOCAL"   ,cLocDest		   		,Nil},;
							{"D4_LOTECTL" ,aTrnsf[3,nI,6]		,Nil},;
							{"D4_OP"      ,SD4->D4_OP			,Nil},;
							{"D4_DATA"    ,Date() 		    	,Nil},;
							{"D4_QUANT"   ,aTrnsf[3,nI,5]		,Nil},;
							{"D4_QTDEORI" ,aTrnsf[3,nI,5]		,Nil} }
	
				//Altera Empenho
				lMsErroAuto := .F.
				lMSHelpAuto := .T.
				
				MSExecAuto({|x,y| mata380(x,y)},aVetor,4)
				lMSHelpAuto := .F.
				
				If !lMsErroAuto					
					//Cria um novo empenho com o saldo faltante
					If CriaNovoEmpenho(SD4->D4_OP, SD4->D4_COD, cLocDest, nQtdOrig, SD4->D4_TRT, SD4->D4_ROTEIRO)
						
						Aadd(aAux, {aTrnsf[3,nI, 2], aTrnsf[3,nI, 3], aTrnsf[3,nI, 4], aTrnsf[3,nI, 6], aTrnsf[3,nI,5], "Empenho realizado com sucesso", aTrnsf[3,nI,7], aTrnsf[3,nI,8], aTrnsf[3,nI,9] })
					Else
						//Reporta erro para que o rollback seja efetuado
						aEmp[1] := .F.
						Aadd(aAux, {aTrnsf[3,nI, 2], aTrnsf[3,nI, 3], aTrnsf[3,nI, 4], aTrnsf[3,nI, 6], 			 0, Iif(MV_PAR06 == 1, MostraErro(), ""), aTrnsf[3,nI,7], aTrnsf[3,nI,8]})
					EndIf
				Else
					//Alert("Erro na geração do empenho, verifique.")
					aEmp[1] := .F.
					Aadd(aAux, {aTrnsf[3,nI, 2], aTrnsf[3,nI, 3], aTrnsf[3,nI, 4], aTrnsf[3,nI, 6], 			 0, Iif(MV_PAR06 == 1, MostraErro(), ""), aTrnsf[3,nI,7], aTrnsf[3,nI,8]})
				EndIf
			Else
				Aadd(aAux, {aTrnsf[3,nI, 2], aTrnsf[3,nI, 3], aTrnsf[3,nI, 4], aTrnsf[3,nI, 6], aTrnsf[3,nI,5], "Empenho realizado com sucesso", aTrnsf[3,nI,7], aTrnsf[3,nI,8], aTrnsf[3,nI,9]})
			EndIf
		Else
			aEmp[1] := .F.
			Aadd(aAux, {aTrnsf[3,nI, 2], aTrnsf[3,nI, 3], aTrnsf[3,nI, 4], aTrnsf[3,nI, 6], 			 0, Iif(MV_PAR06 == 1, MostraErro(), ""), aTrnsf[3,nI,7], aTrnsf[3,nI,8]})
			
			//Ops que geraram erro
			Aadd(aErro, {SD4->D4_OP, SD4->D4_COD})
			
		EndIf	
		
	EndIf
Next nI
aEmp[5] := aAux

Return aEmp

/*/{Protheus.doc} CriaNovoEmpenho
//TODO Gera o empenho da OP com o saldo não atendido
@author Pirolo
@since 16/04/2019
@version undefined
@param cOP, characters, descricao
@param cProd, characters, descricao
@param cLocDest, characters, descricao
@param nQtdOrig, numeric, descricao
@return return, return_description
/*/
Static Function CriaNovoEmpenho(cOP, cProd, cLocDest, nQtdOrig, cTrt, cRoteiro)
Local lRet := .T.

aVetor:={   {"D4_COD"     	,cProd			,Nil},;
			{"D4_LOCAL"   	,"11"		   	,Nil},;
			{"D4_OP"      	,cOP			,Nil},;
			{"D4_QTDEORI"	,nQtdOrig		,.F.},;
			{"D4_QUANT"   	,nQtdOrig		,.F.},;
			{"D4_TRT"   	,cTrt			,Nil},;
			{"D4_ROTEIRO"	,cRoteiro		,Nil},;
			{"D4_LOTECTL" 	,""				,Nil}}



//Altera Empenho

lMsErroAuto := .F.
lMSHelpAuto := .T.

//Executa a alteração
MSExecAuto({|x,y| mata380(x,y)},aVetor,3)
lMSHelpAuto := .F.

If !lMsErroAuto
	lRet := .T.
Else
	RecLock("SD4", .T.)
		D4_FILIAL	:= xFilial("SD4")
		D4_COD		:= cProd
		D4_LOCAL	:= "11"
		D4_OP		:= cOP
		D4_QTDEORI	:= nQtdOrig
		D4_QUANT	:= nQtdOrig
		D4_TRT		:= cTrt
		D4_LOTECTL	:= ""
		D4_DATA		:= dDataBase
		D4_PRODUTO	:= cProd
		D4_ROTEIRO	:= cRoteiro
	SD4->(MsUnlock())
EndIf

Return lRet

/*/{Protheus.doc} GravaSZS
//TODO Grava o histórico de processamento dos empenhos realizados na tabela SZS.
@author Pirolo
@since 13/06/2019
@version undefined
@param aEmpenho, array, descricao
@return return, return_description
/*/
Static Function GravaSZS(aEmpenho)
Local nI 	:= 0
Local nJ 	:= 0
Local nY	:= 0
Local dData	:= Date()
Local cHora	:= Time()
//Local nSeq	:= 0
Local nSeq	:= ""

//Se o processamento atual não tiver pego um ID, gera um novo.
cId := Iif(Empty(cId), CriaIDProc(), cId)

//ProcRegua(Len(aEmpenho))

If !Empty(aEmpenho)
	//IncProc("ID do Processamento:"+cId+CRLF+"OP: "+AllTrim(aEmpenho[2])+" / "+"Produto: "+AllTrim(aEmpenho[3]))
	For nJ := 1 to Len(aEmpenho[5])
		For nY := 1 to Len(aEmpenho[5, nJ, 9])
			nSeq ++
			RecLock("SZS", .T.)
				SZS->ZS_FILIAL := xFilial("SZS")
				SZS->ZS_ID     := cId
				SZS->ZS_USER   := cUserName
				SZS->ZS_DATA   := dData
				SZS->ZS_HORA   := cHora
				SZS->ZS_OP     := aEmpenho[2]
				SZS->ZS_DOC    := aEmpenho[5, nJ, 9, nY, 3]
				SZS->ZS_PRODUTO:= aEmpenho[3]
				SZS->ZS_LOTECTL:= aEmpenho[5, nJ, 4]
				SZS->ZS_LOCALIZ:= aEmpenho[5, nJ, 3]
				SZS->ZS_QUANT  := aEmpenho[5, nJ, 9, nY, 2]//aEmpenho[nI, 5, nJ, 5]
				SZS->ZS_SEQUENC:= nSeq
				SZS->ZS_LOCORI := aEmpenho[5, nJ, 7]
				SZS->ZS_ENDORI := aEmpenho[5, nJ, 9, nY, 1]//aEmpenho[nI, 5, nJ, 8]
				SZS->ZS_ESTORNO:= "N"
			SZS->(MsUnlock())
		Next nY
	Next nJ
EndIf

Return cId

/*/{Protheus.doc} CriaIDProc
//TODO Pega o ultimo ID disponivel na tabela SZS.
@author Pirolo
@since 23/04/2019
@version undefined
@return return, return_description
/*/
Static Function CriaIDProc()
Local cQry		:= ""
Local cTMPAlia	:= GetNextAlias()
Local cRet		:= "000000000"

cQry	:= "SELECT MAX(ZS_ID) AS ID								"+CRLF 
cQry	+= "FROM "+RetSqlName("SZS")+"							"+CRLF					

//Executa a query
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTMPAlia,.T.,.T.)

If (cTMPAlia)->(!Eof())
	cRet := Soma1((cTMPAlia)->ID)
EndIf

(cTMPAlia)->(DbCloseArea())

Return cRet

/*/{Protheus.doc} ORTF004C
//TODO AXCADASTROS para reimprimir relatório.
@author Pirolo
@since 18/04/2019
@version undefined
@return return, return_description
/*/
User Function ORTF004C()

Private  cFilter  := ""
Private cCadastro := "Empenho automático de OP"
Private aRotina   := {	{"Imprimir"		,"U_RORTF005(SZS->ZS_ID, .T.)"	,0,0},; 						
						{"Processar"	,"U_ORTF0004"					,0,3},;
						{"Pfi Equipamentos"		,"U_xMTR797Z"	    	,0,7}} //Chama a impressão da OP da 20191007)
					//	{"Estornar"		,"U_ORTF004E"					,0,6},; // Removido devido a erro na rotina de Estorno (Samuel Mirnada 20200204)
					
Private cDelFunc  := ".T." 
Private oGDItens
Private cString   := "SZS"

If FwIsAdmin()
	Aadd(aRotina, {"Estornar (admin)"		,"U_ORTF004D"					,0,6})
EndIf
 
dbSelectArea(cString)
dbSetOrder(1)
dbSelectArea(cString)
mBrowse( 6, 1,22,75,cString,,,,,, )

Return

/*/{Protheus.doc} PegaDtValid
//TODO Pega a data da validade na SB8.
@author Pirolo
@since 04/06/2019
@version undefined
@param cProd, characters, descricao
@param cLote, characters, descricao
@param cLocal, characters, descricao
@return return, return_description
/*/
Static Function PegaDtValid(cProd, cLote, cLocal)
Local cQry		:= ""
Local cTMPAlia	:= GetNextAlias()
Local dRet		:= CTOD("")

cQry	:= "SELECT B8_DTVALID                      "+CRLF
cQry	+= "FROM "+RetSqlName("SB8")+"             "+CRLF 
cQry	+= "WHERE B8_FILIAL = '"+xFilial("SB8")+"' "+CRLF
cQry	+= "AND   B8_PRODUTO = '"+cProd+"'         "+CRLF
cQry	+= "AND   B8_LOTECTL = '"+cLote+"'         "+CRLF
cQry	+= "AND	  D_E_L_E_T_ <> '*'                "+CRLF
cQry	+= "AND   B8_LOCAL = '"+cLocal+"'          "+CRLF
cQry	+= "AND   B8_SALDO > 0                     "

//Executa a query
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTMPAlia,.T.,.T.)

If (cTMPAlia)->(!Eof())
	dRet := STOD((cTMPAlia)->B8_DTVALID)
EndIf

(cTMPAlia)->(DbCloseArea())

Return dRet

/*/{Protheus.doc} TotalizaTrans
//TODO Totaliza o array de Transferências pois na tela de empenho
@author Bruno
@since 11/06/2019
@version undefined
@param aTrnsf, array, array gerado pela função de transferências.
@return return, return_description
/*/
Static Function TotalizaTrans(aTrnsf)
Local aAux		:= {}
Local nI		:= 0
Local nJ		:= 0
Local lAchou	:= .F.

For nI := 1 to Len(aTrnsf)
	lAchou := .F.
	
	For nJ := 1 to Len(aAux)
		If aTrnsf[nI, 1] .AND. aTrnsf[nI, 6]  == aAux[nJ, 6] 
			lAchou		:= .T.
			aAux[nJ, 5]	+= aTrnsf[nI, 5]
			aAux[nJ, 2]	+= "|"+aTrnsf[nI, 2]
			aAux[nJ, 8]	+= "|"+aTrnsf[nI, 8]
			
			Aadd(aAux[nJ][9], aTrnsf[nI, 9, 1])
		EndIf
	Next nJ
	
	If !lAchou .AND. aTrnsf[nI, 1]
		AAdd(aAux, aTrnsf[nI])
		
	Else
	
	EndIf
Next nI

Return aAux

User Function ORTF004D()
Local cTMPAlia	:= GetNextAlias()
Local cQry 		:= ""
Local aAuto 	:= {}
Local nQtde		:= 0
Local aAux		:= {}

Private lMsErroAuto := .F.
Private lMSHelpAuto := .T.

If Pergunte("AUTOEMPENH", .T.)
	/*
	cQry := "SELECT *, B.R_E_C_N_O_ AS RECN, A.R_E_C_N_O_ AS RECSZ "+CRLF 
	cQry += "FROM "+RetSqlName("SZS")+" A                          "+CRLF
	cQry += "		INNER JOIN "+RetSqlName("SD4")+" B             "+CRLF
	cQry += "			ON(    B.D_E_L_E_T_ = ''                   "+CRLF
	cQry += "			   AND B.D4_FILIAL  = '"+xFilial("SD4")+"' "+CRLF
	cQry += "			   AND A.ZS_OP      = B.D4_OP              "+CRLF
	cQry += "			   AND A.ZS_LOTECTL = B.D4_LOTECTL         "+CRLF
	cQry += "			   AND A.ZS_PRODUTO = B.D4_COD )           "+CRLF
	cQry += "WHERE A.D_E_L_E_T_ = ''                               "+CRLF
	cQry += "AND   ZS_DATA     >= '"+DTOS(MV_PAR01)+"'             "+CRLF
	cQry += "AND   ZS_DATA     <= '"+DTOS(MV_PAR02)+"'             "+CRLF
	cQry += "AND   ZS_OP	   >= '"+MV_PAR03+"'                   "+CRLF
	cQry += "AND   ZS_OP	   <= '"+MV_PAR04+"'                   "+CRLF
	cQry += "AND   ZS_PRODUTO  >= '"+MV_PAR05+"'                   "+CRLF
	cQry += "AND   ZS_PRODUTO  <= '"+MV_PAR06+"'                   "+CRLF
	cQry += "AND   ZS_ESTORNO   = 'N'                   		   "
	*/

	cQry := "SELECT D4_COD, D3_DOC, D4_OP, D4_DATA, A.R_E_C_N_O_ AS RECND3, B.R_E_C_N_O_ AS RECND4 "+CRLF
	cQry += "FROM SD3010 A                                                     "+CRLF
	cQry += "	LEFT JOIN SD4010 B                                             "+CRLF
	cQry += "		ON      D3_FILIAL    = D4_FILIAL                           "+CRLF
	cQry += "			AND D4_LOTECTL   = D3_LOTECTL                          "+CRLF                
	cQry += "			AND D4_DATA      = D3_EMISSAO                          "+CRLF
	cQry += "			AND D4_DTVALID   = D3_DTVALID                          "+CRLF
	cQry += "			AND B.D_E_L_E_T_ = ''                                  "+CRLF                     
	cQry += "			AND D4_QUANT     = D4_QTDEORI                          "+CRLF                
	cQry += "			AND D4_LOTECTL  <> ''                                  "+CRLF                
	cQry += "			AND D3_FILIAL = '01'                                   "+CRLF
	cQry += "WHERE A.D_E_L_E_T_ = ''                                           "+CRLF
	cQry += "AND   D3_ESTORNO <> 'S'                                           "+CRLF
	cQry += "AND   D3_LOCAL = '11'                                             "+CRLF
	//cQry += "AND   D3_DOC >= (select MIN(ZS_DOC) from SZS010)                  "+CRLF
	//cQry += "AND   D3_DOC <= (select MAX(ZS_DOC) from SZS010)                  "+CRLF
	cQry += "AND   D3_EMISSAO >= '"+DTOS(MV_PAR01)+"'                          "+CRLF
	cQry += "AND   D3_EMISSAO <= '"+DTOS(MV_PAR02)+"'                          "+CRLF
	cQry += "AND   D4_OP      = '"+MV_PAR03+"'                                "+CRLF
	//cQry += "AND   D4_OP      <= '"+MV_PAR04+"'                                "+CRLF
	//cQry += "AND   D4_OP IN ('26731801001', '26734701001', '26735201001', '26775901003', '26806601001', '26810301003', '26840301001', '26850301003', '26857601001', '26860701001', '26860901001', '26861901003', '26863301001', '26863601001', '26863801001', '26863901001', '26864001001', '26864801001', '26864901001', '26865101001', '26865201001', '26865301001', '26869301001', '26869401001', '26869501001', '26869601001', '26869701001', '26869901001', '27132601001') "+CRLF
	cQry += "AND   D3_COD     >= '"+MV_PAR04+"'                                "+CRLF
	cQry += "AND   D3_COD     <= '"+MV_PAR05+"'                             "+CRLF
	cQry += "ORDER BY A.D3_EMISSAO DESC                                        "+CRLF

	
	//Executa a query
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTMPAlia,.T.,.T.)
	
	DbSelectArea("SD4")

	//Grava Tabela de Log
	If (cTMPAlia)->(!Eof())
		While (cTMPAlia)->(!Eof())
			BEGIN TRANSACTION
				//Posiciona no registro da SD4 que será estornado
				SD4->(DbGoTo((cTMPAlia)->RECND4))
				
				If AllTrim(SD4->D4_LOTECTL) <> ""
					//Verifica se existe item conflitante e exclui
					aAux := VerificaItemConflito(SD4->D4_OP, SD4->D4_COD, cLocProc, "          ")
					
					//Se validado ou resolvido conflito
					If aAux[1]
						//Se ocorreu resolução de conflito, pega a qtde do conflito para ajustar no item que sobrou.
						nQtde := aAux[2]
						
						//Remove o empenho do Lote
						aVetor :={	{"D4_COD"     ,SD4->D4_COD				,Nil},;
									{"D4_LOCAL"   ,cLocProc					,Nil},;
									{"D4_LOTECTL" ,"          "				,Nil},;
									{"D4_OP"      ,SD4->D4_OP				,Nil},;
									{"D4_DATA"    ,Date() 		   			,Nil},;
									{"D4_QTDEORI" ,SD4->D4_QTDEORI+nQtde	,.F.},;
									{"D4_QUANT"   ,SD4->D4_QTDEORI+nQtde	,.F.} }
				
						//Altera Empenho
						lMsErroAuto := .F.
						lMSHelpAuto := .T.
						
						MSExecAuto({|x,y| mata380(x,y)},aVetor,4)
						lMSHelpAuto := .F.
						
						If lMsErroAuto
							If lExibMsg
								Alert("Não foi possivel realizar o estorno do empenho (OP "+AllTrim(SD4->D4_OP)+" produto "+AllTrim(SD4->D4_COD)+")")
								MostraErro()
							EndIf
						Else
							DbSelectArea("SD3")
							DbSetOrder(2)
							
							//If SD3->(DbSeek(xFilial("SD3")+PADR((cTMPAlia)->D3_DOC , TamSX3( "D3_DOC" )[1] )+(cTMPAlia)->D4_COD))
							If SD3->(DbSeek(xFilial("SD3")+(cTMPAlia)->D3_DOC +(cTMPAlia)->D4_COD))
								lMsErroAuto := .F.
								lMSHelpAuto := .T.
								
								aAuto := {}					
								MSExecAuto({|x,y| mata261(x,y)},aAuto,6)
								
								If !lMsErroAuto
									
									DbSelectArea("SZS")
									SZS->(DbSetOrder(4))//ZS_FILIAL+ZS_OP+ZS_PRODUTO
									
									If SZS->(DbSeek(xFilial("SZS")+SD4->D4_OP+SD4->D4_COD))
										RecLock("SZS", .F.)
											SZS->ZS_ESTORNO := "S"
										SZS->(MsUnlock())
									EndIf
									
									If lExibMsg
										MsgInfo("Estorno(s) realizado(s) com sucesso."+CRLF+"OP "+AllTrim(SD4->D4_OP)+" produto "+AllTrim(SD4->D4_COD), "Estorno de Empenho")
									EndIf		
								Else	
									If lExibMsg
										Alert("Não foi possivel realizar o estorno do(s) empenho(s)."+CRLF+"OP "+AllTrim(SD4->D4_OP)+" produto "+AllTrim(SD4->D4_COD))  	
										MostraErro()
									EndIf
									DisarmTransaction()
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf		
				
			If lSimula
				DisarmTransaction()
			EndIf
			END TRANSACTION
			(cTMPAlia)->(DbSkip())
		End
	Else 
		MsgInfo("Não foram localizados registros para estorno.")
	EndIf


		MsgInfo("Processamento concluido.", "Estorno de Empenho")

EndIf

Return

/*/{Protheus.doc} VerificaItemConflito
//TODO Verifica se já existe um item para o produto e lote a ser alterado, nessa situação um dos empenhos precisam ser excluidos.
@author Pirolo
@since 08/08/2019
@param cOp, characters, descricao
@param cProd, characters, descricao
@param cLocProc, characters, descricao
@param cLote, characters, descricao
@return return, return_description
/*/
Static Function VerificaItemConflito(cOp, cProd, cLocProc, cLote)
Local aAreaSD4	:= SD4->(GetArea())
Local nQtde		:= 0
Local aRet		:= {.T., 0}

DbSelectArea("SD4")
SD4->(DbSetOrder(2))//D4_FILIAL, D4_OP, D4_COD, D4_LOCAL

//Verifica se já existe um item de empenho para o Lote em questão
If SD4->(DbSeek(xFilial("SD4")+cOp+cProd+cLocProc))
	//Percorre os lotes
	While SD4->(!Eof() .AND. D4_FILIAL+D4_OP+D4_COD+D4_LOCAL == xFilial("SD4")+cOp+cProd+cLocProc)
		If AllTrim(SD4->D4_LOTECTL) == AllTrim(cLote)
			nQtde := SD4->D4_QTDEORI
			
			//Remove o empenho do Lote
			aVetor :={	{"D4_COD"     ,SD4->D4_COD		,Nil},;
						{"D4_LOCAL"   ,SD4->D4_LOCAL	,Nil},;
						{"D4_LOTECTL" ,SD4->D4_LOTECTL	,Nil},;
						{"D4_OP"      ,SD4->D4_OP		,Nil},;
						{"D4_DATA"    ,SD4->D4_DATA   	,Nil},;
						{"D4_TRT"     ,SD4->D4_TRT   	,Nil} }
	
			//Altera Empenho
			lMsErroAuto := .F.
			lMSHelpAuto := .T.
			/*
			Número da opção a executar
				3 = Incluir
				4 = Alterar
				5 = Excluir
			*/
			MSExecAuto({|x,y| mata380(x,y)},aVetor, 5)
			lMSHelpAuto := .F.
			
			If lMsErroAuto
				aRet := {.F., 0}
				If lExibMsg
					Alert("Não foi possivel realizar o estorno do empenho (OP "+AllTrim(SD4->D4_OP)+" produto "+AllTrim(SD4->D4_COD)+")")
					MostraErro()
				EndIf
			Else
				aRet := {.T., nQtde}
			EndIf
		EndIf
		SD4->(DbSkip())
	EndDo

EndIf
RestArea(aAreaSD4)
Return aRet

User Function ORTF004E()
Local cTMPAlia	:= GetNextAlias()
Local cQry 		:= ""
Local aAuto 	:= {}

Private lMsErroAuto := .F.
Private lMSHelpAuto := .T.

If Pergunte("AUTOEMPENH", .T.)
	cQry := "SELECT *, B.R_E_C_N_O_ AS RECN, A.R_E_C_N_O_ AS RECSZ "+CRLF 
	cQry += "FROM "+RetSqlName("SZS")+" A                          "+CRLF
	cQry += "		INNER JOIN "+RetSqlName("SD4")+" B             "+CRLF
	cQry += "			ON(    B.D_E_L_E_T_ = ''                   "+CRLF
	cQry += "			   AND B.D4_FILIAL  = '"+xFilial("SD4")+"' "+CRLF
	cQry += "			   AND A.ZS_OP      = B.D4_OP              "+CRLF
	cQry += "			   AND A.ZS_LOTECTL = B.D4_LOTECTL         "+CRLF
	cQry += "			   AND A.ZS_PRODUTO = B.D4_COD )           "+CRLF
	cQry += "WHERE A.D_E_L_E_T_ = ''                               "+CRLF
	cQry += "AND   ZS_DATA     >= '"+DTOS(MV_PAR01)+"'             "+CRLF
	cQry += "AND   ZS_DATA     <= '"+DTOS(MV_PAR02)+"'             "+CRLF
	cQry += "AND   ZS_OP	    = '"+MV_PAR03+"'                   "+CRLF
	//cQry += "AND   ZS_OP	   <= '"+MV_PAR04+"'                   "+CRLF
	cQry += "AND   ZS_PRODUTO  >= '"+MV_PAR04+"'                   "+CRLF
	cQry += "AND   ZS_PRODUTO  <= '"+MV_PAR05+"'                   "+CRLF
	cQry += "AND   ZS_ESTORNO   = 'N'                   		   "

	//Executa a query
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTMPAlia,.T.,.T.)
	
	DbSelectArea("SD4")

	//Grava Tabela de Log
	If (cTMPAlia)->(!Eof())
		While (cTMPAlia)->(!Eof())
			BEGIN TRANSACTION
				//Posiciona no registro da SD4 que será estornado
				SD4->(DbGoTo((cTMPAlia)->RECN))
	
				//Verifica se existe item conflitante e exclui
				aAux := VerificaItemConflito(SD4->D4_OP, SD4->D4_COD, cLocProc, "          ")
				
				//Se validado ou resolvido conflito
				If aAux[1]
							
					//Remove o empenho do Lote
					aVetor :={	{"D4_COD"     ,SD4->D4_COD		,Nil},;
								{"D4_LOCAL"   ,cLocProc			,Nil},;
								{"D4_LOTECTL" ,"          "		,Nil},;
								{"D4_OP"      ,SD4->D4_OP		,Nil},;
								{"D4_DATA"    ,Date() 		   	,Nil} }
			
					//Altera Empenho
					lMsErroAuto := .F.
					lMSHelpAuto := .T.
					
					MSExecAuto({|x,y| mata380(x,y)},aVetor,4)
					lMSHelpAuto := .F.
					
					If lMsErroAuto
						Alert("Não foi possivel realizar o estorno do empenho (OP "+AllTrim(SD4->D4_OP)+" produto "+AllTrim(SD4->D4_COD)+")")
						MostraErro()
					Else
						DbSelectArea("SD3")
						DbSetOrder(2)
						
						If SD3->(DbSeek(xFilial("SD3")+PADR((cTMPAlia)->ZS_DOC , TamSX3( "D3_DOC" )[1] )+(cTMPAlia)->ZS_PRODUTO))
							lMsErroAuto := .F.
							lMSHelpAuto := .T.
							
							aAuto := {}					
							MSExecAuto({|x,y| mata261(x,y)},aAuto,6)
							
							If !lMsErroAuto
								DbSelectArea("SZS")
								SZS->(DbGoTo((cTMPAlia)->RECSZ))
								
								RecLock("SZS", .F.)
									SZS->ZS_ESTORNO := "S"
								SZS->(MsUnlock())
								
								MsgInfo("Estorno(s) realizado(s) com sucesso."+CRLF+"OP "+AllTrim(SD4->D4_OP)+" produto "+AllTrim(SD4->D4_COD), "Estorno de Empenho")		
							Else	
								Alert("Não foi possivel realizar o estorno do(s) empenho(s)."+CRLF+"OP "+AllTrim(SD4->D4_OP)+" produto "+AllTrim(SD4->D4_COD))  	
								MostraErro()
								DisarmTransaction()
							EndIf
						EndIf
					EndIf
				Else
					DisarmTransaction()
				EndIf
			
			End Transaction
			
			(cTMPAlia)->(DbSkip())
		End
	Else 
		MsgInfo("Não foram localizados registros para estorno.")
	EndIf
	If lSimula
		DisarmTransaction()
	EndIf
	
EndIf

Return
