#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#DEFINE DMPAPER_LETTER 1 	// Letter 8 1/2 x 11 in
#DEFINE DMPAPER_A4 9 		// A4 210 x 297 mm

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Programa  ³ RCOMR01  ³ Autor.³  Samuel Miranda       ³ Data ³ 06/05/21 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³ Emissao do Pedido de Compras                               ³±±          
±±³          ³ 												              ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Uso       ³ Ortosintese                                                ³±±     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±    
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/   

User Function RCOMR01()
	//Variaveis
	Private cPerg         := "COM "
	Private nItPg         := 12 //Número de linhas x2 16
	Private _nTotGeral    := 0 //Samuel Miranda-06/05/21
	Private _nIpiGeral    := 0 //Samuel Miranda-06/05/21
	Private _nFreteGeral  := 0 //Samuel Miranda-06/05/21
	Private _nDestoTotal  := 0 //Samuel Miranda-06/05/21
	Private _nTotalDespsa := 0 //Samuel Miranda-06/05/21
	//Chama o Pergunta
	CriaSX1(cPerg)
	//Faz a validação do Pergunta
	Pergunte(cPerg,.T.)
	//Processa o relatório
	Processa({|| MontaCom()})

Return Nil

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Programa  | MONTACOM  | Autor.³  Samuel Miranda      ³ Data ³ 06/05/21 |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Descrição | Query e arrys do relatório 						          |±±          
±±|          | 												              |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Uso       | Ortosintese                                                |±±     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±    
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/   

