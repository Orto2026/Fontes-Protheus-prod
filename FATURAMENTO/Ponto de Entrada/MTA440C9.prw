/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA440C9  ºAutor  ³Microsiga           º Data ³  01/02/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE na Criacao do SC9 - Itens do Pedido Liberado para       º±±
±±º          ³ Gravar campos customizados                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P12                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA440C9()

_aArea := GetArea()
_aAreaSC5	:= SC5->(GetArea())
_aAreaSC6	:= SC6->(GetArea())
_aAreaSC9	:= SC9->(GetArea())

If AllTrim(FUNNAME())$ "MATA410/MATA440/MATA455"
	
	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(SC5->C5_FILIAL+SC5->C5_NUM)
	While !Eof() .and. SC6->C6_FILIAL == SC5->C5_FILIAL .and. SC6->C6_NUM == SC5->C5_NUM

	   	If Empty(SC6->C6_XLIBPED)     
			RecLock("SC6", .F.)
			SC6->C6_XLIBPED := DDATABASE
			MsUnLock()
	   	EndIf 
	   	
	   	If !Empty(SC6->C6_XLIBPED) .and. AllTrim(FUNNAME())$ "MATA410/MATA440
			RecLock("SC6", .F.)
			SC6->C6_XLIBPED := DDATABASE
			MsUnLock()    
		EndIf
		
		
		DbSelectArea("SC9")
		DbSetOrder(1)
		If dbSeek(SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM)
			
			While !Eof() .and. SC6->C6_FILIAL == SC9->C9_FILIAL .and. SC6->C6_NUM == SC9->C9_PEDIDO .and. SC6->C6_ITEM == SC9->C9_ITEM
				RecLock("SC9",.F.)
				SC9->C9_XLIBPED := SC6->C6_XLIBPED
				SC9->C9_CLASPED := SC6->C6_CLASPED
				SC9->C9_XEMISSA := Posicione("SC5",1,SC9->(C9_FILIAL+C9_PEDIDO),"C5_EMISSAO")
				MsUnlock()
				dbSelectArea("SC9")
				dbSkip()
			EndDo
		
		EndIf
		
		dbSelectArea("SC6")
		dbSkip()
		
	EndDo
EndIf        

RestArea(_aAreaSC5)
RestArea(_aAreaSC6)
RestArea(_aAreaSC9) 

Restarea(_aArea)
Return()