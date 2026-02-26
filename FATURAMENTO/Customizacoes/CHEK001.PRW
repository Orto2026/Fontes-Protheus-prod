#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"        
#INCLUDE "TOPCONN.CH"  
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"   
#INCLUDE "fileio.ch"
#DEFINE CRLF chr(13) + chr(10)        
#DEFINE DMPAPER_LETTER 1 	// Letter 8 1/2 x 11 in
#DEFINE DMPAPER_A4 9 		// A4 210 x 297 mm


//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºRotina    | CHEK001  | Samuel Miranda              | Data | 11/01/2024 º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±± Descricao | Impressão dos itens faturados para separação    			º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºUso       | Especifico Ortosintese                                     º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
          
User Function CHEK001()    
//Local titulo	:= "Cchek Liste de Espedição"
Private cPerg		:= "CHEKLIST"
Private nItPg		:= 43  //Número de linhas x2 16
Private lPreVale	:= .f.
Private lValido		:= .t.

ValidPerg() 
                                                '
                                                
If !Pergunte(cPerg,.T.)
	Return()
Endif
//Pergunte(cPerg,.T.)

//Processa({|| MontaCom()})
//RptStatus({|| MontaCom() },Titulo)
FwMsgRun(NIL, {|| MontRelat()}, "Processando", "Coletando os dados...")

Return Nil     

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºRotina    | MONTRELAT  | Samuel Miranda            | Data | 11/01/2024 º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±± Descricao | Monta o Relatorio com os itens a ser impresso   			º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºUso       | Especifico Ortosintese                                     º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//         
Static Function MontRelat()
Local cQuery	   := ""
Local nRec		   := 0
Local aPrtLi	   := {}
Local aPrtIt	   := {}
Local aCabec	   := {}
Local Folha 	   := 0
Local Folhas 	   := 0
Local i			   := 0
Local j			   := 0
Local k			   := 0
Local cDescProd	   := ""
Local cNameRel     := Alltrim(MV_PAR01)
lOCAL _dData       := Date()
Private oPrint
 Private cCodUser := RetCodUsr() //Retorna o Codigo do Usuario 
Private cNamUser := UsrRetName(cCodUser) //Retorna o nome do Usuario 
Private _xArquivo := ("\LOGS_PROGRAMAS\CHEKLIST_"+StrTran(AllTrim(Dtoc(_dData)),"/","") +".txt")//Nome do Arquivo de Log

lAdjustToLegacy := .F.
lDisableSetup  := .T.

//Função para a impressão do relatorio.
oPrint := FwMsPrinter():New(cNameRel, IMP_PDF, .T.,,.T.,,,)
//FWMsPrinter(): New ( < cFilePrintert >, [ nDevice], [ lAdjustToLegacy], [ cPathInServer], [ lDisabeSetup ], [ lTReport], [ @oPrintSetup], [ cPrinter], [ lServer], [ lPDFAsPNG], [ lRaw], [ lViewPDF], [ nQtdCopy] ) --> oPrinter
			//					1				2				3					4				5				6				7			 8		    9		      10		  11		 12		 13		
