#Include 'Protheus.ch'
#Include "RPTDEF.CH"
#INCLUDE "TBICONN.CH"


/*/{Protheus.doc} FATOR01
description
@type Relatorio de Pedido de Venda
@version 12.1.2210 
@author Rodolfo Santos
@since 15/01/2024
/*/
User Function FATOR01( cAlias, nReg, nOpcx )
	Local oReport

	Private cFilSA1		:= xFilial("SA1")
	Private cFilSB1		:= xFilial("SB1")
	Private cFilSB5		:= xFilial("SB5")
	Private cFilSC6		:= xFilial("SC6")
	Private __nTamLinha := 0
	Private nTamDscPrd 	:=  Min(GetSx3Cache('B1_DESC','X3_TAMANHO'),30)


	oReport:= ReportDef(nReg, nOpcx)
	oReport:nDevice	:= 6	// 6 == PDF
	oReport:cFile		:= "RELPED" + dtos(date()) + cValtoChar(time())
	oReport:lPreview 	:= .F.
	oReport:lViewPDF 	:= .T.
	oReport:Print()

	oReport:FreeAllObjs( )


Return

/*/{Protheus.doc} ReportDef
Definição do relatorio
@type function
@version 12.1.2210 
@author Rodolfo Santos
@since 15/01/2024
/*/
Static Function ReportDef(nReg,nOpcx)
	Local cTitle   		:= "Pedidos de Venda"
	Local oReport
	Local oSection1
	Local oSection2

	Local cPicQtde := ""
	Local nMaxQtde := 12
	Local nTamQtde := 0
	Local aPicQtde := TamSx3("C6_QTDVEN")
	Local lAutosize := .F.


	aPicQtde[1] := Min(aPicQtde[1] , nMaxQtde)
	If aPicQtde[2] > 0
		aPicQtde[2] := Min(aPicQtde[2], 4)
		aPicQtde[1] -= (aPicQtde[2]+1)
	EndIf

	cPicQtde := Replicate('9',aPicQtde[1])+IIF(aPicQtde[2] >0, "."+Replicate('9',aPicQtde[2]), "")
	nTamQtde := Len(cPicQtde)
	cPicQtde := "@E "+cPicQtde

	If Type("cFilSA1") == "U"
		cFilSA1		:= xFilial("SA1")
	Endif

	If Type("cFilSB1") == "U"
		cFilSB1		:= xFilial("SB1")
	Endif

	If Type("cFilSB5") == "U"
		cFilSB5		:= xFilial("SB5")
	Endif

	If Type("cFilSC6") == "U"
		cFilSC6		:= xFilial("SC6")
	Endif

	oReport:= TReport():New("FATOR01",cTitle,"FATOR01", {|oReport| ReportPrint(oReport,nReg,nOpcx)}, '', .F.)
	//oReport:SetPortrait()			// Relatório como A4
	oReport:SetLandScape(.T.)		// Relatório como Paisagem
	oReport:HideParamPage()
	oReport:HideHeader()
	oReport:HideFooter()
	oReport:SetTotalInLine(.F.)
	oReport:SetUseGC(.F.)
	oReport:SetColSpace( 1 , .F.)


	oReport:oPage:setPaperSize(9)
	oSection1:= TRSection():New(oReport,'HEADER',{"SC6","SM0","SA1"}, /* <aOrder> */ ,;
								 /* <.lLoadCells.> */ , , /* <cTotalText>  */, /* !<.lTotalInCol.>  */, /* <.lHeaderPage.>  */,;
								 /* <.lHeaderBreak.> */, /* <.lPageBreak.>  */, /* <.lLineBreak.>  */, /* <nLeftMargin>  */,;
		.T./* <.lLineStyle.>  */, /* <nColSpace>  */,lAutosize /*<.lAutoSize.> */, /*<cSeparator> */,;
								 /*<nLinesBefore>  */, /*<nCols>  */, /* <nClrBack> */, /* <nClrFore>  */)
		oSection1:SetReadOnly()
	oSection1:SetNoFilter("SA1")

	oReport:cFontBody := 'Arial'
	oReport:nFontBody := 9			//Tamanho

	oReport:SetLineHeight( GetTamLinha(oReport) )

	__nTamLinha := oReport:LineHeight()*1.25

	TRCell():New(oSection1,"C5_NUM"		,"SC5", /*Titulo*/,/*Picture*/, GetSx3Cache('C5_NUM','X3_TAMANHO')		,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"A1_NOME"	,"SA1", /*Titulo*/,/*Picture*/, GetSx3Cache('A1_NOME','X3_TAMANHO')		,/*lPixel*/,/*{|| code-block de impressao }*/)


	oSection2:= TRSection():New(oSection1, 'Itens', "SC6", /* <aOrder> */ ,;  // estava assim {"SC6","SB1"}
								 /* <.lLoadCells.> */ , , /* <cTotalText>  */, /* !<.lTotalInCol.>  */, /* <.lHeaderPage.>  */,;
								 /* <.lHeaderBreak.> */, /* <.lPageBreak.>  */, /* <.lLineBreak.>  */,   0,;
								 /* <.lLineStyle.>  */, /* <nColSpace>  */, lAutosize/*<.lAutoSize.> */, /*<cSeparator> */,;
								 /*<nLinesBefore>  */, /*<nCols>  */, /* <nClrBack> */, /* <nClrFore>  */)

	// Bordas para o cabeçalho
	oSection2:SetCellBorder("BOTTOM", /*tamanho da borda*/, /*Cor da Borda*/, .T./*Borda no cabeçalho*/)

	TRCell():New(oSection2, "C6_PRODUTO"   	, "SC6", 'Codigo'       ,/*Picture*/, TamSX3( 'C6_PRODUTO' )[1]+7.5	,/*lPixel*/,   	,"LEFT"	, /*Quebra de texto*/	, "LEFT"  	,,, .T.)
	TRCell():New(oSection2, "C6_DESCRI"   	, "SC6", 'Descricao'    ,/*Picture*/, TamSX3( 'C6_DESCRI' )[1]		,/*lPixel*/,    ,"LEFT" , .T.					, "LEFT"  	,,, .T.)
	TRCell():New(oSection2, "COLUNA1"   	, "SC6", 'Desc Alx '    ,/*Picture*/, 13.5							,/*lPixel*/,   	,"LEFT" , /*Quebra de texto*/	, "LEFT"  	,,, .T.)
	TRCell():New(oSection2, "C6_LOTECTL"   	, "SC6", 'Lote'         ,/*Picture*/, TamSX3( 'C6_LOTECTL' )[1]+7 	,/*lPixel*/,   	,"LEFT" , /*Quebra de texto*/ 	, "LEFT"  	,,, .T.)
	TRCell():New(oSection2, "C6_QTDVEN"   	, "SC6", 'Qtd'	        ,cPicQtde	, nTamQtde+2  					,/*lPixel*/,    ,"LEFT" , /*Quebra de texto*/	, "LEFT" 	,,, .T.)
	TRCell():New(oSection2, "C6_LOCAL"   	, "SC6", 'Armaz.'       ,/*Picture*/, TamSX3( 'C6_LOCAL' )[1]+7.5	,/*lPixel*/,    ,"LEFT" , /*Quebra de texto*/	, "LEFT"  	,,, .T.)
	TRCell():New(oSection2, "C6_LOCALIZ"   	, "SC6", 'Endereco'     ,/*Picture*/, TamSX3( 'C6_LOCALIZ' )[1]		,/*lPixel*/,    ,"LEFT" , .T.					, "LEFT"  	,,, .T.)
	TRCell():New(oSection2, "COLUNA4"   	, "SC6", 'Visto'       	,/*Picture*/, 8								,/*lPixel*/,    ,"LEFT" , /*Quebra de texto*/	, "LEFT"  	,,, .T.)

	aPicQtde := TamSx3("C6_QTDVEN")

	If aPicQtde[2] > 0
		aPicQtde[2] := Min(aPicQtde[2], 4)
		aPicQtde[1] -= (aPicQtde[2]+1)
	EndIf

	cPicQtde := Replicate('9',aPicQtde[1])+IIF(aPicQtde[2] >0, "."+Replicate('9',aPicQtde[2]), "")
	nTamQtde := Len(cPicQtde)
	cPicQtde := "@E "+cPicQtde

