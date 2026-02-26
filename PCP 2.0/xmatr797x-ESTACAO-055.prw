#Include "MATR797.CH"
#Include "TOPCONN.CH"
#Include "PROTHEUS.CH"
#Include "TBICONN.CH"
#Include "APWIZARD.CH"
#Include "FILEIO.CH"
#Include "RPTDEF.CH"
#Include "FWPrintSetup.ch"
#Include "TOTVS.CH"
#Include "PARMTYPE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR797  ³ Autor ³ Anieli Rodrigues	    ³ Data ³ 13/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ordens de Producao Ortopedia                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function xMTR797X(n_RecnoSZ7)

Local aOrdem     :={STR0001, STR0002, STR0003, STR0004} //"Por Numero"//"Por Produto"//"Por Centro de Custo"//"Por Prazo de Entrega"
Local aDevice    := {}
Local bParam     :={|| }
Local cDevice    := ""
Local cRelName   := "MATR797"
Local cSession   := GetPrinterSession()
Local lAdjust    := .F.
Local nFlags     := PD_ISTOTVSPRINTER //+PD_DISABLEPAPERSIZE
Local nLocal     := 1
Local nOrdem     := 1
Local nOrient    := 1
Local nPrintType := 6
Local oPrinter   := Nil
Local oSetup     := Nil
Private aArray   := {}
Private li       := 15
Private nMaxLin  := 0
Private nMaxCol  := 0
Private lItemNeg := GetMv("MV_NEGESTR") //.And. MV_PAR11 == 1

Private _nQtdPrt := 0	// Quantidade de Impressoes da OP // Não Excluir

Private _lImpEsp := .F.

Default n_RecnoSZ7 := 0

DbSelectArea('SZ7')		// DESMEMBRAMENTO ORDEM PRODUCAO
SZ7->(DbSetOrder(1))	// Z7_FILIAL+Z7_NUMOP+Z7_ITEM+Z7_SEQUEN+Z7_BARRA+Z7_PRODUTO

If !Empty(n_RecnoSZ7)
	// Posiciona no registro
	SZ7->(DbGoTo(n_RecnoSZ7))

	// Se conseguiu posicionar
	_lImpEsp := SZ7->(!Eof())
EndIf

// Se não for impressão especifica
If !_lImpEsp
	// Preenche o bloco de codigo com o pergunte
	bParam := {|| _fPergunte() }

	// Realiza os perguntes
	Eval(bParam)
EndIf

cRelName := AllTrim(MV_PAR01)+"_"+AllTrim(MV_PAR02)

_lTemInsp	:= .F. // Variavel de COntrole NAO REVOMER -- DEMA
nPagina		:= 0
_cProdPai 	:= ""

AADD(aDevice,"DISCO") // 1
AADD(aDevice,"SPOOL") // 2
AADD(aDevice,"EMAIL") // 3
AADD(aDevice,"EXCEL") // 4
AADD(aDevice,"HTML" ) // 5
AADD(aDevice,"PDF"  ) // 6

cSession := GetPrinterSession()

// Obtem ultima configuracao de tipo de impressão (spool ou pdf) gravada no arquivo de configuracao
cDevice := If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))

// Obtem ultima configuracao de orientacao de papel (retrato ou paisagem) gravada no arquivo de configuracao
nOrient := If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)

// Obtem ultima configuracao de destino (cliente ou servidor) gravada no arquivo de configuracao
nLocal := If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
nPrintType := aScan(aDevice,{|x| x == cDevice })

oPrinter := FWMSPrinter():New(cRelName,nPrintType,lAdjust,,.T.)

// Cria e exibe tela de Setup Customizavel - Utilizar include "FWPrintSetup.ch"

oSetup := FWPrintSetup():New (nFlags,cRelName)
oSetup:SetPropert(PD_PRINTTYPE,nPrintType)
oSetup:SetPropert(PD_ORIENTATION,nOrient)
oSetup:SetPropert(PD_DESTINATION,nLocal)
oSetup:SetPropert(PD_MARGIN,{0,0,0,0})
oSetup:SetOrderParms(aOrdem,@nOrdem)

If !_lImpEsp
	oSetup:SetUserParms(bParam)
EndIf

If oSetup:Activate() == PD_OK
	// Grava ultima configuracao de destino (cliente ou servidor) no arquivo de configuracao
	fwWriteProfString( cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
	// Grava ultima configuracao de tipo e impressao (spool ou pdf) no arquivo de configuracao
	fwWriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )
	// Grava ultima configuracao de orientacao de papel (retrato ou paisagem) no arquivo de configuracao
	fwWriteProfString( cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )
	// Atribui configuracao de destino (cliente ou servidor) ao objeto FwMsPrinter
	oPrinter:lServer := oSetup:GetProperty(PD_DESTINATION) == AMB_SERVER
	// Atribui configuracao de tipo de impressao (spool ou pdf) ao objeto FwMsPrinter
	oPrinter:SetDevice(oSetup:GetProperty(PD_PRINTTYPE))
	// Atribui configuracao de orientacao de papel (retrato ou paisagem) ao objeto FwMsPrinter
	If oSetup:GetProperty(PD_ORIENTATION) == 1
		oPrinter:SetPortrait()
		nMaxLin	:= 800
		nMaxCol	:= 600
	Else
		oPrinter:SetLandscape()
		nMaxLin	:= 600
		nMaxCol	:= 800
	EndIf
	// Atribui configuracao de tamanho de papel ao objeto FwMsPrinter
	oPrinter:SetPaperSize(oSetup:GetProperty(PD_PAPERSIZE))
	oPrinter:setCopies(Val(oSetup:cQtdCopia))
	If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
		oPrinter:nDevice := IMP_SPOOL
		fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
		oPrinter:cPrinter := oSetup:aOptions[PD_VALUETYPE]
	Else
		oPrinter:nDevice := IMP_PDF
		oPrinter:cPathPDF := oSetup:aOptions[PD_VALUETYPE]
		oPrinter:SetViewPDF(.T.)
	Endif
	
	oFontTBx 	:= TFont():New('Courier new',,7,.T.,.T.)
	oFontT 		:= TFont():New('Courier new',,8,.T.)
	oFontTB 	:= TFont():New('Courier new',,8,.T.,.T.)
	oFontC 		:= TFont():New('Courier new',,12,.T.)
	oFontCB 	:= TFont():New('Courier new',,12,.T.,.T.)
	oFont14N 	:= TFont():New('Courier new',,14,.T.,.T.)
	oFont16N 	:= TFont():New('Courier new',,16,.T.,.T.)
	
	RptStatus({|lEnd| U_xMt797Proc(@lEnd,nOrdem, @oPrinter)},"Imprimindo Relatorio...")
Else
	MsgInfo(STR0005)//"Relatório cancelado pelo usuário."
	oPrinter:Cancel()
EndIf

oSetup:= Nil
oPrinter:= Nil

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | Mtr797Proc ³ Autor ³ Anieli Rodrigues      ³ Data ³22/03/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua o processamento do relatorio	                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR797                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xMt797Proc(lEnd, nOrdem, oPrinter)

Local _cBmp        := ""
Local _cNumOP      := ""

Local _nCount      := 0

Local _aBmp        := {}
Local _aProdSeq1   := {}
Local _cAuxEnd     := {} // alte 16/03
Local _cnAux       := 0 // alte 16/03
Local xpage        := 0
Private _cAliasTop := "SC2"

Private _nQuantOP  := 0

DbSelectArea("SC2")		// ORDENS DE PRODUÇÃO
SC2->(DbSetOrder(1))	// C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD

DbSelectArea("SB1")		// DESCRIÇÃO GENÉRICA DO PRODUTO
SB1->(DbSetOrder(1))	// B1_FILIAL+B1_COD

// Monta a query principal
_cAliasTop := _fMkQryPrn(nOrdem)

AEval(SC2->(dbStruct()),{|x| IIf(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(_cAliasTop,x[1],x[2],x[3],x[4]),Nil) })

// Posiciona na query
DbSelectArea(_cAliasTop)

// Posiciona no primeiro registro
(_cAliasTop)->(DbGoTop())

// Se não tiver informação
If (_cAliasTop)->(Eof())
	MsgAlert('Não existe dados para os parâmetros informados! Verifique.','Atenção')
