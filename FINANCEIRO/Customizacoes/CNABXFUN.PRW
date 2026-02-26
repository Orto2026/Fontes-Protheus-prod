#Include "PROTHEUS.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALCOD1   ºAutor  ³Montes              º Data ³  08/03/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida a linha digitavel / codigo de barras.                º±±
±±º          ³Cria campo E2_CODBAR C,48 - VLDUSR = U_VALCOD1()            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VALCOD1(cModelo)

Local nModulo, cStr, i, nMult, cChar, cDigito, cDV1, cDV2, cDV3, cCampo1, cCampo2, cCampo3, nCalc_DV1, nCalc_DV2, nCalc_DV3, nVal
Local LRET := .F.
Local nCampo

DEFAULT cModelo := M->E2_FORMPAG

If ValType(M->E2_CODBAR) == NIL
	Return(.t.)
EndIf

If EMPTY(alltrim(M->E2_CODBAR))
	Return(.T.)
EndIf

cStr := M->E2_CODBAR

If "*" $ cStr
	Help(" ", 1, "ONLYNUM")
	Return(.f.)
EndIf                          

If cModelo $ "11|13" //Codigo de barras de tributos e concessionarias

   i := 0
   nMult := 2
   nModulo := 0
   cChar := SPACE(1)
   cDigito := SPACE(1)
 
   If len(AllTrim(cStr)) > 44  // linha digitada

      cIDEmp  := Substr(cStr,17,4) //--- Posicao 17 - 4 caracteres igual a 0179 ou 0180 ou 0181 significa FGTS
      cMoeda  := Substr(cStr,03,1)
      //lMod11  := ( cIDEmp == "0179" .Or. cIDEmp == "0180" .Or. cIDEmp == "0181" ) //--- Valida pelo Modulo 11  para FGTS
      lMod11  := cMoeda $ "89" //Modulo 11

	  aDV     := { SUBSTR(cStr,12, 1), SUBSTR(cStr,24, 1), SUBSTR(cStr,36, 1), SUBSTR(cStr,48, 1) }
	  cDVG    := SUBSTR(cStr,04, 1)
	
	  aCampos := { SUBSTR(cStr, 1,11), SUBSTR(cStr,13,11), SUBSTR(cStr,25,11), SUBSTR(cStr,37,11) } 
	  aCalcDv := { 0, 0, 0, 0 }
	  
	  /*
	  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	  ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
	  ±±³Descri‡…o ³ Calculo do modulo 10 sugerido pelo ITAU. Esta funcao       ³±±
	  ±±³          ³ somente e utilizada como validacao do campo E2_CODBAR      ³±±
	  ±±³          ³ Verifica a digitacao do codigo de barras                   ³±±
	  ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	  */
	
	  //
	  // Calcula Digitos aCampos 
	  //
	  For nCampo := 1 To 4	
	      nMult := 2
	      nModulo := 0
	      nVal := 0
	      For i := Len(aCampos[nCampo]) to 1 Step -1
		      cChar := Substr(aCampos[nCampo],i,1)
		      If isAlpha(cChar) 
			     Help(" ", 1, "ONLYNUM")
			     Return(.f.)
		      EndIf                      
		      If lMod11 //--- Valida pelo Modulo 11  para FGTS
		         nModulo := Val(cChar)*nMult
		   	     nVal    := nVal + nModulo
			     nMult   := IF(nMult==9,2,nMult+1)
		      Else
		         nModulo := Val(cChar)*nMult
			     nVal    := nVal + IIF(nModulo>9,1,0) + (nModulo-IIF(nModulo>9,10,0))
			     nMult   := IIF(nMult==2,1,2)
	          EndIf
	      Next
	      If lMod11
		     aCalcDV[nCampo] := 11 - MOD(nVal,11)
		     aCalcDV[nCampo] := IF(aCalcDV[nCampo]==0 .OR. aCalcDV[nCampo]==10 .OR. aCalcDV[nCampo]==11,0,aCalcDV[nCampo])
          Else
	         aCalcDV[nCampo] := 10 - (nVal % 10)
	         If aCalcDV[nCampo] == 10
		        aCalcDV[nCampo] := 0
	         EndIf
	      EndIf
	  Next
	  	
	  If !(aCalcDV[1] == Val(aDV[1]) .and. aCalcDV[2] == Val(aDV[2]) .and. aCalcDV[3] == Val(aDV[3]) .and. aCalcDV[4] == Val(aDV[4]) )
		 Help(" ",1,"INVALCODBAR",,"Codigo de Barras Invalido !",4)
		 lRet := .F.
	  Else
		 lRet := .T.
	  EndIf
	
   Else
	  cDigito := SUBSTR(cStr,4, 1)
	  cStr    := SUBSTR(cStr,1, 3)+ ;
	             SUBSTR(cStr,5,40)
	  
	  cMoeda  := Substr(cStr,03,1)
      lMod11  := cMoeda $ "89" //Modulo 11
	
	  /*
	  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	  ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
	  ±±³Descri‡…o ³ Calculo do modulo 11 sugerido pelo ITAU. Esta funcao       ³±±
	  ±±³          ³ somente e utilizada como validacao do campo E2_CODBAR.     ³±±
	  ±±³          ³ Verifica o codigo de barras grafico (Atraves de leitor)    ³±±
	  ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	  */
	
	  cStr := AllTrim(cStr)
	
	  If Len(cStr) < 43
		 Help(" ", 1, "FALTADG",,"Falta digito verificador !",4)
		 Return(.f.)
	  EndIf
	  
	  For i := Len(cStr) to 1 Step -1
		  cChar := Substr(cStr,i,1)
		  If isAlpha(cChar) 
			 Help(" ", 1, "ONLYNUM")
			 Return(.f.)
		  EndIf                
		  nMod    := Val(cChar)*nMult
		  If lMod11
		     nModulo := nModulo + nMod
		     nMult   := if(nMult==9,2,nMult+1)
		  Else
   		     nModulo := nModulo + IIF(nMod>9,1,0) + (nMod-IIF(nMod>9,10,0))
		     nMult   := if(nMult==2,1,2)
		  EndIf
	  Next
      If lMod11 
         nRest11 := 11-(nModulo % 11)
	     nDigito := if(nRest11 >= 11,0,nRest11)	
	  Else
	     nRest10 := 10 - (nModulo % 10)
	     nDigito := if(nRest10==10,0,nRest10)
	  EndIf
	  
	  If nDigito <> Val(cDigito)
		 Help(" ",1,"DgCnab",,"Digito verificador nao confere! DV="+Str(nDigito,1),4)
		 lRet := .F.
	  Else
		 lRet := .T.
	  EndIf
	
   EndIf

