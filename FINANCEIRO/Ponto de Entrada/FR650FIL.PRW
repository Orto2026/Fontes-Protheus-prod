#Include "PROTHEUS.CH"
#Include "rwmake.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FR650FIL ³ Autor ³ Raphael Proto - Dema  ³ Data ³ 05/09/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada para pesquisa por numero bancario         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FA200FIL()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Retorna .F. caso encontre titulo do ITAU                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ o array aValores ir  permitir ³
//³ que qualquer exce‡„o ou neces-³
//³ sidade seja tratado no ponto  ³
//³ de entrada em PARAMIXB        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Estrutura de aValores
//	Numero do T¡tulo	- 01
//	data da Baixa		- 02
// Tipo do T¡tulo		- 03
// Nosso Numero			- 04
// Valor da Despesa		- 05
// Valor do Desconto	- 06
// Valor do Abatiment	- 07
// Valor Recebido    	- 08
// Juros				- 09
// Multa				- 10
// Outras Despesas		- 11
// Valor do Credito		- 12
// Data Credito			- 13
// Ocorrencia			- 14
// Motivo da Baixa 		- 15
// Linha Inteira		- 16
// Data de Vencto	   	- 17
User Function FR650FIL()
Local lRet   := .F.
Local nTamTit:= 10 // IDCNAB

// ja estou na tabela SE1
dbSetOrder(16)  // Filial+IdCnab primeiro consulta verificando se é primeira entrada Ocorrecia "02"
If dbSeek(xFilial("SE1")+ StrZero(Val(ParamIXB[1]),nTamTit) )   // numero do IDCNAB - antes ParamIXB[1,1]
		cEspecie := SE1->E1_TIPO
		lRet     := .T.
		nPos     := 1
EndIf

Return(lRet) 