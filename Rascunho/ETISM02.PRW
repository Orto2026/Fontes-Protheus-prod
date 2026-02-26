#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#include "topconn.ch"
#INCLUDE "rwmake.ch"
#include "TBICONN.CH"
#include "TBICODE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±± Autoanda com Auxilio Dos profissionais da Think Fast     º±±
±±																		                    »±±
±±ºRotina    ³ ETISM02 º Miranda		 º Data ³  26/05/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de Impressao de Etiqueta de Endereço                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ETISM02()

Local cQuery	:=""
LOCAL cString	:= "SC5"
Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo 	:= "Impressão de etiqueta de Controle de Estoque/Clientes."
Private cPerg	:= "ETISM02" 
Private lEnd	:= .F.  
Private nNota	:=""

//AjustaSx1()  // Configuração dos perguntes
// ate aqui

//If ! Pergunte(cPerg,.T.)
//	Return                    
//Endif
 
	RptStatus({|lEnd| ETISM02Imp(@lEnd)},"Imprimindo, aguarde...")
	
Return()



Static Function ETISM02Imp(lEnd,nNota) 

Local cCodUser    	:= RetCodUsr()
Local cNamUser 		:= UsrRetName( cCodUser )//Retorna o nome do us
Local nCopias 		:= "1"
Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 		:= "0" 
Local cFonte1 		:= "020,020"    //oFont08N := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local cFonte2 		:= "017,017"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "015,015" //TFont():New("Times New Roman",15,15,,.T.,,,,.T.,.F.) //"015,015"
Local cFonte5 		:= "028,028"
Local cFonte6 		:= "032,032"
Local cFonte7 		:= "042,042"
Local cFonte8 		:= "048,048"
Local cFonte9 		:= "082,082"  //062 
Local cFonte10 		:= "072,072"
Local cDate  		:= Date()
Local cQuant		:= "1"
Local cQuery 		:= ""



oFont08	 	:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont08N 	:= TFont():New("Arial",28,28,,.T.,,,,.T.,.F.)
oFont10	 	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont11  	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
oFont14	 	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16	 	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont10N 	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont12  	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont12N 	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont16N 	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont14N 	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont06	 	:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont06N 	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.) 
//oFont07  := TFont():New("Times New Roman",06,06,,.T.,,,,.T.,.F.)
//oFont08  := TFont():New("Times New Roman",06,06,,.T.,,,,.T.,.F.)
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
cDataImpressao := cDia+" de "+cMesExt+" de "+cAno
//cDataFechamento := (Dtos(MV_PAR04))     //mv_par04 
//cDataFechamento := (Substr(DtoS(MV_PAR04),7,2)+"/"+Substr(DtoS(MV_PAR04),5,2)+"/"+Substr(DtoS(MV_PAR04),1,4))
//Substr(DtoS(MV_PAR04),7,2)+"/"+Substr(DtoS(MV_PAR04),5,2)+"/"+Substr(DtoS(MV_PAR04),1,4),;
//Substr(DtoS(ENTREGA),7,2)+"/"+Substr(DtoS(ENTREGA),5,2)+"/"+Substr(DtoS(ENTREGA),1,4),;

//oPrn:StartPage()
 
	cQuery	:= "SELECT "+CHR(13)+CHR(10)
	cQuery	+= "C5_FILIAL ,"+CHR(13)+CHR(10)
	cQuery	+= "C5_CLIENTE ,"+CHR(13)+CHR(10)
	cQuery	+= "C5_NUM ,"+CHR(13)+CHR(10)
	cQuery	+= "C5_NOTA ,"+CHR(13)+CHR(10)
	cQuery	+= "C5_EMISSAO ,"+CHR(13)+CHR(10)
	cQuery	+= "C5_LOJACLI ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_FILIAL ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_COD ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_LOJA ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_NREDUZ ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_NOME , "+CHR(13)+CHR(10)	
	cQuery	+= "A1_FILIAL ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_COD ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_ENDENT ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_CODMUNE ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_CEPE ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_BAIRROE ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_CONTATO ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_TRANSP ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_EMAIL ,"+CHR(13)+CHR(10)                          
	cQuery	+= "A1_ESTE ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_NREDUZ ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_NOME ,"+CHR(13)+CHR(10)
	cQuery	+= "A1_LOJA ,"+CHR(13)+CHR(10)
	cQuery	+= "A4_FILIAL ,"+CHR(13)+CHR(10)
	cQuery	+= "A4_COD ,"+CHR(13)+CHR(10)
	cQuery	+= "A4_NOME ,"+CHR(13)+CHR(10)
	cQuery	+= "A4_NREDUZ ,"+CHR(13)+CHR(10)
	cQuery	+= "A4_VIA "+CHR(13)+CHR(10)	
	cQuery 	+= "FROM "+CHR(13)+CHR(10)
  	cQuery 	+=	RetSqlName("SC5 ")+CHR(13)+CHR(10)
  	cQuery	+= "INNER JOIN SA1020 SA1 ON A1_FILIAL='' AND SA1.D_E_L_E_T_='' AND A1_COD=C5_NOTA "+CHR(13)+CHR(10)
	cQuery	+= "INNER JOIN SA4020 SA4 ON A4_FILIAL='' AND SA4.D_E_L_E_T_='' AND A1_TRANSP= A4_COD "+CHR(13)+CHR(10)
	cQuery 	+= "WHERE"+CHR(13)+CHR(10)
	cQuery 	+= "C5_NOTA ='35231248240709000190550010002965021882918479' "//  "+nNota+""+CHR(13)+CHR(10)
  	cQuery 	:= ChangeQuery(cQuery) 
	
	MEMOWRIT( "ETISM02.SQL", cQuery ) 
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery  ), "QRY", .T., .T. )

	//If Select("QRY") > 0
	// 	Dbselectarea("QRY")
	//  	QRY->(DbClosearea())  
	//EndIf

	//TcQuery cQuery New Alias "QRY"   //	DbGotop()
	    
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
	    //Exit
	Endif
	// Fim da Rotina para verificação de itens na query do SQL SERVER
