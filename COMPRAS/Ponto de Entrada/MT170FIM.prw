#Include 'Protheus.ch'

User Function MT170FIM( )

Local aScs := PARAMIXB[1]
Local nX := 0

For nX:= 1 To Len(aScs)

    dbSelectArea('SC1')
    If dbSeek(xFilial('SC1')+aScs[nX,2])
        Reclock('SC1',.F.)
        SC1->C1_OBS := 'SC gerada por ponto de pedido'
        MsUnlock()     
    Endif
    
    If SC1->C1_LOCAL == "11"
      RecLock("SC1",.F.)
      SC1->C1_UNIDREQ:= "00001"
      SC1->C1_CODCOMP:= "031"
      SC1->C1_CC:= "111260"
      MsUnlock()
   EndIf 	
Next
Return Nil
