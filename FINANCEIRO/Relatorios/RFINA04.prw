#INCLUDE "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"
               
#DEFINE CRLF CHR(13)+CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFINA04  ³ Autor ³ Montes - THINKFAST    ³ Data ³ 10/07/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DE BOLETO COM COD.BARRAS					      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ORTOSINTESE                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFINA04(cAliasOri,cRecOri,nOpcx,cNota,cSerie,lSetup)  

Private lEnd       := .F.
Private aArea      := GetArea()
Private aAreaSM0   := SM0->(GetArea())

DEFAULT lSetup := .T.

dbSelectArea("SE1")

If cNota <> Nil .And. cSerie <> Nil
	dbSetOrder(1)
	If !dbSeek(xFilial("SE1")+cSerie+cNota)
    	Return Nil
	EndIf
EndIf

Processa({|lEnd|MontaRel(lSetup)})

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Montes - THINKFAST    ³ Data ³ 10/07/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ortosintese                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel(lSetup)

LOCAL oPrint
LOCAL nX := 0
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                                                   ,; //[1]Nome da Empresa
								AllTrim(SM0->M0_ENDCOB)+' '+AllTrim(SM0->M0_COMPCOB)                      ,; //[2]Endereço
								AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
								"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
								"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
								"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+              ; //[6]
								Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
								Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
								"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
								Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E
LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {"Após o vencimento cobrar multa de "                ,;
								"Mora Diaria de R$ "}

LOCAL nI           := 1
LOCAL aCB_RN_NN    := {}
LOCAL nVlrTit      := 0

Local lImprime		:= .F.
Local MVLJMULTA     := SuperGetMv("MV_LJMULTA")

Private cCodBanco := ""
Private cBanco    := SE1->E1_PORTADO
Private cAgencia  := SE1->E1_AGEDEP
Private cConta    := SE1->E1_CONTA

If EMPTY(cBanco)
	aBanco := SelBanco()
	
	If aBanco = Nil
		Return Nil
	EndIf

	cBanco	 := aBanco[1]
	cAgencia := aBanco[2]
	cConta	 := aBanco[3]
ElseIf EMPTY(cAgencia) .or. EMPTY(cConta)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+cBanco)
	cAgencia := SA6->A6_AGENCIA
	cConta	 :=	SA6->A6_NUMCON
EndIf

cFilePDF := "BOLETO_"+AllTrim(SE1->E1_NUM)+SE1->E1_PARCELA+"-"+Dtos(MSDate())+StrTran(Time(),":","")
lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
cPathInServer   := Nil
lDisabeSetup    := !lSetup //Lógico	Se .T. não exibe a tela de Setup, ficando à cargo do programador definir quando e se será feita sua chamada. Default é .F.
lServer         := .F.
lViewPDF        := .T.

oPrint := FWMSPrinter():New(cFilePDF, IMP_PDF, lAdjustToLegacy,cPathInServer,lDisabeSetup,,,,lServer,,,lViewPDF, /*IIF(!EMPTY(cFilePDF),.F.,.T.)*/ )

oPrint:SetResolution(78) //Tamanho estipulado para a Danfe
oPrint:SetPortrait()
oPrint:SetPaperSize(DMPAPER_A4)
oPrint:SetMargin(60,60,60,60)
If !lSetup
	oPrint:lServer  := .F. 
	oPrint:cPathPDF := GetTempPath()
	oPrint:SetViewPDF(.T.)  //Este método estará disponível em pacote de lib, no qual o fonte FWMSPrinter.PRW tenha a data superior ou igual a 08/09/2011
Else
	oPrint:lServer  := .T. //oSetup:GetProperty(PD_DESTINATION)==AMB_SERVER
EndIf

cChaveSE1 := SE1->E1_FILIAL+SE1->E1_NUM+SE1->E1_PREFIXO
cNumTit   := SE1->E1_NUM
cPrefixo  := SE1->E1_PREFIXO
dEmissao  := SE1->E1_EMISSAO
lImprime  := .F.
   
