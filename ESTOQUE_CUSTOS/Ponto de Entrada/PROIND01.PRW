#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
                            
/*                        
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERALOT   บAutor  ณRobson William      บ Data ณ  23/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Formula padrao dos lotes de MP e PA                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ D1_COD/D3_OP                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PROIND01()
Local i	:= 0
Local aArea := GetArea()
Local cLot, dDtV, cCod, cGrupo
Local cRet, cTemp
cRet := &(Readvar())
If Funname() $ "MATA103/MATA140/XMLNFE"  //Para nota fiscal de entrada e Classificacao do XML
	//a mascara do lote para MP e': 06/01/001
	//significa:
	//06	= Ano
	//01	= Mes
	//001	= Sequencia - reinicia a cada mes
	cLot := aScan(aHeader, {|x| Alltrim(x[2]) = "D1_LOTECTL"})
	dDtV := aScan(aHeader, {|x| Alltrim(x[2]) = "D1_DTVALID"})
	cCod := aScan(aHeader, {|x| Alltrim(x[2]) = "D1_COD"})
	cRet := aCols[n,cCod]
	If Rastro(cRet)
		If n > 1
			//Verifica se o lote eh valido
			If Alltrim(aCols[n-1,cLot]) <> ""
				cTemp := U_PROIND02()
				If Alltrim(cTemp) = ""
					cTemp := Soma1(Substr(aCols[n-1,cLot],7,3))
				Endif
				aCols[n,cLot] := Substr(dtos(dDatabase),3,2) + "/" + Substr(dtos(dDatabase),5,2) + "/" + cTemp
			Else
				//Verifica o acols inteiro para ver se alguma linha teve lote calculado
				cTemp := ""
				For i:=1 to len(aCols)
					If Alltrim(aCols[i,cLot]) <> ""
						cTemp := Soma1(Substr(aCols[i,cLot],7,3))
					Endif
				Next
				If cTemp = ""
					aCols[n,cLot] := U_fGetLot(1,aCols[n,cCod])
				Else
					aCols[n,cLot] := Substr(dtos(dDatabase),3,2) + "/" + Substr(dtos(dDatabase),5,2) + "/" + cTemp
				Endif
			Endif
		Else
			aCols[n,cLot] := U_fGetLot(1,aCols[n,cCod])
		Endif
		aCols[n,dDtv] := Ctod("31/12/49")
	Endif
Elseif funname() $ "MATA250" 
	//a mascara do lote do PA e': 0001A06
	//significa:
	//0001	= numero 0001 - reinicia a cada ano
	//A		= Janeiro (e assim por diante)
	//06	= Ano
	cRet := M->D3_COD
	cOpA := M->D3_OP
	cLotA:= ""
	If Rastro(cRet)
		If  M->D3_COD <> ""
			//Busca o codigo do lote na OP
			_aArea := SD3->(GetAreA())
			DbSelectArea("SC2")
			SC2->(DbSetOrder(1))
//			If SC2->(DbSeek(xFilial("SC2")+Substr(cOpA,1,6)))
			If SC2->(DbSeek(xFilial("SC2")+cOpA))
				cLotA := SC2->C2_LOTECTL
			Endif
			RestArea(_aArea)
			M->D3_LOTECTL := Iif(cLotA = "",U_fGetLot(2,M->D3_COD),cLotA)
			//M->D3_DTVALID := dDataBase + GetMv("MV_DTVALPD",.F.,1825)  //Validade de 5 anos     ALTERADO MAURICIO 03/04/2018
			//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออป
			//บRegra de Automatizacao da Validade do Lote do Produtoบ
			//ศอออออออออออออออออออออออออออออออออออออออออออออออออออออผ
			//Pirolo - Retirado o tratamento pois o mesmo foi realizado via gatilho
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+M->D3_COD)
				M->D3_DTVALID := YearSum(LastDay(dDataBase), Iif(AllTrim(SB1->B1_XSTERI) == "1", 5, 10)) 
				
			EndIf     
/*
			If dbSeek(xFilial("SB1")+M->D3_COD) .And. SB1->B1_TIPO $ "PA/PI" .And. LEN(ALLTRIM(M->D3_LOTECTL))==7
				If SB1->B1_XSTERI <> "1"
					M->D3_DTVALID := Ctod("31/12/49")
				Else
			   		M->D3_DTVALID := (dDataBase+1)+(365*5)
				EndIf
			EndIf
			*/
		Else
			Alert("Informe o codigo do produto!")
		Endif
	Endif
