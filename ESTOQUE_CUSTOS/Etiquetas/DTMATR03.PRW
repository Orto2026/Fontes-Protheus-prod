#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ºRotina    ³ DTMATR03    ºAuto ³Samuel Miranda     º Data ³ 03/12/2019  º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ºDescricao ³ Rotina para impressao de etiquetas de Produtos             º±±
//±±º              com o codigo de barras data matrix                       º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ºUso       ³ Especifico Ortosintese                                     º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//Obs. um espaço = 8


User Function DTMATR03()
//Variaveis Locais
Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo 	:= "Impressão de etiqueta de Produtos (DataMatrix)."
//variaveis Privantes
Private cDesc1 	:= "Este programa irá imprimir de etiqueta de "
Private cDesc2 	:= "Produto , em impressora térmica Zebra, "
Private cDesc3 	:= "conforme os parâmetros definidos pelo usuário."
Private cDesc4 	:= ""
Private cDesc5 	:= "By | TI - Ortosintese."
Private cPerg  	:= Padr("DTMATR03",10)
Private lEnd 	:= .F.

//Chama as perguntas e caso não existir ele cria.
ValidPerg()

If !Pergunte(cPerg,.T.)
	Return()
Endif	

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )

aAdd( aButton, { 5, .T., { || Pergunte( cPerg, .T. )  } } )
aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch()            } } )

FormBatch( cTitulo, aSay, aButton )

If nOpc == 1
    RptStatus({|lEnd| U_DT03PRINT(.F.,mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07)},"Imprimindo, aguarde...")
Endif	

Return()



//Função de impressão das etiquetas
User Function DT03PRINT(lEnd,_cProd,_cLote,_nQuant,_nLang,_dFabric,_dDtEmis,_nCop)
						    //Codigo, lote,PcsEbale,Idioma,DTFabi,DTesteril,QtdeRto	
//mv_par01 _cProd	:= Codigo do Produto a Ser Impresso
//mv_par02 _cLote	:= Lote do Produto
//mv_par03 _nQtde	:= Quantidade (Informada no Parametro - Analisar quando for da OP - qual QTDE Trazer
//mv_par04 _cValid	:= Texto com a Data da Validade ou Literal: Val Indeterminada (Retirado do pergunte)
//mv_par05 _dFabric := Data da Fabricacao do Produto
//mv_par06 _dDtEmis	:= Campo Data mal definido no levantamento - Quando automatico trazer dDatabase
//mv_par07 _nCop	:= Numero de Copias de Etiqueta.
//mv_par08 _nLang	:= 1=Port / 2=Ingles / 3=Spanish					

Local nCopias 		:= _nCop   //Número de Copias 
Local cImpressora 	:= "ZEBRA" //Nome da Impressora
Local cPorta 		:= "LPT1"  //Porta padrão 
Local _cValid		:= " "
//If _nLang == 2
	//Set(_SET_DATEFORMAT, 'mm/dd/yyyy')
//	Set(_SET_DATEFORMAT, 'yyyy/mm/dd')
//EndIf

SetRegua(1)
dbSelectArea("SB1")
SB1->(dbSetOrder(1))
If SB1->(!dbSeek(xFilial("SB1")+_cProd))
	APMsgAlert("Produto não localizado no cadastro, verifique.")
	Return()
Endif
IncRegua()
	
