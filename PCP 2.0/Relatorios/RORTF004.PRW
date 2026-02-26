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
Static oFonte11N	:= tFont():New("ARIAL"		,11,11,,.T.,,,,.T.,.F.)
Static oFonte12		:= tFont():New("ARIAL"		,12,12,,.F.,,,,.T.,.F.)
Static oFonte12N	:= tFont():New("ARIAL"		,12,12,,.T.,,,,.T.,.F.)
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
Static _oFonte06	:= tFont():New("Courier New"	,06,06,,.F.,,,,.T.,.F.)
Static _oFonte06N	:= tFont():New("Courier New"	,06,06,,.T.,,,,.T.,.F.)
Static _oFonte08	:= tFont():New("Courier New"	,08,08,,.F.,,,,.T.,.F.)
Static _oFonte08N	:= tFont():New("Courier New"	,08,08,,.T.,,,,.T.,.F.)
Static _oFonte10	:= tFont():New("Courier New"	,10,10,,.F.,,,,.T.,.F.)
Static _oFonte10N	:= tFont():New("Courier New"	,10,10,,.T.,,,,.T.,.F.)
Static _oFonte12	:= tFont():New("Courier New"	,12,12,,.F.,,,,.T.,.F.)
Static _oFonte12N	:= tFont():New("Courier New"	,12,12,,.T.,,,,.T.,.F.)
Static _oFonte14	:= tFont():New("Courier New"	,14,14,,.F.,,,,.T.,.F.)
Static _oFonte14N	:= tFont():New("Courier New"	,14,14,,.T.,,,,.T.,.F.)
Static _oFonte16	:= tFont():New("Courier New"	,16,16,,.F.,,,,.T.,.F.)
Static _oFonte16N	:= tFont():New("Courier New"	,16,16,,.T.,,,,.T.,.F.)

User Function RORTF004(aDados, lSaltaOP, cId)
//RpcSetType(3)
//RpcSetEnv("01", "01")
//If Len(aDados) > 0
	Processa( {|| ImprimeRel(aDados, lSaltaOP, cId) },"Aguarde imprimindo pedido..." )
//EndIf

Return( Nil )

/*/{Protheus.doc} ImprimeRel
//TODO Descrição auto-gerada.
@author author
@since 15/02/2019
@version version
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function ImprimeRel(aDados, lSaltaOP, cId)
Private oPrint		:= nil
Private	nPbruto		:= 0
Private	nTotalUM	:= 0
Private nQtdUm 		:= 0
Private nUnidTtr	:= 0
Private nPag		:= 0
//Automatico
cFilePrint 		:= "RORTF004"


FERASE("C:\temp\formentreg.pdf")

//Montagem do objeto para geração automatica do arquivo
oPrint 					:= FWMSPrinter():New("FormEntreg", IMP_PDF, .F. , ,.T. , , , , , , , .F.,  )
oPrint:cPathPDF 		:= "C:\temp\"
//oPrint:Setup()
oPrint:SetPortrait()    //Modo retrato
oPrint:SetMargin(0,0,0,0)
oPrint:SetPaperSize(1)

If Empty(oPrint:oFileWriter:oErroLog:Message)
	
	oPrint	:= GeraLinha(oPrint, aDados, lSaltaOP, cId)
	
	//oPrint:Print()
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
@example
(examples)
@see (links_or_references)
/*/
Static Function GeraLinha(oPrint, aDados, lSaltaOP, cId)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaração de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cCodEmp		:= FWCodEmp()
Local cCodFil		:= FWCodFil()

//Local aArea		:= GetArea()
Local nLinCab		:= 0
Local nLimPag		:= 780 //IIF(cEmpAnt=="15",530,540)
Local nLinAdd		:= 0
Local nTotItens		:= 10

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia impressao da pagina.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:StartPage()
	
	MontaCabec(cId)
	
	ImprimeDetalhe(aDados, lSaltaOP, cId)

oPrint:EndPage()


Return( oPrint )

Static Function ImprimeDetalhe(aDados, lSaltaOP, cId)
Local nLinIni		:= 80
Local nI			:= 0
Local nJ			:= 0
Local nY			:= 0
Local nLinBase		:= 50
Local nLimPag		:= 564
Local cOpAnt		:= ""
Local nCol1			:= 20
Local nCol2			:= 90
Local nCol3			:= 150
Local nCol4			:= 400
Local nCol5			:= 460
Local nCol6			:= 540
MontaRodape()

