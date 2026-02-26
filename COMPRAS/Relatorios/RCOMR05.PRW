#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"        
#INCLUDE "TOPCONN.CH"          
#DEFINE DMPAPER_LETTER 1 	// Letter 8 1/2 x 11 in
#DEFINE DMPAPER_A4 9 		// A4 210 x 297 mm

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RCOMR05  ³ Revis.³  Samuel Miranda       ³ Data ³ 05/03/20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Pedido de Compras                               ³±±          
±±³          ³ Feita alteração para imprimir o valor do Frete             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ortosintese                                                ³±±     
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/              
User Function RCOMR05()        

Private cPerg		:= "COM       "
Private nItPg		:= 12   //Número de linhas x2 antes 16 
Private aMes		:= {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
Private lPreVale	:= .f.
Private lValido		:= .t.

_nTotGeral 		:= 0 //SAMUEL
_nIpiGeral   	:= 0 //SAMUEL
_nFreteGeral   	:= 0 //SAMUEL  

CriaSX1(cPerg)                                                    '

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
Local aPrtLi		:= {}
Local aPrtIt		:= {}
Local aCabec		:= {}
Local Folha 		:= 0
Local Folhas 		:= 0
Local i				:= 0
Local j				:= 0
Local k				:= 0


PRIVATE oPrint

cQuery		:= "SELECT "+CHR(13)+CHR(10)
cQuery		+= 		"DISTINCT(SC7.C7_NUM ) REG "+CHR(13)+CHR(10)
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
Private oPrint	
oPrint:= TMSPrinter():New( "Pedido Compras" )
oPrint:SetPortrait()
oPrint:setPaperSize( DMPAPER_A4 )

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
	cQuery		+= 		"C7_DESCRI C7_DESCRI "+CHR(13)+CHR(10)
	cQuery		+= 		"FROM "+CHR(13)+CHR(10)
	cQuery		+= 		RetSqlName("SC7")+" SC7 "+CHR(13)+CHR(10)
	cQuery		+= 		"INNER JOIN " + RetSqlName("SA2") + " SA2 ON A2_FILIAL = '"+xFilial("SA2")+"' AND A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ = ''" +CHR(13)+CHR(10)
	cQuery		+= 		"INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = C7_PRODUTO AND SB1.D_E_L_E_T_ = '' " +CHR(13)+CHR(10)
	cQuery		+= 		"WHERE "+CHR(13)+CHR(10)
	cQuery		+= 		"SC7.C7_FILIAL = "+xFilial("SC7")+" AND "+CHR(13)+CHR(10)
	cQuery		+= 		"SC7.C7_NUM = "+alltrim(COMS->REG)+" AND "+CHR(13)+CHR(10)
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
  //	TcSetField("COM","DESCONTO"	,"N",16,2)// SAMUEL
	
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
				
				aCabec		:=	{	cEmpresa,;		
	       							cEndere,;	 	
	       							cCgc,;			
	       							cInsc,;     	
	       							cTel,;   	   
	       							cFax,;         
	       							c_PED,;	   	
	       							c_END,;			
		       						c_BAIRRO,;     
		       						c_MUN,;   		
		       						c_EST,;        
		       						c_CEP,;        
		       						c_TEL,;
		       						c_EMISSAO,;    	
		       						c_ENTREGA,;    
		       						c_FORNECE,;    
		       						c_CONTATO,;    
		       						c_DDD,;
		       						c_FONE,;        
		       						c_CNPJ,;		
		       						c_CONDPAG,;
		       						c_MOEDA,;
		       						c_NUMSC,;
		       						c_OBSSC,;
		       						c_OBSPV,;
		       						c_XCOMPR,;
		       						c_XLOTEOF,;
		       						c_XPRODOF,;
		       						c_XQTDEOF,;
		       						c_XUMOF,;
		       						c_XDESCOF}
		       							   
				aItens := {}            
	
		 	EndIf
	   	        
	   		aadd( aItens,	{  	COD,;
	   								Substr(C7_DESCRI,1,57),;  // alterado por samuel miranda de 1,50 para 1,45 (46,20)   dia 06/03/2018
	   								Substr(C7_DESCRI,58,20),;
	   								Transform(QUANT,"@E 9,999,999.9999"),;
	   								UM,;             // MAURICIO UM
	   								Transform(PRCVEN,"@E 9,999,999.9999"),;
	   								TOTAL,;
	   								XCERTIF,;
	   								TOTIPI,;
	   								Substr(DtoS(ENTREGA),7,2)+"/"+Substr(DtoS(ENTREGA),5,2)+"/"+Substr(DtoS(ENTREGA),1,4),;    //DATA DE ENTREGA
	   								XLOTEOF,;
	   								OBSPV,;
	   								XPRODOF,;
	   								XDESCOF,;
	   								XQTDEOF,;
	   								XUMOF,;
	   								FRETE,;
	   								DESPESA,;
	   								DESCONTO,;     //* SAMUEL DIA 29/11/2017 */
									Transform(QUANTSG,"@E 9990"),;
									UMSG   } ) 
	   								
	   								
			dbSelectArea("COM")
			dbSkip()
	
		EndDo
        
		While Mod(len(aItens),nItPg) > 0

		  	aadd( aItens,	{	" ",;								
		  							" ",;
		  							" ",;
		  							" ",;
		  							" ",; // MAURICIO UM
		  							" ",;
		  							  0,;
		  							" ",;
		  							  0,;
		  							" ",;
		  							" ",;
		  							" ",;
		  							" ",;
		  							" ",;
		  							  0,;
		  							" ",;
		  							  0,;
		  							  0,;
		  							  0,;
									" ",;
									" "   } )	//SAMUEL DIA 29/11/2017
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
				Impress(aCabec,aPrtLi,Folha++,Folhas)		// Vale
				oPrint:EndPage()							// Finaliza a página
		
			Next k
			
		Next i
	    
        aCabec	:= {}
	
		dbSelectArea("COM")
		dbCloseArea()

	EndIf

	dbSelectArea("COMS")
	dbSkip()

EndDo

dbSelectArea("COMS")
dbCloseArea()
	
oPrint:Preview()     // Visualiza antes de imprimir

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Impress  ³ Revis.³  Samuel Miranda       ³ Data ³ 14/12/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Montagem do Pedido de Compras                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Ortosintese                                     ³±±
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

Local c_Folha		:= "Folha: "+Alltrim(Str(Folha))+"/"+Alltrim(Str(Folhas))
//ABmp := "VALE_"+AllTrim(cEmpAnt)+".JPEG"
// ABmp := "VALE_04.bmp"
ABmp := "LGMID01.png"
         
oFont6A			:= TFont():New("Arial",9,6 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont6An			:= TFont():New("Arial",9,6 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont7A			:= TFont():New("Arial",9,6 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7An			:= TFont():New("Arial",9,6 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8A			:= TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8An			:= TFont():New("Arial",9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9A			:= TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9An			:= TFont():New("Arial",9,9 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10A			:= TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10An		:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12A			:= TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oFont12An		:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13A			:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
oFont13An		:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14A			:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14An		:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20A			:= TFont():New("Arial",9,20,.T.,.F.,5,.T.,5,.T.,.F.)
oFont20An		:= TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)

oFont50An		:= TFont():New("Arial",18,50,.T.,.T.,5,.T.,5,.T.,.F.)
oFont6C			:= TFont():New("Courier New",9, 6,.T.,.F.,5,.T.,5,.T.,.F.)
oFont6Cn			:= TFont():New("Courier New",9, 6,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8C			:= TFont():New("Courier New",7, 8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8Cn			:= TFont():New("Courier New",7, 8,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10C			:= TFont():New("Courier New",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10Cn		:= TFont():New("Courier New",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9C			:= TFont():New("Courier New",9, 9,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9Cn			:= TFont():New("Courier New",9, 9,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8C			:= TFont():New("Courier New",9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8Cn			:= TFont():New("Courier New",9, 8,.T.,.T.,5,.T.,5,.T.,.F.)

oBrush := TBrush():New("",4)

// ----------------------------------  Logotipo
If File(aBmp)
  //oPrint:SayBitmap( 0000,0000,aBmp,2370,0700 )
  //oPrint:SayBitmap( 0060,0060,aBmp,0700,0080 )
  oPrint:SayBitmap( 0015,0015,aBmp,0500,0250 )
EndIf                    
// ----------------------------------  Contorno do documento

oPrint:Line (0015,0520,0280,0520)// Linha vertical do Logo	
oPrint:box  (0015,0015,2800,2355)//2470) //Box Moldura 

oPrint:Say	(0120,0950,"PEDIDO DE COMPRAS",oFont20An )
oPrint:Say	(0120,2170,c_Folha,oFont10An )
oPrint:line (0280,0020,0280,2355)//Linha Horizontal	

oPrint:Say	(0300,0020,cEmpresa,oFont14An )
oPrint:Say	(0300,1750,"Pedido Compra N.:",oFont13An )		;	oPrint:Say	(0300,2200,c_PED,oFont12An )
oPrint:Say	(0350,0020,cEndere,oFont8An )
oPrint:line (0385,0020,0385,2355)//Linha Horizontal	

oPrint:Say	(0400,0020,"TEL:",oFont10An )					;	oPrint:Say	(0400,0160,cTel,oFont8A )
oPrint:Say	(0400,0450,"E-Mail:",oFont10An )				;	oPrint:Say	(0400,0650,"compras@ortosintese.com.br",oFont8An )
oPrint:Say	(0400,1070,"Site:",oFont10An )					;	oPrint:Say	(0400,1200,"www.ortosintese.com.br",oFont8An )
oPrint:Say	(0400,1800,"Emissao:",oFont10An )				;	oPrint:Say	(0400,1970,c_Emissao,oFont8A )
oPrint:line (0440,0020,0440,2355)//Linha Horizontal	 

oPrint:Say	(0450,0020,"CNPJ:",oFont10An )					;	oPrint:Say	(0450,0180,cCgc,oFont8A )
oPrint:Say	(0450,0450,"INSCR.EST :",oFont10An )			;	oPrint:Say	(0450,0670,cInsc,oFont8A )
oPrint:Say	(0450,1070,"FAX:",oFont10An )					;	oPrint:Say	(0450,1200,cFax,oFont8A )
oPrint:line (0490,0020,0490,2355)//Linha Horizontal	
                                                

//oPrint:line (0540,0050,0540,2400)//2470) Linha 2377
// ----------------------------------  quadro 3  Destinatário
oPrint:Say	(0500,0020,"DADOS DO FORNECEDOR",oFont10An )
oPrint:line (0540,0015,0540,2355)// Linha Horizontal	
oPrint:Say	(0550,0020,"FORNECEDOR:",oFont8An )	   					;	oPrint:Say	(0550,0350,c_FORNECE,oFont8An )
oPrint:Say	(0550,1500,"CNPJ:",oFont8An )			   				;	oPrint:Say	(0550,1650,c_CNPJ,oFont8An )
oPrint:line (0585,0020,0585,2355)//Linha Horizontal	 

oPrint:Say	(0600,0020,"ENDEREÇO:",oFont8An )	   					;	oPrint:Say	(0600,0350,c_END,oFont8A )
oPrint:Say	(0600,1500,"BAIRRO:",oFont8An )		   					;	oPrint:Say	(0600,1650,c_BAIRRO,oFont8A )
oPrint:line (0635,0020,0635,2355)//Linha Horizontal	 

oPrint:Say	(0650,0020,"CIDADE:",oFont8An )		   					;	oPrint:Say	(0650,0350,c_MUN,oFont8A )
oPrint:Say	(0650,1500,"ESTADO:",oFont8An )		   					;	oPrint:Say	(0650,1650,c_EST,oFont8A )
oPrint:Say	(0650,1800,"C.E.P:",oFont8An )		   					;	oPrint:Say	(0650,1900,c_CEP,oFont8A )
oPrint:line (0685,0020,0685,2355)//Linha Horizontal	

oPrint:Say	(0700,0020,"CONTATO:",oFont8An )		   				;	oPrint:Say	(0700,0350,c_Contato,oFont8A )
oPrint:Say	(0700,1500,"FONE:",oFont8An )		   					;	oPrint:Say	(0700,1650,c_Ddd +" - ",oFont8A )
oPrint:Say	(0700,1340," ",oFont8An )				   				;	oPrint:Say	(0700,1750,c_Fone,oFont8A )
oPrint:line (0735,0020,0735,2355)//Linha Horizontal		
oPrint:Say	(0750,0020,"MOEDA...:",oFont8An )				   		; oPrint:Line (0540,1490,0735,1490) // Linha vertical	
oPrint:line (0785,0020,0785,2355)//Linha Horizontal	

If c_MOEDA == 1
		oPrint:Say	(0750,0350,"REAL",oFont8An )
	ElseIf c_MOEDA == 2
		oPrint:Say	(0750,0350,"DOLAR",oFont8An )
	ElseIf c_MOEDA == 3
		oPrint:Say	(0750,0350,"UFIR",oFont8An ) 
	ElseIf c_MOEDA == 4
		oPrint:Say	(0750,0350,"EURO",oFont8An ) 
	ElseIf c_MOEDA == 5
		oPrint:Say	(0750,0350,"IENE",oFont8An ) 
EndIf
oBrush 	:= TBrush():New(,RGB(192,192,192)) 
oBrush1 := TBrush():New(,RGB(0,0,0)) 

oPrint:line (0845,0020,0845,2355)// Linha Horizontal
//oPrint:FillRect({0295,0018,0345,0995},oBrush) 
// ----------------------------------  quadro 4  Cabec Itens 
oPrint:Say	(0860,0030,"PRODUTO",oFont8An )
oPrint:Say	(0860,0350,"DESCRIÇÃO DO PRODUTO",oFont8An ) //SAMUEL DIA 29/11/2017 LTERADO PARA 0280

oPrint:Line (0785,1230,0900,1230)// Linha vertical
oPrint:Say	(0810,1320,OEMTOANSI("1ª UNID."),oFont8An )
oPrint:Say	(0860,1270,"QTD",oFont8An )					//oPrint:Say	(0860,1480,"QUANT.",oFont8An )
oPrint:Say	(0860,1420,"UN",oFont8An ) 	
oPrint:Line (0785,1480,0900,1480)// Linha vertical  	//oPrint:Say	(0860,1620,"UNID.",oFont8An ) // MAURICIO UM
oPrint:Say	(0810,1555,OEMTOANSI("2ª UNID."),oFont8An )
oPrint:Say	(0860,1510,"QTD",oFont8An )					//oPrint:Say	(0860,1480,"QUANT.",oFont8An )
oPrint:Say	(0860,1650,"UN",oFont8An ) 
oPrint:Line (0785,1710,0900,1710)// Linha vertical 
		 
oPrint:Say	(0860,1770,"$ UNIT",oFont8An )
oPrint:Say	(0860,1950,"$ TOTAL",oFont8An )
oPrint:Say	(0860,2095,"CERT",oFont8An )    			//oPrint:Say	(0820,2000,"CERTIF. CONF.",oFont6An )
//oPrint:Say	(0820,1930,"CERTIF. CONF.",oFont10An )
oPrint:Say	(0860,2225,"ENT. ATÉ",oFont8An )  
//oPrint:Say	(0820,2200,"ENTREGA",oFont10An )          
oPrint:line (0900,0020,0900,2355)// Linha Horizontal  
//oPrint:line (0870,0050,0870,2400)//2470)  

// ----------------------------------  quadro 5  Detalhe dos Itens 
_Li := 0880

_nTotal 		:= 0 
_nIpi   		:= 0
_nFrete 		:= 0
_nDespesa 		:= 0
_nDesconto  	:= 0  //SAMUEL DIA 29/11/2017
_nSalto			:= 0
//_nTotGeral 		:= 0 	//SAMUEL
//_nIpiGeral   		:= 0	//SAMUEL  
//_nFreteGeral		:= 0 	//SAMUEL  


For i := 1 to len(aPrtLi)  

	_Li		+= 40
	_nSalto	+= 75

	oPrint:Say	(_Li,0030,aPrtLi[i,1], oFont8C )	// PRODUTO
	oPrint:Say	(_Li,0310,aPrtLi[i,2], oFont8C )	// DESCRICAO //alterado de 0250 para 0310  por SAMUEL MIRANDA 06/03/2018 //Alltrim(Substr( ,1,35))
	
	oPrint:Say	(_Li,1150,aPrtLi[i,4], oFont8C )	// QUANT 1ª
	oPrint:Say	(_Li,1420,aPrtLi[i,5], oFont8C )	// UM
	oPrint:Say	(_Li,1520,aPrtLi[i,20], oFont8C )	// QUANT 2ª
	oPrint:Say	(_Li,1655,aPrtLi[i,21], oFont8C )	// UM
	
	oPrint:Say	(_Li,1635,aPrtLi[i,6], oFont8C )	// PRCVEN
	If aPrtLi[i,7] > 0 
		oPrint:Say	(_Li,1825,Transform(aPrtLi[i,7],"@E 999,999,999.99"),oFont8C )	// PRECO TOTAL  MUDADO PARA 1000
	Endif
	oPrint:Say	(_Li,2110,aPrtLi[i,8], oFont8C )	// CERTIF.CONFORM //MUDADO PARA 2100
	oPrint:Say	(_Li,2185,aPrtLi[i,10], oFont8C )	// ENTREGA
	
   	_Li	+= 40
	oPrint:Say	(_Li-15,0310,aPrtLi[i,3], oFont8C )	// DESCRICAO antes era 290
	oPrint:Say	(_Li-15,0720,aPrtLi[i,11], oFont8C )	// XLOTEOF
	//_Li	+= 30       (2660,0160,
	oPrint:Say	(_Li - 15,0900,aPrtLi[i,12], oFont8C )	// OBSPC

	If !Empty(SC7->C7_XLOTEOF)
	  	_Li	+= 30	
		oPrint:Say	(_Li - 15,0500,aPrtLi[i,13], oFont8C )	// XPRODOF
		oPrint:Say	(_Li - 15,0700,aPrtLi[i,14], oFont8C )	// XDESCOF
		If aPrtLi[i,15] > 0
		oPrint:Say	(_Li - 15,1350,Transform(aPrtLi[i,15],"@E 9999"),oFont8C )	// XQTDEOF
		EndIf
		oPrint:Say	(_Li - 15,1550,aPrtLi[i,16], oFont8C )	// XUMOF   
	EndIf
			
	_nTotal 	+= aPrtLi[i,7]
	_nFrete 	+= aPrtLi[i,17]
	_nDespesa 	+= aPrtLi[i,18]	 
	_nDesconto 	+= aPrtLi[i,19]   //SAMUEL DIA 29/11/2017
	
	If aPrtLi[i,9] > 0
		_nIpi   += aPrtLi[i,9]
	EndIf
 
    _Li	-= 30
    
	//Imprimi as linhas vertical e horizontal na grid.
	if !empty(aPrtLi[i,1])
	 	oPrint:Line (0785,1230,_nSalto+0900,1230)// Linha vertical
		oPrint:Line (0785,1480,_nSalto+0900,1480)// Linha vertical   
		oPrint:Line (0785,1710,_nSalto+0900,1710)// Linha vertical 
  	_Li	+= 30
		oPrint:Say	(_Li,0020,replicate("--",85))   
		//oPrint:line (_Li,0020,_Li,2355)//Linha Vertical	
	EndIf 
	
Next i

_nTotGeral 		+= _nTotal 	//SAMUEL
_nIpiGeral   	+= _nIpi 	//SAMUEL  
_nFreteGeral	+= _nFrete	//SAMUEL  

//oPrint:Say	(2060,0020,"Prezados Parceiros, Fornecedores e Prestadores de Serviços, Gostaríamos de informar, que no período de 22 de Dezembro de 2023 à 07 de Janeiro de 2024,",oFont8An )	
//oPrint:Say	(2110,0020,"	os recebimentos de materiais produtivos, improdutivos e serviços estarão suspensos. Casos extremamente necessários, serão informados e agendados ",oFont8An )	
//oPrint:Say	(2160,0020,"		com os parceiros.A retomada dos recebimentos serão à partir do dia 08 de Janeiro de 2024.Desejamos a todos excelentes festas.",oFont8An )	
oPrint:Say	(1960,0040,"A Ortosintese não autoriza a quaisquer parceiros, fornecedores, prestadores de serviços, consultores etc. o desconto de seus títulos de qualquer forma ou em qualquer ",oFont10An )	
oPrint:Say	(2040,0050,+Space(5)+" instituição financeira ou correlatos como factoring, bem como quaisquer cessões de crédito terão de ser aprovados previamente pela diretoria financeira da companhia. ",oFont10An )	
oPrint:Say	(2090,0040," Caso haja o recebimento cujo cedente seja diferente da Nota Fiscal o título será recusado e devolvido ao cedente e em caso de negativação da Ortosintese ",oFont10An )	
oPrint:Say	(2140,0050,+Space(50)+"haverá as devidas ações judiciais para ressarcimentos dos prejuízos.",oFont10An )	



oPrint:line (2180,0020,2180,2355)//Linha Horizontal	
oPrint:Say	(2210,0020,"RC:",oFont8An )		   					;	oPrint:Say	(2210,0120,c_NUMSC,oFont8An )
oPrint:Say	(2260,0020,"MATERIAL SUJEITO A INSPECAO",oFont8Cn )
//oPrint:Say	(2330,0060,"FORNECEDORES QUE UTILIZAM SUBSTITUICAO TRIBUTARIA DE ICMS, FAVOR CONSTAR NAS NFS",oFont8Cn )
//oPrint:Say	(2380,0060,"O VALOR DA ALIQUOTA E BASE DE CALCULO DO ICMS",oFont8Cn )
oPrint:Say	(2330,0020,"FORNECEDORES QUE UTILIZAM SUBSTITUICAO TRIBUTARIA DE ICMS, FAVOR CONSTAR NAS NFS O VALOR DA ALIQUOTA E BASE DE CALCULO DO ICMS",oFont8Cn )
oPrint:Say	(2380,0020,"OPTANTES PELO SIMPLES NACIONAL, FAVOR DESTACAR ALIQUOTA DO ICMS NA NOTA FISCAL",oFont8Cn )
oPrint:line (2440,0020,2440,2355)//Linha Horizontal	


oPrint:Say	(2550,0020,"Condicoes e Forma ",oFont10An)		   		; oPrint:Say	(2610,0340,c_Condpag,oFont8A ) //;	oPrint:Say	(2600,0320,c_Condpag,oFont8A )
oPrint:Say	(2600,0020,"De Pagamento :",oFont10An )
oPrint:Say	(2660,0020,"Observ. P.C :",oFont10An ) 					; oPrint:Say	(2670,0290,c_Obssc,oFont8A )   //;	oPrint:Say	(2660,0270,c_Obssc,oFont8A ) 
//SAMUEL DIA 29/11/2017
//oPrint:Say	(2740,0020,"Valor do Desconto: R$ ",oFont10An ) 	; oPrint:Say	(2741,0400,Transform(_nDesconto,"@E 999,999,999.99"),oFont10An )

oPrint:line (2520,0020,2520,2355)//Linha Horizontal	 
oPrint:Say	(2470,1400,"PRODUTOS ",oFont10An) 						; oPrint:Say	(2470,2100,Transform(_nTotal,"@E 999,999,999.99"),oFont10An )
//oPrint:Say	(2530,1400,"PRODUTOS ",oFont10An) 					; oPrint:Say	(2530,2100,Transform(_nTotal,"@E 999,999,999.99"),oFont10An )
oPrint:Say	(2530,1400,"DESCONTO               - ",oFont10An) 						; oPrint:Say	(2530,2100,Transform(_nDesconto,"@E 999,999,999.99"),oFont10An )
oPrint:line (2580,1350,2580,2355)//Linha Horizontal	 
 
oPrint:Line (2440,1350,2800,1350)// Linha vertical	
oPrint:Say	(2600,1400,"IPI"      ,oFont10An )						; oPrint:Say	(2600,2100,Transform(_nIpi,"@E 999,999,999.99"),oFont10An )

oPrint:line (2650,0020,2650,2355)// Linha Horizontal	 
oPrint:Say	(2670,1400,"FRETE / DESPESA"      ,oFont10An )			; oPrint:Say	(2670,2100,Transform(_nFrete+_nDespesa,"@E 999,999,999.99"),oFont10An )    //DIA 22/02/2019 Samuel Miranda

oPrint:line (2720,0020,2720,2355)// Linha Horizontal	 
//oPrint:Say	(2740,1400,"TOTAL PEDIDO(Frete/Despesas)"  ,oFont10An )     ; oPrint:Say	(2740,2100,Transform(_nTotal+_nIpi+_nFrete+_nDespesa-_nDesconto,"@E 999,999,999.99"),oFont10An ) 

 if Folha = Folhas
 	oPrint:Say	(2740,1400,"TOTAL PEDIDO"  ,oFont10An )     		; oPrint:Say	(2740,2100,Transform(_nTotGeral+_nIpi+_nFrete+_nDespesa-_nDesconto,"@E 999,999,999.99"),oFont10An ) 	
 Endif

oPrint:Say	(2820,0020,"O N. DESTE PEDIDO DEVE CONSTAR EM SUA NOTA FISCAL O FORNECEDOR AO ACEITAR ESTE PEDIDO COMPREMETE-SE EM",oFont8Cn )
oPrint:Say	(2870,0020,"INFORMAR-NOS SOBRE QUALQUER ALTERACAO QUE VENHA A OCORRER NOS PRODUTOS OU SERVICOS FORNECIDOS.",oFont8Cn )
oPrint:Say	(2950,0020,"NOS CASOS EM QUE CONSTAR A REVISAO DO DESENHO NA DESCRICAO, CONFIRMAR SE POSSUI A ATUALIZADA",oFont8Cn )     
oPrint:Say	(3050,0020,"OS ARQUIVOS XML DEVEM SER ENVIADOS PARA NFE@ORTOSINTESE.COM.BR.NÃO RECEBEREMOS NFS EMITIDAS A MAIS DE 05 DIAS",oFont9An )//SAMUEL DIA 29/11/2017 ALTERADO DE oFont10An Para oFont9An


oPrint:box  (3220,0750,3220,1330) //SAMUEL
oPrint:box  (3220,1550,3220,2250) //SAMUEL
//oPrint:box  (3220,0800,3220,1300)
//oPrint:box  (3220,1500,3220,1950)

oPrint:Say	(3220,0020,"Data do Pedido :",oFont10An )			;	oPrint:Say	(3230,0350,c_Emissao,oFont8A )
oPrint:Say	(3355,2180,"By TI Ortosintese ",oFont6A ) //SAMUEL

oPrint:Say	(3232,1030,c_XCOMPR,oFont8An )//SAMUEL
//oPrint:Say	(3250,0850,c_XCOMPR,oFont10An )

oPrint:Say	(3232,0750,"COMPRADO POR :",oFont8An )//SAMUEL
//oPrint:Say	(3300,0850,"COMPRADO POR",oFont10An ) 

oPrint:Say	(3232,1550,"APROVADO POR :",oFont8An ) //SAMUEL
//oPrint:Say	(3300,1550,"APROVADO POR",oFont10An )

If Folha <> Folhas
	oPrint:Say	(3300,0060,"Continua na próxima folha",oFont14An )
Else
EndIf

Return    

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

aAdd(aP,{"Fornecedor de"                ,"C", 6,0,"G","                                     ","SA2"   ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Fornecedor ate"               ,"C", 6,0,"G","(mv_par02>=mv_par01)                 ","SA2"   ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Emissao de"                	,"D", 8,0,"G","                                     ",""      ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Emissao ate"               	,"D", 8,0,"G","(mv_par04>=mv_par03)                 ",""      ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Pedido de"                 	,"C", 6,0,"G","                                     ","SC7"   ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Pedido ate"                	,"C", 6,0,"G","(mv_par06>=mv_par05)                 ","SC7"   ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Numero de Vias"            	,"N", 2,0,"G","(mv_par07>=1)                        ",""      ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Qual Unid. Med."            	,"N", 1,0,"G","(mv_par08>=1)                        ",""      ,""           ,""             ,""            ,"",""})

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