MSCBPRINTER(cImpressora,cPorta)	 
MSCBCHKStatus(.F.)
//MSCBBEGIN(nCopias,6)  

	MSCBLOADGRAF("LOG3.GRF")	  //Logo Ortosintese
	MSCBLOADGRAF("FABRICA.GRF")   //Imagem fabricante                                                                 
	MSCBLOADGRAF("ATTENCAO.GRF")  //Imagem cuidado consultar instrucoes
	MSCBLOADGRAF("AMPULHET.GRF")  //Imagem da validade                                 
	MSCBLOADGRAF("FABRICAB.GRF")  //Imagem data de fabrica??o 
	MSCBLOADGRAF("02CE.GRF")	  //Imagem do CE
	MSCBLOADGRAF("COPO.GRF")  	  //Copo Simbolo de fragil manusear com cuidado
	MSCBLOADGRAF("10.GRF") 		  //Imagem Logo Nao Esteril 
	MSCBLOADGRAF("UR0010.GRF") 	  //Imagem Umidade relativa do AR
	MSCBLOADGRAF("TEMP13.GRF") 	  //Imagem Temperatura
	MSCBLOADGRAF("UNICO5.GRF") 	  //Imagem Uso Unico
	
	//Inicia a montagem da imagem(etiqueta) a ser impressa		
	MSCBWRITE("^XA")
	MSCBWRITE("^PR4")
	MSCBWRITE("^PQ1")
	MSCBWRITE("^FO48,8^XGLOG3^FS") //Logo Ortosintese
	MSCBWRITE("^FO120,8^A0N,020,020^FH_^FDORTOSINTESE IND. E COM. LTDA^FS")
	MSCBWRITE("^FO600,8^XGATTENCAO^FS")//Imagem cuidado consultar instrucoes
	If SB1->B1_XSTERI = "2" 
		MSCBWRITE("^FO680,8^GB120,24,3,B^FS")//Box ESTRERIL/NO ESTERIL
		MSCBWRITE("^FO528,248^XG10^FS")
	Else
		MSCBWRITE("^FO680,8^GB120,24,3,B^FS")
	Endif
	//Portugues
	if _nLang = 1  			
		MSCBWRITE("^FO688,16^A0N,015,015^FH_^FD"+ IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL")+"^FS ") 			
	ENDIF
	//Ingles
	IF  _nLang = 2
		MSCBWRITE("^FO688,16^A0N,015,015^FH_^FD"+ IIf(SB1->B1_XSTERI = "2","NO STERILE","STERILE")	+"^FS ") 		
	EndIf
	//Espanhol
	if _nLang = 3
		MSCBWRITE("^FO688,16^A0N,015,015^FH_^FD"+ IIf(SB1->B1_XSTERI = "2","NO ESTERIL","ESTERIL")	+"^FS ") 	
	ENDIF
	
	//Impressão e indentificaçã do tipo de esterilização.
	If SB1->B1_XSTERI = "1" 
		If SB1->B1_XSTETP = "2"
			MSCBWRITE("^FO760,8^GB0,24,3,B^FS 				")//linha Vertical no Box
			MSCBWRITE("^FO768,16^A0N,015,015^FH_^FDEO^FS  	")
		EndIf
		
		If SB1->B1_XSTETP = "1"
			MSCBWRITE("^FO760,8^GB0,24,3,B^FS 				")
			MSCBWRITE("^FO768,16^A0N,015,015^FH_^FD R^FS  	")
		EndIf 
		
		If SB1->B1_XSTETP = " "
			MSCBWRITE("^FO768,16^A0N,015,015^FH_^FD ^FS   	")
		EndIf			
	EndIf

	MSCBWRITE("^FO120,32^A0N,016,016^FH_^FDAv Nelson Palma Travassos, 651-Cep:02998-000^FS")
	MSCBWRITE("^FO520,24^XGFABRICA^FS") //Imagem fabrica 
	MSCBWRITE("^FO120,48^A0N,017,017^FH_^FDTel.: 55(11)39484000 - FAX: 55(11)39484010^FS")
	MSCBWRITE("^FO576,64^A0N,017,017^FH_^FD"+ IIf(_nLang=1,"Ver instrucao",IIf(_nLang=2,"See instruction","Ver instruccion")) + "^FS")
	MSCBWRITE("^FO680,48^GB120,44,3,B^FS")//Retangulo do Proibido processar
	If SB1->B1_XUNICO ="1"
		MSCBWRITE("^FO712,56^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Proibido",IIf(_nLang=2,"Do not","Prohibido"))+"^FS")
	EndIf
	MSCBWRITE("^FO120,64^A0N,017,017^FH_^FDSao Paulo-SP Brasil - Site: www.ortosintese.com.br^FS")
	MSCBWRITE("^FO600,80^A0N,017,017^FH_^FD"+IIf(_nLang=1,"de uso",IIf(_nLang=2,"for use","de uso"))+"^FS")
	If SB1->B1_XUNICO ="1"
		MSCBWRITE("^FO696,72^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Reprocessar",IIf(_nLang=2,"Reprocess","Reprocesar"))+"^FS")
	EndIf
	MSCBWRITE("^FO40,96^GB280,32,3,B^FS")
	MSCBWRITE("^FO320,96^GB280,32,3,B^FS")
	MSCBWRITE("^FO600,96^GB200,32,3,B^FS")
	MSCBWRITE("^FO40,104^A0N,024,024^FH_^FD  "+"Ref.: "+ Alltrim(SB1->B1_COD)+"^FS") 	//Codigo do Produto
	MSCBWRITE("^FO328,104^A0N,024,024^FH_^FD "+IIf(_nLang=1,"Lote: ",IIf(_nLang=2,"Lot: ","Lote: "))+UPPER(_cLote)+"^FS") //Lote do Produto
	MSCBWRITE("^FO608,104^A0N,024,024^FH_^FD "+IIf(_nLang=1,"Quant.: ",IIf(_nLang=2,"Quant.: ","Cant.: "))+ Alltrim(Str(_nQuant)) + IIf(_nLang=1,"pc",IIf(_nLang=2,"pc","pz")) + "^FS")	//Quantidade do Produto por embalagem
	//Descrição do Produto	
	MSCBWRITE("^FO40,136^A0N,020,020^FH_^FD"+ IIf(_nLang=1,SB1->B1_XDMCP,IIf(_nLang=2,SB1->B1_XDMCI,SB1->B1_XDMCE)) +	"^FS") //Descrição do Produto
	MSCBWRITE("^FO40,160^A0N,020,020^FH_^FD"+ IIf(_nLang=1,SB1->B1_XDNCP,IIf(_nLang=2,SB1->B1_XDNCI,SB1->B1_XDNCE)) +	"^FS") //Nome Comercial do produto.
	MSCBWRITE("^FO40,184^A0N,020,020^FH_^FD"+ IIf(_nLang=1,SB1->B1_XDNTP,IIf(_nLang=2,SB1->B1_XDNTI,SB1->B1_XDNTE)) +	"^FS") //Nome Técnico do produto.

	//Registro Anvisa
	If EMPTY(SB1->B1_XANVISA) 
		//Português
		 If _nLang=1 
		  MSCBWRITE("^FO40,208^A0N,020,020^FH_^FDExclusivo Mercado Externo^FS ")
		 EndIf
		 //Ingles
		 If _nLang=2 
		  MSCBWRITE("^FO40,208^A0N,020,020^FH_^FDExclusive Foreign Market^FS ")
		 EndIf
		 //Espanhol
		 If _nLang=3
		  MSCBWRITE("^FO40,208^A0N,020,020^FH_^FDExclusivo Mercado Externo^FS ")
		 EndIf
	EndIf
	
	//Registro Anvisa conforme filial e idioma
	If SB1->B1_XANVEMP ="1"
		//Português
		 If _nLang=1
		 	MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD Registro ANVISA: 1022371"+ Alltrim(SB1->B1_XANVISA) +" ^FS ")
		 EndIf
		 //Ingles
		 If _nLang=2
		 	MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD ANVISA Registration: 1022371"+ Alltrim(SB1->B1_XANVISA)+" ^FS ")
		 EndIf
		 //Espanhol
		 If _nLang=3
		 	MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD Registro ANVISA: 1022371"+ Alltrim(SB1->B1_XANVISA)+" ^FS ")
		 EndIf
	EndIf
	//Registro Anvisa conforme filial e idioma
	If SB1->B1_XANVEMP ="2"
		//Português
		 If _nLang=1
		 	MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD Registro ANVISA: 8120219"+ Alltrim(SB1->B1_XANVISA) +" ^FS ")
		 EndIf
		 //Ingles
		 If _nLang=2
		 	MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD ANVISA Registration: 8120219"+ Alltrim(SB1->B1_XANVISA) +" ^FS ")
		 EndIf
		 //Espanhol
		 If _nLang=3
		 	MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD Registro ANVISA: 8120219"+ Alltrim(SB1->B1_XANVISA)+" ^FS ")
		 EndIf
	EndIf
	
	//Materia Prima
	If _nLang = 1	//Português	
		MSCBWRITE("^FO40,232^A0N,020,020^FH_^FD"+"MP: "+ Alltrim(Upper(SB1->B1_XDESM1))+ "  "+ Alltrim(Upper(SB1->B1_XDESM2))+ "  "+ Alltrim(Upper(SB1->B1_XDESM3))+ " ^FS    ") 
	ElseIf _nLang = 2 //Ingles
		MSCBWRITE("^FO40,232^A0N,020,020^FH_^FD"+"RM: "+ Alltrim(Upper(SB1->B1_XDESMI1))+"  "+ Alltrim(Upper(SB1->B1_XDESMI2))+"  "+ Alltrim(Upper(SB1->B1_XDESMI3)) +" ^FS   ") 
	ElseIf _nLang = 3 //Espanhol
		MSCBWRITE("^FO40,232^A0N,020,020^FH_^FD"+"MP: "+ Alltrim(Upper(SB1->B1_XDESM1))+ "  "+ Alltrim(Upper(SB1->B1_XDESM2))+ "  "+ Alltrim(Upper(SB1->B1_XDESM3))+ " ^FS    ") 
	EndIf
	
	MSCBWRITE("^FO45,248^XGFABRICAB^FS")//Imagem da validade 
	cMes := SubStr(DtoS(_dFabric),5,2)
	cAno := SubStr(DtoS(_dFabric),1,4) 
	cDia := substr(Dtos(_dFabric),7,2)
	MSCBWRITE("^FO35,304^A0N,017,017^FH_^FD "+ IIf(_nLang=1,cMes +"/"+ cAno,IIf(_nLang=2,cAno +"/"+ cMes, cMes +"/"+ cAno ))+ " ^FS")  //COLOCAR DATA 
	
	//MSCBWRITE("^FO35,304^A0N,017,017^FH_^FD "+ cMes +"/"+ cAno +" ^FS  	")  //COLOCAR DATA + IIf(_nLang=1,cMes +"/"+ cAno,IIf(_nLang=2,cAno +"/"+ cMes,"")) +
	
	//Validacao para 10 anos  
	MSCBWRITE("^FO160,248^XGAMPULHET^FS")//Imagem da validade 
	If SB1->B1_XSTERI = "2" 															
		_cValid := (_dFabric+1)+(365*10)  
		cMes := SubStr(DtoS(_cValid),5,2)
		cAno := SubStr(DtoS(_cValid),1,4) 
		cDia := substr(Dtos(_cValid),7,2) 																		
		MSCBWRITE("^FO150,304^A0N,017,017^FH_^FD " + IIf(_nLang=1,cMes +"/"+ cAno,IIf(_nLang=2,cAno +"/"+ cMes,cMes +"/"+ cAno )) + " ^FS   ")
		//_cValid := ""
	ENDIF

	//Validacao para 5 anos  	
	If SB1->B1_XSTERI = "1" 															
		_cValid := (_dFabric+1)+(365*5)  
		cMes := SubStr(DtoS(_cValid),5,2)
		cAno := SubStr(DtoS(_cValid),1,4) 
		cDia := substr(Dtos(_cValid),7,2) 																			
		MSCBWRITE("^FO150,304^A0N,017,017^FH_^FD "+ IIf(_nLang=1,cMes +"/"+ cAno,IIf(_nLang=2,cAno +"/"+cMes,cMes +"/"+cAno)) +" ^FS   ")
	EndIf
	//Português	
	If SB1->B1_XUNICO ="1"
		MSCBWRITE("^FO272,256^XGUNICO5^FS")//Imagem Uso Unico
		MSCBWRITE("^FO264,304^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Uso Unico",IIf(_nLang=2,"Sigle Use","Uso Unico"))+"^FS ")
	EndIf
	//Retirado a pedido do cetor de assuntos regulatorio 23/11/2022 - Samuel Miranda
	//If SB1->B1_XCE0434 = "1"  
	//	MSCBWRITE("^FO376,256^XG02CE^FS")//Imagem  CE2460
	//	MSCBWRITE("^FO392,304^A0N,017,017^FH_^FD2460^FS")
	//EndIf
	MSCBWRITE("^FO464,240^XGCOPO^FS") //imagem do Copo
	If SB1->B1_XHUMID = "1"
		MSCBWRITE("^FO616,240^XGUR0010^FS")//Imagem Umidade relativa do AR
	EndIf
	
	//Data de validade impressa no Data matrix																					  		
	//cMes := SubStr(DtoS(_cValid),5,2)
	//cAno := SubStr(DtoS(_cValid),1,4)
	//cDia := substr(Dtos(_cValid),7,2) 
	//Registro Anvisa conforme parametro B1_XANVISA
	If SB1->B1_XANVEMP ="1"
		 cRegAnvisa := "1022371" + Alltrim(SB1->B1_XANVISA)
	ElseIf SB1->B1_XANVEMP ="2"
		 cRegAnvisa := "8120219"+ Alltrim(SB1->B1_XANVISA) 
	EndIf
	//----------------------Impressão do Codigo DataMatrix-------------------------------------//  
	//(01) Global Trade Item Number (GTIN)
	//(17) Data de Validade
	//(10) Numero do lote           
	MSCBWRITE("^BY0,0				   	")    			
	MSCBWRITE("^FT700, 227			   	")			  
	MSCBWRITE("^BXN,4,200,0,0,1, ~ ^FH	")   			
	MSCBWRITE("^FD"+"01"+Alltrim(SB1->B1_COD)+" ") 	//Codigo do Produto			   
	MSCBWRITE("17"+cAno+"-"+cMes+"-"+cDia+" ")	   	//Data
	MSCBWRITE("10"+UPPER(_cLote)+ "")				//Lote do Produto
	//MSCBWRITE("" + cRegAnvisa + "   ") 			//Registro Anvisa
	//MSCBWRITE("01234567890123456	  ")  			//
	MSCBWRITE(" ^FS	")
	//-------------------------Fim da Impressão Datamatrix-------------------------------------//  
	_cValid := ""	

	MSCBWRITE("^FO712,232^XGTEMP13^FS")
	MSCBWRITE("^FO32,320^GB328,112,3,B^FS")
	MSCBWRITE("^FO64,320^BY3,2,64^BEN, 64,Y,N^FD"+Alltrim(SB1->B1_CODBAR)+"^FS")
	MSCBWRITE("^FO0,16^BY2,2,32^BCB, 32,N,N,N,N^FD"+UPPER(_cLote)+"^FS")
	//MSCBWRITE("^FO368,320^A0N,017,017^FH_^FDEuropean Authorized Representative Obelis SA^FS")
	//MSCBWRITE("^FO368,336^A0N,017,017^FH_^FDBd. General Wahis 53 1030 Brussels, BELGIUM^FS")
	//MSCBWRITE("^FO368,320^A0N,017,017^FH_^FDTel +(32)2.732.59.54 Fax +(32)2.732.60.03^FS")//MSCBWRITE("^FO368,352^A0N,017,017^FH_^FDTel +(32)2.732.59.54 Fax +(32)2.732.60.03^FS")
	//MSCBWRITE("^FO368,336^A0N,017,017^FH_^FDEmail: mail@obelis.net - Resp. Verificacao: F. MARTINS^FS")//MSCBWRITE("^FO368,368^A0N,017,017^FH_^FDEmail: mail@obelis.net - Resp. Verificacao: F. MARTINS^FS")
	//Portugues
	If _nLang = 1
		MSCBWRITE("^FO368,384^A0N,017,017^FH_^FDResp. Tecnico: CARLOS M. NAKAMURA/CREA SP 0601828973 ^FS")
	ENDIF
	//Engles
	If _nLang = 2
		MSCBWRITE("^FO368,384^A0N,017,017^FH_^FDTech Resp.: CARLOS M. NAKAMURA/CREA SP 0601828973 ^FS")
	ENDIF
	//Espanhol
	If _nLang = 3
		MSCBWRITE("^FO368,384^A0N,017,017^FH_^FDResp. Tecnico: CARLOS M. NAKAMURA/CREA SP 0601828973 ^FS")
	ENDIF
	//Instrução de Uso
	If SB1->B1_XINSTRU = "1"
		//Portugues
		if _nLang = 1
			MSCBWRITE("^FO368,400^A0N,017,017^FH_^FDInstrucoes de Uso acesse em www.ortosintese.com.br ou ^FS")
			MSCBWRITE("^FO368,416^A0N,017,017^FH_^FDinstrucoesdeuso@ortosintese.com.br Rotulo Rev 04-11/2022^FS") //MSCBWRITE("^FO368,416^A0N,017,017^FH_^FDinstrucoesdeuso@ortosintese.com.br Rotulo Rev 02-04/2020^FS")
			//Rev 04 – 11/2022.
		ENDIF
		//Engles
		if _nLang = 2
			MSCBWRITE("^FO368,400^A0N,017,017^FH_^FDIFU access at www.ortosintese.com.br or request by ^FS")
			MSCBWRITE("^FO368,416^A0N,017,017^FH_^FDinstrucoesdeuso@ortosintese.com.br Label Rev 04-11/2022^FS")
		ENDIF
		//Espanhol
		if _nLang = 3
			MSCBWRITE("^FO368,400^A0N,017,017^FH_^FDInstruccion de Uso visite www.ortosintese.com.br o ^FS")
			MSCBWRITE("^FO368,416^A0N,017,017^FH_^FDinstrucoesdeuso@ortosintese.com.br Rotulo Rev 04-11/2022^FS")
		ENDIF
	ENDIF	
	//Box 1 2 3
	MSCBWRITE("^FO16,448^GB384,96,3,B^FS") // 01
	MSCBWRITE("^FO16,568^GB384,96,3,B^FS") // 02
	MSCBWRITE("^FO16,688^GB384,96,3,B^FS") // 03
	//Box 4 5 6
	MSCBWRITE("^FO416,448^GB380,96,3,B^FS") //04
	MSCBWRITE("^FO416,568^GB380,96,3,B^FS") //05
	MSCBWRITE("^FO416,688^GB380,96,3,B^FS") //06
	//Box 1 2 3
	MSCBWRITE("^FO24,456^A0N,017,017^FH_^FDORTOSINTESE IND. E COM. LTDA ^FS") // 01
	MSCBWRITE("^FO24,576^A0N,017,017^FH_^FDORTOSINTESE IND. E COM. LTDA ^FS") // 02
	MSCBWRITE("^FO24,696^A0N,017,017^FH_^FDORTOSINTESE IND. E COM. LTDA ^FS") // 03
	//Box 4 5 6
	MSCBWRITE("^FO424,456^A0N,017,017^FH_^FDORTOSINTESE IND. E COM. LTDA ^FS") //04
	MSCBWRITE("^FO424,576^A0N,017,017^FH_^FDORTOSINTESE IND. E COM. LTDA ^FS") //05
	MSCBWRITE("^FO424,696^A0N,017,017^FH_^FDORTOSINTESE IND. E COM. LTDA ^FS") //06
	//Box 1 2 3
	MSCBWRITE("^FO24,472^A0N,017,017^FH_^FDTel.: 55(11)39484000 ^FS") // 01
	MSCBWRITE("^FO24,592^A0N,017,017^FH_^FDTel.: 55(11)39484000 ^FS") // 02
	MSCBWRITE("^FO24,712^A0N,017,017^FH_^FDTel.: 55(11)39484000 ^FS") // 03
	//Box 4 5 6
	MSCBWRITE("^FO424,472^A0N,017,017^FH_^FDTel.: 55(11)39484000 ^FS") //04
	MSCBWRITE("^FO424,592^A0N,017,017^FH_^FDTel.: 55(11)39484000 ^FS") //05
	MSCBWRITE("^FO424,712^A0N,017,017^FH_^FDTel.: 55(11)39484000 ^FS") //06
	//Box 1 2 3
	MSCBWRITE("^FO24,504^A0N,017,017^FH_^FDRef.: "+ Alltrim(SB1->B1_COD)+"^FS") //01
	MSCBWRITE("^FO24,624^A0N,017,017^FH_^FDRef.: "+ Alltrim(SB1->B1_COD)+"^FS") //02
	MSCBWRITE("^FO24,744^A0N,017,017^FH_^FDRef.: "+ Alltrim(SB1->B1_COD)+"^FS") //03
	//Box 4 5 6
	MSCBWRITE("^FO424,504^A0N,017,017^FH_^FDRef.: "+ Alltrim(SB1->B1_COD)+"^FS") //04
	MSCBWRITE("^FO424,624^A0N,017,017^FH_^FDRef.: "+ Alltrim(SB1->B1_COD)+"^FS") //05
	MSCBWRITE("^FO424,744^A0N,017,017^FH_^FDRef.: "+ Alltrim(SB1->B1_COD)+"^FS") //06
	//Box 1 2 3											
	MSCBWRITE("^FO20,488^A0N,017,017^FH_^FD "+IIf(_nLang=1,Alltrim((Substr(SB1->B1_XDMCP,1,40))),IIf(_nLang=2,Alltrim((Substr(SB1->B1_XDMCI,1,40))),Alltrim((Substr(SB1->B1_XDMCE,1,40))))) +	"^FS") //01
	MSCBWRITE("^FO20,608^A0N,017,017^FH_^FD "+IIf(_nLang=1,Alltrim((Substr(SB1->B1_XDMCP,1,40))),IIf(_nLang=2,Alltrim((Substr(SB1->B1_XDMCI,1,40))),Alltrim((Substr(SB1->B1_XDMCE,1,40))))) +	"^FS") //02 
	MSCBWRITE("^FO20,728^A0N,017,017^FH_^FD "+IIf(_nLang=1,Alltrim((Substr(SB1->B1_XDMCP,1,40))),IIf(_nLang=2,Alltrim((Substr(SB1->B1_XDMCI,1,40))),Alltrim((substr(SB1->B1_XDMCE,1,40))))) +	"^FS") //03 
	//Box 4 5 6			
	MSCBWRITE("^FO420,488^A0N,017,017^FH_^FD "+IIf(_nLang=1,Alltrim((Substr(SB1->B1_XDMCP,1,40))),IIf(_nLang=2,Alltrim((substr(SB1->B1_XDMCI,1,40))),Alltrim((Substr(SB1->B1_XDMCE,1,40))))) +	"^FS") //04
	MSCBWRITE("^FO420,608^A0N,017,017^FH_^FD "+IIf(_nLang=1,Alltrim((Substr(SB1->B1_XDMCP,1,40))),IIf(_nLang=2,Alltrim((Substr(SB1->B1_XDMCI,1,40))),Alltrim((Substr(SB1->B1_XDMCE,1,40))))) +	"^FS") //05
	MSCBWRITE("^FO420,728^A0N,017,017^FH_^FD "+IIf(_nLang=1,Alltrim((Substr(SB1->B1_XDMCP,1,40))),IIf(_nLang=2,Alltrim((Substr(SB1->B1_XDMCI,1,40))),Alltrim((Substr(SB1->B1_XDMCE,1,40))))) +	"^FS") //06
	//Box 1 2 3
	MSCBWRITE("^FO200,504^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Lote: ",IIf(_nLang=2,"Lot: ","Lote: "))+UPPER(_cLote)+"^FS") //01
	MSCBWRITE("^FO200,624^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Lote: ",IIf(_nLang=2,"Lot: ","Lote: "))+UPPER(_cLote)+"^FS") //02
	MSCBWRITE("^FO200,744^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Lote: ",IIf(_nLang=2,"Lot: ","Lote: "))+UPPER(_cLote)+"^FS") //03
	//Box 4 5 6
	MSCBWRITE("^FO560,504^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Lote: ",IIf(_nLang=2,"Lot: ","Lote: "))+UPPER(_cLote)+"^FS") //04
	MSCBWRITE("^FO560,624^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Lote: ",IIf(_nLang=2,"Lot: ","Lote: "))+UPPER(_cLote)+"^FS") //05
	MSCBWRITE("^FO560,744^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Lote: ",IIf(_nLang=2,"Lot: ","Lote: "))+UPPER(_cLote)+"^FS") //06
	//Alimenta a variavel cRegAnvisa conforme paramentros
	If EMPTY(SB1->B1_XANVISA) 
	  	cRegAnvisa := IIf(_nLang=1,"Exclusivo Mercado Externo",IIf(_nLang=2,"Exclusive Foreign Market","Exclusivo Mercado Externo"))
	Else
		If SB1->B1_XANVEMP ="1"		//Portugeês                     //Inglês                                //Espanhol
		 cRegAnvisa := IIf(_nLang=1,"Registro ANVISA: 1022371",IIf(_nLang=2,"ANVISA Registration: 1022371","Registro ANVISA: 1022371"))+ Alltrim(SB1->B1_XANVISA)
		ElseIf SB1->B1_XANVEMP ="2" //Portugeês                     //Inglês                                //Espanhol
		 cRegAnvisa := IIf(_nLang=1,"Registro ANVISA: 8120219",IIf(_nLang=2,"ANVISA Registration: 8120219","Registro ANVISA: 8120219"))+ Alltrim(SB1->B1_XANVISA) 
	    EndIf
	End If 
	//----------------------------------------------------------------// 
	//----------------------------------------------------------------// 
	//Box 1 2 3  //Imprimi a variavel com o conteudo do registro anvisa. 
	MSCBWRITE("^FO24,520^A0N,017,017^FH_^FD"+cRegAnvisa+"^FS") //01
	MSCBWRITE("^FO24,640^A0N,017,017^FH_^FD"+cRegAnvisa+"^FS") //02
	MSCBWRITE("^FO24,760^A0N,017,017^FH_^FD"+cRegAnvisa+"^FS") //03
	//----------------------DATAMATRIX BOX 01-------------------------//  
	//(01) Global Trade Item Number (GTIN)
	//(17) Data de Validade
	//(10) Numero do lote           
	MSCBWRITE("^BY0,0				   	")    			
	MSCBWRITE("^FT350, 530			   	")			  
	MSCBWRITE("^BXN,2,200,0,0,1, ~ ^FH	")   			
	MSCBWRITE("^FD"+"01"+Alltrim(SB1->B1_COD)+" ") 	//Codigo do Produto			   
	MSCBWRITE("17"+cAno+"-"+cMes+"-"+cDia+" ")	   	//Data
	MSCBWRITE("10"+UPPER(_cLote)+ "")				//Lote do Produto
	//MSCBWRITE("" + cRegAnvisa + "   ") 			//Registro Anvisa
	//MSCBWRITE("01234567890123456	  ")  			//
	MSCBWRITE(" ^FS	")
	//----------------------------------------------------------------//  
	//----------------------DATAMATRIX BOX 02-------------------------//  
	//(01) Global Trade Item Number (GTIN)
	//(17) Data de Validade
	//(10) Numero do lote           
	MSCBWRITE("^BY0,0				   	")    			
	MSCBWRITE("^FT350, 650			   	")			  
	MSCBWRITE("^BXN,2,200,0,0,1, ~ ^FH	")   			
	MSCBWRITE("^FD"+"01"+Alltrim(SB1->B1_COD)+" ") 	//Codigo do Produto			   
	MSCBWRITE("17"+cAno+"-"+cMes+"-"+cDia+" ")	   	//Data
	MSCBWRITE("10"+UPPER(_cLote)+ "")				//Lote do Produto
	//MSCBWRITE("" + cRegAnvisa + "   ") 			//Registro Anvisa
	//MSCBWRITE("01234567890123456	  ")  			//
	MSCBWRITE(" ^FS	")
	//----------------------------------------------------------------//  
	//----------------------DATAMATRIX BOX 03-------------------------// 
	//(01) Global Trade Item Number (GTIN)
	//(17) Data de Validade
	//(10) Numero do lote           
	MSCBWRITE("^BY0,0				   	")    			
	MSCBWRITE("^FT350, 770			   	")			  
	MSCBWRITE("^BXN,2,200,0,0,1, ~ ^FH	")   			
	MSCBWRITE("^FD"+"01"+Alltrim(SB1->B1_COD)+" ") 	//Codigo do Produto			   
	MSCBWRITE("17"+cAno+"-"+cMes+"-"+cDia+" ")	   	//Data
	MSCBWRITE("10"+UPPER(_cLote)+ "")				//Lote do Produto
	//MSCBWRITE("" + cRegAnvisa + "   ") 			//Registro Anvisa
	//MSCBWRITE("01234567890123456	  ")  			//
	MSCBWRITE(" ^FS	")
	//-----------------------------------------------------------------// 
	//-----------------------------------------------------------------//  
	//Box 4 5 6
	MSCBWRITE("^FO424,640^A0N,017,017^FH_^FD"+cRegAnvisa+"^FS") //04
	MSCBWRITE("^FO424,520^A0N,017,017^FH_^FD"+cRegAnvisa+"^FS") //05
	MSCBWRITE("^FO424,760^A0N,017,017^FH_^FD"+cRegAnvisa+"^FS") //06
	//-----------------------------------------------------------------// 
	//----------------------DATAMATRIX BOX 04-------------------------// 
	//(01) Global Trade Item Number (GTIN)
	//(17) Data de Validade
	//(10) Numero do lote           
	MSCBWRITE("^BY0,0				   	")    			
	MSCBWRITE("^FT744, 530			   	")			  
	MSCBWRITE("^BXN,2,200,0,0,1, ~ ^FH	")   			
	MSCBWRITE("^FD"+"01"+Alltrim(SB1->B1_COD)+" ") 	//Codigo do Produto			   
	MSCBWRITE("17"+cAno+"-"+cMes+"-"+cDia+" ")	   	//Data
	MSCBWRITE("10"+UPPER(_cLote)+ "")				//Lote do Produto
	//MSCBWRITE("" + cRegAnvisa + "   ") 			//Registro Anvisa
	//MSCBWRITE("01234567890123456	  ")  			//
	MSCBWRITE(" ^FS	")
	//----------------------------------------------------------------//  
	//----------------------DATAMATRIX BOX 05-------------------------// 
	//(01) Global Trade Item Number (GTIN)
	//(17) Data de Validade
	//(10) Numero do lote           
	MSCBWRITE("^BY0,0				   	")    			
	MSCBWRITE("^FT744, 650			   	")			  
	MSCBWRITE("^BXN,2,200,0,0,1, ~ ^FH	")   			
	MSCBWRITE("^FD"+"01"+Alltrim(SB1->B1_COD)+" ") 	//Codigo do Produto			   
	MSCBWRITE("17"+cAno+"-"+cMes+"-"+cDia+" ")	   	//Data
	MSCBWRITE("10"+UPPER(_cLote)+ "")				//Lote do Produto
	//MSCBWRITE("" + cRegAnvisa + "   ") 			//Registro Anvisa
	//MSCBWRITE("01234567890123456	  ")  			//
	MSCBWRITE(" ^FS	")
	//----------------------------------------------------------------//  
	//----------------------DATAMATRIX BOX 06-------------------------// 
	//(01) Global Trade Item Number (GTIN)
	//(17) Data de Validade
	//(10) Numero do lote           
	MSCBWRITE("^BY0,0				   	")    			
	MSCBWRITE("^FT744, 770			   	")			  
	MSCBWRITE("^BXN,2,200,0,0,1, ~ ^FH	")   			
	MSCBWRITE("^FD"+"01"+Alltrim(SB1->B1_COD)+" ") 	//Codigo do Produto			   
	MSCBWRITE("17"+cAno+"-"+cMes+"-"+cDia+" ")	   	//Data
	MSCBWRITE("10"+UPPER(_cLote)+ "")				//Lote do Produto
	//MSCBWRITE("" + cRegAnvisa + "   ") 			//Registro Anvisa
	//MSCBWRITE("01234567890123456	  ")  			//
	MSCBWRITE(" ^FS	")
	//-----------------------------------------------------------------//  
	//Informação EC | REP
	//MSCBWRITE("^FO720,320^GB80,40,3,B^FS")
	//MSCBWRITE("^FO760,320^GB0,40,3,B^FS")
	//MSCBWRITE("^FO728,336^A0N,015,015^FH_^FDEC^FS")
	//MSCBWRITE("^FO768,336^A0N,015,015^FH_^FDREP^FS")
	//MSCBWRITE("^PQ"+ cvaltochar(nCopias)+",0,1,Y ")// Numero de copias
	MSCBWRITE("^PQ"+ cvaltochar(nCopias)+"")// Numero de copias
	MSCBWRITE("^XZ ")		
		