For nI := 1 to Len(aDados)
	If nLimPag > nLinIni+10 
		If lSaltaOP .AND. AllTrim(cOpAnt) <> Alltrim(aDados[nI, 2]) .AND. nI > 1
			//Finaliza a página atual
			oPrint:EndPage()
			
			//Inicia uma nova página
			oPrint:StartPage()
			
			//Monta o cabeçalho
			MontaCabec(cId)
			
			//Monta Rodapé
			MontaRodape()
					
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
		MontaCabec(cId)
		
		//Monta Rodapé
		MontaRodape()
				
		//Reinicia a posição de base dos detalhes
		nLinIni := nLinBase
	EndIf
	
	//Produto retirada
	If AllTrim(cOpAnt) <> Alltrim(aDados[nI, 2])
		nLinIni += Iif(Empty(cOpAnt), 0, 10)
		
		oPrint:Say(   nLinIni	, 420	,OemToAnsi("Ordem de Produção: "+aDados[nI, 2]), oFonte13N)
		oPrint:Line(  nLinIni+2	, 010	, nLinIni+2	, 590)
		nLinIni += 12
		
		//Documento de Transferência
		oPrint:Say(   nLinIni	, nCol1	,OemToAnsi("Documento"), oFonte08N)

		//Produto
		oPrint:Say(   nLinIni	, nCol2	,OemToAnsi("Produto"), oFonte08N)

		//Descrição Produto
		oPrint:Say(   nLinIni	, nCol3	,OemToAnsi("Descrição"), oFonte08N)		
		
		//Lote
		oPrint:Say(   nLinIni	, nCol4	,OemToAnsi("Lote"), oFonte08N)
		
		//Endereço
		oPrint:Say(   nLinIni	, nCol5	,OemToAnsi("Endereço"), oFonte08N)

		//Quantidade
		oPrint:Say(   nLinIni	, nCol6	,OemToAnsi("Quantidade"), oFonte08N)
				
		nLinIni += 10
	EndIf
	
	For nJ := 1 to Len(aDados[nI, 5])
		//Documento de Transferência
		oPrint:Say(   nLinIni	, nCol1	,OemToAnsi(aDados[nI, 5, nJ, 1]), oFonte08)

		//Produto
		oPrint:Say(   nLinIni	, nCol2	,OemToAnsi(aDados[nI, 3]), oFonte08)

		//Descrição Produto
		oPrint:Say(   nLinIni	, nCol3	,OemToAnsi(Posicione("SB1",1,xFilial("SB1")+aDados[nI, 3],"B1_DESC")), oFonte08)
		
		//Lote
		oPrint:Say(   nLinIni	, nCol4	,OemToAnsi(aDados[nI, 5, nJ, 4]), oFonte08)
		
		//Endereço
		oPrint:Say(   nLinIni	, nCol5	,OemToAnsi(aDados[nI, 5, nJ, 3]), oFonte08)

		//Quantidade
		oPrint:Say(   nLinIni	, nCol6	,OemToAnsi(Transform(aDados[nI, 5, nJ, 5], "@E 9999999999999.99")), oFonte08)
		
		nLinIni += 10
	Next nJ
	cOpAnt := aDados[nI, 2]
Next nI

Return

Static Function MontaCabec(cId)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Escreve cabeçalho.		                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oPrint:Box(0010, 010,50,600)
oPrint:Box(0010, 010,23,600)
oPrint:Say(0020, 0200, OemToAnsi("Relatório de Auto Empenhos - "+DtoC(Date())+" "+Time()+" - ID Processamento: "+cId)	,oFonte10N)

Return

Static Function MontaRodape()
	oPrint:Box(0730, 010,745,600)

	//Imprime rodapé com numero da pagina
	InsereNumPag()
Return

/*/{Protheus.doc} InsereNumPag
//TODO Descrição auto-gerada.
@author Pirolo
@since 18/04/2019
@version undefined

@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static function InsereNumPag()
//Totaliza o n.º de paginas
nPag +=1

//Imprime rodapé com numero da pagina
oPrint:Say(0740	, 0560	,OemToAnsi("Pag.:"+Transform(nPag, "@E 999")), oFonte08)

Return

//User Function RORTF004()

//Return