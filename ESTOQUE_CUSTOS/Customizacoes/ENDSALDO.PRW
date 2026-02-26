#INCLUDE "PROTHEUS.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Função   ³ ENDSALDO  ³ Autor ³ samuel Miranda    ³ Data ³ 12/01/2022  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Descrição ³ Fução para não bloquear endereço que tenha saldo 		  ³±±
±±³                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function ENDSALDO()

Local _aArea 	  := GetArea()
Local _aAreaSBE   := SBE->(GetArea())
Local _aAreaSBF   := SBF->(GetArea())
Local _cEndereco  := AllTrim(M->BE_LOCALIZ)
Local _cStatus    := AllTrim(M->BE_MSBLQL)
Local _cnLocal    := M->BE_LOCAL
Local lRet:= .T.

DBSelectArea('SBF')
DbSetOrder(1)	


//while !SBF->(Eof()) 
//if DBSeek(xFilial("SBF")+_cnLocal+alltrim(_cEndereco))  // SBF->BF_LOCAL+SBF->BF_LOCALIZ, 
if SB1->(DbSeek(XFilial("SBF")+_cnLocal+alltrim(_cEndereco)))
    If _cStatus ='1' .AND. SBF->BF_QUANT > 0 .AND. alltrim(SBF->BF_LOCALIZ) == alltrim(_cEndereco)
        MsgAlert("O Endereço possui Saldo!", "A T E N Ç Ã O !")
        //M->BE_MSBLQL
        lRet:= .F.
        //BREAK
    EndIf
EndIf
        //SBF->(DBSkip())
        //EndDo
RestArea(_aAreaSBE)
RestArea(_aAreaSBF)
RestArea(_aArea)

Return lRet 
