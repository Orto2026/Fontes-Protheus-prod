
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR025 º Autor ³Samuel Miranda      º Data ³  03/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de para impressao de etiquetas de produtos com      º±±
±±º          ³ codigo de barras.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTR025()
Local ni        := 0
Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo 	:= "Impressão de etiqueta de Produtos com Código de Barras."
Local _nLang	:= 0

cPerg  	:= Padr("RESTR025",10)

Private cDesc1 	:= "Este programa irá imprimir as etiquetas de Produto com"
Private cDesc2 	:= "código de barras, em impressora térmica Zebra, "
Private cDesc3 	:= "conforme os parâmetros definidos pelo usuário."
Private cDesc4 	:= ""
Private cDesc5 	:= ""
Private cPerg  	:= ""
Private lEnd 	:= .F.
                              
//RpcSetType(3)
//RpcSetEnv("01", "01")



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
	//RptStatus({|lEnd| 	U_RESTR25Imp(@lEnd,mv_par01,mv_par02,mv_par03,mv_par05,mv_par06,mv_par07,mv_par08,mv_par04, .T., mv_par09)},"Imprimindo, aguarde...")
	dbSelectArea("SB5")
	dbSetOrder(1)

	_nLang := mv_par04
	
	_nQuant := mv_par08
	
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+MV_PAR01))

	DbSelectArea("SZQ")
	SZQ->(DbSetOrder(1))
    
    For nI := 1 to mv_par08
    	//Pega a quantidade de impressões necessarias
    	nQtdImp := POSICIONE( "SB1", 1, xFilial("SB1")+MV_PAR01, "B1_XQTETIQ" )
    	
    	//Proteção para o caso de não existir o produto cadastrado
    	nQtdImp	:= Iif(ValType(nQtdImp)=="N" .AND. nQtdImp > 0, nQtdImp, 1)
    	
    	//Imprime o produto pai        @lEnd,mv_par01, mv_par02, mv_par03, mv_par05, mv_par06, mv_par07, mv_par08,mv_par04, .T.
    	RptStatus({|lEnd| U_RESTR25Imp(.F.  ,MV_PAR01, mv_par02, mv_par03,"", mv_par06, mv_par07, nQtdImp, mv_par04)},"Imprimindo, aguarde...")

    	//Verificar se possui produtos filhos e imprime
		If SZQ->(DbSeek(xFilial("SZQ")+MV_PAR01))
			While SZQ->(!Eof() .AND. AllTrim(ZQ_PRODPAI) == AllTrim(MV_PAR01))
				If SZQ->ZQ_ATIVO == "S"
				
			    	//Pega a quantidade de impressões necessarias
					nQtdImp := POSICIONE( "SB1", 1, xFilial("SB1")+SZQ->ZQ_PRODFIL, "B1_XQTETIQ" )
					
					//Proteção para o caso de não existir o produto cadastrado
					nQtdImp	:= Iif(ValType(nQtdImp)=="N" .AND. nQtdImp > 0, nQtdImp, 1) 
					
					SB1->(dbSeek(xFilial("SB1")+SZQ->ZQ_PRODFIL))
					
					//Reinicia a qtde embalagem
					_nQtdEmb := 1
					
					//Pega a qtde de embalagens no cadastro do produto
			    	_nQtdEmb := POSICIONE( "SB1", 1, xFilial("SB1")+SZQ->ZQ_PRODFIL, "B1_XQE")
			    	_nQtdEmb := Iif(_nQtdEmb == 0, 1, _nQtdEmb)
					/*If FieldPos("B1_XQTETIQ") <> 0 .AND. SB5->(dbSeek(xFilial("SB5")+SB1->B1_COD))
						_nQtdEmb := SB5->B5_QEI
					EndIf*/
			
					RptStatus({|lEnd| U_RESTR25Imp(.F., SZQ->ZQ_PRODFIL, mv_par02, _nQtdEmb, "", mv_par06, mv_par07, nQtdImp, mv_par04)},"Imprimindo etiquetas filhas, aguarde...")
				EndIf
				SZQ->(DbSkip())
			End
		EndIf
    Next nI


Endif	

Return()

