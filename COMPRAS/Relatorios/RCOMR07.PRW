#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"        
#INCLUDE "TOPCONN.CH"  
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"           
#DEFINE DMPAPER_LETTER 1 	// Letter 8 1/2 x 11 in
#DEFINE DMPAPER_A4 9 		// A4 210 x 297 mm

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RCOMR07  ³ Autor.³  Samuel Miranda       ³ Data ³ 06/05/21 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Pedido de Compras                               ³±±          
±±³          ³ Especifoco para Matriz 						             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ortosintese                                                ³±±     
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/              
User Function RCOMR07()    

Private cPerg		:= "RCOMR07"
Private nItPg		:= 12  //Número de linhas x2 16
Private aMes		:= {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
Private lPreVale	:= .f.
Private lValido		:= .t.

_nTotGeral 		:= 0 //SAMUEL
_nIpiGeral   	:= 0 //SAMUEL
_nFreteGeral   	:= 0 //SAMUEL  

ValidPerg()                                                 '

Pergunte(cPerg,.T.)

Processa({|| MontaCom()})

Return Nil     

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MontaCom  ³ Revis.³  Samuel Miranda      ³ Data ³ 14/12/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Montagem do Pedido de Compras                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Ortosintese                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/              
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
Local xmp			:= 0
Local oFont14An    
//Fonte usanda na Impressão dos Desenhos.
oFont14An	:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)

PRIVATE oPrint
//Query para selecionar o Número do Pedido
cQuery		:= "SELECT "+CHR(13)+CHR(10)
cQuery		+= 		"DISTINCT(SC7.C7_NUM ) REG "+CHR(13)+CHR(10)
cQuery		+= "FROM  "+CHR(13)+CHR(10)
cQuery		+= 		RetSqlName("SC7")+" SC7 "+CHR(13)+CHR(10)
cQuery		+= "WHERE  "+CHR(13)+CHR(10)
cQuery		+= 		"SC7.D_E_L_E_T_ = ' ' AND "+CHR(13)+CHR(10) 
cQuery		+= 		"SC7.C7_FILIAL = '"+cFilAnt+"' AND "+CHR(13)+CHR(10)
cQuery		+= 		"SC7.C7_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "+CHR(13)+CHR(10)
cQuery		+= 		"SC7.C7_FORNECE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "+CHR(13)+CHR(10)
cQuery		+= 		"SC7.C7_CONAPRO = 'L' AND "+CHR(13)+CHR(10) // APROVACAO INCLUIDO PARA SOMENTE IMPRIMIR PEDIDOS APROVADOS
cQuery		+= 		"SC7.C7_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "+CHR(13)+CHR(10)
cQueryOrd	+= "ORDER BY "+CHR(13)+CHR(10)
cQueryOrd	+= 	"1 "+CHR(13)+CHR(10)

MemoWrite("COMS.SQL", cQuery + cQueryOrd)

If Select("COMS") > 0
	dbSelectArea("COMS")    
	dbCloseArea()
EndIf                                           

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery + cQueryOrd ), "COMS", .T., .T. )

TcSetField("COMS","RECNO"		,"N",10,0)

dbSelectArea( "COMS" )
dbGotop()
COMS->(dbEval({ || nRec++ },,{||!Eof()} ))
dbGoTop()

	If nRec == 0
		dbSelectArea("COMS")
		dbCloseArea()
		Alert("Nenhum Pedido de Compras foi selecionado.","Verifique os parâmetros")
		Return()
	EndIf                                           
//Private oPrint	

lAdjustToLegacy := .F.
lDisableSetup  := .T.

//Função para a impressão do relatorio.
oPrint := FwMsPrinter():New('PEDIDO DE COMPRA', IMP_PDF, .T.,,.T.,,,)
//FWMsPrinter(): New ( < cFilePrintert >, [ nDevice], [ lAdjustToLegacy], [ cPathInServer], [ lDisabeSetup ], [ lTReport], [ @oPrintSetup], [ cPrinter], [ lServer], [ lPDFAsPNG], [ lRaw], [ lViewPDF], [ nQtdCopy] ) --> oPrinter
			//					1				2				3					4				5				6				7			 8		    9		      10		  11		 12		 13		
oPrint:SetPortrait()
oPrint:SetPaperSize(DMPAPER_A4) 