Else
	// Seta a regua
	SetRegua(fConta(_cAliasTop))

	// Enquanto não for final de arquivo
	While (_cAliasTop)->(!Eof())
		_nQtdPrt := (_cAliasTop)->C2_XQTDPRT
		cProduto := (_cAliasTop)->C2_PRODUTO

		IF lEnd
			oPrinter:StartPage()
			oPrinter:Say(li,5,STR0006)//"CANCELADO PELO OPERADOR"
			oPrinter:EndPage()
			oPrinter:Print()
			Exit
		EndIF

		// Atualiza a regua
		IncRegua()
		
		If !MtrAValOP(MV_PAR10,"SC2",_cAliasTop)
			dbSkip()
			Loop
		EndIf
		
		// Guarda a quantidade
		_nQuantOP := aSC2Sld(_cAliasTop)
		
		// Posiciona no produto
		SB1->(DbSeek(xFilial("SB1")+(_cAliasTop)->C2_PRODUTO))

		// Adiciona o primeiro elemento da estrutura , ou seja , o Pai
		AddAr797(_nQuantOP)

		// Monta um array com a estrutura do produto
		MontStruc((_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))

		If MV_PAR09 == 1
			ASort(aArray,2,,{|x,y| (x[1]+x[8]) < (y[1]+y[8]) })
		Else
			ASort(aArray,2,,{|x,y| (x[8]+x[1]) < (y[8]+y[1]) })
		EndIf

		// Imprime cabecalho
		If AllTrim(_cNumOP) <> AllTrim((_cAliasTop)->(C2_NUM))
			nPagina := 1
			cabecOp(nPagina,oPrinter,0,.T.)
			_cNumOP := (_cAliasTop)->(C2_NUM)
		Else
			If li > (nMaxLin-200)
				oPrinter:EndPage()
				Li := 15
				nPagina++
				cabecOp(nPagina,oPrinter,0,.T.)
			Else
				cabecOp(nPagina,oPrinter,li,.T.)
			EndIf
		EndIf
		
		//Cria Box Itens dos COMPONENTES
		If (_cAliasTop)->(C2_PRODUTO) == "REESTERILIZACAO"
			oPrinter:Box(Li,001,Li+(15*10),070) // Codigo - 070 Pos
			oPrinter:Box(Li,070,Li+(15*10),270) // Descricao - 220 Pos
			oPrinter:Box(Li,270,Li+(15*10),340) // Quantidade - 070 Pos
			oPrinter:Box(Li,340,Li+(15*10),370) // U.M. - 030 Pos
			oPrinter:Box(Li,370,Li+(15*10),390) // Armazem - 020 Pos
			oPrinter:Box(Li,390,Li+(15*10),460) // Endereco - 100 Pos
			oPrinter:Box(Li,460,Li+(15*10),490) // 2a U.M. Sigla - 030 Pos
			oPrinter:Box(Li,490,Li+(15*10),550) // Lote - 060 Pos
			oPrinter:Box(Li,550,Li+(15*10),nMaxCol-10) // 2 U.M. - 040 Pos
			Li+=(15*10)
		Else		
			oPrinter:Box(Li,001,Li+(Len(aArray)*10),070) // Codigo - 070 Pos
			oPrinter:Box(Li,070,Li+(Len(aArray)*10),300) // Descricao - 220 Pos
			oPrinter:Box(Li,300,Li+(Len(aArray)*10),340) // Quantidade - 070 Pos    270
			oPrinter:Box(Li,340,Li+(Len(aArray)*10),370) // U.M. - 030 Pos
			oPrinter:Box(Li,370,Li+(Len(aArray)*10),390) // Armazem - 020 Pos
			oPrinter:Box(Li,390,Li+(Len(aArray)*10),460) // Endereco - 100 Pos
			oPrinter:Box(Li,460,Li+(Len(aArray)*10),490) // 2a U.M. Sigla - 030 Pos
			oPrinter:Box(Li,490,Li+(Len(aArray)*10),550) // Lote - 060 Pos
			oPrinter:Box(Li,550,Li+(Len(aArray)*10),nMaxCol-10) // 2 U.M. - 040 Pos
		EndIf
		
		For _nCount := 2 TO Len(aArray)
			cQtd := Transform(aArray[_nCount][5],PesqPictQt("D4_QUANT",TamSX3("D4_QUANT")[1]))
			cQtd2:= Transform(aArray[_nCount][12],PesqPictQt("D4_QUANT",TamSX3("D4_QUANT")[1]))
			_cAuxEnd  := aArray[_nCount][13]
				//Array com os endereços diferentes e com o mesmo numero de Lote.
				iF !Empty(_cAuxEnd) 
					For _cnAux := 1 To Len(_cAuxEnd)
					oPrinter:Box(Li,001,Li+10,070) // Codigo - 070 Pos
					oPrinter:Box(Li,070,Li+10,300) // Descricao - 220 Pos
					oPrinter:Box(Li,300,Li+10,340) // Quantidade - 070 Pos    270
					oPrinter:Box(Li,340,Li+10,370) // U.M. - 030 Pos
					oPrinter:Box(Li,370,Li+10,390) // Armazem - 020 Pos
					oPrinter:Box(Li,390,Li+10,460) // Endereco - 100 Pos
					oPrinter:Box(Li,460,Li+10,490) // 2a U.M. Sigla - 030 Pos
					oPrinter:Box(Li,490,Li+10,550) // Lote - 060 Pos
					oPrinter:Box(Li,550,Li+10,nMaxCol-10) // 2 U.M. - 040 Pos
					
					oPrinter:Say(Li+07,002,aArray[_nCount][1]		  ,oFontTBX)  //"CODIGO"
					oPrinter:Say(Li+07,072,Alltrim(aArray[_nCount][2]),oFontTBx) //"DESCRICAO"
					oPrinter:Say(Li+07,280,Transform(_cAuxEnd[_cnAux][1],PesqPictQt("D4_QUANT",TamSX3("D4_QUANT")[1])) ,oFontTB) //"QUANTIDADE"       272
					oPrinter:Say(Li+07,345,aArray[_nCount][4],oFontTB)  //"UM"
					oPrinter:Say(Li+07,372,aArray[_nCount][6],oFontTB)  //"ARM"
					oPrinter:Say(Li+07,396,_cAuxEnd[_cnAux][2],oFontTB) //"ENDERECO"
					oPrinter:Say(Li+07,462,Posicione("SB1",1,xFilial("SB1")+aArray[_nCount][1],"B1_SEGUM"),oFontTB) //"2a UM Sigla"
					oPrinter:Say(Li+07,495,aArray[_nCount][10],oFontTB) //"LOTE"
					oPrinter:Say(Li+07,560,AllTrim(Transform(_cAuxEnd[_cnAux][5],PesqPictQt("D4_QUANT",TamSX3("D4_QUANT")[1]))),oFontTB) //"2 UM"
					//oPrinter:Line(Li+13,001,Li+13,nMaxCol-10)// Linha vertical descrição
					
					Li+=10
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se nao couber, salta para proxima folha                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If li >= nMaxLin-140
						oPrinter:EndPage()
						Li := 15
						nPagina++
						CabecOp(nPagina,oPrinter,0,.T.)		// imprime cabecalho da OP
					EndIF
					Next _cnAux
				  Else
					oPrinter:Box(Li,001,Li+10,070) // Codigo - 070 Pos
					oPrinter:Box(Li,070,Li+10,300) // Descricao - 220 Pos
					oPrinter:Box(Li,300,Li+10,340) // Quantidade - 070 Pos    270
					oPrinter:Box(Li,340,Li+10,370) // U.M. - 030 Pos
					oPrinter:Box(Li,370,Li+10,390) // Armazem - 020 Pos
					oPrinter:Box(Li,390,Li+10,460) // Endereco - 100 Pos
					oPrinter:Box(Li,460,Li+10,490) // 2a U.M. Sigla - 030 Pos
					oPrinter:Box(Li,490,Li+10,550) // Lote - 060 Pos
					oPrinter:Box(Li,550,Li+10,nMaxCol-10) // 2 U.M. - 040 Pos
					
					oPrinter:Say(Li+010,002,aArray[_nCount][1]			,oFontTB) //"CODIGO"
					oPrinter:Say(Li+010,072,Alltrim(aArray[_nCount][2])	,oFontTBx) //"DESCRICAO"
					oPrinter:Say(Li+010,288,cQtd,oFontTB) //"QUANTIDADE"       272
					oPrinter:Say(Li+010,342,aArray[_nCount][4],oFontTB) //"UM"
					oPrinter:Say(Li+010,372,aArray[_nCount][6],oFontTB) //"ARM"
					oPrinter:Say(Li+010,392,aArray[_nCount][7],oFontTB) //"ENDERECO"
					oPrinter:Say(Li+010,462,Posicione("SB1",1,xFilial("SB1")+aArray[_nCount][1],"B1_SEGUM"),oFontTB) //"2a UM Sigla"
					oPrinter:Say(Li+010,490,aArray[_nCount][10],oFontTB) //"LOTE"
					oPrinter:Say(Li+010,550,AllTrim(cQtd2),oFontTB)      //"2 UM"
					Li+=10
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se nao couber, salta para proxima folha                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If li >= nMaxLin-140
						oPrinter:EndPage()
						Li := 15
						nPagina++
						CabecOp(nPagina,oPrinter,0,.T.)	// imprime cabecalho da OP
					EndIF
				EndIf	
		Next
		
		If MV_PAR05 == 1
			If li >= (nMaxLin-140)
				oPrinter:EndPage()
				Li := 15
				nPagina++
				CabecOp(nPagina,oPrinter,0,.F.)	// imprime cabecalho da OP
			EndIF
			RotOper(oPrinter)  // IMPRIME ROTEIRO DAS OPERACOES
		Endif

		// Se for impressão especifica e a sequencia for 1
		If _lImpEsp .And. SC2->C2_SEQUEN == PadL("1",TamSx3("C2_SEQUEN")[1],"0")
			// Guarda a Op
			Aadd(_aProdSeq1,AllTrim((_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)) + "/" + SZ7->Z7_BARRA + " LOTE: " + (_cAliasTop)->C2_LOTECTL)

			// Guarda o produto
			Aadd(_aProdSeq1,aArray[1][1])

			// Guarda a descrição
			Aadd(_aProdSeq1,aArray[1][2])

			// Guarda o autor
			Aadd(_aProdSeq1,AllTrim(FWLEUSERLG("C2_USERLGI",1)))

			// Guarda a emissao
			Aadd(_aProdSeq1,DTOC((_cAliasTop)->C2_EMISSAO))

			// Guarda a data de previsão de entrega
			Aadd(_aProdSeq1,DTOC((_cAliasTop)->C2_DATPRF))
		EndIf

		aArray:={}
		li+=10

		// Atualiza a SC2
		_fAtualSC2((_cAliasTop)->SC2RECNO)

		// vai para o proximo registro
		(_cAliasTop)->(DbSkip())

		_cAlias := Alias()
		dbSelectArea("SZ2")
		dbSetOrder(1)
		//_aBmp := "\jpg\"+AllTrim(_cProdPai)+"\"+AllTrim(_cProdPai)+"_page_1.jpg" // Buscar nome em tabela especifica
		
		If dbSeek(xFilial("SZ2")+cProduto)	
			
			_aBmp := StrTokArr( AllTrim(SZ2->Z2_ARQDESE) , ";" ) // Nome das figuras Separado por ; sem EXTENSAO, cria um Array

			For _nCount := 1 to Len(_aBmp) // Le o Array com as Figuras a serem impressas
				If Empty(_aBmp[_nCount])
					Loop
				EndIf

				//_cBmp := "\dirdoc\co01\shared\"+AllTrim(_aBmp[_nCount])+".jpg" // Nome do Arquivo Referente a Imagem
				_cBmp := "O:\Desenhos em PDF\Desenhos JPG Ortopedia\"+AllTrim(_aBmp[_nCount])+".jpg" 
				// Se encontrar o registro
				If File(_cBmp)
					oPrinter:SetLandscape()
					oPrinter:StartPage()
					// lin, col, jpg, larg, alt
					oPrinter:SayBitmap( 0000,0000,_cBmp,0600,0800 )
					oPrinter:SetPortrait()
					li+=50
					//Por Samuel Miranda 25/09/2023
					//Adicionado para imprim duar paginas em branco, Solicitado Por: Luis Riardo (PCP)
					If File(_cBmp)
						For xpage := 1 to 2
							oPrinter:SetLandscape()
							oPrinter:StartPage()
							// lin, col, jpg, larg, alt
							//oPrinter:SayBitmap( 0000,0000,_cBmp,0600,0800 )
							oPrinter:SetPortrait()
							li+=50
						Next xpage
					EndIf
				EndIf
			Next
		EndIf	
		dbSelectArea(_cAlias)
	EndDo

	// Se for a impressão especifica e tiver o produto da sequencia 1
	If _lImpEsp .And. !Empty(_aProdSeq1)
		oPrinter:EndPage()
		Li := 15
		nPagina++

		CabecOp(nPagina,oPrinter,0,.F.,_aProdSeq1,.T.)		// imprime cabecalho da OP
	EndIf		
EndIf


dbSelectArea("SH8")
dbCloseArea()

dbSelectArea("SC2")
(_cAliasTop)->(dbCloseArea())

dbClearFilter()
dbSetOrder(1)

oPrinter:Print()

Return

/*/{Protheus.doc} _fPergunte
	(Função para realizar os perguntes)

	@type Static Function
	@author Vitor Ribeiro
	@since 08/02/2019

	@return _lContinua, logico, se continua ou não
	/*/
Static Function _fPergunte()

	Local _lContinua := .F.

	// Ajusta o SX1
	AjustaSX1()

	// Realiza o pergunte
	_lContinua := Pergunte("MTR797",.T.)

	// Sempre Imprimir Lote
	MV_PAR12 := 1

Return _lContinua

/*/{Protheus.doc} _fMkQryPrn
	(Função para realizar a query principal)

	@type Static Function
	@author Vitor Ribeiro
	@since 08/02/2019

	@return _cAlias, caracter, retorna o alias da query
	/*/
