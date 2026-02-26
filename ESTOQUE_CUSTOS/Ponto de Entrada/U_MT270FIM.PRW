User Function MT270FIM()

    // Seleciona SC2
    DbSelectArea("SC2")
    DbSetOrder(1) // índice adequado, normalmente 1 = Filial + OP + Item + Seq

    // Busca a OP atual
    Local cOP   := SC2->C2_NUM
    Local cItem := SC2->C2_ITEM
    Local cSeq  := SC2->C2_SEQUEN

    If dbSeek(xFilial("SC2") + cOP + cItem + cSeq)
        RecLock("SC2", .F.)
            // Atualiza XQTDROT com a quantidade já baixada (C2_QUJE)
            SC2->C2_XQTDROT := SC2->C2_QUJE
        MsUnlock()
    EndIf

Return



