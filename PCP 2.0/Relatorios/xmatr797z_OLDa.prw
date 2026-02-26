#INCLUDE "MATR797.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"	
#INCLUDE "TBICONN.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"
//#INCLUDE "COLOR.CH"

Static lContImp := .F. //Controla se já contou a OP
Static lObCabIm	:= .F. //Indica se no cabeçalho foi adicionada a 
Static cUltOP	:= ""
//Static oFontMD 	:= TFont():New('Courier new',,50,.T.,.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR797  ³ Autor ³ Anieli Rodrigues	    ³ Data ³ 13/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ordens de Producao Equipamentos                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ortosintese Equipamentos                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function xMTR797Z()

// VERSAO COM QUEBRA DE PAGINA A CADA OP 
// REOVIDA A QUEBRA DE PAGINA A CADA OP - SOLICITACAO: MAURICIO - 03/2018
Local aOrdem 	 := {STR0001,STR0002,STR0003,STR0004}//"Por Numero"//"Por Produto"//"Por Centro de Custo"//"Por Prazo de Entrega"
Local aDevice 	 := {}
Local bParam	 := {|| _fPergunte() }
Local cDevice    := ""
Local cRelName   := "MATR797"
Local cSession   := GetPrinterSession()
Local lAdjust    := .F.
Local nFlags     := PD_ISTOTVSPRINTER//+PD_DISABLEPAPERSIZE
Local nLocal     := 1
Local nOrdem 	 := 1
Local nOrient    := 1
Local nPrintType := 6
Local oPrinter 	 := Nil
Local oSetup     := Nil
Private aArray	 := {}
Private li		 := 15
Private li1		 := 15
Private nMaxLin	 := 0
Private nMaxCol	 := 0
//Private lItemNeg := GetMv("MV_NEGESTR") .And. mv_par11 == 1

//Realiza os perguntes
Eval(bParam)

_lTemInsp	:= .F. // Variavel de Controle NAO REVOMER -- DEMA
nPagina		:= 0
_cProdPai 	:= ""

AADD(aDevice,"DISCO") // 1
AADD(aDevice,"SPOOL") // 2
AADD(aDevice,"EMAIL") // 3
AADD(aDevice,"EXCEL") // 4
AADD(aDevice,"HTML" ) // 5
AADD(aDevice,"PDF"  ) // 6

cSession	:= GetPrinterSession()
//Obtem ultima configuracao de tipo de impressão (spool ou pdf) gravada no arquivo de configuracao
cDevice		:= If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
//Obtem ultima configuracao de orientacao de papel (retrato ou paisagem) gravada no arquivo de configuracao
nOrient	    := If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
//Obtem ultima configuracao de destino (cliente ou servidor) gravada no arquivo de configuracao
nLocal		:= If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
nPrintType  := aScan(aDevice,{|x| x == cDevice })
//Atribui o nome do relatório
cRelName 	:= "OP_"+Alltrim(MV_PAR01)+"_"+Alltrim(MV_PAR02) 
oPrinter 	:= FWMSPrinter():New(cRelName,nPrintType,lAdjust,,.T.)

// Cria e exibe tela de Setup Customizavel - Utilizar include "FWPrintSetup.ch"
oSetup := FWPrintSetup():New (nFlags,cRelName)
oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
oSetup:SetPropert(PD_ORIENTATION , nOrient)
oSetup:SetPropert(PD_DESTINATION , nLocal)
oSetup:SetPropert(PD_MARGIN      , {0,0,0,0})
oSetup:SetOrderParms(aOrdem,@nOrdem)
oSetup:SetUserParms(bParam)

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
		//Pirolo - Ajustado o limite da pagina de 800 para 650 pois estava estourando o tamanho.
		nMaxLin	:= 650
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
	//Fontes utilizadas na imoressão.
	oFontT 		:= TFont():New('Courier new',,8,.T.)
	oFontTB 		:= TFont():New('Courier new',,8,.T.,.T.)
	oFontC 		:= TFont():New('Courier new',,12,.T.)
	oFontCB 		:= TFont():New('Courier new',,12,.T.,.T.)
	oFont14N 	:= TFont():New('Courier new',,14,.T.,.T.)
	oFont16N 	:= TFont():New('Courier new',,16,.T.,.T.)
	//Chama a função de imoressão
	RptStatus({|lEnd| U_xMt797zP(@lEnd,nOrdem, @oPrinter)},"Imprimindo Relatorio...")
Else
	MsgInfo(STR0005)//"Relatório cancelado pelo usuário."
	oPrinter:Cancel()
EndIf
oSetup   := Nil
oPrinter := Nil
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
User Function xMt797zP(lEnd, nOrdem, oPrinter)
Local _cNumOP 		:= ""
Local i 			:= 0
Local _nCount 		:= 0
Private _cAliasTop 	:= "SC2"
Private nCount		:= 0
//Seleciona a tabela SC2
DbSelectArea("SC2")		// ORDENS DE PRODUÇÃO
SC2->(DbSetOrder(1))	// C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
//Seleciona a tabela SBA
DbSelectArea("SB1")		// DESCRIÇÃO GENÉRICA DO PRODUTO
SB1->(DbSetOrder(1))	// B1_FILIAL+B1_COD

// Monta a query principal
_cAliasTop := _fMkQryPrn(nOrdem)

AEval(SC2->(dbStruct()),{|x| IIf(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(_cAliasTop,x[1],x[2],x[3],x[4]),Nil) })

// Posiciona na query
DbSelectArea(_cAliasTop)

//Guarda o total de registros
Count to nCount

// Posiciona no primeiro registro
(_cAliasTop)->(DbGoTop())

// Se não tiver informação
If (_cAliasTop)->(Eof())
	MsgAlert('Não existe dados para os parâmetros informados! Verifique.','Atenção')