Static Function _fMkQryPrn(n_Ordem)

	Local _cWhere := ""
	Local _cOrdem := ""
	Local _cExpre := ""
	Local _cAlias := ""

	Local _aTamanho := {}

	Default n_Ordem := 0

	_aTamanho := TamSX3("C2_DATRF")

	If MV_PAR08 == 2
		_cWhere += " AND SC2.C2_DATRF = '" + Space(_aTamanho[1]) + "' "
	Endif

	// Parametro Novo - 29/08/2017 -- Imprime apenas OPs do usuario Logado
	If MV_PAR14 == 1                                                                                 
		_cWhere += " AND C2_XUSUARI = '" + cUserName + "' "
	 
	 // Leonardo 12/03/2019
	 //_cWhere += " AND SUBSTRING(C2_XUSUARI,1,15) = '" + Substr(UsrFullName(__CUSERID),1,15) + "' "
	EndIf

	// Imprime Ordem Inversa?
	If MV_PAR13 == 2	// Não
		If n_Ordem == 4
			_cOrdem := "ORDER BY SC2.C2_FILIAL, SC2.C2_DATPRF"
		Else
			_cOrdem := "ORDER BY " + SqlOrder(SC2->(IndexKey(n_Ordem)))
		EndIf
	Else				// Sim
		_cOrdem := "ORDER BY C2_NUM,C2_ITEM,C2_SEQUEN DESC"
	EndIf

	_cExpre := "%" + _cWhere + _cOrdem + "%"

	// Pega o proximo alias
	_cAlias := GetNextAlias()

	BeginSql Alias _cAlias
	SELECT
            SC2.C2_FILIAL, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_DATPRF,
            SC2.C2_DATRF, SC2.C2_PRODUTO, SC2.C2_DESTINA, SC2.C2_PEDIDO, SC2.C2_ROTEIRO, SC2.C2_QUJE,
            SC2.C2_PERDA, SC2.C2_QUANT, SC2.C2_DATPRI, SC2.C2_EMISSAO, SC2.C2_CC, SC2.C2_DATAJI, SC2.C2_DATAJF,
            SC2.C2_STATUS, SC2.C2_OBS, SC2.C2_TPOP, SC2.C2_LOTECTL, SC2.R_E_C_N_O_ AS REG,
            SC2.R_E_C_N_O_  SC2RECNO, SC2.C2_XQTDPRT, PAI.C2_PRODUTO PRODUTO_PAI
        FROM %Table:SC2% SC2
            INNER JOIN %Table:SC2% PAI
                 ON PAI.C2_FILIAL  = SC2.C2_FILIAL
                AND PAI.C2_NUM     = SC2.C2_NUM
                AND PAI.C2_ITEM    = SC2.C2_ITEM
                AND PAI.C2_SEQUEN  = '001'
                AND PAI.D_E_L_E_T_ = ' '
 
        WHERE
            SC2.C2_FILIAL = %xFilial:SC2%
            AND SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD >= %Exp:MV_PAR01%
            AND SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD <= %Exp:MV_PAR02%
            AND SC2.C2_DATPRF BETWEEN %Exp:Dtos(MV_PAR03)% AND %Exp:Dtos(MV_PAR04)%
            AND SC2.%NotDel%
 
            %Exp:_cExpre%
 
	EndSql

Return _cAlias

/*/{Protheus.doc} fConta
	(Função para contar registros em um alias)

	@type Static Function
	@author Vitor Ribeiro
	@since 08/02/2019

    @param c_Alias, caracter, alias do arquivo

	@return _nTotal, numerico, retorna o total de registros do arquivo.
	/*/
Static Function fConta(c_Alias)

    Local _nTotal := 0

    Default c_Alias := ""
    
    // Se não for final de arquivo
    If (c_Alias)->(!Eof())
        // Vai para o primeiro registro
        (c_Alias)->(DbGoTop())

        // Conta todos os registros
        _nTotal := Contar(c_Alias,"!Eof()")

        // Vai para o primeiro registro
        (c_Alias)->(DbGoTop())
    EndIf

Return _nTotal

/*/{Protheus.doc} _fAtualSC2
	(Função para realizar a query principal)

	@type Static Function
	@author Vitor Ribeiro
	@since 08/02/2019

	@return Nil, nulo, não tem retorno
	/*/
Static Function _fAtualSC2(n_RecnoSC2)

	Default n_RecnoSC2 := 0

	// Posiciona no registro da SC2
	SC2->(DbGoTo(n_RecnoSC2))

	// Se conseguiu posicionar no registro
	If SC2->(!Eof())
		RecLock("SC2",.F.)
			SC2->C2_XQTDPRT := (SC2->C2_XQTDPRT + 1)
		SC2->(MsUnlock())
	EndIf

Return Nil

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ AddAr797 ³ Autor ³ Anieli Rodrigues      ³ Data ³ 25/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Adiciona um elemento ao Array                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ AddAr797(ExpN1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Quantidade da estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR797                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function AddAr797(nQuantItem,l_Estrut)

Local cDesc := SB1->B1_DESC
Local cLocal := ""
Local cKey := ""
Local cRoteiro := ""
Local cLocais  :={}
Local _nPosicao := 0

Default l_Estrut := .T.

// Verifica se imprime nome cientifico do produto. Se Sim verifica se existe registro no SB5 e se nao esta vazio
If MV_PAR07 == 1
	DbSelectArea("SB5")
	dbSeek(xFilial()+SB1->B1_COD)
	If Found() .and. !Empty(B5_CEME)
		cDesc := B5_CEME
	EndIf
ElseIf MV_PAR07 == 2
	cDesc := SB1->B1_DESC
Else
	// Verifica se imprime descricao digitada ped.venda, se sim verifica se existe registro no SC6 e se nao esta vazio
	If (_cAliasTop)->C2_DESTINA == "P"
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+(_cAliasTop)->C2_PEDIDO+(_cAliasTop)->C2_ITEM)
		If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
			cDesc := C6_DESCRI
		ElseIf C6_PRODUTO # SB1->B1_COD
			dbSelectArea("SB5")
			dbSeek(xFilial()+SB1->B1_COD)
			If Found() .and. !Empty(B5_CEME)
				cDesc := B5_CEME
			EndIf
		EndIf
	EndIf
EndIf

// Verifica se imprime ROTEIRO da OP ou PADRAO do produto
If !Empty((_cAliasTop)->C2_ROTEIRO)
	cRoteiro:=(_cAliasTop)->C2_ROTEIRO
Else
	If !Empty(SB1->B1_OPERPAD)
		cRoteiro:=SB1->B1_OPERPAD
	Else
		dbSelectArea("SG2")
		If dbSeek(xFilial()+(_cAliasTop)->C2_PRODUTO+"01")
			cRoteiro:="01"
		EndIf
	EndIf
EndIf

dbSelectArea("SB2")
dbSeek(xFilial()+SB1->B1_COD+SD4->D4_LOCAL)

DbSelectArea("SD4")	// Requisições Empenhadas
cKey:=SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT+SD4->D4_LOTECTL+SD4->D4_NUMLOTE

DbSelectArea("SDC")		// COMPOSICAO DO EMPENHO
SDC->(DbSetOrder(2))	// DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI
If SDC->(DbSeek(xFilial("SDC")+cKey))
	//If SDC->(!Eof()) .And. SDC->(DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE) == cKey
	Do While SDC->(!Eof()) .And. SDC->(DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE) == cKey
		cLocal := SDC->DC_LOCALIZ 
		//Criado para adicionar possuir mais de um endereço do mesmo Lote 1
		
		Aadd(cLocais,{SDC->DC_QUANT,SDC->DC_LOCALIZ,SDC->DC_OP,SDC->DC_LOTECTL,SDC->DC_QTSEGUM})
		SDC->(DbSkip())
	EndDo
	//EndIf
EndIf
DbSelectArea("SD4")	// Requisições Empenhadas
//(Posicione("SF2",1,xFilial("SF2")+QRY->NUMNF,"F2_EMISSAO")
//Aadd(aArray,{SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,cLocal,SD4->D4_TRT,cRoteiro,If(MV_PAR12 == 1,SD4->D4_LOTECTL,""),If(MV_PAR12 == 1,SD4->D4_NUMLOTE,""), SD4->D4_QTSEGUM } )

// Adiciona uma posicao
Aadd(aArray,Array(14))
_nPosicao := Len(aArray)

aArray[_nPosicao][01] := SB1->B1_COD
aArray[_nPosicao][02] := cDesc
aArray[_nPosicao][03] := SB1->B1_TIPO
aArray[_nPosicao][04] := SB1->B1_UM

If _lImpEsp .And. !l_Estrut
	aArray[_nPosicao][05] := SZ7->Z7_QUANT
// Essa parte ainda será discutida com os usuários - Vitor Ribeiro - 12/02/2019
//ElseIf l_Estrut .And. _lImpEsp
	//aArray[_nPosicao][05] := (_nQuantOP / nQuantItem) * SZ7->Z7_QUANT
Else
	aArray[_nPosicao][05] := nQuantItem
EndIf

aArray[_nPosicao][06] := SD4->D4_LOCAL
aArray[_nPosicao][07] := cLocal
aArray[_nPosicao][08] := SD4->D4_TRT
aArray[_nPosicao][09] := cRoteiro
aArray[_nPosicao][10] := IIf(MV_PAR12 == 1,SD4->D4_LOTECTL,"")
aArray[_nPosicao][11] := IIf(MV_PAR12 == 1,SD4->D4_NUMLOTE,"")
aArray[_nPosicao][12] := IIf(_lImpEsp,ConvUm(SB1->B1_COD,nQuantItem,0,2),SD4->D4_QTSEGUM)
aArray[_nPosicao][13] := cLocais
aArray[_nPosicao][14] := (_cAliasTop)->PRODUTO_PAI

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ MontStruc³ Autor ³ Anieli Rodrigues      ³ Data ³ 25/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta um array com a estrutura do produto                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade base a ser explodida                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR797                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function MontStruc(cOp)

	Local _nQtde := 0

	Default cOp := ""

	DbSelectArea("SD4")		// Requisições Empenhadas
	SD4->(DbSetOrder(2))	// D4_FILIAL+D4_OP+D4_COD+D4_LOCAL

	DbSelectArea("SD3")		// MOVIMENTAÇÕES INTERNAS
	SD3->(DbSetOrder(1))	// D3_FILIAL+D3_OP+D3_COD+D3_LOCAL

	If SD4->(DbSeek(xFilial("SD4")+cOp))
		While SD4->(!Eof()) .And. SD4->(D4_FILIAL+D4_OP) == xFilial("SD4")+cOp
			// Posiciona no produto desejado
			If SB1->(DbSeek(xFilial("SB1")+SD4->D4_COD))
				// Se considera saldo e tem saldo
				If MV_PAR15 == 1 .And. (SD4->D4_QUANT > 0 .Or. (lItemNeg .And. SD4->D4_QUANT < 0))
					AddAr797(SD4->D4_QUANT,.T.)
				ElseIf MV_PAR15 == 2	// Se não considera saldo
					AddAr797(SD4->D4_QTDEORI,.T.)
				ElseIf MV_PAR08 == 1	// Impr. Op Encerrada -> Sim
					// Inicializa a variavel
					_nQtde := 0

					// Pesquisa o movimento
					If SD3->(DbSeek(xFilial("SD3")+SD4->(D4_OP+D4_COD)))
						_nQtde := SD3->D3_QUANT
					EndIf

					// Adiciona o item
					AddAr797(_nQtde,.T.)
				EndIf
			EndIf

			// Vai para o proximo registro
			SD4->(DbSkip())
		Enddo
	EndIf

	SD4->(DbSetOrder(1))	// D4_FILIAL+D4_COD+D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ CabecOp  ³ Autor ³ Anieli Rodrigues      ³ Data ³ 25/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta o cabecalho da Ordem de Producao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ CabecOp()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR797                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function CabecOp(nPagOp,oPrinter,nLiAtu,l_Tudo,a_ProdSeq1,l_DadDesm) //lTudo (Imprime CABEC Completo ou Resumido

