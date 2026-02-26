/*
Padrao Zebra
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMG04     ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de operador             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img04 // imagem de etiqueta de dispositivo de movimentacao
Local cCodigo
Local nID    := paramixb[1]//Nome,
Local nSenha := paramixb[2]//senha,	
Local cOper  := paramixb[3]//Indentificaçao
//Local cOper  := paramixb[3]//,local de impressão

Local cTpFonte 		:= "0"
Local cFonte1 		:= "028,028"
Local cFonte2 		:= "030,030"
xCol := 03 //Valor da Coluna
yLin := 06 //Valor da Linha

IF nID # NIL
	cCodigo := nID
ElseIf Empty(CB1->CB1_IDETIQ)
	IF UsaCB0("04")
		cCodigo := CBGrvEti('04',{CB1->CB1_CODOPE})
		RecLock("CB1",.F.)
		CB1->CB1_IDETIQ := cCodigo
		MsUnlock()
	Else
		cCodigo := CB1->CB1_CODOPE
	EndIf
Else
	IF UsaCB0("04")
		cCodigo := CB1->CB1_IDETIQ
	Else
		cCodigo := CB1->CB1_CODOPE
	EndIf
Endif
cCodigo := Alltrim(cCodigo)

	//Imprime o padrão 
	MSCBLOADGRF("SIGA.GRF")
	MSCBBEGIN(1,6)

	MSCBBEGIN(1,6)
	//MSCBBEGIN(1,4) 
    MSCBBOX(03,02,95,54,8)  // Box da Borda
	MSCBSAY(xCol+25,   yLin-2,"ETIQUETA DE AUTENTICAÇÃO","N",cTpFonte,cFonte1) 
	MSCBSAY(xCol+39,   yLin+2,"Usuário"					,"N",cTpFonte,cFonte1) 

	MSCBWRITE("^MMT 	") 
	MSCBWRITE("^PW799 	") 
	MSCBWRITE("^LL0400 	") 
	MSCBWRITE("^LS0 	") 
	MSCBWRITE("^FT340,212^BQN,2,5 	") 
	MSCBWRITE("^FDLA,"+AllTrim(cNome)+"^FS	") 
	MSCBLINEH(003,026,095,005,"B") //Linha horizontal
	MSCBSAY(xCol+11,   yLin+21,"Senha"					     ,"N",cTpFonte,cFonte1) 
	//MSCBSAYBAR(xCol+06,yLin+27,AllTrim(cNSenha),"N","MB07"  ,5,.F.,.F.,.F.,,2,4,.F.) 

	MSCBWRITE("^MMT 	") 
	MSCBWRITE("^PW799 	") 
	MSCBWRITE("^LL0400 	") 
	MSCBWRITE("^LS0 	") 
	MSCBWRITE("^FT100,375^BQN,2,5 	") 
	MSCBWRITE("^FDLA,"+AllTrim(nSenha)+"^FS	") 
	
	MSCBSAY(xCol+4,	yLin+42,"OPERADOR(A) : "+Alltrim(Upper(cOper)) 	    ,"N",cTpFonte,cFonte2) 


	MSCBInfoEti("Operador","30X100")
	MSCBEND()

Return .F.