Static Function MontaCom()
	Local cQuery		:= ""
	Local cQueryOrd		:= ""
	Local nRec			:= 0
	Local aPrtLi		:= {}
	Local aPrtIt		:= {}
	Local aCabec		:= {}
	Local Folha 		:= 0
	Local Folhas 		:= 0
	Local i				:= 0
	Local j				:= 0
	Local k				:= 0
	Local _nItem        := 1
	//Array para ser alimento com os número das colictaçoes de compra //Por Samuel Miranda 18/07/2022
	Private  _cNumSC    :={}
	Private  oPrint
	//Private nMaxCol		:= 600
	//Query para selecionar o Pedido
	cQuery		:= "SELECT "+CHR(13)+CHR(10)
	cQuery		+= 		"DISTINCT(SC7.C7_NUM) REG "+CHR(13)+CHR(10)
	cQuery		+= "FROM  "+CHR(13)+CHR(10)
	cQuery		+= 		RetSqlName("SC7")+" SC7 "+CHR(13)+CHR(10)
	cQuery		+= "WHERE  "+CHR(13)+CHR(10)
	cQuery		+= 		"SC7.D_E_L_E_T_ = ' ' AND "+CHR(13)+CHR(10)
	cQuery		+= 		"SC7.C7_FILIAL = '"+cFilAnt+"' AND "+CHR(13)+CHR(10)
	cQuery		+= 		"SC7.C7_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "+CHR(13)+CHR(10)
	cQuery		+= 		"SC7.C7_FORNECE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "+CHR(13)+CHR(10)
	cQuery		+= 		"SC7.C7_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "+CHR(13)+CHR(10)
	cQueryOrd	+= "ORDER BY "+CHR(13)+CHR(10)
	cQueryOrd	+= 	"1 "+CHR(13)+CHR(10)
	//Salva o resultado da Query
	MemoWrite("COMS.SQL", cQuery + cQueryOrd)
	//Verifica se o Alias estar vazio
	If Select("COMS") > 0
		dbSelectArea("COMS")
		dbCloseArea()
	EndIf
	//Faz a conexão com o banco
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery + cQueryOrd), "COMS", .T., .T.)
	TcSetField("COMS","RECNO","N",10,0)
	dbSelectArea( "COMS")
	dbGotop()
	COMS->(dbEval({ || nRec++ },,{||!Eof()}))
	dbGoTop()
	//
	If nRec == 0
		dbSelectArea("COMS")
		dbCloseArea()
		Alert("Nenhum Pedido de Compras foi selecionado.","Verifique os parâmetros")
		Return()
	EndIf

	oPrint := FwMsPrinter():New('PEDIDO DE COMPRA', IMP_PDF, .T.,,.T.,,,)
	//FWMsPrinter(): New ( < cFilePrintert >, [ nDevice], [ lAdjustToLegacy], [ cPathInServer], [ lDisabeSetup ], [ lTReport], [ @oPrintSetup], [ cPrinter], [ lServer], [ lPDFAsPNG], [ lRaw], [ lViewPDF], [ nQtdCopy]) --> oPrinter
	//					1				2				3					4				5				6				7			 8		    9		      10		  11		 12		 13
	oPrint:SetPortrait()
	oPrint:setPaperSize( DMPAPER_A4)

	//Query para selecionar os itens de cada pedido selecionado.
	While !COMS->(Eof())
		dbSelectArea("SC7")
		//dbGoto(COMS->REG)
		_nTotGeral 		:= 0 	//SAMUEL
		_nIpiGeral   	:= 0	//SAMUEL
		_nFreteGeral	:= 0 	//SAMUEL

		//Inicia a Criação qua query sql 
		cQuery		:= 		"SELECT "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_NUM PED, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_EMISSAO EMISSAO, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_COND CONDPAG, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_MOEDA MOEDA, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_FORNECE FORNECE, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_LOJA LOJA, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_CONTATO CONTATO, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_PRODUTO COD, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_DATPRF ENTREGA, "+CHR(13)+CHR(10)
		If MV_PAR08 = 1 //Qual Unid. Med
			cQuery		+= 		"C7_QUANT QUANT, "+CHR(13)+CHR(10)
			cQuery		+= 		"C7_PRECO PRCVEN, "+CHR(13)+CHR(10)
			cQuery		+= 		"C7_UM UM, "+CHR(13)+CHR(10)
		 Else
			cQuery		+= 		"C7_QTSEGUM  QUANT, "+CHR(13)+CHR(10)
			cQuery		+= 		"C7_XPRECO PRCVEN, "+CHR(13)+CHR(10)
			cQuery		+= 		"C7_SEGUM UM, "+CHR(13)+CHR(10)
		EndIf
		cQuery		+= 		"C7_TOTAL TOTAL, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_IPI IPI, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_NUMSC NUMSC, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_VALFRE FRETE, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_DESPESA DESPESA, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_OBSPV OBSSC, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_OBS OBSPV, "+CHR(13)+CHR(10)
		//cQuery		+= 		"C7_USER XCOMPR, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_VLDESC DESCONTO, "+CHR(13)+CHR(10) //SAMUEL
		cQuery		+= 		"C7_XCOMPR XCOMPR, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_XLOTEOF XLOTEOF, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_XPRODOF XPRODOF, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_XDESCOF XDESCOF, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_XQTDEOF XQTDEOF, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_XUMOF XUMOF, "+CHR(13)+CHR(10)
		cQuery		+= 		"CASE  WHEN C7_XCERTIF = '1' THEN 'SIM'   ELSE 'NAO'  END XCERTIF, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_COD FORNECE, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_LOJA LOJA, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_NOME NOME, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_CONTATO CONTATO, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_DDD DDD, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_TEL FONE, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_CGC CNPJ, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_END ENDER, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_BAIRRO BAIRRO, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_MUN MUN, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_EST EST, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_CEP CEP, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_TOTAL*C7_IPI/100  TOTIPI, "+CHR(13)+CHR(10)
		cQuery		+= 		"C7_DESCRI C7_DESCRI "+CHR(13)+CHR(10)
		cQuery		+= 		"FROM "+CHR(13)+CHR(10)
		cQuery		+= 		RetSqlName("SC7")+" SC7 "+CHR(13)+CHR(10)
		cQuery		+= 		"INNER JOIN " + RetSqlName("SA2") + " SA2 ON A2_FILIAL = '"+xFilial("SA2")+"' AND A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ = ''" +CHR(13)+CHR(10)
		cQuery		+= 		"INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = C7_PRODUTO AND SB1.D_E_L_E_T_ = '' " +CHR(13)+CHR(10)
		cQuery		+= 		"WHERE "+CHR(13)+CHR(10)
		cQuery		+= 		"SC7.C7_FILIAL = "+xFilial("SC7")+" AND "+CHR(13)+CHR(10)
		cQuery		+= 		"SC7.C7_NUM = "+alltrim(COMS->REG)+" AND "+CHR(13)+CHR(10) 
		cQuery		+= 		"SC7.C7_RESIDUO = ' ' AND "+CHR(13)+CHR(10)  // Adicionado por Samuel Miranda dia 08/02/2023
		cQuery		+= 		"SC7.D_E_L_E_T_ = ' ' " +CHR(13)+CHR(10)
		cQueryORD	:= 		"ORDER BY "+CHR(13)+CHR(10)
		cQueryORD	+= 		"SC7.C7_NUM, "+CHR(13)+CHR(10)
		cQueryORD	+= 		"SC7.C7_ITEM "+CHR(13)+CHR(10)
		//Grava o resultado da query
		MemoWrite("COM.SQL", cQuery + cQueryOrd)
		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery + cQueryOrd), "COM", .T., .T.)

		TcSetField("COM","EMISSAO"		,"D", 8,0)
		TcSetField("COM","ENTREGA"		,"D", 8,0)
		TcSetField("COM","QUANT"		,"N",16,2)
		TcSetField("COM","PRECO"		,"N",16,4)
		TcSetField("COM","TOTAL"		,"N",16,4)
		TcSetField("COM","TOTIPI"		,"N",16,2)
		//	TcSetField("COM","DESCONTO"	,"N",16,2)// SAMUEL

		//Inicia a variavel 
		nRec	:= 0
		dbSelectArea( "COM")
		dbGotop()
		COM->(dbEval({ || nRec++ },,{||!Eof()}))
		dbGoTop()
		//Verifica se e consulta retornou algum registro.
		If nRec == 0
			dbSelectArea("COM")
			dbCloseArea()
			Alert("Pedido de Compras não contem itens." ,"Verifique !")
		Else
			dbSelectArea("COM")
			dbGotop()
			//
			While !COM->(Eof())
				If Len(aCabec)==0
					cEmpresa 	:= SM0->M0_NOMECOM
					cEndere		:= Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_BAIRCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" - "+Alltrim(SM0->M0_ESTCOB)+" - "+iif(!Empty(SM0->M0_CEPCOB), "CEP: "+Transform(Alltrim(SM0->M0_CEPCOB),"@R 99999-999") , "")
					cCgc		:= IIF(LEN(ALLTRIM(SM0->M0_CGC))==14, Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),Transform(SM0->M0_CGC,"@R 999.999.999-99"))
					cInsc		:= Transform(SM0->M0_INSC,"@R 999.999.999.999")
					cTel		:= Transform(SM0->M0_TEL,"@R9999-9999")
					cFax		:= Transform(SM0->M0_FAX,"@R9999-9999")
					c_PED		:= PED
					c_END		:= Alltrim(ENDER)
					c_Bairro	:= Alltrim(BAIRRO)
					c_MUN		:= Alltrim(MUN)
					c_EST		:= Alltrim(EST)
					c_CEP		:= Transform(Alltrim(CEP),"@R 99999-999")
					c_TEL		:= Transform(FONE,"@R9999-9999")
					c_EMISSAO	:= Substr(DtoS(EMISSAO),7,2)+"/"+Substr(DtoS(EMISSAO),5,2)+"/"+Substr(DtoS(EMISSAO),1,4)
					c_ENTREGA	:= Substr(DtoS(ENTREGA),7,2)+"/"+Substr(DtoS(ENTREGA),5,2)+"/"+Substr(DtoS(ENTREGA),1,4)
					c_FORNECE	:= FORNECE+"-"+LOJA+"/"+NOME
					c_CONTATO	:= CONTATO
					c_DDD	    := DDD
					c_CNPJ		:= IIF(LEN(ALLTRIM(CNPJ))==14, Transform(CNPJ,"@R 99.999.999/9999-99"),Transform(CNPJ,"@R 999.999.999-99"))
					c_CONDPAG	:= Posicione("SE4",1,xFilial("SE4")+CONDPAG,"E4_DESCRI")
					c_MOEDA		:= MOEDA
					c_FONE		:= FONE
					c_NUMSC		:= NUMSC
					c_OBSSC		:= OBSSC //Obervação do Item 
					c_OBSPV		:= OBSPV //Obervação do Pedido
					//c_XCOMPR	:= UsrFullName(XCOMPR)
					c_XCOMPR	:= XCOMPR
					c_XLOTEOF	:= XLOTEOF
					c_XPRODOF	:= XPRODOF
					c_XQTDEOF	:= XQTDEOF
					c_XUMOF		:= XUMOF
					c_XDESCOF	:= XDESCOF
					//Array contendo os dados do Cabeçalho
					aCabec	:=	{cEmpresa,; //01
					cEndere,;	 	//02
					cCgc,;			//03
					cInsc,;     	//04
					cTel,;   	   	//05
					cFax,;         	//06
					c_PED,;	   		//07
					c_END,;			//08
					c_BAIRRO,;    	//09
					c_MUN,;   		//10
					c_EST,;        	//11
					c_CEP,;        	//12
					c_TEL,;			//13
					c_EMISSAO,;		//14
					c_ENTREGA,;    	//15
					c_FORNECE,;    	//16
					c_CONTATO,;    	//17
					c_DDD,;			//18
					c_FONE,;   		//19
					c_CNPJ,;		//20
					c_CONDPAG,;		//21
					c_MOEDA,;		//22
					c_NUMSC,;		//23
					c_OBSSC,;		//24 //Obervação do Item 
					c_OBSPV,;		//25 //Obervação do Pedido
					c_XCOMPR,;		//26
					c_XLOTEOF,;		//27
					c_XPRODOF,;		//28
					c_XQTDEOF,;		//29
					c_XUMOF,;		//30
					c_XDESCOF}		//31
					//Inicializa o array com os itens
					aItens := {}
				EndIf
				//Adiciona os itens a serem impresso no array
				aadd( aItens,	{  COD,;				//01-Codigo do Produto
				Substr(C7_DESCRI,1,70),;  				//02-DesCrição do Produto
				Substr(C7_DESCRI,1,70),;				//03-Não esta sendo usado	
				Transform(QUANT,"@E 9,999,999.99"),;	//04-Quantidade
				UM,;             						//05-Unidade de Medida
				Transform(PRCVEN,"@E 9,999,999.99"),;	//06-Preço de Venda
				TOTAL,;									//07-Total (Quntidade x Valor)
				XCERTIF,;								//08-Certificado
				TOTIPI,;								//09-Valor do IPI
				Substr(DtoS(ENTREGA),7,2)+"/"+Substr(DtoS(ENTREGA),5,2)+"/"+Substr(DtoS(ENTREGA),1,4),; //10-Data de Entrega
				XLOTEOF,;								//11-Lote OF
				OBSPV,; 								//12-Observação do Pedido
				XPRODOF,;  								//13-Produto OF
				XDESCOF,;  								//14-Descrição OF
				XQTDEOF,;  								//15-Quantidade OF
				XUMOF,;    								//16-Unidade de Medida OF
				FRETE,;    								//17-Valor do Frete Unidade de Medida OF
				DESPESA,;  								//18-Valor da Despesa
				DESCONTO,; 								//19-Valor do Desconto
				_nItem ,;								//20-Numero so Item do Pedido
				NUMSC }) 								//21-Número da Solicitação de compra //Por Samuel Miranda 18/07/2022 
				// Visualiza antes de imprimir
				dbSelectArea("COM")
				dbSkip()//Passa pro proximo item do alias
				If c_PED == PED
					_nItem += 1
				EndIf
			EndDo

			While Mod(len(aItens),nItPg) > 0
				//Adicionar 
				aadd( aItens,	{	" ",;  //01-Codigo do Produto
								    " ",;  //02-DesCrição do Produto
								    " ",;  //03-Não esta sendo usado	
								    " ",;  //04-Quantidade
								    " ",;  //05-Unidade de Medida
								    " ",;  //06-Preço de Venda
								      0,;  //07-Total (Quntidade x Valor)
								    " ",;  //08-Certificado
								      0,;  //09-Valor do IPI
								    " ",;  //10-Data de Entrega
								    " ",;  //11-Lote OF
								    " ",;  //12-Observação do Pedido
								    " ",;  //13-Produto OF
								    " ",;  //14-Descrição OF
								      0,;  //15-Quantidade OF
								    " ",;  //16-Unidade de Medida OF
								      0,;  //17-Valor do Frete Unidade de Medida OF
								      0,;  //18-Valor da Despesa
								      0,;  //19-Valor do Desconto
								      0,;  //20-Numero so Item do Pedido
								  " " })   //21-Número da Solicitação de compra //Por Samuel Miranda 18/07/202
			EndDo
			//Faz divisao dos itens para obter o número de paginas
			Folhas 	:= Int( len(aItens) / nItPg)
			Folha 	:= 1
			//Adciona os itens nas paginas (24 linhas por paginas)
			For i := 1 to len(aItens) Step nItPg
				//Inicializa o array
				aPrtLi	:= {}
				//
				For j := 0 to nItPg - 1
					//Inicializa o array dos itens das linhas das paginas
					aPrtIt	:= {}
					//Adciona os itens nas linhas das paginas
					For k := 1 to len(aItens[i+j])
						aadd(aPrtIt,aItens[i+j,k])
					Next k
					aadd(aPrtLi,aPrtIt)
				Next j
				//Parametro para o numero de copias a ser impresso
				For k := 1 To MV_PAR07
					oPrint:StartPage()							// Inicia uma nova página
					Impress(aCabec,aPrtLi,Folha++,Folhas)		// Vale
					oPrint:EndPage()							// Finaliza a página
				Next k
			Next i
			//Inicializa o array do cabeçalho
			aCabec	:= {}
			//Seleciona o Alias dos itens 
			dbSelectArea("COM")
			dbCloseArea()//Fecha o Alias
		EndIf
		//Seleciona o Alias dos itens e em seguida fecha.
		dbSelectArea("COMS")
		dbSkip()//Fecha o Alias
	EndDo
	//Seleciona o Alias dos itens e em seguida fecha.
	dbSelectArea("COMS")
	dbCloseArea()//Fecha o Alias
	// Visualiza antes de imprimir
	oPrint:Preview()     // Visualiza antes de imprimir
