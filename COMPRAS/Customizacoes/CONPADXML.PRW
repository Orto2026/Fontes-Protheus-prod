#INCLUDE "rwmake.ch"    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONPADXML º Autor ³Raphael Camillo-Demaº Data ³  29/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para Criar Tabela Temporaria para consulta F3 dos   º±±
±±º          ³ Produtos Validos na Classificacao do XML                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10 - Especifico ORTOSINTESE - COMPRAS/XML                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CONPADXML(cPC)

Private cFilMov1 := SPACE(12)
Private cFilMov2 := SPACE(12)
Private cFilMov3 := SPACE(12)
Private lRet     := .F.      
Private aCampos  := {}
Private _stru    := {}
Private cFilSB1  := SB1->(Padr(xFilial('SB1'),4))

@ 65,0 To 500,750 Dialog mkwdlg Title OemToAnsi("Consulta Avançada de Produtos")

AADD(_stru,{"COD"  ,"C",TamSx3('B1_COD')[1],0})
AADD(_stru,{"DESC" ,"C",TamSx3('B1_DESC')[1],0})

aCampos :={	{ "COD"	,"Codigo"       ,PesqPict('SB1','B1_COD',TamSx3('B1_COD')[1])},;
            { "DESC"	,"Descrição"    ,PesqPict('SB1','B1_DESC',TamSx3('B1_DESC')[1])}}

cArq:=Criatrab(_stru,.T.)

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
Endif

DBUSEAREA(.t.,,carq,"TMP")

If Empty(cPC)
	cQuery := " SELECT B1_COD AS PRODUTO, B1_DESC AS DESCRICAO "    
	cQuery += " FROM " +  RetSqlName('SB1') + "  SB1 " 
	cQuery += " WHERE B1_FILIAL = '" + cFilSB1 + "'"
	cQuery += " AND SB1.B1_MSBLQL  = '2'           "
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "   
	cQuery += " ORDER BY B1_COD "
Else
	cQuery := " SELECT C7_PRODUTO AS PRODUTO, B1_DESC AS DESCRICAO "
	cQuery += " FROM " + RetSqlName("SC7") + " SC7 "
	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = C7_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE C7_FILIAL = '"+xFilial("SC7")+"' "
	cQuery += " AND C7_NUM = '"+cPC+"' "
	cQuery += " AND SC7.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY PRODUTO "
EndIf
	
If Select("TM5") <> 0
  dbSelectArea("TM5")
  dbCloseArea()
EndIf
	
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TM5',.F.,.F.)
	
dbSelectArea('TM5');dbGoTop()
While !Eof()
	DbSelectArea("TMP")
	RecLock("TMP",.T.)
	TMP->COD     :=  TM5->PRODUTO
	TMP->DESC    :=  TM5->DESCRICAO
	MsUnLock("TMP")
	dbSelectArea('TM5')
	dbSkip()
EndDo

DbSelectArea("TMP")
DbGotop()

@ 011,010 TO 200,370 BROWSE "TMP" FIELDS aCampos
@ 205,010 SAY "Filtros:"
@ 205,030 GET  cFilMov1  PICTURE "@!" 	SIZE 060,012
@ 205,098 SAY "+"
@ 205,110 GET  cFilMov2  PICTURE "@!" 	SIZE 060,012
@ 205,178 SAY "+"
@ 205,190 GET  cFilMov3  PICTURE "@!" 	SIZE 060,012
@ 203,260 BmpButton Type 17 Action Filtra(cPC)
@ 203,310 BmpButton Type  1 Action Seleciona()
@ 203,340 BmpButton Type  2 Action Cancela()
mkwdlg:Refresh()
SysRefresh()
Activate Dialog mkwdlg

Return lRet

Static Function Seleciona()
lRefresh := .T.
If !Empty(TMP->COD)
	M->ZP_B1COD	:= TMP->COD
	GDFIELDPUT("ZP_B1COD",TMP->COD,n)
	LRet := .T.
	Close(mkwdlg)
