#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ F240TIT  ³ Autores ³ Montes - Thinkfast     ³ Data ³08/03/2023³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ PE na marcacao de titulo na tela de bordero de pagamentos     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alteração ³                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F240TIT()

Local lBxTit    := .T.
Local lInformar := .T.
Local aArea     := GETAREA()
Local lPergunta := IsInCallStack("FA240MARK")

While .T.

    lInformar := .F.

    dbSelectArea("SA2")
    dbSetOrder(1)
    dbSeek(xFilial("SA2")+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)
    dbSelectArea("SE2TMP")

    If cModPgto $ "30|31|11|13" .And. ( cModPgto <> SE2TMP->E2_FORMPAG .Or. EMPTY(SE2TMP->E2_CODBAR) )

        If lPergunta
            If Aviso("Atenção","Titulo sem a informação do Codigo de Barras para pagamento?",{"Informar","Retornar"}) = 1
                lInformar := .T.
            Else
                lBxTit := .F.
            EndIf
        Else 
            lBxTit := .F.
        EndIf

    ElseIf cModPgto $ "01|03|05|41|43|99" .And. ( cModPgto <> SE2TMP->E2_FORMPAG .Or. EMPTY(SA2->A2_BANCO) .OR. EMPTY(SA2->A2_AGENCIA) .OR. EMPTY(SA2->A2_NUMCON))

        If lPergunta
            If Aviso("Atenção","Dados da conta do fornecedor deste Titulo não preenchido no cadastro?",{"Informar","Retornar"}) = 1
                lInformar := .T.
            Else
                lBxTit := .F.
            EndIf
        Else
            lBxTit := .F.
        EndIf

    ElseIf cModPgto $ "45|" .And. ( cModPgto <> SE2TMP->E2_FORMPAG .Or. EMPTY(FNRETPIX(2)) )

        If lPergunta
            Aviso("Atenção","Fornecedor sem chave de PIX cadastrada para pagamento!",{"Retornar"})
        EndIf
        lBxTit := .F.

    EndIf
 
    If lInformar
        dbSelectArea("SE2")
        dbSetOrder(1)
        If dbSeek(xFilial("SE2")+SE2TMP->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
            //Chama ponto de entrada na gravação do titulo a pagar para abertura de 
            //tela de complemento das informações para pagamento via CNAB          
            U_MT100GE2()

            If !EMPTY(SE2->E2_CODBAR) .Or. !EMPTY(SE2->E2_FORMPAG)
                dbSelectArea("SE2TMP")
                RecLock("SE2TMP",.F.) 
                SE2TMP->E2_FORMPAG := SE2->E2_FORMPAG
                SE2TMP->E2_CODBAR  := SE2->E2_CODBAR
                MsUnLock()
            EndIf
        EndIf
        dbSelectArea("SE2TMP")
        Loop
    EndIf
    Exit
EndDo

RestArea(aArea)

Return lBxTit
