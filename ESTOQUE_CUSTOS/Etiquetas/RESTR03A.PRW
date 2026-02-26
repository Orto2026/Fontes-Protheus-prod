#include "protheus.ch"


//===================================================================================//
//===================================================================================//
//=== Rotina    -  RESTR038  - Autor  - Samuel Miranda     - Data    -  26/03/2019 ==// 
//===================================================================================//
//=== Descricao ? Rotina de para impressao de etiquetas de produtos com      	   ==//
//===         ? codigo de barras.                                          	       ==//
//===================================================================================//
//=== Uso       ? Especifico Ortosintese                                     	   ==//
//===================================================================================//
//===================================================================================//


User Function RESTR03A()

Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo 	:= "Impressão de etiqueta de Produtos com Código de Barras."

Private cDesc1 	:= "Este programa irá imprimir as etiquetas de Produto com"
Private cDesc2 	:= "código de barras, em impressora térmica Zebra, "
Private cDesc3 	:= "conforme os parâmetros definidos pelo usuário."
Private cDesc4 	:= ""
Private cDesc5 	:= ""
Private cPerg  	:= Padr("RESTR03A",10)
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


		RptStatus({|lEnd| U_RESTR3AImp(@lEnd,mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07,mv_par08,mv_par09 , .t. )},"Imprimindo, aguarde...")
		
		RptStatus({|lEnd| U_RESTR3AImp(@lEnd,mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07,mv_par08,mv_par09, .f. )},"Imprimindo, aguarde...")
		
Endif	

Return()

User Function RESTR3AImp(lEnd,_cProd,_cLote,_nQuant,_nLang,_cValid,_dFabric,_dDtEmis,_nCop,_RegAnvisa, lrotulo)
// lEnd Default == .F.
// _cProd		:= Codigo do Produto a Ser Impresso
// _cLote		:= Lote do Produto
// _nQtde		:= Quantidade (Informada no Parametro - Analisar quando for da OP - qual QTDE Trazer
// _cValid		:= Texto com a Data da Validade ou Literal: Val Indeterminada
// _dFabric 	:= Data da Fabricacao do Produto
// _dDtEmis		:= Campo Data mal definido no levantamento - Quando automatico trazer dDatabase
// _nCop	  	:= Numero de Copias de Etiqueta.
// _nLang		:= 1=Port / 2=Ingles / 3=Spanish
// _RegAnvisa	:= Texto do Registro Anvisa

Local nCopias 		:= _nCop
Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 		:= "0"
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
	APMsgAlert("Produto nãoo localizado no cadastro, verifique.")
	Return()
Endif

IncRegua()
	
MSCBPRINTER(cImpressora,cPorta)	 
MSCBCHKStatus(.F.)



//MSCBLOADGRAF("ORTO.GRF")
MSCBLOADGRAF("L70X70.GRF") 	//Logo Ortosintese
MSCBLOADGRAF("FABRICA.GRF") //Simbolo fabricante                                                                 
//MSCBLOADGRAF("ATTENCAO.GRF")  //Simbolo cuidado consultar instru?oes
MSCBLOADGRAF("AMPULHET.GRF") //Simbolo da validade                                 
MSCBLOADGRAF("FABRICAB.GRF") //Simbolo data de fabrica??o 
//MSCBLOADGRAF("02CE.GRF") 	//Simbolo do CE
MSCBLOADGRAF("COPO.GRF") 	//Copo Simbolo de fragil manusear com cuidado
MSCBLOADGRAF("10.GRF") 		//Simbolo Logo Nao Esteril 
MSCBLOADGRAF("UR0010.GRF") 	//Simbolo Umidade relativa do AR
MSCBLOADGRAF("TEMP13.GRF") 	//Simbolo Temperatura
MSCBLOADGRAF("UNICO5.GRF") 	//Simbolo Uso unico
MSCBBEGIN(nCopias,4)

//if lrotulo


          

MSCBGRAFIC(06,01,"L70X70") //Logo Ortosintese
MSCBSAY(15,01,"ORTOSINTESE IND. E COM. LTDA","N",cTpFonte,cFonte1) 

//MSCBGRAFIC(75,01,"ATTENCAO")
//MSCBGRAFIC(75,01,"ORT")
If SB1->B1_XSTERI = "2" 
	MSCBBOX(85,01,100,4,3)
	MSCBGRAFIC(66,31,"10")	//Logo Nao Esteril