While !COMS->(Eof())
   dbSelectArea("SC7")
   //dbGoto(COMS->REG) 
   _nTotGeral 		:= 0 	//SAMUEL
	_nIpiGeral   	:= 0	//SAMUEL  
	_nFreteGeral	:= 0 	//SAMUEL  
   	
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
	//If MV_PAR08 = 1
	cQuery		+= 		"C7_QUANT QUANT, "+CHR(13)+CHR(10)     
	cQuery		+= 		"C7_PRECO PRCVEN, "+CHR(13)+CHR(10)    
	cQuery		+= 		"C7_UM UM, "+CHR(13)+CHR(10)    
	//Else
	cQuery		+= 		"C7_QTSEGUM  QUANTSG, "+CHR(13)+CHR(10)
	cQuery		+= 		"C7_XPRECO PRCVENSG, "+CHR(13)+CHR(10)
	cQuery		+= 		"C7_SEGUM UMSG, "+CHR(13)+CHR(10)
	//EndIf
	//cQuery		+= 		"CASE WHEN C7_QTSEGUM > 0 THEN C7_QTSEGUM ELSE C7_QUANT END QUANT, "+CHR(13)+CHR(10)
	//cQuery		+= 		"CASE WHEN C7_XPRECO >  0 THEN C7_XPRECO  ELSE C7_PRECO END PRCVEN, "+CHR(13)+CHR(10)
	//cQuery		+= 		"C7_QUANT QUANT, "+CHR(13)+CHR(10)              
	//cQuery		+= 		"C7_PRECO PRCVEN, "+CHR(13)+CHR(10)
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
	cQuery		+= 		"C7_DESCRI C7_DESCRI, "+CHR(13)+CHR(10)
	cQuery		+= 		"B1_XECOORT ECOORTO, C7_CONAPRO C7_CONAPRO "+CHR(13)+CHR(10) //Por samuel Miranda dia 17/04/2020 
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

	MemoWrite("COM.SQL", cQuery + cQueryOrd)
		
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery + cQueryOrd ), "COM", .T., .T. )

	TcSetField("COM","EMISSAO"		,"D", 8,0)
	TcSetField("COM","ENTREGA"		,"D", 8,0)
	TcSetField("COM","QUANT"		,"N",16,2)
	TcSetField("COM","PRECO"		,"N",16,4)
	TcSetField("COM","TOTAL"		,"N",16,4)
	TcSetField("COM","TOTIPI"		,"N",16,2)
  //TcSetField("COM","DESCONTO"	   ,"N",16,2)// SAMUEL
	
	nRec	:= 0

	dbSelectArea( "COM" )
	dbGotop()
	COM->(dbEval({ || nRec++ },,{||!Eof()} ))
	dbGoTop()
	
	If nRec == 0

		dbSelectArea("COM")
		dbCloseArea()
		Alert("Pedido de Compras não contem itens." ,"Verifique !")
	
	Else
	
		dbSelectArea("COM")
		dbGotop()
	
		While !COM->(Eof())
		
			If Len(aCabec)==0
				
				cEmpresa 		:= SM0->M0_NOMECOM
				cEndere			:= Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_BAIRCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" - "+Alltrim(SM0->M0_ESTCOB)+" - "+iif(!Empty(SM0->M0_CEPCOB), "CEP: "+Transform(Alltrim(SM0->M0_CEPCOB),"@R 99999-999") , "" ) 
				cCgc			:= IIF(LEN(ALLTRIM(SM0->M0_CGC))==14, Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),Transform(SM0->M0_CGC,"@R 999.999.999-99") ) 
				cInsc			:= Transform(SM0->M0_INSC,"@R 999.999.999.999")
				cTel		  	:= Transform(SM0->M0_TEL,"@R9999-9999")
				cFax		  	:= Transform(SM0->M0_FAX,"@R9999-9999")			
				c_PED		  	:= PED
				c_END		  	:= Alltrim(ENDER)
				c_Bairro		:= Alltrim(BAIRRO)
				c_MUN			:= Alltrim(MUN)
				c_EST			:= Alltrim(EST)
				c_CEP			:= Transform(Alltrim(CEP),"@R 99999-999") 
				c_TEL			:= Transform(FONE,"@R9999-9999")
		     	c_EMISSAO		:= Substr(DtoS(EMISSAO),7,2)+"/"+Substr(DtoS(EMISSAO),5,2)+"/"+Substr(DtoS(EMISSAO),1,4)
				c_ENTREGA		:= Substr(DtoS(ENTREGA),7,2)+"/"+Substr(DtoS(ENTREGA),5,2)+"/"+Substr(DtoS(ENTREGA),1,4)
				c_FORNECE		:= FORNECE+"-"+LOJA+"/"+NOME
				c_CONTATO		:= CONTATO
				c_DDD	    	:= DDD
				c_CNPJ			:= IIF(LEN(ALLTRIM(CNPJ))==14, Transform(CNPJ,"@R 99.999.999/9999-99"),Transform(CNPJ,"@R 999.999.999-99") )
		  		c_CONDPAG		:= Posicione("SE4",1,xFilial("SE4")+CONDPAG,"E4_DESCRI")
		  		c_MOEDA			:= MOEDA
		  		c_FONE			:= FONE
		  		c_NUMSC			:= NUMSC
		  		c_OBSSC			:= OBSSC
		  		c_OBSPV			:= OBSPV
		  		//c_XCOMPR		:= UsrFullName(XCOMPR)
		  		c_XCOMPR		:= XCOMPR
		  		c_XLOTEOF		:= XLOTEOF
		  		c_XPRODOF		:= XPRODOF
		  		c_XQTDEOF		:= XQTDEOF
		  		c_XUMOF			:= XUMOF
		  		c_XDESCOF		:= XDESCOF
				
				aCabec		:=	{	cEmpresa,;		// aCabec[01]              
	       							cEndere,;	    // aCabec[02]
	       							cCgc,;			// aCabec[03]
	       							cInsc,;     	// aCabec[04]
	       							cTel,;   	    // aCabec[05]
	       							cFax,;          // aCabec[06]
	       							c_PED,;	   		// aCabec[07]
	       							c_END,;			// aCabec[08]
		       						c_BAIRRO,;      // aCabec[09]
		       						c_MUN,;   		// aCabec[10]
		       						c_EST,;         // aCabec[11]
		       						c_CEP,;         // aCabec[12]
		       						c_TEL,;			// aCabec[13]
		       						c_EMISSAO,;    	// aCabec[14]
		       						c_ENTREGA,;     // aCabec[15]
		       						c_FORNECE,;     // aCabec[16]
		       						c_CONTATO,;     // aCabec[17]
		       						c_DDD,;			// aCabec[18]
		       						c_FONE,;        // aCabec[19]
		       						c_CNPJ,;		// aCabec[20]
		       						c_CONDPAG,;		// aCabec[21]
		       						c_MOEDA,;		// acabec[22]
		       						c_NUMSC,;		// aCabec[23]
		       						c_OBSSC,;		// aCabec[24]    
		       						c_OBSPV,;		// aCabec[25]
		       						c_XCOMPR,;		// aCabec[26]
		       						c_XLOTEOF,;		// aCabec[27]
		       						c_XPRODOF,;		// aCabec[28]
		       						c_XQTDEOF,;		// aCabec[29]
		       						c_XUMOF,;		// aCabec[30]
		       						c_XDESCOF}		// aCabec[31]
		       							   
				aItens := {}            
	
		 	EndIf
	   	        
	   		aadd( aItens,	{  	COD,;																												// aItens[01]
	   								Substr(C7_DESCRI,1,45),;  // alterado por samuel miranda de 1,50 para 1,45 (46,20)   dia 06/03/2018        		// aItens[02] 
	   								Substr(C7_DESCRI,46,70),;																						// aItens[03]
	   								Transform(QUANT,"@E 9,999,999.9999"),;																			// aItens[04]
	   								UM,;             // MAURICIO UM																					// aItens[05]
	   								Transform(PRCVEN,"@E 9,999,999.9999"),;																			// aItens[06]
	   								TOTAL,;																											// aItens[07]
	   								XCERTIF,;																										// aItens[08]
	   								TOTIPI,;																										// aItens[09]
	   								Substr(DtoS(ENTREGA),7,2)+"/"+Substr(DtoS(ENTREGA),5,2)+"/"+Substr(DtoS(ENTREGA),1,4),;    //DATA DE ENTREGA	// aItens[10]
	   								XLOTEOF,;																										// aItens[11]
	   								OBSPV,;  																										// aItens[12]
	   								XPRODOF,;																										// aItens[13]
	   								XDESCOF,;																										// aItens[14]
	   								XQTDEOF,;																										// aItens[15]
	   								XUMOF,;  																										// aItens[16]
	   								FRETE,;  																										// aItens[17]
	   								DESPESA,;																										// aItens[18]
	   								DESCONTO,;     																									// aItens[19]
									QUANTSG,;		                    																			// aItens[20]
									UMSG,;																											// aItens[21]
									ECOORTO } ) 																									// aItens[22]
	   								
	   								
			dbSelectArea("COM")
			dbSkip()
	
		EndDo
        
		While Mod(len(aItens),nItPg) > 0

		  	aadd( aItens,	{	" ",;									// aItens[01] CODIGO     
		  						" ",;									// aItens[02] DESCRIÇÃO 35 CARACTERES
		  						" ",;									// aItens[03] DESCRIÇÃO 35 CARACTERES 
		  						" ",;									// aItens[04] QUATIDADE
		  						" ",; 									// aItens[05] UNIDADE DE MEDIA
		  						" ",;									// aItens[06] PREÇO DE VENDA
		  						  0,;									// aItens[07] TOTAL
		  						" ",;									// aItens[08] CERTIDICADO 
		  						  0,;									// aItens[09] VALOR DO IPI
		  						" ",;									// aItens[10] DATA DE ENTREGA
		  						" ",;									// aItens[11] LOTE OF
		  						" ",;									// aItens[12] OBSERVAÇÃO PV
		  						" ",;									// aItens[13] PRODUTO DA OF
		  						" ",;									// aItens[14] DESCRIÇÃO DA OF
		  						  0,;									// aItens[15] QUANTIDADE DA OF
		  						" ",;									// aItens[16] UNIDADE DE MEDIDA DA OF
		  						  0,;									// aItens[17] VALOR FRETE
		  						  0,;									// aItens[18] VALOR DA DESPESA
		  						  0,;									// aItens[19] VALOR DO DESCONTO
								" ",;									// aItens[20] QUANTIDADE DA SEGUNDA UNIDADE DE MEDIDA
								" ",;	  								// aItens[21] SEGUNDA UNIDADE DE MEDIDA
								" "  } )  								// aItens[22] NUMERO DA ECO
		EndDo

        Folhas 	:= Int( len(aItens) / nItPg )
		Folha 	:= 1
		
		For i := 1 to len(aItens) Step nItPg

			aPrtLi	:= {}
				
			For j := 0 to nItPg - 1
					
				aPrtIt	:= {}
					
				For k := 1 to len(aItens[i+j])
						
					aadd(aPrtIt,aItens[i+j,k])
					
				Next k
					
				aadd(aPrtLi,aPrtIt)
				
			Next j
	
			For k := 1 To MV_PAR07
		
				oPrint:StartPage()							// Inicia uma nova página
					Impress(aCabec,aPrtLi,Folha++,Folhas)	// 
				oPrint:EndPage()							// Finaliza a página
		
			Next k
			
		Next i
		//FAZ A IMPRESSÃO DOS DESENHOS 
		//---------------------------------------------------------------------------------//
		// | Auto - Samuel Mirada |	                                                       //
		// Ler o array e imprime os desenhos de cada produto caso ele exita na pasta       //
		//---------------------------------------------------------------------------------//
		For xmp := 1 To len(aItens)
			cProduto := Alltrim(aItens[xmp,1])  //+".jpg"
			//Img :="192.168.0.251\Ortosintese$\Desenhos em PDF\Desenhos JPG\"+Alltrim(aPrtLi[d,1])+".jpg"
			//If FILE(Img) //<> NIL	
			ABmp := "O:\Desenhos em PDF\Desenhos JPG Equipamentos\"+AllTrim(cProduto)+".jpg"
			//ABmp := "C:\"+AllTrim(cProduto)+".jpg"
			If File(aBmp)

				oPrint:StartPage()
				oPrint:Say( 0020,0020,"Imagem do Produto: "+Alltrim(aItens[xmp,1]),oFont14An )
				    //		  Linha,coluna   Largura,altura 
				oPrint:SayBitmap( 0100,0000,aBmp,2400,3000 )
				oPrint:SetPortrait()
				oPrint:EndPage()
			EndIf
		Next xmp 
		
        aCabec	:= {}
	
		dbSelectArea("COM")
		dbCloseArea()

	EndIf

	dbSelectArea("COMS")
	dbSkip()

