#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ M460FIM  ³ Autor ³ ARM           º Data ³dd/mm/aa 			 º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ - Utilizado na Geracao da Nota Fiscal de Saida               ³±±
±±º          ³ - Ponto de entrada disparado na geracao da nota de saida.    º±±
±±º          							          											 º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ 						         										    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³                                                            ³±±
±±³            ³                                                            ³±±
±±³            ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function M460FIM()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva Areas de Trabalho        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aArea	:= GetArea()			// Inicializa array para capturar Area de Trabalho desconhecida
Local _aAreaSB1	:= SB1->(GetArea())	// Inicializa array para capturar Area de Trabalho SB1
Local _aAreaSF2 := SF2->(GetArea())	// Inicializa array para capturar Area de Trabalho SF2
Local _aAreaSD2	:= SD2->(GetArea())	// Inicializa array para capturar Area de Trabalho SD2
Local _aAreaSA1	:= SA1->(GetArea())	// Inicializa array para capturar Area de Trabalho SA1
Local _aAreaSA2	:= SA2->(GetArea())	// Inicializa array para capturar Area de Trabalho SA2
Local _aAreaSC5	:= SC5->(GetArea())	// Inicializa array para capturar Area de Trabalho SC5
Local _aAreaSF4	:= SF4->(GetArea())	// Inicializa array para capturar Area de Trabalho SF4

//_lFecha := .f.
Local lPV 	   := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona SD2 - itens da nota fiscal                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD2")
dbSetOrder(3)                 //filial,doc,serie,cliente,loja,cod
dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE)

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)

If SC5->C5_XTPLIB == "P"
	RecLock("SC5",.F.)
    SC5->C5_XLIBFAT := "N"
    SC5->C5_XUSRLIB := " "
    SC5->C5_XDTLIB  := Ctod("  /  /  ")
	SC5->C5_XTPLIB  := " "
	MsUnlock()
ElseIf SC5->C5_XTPLIB == "T"
	RecLock("SC5",.F.)
    SC5->C5_XLIBFAT := "E"
	MsUnlock()
EndIf

If SF2->(FieldPos("F2_CLASPED")) > 0
	RecLock("SF2",.F.)
	SF2->F2_CLASPED	:= SC5->C5_CLASPED
	MsUnLock()
EndIf

&& SF2 está posicionado na nota gerada:


SE1->(dbSetOrder(1))

If SE1->(dbSeek( xFilial("SE1") + SF2->F2_SERIE + SF2->F2_DOC  ))
	
	Do While SE1->(!Eof()) .and. (SE1->E1_PREFIXO == SF2->F2_SERIE) .and. (SE1->E1_NUM == SF2->F2_DOC)
		Reclock("SE1",.F.)
		
		If SE1->(FieldPos("E1_CLASPED")) > 0
			SE1->E1_CLASPED	:= SC5->C5_CLASPED
		EndIf
		SE1->(MsUnlock())
		SE1->(dbSkip())
	Enddo
	
Endif



MsUnLock()

// Fim da Gravacao da Tabela SZL


RestArea(_aAreaSF2)
RestArea(_aAreaSD2)
RestArea(_aAreaSA1)
RestArea(_aAreaSA2)
RestArea(_aAreaSC5)
RestArea(_aAreaSB1)
RestArea(_aAreaSF4)
RestArea(_aArea)

Return