User Function RESTR25Imp(lEnd,_cProd,_cLote,_nQuant,_cValid,_dFabric,_dDtEmis,_nCop,_nLang, lImpFilh, _nQtdFil)
// lEnd Default == .F.
//mv_par01 _cProd	:= Codigo do Produto a Ser Impresso
//mv_par02 _cLote	:= Lote do Produto
//mv_par03 _nQtde	:= Quantidade (Informada no Parametro - Analisar quando for da OP - qual QTDE Trazer
//mv_par04 _cValid	:= Texto com a Data da Validade ou Literal: Val Indeterminada
//mv_par05 _dFabric := Data da Fabricacao do Produto
//mv_par06 _dDtEmis	:= Campo Data mal definido no levantamento - Quando automatico trazer dDatabase
//mv_par07 _nCop	:= Numero de Copias de Etiqueta.
//mv_par08 _nLang	:= 1=Port / 2=Ingles / 3=Spanish
Local ni            := 0
Local nCopias 		:= _nCop
Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 		:= "0"
Local cFonte1 		:= "020,020"
Local cFonte2 		:= "017,017"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "015,015"
Local cFonte5 		:= "016,016"
Local cCoDigos 		:= ""
 
cCoDigos :="0703/01|0703/05|0703/06|0703/10|0704/01|0704/05|0704/06|0709/01|0709/05|0711/01|0711/05|0711/06|0713/01|0713/05|0713/06|0721/01|0721/05|0721/06|"
cCoDigos +="0729/01|0729/05|0729/06|0736/01|0736/05|0742/01|0742/05|0744/01|0744/05|0748/01|0748/05|0750/01|0750/05|0750/06|0756/01|0756/05|0756/06|0758/06|"
cCoDigos +="0761/05|0765/01|0765/05|0765/06|0767/01|0767/05|0770/01|0770/05|0770/06|0772/01|0772/05|0776/01|0776/05|0792/01|0792/05|0806/01|0806/05|0806/06|"
cCoDigos +="0809/01|0809/05|0821/01|0821/05|0821/06|0823/01|0823/02|0823/03|0823/04|0823/05|0823/06|0823/08|0823/09|0823/10|0823/11|0823/12|0823/13|0823/14|"
cCoDigos +="0823/15|0823/16|0823/18|0823/19|0823/22|0823/23|0823/24|0823/25|0823/26|0823/28|0837/01|0837/05|0837/06|0840/01|0840/02|0840/05|0840/06|0840/07|"
cCoDigos +="0840/08|0840/09|0701/05|0701/06|0707/05|0707/06|0741/01|0741/05|0743/01|0743/05|0746/01|0746/05|0746/06|0748/06|0756/07|0763/01|0763/05|0763/06|"
cCoDigos +="0770/02|0770/07|0772/06|0778/01|0780/01|0780/05|0804/01|0804/02|0804/05|0804/06|0804/07|0808/05|0808/06|0808/07|0810/01|0810/05|0823/07|0823/17|"
cCoDigos +="0823/20|0823/21|0840/03|0840/10|0840/11|0840/12|0842/01|0842/05|0848/01|0848/05|0848/06|0849/01|0849/05|0849/02|0849/06|0850/01|0850/05|0855/01|"
cCoDigos +="0855/05|0855/06|0855/14|0855/07|0855/08|0855/09|0855/10|0855/11|0855/12|0855/13|0855/15|0856/01|0856/02|0856/03|0857/01|0857/05|0857/06|0858/01|"
cCoDigos +="0858/05|0858/06|0859/01|0859/02|0859/05|0859/06|0860/01|0860/05|0860/06|0861/01|0861/02|0861/05|0861/08|0861/09|0861/06|0861/07|0861/03|0861/17|"
cCoDigos +="0862/01|0862/05|0862/06|0863/01|0863/05|0863/06|0864/01|0864/05|0864/06|0865/01|0865/05|0865/06|0865/07|0866/01|0866/05|0866/06|0866/07|0867/01|"
cCoDigos +="0867/05|0867/06|0868/01|0868/02|0868/05|0868/07|0870/01|0870/02|0870/03|0870/04|0870/05|0870/06|0870/07|0870/08|0870/09|0870/10|0871/01|0871/05|"
cCoDigos +="0871/06|0872/01|0872/02|0872/03|0872/04|0721/07|0761/02|0765/02|0778/05|0848/04|0849/04|0868/06|0874/01|0873/05|0873/06|0874/05|0874/06|0875/01|"
cCoDigos +="0875/05|0875/06|0875/07|0729/07|0729/08|0736/06|0744/06|0776/07|0792/06|0835/08|0842/06|0849/03|0850/06|0859/03|0859/04|0866/08|0866/09|0866/10|"
cCoDigos +="0874/07|0874/08|0874/09|0874/10|0876/05|0753/05|0753/06|0879/05|0879/06|0879/07|0880/05|0881/05|0878/02|0878/03|0878/04|0776/06|0868/06|0882/01|"
cCoDigos +="0760/01|0760/05|0761/01|0761/04|0882/05|0883/01|0883/05|0767|0805""

