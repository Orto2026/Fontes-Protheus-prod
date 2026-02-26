#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MTA410    ³ Autor ³ Wagner Alves          ³ Data ³ Mar/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida todo o pedido de venda apos confirmacao             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MTA410()
Local _nOpc1
Private cArea := GetArea()
Private lRet := .T.
cCodTab := M->C5_TABELA
cCodPag := M->C5_CONDPAG   
cMoeda	 	:= M->C5_MOEDA //Por Samuel
//cTipOper := M->C5_XOPER

dbSelectArea("DA1")
dbSetOrder(2)
For _nOpc1 := 1 To Len(aCols)
	If !aCols[_nOpc1,Len(aHeader)+1] // nao esta deletado
		
		_cCodProd := " "
		_nQtde 	  := "" //Por Samuel Miranda
		_nMult	  := "" //Por Samuel Miranda
		
		_nC6CodPro := aScan(aHeader,{|x|Alltrim(x[2])=="C6_PRODUTO"})
		_nC6PrcVen := aScan(aHeader,{|x|Alltrim(x[2])=="C6_PRCVEN"})
		_nPedQtd   := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_QTDVEN"}) //Posição do campo Quantidade
		
		_cCodProd := aCols[_nOpc1,_nC6CodPro] 
		_cPrcVen  := aCols[_nOpc1,_nC6PrcVen]
		
		
		// Inicio Por Samuel Miranda 
		If M->C5_XOPER == '01'
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+ aCols[_nOpc1,_nC6CodPro])
			
			_nMult	 	:= SB1->B1_XQE	//Pega a quantidade cadatrada como minima
			_nQtde	 	:= aCols[_nOpc1,_nPedQtd]//Pega a quantidade digitada no pedido	
			
			if (_nMult) > 0 .AND. SB1->B1_TIPO =='PA'  //Verifica a quantidade minima e verifica se o Produto é PA	
				If Mod(_nQtde,_nMult) = 0  // Verifica se é Multiplo			
				Else
					Aviso("Atenção!!","O Produto: "+ Alltrim(_cCodProd) +" A quantidade deve ser Multiplo de   :  "+ cValToChar(_nMult)+ ".  Por favor corrigir!",{"OK"},1,"Erro na quantidade...")
					RestArea(cArea)
					Return(.F.)
				Endif 
			EndIf
		Endif
		// Fim  Por Samuel Miranda
	   
	   // Inicio Por Samuel Miranda 23/03/2020
	    //Varre a DA1 e verificar a moeda conforme pedido e Tabela
		If !Empty(cCodTab)  
			iF DA1->(dbSeek(xFilial("DA1")+_cCodProd+cCodTab)) = .T. .AND. DA1->DA1_MOEDA <> cMoeda  
				
				_cTexto1 := "Produto: "+ _cCodProd + CHR(13)+CHR(10)
				_cTexto2 := "Tabela : "+ cCodTab + CHR(13)+CHR(10)
				_cTexto3 := "Moeda  : "+ Alltrim(STR(DA1->DA1_MOEDA) )

				Aviso("Atencao!",_cTexto1 + _cTexto2 + _cTexto3,{"OK"},2,"Verificar Tabela e Moeda...")
				RestArea(cArea)
				Return(.F.)
			EndIf
		EndIf	
		// Fim  Por Samuel Miranda



		// EXCLUIDA VALIDACAO. FORAM INCLUIDAS REGRAS DE NEGOCIO 
		/*	
		
		If !Empty(cCodTab) .and. !(cCodPag $ "001/01 /039/031")
			DA1->(dbSeek(xFilial("DA1")+_cCodProd+cCodTab))
				If DA1->DA1_ATIVO <> "2" .And. _cPrcVen < DA1->DA1_PRCVEN
					Aviso("Atencao!!!","O Produto: "+Alltrim(_cCodProd)+" esta com o preco unitario inferior a tabela de preco "+cCodTab+". Corrija o valor do produto!",{"OK"},1,"Preco menor que a tabela vigente...")
					RestArea(cArea)
					Return(.F.)
				EndIf
		EndIf
		*/
	Endif
	
	
Next

Return(lRet)
