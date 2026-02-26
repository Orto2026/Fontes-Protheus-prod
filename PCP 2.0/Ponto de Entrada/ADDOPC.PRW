

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Função   | ADDOPC  | Autor | Samuel Miranda	     | Data |04/06/2024 |±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±|Descrição| P.E. Para posicionar o roteiro na SC2 (C2_ROTEIRO)          |±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±| Uso     | Ortositese-SIGAPCP                                          |±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//

User Function ADDOPC()
    //Variaveis 
	local aRegs      := PARAMIXB[1]
	local cProdAnt   := PARAMIXB[2]
	local cOpcionais := PARAMIXB[3]
	Local nRoteiro   :=  Alltrim(Substr(Alltrim(cOpcionais),1,3))
    // Customizações do usuário
	If nRoteiro =="102"
		M->C2_ROTEIRO := Alltrim(Substr(Alltrim(cOpcionais),4,3))
	EndiF
Return aRegs
