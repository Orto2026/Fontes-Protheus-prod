#INCLUDE "PROTHEUS.CH"
#INCLUDE "PRTOPDEF.CH"
#INCLUDE "RWMAKE.CH"

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Rotina    | DTMATR05    |Auto | Samuel Miranda    | Data | 03/12/2019  |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Descricao | Rotina para impressao de etiquetas de Produtos             |±±
//±±|              com o codigo de barras data matrix                       |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Uso       | Especifico Ortosintese                                     |±±
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

If nOpc == 1              //       01     02        03       04      05       06        07      08            
    RptStatus({|lEnd| U_DTR5PRINT(.F.,mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07)},"Imprimindo, aguarde...")
Endif	

Return()

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Rotina    | DTR5PRINT    |Auto | Samuel Miranda    | Data | 03/12/2019 |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Uso       | Função principal para impressão das etiquetas.             |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//                       01     02     03      04      05      06     07      08  
User Function DTR5PRINT(lEnd,_cProd,_cLote,_nQuant,_nLang,_dFabric,_dDtEmis,_nCop)
						   //Codigo, lote,PcsEbale,Idioma,DTFabi,DTesteril,QtdeRto	
//mv_par01 _cProd	:= Codigo do Produto a Ser Impresso
//mv_par02 _cLote	:= Lote do Produto
//mv_par03 _nQtde	:= Quantidade (Informada no Parametro - Analisar quando for da OP - qual QTDE Trazer
//mv_par04 _cValid	:= Texto com a Data da Validade ou Literal: Val Indeterminada (Retirado do pergunte)
//mv_par05 _nLang	:= 1=Port / 2=Ingles / 3=Spanish
//mv_par06 _dDtEmis	:= Campo Data mal definido no levantamento - Quando automatico trazer dDatabase
//mv_par07 _nCop	:= Numero de Copias de Etiqueta.
					
//Local _nvz          := _nCop
//Local _nTru			:= nTru	
Local nCopias 		:= _nCop  //_nCop   //Número de Copias 
Local cImpressora 	:= "ZEBRA" //Nome da Impressora
Local cPorta 		:= "LPT1"  //Porta padrão 
Local _cValid		:= ""
Local _cDatmatrix	:= ""
Local _cCodPro		:= ""
Local _cNavisa		:= "8120219"
Local _cInstru      := .T.
Local _cTipProd     := ""//Guarda o tipo do produto
Local cMes 			:= ""//SubStr(DtoS(_dFabric),5,2)
Local cAno 			:= ""//SubStr(DtoS(_dFabric),1,4) 
Local cDia 			:= ""//substr(Dtos(_dFabric),7,2)

//Local _cCodMtrix  := ""
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

//MSCBWRITE("^FO35,304^A0N,017,017^FH_^FD "+ cMes +"/"+ cAno +" ^FS  	")  //COLOCAR DATA + IIf(_nLang=1,cMes +"/"+ cAno,IIf(_nLang=2,cAno +"/"+ cMes,"")) +

//Validação para impressão de etiquetas de caixa incluido por Samuel Miranda dia 03/09/2025
SetRegua(1)
dbSelectArea("SB1")
SB1->(dbSetOrder(1))
If SB1->(dbSeek(xFilial("SB1")+_cProd))
	_cTipProd := SB1->B1_TIPO
	iF SB1->B1_GRUPO == 'KT01'
		_cInstru      := .F.
	EndIf
Endif

IncRegua()

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
	
