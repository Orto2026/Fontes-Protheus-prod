#INCLUDE "PROTHEUS.CH"

User Function GrvDigito()
DbSelectArea("SB1")
SB1->(dbgotop())	
While ! SB1->(Eof()) 
	If !Empty (SB1->B1_CODBAR)	.AND. B1_TIPO = 'PA' 		   //.AND. B1_COD = '6800/03'
		RecLock("SB1",.F.)
		SB1->B1_CODBAR := trim(SB1->B1_CODBAR)+eandigito(trim(SB1->B1_CODBAR))
		SB1->(MsUnlock())	    
	EndIf
	SB1->(DbSkip())
Enddo
Return 
