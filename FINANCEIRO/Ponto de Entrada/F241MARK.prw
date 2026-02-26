#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF241MARK  บAutor  ณRaphael Camillo-Demaบ Data ณ  02/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada para Reordenar o Browse de selecao dos     บฑฑ
ฑฑบ          ณTitulo no Bordero de Pagamento                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JHSF                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F241MARK 

Local aArea 	:= GetArea()
Local aCampos	:= PARAMIXB
Local aRet		:= {}
Local _cCampos := "E2_NOMFOR/E2_PREFIXO/E2_NUM/E2_PARCELA/E2_TIPO/E2_VALOR/E2_EMISSAO/E2_VENCTO/E2_VENCREA/E2_FORMPAG/E2_CODBAR/E2_FORBCO/E2_FORAGE/E2_FORCTA/E2_FCTADV/"

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_NOMFOR"})
If nPos <> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_PREFIXO"})
If nPos	<> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_NUM"})
If nPos	<> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_PARCELA"})
If nPos <> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_TIPO"})
If nPos <> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_VALOR"})
If nPos <> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_EMISSAO"})
If nPos <> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_VENCTO"})
If nPos <> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_VENCREA"})
If nPos <> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_FORMPAG"})
If nPos	<> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

//E2_CODBAR/E2_FORBCO/E2_FORAGE/E2_FORCTA/E2_FCTADV/

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_CODBAR"})
If nPos	<> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_FORBCO"})
If nPos	<> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_FORAGE"})
If nPos	<> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_FORCTA"})
If nPos	<> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

nPos := Ascan(aCampos,{|X| AllTrim(X[1]) == "E2_FCTADV"})
If nPos	<> 0
	aAdd(aRet,{aCampos[nPos,1],aCampos[nPos,2],aCampos[nPos,3],aCampos[nPos,4]})
EndIf

aEval(aCampos,{|Z| If( !(AllTrim(Z[1])$_cCampos), aAdd(aRet,{Z[1],Z[2],Z[3],Z[4]}), NIL)})

RestArea(aArea)
Return aRet
