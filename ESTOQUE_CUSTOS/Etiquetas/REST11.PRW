#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ REST11   ºAutor  ³Samue Miranda       º Data ³  20/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de para impressao de etiquetas de produtos com      º±±
±±º          ³ codigo de barras.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function REST11()

Local aSay := {}
Local aButton := {}
Local nOpc := 0
Local cTitulo := "Impressão de etiqueta de Produtos com Código de Barras."

Private cDesc1 := "Este programa irá imprimir as etiquetas de Produto com"
Private cDesc2 := "código de barras, em impressora térmica Zebra, "
Private cDesc3 := "conforme os parâmetros definidos pelo usuário."
Private cDesc4 := ""
Private cDesc5 := ""
Private cPerg  := Padr("REST11",10)
Private lEnd := .F.

VerSX1()

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
	RptStatus({|lEnd| U_REST11Imp(@lEnd,mv_par01,mv_par02,mv_par03,mv_par05,mv_par06,mv_par07,mv_par08,mv_par04)},"Imprimindo, aguarde...")
Endif	

Return()


User Function REST11Imp(lEnd,_cProd,_cLote,_nQuant,_cValid,_dFabric,_dDtEmis,_nCop,_nLang)
// lEnd Default == .F.
// _cProd	:= Codigo do Produto a Ser Impresso
// _cLote	:= Lote do Produto
// _nQtde	:= Quantidade (Informada no Parametro - Analisar quando for da OP - qual QTDE Trazer
// _cValid	:= Texto com a Data da Validade ou Literal: Val Indeterminada
// _dFabric := Data da Fabricacao do Produto
// _dDtEmis	:= Campo Data mal definido no levantamento - Quando automatico trazer dDatabase
// _nCop		:= Numero de Copias de Etiqueta.
// _nLang	:= 1=Port / 2=Ingles / 3=Spanish

Local nCopias 		:= _nCop
Local cImpressora := "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 	:= "0"
Local cFonte1 		:= "020,020"
Local cFonte2 		:= "017,017"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "015,015"
Local cFonte5 		:= "016,016"

If _nLang == 2
	//Set(_SET_DATEFORMAT, 'mm/dd/yyyy')
	Set(_SET_DATEFORMAT, 'yyyy/mm/dd')
EndIf
    
SetRegua(1)

SB1->(dbSetOrder(1))
If SB1->(!dbSeek(xFilial("SB1")+_cProd))
	APMsgAlert("Produto não localizado no cadastro, verifique.")
	Return()
Endif

IncRegua()
	
MSCBPRINTER(cImpressora,cPorta)	 
MSCBCHKStatus(.F.)

//MSCBLOADGRAF("LOGOORTO.GRF")
MSCBLOADGRAF("LOGOORTO.GRF")
MSCBLOADGRAF("FABRICA.GRF")                                                                   
MSCBLOADGRAF("WARNING.GRF")
MSCBLOADGRAF("AMPULHET.GRF")                                      
MSCBLOADGRAF("FABRICAB.GRF")
MSCBLOADGRAF("USOUNICO.GRF")
MSCBLOADGRAF("02CE.GRF")
MSCBLOADGRAF("COPO.GRF")
MSCBLOADGRAF("TERMOMET.GRF")
MSCBLOADGRAF("UMIDADE.GRF")
                                                           
MSCBBEGIN(nCopias,4)          
MSCBBOX(001,056,099,068)//Box Destaque 01 
MSCBBOX(001,071,099,083)//Box Destaque 02   
MSCBBOX(001,086,099,098)//Box Destaque 03
//MSCBBOX(57,57,100,16,3)

MSCBGRAFIC(04,01,"LOGOORTO")
MSCBSAY(15,01,"ORTOSINTESE IND. E COM. LTDA","N",cTpFonte,cFonte1) 

MSCBSAY(02,57,"ORTOSINTESE IND. E COM. LTDA","N",cTpFonte,cFonte4) //Destaque 01 
MSCBSAY(02,72,"ORTOSINTESE IND. E COM. LTDA","N",cTpFonte,cFonte4) //Destaque 02  
MSCBSAY(02,87,"ORTOSINTESE IND. E COM. LTDA","N",cTpFonte,cFonte4) //Destaque 03  
	
MSCBGRAFIC(75,01,"WARNING")
If SB1->B1_XSTERI = "2" 
	MSCBBOX(85,01,100,4,3)
