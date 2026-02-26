#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR001 ºAutor  ³Totvs               º Data ³  14/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de para impressao de etiquetas de produtos com      º±±
±±º          ³ codigo de barras.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTR001()

Local aSay := {}
Local aButton := {}
Local nOpc := 0
Local cTitulo := "Impressão de etiqueta de Produtos com Código de Barras."

Private cDesc1 := "Este programa irá imprimir as etiquetas de Produto com"
Private cDesc2 := "código de barras, em impressora térmica Zebra, "
Private cDesc3 := "conforme os parâmetros definidos pelo usuário."
Private cDesc4 := ""
Private cDesc5 := ""
Private cPerg  := Padr("RESTR001",10)
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
	RptStatus({|lEnd| U_RESTR01Imp(@lEnd,mv_par01,mv_par02,mv_par03,mv_par05,mv_par06,mv_par07,mv_par08,mv_par04)},"Imprimindo, aguarde...")
Endif	

Return()


User Function RESTR01Imp(lEnd,_cProd,_cLote,_nQuant,_cValid,_dFabric,_dDtEmis,_nCop,_nLang)
// lEnd Default == .F.
// _cProd	:= Codigo do Produto a Ser Impresso
// _cLote	:= Lote do Produto
// _nQtde	:= Quantidade (Informada no Parametro - Analisar quando for da OP - qual QTDE Trazer
// _cValid	:= Texto com a Data da Validade ou Literal: Val Indeterminada
// _dFabric := Data da Fabricacao do Produto
// _dDtEmis	:= Campo Data mal definido no levantamento - Quando automatico trazer dDatabase
// _nCop		:= Numero de Copias de Etiqueta.
// _nLang	:= 1=Port / 2=Ingles / 3=Spanish

Local nCopias := _nCop
Local cImpressora := "ZEBRA"
Local cPorta := "LPT1"
Local cTpFonte := "0"
Local cFonte1 := "020,020"
Local cFonte2 := "017,017"
Local cFonte3 := "024,024"
Local cFonte4 := "015,015"
Local cFonte5 := "016,016"

If _nLang == 2
	Set(_SET_DATEFORMAT, 'yyyy/mm/dd') //ALTERADO POR WAGNER LIMA CONFORME SOLCITACAO DO SR. EDSON DE 'mm/dd/yyyy' PARA 'yyyy/mm/dd'
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

MSCBLOADGRAF("ORTO.GRF")
MSCBLOADGRAF("FABRICA.GRF")                                                                   
MSCBLOADGRAF("WARNING.GRF")
MSCBLOADGRAF("AMPULHET.GRF")
MSCBLOADGRAF("FABRICAB.GRF")
MSCBLOADGRAF("USOUNICO.GRF")
MSCBLOADGRAF("02CE.GRF")
MSCBLOADGRAF("COPO.GRF")
MSCBLOADGRAF("TERMOMET.GRF")
MSCBLOADGRAF("UMIDADE.GRF")
MSCBLOADGRAF("NEMBAL.GRF")
MSCBLOADGRAF("NSTERIL.GRF")

MSCBBEGIN(nCopias,4)          

MSCBGRAFIC(04,01,"ORTO")
MSCBSAY(15,01,"ORTOSINTESE IND. E COM. LTDA","N",cTpFonte,cFonte1)   	
MSCBGRAFIC(75,01,"WARNING")
If SB1->B1_XSTERI = "2" 
	MSCBBOX(85,01,100,4,3)
Else
	MSCBBOX(85,01,95,4,3)
	MSCBBOX(95,01,100,4,3)
Endif	 