Else
	// Seta a regua
	SetRegua((_cAliasTop)->(LastRec()))

	// Enquanto não for final de arquivo
	While (_cAliasTop)->(!Eof())
		IF lEnd
			oPrinter:StartPage()
			oPrinter:Say(li,5,STR0006)//"CANCELADO PELO OPERADOR"
			oPrinter:EndPage()
			oPrinter:Print()
			Exit
		EndIF
		IncRegua()
		If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial('SC2')+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial('SC2')+mv_par02
			dbSkip()
			Loop
		EndIf
		//Verifica se a OP é firme ou Prevista.
		If !MtrAValOP(mv_par10,"SC2",_cAliasTop)
			dbSkip()
			Loop
		EndIf
		//Atruibui o codigo do Produto
		cProduto  := C2_PRODUTO
		//Atruibui a Quantidade do Produto
		nQuant    := aSC2Sld(_cAliasTop)

		//Seleciona o Alias
		dbSelectArea("SB1")
		dbSeek(xFilial()+cProduto)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona o primeiro elemento da estrutura , ou seja , o Pai  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AddAr797(nQuant)
		MontStruc((_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD),nQuant)
		If mv_par09 == 1
			aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
		Else
			aSort( aArray,2,, { |x, y| (x[8]+x[1]) < (y[8]+y[1]) } )
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime cabecalho                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+cProduto)
		
		//If AllTrim(_cNumOP) <> AllTrim((_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)) 
		If AllTrim(_cNumOP) <> AllTrim((_cAliasTop)->(C2_NUM))
			nPagina := 1
			cabecOp(nPagina,oPrinter,0,.T.)
			//_cNumOP := (_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
			_cNumOP := (_cAliasTop)->(C2_NUM)
		Else
			If li > (nMaxLin-200)
				oPrinter:EndPage()
				Li := 15
				nPagina++
				cabecOp(nPagina,oPrinter,0,.F.)
			Else
				cabecOp(nPagina,oPrinter,li,.T.)
			EndIf
		EndIf
		
		//Retorna a Qtde de Item que serao impressao em outro Quadro (OPERACOES)
		_nQtdAux := xNumSZ6((_cAliasTop)->C2_PRODUTO)	 
		
		If _nQtdAux > Len(aArray)
			_nQtdAux := (Len(aArray)-1)
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
			// Li = 201
			/*
			oPrinter:Line( 201, 460, 790, 460,, "-1") // Linha Vertical Primeira - Codgido
			oPrinter:Line( 201, 001, 790, 001,, "-1") // Linha Vertical Codigo 
			oPrinter:Line( 201, 070, 790, 070,, "-1") // Linha Vertical Descição
			oPrinter:Line( 201, 270, 790, 270,, "-1") // Linha Vertical Quantidade
			oPrinter:Line( 201, 340, 790, 340,, "-1") // Linha Vertical U.M - Unidade de Medida
			oPrinter:Line( 201, 370, 790, 370,, "-1") // Linha Vertical Armazem
			oPrinter:Line( 201, 390, 790, 390,, "-1") // Linha Vertical Endereço
			oPrinter:Line( 201, 490, 790, 490,, "-1") // Linha Vertical da da 2ª unidade de Mediada
			oPrinter:Line( 201, 550, 790, 550,, "-1") // Linha Vertical do Lote
			oPrinter:Line( 201, 590, 790, 590,, "-1") // Linha Vertical da QT da 2ª unidade
			oPrinter:Line( 790,001, 790	, 590,, "-1") // linha Horizontal no fina da Pagina
			*/
		EndIf
		
		_cAlias		:= Alias()
		For I := 2 TO Len(aArray)
			dbSelectArea("SZ6")
			dbSetOrder(2)
			If !dbSeek(xFilial("SZ6")+(_cAliasTop)->C2_PRODUTO+SG2->G2_CODIGO+aArray[I][1])
				
				cQtd := Transform(aArray[I][5],PesqPictQt("D4_QUANT",TamSX3("D4_QUANT")[1]))
				cQtd2:= Transform(aArray[I][12],PesqPictQt("D4_QUANT",TamSX3("D4_QUANT")[1]))
				
				oPrinter:Say(Li+010,002,aArray[I][1]				,oFontTB) //"CODIGO"
				oPrinter:Say(Li+010,072,SubStr(aArray[I][2],1,45)	,oFontTB) //"DESCRICAO"
				oPrinter:Say(Li+010,272,cQtd,oFontTB) //"QUANTIDADE"
				oPrinter:Say(Li+010,343,aArray[I][4],oFontTB) //"UM"
				oPrinter:Say(Li+010,373,aArray[I][6],oFontTB) //"ARM"
				oPrinter:Say(Li+010,393,aArray[I][7],oFontTB) //"ENDERECO"
				oPrinter:Say(Li+010,462,Posicione("SB1",1,xFilial("SB1")+aArray[I][1],"B1_SEGUM"),oFontTB) //"2a UM Sigla"
				oPrinter:Say(Li+010,493,aArray[I][10],oFontTB) //"LOTE"
				oPrinter:Say(Li+010,553,AllTrim(cQtd2),oFontTB) //"2 UM"

				oPrinter:Line( 201, 460, Li, 460,, "-1") // Linha Vertical Primeira - Codgido
				oPrinter:Line( 201, 001, Li, 001,, "-1") // Linha Vertical Codigo 
				oPrinter:Line( 201, 070, Li, 070,, "-1") // Linha Vertical Descição
				oPrinter:Line( 201, 270, Li, 270,, "-1") // Linha Vertical Quantidade
				oPrinter:Line( 201, 340, Li, 340,, "-1") // Linha Vertical U.M - Unidade de Medida
				oPrinter:Line( 201, 370, Li, 370,, "-1") // Linha Vertical Armazem
				oPrinter:Line( 201, 390, Li, 390,, "-1") // Linha Vertical Endereço
				oPrinter:Line( 201, 490, Li, 490,, "-1") // Linha Vertical da da 2ª unidade de Mediada
				oPrinter:Line( 201, 550, Li, 550,, "-1") // Linha Vertical do Lote
				oPrinter:Line( 201, 590, Li, 590,, "-1") // Linha Vertical da QT da 2ª unidade
				
				Li+=10
				//Imprimir as linhas // Por Samuel Miranda 08/05/2020
				oPrinter:Line( 201, 460, Li+2, 460,, "-1") // Linha Vertical Primeira - Codgido
				oPrinter:Line( 201, 001, Li+2, 001,, "-1") // Linha Vertical Codigo 
				oPrinter:Line( 201, 070, Li+2, 070,, "-1") // Linha Vertical Descição
				oPrinter:Line( 201, 270, Li+2, 270,, "-1") // Linha Vertical Quantidade
				oPrinter:Line( 201, 340, Li+2, 340,, "-1") // Linha Vertical U.M - Unidade de Medida
				oPrinter:Line( 201, 370, Li+2, 370,, "-1") // Linha Vertical Armazem
				oPrinter:Line( 201, 390, Li+2, 390,, "-1") // Linha Vertical Endereço
				oPrinter:Line( 201, 490, Li+2, 490,, "-1") // Linha Vertical da da 2ª unidade de Mediada
				oPrinter:Line( 201, 550, Li+2, 550,, "-1") // Linha Vertical do Lote
				oPrinter:Line( 201, 590, Li+2, 590,, "-1") // Linha Vertical da QT da 2ª unidade
				//oPrinter:Line( Li+5,001, Li+5, 590,, "-1") // linha Horizontal no fina da Pagina

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se nao couber, salta para proxima folha                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If li >= nMaxLin-140	
					oPrinter:EndPage()
					Li := 15
					nPagina++
					CabecOp(nPagina,oPrinter,0,.F.)		// imprime cabecalho da OP	
				EndIF
			EndIf
		Next I
		If  !Empty(aArray) // Len(aArray) > 0
			oPrinter:Line( Li+5,001, Li+5, 590,, "-1") // linha Horizontal no fina da Pagina
		EndIf
		dbSelectArea(_cAlias)
		
		If mv_par05 == 1
			If li >= (nMaxLin-140)
				oPrinter:EndPage()
				Li := 15
				nPagina++
				CabecOp(nPagina,oPrinter,0,.F.)		// imprime cabecalho da OP
			EndIF
			RotOper(oPrinter)   	// IMPRIME ROTEIRO DAS OPERACOES
		Endif

		aArray:={}
		li+=10
		
		// vai para o proximo registro
		(_cAliasTop)->(DbSkip())
		nCount--

		// Alteracao chamado 4776 - Whiverson  - inicio
		_cAlias := Alias()
		dbSelectArea("SZ2")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ2")+cProduto)	
			_aBmp := StrTokArr( AllTrim(SZ2->Z2_ARQDESE) , ";" ) // Nome das figuras Separado por ; sem EXTENSAO, cria um Array
			For _nCount := 1 to Len(_aBmp) // Le o Array com as Figuras a serem impressas
				If Empty(_aBmp[_nCount])
					Loop
				EndIf
				//Alterado para pegar o Desenho na pasta DIRDOC do sistema - Por Samuel Mirnda 20/03/2022
				_cBmp := "O:\Desenhos em PDF\Desenhos JPG Equipamentos\"+AllTrim(_aBmp[_nCount])+".jpg" // Nome do Arquivo Referente a Imagem
				If File(_cBmp)
					oPrinter:SetLandscape()
					oPrinter:StartPage()
					// lin, col, jpg, larg, alt
					oPrinter:SayBitmap( 0000,0000,_cBmp,0600,0800 )
					oPrinter:SetPortrait()
					li+=50
				EndIf
			Next
	     Else   
			ABmp := "O:\Desenhos em PDF\Desenhos JPG Equipamentos\"+AllTrim(cProduto)+".jpg" 	         
			If File(aBmp)
				oPrinter:EndPage()
				Li := 15
				nPagina++
				
				oPrinter:SetLandscape()
				oPrinter:StartPage()
				// lin, col, jpg, larg, alt
				oPrinter:SayBitmap( 0000,0000,aBmp,0600,0800 )
				oPrinter:SetPortrait()
				oPrinter:EndPage()
			
				If nCount > 0
					oPrinter:StartPage()
					Li := 15
					nPagina++
				EndIf
			EndIf
		EndIf
	dbSelectArea(_cAlias)
	// Alteracao chamado 4776 - Whiverson  - fim	
	EndDo
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
	//Variaveis
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
	
	//Se esta marcado para filtrar usuário logado
	If MV_PAR14 == 1                                                                                 
		_cWhere += " AND C2_XUSUARI = '" + cUserName + "' "
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
	//Inicia a query em SQL
	BeginSql Alias _cAlias
		SELECT 
			SC2.C2_FILIAL, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_DATPRF,
			SC2.C2_DATRF, SC2.C2_PRODUTO, SC2.C2_DESTINA, SC2.C2_PEDIDO, SC2.C2_ROTEIRO, SC2.C2_QUJE,
			SC2.C2_PERDA, SC2.C2_QUANT, SC2.C2_DATPRI, SC2.C2_EMISSAO, SC2.C2_CC, SC2.C2_DATAJI, SC2.C2_DATAJF,
			SC2.C2_STATUS, SC2.C2_OBS, SC2.C2_TPOP, SC2.C2_LOTECTL, C2_OPC, SC2.R_E_C_N_O_ AS REG,
			SC2.R_E_C_N_O_  SC2RECNO
		FROM %Table:SC2% SC2
		WHERE
			SC2.C2_FILIAL = %xFilial:SC2%
			AND SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD >= %Exp:MV_PAR01%
			AND SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD <= %Exp:MV_PAR02%
			AND SC2.C2_DATPRF BETWEEN %Exp:Dtos(MV_PAR03)% AND %Exp:Dtos(MV_PAR04)%
			AND SC2.%NotDel%
			%Exp:_cExpre%
	EndSql
Return _cAlias

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
±±³ Uso      ³ MATR797                       llll                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function AddAr797(nQuantItem)
Local cDesc    := SB1->B1_DESC
Local cLocal   := ""
Local cKey     := ""
Local cRoteiro := ""

//Local lVer116   := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se imprime nome cientifico do produto. Se Sim    ³
//³ verifica se existe registro no SB5 e se nao esta vazio    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par07 == 1
	dbSelectArea("SB5")
	dbSeek(xFilial()+SB1->B1_COD)
	If Found() .and. !Empty(B5_CEME)
		cDesc := B5_CEME
	EndIf
ElseIf mv_par07 == 2
	cDesc := SB1->B1_DESC
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se imprime descricao digitada ped.venda, se sim  ³
	//³ verifica se existe registro no SC6 e se nao esta vazio    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se imprime ROTEIRO da OP ou PADRAO do produto    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

//If lVer116
//	dbSelectArea("NNR")
//	dbSeek(xFilial()+SD4->D4_LOCAL)
//Else
	dbSelectArea("SB2")
	dbSeek(xFilial()+SB1->B1_COD+SD4->D4_LOCAL)
//EndIf

dbSelectArea("SD4")
cKey:=SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT+SD4->D4_LOTECTL+SD4->D4_NUMLOTE
//cLocal:=SB2->B2_LOCALIZ

DbSelectArea("SDC")
DbSetOrder(2)
DbSeek(xFilial("SDC")+cKey)
If !Eof() .And. SDC->(DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE) == cKey
	cLocal:=DC_LOCALIZ
EndIf

dbSelectArea("SD4")

//If lVer116
//	AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,NNR->NNR_DESCRI,SD4->D4_TRT,cRoteiro,If(mv_par12 == 1,SD4->D4_LOTECTL,""),If(mv_par12 == 1,SD4->D4_NUMLOTE,""), SD4->D4_QTSEGUM } )
//Else
	AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,cLocal,SD4->D4_TRT,cRoteiro,If(mv_par12 == 1,SD4->D4_LOTECTL,""),If(mv_par12 == 1,SD4->D4_NUMLOTE,""), SD4->D4_QTSEGUM } )
//EndIf

