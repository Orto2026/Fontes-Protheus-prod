#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMail001   บAutor  ณDaniel Franciulli   บ Data ณ  10/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao generica para envio de email                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Mail001(cFrom, cSubject, _cMensa,cTo)

Local _MailServer	:= GetMv("MV_RELSERV")     
Local _cAccount	:= GetMv("MV_RELACNT")
Local _cPassw		:= GetMv("MV_RELPSW")
Local _cNome		:= ""
Local _lOk			:= .F.
Local _lOk2			:= .F.    
Local _lAuth		:= .T.

Connect Smtp Server _MailServer Account _cAccount Password _cPassw TimeOut 200 result _lOk

If _lAuth	// Autenticacao da conta de e-mail
	lResult := MailAuth(_cAccount, _cPassw)
	If !lResult
		ConOut("Nao foi possivel autenticar a conta - " + _cAccount)
		Return
	EndIf
EndIf

Send Mail From _cAccount to cTo Subject cSubject Body _cMensa FORMAT TEXT RESULT _lOk2

Get MAIL ERROR cErrorMsg
MsgAlert ("Email enviado com sucesso")
Return