oPrint:SetPortrait()
oPrint:SetPaperSize(DMPAPER_A4) 
    //±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
    //Query para selecionar o Número do Pedido
    cQuery := "SELECT " +CRLF
    cQuery += "SF2.F2_DOC AS NUMNF,"+CRLF
    cQuery += "SF2.F2_SERIE AS SERIENF,"+CRLF
    cQuery += "SF2.F2_CLIENTE AS CODCLI,"+CRLF
    cQuery += "CONVERT(VARCHAR, CONVERT(DATE, F2_EMISSAO ), 103) AS DATAEMISAO,"+CRLF
    cQuery += "SD2.D2_COD AS CODPROD,"+CRLF
    cQuery += "SD2.D2_QUANT AS QTDEPRO,"+CRLF
    cQuery += "SD2.D2_LOTECTL LOTEPRO,"+CRLF
    cQuery += "SD2.D2_LOCAL AS ARMAZEM,"+CRLF
    cQuery += "SD2.D2_LOCALIZ AS ENDERECO,"+CRLF
    cQuery += "SD2.D2_PEDIDO AS PEDNF,"+CRLF
    cQuery += "SA1.A1_NOME AS NOMECLI"+CRLF
    //FROM SF2010 SF2 
    cQuery += "FROM "+CRLF
	cQuery += RetSqlName("SF2")+" SF2 "+CRLF
    cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 "+"ON SA1.A1_COD =  SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA AND SA1.D_E_L_E_T_='' "+CRLF
    cQuery += "INNER JOIN "+RetSqlName("SD2")+" SD2 "+"ON SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_LOJA = SF2.F2_LOJA AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D_E_L_E_T_='' "+CRLF
    cQuery += "WHERE "+CRLF
    cQuery += "F2_DOC='"+Alltrim(MV_PAR01)+"' "+CRLF
    cQuery += "AND SF2.D_E_L_E_T_=''  "+CRLF
    //Grava o resultado da query
    MemoWrite("CHECKLIST.SQL", cQuery)
		
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), "QUERY", .T., .T. )
    
    nRec	:= 0
	dbSelectArea( "QUERY" )
	dbGotop()
	QUERY->(dbEval({ || nRec++ },,{||!Eof()} ))
	dbGoTop()
	
	If nRec == 0
		dbSelectArea("QUERY")
		dbCloseArea()
		Alert("Dados não encontrados." ,"Verifique !")
        Return()
	EndIf
    //±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
    //Carrega as variaveis com o resultado da query
    While !QUERY->(Eof())
        If Len(aCabec)==0
            cCliente     := QUERY->CODCLI +" - " + QUERY-> NOMECLI
            cNotaFiscal  := QUERY->NUMNF
            cSerie       := QUERY->SERIENF
            cDataEmissao := QUERY->DATAEMISAO
            cPedidoNF    := QUERY->PEDNF
            //Adiciona os dados ao arrat do cabeçalho
            aCabec :={	cCliente,;	   // aCabec[01] - Nome do Cliente             
	       		 		cNotaFiscal,;  // aCabec[02] - Nota Fiscal
	       		 		cSerie,;	   // aCabec[03] - Serie
	       		 		cDataEmissao,; // aCabec[04] - Data Da Emissão
	       		 		cPedidoNF}     // aCabec[05] - Numero do pedido na NF
            //Inicializa a variavel
            aItens := {}
        EndIf
     //±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
        cDescProd := SubStr(Posicione('SB1',1,xFilial("SB1")+CODPROD,"B1_DESC"),1,45) //Substr(C7_DESCRI,1,45)
        aadd(aItens,{ CODPROD,;	 //aItens[01]- Codigo do Produto
                    cDescProd,;  //aItens[02]- Descrição do Produto
                      LOTEPRO,;	 //aItens[03]- Lote 
                      QTDEPRO,;	 //aItens[04]- Quantidade
                      ARMAZEM,;	 //aItens[05]- Armazém
                      ENDERECO })//aItens[05]- Endereço
        QUERY->(DbSkip())
    EndDo
     //±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
    While Mod(len(aItens),nItPg) > 0

		  	aadd( aItens,{	" ",;	//aItens[01]- Codigo do Produto
		  					" ",;   //aItens[02]- Descrição do Produto
                            " ",;	//aItens[03]- Lote 
		  					" ",;	//aItens[04]- Quantidade
		  					" ",;	//aItens[05]- Armazém
		  					" "} )  //aItens[05]- Endereço
		  						 
	EndDo
    //Faz a conferencias do numero de paginas
    Folhas 	:= Int( len(aItens) / nItPg )
    Folha 	:= 1
    //Incrementa a  aPrtIt com os itens do relatorio
    For i := 1 to len(aItens) Step nItPg
        //Inicializa a variavel
        aPrtLi	:= {}
            
        For j := 0 to nItPg - 1
            //Inicializa a variavel   
            aPrtIt	:= {}         
            For k := 1 to len(aItens[i+j])      
                aadd(aPrtIt,aItens[i+j,k])
            Next k    
            aadd(aPrtLi,aPrtIt)  
        Next j
        //Starta a impressão
        oPrint:StartPage()							// Inicia uma nova página
            ImpRel(aCabec,aPrtLi,Folha++,Folhas)	
        oPrint:EndPage()							// Finaliza a página
    Next i 
    //Inicializa a variavél do cabeçalho
    aCabec	:= {}
    //Fecha o Alias
    dbSelectArea("QUERY")
    dbCloseArea()
//Função desabilitada via parametro na função FWSPrinter	
oPrint:Preview()   // Visualiza antes de imprimir

    //±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
    //±±anda 16/02/2024  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
    //Cria um arquivo txt com a relação dos e-mails eviandos e a data           º±±//
    //±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
    //Verifica se o arquivo existe,se não ele cria
    If !File(_xArquivo)
        nHandle := FCREATE(_xArquivo)// Cria o arquivo
        fclose(nHandle) // Fecha o arquivo para gravação
    EndIf
    nHandle := fopen(_xArquivo , FO_READWRITE + FO_SHARED )// Abre o arquivo
    FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
    FWrite(nHandle,Dtoc(_dData) + " - "+ UPPER(cNamUser)+"- NOTA FISCAL - "+MV_PAR01 +CRLF ) // Insere texto no arquivo
    fclose(nHandle) // Fecha o arquivo