//If lVer116
//	AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,NNR->NNR_DESCRI,SD4->D4_TRT,cRoteiro,If(mv_par12 == 1,SD4->D4_LOTECTL,""),If(mv_par12 == 1,SD4->D4_NUMLOTE,""), If(SB1->B1_TIPCONV == "D",nQuantItem/SB1->B1_CONV,nQuantItem*SB1->B1_CONV) } )
//Else
//	AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,cLocal,SD4->D4_TRT,cRoteiro,If(mv_par12 == 1,SD4->D4_LOTECTL,""),If(mv_par12 == 1,SD4->D4_NUMLOTE,""), If(SB1->B1_TIPCONV == "D",nQuantItem/SB1->B1_CONV,nQuantItem*SB1->B1_CONV) } )
//EndIf
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
	//Selectio a Tabela SD4
	DbSelectArea("SD4")		// Requisições Empenhadas
	SD4->(DbSetOrder(2))	// D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
	//Selectio a Tabela SD3
	DbSelectArea("SD3")		// MOVIMENTAÇÕES INTERNAS
	SD3->(DbSetOrder(1))	// D3_FILIAL+D3_OP+D3_COD+D3_LOCAL

	If SD4->(DbSeek(xFilial("SD4")+cOp))
		While SD4->(!Eof()) .And. SD4->(D4_FILIAL+D4_OP) == xFilial("SD4")+cOp
			// Posiciona no produto desejado
			If SB1->(DbSeek(xFilial("SB1")+SD4->D4_COD))
				// Se considera saldo e tem saldo
				If MV_PAR15 == 1 .And. (SD4->D4_QUANT > 0)// .Or. (lItemNeg .And. SD4->D4_QUANT < 0))
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
Static Function CabecOp(nPagOp,oPrinter,nLiAtu,lTudo) //lTudo (Imprime CABEC Completo ou Resumido
//Variavel para o titulo da Ordem de Produção
Local cTitulo := "PFI - PLANO DE FABRICACAO E INSPECAO "
Local cTitulo2:= "PFI :"+(_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD) + "LOTE: " + (_cAliasTop)->C2_LOTECTL + If((_cAliasTop)->C2_LOTECTL <> '',"" ,"")  //samuel

//Local cTitulo2:= "PFI :"+(_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD) + "LOTE: " + (_cAliasTop)->C2_LOTECTL + If((_cAliasTop)->C2_LOTECTL <> '',"N. SERIE: " + (_cAliasTop)->C2_LOTECTL,"")
Local nBegin, _nI
Local nAltura  	:= 0
Local nTotImp	:= 0
Local _aOpcs	:= {}
Local _cDescri 	:= ""
Local _nLiAux	:= 0

Private oFontC
Private oFontT
Private oFont14N
Private oFont16N

oFontT 		:= TFont():New('Courier new',,8,.T.)
oFontTB 		:= TFont():New('Courier new',,8,.T.,.T.)
oFontC 		:= TFont():New('Courier new',,12,.T.)
oFontCB 		:= TFont():New('Courier new',,12,.T.,.T.)
oFont14N 	:= TFont():New('Courier new',,14,.T.,.T.)
oFont16N 	:= TFont():New('Courier new',,16,.T.,.T.)

If nLiAtu == 0
	oPrinter:StartPage()
	nAltura := 10//oPrinter:nPageHeight
	nLargura:= 10//oPrinter:nPageWidth
	oPrinter:Cmtr2Pix(nAltura,nLargura)
	Li := 20
Else
	oPrinter:Line( Li, 		5, li		, nMaxCol-10,, "-1")
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

//Pirolo - Adicionado tratamento para que o código de barras seja impresso na linha corrente e não fixo no topo da pagina.
oPrinter:FWMSBAR("CODE128" /*cTypeBar*/,li/11.7/*nRow*/,0.3/*nCol*/,AllTrim(cCode)/*cCode*/,oPrinter/*oPrint*/,/*lCheck*/,/*Color*/,/*lHorz*/,/*nWidth*/,1.0/*nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/)
//oPrinter:FWMSBAR("CODE128" /*cTypeBar*/,1.7/*nRow*/,0.3/*nCol*/,AllTrim(cCode)/*cCode*/,oPrinter/*oPrint*/,/*lCheck*/,/*Color*/,/*lHorz*/,/*nWidth*/,1.0/*nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/)
Li+=1
oPrinter:SayAlign(Li-2	,502, "Fol:"+TRANSFORM(nPagOp,'999999999')		,oFontTB,nMaxCol-10,200,,0)
oPrinter:SayAlign(Li+20	,502,"F1 09-02 Rev.01",oFontTB,nMaxCol-10,200,,0) // Leonardo Vieira 27/04/2022
//Pirolo - Adicionar contador de impressões (TOTALIZAR NO CAMPO C2_XQTDPRT)
nTotImp		:= (_cAliasTop)->(PegaTotImp(C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD))
oPrinter:SayAlign(Li+6		,502, "Impressão: "+TRANSFORM(nTotImp,'99')	,oFontTB,nMaxCol-10,200,,0)
//Pirolo - Adicionar Data e Hora de emissão
oPrinter:SayAlign(Li+14		,502, AllToChar(Date())+" "+AllToChar(Time())	,oFontTB,nMaxCol-10,200,,0)

//MAURICIO - LOGO
ABmp := "\logo\OS.BMP" // Buscar nome em tabela especifica
If File(aBmp)
	oPrinter:SetLandscape()
	//oPrinter:StartPage()
	// lin, col, jpg, larg, alt
	oPrinter:SayBitmap( Li+02	,140,aBmp,0040,0030 )
	oPrinter:SetPortrait()
EndIf
//fim
oPrinter:SayAlign(Li+05	,218,cTitulo ,oFont14N,nMaxCol-10,200,,0)
oPrinter:SayAlign(Li+22	,218,cTitulo2,oFont14N,nMaxCol-10,200,,0)
Li += 40
// Aqui Li = 60 Quando Nova Pagina
//Pirolo - Marca dagua
// Trocado por imagem - Por Samuel Miranda 08/05/2020 e colocado na linha 1080
/*
If Posicione("SB1",1,xFilial("SB1")+(_cAliasTop)->C2_PRODUTO,"B1_XCORRID") == "1"
	//If  Posicione("SB1",1,xFilial("SB1")+aArray[1][1],"B1_XCORRID") = "1"
	//oPrinter:SayAlign(0200, 0200, "Protótipo", oFontMD, nMaxCol-10,200, CLR_LIGHTGRAY , 2)
	ABmp2 := "Prot.png"	
	oPrinter:SayBitmap( 0200,0200,ABmp2,0340,0380 )
EndIf
*/
Li +=10
//Cria Box Dados do Produto (2)
oPrinter:Box(Li,001,Li+20,060)
oPrinter:Box(Li,060,Li+20,150)
oPrinter:Box(Li,150,Li+20,210)
oPrinter:Box(Li,210,Li+20,460)
oPrinter:Box(Li,460,Li+20,490)
oPrinter:Box(Li,490,Li+20,530)
oPrinter:Box(Li,530,Li+20,nMaxCol-10)

oPrinter:Say(Li+10,002,"Produto",oFontC)
oPrinter:Say(Li+10,062,aArray[1][1],oFont14N)
oPrinter:Say(Li+10,152,"Descricao",oFontC,600)
oPrinter:Say(Li+10,212,SubStr(aArray[1][2],01,35),oFont14N,600)
oPrinter:Say(Li+20,212,SubStr(aArray[1][2],36,70),oFont14N,600)
oPrinter:Say(Li+10,462,Posicione("SB1",1,xFilial("SB1")+aArray[1][1],"B1_UM"),oFontC,600)
oPrinter:Say(Li+10,492,"Quant.",oFontC,600)
oPrinter:Say(Li+10,532,Transform((_cAliasTop)->C2_QUANT,"@E 99999.99"),oFont14N,600)

Li += 20
// Aqui Li == 80 Quando Nova Pagaina
//Cria Box Dados do Autor / Responsavel / Data (4)
oPrinter:Box(Li,001,Li+20,250)
oPrinter:Box(Li,250,Li+20,500)
oPrinter:Box(Li,500,Li+20,nMaxCol-10)

aAreaSC2 := GetArea("SC2")
dbSelectArea("SC2")
dbGoto((_cAliasTop)->REG)
oPrinter:Say(Li+10,002,"Autor(a): "+AllTrim(FWLEUSERLG("C2_USERLGI",1)),oFontTB)
RestArea(aAreaSC2)

oPrinter:Say(Li+10,251,"Responsável: "+GETMV("MV_XRESTEC"),oFontTB)
oPrinter:Say(Li+7	,502,"Data   : "+DTOC((_cAliasTop)->C2_DATPRI),oFontTB)
//Pirolo - Adicionar Data de Entrega
oPrinter:Say(Li+14	,502,"Entrega: "+DTOC((_cAliasTop)->C2_DATPRF),oFontTB)

//Samuel Miranda 08/07/2019 Inicio
_cAlias := Alias()
dbSelectArea("SZ2")
dbSetOrder(1)
dbSeek(xFilial("SZ2")+ aArray[1][1])
	Li += 20		
	//Cria Box Dados da Revisao do Processo e Desenho (5)
	oPrinter:Box(Li,001,Li+20,150)
	oPrinter:Box(Li,150,Li+20,300)
	oPrinter:Box(Li,300,Li+20,450)
	oPrinter:Box(Li,450,Li+20,nMaxCol-10)

	_Rev 	:= SZ2->Z2_REVPROC
	_Des	:= SZ2->Z2_CODDESE
	_rDes	:= SZ2->Z2_REVDESE
	_aTual	:= DTOC(SZ2->Z2_DTREVIS)
	
	oPrinter:Say(Li+10,002,"Rev Proc.: "	+ AllTrim(_Rev),oFontTB)
	oPrinter:Say(Li+10,151,"Desenho: "		+ AllTrim(_Des),oFontTB)
	oPrinter:Say(Li+10,302,"Rev Desenho: "	+ AllTrim(_rDes),oFontTB)
    //oPrinter:Say(Li+10,452,"Atual.: "		+ _aTual	,oFontTB)	
	_cProdPai := StrTran(Alltrim(SZ2->Z2_CODDESE),"-","")  
 dbSelectArea(_cAlias)
//Samuel Miranda 08/07/2019 Fim 
_cAlias := Alias()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime nome do cliente quando OP for gerada            ³
//³ por pedidos de venda                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (_cAliasTop)->C2_DESTINA == "P"
	
	dbSelectArea("SGJ")
	dbSetOrder(2)
		If dbSeek(xFilial()+(_cAliasTop)->C2_NUM+(_cAliasTop)->C2_ITEM+(_cAliasTop)->C2_SEQUEN,.F.)
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial()+SGJ->GJ_NUMPV,.F.)
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
			
			//	oPrinter:Say(li,5,STR0016)//"Cliente: "
			//	oPrinter:Say(li,42,SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI+" "+A1_NOME)
			Li += 20
			// Aqui Li == 100 Quando Nova Pagaina
			
			//Cria Box Dados da Revisao do Processo e Desenho (5)
			oPrinter:Box(Li,001,Li+20,450)
			oPrinter:Box(Li,450,Li+20,nMaxCol-10)
			oPrinter:Say(Li+10,002,"Cliente: "+SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI+" "+A1_NOME,oFontTB)
			oPrinter:Say(Li+10,452,"Pedido: "+SC5->C5_NUM,oFontTB)
		EndIf
	EndIf
