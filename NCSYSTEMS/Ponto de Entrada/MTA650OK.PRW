#INCLUDE "PROTHEUS.CH"

User function MTA650OK()
    LOCAL LRET := NIL  
    
    IF ISBLIND()//SE NAO FOR JOB, ABRE A TELA
      nOpc := 0
      LRET := .T.
    ENDIF
RETURN LRET
