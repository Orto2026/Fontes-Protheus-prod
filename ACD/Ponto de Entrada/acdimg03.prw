/*
Padrao Zebra
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMG03     ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de dispositivo de movi- º±±
±±º          ³mentacao.(carrinho)                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img03() // imagem de etiqueta de dispositivo de movimentacao
Local cCodigo
Local nID := paramixb[1]
IF nID # NIL
	cCodigo := nID
ElseIf Empty(CB2->CB2_IDETIQ)
	IF UsaCB0("03")
		cCodigo := CBGrvEti('03',{CB2->CB2_DISPID})
		RecLock("CB2",.F.)
		CB2->CB2_IDETIQ := cCodigo
		MsUnlock()
	Else
		cCodigo := CB2->CB2_DISPID
	EndIf
Else
	IF UsaCB0("03")
		cCodigo := CB2->CB2_IDETIQ
	Else
		cCodigo := CB2->CB2_DISPID
	EndIf
Endif
cCodigo := Alltrim(cCodigo)
MSCBLOADGRF("SIGA.GRF")
MSCBBEGIN(1,6)
MSCBBOX(30,05,76,05)
MSCBBOX(02,12.7,76,12.7)
MSCBBOX(02,21,76,21)
MSCBBOX(30,01,30,12.7,3)
MSCBGRAFIC(2,3,"SIGA")
MSCBSAY(33,02,'DISP.MOVIMENT',"N","0","025,035",,,,,.t.)
MSCBSAY(33,06,"CODIGO","N","A","012,008")
MSCBSAY(33,08, CB2->CB2_DISPID, "N", "0", "032,035")
MSCBSAY(05,14,"DESCRICAO","N","A","012,008")
MSCBSAY(05,17,Tabela('J0',CB2->CB2_TIPO),"N", "0", "020,030")
MSCBSAYBAR(23,22,cCodigo,"N","MB07",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.) 
MSCBInfoEti("Disp.Moviment.","30X100")
MSCBEND()
Return .F.



//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Rotina    | Img03A  | Samuel Miranda               | Data | 22/04/2024 |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Descricao | Ponto de entrada para a impressão da etiqueta de separação.|±±

User Function Img03A()
//Paramentros
Local dDateDe 	:= Paramixb[1]//Data Inicial
Local dDateAte 	:= Paramixb[2]//Data Final
Local cClide    := Paramixb[3]//Cliente Inicial
Local cCliAte   := Paramixb[4]//Cliente Final
Local xMercado  := Paramixb[5]//Mercado 
Local OrdSepDe  := Paramixb[6]//Ordem de separação Iniciial
Local OrdSepAte := Paramixb[7]//Ordem de separação Final
Local nNotaDe   := Paramixb[8]//Nota fical inicial
Local nNotaAte  := Paramixb[9]//Nota fical Final
//Variaveis locais
Local nRec			:= 0
Local cTpFonte 		:= "0"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "025,025"
Local cFonte5 		:= "035,035"
Local cFonte6 		:= "040,040"
Local cFonte7 		:= "073,073"
Local nCol			:= 04
Local nlin			:= 04
Local _xMercado		:= cValtochar(xMercado)
Local cCodCli 		:= "" //
Local cCondPgt 		:= "" //
Local cQuery 		:= ""
Local nCopias 		:= 1

//Cria a consulta em sql.
cQuery := "SELECT " + CHR(13)+CHR(10)
cQuery += "DISTINCT CB7.CB7_CLIENT AS CODCLI ," + CHR(13)+CHR(10)
cQuery += "CB7.CB7_LOJA," + CHR(13)+CHR(10)
cQuery += "CB8.CB8_PEDIDO AS NUMPED," + CHR(13)+CHR(10)
cQuery += "CB7.CB7_ORDSEP AS SEPARACAO," + CHR(13)+CHR(10)
cQuery += "CB7.CB7_NOTA AS NUMNF," + CHR(13)+CHR(10)
cQuery += "CB7.CB7_DTEMIS AS EMISSAO," + CHR(13)+CHR(10)
cQuery += "CB7.CB7_COND AS CONPGTO," + CHR(13)+CHR(10)
cQuery += "SA1.A1_NREDUZ AS NOMCLI," + CHR(13)+CHR(10)
cQuery += "CASE" + CHR(13)+CHR(10)
cQuery += "	WHEN SC5.C5_CLASPED = '1' THEN 'M. INTERNO' " + CHR(13)+CHR(10)
cQuery += "	WHEN SC5.C5_CLASPED = '2' THEN 'M. CAIXAS'  " + CHR(13)+CHR(10)
cQuery += "	WHEN SC5.C5_CLASPED = '4' THEN 'M. EXP'  " + CHR(13)+CHR(10)
cQuery += "	WHEN SC5.C5_CLASPED = '5' THEN 'DIVERSOS' " + CHR(13)+CHR(10)
cQuery += "ELSE ''  " + CHR(13)+CHR(10)
cQuery += "	END AS CLASS_PEDIDO " + CHR(13)+CHR(10)
cQuery += "FROM " + CHR(13)+CHR(10)
cQuery += RetSqlName('CB7010 ') + " CB7 " + CHR(13)+CHR(10)
cQuery += " INNER JOIN CB8010 CB8 ON CB8.CB8_ORDSEP = CB7.CB7_ORDSEP AND CB8.CB8_LOCAL = CB7.CB7_LOCAL AND CB8.D_E_L_E_T_=' ' " + CHR(13)+CHR(10)
cQuery += " INNER JOIN SC5010 SC5 ON SC5.C5_NUM = CB8.CB8_PEDIDO  AND SC5.C5_LOJACLI= CB8.CB8_LOCAL  AND   SC5.D_E_L_E_T_=' '" + CHR(13)+CHR(10)
cQuery += " INNER JOIN SA1010 SA1 ON SA1.A1_COD = CB7.CB7_CLIENT AND  SA1.A1_LOJA = CB7.CB7_LOJA AND SA1.D_E_L_E_T_=''" + CHR(13)+CHR(10)
cQuery += " WHERE  " + CHR(13)+CHR(10)
cQuery += "CB7.CB7_DTEMIS BETWEEN '" + DTOS(dDateDe) + "' AND '"+ DTOS(dDateAte) +"' AND "+CHR(13)+CHR(10)// Data da Separaçao De.
cQuery += "CB7.CB7_CLIENT BETWEEN '"+ cClide +"' AND '"+ cCliAte +"' "+CHR(13)+CHR(10) //Cliente    //CB7_ORDSEP BETWEEN '053710' AND '053710'
cQuery += "AND CB7.CB7_ORDSEP BETWEEN '"+ OrdSepDe +"' AND '"+ OrdSepAte +"' "+CHR(13)+CHR(10) //Número da Ordem De
cQuery += "AND CB7.CB7_NOTA   BETWEEN '"+ nNotaDe +"' AND '"+ nNotaAte +"' "+CHR(13)+CHR(10) 
cQuery += "AND CB7.CB7_STATUS = 0 " + CHR(13)+CHR(10) 
cQuery += "AND SC5.C5_CLASPED = '"+ _xMercado +"' " + CHR(13)+CHR(10) //Mercado
cQuery += "ORDER BY CB7.CB7_ORDSEP " + CHR(13)+CHR(10)
//Salva o resultado da query
MemoWrite("REST37A.SQL", cQuery )
cQuery := ChangeQuery(cQuery)
//
dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery ), "QRY" , .T. , .F. )	
dbSelectArea( "QRY" )
dbGotop()
QRY->(dbEval({ || nRec++ },,{||!Eof()} ))
dbGoTop()	
	//Verifica se truxe registro na consulta.
	If nRec == 0
		dbSelectArea("QRY")
		dbCloseArea()
		Alert("Ordens não encontrada!." ,"Verifique !")
		Return()
	Endif
	//Seleciona o Alias	 QRY
	DbSelectArea("QRY")
	DbGotop()//Posiciona do primeiro registro

	//Seleciona o Alias	 SF2
	DbSelectArea("SF2")  // CABEÇALHO DAS NF DE SAÍDA
    SF2->(DbSetOrder(1))  //F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA + F2_FORMUL + F2_TIPO
	//MSCBLOADGRF("SIGA.GRF")
	//Entra no laço
	While !QRY->(Eof())
		//Verifica a configuração do mercado
		If _xMercado <> "2" 
			//Variaveis 
			nSalto	  := 0  //Varivél para forçar a impressão e uma nova etiqueta
			nCol      := 04 //Número de colunas (total são 8, 4 de um lado e 4 de outro)
			nlin	  := 18 //Número total de linhas impressas
			cCodCli   := QRY->CODCLI //Codigo do Cliente
			cCondPgt  := QRY->CONPGTO //Codigo da Condição de Pagamento

			MSCBBEGIN(1,6)
			MSCBBOX(001,002,100,057,6)// Box da Borda
			//Entra no laço para impressão das etiquetas.
			While !QRY->(Eof()) .AND. cCodCli == QRY->CODCLI .AND. cCondPgt == QRY->CONPGTO
																				
				//MSCBSAY(25,04,"ETQ. DE SEPARAÇÃO"													,"N",cTpFonte,cFonte6)//Titulo da etiqueta
				MSCBSAY(04,04,+Alltrim(Upper(QRY->CODCLI))+" - "+Alltrim(QRY->CONPGTO)				,"N",cTpFonte,cFonte5)
				If !Empty(QRY->NUMNF)
					MSCBSAY(40,04,+dToc(Posicione("SF2",1,xFilial("SF2")+QRY->NUMNF,"F2_EMISSAO"))	,"N",cTpFonte,cFonte6)
				EndIf
				MSCBSAY(76,04,+alltrim(Upper(QRY->CLASS_PEDIDO)	)									,"N",cTpFonte,cFonte5)
				MSCBSAY(01,06,replicate("..",56)													,"N",cTpFonte,cFonte3)
				MSCBSAY(04,09," " + Alltrim(Upper(QRY->NOMCLI))										,"N",cTpFonte,cFonte7)
				MSCBLINEH(001,017,100,003,"B") //Linha horizontal
				//Faz a impressão conforma quantidade de registros		
				if nSalto >= 04
					nCol    := 50
					if nSalto == 08 // Aqui encerra a impressão enviar para o buffer e imprime o outro lado da eitueta
						MSCBEND()
						nSalto	:= 0
						nCol    := 04
						nlin	:= 18
						//MSCBPRINTER(cImpressora,cPorta)
						MSCBCHKStatus(.F.)
						MSCBBEGIN(nCopias,4)
						MSCBBOX(001,002,100,057,6)
					EndIf
					if nSalto == 04
						nlin	:= 18
					Endif
					MSCBLINEV(48,17,57,4)// Linha na Vertical 
				Endif 
				//Número do pedido
				MSCBSAY(nCol,nlin,"" +Alltrim(QRY->NUMPED)				,"N",cTpFonte,cFonte5)
				//Número da Nota Fiscal
				MSCBSAY(nCol,nlin+5,"" +Alltrim(QRY->NUMNF)				,"N",cTpFonte,cFonte4)
				//Núemro da Ordem de Separação
				MSCBSAYBAR(nCol+17,nlin,Alltrim(Upper(QRY->SEPARACAO)) 	,"N","MB07",5,.F.,.T.,.F.,,2,1,.F.)			
				//Incrementa as variaveis
				nlin	+=10		
				nSalto  +=1		
				QRY->(dbskip())
			Enddo	
			
			MSCBInfoEti("Eti. Separação","50X100")
			MSCBEND()
			//Inicializa as variaveis
			//cCodCli :=""
			nCol    := 0
			nlin	:= 0		
		 Else
			//Impressão das etiquetas de caixa, uma por etiqueta
			nSalto	:= 0
			nCol    := 04
			nlin	:= 18
			cCodCli := QRY->CODCLI
			//MSCBPRINTER(cImpressora,cPorta)
			MSCBCHKStatus(.F.)
			MSCBBEGIN(nCopias,4)

			MSCBBOX(001,002,100,057,6)// Box da Borda
			MSCBSAY(04,04,"" + Alltrim(Upper(QRY->CODCLI))+" - "+Alltrim(QRY->CONPGTO)		,"N",cTpFonte,cFonte5)//Codigo do Cliente
			If !Empty(QRY->NUMNF)
				MSCBSAY(40,04,+dToc(Posicione("SF2",1,xFilial("SF2")+QRY->NUMNF,"F2_EMISSAO") )	,"N",cTpFonte,cFonte6)//Posiciona a data de emissão da nota fiscal.
			EndIf
			MSCBSAY(76,04,""+ QRY->CLASS_PEDIDO												,"N",cTpFonte,cFonte5)//Classificação do pedido
			MSCBSAY(01,06,replicate("..",55)												,"N",cTpFonte,cFonte3)//Imprimi uma linha 
			MSCBSAY(04,09," " + Alltrim(Upper(QRY->NOMCLI))									,"N",cTpFonte,cFonte7)//Nome reduzido do Cliente
			MSCBLINEH(001,017,100,003,"B") //Linha horizontal
			//Número do Pedido
			MSCBSAY(nCol,nlin+2,"" +Alltrim(QRY->NUMPED)			 						,"N",cTpFonte,cFonte7)//Número do Pedido
			//Número da Nota Fiscal
			MSCBSAY(nCol,nlin+10,"NF.: " +Alltrim(QRY->NUMNF)				 				,"N",cTpFonte,cFonte5)//Número da Nota Fiscal
			MSCBSAYBAR(nCol+36,nlin+2,Alltrim(Upper(QRY->SEPARACAO)),"N","MB07",5,.F.,.T.,.F.,,4,2,.F.)	//Função para impressão do codigo de barras.
			MSCBSAY(nCol,nlin+20,Upper(mv_par10)		 		     						,"N",cTpFonte,cFonte7)		
			
			MSCBInfoEti("Eti. Separação","50X100")
			MSCBEND()
			//Inicializa as variaveis
			nCol    := 0
			nlin	:= 0
			QRY->(DbSkip())
		EndIf
	Enddo
	QRY->(DbcloseArea())
Return()