Default lImpFilh 	:= .T. //Proteger contra loop infinito caso realizem algum cadastro recursivo

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
MSCBLOADGRAF("LOG3.GRF")		//Img Logo Ortosintese  
MSCBLOADGRAF("FABRICA.GRF")    	//Img Fabrica (fabricação)                                                                  
//MSCBLOADGRAF("WARNING.GRF") 
MSCBLOADGRAF("ATTENCAO.GRF")   	// Por Samuel Miranda 20190614 Feito a troca a pedido da Lullis do Assuntos Reg.
MSCBLOADGRAF("AMPULHET.GRF")  	//Img Ampulheta                                 
MSCBLOADGRAF("FABRICAB.GRF")	//Img Fabrica
MSCBLOADGRAF("USOUNICO.GRF")	//Img Uso unico Antigo
//MSCBLOADGRAF("02CE.GRF")		// Img CE
MSCBLOADGRAF("COPO.GRF")		// Img Copo
MSCBLOADGRAF("TERMOMET.GRF") 	// Img da Umidade Antigo
MSCBLOADGRAF("UMIDADE.GRF") 	// Img da Umidade Antigo
MSCBLOADGRAF("10.GRF")	   	// Img Nao Esteril      
MSCBLOADGRAF("UNICO5.GRF") 	// Img Uso unico
MSCBLOADGRAF("UR0010.GRF") 	// Img da Umidade
MSCBLOADGRAF("TEMP13.GRF")  // Img da Umidade
                                                          
MSCBBEGIN(nCopias,4)          

MSCBGRAFIC(06,01,"LOG3")
MSCBSAY(15,01,"ORTOSINTESE IND. E COM. LTDA","N",cTpFonte,cFonte1) 

//MSCBGRAFIC(75,01,"WARNING")  
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

MSCBSAY(96,02,IIf(SB1->B1_XSTERI = "1",IIf(SB1->B1_XSTETP = "2","EO","R"),""),"N",cTpFonte,cFonte4)  
MSCBSAY(15,04,"Av Nelson Palma Travassos, 651"+"-Cep:02998-000","N",cTpFonte,cFonte5) //AllTrim(SM0->M0_ENDCOB) Transform(SM0->M0_CEPCOB,"@R 9999-999")
MSCBGRAFIC(65,03,"FABRICA")

//Alterado de _dDtEmis para _dFabric no dia 13/12/2016 por Samuel Mirada 
//cMes := SubStr(DtoS(_dFabric),5,2)
//cAno := SubStr(DtoS(_dFabric),1,4)
//dResut := cMes +"/"+cAno 
//MSCBSAY(89,05,IIf(SB1->B1_XSTERI = "1",dResut,""),"N",cTpFonte,cFonte2) //MSCBSAY(87,05,dToc(_dDtEmis),"N",cTpFonte,cFonte2) 
//MSCBSAY(89,05,IIf(_nLang=1,cMes +" / "+cAno,IIf(_nLang=2,cAno +" / "+cMes,"")),"N",cTpFonte,cFonte2)//Removido apedido do Fabiano no dia 14/01/2019

MSCBSAY(15,06,"Tel.: 55(11)39484000 - FAX: 55(11)39484010","N",cTpFonte,cFonte2)
MSCBSAY(72,08,IIf(_nLang=1,"Ver instrucao",IIf(_nLang=2,"See instruction","Ver instrucciones")),"N",cTpFonte,cFonte2)   //MSCBSAY(72,07,"Ver Instrucao","N",cTpFonte,cFonte2)
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