EndDo

dbSelectArea("COMS")
dbCloseArea()
//Função desabilitada via parametro na função FWSPrinter	
oPrint:Preview()     // Visualiza antes de imprimir
Return()

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Programa  ³ Impress  ³ Autor.³  Samuel Miranda       ³ Data ³ 06/05/21 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição³ Montagem laouyt de impressão                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Ortosintese                                     ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/ 
 
Static Function Impress(aCabec,aPrtLi,Folha,Folhas)

Local i := 0

// Alimenta a variaél com o array aCabec	
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
Local c_TEL			:= aCabec[13]
Local c_EMISSAO		:= aCabec[14]
Local c_ENTREGA		:= aCabec[15]
Local c_FORNECE		:= aCabec[16]
Local c_CONTATO		:= aCabec[17]
Local c_DDD			:= aCabec[18]
Local c_FONE		:= aCabec[19]
Local c_CNPJ		:= aCabec[20]
Local c_CONDPAG		:= aCabec[21]
Local c_MOEDA		:= acabec[22]
Local c_NUMSC		:= aCabec[23]
Local c_OBSSC		:= aCabec[24]    
Local c_OBSPV		:= aCabec[25]
Local c_XCOMPR		:= aCabec[26]
Local c_XLOTEOF		:= aCabec[27]
Local c_XPRODOF		:= aCabec[28]
Local c_XDESCOF		:= aCabec[29]
Local c_XQTDEOF		:= aCabec[30]
Local c_XUMOF		:= aCabec[31]
Local cAprov		:= ""