While SE1->(!EOF()) .And. SE1->E1_FILIAL+SE1->E1_NUM+SE1->E1_PREFIXO == cChaveSE1

	If !Empty(SE1->E1_NUMBCO)
		If !MsgYesNo(	'Já foi gerado boleto para o título '+SE1->E1_NUM+"/"+SE1->E1_PARCELA+'.'+CRLF+;
						'Deseja gerar a segunda via?','Boleto já gerado')
			SE1->(dbSkip())
			Loop
		EndIf
	EndIf

	If SE1->E1_VENCREA < dDataBase
		MsgAlert('Vencimento do título não pode ser anterior ao processamento do boleto.'+CRLF+;
				'Boleto: '+AllTrim(SE1->E1_PREFIXO)+'-'+SE1->E1_NUM+'-'+SE1->E1_PARCELA+' não será gerado.')
		SE1->(dbSkip())
		Loop
	EndIf

	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+cBanco+cAgencia+cConta)

	//Posiciona na Arq de Parametros CNAB
	DbSelectArea("SEE")
	DbSetOrder(1)
	DbSeek(xFilial("SEE")+cBanco+cAgencia+cConta)
	
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
	
	DbSelectArea("SE1")
	If ALLTRIM(SA6->A6_NUMBCO) == "341"
		cCarteira  := "109" //Default Itau
	 	cNomeBanco := "ITAU" 
		cNumBanco  := "341-7"
		cNumConta  := SUBSTR(SA6->A6_NUMCON,1,5) //Conta com 5 digitos sem o digito verificador
		cBiTMap    := "itau.jpg"
		cNumAgencia:= SUBSTR(SA6->A6_AGENCIA, 1, 4)
	Else
	    If EMPTY(SA6->A6_NUMBCO)
		   Aviso("AVISO","Não definido numero do banco no cadastro da conta "+SA6->A6_COD+"! Campo A6_NUMBCO Ex.: 341.",{"Sair"})
		Else
		   Aviso("AVISO","Numero do banco "+ALLTRIM(SA6->A6_NUMBCO)+" não homologado para impressão!",{"Sair"})
		EndIf
		Return Nil
	EndIf

	aDadosBanco  := {cNumBanco                                                 ,; 	// [1]Numero do Banco  Ex.: 341-7  
					cNomeBanco                                      	       ,; 	// [2]Nome do Banco
					cNumAgencia                              				   ,; 	// [3]Agência
					cNumConta                                                  ,; 	// [4]Conta Corrente sem o digito
					SA6->A6_DVCTA                                              ,; 	// [5]Dígito da conta corrente
					cCarteira                                                  ,;   // [6]Codigo da Carteira
					cBitMap                                                    }    // [7]bitmap

	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
		AllTrim(SA1->A1_MUN )                            ,;  		// [4]Cidade
		SA1->A1_EST                                      ,;     	// [5]Estado
		SA1->A1_CEP                                      ,;      	// [6]CEP
		SA1->A1_CGC										 ,;  		// [7]CGC
		SA1->A1_PESSOA									 }          // [8]PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)            	 ,;   	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA               ,;   	// [2]Código
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC) ,;   	// [3]Endereço
		AllTrim(SA1->A1_MUNC)	                             ,;   	// [4]Cidade
		SA1->A1_ESTC	                                     ,;   	// [5]Estado
		SA1->A1_CEPC                                         ,;   	// [6]CEP
		SA1->A1_CGC											 ,;		// [7]CGC
		SA1->A1_PESSOA										 }		// [8]PESSOA
	Endif
				
	nVlrTit := U_EFINA04S() //Retorna saldo do titulo com abatimentos        

	//"341-ITAU
	//Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo. 
	If Empty(SE1->E1_NUMBCO)
		cPrefixo := STR(VAL(RIGHT(RTRIM(SE1->E1_PREFIXO),1)),1)
		cParcela := STRZERO(VAL(RTRIM(SE1->E1_PARCELA)),2) //STR(VAL(AT(RTRIM(SE1->E1_PARCELA),"ABCDEFGHIJKLMNOPQRSTUVWXYZ")),1)
		cNNum := RIGHT(SE1->E1_NUM,6)+cParcela //cPrefixo+RIGHT(SE1->E1_NUM,6)+cParcela
	Else
		cNNum := Substr(SE1->E1_NUMBCO,4,8) //sem a carteira e digito
	EndIf
	dbSelectArea("SE1")

	//Monta codigo de barras
	aCB_RN_NN    := Ret_cBarra(LEFT(aDadosBanco[1],3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNNum,nVlrTit,E1_VENCTO,aDadosBanco[6])
	
	aDadosTit	:= {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		,;  // [1] Número do título
						E1_EMISSAO                          ,;  // [2] Data da emissão do título
						dDataBase                    		,;  // [3] Data da emissão do boleto
						E1_VENCTO                           ,;  // [4] Data do vencimento
						nVlrTit                             ,;  // [5] Valor do título
						aCB_RN_NN[3]                        ,;  // [6] Nosso número (Ver fórmula para calculo)
						E1_PREFIXO                          ,;  // [7] Prefixo da NF
						E1_TIPO	                           	,;  // [8] Tipo do Titulo
						AllTrim(Transform(nVlrTit* MVLJMULTA,"@E 999,999,999,999.99")) ,;   // [9] Multa valor (3% fixo)
						AllTrim(Transform(SE1->E1_VALJUR,"@E 999,999,999,999.99")),; // [10] Mora diaria / Juros (2% Fixo ao mês, 0,067 ao dia)
						GETMV("MV_LJMULTA")*100}        // [11] Multa percentual (3% Fixo)

	Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
	
	nX := nX + 1
	nI := nI + 1
	lImprime := .T.

	dbSelectArea("SE1")
	dbSkip()
EndDo

oPrint:Preview()     // Visualiza antes de imprimir

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Montes - THINKFAST    ³ Data ³ 10/07/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova página
          
/******************/
/* PRIMEIRA PARTE */
/******************/     
a := 8
nRow1 := -30
 
oPrint:Line (nRow1+0045-A,132,nRow1+0021-A, 132)
oPrint:Line (nRow1+0045-A,187,nRow1+0021-A, 187)

If !EMPTY(aDadosBanco[7]) .And. FILE(aDadosBanco[7])                      
    oPrint:SayBitmap( nRow1+0015,026,aDadosBanco[7],100,020)     // [7]Bitmap com Logo do Banco
Else
	oPrint:Say  (nRow1+0015,026,aDadosBanco[2],oFont14 )	  // [2]Nome do Banco
EndIf
oPrint:Say  (nRow1+0028,135,aDadosBanco[1],oFont21 )      // [1]Numero do Banco

oPrint:Say  (nRow1+0025,501,"Comprovante de Entrega",oFont10)
oPrint:Line (nRow1+0045-A,026,nRow1+0045-A,0606)

oPrint:Say  (nRow1+0045,026,"Beneficiário",oFont8) //Cedente
oPrint:Say  (nRow1+0060,026,aDadosEmp[1],oFont10)				//Nome + CNPJ

oPrint:Say  (nRow1+0045,0279,"Agência/Código Beneficiário",oFont8) //Agência/Código Cedente

oPrint:Say  (nRow1+0060,0279,aDadosBanco[3]+"/"+Alltrim(aDadosBanco[4])+"-"+aDadosBanco[5],oFont10)
oPrint:Say  (nRow1+0045,0398,"Nro.Documento",oFont8)
oPrint:Say  (nRow1+0060,0398,aDadosTit[1],oFont10) //Prefixo +Numero+Parcela
                           
oPrint:Say  (nRow1+0075,026,"Pagador",oFont8) //Sacado
oPrint:Say  (nRow1+0089,026,PADR(aDatSacado[1],30),oFont10)				//Nome

oPrint:Say  (nRow1+0075,0279,"Vencimento",oFont8)
oPrint:Say  (nRow1+0089,0279,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrint:Say  (nRow1+0075,0398,"Valor do Documento",oFont8)
oPrint:Say  (nRow1+0089,0408,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (nRow1+0119,0026,"Recebi(emos) o bloqueto/título",oFont10)
oPrint:Say  (nRow1+0134,0026,"com as características acima.",oFont10)
oPrint:Say  (nRow1+0104,0279,"Data",oFont8)
oPrint:Say  (nRow1+0104,0372,"Assinatura",oFont8)
oPrint:Say  (nRow1+0134,0279,"Data",oFont8)
oPrint:Say  (nRow1+0134,0372,"Entregador",oFont8)
                           
oPrint:Line (nRow1+0075-A,0026,nRow1+0075-A,0501 )
oPrint:Line (nRow1+0104-A,0026,nRow1+0104-A,0501 )
oPrint:Line (nRow1+0134-A,0277,nRow1+0134-A,0501 ) //---
oPrint:Line (nRow1+0164-A,0026,nRow1+0164-A,0606 )

oPrint:Line (nRow1+0164-A,0277,nRow1+0045-A,0277 )
oPrint:Line (nRow1+0164-A,0369,nRow1+0104-A,0369 )
oPrint:Line (nRow1+0104-A,0395,nRow1+0045-A,0395 ) //--
oPrint:Line (nRow1+0164-A,0501,nRow1+0045-A,0501 )

oPrint:Say  (nRow1+0049,0503,"(  )Mudou-se"                                	,oFont8)
oPrint:Say  (nRow1+0061,0503,"(  )Ausente"                                    ,oFont8)
oPrint:Say  (nRow1+0073,0503,"(  )Não existe nº indicado"                  	,oFont8)
oPrint:Say  (nRow1+0085,0503,"(  )Recusado"                                	,oFont8)
oPrint:Say  (nRow1+0097,0503,"(  )Não procurado"                              ,oFont8)
oPrint:Say  (nRow1+0109,0503,"(  )Endereço insuficiente"                  	,oFont8)
oPrint:Say  (nRow1+0121,0503,"(  )Desconhecido"                            	,oFont8)
oPrint:Say  (nRow1+0133,0503,"(  )Falecido"                                   ,oFont8)
oPrint:Say  (nRow1+0145,0503,"(  )Outros(anotar no verso)"                  	,oFont8)
         
/*****************/
/* SEGUNDA PARTE */
/*****************/
nRow2 := -30

//Pontilhado separador
For nI := 26 to 606 step 13
	oPrint:Line(nRow2+0173-a, nI,nRow2+0173-a, nI+8)
Next nI

oPrint:Line (nRow2+0212-a,026,nRow2+0212-a,606)
oPrint:Line (nRow2+0212-a,132,nRow2+0188-a,132)
oPrint:Line (nRow2+0212-a,187,nRow2+0188-a,187)

If !EMPTY(aDadosBanco[7]) .And. FILE(aDadosBanco[7])                      
    oPrint:SayBitmap( nRow2+0177,026,aDadosBanco[7],100,020)     // [7]Bitmap com Logo do Banco
Else
	oPrint:Say  (nRow2+0177,026,aDadosBanco[2],oFont14 )		// [2]Nome do Banco
EndIf
oPrint:Say  (nRow2+0195,135,aDadosBanco[1],oFont21 )	    // [1]Numero do Banco
oPrint:Say  (nRow2+0192,474,"Recibo do Pagador",oFont10)    //Sacado
                                           
oPrint:Line (nRow2+0241-a,026,nRow2+0241-a,0606 )
oPrint:Line (nRow2+0271-a,026,nRow2+0271-a,0606 )
oPrint:Line (nRow2+0292-a,026,nRow2+0292-a,0606 )
oPrint:Line (nRow2+0313-a,026,nRow2+0313-a,0606 )

oPrint:Line (nRow2+0271-a,132,nRow2+0313-a,132)
oPrint:Line (nRow2+0292-a,198,nRow2+0313-a,198)
oPrint:Line (nRow2+0271-a,263,nRow2+0313-a,263)
oPrint:Line (nRow2+0271-a,343,nRow2+0292-a,343)
oPrint:Line (nRow2+0271-a,390,nRow2+0313-a,390)

oPrint:Say  (nRow2+0212,026 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+0216,105 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO "+aDadosBanco[2],oFont10)
oPrint:Say  (nRow2+0228,105 ,"APÓS O VENCIMENTO, SOMENTE NO "+aDadosBanco[2],oFont10)

oPrint:Say  (nRow2+0212,477,"Vencimento"                                     ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)

nCol := 477+(99-(len(cString)*6))
oPrint:Say  (nRow2+0224,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0241,026 ,"Beneficiário"                                        ,oFont8) //Cedente
//oPrint:Say  (nRow2+0253,026 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
oPrint:Say  (nRow2+0250,026 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
oPrint:Say  (nRow2+0258,026 ,aDadosEmp[2]+" "+aDadosEmp[3]+" "+aDadosEmp[4]		,oFont10) //Endereço + CEP

oPrint:Say  (nRow2+0241,477,"Agência/Código Beneficiário",oFont8) //Agência/Código Cedente
cString := Alltrim(aDadosBanco[3]+"/"+Alltrim(aDadosBanco[4])+"-"+aDadosBanco[5])
nCol 	:= 477+(99-(len(cString)*6))
oPrint:Say  (nRow2+0253,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0271,026 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (nRow2+0280,026, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0271,133 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow2+0280,159 ,aDadosTit[1]						              ,oFont10) //Prefixo +Numero+Parcela
oPrint:Say  (nRow2+0271,265 ,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (nRow2+0280,277 ,"DM"												,oFont10) //Tipo do Titulo
                            
oPrint:Say  (nRow2+0271,0344,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow2+0280,0369,"N"                                              ,oFont10)

oPrint:Say  (nRow2+0271,0391,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow2+0280,0408,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0271,0477,"Nosso Número"                                   ,oFont8)
cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
nCol := 477+(99-(len(cString)*6))
oPrint:Say  (nRow2+0280,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0292,026 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow2+0292,133 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow2+0301,146 ,aDadosBanco[6]                                   ,oFont10)

oPrint:Say  (nRow2+0292,199 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow2+0301,212 ,"R$"                                             ,oFont10)
                           
oPrint:Say  (nRow2+0292,0265,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow2+0292,0391,"Valor"                                          ,oFont8)

oPrint:Say  (nRow2+0292,0477,"Valor do Documento"                          	  ,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 477+(99-(len(cString)*6))
oPrint:Say  (nRow2+0301,nCol,cString ,oFont11c)
                      
oPrint:Say  (nRow2+0313,026 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiário)",oFont8) //cedente
oPrint:Say  (nRow2+0343,026 ,aBolText[1]+"R$ "+AllTrim(aDadosTit[9])+" e "+aBolText[2]+" "+AllTrim(aDadosTit[10])      ,oFont10) 

//cBitMap:= "\imagens\logoempresa.PNG"
//oPrint:SayBitmap(nRow2+0319,0356,cBitMap,0128,089)

oPrint:Say  (nRow2+0358,026 ,"** VALORES EXPRESSOS EM REAIS **",oFont10)                        
//oPrint:Say  (nRow2+0358,026 ,"Sujeito a Protesto senao for pago no Vencimento",oFont10)
//oPrint:Say  (nRow2+0373,026 ,"Cobranca Escritural",oFont10)

oPrint:Say  (nRow2+0313,0477,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow2+0334,0477,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (nRow2+0355,0477,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow2+0376,0477,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (nRow2+0397,0477,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow2+0417,026 ,"Pagador"                                        ,oFont8) //Sacado
oPrint:Say  (nRow2+0426,105 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont8)
oPrint:Say  (nRow2+0438,105 ,aDatSacado[3]                                    ,oFont8)
oPrint:Say  (nRow2+0453,105 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont8) // CEP+Cidade+Estado

if aDatSacado[8] = "J"
	oPrint:Say  (nRow2+0468,105 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont8) // CGC
Else
	oPrint:Say  (nRow2+0468,105 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont8) 	// CPF
EndIf

oPrint:Say  (nRow2+0468,1850,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)

oPrint:Say  (nRow2+0481,0026,"Pagador/Avalista: ",oFont8) //Sacador
oPrint:Say  (nRow2+0496,0395,"Autenticação Mecânica",oFont8)

oPrint:Line (nRow2+0212-a,474,nRow2+0417-a,0474 ) 
oPrint:Line (nRow2+0334-a,474,nRow2+0334-a,0606 )
oPrint:Line (nRow2+0355-a,474,nRow2+0355-a,0606 )
oPrint:Line (nRow2+0376-a,474,nRow2+0376-a,0606 )
oPrint:Line (nRow2+0397-a,474,nRow2+0397-a,0606 )
oPrint:Line (nRow2+0417-a,026,nRow2+0417-a,0606 )
oPrint:Line (nRow2+0492-a,026,nRow2+0492-a,0606 )

/******************/
/* TERCEIRA PARTE */
/******************/
nRow3 := -30

For nI := 26 to 606 step 13
	oPrint:Line(nRow3+560-a, nI, nRow3+560-a, nI+8)
Next nI

oPrint:Line (nRow3+0596-a,026,nRow3+0596-a,606)
oPrint:Line (nRow3+0596-a,132,nRow3+0572-a,132)
oPrint:Line (nRow3+0596-a,187,nRow3+0572-a,187)

If !EMPTY(aDadosBanco[7]) .And. FILE(aDadosBanco[7])                      
    oPrint:SayBitmap( nRow3+0562,026,aDadosBanco[7],100,020)     // [7]Bitmap com Logo do Banco
Else
	oPrint:Say  (nRow3+0562,026,aDadosBanco[2],oFont14 )		// 	[2]Nome do Banco
EndIf
oPrint:Say  (nRow3+0580,135,aDadosBanco[1],oFont21 )	    // 	[1]Numero do Banco
oPrint:Say  (nRow3+0577,199,aCB_RN_NN[2],oFont15n)			//		Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+0626-a,026,nRow3+0626-a,606 )
oPrint:Line (nRow3+0656-a,026,nRow3+0656-a,606 )
oPrint:Line (nRow3+0677-a,026,nRow3+0677-a,606 )
oPrint:Line (nRow3+0698-a,026,nRow3+0698-a,606 )

oPrint:Line (nRow3+0656-a,132,nRow3+0698-a,132 )
oPrint:Line (nRow3+0677-a,198,nRow3+0698-a,198 )
oPrint:Line (nRow3+0656-a,263,nRow3+0698-a,263 )
oPrint:Line (nRow3+0656-a,343,nRow3+0677-a,343 )
oPrint:Line (nRow3+0656-a,390,nRow3+0698-a,390 )

oPrint:Say  (nRow3+0596,026,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+0601,105 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO "+aDadosBanco[2],oFont10)
oPrint:Say  (nRow2+0613,105 ,"APÓS O VENCIMENTO, SOMENTE NO "+aDadosBanco[2],oFont10)
           
oPrint:Say  (nRow3+0596,477,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 477+(99-(len(cString)*6))
oPrint:Say  (nRow3+0608,nCol,cString,oFont11c)
                       
oPrint:Say  (nRow3+0626,026,"Beneficiário",oFont8) //Cedente
//oPrint:Say  (nRow3+0638,026,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
oPrint:Say  (nRow3+0635,026 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
oPrint:Say  (nRow3+0643,026 ,aDadosEmp[2]+" "+aDadosEmp[3]+" "+aDadosEmp[4]		,oFont10) //Endereço + CEP

oPrint:Say  (nRow3+0626,477,"Agência/Código Beneficiário",oFont8) //Cedente
If ALLTRIM(SA6->A6_NUMBCO) == "422"
	cString := Alltrim(aDadosBanco[3]+"/"+Alltrim(aDadosBanco[4])+aDadosBanco[5])
Else
	cString := Alltrim(aDadosBanco[3]+"/"+Alltrim(aDadosBanco[4])+"-"+aDadosBanco[5])
EndIf
nCol 	 := 477+(99-(len(cString)*6))
oPrint:Say  (nRow3+0638,nCol,cString ,oFont11c)


oPrint:Say  (nRow3+0656,026 ,"Data do Documento"                              ,oFont8)
oPrint:Say (nRow3+0665,026, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


oPrint:Say  (nRow3+0656,133 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow3+0665,159 ,aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+0656,0265,"Espécie Doc."										,oFont8)
oPrint:Say  (nRow3+0665,0277,"DM"												,oFont10) //Tipo do Titulo
                       
oPrint:Say  (nRow3+0656,0344,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow3+0665,0369,"N"                                             ,oFont10)

oPrint:Say  (nRow3+0656,0391,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow3+0665,0408,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow3+0656,0477,"Nosso Número"                                   ,oFont8)
cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
nCol 	 := 477+(99-(len(cString)*6))
oPrint:Say  (nRow3+0665,nCol,cString,oFont11c)


oPrint:Say  (nRow3+0677,026 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow3+0677,133 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow3+0686,146 ,aDadosBanco[6]                                	  ,oFont10)
                       
oPrint:Say  (nRow3+0677,199 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow3+0686,212 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow3+0677,0265,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow3+0677,0391,"Valor"                                          ,oFont8)

oPrint:Say  (nRow3+0677,0477,"Valor do Documento"                          	  ,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 477+(99-(len(cString)*6))
oPrint:Say  (nRow3+0686,nCol,cString,oFont11c)
                    
oPrint:Say  (nRow3+0698,026 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiário)",oFont8) //cedente
oPrint:Say  (nRow3+0727,026 ,aBolText[1]+"R$ "+AllTrim(aDadosTit[9])+" e "+aBolText[2]+" "+AllTrim(aDadosTit[10])   ,oFont10)  
oPrint:Say  (nRow2+0742,026 ,"** VALORES EXPRESSOS EM REAIS **",oFont10)
//oPrint:Say  (nRow2+0742,026 ,"Sujeito a Protesto senao for pago no Vencimento",oFont10)
//oPrint:Say  (nRow2+0757,026 ,"Cobranca Escritural",oFont10)

oPrint:Say  (nRow3+0698,477,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow3+0718,477,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (nRow3+0739,477,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow3+0760,477,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (nRow3+0781,477,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow3+0802,026 ,"Pagador"                                        ,oFont8) //Sacado
oPrint:Say  (nRow3+0805,105 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont8)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+0805,0461,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont8) // CGC
Else
	oPrint:Say  (nRow3+0805,0461,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont8) 	// CPF
EndIf

oPrint:Say  (nRow3+0817,105,aDatSacado[3]                                    ,oFont8)
oPrint:Say  (nRow3+0829,105,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont8) // CEP+Cidade+Estado
oPrint:Say  (nRow3+0829,461,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont8)

If LEFT(aDadosBanco[1],3) == "422"
    oPrint:Say  (nRow3+0842,026,"Sacador/Avalista: ",oFont8) //Sacador
Else
	oPrint:Say  (nRow3+0842,026,"Pagador/Avalista: ",oFont8) //Sacador
EndIf
oPrint:Say  (nRow3+0856,395,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont8)

oPrint:Line (nRow3+0596-a,474,nRow3+0802-a,474)
oPrint:Line (nRow3+0718-a,474,nRow3+0718-a,606)
oPrint:Line (nRow3+0739-a,474,nRow3+0739-a,606)
oPrint:Line (nRow3+0760-a,474,nRow3+0760-a,606)
oPrint:Line (nRow3+0781-a,474,nRow3+0781-a,606)
oPrint:Line (nRow3+0802-a,026,nRow3+0802-a,606)

oPrint:Line (nRow3+0853-a,026,nRow3+0853-a,606)
  
MSBAR3("INT25",7.00,0.20,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.005,0.325,Nil,Nil,"A",.F.)

dbSelectArea("SE1")
RecLock("SE1",.F.)
SE1->E1_PORTADO := SA6->A6_COD
SE1->E1_NUMBCO 	:= aCB_RN_NN[3]   // Nosso número (Ver fórmula para calculo)
SE1->E1_CODBAR  := aCB_RN_NN[1]
SE1->E1_CODDIG  := STRTRAN(STRTRAN(aCB_RN_NN[2],".","")," ","") // Retira espacos e pontos da linha digitaval para gravação
MsUnlock()

oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Montes                ³ Data ³ 10/07/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Montes                ³ Data ³ 10/07/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ORTOSINTESE                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ MONTES                ³ Data ³ 10/07/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ORTOSINTESE                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto,cCart)

LOCAL cValorFinal := strzero(int(nValor*100),10)
LOCAL nDvnn			:= 0
LOCAL nDvcb			:= 0
LOCAL nDv			:= 0
LOCAL cNN			:= '' //Nosso Numero
LOCAL cRN			:= '' //Linha Digitavel
LOCAL cCB			:= '' //Codigo de Barra
LOCAL cS			:= ''
LOCAL cCpoLivre     := '' // 25 posições de Campo Livre
LOCAL cFator        := strzero(dVencto - ctod("07/10/97"),4)
//LOCAL cConvenio		:= SEE->EE_CODEMP
//-----------------------------
// Definicao do NOSSO NUMERO
// ----------------------------
cS    := cAgencia + cConta + cCart + cNroDoc    //11112222233344444444 (20 digitos)
nDvnn := modulo10(cS) // digito verifacador Agencia + Conta + Carteira + Nosso Num
cNN   := cCart + cNroDoc + '-' + AllTrim(Str(nDvnn))

//----------------------------------
//	 Definicao do CODIGO DE BARRAS
//----------------------------------                               
cCpoLivre := Subs(cNN,1,11) + Subs(cNN,13,1) + cAgencia + cConta + cDacCC + '000'
cS    := cBanco + cFator +  cValorFinal + cCpoLivre
nDvcb := modulo11(cS)
cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,25) + AllTrim(Str(nDvnn)) + SubStr(cS,31)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//341-ITAU
   
   //	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
   //	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

   // 	CAMPO 1:
   //	AAA	= Codigo do banco na Camara de Compensacao
   //	  B = Codigo da moeda, sempre 9
   //	CCC = Codigo da Carteira de Cobranca
   //	 DD = Dois primeiros digitos no nosso numero
   //	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

   cS    := cBanco + cCart + SubStr(cNroDoc,1,2)
   nDv   := modulo10(cS)
   cRN   := SubStr(cS, 1, 5) + '.' + SubStr(cS, 6, 4) + AllTrim(Str(nDv)) + '  '      

   // 	CAMPO 2:
   //	DDDDDD = Restante do Nosso Numero
   //	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
   //	   FFF = Tres primeiros numeros que identificam a agencia
   //	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

   cS    := Subs(cNN,6,6) + Alltrim(Str(nDvnn))+ Subs(cAgencia,1,3)
   nDv   := modulo10(cS)
   cRN   := Subs(cBanco,1,3) + "9" + Subs(cCart,1,1)+'.'+ Subs(cCart,2,3) + Subs(cNN,4,2) + SubStr(cRN,11,1)+ ' '+  Subs(cNN,6,5) +'.'+ Subs(cNN,11,1) + Alltrim(Str(nDvnn))+ Subs(cAgencia,1,3) +Alltrim(Str(nDv)) + ' ' 

   // 	CAMPO 3:
   //	     F = Restante do numero que identifica a agencia
   //	GGGGGG = Numero da Conta + DAC da mesma
   //	   HHH = Zeros (Nao utilizado)
   //	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
   cS    := Subs(cAgencia,4,1) + Subs(cConta,1,4) +  Subs(cConta,5,1)+Alltrim(cDacCC)+'000'
   nDv   := modulo10(cS)
   cRN   := cRN + Subs(cAgencia,4,1) + Subs(cConta,1,4) +'.'+ Subs(cConta,5,1)+Alltrim(cDacCC)+'000'+ Alltrim(Str(nDv))

   //	CAMPO 4:
   //	     K = DAC do Codigo de Barras
   cRN   := cRN + ' ' + AllTrim(Str(nDvcb)) + '  '

   // 	CAMPO 5:
   //	      UUUU = Fator de Vencimento 
   //	VVVVVVVVVV = Valor do Titulo
   cRN   := cRN + cFator + StrZero(Int(nValor * 100),14-Len(cFator))

Return({cCB,cRN,cNN})

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Modulo11B7³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo do digito Modulo 11 com Base 7                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11b7(cData) //Modulo 11 com base 7

LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
DV:= " "

While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 7   //Volta para o inicio, ou seja comeca a multiplicar por 2,3,4...
		P := 1
	End
	L := L - 1
End

if D >=11
	_nResto := mod(D,11)  //Resto da Divisao
	//D := 11 - (mod(D,11)) // Diferenca 11 (-) Resto da Divisao
	D := 11 - _nResto
	DV:=ALLTRIM(STR(D))
endif 

If _nResto == 0
	DV := "0"
End
If _nResto == 1
	DV := "P"
End

Return(DV)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EFINA04S ºAutor  ³Marcos A. Montes    º Data ³  10/07/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Recalcula o saldo do titulo considerando os abatimentos     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ORTOSINTESE                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EFINA04S()

Local nSaldo   := SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE 
Local nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

nSaldo := ROUND(nSaldo - nVlrAbat,2)

Return(nSaldo)

///////////////////////////////////////////////////////////////
// SELECIONA O BANCO QUANDO NAO POSSUI E1_PORTADO PREENCHIDO //
///////////////////////////////////////////////////////////////
Static Function SelBanco()

Local cContas  := SPACE(20)
Local aContas  := {}
Local nConta   := 1
//Local lFound   := .T.                                 
Local lOk      := .F.                                 
Local oChecked	:= LoadBitmap( GetResources() ,"CHECKED"  )
Local oUnChecked := LoadBitmap( GetResources() ,"UNCHECKED" )

dbSelectArea("SEE")
dbGoTop()
While !EOF()
	SA6->(dbSeek(xFilial("SA6")+SEE->EE_CODIGO+SEE->EE_AGENCIA+SEE->EE_CONTA))
	AADD(aContas,{ PADR(SEE->EE_CODIGO,3), PADR(SEE->EE_AGENCIA,5), PADR(SEE->EE_CONTA,10), SA6->A6_NOME, PADR(SEE->EE_CODIGO,3)+"|"+PADR(SEE->EE_AGENCIA,5)+"|"+PADR(SEE->EE_CONTA,10) } )
	dbSkip()     
EndDo

/*
dbSelectArea("SX6")
dbSetOrder(1)
If (lFound := dbSeek("  "+"MV_XBOLETO"))
   cBanco   := SUBSTR(SX6->X6_CONTEUD,1,3)
   cAgencia := SUBSTR(SX6->X6_CONTEUD,4,5)
   cConta   := SUBSTR(SX6->X6_CONTEUD,9,10)
EndIf
*/
cConteudo := GETMV("MV_XBOLETO")
cBanco    := SUBSTR(cConteudo,1,3)
cAgencia  := SUBSTR(cConteudo,4,5)
cConta    := SUBSTR(cConteudo,9,10)

cContas := cBanco+"|"+cAgencia+"|"+cConta
nPos := ASCAN(aContas,{|x|x[5]=cContas})
If nPos > 0
   nConta := nPos
EndIf   

DEFINE MSDIALOG oPadraoDlg TITLE OemToAnsi("Seleciona Conta padrão para impressão Boleto") From 81,107 To 347,788 OF oMainWnd PIXEL

//@ 13,003 TO 095,337 OF oPadraoDlg PIXEL
                                                              
@ 16,05 LISTBOX oContas Var cContas FIELDS HEADER ;
           OemToAnsi(" "),;
           OemToAnsi("Banco"),;
           OemtoAnsi("Agencia"),;
           OemtoAnsi("Conta"),;
           OemtoAnsi("Nome") FIELDSIZES 10,30,30,50,100 SIZE 330,080;       //370
           ON DBLCLICK(nConta:=oContas:nAt,oContas:Refresh()) OF oPadraoDlg PIXEL

oContas:nFreeze := 0
oContas:SetArray(aContas)
oContas:bLine:={ ||{ IIF(oContas:nAT=nConta,oChecked,oUnChecked),;
                     aContas[oContas:nAT,1],;
                     aContas[oContas:nAT,2],;
                     aContas[oContas:nAT,3],;
                     aContas[oContas:nAT,4] }}      
oContas:nAt := 1
                         
DEFINE SBUTTON FROM 108,134.6 TYPE 1 ACTION (lOk := .T.,oPadraoDlg:End()) ENABLE OF oPadraoDlg
DEFINE SBUTTON FROM 108,170.6 TYPE 2 ACTION (lOk := .F.,oPadraoDlg:End()) ENABLE OF oPadraoDlg

ACTIVATE MSDIALOG oPadraoDlg CENTERED
                                             
If lOk = .T.
   PutMv("MV_XBOLETO",STRTRAN(aContas[nConta,5],"|","")) //cBanco+cAgencia+cConta
   /*
   If !lFound 
      Reclock("SX6",.T.)
      SX6->X6_FIL     := "  "           
      SX6->X6_VAR     := "MV_XBOLETO" 
      SX6->X6_TIPO    := "C"
      SX6->X6_DESCRIC := "Conta padrao para Emissao de Boleto Empresa"
      SX6->X6_DESC1   := "BANCO+AGENCIA+CONTA (CHAVE DO SA6/SEE)"
      SX6->X6_PROPRI  := "U"
      SX6->X6_PYME    := "N"
   Else
      Reclock("SX6",.F.)   
   EndIf
   SX6->X6_CONTEUD := STRTRAN(aContas[nConta,5],"|","") //cBanco+cAgencia+cConta
   MsUnLock()
   */
   cBanco   := SUBSTR(SX6->X6_CONTEUD,1,3)
   cAgencia := SUBSTR(SX6->X6_CONTEUD,4,5)
   cConta   := SUBSTR(SX6->X6_CONTEUD,9,10)
Else
	Return Nil
EndIf

Return({cBanco,cAgencia,cConta})