portugues :=SB1->B1_XDMCP
ingles    :=SB1->B1_XDMCI

portugues := Alltrim(StrTran(Alltrim(portugues),"Ø",chr(65533)))           
portugues := Alltrim(StrTran(Alltrim(portugues),"º","§")) 
portugues := Alltrim(StrTran(Alltrim(portugues),"°","§")) 
portugues := Alltrim(StrTran(Alltrim(portugues),"ï",chr(65533)))
portugues := Alltrim(StrTran(Alltrim(portugues),"ï","Ø")) 
 
ingles := Alltrim(StrTran(Alltrim(ingles),"Ø",chr(65533)))              
ingles := Alltrim(StrTran(Alltrim(ingles),"º","§")) 
ingles := Alltrim(StrTran(Alltrim(ingles),"°","§")) 
ingles := Alltrim(StrTran(Alltrim(ingles),"ï",chr(65533))) 
ingles := Alltrim(StrTran(Alltrim(ingles),"ï","Ø")) 
 
B1_XDMCP	:= portugues	// Descricao em Portugues
B1_XDMCI 	:= ingles 		// Descricao em Engles


MSCBSAY(05,17,IIf(_nLang=1,B1_XDMCP,IIf(_nLang=2,ingles,SB1->B1_XDMCE)),"N",cTpFonte,cFonte1)
MSCBSAY(05,20,IIf(_nLang=1,SB1->B1_XDNCP,IIf(_nLang=2,SB1->B1_XDNCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte1)
//MSCBSAY(05,20,IIf(_nLang=1,SB1->B1_XDNCP,IIf(_nLang=2,SB1->B1_XDNCI,SB1->B1_XDNCE)),"N",cTpFonte,cFonte1)
MSCBSAY(05,23,IIf(_nLang=1,SB1->B1_XDNTP,IIf(_nLang=2,SB1->B1_XDNTI,SB1->B1_XDNTE)),"N",cTpFonte,cFonte1) 

If EMPTY(SB1->B1_XANVISA) //Adicionado em 18092017 a pedido do Leandro do PCP para produtos sem registro 
  	MSCBSAY(05,26,IIf(_nLang=1,"Registro ANVISA: Exclusivo Mercado Externo",IIf(_nLang=2,"ANVISA Registration: Exclusive Foreign Market","")),"N",cTpFonte,cFonte1) 
  Else
	If SB1->B1_XANVEMP ="1"
		//MSCBSAY(05,26,"Registro ANVISA:  1022371" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)
		MSCBSAY(05,26,IIf(_nLang=1,"Registro ANVISA: 1022371",IIf(_nLang=2,"ANVISA Registration: 1022371",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)
		ElseIf SB1->B1_XANVEMP ="2"
		//MSCBSAY(05,26,"Registro ANVISA:  8120219" +Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)  
		MSCBSAY(05,26,IIf(_nLang=1,"Registro ANVISA: 8120219",IIf(_nLang=2,"ANVISA Registration: 8120219",""))+Alltrim(SB1->B1_XANVISA),"N",cTpFonte,cFonte1)
	EndIf
EndIf 

If _nLang = 1
	MSCBSAY(05,29,"MP: "+Alltrim(Upper(SB1->B1_XDESM1))+"  "+Alltrim(Upper(SB1->B1_XDESM2))+"  "+Alltrim(Upper(SB1->B1_XDESM3)),"N",cTpFonte,cFonte1) 
	ElseIf _nLang = 2
	MSCBSAY(05,29,"RM: "+Alltrim(Upper(SB1->B1_XDESMI1))+"  "+Alltrim(Upper(SB1->B1_XDESMI2))+"  "+Alltrim(Upper(SB1->B1_XDESMI3)),"N",cTpFonte,cFonte1) 
	ElseIf _nLang = 3
	MSCBSAY(05,29,"MP: "+Alltrim(Upper(SB1->B1_XDESME1))+"  "+Alltrim(Upper(SB1->B1_XDESME2))+"  "+Alltrim(Upper(SB1->B1_XDESME3)),"N",cTpFonte,cFonte1) 
EndIf
         
MSCBGRAFIC(05,31,"FABRICAB")
cMes := SubStr(DtoS(_dFabric),5,2)
cAno := SubStr(DtoS(_dFabric),1,4)
                       
MSCBSAY(04.5,38,IIf(_nLang=1,cMes +"/"+cAno,IIf(_nLang=2,cAno +"/"+cMes,"")),"N",cTpFonte,cFonte2)//Adiciona A pedido do Fabiano Lopes dia 20/11/2018 por samuel Miranda 
                    
MSCBGRAFIC(20,31,"AMPULHET")    //MSCBGRAFIC(20,31,"FABRICAB")
//If Empty(_cValid) .And. SB1->B1_XSTERI = "1"  	// Incluido em 03/02/2015	
If SB1->B1_XSTERI = "1" 
	cMes := StrZero(Month(_dFabric),2)		// SubStr(DtoS(_cValid),5,2)
	cAno := StrZero(Year(_dFabric) + 5,4)	// SubStr(DtoS(_cValid),1,4)  
	MSCBSAY(19,38,IIf(_nLang=1,cMes +"/"+cAno,IIf(_nLang=2,cAno +"/"+cMes,"")),"N",cTpFonte,cFonte2)//Adiciona A pedido do Fabiano Lopes dia 20/11/2018 por samuel Miranda                       
EndIf	

//Validacao para 10 anos  
//If Empty(_cValid) .And. SB1->B1_XSTERI = "2" 
If (AllTrim(SB1->B1_COD)) $ cCoDigos
	//Validade indeterminada para as caixas 
	IF _nLang=1
		MSCBSAY(16.5,38,"Indeterminada","N",cTpFonte,cFonte2)
	EndIf
	If _nLang=2
		MSCBSAY(16.5,38,"Undetermined","N",cTpFonte,cFonte2)
	EndIf
	iF _nLang=3
		MSCBSAY(16.5,38,"Undetermined","N",cTpFonte,cFonte2)
	EndIf

	ElseIf SB1->B1_XSTERI = "2" 																	
  	cMes := StrZero(Month(_dFabric),2)		// SubStr(DtoS(_cValid),5,2)
	cAno := StrZero(Year(_dFabric) + 10,4)	// SubStr(DtoS(_cValid),1,4)  																		
	MSCBSAY(20,38,IIf(_nLang=1,cMes +"/"+cAno,IIf(_nLang=2,cAno +"/"+cMes,"")),"N",cTpFonte,cFonte2)
EndIf

/*
//Validacao Indeterminada
If SB1->B1_XSTERI = "2"
	If _nLang <> 2
		MSCBSAY(17,38,"Indeterminada","N",cTpFonte,cFonte2) 		  
	Else
		MSCBSAY(17,38,"Undetermined","N",cTpFonte,cFonte2) 		
  	EndIf
EndIf   
*/ 

//Verifica se se o produto está marcado para uso unico
If SB1->B1_XUNICO ="1"
	MSCBGRAFIC(34,32,"UNICO5")
	MSCBSAY(33,38,IIf(_nLang=1,"Uso Unico",IIf(_nLang=2,"Single use","De un solo uso")),"N",cTpFonte,cFonte2)  // Samuel Miranda 20190627 retirado a pedido da Lulliz assunt. Regulatorios
EndIf

//Impressao CE
//If SB1->B1_XCE0434 = "1"     //Alterado no dia 03/07/2018 por Mauricio, apedido do Fabiano Depto. Assu. Regulatorios
//	MSCBGRAFIC(47,32,"02CE")
//    MSCBSAY(49,38,"2460","N",cTpFonte,cFonte2)
//EndIf

//Impressao  Copo
MSCBGRAFIC(58,30,"COPO")

//Simbolo de Umidade
If SB1->B1_XHUMID = "1"
	//MSCBGRAFIC(76,30,"UR0010")
	MSCBGRAFIC(77,30,"UR0010") 
EndIf

//Impressao  do Termometro simbolo da tenperatura
	//MSCBGRAFIC(89,30,"TEMP13")
MSCBGRAFIC(89,29,"TEMP13")

//Impressao  dos cosdigos de Barra (Lote e Refrencia
MSCBBOX(04,40,45,54,3)
MSCBSAYBAR(08,40,Alltrim(SB1->B1_CODBAR),"N","MB04",8,.F.,.T.,.F.,,3,2,.F.) // ALTERADO CLAUDIO ERA: MSCBSAYBAR(08,40,Alltrim(SB1->B1_CODBAR),"N","MB04",10,.F.,.T.,.F.,,3,2,.F.)
MSCBSAYBAR(00,02,Alltrim(Upper(_cLote)),"B","MB07",4,.F.,.F.,.F.,,2,2,.F.)


//MSCBSAY(46,40,"European Authorized Representative Obelis SA","N",cTpFonte,cFonte2)
//MSCBSAY(46,42,"Bd. General Wahis 53 1030 Brussels, BELGIUM","N",cTpFonte,cFonte2)
//MSCBSAY(46,44,"Tel +(32)2.732.59.54 Fax +(32)2.732.60.03","N",cTpFonte,cFonte2)
//MSCBSAY(46,46,IIf(_nLang=1,"Email: mail@obelis.net - Resp. Verificacao: F. MARTINS",IIf(_nLang=2,"Email: mail@obelis.net - Verication Resp.: F. MARTINS","")),"N",cTpFonte,cFonte2)  //ALTERADO A SIGLA DE J.S.S  P/ H.R DIA 07/10/15 POR SAMUEL MIRANDA
//if _nLang = 1
//	MSCBSAY(46,46,"Email: mail@obelis.net - Resp. Verificacao: F. MARTINS","N",cTpFonte,cFonte2)
//EndIf
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
		MSCBSAY(46,52,"instrucoesdeuso@ortosintese.com.br Rotulo Rev 01-12/2019" 	,"N",cTpFonte,cFonte2) // + AllTrim(SB1->B1_XREVINS)+ "   -  "+ cDataImpressao   	
	Endif
	
	If _nLang = 2
		MSCBSAY(46,50,"IFU access at www.ortosintese.com.br or request by "		,"N",cTpFonte,cFonte2)
		MSCBSAY(46,52, "instrucoesdeuso@ortosintese.com.br Label Rev 01-2019/12" 	,"N",cTpFonte,cFonte2) // + AllTrim(SB1->B1_XREVINS)+ "   -  "+ cDataImpressao   	
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
Local ni
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i,j
Local nTamSX1	:= Len(SX1->X1_GRUPO)
Local aHelp 	:= {}
Local nI
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 			:= PADR("RESTR025",nTamSX1)

Aadd(aRegs,{cPerg,"01","Codigo do Produto ? ","Codigo do Produto ?","Codigo do Produto ? "	,"mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","",,"",""})
Aadd(aRegs,{cPerg,"02","Lote ? ","Lote ?","Lote ? "											,"mv_chb","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"03","Peças por Embalagem? ","Quantidade ?","Quantidade ? "				,"mv_chc","N",10,2,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Idioma ? ","Idioma ?","Idioma ? "									,"mv_ch4","N",01,0,1,"C","","mv_par04","Portugues","Portugues","Portugues","","","Ingles","Ingles","Ingles","","","Espanhol","Espanhol","Espanhol","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Validade Lote ? ","Validade Lote ?","Validade Lote ? "				,"mv_ch5","C",30,0,0,"G","","mv_par05",,"","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Data Fabricacao ? ","Data Fabricacao ?","Data Fabricacao ? "		,"mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Data Esterilização? ","Data Esteril. ?","Data Esteril. ? "			,"mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"08","Qtde Rótulos ? ","Quantidade Copias ?","Quantidade Copias ? "		,"mv_ch8","N",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTR025  ºAutor  ³Pirolo              º Data ³  02/04/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Dispara a impressão das etiquetas filhas.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTR25Fil(lEnd,_cProd,_cLote,_nQuant,_cValid,_dFabric,_dDtEmis,_nCop,_nLang)
Local ni
DbSelectArea("SZQ")
SZQ->(DbSetOrder(1))

SZQ->(DbGoTop())

If SZQ->(DbSeek(xFilial("SZQ")+_cProd))
	While SZQ->(!Eof() .AND. AllTrim(ZQ_PRODPAI) == AllTrim(_cProd))
		If SZQ->ZQ_ATIVO == "S"
			U_RESTR25Imp(lEnd, SZQ->ZQ_PRODFIL, _cLote, SZQ->ZQ_QTDE, _cValid, _dFabric, _dDtEmis, _nCop, _nLang, .F.)
		EndIf
		SZQ->(DbSkip())
	End
EndIf

Return
