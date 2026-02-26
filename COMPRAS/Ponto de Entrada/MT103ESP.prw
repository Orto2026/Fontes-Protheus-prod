User Function MT103ESP()

Local cRetEsp 

cRetEsp := PARAMIXB[1]

If cRetEsp = "S"         
	CESPECIE:= "SPED"
Else
	CESPECIE:= Space(Len(SF1->F1_ESPECIE))
EndIf
Return ()
   
