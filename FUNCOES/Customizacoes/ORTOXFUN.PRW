#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ORTOXFUN บ Autor ณ AP6 IDE            บ Data ณ  23/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcoes Genericas - especifica                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณ GATIL01  บ Autor ณ AP6 IDE            บ Data ณ  23/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ gatilho do Inspecao de Processo                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function GATIL01() 
Local cRet := ""

Local nPNomina 	:= aScan(aHeader,{|x|AllTrim(x[2]) = "QP7_NOMINA" 	}) 
Local nPAFI 		:= aScan(aHeader,{|x|AllTrim(x[2]) = "QP7_AFI" 		}) 
Local nPAFS 		:= aScan(aHeader,{|x|Alltrim(x[2]) = "QP7_AFS" 		}) 

If AllTrim(SX7->X7_CAMPO) == "QP7_NOMINA" .AND. AllTrim(SX7->X7_CDOMIN) == "QP7_LIC"

	cVal1 := StrTran(AllTrim(M->QP7_NOMINA),",",".")
	nVal1 := Val(cVal1)
   cVal2 := StrTran(AllTrim(acols[n,nPAFI]),",",".")
	nVal2 := Val(cVal2)
	nRet := nVal1+nVal2       
	cRet := Str(nRet,8,2)                                   
			//Cnt.Dominio	QP7_AFI   

ElseIf AllTrim(SX7->X7_CAMPO) == "QP7_NOMINA" .AND. AllTrim(SX7->X7_CDOMIN) == "QP7_LSC"
			//Cnt.Dominio	QP7_AFS   
	cVal1 := StrTran(AllTrim(M->QP7_NOMINA),",",".")
	nVal1 := Val(cVal1)
   cVal2 := StrTran(AllTrim(acols[n,nPAFS]),",",".")
	nVal2 := Val(cVal2)
	nRet := nVal1+nVal2
	nRet := nVal1+nVal2
	cRet := Str(nRet,8,2)                                   
ElseIf AllTrim(SX7->X7_CAMPO) == "QP7_AFI"
			//Cnt.Dominio	QP7_LIC   
	cVal1 := StrTran(AllTrim(acols[n,nPNomina]),",",".")
	nVal1 := Val(cVal1)
	cVal2 := StrTran(Alltrim(M->QP7_AFI),",",".")
	nVal2 := Val(cVal2)
	nRet := nVal1+nVal2
	cRet := Str(nRet,8,2)                                   

ElseIf AllTrim(SX7->X7_CAMPO) == "QP7_AFS"
			//Cnt.Dominio	QP7_LIC   
	cVal1 := StrTran(AllTrim(acols[n,nPNomina]),",",".")
	nVal1 := Val(cVal1)
	cVal2 := StrTran(Alltrim(M->QP7_AFS),",",".")
	nVal2 := Val(cVal2)
	nRet := nVal1+nVal2
	cRet := Str(nRet,8,2)                                    

EndIf

