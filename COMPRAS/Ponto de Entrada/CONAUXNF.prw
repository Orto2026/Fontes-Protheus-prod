#INCLUDE "TOTVS.CH"


User Function CONAUXNF()
Local aArea := GetArea()

//ValidPerg()

If !Pergunte("F060",.T.)
	Return( Nil )
Endif

Grava()

RestArea(aArea)
Return( Nil )

/*/{Protheus.doc} Grava
Grava as informacoes adicionais na tabela SE2
/*/

Static Function Grava()
Local cFilialSE2	:= xFilial("SE2")
Local cFilialSF1	:= xFilial("SF1") 
Local cFilialSD1	:= xFilial("SD1")


If Empty(SF1->F1_XUNID) .And. Reclock("SF1",.F.) 
			
	If Mv_Par01 == 1
		SF1->F1_XUNID := "E"
	ElseIf Mv_Par01 == 2
		SF1->F1_XUNID := "O"
	EndIf
	SF1->( MsUnlock() )
Else
	Conout('Nao foi possivel RECLOCK SF1')
Endif

dbSelectArea("SZO")
dbSetOrder(1)

	If dbSeek(xFilial("SZO")+SF1->F1_CHVNFE)
		RecLock("SF1",.F.)
		SF1->F1_XUNID 	:= SZO->ZO_XUNID
		MsUnlock()
	EndIf

/*
dbSelectArea("SD1")
SD1->( dbSetOrder(1) )

//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM                                                                                                     


If SD1->( MsSeek( cFilialSD1+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
	
	Do While SD1->( !EOF() ) .AND. cFilialSF1+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)==cFilialSD1+SD1->(D1_FORNECE+D1_LOJA+D1_SERIE+D1_COD)
		//ZP_FILIAL+ZP_NFEID+ZP_NITEM                                                                                                                                     

		dbSelectArea("SZP")
		dbSetOrder(1)

		If dbSeek(xFilial("SZP")+SF1->F1_CHVNFE+SD1->D1_ITEM)

			If( Reclock("SD1",.F.) )
				SD1->D1_DTVALID := SZP->ZP_DTVALID
			Else
				Conout('Nao foi possivel RECLOCK SE2')
			Endif

		EndIf

		SD1->( dbSkip() )


	Enddo
	
Endif

*/

dbSelectArea("SE2")
SE2->( dbSetOrder(6) )

If SE2->( MsSeek( cFilialSE2+SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC ) )
	
	Do While SE2->( !EOF() ) .AND. cFilialSF1+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)==cFilialSE2+SE2->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
		
		If( Reclock("SE2",.F.) )
			SE2->E2_XUNID := SF1->F1_XUNID
		Else
			Conout('Nao foi possivel RECLOCK SE2')
		Endif
			
		SE2->( dbSkip() )
	Enddo
	
Endif

Return(Nil)

/*/{Protheus.doc} ValidPerg
Cria pergunta
/*/
Static Function ValidPerg()
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i,j
Local nTamSX1	:= Len(SX1->X1_GRUPO)

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("F060",nTamSX1)

//aAdd(aRegs,{cPerg,"01","Hist. Contas a Pagar:","Hist?ico Contas a Pagar:","Hist?ico Contas a Pagar:","mv_ch1","C",99,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
Aadd(aRegs,{cPerg,"01","Unidade  ?","","","mv_ch1","N",01,0,3,"C","","Mv_Par01","Equipamentos","Equipamentos","Equipamentos","","","Ortopedia","Ortopedia","Ortopedia","","","","","","","","","","","","","","","","","","","",""})


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

Return( Nil )
