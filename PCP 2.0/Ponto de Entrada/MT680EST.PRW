#Include "Protheus.Ch"
#Include "rwmake.Ch"
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Rotina    | EST001      |Auto|                     | Data|  09/12/2023  |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Descricao | Rotina para impressao de etiquetas de Nota de Saida        |±±
//±±|   OK                                                                  |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±


User Function MT680EST()
Local nAcao := PARAMIXB[1]
Local lRet  := .F.

//If nAcao == 2 //Operador confirmou estorno 
////Executa processamento / validação de usuário 
//     lRet  := .T.
//Else lRet  := .F.
//
//EndIf
Return lRet