//Imprimi a quantidade de paginas
Local c_Folha		:= "Folha: "+Alltrim(Str(Folha))+"/"+Alltrim(Str(Folhas))
//Carrega a variavel com o Logotipo.
ABmp := "LGMID01.png"
       
oFont10An		:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12An		:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13A			:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
oFont13An		:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14A			:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14An		:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16An		:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont25An			:= TFont():New("Arial",9,25,.T.,.T.,5,.T.,5,.T.,.F.)

oFont10C			:= TFont():New("Courier New",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11C			:= TFont():New("Courier New",9,11,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10Cn			:= TFont():New("Courier New",9,10,.T.,.T.,5,.T.,5,.T.,.F.)


//Função de cores
//oBrush 	:= TBrush():New(,RGB(192,192,192)) //100,149,237
oBrush  := TBrush():New(, RGB(176,196,222)) //
oBrush0 := TBrush():New(, RGB(173,216,230))
oBrush1 := TBrush():New(, RGB(0,0,0))

      
// ----------------------------------  Contorno do documento
oPrint:box  (0015,0015,2680,2355)//2470) //Box Moldura 
oPrint:Line (0015,0560,0280,0560)// Linha vertical do Logo	

// ----------------------------------  Logotipo
If File(aBmp)
  oPrint:SayBitmap( 0020,0025,ABmp,0500,0240)
EndIf  

oPrint:Say	(0120,0950,"PEDIDO DE COMPRAS",oFont25An )
oPrint:Say	(0120,2170,c_Folha,oFont13An )
oPrint:line (0280,0020,0280,2355)//Linha Horizontal	

oPrint:Say	(0310,0020,cEmpresa,oFont16An )
oPrint:Say	(0310,1850,"Pedido Compra N.:",oFont14An )		;	oPrint:Say	(0310,2200,c_PED,oFont14An )
oPrint:Say	(0340,0020,cEndere,oFont10An )
oPrint:line (0350,0020,0350,2355)//Linha Horizontal	

oPrint:Say	(0385,0020,"TEL:",oFont12An )					;	oPrint:Say	(0385,0150,cTel,oFont12An )
oPrint:Say	(0385,0470,"E-Mail:",oFont12An )				;	oPrint:Say	(0385,0610,"compras@ortosintese.com.br",oFont12An )
oPrint:Say	(0385,1120,"Site:",oFont12An )					;	oPrint:Say	(0385,1220,"www.ortosintese.com.br",oFont12An )
oPrint:Say	(0385,1900,"Emissao:",oFont12An )				;	oPrint:Say	(0385,2070,c_Emissao,oFont12An ) 
oPrint:Say	(0420,0020,"CNPJ:",oFont12An )					;	oPrint:Say	(0420,0150,cCgc,oFont12An )
oPrint:Say	(0420,0470,"INSCR.EST :",oFont12An )			;	oPrint:Say	(0420,0670,cInsc,oFont12An )
oPrint:Say	(0420,1120,"FAX:",oFont12An )					;	oPrint:Say	(0420,1220,cFax,oFont12An ) ////oPrint:line (0440,0020,0440,2355)//Linha Horizontal
oPrint:line (0430,0020,0430,2355)//Linha Horizontal	
                                                

// ----------------------------------  quadro 3  Destinatário -----------------------------------------------------//
oPrint:FillRect({0435,0020,0470,2350},oBrush)  //Imprime uma tarja 
oPrint:Say	(0465,0950,"DADOS DO FORNECEDOR",oFont14An )
oPrint:line (0475,0015,0475,2355)// Linha Horizontal	
oPrint:Say	(0505,0020,"FORNECEDOR:",oFont14An )	   				;	oPrint:Say	(0505,0350,c_FORNECE,oFont14A )
oPrint:Say	(0505,1500,"CNPJ:",oFont14An )			   				;	oPrint:Say	(0505,1650,c_CNPJ,oFont14A )
oPrint:line (0515,0020,0515,2355)//Linha Horizontal	 

oPrint:Say	(0545,0020,"ENDEREÇO:",oFont14An )	   					;	oPrint:Say	(0545,0350,c_END,oFont14A )
oPrint:Say	(0545,1500,"BAIRRO:",oFont14An )		   				;	oPrint:Say	(0545,1660,c_BAIRRO,oFont14A )
oPrint:line (0555,0020,0555,2355)//Linha Horizontal	 

oPrint:Say	(0585,0020,"CIDADE:",oFont14An )		   				;	oPrint:Say	(0585,0350,c_MUN,oFont14A )
oPrint:Say	(0585,1500,"ESTADO:",oFont14An )		   				;	oPrint:Say	(0585,1670,c_EST,oFont14A )
oPrint:Say	(0585,1800,"C.E.P:",oFont14An )		   					;	oPrint:Say	(0585,1920,c_CEP,oFont14A )
oPrint:line (0595,0020,0595,2355)//Linha Horizontal	

oPrint:Say	(0625,0020,"CONTATO:",oFont14An )		   				;	oPrint:Say	(0625,0350,c_Contato,oFont14A )
oPrint:Say	(0625,1500,"FONE:",oFont14An )		   					;	oPrint:Say	(0625,1650,c_Ddd +" -  "+c_Fone ,oFont14A ) //;	oPrint:Say	(0625,1750,c_Fone,oFont14A )
oPrint:line (0635,0020,0635,2355)//Linha Horizontal		
oPrint:Say	(0665,0020,"MOEDA...:",oFont14An )				   		
oPrint:line (0675,0020,0675,2355)//Linha Horizontal	
oPrint:Line (0475,1490,0635,1490) // Linha vertical	

//Imprime a Moeda conforme parametro.
If c_MOEDA == 1
		oPrint:Say	(0665,0350,"REAL",oFont14A )
	ElseIf c_MOEDA == 2
		oPrint:Say	(0665,0350,"DOLAR",oFont14A )
	ElseIf c_MOEDA == 3
		oPrint:Say	(0665,0350,"UFIR",oFont14A ) 
	ElseIf c_MOEDA == 4
		oPrint:Say	(0665,0350,"EURO",oFont14A ) 
	ElseIf c_MOEDA == 5
		oPrint:Say	(0665,0350,"IENE",oFont14A ) 
EndIf
oPrint:FillRect({0680,0020,0715,2350},oBrush)  //Imprime uma tarja 
oPrint:Say	(0705,0950,"DADOS DO PEDIDO",oFont14An )
oPrint:line (0715,0020,0715,2355)//Linha Horizontal	

// ----------------------------------  quadro 4  Cabec Itens 

oPrint:Line (0715,1230,0800,1230)// Linha vertical
oPrint:Say	(0750,1300,OEMTOANSI("1ª UNID."),oFont13An )
oPrint:Line (0715,1480,0800,1480)// Linha vertical  		//oPrint:Say	(0860,1620,"UNID.",oFont8An ) // MAURICIO UM
oPrint:Say	(0750,1540,OEMTOANSI("2ª UNID."),oFont13An )
oPrint:line (0760,0020,0760,2355)//Linha Horizontal	

oPrint:Say	(0790,0030,"PRODUTO",oFont13An )
oPrint:Line (0760,0265,0800,0265)// Linha vertical

oPrint:Say	(0790,0350,"DESCRIÇÃO DO PRODUTO",oFont13An ) //SAMUEL DIA 29/11/2017 LTERADO PARA 0280
oPrint:Line (0760,1040,0800,1040)// Linha vertical

oPrint:Say	(0790,1100,"ECO",oFont13An )
oPrint:Say	(0790,1270,"QTD",oFont13An ) //Primeira unidade
oPrint:Say	(0790,1420,"UN",oFont13An ) 	
oPrint:Say	(0790,1510,"QTD",oFont14An )//segunda unidadea
oPrint:Say	(0790,1650,"UN",oFont13An ) 

oPrint:Line (0715,1710,0800,1710)// Linha vertical  

oPrint:Say	(0790,1720,"UT 1ª UNID",oFont13An )
oPrint:Line (0760,1890,0800,1890)// Linha vertical 

oPrint:Say	(0790,1920,"$ TOTAL",oFont13An )
oPrint:Line (0760,2090,0800,2090)// Linha vertical

oPrint:Say	(0790,2090,"CERT.",oFont13An )    		
oPrint:Say	(0790,2200,"ENT. ATÉ",oFont13An )  
oPrint:Line (0760,2180,0800,2180)// Linha vertical       
oPrint:line (0800,0020,0800,2355)// Linha Horizontal  

// ----------------------------------  quadro 5  Detalhe dos Itens ---------------------------------- //
_Li := 0800

_nTotal 		:= 0 
_nIpi   		:= 0
_nFrete 		:= 0
_nDespesa 		:= 0
_nDesconto  	:= 0  //SAMUEL DIA 29/11/2017
_nTotalDescto   := 0  //
_nSalto			:= 0
//_nTotGeral 		:= 0 	//SAMUEL
//_nIpiGeral   		:= 0	//SAMUEL  
//_nFreteGeral		:= 0 	//SAMUEL  

For i := 1 to len(aPrtLi)  

	_Li		+= 30
	_nSalto	+= 75

	oPrint:Say	(_Li,0030,aPrtLi[i,1], oFont10C )	// PRODUTO
	oPrint:Say	(_Li,0280,aPrtLi[i,2], oFont10C )	// DESCRICAO ATE 35 CARACTERES
	
	oPrint:Say	(_Li,1060,aPrtLi[i,22], oFont10C ) //ECO ORTOSINTESE
	
	oPrint:Say	(_Li,1150,aPrtLi[i,4], oFont10C )	// QUANT 1ª
	oPrint:Say	(_Li,1420,aPrtLi[i,5], oFont10C )	// UM
	//oPrint:Say	(_Li,1520,aPrtLi[i,20], oFont10C )
	If !Empty(aPrtLi[i,1])
		oPrint:Say	(_Li,1495,Transform(aPrtLi[i,20],"@E 9999.999"), oFont10C )	// QUANT 2ª
	EndIf
	oPrint:Say	(_Li,1655,aPrtLi[i,21], oFont10C )	// UM
	
	oPrint:Say	(_Li,1650,aPrtLi[i,6], oFont10C )	// PRCVEN
	If aPrtLi[i,7] > 0 
		oPrint:Say	(_Li,1825,Transform(aPrtLi[i,7],"@E 999,999,999.99"),oFont10C )	// PRECO TOTAL  MUDADO PARA 1000
	Endif
	oPrint:Say	(_Li,2110,aPrtLi[i,8], oFont10C )	// NÚEMRO DO CERTIFICADO
	oPrint:Say	(_Li,2190,aPrtLi[i,10], oFont10C )	// ENTREGA
	
   	_Li	+= 40 //Iprime na linha abaixo
		oPrint:Say	(_Li-15,0300,aPrtLi[i,3], oFont10C )	// DESCRICAO DO 36 A0 70 CARACTERES
		oPrint:Say	(_Li-15,0720,aPrtLi[i,11], oFont10C )	// XLOTEOF
		//_Li	+= 30       (2660,0160,
	oPrint:Say	(_Li - 15,0800,aPrtLi[i,12], oFont10C )		// OBERVAÇÃO DO PEDIDO.

	If !Empty(SC7->C7_XLOTEOF)
	  	_Li	+= 30	
		oPrint:Say	(_Li - 15,0500,aPrtLi[i,13], oFont10C )	// XPRODOF
		oPrint:Say	(_Li - 15,0700,aPrtLi[i,14], oFont10C )	// XDESCOF
		If aPrtLi[i,15] > 0
		oPrint:Say	(_Li - 15,1350,Transform(aPrtLi[i,15],"@E 9999"),oFont10C )	// XQTDEOF
		EndIf
		oPrint:Say	(_Li - 15,1550,aPrtLi[i,16], oFont10C )	// XUMOF   
	EndIf
			
	_nTotal 	+= aPrtLi[i,7]
	_nFrete 	+= aPrtLi[i,17]
	_nDespesa 	+= aPrtLi[i,18]	 
	_nDesconto 	+= aPrtLi[i,19]   	
	
	If aPrtLi[i,9] > 0
		_nIpi   += aPrtLi[i,9]
	EndIf
 
    _Li	-= 30
    
	//Imprimi as linhas vertical na grid.
	if !empty(aPrtLi[i,1])
		IF i <> 16
			oPrint:Line (0800,0265,_nSalto+0795,0265)// Linha vertical descrição
			oPrint:Line (0800,1040,_nSalto+0795,1040)// Linha vertical - Coluna ECO
			oPrint:Line (0800,1230,_nSalto+0795,1230)// Linha vertical - Coluna 1ª UNIDADE
			oPrint:Line (0800,1480,_nSalto+0795,1480)// Linha vertical - Coluna do meio da 1ª e 2ª
			oPrint:Line (0800,1710,_nSalto+0795,1710)// Linha vertical - Coluna 2ª UNIDADE
			oPrint:Line (0800,1890,_nSalto+0795,1890)// Linha vertical - Culuna Total 1ª Unidade
			oPrint:Line (0800,2090,_nSalto+0795,2090)// Linha vertical - Culuna Certificado
			oPrint:Line (0800,2180,_nSalto+0795,2180)// Linha vertical - Culuna Data de Entrega
		EndIf	
			_Li	+= 30
			//oPrint:Say	(_Li,0020,replicate("--",85))   
			oPrint:line (_Li,0020,_Li,2355)//Linha Vertical	
			If !Empty(aPrtLi[i,3])
				oPrint:Line (_Li,0265,0795,0265)// Linha vertical descrição
				oPrint:Line (_Li,1040,0795,1040)// Linha vertical - Coluna ECO
				oPrint:Line (_Li,1230,0795,1230)// Linha vertical - Coluna 1ª UNIDADE
				oPrint:Line (_Li,1480,0795,1480)// Linha vertical - Coluna do meio da 1ª e 2ª
				oPrint:Line (_Li,1710,0795,1710)// Linha vertical - Coluna 2ª UNIDADE
				oPrint:Line (_Li,1890,0795,1890)// Linha vertical - Culuna Total 1ª Unidade
				oPrint:Line (_Li,2090,0795,2090)// Linha vertical - Culuna Certificado
				oPrint:Line (_Li,2180,0795,2180)// Linha vertical - Culuna Data de Entrega
			EndIf
			oPrint:line (_Li,0020,_Li,2355)//Linha Horizontal
		
	EndIf

Next i

_nTotGeral 		+= _nTotal 	//Atualiza a variavel total
_nIpiGeral   	+= _nIpi 	//Atualiza a variavel nIpi
_nFreteGeral	+= _nFrete	//Atualiza a variavel Frete
_nTotalDescto   += _nDesconto

// ---------------------------------- Rodapé da pagina---------------------------------- //
//oPrint:line (2180,0020,2180,2355)//Linha Horizontal	
//oPrint:Say	(2210,0020,"RC:",oFont13An )		   					;	oPrint:Say	(2210,0120,c_NUMSC,oFont13A )    
//oPrint:Say	(2260,0020,"MATERIAL SUJEITO A INSPECAO",oFont13An )
//
//oPrint:Say	(2330,0020,"FORNECEDORES QUE UTILIZAM SUBSTITUICAO TRIBUTARIA DE ICMS, FAVOR CONSTAR NAS NFS O VALOR DA ALIQUOTA ",oFont13An )
//oPrint:Say	(2380,0020,"E BASE DE CALCULO DO ICMS OPTANTES PELO SIMPLES NACIONAL, FAVOR DESTACAR ALIQUOTA DO ICMS NA NOTA FISCAL",oFont13An )
//oPrint:line (2440,0020,2440,2355)//Linha Horizontal	

//oPrint:Say	(2005,0040,"PREZADOS PARCEIROS, FORNECEDORES E PRESTADORES DE SERVIÇOS, GOSTARÍAMOS DE INFORMAR, QUE NO PERÍODO DE 22 DE DEZEMBRO DE 2023 À 07 DE JANEIRO DE 2024",oFont10An )	
//oPrint:Say	(2045,0050,+Space(05)+"OS RECEBIMENTOS DE MATERIAIS PRODUTIVOS, IMPRODUTIVOS E SERVIÇOS ESTARÃO SUSPENSOS. CASOS EXTREMAMENTE NECESSÁRIOS, SERÃO INFORMADOS E   ",oFont10An )	
//oPrint:Say	(2085,0050,+Space(10)+" AGENDADOS COM OS PARCEIROS.A RETOMADA DOS RECEBIMENTOS SERÃO À PARTIR DO DIA 08 DE JANEIRO DE 2024.DESEJAMOS A TODOS EXCELENTES FESTAS.",oFont10An )	
oPrint:line(2100,0020,2100,2355)//Linha Horizontal
oPrint:Say(2130,0020,"RC:",oFont13An)		   					;	oPrint:Say(2130,0115,c_NUMSC,oFont13A)

oPrint:Say(2170,0020,"HORARIO DE RECEBIMENTO: ",oFont12An)
oPrint:Say(2200,0020,"        SEGUNDAS AS QUINTAS-FEIRAS - HORÁRIO DE RECEBIMENTO DAS 07:15 AS 11:30 E DAS 13:00 AS 16:30, FORA DESSE HORÁRIO SOMENTE SERÁ RECEBIDO NO DIA SEGUINTE.",oFont10An )
oPrint:Say(2230,0020,"                    SEXTAS-FEIRAS - HORÁRIO DE RECEBIMENTO DAS 07:15 AS 11:30 E DAS 13:00 AS 15:30, FORA DESSE HORÁRIO SOMENTE SERÁ RECEBIDO NO DIA SEGUINTE.",oFont10An )

oPrint:Say(2325,0020,"MATERIAL SUJEITO A INSPEÇÃO",oFont12An)
oPrint:Say(2360,0020,"                                FORNECEDORES QUE UTILIZAM SUBSTITUICAO TRIBUTARIA DE ICMS, FAVOR CONSTAR NAS NFS O VALOR DA ALIQUOTA E BASE DE CALCULO DO ",oFont10An )
oPrint:Say(2395,0020,"                                                         ICMS OPTANTES PELO SIMPLES NACIONAL, FAVOR DESTACAR ALIQUOTA DO ICMS NA NOTA FISCAL",oFont10An)
oPrint:line(2440,0020,2440,2355)//Linha Horizontal
 
oPrint:Say	(2470,0020,"Condicoes e Forma ",oFont13An)		   		; oPrint:Say(2520,0340,c_Condpag,oFont13A) 
oPrint:Say	(2520,0020,"De Pagamento :",oFont13An)
oPrint:Say	(2560,0020,"Observ. P.C :",oFont13An) 					; oPrint:Say(2600,0020,c_Obssc,oFont11C)   

oPrint:Say	(2470,1400,"PRODUTOS ",oFont13An) 						; oPrint:Say(2470,2100,Transform(_nTotal,"@E 999,999,999.99"),oFont13A)
oPrint:line (2480,1350,2480,2355)//Linha Horizontal	
oPrint:Say	(2520,1400,"DESCONTO               - ",oFont13An) 		; oPrint:Say(2520,2100,Transform(_nDesconto,"@E 999,999,999.99"),oFont13A)
oPrint:line (2530,0020,2530,2355)//Linha Horizontal	
oPrint:Line (2440,1350,2700,1350)// Linha vertical	
oPrint:Say	(2560,1400,"IPI"      			   ,oFont13An )			; oPrint:Say(2560,2100,Transform(_nIpi,"@E 999,999,999.99"),oFont13A )
oPrint:line (2570,1350,2570,2355)//Linha Horizontal	
oPrint:Say	(2610,1400,"FRETE / DESPESA"        ,oFont13An )		; oPrint:Say(2610,2100,Transform(_nFrete+_nDespesa,"@E 999,999,999.99"),oFont13A )    
oPrint:line (2620,1350,2620,2355)//Linha Horizontal	

 if Folha = Folhas
 	oPrint:Say	(2660,1400,"TOTAL PEDIDO"      ,oFont13An )     	; oPrint:Say(2660,2100,Transform(_nTotGeral+_nIpi+_nFrete+_nDespesa-_nTotalDescto,"@E 999,999,999.99"),oFont13A ) 	
 Endif 

oPrint:Say	(2705,0020,"O NUMERO DESTE PEDIDO DEVE CONSTAR EM SUA NOTA FISCAL O FORNECEDOR AO ACEITAR ESTE PEDIDO COMPREMETE-SE EM NFORMAR-NOS SOBRE QUALQUER ALTERACAO QUE VENHA",oFont10Cn )
oPrint:Say	(2740,0020,"      A OCORRER NOS PRODUTOS OU SERVICOS FORNECIDOS. NOS CASOS EM QUE CONSTAR A REVISAO DO DESENHO NA DESCRICAO CONFIRMAR SE POSSUI A ATUALIZADOS",oFont10Cn )
oPrint:Say	(2775,0020,"                   OS ARQUIVOS XML DEVEM SER ENVIADOS PARA NFE@ORTOSINTESE.COM.BR.NÃO RECEBEREMOS NFS EMITIDAS A MAIS DE 05 DIAS.",oFont10Cn )     

oPrint:box  (2860,0020,2860,0500) //linha da data do pedido
oPrint:box  (2860,0750,2860,1330) //linha dc Comprador
oPrint:box  (2860,1550,2860,2250) //Linha do aprovador
oPrint:Say	(2890,0150,"Data do Pedido :",oFont13An )			;	oPrint:Say	(2855,0175,c_Emissao,oFont13An)


//APROVACAO
dbSelectArea("SCR")
dbSetOrder(1)
If(dbSeek(xFilial("SCR")+"PC"+c_PED))
	cAprov += AllTrim(UsrFullName(SCR->CR_USERLIB))
Endif

oPrint:Say	(2855,0850,UPPER(c_XCOMPR),oFont13An )				; oPrint:Say	(2855,1700,UPPER(cAprov),oFont13An)

oPrint:Say	(2890,0900,"Comprado Por :",oFont13An )				; oPrint:Say	(2890,1750,"Aprovado Por:",oFont13An)


oPrint:Say	(3010,1500,"A1 06-02 Rev01",oFont13An ) // Apedido daColaboradora Debora Luna conforme chamando 14010 ( Samuel Miranda 16/11/2021)

If Folha <> Folhas
	oPrint:Say	(3030,0060,"Continua na próxima folha",oFont13An )
Else
EndIf
oPrint:Say	(3030,2145,"By TI Ortosintese ",oFont13An )

Return    

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Função    ValidPerg   ³ Rev.  ³ Samuel Miranda	     ³ Data ³ 06/05/21³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descrição ³ Cria os perguntes caso ele não exetam 		              ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function ValidPerg()
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i,j
Local nTamSX1	:= Len(SX1->X1_GRUPO)
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 			:= PADR("RCOMR07",nTamSX1)

Aadd(aRegs,{cPerg,"01","Fornecedor de !"	,"CFornecedor de !"		,"Fornecedor de !"		,"mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
Aadd(aRegs,{cPerg,"02","Fornecedor Ate !"	,"Fornecedor ate !"		,"Fornecedor ate !"		,"mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
Aadd(aRegs,{cPerg,"03","Emissao de !"		,"Emissao de !"			,"Emissao de !"			,"mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
Aadd(aRegs,{cPerg,"04","Emissao Ate !"		,"Emissao ate !"		,"Emissao ate !"		,"mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
Aadd(aRegs,{cPerg,"05","Pedido de !"		,"Pedido de !"			,"Pedido de !"			,"mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","",""})
Aadd(aRegs,{cPerg,"06","Pedido Ate !"		,"Pedido ate !"			,"Pedido ate !"			,"mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","",""})
Aadd(aRegs,{cPerg,"07","Numero de Copias !"	,"Numero de Copias !"	,"Numero de Copias !"	,"mv_ch7","N",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})


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

dbSelectArea(_sAlias)

Return()
