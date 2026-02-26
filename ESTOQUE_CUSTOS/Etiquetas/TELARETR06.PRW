#Include "Protheus.Ch"
#Include "rwmake.Ch"
#INCLUDE "TOPCONN.CH"  
/*/

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ TELARETR06  ³ Autor ³Samuel Miranda  ³ Data ³ 29/04/2021  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³ Rotina de Impressao de Etiqueta atraves  da OP            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

User Function TELARETR06()
Private lRet     := .T.
Private _Itens   := {}
Private cCodUser := RetCodUsr()
Private cNamUser := UsrRetName(cCodUser) //Retorna o nome do us
Private oDlg1, _cLote,oDocP,oDescProd,oAmzPD, oLote,oDatEnd,oQtde, oQtdCopy, oSair
Private cPerg    := "TELARETR06"

ValidPerg()

If !Pergunte(cPerg,.T.)
	Return()
Endif
//Chama a Função para a consulta no banco de dados.
ValidDoc(_Itens) 

If lRet = .T.

	_cDocOP   := (_Itens[1,1])	//Space(LEN(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
	_nProd	  := (_Itens[1,2])
	_cDesc    := Posicione("SB1",1,xFilial("SB1")+_nProd,"B1_DESC")
	_cUM      := Posicione("SB1",1,xFilial("SB1")+_nProd,"B1_UM")
	_cAmzP    := (_Itens[1,3])
	_cLote    := (_Itens[1,4])
	_cEndereco:= (_Itens[1,5])
	_nQtdEnd  := (_Itens[1,6])
	_dDtEnd   := (STOD(_Itens[1,7]))
	_nCopy	  := 1
	//aadd(_Itens,{NDOC,PRODUTO,AMZP,NLOTE,ENDERECO,QTDEND,DATAEND})
			//      1     2      3     4       5      6      7
	DEFINE MSDIALOG oDlg1 TITLE "Impressão de Etiquetas" FROM 200,70 TO 430,550 PIXEL   
	@ 3,4 To 105,240   //Contorno     

	oFont6An	:= TFont():New("Arial",,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14An	:= TFont():New("Arial",,14,.T.,.T.,5,.T.,5,.T.,.F.)

	//Usando o método New
	oSay1 := TSay():New(010, 010, {|| 'DOCUMENTO:' }    , oDlg1, , oFont14An, , , , .T., CLR_BLACK, CLR_WHITE, 200, 20)
	oSay1 := TSay():New(010, 130, {|| 'PRODUTO:' }      , oDlg1, , oFont14An, , , , .T., CLR_BLACK, CLR_WHITE, 200, 20)
	oSay1 := TSay():New(025, 010, {|| 'LOTE:' }         , oDlg1, , oFont14An, , , , .T., CLR_BLACK, CLR_WHITE, 200, 20)
	oSay1 := TSay():New(025, 130, {|| 'ARMZ. PADRÃO:' } , oDlg1, , oFont14An, , , , .T., CLR_BLACK, CLR_WHITE, 200, 20)
	oSay1 := TSay():New(040, 010, {|| 'DESCRIÇÃO:' }    , oDlg1, , oFont14An, , , , .T., CLR_BLACK, CLR_WHITE, 200, 20)
	oSay1 := TSay():New(055, 010, {|| 'ENDEREÇAMENTO:' }, oDlg1, , oFont14An, , , , .T., CLR_BLACK, CLR_WHITE, 200, 20)
	oSay1 := TSay():New(055, 130, {|| 'QUANTIDADE:' }   , oDlg1, , oFont14An, , , , .T., CLR_BLACK, CLR_WHITE, 200, 20)
	oSay1 := TSay():New(070, 010, {|| 'COPIAS:' }       , oDlg1, , oFont14An, , , , .T., CLR_BLACK, CLR_WHITE, 200, 20)

	//Pegando os valores das variaveis
	oSay1 := TSay():New(010, 060, {||_cDocOP} , oDlg1, , oFont14An, , , , .T., CLR_RED  , CLR_WHITE, 200, 20)
	oSay1 := TSay():New(010, 180, {||_nProd}  , oDlg1, , oFont14An, , , , .T., CLR_RED  , CLR_WHITE, 200, 20)
	oSay1 := TSay():New(025, 060, {||_cLote}  , oDlg1, , oFont14An, , , , .T., CLR_RED  , CLR_WHITE, 200, 20)
	oSay1 := TSay():New(025, 180, {||_cAmzP}  , oDlg1, , oFont14An, , , , .T., CLR_RED  , CLR_WHITE, 200, 20)
	oSay1 := TSay():New(040, 060, {||_cDesc}  , oDlg1, , oFont14An, , , , .T., CLR_RED  , CLR_WHITE, 200, 20)
	oSay1 := TSay():New(055, 060, {||_dDtEnd} , oDlg1, , oFont14An, , , , .T., CLR_RED  , CLR_WHITE, 200, 20)
	oSay1 := TSay():New(055, 180, {||_nQtdEnd}, oDlg1, , oFont14An, , , , .T., CLR_RED  , CLR_WHITE, 200, 20)
	oSay1 := TSay():New(055, 200, {||_cUM}    , oDlg1, , oFont14An, , , , .T., CLR_RED  , CLR_WHITE, 200, 20)
	oSay1 := TSay():New(070, 060, {||MV_PAR02}, oDlg1, , oFont14An, , , , .T., CLR_BLACK, CLR_WHITE, 200, 20)
	
	@ 080,050 Button oOK  	Prompt "Imprimir" Size 25,13 Action Rest06(_nProd,_cLote,_cAmzP,_dDtEnd,_nQtdEnd,MV_PAR02) OF oDlg1 PIXEL
	@ 080,150 Button oSair  	Prompt "Sair" Size 25,13 Action Close(oDlg1) OF oDlg1 PIXEL

	oSay1:= TSay():New(108,200,{||'By | TI Ortosintese'},oDlg1,,oFont6An,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)

	ACTIVATE MSDIALOG oDlg1 CENTERED

	DlgRefresh(oDlg1)
Else
	Return()
EndIf
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º  Funcao  ³ ValidDoc  ºAutor  Samuel Miranda      º Data ³  29/04/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz a consulta no banco para obiter                       º±±
±±º          ³ as informaçoes a serem impressa                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function ValidDoc(_cDoc)
Local cQuery := ""
Local nRec   := 0

cQuery := "SELECT "+ CHR(13)+CHR(10)
cQuery	+="SDB.DB_DOC AS NDOC,"+ CHR(13)+CHR(10)
cQuery	+="SDB.DB_PRODUTO AS PRODUTO,"+ CHR(13)+CHR(10)
cQuery	+="SDB.DB_LOCAL AS AMZP,"+ CHR(13)+CHR(10)
cQuery	+="SDB.DB_LOCALIZ AS ENDERECO,"+ CHR(13)+CHR(10)
cQuery	+="SDB.DB_DOC AS DOCUMENTO,"+ CHR(13)+CHR(10)
cQuery	+="SDB.DB_QUANT AS QTDEND,"+ CHR(13)+CHR(10)
cQuery	+="SDB.DB_DATA AS DATAEND,"+ CHR(13)+CHR(10)
cQuery	+="SDB.DB_LOTECTL AS NLOTE "+ CHR(13)+CHR(10)
cQuery	+="FROM "+ CHR(13)+CHR(10)
cQuery	+= RetSqlName("SDB")+ " SDB"+ CHR(13)+CHR(10)
cQuery	+="WHERE "+ CHR(13)+CHR(10)
cQuery	+="SDB.DB_DOC='"+MV_PAR01+"' AND "+ CHR(13)+CHR(10)
cQuery	+="SDB.D_E_L_E_T_='' "+ CHR(13)+CHR(10)
cQuery	+="AND SDB.DB_ESTORNO=''"+ CHR(13)+CHR(10)
cQuery := ChangeQuery(cQuery)

MemoWrite("TELARETRO6.SQL", cQuery )
	
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery  ), "QRY", .T., .T. )

dbSelectArea("QRY")
dbGoTop()
QRY->(dbEval({ || nRec++ },,{||!Eof()} ))
dbGoTop()

If nRec == 0
	dbSelectArea("QRY")
	dbCloseArea()
	MsgAlert("Nenhum documento encontrado.","Verifique os Parâmetros")
	//Alert("Nenhum documento encontrado.","Verifique os parâmetros")
	lRet = .F.
	Return()
	//MSGALERT( <cTexto>, <cTitulo> )
EndIf          

While !QRY->(Eof())

	aadd(_Itens,{NDOC,PRODUTO,AMZP,NLOTE,ENDERECO,QTDEND,DATAEND})

QRY->(DbSkip())
EndDo

Return(_Itens)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º  Funcao  ³ Rest06   ºAutor  ³Samuel Miranda      º Data ³  29/04/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa a Impressao da Etiqueta                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Rest06(_nProd,_cLote,_cAmzP,_dDtEnd,_nQtdEnd,MV_PAR02)
						//(_nProd,_cLote,_cAmzP,_dDtEnd,_nQtdEnd,MV_PAR02)

Local nCopias 		:= MV_PAR02 //Número de cópias 
Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 		:= "0"
//Local cFonte1 		:= "020,020"
//Local cFonte2 		:= "017,017"
//Local cFonte3 		:= "024,024"
//Local cFonte4 		:= "015,015"
Local cFonte5 		:= "026,026"
Local cFonte6 		:= "028,028"

Private cCodUser    	:= RetCodUsr()
Private cNamUser 		:= UsrRetName( cCodUser )//Retorna o nome do us

xCol := 04 //Valor da Coluna
yLin := 04 //Valor da Linha

//SetRegua(1)
SB1->(dbSetOrder(1))
If SB1->(!dbSeek(xFilial("SB1")+_nProd))
	APMsgAlert("Produto não localizado no cadastro, verifique.")
	Return()
Endif
//IncRegua()

MSCBPRINTER(cImpressora,cPorta)
MSCBCHKStatus(.F.)
MSCBLOADGRAF("ORTO.GRF")
MSCBBEGIN(nCopias,4)

	MSCBBOX(xCol-2,yLin,90,53,5)  // Box da Borda
	MSCBGRAFIC(xCol,yLin+1,"ORTO")
	MSCBSAY(xCol+16,yLin+2,"ETIQUETA DE IDENTIFICACAO DE PRODUTOS"					,"N",cTpFonte,cFonte6)
	
	If SB1->B1_TIPO =="PA"
		MSCBSAY(xCol+29,yLin+6,"( PA ) PRODUTO ACABADO"							  	,"N",cTpFonte,cFonte6)
		Else
		MSCBSAY(xCol+29,yLin+6,"( SA ) SEMI-ACABADO"							  	,"N",cTpFonte,cFonte6)
	EndIf
	MSCBLINEH(xCol-2,yLin+10,90,2,"B") //horizontal
	MSCBSAY(xCol-1, yLin+11	,"PRODUTO: "  +Alltrim(_nProd)							,"N",cTpFonte,cFonte5)
	MSCBSAY(xCol+46,yLin+11	,"LOTE: "	  +Alltrim(Upper(_cLote))					,"N",cTpFonte,cFonte5)
	MSCBSAY(xCol-1, yLin+16	,"DESCRICAO: "+Alltrim(Substr(SB1->B1_DESC,1,35))		,"N",cTpFonte,cFonte5)
	MSCBSAY(xCol,   yLin+20	,Alltrim(Substr(SB1->B1_DESC,36,70))		   			,"N",cTpFonte,cFonte5)
	MSCBSAY(xCol-1, yLin+24	,"ARM: "	 +Alltrim(_cAmzP)							,"N",cTpFonte,cFonte5)// Por samuel Miranda 18/04/2021
	MSCBSAY(xCol+18,yLin+24	,"QUANT: "	 +alltrim(CVALTOCHAR(_nQtdEnd))+" "+Alltrim(SB1->B1_UM)	,"N",cTpFonte,cFonte5)
	MSCBSAY(xCol+47,yLin+24	,+time()												,"N",cTpFonte,cFonte5)
	MSCBSAY(xCol+47,yLin+29	,+Alltrim(Upper(cNamUser))								,"N",cTpFonte,cFonte5)											
	MSCBSAY(xCol-1, yLin+29	,"DATA ENTRADA: "	+dToc(_dDtEnd)						,"N",cTpFonte,cFonte5)
	If SB1->B1_TIPO =="PA"
		MSCBSAYBAR(xCol,yLin+32,Alltrim(SB1->B1_CODBAR),"N","MB07",8,.F.,.T.,.F.,,3,2,.F.) // Imprime o codigo de barras para prodotos PA
		Else
		MSCBSAYBAR(xCol,yLin+36,Alltrim(Upper(_nProd)),"N","MB07",8,.F.,.T.,.F.,,3,2,.F.) //Codigo do Produto 
	EndIf
	MSCBSAYBAR(xCol+87,yLin+5,Alltrim(Upper(_cLote)) ,"B","MB07",8,.F.,.F.,.F.,,2,2,.F.) //"C",8.36,.F.,.T.,.F.,,2,1 //Numero do Lote

MSCBEND()
MSCBCLOSEPRINTER()
MS_FLUSH()

Return()


//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
///±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±º  Funcao  ³ ValidPerg   ºAutor  ³Samuel Miranda   º Data ³  29/04/2021 º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³ Cria o Pergunte caso ele não exista                        º±±
//±±º          ³                                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
Static Function ValidPerg()
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i,j
Local nTamSX1	:= Len(SX1->X1_GRUPO)
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("TELARETR06",nTamSX1)

Aadd(aRegs,{cPerg,"01","Número do Documeto.......?","Número do Documeto.......?","Número do Documeto.......?","mv_cha","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Quantidade Copias........?","Quantidade Copias........?","Quantidade Copias........?","mv_chb","N",03,0,1,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
