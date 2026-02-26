#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณORTF0008  บAutor  ณMicrosiga           บ Data ณ  05/14/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ORTF0008(cProd, cLocal, cLoteCtl, cNumLote, cNumSeq, dDataVld)

Local cProd 	:= ""
Local cLocal 	:= ""
Local cLoteCtl := ""
Local cNumLote := ""
Local cNumSeq 	:= ""
Local dDataVld := CtoD("//")
Local aVetor 	:= {}
Local aTamCOD 	:= {}
Local aTamLOC 	:= {}
Local aTamLOT 	:= {}
Local aTamNLOT := {}
Local aTamSEQ 	:= {}
Local nOpc 		:= 4

Private lMsErroAuto := .F.

//RpcSetType(3)
//RpcSetEnv("01", "02")

aTamCOD := TamSx3("D5_PRODUTO")
aTamLOC := TamSx3("D5_LOCAL")
aTamLOT := TamSx3("D5_LOTECTL")
aTamNLOT := TamSx3("D5_NUMLOTE")
aTamSEQ := TamSx3("D5_NUMSEQ")

DbSelectArea("SD5")
/*
cProd 	:= PadR("MA014058",aTamCOD[1])
cLocal 	:= PadR("98",aTamLOC[1])
cLoteCtl := PadR("17/12/0002",aTamLOT[1])
cNumLote := PadR("",aTamNLOT[1])
cNumSeq 	:= PadR("9BSC0A",aTamSEQ[1])
dDataVld := dDataBase+90
*/

aadd(aVetor,{"D5_PRODUTO" ,cProd ,NIL})
aadd(aVetor,{"D5_LOCAL" ,cLocal ,NIL})
aadd(aVetor,{"D5_LOTECTL" ,cLoteCtl ,NIL})
aadd(aVetor,{"D5_NUMLOTE" ,cNumLote ,NIL})
aadd(aVetor,{"D5_NUMSEQ" ,cNumSeq ,NIL})
aadd(aVetor,{"B8_DTVALID" ,dDataVld ,NIL}) //Utiliza B8 mesmo
//aadd(aVetor,{"D5_DTVALID" ,dDataVld ,NIL}) //Utiliza B8 mesmo

MSExecAuto({|x,y| Mata390(x,y)},aVetor,nOpc)

If !lMsErroAuto
	ConOut("Alterado data de validade com sucesso! " + cProd)
Else
	MostraErro()
	Conout("Erro na altera็ใo da data!")
EndIf

//RESET ENVIRONMENT

Return !lMsErroAuto