SetRegua(1)  

IncRegua() 
DbSelectArea("QRY")
DbGoTop() 

   //	While EOF() //.AND. PED_CODCLI == CAD_COD 
		MSCBPRINTER(cImpressora,cPorta)	 
		MSCBCHKSTATUS(.F.) 
		cCliente :=	cNamUser 
		MSCBBEGIN(nCopias,4) 
	         
	 	MSCBBOX(03,03,100,55,3,"B")
		MSCBBOX(03,03,100,55,3,"B")
		//MSCBLineH(03,51,97,3,"B")
		//MSCBSAY(25,05,"Ortosintese Ind e Com Ltda"		,"N",cTpFonte,cFonte8)//Nome da Enpresa	
		//MSCBBOX(03,03,24,18,3) // CAIXA DO LOGOTIPO 
		//MSCBBOX(03,03,100,18,3)
		
		MSCBSAY(04,04,"DESTINATARIO"				  					,"N",cTpFonte,cFonte3)//Rotulo do Nome do Cliente	
		MSCBSAY(04,07,Alltrim(A1_NREDUZ)			     				,"N",cTpFonte,cFonte8)//Nome do Cliente	 
		
		MSCBSAY(75,04,"NOTA FISCAL"					 				,"N",cTpFonte,cFonte3)//Rotulo do Nome do Cliente	
	   MSCBSAY(75,07,Alltrim(C5_NOTA)				  				,"N",cTpFonte,cFonte8)//Nome do Cliente	
		
		MSCBSAY(04,13,"ENDERECO DE ENTREGA"							,"N",cTpFonte,cFonte3)//Rotulo do Nome do Cliente	
		MSCBSAY(04,16,"FLORIANO FLO"+Alltrim(A1_ENDENT)			,"N",cTpFonte,cFonte6)//Nome do Cliente	
		      
		MSCBLineH(03,12,100,2)// Linha na horizontal
		
	   MSCBSAY(50,20,"BAIRRO"	    					   ,"N",cTpFonte,cFonte3)//Numeros do Pedido
		MSCBSAY(50,23,Alltrim(A1_BAIRROE)	    		,"N",cTpFonte,cFonte6)//Numeros do Pedido
	   	//MSCBSAY(05,20,"XXXXXXXXXXXXXXXXXXXX"	    	,"N",cTpFonte,cFonte6)//Numeros do Pedido
		
		MSCBSAY(40,27,"CIDADE"	    						,"N",cTpFonte,cFonte3)//Numeros do Pedido
		MSCBSAY(40,30,"XXXXXXXXXXXXXXX" 	    			,"N",cTpFonte,cFonte6)//Numeros do Pedido
			   
		MSCBSAY(04,27,"CEP"									,"N",cTpFonte,cFonte3)  
		MSCBSAY(04,30,"02993-040"				  			,"N",cTpFonte,cFonte6)//Numeros do Pedido	 
		//MSCBSAY(05,37,Alltrim(A1_CEPE)					,"N",cTpFonte,cFonte6)//Numeros do Pedido 
	  	       
	  	//MSCBLineH(04,34,100,2)// Linha na horizontal
	   MSCBSAY(40,35,"TRANPORTADORA"						,"N",cTpFonte,cFonte3)  
		MSCBSAY(40,38,Alltrim(A4_NREDUZ)					,"N",cTpFonte,cFonte8)//Numeros do Pedido
	  	//MSCBLineH(04,45,100,2)// Linha na horizontal
	  	  
	  	                                          
		MSCBSAY(04,47,"USUARIO"								,"N",cTpFonte,cFonte3)//Rotulo do Nome d Usuario 
		MSCBSAY(04,50,(Transform(cNamUser,"@!"))		,"N",cTpFonte,cFonte6)//Nome d Usuario
		
		//MSCBSAY(25,50,"   " +dToc(dDataBase)			,"N",cTpFonte,cFonte6)//Data base do Sistema
		MSCBSAY(25,50,""+(cDataImpressao)				,"N",cTpFonte,cFonte6) 
		//MSCBSAY(25,50,"   "	+Time()						,"N",cTpFonte,cFonte6)//Hora do Sistema  
	   MSCBLineV(65,45,55,2)// Linha na Vertical  
	   
		//if !empty(mv_par02)
			//MSCBSAY(67,46,"VOLUME "					  	,"N",cTpFonte,cFonte3)
		   //MSCBSAY(80,48,Alltrim(mv_par02)				,"N",cTpFonte,cFonte8)//E o Numero da Caixa 														   
		//end if
		//For k := 1 To MV_PAR02
		//next k			
 //	Enddo
