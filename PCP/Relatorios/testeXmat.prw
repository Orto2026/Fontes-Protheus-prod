#include "Protheus.ch"

User Function U_TEST_REGEX()
    Local cDesc    := "Cúpula metálica 200mm x 10mm"
    Local oRegex   := RegexNew("\d+mm")  //\d ? qualquer dígito (0 a 9)  //literal "mm".
    Local aMatches := {}
    Local nI       := 0
//pega qualquer número seguido de "mm".
//Local bError  := ErrorBlock(  { |oError| alert(oError:Description),cRet:= })
 
    ConOut(">>> Texto analisado: " + cDesc)

    // Executa a busca
    aMatches := oRegex:Exec(cDesc)

    If Len(aMatches) > 0
        For nI := 1 To Len(aMatches)
            ConOut(">>> Achei medida: " + aMatches[nI])
        Next
    Else
        ConOut(">>> Nenhuma medida encontrada.")
    EndIf

Return

