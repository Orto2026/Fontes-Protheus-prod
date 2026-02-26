#Include "protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#Include "TBIConn.ch"
#Include "PROTHEUS.ch"

/*/{Protheus.doc} ORTF0007
//TODO Rotina que dispara a ProcLote via ExecAuto
@author Pirolo
@since 09/05/2019
@version undefined
@param cEmpr, characters, Empresa onde o job executará
@param cFilProc, characters, Filial onde o Job executará
@return return, nil
@see (links_or_references)
/*/
User Function ORTF0007(aParam)
Local aCampos		:= {}
Local cLOTVENC 		:= "S"
Local RpcSetEnv 	:={}

default aParam	:= {"01", "01"}

If Type('__LocalDriver') == "U"
	_lAgend := .T.
	RpcSetType(3)
	RpcSetEnv(aParam[1], aParam[2])
	//Prepare Environment Empresa aParam[1] Filial aParam[2] FUNNAME "WFRCOB02"
	CONOUT("Iniciando Processo Agendado - ORTF0007")
	cParam := aParam[2]
EndIf  


If !LockByName("ORTF0007",.F.,.F.,.T.)
    Conout("ORTF0007 - Rotina já em execução.")
    Return
EndIf

//Altera o parametro que controla ultimo processamento para permitir reprocessamento se necessário
PutMV('MV_DATALOT',DtoC(dDataBase-1))
PutMV("MV_LOTVENC", "N")

Conout("ORTF0007 - Preparou ambiente ("+aParam[1]+"/"+aParam[2]+")")

Conout("ORTF0007 - Iniciado ProcLote   "+AllToChar(Date())+" "+Time())
ProcLote()
Conout("ORTF0007 - Finalizado ProcLote "+AllToChar(Date())+" "+Time())

PutMV("MV_LOTVENC", cLOTVENC)

UnLockByName("ORTF0007",.F.,.F.,.T.)

Return
