#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR038 º Autor ³Samuel Miranda      º Data ³  26/03/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de para impressao de etiquetas de produtos com      º±±
±±º          ³ codigo de barras.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESTR038()

Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo 	:= "Impressão de etiqueta de Produtos com Código de Barras."

Private cDesc1 	:= "Este programa irá imprimir as etiquetas de Produto com"
Private cDesc2 	:= "código de barras, em impressora térmica Zebra, "
Private cDesc3 	:= "conforme os parâmetros definidos pelo usuário."
Private cDesc4 	:= ""
Private cDesc5 	:= ""
Private cPerg  	:= Padr("RESTR038",10)
Private lEnd 		:= .F.

ValidPerg() //Chama a função das Perguntas

If !Pergunte(cPerg,.T.) //Validação das Perguntas
	Return()
Endif	

//Monta a Interface 
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
	RptStatus({|lEnd| U_RESTR38Imp(@lEnd,mv_par01,mv_par02,mv_par03,mv_par05,mv_par06,mv_par07,mv_par08,mv_par04)},"Imprimindo, aguarde...")
Endif	

Return()

User Function RESTR38Imp(lEnd,_cProd,_cLote,_nQuant,_cValid,_dFabric,_dDtEmis,_nCop,_nLang)
// lEnd Default == .F.
// _cProd	:= Codigo do Produto a Ser Impresso
// _cLote	:= Lote do Produto
// _nQtde	:= Quantidade (Informada no Parametro - Analisar quando for da OP - qual QTDE Trazer
// _cValid	:= Texto com a Data da Validade ou Literal: Val Indeterminada
// _dFabric := Data da Fabricacao do Produto
// _dDtEmis	:= Campo Data mal definido no levantamento - Quando automatico trazer dDatabase
// _nCop	:= Numero de Copias de Etiqueta.
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

//MSCBLOADGRAF("ORTO.GRF")
MSCBLOADGRAF("LOG3.GRF")
MSCBLOADGRAF("FABRICA.GRF")                                                                   
//MSCBLOADGRAF("WARNING.GRF")
MSCBLOADGRAF("ATTENCAO.GRF")
MSCBLOADGRAF("AMPULHET.GRF")                                      
MSCBLOADGRAF("FABRICAB.GRF")
MSCBLOADGRAF("USOUNICO.GRF")
//MSCBLOADGRAF("02CE.GRF")
MSCBLOADGRAF("COPO.GRF")
MSCBLOADGRAF("TERMOMET.GRF")
MSCBLOADGRAF("UMIDADE.GRF") 
MSCBLOADGRAF("10.GRF") //Logo Nao Esteril 
MSCBLOADGRAF("25GRAU.GRF") //Imagem 25 Grau   
MSCBLOADGRAF("UNICO5.GRF")

                                                          
MSCBBEGIN(nCopias,4)          

MSCBGRAFIC(06,01,"LOG3")
MSCBSAY(15,01,"ORTOSINTESE IND. E COM. LTDA","N",cTpFonte,cFonte1) 

MSCBGRAFIC(75,01,"ATTENCAO")
//MSCBGRAFIC(75,01,"ORT")
If SB1->B1_XSTERI = "2" 
	MSCBBOX(85,01,100,4,3)
	MSCBGRAFIC(66,31,"10")//Logo Nao Esteril
Else
	MSCBBOX(85,01,95,4,3)
	MSCBBOX(95,01,100,4,3)
Endif	 

