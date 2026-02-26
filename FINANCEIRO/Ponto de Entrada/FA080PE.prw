#INCLUDE "PROTHEUS.CH"

User Function FA080PE()

Reclock("SE5",.F.)
SE5->E5_XUNID :=  SE2->E2_XUNID
SE5->E5_CCD   :=  SE2->E2_CCD 
MsUnlock()

Return 