EndIf
dbSelectArea(_cAlias)

li += 20
If !(Empty((_cAliasTop)->C2_OBS))
	oPrinter:Box(Li,001,Li+20,nMaxCol-10)
	oPrinter:Say(li+10,002,STR0033)//"Observacao: "
	For nBegin := 1 To Len(Alltrim((_cAliasTop)->C2_OBS)) Step 65
		oPrinter:Say(li+10,60,Substr((_cAliasTop)->C2_OBS,nBegin,65))
		@li,012 PSay Substr((_cAliasTop)->C2_OBS,nBegin,65)
		li+=10
	Next nBegin
EndIf

li += 10
If !(Empty((_cAliasTop)->C2_OPC))
	_aOpcs := StrTokArr( (_cAliasTop)->C2_OPC, "/" )
	_nLiAux := (10*Len(_aOpcs))+10
	oPrinter:Box(Li,001,Li+_nLiAux,nMaxCol-10)
	oPrinter:Say(li+10,002,"Opcionais:")
	For _nI := 1 To Len(_aOpcs)
		If Empty(AllTrim(_aOpcs[_nI]))
			Loop
		EndIf		
		dbSelectArea("SGA")
		dbSetOrder(1)
		dbSeek( xFilial("SGA")+AllTrim(_aOpcs[_nI]) )
		_cDescri := SGA->GA_DESCGRP + ": " + SGA->GA_DESCOPC
		oPrinter:Say(li+10,060,_cDescri)
		li+=10
	Next _nI
EndIf

_cAlias := Alias()
dbSelectArea("SZ5")
dbSetOrder(1)
If dbSeek(xFilial("SZ5")+aArray[1][1])
	Li += 30
	//Aqui Li == 100 Quando Nova Pagina
	//Cria Box Dados da Revisao do Processo e Desenho (5)
	oPrinter:Box(Li,001,Li+20,nMaxCol-10)
	oPrinter:Say(Li+10,002,"Lista Mestra: ",oFontTB)
	oPrinter:Say(Li+10,151,"Pagina: ",oFontTB)
	oPrinter:Say(Li+10,452,"Revisao: ",oFontTB)

	While !Eof() .And. SZ5->Z5_PRODUTO == aArray[1][1]
		Li += 20	
		oPrinter:Box(Li,001,Li+20,nMaxCol-10)
		oPrinter:Say(Li+10,002,AllTrim(SZ5->Z5_PRODUTO),oFontTB)
		oPrinter:Say(Li+10,151,AllTrim(SZ5->Z5_PAGINA),oFontTB)
		oPrinter:Say(Li+10,452,AllTrim(SZ5->Z5_REVDESE),oFontTB)
		dbSkip()
	EndDo
	_cProdPai := aArray[1][1]
EndIf
dbSelectArea(_cAlias)
li += 20
// Aqui Li == 120 Quando Nova Pagaina
//Cria Box RASTREAMENTO MP (5)
oPrinter:Box(Li,001,li+20,nMaxCol-10)
oPrinter:Say(Li+10,050,"Rastrear Matéria Prima - Procedimento Aplicável DQL"+AllTrim(GetMv("MV_XPROCMP")),oFont14N)
Li += 20
//Cria Box COMPONENTES (6)
oPrinter:Box(Li,001,Li+10,070) // Codigo - 070 Pos
oPrinter:Box(Li,070,Li+10,270) // Descricao - 220 Pos
oPrinter:Box(Li,270,Li+10,340) // Quantidade - 070 Pos
oPrinter:Box(Li,340,Li+10,370) // U.M. - 030 Pos
oPrinter:Box(Li,370,Li+10,390) // Armazem - 020 Pos
oPrinter:Box(Li,390,Li+10,460) // Endereco - 070 Pos
oPrinter:Box(Li,460,Li+10,490) // 2 UM SIGLA - 030 Pos
oPrinter:Box(Li,490,Li+10,550) // Lote - 040 Pos
oPrinter:Box(Li,550,Li+10,nMaxCol-10) // 2 U.M. QTD - 080 Pos
//Imprime o cabeçalho
oPrinter:Say(Li+006,002,STR0034,oFontTB) //"CODIGO"
oPrinter:Say(Li+006,072,STR0035,oFontTB) //"DESCRICAO"
oPrinter:Say(Li+006,272,STR0036,oFontTB) //"QUANTIDADE"
oPrinter:Say(Li+006,342,STR0037,oFontTB) //"UM"
oPrinter:Say(Li+006,372,STR0038,oFontTB) //"ARM"
oPrinter:Say(Li+006,392,STR0039,oFontTB) //"ENDERECO"
oPrinter:Say(Li+006,462,"2a UM" ,oFontTB) //"2a UM Sigla"
oPrinter:Say(Li+006,492,"LOTE" ,oFontTB) //"LOTE"
oPrinter:Say(Li+006,552,"Qt 2a UM",oFontTB) //"2a UM QT"
Li+=10
oPrinter:Say(Li,001,"",oFontT)
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
				If !_lFirst1
					//Imprime os Box	
					oPrinter:Box(Li,001,Li+_nAux,020) // Operacao - 020 Pos
					oPrinter:Box(Li,020,Li+_nAux,170) // Recurso  - 150 Pos
					oPrinter:Box(Li,170,Li+_nAux,270) // Ferramenta - 100 Pos
					oPrinter:Box(Li,270,Li+_nAux,320) // Tempo - 050 Pos
					oPrinter:Box(Li,320,Li+_nAux,520) // Instrucoes - 200 Pos
					oPrinter:Box(Li,520,Li+_nAux,nMaxCol-10) // DQL - 070 Pos
					//IMprime o cabeçalho dos roteiros
					oPrinter:Say(li+08,002,"OPER",oFontTB)			//"OPERACAO"
					oPrinter:Say(li+08,022,STR0047,oFontTB)			//"RECURSO"
					oPrinter:Say(li+08,172,STR0048,oFontTB)			//"FERRAMENTA"
					oPrinter:Say(li+08,272,"TEMPO",oFontTB)			//"TEMPO"
					oPrinter:Say(li+08,322,"INSTRUÇÕES",oFontTB)	//"Instrucoes"
					oPrinter:Say(li+08,522,"Proc.Apli.DQL",oFontTB)	//"DQL"
					li+=10
				EndIf
				_lFirst1 := .T.
				ImpRot(lSH8,oPrinter)
				dbSelectArea("SH8")
				dbSkip()
			End
		Else
			If !_lFirst1
				//Imprime os Box	
				oPrinter:Box(Li,001,Li+10,020) // Operacao - 020 Pos
				oPrinter:Box(Li,020,Li+10,170) // Recurso  - 150 Pos
				oPrinter:Box(Li,170,Li+10,320) // Ferramenta - 150 Pos
				oPrinter:Box(Li,320,Li+10,520) // Instrucoes - 200 Pos
				oPrinter:Box(Li,520,Li+10,nMaxCol-10) // DQL - 070 Pos
				//IMprime o cabeçalho dos roteiros
				oPrinter:Say(li+08,002,"OPER",oFontTB)			//"OPERACAO"
				oPrinter:Say(li+08,022,STR0047,oFontTB)			//"RECURSO"
				oPrinter:Say(li+08,172,STR0048,oFontTB)			//"FERRAMENTA"
				oPrinter:Say(li+08,322,"INSTRUÇÕES",oFontTB)    //"Instrucoes"
				oPrinter:Say(li+08,522,"Proc.Apli.DQL",oFontTB)	//"DQL"
				li+=10
			EndIf
			_lFirst1 := .T.
			ImpRot(lSH8,oPrinter)
		Endif

		//Samuel Miranda - Marca dagua 08/05/2020
		If Posicione("SB1",1,xFilial("SB1")+(_cAliasTop)->C2_PRODUTO,"B1_XCORRID") == "1"
				ABmp2 := "Prot.png"	
				oPrinter:SayBitmap( 0700,0170,ABmp2,0271,0052 )
		EndIf
		If Alltrim(Posicione("SB1",1,xFilial("SB1")+(_cAliasTop)->C2_PRODUTO,"B1_XEMBAL")) == "1"
			ABmp2 := "ESPECIAL.png"	
			oPrinter:SayBitmap( 0700,0170,ABmp2,0271,0052 )										
											//  Larg. Alt.		
		EndIf
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
±±³ Sintaxe  ³ RotOper()                                                  ³±±
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
	oPrinter:SayAlign(Li,050,"PODERÁ SER UTILIZADA OUTRA MÁQUINA MESMO NÃO ESTANDO NA SEQUÊNCIA DO PFI",oFont14N,nMaxCol-10,,,0)
	li+=10
	oPrinter:SayAlign(Li,200,cCabec1,oFont14N,nMaxCol-10,,,0)
	li+=20
	//Imprime os box
	oPrinter:Box(Li,001,Li+10,020) // Operacao - 020 Pos
	oPrinter:Box(Li,020,Li+10,170) // Recurso  - 150 Pos
	oPrinter:Box(Li,170,Li+10,270) // Ferramenta - 100 Pos
	oPrinter:Box(Li,270,Li+10,320) // Tempo Processo - 050 Pos
	oPrinter:Box(Li,320,Li+10,520) // Instrucoes - 200 Pos
	oPrinter:Box(Li,520,Li+10,nMaxCol-10) // DQL - 070 Pos
	//Imprime o cabeçalho do roteiro
	oPrinter:Say(li+08,002,"OPER",oFontTB)				//"OPERACAO"
	oPrinter:Say(li+08,022,STR0047,oFontTB)			//"RECURSO"
	oPrinter:Say(li+08,172,STR0048,oFontTB)			//"FERRAMENTA"
	oPrinter:Say(li+08,272,"TEMPO",oFontTB)			//"TEMPO"
	oPrinter:Say(li+08,322,"INSTRUÇÕES",oFontTB)		//"Instrucoes"
	oPrinter:Say(li+08,522,"Proc.Apli.DQL",oFontTB)	//"DQL"
	li+=10 //Aribui dez linhas a variavél
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
Local _nAux      := 0
Local nBegin     := 0
Local I          := 0
Local nI         := 0
Local _nxRec     := 0
Local cQueryOP   := ""
Local ALTEREC    := ""
Local vMinutos 	 := 0
Local tTempTotal := 0
Local nx         := 0
Local nCalc      := ""
Private oFontC
Private oFontT

