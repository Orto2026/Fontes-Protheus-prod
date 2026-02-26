#INCLUDE "PROTHEUS.CH"
#INCLUDE "PRTOPDEF.CH"
#INCLUDE "RWMAKE.CH"

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ºRotina    ³ DTMATR05    ºAuto ³Samuel Miranda     º Data ³ 03/12/2019  º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ºDescricao ³ Rotina para impressao de etiquetas de Produtos             º±±
//±±º              com o codigo de barras data matrix                       º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ºUso       ³ Especifico Ortosintese                                     º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//Obs. um espaço = 8 uma Linnha  = 8

User Function DTMATR05()
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
Private cPerg  	:= Padr("DTMATR05",10)
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
    RptStatus({|lEnd| U_DTR5PRINT(.F.,mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07)},"Imprimindo, aguarde...")
Endif	

Return()

//Função de impressão das etiquetas

User Function DTR5PRINT(lEnd,_cProd,_cLote,_nQuant,_nLang,_dFabric,_dDtEmis,_nCop)
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
Local _cDatmatrix	:= ""
Local _cCodPro		:= ""
Local _cNavisa		:= "8120219"
Local _CodCaixa 	:= ""
Local _cCodMtrix    := ""
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
	MSCBWRITE("^XA ~TA000~JSN^LT09^MNW^MTT^PON^PMN^LH0,0^JMA^PR6,6~SD15^JUS")
	//MSCBWRITE("^LL0810")//Largura da Etiqueta
	//MSCBWRITE("^LS-11")//Posição a Esquerda
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
	MSCBWRITE("^FO572,64^A0N,017,017^FH_^FD"+ IIf(_nLang=1,"Ver instrucao",IIf(_nLang=2,"See instruction","Ver instruccion")) + "^FS")
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

	// Trata a impressão de caracteres especiais.
	portugues 		:= SB1->B1_XDMCP
	ingles  		:= SB1->B1_XDMCI
	Espanhol 		:= SB1->B1_XDMCE

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

	Espanhol := Alltrim(StrTran(Alltrim(Espanhol),"Ø",""))              
	Espanhol := Alltrim(StrTran(Alltrim(Espanhol),"º","§")) 
	Espanhol := Alltrim(StrTran(Alltrim(Espanhol),"°","§")) 
	Espanhol := Alltrim(StrTran(Alltrim(Espanhol),"ï","")) 
	Espanhol := Alltrim(StrTran(Alltrim(Espanhol),"ï","Ø")) 

 	//Descrição do Produto
	MSCBWRITE("^FO40,136^A0N,020,020^FH_^FD"+ IIf(_nLang=1,portugues,IIf(_nLang=2,ingles,Espanhol)) +"^FS") //Descrição do Produto
	MSCBWRITE("^FO40,160^A0N,020,020^FH_^FD"+ IIf(_nLang=1,SB1->B1_XDNCP,IIf(_nLang=2,SB1->B1_XDNCI,SB1->B1_XDNCE)) +"^FS") //Nome Comercial do produto.
	MSCBWRITE("^FO40,184^A0N,020,020^FH_^FD"+ IIf(_nLang=1,SB1->B1_XDNTP,IIf(_nLang=2,SB1->B1_XDNTI,SB1->B1_XDNTE)) +"^FS") //Nome Técnico do produto.
	//MSCBWRITE("^FO40,136^A0N,020,020^FH_^FD"+ IIf(_nLang=1,OEMTOANSI(SB1->B1_XDMCP),IIf(_nLang=2,OEMTOANSI(SB1->B1_XDMCI),OEMTOANSI(SB1->B1_XDMCE))) +"^FS") //Descrição do Produto
	//MSCBWRITE("^FO40,160^A0N,020,020^FH_^FD"+ IIf(_nLang=1,OEMTOANSI(SB1->B1_XDNCP),IIf(_nLang=2,OEMTOANSI(SB1->B1_XDNCI),OEMTOANSI(SB1->B1_XDNCE))) +"^FS") //Nome Comercial do produto.
	//MSCBWRITE("^FO40,184^A0N,020,020^FH_^FD"+ IIf(_nLang=1,OEMTOANSI(SB1->B1_XDNTP),IIf(_nLang=2,OEMTOANSI(SB1->B1_XDNTI),OEMTOANSI(SB1->B1_XDNTE))) +"^FS") //Nome Técnico do produto.

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
		 	MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD REGISTRO ANVISA: 1022371"+ Alltrim(SB1->B1_XANVISA) +" ^FS ")
		 EndIf
		 //Ingles
		 If _nLang=2
		 	MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD ANVISA REGISTRATION: 1022371"+ Alltrim(SB1->B1_XANVISA)+" ^FS ")
		 EndIf
		 //Espanhol
		 If _nLang=3
		 	MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD REGISTRO ANVISA: 1022371"+ Alltrim(SB1->B1_XANVISA)+" ^FS ")
		 EndIf
	EndIf
	//Registro Anvisa conforme filial e idioma
	If SB1->B1_XANVEMP ="2"
		//Alterado dia 05/01/2021 a pedido da Lullis do Assunt. Regulatórios conforme chamado n°11369
		If _cNavisa+Alltrim(SB1->B1_XANVISA)=="81202190001" .AND. DTOS(_dFabric) >= '20210104'
			//Português
			If _nLang=1
			MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD REGISTRO ANVISA: NAO APLICAVEL CONFORME NT 218/2020 ^FS ")
			EndIf
			//Ingles 
			If _nLang=2
			MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD ANVISA REGISTRATION: NOT APPLICABLE ACCORDING TO NT 218/2020 ^FS ")
			EndIf
			//Espanhol
			If _nLang=3
			MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD REGISTRO ANVISA: NO APLICABLE SEGUN NT 218/2020 ^FS ")
			EndIf
		Else
			//Português
			If _nLang=1
			MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD REGISTRO ANVISA: 8120219"+ Alltrim(SB1->B1_XANVISA) +" ^FS ")
			EndIf
			//Ingles
			If _nLang=2
			MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD ANVISA REGISTRATION: 8120219"+ Alltrim(SB1->B1_XANVISA) +" ^FS ")
			EndIf
			//Espanhol
			If _nLang=3
			MSCBWRITE("^FO34,208^A0N,020,020^FH_^FD REGISTRO ANVISA: 8120219"+ Alltrim(SB1->B1_XANVISA)+" ^FS ")
			EndIf
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
	MSCBWRITE("^FO38,304^A0N,017,017^FH_^FD "+ IIf(_nLang=1,cMes +"/"+ cAno,IIf(_nLang=2,cAno +"/"+ cMes, cMes +"/"+ cAno ))+ " ^FS")  //COLOCAR DATA 
	
	//MSCBWRITE("^FO35,304^A0N,017,017^FH_^FD "+ cMes +"/"+ cAno +" ^FS  	")  //COLOCAR DATA + IIf(_nLang=1,cMes +"/"+ cAno,IIf(_nLang=2,cAno +"/"+ cMes,"")) +
	 _CodCaixa := "0703/01|0703/05|0703/06|0703/10|0704/01|0704/05|0704/06|0709/01|0709/05|0711/01|0711/05|0711/06|0713/01|0713/05|0713/06|0721/01|"
	 _CodCaixa += "0721/05|0721/06|0729/01|0729/05|0729/06|0736/01|0736/05|0742/01|0742/05|0744/01|0744/05|0748/01|0748/05|0750/01|0750/05|0750/06|"
	 _CodCaixa += "0756/01|0756/05|0756/06|0758/06|0760/01|0760/05|0761/01|0761/04|0761/05|0765/01|0765/05|0765/06|0767/01|0767/05|0770/01|0770/05|"
	 _CodCaixa += "0770/06|0772/01|0772/05|0776/01|0776/05|0792/01|0792/05|0806/01|0806/05|0806/06|0809/01|0809/05|0821/01|0821/05|0821/06|0823/01|"
	 _CodCaixa += "0823/02|0823/03|0823/04|0823/05|0823/06|0823/08|0823/09|0823/10|0823/11|0823/12|0823/13|0823/14|0823/15|0823/16|0823/18|0823/19|"
	 _CodCaixa += "0823/22|0823/23|0823/24|0823/25|0823/26|0823/28|0837/01|0837/05|0837/06|0840/01|0840/02|0840/05|0840/06|0840/07|0840/08|0840/09|"
	 _CodCaixa += "0701/05|0701/06|0707/05|0707/06|0741/01|0741/05|0743/01|0743/05|0746/01|0746/05|0746/06|0748/06|0756/07|0763/01|0763/05|0763/06|"
	 _CodCaixa += "0770/02|0770/07|0772/06|0778/01|0780/01|0780/05|0804/01|0804/02|0804/05|0804/06|0804/07|0808/05|0808/06|0808/07|0810/01|0810/05|"
	 _CodCaixa += "0823/07|0823/17|0823/20|0823/21|0840/03|0840/10|0840/11|0840/12|0842/01|0842/05|0848/01|0848/05|0848/06|0849/01|0849/05|0849/02|"
	 _CodCaixa += "0849/06|0850/01|0850/05|0855/01|0855/05|0855/06|0855/14|0855/07|0855/08|0855/09|0855/10|0855/11|0855/12|0855/13|0855/15|0856/01|"
	 _CodCaixa += "0856/02|0856/03|0857/01|0857/05|0857/06|0858/01|0858/05|0858/06|0859/01|0859/02|0859/05|0859/06|0860/01|0860/05|0860/06|0861/01|"
	 _CodCaixa += "0861/02|0861/05|0861/08|0861/09|0861/06|0861/07|0861/03|0861/17|0862/01|0862/05|0862/06|0863/01|0863/05|0863/06|0864/01|0864/05|"
	 _CodCaixa += "0864/06|0865/01|0865/05|0865/06|0865/07|0866/01|0866/05|0866/06|0866/07|0867/01|0867/05|0867/06|0868/01|0868/02|0868/05|0868/07|"
	 _CodCaixa += "0870/01|0870/02|0870/03|0870/04|0870/05|0870/06|0870/07|0870/08|0870/09|0870/10|0871/01|0871/05|0871/06|0872/01|0872/02|0872/03|"
	 _CodCaixa += "0872/04|0721/07|0761/02|0765/02|0767|0778/05|0805|0848/04|0849/04|0868/06|0874/01|0873/05|0873/06|0874/05|0874/06|0875/01|"
	 _CodCaixa += "0875/05|0875/06|0875/07|0729/07|0729/08|0736/06|0744/06|0776/07|0792/06|0835/08|0842/06|0849/03|0850/06|0859/03|0859/04|0866/08|"
	 _CodCaixa += "0866/09|0866/10|0874/07|0874/08|0874/09|0874/10|0876/05|0753/05|0753/06|0879/05|0879/06|0879/07|0880/05|0881/05|0878/02|0878/03|"
	 _CodCaixa += "0878/04|0776/06|0868/06|0882/01|0882/05|0883/01|0883/05|"

	//Validacao para 10 anos  
	MSCBWRITE("^FO160,248^XGAMPULHET^FS")//Imagem da validade 
	//Verificar se o codigo do produto é uma caixa se sim imprime a validade indeterminada
	If (Alltrim(SB1->B1_COD)) $ _CodCaixa
		//Validade indeterminada para as caixas 
		If _nLang=1
			MSCBWRITE("^FO132,304^A0N,017,017^FH_^FDIndeterminado^FS ")
		EndIf
		If _nLang=2
			MSCBWRITE("^FO132,304^A0N,017,017^FH_^FDUndetermined^FS ")
		Endif
		If _nLang=3
			MSCBWRITE("^FO146,304^A0N,017,017^FH_^FDIndefinido^FS ")
		Endif
	ElseIf SB1->B1_XSTERI = "2" 															
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

	//If SB1->B1_XCE0434 = "1"  
	//	MSCBWRITE("^FO376,256^XG02CE^FS")//Imagem  CE2460
	//	MSCBWRITE("^FO392,304^A0N,017,017^FH_^FD2460^FS")
	//EndIf
	MSCBWRITE("^FO464,240^XGCOPO^FS") //imagem do Copo
	If SB1->B1_XHUMID = "1"
		MSCBWRITE("^FO616,240^XGUR0010^FS")//Imagem Umidade relativa do AR
	EndIf
	
	//Data de validade impressa no Data matrix																					  		
	_cDatmatrix := alltrim(Substr(cAno,3,4))+cMes+cDia
	//Remove caracteres especiais do codigo do produto
	_cCodPro    := Alltrim(StrTran(alltrim(SB1->B1_COD),"/",""))

	//Alltrim(StrTran(Alltrim(ingles),"Ø",""))  

	//-------------------------Impressão do Codigo DataMatrix----------------------------------------// 

	//01 = AI
	//07898357410015 = GTIN incluido de um Zero no início
	//17 = AI
	//251231 = data de validade no formato correto AAMMDD
	//10 = AI
	//ABC123 = informação do lote
	//(01) Global Trade Item Number (GTIN)
	//(17) Data de Validade
	//(10) Numero do lote 	 7899144314233  
	//(91) Codigo do Produo "12345678901231" B1_CODGTIN
	//_cCodMtrix := "_101"+"12345678901231"+"17"+_cDatmatrix+"10"+Alltrim(UPPER(_cLote))+"_1"+"91"+Alltrim(_cCodPro)

	MSCBWRITE("^BY0,0				   	")    			
	MSCBWRITE("^FT700, 227			   	")			  
	MSCBWRITE("^BXN,4,200,0,0,1,_,1  	")  //Adicionado a codificação para para que possa ser indentificado as infomarções conforme GS1
	MSCBWRITE("^FH\^FD"+"_1010"+Alltrim(SB1->B1_CODBAR)+"17"+Alltrim(_cDatmatrix)+"10"+Alltrim(UPPER(_cLote))+"_191"+Alltrim(_cCodPro)+"^FS")
	//^FH\^FD_10107899144314233173307291023D001998_1913080^FS
	//---------------------------Fim da Impressão Datamatrix-----------------------------------------//  
	_cValid := ""	

	MSCBWRITE("^FO712,232^XGTEMP13^FS")
	MSCBWRITE("^FO32,320^GB328,112,3,B^FS") //Caixa do Codigo de Barras EAN
	MSCBWRITE("^FO64,320^BY3,2,64^BEN, 64,Y,N^FD"+Alltrim(SB1->B1_CODBAR)+"^FS")
	MSCBWRITE("^FO0,16^BY2,2,32^BCB, 32,N,N,N,N^FD"+UPPER(_cLote)+"^FS")
	//MSCBWRITE("^FO368,320^A0N,017,017^FH_^FDEuropean Authorized Representative Obelis SA^FS")//
	//MSCBWRITE("^FO368,336^A0N,017,017^FH_^FDBd. General Wahis 53 1030 Brussels, BELGIUM^FS")//MSCBWRITE("^FO368,336^A0N,017,017^FH_^FDBd. General Wahis 53 1030 Brussels, BELGIUM^FS")
	//MSCBWRITE("^FO368,320^A0N,017,017^FH_^FDTel +(32)2.732.59.54 Fax +(32)2.732.60.03^FS")//MSCBWRITE("^FO368,352^A0N,017,017^FH_^FDTel +(32)2.732.59.54 Fax +(32)2.732.60.03^FS")
	//MSCBWRITE("^FO368,336^A0N,017,017^FH_^FDEmail: mail@obelis.net - Resp. Verificacao: F. MARTINS^FS")
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
			MSCBWRITE("^FO368,416^A0N,017,017^FH_^FDinstrucoesdeuso@ortosintese.com.br Rotulo Rev 04-11/2022^FS")//Rev 04 – 11/2022.
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

	//Registro Anvisa conforme parametro B1_XANVISA
	If SB1->B1_XANVEMP ="1"
		 cRegAnvisa := "1022371"+Alltrim(SB1->B1_XANVISA)
	ElseIf SB1->B1_XANVEMP ="2"
		 cRegAnvisa := "8120219"+Alltrim(SB1->B1_XANVISA) 
	EndIf

    //Alimenta a variavel cRegAnvisa conforme paramentros
	If EMPTY(SB1->B1_XANVISA) 
	  	cRegAnvisa := IIf(_nLang=1,"Exclusivo Mercado Externo",IIf(_nLang=2,"Exclusive Foreign Market","Exclusivo Mercado Externo"))
	Else
		If SB1->B1_XANVEMP ="1"		//Portugeês                      //Inglês                                //Espanhol
			cRegAnvisa := IIf(_nLang=1,"Registro ANVISA: 1022371",IIf(_nLang=2,"ANVISA Registration: 1022371","Registro ANVISA: 1022371"))+ Alltrim(SB1->B1_XANVISA)
		//Alterado dia 05/01/2021 a pedido da Lullis do Assunt. Regulatórios conforme chamado n°11369
		ElseIf SB1->B1_XANVEMP ="2" .AND. cRegAnvisa ="81202190001" .AND. DTOS(_dFabric) >= '20210104'
			cRegAnvisa := IIf(_nLang=1,"REGISTRO ANVISA: NAO APLICAVEL CONFORME NT 218/2020",IIf(_nLang=2,"ANVISA REGISTRATION: NOT APPLICABLE ACCORDING TO NT 218/2020","REGISTRO ANVISA: NO APLICABLE SEGUN NT 218/2020"))
		ElseIf SB1->B1_XANVEMP ="2"  //Portugeês                      //Inglês                                //Espanhol
			cRegAnvisa := IIf(_nLang=1,"Registro ANVISA: 8120219",IIf(_nLang=2,"ANVISA Registration: 8120219","Registro ANVISA: 8120219"))+ Alltrim(SB1->B1_XANVISA) 
	    Endif            
		
	End If 

	//Portugeês = Registro ANVISA: NAO APLICAVEL CONFORME NT 218/2020 	
	//Inglês	= ANVISA Registration: Not applicable according to NT 218/2020
	//Espanhol  = Registro ANVISA: No aplicable según NT 218/2020

	MSCBWRITE("^FO20,448^GB780,100,3,B^FS") //Box 01
    MSCBWRITE("^FO25,458^A0N,017,017^FH_^FDORTOSINTESE IND. E COM. LTDA ^FS") // 01
    MSCBWRITE("^FO25,476^A0N,017,017^FH_^FDTel.: 55(11)39484000 ^FS") // 01
    MSCBWRITE("^FO25,494^A0N,017,017^FH_^FDRef.: "+ Alltrim(SB1->B1_COD)+"^FS") //01
    MSCBWRITE("^FO200,494^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Lote: ",IIf(_nLang=2,"Lot: ","Lote: "))+UPPER(_cLote)+"^FS") //01
    MSCBWRITE("^FO25,512^A0N,017,017^FH_^FD"+IIf(_nLang=1,Alltrim(portugues),IIf(_nLang=2,Alltrim(ingles),Alltrim(Espanhol))) +"^FS") //01
    //MSCBWRITE("^FO25,523^A0N,017,017^FH_^FD"+IIf(_nLang=1,Alltrim((Substr(portugues,1,70))),IIf(_nLang=2,Alltrim((Substr(ingles,1,70))),Alltrim((Substr(Espanhol,1,70))))) +"^FS") //01
    MSCBWRITE("^FO25,530^A0N,017,017^FH_^FD"+cRegAnvisa+"^FS") //01

	MSCBWRITE("^FO20,568^GB780,100,3,B^FS") //Box 02
    MSCBWRITE("^FO25,578^A0N,017,017^FH_^FDORTOSINTESE IND. E COM. LTDA ^FS") // 02
    MSCBWRITE("^FO25,596^A0N,017,017^FH_^FDTel.: 55(11)39484000 ^FS") // 02
    MSCBWRITE("^FO25,614^A0N,017,017^FH_^FDRef.: "+ Alltrim(SB1->B1_COD)+"^FS") //02 
    MSCBWRITE("^FO200,614^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Lote: ",IIf(_nLang=2,"Lot: ","Lote: "))+UPPER(_cLote)+"^FS") //02	
    MSCBWRITE("^FO25,632^A0N,017,017^FH_^FD"+IIf(_nLang=1,Alltrim(portugues),IIf(_nLang=2,Alltrim(ingles),Alltrim(Espanhol))) +"^FS") //02 
    //MSCBWRITE("^FO25,641^A0N,017,017^FH_^FD"+IIf(_nLang=1,Alltrim((Substr(portugues,1,70))),IIf(_nLang=2,Alltrim((Substr(ingles,1,70))),Alltrim((Substr(Espanhol,1,70))))) +"^FS") //02 
	MSCBWRITE("^FO25,650^A0N,017,017^FH_^FD"+cRegAnvisa+"^FS") //02

    MSCBWRITE("^FO20,688^GB780,100,3,B^FS") //Box 03
    MSCBWRITE("^FO25,698^A0N,017,017^FH_^FDORTOSINTESE IND. E COM. LTDA ^FS") // 03
	MSCBWRITE("^FO25,716^A0N,017,017^FH_^FDTel.: 55(11)39484000 ^FS") // 03
	MSCBWRITE("^FO25,734^A0N,017,017^FH_^FDRef.: "+ Alltrim(SB1->B1_COD)+"^FS") //03
    MSCBWRITE("^FO200,734^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Lote: ",IIf(_nLang=2,"Lot: ","Lote: "))+UPPER(_cLote)+"^FS") //03
    MSCBWRITE("^FO25,752^A0N,017,017^FH_^FD"+IIf(_nLang=1,Alltrim(portugues),IIf(_nLang=2,Alltrim(ingles),Alltrim(Espanhol))) +"^FS") //03 
    //MSCBWRITE("^FO25,767^A0N,017,017^FH_^FD"+IIf(_nLang=1,Alltrim((Substr(portugues,1,70))),IIf(_nLang=2,Alltrim((Substr(ingles,1,70))),Alltrim((substr(Espanhol,1,70))))) +"^FS") //03 
	MSCBWRITE("^FO25,770^A0N,017,017^FH_^FD"+cRegAnvisa+"^FS") //03

	//-----------------------------------------------------------------// 
	//----------------------DATAMATRIX BOX 01--------------------------// 
	//(01) Global Trade Item Number (GTIN)
	//(17) Data de Validade
	//(10) Numero do lote 
	//(91) Codigo do Produo           
	MSCBWRITE("^BY0,0				   	")    			
	MSCBWRITE("^FT720, 530			   	")			  
	MSCBWRITE("^BXN,3,200,0,0,1,_,1  	")  //Adicionado a codificação para para que possa ser indentificado as infomarções conforme GS1
	MSCBWRITE("^FH\^FD"+"_1010"+Alltrim(SB1->B1_CODBAR)+"17"+Alltrim(_cDatmatrix)+"10"+Alltrim(UPPER(_cLote))+"_191"+Alltrim(_cCodPro)+"^FS")

	//----------------------------------------------------------------//  
	//----------------------DATAMATRIX BOX 02-------------------------//
	//(01) Global Trade Item Number (GTIN)
	//(17) Data de Validade
	//(10) Numero do lote 
	//(91) Codigo do Produo           
	MSCBWRITE("^BY0,0				   	")    			
	MSCBWRITE("^FT720, 650			   	")			  
	MSCBWRITE("^BXN,3,200,0,0,1,_,1  	")  //Adicionado a codificação para para que possa ser indentificado as infomarções conforme GS1
	MSCBWRITE("^FH\^FD"+"_1010"+Alltrim(SB1->B1_CODBAR)+"17"+Alltrim(_cDatmatrix)+"10"+Alltrim(UPPER(_cLote))+"_191"+Alltrim(_cCodPro)+"^FS")

	//----------------------------------------------------------------//  
	//----------------------DATAMATRIX BOX 03-------------------------// 
	//(01) Global Trade Item Number (GTIN)
	//(17) Data de Validade
	//(10) Numero do lote 
	//(91) Codigo do Produo           
	MSCBWRITE("^BY0,0				   	")    			
	MSCBWRITE("^FT720, 770			   	")			  		
	MSCBWRITE("^BXN,3,200,0,0,1,_,1  	")  //Adicionado a codificação para para que possa ser indentificado as infomarções conforme GS1
	MSCBWRITE("^FH\^FD"+"_1010"+Alltrim(SB1->B1_CODBAR)+"17"+Alltrim(_cDatmatrix)+"10"+Alltrim(UPPER(_cLote))+"_191"+Alltrim(_cCodPro)+"^FS")
	
	
	//-----------------------------------------------------------------//  
	//Informação EC | REP
	//MSCBWRITE("^FO720,320^GB80,40,3,B^FS")
	//MSCBWRITE("^FO760,320^GB0,40,3,B^FS")
	//MSCBWRITE("^FO728,336^A0N,015,015^FH_^FDEC^FS")
	//MSCBWRITE("^FO768,336^A0N,015,015^FH_^FDREP^FS")
	//MSCBWRITE("^PQ"+ cvaltochar(nCopias)+",0,1,Y ") // Numero de copias
	MSCBWRITE("^PQ"+ cvaltochar(nCopias)+"")          // Numero de copias
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