Return oReport

/*/{Protheus.doc} GetLines
Quebra o texto em linhas
@type function
@version 12.1.2210 
@author Rodolfo Santos
@since 15/01/2024
@return aLines, Linhas a serem impressas
/*/
Static Function GetLines(cText, aFonts, nAreaImp)
	Local aLines := {}
	Local nTam := Len(cText)
	Local nTamPalavra := 0
	Local cTextoQbr := ""
	Local nC := 1
	Local cPalavra := ""
	Local nTamTot := 0
	Local nFator := 1.55//0.7

	If Len(aFonts) > 0
		Do While nC <= nTam
			cPalavra := ""
			Do While nC <= nTam
				cPalavra += Substr(cText,nC,1)

				If Substr(cText,nC,1) == " "
					nC++
					Exit
				Else
					nC++
				EndIf
			EndDo

			nTamPalavra := GetTamPalavra(cPalavra, aFonts[4])
			If Int((nTamTot + nTamPalavra)*nFator) > nAreaImp
				aAdd(aLines, cTextoQbr)
				cTextoQbr := ""
				nTamTot := 0

			EndIf

			cTextoQbr += cPalavra
			nTamTot += nTamPalavra
		EndDo
	EndIf

	If nTamTot > 0
		aAdd(aLines, cTextoQbr)
	ElseIf nTamTot == 0 .And. nTam == 0 .Or. Len(aFonts) > 0 //Insere a Linha em branco
		aAdd(aLines, cTexto)
	EndIf