MSCBPRINTER(cImpressora,cPorta)	 
MSCBCHKStatus(.F.)
    //MSCBBEGIN(nCopias,6)  
	MSCBLOADGRAF("L70X70.GRF")    //Logo Ortosintese Novo 
	MSCBLOADGRAF("UD70X49.GRF")   //UDI01
	MSCBLOADGRAF("FABRICA.GRF")   //Imagem fabrica                                                                  
	MSCBLOADGRAF("ATTENCAO.GRF")  //Imagem cuidado consultar instrucoes
	MSCBLOADGRAF("AMPULHET.GRF")  //Imagem da validade                                 
	MSCBLOADGRAF("FABRICAB.GRF")  //Imagem data de fabricação 
	MSCBLOADGRAF("02CE.GRF")	  //Imagem do CE
	MSCBLOADGRAF("COPO.GRF")  	  //Copo Simbolo de fragil manusear com cuidado
	MSCBLOADGRAF("10.GRF") 		  //Imagem Logo Nao Esteril 
	MSCBLOADGRAF("UR0010.GRF") 	  //Imagem Umidade relativa do AR
	MSCBLOADGRAF("TEMP13.GRF") 	  //Imagem Temperatura
	MSCBLOADGRAF("UNICO5.GRF") 	  //Imagem Uso Unico
	
	//Inicia a montagem da imagem(etiqueta) a ser impressa		
	//MSCBWRITE("^XA ~TA000~JSN^LT09^MNW^MTT^PON^PMN^LH0,0^JMA^PR6,6~SD15^JUS") //CI0
	MSCBWRITE("^XA^CI0") 
	//MSCBWRITE("^LL0810")//Largura da Etiqueta
	//MSCBWRITE("^LS-11")//Posição a Esquerda
	MSCBWRITE("^PR4")
	MSCBWRITE("^PQ1")

	//Trata a impressão das etiquetas (Pai e Filho)
	If _cTipProd == "PA"
	   
		MSCBWRITE("^FO045,008^XGL70X70^FS") //Logo Ortosintese
		MSCBWRITE("^FO125,008^A0N,020,020^FH_^FDORTOSINTESE IND. E COM. LTDA Á á ^FS")
		//Divisão de Ortopedi
		MSCBWRITE("^FO125,028^A0N,016,016^FH_^FDAv. Nelson Palma Travassos, 651-Cep:02998-000^FS")
		MSCBWRITE("^FO125,048^A0N,017,017^FH_^FDTel.: 55(11)39484000 - FAX: 55(11)39484010^FS")
		MSCBWRITE("^FO125,068^A0N,017,017^FH_^FDSao Paulo-SP Brasil - Site: www.ortosintese.com.br^FS")
		
		MSCBWRITE("^FO505,006^XGFABRICA^FS") //Imagem fabrica 
		If SB1->B1_XSTERI = "2" 
			MSCBWRITE("^FO680,008^GB120,24,3,B^FS")//Box ESTRERIL/NO ESTERIL
			MSCBWRITE("^FO505,238^XG10^FS")//Imagem Nao Esteril 	
		Else
			MSCBWRITE("^FO680,008^GB120,24,3,B^FS")
		Endif
		//Portugues
		if _nLang = 1  
			//MSCBWRITE("^FO688,016^A0N,015,015^FH_^FD"+ IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL")+"^FS ") 
			MSCBWRITE("^A0N,15,15^FO688,15^FD "+ IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL")+" ^FS") 
			MSCBWRITE("^A0N,15,15^FO689,15^FD "+ IIf(SB1->B1_XSTERI = "2","NAO ESTERIL","ESTERIL")+" ^FS") 	
		ENDIF
		//Ingles
		IF  _nLang = 2
			MSCBWRITE("^FO688,016^A0N,015,015^FH_^FD"+ IIf(SB1->B1_XSTERI = "2","NO STERILE","STERILE")	+"^FS ") 		
		EndIf
		//Espanhol
		if _nLang = 3
			MSCBWRITE("^FO688,016^A0N,015,015^FH_^FD"+ IIf(SB1->B1_XSTERI = "2","NO ESTERIL","ESTERIL")	+"^FS ") 	
		ENDIF
		//Impressão e indentificaçã do tipo de esterilização.
		If SB1->B1_XSTERI = "1" 
			If SB1->B1_XSTETP = "2"
				MSCBWRITE("^FO760,008^GB0,24,3,B^FS 		    ")//linha Vertical no Box
				MSCBWRITE("^FO768,016^A0N,015,015^FH_^FD EO ^FS ") //Tipo de esterelização
			EndIf
			
			If SB1->B1_XSTETP = "1"
				MSCBWRITE("^FO760,008^GB0,24,3,B^FS 			")//linha Vertical no Box
				MSCBWRITE("^FO768,016^A0N,015,015^FH_^FD R ^FS  ")//Tipo de esterelização
			EndIf 
			
			If SB1->B1_XSTETP = " "
				MSCBWRITE("^FO768,016^A0N,015,015^FH_^F D ^FS   ")
			EndIf			
		EndIf
		//Valida a impressão da intrução
		If _cInstru == .T.
			MSCBWRITE("^FO600,008^XGATTENCAO^FS")//Imagem cuidado consultar instrucoes
			MSCBWRITE("^FO573,060^A0N,017,017^FH_^FD"+ IIf(_nLang=1,"Ver instrucao",IIf(_nLang=2,"See instruction","Ver instruccion")) + "^FS")
			MSCBWRITE("^FO600,076^A0N,017,017^FH_^FD"+IIf(_nLang=1,"de uso",IIf(_nLang=2,"for use","de uso"))+"^FS")
		EndIf
		MSCBWRITE("^FO680,40^GB120,44,3,B^FS")//Box do Proibido processar
		If SB1->B1_XUNICO ="1"
			MSCBWRITE("^FO712,048^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Proibido",IIf(_nLang=2,"Do not","Prohibido"))+"^FS")
			MSCBWRITE("^FO696,064^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Reprocessar",IIf(_nLang=2,"Reprocess","Reprocesar"))+"^FS")
		EndIf
		MSCBWRITE("^FO045,094^GB280,32,3,B^FS")// Box do Codigo do Produto
		MSCBWRITE("^FO320,094^GB280,32,3,B^FS")// Box do Lote do Produto
		MSCBWRITE("^FO600,094^GB200,32,3,B^FS")// Box da Quantidade
		MSCBWRITE("^FO45,102^A0N,024,024^FH_^FD  "+"Ref.: "+ Alltrim(SB1->B1_COD)+"^FS") 	//Codigo do Produto
		MSCBWRITE("^FO328,102^A0N,024,024^FH_^FD "+IIf(_nLang=1,"Lote: ",IIf(_nLang=2,"Lot: ","Lote: "))+UPPER(_cLote)+"^FS") //Lote do Produto
		MSCBWRITE("^FO608,102^A0N,024,024^FH_^FD "+IIf(_nLang=1,"Quant.: ",IIf(_nLang=2,"Quant.: ","Cant.: "))+ Alltrim(Str(_nQuant)) + IIf(_nLang=1,"pc",IIf(_nLang=2,"pc","pz")) + "^FS")	//Quantidade do Produto por embalagem

		//Descrição do Produto
		MSCBWRITE("^FO45,132^A0N,020,020^FH_^FD"+ IIf(_nLang=1,portugues,IIf(_nLang=2,ingles,Espanhol)) +"^FS") //Descrição do Produto
		MSCBWRITE("^FO45,153^A0N,020,020^FH_^FD"+ IIf(_nLang=1,SB1->B1_XDNCP,IIf(_nLang=2,SB1->B1_XDNCI,SB1->B1_XDNCE)) +"^FS") //Nome Comercial do produto.
		MSCBWRITE("^FO45,174^A0N,020,020^FH_^FD"+ IIf(_nLang=1,SB1->B1_XDNTP,IIf(_nLang=2,SB1->B1_XDNTI,SB1->B1_XDNTE)) +"^FS") //Nome Técnico do produto.

		//Registro Anvisa
		If EMPTY(SB1->B1_XANVISA) 
			//Português
			If _nLang=1 
			MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDExclusivo Mercado Externo^FS ")
			EndIf
			//Ingles
			If _nLang=2 
			MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDExclusive Foreign Market^FS ")
			EndIf
			//Espanhol
			If _nLang=3
			MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDExclusivo Mercado Externo^FS ")
			EndIf
		EndIf
		
		//Registro Anvisa conforme filial e idioma
		If SB1->B1_XANVEMP ="1"
			//Português
			If _nLang=1
				MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDREGISTRO ANVISA: 1022371"+ Alltrim(SB1->B1_XANVISA) +" ^FS ")
			EndIf
			//Ingles
			If _nLang=2
				MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDANVISA REGISTRATION: 1022371"+ Alltrim(SB1->B1_XANVISA)+" ^FS ")
			EndIf
			//Espanhol
			If _nLang=3
				MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDREGISTRO ANVISA: 1022371"+ Alltrim(SB1->B1_XANVISA)+" ^FS ")
			EndIf
		EndIf
		//Registro Anvisa conforme filial e idioma
		If SB1->B1_XANVEMP ="2"
			//Validação para impressão de caixas.
			If _cInstru == .F.
				//Português
				If _nLang=1
				MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDREGISTRO ANVISA: NAO APLICAVEL CONFORME NT 218/2020 ^FS ")
				EndIf
				//Ingles 
				If _nLang=2
				MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDANVISA REGISTRATION: NOT APPLICABLE ACCORDING TO NT 218/2020 ^FS ")
				EndIf
				//Espanhol
				If _nLang=3
				MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDREGISTRO ANVISA: NO APLICABLE SEGUN NT 218/2020 ^FS ")
				EndIf
			 Else
				//Alterado dia 05/01/2021 a pedido da Lullis do Assunt. Regulatórios conforme chamado n°11369
				If _cNavisa+Alltrim(SB1->B1_XANVISA)=="81202190001" .AND. DTOS(_dFabric) >= '20210104'
					//Português
					If _nLang=1
					MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDREGISTRO ANVISA: NAO APLICAVEL CONFORME NT 218/2020 ^FS ")
					EndIf
					//Ingles 
					If _nLang=2
					MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDANVISA REGISTRATION: NOT APPLICABLE ACCORDING TO NT 218/2020 ^FS ")
					EndIf
					//Espanhol
					If _nLang=3
					MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDREGISTRO ANVISA: NO APLICABLE SEGUN NT 218/2020 ^FS ")
					EndIf
				 Else
					//Português
					If _nLang=1
					MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDREGISTRO ANVISA: 8120219"+ Alltrim(SB1->B1_XANVISA) +" ^FS ")
					EndIf
					//Ingles
					If _nLang=2
					MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDANVISA REGISTRATION: 8120219"+ Alltrim(SB1->B1_XANVISA) +" ^FS ")
					EndIf
					//Espanhol
					If _nLang=3
					MSCBWRITE("^FO45,195^A0N,020,020^FH_^FDREGISTRO ANVISA: 8120219"+ Alltrim(SB1->B1_XANVISA)+" ^FS ")
					EndIf
				EndIf
			EndIf
		EndIf
		
		//Materia Prima
		If _nLang = 1	//Português	
			MSCBWRITE("^FO45,216^A0N,020,020^FH_^FD"+"MP: "+ Alltrim(Upper(SB1->B1_XDESM1))+ "  "+ Alltrim(Upper(SB1->B1_XDESM2))+ "  "+ Alltrim(Upper(SB1->B1_XDESM3))+ " ^FS    ") 
		ElseIf _nLang = 2 //Ingles
			MSCBWRITE("^FO45,216^A0N,020,020^FH_^FD"+"RM: "+ Alltrim(Upper(SB1->B1_XDESMI1))+"  "+ Alltrim(Upper(SB1->B1_XDESMI2))+"  "+ Alltrim(Upper(SB1->B1_XDESMI3))+" ^FS   ") 
		ElseIf _nLang = 3 //Espanhol
			MSCBWRITE("^FO45,216^A0N,020,020^FH_^FD"+"MP: "+ Alltrim(Upper(SB1->B1_XDESM1))+ "  "+ Alltrim(Upper(SB1->B1_XDESM2))+ "  "+ Alltrim(Upper(SB1->B1_XDESM3))+ " ^FS    ") 
		EndIf
		
		MSCBWRITE("^FO55,233^XGFABRICAB^FS")//Imagem da validade 
		cMes := SubStr(DtoS(_dFabric),5,2)
		cAno := SubStr(DtoS(_dFabric),1,4) 
		cDia := substr(Dtos(_dFabric),7,2)
		MSCBWRITE("^FO45,291^A0N,017,017^FH_^FD "+ IIf(_nLang=1,cMes +"/"+ cAno,IIf(_nLang=2,cAno +"/"+ cMes,cMes +"/"+ cAno ))+ " ^FS")  //COLOCAR DATA 
		//MSCBWRITE("^FO40,291^A0N,017,017^FH_^FD "+ IIf(_nLang=1,cDia+"/"+cMes +"/"+ cAno,IIf(_nLang=2,cAno +"/"+ cMes+"/"+cDia,cDia+"/"+ cMes +"/"+ cAno ))+ " ^FS")  //COLOCAR DATA 
		
		//Validacao para 10 anos  
		MSCBWRITE("^FO158,235^XGAMPULHET^FS")//Imagem da validade 
		//Verificar se o codigo do produto é uma caixa se sim imprime a validade indeterminada
		If _cInstru == .F.   
			//Informa que a instrução de uso não vai ser impressa.
			//Validade indeterminada para as caixas 
			If _nLang=1
				MSCBWRITE("^FO132,291^A0N,017,017^FH_^FDIndeterminado^FS ")
			EndIf
			If _nLang=2
				MSCBWRITE("^FO132,291^A0N,017,017^FH_^FDUndetermined^FS ")
			Endif
			If _nLang=3
				MSCBWRITE("^FO146,291^A0N,017,017^FH_^FDIndefinido^FS ")
			Endif
		 ElseIf SB1->B1_XSTERI = "2" 															
			_cValid := (_dFabric+1)+(365*10)  
			cMes := SubStr(DtoS(_cValid),5,2)
			cAno := SubStr(DtoS(_cValid),1,4) 
			cDia := substr(Dtos(_cValid),7,2) 																		
			MSCBWRITE("^FO150,292^A0N,017,017^FH_^FD " + IIf(_nLang=1,cMes +"/"+ cAno,IIf(_nLang=2,cAno +"/"+ cMes,cMes +"/"+ cAno )) + " ^FS   ")
			//MSCBWRITE("^FO150,292^A0N,017,017^FH_^FD " + IIf(_nLang=1,cDia+"/"+cMes +"/"+ cAno,IIf(_nLang=2,cAno +"/"+ cMes+"/"+cDia,cDia+"/"+cMes +"/"+ cAno )) + " ^FS   ")		
			//_cValid := ""
		ENDIF

		//Validacao para 5 anos  	
		If SB1->B1_XSTERI = "1" 															
			_cValid := (_dFabric+1)+(365*5)  
			cMes := SubStr(DtoS(_cValid),5,2)
			cAno := SubStr(DtoS(_cValid),1,4) 
			cDia := substr(Dtos(_cValid),7,2) 																			
			MSCBWRITE("^FO150,291^A0N,017,017^FH_^FD "+ IIf(_nLang=1,cMes +"/"+ cAno,IIf(_nLang=2,cAno +"/"+cMes,cMes +"/"+cAno)) +" ^FS   ")
			//MSCBWRITE("^FO150,291^A0N,017,017^FH_^FD "+ IIf(_nLang=1,cDia+"/"+cMes +"/"+ cAno,IIf(_nLang=2,cAno +"/"+cMes+"/"+cDia,cDia+"/"+cMes +"/"+cAno)) +" ^FS   ")
		EndIf
		//Português	
		If SB1->B1_XUNICO ="1"
			MSCBWRITE("^FO272,239^XGUNICO5^FS")//Imagem Uso Unico
			MSCBWRITE("^FO264,291^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Uso Unico",IIf(_nLang=2,"Sigle Use","Uso Unico"))+"^FS ")
		EndIf

		MSCBWRITE("^FO435,230^XGCOPO^FS") //imagem do Copo
		If SB1->B1_XHUMID = "1"
			MSCBWRITE("^FO610,235^XGUR0010^FS")//Imagem Umidade relativa do AR
		EndIf
		
		//Data de validade impressa no Data matrix																					  		
		_cDatmatrix := alltrim(Substr(cAno,3,4))+cMes+cDia
		//Remove caracteres especiais do codigo do produto
		_cCodPro    := alltrim(SB1->B1_COD) // Alltrim(StrTran(alltrim(SB1->B1_COD),"/",""))
		
		//-------------------------Impressão do Codigo DataMatrix----------------------------------------// 
		//(01)0+ Global Trade Item Number (GTIN)
		//(17)+ Data de Validade
		//(10)+ Numero do lote 	   
		//(91)+ Codigo do Produo
		if _cInstru == .T.
			//Imagem do UDI
			MSCBWRITE("^FO450,380^XGUD70X49^FS")// MSCBGRAFIC(20,01,"UD70X49")
			//Impressão DataMatrix
			MSCBWRITE("^BY0,0				   	")    			
			MSCBWRITE("^FT530, 426			   	")	//MSCBWRITE("^FT715, 530			   	")			  
			MSCBWRITE("^BXN,4,200,0,0,1,_,1  	")  //Adicionado a codificação para para que possa ser indentificado as infomarções conforme GS1
			MSCBWRITE("^FH\^FD"+"_1010"+Alltrim(SB1->B1_CODBAR)+"17"+Alltrim(_cDatmatrix)+"10"+Alltrim(UPPER(_cLote))+"_191"+Alltrim(_cCodPro)+"^FS")
			
			//Impressão do humano legivel	
			MSCBWRITE("^FO627,347^A0N,020,020^FD"+"(01)0"+ Alltrim(SB1->B1_CODBAR)+"^FS")
			MSCBWRITE("^FO627,368^A0N,020,020^FD"+"(17)"+ Alltrim(_cDatmatrix)+"^FS")
			MSCBWRITE("^FO627,389^A0N,020,020^FD"+"(10)"+ Alltrim(UPPER(_cLote))+"^FS")
			MSCBWRITE("^FO627,410^A0N,020,020^FD"+"(91)"+ Alltrim(_cCodPro)+"^FS") 
		EndIf
		//---------------------------Fim da Impressão Datamatrix-----------------------------------------//  
		_cValid := ""	
		
		MSCBWRITE("^FO715,235^XGTEMP13^FS")//Imagem da Temperatura
		
		//Portugues
		If _nLang = 1
			MSCBWRITE("^FO45,316^A0N,017,017^FH_^FDResp. Tecnico: CARLOS M. NAKAMURA/CREA SP 0601828973 ^FS")
		ENDIF
		//Engles
		If _nLang = 2
			MSCBWRITE("^FO45,316^A0N,017,017^FH_^FDTech Resp.: CARLOS M. NAKAMURA/CREA SP 0601828973 ^FS")
		ENDIF
		//Espanhol
		If _nLang = 3
			MSCBWRITE("^FO45,316^A0N,017,017^FH_^FDResp. Tecnico: CARLOS M. NAKAMURA/CREA SP 0601828973 ^FS")
		ENDIF
		//Instrução de Uso
		If SB1->B1_XINSTRU = "1" .AND. _cInstru = .T.  //Sim
			//Portugues
			if _nLang = 1
				MSCBWRITE("^FO45,332^A0N,017,017^FH_^FDInstrucoes de Uso acesse em www.ortosintese.com.br ou ^FS")
				MSCBWRITE("^FO45,348^A0N,017,017^FH_^FDinstrucoesdeuso@ortosintese.com.br Rotulo Rev.06-07/2025^FS")//  Rev 04 – 11/2022. Rotulo Rev 06 - 07/2025 (Ultima  Rev.07-11/2025)
			EndIf
			//Engles
			if _nLang = 2
				MSCBWRITE("^FO45,332^A0N,017,017^FH_^FDIFU access at www.ortosintese.com.br or request by instrucoesdeuso@ortosintese.com.br ^FS")
				MSCBWRITE("^FO45,348^A0N,017,017^FH_^FDinstrucoesdeuso@ortosintese.com.br Label Rev.06-07/2025 ^FS")//
			EndIf
			//Espanhol
			if _nLang = 3
				MSCBWRITE("^FO45,332^A0N,017,017^FH_^FDInstruccion de Uso visite www.ortosintese.com.br o instrucoesdeuso@ortosintese.com.br ^FS")
				MSCBWRITE("^FO45,348^A0N,017,017^FH_^FDinstrucoesdeuso@ortosintese.com.br Rotulo Rev.06-07/2025^FS")// 
			EndIf
		 Else
			if _nLang = 1
				MSCBWRITE("^FO45,334^A0N,017,017^FH_^FDRotulo Rev.06-07/2025^FS")//Rev 04 – 11/2022. Rotulo Rev 06 - 07/2025
			EndIf
			//Engles
			if _nLang = 2
				MSCBWRITE("^FO45,334^A0N,017,017^FH_^FDLabel Rev.06-07/2025 ^FS")//
			EndIf
			//Espanhol
			if _nLang = 3
				MSCBWRITE("^FO45,334^A0N,017,017^FH_^FDRotulo Rev.06-07/2025^FS")// 
			EndIf
		EndIF	

		//Codigo de barras do Lote
		MSCBWRITE("^FO5,010")
		MSCBWRITE("^BY2,2,32")
		MSCBWRITE("^BCB, 32,N,N,N,N")
		MSCBWRITE("^FD"+UPPER(_cLote)+"^FS")

		//Caixa do Codigo de Barras EAN
		//MSCBWRITE("^FO32,400")
		//MSCBWRITE("^GB329,070,3,B^FS") //Caixa do Codigo de Barras EAN
		//Codigo de barras do codigo do produto
		MSCBWRITE("^FO64,367")
		MSCBWRITE("^BY3,2,35")
		MSCBWRITE("^BEN, 30,Y,N")
		MSCBWRITE("^FD"+Alltrim(SB1->B1_CODBAR)+"^FS")
		
	EndIf//Final da Validação do tipo de Produto

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
			cRegAnvisa := IIf(_nLang=1,"REGISTRO ANVISA: 1022371",IIf(_nLang=2,"ANVISA Registration: 1022371","Registro ANVISA: 1022371"))+ Alltrim(SB1->B1_XANVISA)
		//Alterado dia 05/01/2021 a pedido da Lullis do Assunt. Regulatórios conforme chamado n°11369
		ElseIf SB1->B1_XANVEMP ="2" .AND. cRegAnvisa ="81202190001" .AND. DTOS(_dFabric) >= '20210104'
			cRegAnvisa := IIf(_nLang=1,"REGISTRO ANVISA: NAO APLICAVEL CONFORME NT 218/2020",IIf(_nLang=2,"ANVISA REGISTRATION: NOT APPLICABLE ACCORDING TO NT 218/2020","REGISTRO ANVISA: NO APLICABLE SEGUN NT 218/2020"))
		ElseIf SB1->B1_XANVEMP ="2"  //Portugeês                      //Inglês                                //Espanhol
			cRegAnvisa := IIf(_nLang=1,"REGISTRO ANVISA: 8120219",IIf(_nLang=2,"ANVISA Registration: 8120219","Registro ANVISA: 8120219"))+ Alltrim(SB1->B1_XANVISA) 
		Endif            	
	End If 

	//Portugeês = Registro ANVISA: NAO APLICAVEL CONFORME NT 218/2020 	
	//Inglês	= ANVISA Registration: Not applicable according to NT 218/2020
	//Espanhol  = Registro ANVISA: No aplicable según NT 218/2020

	If _cInstru == .F.
		//Português
		If _nLang=1
			cRegAnvisa :="REGISTRO ANVISA: NAO APLICAVEL CONFORME NT 218/2020"
		EndIf
		//Ingles 
		If _nLang=2
			cRegAnvisa :="REGISTRO ANVISA: NOT APPLICABLE ACCORDING TO NT 218/2020"
		EndIf
		//Espanhol
		If _nLang=3
			cRegAnvisa :="REGISTRO ANVISA: NO APLICABLE SEGUN NT 218/2020"
		EndIf
	EndIf
  //If _nvz <= 1 
	//Impressão dos boxs 1 2 e 3
	MSCBWRITE("^FO20,458^GB780,099,3,B^FS") //Box 01
    MSCBWRITE("^FO25,468^A0N,017,017^FH_^FDORTOSINTESE IND. E COM. LTDA ^FS") // 01
    MSCBWRITE("^FO25,486^A0N,017,017^FH_^FDTel.: 55(11)39484000 ^FS") // 01
    MSCBWRITE("^FO25,506^A0N,017,017^FH_^FDRef.: "+ Alltrim(SB1->B1_COD)+"^FS") //01
    MSCBWRITE("^FO200,506^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Lote: ",IIf(_nLang=2,"Lot: ","Lote: "))+UPPER(_cLote)+"^FS") //01
    MSCBWRITE("^FO25,522^A0N,017,017^FH_^FD"+IIf(_nLang=1,Alltrim(portugues),IIf(_nLang=2,Alltrim(ingles),Alltrim(Espanhol))) +"^FS") //01
    //MSCBWRITE("^FO25,523^A0N,017,017^FH_^FD"+IIf(_nLang=1,Alltrim((Substr(portugues,1,70))),IIf(_nLang=2,Alltrim((Substr(ingles,1,70))),Alltrim((Substr(Espanhol,1,70))))) +"^FS") //01
    MSCBWRITE("^FO25,540^A0N,017,017^FH_^FD"+cRegAnvisa+"^FS") //01

	MSCBWRITE("^FO20,578^GB780,099,3,B^FS") //Box 02
    MSCBWRITE("^FO25,588^A0N,017,017^FH_^FDORTOSINTESE IND. E COM. LTDA ^FS") // 02
    MSCBWRITE("^FO25,606^A0N,017,017^FH_^FDTel.: 55(11)39484000 ^FS") // 02
    MSCBWRITE("^FO25,624^A0N,017,017^FH_^FDRef.: "+ Alltrim(SB1->B1_COD)+"^FS") //02 
    MSCBWRITE("^FO200,624^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Lote: ",IIf(_nLang=2,"Lot: ","Lote: "))+UPPER(_cLote)+"^FS") //02	
    MSCBWRITE("^FO25,642^A0N,017,017^FH_^FD"+IIf(_nLang=1,Alltrim(portugues),IIf(_nLang=2,Alltrim(ingles),Alltrim(Espanhol))) +"^FS") //02 
    //MSCBWRITE("^FO25,641^A0N,017,017^FH_^FD"+IIf(_nLang=1,Alltrim((Substr(portugues,1,70))),IIf(_nLang=2,Alltrim((Substr(ingles,1,70))),Alltrim((Substr(Espanhol,1,70))))) +"^FS") //02 
	MSCBWRITE("^FO25,660^A0N,017,017^FH_^FD"+cRegAnvisa+"^FS") //02

    MSCBWRITE("^FO20,698^GB780,099,3,B^FS") //Box 03
    MSCBWRITE("^FO25,708^A0N,017,017^FH_^FDORTOSINTESE IND. E COM. LTDA ^FS") // 03
	MSCBWRITE("^FO25,726^A0N,017,017^FH_^FDTel.: 55(11)39484000 ^FS") // 03
	MSCBWRITE("^FO25,744^A0N,017,017^FH_^FDRef.: "+ Alltrim(SB1->B1_COD)+"^FS") //03
    MSCBWRITE("^FO200,744^A0N,017,017^FH_^FD"+IIf(_nLang=1,"Lote: ",IIf(_nLang=2,"Lot: ","Lote: "))+UPPER(_cLote)+"^FS") //03
    MSCBWRITE("^FO25,762^A0N,017,017^FH_^FD"+IIf(_nLang=1,Alltrim(portugues),IIf(_nLang=2,Alltrim(ingles),Alltrim(Espanhol))) +"^FS") //03 
    //MSCBWRITE("^FO25,767^A0N,017,017^FH_^FD"+IIf(_nLang=1,Alltrim((Substr(portugues,1,70))),IIf(_nLang=2,Alltrim((Substr(ingles,1,70))),Alltrim((substr(Espanhol,1,70))))) +"^FS") //03 
	MSCBWRITE("^FO25,780^A0N,017,017^FH_^FD"+cRegAnvisa+"^FS") //03
    
	If _cInstru == .T. .AND. _cTipProd == "PA"
		//-----------------------------------------------------------------// 
		//----------------------DATAMATRIX BOX 01--------------------------// 
		//(01) Global Trade Item Number (GTIN)
		//(17) Data de Validade
		//(10) Numero do lote 
		//(91) Codigo do Produo           
		MSCBWRITE("^BY0,0				   	")    			
		MSCBWRITE("^FT575, 540			   	")			  
		MSCBWRITE("^BXN,3,200,0,0,1,_,1  	")  //Adicionado a codificação para para que possa ser indentificado as infomarções conforme GS1
		MSCBWRITE("^FH\^FD"+"_1010"+Alltrim(SB1->B1_CODBAR)+"17"+Alltrim(_cDatmatrix)+"10"+Alltrim(UPPER(_cLote))+"_191"+Alltrim(_cCodPro)+"^FS")
		
		MSCBWRITE("^FO650,470^A0N,017,017^FD"+"(01)0"+ Alltrim(SB1->B1_CODBAR)+"^FS")
		MSCBWRITE("^FO650,491^A0N,017,017^FD"+"(17)"+ Alltrim(_cDatmatrix)+"^FS")
		MSCBWRITE("^FO650,512^A0N,017,017^FD"+"(10)"+ Alltrim(UPPER(_cLote))+"^FS")
		MSCBWRITE("^FO650,533^A0N,017,017^FD"+"(91)"+ Alltrim(_cCodPro)+"^FS")
		//----------------------------------------------------------------//  
		//----------------------DATAMATRIX BOX 02-------------------------//
		//(01) Global Trade Item Number (GTIN)
		//(17) Data de Validade
		//(10) Numero do lote 
		//(91) Codigo do Produo           
		MSCBWRITE("^BY0,0				   	")    			
		MSCBWRITE("^FT575, 660			   	")			  
		MSCBWRITE("^BXN,3,200,0,0,1,_,1  	")  //Adicionado a codificação para para que possa ser indentificado as infomarções conforme GS1
		MSCBWRITE("^FH\^FD"+"_1010"+Alltrim(SB1->B1_CODBAR)+"17"+Alltrim(_cDatmatrix)+"10"+Alltrim(UPPER(_cLote))+"_191"+Alltrim(_cCodPro)+"^FS")

		MSCBWRITE("^FO650,590^A0N,017,017^FD"+"(01)0"+ Alltrim(SB1->B1_CODBAR)+"^FS")
		MSCBWRITE("^FO650,611^A0N,017,017^FD"+"(17)"+ Alltrim(_cDatmatrix)+"^FS")
		MSCBWRITE("^FO650,632^A0N,017,017^FD"+"(10)"+ Alltrim(UPPER(_cLote))+"^FS") 
		MSCBWRITE("^FO650,653^A0N,017,017^FD"+"(91)"+ Alltrim(_cCodPro)+"^FS")
		//----------------------------------------------------------------//  
		//----------------------DATAMATRIX BOX 03-------------------------// 
		//(01) Global Trade Item Number (GTIN)
		//(17) Data de Validade
		//(10) Numero do lote 
		//(91) Codigo do Produo           
		MSCBWRITE("^BY0,0				   	")    			
		MSCBWRITE("^FT575, 780			   	")			  		
		MSCBWRITE("^BXN,3,200,0,0,1,_,1  	")  //Adicionado a codificação para para que possa ser indentificado as infomarções conforme GS1
		MSCBWRITE("^FH\^FD"+"_1010"+Alltrim(SB1->B1_CODBAR)+"17"+Alltrim(_cDatmatrix)+"10"+Alltrim(UPPER(_cLote))+"_191"+Alltrim(_cCodPro)+"^FS")
		
		MSCBWRITE("^FO650,710^A0N,017,017^FD"+"(01)0"+ Alltrim(SB1->B1_CODBAR)+"^FS")
		MSCBWRITE("^FO650,731^A0N,017,017^FD"+"(17)"+ Alltrim(_cDatmatrix)+"^FS")
		MSCBWRITE("^FO650,752^A0N,017,017^FD"+"(10)"+ Alltrim(UPPER(_cLote))+"^FS")
		MSCBWRITE("^FO650,773^A0N,017,017^FD"+"(91)"+ Alltrim(_cCodPro)+"^FS")
	EndIf
  //EndIf
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
/*
Method RemoveEspec(cWord) class suaclasse
	cWord := OemToAnsi(AllTrim(cWord))
	cWord := FwNoAccent(cWord)
	cWord := FwCutOff(cWord)
	cWord := strtran(cWord,"ã","")
	cWord := strtran(cWord,"Ã","")
	cWord := strtran(cWord,"â","")
	cWord := strtran(cWord,"Â","")
	cWord := strtran(cWord,"Õ","")
	cWord := strtran(cWord,"õ","")
	cWord := strtran(cWord,"?","")
	cWord := strtran(cWord,"!","")
	cWord := strtran(cWord,"~","")
	cWord := strtran(cWord,"^","")
	cWord := strtran(cWord," ´","")
	cWord := strtran(cWord,">","")
	cWord := strtran(cWord,"<","")
	cWord := strtran(cWord,"`","")
	cWord := strtran(cWord,"¨","")
	cWord := strtran(cWord,"º","")
	cWord := strtran(cWord,"%","")
	cWord := strtran(cWord,"*","")
	cWord := strtran(cWord,"|","")
	cWord := strtran(cWord,"&","")
	cWord := strtran(cWord,"$","")
	cWord := strtran(cWord,"#","")
	cWord := strtran(cWord,"§","")
	cWord := strtran(cWord,"ä","a")
	cWord := strtran(cWord,""+'"'+"","")
Return cWord
*/


//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Rotina    | VALIDPERG    |Auto | Samuel Miranda    | Data | 03/12/2019 |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Uso       | Cria as perguntas caso elas não existao na SX1             |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs   := {}
Local i		  := 0
Local j		  := 0
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
//Aadd(aRegs,{cPerg,"08","Divisão.............?","Divisão.............?","Divisão.............?","mv_ch8","N",01,0,1,"C","","mv_par08","Ortopedia","Ortopedia","Ortopedia","","","Equipamentos","Equipamentos","Equipamentos","","","","","","","","","","","","","","","","","","","","",""})

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
