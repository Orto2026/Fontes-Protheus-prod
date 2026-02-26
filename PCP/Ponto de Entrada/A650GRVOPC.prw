/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A650GRVOPCºAutor  ³Microsiga           º Data ³  03/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manutencao do aCols da geracao do Empenho das OPs          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A650GRVOPC
Local aArea		:= GetArea()
Local aAreaSB1	:= SB1->(GetArea())
Local aAreaSBF	:= SBF->(GetArea())
Local aAreaSB8	:= SB8->(GetArea())
Local nI		:= 0
Local nPos		:= 0
Local _aProdutos:= {}
Local aAux		:= {}

//Parametro para desabilitar emergencialmente a customização
If SuperGetMV("ES_DSL650G", .F., .T.) 
	//Abre a tabela de produtos
	dbSelectArea("SB1")
	dbSetOrder(1)//B1_FILIAL+B1_COD
	
	//Lê o aCols e totaliza o mesmo no array aAux
	For nI := 1 to Len(aCols)
		//Verifica se o produto posicionado já foi armazenado no aAux
		nPos := aScan( aAux, {|x| X[1] = aCols[ni, nPosCod] })
		
		//Posiciona no Produto
		SB1->(dbSeek(xFilial("SB1")+aCols[ni, nPosCod]))
		
		/*	Se for um produto intermediario ou não pertencer ao armazem 10, não limpa os campos
			Qualquer alteração neste IF deve ser replicada para o IF do segundo For */
		If SB1->B1_TIPO == "PI" .OR. aCols[ni, nPosLocal] <> "10" .OR. aCols[ni, nPosLocal] == "98" .OR. SB1->B1_LOTEUNI <> "S"
			Aadd(aAux, aCols[nI])
			
		//Se não encontrar, adiciona com os campos Lote, Validade e Localiz zerados, os mesmos serão preenchidos posteriormente
		ElseIf nPos == 0
			aCols[nI, 6] := Space(Len(SB8->B8_LOTECTL))	// Lote
			aCols[nI, 7] := Ctod("  /  /  ")			// Validade
			aCols[nI, 9] := Space(Len(SBF->BF_LOCALIZ))	// Endereco
	
			Aadd(aAux, aCols[nI])
		
		//Se já existe, totaliza a quantidade da primeira e segunda unidade
		Else
			//Totaliza as Qtdes
			aAux[nPos, 02] += aCols[nI, 02]
			aAux[nPos, 12] += aCols[nI, 12]
		EndIf
	Next nI
	
	//Abre a tabela de saldos por endereço
	dbSelectArea("SBF")
	dbSetOrder(2)
	
	//Percorre o array aAux para indicar os lotes que atendem totalmente a quantidade totalizada necessária, sem necessidade de quebra.
	For nI := 1 to Len(aAux)
		//Verifica o saldo do produto por endereços
		SBF->(dbSeek(xFilial("SBF")+aAux[nI, nPosCod]+aAux[nI, 3])) // +aAux[nI, 3] Incluido devido a problema quando existe saldo em 2 armazens.
		
		//Percorre os saldos existentes do produto em questão
		While SBF->(!Eof()) .And. SBF->(BF_FILIAL+BF_PRODUTO) == xFilial("SBF")+aAux[nI, nPosCod]+aAux[nI, 3] // +aAux[nI, 3] Incluido devido a problema quando existe saldo em 2 armazens.
			//Posiciona no Produto
			SB1->(dbSeek(xFilial("SB1")+aAux[nI, nPosCod]))
			
			//Este IF deve ser equalizado com o IF do FOR anterior.
			If SB1->B1_TIPO    == "PI" .OR. ;
			   SBF->(BF_LOCAL  == "98" .OR. BF_LOCAL <> "10") .OR.;
			   SB1->B1_LOTEUNI <> "S" //Se o produto não for indicado para AutoEmpenho, desconsidera.
				SBF->(dbSkip())
				Loop
			EndIf
			
			// Verifica se a quantidade disponivel menos empenhos atende 100% a necessidade do produto.
			If SBF->(BF_QUANT - BF_EMPENHO) >= aAux[nI, nPosQuant] 
				//Preenche os dados do lote que atendeu 100%
				aAux[nI, 3] := SBF->BF_LOCAL
				aAux[nI, 6] := SBF->BF_LOTECTL
				aAux[nI, 7] := POSICIONE( "SB8", 2, SBF->(BF_FILIAL+BF_NUMLOTE+BF_LOTECTL+BF_PRODUTO+BF_LOCAL), "B8_DTVALID" ) 
				aAux[nI, 9] := SBF->BF_LOCALIZ
				Exit
			EndIf  
			SBF->(dbSkip())
		EndDo
	
	Next nI
	
	//Substitui o conteúdo do aCols pelo conteúdo do array aAux.
	aCols := AClone(aAux)
EndIf