MSCBEND()                                                                                         //(Transform(TOTAL,"@E 9999.99"))
MSCBCLOSEPRINTER()	
MS_FLUSH() 
Return

Static Function AjustaSX1()
Local aArea := GetArea()
//Local aHelpPor	:= {}
//Local aHelpEng	:= {}
//Local aHelpSpa	:= {}                                                                                                                             // 1   2   3   4  5   6   7   8   9   10   11  12  13  14
PutSx1(cPerg,"01","Numero do Pedido ?","Numero do Pedido ? ","Numeo do Pedido ? ","mv_cha","C",10,0,0,"G","","","","","mv_par01",;
" "," "," ",""," "," "," "," "," "," ", " "," "," "," "," "," ",{"Informe numero do Pedido!"},{"Informe o numero do Pedido!"},{"Informe o Numero do Pedid!"})
//PutSx1(cPerg,"01","Numero do Pedido ? ","Numeo do Pedido ?","Numeo do Pedido ? ","mv_cha","C",10,0,0,"G","","","","","mv_par01",;
//"","","","","","","","","","","","","","","","","","","","",{"Informe o Numero do Pedido!"},{"Informe o Numero do Pedido!"},{"Informe o Numero do Pedido!"},"","")
//PutSX1Help("P.ETISM02.",aHelpPor,aHelpEng,aHelpSpa)  
//aHelpPor	:= {}
//aHelpEng	:= {}
//aHelpSpa	:= {}
//Help muv par 01   
//Aadd( aHelpPor, "Informe o Numero do Pedido.			 " )
//Aadd( aHelpPor, "Informe o Numero do Pedido.			 " )
//Aadd( aHelpEng, "Informe o Numero do Pedido.        	 " )
//Aadd( aHelpEng, "Informe o Numero do Pedido.             " )
//Aadd( aHelpSpa, "Informe o Numero do Pedido.       		 " )
//Aadd( aHelpSpa, "Informe o Numero do Pedido.             " )  
 
//aHelpPor	:= {}
//aHelpEng	:= {}
//aHelpSpa	:= {}
//Help muv par 02
//Aadd( aHelpPor, "Informe a Quantidade de Copias.         " )
//Aadd( aHelpPor, "                                        " )
//Aadd( aHelpEng, "Informe a Quantidade de Copias.         " )
//Aadd( aHelpEng, "                                        " )
//Aadd( aHelpSpa, "Informe a Quantidade de Copias.         " )
//Aadd( aHelpSpa, "                                        " ) 
PutSx1(cPerg,"02","Quantidade Copias ? ","Quantidade Copias ?","Quantidade Copias ? ","mv_che","N",10,0,0,"G","","","","","mv_par03",;
"","","","","","","","","","","","","","","","","","","","","","",{"Informe a Quantidade de Copias"},{"Informe a Quantidade de Copias"},{"Informe a Quantidade de Copias"},"","")
//PutSX1Help("P.ETISM02.",aHelpPor,aHelpEng,aHelpSpa)  
//PutSx1(cPerg,"02","Quantidade de Caixas ? ","Quantidade de Caixas ? ","Quantidade de Caixas ? ","mv_chd","C",05,0,0,"G","","","","","mv_par02",;
//"","","","","","","","","","","","","","","","","","","","","","","","","")
//PutSX1Help("P.ETISM02.",aHelpPor,aHelpEng,aHelpSpa)  
RestArea(aArea)
Return

Return