Else

   i := 0
   nMult := 2
   nModulo := 0
   cChar := SPACE(1)
   cDigito := SPACE(1)

   If len(AllTrim(cStr)) > 44  // linha digitada
	
	  cDV1    := SUBSTR(cStr,10, 1)
	  cDV2    := SUBSTR(cStr,21, 1)
	  cDV3    := SUBSTR(cStr,32, 1)
	
	  cCampo1 := SUBSTR(cStr, 1, 9)
	  cCampo2 := SUBSTR(cStr,11,10)
	  cCampo3 := SUBSTR(cStr,22,10)
	
	  /*
	  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	  ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
	  ±±³Descri‡…o ³ Calculo do modulo 10 sugerido pelo ITAU. Esta funcao       ³±±
	  ±±³          ³ somente e utilizada como validacao do campo E2_CODBAR      ³±±
	  ±±³          ³ Verifica a digitacao do codigo de barras                   ³±±
	  ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	  */
	
	  //
	  // Calcula DV1
	  //
	
	  nMult := 2
	  nModulo := 0
	  nVal := 0
	
	  For i := Len(cCampo1) to 1 Step -1
		  cChar := Substr(cCampo1,i,1)
		  if isAlpha(cChar) 
			 Help(" ", 1, "ONLYNUM")
			 Return(.f.)
		  endif
		  nModulo := Val(cChar)*nMult
		  If nModulo >= 10
			 nVal := NVAL + 1
			 nVal := nVal + (nModulo-10)
		  Else
			 nVal := nVal + nModulo
		  EndIf
		  nMult:= if(nMult==2,1,2)
	  Next
	  nCalc_DV1 := 10 - (nVal % 10)
	  if nCalc_DV1 == 10
		 nCalc_DV1:=0
	  endif
	
	  //
	  // Calcula DV2
	  //
	  nMult := 2
	  nModulo := 0
	  nVal := 0
	
	  For i := Len(cCampo2) to 1 Step -1
		  cChar := Substr(cCampo2,i,1)
		  if isAlpha(cChar) 
			 Help(" ", 1, "ONLYNUM")
			 Return(.f.)
		  endif
		  nModulo := Val(cChar)*nMult
		  If nModulo >= 10
			 nVal := nVal + 1
			 nVal := nVal + (nModulo-10)
		  Else
			 nVal := nVal + nModulo
		  EndIf
		  nMult:= if(nMult==2,1,2)
	  Next
	  nCalc_DV2 := 10 - (nVal % 10)
	  if nCalc_DV2==10
		 nCalc_DV2:=0
	  endif
	  //
	  // Calcula DV3
	  //
	  nMult := 2
	  nModulo := 0
	  nVal := 0
	
	  For i := Len(cCampo3) to 1 Step -1
		  cChar := Substr(cCampo3,i,1)
		  if isAlpha(cChar) 
			 Help(" ", 1, "ONLYNUM")
			 Return(.f.)
		  endif
		  nModulo := Val(cChar)*nMult
		  If nModulo >= 10
			 nVal := nVal + 1
			 nVal := nVal + (nModulo-10)
		  Else
			 nVal := nVal + nModulo
		  EndIf
		  nMult:= if(nMult==2,1,2)
	  Next
	  nCalc_DV3 := 10 - (nVal % 10)
	
	  If nCalc_DV3==10
		 nCalc_DV3:=0
	  EndIf
	
	  If !(nCalc_DV1 == Val(cDV1) .and. nCalc_DV2 == Val(cDV2) .and. nCalc_DV3 == Val(cDV3) )
		 Help(" ",1,"INVALCODBAR",,"Codigo de Barras Invalido !",4)
		 lRet := .F.
	  Else
		 lRet := .T.
	  EndIf
	
   Else
	  cDigito := SUBSTR(cStr,5, 1)
	  cStr    := SUBSTR(cStr,1, 4)+ ;
	             SUBSTR(cStr,6,39)
	
	  /*
	  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	  ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
	  ±±³Descri‡…o ³ Calculo do modulo 11 sugerido pelo ITAU. Esta funcao       ³±±
	  ±±³          ³ somente e utilizada como validacao do campo E2_CODBAR.     ³±±
	  ±±³          ³ Verifica o codigo de barras grafico (Atraves de leitor)    ³±±
	  ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	  */
	
	  cStr := AllTrim(cStr)
	
	  If Len(cStr) < 43
		 Help(" ", 1, "FALTADG",,"Falta digito verificador !",4)
		 Return(.f.)
	  EndIf
	
	  For i := Len(cStr) to 1 Step -1
		  cChar := Substr(cStr,i,1)
		  If isAlpha(cChar) 
			 Help(" ", 1, "ONLYNUM")
			 Return(.f.)
		  EndIf
		  nModulo := nModulo + Val(cChar)*nMult
		  nMult:= if(nMult==9,2,nMult+1)
	  Next
	  nRest := 11 - (nModulo % 11)
	  nRest := if(nRest==10 .or. nRest==11 .or. nRest == 0,1,nRest)
	  If nRest <> Val(cDigito)
		 Help(" ",1,"DgCnab",,"Digito verificador nao confere!"+Str(nRest),4)
		 lRet := .F.
	  Else
		 lRet := .T.
	  EndIf
	
   EndIf

EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRFCODBAR ºAutor  ³ Montes             º Data ³  08/03/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Transforma a linha digitavel em codigo de barras.           º±±
±±º          ³Criar Gatilho Campo E2_CODBAR, Contra Dominio E2_CODBAR     º±±
±±º          ³Regra U_TRFCODBAR(), tipo primario                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TRFCODBAR(cModelo)

Local cMonta1 := ""
Local cMonta2 := ""
Local cMonta3 := ""
Local cMonta4 := ""
Local cMonta5 := ""
Local cMonta6 := ""
Local cMonta7 := ""
Local cReturn := ""
Local cCodbar := Trim(M->E2_CODBAR)
Local nTamCod := Len(cCodbar)
Local nTamVal := Len(cCodbar)-33                                      

DEFAULT cModelo := M->E2_FORMPAG
                                                  
// Verifica tamanho da linha digitável
If !Empty(AllTrim(cCodbar))

   If cModelo $ "11|13" //Codigo de barras de tributos ou concessionarias

	  If nTamCod == 44
		 cReturn := cCodbar
	  Else
		 // Monta o Codigo de Barras
		 cMonta1:= Substr(cCodbar,1,11)
		 cMonta2:= Substr(cCodbar,13,11)
		 cMonta3:= Substr(cCodbar,25,11)
		 cMonta4:= Substr(cCodbar,37,11)
		
		 cCodBar := cMonta1 + cMonta2 + cMonta3 + cMonta4
	  EndIf
   Else
	
	  If nTamCod == 44
		 cReturn := cCodbar
	  Else
		 If nTamVal < 14        // Codigo de Barras sem fator de vencimento.
			cMonta3 := "0000"
			cMonta4 := Strzero(Val(Substr(cCodbar,34,nTamVal)),10)
		 Else                    // Codigo de Barras com fator de vencimento.
			cMonta3:= Substr(cCodbar,34,4)
			cMonta4:= Substr(cCodbar,38,10)
		 EndIf
		
		 // Monta o Codigo de Barras
		
		 cMonta1:= Substr(cCodbar,1,4)
		 cMonta2:= Substr(cCodbar,33,1)
		 cMonta5:= Substr(cCodbar,5,5)
		 cMonta6:= Substr(cCodbar,11,10)
		 cMonta7:= Substr(cCodbar,22,10)
		
		 cCodBar := cMonta1 + cMonta2 + cMonta3 + cMonta4 + cMonta5 + cMonta6 + cMonta7
	  EndIf
   EndIf
