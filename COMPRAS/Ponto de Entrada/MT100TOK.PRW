#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณMT100TOK  ณ Autor ณ Wallace Botelho       ณ Data ณ Nov/2008 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ impedir a inclusao de notas situacao tributaria invalida   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Prosintese                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Execblock Validador do Campo F1_CHVNFE                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Valida a posicao 01 a 02 Codigo do Estado do Fornecedor    บฑฑ
ฑฑบ          ณ Valida a posicao 23 a 25 Serie da Nota Fiscal              บฑฑ
ฑฑบ          ณ Valida a posicao 26 a 34 Numero da Nota Fiscal             บฑฑ
ฑฑบ          ณ Tamanho Total do Registro - 44 Caracteres                  บฑฑ
ฑฑบMelhorias ณ                                                            บฑฑ
ฑฑบ          ณ Tratamento para NF de devolucao                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MT100TOK()

Local _cCodUF	:= SubStr(aNfeDanfe[13],01,02)
Local _cSerCUNF	:= SubStr(aNfeDanfe[13],23,03)
Local _cNumNF	:= SubStr(aNfeDanfe[13],26,09)
Local _nTamChv	:= Len(AllTrim(aNfeDanfe[13]))
Local _cCNPJ	:= SubStr(aNfeDanfe[13],07,14)
Local _cNature	:= MaFisRet(,"NF_NATUREZA")
local I 		:= 0
local J 		:= 0
//Local _cSerNF 	:=""

local cArea := GetArea()
Local _aAreaD1	:= SD1->(GetArea())

lRet := .T.
nLin := 0

xCol:=aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CLASFIS"})
xProd:=aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})
xTes:=aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"})
xLot:=aScan(aHeader,{|x| AllTrim(x[2]) == "D1_LOTECTL"})
xCfop:=aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CF"})

// Caso Usem Formulario Proprio - Forca SPED na Especie
If cFormul == "S" .And. AllTrim(cEspecie) <> "SPED"
	cEspecie := "SPED"
EndIf


If AllTrim(cEspecie) == "SPED" .And. cFormul == "N"
	If _nTamChv < 44
		Aviso("Aten็ใo !","Tamanho Minimo da Chave da NFE nao confere! ",{"Ok"})
		lRet := .F.
	EndIf

	If cTipo == "N" .And. BscCodUF(_cCodUF) <> CUFORIG .And. lRet
		Aviso("Aten็ใo !","Codigo da Chave da NFE nao confere com a UF do Fornecedor!",{"Ok"})
		lRet := .F.
	EndIf

	If cTipo == "N" .And. _cCNPJ <> SA2->A2_CGC .And. lRet
		Aviso("Aten็ใo !","Codigo da Chave da NFE nao confere com a CNPJ do Fornecedor!",{"Ok"})
		lRet := .F.
	EndIf

	If cTipo == "D" .And. BscCodUF(_cCodUF) <> CUFORIG .And. lRet
		Aviso("Aten็ใo !","Codigo da Chave da NFE nao confere com a UF do Cliente!",{"Ok"})
		lRet := .F.
	EndIf

	If cTipo == "D" .And. _cCNPJ <> SA1->A1_CGC .And. lRet
		Aviso("Aten็ใo !","Codigo da Chave da NFE nao confere com a CNPJ do Cliente!",{"Ok"})
		lRet := .F.
	EndIf

	//If Val(_cSerNF) <> Val(cSerie) .And. lRet
		//Aviso("Aten็ใo !","Codigo da Chave da NFE nao confere com a Serie da NF Informada!",{"Ok"})
		//lRet := .F.
	//EndIf
	
	If _cNumNF <> cNFiscal .And. lRet
		Aviso("Aten็ใo !","Codigo da Chave da NFE nao confere com o Numero da NF Informada!",{"Ok"})
		lRet := .F.
	EndIf

	
EndIf


//Validacao da chave de acesso para CT-e - Wagner 15/10/2014
If AllTrim(cEspecie) == "CTE" .And. cFormul == "N"
	If _nTamChv < 44
		Aviso("Aten็ใo !","Tamanho Minimo da Chave do CTE nao confere! ",{"Ok"})
		lRet := .F.
	EndIf