Return()

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Programa  | MONTACOM  | Autor.|  Samuel Miranda      | Data | 06/05/21 |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Descri‡…o | Monta a estrutura a ser impressa pelo relatório.           |±±          
±±|          | 												              |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Uso       | Ortosintese                                                |±±     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±    
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/ 
Static Function Impress(aCabec,aPrtLi,Folha,Folhas)

	Local i  			:= 0
	Local _nSalto 		:= 0
	Local cEmpresa		:= aCabec[01]
	Local cEndere		:= aCabec[02]
	Local cCgc			:= aCabec[03]
	Local cInsc			:= aCabec[04]
	Local cTel			:= aCabec[05]
	Local cFax			:= aCabec[06]
	Local c_PED			:= aCabec[07]
	Local c_END			:= aCabec[08]
	Local c_BAIRRO		:= aCabec[09]
	Local c_MUN			:= aCabec[10]
	Local c_EST			:= aCabec[11]
	Local c_CEP			:= aCabec[12]
	//Local c_TEL			:= aCabec[13] //Variacel sem estar em usu.
	Local c_EMISSAO		:= aCabec[14]
	//Local c_ENTREGA		:= aCabec[15] //Variacel sem estar em usu.
	Local c_FORNECE		:= aCabec[16]
	Local c_CONTATO		:= aCabec[17]
	Local c_DDD			:= aCabec[18]
	Local c_FONE		:= aCabec[19]
	Local c_CNPJ		:= aCabec[20]
	Local c_CONDPAG		:= aCabec[21]
	Local c_MOEDA		:= acabec[22]
	//Local c_NUMSC		:= aCabec[23] //Variacel sem estar em usu.
	Local c_OBSSC		:= aCabec[24]
	//Local c_OBSPV		:= aCabec[25] //Variacel sem estar em usu.
	Local c_XCOMPR		:= aCabec[26]
	//Local c_XLOTEOF		:= aCabec[27] //Variacel sem estar em usu.
	//Local c_XPRODOF		:= aCabec[28] //Variacel sem estar em usu.
	//Local c_XDESCOF		:= aCabec[29] //Variacel sem estar em usu.
	//Local c_XQTDEOF		:= aCabec[30] //Variacel sem estar em usu.
	//Local c_XUMOF		    := aCabec[31] //Variacel sem estar em usu.
	Local nValIpostos 	:= {}
	Local nAux 			:=0
	Local c_Folha		:= "Folha: "+Alltrim(Str(Folha))+"/"+Alltrim(Str(Folhas))
	Private  cNumPedido := c_PED
	//ABmp := "VALE_"+AllTrim(cEmpAnt)+".JPEG"
	// ABmp := "VALE_04.bmp"
	ABmp := "LGMID01.png"
	//Fontes Arial
	oFont10An		:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11An		:= TFont():New("Arial",7,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12An		:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont13A		:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont13An		:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14A		:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14An		:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16An		:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont25An		:= TFont():New("Arial",9,25,.T.,.T.,5,.T.,5,.T.,.F.)
	// Fontes Courier
	oFont10C		:= TFont():New("Courier New",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11C		:= TFont():New("Courier New",9,11,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10Cn		:= TFont():New("Courier New",9,10,.T.,.T.,5,.T.,5,.T.,.F.)

	//Função de cores
	//oBrush 	:= TBrush():New(,RGB(192,192,192)) //100,149,237
	oBrush  := TBrush():New(, RGB(176,196,222)) //
	oBrush0 := TBrush():New(, RGB(173,216,230))
	oBrush1 := TBrush():New(, RGB(0,0,0))

	// ----------------------------------  Contorno do documento -----------------------------------//
	oPrint:box(0015,0015,2680,2355)//2470) //Box Moldura
	oPrint:Line(0015,0550,0280,0550)// Linha vertical do Logo

	// ----------------------------------  Logotipo ------------------------------------------------//
	If File(aBmp)
		oPrint:SayBitmap( 0020,0025,ABmp,0500,0240)
	EndIf

	oPrint:Say(0120,0950,"PEDIDO DE COMPRAS",oFont25An)
	oPrint:Say(0120,2170,c_Folha,oFont13An)
	oPrint:line(0280,0020,0280,2355)//Linha Horizontal

	oPrint:Say(0310,0020,cEmpresa,oFont16An)
	oPrint:Say(0310,1850,"Pedido Compra N.:",oFont14An)	;	oPrint:Say(0310,2200,c_PED,oFont14An)
	oPrint:Say(0340,0020,cEndere,oFont10An)
	oPrint:line(0350,0020,0350,2355)//Linha Horizontal

	oPrint:Say(0385,0020,"TEL:",oFont12An)				;	oPrint:Say(0385,0150,cTel,oFont12An)
	oPrint:Say(0385,0470,"E-Mail:",oFont12An)			;	oPrint:Say(0385,0600,"compras.ortopedia@ortosintese.com.br",oFont12An)
	oPrint:Say(0385,1160,"Site:",oFont12An)				;	oPrint:Say(0385,1250,"www.ortosintese.com.br",oFont12An)
	oPrint:Say(0385,1900,"Emissao:",oFont12An)			;	oPrint:Say(0385,2070,c_Emissao,oFont12An)
	oPrint:Say(0420,0020,"CNPJ:",oFont12An)				;	oPrint:Say(0420,0150,cCgc,oFont12An)
	oPrint:Say(0420,0470,"INSCR.EST :",oFont12An)		;	oPrint:Say(0420,0670,cInsc,oFont12An)
	oPrint:Say(0420,1160,"FAX:",oFont12An)				;	oPrint:Say(0420,1250,cFax,oFont12An) ////oPrint:line (0440,0020,0440,2355)//Linha Horizontal
	oPrint:line(0430,0020,0430,2355)//Linha Horizontal


	// ----------------------------------  quadro 3  Destinatário -----------------------------------------------------//
	oPrint:FillRect({0435,0020,0470,2350},oBrush)  //Imprime uma tarja
	oPrint:Say(0465,0950,"DADOS DO FORNECEDOR",oFont14An)
	oPrint:line(0475,0015,0475,2355)// Linha Horizontal
	oPrint:Say(0505,0020,"FORNECEDOR:",oFont14An)	   	;	oPrint:Say	(0505,0300,c_FORNECE,oFont14A)
	oPrint:Say(0545,1500,"CNPJ:",oFont14An)			   	;	oPrint:Say	(0545,1630,c_CNPJ,oFont14A)
	oPrint:line(0515,0020,0515,2355)//Linha Horizontal

	oPrint:Say(0545,0020,"ENDEREÇO:",oFont14An)	   		;	oPrint:Say	(0545,0300,c_END,oFont14A)
	oPrint:Say(0585,1500,"BAIRRO:",oFont14An)		   	;	oPrint:Say	(0585,1660,c_BAIRRO,oFont14A)
	oPrint:line(0555,0020,0555,2355)//Linha Horizontal

	oPrint:Say(0585,0020,"CIDADE:",oFont14An)		  	;	oPrint:Say	(0585,0300,c_MUN,oFont14A)
	oPrint:Say(0625,1500,"ESTADO:",oFont14An)		  	;	oPrint:Say	(0625,1670,c_EST,oFont14A)
	oPrint:Say(0625,1800,"C.E.P:",oFont14An)		  	;	oPrint:Say	(0625,1920,c_CEP,oFont14A)
	oPrint:line(0595,0020,0595,2355)//Linha Horizontal

	oPrint:Say(0625,0020,"CONTATO:",oFont14An)		  	;	oPrint:Say	(0625,0300,c_Contato,oFont14A)
	oPrint:Say(0665,1500,"FONE:",oFont14An)		  		;	oPrint:Say	(0665,1650,c_Ddd +" -  "+c_Fone ,oFont14A) //;	oPrint:Say	(0625,1750,c_Fone,oFont14A)
	oPrint:line(0635,0020,0635,2355)//Linha Horizontal
	oPrint:Say(0665,0020,"MOEDA...:",oFont14An)
	oPrint:line(0675,0020,0675,2355)//Linha Horizontal
	oPrint:Line(0515,1490,0675,1490) // Linha vertical

	//Imprime a Moeda conforme parametro.
	If c_MOEDA == 1
		oPrint:Say(0665,0300,"REAL",oFont14A)
	ElseIf c_MOEDA == 2
		oPrint:Say(0665,0300,"DOLAR",oFont14A)
	ElseIf c_MOEDA == 3
		oPrint:Say(0665,0300,"UFIR",oFont14A)
	ElseIf c_MOEDA == 4
		oPrint:Say(0665,0300,"EURO",oFont14A)
	ElseIf c_MOEDA == 5
		oPrint:Say(0665,0300,"IENE",oFont14A)
	EndIf
	//Imprime uma tarja
	oPrint:FillRect({0680,0020,0715,2350},oBrush) 
	oPrint:Say(0705,0950,"DADOS DO PEDIDO",oFont14An)
	oPrint:line(0715,0020,0715,2355)//Linha Horizontal
	//oPrint:line (0845,0020,0845,2355)// Linha Horizontal
	// ----------------------------------  quadro 4  Cabec Itens -----------------------------------------------------//
	oPrint:Say(0750,0020,"ITEM",oFont13An)
	oPrint:Line(0715,120,0760,120)// Linha vertical

	oPrint:Say(0750,0150,"PRODUTO",oFont13An)
	oPrint:Line(0715,0340,0760,0340)// Linha vertical

	oPrint:Say(0750,0350,"DESCRIÇÃO DO PRODUTO",oFont13An) //SAMUEL DIA 29/11/2017 LTERADO PARA 0280
	oPrint:Line(0715,1440,0760,1440)// Linha vertical
	
	oPrint:Say(0750,1480,"QUANT",oFont13An) //Primeira unidade
	oPrint:Line(0715,1605,0760,1605)// Linha vertical
	
	oPrint:Say(0750,1620,"UNID.",oFont13An)
	oPrint:Line(0715,1710,0760,1710)// Linha vertical
	
	oPrint:Say(0750,1735,"$ UNIT.",oFont13An)
	oPrint:Line(0715,1890,0760,1890)// Linha vertical
	
	oPrint:Say(0750,1920,"$ TOTAL",oFont13An)
	oPrint:Line(0715,2090,0760,2090)// Linha vertical
	
	oPrint:Say(0750,2090,"CERT.",oFont13An)
	oPrint:Say(0750,2200,"ENT. ATÉ",oFont13An)
	
	oPrint:Line(0715,2180,0760,2180)// Linha vertical
	oPrint:line(0760,0020,0760,2355)// Linha Horizontal

	// ----------------------------------  quadro 5  Detalhe dos Itens -----------------------------------------------------//
	_Li           := 0760
	_nTotal       := 0
	_nIpi         := 0
	_nFrete       := 0
	_nDespesa     := 0
	_nDesconto    := 0 //SAMUEL DIA 29/11/201
	_nImpSC       := {}
	//_nIpiGeral   		:= 0	//SAMUEL  
	//_nFreteGeral		:= 0 	//SAMUEL  

	For i := 1 to len(aPrtLi)
		_Li		+= 40
		_nSalto	+= 75

		If !Empty(aPrtLi[i,1])
			oPrint:Say (_Li,0022,CVALTOCHAR(STRZERO(aPrtLi[i,20],4)),oFont10C) //STRZERO(VAL(cValor),10)
		EndIf
		oPrint:Say	(_Li,0130,aPrtLi[i,1], oFont10C)	// PRODUTO
		If !Empty(aPrtLi[i,12])
			oPrint:Say	(_Li-15,0350,UPPER(aPrtLi[i,2]), oFont10C)	// DESCRICAO //alterado de 0250 para 0310  por SAMUEL MIRANDA 06/03/2018
		Else
			oPrint:Say	(_Li,0350,UPPER(aPrtLi[i,2]), oFont10C)	
		EndIf
		oPrint:Say	(_Li,1400,aPrtLi[i,4], oFont10C)	// QUANT
		oPrint:Say	(_Li,1640,aPrtLi[i,5], oFont10C)	// UM
		oPrint:Say	(_Li,1680,aPrtLi[i,6], oFont10C)	// PRCVEN
		If aPrtLi[i,7] > 0
			oPrint:Say	(_Li,1850,Transform(aPrtLi[i,7],"@E 999,999,999.99"),oFont10C)	// PRECO TOTAL  MUDADO PARA 1000
		Endif
		oPrint:Say	(_Li,2110,aPrtLi[i,8], oFont10C)	// CERTIF.CONFORM //MUDADO PARA 2100
		oPrint:Say	(_Li,2190,aPrtLi[i,10], oFont10C)	// ENTREGA

		_Li	+= 40
		//oPrint:Say	(_Li-15,0350,aPrtLi[i,3], oFont10C)	// DESCRICAO antes era 290
		oPrint:Say	(_Li-15,0720,aPrtLi[i,11], oFont10C)	// XLOTEOF
		//_Li	+= 30       (2660,0160,
		If !Empty(aPrtLi[i,12])
			oPrint:Say	(_Li-30 ,0350,"Obs:"+ Lower(Substr(aPrtLi[i,12],1,65)), oFont10C)	// OBSPC //Substr(C7_DESCRI,1,70)
			oPrint:Say	(_Li- 5,0350,Substr(aPrtLi[i,12],66,99), oFont10C)
		EndIf
		If !Empty(SC7->C7_XLOTEOF)
			_Li	+= 30
			oPrint:Say	(_Li - 15,0500,aPrtLi[i,13], oFont10C)	// XPRODOF
			oPrint:Say	(_Li - 15,0700,aPrtLi[i,14], oFont10C)	// XDESCOF
			If aPrtLi[i,15] > 0
				oPrint:Say	(_Li - 15,1350,Transform(aPrtLi[i,15],"@E 9999"),oFont10C)	// XQTDEOF
			EndIf
			oPrint:Say	(_Li - 15,1550,aPrtLi[i,16], oFont10C)	// XUMOF
		EndIf
		//Icrementa as variaveis
		_nTotal 	+= aPrtLi[i,7]
		_nFrete 	+= aPrtLi[i,17]
		_nDespesa 	+= aPrtLi[i,18]  //DESPESA 
		_nDesconto 	+= aPrtLi[i,19]  //DESCONTO SAMUEL DIA 29/11/2017

		If aPrtLi[i,9] > 0
			_nIpi   += aPrtLi[i,9]
		EndIf

		_Li	-= 30
		//Imprimi as linhas vertical na grid.
		if !empty(aPrtLi[i,1])
			oPrint:Line (0715,0120,_nSalto+0760,0120)// Linha do Item 
			oPrint:Line (0715,0340,_nSalto+0760,0340)// Descrição do Produto 
			oPrint:Line (0715,1440,_nSalto+0760,1440)// Quantidade
			oPrint:Line (0715,1605,_nSalto+0760,1605)// Quantidade / Unidade
			oPrint:Line (0715,1710,_nSalto+0760,1710)// Unidade / Unitario
			oPrint:Line (0715,1890,_nSalto+0760,1890)// Unitario / Total
			oPrint:Line (0715,2090,_nSalto+0760,2090)// Total Certificado
			oPrint:Line (0715,2180,_nSalto+0760,2180)// Ceti / Entrega Até

			_Li	+= 30
			oPrint:Line (_Li,0120,0760,0120)// Linha do Item 
			oPrint:Line (_Li,0340,0760,0340)// Descrição do Produto
			oPrint:Line (_Li,1440,0760,1440)// Quantidade
			oPrint:Line (_Li,1605,0760,1605)// Quantidade / Unidade
			oPrint:Line (_Li,1710,0760,1710)// Unidade / Unitario
			oPrint:Line (_Li,1890,0760,1890)// Unitario / Total
			oPrint:Line (_Li,2090,0760,2090)// Total Certificado
			oPrint:Line (_Li,2180,0760,2180)// Ceti / Entrega Até

			oPrint:line (_Li,0020,_Li,2355)//Linha Horizontal
		EndIf

		// Inicio---------------------------------------------------------------------------------------------------//
		// |Autor - Samuel Mirada |	                                                       							//
		// | Alteração feita para imprimir os números das solicitaçoes de comprar //Por Samuel Miranda 18/07/2022   //
		//----------------------------------------------------------------------------------------------------------//
		itemArray := aPrtLi[i,21]
		//Se o tamanho for 0, Array é vazio
		If Len(_cNumsc) == 0
			aAdd(_nImpSC,aPrtLi[i,21])//Alimenta o para impressão
			aAdd(_cNumsc,aPrtLi[i,21]) //Alimenta principal
			//Verifica se não existi o número da SC para não imprimir numeros repetidos.
		ElseIf !(aScan(_cNumsc,{|x| x == itemArray })) .AND. itemArray<>""
			//aScan(aArray, {|x| x == "SUA_BUSCA"})
			aAdd(_nImpSC,aPrtLi[i,21]) //Alimenta o para impressão
			aAdd(_cNumsc,aPrtLi[i,21]) //Alimenta principal
		EndIf
	Next i
	//Varial para ser alimentada com as Solitaçoes de Compra
	cImpSC := ' '
	For nAux := 1 to len (_nImpSC)
		if !(Empty(_nImpSC[nAux]))
			cImpSC +=_nImpSC [nAux]+'; '
		EndIF
	next nAux
	//Fim--------------------------------------------------------------------------------------------------------//

	_nTotGeral 		+= _nTotal 	 	//Samuel Miranda-06/05/21	
	_nIpiGeral   	+= _nIpi 		//Samuel Miranda-06/05/21	
	_nFreteGeral	+= _nFrete		//Samuel Miranda-06/05/21	
	_nDestoTotal    += _nDesconto	//Samuel Miranda-06/05/21	
	_nTotalDespsa   += _nDespesa	//Samuel Miranda-06/05/21	

 	// ---------------------------------- Rodapé da pagina---------------------------------- //
	//oPrint:Say	(2005,0040,"PREZADOS PARCEIROS, FORNECEDORES E PRESTADORES DE SERVIÇOS, GOSTARÍAMOS DE INFORMAR, QUE NO PERÍODO DE 22 DE DEZEMBRO DE 2023 À 07 DE JANEIRO DE 2024",oFont10An)	
	//oPrint:Say	(2045,0050,+Space(05)+"OS RECEBIMENTOS DE MATERIAIS PRODUTIVOS, IMPRODUTIVOS E SERVIÇOS ESTARÃO SUSPENSOS. CASOS EXTREMAMENTE NECESSÁRIOS, SERÃO INFORMADOS E   ",oFont10An)	
	//oPrint:Say	(2085,0050,+Space(10)+" AGENDADOS COM OS PARCEIROS.A RETOMADA DOS RECEBIMENTOS SERÃO À PARTIR DO DIA 08 DE JANEIRO DE 2024.DESEJAMOS A TODOS EXCELENTES FESTAS.",oFont10An)	
	
	oPrint:Say	(1925,0040,"A Ortosintese não autoriza a quaisquer parceiros, fornecedores, prestadores de serviços, consultores etc. o desconto de seus títulos de qualquer forma ou em qualquer instituição financeira ",oFont10An)	
	oPrint:Say	(1965,0050,+Space(15)+" ou correlatos como factoring, bem como quaisquer cessões de crédito terão de ser aprovados previamente pela diretoria financeira da companhia. ",oFont10An)	
	//oPrint:Say	(2005,0050,+Space(10)+"",oFont10An)	
	oPrint:Say	(2005,0040," Caso haja o recebimento cujo cedente seja diferente da Nota Fiscal o título será recusado e devolvido ao cedente e em caso de negativação da Ortosintese haverá as devidas ações",oFont10An)	
	oPrint:Say	(2045,0050,+Space(40)+" judiciais para ressarcimentos dos prejuízos.",oFont10An)	


	oPrint:line(2100,0020,2100,2355)//Linha Horizontal
	oPrint:Say(2130,0020,"RC:",oFont13An)		   					;	oPrint:Say(2130,0115,cImpSC,oFont13A)
	
	oPrint:Say(2170,0020,"HORARIO DE RECEBIMENTO: ",oFont12An)
	oPrint:Say(2200,0020,"        SEGUNDAS AS QUINTAS-FEIRAS - HORÁRIO DE RECEBIMENTO DAS 07:15 AS 11:30 E DAS 13:00 AS 16:30, FORA DESSE HORÁRIO SOMENTE SERÁ RECEBIDO NO DIA SEGUINTE.",oFont10An)
	oPrint:Say(2230,0020,"                    SEXTAS-FEIRAS - HORÁRIO DE RECEBIMENTO DAS 07:15 AS 11:30 E DAS 13:00 AS 15:30, FORA DESSE HORÁRIO SOMENTE SERÁ RECEBIDO NO DIA SEGUINTE.",oFont10An)
	
	oPrint:Say(2300,0020,"MATERIAL SUJEITO A INSPEÇÃO",oFont12An)
	oPrint:Say(2335,0020,"                                FORNECEDORES QUE UTILIZAM SUBSTITUICAO TRIBUTARIA DE ICMS, FAVOR CONSTAR NAS NFS O VALOR DA ALIQUOTA E BASE DE CALCULO DO ",oFont10An)
	oPrint:Say(2370,0020,"                                                         ICMS OPTANTES PELO SIMPLES NACIONAL, FAVOR DESTACAR ALIQUOTA DO ICMS NA NOTA FISCAL.",oFont10An)
	oPrint:Say(2400,0020,"                                                       SE O MATERIAL NECESSITAR DE CERTIFICAÇÃO / LAUDO, FAVOR ACOMPANHAR O MATERIAL E A DANFE.",oFont10An)
	oPrint:line(2440,0020,2440,2355)//Linha Horizontal

	oPrint:Say(2470,0020,"Condicoes e Forma ",oFont13An)		  ; oPrint:Say(2520,0340,c_Condpag,oFont13A)
	oPrint:Say(2520,0020,"De Pagamento :",oFont13An)
	oPrint:Say(2560,0020,"Observ. P.C :",oFont13An) 			  ; oPrint:Say(2600,0020,c_Obssc,oFont11C)
	oPrint:Say(2470,1400,"PRODUTOS ",oFont13An) 				  ; oPrint:Say(2470,2100,Transform(_nTotal,"@E 999,999,999.99"),oFont13A)
	oPrint:line(2480,1350,2480,2355)//Linha Horizontal
	If Folha <> Folhas
		oPrint:Say(2520,1400,"DESCONTO               - ",oFont13An)   ; oPrint:Say(2520,2100,Transform(_nDesconto,"@E 999,999,999.99"),oFont13A)
	EndIf
	//Endif
	oPrint:line(2530,0020,2530,2355)//Linha Horizontal
	oPrint:Line(2440,1350,2680,1350)// Linha vertical
	If Folha <> Folhas
		oPrint:Say(2560,1400,"IPI"      			   ,oFont13An)	  ; oPrint:Say(2560,2100,Transform(_nIpi,"@E 999,999,999.99"),oFont13A)
	Endif
	oPrint:line(2570,1350,2570,2355)//Linha Horizontal
	If Folha <> Folhas
		oPrint:Say(2610,1400,"FRETE / DESPESA"        ,oFont13An)	  ; oPrint:Say(2610,2100,Transform(_nFrete+_nDespesa,"@E 999,999,999.99"),oFont13A)
	Endif
	oPrint:line(2620,1350,2620,2355)//Linha Horizontal

	if Folha = Folhas
		nValIpostos := TOTICMS()
		oPrint:Say(2520,1400,"TOTAL DESCONTO         - ",oFont13An)  ; oPrint:Say(2520,2100,nValIpostos[1][8],oFont13A) // 8 - Valor do total do desconto
		oPrint:Say(2560,1400,"IPI"      			    ,oFont13An)	 ; oPrint:Say(2560,2100,nValIpostos[1][4],oFont13A) // 4 - Valor do IPI
		oPrint:Say(2610,1400,"FRETE / DESPESA"          ,oFont13An)	 ; oPrint:Say(2610,2100,nValIpostos[1][9],oFont13A) // 9 - Valor do Frete + Despesa 
		oPrint:Say(2660,1400,"TOTAL PEDIDO"             ,oFont13An)  ; oPrint:Say(2660,2100,nValIpostos[1][7],oFont13A) // 7 - Valor do pedido com os impostos

		//oPrint:Say(2520,1400,"TOTAL DESCONTO       - ",oFont13An)  ; oPrint:Say(2520,2100,Transform(_nDestoTotal,"@E 999,999,999.99"),oFont13A)
		//oPrint:Say(2560,1400,"IPI"      			    ,oFont13An)	 ; oPrint:Say(2560,2100,Transform(_nIpiGeral,"@E 999,999,999.99"),oFont13A)
		//oPrint:Say(2610,1400,"FRETE / DESPESA"        ,oFont13An)	 ; oPrint:Say(2610,2100,Transform(_nFreteGeral+_nTotalDespsa,"@E 999,999,999.99"),oFont13A)
		//oPrint:Say(2660,1400,"TOTAL PEDIDO"           ,oFont13An)  ; oPrint:Say(2660,2100,Transform(_nTotGeral+_nIpiGeral+_nFrete+_nTotalDespsa-_nDestoTotal,"@E 999,999,999.99"),oFont13A)
	Endif
	
	oPrint:Say(2705,0020,"O NUMERO DESTE PEDIDO DEVE CONSTAR EM SUA NOTA FISCAL O FORNECEDOR AO ACEITAR ESTE PEDIDO COMPREMETE-SE EM NFORMAR-NOS SOBRE QUALQUER ALTERACAO QUE VENHA",oFont10Cn)
	oPrint:Say(2740,0020,"      A OCORRER NOS PRODUTOS OU SERVICOS FORNECIDOS. NOS CASOS EM QUE CONSTAR A REVISAO DO DESENHO NA DESCRICAO CONFIRMAR SE POSSUI A ATUALIZADOS",oFont10Cn)
	oPrint:Say(2775,0020,"                       OS ARQUIVOS XML DEVEM SER ENVIADOS PARA NFE@ORTOSINTESE.COM.BR.NÃO RECEBEREMOS NFS EMITIDAS A MAIS DE 05 DIAS.",oFont10Cn)

	oPrint:box (2900,0020,2900,0500) //linha da data do pedido
	oPrint:box (2900,0750,2900,1330) //linha dc Comprador
	oPrint:box (2900,1550,2900,2250) //Linha do aprovador

	oPrint:Say(2895,0850,UPPER(c_XCOMPR),oFont13An)
	oPrint:Say(2930,0150,"Data do Pedido :",oFont13An)			;	oPrint:Say	(2895,0175,c_Emissao,oFont13An)
	oPrint:Say(2930,0900,"Comprado Por :",oFont13An)			; oPrint:Say	(2930,1750,"Aprovado Por:",oFont13An)
	oPrint:Say(3010,1500,"A1 06-02 Rev01",oFont13An) // Apedido daColaboradora Debora Luna conforme chamando 14010 ( Samuel Miranda 16/11/2021)

	If Folha <> Folhas
		oPrint:Say(3010,0060,"Continua na Próxima Pagina",oFont13An)
	Else
	EndIf
	oPrint:Say(3030,2125,"By TI Ortosintese ",oFont13An)
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Programa  ³ TOTICMS  ³ Autor.³  Samuel Miranda       ³ Data ³ 06/05/21 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³ Função para montar um array com os valores dos impostos.   ³±±          
±±³          ³ 												              ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Uso       ³ Ortosintese                                                ³±±     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±    
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/  
Static Function TOTICMS()
Local cQry :=""
Local nValores :={}

//Query sql para trazer os valores dos impostos.
cQry := " SELECT "+CHR(13)+CHR(10)
cQry +="ROUND(SUM(SC7.C7_SEGURO),2) AS  SEGURO,"+CHR(13)+CHR(10)
cQry +="ROUND(SUM(SC7.C7_DESPESA),2) AS DESPESA,"+CHR(13)+CHR(10)
cQry +="ROUND(SUM(SC7.C7_TOTAL*C7_IPI/100),2) AS  IPI,"+CHR(13)+CHR(10)
cQry +="ROUND(SUM(SC7.C7_VALICM ),2) AS  ICMS,"+CHR(13)+CHR(10)
cQry +="ROUND(SUM(SC7.C7_TOTAL),2) AS  PEDIDO,"+CHR(13)+CHR(10)
cQry +="ROUND(             "+CHR(13)+CHR(10)
cQry +="SUM(SC7.C7_TOTAL*C7_IPI/100)+ "+CHR(13)+CHR(10)
cQry +="SUM(SC7.C7_TOTAL)+      			"+CHR(13)+CHR(10)
cQry +="SUM(SC7.C7_SEGURO)+ 				 "+CHR(13)+CHR(10)
cQry +="SUM(SC7.C7_DESPESA)+				 "+CHR(13)+CHR(10)
cQry +="SUM(SC7.C7_VALFRE),2) AS PEDTOTAL, 	 "+CHR(13)+CHR(10)
cQry +="ROUND(SUM(SC7.C7_VALFRE),2) AS FRETE, "+CHR(13)+CHR(10)
cQry +="ROUND(SUM(SC7.C7_DESC),2) AS  VDESCONTO, "+CHR(13)+CHR(10)
cQry +="ROUND(SUM(SC7.C7_VALFRE+SC7.C7_DESPESA),2) AS DESPFRTE "+CHR(13)+CHR(10)
cQry += "FROM "+CHR(13)+CHR(10)
cQry += RetSqlName("SC7") + " SC7 "+CHR(13)+CHR(10)
cQry += "WHERE "+CHR(13)+CHR(10)
cQry += " SC7.C7_NUM = '"+cNumPedido+"' AND "+CHR(13)+CHR(10)
cQry += " SC7.C7_RESIDUO = ' ' AND "+CHR(13)+CHR(10)
cQry += " SC7.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQry := ChangeQuery(cQry)
MemoWrit("TOTICMS.SQL",cQry)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"CQRY",.T.,.T.)
//SEGURO	DESPESA	IPI	ICMS	PEDIDO	PEDTOTAL	FRETE
//891,38	897,43	226,31	1191,59	6470,05	8635,04	149,87
DbSelectArea("CQRY")
dbGoTop()
	AAdd(nValores,{ Transform(CQRY->SEGURO,"@E 999,999,999.99"),;   // 1 - Valor do Seguro  
					Transform(CQRY->DESPESA,"@E 999,999,999.99"),;  // 2 - Valor das Despesa
					Transform(CQRY->FRETE,"@E 999,999,999.99"),;    // 3 - Valor do Frete
					Transform(CQRY->IPI,"@E 999,999,999.99"),;      // 4 - Valor do IPI
					Transform(CQRY->ICMS ,"@E 999,999,999.99"),;    // 5 - Valor do ICMS
					Transform(CQRY->PEDIDO,"@E 999,999,999.99"),;   // 6 - Valor dos Itens do Pedido
					Transform(CQRY->PEDTOTAL,"@E 999,999,999.99"),; // 7 - Valor do pedido com os impostos
					Transform(CQRY->VDESCONTO,"@E 999,999,999.99"),;// 8 - Valor do total do desconto
					Transform(CQRY->DESPFRTE,"@E 999,999,999.99")}) // 9 - Valor do Frete + Despesa 
//Retorna um array com os dados a serem alterados.
CQRY->(DbCloseArea())
Return(nValores)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CriaSX1   ³ Rev.  ³ Samuel Miranda	     ³ Data ³ 14/12/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria uma janela contendo a legenda da mBrowse              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1(cPerg)

	Local aArea	:= GetArea()

	Local aP:= {}
	Local i:= 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp:= {}

	aAdd(aP,{"Fornecedor de"                ,"C", 6,0,"G","                                                            ","SA2"   ,""           ,""             ,""            ,"",""})
	aAdd(aP,{"Fornecedor ate"               ,"C", 6,0,"G","(mv_par02>=mv_par01)                                        ","SA2"   ,""           ,""             ,""            ,"",""})
	aAdd(aP,{"Emissao de"                	,"D", 8,0,"G","                                                            ",""      ,""           ,""             ,""            ,"",""})
	aAdd(aP,{"Emissao ate"               	,"D", 8,0,"G","(mv_par04>=mv_par03)                                        ",""      ,""           ,""             ,""            ,"",""})
	aAdd(aP,{"Pedido de"                 	,"C", 6,0,"G","                                                            ","SC7"   ,""           ,""             ,""            ,"",""})
	aAdd(aP,{"Pedido ate"                	,"C", 6,0,"G","(mv_par06>=mv_par05)                                        ","SC7"   ,""           ,""             ,""            ,"",""})
	aAdd(aP,{"Numero de Vias"            	,"N", 2,0,"G","(mv_par07>=1)                                               ",""      ,""           ,""             ,""            ,"",""})
	aAdd(aP,{"Qual Unid. Med."            	,"N", 1,0,"G","(mv_par08>=1)                                               ",""      ,""           ,""             ,""            ,"",""})

	aAdd(aHelp,{"Informe o Código do Fornecedor ","inicial para a seleção dos dados"})
	aAdd(aHelp,{"Informe o Código do Fornecedor ","Final para a seleção dos dados"})
	aAdd(aHelp,{"Informe a Data de Emissao  ","inicial para a seleção dos dados"})
	aAdd(aHelp,{"Informe a Data de Emissao  ","final para a seleção dos dados"})
	aAdd(aHelp,{"Informe o Numero do Pedido","inicial para a seleção dos dados"})
	aAdd(aHelp,{"Informe o Numero do Pedido","final para a seleção dos dados"})
	aAdd(aHelp,{"Informe a quantidade de cópias","a serem impressas."})
	aAdd(aHelp,{"Informe a Unidade de Medida" ,"a serem impressas."})

	_aParm := aClone(aP)

	For i:=1 To Len(aP)
		cSeq   := StrZero(i,2,0)

		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
		PutSx1(cPerg,;
			cSeq,;
			aP[i,1],aP[i,1],aP[i,1],;
			cMvCh,;
			aP[i,2],;
			aP[i,3],;
			aP[i,4],;
			0,;
			aP[i,5],;
			aP[i,6],;
			aP[i,7],;
			"",;
			"",;
			cMvPar,;
			aP[i,8],aP[i,8],aP[i,8],;
			"",;
			aP[i,9],aP[i,9],aP[i,9],;
			aP[i,10],aP[i,10],aP[i,10],;
			aP[i,11],aP[i,11],aP[i,11],;
			aP[i,12],aP[i,12],aP[i,12],;
			aHelp[i],;
			{},;
			"")
	Next i

	RestArea(aArea)

Return()