Local _sAlias := Alias()
Local aRegs   := {}
Local i,j
Local nTamSX1 := Len(SX1->X1_GRUPO)
//Local aHelp := {}

dbSelectArea("SX1")
dbSetOrder(1)
cPerg         := PADR("DTMATR05",nTamSX1)

Aadd(aRegs,{cPerg,"01","Codigo do Produto...?","Codigo do Produto...?","Codigo do Produto...?","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
Aadd(aRegs,{cPerg,"02","Lote................?","Lote................?","Lote................?","mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Peças por Embalagem.?","Quantidade..........?","Quantidade..........?","mv_ch3","N",10,2,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Idioma..............?","Idioma..............?","Idioma..............?","mv_ch4","N",01,0,1,"C","","mv_par04","Portugues","Portugues","Portugues","","","Ingles","Ingles","Ingles","","","Espanhol","Espanhol","Espanhol","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Data Fabricacao.....?","Data Fabricacao.....?","Data Fabricacao.....?","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Data Esterilização..?","Data Esteril........?","Data Esteril........?","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Qtde Rótulos........?","Qtde Rótulos........?","Qtde Rótulos........?","mv_ch7","N",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//Aadd(aRegs,{cPerg,"09","Qtde Rótulos FILHO ? ","Qtde Rótulos FILHO ? ","Qtde Rótulos FILHO ? ","mv_ch9","N",03,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//mv_par01,	mv_par02,	mv_par03,	mv_par04,	mv_par05,	mv_par06,	mv_par07,	mv_par08
//Codigo,lote,PcsEbale,Idioma,Validade,DTFabi,DTesteril,QtdeRto

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