Else
	MSCBBOX(085,001,100,004,3)	//Box Nao Esteril
	MSCBLINEV(095,001,004,003,"B") 	//Linha Vestical 
	//MSCBBOX(85,01,95,4,3)	
	//MSCBBOX(95,01,100,4,3)	
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

MSCBSAY(15,04,"Av Nelson Palma Travassos, 651"+", Cep 02998-000","N",cTpFonte,cFonte5) //AllTrim(SM0->M0_ENDCOB) Transform(SM0->M0_CEPCOB,"@R 9999-999")
MSCBGRAFIC(65,03,"FABRICA") //Simbolo fabricante 

//Alterado de _dDtEmis para _dFabric no dia 13/12/2016 por Samuel Mirada 
cMes := SubStr(DtoS(_dFabric),5,2)
cAno := SubStr(DtoS(_dFabric),1,4)
//dResut := cMes +"/"+cAno 
//MSCBSAY(89,05,IIf(SB1->B1_XSTERI = "1",dResut,""),"N",cTpFonte,cFonte2) //MSCBSAY(87,05,dToc(_dDtEmis),"N",cTpFonte,cFonte2) 
//MSCBSAY(89,05,IIf(_nLang=1,cMes +" / "+cAno,IIf(_nLang=2,cAno +" / "+cMes,"")),"N",cTpFonte,cFonte2)//Removido apedido do Fabiano no dia 14/01/2019
MSCBSAY(15,06,"Tel.: 55(11)3948-4000 ","N",cTpFonte,cFonte2)
//MSCBSAY(72,08,IIf(_nLang=1,"Ver instrucao",IIf(_nLang=2,"See instruction","Ver instrucciones")),"N",cTpFonte,cFonte2)   //MSCBSAY(72,07,"Ver Instrucao","N",cTpFonte,cFonte2)

//Box do texto Proibido Proibido reprocessar
MSCBBOX(85,06,100,11.5,3) 
If SB1->B1_XUNICO ="1"
    MSCBSAY(89,07,IIf(_nLang=1,"Proibido",IIf(_nLang=2,"Do not","Prohibida")),"N",cTpFonte,cFonte2)    // MAURICIO 12/08/14 MSCBSAY(89,08,"Proibido","N",cTpFonte,cFonte2)
EndIf

MSCBSAY(15,08,"Sao Paulo-SP Brasil - Site: www.ortosintese.com.br","N",cTpFonte,cFonte2)
//MSCBSAY(75,10,IIf(_nLang=1,"de uso",IIf(_nLang=2,"for use","de uso")),"N",cTpFonte,cFonte2) //MSCBSAY(75,09,"de Uso","N",cTpFonte,cFonte2)

If SB1->B1_XUNICO ="1"
	MSCBSAY(87,09,IIf(_nLang=1,"Reprocessar",IIf(_nLang=2,"Reprocess","Reprocessar")),"N",cTpFonte,cFonte2)  // 12/08/14  MSCBSAY(87,10,"Reprocessar","N",cTpFonte,cFonte2)
EndIf

MSCBBOX(05,12,40,16,3)	//Box da Referencia
MSCBBOX(40,12,75,16,3)	//Box do Lote
MSCBBOX(75,12,100,16,3)	//Box da Quatidade

MSCBSAY(06,13,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte3) 
MSCBSAY(41,13,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte3) //MSCBSAY(41,13,"Lote:"+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte3)
MSCBSAY(76,13,"Quant.:"+Alltrim(Str(_nQuant))+" pc","N",cTpFonte,cFonte3)

portugues 	:= SB1->B1_XDMCP
ingles  	:= SB1->B1_XDMCI


portugues := Alltrim(StrTran(Alltrim(portugues),"Ø",""))              
portugues := Alltrim(StrTran(Alltrim(portugues),"º","§")) 
portugues := Alltrim(StrTran(Alltrim(portugues),"°","§")) 
portugues := Alltrim(StrTran(Alltrim(portugues),"ï","")) 

ingles := Alltrim(StrTran(Alltrim(ingles),"Ø",""))              
ingles := Alltrim(StrTran(Alltrim(ingles),"º","§")) 
ingles := Alltrim(StrTran(Alltrim(ingles),"°","§")) 
ingles := Alltrim(StrTran(Alltrim(ingles),"ï",""))
 
 
B1_XDMCP	:= portugues 	// Descricao em Portugues
B1_XDMCI 	:= ingles 		// Descricao em Engles