Elseif AllTrim(funname()) $ "MATA650"
	//a mascara do lote do PA e': 0001A06
	//significa:
	//0001	= numero 0001 - reinicia a cada Mes
	//A		= Ja5neiro (e assim por diante)
	//06	= Ano
	cRet := M->C2_PRODUTO
	If Rastro(M->C2_PRODUTO)
		If  M->C2_PRODUTO <> ""
			M->C2_LOTECTL := U_fGetLot(2,M->C2_PRODUTO)
		Else
			Alert("Informe o codigo do produto")
		Endif
	Endif
Elseif AllTrim(funname()) $ "MATA760"
	//a mascara do lote do PA e': 0001A06
	//significa:
	//0001	= numero 0001 - reinicia a cada ano
	//A		= Ja5neiro (e assim por diante)
	//06	= Ano
	cRet := SC2->C2_PRODUTO
	If Rastro(SC2->C2_PRODUTO)
		If SC2->C2_PRODUTO <> ""
			SC2->C2_LOTECTL := U_fGetLot(2,SC2->C2_PRODUTO)
		Else
			Alert("Informe o codigo do produto")
		Endif
	Endif
Endif

RestArea(aArea)
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERALOT   บAutor  ณRobson William      บ Data ณ  23/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o novo codigo de lote                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fGetLot(_cOpt,cCod)
Local cRet
Local cB8Filial
Local cTemp		:= ""
Local cNomMes	:= fNomeMes()
//Verifica o arquivo de lotes para verificar a proxima sequencia
DbSelectArea("SB8")  //abre a area apenas para pegar a filial
cB8Filial := xFilial("SB8")
DbSelectArea("SC2")
cC2Filial := xFilial("SC2")

If _cOpt = 1
	//06/01/001
	_cQuery := " SELECT B8_LOTECTL AS LOTECTL FROM " + RETSQLNAME("SB8") 
	_cQuery += " WHERE B8_FILIAL = '"+cB8Filial+"'"
	_cQuery += " AND SUBSTRING(B8_LOTECTL,1,5) = '"+Substr(dtos(dDatabase),3,2) + "/" + Substr(dtos(dDatabase),5,2)+"'"
	_cQuery += " AND D_E_L_E_T_ = ''"
	_cQuery += " ORDER BY B8_LOTECTL DESC"
	_cQuery := ChangeQuery(_cQuery)
	TCQUERY _cQuery NEW ALIAS "QSB8"

Else
	//00001A06
	//AAM000001 -- Alterado em 01/04/2018
	_cQuery := " SELECT C2_LOTECTL AS LOTECTL "
	_cQuery += " FROM " + RETSQLNAME("SC2")
	_cQuery += " WHERE D_E_L_E_T_ <> '*' "
	_cQuery += " AND C2_FILIAL = '"+cC2Filial+"'"
	_cQuery += " AND SUBSTRING(C2_LOTECTL,1,3) = '"+cNomMes+"'" // altera em 26/03 - colocar no ar em 01/04/2018 - Novo Formato AAM000000
	_cQuery += " GROUP BY C2_LOTECTL "
	_cQuery += " ORDER BY C2_LOTECTL DESC "
	_cQuery := ChangeQuery(_cQuery)
	TCQUERY _cQuery NEW ALIAS "QSB8"
Endif

If _cOpt = 1
	If !Eof()
		cRet := Substr(QSB8->LOTECTL,7,3)
	Else // Caso seja a primeira
		cRet := "000"
	EndIf
