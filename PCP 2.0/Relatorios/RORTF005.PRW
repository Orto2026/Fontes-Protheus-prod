#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#Include "RPTDEF.CH" 
#INCLUDE "TBICONN.CH"

//Colunas de inicio dos detalhes
Static aColunas		:= {0030, 0160, 0250, 0283, 0309, 0373, 0410, 0468, 0495,0554}

Static oFonte06		:= tFont():New("ARIAL"		,06,06,,.F.,,,,.T.,.F.)
Static oFonte06N	:= tFont():New("ARIAL"		,06,06,,.T.,,,,.T.,.F.)
Static oFonte08		:= tFont():New("ARIAL"		,08,08,,.F.,,,,.T.,.F.)
Static oFonte08N	:= tFont():New("ARIAL"		,08,08,,.T.,,,,.T.,.F.)
Static oFonte10		:= tFont():New("ARIAL"		,10,10,,.F.,,,,.T.,.F.)
Static oFonte10N	:= tFont():New("ARIAL"		,10,10,,.T.,,,,.T.,.F.)
Static oFonte13N	:= tFont():New("ARIAL"		,13,13,,.T.,,,,.T.,.F.)
Static oFonte14		:= tFont():New("ARIAL"		,14,14,,.F.,,,,.T.,.F.)
Static oFonte14N	:= tFont():New("ARIAL"		,14,14,,.T.,,,,.T.,.F.)
Static oFonte16		:= tFont():New("ARIAL"		,16,16,,.F.,,,,.T.,.F.)
Static oFonte16N	:= tFont():New("ARIAL"		,16,16,,.T.,,,,.T.,.F.)
Static oFonte18		:= tFont():New("ARIAL"		,18,18,,.F.,,,,.T.,.F.)
Static oFonte18N	:= tFont():New("ARIAL"		,18,18,,.T.,,,,.T.,.F.)
Static oFonte20		:= tFont():New("ARIAL"		,20,20,,.F.,,,,.T.,.F.)
Static oFonte20N	:= tFont():New("ARIAL"		,20,20,,.T.,,,,.T.,.F.)
Static oFonte22		:= tFont():New("ARIAL"		,22,22,,.F.,,,,.T.,.F.)
Static oFonte22N	:= tFont():New("ARIAL"		,22,22,,.T.,,,,.T.,.F.)
Static oFonte24		:= tFont():New("ARIAL"		,24,24,,.F.,,,,.T.,.F.)
Static oFonte24N	:= tFont():New("ARIAL"		,24,24,,.T.,,,,.T.,.F.)


/*/{Protheus.doc} RORTF005
//TODO Relatório de processamento do AutoEmpenho.
@author Pirolo
@since 23/04/2019
@version undefined
@param cId, characters, Id do processamento na tabela SZS
@return return, return_description
/*/
User Function RORTF005(cId)
Default cId 	:= SZS->ZS_ID

//Processa( {|| ImprimeRel(cId) },"Aguarde imprimindo pedido..." )
ImprimeRel(cId)

Return( Nil )

/*/{Protheus.doc} ImprimeRel
//TODO Descrição auto-gerada.
@author Pirolo
@since 15/02/2019
@version version
@return return, return_description
/*/
Static Function ImprimeRel(cId)
Private oPrint		:= nil
Private	nPbruto		:= 0
Private	nTotalUM	:= 0
Private nQtdUm 		:= 0
Private nUnidTtr	:= 0
Private nPag		:= 0

//Automatico
cFilePrint 			:= "RORTF004"

//Montagem do objeto para geração automatica do arquivo
oPrint 					:= FWMSPrinter():New("AUTOEMPENHO_"+cUserName+"_"+DTOS(Date()), IMP_PDF, .F. , ,.F. , , , , , , , .T.,  )

oPrint:SetPortrait()    //Modo retrato
oPrint:SetMargin(0,0,0,0)
oPrint:SetPaperSize(1)

If Empty(oPrint:oFileWriter:oErroLog:Message)
	
	Processa( {|| oPrint := GeraLinha(oPrint, cId) },"Aguarde imprimindo pedido..." )
		
	oPrint:Preview()
EndIf

If Type("oPrint:nHandle") <> 'U'
	FClose(oPrint:nHandle)
EndIf

FreeObj(oPrint)

Return

/*/{Protheus.doc} GeraLinha
//TODO Descrição auto-gerada.
@author Pirolo
@since 15/02/2019
@version version
parametersSection
@return return, return_description
/*/
Static Function GeraLinha(oPrint, cId)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaração de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cCodEmp		:= FWCodEmp()
Local cCodFil		:= FWCodFil()

