#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "MATR730.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR02  ³ Revis.³ Samuel Miranda        ³ Data ³ 29/11/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressão do Pedido de Venda							      ³±±
±±³          ³														      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR02()

Private cPerg		:= "PED"
Private nItPg		:= 14 // NUMERO DE ITENS POR PAGINAS
Private aMes		:= {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
Private lPreVale	:= .f.
Private lValido		:= .t.
CriaSX1(cPerg)                                                   '

Pergunte(cPerg,.T.)

Processa({|| MontaPed()})

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MontaPed ³ Revis. ³ Samuel Miranda	    ³ Data ³ 29/11/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Montagem do Pedido                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Ortosintese                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaPed()
Local cQuery		:= ""
Local cQueryOrd		:= ""
Local nRec			:= 0
Local aPrtLi		:= {}
Local aPrtIt		:= {}
Local aCabec		:= {}
Local Folha 		:= 0
Local Folhas 		:= 0
Local i				:= 0
Local j				:= 0
Local k				:= 0
Local _nI			:= 0
_nTotGeral 			:= 0 //SAMUEL
_nIpiGeral   		:= 0 //SAMUEL
_nPesoGeral			:= 0
_nIcmGeral			:= 0
PRIVATE oPrint

cQuery		:= "SELECT "+CHR(13)+CHR(10)
cQuery		+= 		"DISTINCT(SC5.R_E_C_N_O_ ) REG "+CHR(13)+CHR(10)
cQuery		+= "FROM  "+CHR(13)+CHR(10)
cQuery		+= 		RetSqlName("SC5")+" SC5 "+CHR(13)+CHR(10)
cQuery		+= "WHERE  "+CHR(13)+CHR(10)
cQuery		+= 		"SC5.D_E_L_E_T_ = ' ' AND "+CHR(13)+CHR(10)
cQuery		+= 		"SC5.C5_FILIAL = '"+cFilAnt+"' AND "+CHR(13)+CHR(10)
cQuery		+= 		"SC5.C5_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "+CHR(13)+CHR(10)
cQuery		+= 		"SC5.C5_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "+CHR(13)+CHR(10)
cQuery		+= 		"SC5.C5_CLIENT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "+CHR(13)+CHR(10)
cQuery		+= 		"SC5.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "+CHR(13)+CHR(10)
cQueryOrd	+= "ORDER BY "+CHR(13)+CHR(10)
cQueryOrd	+= 	"1 "+CHR(13)+CHR(10)

MemoWrite("PEDS.SQL", cQuery + cQueryOrd)

If Select("PEDS") > 0
	dbSelectArea("PEDS")
	dbCloseArea()
EndIf

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery + cQueryOrd ), "PEDS", .T., .T. )

TcSetField("PEDS","RECNO"		,"N",10,0)

dbSelectArea( "PEDS" )
dbGotop()
PEDS->(dbEval({ || nRec++ },,{||!Eof()} ))
dbGoTop()

If nRec == 0
	
	dbSelectArea("PEDS")
	dbCloseArea()
	Alert("Nenhum Pedido de Vendas foi selecionado.","Verifique os parâmetros")
	Return()
	
EndIf

oPrint:= TMSPrinter():New( "Pedido Vendas" )
oPrint:SetPortrait()