Else 
	cSX6 	:= "MV_YLT"+cNomMes
	dbSelectArea("SX6")
	dbSetOrder(1)
	If !dbSeek(cFilAnt+cSX6)
		RecLock("SX6",.T.)
		SX6->X6_FIL			:= cFilAnt
		SX6->X6_VAR 		:= cSX6
		SX6->X6_TIPO 		:= "C"
		SX6->X6_DESCRIC	:= "Parametro Especifico com Numero do Lote PA - ORTO"
		SX6->X6_DSCSPA		:= "Parametro Especifico com Numero do Lote PA - ORTO"
		SX6->X6_DSCENG		:= "Parametro Especifico com Numero do Lote PA - ORTO"
		SX6->X6_DESC1		:= "Ano "+cNomMes
		SX6->X6_DSCSPA1	:= "Ano "+cNomMes
		SX6->X6_DSCENG1	:= "Ano "+cNomMes
		SX6->X6_CONTEUD	:= "000000" // alterado em 26/03/18 - colcoar no ar em 01/04/18
		SX6->X6_PROPRI		:= "U"
		MsUnlock()
	EndIf
	cRet := AllTrim(GetMv(cSX6)) // Pega o Ultimo Lote usado dentro do Mes -- Era -> Substr(QSB8->LOTECTL,1,4) em 12/08/2014
Endif

dbSelectArea("QSB8")
DbCloseArea()

If _cOpt = 1 // Nos Casos de Pre-Nota ainda nao atualiza o SB8, neste caso checa as notas de entrada para pegar o ultimo lote
	_cQuery := " SELECT D1_LOTECTL AS LOTECTL FROM " + RETSQLNAME("SD1") 
	_cQuery += " WHERE D1_FILIAL = '"+xFilial("SD1")+"'"
	_cQuery += " AND SUBSTRING(D1_LOTECTL,1,5) = '"+Substr(dtos(dDatabase),3,2) + "/" + Substr(dtos(dDatabase),5,2)+"'"
	_cQuery += " AND D_E_L_E_T_ = ''"
	_cQuery += " ORDER BY D1_LOTECTL DESC"
	_cQuery := ChangeQuery(_cQuery)
	TCQUERY _cQuery NEW ALIAS "QSD1"
	If !Eof()
		cRet := IIF(cRet < Substr(QSD1->LOTECTL,7,3), Substr(QSD1->LOTECTL,7,3), cRet)
	EndIf
	dbCloseArea("QSD1")
EndIf

cTemp := Soma1(cRet)

//Verifica o codigo do mes
If _cOpt = 2
	cRet := cNomMes+cTemp
	PutMv(cSX6,cTemp) // Grava o Ultimo Lote Usado para PA
Else
	cRet := Substr(dtos(dDatabase),3,2) + "/" + Substr(dtos(dDatabase),5,2) + "/" + cTemp
Endif

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERALOT   บAutor  ณRobson William      บ Data ณ  23/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a letra do mes                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fNomeMes()
Local cRet := ""

Do  Case
	Case Upper(mes(ddatabase)) = "JANEIRO"
		cRet := Substr(dtos(dDatabase),3,2) + "A"
	Case Upper(mes(ddatabase)) = "FEVEREIRO"
		cRet := Substr(dtos(dDatabase),3,2) + "B"
	Case Upper(mes(ddatabase)) $ "MARCO/MARวO"
		cRet := Substr(dtos(dDatabase),3,2) + "C"
	Case Upper(mes(ddatabase)) = "ABRIL"
		cRet := Substr(dtos(dDatabase),3,2) + "D"
	Case Upper(mes(ddatabase)) = "MAIO"
		cRet := Substr(dtos(dDatabase),3,2) + "E"
	Case Upper(mes(ddatabase)) = "JUNHO"
		cRet := Substr(dtos(dDatabase),3,2) + "F"
	Case Upper(mes(ddatabase)) = "JULHO"
		cRet := Substr(dtos(dDatabase),3,2) + "G"
	Case Upper(mes(ddatabase)) = "AGOSTO"
		cRet := Substr(dtos(dDatabase),3,2) + "H"
	Case Upper(mes(ddatabase)) = "SETEMBRO"
		cRet := Substr(dtos(dDatabase),3,2) + "I"
	Case Upper(mes(ddatabase)) = "OUTUBRO"
		cRet := Substr(dtos(dDatabase),3,2) + "J"
	Case Upper(mes(ddatabase)) = "NOVEMBRO"
		cRet := Substr(dtos(dDatabase),3,2)  + "K"
	Case Upper(mes(ddatabase)) = "DEZEMBRO"
		cRet := Substr(dtos(dDatabase),3,2) + "L"
	Otherwise
		cRet := Substr(dtos(dDatabase),3,2) + "Z"
EndCase

Return cRet