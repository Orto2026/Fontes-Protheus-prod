#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RMANA94   º Autor ³ AP5 IDE            º Data ³  02/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP5 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RMANA94
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Instrucao Para Utilizacao desta Rotina:                                ³
//³                                                                       ³
//³- Criar Um Arquivo DBF com os Dados a Serem Alterados.                 ³
//³- Os Campos a Serem Atualizados Devem Conter o Mesmo Nome dos Campos no³
//³Siga.                                                                  ³
//³- O Arquivo Devera Conter Obrigatoriamente um Campo Chamado Codigo para³
//³a Regua de Processamento                                               ³
//³- O Chave de Pesquisa devera ser informada no Parametro 4.             ³
//³Ex.: "CODIGO+LOJA", Sera rodado como Macro.                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cDirect := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cDirect := __RelDir

aRegs := {}
cPerg := "MANA94"
Aadd(aRegs,{cPerg,"01","Nome do Arquivo    ?","","","mv_ch1","C",20,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Alias do Arquivo   ?","","","mv_ch2","C",03,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Ordem do Arquivo   ?","","","mv_ch3","N",01,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Chave de Pesquisa  ?","","","mv_ch4","C",30,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg( aRegs, cPerg)

If ! Pergunte(cPerg,.T.)
	Return
EndIf

_cArquivo := _cDirect+AllTrim(Mv_Par01)

If !File(_cArquivo)
	Aviso("Aviso","Arquivo Nao Encontrado"+_cArquivo,{"OK"},1,"Problema")
	Return
EndIf

dbUseArea(.t.,__LocalDriver,_cArquivo,"ATUALIZA",.F.,.F.)

Processa({|| Geracao()}," "+" Atualizacao de Banco de Dados - "+Mv_Par02,,.F.)

dbSelectArea("ATUALIZA")
dbCloseArea()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GERACAO  ³ Autor ³ Raphael Camillo Proto ³ Data ³ 16/03/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Geracao do Arquivo PMD                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Videolar - Disney.                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Geracao()
Local _nCount := 0
dbSelectArea("ATUALIZA")
ProcRegua(Reccount())
dbGotop()
_cAlias   := "ATUALIZA"
_nTotReg  := RecCount()
_nTotAtu  := 0
While ! Eof()
	
	IncProc("Processando Cliente..."+ ATUALIZA->CODIGO)
	
	aCampos := {}
	For _nCount := 1 TO FCOUNT()
		AADD(aCampos, { FIELDNAME(_nCount), FIELDGET(_nCount) } )
	Next
	
	_cChave := (_cAlias)->(Mv_Par04)
	_cSeek2 := xFilial(Mv_Par02)+&_cChave
	
	dbSelectArea(Mv_Par02)
	dbSetOrder(Mv_Par03)
	If dbSeek(_cSeek2)
		RecLock(Mv_Par02,.F.)
		For _nCount := 1 TO LEN(aCampos)
			nPos := FIELDPOS(aCampos[_nCount,1])
			If nPos > 0 .And. !(aCampos[_nCount,1] $ "B1_COD,B1_DESC,A1_COD/A1_LOJA/A1_NOME/A2_COD/A2_LOJA/A2_NOME/RA_MAT/RA_FILIAL")
				FIELDPUT(nPos,aCampos[_nCount,2])
			EndIf
		Next
		MsUnlock()
		_nTotAtu++
	EndIf
	
	dbSelectArea("ATUALIZA")
	dbSkip()
EndDo
_cTexto1 := "Total de Registros Processados: "+Strzero(_nTotReg,10)+CHR(13)+CHR(10)
_cTexto2 := "Total de Registros Atualizados: "+Strzero(_nTotAtu,10)+CHR(13)+CHR(10)
_cTexto3 := "Total de Registros Desprezados: "+Strzero(_nTotReg-_nTotAtu,10)
Aviso("Aviso!!!",_cTexto1 + _cTexto2 + _cTexto3 ,{"OK"},2,"Fim da Atualizacao...")

Return