While !PEDS->(Eof())
	dbSelectArea("SC5")
	dbGoto(PEDS->REG)

	If !(SC5->C5_TIPO $ "D/B")
		// Checa se o Pedido Sera Impresso (SC9 Blqueado por Credito ou se Nao tiver SC9 e A1_RISCO == E) não sera impresso -- DEMA: 20/02/2018
		dbSelectArea("SC9")
		If dbSeek(sc5->(C5_FILIAL+C5_NUM)) 
			If !Empty(SC9->C9_BLCRED) .And. SC9->C9_BLCRED <> "10"
				// Pedido Bloqueado Por Credito -- ignorar
				dbSelectArea("PEDS")
				dbSkip()
				Loop
			EndIF
		Else
			// Caso nao tennha SC9 - Checa SA1
			dbSelectArea("SA1")
			dbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI))
			If AllTrim(SA1->A1_RISCO) == "E"
				dbSelectArea("PEDS")
				dbSkip()
				Loop
			EndIF
		EndIf
	EndIf

	If !(SC5->C5_TIPO $ "D/B")
		
		cQuery		:= "SELECT "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_NUM PED, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_EMISSAO EMISSAO, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_CONDPAG CONDPAG, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_FRETE FRETE, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XOBSER OBSERV, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XOBSCRI OBSCRI, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XOPC1 OPC1, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XOPC2 OPC2, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XOPC3 OPC3, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XOPC4 OPC4, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XOPC5 OPC5, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XMODFR MODFR, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_CLASPED CLASPED, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XMOEDA MOEDA, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_CLIENT CLIENT, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_LOJAENT LOJAE, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_VEND1 OPERADOR, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_PRODUTO COD, "+CHR(13)+CHR(10)
		//cQuery		+= 		"C6_ITEM ITEMPED, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_UM UM, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_PEDCLI PEDCL, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XBULA XBULA, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XDTENTR ENTREGA, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_QTDVEN QUANT, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_PRCVEN PRCVEN, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_VALOR VALOR, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_XDESCRI DESCRI, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_OPC OPCS, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_ENTREG ENTREGA1, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_COD CLIENTE, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_LOJA LOJA, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_NOME NOME, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_CONTATO CONTATO, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_CGC CNPJ, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_END ENDER, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_BAIRRO BAIRRO, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_BAIRROE BAIRROE, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_BAIRROC BAIRROC, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_MUN MUN, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_MUNE MUNE, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_MUNC MUNC, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_EST EST, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_ESTE ESTE, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_ESTC ESTC, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_CEP CEP, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_CEPE CEPE, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_CEPC CEPC, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_DDD DDD, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_TEL TEL, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_XTEL1 TEL1, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_FAX FAX, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_EMAIL EMAIL, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_ENDENT ENDENT, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_ENDCOB ENDCOB, "+CHR(13)+CHR(10)
		cQuery		+= 		"A1_INSCR INSCR, "+CHR(13)+CHR(10)
		cQuery		+= 		"A4_NOME TRANSP, "+CHR(13)+CHR(10)
		cQuery		+= 		"A4_DDD DDDT, "+CHR(13)+CHR(10)
		cQuery		+= 		"A4_TEL FONE, "+CHR(13)+CHR(10)
		cQuery		+= 		"CASE WHEN F4_IPI = 'S' THEN B1_IPI  ELSE 0 END IPI, "+CHR(13)+CHR(10)
		cQuery		+= 		"CASE WHEN F4_ICM = 'S' THEN B1_PICM ELSE 0 END ICMS, "+CHR(13)+CHR(10)
		//cQuery		+= 		"B1_IPI IPI, "+CHR(13)+CHR(10)
		//cQuery		+= 		"B1_PICM ICMS, "+CHR(13)+CHR(10)
		cQuery		+= 		"B1_PESO*C6_QTDVEN PESO, "+CHR(13)+CHR(10)
		cQuery		+= 		"CASE WHEN F4_IPI = 'S' THEN C6_VALOR*B1_IPI/100  ELSE 0 END TOTIPI, "+CHR(13)+CHR(10)
		cQuery		+= 		"CASE WHEN F4_ICM = 'S' THEN C6_VALOR*B1_PICM/100 ELSE 0 END TOTICM, "+CHR(13)+CHR(10)
		//cQuery		+= 		"C6_VALOR*B1_IPI/100  TOTIPI, "+CHR(13)+CHR(10)
		//cQuery		+= 		"C6_VALOR*B1_PICM/100  TOTICM, "+CHR(13)+CHR(10)
		cQuery		+= 		"B1_DESC B1_DESC, "+CHR(13)+CHR(10)
		
		//Por inicio Para pegar o número do registro Samuel Miranda
		cQuery		+= "CASE WHEN B1_XANVEMP ='' THEN '' "+CHR(13)+CHR(10)
		cQuery		+= "WHEN B1_XANVEMP = '1' AND B1_XANVISA <>'' AND B1_TIPO='PA' THEN '1022371'+B1_XANVISA "+CHR(13)+CHR(10)
		cQuery		+= "WHEN B1_XANVEMP = '2' AND B1_XANVISA <>'' AND B1_TIPO='PA' THEN '8120219'+B1_XANVISA "+CHR(13)+CHR(10)
		cQuery		+= "END AS ANVISA , "+CHR(13)+CHR(10)
		//Por Final Samuel Miranda
		cQuery		+= 		"C6_TES TES, "+CHR(13)+CHR(10)
		cQuery		+= 		"F4_IPI F4_IPI "+CHR(13)+CHR(10)
		cQuery		+= "FROM "+CHR(13)+CHR(10)
		cQuery		+= 	RetSqlName("SC5")+" SC5 "+CHR(13)+CHR(10)
		cQuery		+= 		"INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ''" +CHR(13)+CHR(10)
		cQuery		+= 		"INNER JOIN " + RetSqlName("SC6") + " SC6 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND C6_LOJA = C5_LOJACLI AND SC6.D_E_L_E_T_ = '' " +CHR(13)+CHR(10)
		cQuery		+= 		"LEFT OUTER JOIN " + RetSqlName("SA4") + " SA4 ON A4_FILIAL = '"+xFilial("SA4")+"' AND A4_COD = C5_TRANSP AND SA4.D_E_L_E_T_ = '' " +CHR(13)+CHR(10)
		cQuery		+= 		"INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND F4_CODIGO = C6_TES AND SF4.D_E_L_E_T_ = '' " +CHR(13)+CHR(10)
		cQuery		+= 		"INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = '' " +CHR(13)+CHR(10)
		cQuery		+= "WHERE "+CHR(13)+CHR(10)
		cQuery		+= 		"SC5.R_E_C_N_O_ = "+alltrim(str(PEDS->REG))+" "+CHR(13)+CHR(10)
		cQuery		+= 		"AND SC5.D_E_L_E_T_ = ''"+CHR(13)+CHR(10)
		cQueryORD	:= "ORDER BY "+CHR(13)+CHR(10)
		cQueryORD	+= 		"SC6.C6_NUM, "+CHR(13)+CHR(10)
		cQueryORD	+= 		"SC6.C6_ITEM "+CHR(13)+CHR(10)
	Else
		cQuery		:= "SELECT "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_NUM PED, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_EMISSAO EMISSAO, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_CONDPAG CONDPAG, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_FRETE FRETE, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XOBSER OBSERV, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XOBSCRI OBSCRI, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XOPC1 OPC1, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XOPC2 OPC2, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XOPC3 OPC3, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XOPC4 OPC4, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XOPC5 OPC5, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XMODFR MODFR, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_CLASPED CLASPED, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XMOEDA  MOEDA, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_CLIENT CLIENT, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_LOJAENT LOJAE, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_VEND1 OPERADOR, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_PRODUTO COD, "+CHR(13)+CHR(10)
		//cQuery		+= 		"C6_ITEM ITEMPED, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_UM UM, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_PEDCLI PEDCL, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XBULA XBULA, "+CHR(13)+CHR(10)
		cQuery		+= 		"C5_XDTENTR ENTREGA, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_QTDVEN QUANT, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_PRCVEN PRCVEN, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_VALOR VALOR, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_XDESCRI DESCRI, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_OPC OPCS, "+CHR(13)+CHR(10)
		cQuery		+= 		"C6_ENTREG ENTREGA1, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_COD CLIENTE, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_LOJA LOJA, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_NOME NOME, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_CONTATO CONTATO, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_CGC CNPJ, "+CHR(13)+CHR(10)
		cQuery		+= 		"' '  CGCE, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_END ENDER, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_BAIRRO BAIRRO, "+CHR(13)+CHR(10)
		cQuery		+= 		"' ' BAIRROE, "+CHR(13)+CHR(10)
		cQuery		+= 		"' '  BAIRROC, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_MUN MUN, "+CHR(13)+CHR(10)
		cQuery		+= 		"' '  MUNE, "+CHR(13)+CHR(10)
		cQuery		+= 		"' '  MUNC, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_EST EST, "+CHR(13)+CHR(10)
		cQuery		+= 		"' '  ESTE, "+CHR(13)+CHR(10)
		cQuery		+= 		"' '  ESTC, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_CEP CEP, "+CHR(13)+CHR(10)
		cQuery		+= 		"' '  CEPE, "+CHR(13)+CHR(10)
		cQuery		+= 		"' '  CEPC, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_DDD DDD, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_TEL TEL, "+CHR(13)+CHR(10)
		cQuery		+= 		"' '  TEL1, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_FAX FAX, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_EMAIL EMAIL, "+CHR(13)+CHR(10)
		cQuery		+= 		"' '  ENDENT, "+CHR(13)+CHR(10)
		cQuery		+= 		"' '  ENDCOB, "+CHR(13)+CHR(10)
		cQuery		+= 		"A2_INSCR INSCR, "+CHR(13)+CHR(10)
		cQuery		+= 		"' '  INSCRE, "+CHR(13)+CHR(10)
		cQuery		+= 		"A4_NOME TRANSP, "+CHR(13)+CHR(10)
		cQuery		+= 		"A4_DDD DDDT, "+CHR(13)+CHR(10)
		cQuery		+= 		"A4_TEL FONE, "+CHR(13)+CHR(10)
		cQuery		+= 		"CASE WHEN F4_IPI = 'S' THEN B1_IPI  ELSE 0 END IPI, "+CHR(13)+CHR(10)
		cQuery		+= 		"CASE WHEN F4_ICM = 'S' THEN B1_PICM ELSE 0 END ICMS, "+CHR(13)+CHR(10)
		//cQuery		+= 		"B1_IPI IPI, "+CHR(13)+CHR(10)
		//cQuery		+= 		"B1_PICM ICMS, "+CHR(13)+CHR(10)
		cQuery		+= 		"B1_PESO*C6_QTDVEN PESO, "+CHR(13)+CHR(10)
		cQuery		+= 		"CASE WHEN F4_IPI = 'S' THEN C6_VALOR*B1_IPI/100  ELSE 0 END TOTIPI, "+CHR(13)+CHR(10)
		cQuery		+= 		"CASE WHEN F4_ICM = 'S' THEN C6_VALOR*B1_PICM/100 ELSE 0 END TOTICM, "+CHR(13)+CHR(10)
		//cQuery		+= 		"C6_VALOR*B1_IPI/100  TOTIPI, "+CHR(13)+CHR(10)
		//cQuery		+= 		"C6_VALOR*B1_PICM/100  TOTICM, "+CHR(13)+CHR(10)
	  
		//Por inicio Para pegar o número do registro Samuel Miranda
		cQuery		+= "CASE WHEN B1_XANVEMP ='' THEN '' "+CHR(13)+CHR(10)
		cQuery		+= "WHEN B1_XANVEMP = '1' AND B1_XANVISA <>'' AND B1_TIPO='PA' THEN '1022371'+B1_XANVISA "+CHR(13)+CHR(10)
		cQuery		+= "WHEN B1_XANVEMP = '2' AND B1_XANVISA <>'' AND B1_TIPO='PA' THEN '8120219'+B1_XANVISA "+CHR(13)+CHR(10)
		cQuery		+= "END AS ANVISA , "+CHR(13)+CHR(10)
		//Por Final Samuel Miranda
		
		cQuery		+= 		"SUBSTRING(B1_DESC,1,30) B1_DESC, "+CHR(13)+CHR(10)
				
		cQuery		+= 		"C6_TES TES, "+CHR(13)+CHR(10)
		cQuery		+= 		"F4_IPI F4_IPI "+CHR(13)+CHR(10)
		cQuery		+= "FROM "+CHR(13)+CHR(10)
		cQuery		+= 	RetSqlName("SC5")+" SC5 "+CHR(13)+CHR(10)
		cQuery		+= 		"INNER JOIN " + RetSqlName("SA2") + " SA2 ON A2_FILIAL = '"+xFilial("SA2")+"' AND A2_COD = C5_CLIENTE AND A2_LOJA = C5_LOJACLI AND SA2.D_E_L_E_T_ = ''" +CHR(13)+CHR(10)
		cQuery		+= 		"INNER JOIN " + RetSqlName("SC6") + " SC6 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND C6_LOJA = C5_LOJACLI AND SC6.D_E_L_E_T_ = '' " +CHR(13)+CHR(10)
		cQuery		+= 		"LEFT OUTER JOIN " + RetSqlName("SA4") + " SA4 ON A4_FILIAL = '"+xFilial("SA4")+"' AND A4_COD = C5_TRANSP AND SA4.D_E_L_E_T_ = '' " +CHR(13)+CHR(10)
		cQuery		+= 		"INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND F4_CODIGO = C6_TES AND SF4.D_E_L_E_T_ = '' " +CHR(13)+CHR(10)
		cQuery		+= 		"INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = '' " +CHR(13)+CHR(10)
		cQuery		+= "WHERE "+CHR(13)+CHR(10)
		cQuery		+= 		"SC5.R_E_C_N_O_ = "+alltrim(str(PEDS->REG))+" " +CHR(13)+CHR(10)
		cQuery		+= 		"AND SC5.D_E_L_E_T_ = ''"+CHR(13)+CHR(10)
		cQueryORD	:= "ORDER BY "+CHR(13)+CHR(10)
		cQueryORD	+= 		"SC6.C6_NUM, "+CHR(13)+CHR(10)
		cQueryORD	+= 		"SC6.C6_ITEM "+CHR(13)+CHR(10)
	EndIf
	
	MemoWrite("PED.SQL", cQuery + cQueryOrd)
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery + cQueryOrd ), "PED", .T., .T. )
	
	TcSetField("PED","EMISSAO"	,"D",08,0)
	TcSetField("PED","QTDVEN"	,"N",16,2)
	TcSetField("PED","PRCVEN"	,"N",16,2)
	TcSetField("PED","VALOR"	,"N",16,2)
	TcSetField("PED","IPI"		,"N",05,2)
	TcSetField("PED","TOTIPI"	,"N",16,2)
	TcSetField("PED","ICMS"		,"N", 5,2)
	TcSetField("PED","TOTICM"	,"N",16,2)
	TcSetField("PED","FRETE"	,"N",12,2)
	TcSetField("PED","PESO"		,"N",11,4)
	TcSetField("PED","ENTREGA1"	,"D",08,0)
	
	nRec	:= 0
	_cOpcs := ""
	
	dbSelectArea( "PED" )
	dbGotop()
	PED->(dbEval({ || nRec++ },,{||!Eof()} ))
	dbGoTop()
	
	If nRec == 0
		
		dbSelectArea("PED")
		dbCloseArea()
		Alert("Pedido de Vendas não contem itens." ,"Verifique !")
		
	Else
		
		dbSelectArea("PED")
		dbGotop()
		
		While !PED->(Eof())
			
			If Len(aCabec)==0
				
				cEmpresa 		:= SM0->M0_NOMECOM
				cEndere			:= Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_BAIRCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" - "+Alltrim(SM0->M0_ESTCOB)+" - "+iif(!Empty(SM0->M0_CEPCOB), "CEP: "+Transform(Alltrim(SM0->M0_CEPCOB),"@R 99999-999") , "" )
				cCgc			:= IIF(LEN(ALLTRIM(SM0->M0_CGC))==14, Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),Transform(SM0->M0_CGC,"@R 999.999.999-99") )
				cInsc			:= Transform(SM0->M0_INSC,"@R 999.999.999.999")
				cTel			:= Transform(SM0->M0_TEL,"@R9999-9999")
				cFax			:= Transform(SM0->M0_FAX,"@R9999-9999")
				c_PED			:= PED
				c_PEDCL     	:= PEDCL
				c_END			:= Alltrim(ENDER)
				c_Bairro		:= Alltrim(BAIRRO)
				c_MUN			:= Alltrim(MUN)
				c_EST			:= Alltrim(EST)
				c_CEP			:= Transform(Alltrim(CEP),"@R 99999-999")
				c_TEL			:= Transform(TEL,"@R9999-9999")
				c_TEL1			:= Transform(TEL1,"@R9999-9999")
				c_FAX			:= Transform(FAX,"@R9999-9999")
				c_INSCR     	:= INSCR
				c_EMISSAO		:= Substr(DtoS(SC5->C5_EMISSAO),7,2)+"/"+Substr(DtoS(SC5->C5_EMISSAO),5,2)+"/"+Substr(DtoS(SC5->C5_EMISSAO),1,4)
				c_ENTREGA		:= Substr(DtoS(SC5->C5_XDTENTR),7,2)+"/"+Substr(DtoS(SC5->C5_XDTENTR),5,2)+"/"+Substr(DtoS(SC5->C5_XDTENTR),1,4)
				c_CLIENTE		:= CLIENTE+"-"+LOJA+"/"+NOME
				c_CONTATO		:= CONTATO
				c_DDD	    	:= DDD
				c_CNPJ			:= IIF(LEN(ALLTRIM(CNPJ))==14, Transform(CNPJ,"@R 99.999.999/9999-99"),Transform(CNPJ,"@R 999.999.999-99") )
				c_CONDPAG		:= Posicione("SE4",1,xFilial("SE4")+CONDPAG,"E4_DESCRI")
				c_OBSERV		:=Alltrim(OBSERV)
				c_OBSCRI		:=Alltrim(OBSCRI)
				c_OPC1			:= SC5->C5_XOPC1
				c_OPC2			:= SC5->C5_XOPC2
				c_OPC3			:= SC5->C5_XOPC3
				c_OPC4			:= SC5->C5_XOPC4
				c_OPC5			:= SC5->C5_XOPC5
				c_Frete			:= SC5->C5_FRETE
				c_ENDENT		:= Alltrim(ENDENT)
				c_ENDCOB		:= Alltrim(ENDCOB)
				c_TRANSP		:= Alltrim(TRANSP)
				c_DDDT      	:= DDDT
				c_FONE			:= FONE
				c_MODFR			:= MODFR
				c_CLASPED		:= CLASPED
				c_MOEDA			:= MOEDA
				c_OPERADOR		:= OPERADOR
				c_DESCRI		:= DESCRI
				c_XBULA			:= XBULA
				
				If !(SC5->C5_TIPO $ "D/B")
					c_XCGCE 			:= Posicione("SA1",1,xFilial("SA1")+CLIENT+LOJAE,"A1_CGC")
					c_XINSCRE 		:= Posicione("SA1",1,xFilial("SA1")+CLIENT+LOJAE,"A1_INSCR")
				Else
					c_XCGCE 			:= Posicione("SA2",1,xFilial("SA2")+CLIENT+LOJAE,"A2_CGC")
					c_XINSCRE 		:= Posicione("SA2",1,xFilial("SA2")+CLIENT+LOJAE,"A2_INSCR")
				EndIf
				
				c_BAIRROE	:= Alltrim(BAIRROE)
				c_BAIRROC	:= Alltrim(BAIRROC)
				c_MUNE		:= Alltrim(MUNE)
				c_MUNC		:= Alltrim(MUNC)
				c_ESTE		:= Alltrim(ESTE)
				c_ESTC		:= Alltrim(ESTC)
				c_CEPE		:= Transform(Alltrim(CEPE),"@R 99999-999")
				c_CEPC		:= Transform(Alltrim(CEPC),"@R 99999-999")
				//c_XINSCRE 	:= Posicione("SA1",1,xFilial("SA1")+CLIENT+LOJAE,"A1_INSCR")

				//Array com os dados do cabeçalho.
				aCabec	:=	{cEmpresa,;
				cEndere,;
				cCgc,;
				cInsc,;
				cTel,;
				cFax,;
				c_PED,;
				c_PEDCL,;
				c_END,;
				c_BAIRRO,;
				c_MUN,;
				c_EST,;
				c_CEP,;
				c_TEL,;
				c_TEL1,;
				c_FAX,;
				c_INSCR,;
				c_EMISSAO,;
				c_ENTREGA,;
				c_CLIENTE,;
				c_CONTATO,;
				c_DDD,;
				c_CNPJ,;
				c_CONDPAG,;
				c_OBSERV,;
				c_OBSCRI,;
				c_OPC1,;
				c_OPC2,;
				c_OPC3,;
				c_OPC4,;
				c_OPC5,;
				c_Frete,;
				c_ENDENT,;
				c_ENDCOB,;
				c_TRANSP,;
				c_DDDT,;
				c_FONE,;
				c_MODFR,;
				c_CLASPED,;
				c_MOEDA,;
				c_XCGCE,;
				c_BAIRROE,;
				c_BAIRROC,;
				c_MUNE,;
				c_MUNC,;
				c_ESTE,;
				c_ESTC,;
				c_CEPE,;
				c_CEPC,;
				c_OPERADOR,;
				c_DESCRI,;
				c_XINSCRE,;
				c_XBULA }
				aItens := {}
			EndIf
			
			aadd( aItens,	{	COD,;               //01 - Codigo do Produto
			Substring(B1_DESC,1,60),;			  	//02 - Descrição do Produto (limitadi a 60 Caracteres)
			UM,;									//03 - unidade de medida
			Transform(QUANT,"@E 9999.99"),;			//04 - Quantidade
			Transform(PRCVEN,"@E 9,999,999.99"),;	//05 - Valor unitário do Produto
			Transform(IPI,"@E 999.99"),;			//06 - Valor da margem do IPI
			Transform(ICMS,"@E 999.99"),;			//07 - Valor do ICM
			TOTIPI,;								//08 - Valor do IPI
			TOTICM,;								//09 - vALOR DO ICM
			VALOR,;									//10 - Valor Total ( Produto x Quantidade)
			PESO,;									//11 - Peso do Produto
			DESCRI,;								//12 - 
			dToc(ENTREGA1),;						//13 - Datda da entrega	
			ANVISA} )								//14 - Codigo da Anvisa  Por Samuel Miranda dia 21/03/2019 Apedido do Setor Assuntos regulatórios	
			//ITEMPED } )							//15 - Item do Pedido
			
			If !Empty(OPCS)
				_cOpcs := AllTrim(_cOpcs) + AllTrim(OPCS)
			EndIf
			
			dbSelectArea("PED")
			dbSkip()
			
		EndDo

		aadd( aItens,	{	" ","Opcionais: "," "," "," "," "," ",0,0,0,0," "," "," "} )
		_cDescri := ""
		_nCount  := 0
		If !Empty(_cOpcs)
			_aOpcs := StrTokArr( _cOpcs, "/" )
			For _nI := 1 To Len(_aOpcs)
				If Empty(AllTrim(_aOpcs[_nI]))
					Loop
				EndIf

				dbSelectArea("SGA")
				dbSetOrder(1)
				dbSeek( xFilial("SGA")+AllTrim(_aOpcs[_nI]) )
				If !(SGA->GA_DESCGRP $ _cDescri)
					_cDescri += AllTrim(SGA->GA_DESCGRP) + ": " + AllTrim(SGA->GA_DESCOPC) + " - "
					_nCount++
					If _nCount == 3
						aadd( aItens,	{	" ",_cDescri," "," "," "," "," ",0,0,0,0," "," "," "} )
						_cDescri := ""
						_nCount := 0
					EndIf
				EndIf
			Next _nI
			aadd( aItens,	{	" ",_cDescri," "," "," "," "," ",0,0,0,0," "," "," "} )
		EndIf
		
		While Mod(len(aItens),nItPg) > 0
			
			aadd( aItens,{" ",;  // 01  	
						  " ",;	 // 02
						  " ",;	 // 03
						  " ",;	 // 04
						  " ",;	 // 05
						  " ",;	 // 06
						  " ",;	 // 07
						   0 ,;	 // 08
						   0 ,;	 // 09
						   0 ,;	 // 10
						   0,;	 // 11
						  " ",;	 // 12
						  " ",;	 // 13
						  " " }) // 14
		EndDo
		
		Folhas 	:= Int( len(aItens) / nItPg )
		Folha 	:= 1
		
		For i := 1 to len(aItens) Step nItPg
			
			aPrtLi	:= {}
			
			For j := 0 to nItPg - 1
				
				aPrtIt	:= {}
				
				For k := 1 to len(aItens[i+j])
					
					aadd(aPrtIt,aItens[i+j,k])
					
				Next k
				
				aadd(aPrtLi,aPrtIt)
				
			Next j
			
			For k := 1 To MV_PAR07
				
				oPrint:StartPage()							// Inicia uma nova página
					Impress(aCabec,aPrtLi,Folha++,Folhas)	// Vale
				oPrint:EndPage()							// Finaliza a página
				
			Next k
			
		Next i
		
		aCabec	:= {}
		
		dbSelectArea("PED")
		dbCloseArea()
		
	EndIf	
	//Da um skip (passa pro proximo registro da area)
	dbSelectArea("PEDS")
	dbSkip()	