if _nLang = 1  // ALTERADO POR SAMUEL MIRANDA DIA 25/05/2016.... Foi Colocado um if para a _nLang
	MSCBSAY(86,02,IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL"),"N",cTpFonte,cFonte4) 
ElseIf  _nLang = 2
	MSCBSAY(86,02,IIf(SB1->B1_XSTERI = "2","NO STERILE","STERILE"),"N",cTpFonte,cFonte4) 
EndIf
//MSCBSAY(86,02,IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL"),"N",cTpFonte,cFonte4) 
MSCBSAY(96,02,IIf(SB1->B1_XSTERI = "1",IIf(SB1->B1_XSTETP = "2","EO","R"),""),"N",cTpFonte,cFonte4)
MSCBSAY(15,04,"Av Nelson Palma Travassos, 651"+"-Cep:02998-000","N",cTpFonte,cFonte5) //AllTrim(SM0->M0_ENDCOB) Transform(SM0->M0_CEPCOB,"@R 9999-999")
MSCBGRAFIC(65,03,"FABRICA")

//MSCBSAY(87,05,dToc(_dDtEmis),"N",cTpFonte,cFonte2)
MSCBSAY(87,05,IIf(SB1->B1_XSTERI = "1",dToc(_dFabric),""),"N",cTpFonte,cFonte2) //Alterado a Variavel _dDtEmis para _dFabric no dis 13/12/2016 por Samuel Miranda

MSCBSAY(15,06,"Tel.: 55(11)39484000 - FAX: 55(11)39484010","N",cTpFonte,cFonte2)
MSCBSAY(72,07,IIf(_nLang=1,"Ver Instrucao",IIf(_nLang=2,"See instruction","Ver instrucciones")),"N",cTpFonte,cFonte2)   //MSCBSAY(72,07,"Ver Instrucao","N",cTpFonte,cFonte2)
MSCBBOX(85,07,100,12,3)

If SB1->B1_XUNICO ="1"
    MSCBSAY(89,08,IIf(_nLang=1,"Proibido",IIf(_nLang=2,"Do not","Prohibida")),"N",cTpFonte,cFonte2)    // MAURICIO 12/08/14 MSCBSAY(89,08,"Proibido","N",cTpFonte,cFonte2)
EndIf

MSCBSAY(15,08,"Brasil - Site: www.ortosintese.com.br","N",cTpFonte,cFonte2)
MSCBSAY(75,09,IIf(_nLang=1,"de uso",IIf(_nLang=2,"for use","de uso")),"N",cTpFonte,cFonte2) //MSCBSAY(75,09,"de Uso","N",cTpFonte,cFonte2)

If SB1->B1_XUNICO ="1"
	MSCBSAY(87,10,IIf(_nLang=1,"Reprocessar",IIf(_nLang=2,"Reprocess","Reprocessar")),"N",cTpFonte,cFonte2)  // 12/08/14  MSCBSAY(87,10,"Reprocessar","N",cTpFonte,cFonte2)
EndIf

MSCBBOX(05,12,40,16,3)
MSCBBOX(40,12,75,16,3)
MSCBBOX(75,12,100,16,3)

MSCBSAY(06,13,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte3)
MSCBSAY(41,13,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte3) //MSCBSAY(41,13,"Lote:"+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte3)

//Por Samuel miranda 10/10/2018
B1_XDMCI := Alltrim(StrTran(Alltrim(B1_XDMCI),"Ø",""))              
B1_XDMCI := Alltrim(StrTran(Alltrim(B1_XDMCI),"º","§")) 
B1_XDMCI := Alltrim(StrTran(Alltrim(B1_XDMCI),"°","§"))  

B1_XDNCP := Alltrim(StrTran(Alltrim(B1_XDNCP),"Ø",""))              
B1_XDNCP := Alltrim(StrTran(Alltrim(B1_XDNCP),"º","§")) 
B1_XDNCP := Alltrim(StrTran(Alltrim(B1_XDNCP),"°","§")) 

B1_XDNTP := Alltrim(StrTran(Alltrim(B1_XDNTP),"Ø",""))              
B1_XDNTP := Alltrim(StrTran(Alltrim(B1_XDNTP),"º","§")) 
B1_XDNTP := Alltrim(StrTran(Alltrim(B1_XDNTP),"°","§")) 

MSCBSAY(76,13,"Quant.:"+Alltrim(Str(_nQuant))+" pc","N",cTpFonte,cFonte3)

MSCBSAY(05,17,IIf(_nLang=1,SB1->B1_XDMCP,IIf(_nLang=2,SB1->B1_XDMCI,SB1->B1_XDMCE)),"N",cTpFonte,cFonte1)
MSCBSAY(05,20,IIf(_nLang=1,SB1->B1_XDNCP,IIf(_nLang=2,SB1->B1_XDNCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte1)
MSCBSAY(05,23,IIf(_nLang=1,SB1->B1_XDNTP,IIf(_nLang=2,SB1->B1_XDNTI,SB1->B1_XDNTE)),"N",cTpFonte,cFonte1)
// ALTERADO POR MAURICIO PRADO A PEDIDO DE WAGNER/FABIANO. PARA COMECAR A IMPRIMIR REGISTRO DA FILIAL
If SB1->B1_XANVEMP ="1"
	MSCBSAY(05,26,"Registro ANVISA:  1022371" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)
ElseIf SB1->B1_XANVEMP ="2"
	MSCBSAY(05,26,"Registro ANVISA:  8120219" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)
EndIf



If _nLang = 1
	MSCBSAY(05,29,"MP: "+Alltrim(Upper(SB1->B1_XDESM1))+"  "+Alltrim(Upper(SB1->B1_XDESM2))+"  "+Alltrim(Upper(SB1->B1_XDESM3)),"N",cTpFonte,cFonte1) 
ElseIf _nLang = 2
	MSCBSAY(05,29,"MP: "+Alltrim(Upper(SB1->B1_XDESMI1))+"  "+Alltrim(Upper(SB1->B1_XDESMI2))+"  "+Alltrim(Upper(SB1->B1_XDESMI3)),"N",cTpFonte,cFonte1) 
ElseIf _nLang = 3
	MSCBSAY(05,29,"MP: "+Alltrim(Upper(SB1->B1_XDESME1))+"  "+Alltrim(Upper(SB1->B1_XDESME2))+"  "+Alltrim(Upper(SB1->B1_XDESME3)),"N",cTpFonte,cFonte1) 
EndIf
         
MSCBGRAFIC(05,31,"AMPULHET")

If Empty(_cValid) .And. SB1->B1_XSTERI = "1" 										  		// Incluido em 03/02/2015
	_cValid := (_dFabric+1)+(365*5)    														// Incluido em 03/02/2015
	MSCBSAY(01,38,Dtoc(_cValid),"N",cTpFonte,cFonte2)  						  			// Incluido em 03/02/2015
ElseIf SB1->B1_XSTERI = "1"      																// Incluido em 03/02/2015
	MSCBSAY(IIf("VAL" $ Upper(_cValid),05,09),38,_cValid,"N",cTpFonte,cFonte2)  // Incluido em 03/02/2015
EndIf										  																// Incluido em 03/02/2015

If SB1->B1_XSTERI = "2"
	If _nLang <> 2
		MSCBSAY(01,38,"Val. Indeterminada","N",cTpFonte,cFonte4)  //Alterado para Val. Indeterminada por SAMUEL MIRANDA	 DATA 23/01/2017
	Else
		MSCBSAY(04,38,"10 Years","N",cTpFonte,cFonte4) //Alterado de "Undetermined" para 10 Years por SAMUEL MIRANDA	 DATA 25/11/2016
	EndIf
EndIf

MSCBGRAFIC(20,31,"FABRICAB") //MSCBGRAFIC(15,31,"FABRICAB") alterador por Samuel Miranda dia 23/01/2017
MSCBSAY(18,38,dToc(_dFabric),"N",cTpFonte,cFonte2)  //MSCBSAY(23,38,dToc(_dFabric),"N",cTpFonte,cFonte2) alterador por Samuel Miranda dia 23/01/2017                       

If SB1->B1_XUNICO ="1"
	MSCBGRAFIC(35,31,"USOUNICO")//MSCBGRAFIC(25,31,"USOUNICO")alterador por Samuel Miranda dia 23/01/2017
	MSCBSAY(34,38,IIf(_nLang=1,"Uso Unico",IIf(_nLang=2,"Single use","De un solo uso")),"N",cTpFonte,cFonte2)    // MAURICIO 12/08/14 MSCBSAY(37,38,"Uso Unico","N",cTpFonte,cFonte2) 
EndIf

If SB1->B1_XCE0434 = "1"  //Alterado no dia 03/07/2018 por Mauricio, apedido do Fabiano Depto. Assu. Regulatorios 
	MSCBGRAFIC(50,32,"02CE") //MSCBGRAFIC(35,32,"02CE")
    MSCBSAY(52,38,"2460","N",cTpFonte,cFonte2)//	MSCBSAY(37,38,"0434","N",cTpFonte,cFonte2)
EndIf

MSCBGRAFIC(65,30,"COPO")  //MSCBGRAFIC(45,30,"COPO")

If SB1->B1_XHUMID = "1"
	MSCBGRAFIC(75,31,"UMIDADE")  //MSCBGRAFIC(55,31,"UMIDADE")
EndIf

MSCBGRAFIC(88,31,"TERMOMET") //MSCBGRAFIC(65,31,"TERMOMET")
// Nova imagem inserida a pedido da Camila Regulatoria (Start Mauricio)
//MSCBGRAFIC(78,31,"NEMBAL")
//MSCBGRAFIC(90,31,"NSTERIL")
// Nova imagem inserida a pedido da Camila Regulatoria (Finalizado por Wagner)
 
MSCBBOX(04,40,45,54,3)
MSCBSAYBAR(08,40,Alltrim(SB1->B1_CODBAR),"N","MB04",8,.F.,.T.,.F.,,3,2,.F.) // ALTERADO CLAUDIO ERA: MSCBSAYBAR(08,40,Alltrim(SB1->B1_CODBAR),"N","MB04",10,.F.,.T.,.F.,,3,2,.F.)
MSCBSAYBAR(00,02,Alltrim(Upper(_cLote)),"B","MB07",4,.F.,.F.,.F.,,2,2,.F.)

MSCBSAY(46,40,"European Authorized representative Obelis SA","N",cTpFonte,cFonte2)
MSCBSAY(46,42,"Bd. Generl Wahis 53 1030 Brusseis, BELGIUM","N",cTpFonte,cFonte2)
MSCBSAY(46,44,"Tel +(32)2.732.59.54 Fax +(32)2.732.60,03","N",cTpFonte,cFonte2)
MSCBSAY(46,46,"Email: mail@obelis.net - Resp. Verificacao: F. MARTINS","N",cTpFonte,cFonte2)  //ALTERADO A SIGLA DE H.R  P/ FELIPE N. DIA 18/08/16 POR SAMUEL MIRANDA

//MSCBSAY(46,48,"Resp. Tecnico: CARLOS M. NAKAMURA/CREA N. 0601828973","N",cTpFonte,cFonte2)

if _nLang = 1 	// ALTERADO POR SAMUEL MIRANDA DIA 25/05/2016.... FOI COLOCADO A CODIO o if para a _nLang
	MSCBSAY(46,48,"Resp.Tecnico:CARLOS M. NAKAMURA/CREA N. 0601828973","N",cTpFonte,cFonte2)
ElseIf _nLang = 2
	MSCBSAY(46,48,"Resp.Technician:CARLOS M. NAKAMURA/CREA N.0601828973","N",cTpFonte,cFonte2)
 //	MSCBSAY(46,50,"CREA N. 0601828973","N",cTpFonte,cFonte2)
EndIf

if _nLang = 1   // ALTERADO POR SAMUEL MIRANDA DIA 25/05/2016.... FOI COLOCADO O PRIMEIRO IF
	If SB1->B1_XINSTRU = "1"
		MSCBSAY(46,50,"Instrucoes de uso acesse em www.ortosintese.com.br","N",cTpFonte,cFonte2)
	EndIf
EndIf

//If SB1->B1_XINSTRU = "1"
  //	MSCBSAY(46,50,"Instrucoes de uso acesse em www.ortosintese.com.br","N",cTpFonte,cFonte2)
//EndIf

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

PutSx1("RESTR001","01","Codigo do Produto ? ","Codigo do Produto ?","Codigo do Produto ? ","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00101.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe o lote do produto.              " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR001","02","Lote ? ","Lote ?","Lote ? ","mv_chb","C",10,0,0,"G","","","","","mv_par02",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00102.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a quantidade do produto.        " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR001","03","Peças por Embalagem? ","Quantidade ?","Quantidade ? ","mv_chc","N",10,2,0,"G","","","","","mv_par03",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00103.",aHelpPor,aHelpEng,aHelpSpa)

PutSx1("RESTR001","04","Idioma ? ","Idioma ?","Idioma ? ","mv_ch4","N",01,0,1,"C","","","","","mv_par04",;
"Portugues","Portugues","Portugues","Ingles","Ingles","Ingles","Espanhol","Espanhol","Espanhol","","","","","","","","","","","","","","","","")

PutSx1("RESTR001","05","Validade Lote ? ","Validade Lote ?","Validade Lote ? ","mv_ch5","C",30,0,0,"G","","","","","mv_par05",;
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

PutSx1("RESTR001","06","Data Fabricacao ? ","Data Fabricacao ?","Data Fabricacao ? ","mv_ch6","D",8,0,0,"G","","","","","mv_par06",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00106.",aHelpPor,aHelpEng,aHelpSpa)

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

PutSx1("RESTR001","07","Data Esterilização? ","Data Esteril. ?","Data Esteril. ? ","mv_ch7","D",8,0,0,"G","","","","","mv_par07",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00107.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a quantidade de copias a ser    " )
Aadd( aHelpPor, "impressa.                               " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("RESTR001","08","Qtde Rótulos ? ","Quantidade Copias ?","Quantidade Copias ? ","mv_ch8","N",3,0,0,"G","","","","","mv_par08",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.RESTR00108.",aHelpPor,aHelpEng,aHelpSpa)

RestArea(aArea)
Return()