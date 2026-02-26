User Function F440COM()

LOCAL aArea			:= GetArea()
LOCAL aAreaSE1		:= SC7->( GetArea() )
LOCAL aAreaSE3		:= SC2->( GetArea() ) 


if INCLUI
    
    if SE1->E1_COMIS1 > 0
    RecLock("SE3",.T.)
    SE3->E3_BASE    := SE1->E1_VALOR
    SE3->E3_COMIS   := (SE1->E1_COMIS1*SE1->E1_VALOR/100)
    SE3->E3_FILIAL  := xFilial()          
    SE3->E3_VEND    := SE1->E1_VEND1
    SE3->E3_NUM     := SE1->E1_NUM        
    SE3->E3_SERIE   := SE1->E1_SERIE
    SE3->E3_PORC    := SE1->E1_COMIS1
    SE3->E3_CODCLI  := SE1->E1_CLIENTE    
    SE3->E3_LOJA    := SE1->E1_LOJA       
    SE3->E3_EMISSAO := SE1->E1_EMISSAO    
    SE3->E3_PREFIXO := SE1->E1_PREFIXO    
    SE3->E3_PARCELA := SE1->E1_PARCELA 
    SE3->E3_TIPO    := SE1->E1_TIPO       
    SE3->E3_ORIGEM  := "E"
    SE3->E3_VENCTO  := SE1->E1_VENCTO
    endif

    if SE1->E1_COMIS2 > 0

    RecLock("SE3",.T.)
    SE3->E3_BASE    := SE1->E1_VALOR
    SE3->E3_COMIS   := (SE1->E1_COMIS2*SE1->E1_VALOR/100)
    SE3->E3_FILIAL  := xFilial()          
    SE3->E3_VEND    := SE1->E1_VEND2
    SE3->E3_NUM     := SE1->E1_NUM        
    SE3->E3_SERIE   := SE1->E1_SERIE
    SE3->E3_PORC    := SE1->E1_COMIS2
    SE3->E3_CODCLI  := SE1->E1_CLIENTE    
    SE3->E3_LOJA    := SE1->E1_LOJA       
    SE3->E3_EMISSAO := SE1->E1_EMISSAO    
    SE3->E3_PREFIXO := SE1->E1_PREFIXO    
    SE3->E3_PARCELA := SE1->E1_PARCELA 
    SE3->E3_TIPO    := SE1->E1_TIPO       
    SE3->E3_ORIGEM  := "E"
    SE3->E3_VENCTO  := SE1->E1_VENCTO
    MsUnlock()    
    endif

    if SE1->E1_COMIS3 > 0
    RecLock("SE3",.T.)
    SE3->E3_BASE    := SE1->E1_VALOR
    SE3->E3_COMIS   := (SE1->E1_COMIS3*SE1->E1_VALOR/100)
    SE3->E3_FILIAL  := xFilial()          
    SE3->E3_VEND    := SE1->E1_VEND3
    SE3->E3_NUM     := SE1->E1_NUM        
    SE3->E3_SERIE   := SE1->E1_SERIE
    SE3->E3_PORC    := SE1->E1_COMIS3
    SE3->E3_CODCLI  := SE1->E1_CLIENTE    
    SE3->E3_LOJA    := SE1->E1_LOJA       
    SE3->E3_EMISSAO := SE1->E1_EMISSAO    
    SE3->E3_PREFIXO := SE1->E1_PREFIXO    
    SE3->E3_PARCELA := SE1->E1_PARCELA 
    SE3->E3_TIPO    := SE1->E1_TIPO       
    SE3->E3_ORIGEM  := "E"
    SE3->E3_VENCTO  := SE1->E1_VENCTO
    MsUnlock()    
    endif

    if SE1->E1_COMIS4 > 0
    RecLock("SE3",.T.)
    SE3->E3_BASE    := SE1->E1_VALOR
    SE3->E3_COMIS   := (SE1->E1_COMIS4*SE1->E1_VALOR/100)
    SE3->E3_FILIAL  := xFilial()          
    SE3->E3_VEND    := SE1->E1_VEND4
    SE3->E3_NUM     := SE1->E1_NUM        
    SE3->E3_SERIE   := SE1->E1_SERIE
    SE3->E3_PORC    := SE1->E1_COMIS4
    SE3->E3_CODCLI  := SE1->E1_CLIENTE    
    SE3->E3_LOJA    := SE1->E1_LOJA       
    SE3->E3_EMISSAO := SE1->E1_EMISSAO    
    SE3->E3_PREFIXO := SE1->E1_PREFIXO    
    SE3->E3_PARCELA := SE1->E1_PARCELA 
    SE3->E3_TIPO    := SE1->E1_TIPO       
    SE3->E3_ORIGEM  := "E"
    SE3->E3_VENCTO  := SE1->E1_VENCTO
    MsUnlock()    
    endif

    if SE1->E1_COMIS5 > 0
    RecLock("SE5",.T.)
    SE3->E3_BASE    := SE1->E1_VALOR
    SE3->E3_COMIS   := (SE1->E1_COMIS5*SE1->E1_VALOR/100)
    SE3->E3_FILIAL  := xFilial()          
    SE3->E3_VEND    := SE1->E1_VEND5
    SE3->E3_NUM     := SE1->E1_NUM        
    SE3->E3_SERIE   := SE1->E1_SERIE
    SE3->E3_PORC    := SE1->E1_COMIS5
    SE3->E3_CODCLI  := SE1->E1_CLIENTE    
    SE3->E3_LOJA    := SE1->E1_LOJA       
    SE3->E3_EMISSAO := SE1->E1_EMISSAO    
    SE3->E3_PREFIXO := SE1->E1_PREFIXO    
    SE3->E3_PARCELA := SE1->E1_PARCELA 
    SE3->E3_TIPO    := SE1->E1_TIPO       
    SE3->E3_ORIGEM  := "E"
    SE3->E3_VENCTO  := SE1->E1_VENCTO
    MsUnlock()    
    endif

endif

if !INCLUI .AND. !ALTERA .AND. AllTrim(SE1->E1_TIPO) == "RA"

    
    
    dbSelectArea("SE3")
    dbSetOrder(1)

    If DBSeek( SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM  + SE1->E1_PARCELA) 
	
  
	
    Do While SE3->( !EOF() ) .AND. (SE3->E3_FILIAL +SE3->E3_PREFIXO  + SE3->E3_NUM  + SE3->E3_PARCELA==SE1->E1_FILIAL + SE1->E1_PREFIXO  + SE1->E1_NUM  + SE1->E1_PARCELA) 
				
        If( Reclock("SE3",.F.) )
            DBDelete()
            MsUnlock()
		Else
			Conout('Nao foi possivel RECLOCK SE1')
		Endif
			
		SE3->( dbSkip() )
	Enddo
	
Endif
endif
RestArea(aAreaSE1)
RestArea(aAreaSE3)
RestArea(aArea)
Return
