/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³  SF2460I ³ Autor ³ Raphael Camillo - Dema³ Data ³ Jan/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de Entrada na geracao da Nota Fiscal de saida        ³±±
±±³          ³ para Gravar dados de Exportacao 							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SF2460I()

_cAlias 		:= GetArea()
_cAliasD2 	:= GetArea("SD2")
_cAliasC5	:= GetArea("SC5")

// GRAVA TABELA CDL PARA NOTAS FISCAIS DE EXPORTACAO
If SF2->F2_EST == "EX"
	dbSelectArea("SD2")
	dbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	dbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA))
	While !Eof() .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
		
		dbSelectArea("SC5")
		dbSetOrder(1) //C5_FILIAL+C5_NUM
		dbSeek(SD2->(D2_FILIAL+D2_PEDIDO))
		
		dbSelectArea("CDL")
		dbSetOrder(1)
		//CDL_FILIAL+CDL_DOC+CDL_SERIE+CDL_CLIENT+CDL_LOJA+CDL_NUMDE+CDL_DOCORI+CDL_SERORI+CDL_FORNEC+CDL_LOJFOR+CDL_NRREG+CDL_ITEMNF+CDL_NRMEMO
		_cNumde 	:= Space(Len(CDL->CDL_NUMDE))
		_cDocOri	:= Space(Len(CDL->CDL_DOCORI))
		_cSerOri := Space(Len(CDL->CDL_SERORI))
		_cFornec := Space(Len(CDL->CDL_FORNEC))
		_cLjFor	:= Space(Len(CDL->CDL_LOJFOR))
		_cNrReg	:= Space(Len(CDL->CDL_NRREG))
		If !dbSeek(SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)+_cNumde+_cDocOri+_cSerOri+_cFornec+_cLjFor+_cNrReg+SD2->D2_ITEM)
			RecLock("CDL",.T.)
			CDL->CDL_FILIAL		:= SD2->D2_FILIAL
			CDL->CDL_DOC   		:= SD2->D2_DOC
			CDL->CDL_SERIE 		:= SD2->D2_SERIE
			CDL->CDL_CLIENT		:= SD2->D2_CLIENTE                 
			CDL->CDL_LOJA  		:= SD2->D2_LOJA
			CDL->CDL_ESPEC		:= SF2->F2_ESPECIE
			CDL->CDL_UFEMB		:= SC5->C5_XESTEMB
			CDL->CDL_LOCEMB		:= SC5->C5_XLOCEMB
			If AllTrim(SD2->D2_CF) == "7127"
				CDL->CDL_ACDRAW		:= SC5->C5_XACDRAW 		
			Else
				CDL->CDL_ACDRAW		:= ""	
			EndIf
			CDL->CDL_LOCDES		:= SC5->C5_XLOCEMB
			CDL->CDL_PRODNF		:= SD2->D2_COD
			CDL->CDL_ITEMNF		:= SD2->D2_ITEM
			MsUnlock()
		EndIf
		
		dbSelectArea("SD2") // Nao esquecer de Voltar o Alias do While senao fica em Loop
		dbSkip()
	EndDo
EndIf

RestArea(_cAliasC5)
RestArea(_cAliasD2)
RestArea(_cAlias)

Return
