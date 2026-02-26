user function MT103DTLT

Local dData := Nil
Local lRet  := .T.

//lRet := MsgYesNo("Deseja que o sistema mantenha a data de validade do lote?")

If lRet    

dData := PARAMIXB[4] 

// Usuário deseja manter a data original informada na pré-nota
// 23/08/2022
EndIf

Return dData