Return aLines

/*/{Protheus.doc} GetTamPalavra
Retorna o Tamanho da palavra em pixels
@type function
@version 12.1.2210 
@author Rodolfo Santos
@since 15/01/2024
@return nTamTot, Tamanho da palavra
/*/
Static Function GetTamPalavra(cPalavra, aFonts)
	Local nTamTot := 0
	Local nTam :=  Len(cPalavra)
	Local cByte := 0
	Local nC := 0

	For nC := 1 to nTam
		cByte := Substr(cPalavra,nC,1)
		nTamByte := Asc(cByte)
		If nTamByte <= Len(aFonts)
			nTamByte := aFonts[nTamByte]
		Else
			nTamByte := 0
		EndIf
		nTamTot += nTamByte

	Next nC
Return nTamTot

/*/{Protheus.doc} ReportPrint
Função de Impressao do relatório
@type function
@version 12.1.2210 
@author Rodolfo Santos
@since 15/01/2024
@return variant, return_description
/*/
Static Function ReportPrint(oReport,nReg,nOpcX)
	Local nVias			:= 0
	Local oSection1   	:= nil
	Local oSection2   	:= nil
	Local cNumSC6		:= Len(SC6->C6_NUM)
	Local cCondicao		:= ""
	Local nPrinted    	:= 0
	Local nPagina     	:= 0
	Local nLinPos		:= 0
	Local lQuebra		:= .F.
	Local nLastIt       := 0
	Local aAreaSC6      := SC6->(GetArea())
	Local cQuebra		:= ""
	Local nTotQtde      := ""
	Local bExprQbr      := {|| C6_FILIAL + C6_NUM}
	Local nLinEnd       := 0

	If Type("cFilSA1") == "U"
		cFilSA1		:= xFilial("SA1")
	Endif

	If Type("cFilSB1") == "U"
		cFilSB1		:= xFilial("SB1")
	Endif

	If Type("cFilSB5") == "U"
		cFilSB5		:= xFilial("SB5")
	Endif

	If Type("cFilSC6") == "U"
		cFilSC6		:= xFilial("SC6")
	Endif


	MakeAdvplExpr(oReport:uParam)

	cCondicao := "C6_FILIAL== '" +SC5->C5_FILIAL+ "' .And."
	cCondicao += "C6_NUM == '" +SC5->C5_NUM+ "' "

	oReport:Section(1):SetFilter(cCondicao, "C6_FILIAL+C6_NUM" )

	oSection1   	:= oReport:Section(1)
	oSection2   	:= oReport:Section(1):Section(1)

	TRPosition():New(oSection2,"SB1",1,{ || cFilSB1 + SC6->C6_PRODUTO })
	TRPosition():New(oSection2,"SB5",1,{ || cFilSB5 + SC6->C6_PRODUTO })
	TRPosition():New(oSection1,"SA1",1,{ || cFilSA1 + SC5->C5_CLIENTE + SC5->C5_LOJACLI })

	nLastIt := SC6->(LastRec())
	SC6->( dbGoTop() )

	oReport:SetMeter(nLastIt)


	While !oReport:Cancel() .And. !SC6->(Eof())

		If oReport:Cancel()
			Exit
		EndIf

		Eval( { || nPagina++ , nPrinted := 0 , nLinEnd := CabecPCxAE( oReport, oSection1, nVias, nPagina, @nLinPos, .T., oSection2  ) })

		cQuebra		:= SC6->(Eval(bExprQbr))
		nTotQtde      :=  0
		cNumSC6 := SC6->C6_NUM

		While !oReport:Cancel() .And. !SC6->(Eof()) .And.  SC6->C6_FILIAL == cFilSC6 .And. SC6->C6_NUM == cNumSC6

			If oReport:Cancel()
				Exit
			EndIf

			lQuebra := .F.
			nSC6Rec := SC6->( Recno() )

			oReport:IncMeter()


			If HasNoAreaImp(oReport,oSection2:LineCount())
				oReport:SkipLine()
				oReport:PrintText( 'Continua na Proxima pagina ....',, 070 )

				oSection2:Finish()
				oSection1:Finish()
				oReport:EndPage()
				Eval( { || nPagina++ , nPrinted := 0 , nLinEnd := CabecPCxAE( oReport, oSection1, nVias, nPagina, @nLinPos, .T., oSection2  ) })
			EndIf

			oSection2:PrintLine()
			oReport:SkipLine()
			oReport:ThinLine()

			SC6->(dbSkip())
		EndDo

		oReport:EndPage()

	EndDo

	RestArea(aAreaSC6)