oFontT := TFont():New('Courier new',,8,.T.)
oFontC := TFont():New('Courier new',,12,.T.)

dbSelectArea("SH1")
dbSeek(xFilial()+IIf(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO))

Verilim(oPrinter)
// Variavel Auxiliar para Saber se Gera BOX com Uma Linha ou Mais // NAO REMOVER
// INICIO DA LOGICA
_cInstru := Alltrim(SG2->G2_DESCRI)+" "+AllTrim(SG2->G2_XDESEXT)
_nAux := 0
If Len(Alltrim(_cInstru)) > 40
	_nAux := Int(Len(Alltrim(_cInstru))/40)
EndIf
If _nAux <> 0
	_nAux := (_nAux+1) * 10
Else
	_nAux	:= 10
EndIf
// FIM DA LOGICA
//SAmuel - Imprime os Box das operações
oPrinter:Box(Li,001,Li+_nAux,020) // Operacao - 020 Pos
oPrinter:Box(Li,020,Li+_nAux,170) // Recurso  - 150 Pos
oPrinter:Box(Li,170,Li+_nAux,270) // Ferramenta - 100 Pos
oPrinter:Box(Li,270,Li+_nAux,320) // Tempo - 050 Pos
oPrinter:Box(Li,320,Li+_nAux,520) // Instrucoes - 200 Pos
oPrinter:Box(Li,520,Li+_nAux,nMaxCol-10) // DQL - 070 Pos
//Pega o valor dos minutos
tTempTotal := (SG2->G2_TEMPAD)

//Faz o calculo do tempo padrão X Quantidade    
vMinutos := TPTIME01(tTempTotal,(_cAliasTop)->C2_QUANT) //vMinutos := Min2Hrs(tTempTotal)

nCalc := cValToChar(tTempTotal) + " X "+ cValToChar((_cAliasTop)->C2_QUANT) +" = " + vMinutos
//Imprime as operaçoes
oPrinter:Say(li+008,002,SG2->G2_OPERAC,oFontT) // Operacao 
oPrinter:Say(li+008,022,IIF(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO)+" "+SUBS(SH1->H1_DESCRI,1,25),oFontT)//Recurso
oPrinter:Say(li+008,172,SG2->G2_FERRAM+" "+SUBS(SH4->H4_DESCRI,1,20),oFontT)//Ferramenta
oPrinter:Say(li+008,272,vMinutos,oFontT) // Tempo  //((_cAliasTop)->C2_QUANT)*(SG2->G2_TEMPAD)
oPrinter:Say(li+008,522,SH1->H1_XDQL,oFontT) // DQL 
//oPrinter:Say(li+008,272,cValtoChar(Min2Hrs(Val(Substr(cValtochar(vMinutos),3)))),oFontT) // Tempo  //((_cAliasTop)->C2_QUANT)*(SG2->G2_TEMPAD)

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±n Faz a quebra das intruções 43 caracteres por linhas.					º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
_nVezes := 0
For nBegin := 1 To Len(_cInstru) Step 43
	oPrinter:Say(li+008,322,OemToAnsi(Substr(_cInstru,nBegin,43)),oFontT) // Instrucoes
	li+=10
	_nVezes++
	If li> nMaxLin-60
		li:= 0
		oPrinter:EndPage()
		nPagina++
		oPrinter:StartPage()
		Li+=10
		cRotOper(oPrinter)
		//Samuel
		oPrinter:Box(Li,001,Li+_nAux,020) // Operacao - 020 Pos
		oPrinter:Box(Li,020,Li+_nAux,170) // Recurso  - 150 Pos
		oPrinter:Box(Li,170,Li+_nAux,270) // Ferramenta - 270 Pos
		oPrinter:Box(Li,270,Li+_nAux,320) // Tempo - 050 Pos
		oPrinter:Box(Li,320,Li+_nAux,520) // Instrucoes - 200 Pos
		oPrinter:Box(Li,520,Li+_nAux,nMaxCol-10) // DQL - 070 Pos
	EndIf
Next nBegin
Li := Li - (5*_nVezes)
//oPrinter:Say(li+008,522,SH1->H1_XDQL,oFontT) // DQL 
Li := Li + (5*_nVezes)
li+=10 //15
//oPrinter:Say(Li,001,cValToChar(Li),oFontTB)//Imprime o numero ra linha (somente para teste)

//oPrinter:Box(Li,520,Li+30,nMaxCol-10) // CARIMBO
//IMPRESSAO DE COMPONETES POR OPERACAO - INICIO
dbSelectArea("SZ6")
dbSetOrder(1)        // Z6_FILIAL+Z6_PRODUTO+Z6_ROTEIRO+Z6_OPERAC+Z6_COMP+Z6_TRT
If dbSeek(xFilial("SZ6")+(_cAliasTop)->C2_PRODUTO+SG2->G2_CODIGO+SG2->G2_OPERAC)
	// *** POSICIONA ITEM COMPONENTE, SE EXISTIR IMPRIMI
	//Cria Box RASTREAMENTO MP (5)
	oPrinter:Box(Li,001,li+20,nMaxCol-10)
	oPrinter:Say(Li+10,050,"Rastrear Matéria Prima - Procedimento Aplicável DQL"+AllTrim(GetMv("MV_XPROCMP")),oFont14N)
	Li += 20
	
	//Cria Box COMPONENTES (6)
	oPrinter:Box(Li,001,Li+10,070) // Codigo - 070 Pos
	oPrinter:Box(Li,070,Li+10,270) // Descricao - 220 Pos
	oPrinter:Box(Li,270,Li+10,340) // Quantidade - 070 Pos
	oPrinter:Box(Li,340,Li+10,370) // U.M. - 030 Pos
	oPrinter:Box(Li,370,Li+10,390) // Armazem - 020 Pos
	oPrinter:Box(Li,390,Li+10,460) // Endereco - 070 Pos
	oPrinter:Box(Li,460,Li+10,490) // 2 UM SIGLA - 030 Pos
	oPrinter:Box(Li,490,Li+10,550) // Lote - 040 Pos
	oPrinter:Box(Li,550,Li+10,nMaxCol-10) // 2 U.M. QTD - 080 Pos
	//Imprime os componentes 
	oPrinter:Say(Li+006,002,STR0034,oFontTB) //"CODIGO"
	oPrinter:Say(Li+006,072,STR0035,oFontTB) //"DESCRICAO"
	oPrinter:Say(Li+006,272,STR0036,oFontTB) //"QUANTIDADE"
	oPrinter:Say(Li+006,342,STR0037,oFontTB) //"UM"
	oPrinter:Say(Li+006,372,STR0038,oFontTB) //"ARM"
	oPrinter:Say(Li+006,392,STR0039,oFontTB) //"ENDERECO"
	oPrinter:Say(Li+006,462,"2a UM" ,oFontTB) //"2a UM Sigla"
	oPrinter:Say(Li+006,492,"LOTE" ,oFontTB) //"LOTE"
	oPrinter:Say(Li+006,552,"Qt 2a UM",oFontTB) //"2a UM QT"
	Li+=10
	// Retorna a Qtde de Item que serao impressao em outro Quadro (OPERACOES)
	_nQtdAux := xNumSZ6((_cAliasTop)->C2_PRODUTO, SG2->G2_CODIGO, SG2->G2_OPERAC,aArray)
	//Imprime os Box
	oPrinter:Box(Li,001,Li+5+(_nQtdAux*10),070) // Codigo - 070 Pos
	oPrinter:Box(Li,070,Li+5+(_nQtdAux*10),270) // Descricao - 220 Pos
	oPrinter:Box(Li,270,Li+5+(_nQtdAux*10),340) // Quantidade - 070 Pos
	oPrinter:Box(Li,340,Li+5+(_nQtdAux*10),370) // U.M. - 030 Pos
	oPrinter:Box(Li,370,Li+5+(_nQtdAux*10),390) // Armazem - 020 Pos
	oPrinter:Box(Li,390,Li+5+(_nQtdAux*10),460) // Endereco - 100 Pos
	oPrinter:Box(Li,460,Li+5+(_nQtdAux*10),490) // 2a U.M. Sigla - 030 Pos
	oPrinter:Box(Li,490,Li+5+(_nQtdAux*10),550) // Lote - 060 Pos
	oPrinter:Box(Li,550,Li+5+(_nQtdAux*10),nMaxCol-10) // 2 U.M. - 040 Pos
	
	//oPrinter:Say(Li,001,"",oFontT)
	For I := 2 TO Len(aArray)	
		// *** POSICIONA OPERACAO X COMPONENTE, COM PRODUTO E A OPERACAO, SE OK, IMPRIMI
		If dbSeek(xFilial("SZ6")+(_cAliasTop)->C2_PRODUTO+SG2->G2_CODIGO+SG2->G2_OPERAC+aArray[I][1])     // MAURICIO INCLUIDO SD4->D4_TRT - 17/02/2022 MAURICIO RETIRADO +aArray[I][8]
			
			If li >= nMaxLin-100
				li:= 0
				oPrinter:EndPage()
				nPagina++
				oPrinter:StartPage()
				Li+=10
				cCabec1 := STR0041+(_cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)	//" ROTEIRO DE OPERACOES NRO :"
				li+=10
				oPrinter:SayAlign(Li,050,"PODERÁ SER UTILIZADA OUTRA MÁQUINA MESMO NÃO ESTANDO NA SEQUÊNCIA DO PFI",oFont14N,nMaxCol-10,,,0)
				li+=10
				oPrinter:SayAlign(Li,200,cCabec1,oFont14N,nMaxCol-10,,,0)
				li+=20
				
				//Cria Box COMPONENTES (6)
				oPrinter:Box(Li,001,Li+10,070) // Codigo - 070 Pos
				oPrinter:Box(Li,070,Li+10,270) // Descricao - 220 Pos
				oPrinter:Box(Li,270,Li+10,340) // Quantidade - 070 Pos
				oPrinter:Box(Li,340,Li+10,370) // U.M. - 030 Pos
				oPrinter:Box(Li,370,Li+10,390) // Armazem - 020 Pos
				oPrinter:Box(Li,390,Li+10,460) // Endereco - 070 Pos
				oPrinter:Box(Li,460,Li+10,490) // 2 UM SIGLA - 030 Pos
				oPrinter:Box(Li,490,Li+10,550) // Lote - 040 Pos
				oPrinter:Box(Li,550,Li+10,nMaxCol-10) // 2 U.M. QTD - 080 Pos
				//Imprime o cabeçalho dos componentes
				oPrinter:Say(Li+006,002,STR0034,oFontTB) //"CODIGO"
				oPrinter:Say(Li+006,072,STR0035,oFontTB) //"DESCRICAO"
				oPrinter:Say(Li+006,272,STR0036,oFontTB) //"QUANTIDADE"
				oPrinter:Say(Li+006,342,STR0037,oFontTB) //"UM"
				oPrinter:Say(Li+006,372,STR0038,oFontTB) //"ARM"
				oPrinter:Say(Li+006,392,STR0039,oFontTB) //"ENDERECO"
				oPrinter:Say(Li+006,462,"2a UM" ,oFontTB) //"2a UM Sigla"
				oPrinter:Say(Li+006,492,"LOTE" ,oFontTB) //"LOTE"
				oPrinter:Say(Li+006,552,"Qt 2a UM",oFontTB) //"2a UM QT"
				Li+=10
				//oPrinter:Say(Li,001,"",oFontT)
				//Imprime os box
				oPrinter:Box(Li,001,Li+(_nQtdAux*10),070) // Codigo - 070 Pos
				oPrinter:Box(Li,070,Li+(_nQtdAux*10),270) // Descricao - 220 Pos
				oPrinter:Box(Li,270,Li+(_nQtdAux*10),340) // Quantidade - 070 Pos
				oPrinter:Box(Li,340,Li+(_nQtdAux*10),370) // U.M. - 030 Pos
				oPrinter:Box(Li,370,Li+(_nQtdAux*10),390) // Armazem - 020 Pos
				oPrinter:Box(Li,390,Li+(_nQtdAux*10),460) // Endereco - 100 Pos
				oPrinter:Box(Li,460,Li+(_nQtdAux*10),490) // 2a U.M. Sigla - 030 Pos
				oPrinter:Box(Li,490,Li+(_nQtdAux*10),550) // Lote - 060 Pos
				oPrinter:Box(Li,550,Li+(_nQtdAux*10),nMaxCol-10) // 2 U.M. - 040 Pos
				//oPrinter:Say(Li,001,"",oFontT)
			EndIf
			//Atualiza o valor da variavel
			_nQtdAux--
			
			cQtd := Transform(aArray[I][5],PesqPictQt("D4_QUANT",TamSX3("D4_QUANT")[1])) //Quantide 01 
			cQtd2:= Transform(aArray[I][12],PesqPictQt("D4_QUANT",TamSX3("D4_QUANT")[1])) //Quantide 02
			
			oPrinter:Say(Li+010,002,aArray[I][1]				,oFontTB) //"CODIGO"
			oPrinter:Say(Li+010,072,SubStr(aArray[I][2],1,45)	,oFontTB) //"DESCRICAO"
			oPrinter:Say(Li+010,272,cQtd						,oFontTB) //"QUANTIDADE"
			oPrinter:Say(Li+010,342,aArray[I][4]				,oFontTB) //"UM"
			oPrinter:Say(Li+010,372,aArray[I][6]				,oFontTB) //"ARM"
			oPrinter:Say(Li+010,392,aArray[I][7]				,oFontTB) //"ENDERECO"
			oPrinter:Say(Li+010,462,Posicione("SB1",1,xFilial("SB1")+aArray[I][1],"B1_SEGUM"),oFontTB) //"2a UM Sigla"
			oPrinter:Say(Li+010,510,aArray[I][10]				,oFontTB) //"LOTE"
			oPrinter:Say(Li+010,570,AllTrim(cQtd2)				,oFontTB) //"2 UM"
			Li+=10			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se nao couber, salta para proxima folha                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		EndIf
	Next I
	li+=15