EndDo
//Fecha a area 
dbSelectArea("PEDS")
dbCloseArea()

oPrint:Preview()     // Visualiza antes de imprimir
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Impress  ³ Autor ³ Claudio               ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(aCabec,aPrtLi,Folha,Folhas)
Local oFont8A
Local oFont8An
Local oFont9A
Local oFont9An
Local oFont10A
Local oFont10An
Local oFont12A
Local oFont12An
Local oFont13A
Local oFont13An
Local oFont14A
Local oFont14An
Local oFont20A
Local oFont20An
Local oFont10C
Local oFont10Cn
Local oFont9C
Local oFont9Cn
Local oFont8C
Local oFont8Cn
Local i


Local cEmpresa		:= aCabec[01]
Local cEndere		:= aCabec[02]
Local cCgc			:= aCabec[03]
Local cInsc			:= aCabec[04]
Local cTel			:= aCabec[05]
Local cFax			:= aCabec[06]
Local c_PED			:= aCabec[07]
Local c_PEDCL		:= aCabec[08]
Local c_END			:= aCabec[09]
Local c_BAIRRO		:= aCabec[10]
Local c_MUN			:= aCabec[11]
Local c_EST			:= aCabec[12]
Local c_CEP			:= aCabec[13]
Local c_TEL			:= aCabec[14]
Local c_TEL1		:= aCabec[15]
Local c_FAX			:= aCabec[16]
Local c_INSCR		:= aCabec[17]
Local c_EMISSAO		:= aCabec[18]
Local c_ENTREGA		:= aCabec[19]
Local c_CLIENTE		:= aCabec[20]
Local c_CONTATO		:= aCabec[21]
Local c_DDD			:= aCabec[22]
Local c_CNPJ		:= aCabec[23]
Local c_CONDPAG		:= aCabec[24]
Local c_OBSERV		:= aCabec[25]
Local c_OBSCRI		:= aCabec[26]
Local c_OPC1		:= aCabec[27]
Local c_OPC2		:= aCabec[28]
Local c_OPC3		:= aCabec[29]
Local c_OPC4		:= aCabec[30]
Local c_OPC5		:= aCabec[31]
Local c_Frete 	   	:= aCabec[32]
Local c_ENDENT		:= aCabec[33]
Local c_ENDCOB		:= aCabec[34]
Local c_TRANSP		:= aCabec[35]
Local c_DDDT		:= aCabec[36]
Local c_FONE		:= aCabec[37]
Local c_MODFR		:= acabec[38]
Local c_CLASPED		:= acabec[39]
Local c_MOEDA		:= acabec[40]
Local c_XCGCE		:= acabec[41]
Local c_BAIRROE		:= acabec[42]
Local c_BAIRROC		:= acabec[43]
Local c_MUNE		:= acabec[44]
Local c_MUNC		:= acabec[45]
Local c_ESTE		:= acabec[46]
Local c_ESTC		:= acabec[47]
Local c_CEPE		:= acabec[48]
Local c_CEPC		:= acabec[49]
Local c_OPERADOR	:= acabec[50]
Local c_DESCRI		:= acabec[51]
Local c_XINSCRE		:= acabec[52]
Local c_XBULA		:= acabec[53]

