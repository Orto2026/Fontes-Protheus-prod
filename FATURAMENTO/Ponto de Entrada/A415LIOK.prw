#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A415LIOK º Autor ³ AP6 IDE            º Data ³  12/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PE Validacao da Linha d Orcamento                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ortosintese                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A415LIOK()

Local _aArea 	:= GetArea()
Local _aAreaB1	:= SB1->(GetArea())
Local _nRegAtu 	:= 0  
Local _cPedCli 	:= ""
Local	cCodProd := ""

If !TMP1->CK_FLAG .And. SCJ->(FieldPos("CJ_XCLASPD")) > 0
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+TMP1->CK_PRODUTO)
	If FieldPos("B1_XBLOQ") > 0
		If (AllTrim(M->CJ_XCLASPD) $ "12" .And. Alltrim(SB1->B1_XBLOQ) $ "13") .Or. (AllTrim(M->CJ_XCLASPD) == "4" .And. Alltrim(SB1->B1_XBLOQ) $ "23")
			Alert("Produto bloqueado para este mercado")
			RestArea(_aAreaB1)
			RestArea(_aArea)
			Return(.F.)
		EndIf
	EndIf
Endif  

// Inicio - Verifica se a quantidade digitada e multiplo - Por SAMUEL MIRANDA 2019-04-15
If !Empty(TMP1->CK_PRODUTO)
   
   dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+TMP1->CK_PRODUTO) //Seleciona o no Alias SB1
    
    nQtdeMult	:= SB1->B1_XQE		//Quantidade Multipla	
    cCodProd 	:= TMP1->CK_PRODUTO	//Codigo do Produto Digitada no Grid
    nQtdeProd 	:= TMP1->CK_QTDVEN	//Quantida do produto digitada no Grid
    //VErifica se o a quantidade multipla é maior que zero e se o tipo é PA
    If (nQtdeMult) > 0 .And. SB1->B1_TIPO="PA"
	    if Mod(nQtdeProd,nQtdeMult)=0
		else
			Alert("Quantidade do Produto invalida!", "Atenção") 
			Return(.F.)
		End if
	EndIf
EndIf   
// Fim - Verifica se a quantidade digitada e multiplo - Por SAMUEL MIRANDA 2019-04-15


dbSelectArea("TMP1")
_nRegAtu := Recno()
dbGotop()
While !Eof() 
	If TMP1->CK_FLAG
		dbSkip()
		Loop
	Else
		_cPedCli := TMP1->CK_PEDCLI
		Exit
	EndIf
EndDo

dbGoto(_nRegAtu)

RecLock("TMP1")
	TMP1->CK_PEDCLI	:= _cPedCli
MsUnlock()

RestArea(_aArea)

Return(.T.)