EndIf
// FIM
oPrinter:Say(Li,001,"",oFontT) // Seta a Fonte Normal (Sem Negrito) imprime o numero da linha

//Pirolo - Correção de posicionamento da linha, sem este ajuste o relatório truncava as linhas abaixo com a tabela de detalhes.
If _nQtdAux > 0
	li:= Li+(_nQtdAux*10)
Else
	li:= Li+_nAux/2
EndIf

//oPrinter:Box(Li,520,Li+30,nMaxCol-10) // CARIMBO
//li+=15

//Impressão dos recursos alternativos
//Inicio
Verilim(oPrinter) //Verifica se cabe na mesma pagina
//se for uma nova adciono mais vinte linhas.
IF li == 75
	li += 20
EndIf
//Por Samuel Miranda
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
li+=05 //10
//Final da Impressão do recurso alternativo
// Inicio Retirado por Samuel Miranda 20190719
/*
oPrinter:Say(li,5,STR0050+IIF(lSH8,DTOC(SH8->H8_DTINI),Space(8))+" "+IIF(lSH8,SH8->H8_HRINI,Space(5))+" "+STR0051+" ______/ ______/______    ____:____")//"INICIO  DESIG: "//" INICIO  REAL :"
li+=25
oPrinter:Say(li,5,STR0052+IIF(lSH8,DTOC(SH8->H8_DTINI),Space(8))+" "+IIF(lSH8,SH8->H8_HRINI,Space(5))+" "+"TERMINO REAL : "+" ______/ ______/______    ____:____")//"TERMINO DESIG: "//" INICIO  REAL :"
li+=15
oPrinter:Say(li,5,STR0054)                                                    //"Quantidade: "
//oPrinter:Say(li,25,Transform(IIF(lSH8,SH8->H8_QUANT,aSC2Sld(_cAliasTop)),PesqPictQt("H8_QUANT",14)))
oPrinter:Say(li,25,Transform(IIF(lSH8,SH8->H8_QUANT,aSC2Sld(_cAliasTop)),"@E 99,999,999,999.99"))
oPrinter:Say(li,140,STR0055)//"Quantidade produzida: "
oPrinter:Say(li,350,STR0056)//"Perdas: "
*/
//Planilha de controle
//Cria Box COMPONENTES (6)
oPrinter:Box(Li-15,001,Li+25,nMaxCol-10) //
oPrinter:Say(li-03,025,"DATA"		,oFontTB)// Data 	   -> 25 Posições
oPrinter:Say(li-03,085,"INICIO"		,oFontTB)// Inicio 	   -> 60 Posições
oPrinter:Say(li-03,145,"FIM"		,oFontTB)// Fim 	   -> 85 Posições
oPrinter:Say(li-03,200,"QTDE"		,oFontTB)// Qtde 	   -> 55 Posições
oPrinter:Say(li-03,265,"PERDA"		,oFontTB)// Perda 	   -> 65 Posições
oPrinter:Say(li-03,340,"OPERADOR"	,oFontTB)// Operador   -> 75 Posições
oPrinter:Say(li-03,470,"OBSERVAÇÃO" ,oFontTB)// Observação -> 130 Posições
//oPrinter:Say(li+15,470, nCalc ,oFontTB)// Observação -> 130 Posições

//Entra no Laço para crias os Box 
for nx := 1 to 5
	oPrinter:Box(Li,001,Li+32,100) // Data 	     -> 25 Posições
	oPrinter:Box(Li,075,Li+32,125) // Inicio 	 -> 60 Posições
	oPrinter:Box(Li,125,Li+32,175) // Fim 	     -> 85 Posições
	oPrinter:Box(Li,175,Li+32,250) // Qtde 	     -> 55 Posições
	oPrinter:Box(Li,250,Li+32,325) // Perda 	 -> 65 Posições
	oPrinter:Box(Li,325,Li+32,400) // Operador   -> 75 Posições
	oPrinter:Box(Li,400,Li+32,nMaxCol-10) // Observação -> 130 Posições
	li+=32 
Next i
oPrinter:Say(li-10,410,"Tempo :"+nCalc,oFontTB)
// Fim Retirado por Samuel Miranda 20190719
// IMPRIMIR PRODUTO BN E FORNECEDOR - INICIO
If !Empty(SG2->G2_XBNPROD)  
	oPrinter:Say(li+008,001,"Produto  BN: "+SG2->G2_XBNPROD,oFontT)
	//Seleciona o Alias
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