Return(cRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณ GATIL02  บ Autor ณ AP6 IDE            บ Data ณ  23/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ gatilho do Inspecao de Entrada                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function GATIL02()
Local cRet := ""

Local nPNomina 	:= aScan(aHeader,{|x|AllTrim(x[2]) = "QE7_NOMINA" 	}) 
Local nPAFI 		:= aScan(aHeader,{|x|AllTrim(x[2]) = "QE7_AFI" 		}) 
Local nPAFS 		:= aScan(aHeader,{|x|Alltrim(x[2]) = "QE7_AFS" 		}) 

If AllTrim(SX7->X7_CAMPO) == "QE7_NOMINA" .AND. AllTrim(SX7->X7_CDOMIN) == "QE7_LIC"

	cVal1 := StrTran(AllTrim(M->QE7_NOMINA),",",".")
	nVal1 := Val(cVal1)
   cVal2 := StrTran(AllTrim(acols[n,nPAFI]),",",".")
	nVal2 := Val(cVal2)
	nRet := nVal1+nVal2
	cRet := Str(nRet,8,2)                                   
			//Cnt.Dominio	QE7_AFI   

ElseIf AllTrim(SX7->X7_CAMPO) == "QE7_NOMINA" .AND. AllTrim(SX7->X7_CDOMIN) == "QE7_LSC"
			//Cnt.Dominio	QE7_AFS   
	cVal1 := StrTran(AllTrim(M->QE7_NOMINA),",",".")
	nVal1 := Val(cVal1)
   cVal2 := StrTran(AllTrim(acols[n,nPAFS]),",",".")
	nVal2 := Val(cVal2)
	nRet := nVal1+nVal2
	nRet := nVal1+nVal2
	cRet := Str(nRet,8,2)                                   
ElseIf AllTrim(SX7->X7_CAMPO) == "QE7_AFI"
			//Cnt.Dominio	QE7_LIC   
	cVal1 := StrTran(AllTrim(acols[n,nPNomina]),",",".")
	nVal1 := Val(cVal1)
	cVal2 := StrTran(Alltrim(M->QE7_AFI),",",".")
	nVal2 := Val(cVal2)
	nRet := nVal1+nVal2
	cRet := Str(nRet,8,2)                                   

ElseIf AllTrim(SX7->X7_CAMPO) == "QE7_AFS"
			//Cnt.Dominio	QE7_LIC   
	cVal1 := StrTran(AllTrim(acols[n,nPNomina]),",",".")
	nVal1 := Val(cVal1)
	cVal2 := StrTran(Alltrim(M->QE7_AFS),",",".")
	nVal2 := Val(cVal2)
	nRet := nVal1+nVal2
	cRet := Str(nRet,8,2)                                   

EndIf

Return(cRet)

/*/                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบ Funcao   ณ SETF1NUMDOC บ Autor ณ AP6 IDE            บ Data ณ  23/09/13บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ gatilho do Inspecao de Entrada                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
// Ajusta o numero do documento na nota fiscal de entrada (f1_Doc-validuser) para preencher com zeros a esquerda
User Function SetF1NumDoc()
If Val(cNFiscal) > 0
 	CNFISCAL := PADL(TRIM(CNFISCAL),TamSx3("F1_DOC")[1],"0") 
  	SysRefresh()
EndIf
Return(.T.)


/*                        
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GERALOTD1บAutor  ณRaphael Camillo-Demaบ Data ณ  23/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Formula padrao dos lotes nas notas de Entrada - NRE        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifivo ORTOSINTESE                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GERALOTD1(nChamada)
Local aArea := GetArea()
Local cLot, dDtV, cCod, cNumLote
Local cRet, cTemp, _cProd
cRet := &(Readvar())
If AllTrim(Funname()) $ "MATA103/MATA140/XMLNFE"  //Para nota fiscal de entrada e Classificacao do XML
	//a mascara do lote para MP e': 06/01/001
	//significa:
	//06	= Ano
	//01	= Mes
	//001	= Sequencia - reinicia a cada mes
	cTemp 	:= "MV_XLT"+SubStr(Dtos(dDatabase),3,2)+SubStr(Dtos(dDatabase),5,2)
	dbSelectArea("SX6")
	dbSetOrder(1)
	If !dbSeek(cFilAnt+cTemp)
		RecLock("SX6",.T.)
		SX6->X6_FIL			:= cFilAnt
		SX6->X6_VAR 		:= cTemp
		SX6->X6_TIPO 		:= "C"
		SX6->X6_DESCRIC		:= "Parametro Especifico com Numero do Lote MP - ORTO"
		SX6->X6_DSCSPA		:= "Parametro Especifico com Numero do Lote MP - ORTO"
		SX6->X6_DSCENG		:= "Parametro Especifico com Numero do Lote MP - ORTO"
		SX6->X6_DESC1		:= "Ano "+SubStr(Dtos(dDatabase),1,4)+" e Mes "+SubStr(Dtos(dDatabase),5,2)
		SX6->X6_DSCSPA1	:= "Ano "+SubStr(Dtos(dDatabase),1,4)+" e Mes "+SubStr(Dtos(dDatabase),5,2)
		SX6->X6_DSCENG1	:= "Ano "+SubStr(Dtos(dDatabase),1,4)+" e Mes "+SubStr(Dtos(dDatabase),5,2)
		SX6->X6_CONTEUD	:= "0001"
		SX6->X6_PROPRI		:= "U"
		MsUnlock()
	EndIf
	_cSeq 	:= GETMV(cTemp)
	cNumLote	:= SubStr(Dtos(dDatabase),3,2)+"/"+SubStr(Dtos(dDatabase),5,2)+"/"+_cSeq
	PutMv(cTemp,Soma1(_cSeq))
	If nChamada == 2
		cLot 		:= aScan(aHeader, {|x| Alltrim(x[2]) = "ZP_LOTECTL"})
		dDtV 		:= aScan(aHeader, {|x| Alltrim(x[2]) = "ZP_DTVALID"})
		cCod 		:= aScan(aHeader, {|x| Alltrim(x[2]) = "ZP_B1COD"})
	Else
		cLot 		:= aScan(aHeader, {|x| Alltrim(x[2]) = "D1_LOTECTL"})
		dDtV 		:= aScan(aHeader, {|x| Alltrim(x[2]) = "D1_DTVALID"})
		cCod 		:= aScan(aHeader, {|x| Alltrim(x[2]) = "D1_COD"})	
	EndIf


	_cProd := aCols[n,cCod]
	If Rastro(_cProd) .And. Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_TIPO") $ "MP/CC/SA/MC/EM/MS/IF/BN/PC" //Adcionado o tipo PC -Por Samuel Miranda 16/07/2024
		aCols[n,cLot] := cNumLote
		aCols[n,dDtv] := Ctod("31/12/49")
	Endif
EndIf

RestArea(aArea)

Return(cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณxBscOpLot บAutor  ณMauricio Prado      บ Data ณ  26/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que retorna a quantidade de MP da OP					  บฑฑ
ฑฑบ          ณ Lote passado como Parametro                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gatilho Pedido de compra - campo C7_XLOTE					     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xBscOpLot(cLote)

Local _nRet 	:= 0
Local _cQuery 	:= " "
Local _aArea	:= GetArea()

_cQuery := " SELECT DC_QTDORIG AS QUANT "
_cQuery += " FROM SDC010 SDC    "
_cQuery += " INNER JOIN SB1010 SB1 ON SB1.B1_COD = DC_PRODUTO AND SB1.D_E_L_E_T_ ='' AND SB1.B1_TIPO IN ('CC','MP') "
_cQuery += " WHERE DC_FILIAL ='01' AND SDC.D_E_L_E_T_ ='' AND DC_OP =( " 
_cQuery += " SELECT C2_NUM+C2_ITEM+C2_SEQUEN FROM SC2010 SC2 WHERE C2_FILIAL ='01' AND SC2.D_E_L_E_T_ ='' AND C2_LOTECTL ='"+cLote+"' AND C2_SEQUEN = ( "
_cQuery += " SELECT MAX(C2_SEQUEN) FROM SC2010 WHERE C2_FILIAL ='01' AND SDC.D_E_L_E_T_ ='' AND C2_LOTECTL ='"+cLote+"'))"



_cQuery := ChangeQuery( _cQuery )

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)

dbSelectArea("QRY")
dbGotop()
While !Eof()
	_nRet := QRY->QUANT
	dbSkip()
EndDo

dbCloseArea()
RestArea(_aArea)



Return(_nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณxBscOpProdบAutor  ณMauricio Prado      บ Data ณ  26/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que retorna a quantidade de MP da OP					  บฑฑ
ฑฑบ          ณ Lote passado como Parametro                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gatilho Pedido de compra - campo C7_XLOTE					     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xBscOpProd(cLote)

Local _nRet 	:= " "
Local _cQuery 	:= " "
Local _aArea	:= GetArea()

_cQuery := " SELECT DC_PRODUTO AS PRODUTO "
_cQuery += " FROM SDC010 SDC "
_cQuery += " INNER JOIN SB1010 SB1 ON SB1.B1_COD = DC_PRODUTO AND SB1.D_E_L_E_T_ ='' AND SB1.B1_TIPO IN ('CC','MP') "
_cQuery += " WHERE DC_FILIAL ='01' AND SDC.D_E_L_E_T_ ='' AND DC_OP =( " 
_cQuery += " SELECT C2_NUM+C2_ITEM+C2_SEQUEN FROM SC2010 SC2 WHERE C2_FILIAL ='01' AND SC2.D_E_L_E_T_ ='' AND C2_LOTECTL ='"+cLote+"' AND C2_SEQUEN = ( "
_cQuery += " SELECT MAX(C2_SEQUEN) FROM SC2010 WHERE C2_FILIAL ='01' AND SDC.D_E_L_E_T_ ='' AND C2_LOTECTL ='"+cLote+"'))"

_cQuery := ChangeQuery( _cQuery )

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)

dbSelectArea("QRY")
dbGotop()
While !Eof()
	_nRet := QRY->PRODUTO
	dbSkip()
EndDo

dbCloseArea()
RestArea(_aArea)




Return(_nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณxBscOpUmบAutor  ณMauricio Prado      บ Data ณ  26/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que retorna a quantidade de MP da OP					  บฑฑ
ฑฑบ          ณ Lote passado como Parametro                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gatilho Pedido de compra - campo C7_XLOTE					     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xBscOpUm(cLote)

Local _nRet 	:= " "
Local _cQuery 	:= " "
Local _aArea	:= GetArea()


_cQuery := " SELECT B1_UM AS UM FROM SB1010 WHERE B1_FILIAL ='' AND B1_TIPO IN ('MP','CC') AND B1_COD IN ( "
_cQuery += " SELECT DC_PRODUTO " 
_cQuery += " FROM SDC010 SDC "
_cQuery += " INNER JOIN SB1010 SB1 ON SB1.B1_COD = DC_PRODUTO AND SB1.D_E_L_E_T_ ='' AND SB1.B1_TIPO IN ('CC','MP') "
_cQuery += " WHERE DC_FILIAL ='01' AND SDC.D_E_L_E_T_ ='' AND DC_OP =( " 
_cQuery += " SELECT C2_NUM+C2_ITEM+C2_SEQUEN FROM SC2010 SC2 WHERE C2_FILIAL ='01' AND SC2.D_E_L_E_T_ ='' AND C2_LOTECTL ='"+cLote+"' AND C2_SEQUEN = ( "
_cQuery += " SELECT MAX(C2_SEQUEN) FROM SC2010 WHERE C2_FILIAL ='01' AND SDC.D_E_L_E_T_ ='' AND C2_LOTECTL ='"+cLote+"'))) "



_cQuery := ChangeQuery( _cQuery )

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)

dbSelectArea("QRY")
dbGotop()
While !Eof()
	_nRet := QRY->UM
	dbSkip()
EndDo

dbCloseArea()
RestArea(_aArea)




Return(_nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณxBscOpUmบAutor  ณMauricio Prado      บ Data ณ  26/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que retorna a quantidade de MP da OP					  บฑฑ
ฑฑบ          ณ Lote passado como Parametro                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gatilho Pedido de compra - campo C7_XLOTE					     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xBscOpDesc(cLote)

Local _nRet 	:= " "
Local _cQuery 	:= " "
Local _aArea	:= GetArea()


_cQuery := " SELECT B1_DESC AS DESCR FROM SB1010 WHERE B1_FILIAL ='' AND B1_TIPO IN ('MP','CC') AND B1_COD IN ( "
_cQuery += " SELECT DC_PRODUTO " 
_cQuery += " FROM SDC010 SDC "
_cQuery += " INNER JOIN SB1010 SB1 ON SB1.B1_COD = DC_PRODUTO AND SB1.D_E_L_E_T_ ='' AND SB1.B1_TIPO IN ('CC','MP') "
_cQuery += " WHERE DC_FILIAL ='01' AND SDC.D_E_L_E_T_ ='' AND DC_OP =( " 
_cQuery += " SELECT C2_NUM+C2_ITEM+C2_SEQUEN FROM SC2010 SC2 WHERE C2_FILIAL ='01' AND SC2.D_E_L_E_T_ ='' AND C2_LOTECTL ='"+cLote+"' AND C2_SEQUEN = ( "
_cQuery += " SELECT MAX(C2_SEQUEN) FROM SC2010 WHERE C2_FILIAL ='01' AND SDC.D_E_L_E_T_ ='' AND C2_LOTECTL ='"+cLote+"'))) "



_cQuery := ChangeQuery( _cQuery )

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)

dbSelectArea("QRY")
dbGotop()
While !Eof()
	_nRet := QRY->DESCR
	dbSkip()
EndDo

dbCloseArea()
RestArea(_aArea)

Return(_nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ  Funcao  ณxProNivSZ2บAutor  ณMicrosiga           บ Data ณ  04/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o Proximo Numero Disponivel quando na Criacao de umaบฑฑ
ฑฑบ          ณNova Revisao no Cadastro de revisoes                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xProNumSZ2()

Local _cRet 	:= " "
Local _cQuery 	:= ""                       
Local _aArea	:= GetArea()
_cProduto		:= M->Z2_PRODUTO  

_cQuery := " SELECT MAX(Z2_REVDESE) AS RET "
_cQuery += " FROM "+RetSqlName("SZ2")+" SZ2 "
_cQuery += " WHERE Z2_FILIAL = '"+xFilial("SZ2")+"' AND Z2_PRODUTO = '"+_cProduto+"' " 
_cQuery += " AND D_E_L_E_T_ = ' ' "

_cQuery := ChangeQuery( _cQuery )

If Select("TRB1") <> 0                                                                             
  dbSelectArea("TRB1")
  dbCloseArea()
EndIf
	
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),'TRB1',.F.,.F.)
	
dbSelectArea('TRB1')
dbGoTop()
While !Eof()
	_cRet := Soma1(TRB1->RET,Len(SZ2->Z2_REVDESE))
	dbSkip()
EndDo
dbCloseArea()

RestArea(_aArea)
Return(_cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณ GATFATA14บ Autor ณ AP6 IDE            บ Data ณ  16/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gatilho para atualizar o CFOP quando alterar o TES na      บฑฑ
ฑฑบ          ณ rotina RFATA14 (Alt. Pedidos Liberados)                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function GatFata14(_cTes)

_aArea	:= GetArea()
_aAreaA1 := GetArea("SA1")
_aAreaF4 := GetArea("SC5")

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+M->C5_CLIENT+M->C5_LOJAENT)

_cDest := If(SA1->A1_EST=="EX","7",If(SA1->A1_EST $ GetMv("MV_ESTADO"),"5","6"))

dbSelectArea("SF4")
dbSetOrder(1)
dbSeek(xFilial("SF4")+_cTes)

_cCfop := _cDest+SubStr(SF4->F4_CF,2,3)


RestArea(_aAreaA1)
RestArea(_aAreaF4)
RestArea(_aArea)

Return(_cCfop)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ XCHKEND  บ Autor ณ AP6 IDE            บ Data ณ  03/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para Checar se o ENdereco (SBE) existe no momento doบฑฑ
ฑฑบ          ณ enderecamento                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function XCHKEND()
Local _cEnd		:= Space(Len(SDB->DB_LOCALIZ))
Local _aArea 	:= GetArea()
Local _aAreaB1 := SB1->(GetArea())
Local _aAreaBE := SBE->(GetArea())

If !Empty(GDFIELDGET("DB_LOCALIZ"))
	Return(GDFIELDGET("DB_LOCALIZ"))
EndIf

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+SDA->DA_PRODUTO)

dbSelectArea("SBE")
dbSetOrder(1) //BE_FILIAL+BE_LOCAL+BE_LOCALIZ
If !dbSeek(xFilial("SBE")+SDA->DA_LOCAL+SB1->B1_XLOCALI)
	Alert("Aten็ใo: O Endere็o "+SB1->B1_XLOCALI+" nใo estแ cadastro para este Armazaem!!!!")
Else
	_cEnd := SB1->B1_XLOCALI
EndIf

RestArea(_aAreaBE)
RestArea(_aAreab1)
RestArea(_aArea)

Return(_cEnd)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ XCALCDATAบ Autor ณ AP6 IDE            บ Data ณ  03/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para calcular o prazo de entrega                    บฑฑ
ฑฑบ          ณ enderecamento                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function XCALCDATA(cProduto,dDtEmi)         

Local _aArea1 	:= GetArea()
Local _dDtEnt   := dDtEmi

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+cProduto)  
//MsgAlert("entrou")

If SB1->B1_TIPE ='H'     
	_dDtEnt = dDtEmi + ROUND((SB1->B1_PE/24),0)
EndIf

If SB1->B1_TIPE ='D'     
	_dDtEnt = dDtEmi + SB1->B1_PE
EndIf

If SB1->B1_TIPE ='S'     
	_dDtEnt = dDtEmi + (SB1->B1_PE*7)
EndIf

If SB1->B1_TIPE ='M'     
	_dDtEnt = dDtEmi + (SB1->B1_PE*30)
EndIf

If SB1->B1_TIPE ='A'     
	_dDtEnt = dDtEmi + (SB1->B1_PE*365)
EndIf

If SB1->B1_TIPE =' '  .OR. SB1->B1_PE = 0   
	_dDtEnt = dDtEmi + 90
EndIf

RestArea(_aArea1)

Return(_dDtEnt)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ  Funcao  ณX415AProvaบ Autor ณ AP6 IDE            บ Data ณ  06/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para Mudar o Flag do Orcamento para Aprovado ou     บฑฑ
ฑฑบ          ณ Reprovado                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function X415Aprova(xOpcx)

Private	aOpc1	:= {"Aprovado", "Reprovado"}
Private	nOpc1	:= 1

If SCJ->CJ_STATUS $ "A/B"
	Aviso("Aten็ใo !","Esse Or็amento nใo requer Aprovacao !",{"Ok"})
	Return()
EndIf


@ 65,14 To 300,350 Dialog oDlg1 Title OemToAnsi("Aprovacao/Reprovacao do Orcamento")
@ 01,06 To 51,126 Title OemToAnsi("Situacao")
@ 10,12 Radio aOpc1 Var nOpc1
@ 80,135 BmpButton Type 1 Action Autoriza()
@ 95,135 BmpButton Type 2 Action Close(oDlg1)
Activate Dialog oDlg1 Centered

Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ  Funcao  ณ Autoriza บ Autor ณ AP6 IDE            บ Data ณ  06/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para Mudar o Flag do Orcamento para Aprovado ou     บฑฑ
ฑฑบ          ณ Reprovado                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Autoriza()

Close(oDlg1)

If nOpc1 == 1
	RecLock("SCJ")
	SCJ->CJ_STATUS		:= "A"
	MsUnlock()
EndIf

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณ CHKOPPAI  Autor ณ AP6 IDE            บ Data ณ  19/05/22    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Verifica se a OP informa e da familia				      บฑฑ
ฑฑบ          ณ 										                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CHKOPPAI(_cOp,_cOpPai)

_aArea	:= GetArea()
_aAreaF1 := GetArea("SF1")
_aAreaD1 := GetArea("SD1")

If SubStr(_cOp,1,6) == SubStr(_cOpPai,1,6)
	_cOp := _cOpPai
else
	_cOp := ""
EndIf 	

RestArea(_aAreaF1)
RestArea(_aAreaD1)
RestArea(_aArea)

Return(_cOp)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณ CHKFILE  Autor ณ AP6 IDE            บ Data ณ  19/05/22    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ 														      บฑฑ
ฑฑบ          ณ 										                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
/*
User Function XCHKFILE()


	dbSelectArea("C1H")
	dbSetOrder(1)

	If dbSeek(xFilial("C1H")+"")

		RecLock("C1H")
		MsUnlock()
	EndIf

	dbSelectArea("C1A")
	dbSetOrder(1)

	If dbSeek(xFilial("C1A")+"")

		RecLock("C1A")
		MsUnlock()
	EndIf

	dbSelectArea("C30")
	dbSetOrder(1)

	If dbSeek(xFilial("C30")+"")

		RecLock("C30")
		MsUnlock()
	EndIf

	dbSelectArea("CS4")
	dbSetOrder(1)

	If dbSeek(xFilial("CS4")+"")

		RecLock("CS4")
		MsUnlock()
	EndIf


	dbSelectArea("CWZ")
	dbSetOrder(1)

	If dbSeek(xFilial("CWZ")+"")

		RecLock("CWZ")
		MsUnlock()
	EndIf

	dbSelectArea("LEM")
	dbSetOrder(1)

	If dbSeek(xFilial("LEM")+"")

		RecLock("LEM")
		MsUnlock()
	EndIf

	dbSelectArea("SOR")
	dbSetOrder(1)

	If dbSeek(xFilial("SOR")+"")

		RecLock("SOR")
		MsUnlock()
	EndIf

	dbSelectArea("LF0")
	dbSetOrder(1)

	If dbSeek(xFilial("LF0")+"")

		RecLock("LF0")
		MsUnlock()
	EndIf

	dbSelectArea("T3E")
	dbSetOrder(1)

	If dbSeek(xFilial("T3E")+"")

		RecLock("T3E")
		MsUnlock()
	EndIf

	dbSelectArea("T5O")
	dbSetOrder(1)

	If dbSeek(xFilial("T5O")+"")

		RecLock("T5O")
		MsUnlock()
	EndIf

	dbSelectArea("V6Z")
	dbSetOrder(1)

	If dbSeek(xFilial("V6Z")+"")

		RecLock("V6Z")
		MsUnlock()
	EndIf

Return()
*/