EndIf  

cCodBar := PADR(cCodBar,LEN(SE2->E2_CODBAR))

Return(cCodBar)                                      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLRCODBAR ºAutor  ³ Montes             º Data ³  08/03/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica o valor do titulo com o codigo de barras           º±±
±±º          ³Criar Gatilho Campo E2_CODBAR, Contra Dominio E2_CODBAR     º±±
±±º          ³Regra U_VLRCODBAR(), tipo primario                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VLRCODBAR(cModelo)

Local nValor  := 0
Local cReturn := ""
Local cCodbar := Trim(M->E2_CODBAR)
Local nVlrTit := SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE) //M->E2_VALOR //+M->E2_IRRF
Local nTamCod := Len(cCodbar)
Local nTamVal := Len(cCodbar)-33
                               
DEFAULT cModelo := M->E2_FORMPAG
                                                 
// Verifica tamanho da linha digitável          	
If !Empty(alltrim(cCodbar))
	
   If cModelo $ "11|13" //11-PAGAMENTO DE CONTAS E TRIBUTOS COM CODIGO DE BARRAS
   	  
   	  cCodbar := alltrim(U_TRFCODBAR(cModelo))
      nTamCod := Len(cCodbar)
   	  
   	  If nTamCod <> 44
	     MsgInfo("Tamanho do Codigo de barras invalido !" +Chr(13)+Chr(10)+"Verifique codigo lido!", "Codigo de barras invalido!")
	     cReturn := ""
   	  Else
	     nValor := Val(Substr(cCodbar,5,11)) / 100
	     
	     // Compara valores
		 If nVlrTit = nValor
			cReturn := cCodbar
		 Else
		    MsgInfo("Valor do codigo de barra não confere com o título!" +Chr(13)+Chr(10)+"Verifique codigo lido!", "Codigo de barras invalido!")
			cReturn := ""
		 EndIf

   	  EndIf
   Else
	  If nTamCod == 44 
	     cReturn := cCodbar
	  Else
		 If nTamVal < 14        // Codigo de Barras sem fator de vencimento.
			nValor := Val(Substr(cCodbar,34,nTamVal)) / 100
		 Else                    // Codigo de Barras com fator de vencimento.
			nValor := Val(Substr(cCodbar,38,10)) / 100
		 Endif
		
		 // Compara valores
		 If nVlrTit = nValor
			cReturn := cCodbar
		 Else
		    MsgInfo("Valor da linha digitável não confere com o título!" +Chr(13)+Chr(10)+"Verifique linha digitável!", "Linha Digitável Inválida!")
			cReturn := ""
		 EndIf
	  EndIf
   EndIf