li+=10 //30
// Incluido Claudio 07/10/2013 INICIO
_aArea := GetArea()
_cQuery := ""
_cQuery += " SELECT QP8_ENSAIO ENSAIO,QP1_DESCPO DESCRICAO,QP8_LABOR LABOR,QP8_METODO METODO,QP8_TEXTO TEXTO,' ' MINIMO,' ' MAXIMO , '1' ORDEM, QP8.R_E_C_N_O_ REG " +CHR(13)+CHR(10)
_cQuery += " FROM "+RetSqlName("QQK")+" QQK "  +CHR(13)+CHR(10)
_cQuery += " INNER JOIN "+RetSqlName("QP8")+" QP8 ON "  +CHR(13)+CHR(10)
_cQuery += " QP8_FILIAL = '"+xFilial("QP8")+"' " +CHR(13)+CHR(10)
_cQuery += " AND QP8_PRODUT = QQK_PRODUT "  +CHR(13)+CHR(10)
_cQuery += " AND QP8_OPERAC = QQK_OPERAC " +CHR(13)+CHR(10)
_cQuery += " AND QP8_REVI = ("
_cQuery += "     SELECT MAX(QP6_REVI) "
_cQuery += "     FROM "+RetSqlName("QP6")+" QP6 "
_cQuery += "     WHERE QP6_FILIAL = '"+xFilial("QP6")+"' "
_cQuery += "     AND QP6_PRODUT = '"+Alltrim((_cAliasTop)->C2_PRODUTO)+"' "
_cQuery += "     AND QP6_CODREC = '"+Alltrim((_cAliasTop)->C2_ROTEIRO)+"' "
_cQuery += "     AND QP6.D_E_L_E_T_ = ' ') " 
_cQuery += " AND QP8.D_E_L_E_T_ = ' ' "  +CHR(13)+CHR(10)
_cQuery += " INNER JOIN "+RetSqlName("QP1")+" QP1 ON QP1_FILIAL = ' ' AND QP1_ENSAIO = QP8_ENSAIO AND QP1.D_E_L_E_T_ = ' ' " +CHR(13)+CHR(10)
_cQuery += " WHERE QQK_FILIAL = '"+xFilial("QQK")+"' "    +CHR(13)+CHR(10)
_cQuery += " AND QQK_PRODUT = '"+(_cAliasTop)->C2_PRODUTO+"' " +CHR(13)+CHR(10)
_cQuery += " AND QQK_RECURS = '"+SG2->G2_RECURSO+"' " +CHR(13)+CHR(10)
_cQuery += " AND QQK_OPERAC = '"+SG2->G2_OPERAC+"' " +CHR(13)+CHR(10)
_cQuery += " AND QQK_FERRAM = '"+SG2->G2_FERRAM+"' " +CHR(13)+CHR(10)
_cQuery += " AND QQK_REVIPR = QP8_REVI " +CHR(13)+CHR(10)
_cQuery += " AND QQK.D_E_L_E_T_ = ' ' " +CHR(13)+CHR(10)
_cQuery += " UNION ALL " +CHR(13)+CHR(10)
_cQuery += " SELECT DISTINCT QP7_ENSAIO ENSAIO,QP1_DESCPO DESCRICAO,QP7_LABOR LABOR,QP7_METODO METODO,' ' TEXTO,QP7_LIC MINIMO,QP7_LSC MAXIMO,  '2' ORDEM, QP7.R_E_C_N_O_ REG " +CHR(13)+CHR(10)
_cQuery += " FROM "+RetSqlName("QQK")+" QQK "  +CHR(13)+CHR(10)
_cQuery += " INNER JOIN "+RetSqlName("QP7")+" QP7 ON " +CHR(13)+CHR(10)
_cQuery += " QP7_FILIAL =  '"+xFilial("QP7")+"' "  +CHR(13)+CHR(10)
_cQuery += " AND QP7_PRODUT = QQK_PRODUT "  +CHR(13)+CHR(10)
_cQuery += " AND QP7_OPERAC = QQK_OPERAC "  +CHR(13)+CHR(10)
_cQuery += " AND QP7_REVI = ( "
_cQuery += "     SELECT MAX(QP6_REVI) "
_cQuery += "     FROM "+RetSqlName("QP6")+" QP6 "
_cQuery += "     WHERE QP6_FILIAL = '"+xFilial("QP6")+"' "
_cQuery += "     AND QP6_PRODUT = '"+(_cAliasTop)->C2_PRODUTO+"' "
_cQuery += "     AND QP6_CODREC = '"+(_cAliasTop)->C2_ROTEIRO+"' "
_cQuery += "     AND QP6.D_E_L_E_T_ = ' ') "
_cQuery += " AND QP7.D_E_L_E_T_ = ' ' "  +CHR(13)+CHR(10)
_cQuery += " INNER JOIN "+RetSqlName("QP1")+" QP1 ON QP1_FILIAL = ' ' AND QP1_ENSAIO = QP7_ENSAIO AND QP1.D_E_L_E_T_ = ' ' " +CHR(13)+CHR(10)
_cQuery += " WHERE QQK_FILIAL = '"+xFilial("QQK")+"' " +CHR(13)+CHR(10)
_cQuery += " AND QQK_PRODUT = '"+(_cAliasTop)->C2_PRODUTO+"' " +CHR(13)+CHR(10)
_cQuery += " AND QQK_RECURS = '"+SG2->G2_RECURSO+"' " +CHR(13)+CHR(10)
_cQuery += " AND QQK_OPERAC = '"+SG2->G2_OPERAC+"' " +CHR(13)+CHR(10)
_cQuery += " AND QQK_FERRAM = '"+SG2->G2_FERRAM+"' " +CHR(13)+CHR(10)
_cQuery += " AND QQK_REVIPR = QP7_REVI " +CHR(13)+CHR(10)
_cQuery += " AND QQK.D_E_L_E_T_ = ' ' " +CHR(13)+CHR(10)
_cQUery += " ORDER BY ORDEM, REG " 
//Grava o resultado da Query
MemoWrit("XMATR820.SQL",_cQuery)
//Execulta a query no banco
_cQuery := ChangeQuery( _cQuery)

If Select("QRY") > 0
	DbSelectArea("QRY")
	DbCloseArea()
Endif
//Selecina o Alias (resuktado da Query sql)
TcQuery _cQuery New Alias ("QRY")

_lFirst 	:= .T.
_lTemInsp	:= .F.

dbSelectArea("QRY")

//Pirolo - Melhoria solicitada em 23/05/2019 - Imprimir a o quadro de inspeções x vezes conforme amarração na tabela QA6
// - Se for TIPO PA, imprime uma unica vez
nQtdInsp := Iif(Posicione("SB1",1,xFilial("SB1")+(_cAliasTop)->C2_PRODUTO, "B1_TIPO") == "PA", 1, (_cAliasTop)->C2_QUANT)

//Verifica se o produto é PA
If nQtdInsp > 1
	DbSelectArea("QA6")
	QA6->(DbSetOrder(2))//QA6_FILIAL+QA6_PLANO
	//Verifica se é uma amostra
	If QA6->(DbSeek(xFilial("QA6")+"INTERN"))
		While QA6->(!Eof() .AND. QA6_FILIAL+QA6_PLANO==xFilial("QA6")+"INTERN")
			If QA6->(nQtdInsp >= QA6_LOTINF .AND. nQtdInsp <= QA6_LOTSUP)
				nQtdInsp := Val(QA6->QA6_CODAMO)
				Exit
			EndIf 
			//Passa pro proxímo registro
			QA6->(DbSkip())
		EndDo
	EndIf
EndIf

//Imprime os quadros de inspeção conforme range.
For nI := 1 to nQtdInsp
	QRY->(dbGotop())
	While QRY->(!Eof())
		
		_lTemInsp	:= .T.
		
		If li > nMaxLin-60
			li:= 0
			oPrinter:EndPage()
			nPagina++
			oPrinter:StartPage()
			CabeInsp(oPrinter)
			_lFirst := .f.
			oPrinter:Box(Li,001,Li+10,035) 		 // Ensaio - 035 Pos
			oPrinter:Box(Li,035,Li+10,185) 		 // Descricao  - 150 Pos
			oPrinter:Box(Li,185,Li+10,220) 		 // Laboratrio - 035 Pos
			oPrinter:Box(Li,220,Li+10,550) 		 // Especificacao - 330 Pos
			oPrinter:Box(Li,550,Li+10,nMaxCol-10)// Resultado - 040 Pos
			
			oPrinter:Say(li+006,002,"ENSAIO" 		, oFontTB)// Ensaio - 035 Pos
			oPrinter:Say(li+006,037,"DESCRICAO" 	, oFontTB)// Descricao  - 150 Pos
			oPrinter:Say(li+006,187,"LABOR" 		, oFontTB)// Laboratrio - 035 Pos
			oPrinter:Say(li+006,250,"ESPECIFICACAO"	, oFontTB)// Especificacao - 330 Pos
			oPrinter:Say(li+006,552,"RESULTADO" 	, oFontTB)// Resultado - 040 Pos
			Li+=10
		EndIf
		
		If _lFirst
			CabeInsp(oPrinter)
			_lFirst := .f.
			oPrinter:Box(Li,001,Li+10,035) 		 // Ensaio - 040 Pos
			oPrinter:Box(Li,035,Li+10,185) 		 // Descricao  - 150 Pos
			oPrinter:Box(Li,185,Li+10,220) 		 // Laboratrio - 035 Pos
			oPrinter:Box(Li,220,Li+10,550) 		 // Especificacao - 330 Pos
			oPrinter:Box(Li,550,Li+10,nMaxCol-10)// Resultado - 040 Pos
			
			oPrinter:Say(li+006,002,"ENSAIO" 		, oFontTB)// Ensaio - 040 Pos
			oPrinter:Say(li+006,037,"DESCRICAO" 	, oFontTB)// Descricao  - 150 Pos
			oPrinter:Say(li+006,187,"LABOR" 		, oFontTB)// Laboratrio - 035 Pos
			oPrinter:Say(li+006,250,"ESPECIFICACAO"	, oFontTB)// Especificacao - 330 Pos
			oPrinter:Say(li+006,552,"RESULTADO" 	, oFontTB)// Resultado - 040 Pos
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
		//oPrinter:Say(Li+10,222,AllTrim(QRY->METODO)+IIF(!Empty(QRY->TEXTO),Left(QRY->TEXTO,40)+"  _____________",Padr("Min: "+AllTrim(QRY->MINIMO)+" - Max: "+AllTrim(QRY->MAXIMO),40)+ " Min: _________   Max:_________"), oFontT)
			oPrinter:Say(Li+10,222,AllTrim(QRY->METODO)+IIF(!Empty(QRY->TEXTO),Left(QRY->TEXTO,40)+"  _____________",Padr("Min: "+AllTrim(QRY->MINIMO)+" - Max: "+AllTrim(QRY->MAXIMO),40)), oFontT)
		Li+=20
		//Passa pro proxímo registro
		QRY->(dbSkip())
	EndDo
	//  Alterado por Samuel Miranda Solicitado Pelo Wyverson (10/12/2024) Visto do Inspetor
	If _lTemInsp
		li+=15
		oPrinter:Say(Li,00 , "Liberado Por:_________________________________ Instrumento(s):_________________________________________ Data:______________")
		Li+=10
	EndIf
Next nI

dbCloseArea()
RestArea(_aArea)
// Incluido Claudio 07/10/2013 FINAL
//oPrinter:Say(2000,00,"* Tempo Unitario"+cValtoChar(SG2->G2_TEMPAD))
Return
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
IF li > (nMaxLin-40)		//60				// Li > 55
	li := 15
	oPrinter:EndPage()
	nPagina++
	oPrinter:StartPage()
	Li+=10
	cRotOper(oPrinter)			// Imprime cabecalho roteiro de operacoes