//Local aArea		:= GetArea()
Local nLinCab		:= 0
Local nLimPag		:= 750 //IIF(cEmpAnt=="15",530,540)
Local nLinAdd		:= 0
Local nTotItens		:= 10
Local cQry			:= ""
Local cTMPAlia		:= GetNextAlias()
Local nTotReg		:= 0

cQry	:= "SELECT *						"+CRLF 
cQry	+= "FROM "+RetSqlName("SZS")+"		"+CRLF
cQry	+= "WHERE ZS_ID = '"+cId+"'			"+CRLF
cQry	+= "AND D_E_L_E_T_ <> '*'			"
cQry	+= "ORDER BY ZS_OP, ZS_ENDORI, ZS_SEQUENC	"

MemoWrite("RORTF005.SQL", cQry)
//Executa a query
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTMPAlia,.T.,.T.)

If (cTMPAlia)->(!Eof())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia impressao da pagina.                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:StartPage()
		
		MontaCabec(cId)
		
		ImprimeDetalhe(cTMPAlia)
	
	oPrint:EndPage()
EndIf

Return( oPrint )

/*/{Protheus.doc} ImprimeDetalhe
//TODO Imprime as linhas do relatório.
@author Pirolo
@since 11/06/2019
@version undefined
@param cTMPAlia, characters, descricao
@return return, return_description
/*/
Static Function ImprimeDetalhe(cTMPAlia)
Local nLinIni		:= 80
Local nI			:= 0
Local nJ			:= 0
Local nY			:= 0
Local nLinBase		:= 50
Local nLimPag		:= 750
Local cOpAnt		:= ""
Local nCol1			:= 20
Local nCol2			:= 90
Local nCol3			:= 150
Local nCol4			:= 400
Local nCol5			:= 450
Local nCol6			:= 520
Local nCol7			:= 540
LOCAL n_item		:= 0 //
local Folhas		:= 0 //

Local lSaltaOP		:= MsgYesNo("Deseja quebrar paginas por OP?", "Impressão")
Local nTotReg		:= 0

Local oFont8Cn		:= TFont():New("Courier New",7, 8,.T.,.T.,5,.T.,5,.T.,.F.) //
//Cria objeto com cores
oBrush 	:= TBrush():New(,RGB(192,192,192)) 
oBrush1 := TBrush():New(,RGB(0,0,0)) 


//MontaRodape()

//Pega o total de registros do alias
Count to nTotReg
	if ntotReg >42
		Folhas 	:= Int(nTotReg / 42 )
	else
		Folhas := 1	
	ENDIF
	//Folhas 	:= MOD(nTotReg,42 )

MontaRodape(Folhas)

//Dimensiona o ProcRegua
ProcRegua(nTotReg)
(cTMPAlia)->(DbGoTop())