Return


/*/{Protheus.doc} CabecPCxAE
Imprime o cabeçalho do relatório
@type function
@version 12.1.2210 
@author Rodolfo Santos
@since 15/01/2024
@return nRowIniS, Linha final
/*/
Static Function CabecPCxAE( oReport, oSection1, nVias, nPagina, nLinPos, lShow, oSection2 )
	Local nLinPC		:= 0
	Local nPageWidth	:= 0
	Local nFont := oReport:nfontbody*1.25
	Local oFont24	:= TFont():New(oReport:cfontbody,oReport:nfontbody*2,oReport:nfontbody*2,,.T.,,,,.T.,.F.)
	Local oFontB    := TFont():New(oReport:cfontbody,nFont,nFont,,.T.,,,,.F.,.F.)
	Local oFont    := TFont():New(oReport:cfontbody,nFont,nFont,,.F.,,,,.F.,.F.)
	Local nFont2 := oReport:nfontbody*1.5
	Local oFontB2    := TFont():New(oReport:cfontbody,nFont2,nFont2,,.T.,,,,.F.,.F.)
	Local nRowIni      := 0
	Local nRowIniS     := 0
	Local nTamLinha :=0
	Local nLinhaEsp := 0
	Local cTexto := ""
	Local nColunas := 0
	Local nCol1 := 0
	Local nColBox := Int(nFont/2)

	oReport:oPage:setPaperSize(9)

	nPageWidth	:= oReport:PageWidth()+110 // Linha lateral da pagina
	nTamLinha := GetTamLinha(oReport)
	nLinhaEsp := (nTamLinha*0.1)
	nColunas := Int((nPageWidth-4)/3)

	nCol1 := nColunas*2 + 10
	nColBox := Int(nFont/2)


	If Type("cInscrEst") == "U"
		cInscrEst := InscrEst()
	Endif

	If Type("cFilSA1") == "U"
		cFilSA1		:= xFilial("SA1")
	Endif

	If Type("cFilSB1") == "U"
		cFilSB1		:= xFilial("SB1")
	Endif

	If Type("cFilSB5") == "U"
		cFilSB5		:= xFilial("SB5")
	Endif

	If Type("cFilSC6") == "U"
		cFilSC6		:= xFilial("SC6")
	Endif

	SA1->(dbSetOrder(1))
	SA1->(dbSeek(cFilSA1 + SC5->C5_CLIENTE + SC5->C5_LOJACLI))

	oReport:SetLineHeight(GetTamLinha(oReport))

	oSection1:Init()

	oReport:SetRow(nLinhaEsp)

	nRowIni := oReport:Row()

	oReport:SkipLine()

	nRowIniS := GetTamLinha(oReport)*5


