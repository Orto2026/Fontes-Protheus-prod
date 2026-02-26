#include "protheus.ch"
#define enter chr(13) + chr(10)

function u_F90SE5GRV()

Reclock("SE5",.F.)
SE5->E5_XUNID :=  SE2->E2_XUNID
SE5->E5_CCD   :=  SE2->E2_CCD 
MsUnlock()
 
return