EndIf

cReturn := PADR(cReturn,LEN(SE2->E2_CODBAR))

Return(cReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CNABREGN ºAutor  ³Montes               º Data ³  08/03/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta complemento de detalhamento dos dados de tributo no   º±±
±±º          ³registro N do Cnab a pagar                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CNABREGN()

Local cReturn := ""

If SEA->EA_MODELO $ "16" //16-PAGAMENTO DE TRIBUTOS - DARF NORMAL - SEGMENTO N2
                    
 	cReturn := "02"                                           // DARF NORMAL 
	cReturn += SE2->E2_XCDARF                                 // CODIGO DE RETENCAO DA RECETA    	
    cReturn += "2"                                            // 1=PESSOA FISICA,2=PESSOA JURIDICA 
	cReturn += ALLTRIM(SM0->M0_CGC)			               // CNPJ
	cReturn += GRAVADATA(SE2->E2_EMISSAO,.F.,5)               // PERIODO DE APURACAO 
	cReturn += Repli("0",17)                                  // numero de referencia 
	cReturn += STRZERO(SE2->E2_SALDO*100,14)                  // valor  
	cReturn += STRZERO(SE2->E2_ACRESC*100,14)
	cReturn += REPL("0",14)                                   // atualizacao monetaria 
    cReturn += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14) // valor arrecadado 
    cReturn += GRAVADATA(SE2->E2_VENCTO,.F.,5)                // data de arrecadacao                                                       
 	cReturn += GRAVADATA(SE2->E2_VENCTO,.F.,5)                // DATA DE PAGTO                                    
 	cReturn += space(30)                                      // BRANCOS
 	cReturn += SUBSTR(SM0->M0_NOME,1,30)

ElseIf SEA->EA_MODELO $ "17" //17-PAGAMENTO DE TRIBUTOS - GPS  - SEGMENTO N1 -> // GPS POSICAO 018-195

	cReturn := SE2->E2_XTRIBUT 	 		                   //  01=GPS
	cReturn += ALLTRIM(SE2->E2_XCGPS)		                   // EMPRESAS EM GERAL (PADRAO)
	cReturn += SE2->E2_XCOMPGP 		                       // MMAAAA COMPETENCIA
	cReturn += ALLTRIM(SM0->M0_CGC)	                       // CNPJ
	cReturn += STRZERO(SE2->E2_SALDO*100,14)                  // VALOR
	cReturn += STRZERO(SE2->E2_ACRESC*100,14) 	               // VALOR OUTRAS ENTIDADES
	cReturn += STRZERO(SE2->E2_ACRESC*100,14)                 // ATUALIZACAO MONET
	cReturn += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14) // VALOR ARRECADADO
	cReturn += GRAVADATA(SE2->E2_VENCTO,.F.,5) 	           // DATA DE ARRECADACAO
	cReturn += SPACE(08)
	cReturn += SA2->A2_CGC
	cReturn += SPACE(36)
	cReturn += SUBSTR(SM0->M0_NOME,1,30)