/*-----------------------------------
                                    |
        BOXES DO CABEÇALHO          |
                                    |
-----------------------------------*/

// Box da Check List
oReport:Box( nRowIni/*Linha Superior*/, nColBox-2/*linha Esquerda*/,  nRowIniS/*Linha Inferior*/, nPageWidth-43/*linha Direita*/)

// Box do Logo
oReport:Box( nRowIni/*Linha Superior*/, nColBox-2/*linha Esquerda*/,  nRowIniS/*Linha Inferior*/, 580 /*linha Direita*/ )

// Box da Emissão
oReport:Box( nRowIni/*Linha Superior*/, 2830/*linha Esquerda*/   ,  nRowIniS/*Linha Inferior*/, nPageWidth-43/*linha Direita*/ )


/*-----------------------------------
                                    |
        TEXTOS DO CABEÇALHO         |
                                    |
-----------------------------------*/

// INSERE O LOGO
_cFileLogo	:= GetSrvProfString('Startpath','') + GETMV('FS_DIRLG')

If !File(_cFileLogo)
	MsgAlert('O Diretório informado no Parametro (FS_DIRLG) esta incorreto. Favor verificar.')
	_cFileLogo := GetSrvProfString('Startpath','')
EndIf

	oReport:SayBitmap(nRowIni+nLinhaEsp, nColBox*7/*Direita*/, _cFileLogo, ((nColunas/2)-nColBox)-50 /*Esquerda*/, nRowIniS -( nRowIni+nLinhaEsp*2))
	
	// INSERE O TÍTULO
	cTexto := "Check List de Expedicao"
	oReport:Say( Int(GetTamLinha(oReport)*2.5) /*Linha do texto*/ ,(nColunas + nColBox)+190, cTexto , oFont24)

	oReport:SetRow(nRowIni)
	oReport:SkipLine()

	// INFORMAÇÃO ADICIONAL DE EMISSÃO
	cTexto :=  "Emissão: "
	oReport:Say( Int(GetTamLinha(oReport)*1.7) /*Linha do texto*/ ,nCol1+730, cTexto , oFont)
	oReport:Say(oReport:Row()+23, nCol1+860, Dtoc( SC5->C5_EMISSAO ), oFont)
	//nCol2 := PrintTitle(oReport, nCol1+430, cTexto , oFontB, nFont)


	oReport:SkipLine()

	// INFORMAÇÃO ADICIONAL DE REVISÃO
	cTexto := "Revisão: 01"
	oReport:Say( Int(GetTamLinha(oReport)*2.7) /*Linha do texto*/ ,nCol1+730, cTexto , oFont)
	//nCol2 := PrintTitle(oReport, nCol1+430, cTexto , oFontB, nFont)


	oReport:SkipLine()


	nRowIni := nRowIniS
	nRowIniS := nRowIni + GetTamLinha(oReport)*4  // *5 antes
	oReport:Box( nRowIni, nColBox ,  nRowIniS , nPageWidth-40 )

	nCol1 := nFont

	//3 COLUNAS
	oReport:SkipLine()
	nLinPC := oReport:Row()


	oReport:SkipLine()

	nCol1 := nFont
	cTexto := "NOME DO CLIENTE: "
	//nCol2 := PrintTitle(oReport, nCol1, cTexto , oFontB, nFont)
	oReport:Say( oReport:Row()+18, nCol1+20, cTexto , oFontB)                                  // NOME DO CLIENTE
	oReport:Say( oReport:Row()+18, nCol1+305,  Capital( AllTrim( SA1->A1_NOME )), oFont)       //INFORMAÇÃO DO NOME DO CLIENTE

	oReport:SkipLine()

	cTexto := "Pedido: "
	//nCol2 := PrintTitle(oReport, nCol1, cTexto , oFontB, nFont)
	oReport:Say( oReport:Row()+18, nCol1+20, cTexto , oFontB)                                  // PEDIDO
	oReport:Say( oReport:Row()+18, nCol1+135,  Capital( AllTrim( SC5->C5_NUM )), oFont)        // INFORMAÇÃO DO PEDIDO

	oReport:SkipLine()

	cTexto := "NF: "
	//nCol2 := PrintTitle(oReport, nCol1, cTexto , oFontB, nFont)
	oReport:Say( oReport:Row()+18, nCol1+20, cTexto , oFontB)                                  // NF
	oReport:Say( oReport:Row()+18, nCol1+80,  Capital( AllTrim( SC5->C5_NOTA )), oFont)        // INFORMAÇÃO DA NF

	nCol1 += nColunas


	//Box da Composição do Pedido
	nRowIni := nRowIniS
	nRowIniS := (GetTamLinha(oReport) + nRowIni ) + 20
	oReport:Box( nRowIni-10 , nColBox, nRowIniS , nPageWidth-40 )
	nRowIni := oReport:Row()
	oReport:SetRow(nRowIni+nLinhaEsp*2)
		

	oReport:SkipLine()


	//Campo  de mensagens adicionais
	nRowIni := nRowIniS
	nRowIniS := nRowIni + GetTamDetalhe(oReport, nRowIni + nLinhaEsp) + nLinhaEsp
	oReport:Box( nRowIni, nColBox, nRowIniS+200, nPageWidth-40 )

	oReport:SetLineHeight(__nTamLinha)

	oReport:SkipLine()

	cTexto := 'Composição do Pedido'
	aFonts := oReport:GetFontSize( oFontB2:Name ,  oFontB2:nWidth  , oFontB2:Bold, oFontB2:Italic , oFontB2:Underline )
	oReport:Say(oReport:Row(), Int(((nPageWidth-40) - Len(cTexto)*aFonts[3] )/2)+20,  cTexto, oFontB2)     


	oReport:SkipLine()      

	oSection2:Init()

	//('SA1')->(DBCLOSEAREA())
	//('SC5')->(DBCLOSEAREA())
	//('SC6')->(DBCLOSEAREA())


