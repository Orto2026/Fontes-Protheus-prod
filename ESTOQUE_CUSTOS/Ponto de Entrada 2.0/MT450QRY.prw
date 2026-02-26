#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MT450QRY บAutor  ณMicrosiga           บ Data ณ  29/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrata utilizado somente para Filtrar SC9 no      บฑฑ
ฑฑบ          ณmomento da Liberacao do Estoque - MATA455                   บฑฑ
ฑฑบ          ณ                                       			  				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico ORTOSINTESE                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MT450QRY()

Local _cQuery := PARAMIXB[1]

//If 1=2 .And. AllTrim(FUNNAME()) == "MATA455" .And. !lEnt450QRY // Desabilitado - Dema: 01/08/2017
If AllTrim(FUNNAME()) == "MATA455" //.And. !lEnt450QRY // Desabilitado - Dema: 01/08/2017
	lEnt450QRY := .T.
	While .T.
		
		_nOpc 		:= 1
		_cAtuCont 	:= Space(2)
		_cCodCliOrto:= Space(6)
		
		@ 050,200 TO 200,500 DIALOG oDlg2 TITLE "Filtra Armaz้m "
		@ 011,010 Say "Armazem a Liberar ou Branco para todos"  SIZE 120,10
		@ 011,125 Get _cAtuCont	PICTURE "@!" WHEN .T. SIZE 15,10
		@ 031,010 Say "Ignorar Cliente ?"  SIZE 120,10
		@ 031,125 Get _cCodCliOrto	PICTURE "@!" WHEN .T. SIZE 15,10
		
		@ 030,060 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
		
		ACTIVATE DIALOG oDlg2 CENTERED
		
		If _nOpc == 1
			Exit
		Endif
		
	EndDo
	
EndIf

If AllTrim(FUNNAME()) == "MATA455" .And. !Empty(_cAtuCont) // Desabilitado - Dema: 01/08/2017
	_cQuery += " AND C9_LOCAL = '"+_cAtuCont+"' "
EndIf

If AllTrim(FUNNAME()) == "MATA455" .And. !Empty(_cCodCliOrto) // Desabilitado - Dema: 01/08/2017
	_cQuery += " AND C9_CLIENTE <> '"+_cCodCliOrto+"' "   
EndIf

Return(_cQuery)