Local cTitulo := "PFI - PLANO DE FABRICACAO E INSPECAO "
Local cTitulo2:= "PFI :" + AllTrim((_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)) + IIf(_lImpEsp,"/" + SZ7->Z7_BARRA,"") + " LOTE: " + (_cAliasTop)->C2_LOTECTL
Local cCabec1 := RTrim(SM0->M0_NOME)
Local cCabec2 := STR0011	//"  C O M P O N E N T E S"
Local nBegin
Local nAltura  := 0
Local nLargura := 0

Local _cMensagem := ''

Private oFontC
Private oFontT
Private oFont14N
Private oFont16N

Default l_Tudo := .T.
Default l_DadDesm := .F.

Default a_ProdSeq1 := {}

If Empty(a_ProdSeq1)
	cTitulo2 := "PFI :" + AllTrim((_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)) + IIf(_lImpEsp,"/" + SZ7->Z7_BARRA,"") + " LOTE: " + (_cAliasTop)->C2_LOTECTL
Else
	cTitulo2 := a_ProdSeq1[1]
EndIf

oFontT 		:= TFont():New('Courier new',,8,.T.)
oFontTB 		:= TFont():New('Courier new',,8,.T.,.T.)
oFontC 		:= TFont():New('Courier new',,12,.T.)
oFontCB 		:= TFont():New('Courier new',,12,.T.,.T.)
oFont11N 	:= TFont():New('Courier new',,11,.T.,.T.)
oFont14N 	:= TFont():New('Courier new',,14,.T.,.T.)
oFont16N 	:= TFont():New('Courier new',,16,.T.,.T.)

If nLiAtu == 0
	oPrinter:StartPage()
	nAltura := 10//oPrinter:nPageHeight
	nLargura:= 10//oPrinter:nPageWidth
	oPrinter:Cmtr2Pix(nAltura,nLargura)
	Li := 20
Else
	oPrinter:Line( Li, 		5, li			, nMaxCol-10,, "-1")
	oPrinter:Line( Li+.5, 	5, li+0.5	, nMaxCol-10,, "-1")
	oPrinter:Line( Li+1, 	5, li+1		, nMaxCol-10,, "-1")
	oPrinter:Line( Li+1.5, 	5, li+1.5	, nMaxCol-10,, "-1")
	oPrinter:Line( Li+2, 	5, li+1		, nMaxCol-10,, "-1")
	Li += 10
EndIf
// Aqui Li = 20 Quando Nova Pagina

//Cria Box Codigo de Barras / Cabecalho (1)
oPrinter:Box(Li,001,Li+40,120)
oPrinter:Box(Li,120,Li+40,210)
oPrinter:Box(Li,210,Li+40,nMaxCol-10)