Else
	MSCBBOX(85,01,95,4,3)
	MSCBBOX(95,01,100,4,3)
Endif	 

if _nLang = 1  // ALTERADO POR SAMUEL MIRANDA DIA 25/05/2016.... Foi Colocado um if para a _nLang
	//MSCBSAY(86,02,IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL"),"N",cTpFonte,cFonte4) 
	MSCBSAY(86,02,IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL"),"N",cTpFonte,cFonte4) 
	MSCBSAY(87,57,IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL"),"N",cTpFonte,cFonte4) //Destaque 01
	MSCBSAY(87,72,IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL"),"N",cTpFonte,cFonte4) //Destaque 02   
	MSCBSAY(87,87,IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL"),"N",cTpFonte,cFonte4) //Destaque 03
ElseIf  _nLang = 2
	//MSCBSAY(86,02,IIf(SB1->B1_XSTERI = "2","NO STERILE","STERILE"),"N",cTpFonte,cFonte4) 
	MSCBSAY(86,02,IIf(SB1->B1_XSTERI = "2","NO STERILE","STERILE"),"N",cTpFonte,cFonte4) 
	MSCBSAY(87,57,IIf(SB1->B1_XSTERI = "2","NO STERILE","STERILE"),"N",cTpFonte,cFonte4) //Destaque 01
	MSCBSAY(87,72,IIf(SB1->B1_XSTERI = "2","NO STERILE","STERILE"),"N",cTpFonte,cFonte4) //Destaque 02   
	MSCBSAY(87,87,IIf(SB1->B1_XSTERI = "2","NO STERILE","STERILE"),"N",cTpFonte,cFonte4) //Destaque 03
EndIf
//MSCBSAY(86,02,IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL"),"N",cTpFonte,cFonte4) 
//MSCBSAY(87,57,IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL"),"N",cTpFonte,cFonte4) //Destaque 01
//MSCBSAY(87,72,IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL"),"N",cTpFonte,cFonte4) //Destaque 02   
//MSCBSAY(87,87,IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL"),"N",cTpFonte,cFonte4) //Destaque 03 

MSCBSAY(96,02,IIf(SB1->B1_XSTERI = "1",IIf(SB1->B1_XSTETP = "2","EO","R"),""),"N",cTpFonte,cFonte4)  
MSCBSAY(96,57,IIf(SB1->B1_XSTERI = "1",IIf(SB1->B1_XSTETP = "2","EO","R"),""),"N",cTpFonte,cFonte4)//Destaque 01
MSCBSAY(96,72,IIf(SB1->B1_XSTERI = "1",IIf(SB1->B1_XSTETP = "2","EO","R"),""),"N",cTpFonte,cFonte4)//Destaque 02
MSCBSAY(96,87,IIf(SB1->B1_XSTERI = "1",IIf(SB1->B1_XSTETP = "2","EO","R"),""),"N",cTpFonte,cFonte4)//Destaque 03 

MSCBSAY(15,04,"Av Nelson Palma Travassos, 651"+"-Cep:02998-000","N",cTpFonte,cFonte5) //AllTrim(SM0->M0_ENDCOB) Transform(SM0->M0_CEPCOB,"@R 9999-999")
MSCBGRAFIC(65,03,"FABRICA")
  //Alterado de _dDtEmis para _dFabric no dia 13/12/2016 por Samuel Mirada
MSCBSAY(87,05,IIf(SB1->B1_XSTERI = "1",dToc(_dFabric),""),"N",cTpFonte,cFonte2) //MSCBSAY(87,05,dToc(_dDtEmis),"N",cTpFonte,cFonte2)
MSCBSAY(87,59,IIf(SB1->B1_XSTERI = "1",dToc(_dFabric),""),"N",cTpFonte,cFonte4)//Destaque 01   
MSCBSAY(87,74,IIf(SB1->B1_XSTERI = "1",dToc(_dFabric),""),"N",cTpFonte,cFonte4)//Destaque 02  
MSCBSAY(87,89,IIf(SB1->B1_XSTERI = "1",dToc(_dFabric),""),"N",cTpFonte,cFonte4)//Destaque 03

MSCBSAY(15,06,"Tel.: 55(11)39484000 - FAX: 55(11)39484010","N",cTpFonte,cFonte2)
MSCBSAY(72,07,IIf(_nLang=1,"Ver Instrucao",IIf(_nLang=2,"See instruction","Ver instrucciones")),"N",cTpFonte,cFonte2)   //MSCBSAY(72,07,"Ver Instrucao","N",cTpFonte,cFonte2)
MSCBBOX(85,07,100,12,3)

If SB1->B1_XUNICO ="1"
    MSCBSAY(89,08,IIf(_nLang=1,"Proibido",IIf(_nLang=2,"Do not","Prohibida")),"N",cTpFonte,cFonte2)    // MAURICIO 12/08/14 MSCBSAY(89,08,"Proibido","N",cTpFonte,cFonte2)
EndIf

MSCBSAY(15,08,"Sao Paulo-SP Brasil - Site: www.ortosintese.com.br","N",cTpFonte,cFonte2)
MSCBSAY(75,09,IIf(_nLang=1,"de uso",IIf(_nLang=2,"for use","de uso")),"N",cTpFonte,cFonte2) //MSCBSAY(75,09,"de Uso","N",cTpFonte,cFonte2)

If SB1->B1_XUNICO ="1"
	MSCBSAY(87,10,IIf(_nLang=1,"Reprocessar",IIf(_nLang=2,"Reprocess","Reprocessar")),"N",cTpFonte,cFonte2)  // 12/08/14  MSCBSAY(87,10,"Reprocessar","N",cTpFonte,cFonte2)
EndIf

MSCBBOX(05,12,40,16,3)
MSCBBOX(40,12,75,16,3)
MSCBBOX(75,12,100,16,3)

MSCBSAY(06,13,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte3) 
MSCBSAY(02,59,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte4)//Destaque 01 
MSCBSAY(02,74,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte4)//Destaque 02  
MSCBSAY(02,89,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte4)//Destaque 03

MSCBSAY(41,13,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte3) //MSCBSAY(41,13,"Lote:"+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte3)
MSCBSAY(15,59,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 01
MSCBSAY(15,74,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 02
MSCBSAY(15,89,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 03


MSCBSAY(76,13,"Quant.:"+Alltrim(Str(_nQuant))+" pc","N",cTpFonte,cFonte3)

MSCBSAY(05,17,IIf(_nLang=1,SB1->B1_XDMCP,IIf(_nLang=2,SB1->B1_XDMCI,SB1->B1_XDMCE)),"N",cTpFonte,cFonte1)
MSCBSAY(05,20,IIf(_nLang=1,SB1->B1_XDNCP,IIf(_nLang=2,SB1->B1_XDNCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte1)
MSCBSAY(05,23,IIf(_nLang=1,SB1->B1_XDNTP,IIf(_nLang=2,SB1->B1_XDNTI,SB1->B1_XDNTE)),"N",cTpFonte,cFonte1)
//MSCBSAY(05,26,"Registro ANVISA:  1022371" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)
If EMPTY(SB1->B1_XANVISA) //Adicionado em 18092017 a pedido do Leandro do PCP para produtos sem registro 
  MSCBSAY(05,26,"Registro ANVISA:  ","N",cTpFonte,cFonte1)
  Else
		If SB1->B1_XANVEMP ="1"
			MSCBSAY(05,26,"Registro ANVISA:  1022371" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)
		ElseIf SB1->B1_XANVEMP ="2"
			MSCBSAY(05,26,"Registro ANVISA:  8120219" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)
		EndIf
End If

MSCBSAY(02,61,IIf(_nLang=1,SB1->B1_XDMCP,IIf(_nLang=2,SB1->B1_XDMCI,SB1->B1_XDMCE)),"N",cTpFonte,cFonte4)//Destaque 01
MSCBSAY(02,63,IIf(_nLang=1,SB1->B1_XDNCP,IIf(_nLang=2,SB1->B1_XDNCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte4)//Destaque 01
//MSCBSAY(02,65,IIf(_nLang=1,SB1->B1_XDNTP,IIf(_nLang=2,SB1->B1_XDNTI,SB1->B1_XDNTE)),"N",cTpFonte,cFonte4)//Destaque 01
//Destaque 01 
If  EMPTY(SB1->B1_XANVISA) //Adicionado em 18/09/2017 a pedido do Leandro do PCP para produtos sem registro  
	MSCBSAY(02,65,"Registro ANVISA:  ","N",cTpFonte,cFonte2)
Else
	If SB1->B1_XANVEMP ="1"
		MSCBSAY(02,65,"Registro ANVISA:  1022371" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
	ElseIf SB1->B1_XANVEMP ="2"
		MSCBSAY(02,65,"Registro ANVISA:  8120219" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
	EndIf 

End If
MSCBSAY(35,65,"Resp. Tecnico: CARLOS M. NAKAMURA / CREA N. 0601828973","N",cTpFonte,cFonte2)//Destaque 01 

MSCBSAY(02,76,IIf(_nLang=1,SB1->B1_XDMCP,IIf(_nLang=2,SB1->B1_XDMCI,SB1->B1_XDMCE)),"N",cTpFonte,cFonte4)//Destaque 02
MSCBSAY(02,78,IIf(_nLang=1,SB1->B1_XDNCP,IIf(_nLang=2,SB1->B1_XDNCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte4)//Destaque 02
//MSCBSAY(02,80,IIf(_nLang=1,SB1->B1_XDNTP,IIf(_nLang=2,SB1->B1_XDNTI,SB1->B1_XDNTE)),"N",cTpFonte,cFonte4)//Destaque 02
//Destaque 02 
If  EMPTY(SB1->B1_XANVISA) //Adicionado em 18/09/2017 a pedido do Leandro do PCP para produtos sem registro 
		MSCBSAY(02,80,"Registro ANVISA:  ","N",cTpFonte,cFonte2)
Else
	If SB1->B1_XANVEMP ="1"
		MSCBSAY(02,80,"Registro ANVISA:  1022371" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
	ElseIf SB1->B1_XANVEMP ="2"
		MSCBSAY(02,80,"Registro ANVISA:  8120219" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
	EndIf 
End If
MSCBSAY(35,80,"Resp. Tecnico: CARLOS M. NAKAMURA/CREA N. 0601828973","N",cTpFonte,cFonte2)//Destaque 02 

MSCBSAY(02,91,IIf(_nLang=1,SB1->B1_XDMCP,IIf(_nLang=2,SB1->B1_XDMCI,SB1->B1_XDMCE)),"N",cTpFonte,cFonte4)//Destaque 03
MSCBSAY(02,93,IIf(_nLang=1,SB1->B1_XDNCP,IIf(_nLang=2,SB1->B1_XDNCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte4)//Destaque 03
//MSCBSAY(02,95,IIf(_nLang=1,SB1->B1_XDNTP,IIf(_nLang=2,SB1->B1_XDNTI,SB1->B1_XDNTE)),"N",cTpFonte,cFonte4)//Destaque 03
//Destaque 03
If EMPTY(SB1->B1_XANVISA)//Adicionado em 18/09/2017 a pedido do Leandro do PCP para produtos sem registro 
	MSCBSAY(02,95,"Registro ANVISA:  ","N",cTpFonte,cFonte2)
Else
	If SB1->B1_XANVEMP ="1"
		MSCBSAY(02,95,"Registro ANVISA:  1022371" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
	ElseIf SB1->B1_XANVEMP ="2"
		MSCBSAY(02,95,"Registro ANVISA:  8120219" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
	EndIf 

End If
MSCBSAY(35,95,"Resp. Tecnico: CARLOS M. NAKAMURA/CREA N. 0601828973","N",cTpFonte,cFonte2)//Destaque 03 


If _nLang = 1
	MSCBSAY(05,29,"MP: "+Alltrim(Upper(SB1->B1_XDESM1))+"  "+Alltrim(Upper(SB1->B1_XDESM2))+"  "+Alltrim(Upper(SB1->B1_XDESM3)),"N",cTpFonte,cFonte1) 
ElseIf _nLang = 2
	MSCBSAY(05,29,"MP: "+Alltrim(Upper(SB1->B1_XDESMI1))+"  "+Alltrim(Upper(SB1->B1_XDESMI2))+"  "+Alltrim(Upper(SB1->B1_XDESMI3)),"N",cTpFonte,cFonte1) 
ElseIf _nLang = 3
	MSCBSAY(05,29,"MP: "+Alltrim(Upper(SB1->B1_XDESME1))+"  "+Alltrim(Upper(SB1->B1_XDESME2))+"  "+Alltrim(Upper(SB1->B1_XDESME3)),"N",cTpFonte,cFonte1) 
EndIf
         
MSCBGRAFIC(12,31,"AMPULHET")

If Empty(_cValid) .And. SB1->B1_XSTERI = "1" 										  		// Incluido em 03/02/2015
	_cValid := (_dFabric+1)+(365*5)    														// Incluido em 03/02/2015
	MSCBSAY(09,38,Dtoc(_cValid),"N",cTpFonte,cFonte2)  						  			// Incluido em 03/02/2015
ElseIf SB1->B1_XSTERI = "1"      															   // Incluido em 03/02/2015
	MSCBSAY(IIf("VAL" $ Upper(_cValid),05,09),38,_cValid,"N",cTpFonte,cFonte2)  	// Incluido em 03/02/2015
EndIf										  												            // Incluido em 03/02/2015

//Validacao para 10 anos 
If Empty(_cValid) .And. SB1->B1_XSTERI = "2" 										  		// Incluido em 14/09/2017 Por Samuel Miranda A pedido do Fabiano A. Regulatorio
	_cValid := (_dFabric+1)+(365*10)    														// Incluido em 14/09/2017 Por Samuel Miranda A pedido do Fabiano A. Regulatorio
	MSCBSAY(09,38,Dtoc(_cValid),"N",cTpFonte,cFonte2)  						  			// Incluido em 14/09/2017 Por Samuel Miranda A pedido do Fabiano A. Regulatorio
ElseIf SB1->B1_XSTERI = "2"      															   // Incluido em 14/09/2017 Por Samuel Miranda A pedido do Fabiano A. Regulatorio
	MSCBSAY(IIf("VAL" $ Upper(_cValid),05,09),38,_cValid,"N",cTpFonte,cFonte2)  	// Incluido em 14/09/2017 Por Samuel Miranda A pedido do Fabiano A. Regulatorio
EndIf
	If SB1->B1_XSTERI = "2"
			If _nLang <> 2
			  	//MSCBSAY(02,38,dToc(_cValid),"N",cTpFonte,cFonte2) 
				MSCBSAY(60,60,"Val. "+ dToc(_cValid),"N",cTpFonte,cFonte2)//Destaque 01 
				MSCBSAY(60,74,"Val. "+ dToc(_cValid),"N",cTpFonte,cFonte2)//Destaque 02 
				MSCBSAY(60,89,"Val. "+ dToc(_cValid),"N",cTpFonte,cFonte2)//Destaque 03   
			Else
				//MSCBSAY(02,38,dToc(_cValid),"N",cTpFonte,cFonte2) 
				MSCBSAY(60,60,"Val. "+ dToc(_cValid),"N",cTpFonte,cFonte2)//Destaque 01 
				MSCBSAY(60,74,"Val. "+ dToc(_cValid),"N",cTpFonte,cFonte2)//Destaque 02 
				MSCBSAY(60,89,"Val. "+ dToc(_cValid),"N",cTpFonte,cFonte2)//Destaque 03  
  		EndIf
	EndIf 

//Colocado essa codicao 
MSCBSAY(60,60,IIf(SB1->B1_XSTERI = "1","Val. "+ dToc(_cValid),""),"N",cTpFonte,cFonte4)//Destaque 01 
MSCBSAY(60,74,IIf(SB1->B1_XSTERI = "1","Val. "+ dToc(_cValid),""),"N",cTpFonte,cFonte4)//Destaque 02
MSCBSAY(60,89,IIf(SB1->B1_XSTERI = "1","Val. "+ dToc(_cValid),""),"N",cTpFonte,cFonte4)//Destaque 03

//Colocado essa codicao


MSCBGRAFIC(25,31,"FABRICAB")
MSCBSAY(23,38,dToc(_dFabric),"N",cTpFonte,cFonte2)                         

If SB1->B1_XUNICO ="1"
	MSCBGRAFIC(38,31,"USOUNICO")
	MSCBSAY(37,38,IIf(_nLang=1,"Uso Unico",IIf(_nLang=2,"Single use","De un solo uso")),"N",cTpFonte,cFonte2)    // MAURICIO 12/08/14 MSCBSAY(37,38,"Uso Unico","N",cTpFonte,cFonte2) 
EndIf

If SB1->B1_XCE0434 = "1"     
   	MSCBGRAFIC(51,32,"02CE")
    MSCBSAY(53,38,"2460","N",cTpFonte,cFonte2)//Alterado no dia 03/07/2018 por Mauricio, apedido do Fabiano Depto. Assu. Regulatorios
EndIf

MSCBGRAFIC(65,30,"COPO")

If SB1->B1_XHUMID = "1"
	MSCBGRAFIC(77,31,"UMIDADE")
EndIf

MSCBGRAFIC(89,31,"TERMOMET")

MSCBBOX(04,40,45,54,3)
MSCBSAYBAR(08,40,Alltrim(SB1->B1_CODBAR),"N","MB04",8,.F.,.T.,.F.,,3,2,.F.) // ALTERADO CLAUDIO ERA: MSCBSAYBAR(08,40,Alltrim(SB1->B1_CODBAR),"N","MB04",10,.F.,.T.,.F.,,3,2,.F.)
MSCBSAYBAR(00,02,Alltrim(Upper(_cLote)),"B","MB07",4,.F.,.F.,.F.,,2,2,.F.)

MSCBSAY(46,40,"European Authorized representative Obelis SA","N",cTpFonte,cFonte2)
MSCBSAY(46,42,"Bd. Generl Wahis 53 1030 Brusseis, BELGIUM","N",cTpFonte,cFonte2)
MSCBSAY(46,44,"Tel +(32)2.732.59.54 Fax +(32)2.732.60,03","N",cTpFonte,cFonte2)
MSCBSAY(46,46,"Email: mail@obelis.net - Resp. Verificacao: F. MARTINS","N",cTpFonte,cFonte2)  //ALTERADO A SIGLA DE J.S.S  P/ H.R DIA 07/10/15 POR SAMUEL MIRANDA
MSCBSAY(46,48,"Resp. Tecnico: CARLOS M. NAKAMURA/CREA N. 0601828973","N",cTpFonte,cFonte2)


If SB1->B1_XINSTRU = "1"
	MSCBSAY(46,50,"Instrucoes de uso acesse em www.ortosintese.com.br","N",cTpFonte,cFonte2)
EndIf 



MSCBBOX(90,40,95,45,3)
MSCBBOX(95,40,100,45,3)
MSCBSAY(91,42,"EC","N",cTpFonte,cFonte4) 
MSCBSAY(96,42,"REP","N",cTpFonte,cFonte4)
		
MSCBEND() 
MSCBCLOSEPRINTER()	
MS_FLUSH()

Set(_SET_DATEFORMAT, 'dd/mm/yyyy')

Return()


Static Function VerSx1()

Local aArea := GetArea()
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o código do produto.            " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("REST11","01","Codigo do Produto ? ","Codigo do Produto ?","Codigo do Produto ? ","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.REST1101.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o lote do produto.              " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("REST11","02","Lote ? ","Lote ?","Lote ? ","mv_chb","C",10,0,0,"G","","","","","mv_par02",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.REST1102.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a quantidade do produto.        " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("REST11","03","Peças por Embalagem? ","Quantidade ?","Quantidade ? ","mv_chc","N",10,2,0,"G","","","","","mv_par03",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.REST1103.",aHelpPor,aHelpEng,aHelpSpa)

PutSx1("REST11","04","Idioma ? ","Idioma ?","Idioma ? ","mv_ch4","N",01,0,1,"C","","","","","mv_par04",;
"Portugues","Portugues","Portugues","Ingles","Ingles","Ingles","Espanhol","Espanhol","Espanhol","","","","","","","","","","","","","","","","")

PutSx1("REST11","05","Validade Lote ? ","Validade Lote ?","Validade Lote ? ","mv_ch5","C",30,0,0,"G","","","","","mv_par05",;
"","","","","","","","","","","","","","","","","","","","","","","","","")

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a data de fabricação.           " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("REST11","06","Data Fabricacao ? ","Data Fabricacao ?","Data Fabricacao ? ","mv_ch6","D",8,0,0,"G","","","","","mv_par06",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.REST1106.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
/*
Aadd( aHelpPor, "Informe o código da Comunidade Européia." )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR001","07","Comunidade Europeia ? ","Comunidade Europeia ?","Comunidade Europeia ? ","mv_ch7","N",10,0,0,"G","","","","","mv_par07",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00107.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
*/
Aadd( aHelpPor, "Informe a Data de Esterilizacao 			" )
Aadd( aHelpPor, "do Produto                                       " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("REST11","07","Data Esterilização? ","Data Esteril. ?","Data Esteril. ? ","mv_ch7","D",8,0,0,"G","","","","","mv_par07",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.REST1107.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a quantidade de copias a ser    " )
Aadd( aHelpPor, "impressa.                               " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("REST11","08","Qtde Rótulos ? ","Quantidade Copias ?","Quantidade Copias ? ","mv_ch8","N",3,0,0,"G","","","","","mv_par08",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.REST1108.",aHelpPor,aHelpEng,aHelpSpa)

RestArea(aArea)
Return() 