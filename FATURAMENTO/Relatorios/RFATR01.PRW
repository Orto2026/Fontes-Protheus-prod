#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"    
         
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR01  ³ Rivis.³ Samuel Miranda	     ³ Data ³ 04/12/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Orçamento 											     				  ³±±
±±³          ³ 										                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/              
User Function RFATR01()

Private cPerg	:= "ORC       "
Private nItPg	:= 28 //28
Private aMes	:= {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
Private lPreVale:= .f.
Private lValido	:= .t.
CriaSX1(cPerg)                                                   '

Pergunte(cPerg,.T.)

Processa({|| MontaOrc()})

Return Nil     

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR01  ³ Rivis.³ Samuel Miranda	     ³ Data ³ 04/12/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Montagem do Orçamento                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Ortosintese                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/              
Static Function MontaOrc()
Local cQuery		:= ""
Local cQueryOrd		:= ""
Local nRec			:= 0
Local aPrtLi		:= {}
Local aPrtLi		:= {}
Local aPrtIt		:= {}
Local aCabec		:= {}
Local Folha 		:= 0
Local Folhas 		:= 0
Local i				:= 0
Local j				:= 0
Local k				:= 0
_nTotGeral 			:= 0 //SAMUEL
_nIpiGeral   		:= 0 //SAMUEL
_nPesoGeral			:= 0
_nIcmGeral			:= 0
PRIVATE oPrint


cQuery		:= "SELECT "+CHR(13)+CHR(10)
cQuery		+= 		"DISTINCT(SCJ.R_E_C_N_O_ ) REG "+CHR(13)+CHR(10)
cQuery		+= "FROM  "+CHR(13)+CHR(10)
cQuery		+= 		RetSqlName("SCJ")+" SCJ "+CHR(13)+CHR(10)
cQuery		+= "WHERE  "+CHR(13)+CHR(10)
cQuery		+= 		"SCJ.D_E_L_E_T_ = ' ' AND "+CHR(13)+CHR(10) 
cQuery		+= 		"SCJ.CJ_FILIAL = '"+cFilAnt+"' AND "+CHR(13)+CHR(10)
cQuery		+= 		"SCJ.CJ_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "+CHR(13)+CHR(10)
cQuery		+= 		"SCJ.CJ_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "+CHR(13)+CHR(10)
cQuery		+= 		"SCJ.CJ_CLIENT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "+CHR(13)+CHR(10)
cQuery		+= 		"SCJ.CJ_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "+CHR(13)+CHR(10)
cQueryOrd	+= "ORDER BY "+CHR(13)+CHR(10)
cQueryOrd	+= 	"1 "+CHR(13)+CHR(10)

MemoWrite("ORCS.SQL", cQuery + cQueryOrd)

If Select("ORCS") > 0
	dbSelectArea("ORCS")    
	dbCloseArea()
EndIf                                           

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery + cQueryOrd ), "ORCS", .T., .T. )

TcSetField("ORCS","RECNO"		,"N",10,0)

dbSelectArea( "ORCS" )
dbGotop()
ORCS->(dbEval({ || nRec++ },,{||!Eof()} ))
dbGoTop()

If nRec == 0

	dbSelectArea("ORCS")
	dbCloseArea()
	Alert("Nenhum Orçamento foi selecionado.","Verifique os parâmetros")
	Return()

EndIf                                           
	
oPrint:= TMSPrinter():New( "Orçamento" )
oPrint:SetPortrait()