cCode := (_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
//oPrinter:Code128C(Li+35	,005,AllTrim(cCode),34)
//Novo codigo de barras 128
If li == 20
	oPrinter:FWMSBAR("CODE128" /*cTypeBar*/,1.7/*nRow*/,0.3/*nCol*/,AllTrim(cCode)/*cCode*/,oPrinter/*oPrint*/,/*lCheck*/,/*Color*/,/*lHorz*/,/*nWidth*/,1.0/*nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/) 
Else
	oPrinter:FWMSBAR("CODE128" /*cTypeBar*/,(li/11.7)/*nRow*/,0.3/*nCol*/,AllTrim(cCode)/*cCode*/,oPrinter/*oPrint*/,/*lCheck*/,/*Color*/,/*lHorz*/,/*nWidth*/,1.0/*nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/) 
EndIf	
oPrinter:SayAlign(Li		,480,STR0015+TRANSFORM(nPagOp,'999'),oFontTB,nMaxCol-10,200,,0)
If _nQtdPrt > 0
	oPrinter:SayAlign(Li+07	,480,"Impressão: "+TRANSFORM(_nQtdPrt+1,'99'),oFontTB,nMaxCol-10,200,,0)
EndIf        
oPrinter:SayAlign(Li+14	,480,AllTrim(USRFULLNAME(__CUSERID)),oFontTB,nMaxCol-10,200,,0)

oPrinter:SayAlign(Li+20	,480,"F1 09-01 Rev.07",oFontTB,nMaxCol-10,200,,0) // Leonardo Vieira 27/04/2022


//Pirolo - Informar que se trata de um OP Desmembrada
oPrinter:SayAlign(Li+21	,480,Iif(_lImpEsp, "PFI Parcial", ""),oFontTB,nMaxCol-10,200,,0)

oPrinter:SayAlign(Li+05	,133,cCabec1,oFont14N,600,200,,0,,,.T.)
oPrinter:SayAlign(Li+05	,220,cTitulo ,oFont14N,nMaxCol-10,200,,0)
oPrinter:SayAlign(Li+20	,220,cTitulo2,oFont14N,nMaxCol-10,200,,0)

Li += 40
// Aqui Li = 60 Quando Nova Pagaina                 	

//Cria Box Dados do Produto (2)
oPrinter:Box(Li,001,Li+20,060)
oPrinter:Box(Li,060,Li+20,150)
oPrinter:Box(Li,150,Li+20,210)
oPrinter:Box(Li,210,Li+20,460)
oPrinter:Box(Li,460,Li+20,490)
oPrinter:Box(Li,490,Li+20,515)
oPrinter:Box(Li,515,Li+20,nMaxCol-10)

oPrinter:Say(Li+10,002,"Produto",oFontC)
oPrinter:Say(Li+10,062,IIf(Empty(a_ProdSeq1),aArray[1][1],a_ProdSeq1[2]),oFont14N)
oPrinter:Say(Li+10,152,"Descricao",oFontC,600)
oPrinter:Say(Li+10,212,SubStr(IIf(Empty(a_ProdSeq1),aArray[1][2],a_ProdSeq1[3]),01,35),oFont14N,600)
oPrinter:Say(Li+20,212,SubStr(IIf(Empty(a_ProdSeq1),aArray[1][2],a_ProdSeq1[3]),36,70),oFont14N,600)
oPrinter:Say(Li+10,462,Posicione("SB1",1,xFilial("SB1")+IIf(Empty(a_ProdSeq1),aArray[1][1],a_ProdSeq1[2]),"B1_UM"),oFontC,600)
oPrinter:Say(Li+10,492,"Qtd",oFontC,600)

//Pirolo - Ajuste para concatenar a quantidade original da OP quando for Desmembramento
//oPrinter:Say(Li+10,532, Transform(IIf(_lImpEsp,SZ7->Z7_QUANT,(_cAliasTop)->C2_QUANT),"@E 99999.99"),oFont14N,600) /*original*/

If _lImpEsp
	oPrinter:Say(Li+10,517, AllTrim(Transform(SZ7->Z7_QUANT,"@E 99999.99"))+ "/"+ AllTrim(Transform((_cAliasTop)->C2_QUANT,"@E 99999.99")),oFont11N/*oFont14N*/,600)
Else
	oPrinter:Say(Li+10,530, Transform((_cAliasTop)->C2_QUANT,"@E 99999.99"),oFont14N,600)
EndIf

Li += 20
// Aqui Li == 80 Quando Nova Pagaina

//Cria Box Dados do Autor / Responsavel / Data (4)
oPrinter:Box(Li,001,Li+20,250)
oPrinter:Box(Li,250,Li+20,500)
oPrinter:Box(Li,500,Li+20,nMaxCol-10)

aAreaSC2 := GetArea("SC2")
dbSelectArea("SC2")
dbGoto((_cAliasTop)->REG)
oPrinter:Say(Li+10,002,"Autor(a): " + IIf(Empty(a_ProdSeq1),AllTrim(FWLEUSERLG("C2_USERLGI",1)),a_ProdSeq1[4]),oFontTB)
RestArea(aAreaSC2)

oPrinter:Say(Li+10,251,"Responsável: "+GETMV("MV_XRESTEC"),oFontTB)   
oPrinter:Say(Li+08,502,"Emissão: " + IIf(Empty(a_ProdSeq1),DTOC((_cAliasTop)->C2_EMISSAO),a_ProdSeq1[5]),oFontTB)
oPrinter:Say(Li+16,502,"Entrega: " + IIf(Empty(a_ProdSeq1),DTOC((_cAliasTop)->C2_DATPRF),a_ProdSeq1[6]),oFontTB)

// Se imprime os dados do desmembramento
If l_DadDesm
	oPrinter:Box(Li,001,Li+20,nMaxCol-10)

	_cMensagem := 'Usuário: ' + SZ7->Z7_CODUSER + ' - ' + IIf(PswSeek(SZ7->Z7_CODUSER,.T.),PswRet()[1][2],'') + ' '
	_cMensagem += 'Data: ' + DToC(SZ7->Z7_DATA) + ' '
	_cMensagem += 'Hora: ' + SZ7->Z7_HORA + ' '
	_cMensagem += 'Operação: ' + SZ7->Z7_OPERAC + ' '

	oPrinter:Say(Li+10,002,_cMensagem,oFontTB)
EndIf

_cAlias := Alias()
dbSelectArea("SZ2")
dbSetOrder(1)
If dbSeek(xFilial("SZ2")+IIf(Empty(a_ProdSeq1),aArray[1][1],a_ProdSeq1[2]))
	Li += 20
	// Aqui Li == 100 Quando Nova Pagaina
	
	//Cria Box Dados da Revisao do Processo e Desenho (5)
	oPrinter:Box(Li,001,Li+20,150)
	oPrinter:Box(Li,150,Li+20,300)
	oPrinter:Box(Li,300,Li+20,450)
	oPrinter:Box(Li,450,Li+20,nMaxCol-10)
	
	oPrinter:Say(Li+10,002,"Rev Proc.: "+AllTrim(SZ2->Z2_REVPROC),oFontTB)
	oPrinter:Say(Li+10,151,"Desenho	: "+AllTrim(SZ2->Z2_CODDESE),oFontTB)
	oPrinter:Say(Li+10,302,"Rev Desenho: "+AllTrim(SZ2->Z2_REVDESE),oFontTB)
	oPrinter:Say(Li+10,452,"Atual.: "+DTOC(SZ2->Z2_DTREVIS),oFontTB)
	
	_cProdPai := StrTran(Alltrim(SZ2->Z2_CODDESE),"-","")

EndIf
dbSelectArea(_cAlias)

li += 20
// Aqui Li == 120 Quando Nova Pagaina

If !(Empty((_cAliasTop)->C2_OBS))
	oPrinter:Say(li,5,STR0033)//"Observacao: "
	For nBegin := 1 To Len(Alltrim((_cAliasTop)->C2_OBS)) Step 65
		oPrinter:Say(li,60,Substr((_cAliasTop)->C2_OBS,nBegin,65))
		@li,012 PSay Substr((_cAliasTop)->C2_OBS,nBegin,65)
		li+=10
	Next nBegin
EndIf

li += 10

If l_Tudo
	//Cria Box RASTREAMENTO MP (5)
	oPrinter:Box(Li,001,li+20,nMaxCol-10)
	oPrinter:Say(Li+10,050,"Rastrear Matéria Prima - Procedimento Aplicável DQL"+AllTrim(GetMv("MV_XPROCMP")),oFont14N)
	Li += 20

	//Cria Box COMPONENTES (6)
	oPrinter:Box(Li,001,Li+10,070) // Codigo - 070 Pos
	oPrinter:Box(Li,070,Li+10,300) // Descricao - 220 Pos
	oPrinter:Box(Li,300,Li+10,340) // Quantidade - 070 Pos     270
	oPrinter:Box(Li,340,Li+10,370) // U.M. - 030 Pos
	oPrinter:Box(Li,370,Li+10,390) // Armazem - 020 Pos
	oPrinter:Box(Li,390,Li+10,460) // Endereco - 070 Pos
	oPrinter:Box(Li,460,Li+10,490) // 2 UM SIGLA - 030 Pos
	oPrinter:Box(Li,490,Li+10,550) // Lote - 040 Pos
	oPrinter:Box(Li,550,Li+10,nMaxCol-10) // 2 U.M. QTD - 080 Pos

	oPrinter:Say(Li+005,002,STR0034,oFontTB) //"CODIGO"
	oPrinter:Say(Li+005,072,STR0035,oFontTB) //"DESCRICAO"
	oPrinter:Say(Li+005,302,"QTDE",oFontTB)  //"QUANTIDADE"    272
	oPrinter:Say(Li+005,342,STR0037,oFontTB) //"UM"
	oPrinter:Say(Li+005,372,STR0038,oFontTB) //"ARM"
	oPrinter:Say(Li+005,392,STR0039,oFontTB) //"ENDERECO"
	oPrinter:Say(Li+005,462,"2a UM" ,oFontTB)//"2a UM Sigla"
	oPrinter:Say(Li+005,492,"LOTE" ,oFontTB) //"LOTE"
	oPrinter:Say(Li+005,552,"Qt 2a UM",oFontTB) //"2a UM QT"
	Li+=20    //30                                   // ALTERADO DO 10 PARA 30 POR MAURICIO 13/06.SOL. JOAO/FABIANA/FELIPE
	oPrinter:Say(Li,001,"",oFontT)
EndIf

Return()

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ RotOper  ³ Autor ³ Anieli Rodrigues      ³ Data ³ 04/04/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ RotOper()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR797                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function RotOper(oPrinter)
Local cSeekWhile := "SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO)"
_lFirst1 := .T.
dbSelectArea("SG2")
If a630SeekSG2(1,aArray[1][1],xFilial("SG2")+aArray[1][1]+aArray[1][9],@cSeekWhile)
	
	cRotOper(oPrinter)
	
	While !Eof() .And. Eval(&cSeekWhile)
		
		dbSelectArea("SH4")
		dbSeek(xFilial()+SG2->G2_FERRAM)
		
		dbSelectArea("SH8")
		dbSetOrder(1)
		dbSeek(xFilial()+(_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+SG2->G2_OPERAC)
		lSH8 := IIf(Found(),.T.,.F.)
		
		If lSH8
			While !Eof() .And. SH8->H8_FILIAL+SH8->H8_OP+SH8->H8_OPER == xFilial()+(_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+SG2->G2_OPERAC
				
				If mv_par13 == 2
						If !Empty(SG2->G2_DTINI)
							If SG2->G2_DTINI > (cAliasTop)->C2_DATPRI
								SH8->(dbSkip())
								Loop
							EndIf
						EndIf
						If !Empty(SG2->G2_DTFIM)
							If SG2->G2_DTFIM < (cAliasTop)->C2_DATPRI
								SH8->(dbSkip())
								Loop
							EndIf
						EndIf
				EndIf
				
				If !_lFirst1
					oPrinter:Box(Li,001,Li+10,020) // Operacao - 020 Pos
					oPrinter:Box(Li,020,Li+10,170) // Recurso  - 150 Pos
					oPrinter:Box(Li,170,Li+10,270) // Ferramenta - 100 Pos
					oPrinter:Box(Li,270,Li+10,320) // Tempo Processo - 50 Pos
					oPrinter:Box(Li,320,Li+10,520) // Instrucoes - 200 Pos
					oPrinter:Box(Li,520,Li+10,nMaxCol-10) // DQL - 070 Pos
					
					oPrinter:Say(li+005,002,"OPER",oFontTB)				//"OPERACAO"
					oPrinter:Say(li+005,022,STR0047,oFontTB)			//"RECURSO"
					oPrinter:Say(li+005,172,STR0048,oFontTB)			//"FERRAMENTA"
					oPrinter:Say(li+005,272,"TEMPO",oFontTB)			//"TEMPO"
					oPrinter:Say(li+005,322,"INSTRUÇÕES",oFontTB)		//"Instrucoes"
					oPrinter:Say(li+005,522,"Proc.Apli.DQL",oFontTB)	//"DQL"
					li+=10
				EndIf
				_lFirst1 := .T.
				ImpRot(lSH8,oPrinter)
				dbSelectArea("SH8")
				dbSkip()
			End
		Else
			If !_lFirst1
				oPrinter:Box(Li,001,Li+10,020) // Operacao - 020 Pos
				oPrinter:Box(Li,020,Li+10,170) // Recurso  - 150 Pos
				oPrinter:Box(Li,170,Li+10,270) // Ferramenta - 100 Pos
				oPrinter:Box(Li,270,Li+10,320) // Tempo Processo - 050 Pos
				oPrinter:Box(Li,320,Li+10,520) // Instrucoes - 200 Pos
				oPrinter:Box(Li,520,Li+10,nMaxCol-10) // DQL - 070 Pos
				
				oPrinter:Say(li+005,002,"OPER",oFontTB)				//"OPERACAO"
				oPrinter:Say(li+005,022,STR0047,oFontTB)			//"RECURSO"
				oPrinter:Say(li+005,172,STR0048,oFontTB)			//"FERRAMENTA"
				oPrinter:Say(li+005,272,"TEMPO",oFontTB)			//"TEMPO"
				oPrinter:Say(li+005,322,"INSTRUÇÕES",oFontTB)		//"Instrucoes"
				oPrinter:Say(li+005,522,"Proc.Apli.DQL",oFontTB)	//"DQL"
				li+=10
			EndIf
			_lFirst1 := .T.
			ImpRot(lSH8,oPrinter)
		Endif
		
		dbSelectArea("SG2")
		dbSkip()
	EndDo
	
Endif

Return Li

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ RotOper  ³ Autor ³ Anieli Rodrigues      ³ Data ³ 04/04/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ cRotOper()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR797                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function cRotOper(oPrinter)

Local cCabec1 := STR0041+(_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)	//" ROTEIRO DE OPERACOES NRO :"
li+=10
//Retirado por Samuel Miranda 30/10/2023 - Apedido do Felipe possa, por se tratar de uma não conformidade 
//oPrinter:SayAlign(Li,050,"PODERÁ SER UTILIZADA OUTRA MÁQUINA MESMO NÃO ESTANDO NA SEQUÊNCIA DO PFI",oFont14N,nMaxCol-10,,,0)
//li+=10
oPrinter:SayAlign(Li,200,cCabec1,oFont14N,nMaxCol-10,,,0)
li+=20

oPrinter:Box(Li,001,Li+10,020) // Operacao - 020 Pos
oPrinter:Box(Li,020,Li+10,170) // Recurso  - 150 Pos
oPrinter:Box(Li,170,Li+10,270) // Ferramenta - 100 Pos
oPrinter:Box(Li,270,Li+10,320) // Tempo Processo - 050 Pos
oPrinter:Box(Li,320,Li+10,520) // Instrucoes - 200 Pos
oPrinter:Box(Li,520,Li+10,nMaxCol-10) // DQL - 070 Pos

oPrinter:Say(li+005,002,"OPER",oFontTB)				//"OPERACAO"
oPrinter:Say(li+005,022,STR0047,oFontTB)			//"RECURSO"
oPrinter:Say(li+005,172,STR0048,oFontTB)			//"FERRAMENTA"
oPrinter:Say(li+005,272,"TEMPO",oFontTB)			//"TEMPO"
oPrinter:Say(li+005,322,"INSTRUÇÕES",oFontTB)		//"Instrucoes"
oPrinter:Say(li+005,522,"Proc.Apli.DQL",oFontTB)	//"DQL"
li+=10

Return li

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ ImpRot   ³ Autor ³ Anieli Rodrigues      ³ Data ³ 05/04/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ ImpRot()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR797                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function ImpRot(lSH8,oPrinter)
Local nBegin
Local _nAux, _nXXX
Local nQtdInsp	:= 0
Local nI		:= 0
Local cQueryOP := ""
Local _nxRec := 0

Private oFontC
Private oFontT

oFontT := TFont():New('Courier new',,8,.T.)
oFontC := TFont():New('Courier new',,12,.T.)

dbSelectArea("SH1")
dbSeek(xFilial()+IIf(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO))

Verilim(oPrinter)
// Variavel Auxiliar para Saber se Gera BOX com Uma Linha ou Mais // NAO REMOVER
// INICIO DA LOGICA
_nAux := 0
_cInstru := Alltrim(SG2->G2_DESCRI)+" "+AllTrim(SG2->G2_XDESEXT)
If Len(Alltrim(_cInstru)) > 45
	_nAux := Int(Len(Alltrim(_cInstru))/45)
EndIf
If _nAux <> 0
	_nAux := (_nAux+1) * 10
Else
	_nAux	:= 10
EndIf
_nXXX := 0
// AFGORA TEM MAIS DE UMA FERRAMENTA ENTAO PRECISA VER QUANTAS TEM PARA AUMENTAR O BOX
If Empty(SG2->G2_FERRAM)
	_nXXX:= 1 
Else
	_cAlias := Alias()
	dbSelectArea("SH3")
	dbSetOrder(1)
	dbSeek(SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO+G2_OPERAC))
	While !Eof() .And. SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO+G2_OPERAC) == SH3->(H3_FILIAL+H3_PRODUTO+H3_CODIGO+H3_OPERAC)
		_nXXX++
		dbSkip()
	EndDo
	dbSelectArea(_cAlias)
EndIf	
If _nXXX > 1 // Para uma Ferramenta apenas nao precisa de mais linhas
	_nAux += ((_nXXX-1)*10)
EndIf
// FIM DA LOGICA

oPrinter:Box(Li,001,Li+_nAux,020) // Operacao - 020 Pos
oPrinter:Box(Li,020,Li+_nAux,170) // Recurso  - 150 Pos
oPrinter:Box(Li,170,Li+_nAux,270) // Ferramenta - 100 Pos
oPrinter:Box(Li,270,Li+_nAux,320) // Tempo - 050 Pos
oPrinter:Box(Li,320,Li+_nAux,520) // Instrucoes - 200 Pos
oPrinter:Box(Li,520,Li+_nAux,nMaxCol-10) // DQL - 070 Pos

oPrinter:Say(li+005,002,SG2->G2_OPERAC,oFontT)
oPrinter:Say(li+005,022,IIF(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO)+" "+SUBS(SH1->H1_DESCRI,1,25),oFontT)

If Empty(SG2->G2_FERRAM)
	oPrinter:Say(li+005,172,SG2->G2_FERRAM+" "+SUBS(SH4->H4_DESCRI,1,20),oFontT)
Else
	nLiOld := li
	_cAlias := Alias()
	dbSelectArea("SH3")
	dbSetOrder(1)
	dbSeek(SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO+G2_OPERAC))
	While !Eof() .And. SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO+G2_OPERAC) == SH3->(H3_FILIAL+H3_PRODUTO+H3_CODIGO+H3_OPERAC)
		oPrinter:Say(li+005,172,SH3->H3_FERRAM+" "+SUBS(Posicione("SH4",1,xFilial("SH4")+SH3->H3_FERRAM,"H4_DESCRI"),1,20))
		li+=10
		dbSkip()
	EndDo
	li := nLiOld
	dbSelectArea(_cAlias)