While (cTMPAlia)->(!Eof())
	nI++
	If nLimPag > nLinIni+10 
		If lSaltaOP .AND. AllTrim(cOpAnt) <> Alltrim((cTMPAlia)->ZS_OP) .AND. nI > 1
			//Finaliza a página atual
			oPrint:EndPage()
			
			//Inicia uma nova página
			oPrint:StartPage()
			
			//Monta o cabeçalho
			MontaCabec((cTMPAlia)->ZS_ID)
			
			//Monta Rodapé
			MontaRodape(Folhas)
					
			//Reinicia a posição de base dos detalhes
			nLinIni := nLinBase-10
		Else
			nLinIni	:= Iif(nI == 1, nLinBase, nLinIni)
		EndIf
	Else		
		//Finaliza a página atual
		oPrint:EndPage()
		
		//Inicia uma nova página
		oPrint:StartPage()
		
		//Monta o cabeçalho
		MontaCabec((cTMPAlia)->ZS_ID)
		
		//Monta Rodapé
		MontaRodape(Folhas)
				
		//Reinicia a posição de base dos detalhes
		nLinIni := nLinBase
	EndIf
	//nQuant  := +AllTrim(Posicione("SC2", 1, xFilial("SC2")+(cTMPAlia)->ZS_OP,"C2_QUANT" ))
	//Produto retirada
	//dbSelectArea("SC2")
	//dbSetOrder(1)
	//dbSeek(xFilial("SC2")+ Alltrim((cTMPAlia)->ZS_OP))
	
	//dbSelectArea("SC2")
	//dbSetOrder(1)
	//dbSeek(xFilial(Alltrim((cTMPAlia)->ZS_OP)))
	//dbSeek((cTMPAlia)->ZS_OP))
	
	
	If AllTrim(cOpAnt) <> Alltrim((cTMPAlia)->ZS_OP)
	
		nLinIni += Iif(Empty(cOpAnt), 0, 10)
		
		oPrint:Say( nLinIni-15	, 010	,OemToAnsi("Ordem de Produção:   "+(cTMPAlia)->ZS_OP ) , oFonte14N)
		oPrint:Say(	nLinIni-15	, 250	,OemToAnsi("Usuário OP: "		+AllTrim(Posicione("SC2", 1, xFilial("SC2")+(cTMPAlia)->ZS_OP, "C2_XUSUARI"))),oFonte14N)
		oPrint:Line(nLinIni-10	, 010	, nLinIni-10, 600)
		oPrint:Say( nLinIni		, 010	,OemToAnsi("Produto: "			+AllTrim(Posicione("SC2", 1, xFilial("SC2")+(cTMPAlia)->ZS_OP, "C2_PRODUTO"))),oFonte14N)
		oPrint:Say( nLinIni		, 150	,OemToAnsi("Lote: "   			+AllTrim(Posicione("SC2", 1, xFilial("SC2")+(cTMPAlia)->ZS_OP, "C2_LOTECTL"))),oFonte14N)
		oPrint:Say( nLinIni		, 350	,OemToAnsi("Quantidade: "   	+ CVALTOCHAR( SC2->C2_QUANT ) ),oFonte14N)	
		oPrint:Line(nLinIni+5	, 010	, nLinIni+5	, 600)
		oPrint:Say( nLinIni+15	, 010	,OemToAnsi("Descrição: " 		+AllTrim(Posicione("SC2", 1, xFilial("SC2")+(cTMPAlia)->ZS_OP, "C2_XDESC"))),oFonte14N)
		oPrint:Line(nLinIni+20	, 010	, nLinIni+20, 600)
		oPrint:Say(	nLinIni+30	, 010	,OemToAnsi("Usuário Empenho : "	+AllTrim(ZS_USER)),oFonte14N)
		oPrint:Say(	nLinIni+30	, 250	,OemToAnsi("Empenho: "			+Iif(VerificaOPLib((cTMPAlia)->ZS_OP), "Atendido", "Não Atendido")),oFonte14N)
		
		//	C2_QUANT
		oPrint:FillRect({nLinIni+35,0010,nLinIni+50,600},oBrush)
	
		oPrint:Line(nLinIni+35	, 008	, nLinIni+35	, 600)
	
		nLinIni += 45
		
		oPrint:Say(   nLinIni	, nCol1-10	,OemToAnsi("ITEM"), oFonte08N)

		//Documento de Transferência
		oPrint:Say(   nLinIni	, nCol1+10	,OemToAnsi("DOCUMENTO"), oFonte08N)

		//Produto
		oPrint:Say(   nLinIni	, nCol2	,OemToAnsi("PRODUTO"), oFonte08N)

		//Descrição Produto
		oPrint:Say(   nLinIni	, nCol3	,OemToAnsi("DESCRIÇÃO"), oFonte08N)		
		
		//Lote
		oPrint:Say(   nLinIni	, nCol4	,OemToAnsi("LOTE"), oFonte08N)
		
		//Endereço
		oPrint:Say(   nLinIni	, nCol5	,OemToAnsi("ENDEREÇO"), oFonte08N)

		//Unidade Medida
		oPrint:Say(   nLinIni	, nCol6	,OemToAnsi("UM."), oFonte08N)
		
		//Quantidade
		oPrint:Say(   nLinIni	, nCol7	,OemToAnsi("QUANTIDADE"), oFonte08N)
				
		nLinIni += 15
	EndIf
	
	n_item +=1

	oPrint:Line(nLinIni+5	, 0020	, nLinIni+5	, 600)

	oPrint:Say(   nLinIni	, nCol1-10	, CVALTOCHAR( n_item ), oFont8Cn )

	//Documento de Transferência
	oPrint:Say(   nLinIni	, nCol1+10	,OemToAnsi((cTMPAlia)->ZS_DOC), oFonte08)

	//Produto
	oPrint:Say(   nLinIni	, nCol2	,OemToAnsi((cTMPAlia)->ZS_PRODUTO), oFonte08)

	//Descrição Produto
	oPrint:Say(   nLinIni	, nCol3	,OemToAnsi(Substring(Posicione("SB1",1,xFilial("SB1")+(cTMPAlia)->ZS_PRODUTO,"B1_DESC"), 1, 60)), oFonte08)
	
	//Lote
	oPrint:Say(   nLinIni	, nCol4	,OemToAnsi((cTMPAlia)->ZS_LOTECTL), oFonte08)
	
	//Endereço
	oPrint:Say(   nLinIni	, nCol5	,OemToAnsi((cTMPAlia)->ZS_ENDORI), oFonte08)

	//Unidade de Medida
	oPrint:Say(   nLinIni	, nCol6	,OemToAnsi(Substring(Posicione("SB1",1,xFilial("SB1")+(cTMPAlia)->ZS_PRODUTO,"B1_UM"), 1, 60)), oFonte08)
	
	//Quantidade
	oPrint:Say(   nLinIni	, nCol7	,OemToAnsi(Transform((cTMPAlia)->ZS_QUANT, "@E 9999999999999.99")), oFonte08)
	
	nLinIni += 15

	cOpAnt := (cTMPAlia)->ZS_OP

	IncProc()
	(cTMPAlia)->(DbSkip())
