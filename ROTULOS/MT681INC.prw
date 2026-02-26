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

	If !Empty(cRecGrv)
		If AllTrim(M->H6_RECURSO) == cRecGrv
			RecLock("SC2", .F.)
				SC2->C2_XQTDROT := SH6->H6_QTDAPONT
			MsUnlock()
		EndIf
	EndIf

Return
