#Include "Protheus.Ch"
#Include "rwmake.Ch"
#INCLUDE "TOPCONN.CH"  
/*/

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Funçção    ³ RESTAUT  ³ Autor ³Samuel Miranda  ³ Data ³ 27/12/2022  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³ Rotina de Impressao de Etiqueta atraves  da OP            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Uso      ³                                                ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/


User Function RESTRAUT()

Private cNome    	:= Space(20)
Private cNSenha  	:= Space(20)
Private cNomeUser 	:= Space(20)

Private oDlg1, oNome, oNSenha,oNomeUser

	DEFINE MSDIALOG oDlg1 TITLE "Impressão de Etiquetas" FROM 200,70 TO 430,550 PIXEL   
	@ 3,4 To 105,240   //Contorno     

	oFont6An	:= TFont():New("Arial",,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14An	:= TFont():New("Arial",,14,.T.,.T.,5,.T.,5,.T.,.F.)

	//Usando o método New
	oSay1:= TSay():New(010,060,{||'IMPRESSÃO DE ETIQUETA DE AUTENTICAÇÃO'},oDlg1,,oFont14An,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
	oSay1:= TSay():New(020,030,{||'OBs.: Não colocar na senha Caracteres Especiais Exemplo: @ % $'},oDlg1,,oFont14An,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	
    //Label 
    oSay1:= TSay():New(030,030,{||'Usuário'},oDlg1,,oFont14An,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    @ 040,030  MSGET oNome	  VAR cNome	  SIZE 80,7 OF oDlg1 PIXEL
    
    //Label 
    oSay1:= TSay():New(030,130,{||'Senha'},oDlg1,,oFont14An,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    //@ 050,130  MSGET oNSenha  VAR cNSenha SIZE 85,7 OF oDlg1 PIXEL
    @ 040,130 MSGET oNSenha VAR cNSenha Size 85,7  Password OF oDlg1 PIXEL

    oSay1:= TSay():New(055,050,{||'Indentificação'},oDlg1,,oFont14An,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    @ 065,050  MSGET oNomeUser  VAR cNomeUser SIZE 130,7 OF oDlg1 PIXEL
		
	@ 085,050 Button oOK  	Prompt "Imprimir" Size 35,13 Action RESTIMP(cNome,cNSenha,cNomeUser) OF oDlg1 PIXEL
	@ 085,150 Button oSair  Prompt "Sair" Size 35,13 Action Close(oDlg1) OF oDlg1 PIXEL
	//Label 
	oSay1:= TSay():New(108,200,{||'By | TI Ortosintese'},oDlg1,,oFont6An,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)

	ACTIVATE MSDIALOG oDlg1 CENTERED
    
	DlgRefresh(oDlg1)
Return 


Static Function RESTIMP(cNome,cNSenha,cNomeUser)

Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 		:= "0"
Local cFonte1 		:= "028,028"
Local cFonte2 		:= "030,030"
//Local cFonte2 		:= "035,035"
xCol := 04 //Valor da Coluna
yLin := 06 //Valor da Linha
 
MSCBPRINTER(cImpressora,cPorta)	 
MSCBCHKStatus(.F.)
	MSCBBEGIN(1,4) 
    MSCBBOX(05,02,90,54,8)  // Box da Borda
    
	MSCBSAY(xCol+25,   yLin-2,"ETIQUETA DE AUTENTICAÇÃO","N",cTpFonte,cFonte1) 
	MSCBSAY(xCol+38,   yLin+4,"Usuário"					,"N",cTpFonte,cFonte1) 
    MSCBSAYBAR(xCol+30,yLin+8,AllTrim(cNome),"N","MB07",5,.F.,.F.,.F.,,2,2,.F.)	
	
	MSCBLINEH(005,025,090,008,"B") //Linha horizontal

	MSCBSAY(xCol+38,   yLin+23,"Senha"						,"N",cTpFonte,cFonte1) 
	MSCBSAYBAR(xCol+30,yLin+27,AllTrim(cNSenha),"I","MB07"  ,5,.F.,.F.,.F.,,2,2,.F.) 
	
	MSCBSAY(xCol+4,	yLin+42,Alltrim(Upper(cNomeUser)) 	    ,"N",cTpFonte,cFonte2) 
MSCBEND() 
MSCBCLOSEPRINTER()	
MS_FLUSH()             

//Refresh(oDlg1)
Close(oDlg1)  //oDlg:Refresh()
//oDlg1:Refresh()
Return()