if _nLang = 1  // ALTERADO POR SAMUEL MIRANDA DIA 25/05/2016.... Foi Colocado um if para a _nLang 
	MSCBSAY(86,02,IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL"),"N",cTpFonte,cFonte4) 		
ElseIf  _nLang = 2
	MSCBSAY(86,02,IIf(SB1->B1_XSTERI = "2","NO STERILE","STERILE"),"N",cTpFonte,cFonte4) 	
EndIf


If SB1->B1_XSTERI = "1" 
	If SB1->B1_XSTETP = "2"
		MSCBSAY(96,02,"EO" ,"N",cTpFonte,cFonte4)
	EndIf
	
	If SB1->B1_XSTETP = "1"
		MSCBSAY(96,02,"R" ,"N",cTpFonte,cFonte4)
	EndIf 
	
   If SB1->B1_XSTETP = " "
		MSCBSAY(96,02," " ,"N",cTpFonte,cFonte4)
	EndIf
EndIf

//MSCBSAY(96,02,IIf(SB1->B1_XSTERI = "1",IIf(SB1->B1_XSTETP = "2","EO","R"),""),"N",cTpFonte,cFonte4)


MSCBSAY(15,04,"Av Nelson Palma Travassos, 651"+"-Cep:02998-000","N",cTpFonte,cFonte5) //AllTrim(SM0->M0_ENDCOB) Transform(SM0->M0_CEPCOB,"@R 9999-999")
MSCBGRAFIC(65,03,"FABRICA")
//Alterado de _dDtEmis para _dFabric no dia 13/12/2016 por Samuel Mirada 
//cMes := SubStr(DtoS(_dFabric),5,2)
//cAno := SubStr(DtoS(_dFabric),1,4)
//dResut := cMes +"/"+cAno 
//MSCBSAY(89,05,IIf(SB1->B1_XSTERI = "1",dResut,""),"N",cTpFonte,cFonte2) //MSCBSAY(87,05,dToc(_dDtEmis),"N",cTpFonte,cFonte2) 
//MSCBSAY(89,05,IIf(_nLang=1,cMes +" / "+cAno,IIf(_nLang=2,cAno +" / "+cMes,"")),"N",cTpFonte,cFonte2)//Removido apedido do Fabiano no dia 14/01/2019

MSCBSAY(15,06,"Tel.: 55(11)39484000 - FAX: 55(11)39484010","N",cTpFonte,cFonte2)
MSCBSAY(72,08,IIf(_nLang=1,"Ver Instrucao",IIf(_nLang=2,"See instruction","Ver instrucciones")),"N",cTpFonte,cFonte2)   //MSCBSAY(72,07,"Ver Instrucao","N",cTpFonte,cFonte2)
MSCBBOX(85,07,100,12,3)

If SB1->B1_XUNICO ="1"
    MSCBSAY(89,08,IIf(_nLang=1,"Proibido",IIf(_nLang=2,"Do not","Prohibida")),"N",cTpFonte,cFonte2)    // MAURICIO 12/08/14 MSCBSAY(89,08,"Proibido","N",cTpFonte,cFonte2)
EndIf

MSCBSAY(15,08,"Sao Paulo-SP Brasil - Site: www.ortosintese.com.br","N",cTpFonte,cFonte2)
MSCBSAY(75,10,IIf(_nLang=1,"de uso",IIf(_nLang=2,"for use","de uso")),"N",cTpFonte,cFonte2) //MSCBSAY(75,09,"de Uso","N",cTpFonte,cFonte2)

If SB1->B1_XUNICO ="1"
	MSCBSAY(87,10,IIf(_nLang=1,"Reprocessar",IIf(_nLang=2,"Reprocess","Reprocessar")),"N",cTpFonte,cFonte2)  // 12/08/14  MSCBSAY(87,10,"Reprocessar","N",cTpFonte,cFonte2)
EndIf

MSCBBOX(05,12,40,16,3)
MSCBBOX(40,12,75,16,3)
MSCBBOX(75,12,100,16,3)

MSCBSAY(06,13,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte3) 
MSCBSAY(41,13,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte3) //MSCBSAY(41,13,"Lote:"+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte3)
MSCBSAY(76,13,"Quant.:"+Alltrim(Str(_nQuant))+" pc","N",cTpFonte,cFonte3)

portugues 		:= SB1->B1_XDMCP
ingles  		:= SB1->B1_XDMCI
//cTexto3 		:= SB1->B1_XDNTP

portugues := Alltrim(StrTran(Alltrim(portugues),"Ø",""))           
portugues := Alltrim(StrTran(Alltrim(portugues),"º","§")) 
portugues := Alltrim(StrTran(Alltrim(portugues),"°","§")) 
portugues := Alltrim(StrTran(Alltrim(portugues),"ï",""))
portugues := Alltrim(StrTran(Alltrim(portugues),"ï","Ø")) 
 

ingles := Alltrim(StrTran(Alltrim(ingles),"Ø",""))              
ingles := Alltrim(StrTran(Alltrim(ingles),"º","§")) 
ingles := Alltrim(StrTran(Alltrim(ingles),"°","§")) 
ingles := Alltrim(StrTran(Alltrim(ingles),"ï","")) 
ingles := Alltrim(StrTran(Alltrim(ingles),"ï","Ø")) 
 
//cTexto3 := Alltrim(StrTran(Alltrim(cTexto3),"Ø",""))              
//cTexto3 := Alltrim(StrTran(Alltrim(cTexto3),"º","§")) 
//cTexto3 := Alltrim(StrTran(Alltrim(cTexto3),"°","§")) 
//cTexto3 := Alltrim(StrTran(Alltrim(cTexto3),"ï",""))  
//cTexto3 := Alltrim(StrTran(Alltrim(cTexto1),"ï","Ø")) 

B1_XDMCP	:= portugues // Descricao em Portugues
B1_XDMCI 	:= ingles // Descricao em Engles
//SB1->B1_XDNCP	:= cTexto2  
//SB1->B1_XDNTP	:= cTexto3

MSCBSAY(05,17,IIf(_nLang=1,portugues,IIf(_nLang=2,ingles,SB1->B1_XDMCE)),"N",cTpFonte,cFonte1)
MSCBSAY(05,20,IIf(_nLang=1,SB1->B1_XDNCP,IIf(_nLang=2,SB1->B1_XDNCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte1)
//MSCBSAY(05,20,IIf(_nLang=1,SB1->B1_XDNCP,IIf(_nLang=2,SB1->B1_XDNCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte1)
MSCBSAY(05,23,IIf(_nLang=1,SB1->B1_XDNTP,IIf(_nLang=2,SB1->B1_XDNTI,SB1->B1_XDNTE)),"N",cTpFonte,cFonte1) 

If EMPTY(SB1->B1_XANVISA) //Adicionado em 18092017 a pedido do Leandro do PCP para produtos sem registro 
  MSCBSAY(05,26,IIf(_nLang=1,"Registro ANVISA: Exclusivo Mercado Externo",IIf(_nLang=2,"ANVISA Registration: Exclusive Foreign Market","")),"N",cTpFonte,cFonte1) 
  Else
		If SB1->B1_XANVEMP ="1"
			//MSCBSAY(05,26,"Registro ANVISA:  1022371" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)
			MSCBSAY(05,26,IIf(_nLang=1,"Registro ANVISA:  1022371",IIf(_nLang=2,"ANVISA Registration:  1022371",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)
		ElseIf SB1->B1_XANVEMP ="2"
			//MSCBSAY(05,26,"Registro ANVISA:  8120219" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)  
			MSCBSAY(05,26,IIf(_nLang=1,"Registro ANVISA:  8120219",IIf(_nLang=2,"ANVISA Registration:  8120219",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)
		EndIf
End If

If _nLang = 1
	MSCBSAY(05,29,"MP: "+Alltrim(Upper(SB1->B1_XDESM1))+"  "+Alltrim(Upper(SB1->B1_XDESM2))+"  "+Alltrim(Upper(SB1->B1_XDESM3)),"N",cTpFonte,cFonte1) 
ElseIf _nLang = 2
	MSCBSAY(05,29,"PM: "+Alltrim(Upper(SB1->B1_XDESMI1))+"  "+Alltrim(Upper(SB1->B1_XDESMI2))+"  "+Alltrim(Upper(SB1->B1_XDESMI3)),"N",cTpFonte,cFonte1) 
ElseIf _nLang = 3
	MSCBSAY(05,29,"MP: "+Alltrim(Upper(SB1->B1_XDESME1))+"  "+Alltrim(Upper(SB1->B1_XDESME2))+"  "+Alltrim(Upper(SB1->B1_XDESME3)),"N",cTpFonte,cFonte1) 
EndIf
         
//Validacao para 10 anos  
/* 
If Empty(_cValid) .And. SB1->B1_XSTERI = "2" 															// Incluido em 14/09/2017 Por Samuel Miranda A pedido do Fabiano A. Regulatorio
	_cValid := (_dFabric+1)+(365*10)  
	cMes := SubStr(DtoS(_cValid),5,2)
	cAno := SubStr(DtoS(_cValid),1,4)  																		// Incluido em 14/09/2017 Por Samuel Miranda A pedido do Fabiano A. Regulatorio
	//MSCBSAY(17,38,Dtoc(_cValid),"N",cTpFonte,cFonte2)  						  		  				// Incluido em 14/09/2017 Por Samuel Miranda A pedido do Fabiano A. Regulatorio
	MSCBSAY(20,38,IIf(_nLang=1,cMes +"/"+cAno,IIf(_nLang=2,cAno +"/"+cMes,"")),"N",cTpFonte,cFonte2)
ElseIf SB1->B1_XSTERI = "2"      																			// Incluido em 14/09/2017 Por Samuel Miranda A pedido do Fabiano A. Regulatorio
  //	MSCBSAY(IIf("VAL" $ Upper(_cValid),05,09),38,_cValid,"N",cTpFonte,cFonte2) 			// Incluido em 14/09/2017 Por Samuel Miranda A pedido do Fabiano A. Regulatorio
	cMes := SubStr(DtoS(_cValid),5,2)
	cAno := SubStr(DtoS(_cValid),1,4)
	If _nLang=1
	MSCBSAY(IIf("VAL" $ Upper(cMes +"/"+cAno),05,09),38,cMes +"/"+cAno,"N",cTpFonte,cFonte2) //Adiciona A pedido do Fabiano Lopes dia 20/11/2018 por samuel Miranda                       
	End if
	If _nLang=2
	MSCBSAY(IIf("VAL" $ Upper(cAno +"/"+cMes),05,09),38,cAno +"/"+cMes,"N",cTpFonte,cFonte2) //Adiciona A pedido do Fabiano Lopes dia 20/11/2018 por samuel Miranda                       
	End if
EndIf
*/

//Validacao Indeterminada 

If SB1->B1_XSTERI = "2"
	If _nLang <> 2
		MSCBSAY(17,38,"Indeterminada","N",cTpFonte,cFonte2) 		  
	Else
		MSCBSAY(17,38,"Undetermined","N",cTpFonte,cFonte2) 		
  	EndIf
EndIf   


MSCBGRAFIC(05,31,"FABRICAB")
cMes := SubStr(DtoS(_dFabric),5,2)
cAno := SubStr(DtoS(_dFabric),1,4)
//dResut := cMes +"/"+cAno 
//MSCBSAY(04,38,dResut,"N",cTpFonte,cFonte2)                         
MSCBSAY(05,38,IIf(_nLang=1,cMes +"/"+cAno,IIf(_nLang=2,cAno +"/"+cMes,"")),"N",cTpFonte,cFonte2)//Adiciona A pedido do Fabiano Lopes dia 20/11/2018 por samuel Miranda 
                    
MSCBGRAFIC(20,31,"AMPULHET")    //MSCBGRAFIC(20,31,"FABRICAB")
If Empty(_cValid) .And. SB1->B1_XSTERI = "1" 								 	// Incluido em 03/02/2015
  	_cValid := (_dFabric+1)+(365*5)
	cMes := SubStr(DtoS(_cValid),5,2)
	cAno := SubStr(DtoS(_cValid),1,4)
	//dResut := cMes +"/"+cAno   											// Incluido em 03/02/2015
	//MSCBSAY(19,38,dResut,"N",cTpFonte,cFonte2)  	 //MSCBSAY(19,38,dResut,"N",cTpFonte,cFonte2)					  	// Incluido em 03/02/2015   
	MSCBSAY(19,38,IIf(_nLang=1,cMes +"/"+cAno,IIf(_nLang=2,cAno +"/"+cMes,"")),"N",cTpFonte,cFonte2)//Adiciona A pedido do Fabiano Lopes dia 20/11/2018 por samuel Miranda                       
ElseIf SB1->B1_XSTERI = "1"      												// Incluido em 03/02/2015
	cMes := SubStr(DtoS(_cValid),5,2)
	cAno := SubStr(DtoS(_cValid),1,4)
	//dResut := cMes +"/"+cAno 
	//MSCBSAY(IIf("VAL" $ Upper(dResut),05,09),38,dResut,"N",cTpFonte,cFonte2)  // Incluido em 03/02/2015  
	If _nLang=1
	MSCBSAY(IIf("VAL" $ Upper(cMes +"/"+cAno),05,09),38,cMes +"/"+cAno,"N",cTpFonte,cFonte2) //Adiciona A pedido do Fabiano Lopes dia 20/11/2018 por samuel Miranda                       
	End if
	If _nLang=2
	MSCBSAY(IIf("VAL" $ Upper(cAno +"/"+cMes),05,09),38,cAno +"/"+cMes,"N",cTpFonte,cFonte2) //Adiciona A pedido do Fabiano Lopes dia 20/11/2018 por samuel Miranda                       
	End if
EndIf	

//Verifica se se o produto está marcado para uso unico
If SB1->B1_XUNICO ="1"
	MSCBGRAFIC(34,32,"UNICO5")
	//MSCBSAY(33,38,IIf(_nLang=1,"Uso Unico",IIf(_nLang=2,"Single use","De un solo uso")),"N",cTpFonte,cFonte2	//Samuel Miranda 20190627 retirado a pedido da Lulliz assunt. Regulatorios)    // MAURICIO 12/08/14 MSCBSAY(37,38,"Uso Unico","N",cTpFonte,cFonte2) 
EndIf

//Impressao CE
//If SB1->B1_XCE0434 = "1"     //Alterado no dia 03/07/2018 por Mauricio, apedido do Fabiano Depto. Assu. Regulatorios
//	MSCBGRAFIC(47,32,"02CE")
//    MSCBSAY(49,38,"2460","N",cTpFonte,cFonte2)
//EndIf

//Impressao  Copo
MSCBGRAFIC(58,30,"COPO")

If SB1->B1_XHUMID = "1"
	MSCBGRAFIC(77,31,"UMIDADE")
EndIf

//Impressao  do Termometro
MSCBGRAFIC(89,30,"TERMOMET")

//Impressao  dos cosdigos de Barra (Lote e Refrencia
MSCBBOX(04,40,45,54,3)
MSCBSAYBAR(08,40,Alltrim(SB1->B1_CODBAR),"N","MB04",8,.F.,.T.,.F.,,3,2,.F.) // ALTERADO CLAUDIO ERA: MSCBSAYBAR(08,40,Alltrim(SB1->B1_CODBAR),"N","MB04",10,.F.,.T.,.F.,,3,2,.F.)
MSCBSAYBAR(00,02,Alltrim(Upper(_cLote)),"B","MB07",4,.F.,.F.,.F.,,2,2,.F.)


//MSCBSAY(46,40,"European Authorized Representative Obelis SA","N",cTpFonte,cFonte2)
//MSCBSAY(46,42,"Bd. General Wahis 53 1030 Brusseis, BELGIUM","N",cTpFonte,cFonte2)
//MSCBSAY(46,44,"Tel +(32)2.732.59.54 Fax +(32)2.732.60,03","N",cTpFonte,cFonte2)
////MSCBSAY(46,46,IIf(_nLang=1,"Email: mail@obelis.net - Resp. Verificacao: F. MARTINS",IIf(_nLang=2,"Email: mail@obelis.net - Verication Resp.: F. MARTINS","")),"N",cTpFonte,cFonte2)  //ALTERADO A SIGLA DE J.S.S  P/ H.R DIA 07/10/15 POR SAMUEL MIRANDA
//if _nLang = 1
//	MSCBSAY(46,46,"Email: mail@obelis.net - Resp. Verificacao: F. MARTINS","N",cTpFonte,cFonte2)
//EndIf
//if _nLang = 2
//	MSCBSAY(46,46,"Email: mail@obelis.net - Verication Resp.: F. MARTINS","N",cTpFonte,cFonte2)
//EndIf
			
//MSCBSAY(46,48,IIf(_nLang=1,"Resp. Tecnico: CARLOS M. NAKAMURA/CREA N. 0601828973",IIf(_nLang=2,"Tech Resp.: CARLOS M. NAKAMURA/CREA N. 0601828973","")),"N",cTpFonte,cFonte2)
if _nLang = 1
	MSCBSAY(46,48,"Resp. Tecnico: CARLOS M. NAKAMURA/CREA N. 0601828973","N",cTpFonte,cFonte2)
EndIf
if _nLang = 2
	MSCBSAY(46,48,"Tech Resp.: CARLOS M. NAKAMURA/CREA N. 0601828973","N",cTpFonte,cFonte2)
EndIf

//If SB1->B1_XINSTRU = "1"
//  //	MSCBSAY(46,50,"Instrucoes de uso acesse em www.ortosintese.com.br","N",cTpFonte,cFonte2)  
//  If _nLang = 1
//		MSCBSAY(46,50,"Instrucoes de uso acesse em www.ortosintese.com.br","N",cTpFonte,cFonte2)
//	Endif
//	If _nLang = 2
//		MSCBSAY(46,50,"Use instructions access on www.ortosintese.com.br","N",cTpFonte,cFonte2)
//	Endif
//	
//EndIf 
If SB1->B1_XINSTRU = "1"
  //	MSCBSAY(46,50,"Instrucoes de uso acesse em www.ortosintese.com.br","N",cTpFonte,cFonte2)  
  	If _nLang = 1
		MSCBSAY(46,50,"Instruções de Uso acesse em www.ortosintese.com.br ou "		,"N",cTpFonte,cFonte2)
		MSCBSAY(46,52,"instrucoesdeuso@ortosintese.com.br " 	,"N",cTpFonte,cFonte2) // Rotulo Rev 01-12/2019  + AllTrim(SB1->B1_XREVINS)+ "   -  "+ cDataImpressao   	
	Endif
	
	If _nLang = 2
		MSCBSAY(46,50,"IFU access at www.ortosintese.com.br or request by "		,"N",cTpFonte,cFonte2)
		MSCBSAY(46,52, "instrucoesdeuso@ortosintese.com.br " 	,"N",cTpFonte,cFonte2)// Label Rev 01-2019/12 // + AllTrim(SB1->B1_XREVINS)+ "   -  "+ cDataImpressao   	
	Endif	   
		
EndIf 


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º 					 Inicio da Impressao dos Box                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
MSCBBOX(002,056,100,068)//Box Destaque 01 
MSCBBOX(002,071,100,083)//Box Destaque 02   
MSCBBOX(002,086,100,098)//Box Destaque 03
//MSCBBOX(051,056,100,068)//Box Destaque 04 
//MSCBBOX(051,071,100,083)//Box Destaque 05   
//MSCBBOX(051,086,100,098)//Box Destaque 06

MSCBSAY(03,57,"ORTOSINTESE IND. E COM. LTDA","N",cTpFonte,cFonte2) //Destaque 01 
MSCBSAY(03,72,"ORTOSINTESE IND. E COM. LTDA","N",cTpFonte,cFonte2) //Destaque 02  
MSCBSAY(03,87,"ORTOSINTESE IND. E COM. LTDA","N",cTpFonte,cFonte2) //Destaque 03  
//MSCBSAY(52,57,"ORTOSINTESE IND. E COM. LTDA","N",cTpFonte,cFonte2) //Destaque 04 
//MSCBSAY(52,72,"ORTOSINTESE IND. E COM. LTDA","N",cTpFonte,cFonte2) //Destaque 05  
//MSCBSAY(52,87,"ORTOSINTESE IND. E COM. LTDA","N",cTpFonte,cFonte2) //Destaque 06  
	

MSCBSAY(03,59,"Tel.: 55(11)39484000","N",cTpFonte,cFonte2)//Destaque 01 
MSCBSAY(03,74,"Tel.: 55(11)39484000","N",cTpFonte,cFonte2)//Destaque 02 
MSCBSAY(03,89,"Tel.: 55(11)39484000","N",cTpFonte,cFonte2)//Destaque 03 
//MSCBSAY(52,59,"Tel.: 55(11)39484000","N",cTpFonte,cFonte2)//Destaque 04 
//MSCBSAY(52,74,"Tel.: 55(11)39484000","N",cTpFonte,cFonte2)//Destaque 05 
//MSCBSAY(52,89,"Tel.: 55(11)39484000","N",cTpFonte,cFonte2)//Destaque 06 

MSCBSAY(03,63,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte2)//Destaque 01 
MSCBSAY(03,78,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte2)//Destaque 02  
MSCBSAY(03,93,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte2)//Destaque 03
//MSCBSAY(52,63,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte2)//Destaque 04 
//MSCBSAY(52,78,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte2)//Destaque 05  
//MSCBSAY(52,93,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte2)//Destaque 06

MSCBSAY(03,61,IIf(_nLang=1,B1_XDMCP,IIf(_nLang=2,B1_XDMCI,SB1->B1_XDMCE)),"N",cTpFonte,cFonte2)//Destaque 01
MSCBSAY(03,76,IIf(_nLang=1,B1_XDMCP,IIf(_nLang=2,B1_XDMCI,SB1->B1_XDMCE)),"N",cTpFonte,cFonte2)//Destaque 02
MSCBSAY(03,91,IIf(_nLang=1,B1_XDMCP,IIf(_nLang=2,B1_XDMCI,SB1->B1_XDMCE)),"N",cTpFonte,cFonte2)//Destaque 03
//MSCBSAY(52,61,IIf(_nLang=1,B1_XDMCP,IIf(_nLang=2,B1_XDMCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte2)//Destaque 04
//MSCBSAY(52,76,IIf(_nLang=1,B1_XDMCP,IIf(_nLang=2,B1_XDMCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte2)//Destaque 05
//MSCBSAY(52,91,IIf(_nLang=1,B1_XDMCP,IIf(_nLang=2,B1_XDMCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte2)//Destaque 06

MSCBSAY(25,63,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 01
MSCBSAY(25,78,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 02
MSCBSAY(25,93,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 03
//MSCBSAY(70,63,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 04
//MSCBSAY(70,78,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 05
//MSCBSAY(70,93,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 06

	If  EMPTY(SB1->B1_XANVISA)  //Adicionado em 18/09/2017 a pedido do Leandro do PCP para produtos sem registro  
		MSCBSAY(03,65,IIf(_nLang=1,"Registro ANVISA: Exclusivo Mercado Externo",IIf(_nLang=2,"ANVISA Registration: Exclusive Foreign Market","")),"N",cTpFonte,cFonte2)  
		MSCBSAY(03,80,IIf(_nLang=1,"Registro ANVISA: Exclusivo Mercado Externo",IIf(_nLang=2,"ANVISA Registration: Exclusive Foreign Market","")),"N",cTpFonte,cFonte2)  
		MSCBSAY(03,95,IIf(_nLang=1,"Registro ANVISA: Exclusivo Mercado Externo",IIf(_nLang=2,"ANVISA Registration: Exclusive Foreign Market","")),"N",cTpFonte,cFonte2)  
		//MSCBSAY(52,80,IIf(_nLang=1,"Registro ANVISA: Exclusivo Mercado Externo",IIf(_nLang=2,"ANVISA Registration: Exclusive Foreign Market","")),"N",cTpFonte,cFonte2)  
		//MSCBSAY(52,65,IIf(_nLang=1,"Registro ANVISA: Exclusivo Mercado Externo",IIf(_nLang=2,"ANVISA Registration: Exclusive Foreign Market","")),"N",cTpFonte,cFonte2)  
		//MSCBSAY(52,95,IIf(_nLang=1,"Registro ANVISA: Exclusivo Mercado Externo",IIf(_nLang=2,"ANVISA Registration: Exclusive Foreign Market","")),"N",cTpFonte,cFonte2)  
	EndIf

	If SB1->B1_XANVEMP ="1"    
		MSCBSAY(03,65,IIf(_nLang=1,"Registro ANVISA:  1022371",IIf(_nLang=2,"ANVISA Registration:  1022371",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
		MSCBSAY(03,95,IIf(_nLang=1,"Registro ANVISA:  1022371",IIf(_nLang=2,"ANVISA Registration:  1022371",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
		MSCBSAY(03,80,IIf(_nLang=1,"Registro ANVISA:  1022371",IIf(_nLang=2,"ANVISA Registration:  1022371",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
		//MSCBSAY(52,65,IIf(_nLang=1,"Registro ANVISA:  1022371",IIf(_nLang=2,"ANVISA Registration:  1022371",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
		//MSCBSAY(52,80,IIf(_nLang=1,"Registro ANVISA:  1022371",IIf(_nLang=2,"ANVISA Registration:  1022371",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
		//MSCBSAY(52,95,IIf(_nLang=1,"Registro ANVISA:  1022371",IIf(_nLang=2,"ANVISA Registration:  1022371",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
  
	ElseIf SB1->B1_XANVEMP ="2" 
		MSCBSAY(03,65,IIf(_nLang=1,"Registro ANVISA:  8120219",IIf(_nLang=2,"ANVISA Registration:  8120219",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
		MSCBSAY(03,95,IIf(_nLang=1,"Registro ANVISA:  8120219",IIf(_nLang=2,"ANVISA Registration:  8120219",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
		MSCBSAY(03,80,IIf(_nLang=1,"Registro ANVISA:  8120219",IIf(_nLang=2,"ANVISA Registration:  8120219",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
		//MSCBSAY(52,65,IIf(_nLang=1,"Registro ANVISA:  8120219",IIf(_nLang=2,"ANVISA Registration:  8120219",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
		//MSCBSAY(52,80,IIf(_nLang=1,"Registro ANVISA:  8120219",IIf(_nLang=2,"ANVISA Registration:  8120219",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
		//MSCBSAY(52,95,IIf(_nLang=1,"Registro ANVISA:  8120219",IIf(_nLang=2,"ANVISA Registration:  8120219",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte2)
	EndIf 

//End If

//MSCBSAY(60,60,IIf(SB1->B1_XSTERI = "1","Val. "+ dToc(_cValid),""),"N",cTpFonte,cFonte4)//Destaque 01 
//MSCBSAY(60,74,IIf(SB1->B1_XSTERI = "1","Val. "+ dToc(_cValid),""),"N",cTpFonte,cFonte4)//Destaque 02
//MSCBSAY(60,89,IIf(SB1->B1_XSTERI = "1","Val. "+ dToc(_cValid),""),"N",cTpFonte,cFonte4)//Destaque 03

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±± 			     	Fim da Impressão dos Box                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

//MSCBBOX(90,40,95,45,3)
//MSCBBOX(95,40,100,45,3)
//MSCBSAY(91,42,"EC","N",cTpFonte,cFonte4) 
//MSCBSAY(96,42,"REP","N",cTpFonte,cFonte4)
		
MSCBEND() 
MSCBCLOSEPRINTER()	
MS_FLUSH()

Set(_SET_DATEFORMAT, 'dd/mm/yyyy')

Return()

//Monta as Perguntas
Static Function ValidPerg()
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i,j
Local nTamSX1	:= Len(SX1->X1_GRUPO)
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 			:= PADR("RESTR038",nTamSX1)

Aadd(aRegs,{cPerg,"01","Codigo do Produto ? ","Codigo do Produto ?","Codigo do Produto ? "	,"mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","",,"",""})
Aadd(aRegs,{cPerg,"02","Lote ? ","Lote ?","Lote ? "											,"mv_chb","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Peças por Embalagem? ","Quantidade ?","Quantidade ? "				,"mv_chc","N",10,2,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Idioma ? ","Idioma ?","Idioma ? "									,"mv_ch4","N",01,0,1,"C","","mv_par04","Portugues","Portugues","Portugues","","","Ingles","Ingles","Ingles","","","Espanhol","Espanhol","Espanhol","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Validade Lote ? ","Validade Lote ?","Validade Lote ? "				,"mv_ch5","C",30,0,0,"G","","mv_par05",,"","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Data Fabricacao ? ","Data Fabricacao ?","Data Fabricacao ? "		,"mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Data Esterilização? ","Data Esteril. ?","Data Esteril. ? "			,"mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Qtde Rótulos ? ","Quantidade Copias ?","Quantidade Copias ? "		,"mv_ch8","N",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

