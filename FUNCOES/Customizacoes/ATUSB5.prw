#include 'protheus.ch'

User Function ATUSB5()

Local aAreaSB1 := GetArea()
Local aAreaSB5 := GetArea()

DbSelectArea("SB1")
DbGoTop()

DbSelectArea("SB5")

While !EOF("SB1") .AND.  xFilial("SB1")  == xFilial("SB5")
	
	If !Dbseek(xFilial("SB5")+SB1->B1_COD)
		
		RecLock('SB5', .T.)                                                       
		
		SB5->B5_COD := ALLTRIM(SB1->B1_COD)
		SB5->B5_CEME := SUBS(ALLTRIM(SB1->B1_DESC),1,70)
		SB5->B5_CODATIV := ALLTRIM(SB1->B1_POSIPI)
		SB5->B5_INSPAT := "1"
		
		MsUnlock()
		
	Endif
	
	DbSkip()
	
Enddo

RestArea(aAreaSB1)
RestArea(aAreaSB5)

Return (Nil)