RestArea(aArea		)
RestArea(aAreaSB1	)
RestArea(aAreaSBF	)
RestArea(aAreaSB8	)
Return Nil
/*
User Function a650bkp//A650GRVOPC

Local _aArea		:= GetArea()
Local _aAreaB1		:= SB1->(GetArea())
Local _aAreaBF		:= SBF->(GetArea())
Local _ni := 1
Local I
Local _aProdutos	:= {}
Local aAux			:= {}
//PE para desligar a customização
If SuperGetMV("ES_DSL650G", .F., .T.) 
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	For _ni := 1 To Len(aCols)
		If SB1->(dbSeek(xFilial("SB1")+aCols[_ni, nPosCod]) .And. SB1->B1_TIPO == "PI") .OR. aCols[_ni, nPosLocal] <> "10" 
			Loop
		EndIf
		
		_nPos := aScan( _aProdutos, {|x| X[1] = aCols[_ni, nPosCod] })
		If _nPos == 0
			aAdd(_aProdutos, {aCols[_ni, nPosCod], aCols[_ni, nPosQuant], 1, _ni, aCols[_ni, nPosQtSegum]})
		Else
			_aProdutos[_nPos, 2] += aCols[_ni, nPosQuant]
			_aProdutos[_nPos, 3]++
			_aProdutos[_nPos, 5] += aCols[_ni, nPosQtSegum]
		EndIf
		
	Next _nI   
	
	// VARRER O APRODUTOS, PEGAR PRODUTO COM POSICAO 3 > 1, BUSCAR SALDO POR LOTE QUE SEJA MAIOR OU IGUAL POSICAO 2, SE ENCONTRAR, DELETA OS PRODUTOS NO ACOLS E CRIAR UM PRODUTO
	// NOVO COM A QTDE TOTAL + LOTE + ENDERECE
	// CASO NAO ACHE, DEIXA UM LINHA COM TUDO ZERADO
	
	For I := 1 to Len(_aProdutos)
		If _aProdutos[I,3] > 1 // Caso o Acols do Empenho retorne mais de lote/Endereço da Mesma MP
	
			_nPriReg := _aProdutos[I,4] // Posicaono Acols do Primeiro Registro encontrado
			
			//Reinicia a variavel contadora
			_nI := 1
			
			While _nI <= Len(aCols)
			//Pirolo - For foi retirado pois devido o array aCols ter seu tamanho reduzido no laço, nesta situação o for não reconsidera o tamanho do array a cada loop
			//For _nI := 1 To Len(aCols) // varre Acols para apagar registros da MP, deixando apenas a 1a com todos os campos zerados
				If _nI == _nPriReg
					aCols[_nI, 2] := _aProdutos[I,2]					// Qtde Empenho
					//Pirolo - Nesta situação, precisa manter o sugerido pelo Padrão.
					//aCols[_nI, 3] := "  "									// Armazem
					aCols[_nI, 6] := Space(Len(SB8->B8_LOTECTL))	// Lote
					aCols[_nI, 7] := Ctod("  /  /  ")					// Validade
					aCols[_nI, 9] := Space(Len(SBF->BF_LOCALIZ))	// Endereco
					aCols[_nI,12] := _aProdutos[I,5]					// Qtde na 2a UM
				Else
					If aCols[_nI, 1]   == _aProdutos[I,1] // Deleta as demais linhas com a Mesmo MP
						aDel(aCols,_nI)
						aSize(aCols, Len(aCols)-1)
					EndIf
				EndIf
				_nI++
			End
			
			For _nI := 1 To Len(aCols)
				If _nI > _nPriReg
					//Em alguns casos o for não esta atualizandol o limitador do laço e gerando errorlog
					If _nI <= len(aCols) .AND. aCols[_nI, 1]   == _aProdutos[I,1] // Deleta as demais linhas com a Mesmo MP
						aDel(aCols,_nI)
						aSize(aCols, Len(aCols)-1)
					EndIf
				EndIf
			Next nI
			
			If _nPriReg <= Len(aCols)
				// Busca Saldo Total do Empenho por Endereco
				dbSelectArea("SBF")
				dbSetOrder(2)
				//dbSeek(xFilial("SBF")+_aProdutos[I,1])
				dbSeek(xFilial("SBF")+aCols[_nPriReg,1])
				//While !Eof() .And. SBF->(BF_FILIAL+BF_PRODUTO) == xFilial("SBF")+_aProdutos[I,1]
				While !Eof() .And. SBF->(BF_FILIAL+BF_PRODUTO) == xFilial("SBF")+aCols[_nPriReg,1]
					If SBF->BF_LOCAL == "98" .OR. SBF->BF_LOCAL <> "10"
						dbSkip()
						Loop
					EndIf
					
					//If _nPriReg <= len(aCols) .AND. (SBF->BF_QUANT - SBF->BF_EMPENHO) >= _aProdutos[I,2] .AND. aCols[_nPriReg, 1] == SBF->BF_PRODUTO // Caso Saldo do Endereco seja Suficiente, pego o Lote x Endereco
					If _nPriReg <= len(aCols) .AND. (SBF->BF_QUANT - SBF->BF_EMPENHO) >= aCols[_nPriReg, nPosQuant] .AND. aCols[_nPriReg, 1] == SBF->BF_PRODUTO // Caso Saldo do Endereco seja Suficiente, pego o Lote x Endereco
						aCols[_nPriReg, 3] := SBF->BF_LOCAL
						aCols[_nPriReg, 6] := SBF->BF_LOTECTL
						aCols[_nPriReg, 7] := Ctod("  /  /  ") //SBF->BF_DTVALID    ALTERADO MAURICIO - ERRO CAMPO NAO EXISTE
						aCols[_nPriReg, 9] := SBF->BF_LOCALIZ
						Exit
					EndIf  
					dbSkip()
				EndDo
			EndIf
		EndIf
	Next I
EndIf

RestArea(_aAreaBF)
RestArea(_aAreaB1)
RestArea(_aArea)          

Return Nil
*/