Local c_Folha		:= "Folha: "+Alltrim(Str(Folha))+"/"+Alltrim(Str(Folhas))
//ABmp := "VALE_"+AllTrim(cEmpAnt)+".JPEG"
//ABmp := "VALE_04.bmp"
ABmp := "LGMID01.png"

oFont6A		:= TFont():New("Arial",9,6 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont6An		:= TFont():New("Arial",9,6 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont7A		:= TFont():New("Arial",9,6 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7An		:= TFont():New("Arial",9,6 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8A		:= TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8An		:= TFont():New("Arial",9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9A		:= TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9An		:= TFont():New("Arial",9,9 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10A		:= TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10An	:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12A		:= TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oFont12An	:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13A		:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
oFont13An	:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14A		:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14An	:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20A		:= TFont():New("Arial",9,20,.T.,.F.,5,.T.,5,.T.,.F.)
oFont20An	:= TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)

oFont50An	:= TFont():New("Arial",18,50,.T.,.T.,5,.T.,5,.T.,.F.)
oFont6C		:= TFont():New("Courier New",9, 6,.T.,.F.,5,.T.,5,.T.,.F.)
oFont6Cn		:= TFont():New("Courier New",9, 6,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8C		:= TFont():New("Courier New",7, 8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8Cn		:= TFont():New("Courier New",7, 8,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10C		:= TFont():New("Courier New",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10Cn	:= TFont():New("Courier New",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9C		:= TFont():New("Courier New",9, 9,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9Cn		:= TFont():New("Courier New",9, 9,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8C		:= TFont():New("Courier New",9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8Cn		:= TFont():New("Courier New",9, 8,.T.,.T.,5,.T.,5,.T.,.F.)

oBrush := TBrush():New("",4)

// ----------------------------------  Logotipo
If File(aBmp)
	oPrint:SayBitmap( 0015,0015,aBmp,0500,0250 )
EndIf
// ----------------------------------  Contorno do documento
//oPrint:line (0520,0020,0540,2400)
//oPrint:line (0540,0020,0540,2400)
 
oPrint:box  (0015,0015,2570,2355)
oPrint:Line (0015,0520,0270,0520)// Linha vertical

oPrint:Say	(0120,0930,"PEDIDO DE VENDAS",oFont20An )

oPrint:Say	(0120,2130,c_Folha,oFont10An )
oPrint:Say	(0230,2090,"A1 05.02 REV 01",oFont9A )
oPrint:Say	(0280,0021,cEmpresa,oFont13An )

oPrint:line (0270,0020,0270,2350)// Linha Horizontal
oPrint:Line (0270,1750,0540,1750)// Linha vertical
	  //       col  Lin
oPrint:Say	(0300,1760,"PEDIDO VENDA :",oFont9An )			;	oPrint:Say	(0301,2095,c_PED,oFont10An )
oPrint:Say	(0330,0021,cEndere,oFont8An )

oPrint:line (0340,1750,0340,2350)// Linha Horizontal
oPrint:Say	(0350,1760,"PEDIDO CLIENTE:",oFont9An )			;	oPrint:Say	(0350,2130,c_PEDCL,oFont10An )

oPrint:line (0380,0020,0380,1750)

oPrint:Say	(0400,0021,"TEL:",oFont9An )					;	oPrint:Say	(0400,0130,cTel,oFont9A )
oPrint:Say	(0400,0430,"FAX:",oFont9An )					;	oPrint:Say	(0400,0520,cFax,oFont9A )
oPrint:Say	(0400,0800,"E-MAIL :",oFont9An )				;	oPrint:Say	(0400,0940,"ortosintese@ortosintese.com.br",oFont9A )

oPrint:line (0450,0020,0450,1750)

oPrint:line (0390,1750,0390,2350)// Linha Horizontal
oPrint:Say	(0400,1760,"EMISSÃO:",oFont9An )				;	oPrint:Say	(0400,1945,c_Emissao,oFont9A )

oPrint:Say	(0470,0021,"CNPJ:",oFont9An )					;	oPrint:Say	(0470,0135,cCgc,oFont9A )

oPrint:Say	(0470,0520,"INSCR.EST :",oFont9An )				;	oPrint:Say	(0470,0745,cInsc,oFont9A )
oPrint:line (0440,1750,0440,2350)// Linha Horizontal
//oPrint:Say	(0450,1760,"ENTREGA:",oFont9An )				;	oPrint:Say	(0452,1945,c_Entrega,oFont9A )

oPrint:line (0490,1750,490,2350)// Linha Horizontal

If c_MOEDA == "1"
	oPrint:Say	(0500,1760,"MOEDA.... : R$",oFont9An )
ElseIf c_MOEDA == "2"
	oPrint:Say	(0500,1760,"MOEDA.... : U$",oFont9An )
ElseIf c_MOEDA == "3"
	oPrint:Say	(0500,1760,"MOEDA.... : EUR$",oFont9An )
ElseIf c_MOEDA == "4"
	oPrint:Say	(0500,1760,"MOEDA.... : Z$",oFont9An )
EndIf

oPrint:line (0540,0020,0540,2350)
// ----------------------------------  quadro 3  Destinatário
oPrint:Say	(0550,0021,"CLIENTE:",oFont9An )	   	  ;	oPrint:Say	(0550,0250,c_CLIENTE,oFont9A )
oPrint:line (0590,0020,0590,2350,)
oPrint:Say	(0600,0021,"ENDEREÇO:",oFont9An )	   	  ;	oPrint:Say	(0600,0250,c_END,oFont9A )
oPrint:Say	(0600,1310,"BAIRRO:",oFont9An )		   	  ;	oPrint:Say	(0600,1465,c_BAIRRO,oFont9A )
oPrint:line (0640,0020,0640,2350)
oPrint:Say	(0650,0021,"CIDADE:",oFont9An )		   	  ;	oPrint:Say	(0650,0250,c_MUN,oFont9A )
oPrint:Say	(0650,0950,"ESTADO:",oFont9An )		   	  ;	oPrint:Say	(0650,1110,c_EST,oFont9A )
oPrint:Say	(0650,1310,"CEP:",oFont9An )		   	  ;	oPrint:Say	(0650,1415,c_CEP,oFont9A )
oPrint:line (0690,0020,0690,2350)

oPrint:Say	(0700,0021,"TELEFONE 1:",oFont9An )		  ;	oPrint:Say	(0700,0250,+"( "+ c_Ddd +" )  " + c_Tel ,oFont9A )
//oPrint:Say	(0700,0250," ",oFont9An )			  ;	oPrint:Say	(0700,0300,c_Tel,oFont9A )
oPrint:Say	(0700,0950,"TELEFONE:",oFont9An )		  ;	oPrint:Say	(0700,1150,+"( "+ c_Ddd +" )  " + c_Tel1 ,oFont9A )
//oPrint:Say	(0700,0680," ",oFont9An )		  	  ;	oPrint:Say	(0700,0725,c_Tel1,oFont9A )

//oPrint:Say	(0700,0950,"FAX:",oFont9An )		  ;	oPrint:Say	(0700,1070,c_Fax,oFont9A )
oPrint:Say	(0700,1760,"FAX:",oFont9An )		   	  ;	oPrint:Say	(0700,1850,c_Fax,oFont9A )
oPrint:line (0740,0020,0740,2350)
oPrint:Say	(0750,0021,"CNPJ MF/CPF:",oFont9An )	  ;	oPrint:Say	(0750,0360,c_Cnpj,oFont9A )
oPrint:Say	(0750,0950,"INSCR/RG:",oFont9An )		  ;	oPrint:Say	(0750,1165,c_Inscr,oFont9A )
oPrint:Say	(0750,1500,"CONTATO:",oFont9An )		  ;	oPrint:Say	(0749,1680,c_Contato,oFont9A )
oPrint:line (0790,0020,0790,2350)
oPrint:Say	(0800,0021,"OPERADOR(a):",oFont9An )	  ;	oPrint:Say	(0800,0290,c_Operador,oFont9A )
oPrint:Say	(0800,0950,"COND. PAGTO:",oFont9An )	  ;	oPrint:Say	(0800,1200,c_Condpag,oFont9A )
oPrint:line (0840,0020,0840,2350)									
oPrint:Say	(0850,0021,"IDIOMA BULA:",oFont9An )	  ; oPrint:Say	(0850,0950,"Obs: Os preços podem ser reajustados sem prévio aviso.",oFont9An )

//Informa qual o idioma da bula
If c_XBULA == "1"
	oPrint:Say	(0850,0380,"PORTUGUES",oFont9An )
ElseIf c_XBULA == "2"
	oPrint:Say	(0850,0380,"INGLES",oFont9An )
ElseIf c_XBULA == "3"
	oPrint:Say	(0850,0380,"ESPANHOL",oFont9An )
EndIf
//oPrint:Say	(0750,0060,"Descricao Auxiliar:",oFont10An )		  		;	oPrint:Say	(0700,0290,c_Operador,oFont8A )

//oPrint:Say	(0760,0060,"Conforme solicitação, informamos preços e condições:",oFont14An )
oPrint:line (0910,0020,0910,2350)

// ----------------------------------  quadro 4  Cabec Itens
oPrint:Say	(0920,0021,"PRODUTO",oFont9An )
oPrint:Say	(0920,0250,"DESCRIÇÃO DO PRODUTO",oFont9An )
//oPrint:Say	(0920,1070,"UM",oFont10An )
oPrint:Say	(0920,1200,"QUANT.",oFont9An )
oPrint:Say	(0920,1370,"VLR UNIT.",oFont9An )
oPrint:Say	(0920,1570,"VLR TOTAL",oFont9An )
oPrint:Say	(0920,1810,"%IPI",oFont9An )
oPrint:Say	(0920,1920,"$TOT.IPI",oFont9An )
oPrint:Say	(0920,2070,"ICMS",oFont9An )
oPrint:Say	(0920,2195,"ENTREGA",oFont9An )

oPrint:line (0970,0020,0970,2350)

_Li := 0960
//_Li := 0980
_nTotal 	:= 0
_nIpi   	:= 0
_nIcm		:= 0
_nPeso		:= 0
dbSelectArea("SA1")
dbSelectArea("SF4")

//Imprime os dados do pedido
For i := 1 to len(aPrtLi)	
	_Li	+= 25
	oPrint:Say	(_Li,0021,aPrtLi[i,1], oFont8Cn )	// PRODUTO
	oPrint:Say	(_Li,0250,aPrtLi[i,2], oFont8Cn )	// DESCRICAO
	If !empty(aPrtLi[i,14])
		oPrint:Say	(_Li+25,0250,+"Reg. ANVISA: "+aPrtLi[i,14], oFont8C )// REGISTRO AVINSA
	EndIf
	If aPrtLi[i,12] != ""
		oPrint:Say	(_Li+50,0250,aPrtLi[i,12], oFont8Cn )// XDESCRI
	//_Li	-= 10
	EndIf
	oPrint:Say	(_Li+15,1200,aPrtLi[i,4], oFont8Cn )	// QUANT    //oPrint:Say	(_Li,1070,aPrtLi[i,3], oFont8Cn )	// UM
	oPrint:Say	(_Li+15,1320,aPrtLi[i,5], oFont8Cn )	// PRCVEN
	If aPrtLi[i,10] > 0
		//_Li	-= 30
		oPrint:Say	(_Li+15,1520,Transform(aPrtLi[i,10],"@E 999,999,999.99"),oFont8Cn )	// TOTAL
	Endif

	If !Empty(aPrtLi[i,1])
		oPrint:Say	(_Li+15,1790,Transform(aPrtLi[i,6],"@E 999.99"), oFont8Cn )	// %IPI
	EndIf

	If !empty(aPrtLi[i,1])
		oPrint:Say	(_Li+15,1790,Transform(aPrtLi[i,8],"@E 999,999,999.99"),oFont8Cn )	// TOTIPI
	Endif
	//	oPrint:Say	(_Li,1950,aPrtLi[i,7], oFont8Cn )	// %ICMS
	If aPrtLi[i,9] > 0
		//_Li	-= 30
		oPrint:Say	(_Li,2050,Transform(aPrtLi[i,9],"@E 999,999,999.99"),oFont8Cn )	// TOTICM
	Endif
	oPrint:Say	(_Li+15,2200,aPrtLi[i,13], oFont8Cn )	// ENTREGA1  
	//Imprimi uma linha 	
	_Li	+= 60
	if !empty(aPrtLi[i,1])
		oPrint:Say	(_Li+5,0020,replicate("--",69)) 
	EndIf 
	
	_nTotal += aPrtLi[i,10] //Valor total do pedido
	_nIpi   += aPrtLi[i,8]  //Valor total do IPI
	_nIcm   += aPrtLi[i,9]  //Valor total do ICM
	_nPeso  += aPrtLi[i,11] //Peso total
	
Next i
_nTotGeral 	+= _nTotal
_nIpiGeral  += _nIpi  //SAMUEL
_nIcmGeral 	+= _nIcm

//oPrint:Say	(2450,1450,Transform(_nTotal+c_Frete,"@E 999,999,999.99"),oFont9Cn )

oPrint:box  (2300,0019,2350,2350)  //Box do total de Produtos

oPrint:Say	(2310,0021,"TOTAL PRODUTOS: ",oFont9Cn )
oPrint:Say	(2310,1450,Transform(_nTotal,"@E 999,999,999.99"),oFont9Cn )
//oPrint:Say	(2310,1350,Transform(_nTotal,"@E 999,999,999.99"),oFont9Cn )

//If A1_EST <> 'EX'

oPrint:Say	(2310,1780,Transform(_nIpi,"@E 999,999,999.99"),oFont9Cn )
oPrint:Say	(2310,2070,Transform(_nIcm,"@E 999,999,999.99"),oFont9Cn )
//EndIf

oPrint:Say	(2360,0020,"TOTAL FRETE   : ",oFont9Cn )
oPrint:Say	(2360,1450,Transform(c_Frete,"@E 999,999,999.99"),oFont9Cn )

oPrint:box  (2390,0019,2390,2350)
oPrint:Say	(2400,0021,"PESO TOTAL    : ",oFont9Cn )
oPrint:Say	(2400,1430,Transform(_nPeso,"@E 999,999,999.999"),oFont9Cn )

oPrint:box  (2440,0019,2440,2350)
oPrint:Say	(2450,0021,"TOTAL GERAL   : ",oFont9Cn )

//If A1_EST <> 'EX'
 if Folha = Folhas
	//oPrint:box  (2573,1780,2350,2350)  //BOX DO VALOR TOTAL  
	//oPrint:Line (0270,1750,0540,1750)// Linha vertical 
 	oPrint:Line (2570,1780,2350,1780)// Linha vertical
	oPrint:Say	(2360,1850,"TOTAL GERAL DO PEDIDO",oFont9Cn )
	oPrint:Say	(2400,1800,"ICMS",oFont9Cn )
	oPrint:Say	(2400,2070,Transform(_nIcmGeral,"@E 999,999,999.99"),oFont9Cn )
	oPrint:Say	(2450,1800,"IPI",oFont9Cn )
	oPrint:Say	(2450,2070,Transform(_nIpiGeral,"@E 999,999,999.99"),oFont9Cn )
	oPrint:Say	(2500,1800,"FRETE / PESO",oFont9Cn )
	oPrint:Say	(2490,2070,Transform(c_Frete,"@E 999,999,999.99"),oFont9Cn )
	oPrint:Say	(2540,2070,Transform(_nTotGeral+c_Frete+_nIpiGeral,"@E 999,999,999.99"),oFont9Cn ) 
	//oPrint:Say	(2450,1450,Transform(_nTotGeral+c_Frete+_nIpiGeral,"@E 999,999,999.99"),oFont9Cn ) //+_nIcm _nTotGeral Samuel 
	//oPrint:Say	(2450,1780,Transform(_nIpiGeral,"@E 999,999,999.99"),oFont9Cn ) //+_nIcm _nTotGeral Samuel 
 Endif
	//oPrint:Say	(2450,1350,Transform(_nTotal+c_Frete+_nIpi,"@E 999,999,999.99"),oFont9Cn ) //+_nIcm  TOTAL GERAL
	//Else
	//oPrint:Say	(2450,1450,Transform(_nTotal+c_Frete,"@E 999,999,999.99"),oFont9Cn )
	//EndIf

oPrint:box  (2490,0019,2570,2350) //BOX DO VALOR TOTAL
//oPrint:box  (2510,0050,2510,2750)
oPrint:Say	(2496,0021,"Frete:",oFont10An )
oPrint:Say	(2496,0460,"Classif.Pedido:",oFont10An )
If c_MODFR == "1"
	oPrint:Say	(2530,0021,"Emitente",oFont10An )
ElseIf c_MODFR == "2"
	oPrint:Say	(2530,0021,"Destinatario",oFont10An )
ElseIf c_MODFR == "3"
	oPrint:Say	(2530,0021,"Terceiros",oFont10An )
ElseIf c_MODFR == "4"
	oPrint:Say	(2530,0021,"Sem Frete",oFont10An )
EndIf
If c_CLASPED == "1"
	oPrint:Say	(2530,0460,"Mercado Interno",oFont10An )
ElseIf c_CLASPED == "2"
	oPrint:Say	(2530,0460,"Caixas",oFont10An )
ElseIf c_CLASPED == "3"
	oPrint:Say	(2530,0460,"Equipamentos",oFont10An )
ElseIf c_CLASPED == "4"
	oPrint:Say	(2530,0460,"Exportacao",oFont10An )
ElseIf c_CLASPED == "5"
	oPrint:Say	(2530,0460,"Diversos",oFont10An )
ElseIf c_CLASPED == "6"
	oPrint:Say	(2530,0460,"Cancelados",oFont10An )
EndIf

oPrint:Say	(2496,0950,"Transportadora:",oFont10An )     				;	oPrint:Say	(2532,0950,c_TRANSP,oFont8A )
oPrint:Say	(2496,1525,"Tel:",oFont10An )								
oPrint:Say	(2530,1525,"( "+c_DDDT+ " )",oFont8A ) 						;	oPrint:Say	(2530,1620,c_FONE,oFont8A )
//oPrint:Say	(2530,1525,"( ",oFont10An )
//oPrint:Say	(2530,1555," )",oFont10An )				  					

//oPrint:box  (2600,0050,2510,2750)

If Folha <> Folhas
	oPrint:Say	(3300,0060,"Continua na próxima folha",oFont14An )
Else
	
	// INCLUIDO PARA IMPRIMIR SOMENTE NA ULTIMA FOLHA ---> CLAUDIO 12/12/2013 - INICIO
	If !(SC5->C5_TIPO $ "D/B")
		//oPrint:line (0540,0019,0540,2400)
		oPrint:box  (2580,0020,2780,1120)
		oPrint:Say	(2580,0400,"ENDEREÇO DE ENTREGA",oFont9An )
		
		//oPrint:line (2605,0020,2610,1120)
		oPrint:Say	(2620,0025,"END.:",oFont8An )		;	oPrint:Say	(2620,0170,c_ENDENT,oFont8A ) //	;	oPrint:Say	(3040,0960,c_BAIRROE,oFont8An )
		oPrint:line (2650,0020,2650,1120)
		oPrint:Say	(2660,0025,"BAIRRO :",oFont8An )	;	oPrint:Say	(2660,0170,c_BAIRROE,oFont8A )
		oPrint:Say	(2660,0750,"CIDADE :",oFont8An )	;	oPrint:Say	(2660,0900,c_MUNE,oFont8A )
		oPrint:line (2690,0020,2690,1120)
		oPrint:Say	(2700,0025,"CEP:",oFont8An )        ;	oPrint:Say	(2700,0170,c_CEPE,oFont8A )    
		oPrint:line (2730,0020,2730,1120)
		oPrint:Say	(2740,0025,"CNPJ :",oFont8An )		;	oPrint:Say	(2740,0170,Transform(c_XCGCE,"@R 99.999.999/9999-99"),oFont8A )
		oPrint:Say	(2740,0650,"INSCR.EST.:",oFont8An ) ;	oPrint:Say	(2740,0850,c_XINSCRE,oFont8A ) //Transform(_nIcm,"@E 999,999,999.99")
			
		oPrint:box  (2580,1150,2780,2350)
		oPrint:Say	(2580,1560,"ENDEREÇO DE COBRANÇA",oFont9An )	
		
		oPrint:Say	(2620,1160,"END.:",oFont8An )			;	oPrint:Say	(2620,1300,c_ENDCOB,oFont8A ) //	;  oPrint:Say	(3240,0990,c_BAIRROC,oFont8An )
		oPrint:line (2650,1150,2650,2350)
		oPrint:Say	(2660,1160,"BAIRRO :",oFont8An )        ;	oPrint:Say	(2660,1300,c_BAIRROC,oFont8A )
		oPrint:Say	(2660,1900,"CIDADE :",oFont8An )		;	oPrint:Say	(2660,2060,c_MUNC,oFont8A )
		
		oPrint:line (2690,1150,2690,2350)	
		oPrint:Say	(2700,1160,"CEP:",oFont8An ) 			;	oPrint:Say	(2700,1300,c_CEPC,oFont8A )
		
		oPrint:line (2730,1150,2730,2350)
		oPrint:Say	(2740,1160,"CNPJ :",oFont8An )			;	oPrint:Say	(2740,1300,Transform(c_XCGCE,"@R 99.999.999/9999-99"),oFont8A )
		oPrint:Say	(2740,1850,"INSCR.EST.:" ,oFont8An ) 	;	oPrint:Say	(2740,2060, c_XINSCRE,oFont8A )
		                            
	EndIf
	
	//Removido conforme chamado numero  14474 Por Samuel Miranda 01032022
	//oPrint:Say	(2805,0021,"Emitido:",oFont10An )                        	;	oPrint:Say	(2805,0560,"Liberado:",oFont10An )
	//oPrint:Say	(2840,0021,"Visto:___________________",oFont10An )  		;	oPrint:Say	(2840,0560,"Visto:___________________",oFont10An )
	//
	//oPrint:Say	(2805,1060,"Separado:",oFont10An )                        	;	oPrint:Say	(2805,1560,"Conferido:",oFont10An )
	//oPrint:Say	(2840,1060,"Visto:___________________",oFont10An )   		;	oPrint:Say	(2840,1560,"Visto:___________________",oFont10An )
	//
	//oPrint:Say	(2805,2060,"Expedido:",oFont10An )
	//oPrint:Say	(2840,2060,"NF:_______________",oFont10An )
	
	If !(SC5->C5_TIPO $ "D/B")
		//oPrint:box  (3670,0450,3670,2550)
		oPrint:Say	(2940,0860,"ANALISE CRÍTICA DO PEDIDO:",oFont10An )
		oPrint:box  (2930,0100,3300,2200)
		oPrint:Say	(2990,0120,"a) Os requisitos estão adequadamente definidos.",oFont10An )
		oPrint:Say	(3040,0120,"b) Os requisitos estão devidamente acordados.",oFont10An )
		oPrint:Say	(3090,0120,"c) Qualquer diferença entre requisitos do pedido, e aqueles definidos no orçamento estão resolvidos.",oFont10An )
		oPrint:Say	(3140,0120,"d) Temos capacidade de atender os requisitos especificados.",oFont10An )
		//oPrint:Say	(3190,0120,"e) Será fabricado conforme sistemática ISO.",oFont10An )
		oPrint:Say	(3190,0120,"e) Observações:",oFont10An )				; oPrint:Say	(3195,0460,c_OBSCRI,oFont8An )
		oPrint:Say	(3265,0400,"O PRAZO DE ENTREGA É CONTADO A PARTIR DA CONFIRMAÇÃO DO PEDIDO E LIBERAÇÃO DO FINANCEIRO",oFont8An )				
		//;  oPrint:Say	(3320,0460,c_OBSCRI,oFont8An )

		oPrint:line (2985,0100,2985,2200)//a
		oPrint:line (3035,0100,3035,2200)//b
		oPrint:line (3085,0100,3085,2200)//c
		oPrint:line (3135,0100,3135,2200)//d
		oPrint:line (3185,0100,3185,2200)//e
		oPrint:line (3235,0100,3235,2200)//f
		//oPrint:box  (3450,0150,3060,2200)
		//oPrint:box  (3310,1900,3060,2200)
		//oPrint:box  (3310,1980,3060,2200)
	EndIf
	
	If !(SC5->C5_TIPO $ "D/B")
		If c_OPC1 == "1"
			oPrint:Say  (2990,1930,"SIM",oFont10An )
		Else
			oPrint:Say  (2990,1930,"NAO",oFont10An )
		EndIf
		
		If c_OPC2 == "1"
			oPrint:Say  (3040,1930,"SIM",oFont10An )
		Else
			oPrint:Say  (3040,1930,"NAO",oFont10An )
		EndIf
		
		If c_OPC3 == "1"
			oPrint:Say  (3090,1930,"SIM",oFont10An )
		Else
			oPrint:Say  (3090,1930,"NAO",oFont10An )
		EndIf
		
		If c_OPC4 == "1"
			oPrint:Say  (3140,1930,"SIM",oFont10An )
		Else
			oPrint:Say  (3140,1930,"NAO",oFont10An )
		EndIf
		
		//If c_OPC5 == "1"
			//oPrint:Say  (3190,1930,"SIM",oFont10An )
		//Else
			//oPrint:Say  (3190,1930,"NAO",oFont10An )
		//Endif
		
		oPrint:Line (2985,1920,3185,1920)// Linha vertical
		
		oPrint:Line (2990,2020,3185,2020)// Linha vertical
	EndIf	
		
EndIf
oPrint:Say	(3310,2070,"By TI | Ortosintese",oFont6A)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CriaSX1   ³ Rev.  ³ Samuel Miranda	    ³ Data ³29.11.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria uma janela contendo a legenda da mBrowse              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1(cPerg)

Local aArea	:= GetArea()

Local aP:= {}
Local i:= 0
Local cSeq
Local cMvCh
Local cMvPar
Local aHelp:= {}

aAdd(aP,{"Cliente de"                ,"C", 6,0,"G","                                                            ","SA1"   ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Cliente ate"               ,"C", 6,0,"G","(mv_par02>=mv_par01)                                        ","SA1"   ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Emissao de"                ,"D", 8,0,"G","                                                            ",""      ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Emissao ate"               ,"D", 8,0,"G","(mv_par04>=mv_par03)                                        ",""      ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Pedido de"                 ,"C", 6,0,"G","                                                            ","SC5"   ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Pedido ate"                ,"C", 6,0,"G","(mv_par06>=mv_par05)                                        ","SC5"   ,""           ,""             ,""            ,"",""})
aAdd(aP,{"Numero de Vias"            ,"N", 2,0,"G","(mv_par07>=1)                                               ",""      ,""           ,""             ,""            ,"",""})

aAdd(aHelp,{"Informe o Código do Cliente ","inicial para a seleção dos dados"})
aAdd(aHelp,{"Informe o Código do Cliente ","Final para a seleção dos dados"})
aAdd(aHelp,{"Informe a Data de Emissao  ","inicial para a seleção dos dados"})
aAdd(aHelp,{"Informe a Data de Emissao  ","final para a seleção dos dados"})
aAdd(aHelp,{"Informe o Numero do Pedido","inicial para a seleção dos dados"})
aAdd(aHelp,{"Informe o Numero do Pedido","final para a seleção dos dados"})
aAdd(aHelp,{"Informe a quantidade de cópias","a serem impressas."})

_aParm := aClone(aP)

For i:=1 To Len(aP)
	cSeq   := StrZero(i,2,0)
	
	cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
	PutSx1(cPerg,;
	cSeq,;
	aP[i,1],aP[i,1],aP[i,1],;
	cMvCh,;
	aP[i,2],;
	aP[i,3],;
	aP[i,4],;
	0,;
	aP[i,5],;
	aP[i,6],;
	aP[i,7],;
	"",;
	"",;
	cMvPar,;
	aP[i,8],aP[i,8],aP[i,8],;
	"",;
	aP[i,9],aP[i,9],aP[i,9],;
	aP[i,10],aP[i,10],aP[i,10],;
	aP[i,11],aP[i,11],aP[i,11],;
	aP[i,12],aP[i,12],aP[i,12],;
	aHelp[i],;
	{},;
	"")
Next i

RestArea(aArea)

Return()

