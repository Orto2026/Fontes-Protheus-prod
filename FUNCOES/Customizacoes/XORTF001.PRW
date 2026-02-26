#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "Totvs.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºRotina    ³ XORTF001    ºAuto ³Samuel Miranda     º Data ³ 01/01/2020  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDescricao ³ Função para retornar dados do usuário logado,              º±±
±±º            usado para o log de inclusão                               º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function XORTF001()
    Local _cTexto := ""    
    _cTexto := "DATA: " 	+ DToC(dDataBase)	+ CRLF
    _cTexto += "HORA: " 	+ Time() 			+ CRLF
    _cTexto += "ID: " 		+ __cUserId 		+ CRLF
    _cTexto += "USUARIO: " 	+ cUserName 		+ CRLF
    _cTexto += "IP:" 		+ GetClientIp() 	+ CRLF
    _cTexto += "MAQUINA:" 	+ GetComputerName() + CRLF
Return _cTexto