MSCBEND()               
MSCBCLOSEPRINTER()
            
Return()


//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ºRotina    ³ VALIDPERG    ºAuto ³Samuel Miranda     º Data ³ 03/12/2019 º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ºUso       ³ Cria as perguntas caso elas não existao na SX1             º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

Static Function ValidPerg()
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i,j
Local nTamSX1	:= Len(SX1->X1_GRUPO)
//Local aHelp 	:= {}
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 			:= PADR("DTMATR03",nTamSX1)

Aadd(aRegs,{cPerg,"01","Codigo do Produto ? ","Codigo do Produto ?","Codigo do Produto ? "		,"mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
Aadd(aRegs,{cPerg,"02","Lote ? ","Lote ?","Lote ? "												,"mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Peças por Embalagem? ","Quantidade ?","Quantidade ? "					,"mv_ch3","N",10,2,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Idioma ? ","Idioma ?","Idioma ? "										,"mv_ch4","N",01,0,1,"C","","mv_par04","Portugues","Portugues","Portugues","","","Ingles","Ingles","Ingles","","","Espanhol","Espanhol","Espanhol","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Data Fabricacao ? ","Data Fabricacao ?","Data Fabricacao ? "			,"mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Data Esterilização? ","Data Esteril. ?","Data Esteril. ? "				,"mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Qtde Rótulos  ? ","Qtde Rótulos  ? ","Qtde Rótulos  ? "					,"mv_ch7","N",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"09","Qtde Rótulos FILHO ? ","Qtde Rótulos FILHO ? ","Qtde Rótulos FILHO ? "	,"mv_ch9","N",03,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//mv_par01,	mv_par02,	mv_par03,	mv_par04,	mv_par05,	mv_par06,	mv_par07,	mv_par08
//Codigo  , lote	,	PcsEbale,	Idioma  ,	Validade,	DTFabi	,	DTesteril,	QtdeRto
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
