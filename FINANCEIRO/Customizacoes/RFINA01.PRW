#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFINA01  º Autor ³Raphael Camillo-Demaº Data ³  19-02-08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ MarkBrowse para Prorrogacao de Titulos a Receber           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFINA01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//teste
Private cPerg 		:= Padr("FINA01",10)
Private aRotina 	:= {}
Private cCadastro := OemToAnsi("Prorroga Vencimento dos Titulos a Receber")
Private _cMarca  := GetMark()

aRotina   := { { "Seleciona"   	,'U_ALTVENC()'	,0,2} }

aCpos := {}

AADD(aCpos, {"MARCA" 		,"",""  })
AADD(aCpos, {"PREFIXO"		,"","Prefixo" })
AADD(aCpos, {"NUMERO"		,"","Numero" }) 
AADD(aCpos, {"NOMCLI"		,"","Cliente" })
AADD(aCpos, {"PARCELA"		,"","Parcela" })
AADD(aCpos, {"TIPO" 			,"","Tipo" })
AADD(aCpos, {"EMISSAO"		,"","Emissao"})
AADD(aCpos, {"VENCTO" 		,"","Vencimento"})
AADD(aCpos, {"VENCREA" 		,"","Vencto. Real"})
AADD(aCpos, {"VALOR"  		,"","Vlr. Titulo"})
AADD(aCpos, {"STATUS"  		,"","Status"})

lInverte:=.F.

cArq1 := ""
cInd1 := ""

aRegs := {}

