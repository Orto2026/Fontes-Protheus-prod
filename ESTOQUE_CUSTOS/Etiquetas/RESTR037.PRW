#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"  
#include 'parmtype.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR037 ºAutor  ³SAMUEL MIRNDA       º Data ³  22/01/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de impressao de etiquetas de separação		      º±±
±±º          ³ de Pedidos.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESTR037()

Local aPergs      := {}
Local cCodCliDe   := Space(TamSX3( 'A1_COD' )[01])
Local cCodCliAt   := StrTran(cCodCliDe,' ','Z') //
Local dDataDe     := FirstDate()
Local dDataAt     := LastDate(Date())
Local nOrdemDe    := Space(TamSX3( 'CB7_ORDSEP' )[01])
Local nOrdemAt    := StrTran(nOrdemDe,' ','Z') //
Local nNFDe       := Space(TamSX3( 'CB7_NOTA' )[01])
Local nNFAt       := StrTran(nNFDe,' ','Z') //
Local cSegto      := Space(30)

local aCombo   := {"1=Reposicao","2=Caixas","3=Equipamentos","4=Exportacao","5=Diversos","6=Pecas Equip","7=Sob Medida " }
DEFAULT lCanSave := .T.
DEFAULT lUserSave := .T.

aadd(aPergs, {01, "Data De"            , dDataDe  , ""    , ".T.", ""   , ""   , 50, .F.})
aadd(aPergs, {01, "Data Até"           , dDataAt  , ""    , ".T.", ""   , ""   , 50, .F.})
aadd(aPergs, {01, "Cliente De"         , cCodCliDe, ""    , ".T.", "SA1", ""   , 50, .F.})
aadd(aPergs, {01, "Cliente Até"        , cCodCliAt, ""    , ".T.", "SA1", ""   , 50, .F.})
aadd(aPergs, {02, "Mercado"            , 01       , aCombo, 50   , ""   , .F.}) //"Tipo 2 - Escolha:",01,aCombo,50,"",.T.})                                  
aadd(aPergs, {01, "Número da Ordem De" , nOrdemDe , ""    , ".T.", "CB7", ""   , 50, .F.})
aadd(aPergs, {01, "Número da Ordem Até", nOrdemAt , ""    , ".T.", "CB7", ""   , 50, .F.})
aadd(aPergs, {01, "Nota Fiscal De."    , nNFDe    , ""    , ".T.", "CB7", ""   , 50, .F.})
aadd(aPergs, {01, "Nota Fiscal Até"    , nNFAt    , ""    , ".T.", "CB7", ""   , 50, .F.})
aadd(aPergs, {01, "Seguimento"         , cSegto   , ""    , ".T.", ""   , ".T.", 50, .F.})

//If ParamBox(aPergs ,"Informe os parâmetros",aRet,,,,,,,,lCanSave,lUserSave,)
If ParamBox(aPergs, "Informe os parâmetros", , , , , , , , , .F., .F.)
	RptStatus({|lEnd| U_RESTR37Imp(@lEnd)},"Imprimindo, aguarde...")
EndIf

Return()

User Function RESTR37Imp(lEnd)

Local nCopias 		:= 1	//mv_par05
Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local nRec			:= 0
Local cTpFonte 		:= "0"
//Local cFonte1 		:= "020,020"
//Local cFonte2 		:= "017,017"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "025,025"
Local cFonte5 		:= "035,035"
Local cFonte6 		:= "040,040"
Local cFonte7 		:= "073,073"
Local nCol			:= 04
Local nlin			:= 04
Local _xMercado		:= cValtochar(mv_par05)
Local cCodCli 		:= "" //
Local cCondPgt 		:= "" //
SetRegua(1)
	
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
cQuery += "CB7.CB7_DTEMIS BETWEEN '" + DTOS(MV_PAR01) + "' AND '"+ DTOS(MV_PAR02) +"' AND "+CHR(13)+CHR(10)// Data da Separaçao De.
cQuery += "CB7.CB7_CLIENT BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04+"' "+CHR(13)+CHR(10) //Cliente    //CB7_ORDSEP BETWEEN '053710' AND '053710'
cQuery += "AND CB7.CB7_ORDSEP BETWEEN '"+ Mv_Par06 +"' AND '"+ Mv_Par07+"' "+CHR(13)+CHR(10) //Número da Ordem De
cQuery += "AND CB7.CB7_NOTA   BETWEEN '"+ Mv_Par08 +"' AND '"+ Mv_Par09+"' "+CHR(13)+CHR(10) 
cQuery += "AND CB7.CB7_STATUS = 0 " + CHR(13)+CHR(10) 
cQuery += "AND SC5.C5_CLASPED = '"+ _xMercado +"' " + CHR(13)+CHR(10) //Mercado
cQuery += "ORDER BY CB7.CB7_ORDSEP " + CHR(13)+CHR(10)

