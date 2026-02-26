#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ETISM01  ³ Autor ³ Sameul Miranda		  ³ Data ³ 20/04/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de etiquetas de Enderecos de entrega de clientes ³±±
±±³          ³ 																           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Obs:      ³Tive o auxilio do Mauricio Prado para a finalizacao da mesma³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/              
User Function ETISM01()


Local cQuery	:=""
LOCAL cString	:= "SC5"
Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo 	:= "Impressão de etiqueta de Controle de Estoque/Clientes."
Private cPerg	:= "ETISM01" 
Private lEnd	:= .F.  

AjustaSx1()  // Configuração dos perguntes
// ate aqui

If ! Pergunte(cPerg,.T.)
	Return                    
Endif
      
	RptStatus({|lEnd| ETISM01Imp(@lEnd)},"Imprimindo, aguarde...")
	
Return()

Static Function ETISM01Imp(lEnd)

//PRIVATE cTitulo := "Impressão do Pedido de Vendas"
//PRIVATE oPrn    := NIL 
Local cCodUser 		:= RetCodUsr()
Local cNamUser 		:= UsrRetName( cCodUser )//Retorna o nome do us
Local nCopias 	  		:= mv_par02
Local cImpressora 	:= "ZEBRA"
Local cPorta 			:= "LPT1"
Local cTpFonte 		:= "0" 
Local cFonte1 			:= "020,020"    //oFont08N := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local cFonte2 			:= "017,017"
Local cFonte3 	  		:= "024,024"
Local cFonte4 			:= "015,015" //TFont():New("Times New Roman",15,15,,.T.,,,,.T.,.F.) //"015,015"
Local cFonte5 	 		:= "028,028"
Local cFonte6 	 		:= "032,032"
Local cFonte7 	 		:= "042,042"
Local cFonte8 	 		:= "048,048"
Local cFonte9 	 		:= "082,082"  //062 
Local cFonte10  		:= "072,072"
Local cDate  	  		:= Date()
Local cQuant	  		:= mv_par02

Local oFont1  := NIL
Local oFont2  := NIL
Local oFont3  := NIL
Local oFont4  := NIL
Local oFont5  := NIL
Local oFont6  := NIL


//DEFINE FONT oFont1 NAME "Times New Roman" SIZE 0,20 BOLD  OF oPrn
//DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,14 BOLD OF oPrn
//DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,14 OF oPrn
//DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,14 ITALIC OF oPrn
//DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,14 OF oPrn
//DEFINE FONT oFont6 NAME "Courier New" BOLD

oFont08	 := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont08N := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
oFont10	 := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont11  := TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
oFont14	 := TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16	 := TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont10N := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont12  := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont12N := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont16N := TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont14N := TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont06	 := TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont06N := TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela de Entrada de Dados - Parametros                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//STATIC FUNCTION Imprimir()
//Orcamento()
//Ms_Flush()
//Return

//STATIC FUNCTION Orcamento()
cDia := SubStr(DtoS(dDataBase),7,2)
cMes := SubStr(DtoS(dDataBase),5,2)
cAno := SubStr(DtoS(dDataBase),1,4)
cMesExt := MesExtenso(Month(dDataBase))  //Muda para dDataBase para obter data do sistema
cDataImpressao := cDia+" DE "+cMesExt+" DE "+cAno
//cDataFechamento := (Dtos(MV_PAR04))     //mv_par04 
//cDataFechamento := (Substr(DtoS(MV_PAR04),7,2)+"/"+Substr(DtoS(MV_PAR04),5,2)+"/"+Substr(DtoS(MV_PAR04),1,4))
	//Substr(DtoS(MV_PAR04),7,2)+"/"+Substr(DtoS(MV_PAR04),5,2)+"/"+Substr(DtoS(MV_PAR04),1,4),;
	//Substr(DtoS(ENTREGA),7,2)+"/"+Substr(DtoS(ENTREGA),5,2)+"/"+Substr(DtoS(ENTREGA),1,4),;