EndIf	

oPrinter:Say(li+005,272,Str(SG2->G2_TEMPAD,5,2),oFontT)

//oPrinter:Box(Li,25,Li+_nAux,075)  // CARIMBO
_nVezes := 0
For nBegin := 1 To Len(_cInstru) Step 45
	oPrinter:Say(li+005,322,Substr(_cInstru,nBegin,45),oFontT)
	li+=10
	_nVezes++
	If li> nMaxLin-59
		_nVezes := 0
		li:= 0
		oPrinter:EndPage()
		nPagina++
		oPrinter:StartPage()
		Li+=10
		cRotOper(oPrinter)
		oPrinter:Box(Li,001,Li+_nAux,020) // Operacao - 020 Pos
		oPrinter:Box(Li,020,Li+_nAux,170) // Recurso  - 150 Pos
		oPrinter:Box(Li,170,Li+_nAux,320) // Ferramenta - 150 Pos
		oPrinter:Box(Li,320,Li+_nAux,520) // Instrucoes - 200 Pos
		oPrinter:Box(Li,520,Li+_nAux,nMaxCol-10) // DQL - 070 Pos
	EndIf
Next nBegin
Li := Li - (10*_nVezes)
oPrinter:Say(li+009,522,SH1->H1_XDQL,oFontT)
//Li := Li + (5*_nVezes)
// MAURICIO 29/08/2017. SOLICITO POR FELIPE POSSA
li+=_nAux //15 // DEMA - 24/04/2018'
oPrinter:Box(Li,520,Li+30,nMaxCol-10) // CARIMBO
li+=15

//Impressão dos recursos alternativos
//Inicio
Verilim(oPrinter) //Verifica se cabe na mesma pagina
//se for uma paga nova adciono mais vinte linhas.
IF li == 75
	li += 20
EndIf

If !empty(SG2->G2_RECURSO)
	//_aArea := GetArea()
	ALTEREC  := GetNextAlias()
	//Query SQL
	cQueryOP := " SELECT SH3.H3_CODIGO AS CODPRO, SH3.H3_OPERAC AS NPERACAO,SH3.H3_RECPRIN AS RECPRINCIPAL,SH3.H3_RECALTE AS RECALTERNATIVO ,SH3.H3_TIPO " + CHR(13)+CHR(10)
	cQueryOP += " FROM " + CHR(13)+CHR(10)
	cQueryOP += RetSqlName('SH3') + " SH3 " + CHR(13)+CHR(10)
	cQueryOP += " WHERE  " + CHR(13)+CHR(10)
	cQueryOP += "SH3.H3_PRODUTO ='"+Alltrim(SG2->G2_PRODUTO)+"' AND"+CHR(13)+CHR(10) // Codigo do Produto  - 30805200-PI1'  
	cQueryOP += "SH3.H3_CODIGO  ='"+Alltrim(SG2->G2_CODIGO)+" ' AND"+CHR(13)+CHR(10) // Codigo da Operacao 
	cQueryOP += "SH3.H3_OPERAC  ='"+Alltrim(SG2->G2_OPERAC)+" ' AND"+CHR(13)+CHR(10) // Numero da Operacao '01' 
	cQueryOP += "SH3.H3_RECPRIN ='"+Alltrim(SG2->G2_RECURSO)+"' AND"+CHR(13)+CHR(10) // Recurso Principal  '02' 
	cQueryOP += "SH3.H3_TIPO    ='A' AND"+CHR(13)+CHR(10) // Tipo de Recurso   'A' AND D_E_L_E_T_=''"+CRLF
	cQueryOP += "SH3.D_E_L_E_T_ ='' "+CHR(13)+CHR(10)
 	cQueryOP += "ORDER BY RECALTERNATIVO "+CHR(13)+CHR(10)
	MemoWrite("RECURSOALTERNATIVO.SQL", cQueryOP )//Grava o resultado da query em um arquivo sql
	dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQueryOP ), "ALTEREC" , .T. , .F. )	

	dbSelectArea("ALTEREC")
	dbGotop()
	ALTEREC->(dbEval({ || _nxRec++ },,{||!Eof()} ))
	dbGoTop()

	If _nxRec > 0
		oPrinter:Box(Li-5,001,Li+10,nMaxCol-200) //
		oPrinter:Say(li+5,125,"RECUSOS ALTERNATIVOS / SECUNDÁRIOS",oFontTB)
		Li+=15
		Do While !ALTEREC->(Eof())
			oPrinter:Box(Li,005,Li+10,15)
			//oPrinter:line (Li,0020,Li,nMaxCol-100) //Linha na Vertical oPrinter:Line (Li,0010,Li+20,0010)// Linha vertical descrição
			oPrinter:Say(li+7,020,ALTEREC->RECALTERNATIVO +" | ",oFontTB)
			oPrinter:Say(li+7,055,"  "+Posicione("SH1",1,xFilial("SH1")+ALTEREC->RECALTERNATIVO,"H1_DESCRI"),oFontTB)
			Li+=5
			oPrinter:Line (Li+10,001,Li+10,nMaxCol-200)// Linha vertical descrição
			Li+=5
			//H1_FILIAL + H1_CODIGO
			li+=10
			ALTEREC->(dbSkip())	
		EndDo
	EndIf
	ALTEREC->(DbCloseArea())
EndIf
li+=10
//Final da Impressão do recurso alternativo
// Incluído em 30/08/2022 Leonardo / chamado #16337
oPrinter:Say(li,5,STR0050+IIF(lSH8,DTOC(SH8->H8_DTINI),Space(8))+" "+IIF(lSH8,SH8->H8_HRINI,Space(5))+" "+STR0051+" ______/ ______/______    ____:____",oFontT)//"INICIO  DESIG: "//" INICIO  REAL :"
li+=15
oPrinter:Say(li,5,STR0052+IIF(lSH8,DTOC(SH8->H8_DTINI),Space(8))+" "+IIF(lSH8,SH8->H8_HRINI,Space(5))+" "+" TERMINO REAL : "+" ______/ ______/______    ____:____",oFontT)//"TERMINO DESIG: "//" INICIO  REAL :"
li+=15
oPrinter:Say(li,5,STR0054)                                                    //"Quantidade: "
//oPrinter:Say(li,25,Transform(IIF(lSH8,SH8->H8_QUANT,aSC2Sld(_cAliasTop)),PesqPictQt("H8_QUANT",14)))
oPrinter:Say(li,25,Transform(IIF(lSH8,SH8->H8_QUANT,aSC2Sld(_cAliasTop)),"@E 99,999,999,999.99"))
oPrinter:Say(li,140,STR0055)//"Quantidade produzida: "          PesqPictQt("D4_QUANT",TamSX3("D4_QUANT")[1])) @E 99,999,999,999.99                         
oPrinter:Say(li,350,STR0056)//"Perdas: "

_nRecurso  := Alltrim(SG2->G2_RECURSO) //Pega o codigo do Recurso
//Por Samuel Miranda 25/09/2023
//Impressão do quadro para etiqueta de produto acabado solicitado pelo Luis Ricardo -PCP Chamado Nº 20270
If _nRecurso == "BG01" // $ "12010|BG01" 
	VerPag(oPrinter)
	//ImgEtiq := "ETIQ1.png"	
	ImgEtiq := "ETIQUETA.png
	//Imprime o primeiro box da direita
	oPrinter:Box(Li+10,001,Li+190,300) // Ensaio - 035 Pos
	//Imprime uma imagem
	oPrinter:SayBitmap( Li+55,105,ImgEtiq,080,080 )
	//Imprime o primeiro box da Esquerda
	oPrinter:Box(Li+10,305,Li+190,nMaxCol-10) // Ensaio - 035 Pos
	//Imprime uma imagem
	oPrinter:SayBitmap( Li+55,400,ImgEtiq,080,080 )
	Li += 190//Separa os box
	//Imprime seguendo box da esquerda
	oPrinter:Box(Li+10,001,Li+190,300) // Ensaio - 035 Pos
	//Imprime uma imagem
	oPrinter:SayBitmap( Li+55,105,ImgEtiq,080,080 )
	//Imprime seguendo box da direita
	oPrinter:Box(Li+10,305,Li+190,nMaxCol-10) // Ensaio - 035 Pos
	//Imprime uma imagem
	oPrinter:SayBitmap( Li+55,400,ImgEtiq,080,080 )
	li += 200
EndIf