MemoWrite("RESTR037.SQL", cQuery )
cQuery := ChangeQuery(cQuery)

dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery ), "QRY" , .T. , .F. )	
dbSelectArea( "QRY" )
dbGotop()
QRY->(dbEval({ || nRec++ },,{||!Eof()} ))
dbGoTop()	

IncRegua()	

	If nRec == 0
		dbSelectArea("QRY")
		dbCloseArea()
		Alert("Ordens não encontrada!." ,"Verifique !")
		Return()
	Endif
		
	dbSelectArea("QRY")
	dbGotop()
	
	DbSelectArea("SF2")     // CABEÇALHO DAS NF DE SAÍDA
    SF2->(DbSetOrder(1))    // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO

	While !QRY->(Eof())

		If _xMercado <> "2" 

			nSalto	:= 0
			nCol    := 04
			nlin	:= 18
			cCodCli := QRY->CODCLI
			cCondPgt:= QRY->CONPGTO

			MSCBPRINTER(cImpressora,cPorta)
			MSCBCHKStatus(.F.)
			MSCBBEGIN(nCopias,4)
			MSCBBOX(001,002,100,057,6)// Box da Borda
		
			While !QRY->(Eof()) .AND. cCodCli == QRY->CODCLI .AND. cCondPgt == QRY->CONPGTO
																				
				//MSCBSAY(25,04,"ETQ. DE SEPARAÇÃO"													,"N",cTpFonte,cFonte6)
				MSCBSAY(04,04,+Alltrim(Upper(QRY->CODCLI))+" - "+Alltrim(QRY->CONPGTO)				,"N",cTpFonte,cFonte5)
				If !Empty(QRY->NUMNF)
					MSCBSAY(40,04,+dToc(Posicione("SF2",1,xFilial("SF2")+QRY->NUMNF,"F2_EMISSAO"))	,"N",cTpFonte,cFonte6)
				EndIf
				MSCBSAY(76,04,+alltrim(Upper(QRY->CLASS_PEDIDO)	)									,"N",cTpFonte,cFonte5)
				MSCBSAY(01,06,replicate("..",56)													,"N",cTpFonte,cFonte3)
				MSCBSAY(04,09," " + Alltrim(Upper(QRY->NOMCLI))										,"N",cTpFonte,cFonte7)
				MSCBLINEH(001,017,100,003,"B") //Linha horizontal
						
				if nSalto >= 04
					nCol    := 50
					if nSalto == 08
						MSCBEND()
						nSalto	:= 0
						nCol    := 04
						nlin	:= 18
						MSCBPRINTER(cImpressora,cPorta)
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
				
				nlin	+=10		
				nSalto  +=1		
				QRY->(dbskip())
			Enddo	
			
			MSCBEND()
			MSCBCLOSEPRINTER()
			MS_FLUSH()
			//cCodCli :=""
			nCol    := 0
			nlin	:= 0		
		 Else
			//Impressão das etiquetas de caixa, uma por etiqueta
			nSalto	:= 0
			nCol    := 04
			nlin	:= 18
			cCodCli := QRY->CODCLI

			MSCBPRINTER(cImpressora,cPorta)
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
			//MSCBSAY(nCol-2,nlin+20,Upper(mv_par10)		 		     						,"N",cTpFonte,cFonte7)
			//MSCBSAY(nCol,nlin,"" +Alltrim(QRY->NUMPED)				,"N",cTpFonte,cFonte5)
			////Número da Nota Fiscal
			//MSCBSAY(nCol,nlin+5,"" +Alltrim(QRY->NUMNF)				,"N",cTpFonte,cFonte4)
			////Núemro da Ordem de Separação
			//MSCBSAYBAR(nCol+17,nlin,Alltrim(Upper(QRY->SEPARACAO)) 	,"N","MB07",5,.F.,.T.,.F.,,2,1,.F.)			
			MSCBEND()
			MSCBCLOSEPRINTER()
			MS_FLUSH()
			//cCodCli :=""
			nCol    := 0
			nlin	:= 0
			QRY->(DbSkip())
			
		EndIf
	Enddo
	QRY->(DbcloseArea())
Return()