Return()


//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºRotina    | IMPREL  | Samuel Miranda               | Data | 11/01/2024 º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±± Descricao | Impressão do relatorio                           			º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºUso       | Especifico Ortosintese                                     º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±// 
Static Function ImpRel(aCabec,aPrtLi,Folha,Folhas)

Local nLinha := 0
Local nLinItem := 0
//Formata a data DD/MM/YYYY
Local  dDateFormart := Substr(DTOS(Date()),7,2)+"/"+Substr(DTOS(Date()),5,2)+"/"+Substr(DTOS(Date()),1,4)
//Imprimi a quantidade de paginas
Local nFolha		:= Alltrim(Str(Folha))+"/"+Alltrim(Str(Folhas))
//Carrega a variavel com o Logotipo.
ABmp := "LGMID01.png"

//Fontes        
Private oFont01        := TFont():New( "Times New Roman",,18,,.T.,,,,.F.,.F.) //Times New Roman 18 - Negrito
Private oFont02        := TFont():New( "Times New Roman",,16,,.T.,,,,.F.,.F.) //Times New Roman 11 - Negrito
Private oFont03        := TFont():New( "Times New Roman",,14,,.F.,,,,.F.,.F.) //Times New Roman 12 - Normal
Private oFont03N       := TFont():New( "Times New Roman",,14,,.T.,,,,.F.,.F.) //Times New Roman 12 - Negrito
Private oFont04        := TFont():New( "Times New Roman",,12,,.F.,,,,.F.,.F.) //Times New Roman 12 - Normal
Private oFont05        := TFont():New( "Times New Roman",,10,,.F.,,,,.F.,.F.) //Times New Roman 09 - Normal
Private oFont06        := TFont():New( "Times New Roman",,10,,.T.,,,,.F.,.F.) //Times New Roman 09 - Normal
Private oFont07        := TFont():New( "Times New Roman",,08,,.F.,,,,.F.,.F.) //Times New Roman 09 - Normal
Private oFont08        := TFont():New( "Times New Roman",,08,,.T.,,,,.F.,.F.) //Times New Roman 09 - Normal
Private oFont13A	   := TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont13An	   := TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.) //Arial 11 - Negrito

//Função de cores
oBrush  := TBrush():New(, RGB(173,216,230)) //
oBrush0 := TBrush():New(, RGB(176,224,230)) //240,255,255 //176,224,230 //211,211,211
oBrush1 := TBrush():New(, RGB(0,0,0))

// ----------------------------------  Contorno do documento
oPrint:box(0015,0015,2680,2355)//2470) //Box Moldura 
oPrint:Line(0015,0400,0200,0400)// Linha vertical do Logo	

// ----------------------------------  Logotipo
If File(aBmp)
  oPrint:SayBitmap( 0020,0050,ABmp,0300,0140)
EndIf  
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
oPrint:Say(0120,0800,"CHECK LIST DE EXPEDIÇÃO",oFont01)
oPrint:Line(0015,1900,0200,1900)// Linha Vestical
oPrint:Say(0100,1910,"Emissão.:",oFont03N)          ; oPrint:Say(0100,2110,dDateFormart,oFont03)//- Data de Emissão do Cheklist	
oPrint:Say(0150,1910,"Página.:",oFont03N)           ; oPrint:Say(0150,2110,nFolha,oFont03)	//- Quantidade de Paginas
oPrint:line(0200,0020,0200,2355)//Linha Horizontal	
oPrint:Say(0250,0030,"NOME DO CLIENTE:",oFont03N)   ;oPrint:Say(0250,0400,aCabec[1],oFont03)//- Codigo e nome do Cliente
oPrint:Say(0300,0030,"NOTA FISCAL:",oFont03N)       ;oPrint:Say(0300,0300,aCabec[2],oFont03)//- Número da Nota Fiscal
oPrint:Say(0300,0600,"SÉRIE:",oFont03N)             ;oPrint:Say(0300,0740,aCabec[3],oFont03)//- Serie
oPrint:Say(0300,1250,"EMISSÃO DA NF:",oFont03N )    ;oPrint:Say(0300,1550,aCabec[4],oFont03)//- Data da Emissão da Nota
oPrint:Say(0350,0030,"PEDIDOS DA NF:",oFont03N)     ;oPrint:Say(0350,0310,aCabec[5],oFont03)//- Pedidos da Nota Fiscal
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
oPrint:line(0365,0020,0365,2355)//Linha Horizontal
oPrint:FillRect({0370,0020,0405,2350},oBrush)  //Imprime uma tarja 
oPrint:Say(0395,0950,"ITENS DA NOTA FISCAL",oFont03N)
oPrint:line(0410,0020,0410,2355)//Linha Horizontal
oPrint:Say(0450,0030,"PRODUTO",oFont03N)
oPrint:Line(0410,0350,0460,0350)// Linha vertical
oPrint:Say(0450,0400,"DESCRIÇÃO DO PRODUTO",oFont03N ) //