MSCBSAY(05,17,IIf(_nLang=1,B1_XDMCP,IIf(_nLang=2,ingles,SB1->B1_XDMCE)),"N",cTpFonte,cFonte1)
MSCBSAY(05,20,IIf(_nLang=1,SB1->B1_XDNCP,IIf(_nLang=2,SB1->B1_XDNCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte1)
//MSCBSAY(05,20,IIf(_nLang=1,SB1->B1_XDNCP,IIf(_nLang=2,SB1->B1_XDNCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte1)
MSCBSAY(05,23,IIf(_nLang=1,SB1->B1_XDNTP,IIf(_nLang=2,SB1->B1_XDNTI,SB1->B1_XDNTE)),"N",cTpFonte,cFonte1) 

//Registro Anvisa Customizado.
MSCBSAY(05,26," " + AllTrim(_RegAnvisa),"N",cTpFonte,cFonte1) 

/*
If SB1->B1_XANVEMP ="1"
	//MSCBSAY(05,26,"Registro ANVISA:  1022371" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)
	MSCBSAY(05,26,IIf(_nLang=1,"Registro ANVISA: 1022371",IIf(_nLang=2,"ANVISA Registration: 1022371",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)
ElseIf SB1->B1_XANVEMP ="2"
	//MSCBSAY(05,26,"Registro ANVISA:  8120219" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)  
	MSCBSAY(05,26,IIf(_nLang=1,"Registro ANVISA: 8120219",IIf(_nLang=2,"ANVISA Registration: 8120219",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)
EndIf
*/

/*
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
*/
If _nLang = 1
	MSCBSAY(05,29,"MP: "+Alltrim(Upper(SB1->B1_XDESM1))+"  "+Alltrim(Upper(SB1->B1_XDESM2))+"  "+Alltrim(Upper(SB1->B1_XDESM3)),"N",cTpFonte,cFonte1) 
ElseIf _nLang = 2
	MSCBSAY(05,29,"RM: "+Alltrim(Upper(SB1->B1_XDESMI1))+"  "+Alltrim(Upper(SB1->B1_XDESMI2))+"  "+Alltrim(Upper(SB1->B1_XDESMI3)),"N",cTpFonte,cFonte1) 
ElseIf _nLang = 3
	MSCBSAY(05,29,"MP: "+Alltrim(Upper(SB1->B1_XDESME1))+"  "+Alltrim(Upper(SB1->B1_XDESME2))+"  "+Alltrim(Upper(SB1->B1_XDESME3)),"N",cTpFonte,cFonte1) 
EndIf
         
//Validacao Indeterminada
/*
If SB1->B1_XSTERI = "2"
	If _nLang <> 2
		MSCBSAY(17,38,"Indeterminada","N",cTpFonte,cFonte2) 		  
	Else
		MSCBSAY(17,38,"Undetermined","N",cTpFonte,cFonte2) 		
  	EndIf
EndIf   
*/

MSCBGRAFIC(05,31,"FABRICAB") 	// Simbolo data de fabrica??o 
cMes := SubStr(DtoS(_dFabric),5,2)
cAno := SubStr(DtoS(_dFabric),1,4)
cDia := SubStr(DtoS(_dFabric),7,2)
//dResut := cMes +"/"+cAno 
//MSCBSAY(04,38,dResut,"N",cTpFonte,cFonte2)                         
MSCBSAY(05,38,IIf(_nLang=1,cDia +"/"+  cMes +"/"+cAno,IIf(_nLang=2,cAno +"/"+cMes,"")),"N",cTpFonte,cFonte2)//Adiciona A pedido do Fabiano Lopes dia 20/11/2018 por samuel Miranda 
                    
MSCBGRAFIC(20,31,"AMPULHET")   //Simbolo da validade   
//MSCBGRAFIC(20,31,"FABRICAB")
If SB1->B1_XSTERI = "1" 
	cMes := StrZero(Month(_dFabric),2)		// SubStr(DtoS(_cValid),5,2)
	cAno := StrZero(Year(_dFabric) + 5,4)	// SubStr(DtoS(_cValid),1,4)  
	cDia := SubStr(DtoS(_dFabric),7,2)
	MSCBSAY(19,38,IIf(_nLang=1,cDia +"/"+  cMes +"/"+cAno,IIf(_nLang=2,cAno +"/"+cMes,"")),"N",cTpFonte,cFonte2)//Adiciona A pedido do Fabiano Lopes dia 20/11/2018 por samuel Miranda                       
EndIf	

//Validacao para 10 anos  
//If Empty(_cValid) .And. SB1->B1_XSTERI = "2" 
If SB1->B1_XSTERI = "2" 														// Incluido em 14/09/2017 Por Samuel Miranda A pedido do Fabiano A. Regulatorio
  	cMes := StrZero(Month(_dFabric),2)		// SubStr(DtoS(_cValid),5,2)
	cAno := StrZero(Year(_dFabric) + 10,4)	// SubStr(DtoS(_cValid),1,4)  		// Incluido em 14/09/2017 Por Samuel Miranda A pedido do Fabiano A. Regulatorio
	MSCBSAY(20,38,IIf(_nLang=1, cDia +"/"+  cMes +"/"+cAno,IIf(_nLang=2,cAno +"/"+cMes,"")),"N",cTpFonte,cFonte2)
EndIf

//Verifica se se o produto est? marcado para uso unico
If SB1->B1_XUNICO ="1"
	MSCBGRAFIC(34,32,"UNICO5") //Simbolo Uso unico
	MSCBSAY(33,38,IIf(_nLang=1,"Uso Unico",IIf(_nLang=2,"Single use","De un solo uso")),"N",cTpFonte,cFonte2)    // MAURICIO 12/08/14 MSCBSAY(37,38,"Uso Unico","N",cTpFonte,cFonte2) 
EndIf

//Impressao CE
//If SB1->B1_XCE0434 = "1"     //Alterado no dia 03/07/2018 por Mauricio, apedido do Fabiano Depto. Assu. Regulatorios
//	MSCBGRAFIC(47,32,"02CE") //Simbolo do CE
//    MSCBSAY(49,38,"2460","N",cTpFonte,cFonte2)
//EndIf

//Impressao  Copo
MSCBGRAFIC(58,30,"COPO") //Copo Simbolo de fragil manusear com cuidado

If SB1->B1_XHUMID = "1"
	MSCBGRAFIC(77,30,"UR0010") //Simbolo Umidade relativa do AR
	MSCBGRAFIC(77,31,"UMIDADE")
EndIf

//Impressao  do Termometro 
//MSCBGRAFIC(89,30,"TERMOMET")
MSCBGRAFIC(89,29,"TEMP13") //Simbolo Temperatura

//Impressao  dos cosdigos de Barra (Lote e Refrencia
MSCBBOX(04,40,45,54,3)
MSCBSAYBAR(08,40,Alltrim(SB1->B1_CODBAR),"N","MB04",8,.F.,.T.,.F.,,3,2,.F.) // ALTERADO CLAUDIO ERA: MSCBSAYBAR(08,40,Alltrim(SB1->B1_CODBAR),"N","MB04",10,.F.,.T.,.F.,,3,2,.F.)
MSCBSAYBAR(00,02,Alltrim(Upper(_cLote)),"B","MB07",4,.F.,.F.,.F.,,2,2,.F.)

//MSCBSAY(46,40,"European Authorized Representative Obelis SA","N",cTpFonte,cFonte2)
//MSCBSAY(46,42,"Bd. General Wahis 53 1030 Brussels, BELGIUM","N",cTpFonte,cFonte2)
//MSCBSAY(46,44,"Tel +(32)2.732.59.54 Fax +(32)2.732.60.03","N",cTpFonte,cFonte2)
////MSCBSAY(46,46,IIf(_nLang=1,"Email: mail@obelis.net - Resp. Verificacao: F. MARTINS",IIf(_nLang=2,"Email: mail@obelis.net - Verication Resp.: F. MARTINS","")),"N",cTpFonte,cFonte2)  //ALTERADO A SIGLA DE J.S.S  P/ H.R DIA 07/10/15 POR SAMUEL MIRANDA

//if _nLang = 1
//	MSCBSAY(46,46,"Email: mail@obelis.net - Resp. Verificacao: F. MARTINS","N",cTpFonte,cFonte2)
//EndIf
//
//if _nLang = 2
//	MSCBSAY(46,46,"Email: mail@obelis.net - Verication Resp.: F. MARTINS","N",cTpFonte,cFonte2)
//EndIf
			
//MSCBSAY(46,48,IIf(_nLang=1,"Resp. Tecnico: CARLOS M. NAKAMURA/CREA N. 0601828973",IIf(_nLang=2,"Tech Resp.: CARLOS M. NAKAMURA/CREA N. 0601828973","")),"N",cTpFonte,cFonte2)
if _nLang = 1
	MSCBSAY(46,48,"Resp. Tecnico: CARLOS M. NAKAMURA/CREA SP 0601828973","N",cTpFonte,cFonte2)
EndIf

if _nLang = 2
	MSCBSAY(46,48,"Tech Resp.: CARLOS M. NAKAMURA/CREA SP 0601828973","N",cTpFonte,cFonte2)
EndIf

If SB1->B1_XINSTRU = "1"
  //	MSCBSAY(46,50,"Instrucoes de uso acesse em www.ortosintese.com.br","N",cTpFonte,cFonte2)  
  	If _nLang = 1
		MSCBSAY(46,50,"Instruções de Uso acesse em www.ortosintese.com.br ou "		,"N",cTpFonte,cFonte2)
		MSCBSAY(46,52,"instrucoesdeuso@ortosintese.com.br Rotulo Rev 00-08/2019" 	,"N",cTpFonte,cFonte2) // + AllTrim(SB1->B1_XREVINS)+ "   -  "+ cDataImpressao   				
	Endif

	If _nLang = 2
		MSCBSAY(46,50,"IFU access at www.ortosintese.com.br or request by "			,"N",cTpFonte,cFonte2)
		MSCBSAY(46,52, "instrucoesdeuso@ortosintese.com.br Label Rev 00-2019/08" 	,"N",cTpFonte,cFonte2) // + AllTrim(SB1->B1_XREVINS)+ "   -  "+ cDataImpressao   	
	Endif	   
EndIf 

MSCBSAY(46,50,"Rótulo Rev.01-12/2025","N",cTpFonte,cFonte2)  //OemToAnsi

//???????????????????????????????????????????????????????????????????????????//
//???????????????????????????????????????????????????????????????????????????//
//??? 					 Inicio da Impressao dos Box                      ???//
//???????????????????????????????????????????????????????????????????????????//
//???????????????????????????????????????????????????????????????????????????//


if lrotulo 

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
	
MSCBSAY(03,59,"CNPJ 48.240.709/0003-52 / Tel.: 55(11)3948-4000","N",cTpFonte,cFonte2)//Destaque 01 
MSCBSAY(03,74,"CNPJ 48.240.709/0003-52 / Tel.: 55(11)3948-4000","N",cTpFonte,cFonte2)//Destaque 02 
MSCBSAY(03,89,"CNPJ 48.240.709/0003-52 / Tel.: 55(11)3948-4000","N",cTpFonte,cFonte2)//Destaque 03 

//MSCBSAY(52,59,"CNPJ 48.240.709/0003-52 / Tel.: 55(11)3948-4000","N",cTpFonte,cFonte2)//Destaque 04 
//MSCBSAY(52,74,"CNPJ 48.240.709/0003-52 / Tel.: 55(11)3948-4000","N",cTpFonte,cFonte2)//Destaque 05 
//MSCBSAY(52,89,"CNPJ 48.240.709/0003-52 / Tel.: 55(11)3948-4000","N",cTpFonte,cFonte2)//Destaque 06 

MSCBSAY(03,63,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte2)//Destaque 01 
MSCBSAY(03,78,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte2)//Destaque 02  
MSCBSAY(03,93,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte2)//Destaque 03

//MSCBSAY(52,63,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte2)//Destaque 04
//MSCBSAY(52,78,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte2)//Destaque 05  
//MSCBSAY(52,93,"Ref.:"+Alltrim(SB1->B1_COD),"N",cTpFonte,cFonte2)//Destaque 06

MSCBSAY(03,61,IIf(_nLang=1,SB1->B1_XDMCP,IIf(_nLang=2,SB1->B1_XDMCI,SB1->B1_XDMCE)),"N",cTpFonte,cFonte2)//Destaque 01
MSCBSAY(03,76,IIf(_nLang=1,SB1->B1_XDMCP,IIf(_nLang=2,SB1->B1_XDMCI,SB1->B1_XDMCE)),"N",cTpFonte,cFonte2)//Destaque 02
MSCBSAY(03,91,IIf(_nLang=1,SB1->B1_XDMCP,IIf(_nLang=2,SB1->B1_XDMCI,SB1->B1_XDMCE)),"N",cTpFonte,cFonte2)//Destaque 03

//MSCBSAY(52,61,IIf(_nLang=1,B1_XDMCP,IIf(_nLang=2,B1_XDMCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte2)//Destaque 04
//MSCBSAY(52,76,IIf(_nLang=1,B1_XDMCP,IIf(_nLang=2,B1_XDMCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte2)//Destaque 05
//MSCBSAY(52,91,IIf(_nLang=1,B1_XDMCP,IIf(_nLang=2,B1_XDMCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte2)//Destaque 06

MSCBSAY(25,63,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 01
MSCBSAY(25,78,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 02
MSCBSAY(25,93,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 03

//MSCBSAY(70,63,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 04
//MSCBSAY(70,78,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 05
//MSCBSAY(70,93,IIf(_nLang=1,"Lote:",IIf(_nLang=2,"Lot:","Lote:"))+Alltrim(Upper(_cLote)),"N",cTpFonte,cFonte2)//Destaque 06

 //Adicionado em 18/09/2017 a pedido do Leandro do PCP para produtos sem registro  
MSCBSAY(03,65," "+ AllTrim(_RegAnvisa),"N",cTpFonte,cFonte2) 
MSCBSAY(03,80," "+ AllTrim(_RegAnvisa),"N",cTpFonte,cFonte2) 
MSCBSAY(03,95," "+ AllTrim(_RegAnvisa),"N",cTpFonte,cFonte2) 
	


endif

//MSCBSAY(52,80," "+ AllTrim(_RegAnvisa),"N",cTpFonte,cFonte2) 
//MSCBSAY(52,65," "+ AllTrim(_RegAnvisa),"N",cTpFonte,cFonte2) 
//MSCBSAY(52,95," "+ AllTrim(_RegAnvisa),"N",cTpFonte,cFonte2)  		

//???????????????????????????????????????????????????????????????????????????//
//???????????????????????????????????????????????????????????????????????????//
//??? 					 Fim da Impressão dos Box 		                  ???//
//???????????????????????????????????????????????????????????????????????????//
//???????????????????????????????????????????????????????????????????????????//

//MSCBBOX(90,40,100,45,3)		 	//Box do Representante autorizado na comunidade europeia. EC
//MSCBLINEV(095,040,045,3,"B") 	//Linha Vestical 		
////MSCBBOX(95,40,100,45,3) 		//Box do Representante autorizado na comunidade europeia REP	
//MSCBSAY(91,42,"EC","N",cTpFonte,cFonte4) 
//MSCBSAY(96,42,"REP","N",cTpFonte,cFonte4) //Simbolo de Representante autorizado na comunidade europeia.
		
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
//Local aHelp 	:= {}
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 			:= PADR("RESTR03A",nTamSX1)

Aadd(aRegs,{cPerg,"01","Codigo do Produto ? ","Codigo do Produto ?","Codigo do Produto ? "	,"mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","",,"",""})
Aadd(aRegs,{cPerg,"02","Lote ? "             ,"Lote ?","Lote ? "							,"mv_chb","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Peças por Embalagem?","Quantidade ?","Quantidade ? "				,"mv_chc","N",10,2,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Idioma ? "           ,"Idioma ?","Idioma ? "						,"mv_ch4","N",01,0,1,"C","","mv_par04","Portugues","Portugues","Portugues","","","Ingles","Ingles","Ingles","","","Espanhol","Espanhol","Espanhol","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Validade Lote ? "    ,"Validade Lote ?","Validade Lote ? "				,"mv_ch5","C",30,0,0,"G","","mv_par05",,"","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Data Fabricacao ? "  ,"Data Fabricacao ?","Data Fabricacao ? "		,"mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Data Esterilizaçãoo?","Data Esteril. ?","Data Esteril. ? "			,"mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Qtde Rótulos ? ","Quantidade Copias ?","Quantidade Copias ? "		,"mv_ch8","N",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"09","Registro Anvisa ? ","Registro Anvisa ? ","Registro Anvisa ? "		,"mv_ch9","C",45,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