ElseIf SEA->EA_MODELO $ "18" //18-PAGAMENTO DE TRIBUTOS - DARF SIMPLES   - SEGMENTO N3

	cPerApu := DTOS(SE2->E2_EMISSAO)
	cDtVenc := DTOS(SE2->E2_VENCTO)
	nRecBru := MV_PAR13  //Valor Receita Bruta Cumulada
	nPerBru := 0         //Percentual sobre a Valor Receita Bruta Cumulada

	cReturn := STRZERO(VAL(SE2->E2_XCDARF),6) //Código da Receita do Tributo - Embora o campo seja alfanumérico, informar o código da receita alinhado à direita e completando com zeros à esquerda. Deve ser obtido nas agências da Secretaria da Receita Federal ou através do site no endereço: http://www.receita.fazenda.gov.br.
	cReturn += "01"                            //Tipo de Identificação do Contribuinte - 1 = CNPJ, 2 = CPF, 3 = NIT/PIS/PASEP, 4 = CEI, 6 = NB, 7 = n°. do título, 8 = DEBCAD, 9 = referência.
	cReturn += SM0->M0_CGC                     //Identificação do Contribuinte
	cReturn += "18"                            //Código de Identificação do Tributo	- 18' Tributo DARF Simples.
	cReturn += SUBSTR(cPerApu,7,2)+SUBSTR(cPerApu,5,2)+SUBSTR(cPerApu,1,4) //Período de Apuração	- DDMMAAAA, DD para dia, MM para mês e AAAA para ano.
	cReturn += STRZERO(nRecBru*100,15)         //Valor Receita Bruta Cumulada 143 157	13	2	Numérico		N010
	cReturn += STRZERO(nPerBru*100,7)         //Percentual sobre a Valor Receita Bruta Cumulada 158 164	5	2	Numérico		N011
	cReturn += STRZERO(((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-SE2->E2_MULTA-SE2->E2_JUROS)*100),15) //Valor Principal	165	179	13	2	Numérico		G042	
	cReturn += STRZERO(SE2->E2_MULTA*100,15) //Valor da Multa	180	194	13	2	Numérico		G048	
	cReturn += STRZERO(SE2->E2_JUROS*100,15) //Valor dos Juros / Encargos	195	209	13	2	Numérico		G047	
	cReturn += SPACE(21)    //Uso Exclusivo FEBRABAN/CNAB - Na remessa, informar 'brancos' (espaços).

ElseIf SEA->EA_MODELO $ "22" //22-PAGAMENTO DE TRIBUTOS - GARE ICMS SP - SEGMENTO N4

	cCodRec := IIF(EMPTY(SE2->E2_XCDARF),"000462",SE2->E2_XCDARF)
	cDtVenc := DTOS(SE2->E2_VENCTO)
      
	cReturn := STRZERO(VAL(cCodRec),6)   //Codigo da Receita do Tributo 
	cReturn += "01"        //Tipo de Identificação do Contribuinte - 1 = CNPJ, 2 = CPF, 3 = NIT/PIS/PASEP, 4 = CEI, 6 = NB, 7 = n°. do título, 8 = DEBCAD, 9 = referência.
	cReturn += SM0->M0_CGC //Identificação do Contribuinte                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
	cReturn += "22"        //Código de Identificação do Tributo - 22’ = Tributo - GARE-SP ICMS   
	cReturn += SUBSTR(cDtVenc,7,2)+SUBSTR(cDtVenc,5,2)+SUBSTR(cDtVenc,1,4) //Data do Vencimento - DDMMAAAA, DD para dia, MM para mês e AAAA para ano. 
	cReturn += PADR(SM0->M0_INSC,12) //12, Inscricao Estadual
	cReturn += SPACE(13)   //Divida Ativa / N.Etiqueta
	cReturn += SE2->E2_XCOMPGP //Periodo de Referencia = MMAAAA, MM para mês e AAAA para ano. 
	cReturn += SPACE(13)   //Numero da Parcela / Notificacao
	cReturn += STRZERO(((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-SE2->E2_MULTA-SE2->E2_JUROS)*100),15) //Valor da Receita
	cReturn += STRZERO(SE2->E2_MULTA*100,14) //Valor dos Juros
	cReturn += STRZERO(SE2->E2_JUROS*100,14) //valor da Multa
	cReturn += SPACE(1)    //Uso Exclusivo FEBRABAN/CNAB

EndIf

Return(cReturn)