If _nRecurso $ "12025|12029"
	li += 5 //20
	_nPosLinha := li / 11.6
	oPrinter:FWMSBAR("CODE128" /*cTypeBar*/,_nPosLinha/*nRow*/,02.5/*nCol*/,AllTrim(aArray[1][14])+"  "+AllTrim((_cAliasTop)->C2_LOTECTL)/*cCode*/,oPrinter/*oPrint*/,;
	/*lCheck*/,/*Color*/,/*lHorz*/,/*nWidth*/,0.5/*nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/) 	
	oPrinter:Say(Li+37,070,+"PRODUTO | LOTE "+AllTrim(aArray[1][14])+" "+AllTrim((_cAliasTop)->C2_LOTECTL),oFontTB)

	oPrinter:FWMSBAR("CODE128" /*cTypeBar*/,_nPosLinha/*nRow*/,35.5/*nCol*/,AllTrim((_cAliasTop)->C2_LOTECTL)/*cCode*/,oPrinter/*oPrint*/,;
	/*lCheck*/,/*Color*/,/*lHorz*/,/*nWidth*/,0.5/*nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/) 	
	oPrinter:Say(Li+37,460,+"LOTE: "+AllTrim((_cAliasTop)->C2_LOTECTL),oFontTB)
EndIf
li += 10
// Adiciona 10 linhas para os recursos especificos
//If _nRecurso $ "12025|12029"
//	li += 10
//End
//Por Samuel Miranda 14/07/2021

If _lImpEsp
	// Imprimi os apontamentos
	_fImpApont(oPrinter)
EndIf

// IMPRIMIR PRODUTO BN E FORNECEDOR - INICIO
If !Empty(SG2->G2_XBNPROD)  
	oPrinter:Say(li+008,001,"Produto  BN: "+SG2->G2_XBNPROD,oFontT)
	dbSelectArea("SA5")
	dbSetOrder(2)
	dbSeek(xFilial("SA5")+SG2->G2_XBNPROD)
	While !Eof() .And. SA5->A5_PRODUTO == SG2->G2_XBNPROD
		If SA5->A5_XPADRBN = '1'
			oPrinter:Say(li+017,001,"Fornecedor: "+SA5->A5_FORNECE+"/"+SA5->A5_LOJA+" "+SA5->A5_NOMEFOR,oFontT)
		EndIf
	dbSkip()
	EndDo
EndIf
// FIM
li+=30

// Incluido Claudio 07/10/2013 INICIO
_aArea := GetArea()
_cQuery := ""
_cQuery += " SELECT QP8_ENSAIO ENSAIO,QP1_DESCPO DESCRICAO,QP8_LABOR LABOR,QP8_METODO METODO,QP8_TEXTO TEXTO,' ' MINIMO,' ' MAXIMO , QP8_SEQLAB ORDEM, QP8.R_E_C_N_O_ REG "+CRLF
_cQuery += " FROM "+RetSqlName("QQK")+" QQK "+CRLF
_cQuery += " INNER JOIN "+RetSqlName("QP8")+" QP8 ON "+CRLF
_cQuery += " QP8_FILIAL = '"+xFilial("QP8")+"' "+CRLF
_cQuery += " AND QP8_PRODUT = QQK_PRODUT "+CRLF
_cQuery += " AND QP8_OPERAC = QQK_OPERAC "+CRLF
_cQuery += " AND QP8_REVI = ( "+CRLF
_cQuery += "     SELECT MAX(QP6_REVI) "+CRLF
_cQuery += "     FROM "+RetSqlName("QP6")+" QP6 "+CRLF
_cQuery += "     WHERE QP6_FILIAL = '"+xFilial("QP6")+"' "+CRLF
_cQuery += "     AND QP6_PRODUT = '"+(_cAliasTop)->C2_PRODUTO+"' "+CRLF
_cQuery += "     AND QP6_SITREV <> 1 "+CRLF  //Por Samuel Miranda colocado para não imprimir revisao bloqueadas 20190527

//Pirolo - Removido o comentario desta linha para obedecer o roteiro definido na OP
_cQuery += "     AND QP6_CODREC = '"+(_cAliasTop)->C2_ROTEIRO+"' "

//Pirolo - Esta linha foi comentada pois fixava no relatório o Roteiro 01
//_cQuery += "     AND QP6_CODREC = '01' "+CRLF

_cQuery += "     AND QP6.D_E_L_E_T_ = ' ') "+CRLF
_cQuery += " AND QP8.D_E_L_E_T_ = ' ' "+CRLF
_cQuery += " INNER JOIN "+RetSqlName("QP1")+" QP1 ON QP1_FILIAL = ' ' AND QP1_ENSAIO = QP8_ENSAIO AND QP1.D_E_L_E_T_ = ' ' "+CRLF
_cQuery += " WHERE QQK_FILIAL = '"+xFilial("QQK")+"' AND QQK_CODIGO = '"+(_cAliasTop)->C2_ROTEIRO+"' "+CRLF
_cQuery += " AND QQK_PRODUT = '"+(_cAliasTop)->C2_PRODUTO+"' "+CRLF
//_cQuery += " AND QQK_RECURS = '"+SG2->G2_RECURSO+"' "+CRLF // MAURICIO 03/04/22 - SOL. ERICA E WYVERSON - DEVIDO A ALTERACAO DE ROTEIRO SEM ALTERACAO DE INSPECAO
_cQuery += " AND QQK_OPERAC = '"+SG2->G2_OPERAC+"' "+CRLF
_cQuery += " AND QQK_FERRAM = '"+SG2->G2_FERRAM+"' "+CRLF
_cQuery += " AND QQK_REVIPR = QP8_REVI "+CRLF
_cQuery += " AND QQK.D_E_L_E_T_ = ' ' "+CRLF
_cQuery += " UNION ALL "+CRLF
_cQuery += " SELECT DISTINCT QP7_ENSAIO ENSAIO,QP1_DESCPO DESCRICAO,QP7_LABOR LABOR,QP7_METODO METODO,' ' TEXTO,QP7_LIC MINIMO,QP7_LSC MAXIMO,  QP7_SEQLAB ORDEM, QP7.R_E_C_N_O_ REG "+CRLF
_cQuery += " FROM "+RetSqlName("QQK")+" QQK "+CRLF
_cQuery += " INNER JOIN "+RetSqlName("QP7")+" QP7 ON "+CRLF
_cQuery += " QP7_FILIAL =  '"+xFilial("QP7")+"' "+CRLF
_cQuery += " AND QP7_PRODUT = QQK_PRODUT "+CRLF
_cQuery += " AND QP7_OPERAC = QQK_OPERAC "+CRLF
_cQuery += " AND QP7_REVI = ( "+CRLF
_cQuery += "     SELECT MAX(QP6_REVI) "+CRLF
_cQuery += "     FROM "+RetSqlName("QP6")+" QP6 "+CRLF
_cQuery += "     WHERE QP6_FILIAL = '"+xFilial("PQ6")+"' "+CRLF
_cQuery += "     AND QP6_PRODUT = '"+(_cAliasTop)->C2_PRODUTO+"' "+CRLF
_cQuery += "     AND QP6_SITREV <> 1 "+CRLF    //Por Samuel Miranda colocado para não imprimir revisao bloqueadas 20190527

//Pirolo - Removido o comentario desta linha para obedecer o roteiro definido na OP
_cQuery += "     AND QP6_CODREC = '"+(_cAliasTop)->C2_ROTEIRO+"' "

//Pirolo - Esta linha foi comentada pois fixava no relatório o Roteiro 01
//_cQuery += "     AND QP6_CODREC = '01' "+CRLF

_cQuery += "     AND QP6.D_E_L_E_T_ = ' ') "+CRLF
_cQuery += " AND QP7.D_E_L_E_T_ = ' ' "+CRLF
_cQuery += " INNER JOIN "+RetSqlName("QP1")+" QP1 ON QP1_FILIAL = ' ' AND QP1_ENSAIO = QP7_ENSAIO AND QP1.D_E_L_E_T_ = ' ' "+CRLF
_cQuery += " WHERE QQK_FILIAL = '"+xFilial("QQK")+"' AND QQK_CODIGO = '"+(_cAliasTop)->C2_ROTEIRO+"' "+CRLF
_cQuery += " AND QQK_PRODUT = '"+(_cAliasTop)->C2_PRODUTO+"' "+CRLF
//_cQuery += " AND QQK_RECURS = '"+SG2->G2_RECURSO+"' "+CRLF
_cQuery += " AND QQK_OPERAC = '"+SG2->G2_OPERAC+"' "+CRLF
_cQuery += " AND QQK_FERRAM = '"+SG2->G2_FERRAM+"' "+CRLF
_cQuery += " AND QQK_REVIPR = QP7_REVI "+CRLF
_cQuery += " AND QQK.D_E_L_E_T_ = ' ' "+CRLF
_cQUery += " ORDER BY ORDEM, REG "+CRLF

_cQuery := ChangeQuery( _cQuery)

If Select("QRY") > 0
	DbSelectArea("QRY")
	DbCloseArea()
Endif

MemoWrit("XMATR820.SQL",_cQuery)

TcQuery _cQuery New Alias ("QRY")

_lFirst 		:= .T.
_lTemInsp	:= .F.

dbSelectArea("QRY")

//Pirolo - Melhoria solicitada em 23/05/2019 - Imprimir a o quadro de inspeções x vezes conforme amarração na tabela QA6
//       - Se for TIPO PA, imprime uma unica vez
nQtdInsp := Iif(Posicione("SB1",1,xFilial("SB1")+(_cAliasTop)->C2_PRODUTO, "B1_TIPO") == "PA", 1, (_cAliasTop)->C2_QUANT)


If nQtdInsp > 1
	DbSelectArea("QA6")
	QA6->(DbSetOrder(2))//QA6_FILIAL+QA6_PLANO
	
	If QA6->(DbSeek(xFilial("QA6")+"INTERN"))
		While QA6->(!Eof() .AND. QA6_FILIAL+QA6_PLANO==xFilial("QA6")+"INTERN")
			If QA6->(nQtdInsp >= QA6_LOTINF .AND. nQtdInsp <= QA6_LOTSUP)
				nQtdInsp := QA6->QA6_XQIMP
				Exit
			EndIf 
			QA6->(DbSkip())
		EndDo
	EndIf
EndIf

//Imprime os quadros de inspeção conforme range.
For nI := 1 to nQtdInsp
	QRY->(dbGotop())
	While QRY->(!Eof())
		
		_lTemInsp	:= .T.
		
		If li > nMaxLin-59
			li:= 0
			oPrinter:EndPage()
			nPagina++
			oPrinter:StartPage()
			CabeInsp(oPrinter)
			_lFirst := .f.
			oPrinter:Box(Li,001,Li+10,035) // Ensaio - 035 Pos
			oPrinter:Box(Li,035,Li+10,185) // Descricao  - 150 Pos
			oPrinter:Box(Li,185,Li+10,220) // Laboratrio - 035 Pos
			oPrinter:Box(Li,220,Li+10,550) // Especificacao - 330 Pos
			oPrinter:Box(Li,550,Li+10,nMaxCol-10) // Resultado - 040 Pos
			
			oPrinter:Say(li+006,002,"ENSAIO" 				 , oFontTB)
			oPrinter:Say(li+006,037,"DESCRICAO" 			 , oFontTB)
			oPrinter:Say(li+006,187,"LABOR" 				 , oFontTB)
			oPrinter:Say(li+006,350,"ESPECIFICAÇÕES/MEDIÇÕES", oFontTB)
			oPrinter:Say(li+006,551,"RESULTADO" 			 , oFontTB)
			Li+=10
		EndIf
		
		If _lFirst
			CabeInsp(oPrinter)
			_lFirst := .f.
			oPrinter:Box(Li,001,Li+10,035) // Ensaio - 040 Pos
			oPrinter:Box(Li,035,Li+10,185) // Descricao  - 150 Pos
			oPrinter:Box(Li,185,Li+10,220) // Laboratrio - 035 Pos
			oPrinter:Box(Li,220,Li+10,550) // Especificacao - 330 Pos
			oPrinter:Box(Li,550,Li+10,nMaxCol-10) // Resultado - 040 Pos
			
			oPrinter:Say(li+006,002,"ENSAIO" 				 , oFontTB)
			oPrinter:Say(li+006,037,"DESCRICAO" 		     , oFontTB)
			oPrinter:Say(li+006,187,"LABOR" 				 , oFontTB)
			oPrinter:Say(li+006,350,"ESPECIFICAÇÕES/MEDIÇÕES", oFontTB)
			oPrinter:Say(li+006,551,"RESULTADO" 		     , oFontTB)
			Li+=10
		EndIf
		
		oPrinter:Box(Li,001,Li+20,035) // Ensaio - 035 Pos
		oPrinter:Box(Li,035,Li+20,185) // Descricao  - 150 Pos
		oPrinter:Box(Li,185,Li+20,220) // Laboratrio - 035 Pos
		oPrinter:Box(Li,220,Li+20,550) // Especificacao - 330 Pos
		oPrinter:Box(Li,550,Li+20,nMaxCol-10) // Resultado - 040 Pos
		
		oPrinter:Say(Li+10,002,AllTrim(QRY->ENSAIO), oFontT)
		oPrinter:Say(Li+10,037,Left(QRY->DESCRICAO,40), oFontT)
		oPrinter:Say(Li+10,187,AllTrim(QRY->LABOR), oFontT)
		oPrinter:Say(Li+10,222,AllTrim(QRY->METODO)+IIF(!Empty(QRY->TEXTO),Left(QRY->TEXTO,40)+"  _____________",Padr("Min: "+AllTrim(QRY->MINIMO)+" - Max: "+AllTrim(QRY->MAXIMO),40)+ " _________ "), oFontT)
		Li+=20
		
		QRY->(dbSkip())
	EndDo
	
	If _lTemInsp
		li+=15
		oPrinter:Say(Li,00 , "Visto do Inspetor:_________________________________ Instrumento(s):_________________________________________ Data:______________")
		Li+=10
	EndIf
Next nI

dbCloseArea()
RestArea(_aArea)
// Incluido Claudio 07/10/2013 FINAL

Return

/*/{Protheus.doc} _fImpApont
	(Função para imprimir o apontamento realizado)

	@type Static Function
	@author Vitor Ribeiro
	@since 08/02/2019

	@param o_Printer, objeto, contém o FWMSPrinter

	@return Nil, nulo, não tem retorno
	/*/
Static Function _fImpApont(o_Printer)

	Local _cMensagem := ''

	Default o_Printer := Nil

	DbSelectArea('SH6')		// MOVIMENTAÇÃO DA PRODUÇÃO
	SH6->(DbSetOrder(1))	// H6_FILIAL+H6_OP+H6_PRODUTO+H6_OPERAC+H6_SEQ+DTOS(H6_DATAINI)+H6_HORAINI+DTOS(H6_DATAFIN)+H6_HORAFIN

	// Verifica se possui apontamento
	If SH6->(DbSeek(xFilial('SH6')+(_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD+C2_PRODUTO)+SG2->G2_OPERAC))
		// Se enquanto não for final de arquivo e for o apontamento da op
		While SH6->(!Eof()) .And. xFilial('SH6')+(_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD+C2_PRODUTO)+SG2->G2_OPERAC == SH6->(H6_FILIAL+H6_OP+H6_PRODUTO+H6_OPERAC)

			_cMensagem := 'APONTAMENTO REALIZADO - '
			_cMensagem += 'INICIO: ' + DToC(SH6->H6_DATAINI) + ' - ' + SH6->H6_HORAINI + ' - '
			_cMensagem += 'TERMINO: ' + DToC(SH6->H6_DATAFIN) + ' - ' + SH6->H6_HORAFIN + ' - '
			_cMensagem += 'QUANTIDADE PRODUZIDA: ' + AllTrim(Str(SH6->H6_QTDPROD))

			o_Printer:Say(li+009,002,_cMensagem,oFontT)
			li+=10
	
			// Vai para o proximo registro
			SH6->(DbSkip())
		EndDo
	EndIf

Return Nil

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ Verilim  ³ Autor ³ Anieli Rodrigues      ³ Data ³ 05/04/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ Verilim()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 			                                          		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR797                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function Verilim(oPrinter)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a possibilidade de impressao da proxima operacao alocada na ³
//³ mesma folha.														 ³
//³ 7 linhas por operacao => (total da folha) 66 - 7 = 59				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF li > (nMaxLin-55)						// Li > 55
	li := 15
	oPrinter:EndPage()
	nPagina++
	oPrinter:StartPage()
	Li+=10
	cRotOper(oPrinter)			// Imprime cabecalho roteiro de operacoes
Endif
Return Li

Static Function VerPag(oPrinter)

IF li + 400 > (nMaxLin)						// Li > 55
	li := 15
	oPrinter:EndPage()
	nPagina++
	oPrinter:StartPage()
	Li+=10
	cRotOper(oPrinter)			// Imprime cabecalho roteiro de operacoes
Endif
Return Li
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³ Anieli Rodrigues	    ³ Data ³21/03/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria pergunta para o grupo			                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR797                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()

Local aHelpPor
Local aHelpEng
Local aHelpSpa

aHelpPor := {'Nr OP inicial a ser considerado na','filtragem do cadastro de OPs (SC2)'}
aHelpEng := {'Nr OP inicial a ser considerado na','filtragem do cadastro de OPs (SC2)'}
aHelpSpa := {'Nr OP inicial a ser considerado na','filtragem do cadastro de OPs (SC2)'}

PutSx1("MTR797","01","Da O.P.","¿De O. P. ?","From Product.Order ?",;
"MV_CH1","C",13,0,0,"G","","SC2","","","MV_PAR01",,,,,,,,"","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Nr OP final a ser considerado na','filtragem do cadastro de OPs (SC2)'}
aHelpEng := {'Nr OP final a ser considerado na','filtragem do cadastro de OPs (SC2)'}
aHelpSpa := {'Nr OP final a ser considerado na','filtragem do cadastro de OPs (SC2)'}

PutSx1("MTR797","02","Ate a O.P.","¿A O. P. ?","To Production Order ?",;
"MV_CH2","C",13,0,0,"G","","SC2","","","MV_PAR02",,,,,,,,"","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}
aHelpEng := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}
aHelpSpa := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}

PutSx1("MTR797","03","Da data","¿A Fecha ?","From Date ?",;
"MV_CH3","D",8,0,0,"G","","","","","MV_PAR03",,,,,,,,"","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}
aHelpEng := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}
aHelpSpa := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}

PutSx1("MTR797","04","Ate a data","¿A Fecha ?","To Date ?",;
"MV_CH4","D",8,0,0,"G","","","","","MV_PAR04",,,,,,,,"","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Lista o roteiro de operações juntamente','com as OPs?'}
aHelpEng := {'Lista o roteiro de operações juntamente','com as OPs?'}
aHelpSpa := {'Lista o roteiro de operações juntamente','com as OPs?'}

PutSx1("MTR797","05","Roteiro de Operacoes","¿Proced.Operaciones ?","Operation Sequence ?",;
"MV_CH5","N",1,0,1,"C","","","","","MV_PAR05","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Considera a impressao do código de','barras do número da ordem de produção.'}
aHelpEng := {'Considera a impressao do código de','barras do número da ordem de produção.'}
aHelpSpa := {'Considera a impressao do código de','barras do número da ordem de produção.'}

PutSx1("MTR797","06","Imprime Cod. Barras","¿Imprime Cod.Barras ?","Print Barcode ?",;
"MV_CH6","N",1,0,2,"C","","","","","MV_PAR06","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Considera a descrição do produto por','descrição cientifica ou generica ou o','que foi cadastrado no pedido de venda.'}
aHelpEng := {'Considera a descrição do produto por','descrição cientifica ou generica ou o','que foi cadastrado no pedido de venda.'}
aHelpSpa := {'Considera a descrição do produto por','descrição cientifica ou generica ou o','que foi cadastrado no pedido de venda.'}

PutSx1("MTR797","07","Descricao Produto","¿Descripcion Producto ?","Product Description ?",;
"MV_CH7","N",1,0,3,"C","","","","","MV_PAR07","Descr.Cient.","Descr.Cient.","Scient.Descr.",,"Descr.Generica","Descr.Generica","General Descr.","Pedido Venda","Pedido Venda","Pedido Venda","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Imprime as Ordens de Producao','Encerradas.'}
aHelpEng := {'Imprime as Ordens de Producao','Encerradas.'}
aHelpSpa := {'Imprime as Ordens de Producao','Encerradas.'}

PutSx1("MTR797","08","Impr. Op Encerrada","¿Imprime OP Cerrada ?","Print Finished Prod. Order ?",;
"MV_CH8","N",1,0,1,"C","","","","","MV_PAR08","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Define se o relatorio sera impresso por ','ordem de Produto ou de Sequencia na','Estrutura.'}
aHelpEng := {'Define se o relatorio sera impresso por ','ordem de Produto ou de Sequencia na','Estrutura.'}
aHelpSpa := {'Define se o relatorio sera impresso por ','ordem de Produto ou de Sequencia na','Estrutura.'}

PutSx1("MTR797","09","Impr. Por Ordem de","¿Impr. por Orden de ?","Print by ?",;
"MV_CH9","N",1,0,1,"C","","","","","MV_PAR09","Codigo","Codigo","Code",,"Sequencia"," Secuencia","Sequence","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Considera as OPs firmes, previstas ou','ambas do cadastro de OPs (SC2).'}
aHelpEng := {'Considera as OPs firmes, previstas ou','ambas do cadastro de OPs (SC2).'}
aHelpSpa := {'Considera as OPs firmes, previstas ou','ambas do cadastro de OPs (SC2).'}

PutSx1("MTR797","10","Considera Ops","¿Considera OPs ?","Consid.Prod.Orders ?",;
"MV_CHA","N",1,0,1,"C","","","","","MV_PAR10","Firmes","Firmes","Confirmed",,"Previstas","Previstas","Estimated","Ambas","Ambas","Both","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Indica se imprime ou não itens negativos','empenhados.','O parametro MV_NEGESTR tambem sera','avaliado.'}
aHelpEng := {'Indica se imprime ou não itens negativos','empenhados.','O parametro MV_NEGESTR tambem sera','avaliado.'}
aHelpSpa := {'Indica se imprime ou não itens negativos','empenhados.','O parametro MV_NEGESTR tambem sera','avaliado.'}

PutSx1("MTR797","11","Item Neg. na Estrut","¿Item Neg. en la Estruct. ?","Neg. Item in Structure ?",;
"MV_CHB","N",1,0,2,"C","","","","","MV_PAR11","Imprime","Imprime","Print",,"Nao Imprime","No Imprime","Do not print","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Opção para a impressao do produto com','rastreabilidade por Lote ou Sub-Lote.'}
aHelpEng := {'Opção para a impressao do produto com','rastreabilidade por Lote ou Sub-Lote.'}
aHelpSpa := {'Opção para a impressao do produto com','rastreabilidade por Lote ou Sub-Lote.'}

PutSx1("MTR797","12","Imprime Lote/S.Lote","¿Imprime Lote/S.Lote ?","Print Lot/S.Lot ?",;
"MV_CHC","N",1,0,2,"C","","","","","MV_PAR12","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Opção para a impressao da Ordem do   ','Relatorio.'}
aHelpEng := {'Opção para a impressao da Ordem do   ','Relatorio.'}
aHelpSpa := {'Opção para a impressao da Ordem do   ','Relatorio.'}

PutSx1("MTR797","13","Imprime Ordem Inversa?","¿Imprime Ordem Inversa ?","Print Inverse Ord ?",;
"MV_CHD","N",1,0,2,"C","","","","","MV_PAR13","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Opcao para considerar ops do usuário ','Relatorio.'}
aHelpEng := {'Opcao para considerar ops do usuário ','Relatorio.'}
aHelpSpa := {'Opcao para considerar ops do usuário ','Relatorio.'}

PutSx1("MTR797","14","Considera Usuario Inclusao?","Considera Usuario Inclusao?","Considera Usuario Inclusao?",;
"MV_CHE","N",1,0,2,"C","","","","","MV_PAR14","Sim","Sim","Sim",,"Nao","Nao","Nao","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Se considera o saldo ou quantidade ','original.'}
aHelpEng := {'Se considera o saldo ou quantidade ','original.'}
aHelpSpa := {'Se considera o saldo ou quantidade ','original.'}

PutSx1("MTR797","15","Considera Saldo","Considera Saldo","Considera Saldo",;
"MV_CHF","N",1,0,1,"C","","","","","MV_PAR15","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ CabeInsp ³ Autor ³ Anieli Rodrigues      ³ Data ³ 25/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta o cabecalho da Ordem de Producao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ CabeInsp()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR797                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function CabeInsp(oPrinter)
Local cCabec2 := "INSPECAO - Produto: "+aArray[1][1]+" Operacao: "+SG2->G2_OPERAC+" Recurso: "+SG2->G2_RECURSO
oPrinter:SayAlign(Li,001,cCabec2,oFont14N,nMaxCol-10,200,,0)
li+=20

Return(li)