While !ORCS->(Eof())
dbSelectArea("SCJ")
   dbGoto(ORCS->REG)

	cQuery		:= "SELECT "+CHR(13)+CHR(10)
	cQuery		+= 		"CJ_NUM ORC, "+CHR(13)+CHR(10)
	cQuery		+= 		"CJ_EMISSAO EMISSAO, "+CHR(13)+CHR(10)
	cQuery		+= 		"CJ_CONDPAG CONDPAG, "+CHR(13)+CHR(10)
	cQuery		+= 		"CJ_FRETE FRETE, "+CHR(13)+CHR(10)
	cQuery		+= 		"CJ_XDTENTR ENTREGA, "+CHR(13)+CHR(10)
	cQuery		+= 		"CK_PRODUTO COD, "+CHR(13)+CHR(10)
	cQuery		+= 		"CK_UM UM, "+CHR(13)+CHR(10)
	cQuery		+= 		"CK_QTDVEN QUANT, "+CHR(13)+CHR(10)
	cQuery		+= 		"CK_PRCVEN PRCVEN, "+CHR(13)+CHR(10)
	cQuery		+= 		"CK_VALOR VALOR, "+CHR(13)+CHR(10)
	cQuery		+= 		"CK_ENTREG ENTREGA1, "+CHR(13)+CHR(10)
	cQuery		+= 		"A1_COD CLIENTE, "+CHR(13)+CHR(10)
	cQuery		+= 		"A1_LOJA LOJA, "+CHR(13)+CHR(10)
	cQuery		+= 		"A1_NOME NOME, "+CHR(13)+CHR(10)
	cQuery		+= 		"A1_CONTATO CONTATO, "+CHR(13)+CHR(10)
	cQuery		+= 		"A1_CGC CNPJ, "+CHR(13)+CHR(10)
	cQuery		+= 		"A1_END ENDER, "+CHR(13)+CHR(10)
	cQuery		+= 		"A1_BAIRRO BAIRRO, "+CHR(13)+CHR(10)
	cQuery		+= 		"A1_MUN MUN, "+CHR(13)+CHR(10)
	cQuery		+= 		"A1_EST EST, "+CHR(13)+CHR(10)
	cQuery		+= 		"A1_CEP CEP, "+CHR(13)+CHR(10)
	cQuery		+= 		"A1_DDD DDD, "+CHR(13)+CHR(10)
	cQuery		+= 		"A1_TEL TEL, "+CHR(13)+CHR(10)
	cQuery		+= 		"A1_FAX FAX, "+CHR(13)+CHR(10)
	cQuery		+= 		"B1_IPI IPI, "+CHR(13)+CHR(10)
	cQuery		+= 		"CK_VALOR*B1_IPI/100  TOTIPI, "+CHR(13)+CHR(10) 
	cQuery		+= 		"B1_DESC B1_DESC, "+CHR(13)+CHR(10)
	//Por inicio Para pegar o número do registro Samuel Miranda
	cQuery		+= "CASE WHEN B1_XANVEMP ='' THEN '' "+CHR(13)+CHR(10)
	cQuery		+= "WHEN B1_XANVEMP = '1' AND B1_XANVISA <>'' AND B1_TIPO='PA' THEN '1022371'+B1_XANVISA "+CHR(13)+CHR(10)
	cQuery		+= "WHEN B1_XANVEMP = '2' AND B1_XANVISA <>'' AND B1_TIPO='PA' THEN '8120219'+B1_XANVISA "+CHR(13)+CHR(10)
	cQuery		+= "END  ANVISA  "+CHR(13)+CHR(10)
	//Por Final Samuel Miranda	
	cQuery		+= "FROM "+CHR(13)+CHR(10)
	cQuery		+= 		RetSqlName("SCJ")+" SCJ "+CHR(13)+CHR(10)
	cQuery		+= 		"INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = CJ_CLIENTE AND A1_LOJA = CJ_LOJA AND SA1.D_E_L_E_T_ = ''" +CHR(13)+CHR(10)
	cQuery		+= 		"INNER JOIN " + RetSqlName("SCK") + " SCK ON CK_FILIAL = CJ_FILIAL AND CK_NUM = CJ_NUM AND CK_CLIENTE = CJ_CLIENTE AND CK_LOJA = CJ_LOJA AND SCK.D_E_L_E_T_ = '' " +CHR(13)+CHR(10)
	cQuery		+= 		"INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = CK_PRODUTO AND SB1.D_E_L_E_T_ = '' " +CHR(13)+CHR(10)
	cQuery		+= "WHERE "+CHR(13)+CHR(10)
	cQuery		+= 		"SCJ.R_E_C_N_O_ = "+alltrim(str(ORCS->REG))+" AND "+CHR(13)+CHR(10)
	cQuery		+= 		"SCJ.D_E_L_E_T_ = ' ' " +CHR(13)+CHR(10)
	cQueryORD	:= "ORDER BY "+CHR(13)+CHR(10)
	cQueryORD	+= 		"SCK.CK_NUM, "+CHR(13)+CHR(10)
	cQueryORD	+= 		"SCK.CK_ITEM "+CHR(13)+CHR(10)
	
	MemoWrite("ORC.SQL", cQuery + cQueryOrd)
		
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery + cQueryOrd ), "ORC", .T., .T. )

	TcSetField("ORC","EMISSAO"		,"D", 8,0)
	TcSetField("ORC","QTDVEN"		,"N",16,2)
	TcSetField("ORC","PRCVEN"		,"N",16,2)
	TcSetField("ORC","VALOR"		,"N",16,2)
	TcSetField("ORC","IPI"			,"N",16,2)
	TcSetField("ORC","TOTIPI"		,"N",16,2)
	TcSetField("ORC","FRETE"		,"N",16,2)
	TcSetField("ORC","ENTREGA1"		,"D", 8,0)
	
	nRec	:= 0

	dbSelectArea( "ORC" )
	dbGotop()
	ORC->(dbEval({ || nRec++ },,{||!Eof()} ))
	dbGoTop()
	
	If nRec == 0
	
		dbSelectArea("ORC")
		dbCloseArea()
		Alert("Orçamento não contem itens." ,"Verifique !")
	
	Else
	
		dbSelectArea("ORC")
		dbGotop()
	
		While !ORC->(Eof())
		
			If Len(aCabec)==0
				
				c_LOCDATA	:= dToc(EMISSAO) //(DTOS(EMISSAO))   //Alltrim(SM0->M0_CIDCOB)+", "+StrZero(Day(EMISSAO),2)+" de "+aMes[Month(EMISSAO)]+" de "+Left(DTOS(EMISSAO),4)
				cEmpresa 	:= SM0->M0_NOMECOM
				c_ORC		:= ORC
				c_CLIENTE	:= CLIENTE+"-"+LOJA+"/"+NOME
				c_CONTATO	:= CONTATO
				c_DDD	    := DDD
				c_TEL		:= Transform(TEL,"@R9999-9999")
				c_FAX		:= Transform(FAX,"@R9999-9999")
				c_CNPJ		:= IIF(LEN(ALLTRIM(CNPJ))==14, Transform(CNPJ,"@R 99.999.999/9999-99"),Transform(CNPJ,"@R 999.999.999-99") )
		  		c_END		:= Alltrim(ENDER) //+" "+Alltrim(BAIRRO)
		        c_MUN		:= Alltrim(MUN)+" / "+Alltrim(EST)//+" "+iif(!Empty(CEP), "CEP: "+Transform(Alltrim(CEP),"@R 99999-999") , "" )
				c_CONDPAG	:= Posicione("SE4",1,xFilial("SE4")+CONDPAG,"E4_DESCRI")
				c_ENTREGA	:= Substr(DtoS(SCJ->CJ_XDTENTR),7,2)+"/"+Substr(DtoS(SCJ->CJ_XDTENTR),5,2)+"/"+Substr(DtoS(SCJ->CJ_XDTENTR),1,4)
				c_Frete		:= SCJ->CJ_FRETE
				 
	    	    aCabec		:=	{	c_LocData,;		// 1
	       							c_Orc,;	 		// 2
	       							c_Cliente,;		// 3
	       							c_Contato,;		// 4
	       							c_Ddd,;        // 5
	       							c_Tel,;        // 6
	       							c_Fax,;        // 7
	       							c_CNPJ,;		   // 8
	       							c_End,;			// 9
	       							c_Mun,;			// 10
		       						c_CondPag,;    // 11
		       						c_Entrega,;		// 12
	       							c_Frete }	   // 13
				aItens := {}            
	
		 	EndIf
		        
	   		aadd( aItens,	{	COD,;  														//01
	   							B1_DESC,;										  				//02
	   							UM,;																//03
	   							Transform(QUANT,"@E 9999.99"),;         				//04
	   							Transform(PRCVEN,"@E 9,999,999.99"),;					//05
	   							Transform(IPI,"@E 9999"),;									//06
	   							TOTIPI,;															//07
	   							VALOR,;//Transform(VALOR,"@E 999,999,999.99")} )	//08
	   							dToc(ENTREGA1),;												//09
	   							ANVISA } )														//10				
				
			dbSelectArea("ORC")
			dbSkip()
	
		EndDo
        
		While Mod(len(aItens),nItPg) > 0

		  	aadd( aItens,	{	" ",;
		  						" ",;
		  						" ",;
		  						" ",;
		  						" ",;
		  						" ",;
		  						0 ,;
		  						0 ,;
		  						" ",;
		  						" " } )		
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
				Impress(aCabec,aPrtLi,Folha++,Folhas)	// Vale
				oPrint:EndPage()								// Finaliza a página
		
			Next k
			
		Next i
	    
        aCabec	:= {}
	
		dbSelectArea("ORC")
		dbCloseArea()

	EndIf

	dbSelectArea("ORCS")
	dbSkip()