//oPrn:StartPage()
 
	//cQuery		:= "SELECT "+CHR(13)+CHR(10)
	cQuery		:= "SELECT F2_DOC,A1_NREDUZ,A1_ENDENT,A1_CEPE,A1_BAIRROE,A1_MUNE,A1_ESTE,A4_NOME "+CHR(13)+CHR(10)
	cQuery 		+= "FROM "+CHR(13)+CHR(10)
	cQuery 		+=	RetSqlName('SF2010') + " SF2 " +CHR(13)+CHR(10)
	cQuery		+= "INNER JOIN SA1010 SA1 ON A1_FILIAL ='' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA "+CHR(13)+CHR(10)
	cQuery		+= "INNER JOIN SA4010 SA4 ON A4_FILIAL=' ' AND A4_COD = F2_TRANSP" +CHR(13)+CHR(10)
	cQuery 		+= "WHERE SF2.F2_FILIAL ='01' AND " +CHR(13)+CHR(10)
	cQuery		+= "SF2.D_E_L_E_T_ ='' AND "+CHR(13)+CHR(10)
	cQuery		+= "SA4.D_E_L_E_T_ ='' AND "+CHR(13)+CHR(10)
   cQuery 		+= "SF2.F2_CHVNFE = '"+MV_PAR01+"'"+CHR(13)+CHR(10) 
	  
  	cQuery 		:= ChangeQuery(cQuery) 
	
	MEMOWRIT( "ETISM01.SQL", cQuery ) 

	If Select("QRY") > 0
	 	Dbselectarea("QRY")
	  	QRY->(DbClosearea())  
	EndIf
	TcQuery cQuery New Alias "QRY"   //	DbGotop()
	    
    // Rotina para verificação de itens na query do SQL SERVER
	nRec	:= 0
	dbSelectArea( "QRY" )
	dbGotop()
	QRY->(dbEval({ || nRec++ },,{||!Eof()} ))
	dbGoTop() 
	
	If nRec == 0
		dbSelectArea("QRY")
		dbCloseArea()
		Alert("A sua consulta não contem itens." ,"Verifique !")
	    Return()
	    //exit()
	Endif
	// Fim da Rotina para verificação de itens na query do SQL SERVER
SetRegua(1)  

IncRegua() 
DbSelectArea("QRY")
DbGoTop() 	  	
   		//MSCBBEGIN(nCopias,4) //	While EOF() //.AND. PED_CODCLI == CAD_COD 
	   
		MSCBPRINTER(cImpressora,cPorta)	 
		MSCBCHKSTATUS(.F.)
		
		MSCBLOADGRAF("LOGO1.GRF") 	 
		cCliente :=	cNamUser 
				
		MSCBBEGIN(nCopias,4)    	 	    
	    MSCBGRAFIC(03,04,"LOGO1")      	
	 	MSCBBOX(03,03,100,55,3)
		MSCBBOX(03,03,100,55,3)
		
		MSCBSAY(21,04,"Ortosintese Ind e Com Ltda"								,"N",cTpFonte,cFonte8)//Nome da Enpresa
		MSCBSAY(21,09,"Rua Prof. Affonso Jose Fioravante,63 City Empresarial"	,"N",cTpFonte,cFonte5)//Nome da Enpresa
		MSCBSAY(21,13,"Jaragua - CEP 02998-010 São Paulo - SP"					,"N",cTpFonte,cFonte5)//Nome da Enpresa
		MSCBSAY(21,17,"Fone:(0xx11)3948-4000 - Fax:(0xx11)3948-4010"	  		,"N",cTpFonte,cFonte5)//Nome da Enpresa		
		MSCBBOX(03,03,20,21,3) // CAIXA DO LOGOTIPO 
	   	MSCBBOX(03,03,100,21,3)
		
		MSCBSAY(04,22,"DESTINATARIO"					,"N",cTpFonte,cFonte3)//Rotulo do Nome do Cliente	
		MSCBSAY(04,25,Alltrim(A1_NREDUZ)				,"N",cTpFonte,cFonte6)//Nome do Cliente	 
		
		MSCBSAY(75,22,"NOTA FISCAL"						,"N",cTpFonte,cFonte3)//Rotulo do Nome do Cliente	
		MSCBSAY(75,25,Alltrim(F2_DOC)					,"N",cTpFonte,cFonte7)//Nome do Cliente	
		
		MSCBSAY(04,29,"ENDERECO DE ENTREGA"				,"N",cTpFonte,cFonte3)//Rotulo do Nome do Cliente	
		MSCBSAY(04,32,Alltrim(A1_ENDENT)				,"N",cTpFonte,cFonte6)//Nome do Cliente	
	   
		MSCBSAY(04,43,"CEP"								,"N",cTpFonte,cFonte3) //Rotulo CEP 
		MSCBSAY(04,46,Alltrim(A1_CEPE)		  		,"N",cTpFonte,cFonte6)//Numeros do CEP DO LOCLA DE ENTRAGA 
		//MSCBSAY(05,37,Alltrim(A1_CEPE)					,"N",cTpFonte,cFonte6)//Numeros do Pedido 
	    
	 	MSCBSAY(30,43,"TRANSPORTADORA"					,"N",cTpFonte,cFonte3)//Rotulo da Transportadora 
		MSCBSAY(30,46,Alltrim(A4_NOME)   				,"N",cTpFonte,cFonte6)//Nome da transportadora
		
		MSCBSAY(04,36,"BAIRRO"	    			   		,"N",cTpFonte,cFonte3)//Rotulo
		MSCBSAY(04,39,Alltrim(A1_BAIRROE)	    		,"N",cTpFonte,cFonte6)//Bairro de Entrega
	   	//MSCBSAY(04,39,"XXXXXXXXXXXXXXXXXXXX"	    		,"N",cTpFonte,cFonte6)//Numeros do Pedido
	    	   
		MSCBSAY(53,36,"CIDADE"	    					,"N",cTpFonte,cFonte3)//Rotulo
		MSCBSAY(53,39,Alltrim(A1_MUNE)	    		,"N",cTpFonte,cFonte6)//Municipio de entrga
		
		MSCBSAY(94,36,"UF"	    						,"N",cTpFonte,cFonte3)//rotulo 
		MSCBSAY(94,39,Alltrim(A1_ESTE)	   		,"N",cTpFonte,cFonte6)//Estado de estrega
				   	                                          
		//MSCBSAY(04,50,"USUARIO"							,"N",cTpFonte,cFonte5)//Rotulo do Nome d Usuario 
		MSCBSAY(04,51,"USUARIO  : "+(Transform(cNamUser,"@!"))		,"N",cTpFonte,cFonte5)//Nome d Usuario
		
		MSCBSAY(50,51,"   " +dToc(dDataBase)			,"N",cTpFonte,cFonte6)//Data base do Sistema 
		//MSCBSAY(25,50,"   "	+Time()						,"N",cTpFonte,cFonte6)//Hora do Sistema  
	        
	        //if !empty(nCopias)   
		    //for i = 1 to cQuant
			//MSCBSAY(85,43,"VOLUME "					  	,"N",cTpFonte,cFonte3)
		    //MSCBSAY(85,47," 1 / "+(int(i))	   			,"N",cTpFonte,cFonte7)//E o Numero da Caixa 														   
	   	    //Next i	
	        //end if 
 //	Enddo