EndIf

//Validacao da especie da NFE solicitado por Ana paula (Fiscal) - Samuel Miranda 03/03/2020
If AllTrim(cEspecie) $ "NFE/NF" .or. Empty(AllTrim(cEspecie)) .And. cFormul == "N"	
		Aviso("Aten็ใo !","Especie invalida! ",{"Ok"})
		lRet := .F.	
EndIf

_lGerFin := .F.

For I := 1 To Len(aCols)
	If aCols[I,Len(aHeader)+1]
		Loop
	EndIf
	If Posicione("SF4",1,xFilial("SF4")+aCols[I,xTes],"F4_DUPLIC") == "S"
		_lGerFin := .T.
	EndIf
Next
If _lGerFin .And. Empty(_cNature)
	Aviso("Aten็ใo !","Para notas que geram duplicata, a Natureza deve informada!",{"Ok"})
	lRet := .F.
EndIf

// VALIDACAO LOTE UNICO - INICIO
	For J := 1 To Len(aCols)

		If aCols[J,Len(aHeader)+1]
			Loop
		EndIf
		
		If SubStr(aCols[j,xCfop],2,3) <> "101"
			Loop
		EndIf

//		If aCols[j,xTes] <> ""
//			Loop
//		EndIf

		If Empty(aCols[J,xLot]) 
			Loop
		EndIf
		
		dbSelectArea("SD1")
		dbordernickname("D1LOTE")
		dbSeek(xFilial("SD1")+aCols[J,xLot]+"N")
		While ! Eof() .And. SD1->D1_FILIAL+SD1->D1_LOTECTL == xFilial("SD1")+aCols[J,xLot] 
			
				If SubStr(SD1->D1_CF,2,3) == "101" .And. !Empty(SD1->D1_TES)//SD1->D1_TESACLA =="   " MAURICIO 02/12 - NAO CLASSIFICAVA PRENOTA
				
					Aviso("Aten็ใo !","Lote informado jแ existe na base de dados. Verifique o Lote: "+aCols[J,xLot],{"Ok"})
					lRet := .F.
					Exit
				EndIf
				 
			DbSkip()
		EndDo
	Next
// VALIDACAO LOTE UNICO - FIM
RestArea(_aAreaD1)
RestArea(cArea)


Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณ BscCodUF บAutor  ณMicrosiga           บ Data ณ  05/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o Codido do Estado conforme UF                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BscCodUF(_cCodUF)


Local cUF 	:= ""
Local aUF 	:= {}
Local _nPos	:= 0

aadd(aUF,{"RO","11"}) // 01
aadd(aUF,{"AC","12"}) // 02
aadd(aUF,{"AM","13"}) // 03
aadd(aUF,{"RR","14"}) // 04
aadd(aUF,{"PA","15"}) // 05
aadd(aUF,{"AP","16"}) // 06 
aadd(aUF,{"TO","17"}) // 07
aadd(aUF,{"MA","21"}) // 08
aadd(aUF,{"PI","22"}) // 09
aadd(aUF,{"CE","23"}) // 10 
aadd(aUF,{"RN","24"}) // 11
aadd(aUF,{"PB","25"}) // 12
aadd(aUF,{"PE","26"}) // 13
aadd(aUF,{"AL","27"}) // 14
aadd(aUF,{"MG","31"}) // 15
aadd(aUF,{"ES","32"}) // 16
aadd(aUF,{"RJ","33"}) // 17
aadd(aUF,{"SP","35"}) // 18
aadd(aUF,{"PR","41"}) // 19
aadd(aUF,{"SC","42"}) // 20
aadd(aUF,{"RS","43"}) // 21
aadd(aUF,{"MS","50"}) // 22
aadd(aUF,{"MT","51"}) // 23
aadd(aUF,{"GO","52"}) // 24
aadd(aUF,{"DF","53"}) // 25
aadd(aUF,{"SE","28"}) // 26
aadd(aUF,{"BA","29"}) // 27
aadd(aUF,{"EX","99"}) // 28

_nPos 	:= aScan(aUF,{|x| x[2] == _cCodUF})
If _nPos <>  0
	cUF := aUF[_nPos][01]
EndIf

Return(cUF)