Return nRowIniS


/*/{Protheus.doc} GetTamDetalhe
Retorna da Linha do detalhe
@type function
@version 12.1.2210 
@author Rodolfo Santos
@since 15/01/2024
@return nTam, Tamanho da Linha Detalhe
/*/
Static Function GetTamDetalhe(oReport, nLinha)

REturn  oReport:PageHeight() - (GetTamRodape(oReport) + nLInha)


/*/{Protheus.doc} GetTamRodape
Retorna o tamanho do rodapé em pixels
@type function
@version 12.1.2210 
@author Rodolfo Santos
@since 15/01/2024
@return nTam, Tamanho do rodapé
/*/
Static Function GetTamRodape(oReport)

REturn  GetTamLinha(oReport)*4


/*/{Protheus.doc} GetTamLinha
retorna o tamanho da Linha
@type function
@version 12.1.2210 
@author Rodolfo Santos
@since 15/01/2024
@return nTam, Tamanho da Linha em pixels
/*/
Static Function GetTamLinha(oReport)

Return oReport:nFontBody*4


/*/{Protheus.doc} HasNoAreaImp
Retorna se NÃO há mais area de impressão
@type function
@version 12.1.2210 
@author Rodolfo Santos
@since 15/01/2024
@return lRet, Não há mais area de impressao
/*/
Static Function HasNoAreaImp(oReport, nQtdLinhas)
Local nLinhasImp :=  0

Default nQtdLinhas := 1

nLinhasImp :=  oReport:LineHeight() * (nQtdLinhas - 1)

Return (oReport:Row() + nLinhasImp) > (oReport:PageHeight() - (oReport:LineHeight() + GetTamRodape(oReport)) )


/*/{Protheus.doc} PrintTitle
Imprime o título do relatório
@type function
@version 12.1.2210 
@author Rodolfo Santos
@since 15/01/2024
@return nCol2, Proxima coluna a imprimir
/*/
Static Function PrintTitle(oReport, nCol1, cTexto , oFontB, nFont)
Local nCol2 := nCol1 + Len(cTexto)*nFont*1.5
oReport:Say(oReport:Row(), nCol1, cTexto, oFontB)

Return nCol2