oPrint:Line(0410,1250,0460,1250)// Linha vertical
oPrint:Say(0450,1300,"LOTE",oFont03N )

oPrint:Line(0410,1480,0460,1480)// Linha vertical
oPrint:Say(0450,1600,"QTD",oFont03N ) //Primeira unidade

oPrint:Line(0410,1700,0460,1700)// Linha vertical
oPrint:Say(0450,1720,"AMZ",oFont03N ) 	

oPrint:Line(0410,1830,0460,1830)// Linha vertical
oPrint:Say(0450,1880,"ENDEREÇO",oFont03N )//segunda unidadea

oPrint:Line(0410,2100,0460,2100)// Linha vertical  
oPrint:Say(0450,2150,"VISTO",oFont03N )  

//oPrint:line(040,0020,0800,2355)// Linha Horizontal  
oPrint:line(0460,0020,0460,2355)//Linha Horizontal
nLinha :=450
For nLinItem := 1 to len(aPrtLi)  
    //Valor inicial da 
	nLinha	+= 50
    //Verifica a li
    If !Empty(aPrtLi[nLinItem,1])
        If nLinItem % 2 == 0
            oPrint:FillRect({nLinha-35,0020,nLinha+15,2350},oBrush0)  //Imprime uma tarja 
        EndIf
        oPrint:Say(nLinha,0030,aPrtLi[nLinItem,1], oFont04 )
        oPrint:Say(nLinha,0350,aPrtLi[nLinItem,2], oFont03 )	//aItens[02]- Descrição do Produto
        oPrint:Say(nLinha,1280,aPrtLi[nLinItem,3], oFont03 )	//aItens[03]- Lote 
        oPrint:Say(nLinha,1580,cValtoChar(aPrtLi[nLinItem,4]), oFont03 )	//aItens[04]- Quantidade
        oPrint:Say(nLinha,1735,aPrtLi[nLinItem,5], oFont03 )
        oPrint:Say(nLinha,1840,aPrtLi[nLinItem,6], oFont04 )	//aItens[05]- Armazém   
    EndIf
        //oPrint:Line(nLinha-70,0350,0795,0350)// Linha vertical descrição
        //oPrint:Line(nLinha-70,1250,0795,1250)// Linha vertical - 
        //oPrint:Line(nLinha-70,1480,0795,1480)// Linha vertical - 
        //oPrint:Line(nLinha-70,1700,0795,1700)// Linha vertical - 
        //oPrint:Line(nLinha-70,1830,0795,1830)// Linha vertical - 
        //oPrint:Line(nLinha-70,2100,0795,2100)// Linha vertical - 
Next nLinItem
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
oPrint:box(2800,0020,2800,0500) //
oPrint:Say(2825,0150,"Liberado Por :",oFont13An )	

oPrint:box(2800,0750,2800,1330) //
oPrint:Say(2825,0900,"Conferido Por :",oFont13An )	
//oPrint:box(2660,1550,2660,2250) //

oPrint:box(2900,0020,2970,2355) //	
oPrint:Say(2950,0050,"Revisão.: ",oFont04) ;oPrint:Say(2950,0150,"001 - 01032024",oFont05)

oPrint:Say(3030,2145,"By TI Ortosintese ",oFont13An )

Return    


//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºRotina    | ValidPerg  | Samuel Miranda            | Data | 11/01/2024 º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±± Descricao | Cria os perguntes caso ele não exitir                   	º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºUso       | Especifico Ortosintese                                     º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±// 

Static Function ValidPerg()
//Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i := 0
Local j := 0
Local nTamSX1	:= Len(SX1->X1_GRUPO)
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 			:= PADR("CKEKLIST",nTamSX1)
Aadd(aRegs,{cPerg,"01","Número da Nota Fiscal !"	,"Número da Nota Fiscal"		,"Número da Nota Fiscal!"		,"mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SF2","","","",""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()            
	Endif
Next i

Return()
