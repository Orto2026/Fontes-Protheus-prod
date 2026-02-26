#Include 'totvs.ch'

/*/
**************************************************************************************************************
Programa  : MT681INC
Descrição : Após a gravação dos dados na rotina de inclusão do apontamento de produção PCP Mod2
Autor     : Cesar Arneiro (CAERP Sistemas)
Data      :   /  /
**************************************************************************************************************
/*/
User Function MT681INC()

	Local cRecGrv := SuperGetMV("MV__RECGRV", /*lHelp*/, "VG01")
	Local cNum    := SC2->(C2_NUM + C2_ITEM)

	Local aSave    := GetArea()
	Local aSaveSC2 := SC2->(GetArea())

	If !Empty(cRecGrv)
		If AllTrim(SH6->H6_RECURSO) == cRecGrv
			RecLock("SC2", .F.)
				SC2->C2_XQTDROT := Transform(SH6->H6_QTDPROD, "@E 9999")
			MsUnlock()

			SC2->(dbSetOrder(1))	// Filial + Número + Item + Sequência
			SC2->(dbSeek(xFilial("SC2") + cNum))
			
			If SC2->C2_SEQUEN == '001'
				RecLock("SC2", .F.)
					SC2->C2_XQTDROT := Transform(SH6->H6_QTDPROD, "@E 9999")
				MsUnlock()
			EndIf
		EndIf
	EndIf

	RestArea(aSaveSC2)
	RestArea(aSave)

Return
