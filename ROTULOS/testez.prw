#INCLUDE "PROTHEUS.CH"

User Function TesteGrau()
    Local cTexto := "Teste Grau 45°"

    // Abre a impressora Zebra (nome padrão da impressora no Windows)
    // Substitua "Zebra" pelo nome da sua impressora se for diferente
    MSCBOPEN("Zebra")

    // Começa a etiqueta
    MSCBWRITE("^XA")

    // Define charset UTF-8 (essencial para o °)
    MSCBWRITE("^CI28")

    // Imprime o texto na posição X=50, Y=50, fonte padrão A0, tamanho 30x30
    MSCBWRITE("^FO50,50^A0N,30,30^FD"+cTexto+"^FS")

    // Fecha a etiqueta
    MSCBWRITE("^XZ")

    // Fecha a impressora
    MSCBCLOSE()

    MsgInfo("Etiqueta enviada para teste. Verifique a impressão.")
Return