AADD(aRegs,{cPerg,"01","Cliente de         ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Cliente ate        ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Emissao de         ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Emissao ate        ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Vencimento de      ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Vencimento ate     ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Nota Fiscal e      ?","","","mv_ch7","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})


ValidPerg(aRegs,cPerg)

If !Pergunte(cPerg,.T.)
	Return
EndIf

If Lastkey() == 27
	Return
EndIf

Processa({||FProcessa()},"Selecionando Titulos")
          
dbSelectArea("QUERY")
dbCloseArea()

dbSelectArea("TMP")
dbCloseArea()
Ferase(cArq1+GetDBExtension())

Return

Static Function FProcessa()

_cQuery := "SELECT E1_NUM, E1_PREFIXO,E1_NOMCLI, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_EMISSAO, E1_VENCTO, E1_VENCREA, E1_VALOR "
_cQuery += "FROM "
_cQuery += RetSqlName("SE1") + " SE1 "
_cQuery += "WHERE "
_cQuery += "E1_FILIAL = '"+xFilial("SE1")+"' "
_cQuery += "AND E1_CLIENTE BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' "
_cQuery += "AND E1_EMISSAO BETWEEN '" + Dtos(Mv_Par03) + "' AND '" + Dtos(Mv_Par04) + "' "
_cQuery += "AND E1_VENCTO BETWEEN '" + Dtos(Mv_Par05) + "' AND '" + Dtos(Mv_Par06) + "' "
_cQuery += "AND E1_NUM = '" + Mv_Par07 + "' "
_cQuery += "AND E1_TIPO = 'NF ' AND E1_BAIXA = '        ' "
_cQuery += "AND E1_PORTADO = '   ' "
_cQuery += "AND D_E_L_E_T_ = ' ' "

_cQuery := ChangeQuery(_cQuery)

MemoWrit("RFINA01.SQL",_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)

TcSetField("QUERY", "E1_EMISSAO", "D")
TcSetField("QUERY", "E1_VENCTO",  "D")
TcSetField("QUERY", "E1_VENCREA", "D")

aCampos1 := {}
AADD(aCampos1,{ "PREFIXO"	, "C",03, 0 , "@!" } )
AADD(aCampos1,{ "NUMERO"   	, "C",09, 0 , "@!" } ) 
AADD(aCampos1,{ "NOMCLI"  	, "C",20, 0 , "@!" } ) 
AADD(aCampos1,{ "PARCELA"  	, "C",02, 0 , "@!" } )
AADD(aCampos1,{ "TIPO"     	, "C",03, 0 , "@!" } )
AADD(aCampos1,{ "CLIENTE"  	, "C",06, 0 , "@!" } )
AADD(aCampos1,{ "LOJA"     	, "C",02, 0 , "@!" } )
AADD(aCampos1,{ "EMISSAO"		, "D",08, 0 , "@D" } )
AADD(aCampos1,{ "VENCTO"               		, "D",08, 0 , "@D" } )
AADD(aCampos1,{ "VENCREA"		, "D",08, 0 , "@D" } )
AADD(aCampos1,{ "VALOR" 		, "N",11, 2 , "@E 99,999,99.99" })
AADD(aCampos1,{ "STATUS"		, "C",20, 0 , "@!" })
AADD(aCampos1,{ "MARCA"  	  	, "C",02, 0 , "@!" } )

cArq1 := CriaTrab(aCampos1,.t.)
dbUseArea(.T.,,cArq1,"TMP",.F.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera os dados a serem exibidos                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("QUERY")
dbGotop()
ProcRegua(1000)
While !Eof()

	IncProc()	

	dbSelectArea("TMP")
	RecLock("TMP",.T.)
	TMP->PREFIXO	:= QUERY->E1_PREFIXO
	TMP->NUMERO		:= QUERY->E1_NUM
	TMP->NOMCLI		:= QUERY->E1_NOMCLI
	TMP->PARCELA	:= QUERY->E1_PARCELA
	TMP->TIPO		:= QUERY->E1_TIPO
	TMP->CLIENTE	:= QUERY->E1_CLIENTE
	TMP->LOJA		:= QUERY->E1_LOJA
	TMP->EMISSAO	:= QUERY->E1_EMISSAO
	TMP->VENCTO		:= QUERY->E1_VENCTO
	TMP->VENCREA	:= QUERY->E1_VENCREA
	TMP->VALOR		:= QUERY->E1_VALOR
	MsUnlock()
	
	dbSelectARea("QUERY")
	dbSKip()
EndDo

DbSelectArea("TMP")
DbGotop()

MarkBrow("TMP","MARCA",,aCpos,,_cMarca)

Return .T.

User Function ALTVENC()
_nDias := 0

@ 0,0 TO 100,400 DIALOG oDlgAsk TITLE "Prorrogacao do Vencimento"

@ 0,3 TO 18, 159 TITLE "Qtde de Dias"
@ 5  , 6 SAY OemToAnsi("Dias para Prorrogacao")
@ 6.3,70 GET _nDias SIZE 30,10 Picture "999" When .T.

@ 03  ,168 BMPBUTTON TYPE 1 ACTION Close(oDlgAsk)

ACTIVATE DIALOG oDlgAsk CENTERED

dbSelectArea("TMP")
dbGotop()
While !Eof()
	If !Empty(TMP->STATUS) //Empty(TMP->MARCA) .OR. !Empty(TMP->STATUS)
		dbSkip()
		loop
	EndIf
	
	dbSelectArea("SE1")
	dbSetOrder(1)
	If dbSeek(xFilial("SE1")+TMP->PREFIXO+TMP->NUMERO+TMP->PARCELA+TMP->TIPO)
	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO                                                                                                                  

		RecLock("SE1",.F.)
		SE1->E1_VENCTO 	:= (TMP->VENCTO+_nDias)
		SE1->E1_VENCREA	:= DataValida(SE1->E1_VENCTO)
		SE1->E1_VENCORI := SE1->E1_VENCTO // Mauricio 10012022 para manter o desconto apos a ateração do vencimento

		MsUnlock()
		dbSelectArea("TMP")
		RecLock("TMP",.F.)
		TMP->STATUS := "PRORROGADO"
		TMP->MARCA  := Space(2)
		MsUnlock()
	EndIf
	dbSelectArea("TMP")
	dbSkip()
EndDo

Return
