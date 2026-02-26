#INCLUDE "PROTHEUS.CH"
#Include "rwmake.Ch"


User Function EtiquetaPFI()

    Local cPFI := Space(20)
    Local lOk  := .F.

    // Loop até o usuário digitar algo ou cancelar
    While !lOk
        cPFI := InputBox("Digite o PFI/OP que deseja imprimir:", "Impressão de Etiqueta", cPFI)
        
        If Empty(cPFI)
            MsgStop("Nenhum valor digitado. Cancelando...", "Aviso")
            Return
        Else
            lOk := .T.
        EndIf
    EndDo

    // Aqui você pode chamar a impressão usando o valor digitado
    MsgInfo("Você digitou: " + cPFI, "Confirmação")

Retur
    If nOpc == 1
        DbSelectArea("OP1")
        DbSetOrder(1)
        If !DbSeek(cPFI)
            APMsgAlert("PFI/OP não localizado!")
            Return
        EndIf

        cProd    := OP1->OP_CODPROD
        cLote    := OP1->OP_LOTE
        cCodBar  := OP1->OP_CODBAR

        ImprimeEtiqueta(cProd, cLote, cCodBar)
    EndIf

Return

//====================================================================//
// Função para imprimir etiqueta centralizada
//====================================================================//
Static Function ImprimeEtiqueta(cProd, cLote, cCodBar)

    Local nCopias     := 1
    Local cImpressora := "ZEBRA"
    Local cPorta      := "LPT1"
    Local cFonte1     := "020,020"
    Local cFonte2     := "017,017"

    MSCBPRINTER(cImpressora, cPorta)
    MSCBCHKStatus(.F.)

    MSCBLOADGRAF("L70X70.GRF")     // Logo
    MSCBBEGIN(nCopias,4)

    MSCBSAY(15,01,"ORTOSINTESE IND. E COM. LTDA","N","0",cFonte1)

    MSCBBOX(05,10,95,30,3)
    MSCBSAY(25,12,"Produto: "+cProd,"N","0",cFonte2)
    MSCBSAY(25,16,"Lote: "+cLote,"N","0",cFonte2)
    
    Local nPosX := 30
    MSCBSAYBAR(nPosX,20,Alltrim(cCodBar),"B","MB04",10,.F.,.T.,.F.,,3,2,.F.)

    MSCBEND()
    MSCBCLOSEPRINTER()
    MS_FLUSH()

Return