EndDo

dbSelectArea("ORCS")
dbCloseArea()
	
oPrint:Preview()     // Visualiza antes de imprimir

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR01  ³ Rivis.³ Samuel Miranda	     ³ Data ³ 04/12/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Função para impressão do Relatório                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Construtora OAS Ltda                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
Static Function Impress(aCabec,aPrtLi,Folha,Folhas)
Local oFont8A
Local oFont8An
Local oFont9A
Local oFont9An
Local oFont10A
Local oFont10An
Local oFont12A
Local oFont12An
Local oFont13A
Local oFont13An
Local oFont14A
Local oFont14An
Local oFont20A
Local oFont20An
Local oFont10C
Local oFont10Cn
Local oFont9C
Local oFont9Cn
Local oFont8C
Local oFont8Cn
Local i 
	
Local c_LOCDATA		:= aCabec[01]
Local c_ORC			:= aCabec[02]
Local c_CLIENTE		:= aCabec[03]
Local c_CONTATO		:= aCabec[04]
Local c_DDD			:= aCabec[05]
Local c_TEL			:= aCabec[06]
Local c_FAX			:= aCabec[07]
Local c_CNPJ		:= aCabec[08]
Local c_END			:= aCabec[09]
Local c_MUN			:= aCabec[10]
Local c_CONDPAG		:= aCabec[11]
Local c_ENTREGA		:= aCabec[12]          
Local c_FRETE		:= aCabec[13]

