#include "protheus.ch"


//===================================================================================//
//===================================================================================//
//=== Rotina    -  RESTR038  - Autor  - Samuel Miranda     - Data    -  26/03/2019 ==// 
//===================================================================================//
//=== Descricao ? Rotina de para impressao de etiquetas de produtos com      	   ==//
//===         ? codigo de barras a partir da OP                            	       ==//
//===================================================================================//
//=== Uso       ? Especifico Ortosintese                                     	   ==//
//===================================================================================//
//===================================================================================//


User Function RESTR11A()

Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo 	:= "Impressão de etiqueta de Produtos com Código de Barras."

Private cDesc1 	:= "Este programa irá imprimir as etiquetas de Produto com"
Private cDesc2 	:= "código de barras, em impressora térmica Zebra, "
Private cDesc3 	:= "conforme os parâmetros definidos pelo usuário."
Private cDesc4 	:= ""
Private cDesc5 	:= ""
Private cPerg  	:= Padr("RESTR11A",10)
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


		RptStatus({|lEnd| U_RTR11AImp(@lEnd,mv_par01  )},"Imprimindo, aguarde...")
		
		//RptStatus({|lEnd| U_RESTR3AImp(@lEnd,mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07,mv_par08,mv_par09, .f. )},"Imprimindo, aguarde...")
		
Endif	

Return()

User Function RTR11AImp(lEnd,_cOp)
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

Local nCopias 		:= 1
Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 		:= "0"
Local cFonte1 		:= "020,020"
Local cFonte2 		:= "017,017"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "015,015"
Local cFonte5 		:= "016,016"


    
SetRegua(1)

dbSelectArea("SC2")
dbSetOrder(1)
IF !  dbSeek(xFilial("SC2")+ MV_PAR01) 
	APMsgAlert("Op Nao Localizada")
	Return()
ENDIF

SB1->(dbSetOrder(1))
If SB1->(!dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
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


    



		


//Impressao  dos cosdigos de Barra (Lote e Refrencia
//MSCBBOX(04,40,45,54,3)
MSCBSAYBAR(08,01,Alltrim(SB1->B1_COD),"N","MB07",8,.F.,.T.,.F.,,3,2,.F. ) // ALTERADO CLAUDIO ERA: MSCBSAYBAR(08,40,Alltrim(SB1->B1_CODBAR),"N","MB04",10,.F.,.T.,.F.,,3,2,.F.)
//MSCBSAYBAR(00,02,Alltrim(Upper(SC2->C2_LOTECTL)),"B","MB07",4,.F.,.F.,.F.,,2,2,.F.)


	





		
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
cPerg 			:= PADR("RESTR11A",nTamSX1)

Aadd(aRegs,{cPerg,"01","Ordem de producao ? ","Ordem de producao ?","Ordem de producao ? "	,"mv_ch1","C",TAMSX3("D3_OP")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","",,"",""})
//Aadd(aRegs,{cPerg,"02","Lote ? "             ,"Lote ?","Lote ? "							,"mv_chb","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"03","Peças por Embalagem?","Quantidade ?","Quantidade ? "				,"mv_chc","N",10,2,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"04","Idioma ? "           ,"Idioma ?","Idioma ? "						,"mv_ch4","N",01,0,1,"C","","mv_par04","Portugues","Portugues","Portugues","","","Ingles","Ingles","Ingles","","","Espanhol","Espanhol","Espanhol","","","","","","","","","","","","","","","","",""})
//////Aadd(aRegs,{cPerg,"05","Validade Lote ? "    ,"Validade Lote ?","Validade Lote ? "				,"mv_ch5","C",30,0,0,"G","","mv_par05",,"","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"06","Data Fabricacao ? "  ,"Data Fabricacao ?","Data Fabricacao ? "		,"mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"07","Data Esterilizaçãoo?","Data Esteril. ?","Data Esteril. ? "			,"mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"08","Qtde Rótulos ? ","Quantidade Copias ?","Quantidade Copias ? "		,"mv_ch8","N",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"09","Registro Anvisa ? ","Registro Anvisa ? ","Registro Anvisa ? "		,"mv_ch9","C",45,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

