#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROIND02  ºAutor  ³Robson William      º Data ³  11/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ GATILHO PARA VERIFICAR UNICIDADE DO CODIGO DO LOTE         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ D1_LOTECTL/D3_LOTECTL                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PROIND02()
Local aArea		:= GetArea()
Local cLot, dDtV, cCod, cRet, cGrupo
Local i
//---------------
If Funname() $ "MATA103/MATA140/XMLNFE"  //Para nota fiscal de entrada e Classificacao do XML
	cLot := aScan(aHeader, {|x| Alltrim(x[2]) = "D1_LOTECTL"})
	dDtV := aScan(aHeader, {|x| Alltrim(x[2]) = "D1_DTVALID"})
	cCod := aScan(aHeader, {|x| Alltrim(x[2]) = "D1_COD"})
	cRet := aCols[n,cLot]
	bCont:= .T.
	If Rastro(aCols[n,cCod])
		//Verifica se no acols tem algum lote igual
		For i:=1 to len(aCols)
			If Alltrim(aCols[i,cLot]) = cRet
				If (Aviso("Aviso","Este numero de lote já foi usado anteriormente. Deseja realmente utilizá-lo novamente?",{"Sim","Não"})) = 2
					cRet := ""
					bCont:= .F.
				Else
					bCont:= .F.
				Endif
				Exit
			Endif
		Next
		If bCont
			If fExist(aCols[n,cLot])
				_cCdLte := U_fGetLot(1,aCols[n,cCod])
				If (Aviso("Aviso","Este numero de lote já foi usado anteriormente. Deseja realmente utilizá-lo novamente?",{"Sim","Não"})) = 2
					cRet := _cCdLte
				Endif		
				aCols[n,dDtV]	:= Ctod("31/12/49")
			Endif
		Endif
	Endif

Elseif funname() $ "MATA250"
	cRet := M->D3_LOTECTL
	If Rastro(M->D3_COD)
		If  M->D3_COD <> ""
			If fExist(M->D3_LOTECTL)
				M->D3_LOTECTL := ""
				_cCdLte := U_fGetLot(2,M->D3_COD)
				If (Aviso("Aviso","Este numero de lote já foi usado anteriormente. Deseja realmente utilizá-lo novamente?",{"Sim","Não"})) = 2
					cRet := _cCdLte
				Endif
			Endif
			M->D3_DTVALID := dDataBase + 1825  //Validade de 5 anos
		Else
			Alert("Informe o codigo do produto")
		Endif
	Endif
Endif

RestArea(aArea)
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROIND02  ºAutor  ³Robson William      º Data ³  11/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se o lote digitado jah existe                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fExist(_cLtCtl)
Local bRet := .F.
Local aB8Area

_cQryB8 := " SELECT COUNT(*) AS QTD FROM " + RETSQLNAME("SB8")
_cQryB8 += " WHERE B8_FILIAL = '"+xFilial("SB8")+"' 
_cQryB8 += " AND B8_LOTECTL = '"+_cLtCtl+"'"
_cQryB8 :=  ChangeQuery(_cQryB8)

TCQUERY _cQryB8 NEW ALIAS "QSB8"

If !Eof()
	If QSB8->QTD > 0
		bRet := .T.
	Endif
Endif
DbCloseArea("QSB8")

Return bRet