Else
	MsgStop("Selecione um produto pesquisado!")
	LRet := .F.
EndIf

Return

Static Function Filtra(cPC)
Private nRegSB5 := 0

Limpa()

If Select("TM5") <> 0
  dbSelectArea("TM5")
  dbCloseArea()
EndIf
 
cFilMov1:=Upper(AllTrim(cFilMov1))
cFilMov2:=Upper(AllTrim(cFilMov2))
cFilMov3:=Upper(AllTrim(cFilMov3))

If Empty(cFilMov1) .and. Empty(cFilMov2) .and. Empty(cFilMov3)
	MsgStop("Preencha ao menos um filtro para pesquisa!")
	Return
Endif
If AllTrim(cFilMov1)== "'" .OR. AllTrim(cFilMov2)== "'" .OR. AllTrim(cFilMov3)== "'"
	MsgStop("Entre somente com caracterese de A...Z ou de 0...9")                   
	Return
EndIf

cArq := Criatrab(_stru,.T.)
	
nRegSB5:= 0
If Empty(cPC)
	cQuery := "  SELECT B1_COD AS PRODUTO, B1_DESC AS DESCRICAO "    
	cQuery += "  FROM " +  RetSqlName('SB1') + "  SB1 " 
	cQuery += "  WHERE B1_FILIAL = '" + cFilSB1 + "'"

	If !Empty(cFilMov1)
		cQuery += "   AND SB1.B1_DESC LIKE '%"+cFilMov1+"%' "
	Endif
	If !Empty(cFilMov2)
		cQuery += "   AND SB1.B1_DESC LIKE '%"+cFilMov2+"%' "
	Endif
	If !Empty(cFilMov3)
 		cQuery += "   AND SB1.B1_DESC LIKE '%"+cFilMov3+"%' "
	Endif
	cQuery += " AND SB1.B1_MSBLQL  = '2' "
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY B1_COD "
	
Else
	cQuery := " SELECT C7_PRODUTO AS PRODUTO, B1_DESC AS DESCRICAO "
	cQuery += " FROM " + RetSqlName("SC7") + " SC7 "
	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = C7_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE C7_FILIAL = '"+xFilial("SC7")+"' "
	cQuery += " AND C7_NUM = '"+cPC+"' "
	cQuery += " AND SC7.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY PRODUTO "
EndIf	

If Select("TM5") <> 0
	dbSelectArea("TM5")
	dbCloseArea()
EndIf
	
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TM5',.F.,.F.)},OemToAnsi('Selecionando registros...'))
	
dbSelectArea('TM5')
dbGoTop()
While !Eof()
	nRegSB5 += 1
	DbSelectArea("TMP")
	RecLock("TMP",.T.)
	TMP->COD     :=  TM5->PRODUTO
	TMP->DESC    :=  TM5->DESCRICAO
	MsUnLock("TMP")
	dbSelectArea('TM5')
	dbSkip()
EndDo
dbSelectArea('TMP')
dbGoTop()

If nRegSB5 = 0 .AND. (!Empty(cFilMov1) .OR. !Empty(cFilMov2) .OR. !Empty(cFilMov3))
	MsgStop("Não existem produtos cadastrados com a(s) palavra(s):"+Chr(13)+;
	" - "+cFilMov1+Chr(13)+;
	" - "+cFilMov2+Chr(13)+;
	" - "+cFilMov3,"Atenção!!!")
EndIf

cFilMov1:=cFilMov2:= cFilMov3 := space(12)

Return

Static Function Cancela()
lRet := .F.
Close(mkwdlg)
Return

Static Function Limpa()
cArq:=Criatrab(_stru,.T.)

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
Endif

DBUSEAREA(.t.,,carq,"TMP")

DbSelectArea("TMP")
RecLock("TMP",.T.)
TMP->COD     :=  " "    
TMP->DESC    :=  " "
MsunLock("TMP")

Return