MSCBEND()  
MSCBCLOSEPRINTER()	
MS_FLUSH() 
Return
Static Function AjustaSX1()

Local aArea := GetArea()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}  

// Aqui as Perguntas
PutSx1(cPerg,"01","Numero da NF ?    ","Numero da NF ?   ","Numero da NF ?    ","mv_cha","C",44,0,0,"G","","","","","mv_par01",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.ETISM01.",aHelpPor,aHelpEng,aHelpSpa) 

//PutSx1(cPerg,"02","Quantidade de Caixas ? ","Quantidade de Caixas ? ","Quantidade de Caixas ? ","mv_chd","C",05,0,0,"G","","","","","mv_par02",;
//"","","","","","","","","","","","","","","","","","","","","","","","","")
//PutSX1Help("P.ETISM01.",aHelpPor,aHelpEng,aHelpSpa)
 
PutSx1(cPerg,"02","Quantidade de Copias ? ","Quantidade de Copias ?","Quantidade de Copias ? ","mv_che","N",10,0,0,"G","","","","","mv_par02",;
"","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1Help("P.ETISM01.",aHelpPor,aHelpEng,aHelpSpa)

 
// Help do mov Par 01  
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
    
Aadd( aHelpPor, "Informe o Numero do Pedido.			 " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "Informe o Numero do Pedido.        	 " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "Informe o Numero do Pedido.       		" )
Aadd( aHelpSpa, "                                        " )


// Help do mov Par 02 
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}  

Aadd( aHelpPor, "Informe a Quantidade de Caixas.		 " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "Informe a Quantidade de Caixas.         " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "Informe a Quantidade de Caixas.         " )
Aadd( aHelpSpa, "                                        " )


// Help do mov Par 03
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a Quantidade de Copias.         " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "Informe a Quantidade de Copias.         " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "Informe a Quantidade de Copias.         " )
Aadd( aHelpSpa, "                                        " )



RestArea(aArea)
Return

Return