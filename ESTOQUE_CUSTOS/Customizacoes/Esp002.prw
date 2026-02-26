#include "rwmake.ch"

User Function Esp002()				// Junior em 03/08/06
Local   nOpca   := 0
Local   aSays   := {}
Local   aButtons:= {}
Local   oDlg
Private cCadastro := OemToAnsi("Rotina de Enderecamento automatico (especifico Ortosintese)")

ValidPerg()

AADD(aSays,OemToAnsi("Esta rotina tem o intuito de enderecar automaticamente todos"))
AADD(aSays,OemToAnsi("os produtos da nota fiscal informada no parametro seguinte, "))
AADD(aSays,OemToAnsi("de acordo com o Endereco informado (3o parametro)."))

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End()}})
		
FormBatch(cCadastro, aSays, aButtons,,200,450 ) // Monta Caixa de dialogo
		
If nOpca == 1	
    Processa({|lEnd| ProcEnd()})
EndIf	
Return


Static Function ProcEnd()
Local  lErro      := .F.
Local  nX
Local  cItem
Local  nQtdSD1    := 0
Local  lTudoOK    := .T.
Private cNota     := Space(TamSx3("F1_DOC")[1])
Private cSerie    := Space(TamSx3("F1_SERIE")[1])
PRIVATE cEnder	  := Space(TamSx3("D1_ENDER")[1])
Private aItensEnd := {}
Private aCab      := {}
Private aItens    := {}
Private lMSHelpAuto
Private lMSErroAuto := .F.

IF ! Pergunte("ESP002",.T.)
	Return
EndIF

cNota  := MV_PAR01
cSerie := MV_PAR02
cEnder := MV_PAR03

If Empty(cNota)
	MsgBox("Nota fiscal informada incorreta!!!","Aviso","OK")
	Return
Endif

SD1->(DbSetOrder(1))
If !SD1->(DbSeek(xFilial("SD1")+cNota+cSerie,.F.))
	MsgBox("Nota fiscal informada incorreta ou inexistente!!!","Aviso","OK")
	Return
Endif

While SD1->(!Eof() .AND. D1_FILIAL+D1_DOC+D1_SERIE == xFilial("SD1")+cNota+cSerie)
	aadd(aItensEnd,{SD1->D1_COD,SD1->D1_LOCAL,SD1->D1_NUMSEQ,SD1->D1_DOC,cEnder,SD1->D1_QUANT,SD1->D1_DTDIGIT})
	++nQtdSD1
	If Empty(cEnder)
		lErro := .T.
		Exit
	Endif
	SD1->(DbSkip())
Enddo
If lErro
	MsgBox("Endereco nao preenchido!!!!","Aviso","OK")
	Return
Endif

If !MsgBox("Confirma o enderecamento dos produtos da Nota/Serie: "+cNota+"/"+cSerie,"Aviso","YESNO")
	Return
Endif

ProcRegua(nQtdSD1)
For nX:=1 to Len(aItensEnd)
	IncProc("Enderecando produto "+AllTrim(aItensEnd[nX,1])+"...")
	cItem := Item(aItensEnd[nX,2],aItensEnd[nX,5],aItensEnd[nX,3],aItensEnd[nX,1])
	aCAB  := {	{"DA_PRODUTO",aItensEnd[nX,1] , nil},;
				{"DA_LOCAL"  ,aItensEnd[nX,2] , nil},;
				{"DA_NUMSEQ" ,aItensEnd[nX,3] , nil},;
				{"DA_DOC"    ,aItensEnd[nX,4] , nil}}
	aITENS:= {{	{"DB_ITEM"   ,cItem           , nil},;
				{"DB_LOCALIZ",aItensEnd[nX,5] , nil},;
				{"DB_QUANT"  ,aItensEnd[nX,6] , nil},;
				{"DB_DATA"   ,aItensEnd[nX,7] , nil}}}           //MAURICIO{"DB_DATA"   ,dDATABASE       , nil}}}
	nModuloOld  := nModulo
	nModulo     := 4
	lMSHelpAuto := .T.
	lMSErroAuto := .F.
	SX3->(DbSetOrder(1))
	msExecAuto({|x,y|mata265(x,y)},aCab,aItens)
	nModulo := nModuloOld
	lMSHelpAuto := .F.
	If lMSErroAuto
		MostraErro()
		lTudoOK := .F.
	EndIf
Next

If lTudoOK
	MsgBox("Todos os itens foram enderecados com sucesso!!!!","Aviso","OK")
Else
	MsgBox("Ocorreram erros no processo de enderecamento. Favor verificar!!!","Aviso","OK")
Endif

Return


Static Function Item(cLocal,Localiz,cNumSeq,cProduto)
Local cItem     := ""
SDB->(DbSetOrder(1))
If SDB->(MsSeek(xFilial("SDB")+cProduto+cLocal+cNumSeq))
	While SDB->(!EOF() .and. xFilial("SDB")+cProduto+cLocal+cNumSeq ==;
		DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ)
		cItem := SDB->DB_ITEM
		SDB->(dbSkip())
	Enddo
	cItem := StrZero(val(cItem)+1,4)
Else
	cItem := "0001"
EndIf
Return cItem


	   
Static Function ValidPerg()
Local cPerg  := "ESP002"
Local cAlias := Alias()
Local aRegs  := {}
Local i,j

DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Nota Fiscal ?        ","","","mv_ch1","C",TamSX3("F2_DOC")[1],00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Serie ?              ","","","mv_ch2","C",03,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Endereco ?           ","","","mv_ch3","C",15,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SBE","",""})

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(cAlias)
Return