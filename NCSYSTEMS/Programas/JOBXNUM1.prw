#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

//FÁBIO A. MICHELON - MICROTRUST
//OBJETIVO: JOB PARA EXECUÇÃO AUTOMÁTICA DOS APONTAMENTOS NO SISTEMA PROTHEUS ORIUNDOS DO SISTEMA NC-MES
//CONFIGURAR NO 'APPSERVER.INI'
//		[ONSTART] 
//		jobs=JOBXNUM1
//		RefreshRate=180 (segundos)
//		
//		[JOBXNUM1]
//		Main=U_JOBXNUM1
//		Environment=NC-SYS
//		nParms=2
//		parm1=99 (código da empresa => SM0->M0_CODIGO
//		parm2=01 (código da filial  => SM0->M0_CODFIL
//

User Function JOBXNUM1(_cEmpresa, _cFilial)

PREPARE ENVIRONMENT EMPRESA _cEmpresa FILIAL _cFilial TABLES "SB1", "SC2", "SH6", "SD3", "SG2", "SB2"

ConOut( "[JOBXNUM1][" + dtoc(Date()) + " - " + Time() + "]:Inicio do Job de Integração dos Apontamentos ..." )
u_NUMXMP1(.T.)
ConOut( "[JOBXNUM1][" + dtoc(Date()) + " - " + Time() + "]:Fim do Job de Integração dos Apontamentos." )

Return