Endif
Return Li


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
Static Function CabeInsp(oPrinter)
Local cCabec2 := "INSPECAO - Produto: "+aArray[1][1]+" Operacao: "+SG2->G2_OPERAC+" Recurso: "+SG2->G2_RECURSO
oPrinter:SayAlign(Li,001,cCabec2,oFont14N,nMaxCol-10,200,,0)
li+=20
Return(li)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ xNumSZ6  ³ Autor ³ Dema Informatica      ³ Data ³ 28/11/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Retorna a QTde de Produtos gravados na Tabela SZ6          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR797                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function xNumSZ6(cProduto, cRot, cOper, xaArray)
Local _nRet 	:= 0
Local _aArea 	:= GetArea()

dbSelectArea("SZ6")
dbSetOrder(1)
If cOper == Nil
	dbSeek(xFilial("SZ6")+cProduto)
	While !Eof() .And. SZ6->(Z6_FILIAL+Z6_PRODUTO) == xFilial("SZ6")+cProduto
		_nRet++
		dbSkip()
	EndDo
ElseIf cOper <> Nil .And. cRot <> Nil
	dbSeek(xFilial("SZ6")+cProduto+cRot+cOper)
	While !Eof() .And. SZ6->(Z6_FILIAL+Z6_PRODUTO+Z6_ROTEIRO+Z6_OPERAC) == xFilial("SZ6")+cProduto+cRot+cOper
		If aScan(xaArray, {|x| AllTrim(x[1]) == AllTrim(SZ6->Z6_COMP)} ) <> 0
			_nRet++
		EndIf
		dbSkip()
	EndDo
Else
EndIf
RestArea(_aArea)
Return(_nRet)

/*/{Protheus.doc} PegaTotImp
//TODO Incrementa e retorna o numero de vezes que ocorreram impressões para esta OP.
@author Pirolo
@since 02/05/2019
@version undefined
@param cC2_NUM, characters, descricao
@param cC2_ITEM, characters, descricao
@param cC2_SEQUEN, characters, descricao
@param cC2_ITEMGRD, characters, descricao
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function PegaTotImp(cC2_NUM, cC2_ITEM, cC2_SEQUEN, cC2_ITEMGRD)
Local nRet 		:= 0
Local aAreaSC2	:= SC2->(GetArea())
Local cUltOP 	:= ""

DbSelectArea("SC2")
SC2->(DbSetOrder(1))//C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD

If SC2->(DbSeek(xFilial("SC2")+cC2_NUM+cC2_ITEM+cC2_SEQUEN+cC2_ITEMGRD))
	If cC2_NUM+cC2_ITEM+cC2_SEQUEN+cC2_ITEMGRD <> cUltOP
		lContImp 	:= .F.
		cUltOP		:= cC2_NUM+cC2_ITEM+cC2_SEQUEN+cC2_ITEMGRD
	EndIf
	
	nRet := SC2->C2_XQTDPRT+Iif(lContImp, 0, 1)
	
	If !lContImp
		RecLock("SC2", .F.)
			SC2->C2_XQTDPRT := nRet
		SC2->(MsUnlock())
		lContImp := .T.
	EndIf
EndIf

RestArea(aAreaSC2)
Return nRet

//Samuel Miranda
Static Function TPTIME01(ndados,nQuants)
	//Variaveis
	Local aDados    := Separa(cvaltochar(Str(ndados,6,2)), ".", .F.)//
	Local nHoras 	:= Val(Alltrim(aDados[1]))  * nQuants //Multiplica a horas X Quantidade
	Local nMinutos 	:= Val(Alltrim(aDados[2]))  * nQuants //Multiplica os Minutos X Quantidade
	Local nSepTemp  := Separa(Transform( Min2Hrs( nMinutos ),"@r 999.99"), ".", .F.)
	Local nTHoras   := 0
	Local nTMinutos	:= 0
		nTHoras         := nHoras 
		nTHoras         += Val(nSepTemp[1])
		nTMinutos 		:= Val(nSepTemp[2])
		
	vRetorno := StrZero(nTHoras,2) + ":" +StrZero(nTMinutos,2) 
Return vRetorno


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
"MV_CH1","C",13,0,0,"G","","SC2","","","mv_par01",,,,,,,,"","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Nr OP final a ser considerado na','filtragem do cadastro de OPs (SC2)'}
aHelpEng := {'Nr OP final a ser considerado na','filtragem do cadastro de OPs (SC2)'}
aHelpSpa := {'Nr OP final a ser considerado na','filtragem do cadastro de OPs (SC2)'}

PutSx1("MTR797","02","Ate a O.P.","¿A O. P. ?","To Production Order ?",;
"MV_CH2","C",13,0,0,"G","","SC2","","","mv_par02",,,,,,,,"","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}
aHelpEng := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}
aHelpSpa := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}

PutSx1("MTR797","03","Da data","¿A Fecha ?","From Date ?",;
"MV_CH3","D",8,0,0,"G","","","","","mv_par03",,,,,,,,"","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}
aHelpEng := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}
aHelpSpa := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}

PutSx1("MTR797","04","Ate a data","¿A Fecha ?","To Date ?",;
"MV_CH4","D",8,0,0,"G","","","","","mv_par04",,,,,,,,"","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Lista o roteiro de operações juntamente','com as OPs?'}
aHelpEng := {'Lista o roteiro de operações juntamente','com as OPs?'}
aHelpSpa := {'Lista o roteiro de operações juntamente','com as OPs?'}

PutSx1("MTR797","05","Roteiro de Operacoes","¿Proced.Operaciones ?","Operation Sequence ?",;
"MV_CH5","N",1,0,1,"C","","","","","mv_par05","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Considera a impressao do código de','barras do número da ordem de produção.'}
aHelpEng := {'Considera a impressao do código de','barras do número da ordem de produção.'}
aHelpSpa := {'Considera a impressao do código de','barras do número da ordem de produção.'}

PutSx1("MTR797","06","Imprime Cod. Barras","¿Imprime Cod.Barras ?","Print Barcode ?",;
"MV_CH6","N",1,0,2,"C","","","","","mv_par06","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Considera a descrição do produto por','descrição cientifica ou generica ou o','que foi cadastrado no pedido de venda.'}
aHelpEng := {'Considera a descrição do produto por','descrição cientifica ou generica ou o','que foi cadastrado no pedido de venda.'}
aHelpSpa := {'Considera a descrição do produto por','descrição cientifica ou generica ou o','que foi cadastrado no pedido de venda.'}

PutSx1("MTR797","07","Descricao Produto","¿Descripcion Producto ?","Product Description ?",;
"MV_CH7","N",1,0,3,"C","","","","","mv_par07","Descr.Cient.","Descr.Cient.","Scient.Descr.",,"Descr.Generica","Descr.Generica","General Descr.","Pedido Venda","Pedido Venda","Pedido Venda","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Imprime as Ordens de Producao','Encerradas.'}
aHelpEng := {'Imprime as Ordens de Producao','Encerradas.'}
aHelpSpa := {'Imprime as Ordens de Producao','Encerradas.'}

PutSx1("MTR797","08","Impr. Op Encerrada","¿Imprime OP Cerrada ?","Print Finished Prod. Order ?",;
"MV_CH8","N",1,0,1,"C","","","","","mv_par08","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Define se o relatorio sera impresso por ','ordem de Produto ou de Sequencia na','Estrutura.'}
aHelpEng := {'Define se o relatorio sera impresso por ','ordem de Produto ou de Sequencia na','Estrutura.'}
aHelpSpa := {'Define se o relatorio sera impresso por ','ordem de Produto ou de Sequencia na','Estrutura.'}

PutSx1("MTR797","09","Impr. Por Ordem de","¿Impr. por Orden de ?","Print by ?",;
"MV_CH9","N",1,0,1,"C","","","","","mv_par09","Codigo","Codigo","Code",,"Sequencia"," Secuencia","Sequence","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Considera as OPs firmes, previstas ou','ambas do cadastro de OPs (SC2).'}
aHelpEng := {'Considera as OPs firmes, previstas ou','ambas do cadastro de OPs (SC2).'}
aHelpSpa := {'Considera as OPs firmes, previstas ou','ambas do cadastro de OPs (SC2).'}

PutSx1("MTR797","10","Considera Ops","¿Considera OPs ?","Consid.Prod.Orders ?",;
"MV_CHA","N",1,0,1,"C","","","","","mv_par10","Firmes","Firmes","Confirmed",,"Previstas","Previstas","Estimated","Ambas","Ambas","Both","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Indica se imprime ou não itens negativos','empenhados.','O parametro MV_NEGESTR tambem sera','avaliado.'}
aHelpEng := {'Indica se imprime ou não itens negativos','empenhados.','O parametro MV_NEGESTR tambem sera','avaliado.'}
aHelpSpa := {'Indica se imprime ou não itens negativos','empenhados.','O parametro MV_NEGESTR tambem sera','avaliado.'}

PutSx1("MTR797","11","Item Neg. na Estrut","¿Item Neg. en la Estruct. ?","Neg. Item in Structure ?",;
"MV_CHB","N",1,0,2,"C","","","","","mv_par11","Imprime","Imprime","Print",,"Nao Imprime","No Imprime","Do not print","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Opção para a impressao do produto com','rastreabilidade por Lote ou Sub-Lote.'}
aHelpEng := {'Opção para a impressao do produto com','rastreabilidade por Lote ou Sub-Lote.'}
aHelpSpa := {'Opção para a impressao do produto com','rastreabilidade por Lote ou Sub-Lote.'}

PutSx1("MTR797","12","Imprime Lote/S.Lote","¿Imprime Lote/S.Lote ?","Print Lot/S.Lot ?",;
"MV_CHC","N",1,0,2,"C","","","","","mv_par12","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {'Opção para a impressao da Ordem do   ','Relatorio.'}
aHelpEng := {'Opção para a impressao da Ordem do   ','Relatorio.'}
aHelpSpa := {'Opção para a impressao da Ordem do   ','Relatorio.'}

PutSx1("MTR797","13","Imprime Ordem Inversa?","¿Imprime Ordem Inversa ?","Print Inverse Ord ?",;
"MV_CHD","N",1,0,2,"C","","","","","mv_par13","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
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