End

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Escreve cabeçalho.		                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function MontaCabec(cId)
	oBrush 	:= TBrush():New(,RGB(192,192,192)) 
	//oPrint:Box(0010, 010,50,600)
	oPrint:Box(008, 010,23,600)
	//oPrint:Say(0020, 020, OemToAnsi("Relatório de Auto Empenhos - "+DtoC(Date())+" "+Time()+" - ID Processamento: "+cId)	,oFonte16N)
	oPrint:Say(0020, 150, OemToAnsi("Relatório de Auto Empenhos - "+DtoC(Date())+" "+Time() )	,oFonte16N)
	If nPag >= 1
		oPrint:FillRect({025,010,040,600},oBrush)
		oPrint:Say(035,010,OemToAnsi("ITEM")		,oFonte08N)
		oPrint:Say(035,030,OemToAnsi("DOCUMENTO")	,oFonte08N)
		oPrint:Say(035,090,OemToAnsi("PRODUTO")		,oFonte08N)
		oPrint:Say(035,150,OemToAnsi("DESCRIÇÃO")	,oFonte08N)		
		oPrint:Say(035,400,OemToAnsi("LOTE")		,oFonte08N)
		oPrint:Say(035,450,OemToAnsi("ENDEREÇO")	,oFonte08N)
		oPrint:Say(035,520,OemToAnsi("UM.")			,oFonte08N)
		oPrint:Say(035,540,OemToAnsi("QUANTIDADE")	,oFonte08N)	
	ENDIF

Return

//TODO Monta o rodapé do relatório.
Static Function MontaRodape(Folhas)
//oPrint:Box(0730, 010,745,600)
	oPrint:Box(750, 010,765,600)
	//Imprime rodapé com numero da pagina
	InsereNumPag(Folhas)
Return

//TODO Controla e insere o numero da pagina no rodapé do relatório.
Static function InsereNumPag(Folhas)
	//Totaliza o n.º de paginas
	nPag +=1
	//Imprime rodapé com numero da pagina
	//oPrint:Say(0740	, 0560	,OemToAnsi("Pag.:"+Transform(nPag, "@E 999")), oFonte08)
	oPrint:Say(0760	, 0550	,OemToAnsi("Pag.:"+Transform(nPag, "@E 999")+" / "+ CVALTOCHAR( Folhas )), oFonte08)
Return

/*/{Protheus.doc} VerificaOPLib
//TODO Verifica se a OP já foi totalmente empenhada
/*/
Static Function VerificaOPLib(cOp)
Local cQry		:= ""
Local cTMPAlia	:= GetNextAlias()
Local lRet		:= .F.
Local nCount	:= 0

cQry	:= "SELECT DISTINCT D4_LOCAL   "+CRLF
cQry	+= "FROM "+RetSqlName("SD4")+" "+CRLF
cQry	+= "WHERE D4_OP = '"+cOp+"'    "+CRLF
cQry	+= "AND   D_E_L_E_T_ = ' '     "

//Executa a query
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTMPAlia,.T.,.T.)

//Verifica qtde de registros na query
Count to nCount

//Posiciona no primeiro registro
(cTMPAlia)->(DbGoTop())

//Se tiver mais de um armazem na query já sabemos que não esta liberada
//Se tiver apenas um verifica se é o de Produção
lRet := nCount == 1 .AND. AllTrim((cTMPAlia)->D4_LOCAL) == AllTrim(SuperGetMV("MV_XLCDESTI",.F.,"96"))


Return lRet
