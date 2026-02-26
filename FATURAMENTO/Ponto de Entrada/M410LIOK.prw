#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ?M410LIOK ?Autor ?Raphael Camillo Proto  ?	Data ?	19/08/04 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ?Ponto de entrada que valida cada linha do pedido de venda   	³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ?Especifico para ORTOSINTESE                                	³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M410LIOK()

Local _cAlias := Alias()
Local _aArea  := SC6->(GetArea())

Local _nPosProd		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
Local _nPLocal		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_LOCAL"})
Local _nPDtEnt		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTREG"})
Local _nPLote		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_LOTECTL"})
Local _nPXqtde		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XQTDE"})

Local _nPedCli		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PEDCLI"})
Local _nPedCom		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_NUMPCOM"})
Local _nPClasPed	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_CLASPED"}) 
Local _nPObsEst		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XOBSEST"})

Local _nPedQtd		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"}) //Posição do campo Quantidade por Samuel Miranda

Local _lRet			:= .T.
Local _cMsg			:= ""
local i				:= 0

If !aCols[n,Len(aHeader)+1]
   // Grava Data de Entrega Igual a Data Informada no Cabecalho
	//aCols[n,_nPDtEnt] := M->C5_XDTENTR                      // MAURICIO ALTERACAO DATA ENTREGA - LEONARDO/GISELI/TATIANE
    //aCols[n,_nPDtEnt] := U_XCALCDATA(aCols[n,_nPosProd],DDATABASE)  
    aCols[n,_nPObsEst] := M->C5_XOBSEST                                                          

// RETIRADO A PEDIDO DE LEONARDO/GISELI/CRISTIANE	

	For i:=1 To Len(aHeader)
//		If Trim(aHeader[i][2]) == "C6_ENTREG"
		If Trim(aHeader[i][2]) == "C6_XOBSEST"
			
				//aCols[n,i] := U_XCALCDATA(aCols[n,_nPosProd],DDATABASE)
				aCols[n,i] := M->C5_XOBSEST
			
		EndIf
	Next


	//Forca o Armazem conforme Classificacao do Pediddo
	If M->C5_CLASPED == "1"
		aCols[n,_nPLocal] := "01"
	ElseIf M->C5_CLASPED == "2"
		aCols[n,_nPLocal] := "01"
   // ElseIf M->C5_CLASPED == "4" // MAURICIO 02/07/2016 ALTERADO PARA EXPORTACAO E CAIXAS USAREM ARMAZEM 01
   // aCols[n,_nPLocal] := "01"// MAURICIO 05/09/2019 ALTERADO PARA EXPORTACAO NAO USAR MAIS A REGRA.
	EndIf
	
	If M->C5_CLASPED == "1"
		aCols[n,_nPClasPed] := "1"
	ElseIf M->C5_CLASPED == "2"
		aCols[n,_nPClasPed] := "2"
	ElseIf M->C5_CLASPED == "3" 
		aCols[n,_nPClasPed] := "3"
	ElseIf M->C5_CLASPED == "4" 
		aCols[n,_nPClasPed] := "4"
	ElseIf M->C5_CLASPED == "5" 
		aCols[n,_nPClasPed] := "5"
	ElseIf M->C5_CLASPED == "6" 
		aCols[n,_nPClasPed] := "6"			
	EndIf
       
	//Validacoes diversas
	// Para Classificacao 1 - Prazo Minimo de Entrega 30 Dias da Emissao, para Classificacao 2 - 60 Dias da Emissao
   /*
		If M->C5_CLASPED == "1" .And. M->C5_XDTENTR < M->C5_EMISSAO+30
		_lRet := .F.
		_cMsg += "Para esse Pedido a Data de Entrega deve ser Maior ou a 30 Dias de Emissao do PV"+CHR(13)+CHR(10)
	ElseIf M->C5_CLASPED == "2" .And. M->C5_XDTENTR < M->C5_EMISSAO+30 // ALTERADO A PEDIDO DE CRISTINA(VENDAS) DE 60 PARA 30
		_lRet := .F.
		_cMsg += "Para esse Pedido a Data de Entrega deve ser Maior ou a 60 Dias de Emissao do PV"+CHR(13)+CHR(10)
	EndIf
    */
	      
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+aCols[n,_nPosProd])
	If FieldPos("B1_XBLOQ") > 0
		If (AllTrim(M->C5_CLASPED) $ "12" .And. Alltrim(SB1->B1_XBLOQ) $ "13") .Or. (AllTrim(M->C5_CLASPED) == "4" .And. Alltrim(SB1->B1_XBLOQ) $ "23")
			_lRet := .F.
			_cMsg := "Produto bloqueado para este mercado"+CHR(13)+CHR(10)
		EndIf
	EndIf
	
	// Inicio Por Samuel Miranda  
	If M->C5_XOPER == '01'
		_nMult	 	:= SB1->B1_XQE	//Pega a quantidade cadatrada como minima
		_nProd		:= aCols[n,_nPosProd]
		_nQtde	 	:= aCols[n,_nPedQtd]//Pega a quantidade digitada no pedido		
		
		if (_nMult) > 0 .AND. SB1->B1_TIPO =='PA' 
		
			If Mod(_nQtde,_nMult) = 0  // _nPOQtven % B1_XQE == 0 
			Else
				_lRet := .F.
				_cMsg := "O Produto: "+Alltrim(_nProd)+"  A quantidade deve ser Multiplo de   :  " + cValToChar(_nMult) + CHR(13)+CHR(10)
			Endif
		endif 
	Endif
	// Fim  Por Samuel Miranda
	

EndIf

//Grava Pedido de Cliente / Pedido de Compra / Item do Pedido de Compras,  igual a linha 1
If n <> 1 .And. !aCols[n,Len(aHeader)+1]
	aCols[n,_nPedCli]		:= aCols[1,_nPedCli]
	aCols[n,_nPedCom]		:= aCols[1,_nPedCom]
EndIf

If !_lRet
	Aviso("Atenção",_cMsg,{"OK"},1,"Validação da Linha")
EndIf

RestArea(_aArea)
dbSelectArea(_cAlias)
Return(_lRet)