Local c_Folha		:= "Folha: "+Alltrim(Str(Folha))+"/"+Alltrim(Str(Folhas))
//ABmp := "VALE_"+AllTrim(cEmpAnt)+".JPEG"
//ABmp := "VALE_04.bmp"
ABmp := "LGMID01.png"     
        
oFont6A		:= TFont():New("Arial",9,6 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont6An		:= TFont():New("Arial",9,6 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont7A		:= TFont():New("Arial",9,6 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7An		:= TFont():New("Arial",9,6 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8A		:= TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8An		:= TFont():New("Arial",9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9A		:= TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9An		:= TFont():New("Arial",9,9 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10A		:= TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10An	:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12A		:= TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oFont12An	:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13A		:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
oFont13An	:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14A		:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14An	:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20A		:= TFont():New("Arial",9,20,.T.,.F.,5,.T.,5,.T.,.F.)
oFont20An	:= TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)

oFont50An	:= TFont():New("Arial",18,50,.T.,.T.,5,.T.,5,.T.,.F.)
oFont6C		:= TFont():New("Courier New",9, 6,.T.,.F.,5,.T.,5,.T.,.F.)
oFont6Cn		:= TFont():New("Courier New",9, 6,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8C		:= TFont():New("Courier New",7, 8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8Cn		:= TFont():New("Courier New",7, 8,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10C		:= TFont():New("Courier New",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10Cn	:= TFont():New("Courier New",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9C		:= TFont():New("Courier New",9, 9,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9Cn		:= TFont():New("Courier New",9, 9,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8C		:= TFont():New("Courier New",9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8Cn		:= TFont():New("Courier New",9, 8,.T.,.T.,5,.T.,5,.T.,.F.)

oBrush := TBrush():New("",4)

// ----------------------------------  Logotipo
If File(aBmp)
  //oPrint:SayBitmap( 0000,0000,aBmp,2370,0700 )
  //oPrint:SayBitmap( 0060,0060,aBmp,0700,0080 )
  //oPrint:SayBitmap( 0040,0000,aBmp,0700,0150 )
  oPrint:SayBitmap( 0015,0015,aBmp,0500,0250 )
EndIf
// ----------------------------------  Contorno do documento
	
oPrint:box  (0015,0015,2850,2355)
oPrint:Line (0015,0520,0270,0520)// Linha vertical

oPrint:Say	(0120,0950,"ORÇAMENTO",oFont20An )
oPrint:Say	(0120,2050,c_Folha,oFont10An )
oPrint:line (0270,0020,0270,2350)// Linha Horizontal



oPrint:Say	(0300,1800,"Orçamento N.:",oFont13An )	;	oPrint:Say	(0300,2170,c_ORC,oFont12An )
//oPrint:Say	(0300,0020,cEmpresa,oFont14An )
//oPrint:Say	(0370,0020,c_LocData,oFont8An )
oPrint:line (0370,0020,0370,2350)// Linha Horizontal

//oPrint:Line (0370,0300,675,0300)// Linha vertical
//oPrint:Line (0015,0520,0270,0520)// Linha vertical

// ----------------------------------  quadro 3  Destinatário    
oPrint:Say	(0390,0020,"Cliente:",oFont12An )			;	oPrint:Say	(0390,0350,c_CLIENTE,oFont8An )
oPrint:line (0435,0020,0435,2350)// Linha Horizontal
oPrint:Say	(0450,0020,"Endereço:",oFont12An )			;	oPrint:Say	(0450,0350,c_END	,oFont8A )
oPrint:line (0495,0020,0495,2350)// Linha Horizontal
oPrint:Say	(0510,0020,"Cidade/UF:",oFont12An )				;	oPrint:Say	(0510,0350,c_MUN	,oFont8A )
oPrint:line (0555,0020,0555,2350)// Linha Horizontal
oPrint:Say	(0570,0020,"Contato:",oFont12An )			;	oPrint:Say	(0570,0350,c_Contato,oFont8A )
oPrint:line (0615,0020,0615,2350)// Linha Horizontal
oPrint:Say	(0630,0020,"Telefone:",oFont12An )			;	oPrint:Say	(0630,0350,"("+c_Ddd+")  " + c_Tel ,oFont8A )
// Substr(DtoS(SCJ->CJ_XDTENTR),7,2)+"/"+Substr(DtoS(SCJ->CJ_XDTENTR),5,2)+"/"+Substr(DtoS(SCJ->CJ_XDTENTR),1,4)+ SubStr( c_Tel, 2, 4 )
//oPrint:Say	(0630,0480," ",oFont12An )					;	oPrint:Say	(0630,0390,c_Tel	,oFont8A )
//oPrint:Say	(0630,0650,"FAX:",oFont12An )				;	oPrint:Say	(0630,0650,c_Fax	,oFont8A )EMISSAO
//oPrint:Line (0615,1400,0675,1400) // Linha vertical
 oPrint:Say	(0630,1900,"Data:",oFont12An )				;   oPrint:Say	(0630,2100,c_LocData,oFont12An )	
//oPrint:Say	(0630,1450,"Data:",oFont12An )				;   oPrint:Say	(0630,1800,c_LocData,oFont8An )						
oPrint:line (0675,0020,0675,2350)// Linha Horizontal


//oPrint:Say	(0710,0020,"Conforme solicitação, informamos preços e condições:",oFont14An )	
oPrint:line (0770,0020,0770,2350)   

// ----------------------------------  quadro 4  Cabec Itens 
oPrint:Say	(0780,0021,"PRODUTO",oFont10An )
oPrint:Say	(0780,0250,"DESCRIÇÃO",oFont10An )
oPrint:Say	(0780,1150,"UM",oFont10An )
oPrint:Say	(0780,1250,"QUANT.",oFont10An )
oPrint:Say	(0780,1450,"V. UNIT.",oFont10An )
oPrint:Say	(0780,1650,"V. TOTAL",oFont10An )
oPrint:Say	(0780,1850,"%IPI",oFont10An )
oPrint:Say	(0780,1950,"TOT.IPI",oFont10An ) 
oPrint:Say	(0780,2150,"ENTG. ATÉ",oFont10An )

oPrint:line (0830,0020,0830,2350)   
// ----------------------------------  quadro 5  Detalhe dos Itens 

_Li := 0800

_nTotal := 0
_nIpi   := 0

For i := 1 to len(aPrtLi)
	//nVerifq  := aPrtLi[i,1]
	_Li	+= 40

	oPrint:Say	(_Li,0021,aPrtLi[i,1], oFont8Cn )	// PRODUTO
	oPrint:Say	(_Li,0250,aPrtLi[i,2], oFont8Cn )	// DESCRICAO
	If !empty(aPrtLi[i,10])
		oPrint:Say	(_Li+25,0250,+"Reg. ANVISA :"+ aPrtLi[i,10], oFont8C )	// REGISTRO ANVISA
	EndIf
	oPrint:Say	(_Li,1150,aPrtLi[i,3], oFont8Cn )	// UM
	oPrint:Say	(_Li,1250,aPrtLi[i,4], oFont8Cn )	// QUANT
	oPrint:Say	(_Li,1380,aPrtLi[i,5], oFont8Cn )	// PRCVEN
	oPrint:Say	(_Li,1850,Transform(aPrtLi[i,6],"@E 999.99"), oFont8Cn )	// %IPI 
	
	If aPrtLi[i,8] > 0 
		oPrint:Say	(_Li,1550,Transform(aPrtLi[i,8],"@E 999,999,999.99"),oFont8Cn )	// TOTAL
	Endif
	
	_nTotal += aPrtLi[i,8] 
	
	If aPrtLi[i,7] > 0 
		oPrint:Say	(_Li,1850,Transform(aPrtLi[i,7],"@E 999,999,999.99"),oFont8Cn )	// TOTIPI
	Endif
	
	oPrint:Say	(_Li,2180,aPrtLi[i,9], oFont8Cn )   // ENTREGA1   
	
	_nIpi   += aPrtLi[i,7]
	
	_Li	+= 20
	
	if !empty(aPrtLi[i,1])
		oPrint:Say	(_Li+20,0020,replicate("--",85))  
	EndIf 
	//MsgAlert( REPLICATE(“-“, 5) )          // Resulta “-----“ Replicate("-",20),
	
Next i

_nTotGeral 		+= _nTotal //SAMUEL
_nIpiGeral   	+= _nIpi //SAMUEL
_nPesoGeral		:= 0
_nIcmGeral		:= 0

//oPrint:box  (2600,0020,2840,2350)
oPrint:line (2550,0019,2550,2350) 
oPrint:line (2600,0019,2600,2350) 

oPrint:Say	(2560,0020,"T O T A L   D O S   P R O D U T O S: ",oFont9Cn )
oPrint:Say	(2560,1530,Transform(_nTotal,"@E 999,999,999.99"),oFont8Cn )
oPrint:Say	(2560,1850,Transform(_nIpi,"@E 999,999,999.99"),oFont8Cn )

  oPrint:line (2645,0019,2645,2350) //linha Horizoontal

oPrint:Say	(2605,0020,"T O T A L   D O  I P I: ",oFont9Cn )
oPrint:Say	(2605,1530,Transform(_nIpi,"@E 999,999,999.99"),oFont8Cn )

oPrint:line (2695,0019,2695,2350) 
oPrint:Say	(2650,0020,"T O T A L   D O  F R E T E: ",oFont9Cn )
oPrint:Say	(2700,0020,"T O T A L   G E R A L: ",oFont9Cn )	
oPrint:line (2745,0019,2745,2350) //linha Horizoontal
 if Folha <> Folhas
	//T O T A L   D O  F R E T E
	oPrint:Say	(2650,1530,Transform(c_Frete,"@E 999,999,999.99"),oFont8Cn )
	//T O T A L   G E R A L
	oPrint:Say	(2700,1525,Transform(_nTotal+_nIpi,"@E 999,999,999.99"),oFont8Cn ) 
 Endif

 if Folha = Folhas
	oPrint:Line (2600,1795,2850,1795)// Linha vertical
	oPrint:Say	(2605,1850,"TOTAL GERAL DO PEDIDO",oFont9Cn )
	oPrint:Say	(2650,1800,"ICMS",oFont9Cn )
	oPrint:Say	(2650,2070,Transform(_nIcmGeral,"@E 999,999,999.99"),oFont9Cn )
	oPrint:Say	(2700,1800,"IPI",oFont9Cn )
	oPrint:Say	(2700,2070,Transform(_nIpiGeral,"@E 999,999,999.99"),oFont9Cn )
	oPrint:Say	(2750,1800,"FRETE ",oFont9Cn )
	oPrint:Say	(2750,2070,Transform(c_Frete,"@E 999,999,999.99"),oFont9Cn )
	oPrint:Say	(2810,2050,Transform(_nTotGeral+_nIpiGeral+c_Frete,"@E 999,999,999.99"),oFont10Cn )
	oPrint:line (2800,1795,2800,2350)  //linha Horizoontal
Endif 
                               
//oPrint:box  (2840,0020,2800,2350)    

If Folha <> Folhas
	oPrint:Say	(2860,0020,"Continua na próxima folha",oFont20An )
Else
	oPrint:Say	(2860,0020,"Condições Gerais",oFont12An )
	oPrint:line (2910,0020,2910,0370)
	oPrint:Say	(2960,0020,"ICMS: Incluso",oFont12An )
	oPrint:Say	(3010,0020,"Cond. pagamento: "+Alltrim(aCabec[11]),oFont12An )
	oPrint:Say	(3060,0020,"Moeda: A-R$",oFont12An )
	oPrint:Say	(3110,0020,"Validade:  "+(aCabec[12]),oFont12An )
//	oPrint:Say	(3160,0060,"Prazo de Entrega: "+(aCabec[12]),oFont12An )
    //oPrint:Say	(3210,0020,"Garantia: 1 ano para defeitos de fabricação",oFont12An ) 
	oPrint:Say	(3210,0020,"Garantia: 6 meses para defeitos de fabricação",oFont12An ) // Samuel Miradnda 20/05/2022 -> Alterado para 6 meses apedido do Cristiano Porto conforme chamdo N°  15358

EndIf

oPrint:Say	(3250,0020,"O prazo de entrega é contado a partir da confirmação do pedido e liberação do financeiro",oFont12An )
//oPrint:Say	(3300,0020,"Atenciosamente.",oFont12An )

oPrint:Say	(3310,2070,"By TI | Ortosintese",oFont6A	 )
Return    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CriaSX1   ³ Rev.  ³ Claudio               ³ Data ³14.08.2010³±±
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

aAdd(aP,{"Cliente de"                ,"C", 6,0,"G","                                                            ","SA1"   ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Cliente ate"               ,"C", 6,0,"G","(mv_par02>=mv_par01)                                        ","SA1"   ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Emissao de"                ,"D", 8,0,"G","                                                            ",""      ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Emissao ate"               ,"D", 8,0,"G","(mv_par04>=mv_par03)                                        ",""      ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Orcamento de"              ,"C", 6,0,"G","                                                            ","SCJ"   ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Orçamento ate"             ,"C", 6,0,"G","(mv_par06>=mv_par05)                                        ","SCJ"   ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Numero de Vias"            ,"N", 2,0,"G","(mv_par07>=1)                                               ",""      ,""           ,""             ,""            ,"",""})

aAdd(aHelp,{"Informe o Código do Cliente ","inicial para a seleção dos dados"})
aAdd(aHelp,{"Informe o Código do Cliente ","Final para a seleção dos dados"})
aAdd(aHelp,{"Informe a Data de Emissao  ","inicial para a seleção dos dados"})
aAdd(aHelp,{"Informe a Data de Emissao  ","final para a seleção dos dados"})
aAdd(aHelp,{"Informe o Numero do Orçamento","inicial para a seleção dos dados"})
aAdd(aHelp,{"Informe o Numero do Orçamento","final para a seleção dos dados"})
aAdd(aHelp,{"Informe a quantidade de cópias","a serem impressas."})

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
