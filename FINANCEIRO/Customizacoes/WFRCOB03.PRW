#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TbiConn.ch"  
#INCLUDE "TOTVS.ch"
#INCLUDE "topconn.ch"
#INCLUDE "ap5mail.ch" 
#INCLUDE "fileio.ch"
#DEFINE CRLF chr(13) + chr(10) 
#DEFINE ENTER CHR(13)+CHR(10)

// Programa WFRCOB03
// Autor : Samuel Mirada
// Envio por e-mail da Relação de clientes inadimplentes

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Rotina    | WFRCOB03| Samuel Miranda              | Data | 11/04/2024  |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Descricao | Rotina para o envio de e-mail com							|±±
//                   Relação de clientes inadimplentes            			|±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Uso       | Especifico Ortosintese                                     |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
                                
User Function WFRCOB03(aParam)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpc 	   	:= 1  
default aParam	:= {"01", "01"}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verificacao de ambiente para rodar em JOB                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_lAgend := .F.
If Type('__LocalDriver') == "U"
	_lAgend := .T.
	RpcSetType(3)
	RpcSetEnv(aParam[1], aParam[2])
	//Prepare Environment Empresa aParam[1] Filial aParam[2] FUNNAME "WFRCOB02"
	CONOUT("Iniciando Processo Agendado - WFRCOB03")
	cParam := aParam[2]
EndIf             
//***************************************************************************
CONOUT("PARAMETRO 1 "+aParam[1] + "PARAMETRO 2 "+aParam[2])
//Faz a chamanda da função para montar o e-mail
If nOpc == 1
	WFmail()
Endif
CONOUT("Fim do Processo Agendado - WFRCOB03")

Return()

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Rotina    | WFMAIL  | Samuel Miranda               | Data | 11/04/2024 |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Descricao | Função para o envio de e-mail com							|±±
//                   Relação de clientes inadimplentes            			|±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

Static Function WFmail()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
//³ Define Variaveis Ambientais                                  //
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
Local cSubject   :="Ortosintese: Relação de Clientes Inadimplentes" //Titulo da Mensagem   
Local cFrom	     :="Ortosintese Ind. e Com. Ltda."
//Local cNomCli	 := ""
Local nLinha     := 0

//Monta a query SQL                                      
cQuery := " SELECT A1_COD AS CODIGO_CLIENTE, A1_NREDUZ AS NOME_CLIENTE,  " + ENTER
cQuery += " (SELECT SUM(E1_SALDO - E1_SDDECRE) FROM SE1010 SE1X  WHERE SE1X.D_E_L_E_T_ = '' AND E1_NATUREZ IN ('01010101','01010102','01010103','5100', '5200', '5300') AND CAST(E1_VENCREA AS DATE) < CAST(GETDATE() AS DATE) AND E1_SALDO > 0 AND E1_TIPO NOT IN ('RA', 'NCC') AND E1_CLIENTE = A1_COD) AS TIT_ATRASO, " + ENTER
cQuery += " CASE A1_MSBLQL WHEN '0' THEN 'LIBERADO' WHEN '1' THEN 'BLOQUEADO' WHEN '2' THEN 'LIBERADO' END AS SITUACAO, VENCIMENTO AS DIAS_VENCIMENTO, ISNULL(SUM(C6_PRCVEN * (C6_QTDVEN - C6_QTDENT)), 0) AS TOTAL_CARTEIRA FROM ( " + ENTER
cQuery += " SELECT " + ENTER
cQuery += " E1_CLIENTE, DATEDIFF(DAY, MIN(E1_VENCREA), GETDATE()) AS VENCIMENTO " + ENTER
cQuery += " FROM " + RetSqlName("SE1") +" SE1  " + ENTER
cQuery += " WHERE SE1.D_E_L_E_T_ = '' " + ENTER
cQuery += " AND E1_SALDO > 0 " + ENTER
cQuery += " AND E1_VENCREA < GETDATE() " + ENTER
cQuery += " AND E1_TIPO NOT IN ('RA','NCC') " + ENTER
cQuery += " GROUP BY E1_CLIENTE " + ENTER
cQuery += " ) AS RESULTSET " + ENTER
cQuery += " LEFT JOIN " + RetSqlName("SC5") +" SC5  ON C5_FILIAL <> 'ZZ' AND SC5.D_E_L_E_T_ = '' AND C5_TIPO = 'N' AND C5_XREFAT IN ('', '2') AND C5_CLIENTE = E1_CLIENTE " + ENTER
cQuery += " LEFT JOIN " + RetSqlName("SC6") +" SC6  ON C6_QTDVEN > C6_QTDENT AND C6_BLQ <> 'R' AND SC6.D_E_L_E_T_ = '' AND C5_LIBEROK = 'S' AND C5_CLASPED IN ('1', '2', '3', '4', '6') AND C6_NUM = C5_NUM " + ENTER
cQuery += " JOIN " + RetSqlName("SA1") +" SA1  ON SA1.D_E_L_E_T_ = '' AND A1_COD = E1_CLIENTE " + ENTER
cQuery += " WHERE " + ENTER
cQuery += " VENCIMENTO > 0  " + ENTER
cQuery += " GROUP BY VENCIMENTO, A1_COD, A1_NREDUZ, A1_MSBLQL " + ENTER
cQuery += " ORDER BY 5 ASC " + ENTER
//Grava o resultado da Query
MEMOWRIT( "WRFCOB03.SQL", cQuery ) 
//Executa a Query                   
cQuery:= ChangeQuery(cQuery)
//TcQuery cQuery New Alias "TRB"
If Select ("TRB") > 0
	TRB->(DbCloseArea())
EndIf        
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
DbSelectArea( "TRB" )
TRB->(DbGotop())
cTo       := ""
_aMensa   := {}
_xData    := Date()
//Parametro com os e-mails a serem enviados o relatorio
cTo     := SuperGetMv("MV_INADIMP")//   //Somente para teste  -> "samuel.miranda@ortosintese.com.br"
//Adiciona os dados no array
While ! TRB->(Eof()) //.And. _cCodCli == TRB->E1_CLIENTE  //.AND. dDataBase == (TRB->E1_VENCREA+4) 	
	AADD(_aMensa,{	TRB->CODIGO_CLIENTE,;
		TRB->NOME_CLIENTE,;
		AllTrim(Transform( TRB->TIT_ATRASO, "@E 999,999,999.99")),;
		TRB->SITUACAO,;
		AllTrim(Transform( TRB->DIAS_VENCIMENTO, "@E 9999999")),;
		AllTrim(Transform( TRB->TOTAL_CARTEIRA, "@E 999,999,999.99"))} ) 
			//         01 -Codigo do Cliente       02 -  Nome do Cliente          03 -Dias de Atraso                      04 -Situação               05  - Dias de Vencimento                                     06 - Carteira      
	TRB->(DbSkip())
EndDo
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//CODIGO_CLIENTE/Filial	NOME_CLIENTE	TIT_ATRASO	SITUACAO	DIAS_VENCIMENTOS	TOTAL_CARTEIRA
_cMensa	:= ""
_cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> <b> RELAÇÃO DE CLIENTES INADIMPLENTES</b></span></p>"
_cMensa += "<table border='0' cellpadding='2' cellspacing='1' width='100%'>"
_cMensa += " <tr>"
_cMensa += "   <td width='60' bgcolor='#AAC8FF' height='19'>"
_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'>  <b>CODICO</b> </span> </p>"	 	//01 ->Codigo do Cliente	
_cMensa += "   </td>"
_cMensa += "   <td width='60' bgcolor='#AAC8FF' height='19'>"
_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'>  <b>NOME</b> </span> </p>"	 	//02 ->Nome do Cliente
_cMensa += "   </td>"
_cMensa += "   <td width='60' bgcolor='#AAC8FF' height='19'>"
_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'>  <b>TIT ATRASO</b> </span> </p>"	 //03 -> Titulos Atrasados
_cMensa += "   </td>"
_cMensa += "   <td width='60' bgcolor='#AAC8FF' height='19'>"
_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'>  <b>SITUACAO </b> </span> </p>"	 //04 -> Situação
_cMensa += "   </td>"
_cMensa += "   <td width='40' bgcolor='#AAC8FF' height='19'>"
_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'>  <b>DIAS VENCIMENTOS</b> </span> </p>"   //05 -> Dias vencidos
_cMensa += "   </td>"	
_cMensa += "   <td width='78' bgcolor='#AAC8FF' height='19'>"
_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> <b>TOTAL_CARTEIRA</b> </span> </p>"    		//06 -> Total em Carteira
_cMensa += "   </td>"
_cMensa += " </tr>"
cCor	:=	"DFEFFF"
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
For nLinha := 1 To Len(_aMensa)
    //Incremanta a mensagem, que será impressa no corpo do e-mail
	_cMensa += " <tr>"
	_cMensa += "   <td width='60' bgcolor='#"+cCor+"' height='19'>"
	_cMensa += "    <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> " +_aMensa[nlinha,1]+" </span> </p>" 		//01 ->Codigo do Cliente			
	_cMensa += "   </td>"
	_cMensa += "   <td width='40' bgcolor='#"+cCor+"' height='19'>"
	_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> "+_aMensa[nlinha,2]+" </span> </p>" 		//02 ->Nome do Cliente
	_cMensa += "   </td>"	
	_cMensa += "   <td width='80' bgcolor='#"+cCor+"' height='19'>"
	_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> "+_aMensa[nlinha,3]+"</span> </p>" 		//03 -> Titulos Atrasados
	_cMensa += "   </td>"
	_cMensa += "   <td width='80' bgcolor='#"+cCor+"' height='19'>"
	_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'>"+_aMensa[nlinha,4]+"</span> </p>" 		//04 -> Dias vencidos
	_cMensa += "   </td>"
	_cMensa += "   <td width='40' bgcolor='#"+cCor+"' height='19'>"
	_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> "+_aMensa[nlinha,5]+"</span> </p>" //05 -> Total em Carteira
	_cMensa += "   </td>"	
	_cMensa += "   <td width='80' bgcolor='#"+cCor+"' height='19'>"
	_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> "+_aMensa[nlinha,6]+"</span> </p>" //06 -> Total em Carteira  
	_cMensa += "   </td>"
	_cMensa += " </tr>"
	If cCor == "DFEFFF" //Tratamento de cores nas linhas     
		cCor := "FFFFFF"
	Else
		cCor := "DFEFFF"
	EndIf					
Next _n
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//Codigo das Cores em HTMl
cAzul 		:= "0000FF"
cPadrao 	:= "008B8B"
cCinza 		:= "A9A9A9"
cTurqueza 	:= "20B2AA"			
_cMensa += "</table>"
_cMensa += "</br>"		
_cMensa += " <span style='font-size:9.0pt;font-family:Arial'> By | TI - Ortosintese </b>  </span>"
_cMensa += "</br>"				
//Rotina para enviar o e-mail				
EnviaMail( cFrom, cSubject, _cMensa,cTo) 			
Return()

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±± Função   | EnviaMail  | Samuel Miranda            | Data | 03/12/2019  º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±± Descricao | Função para montar o e-mail								º±±//
//                              											º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
Static Function EnviaMail( cFrom, cSubject, _cMensa,cTo) 	
    Local cMsg      := ""
    Local xRet
    Local oServer, oMessage
    Local lMailAuth := SuperGetMv("MV_RELAUTH",,.F.)
    Local cPara     := cTo 
    Local cAssunto  := cSubject
    Local cMensagem := _cMensa
    Private cMailConta  := NIL
    Private cMailServer := NIL
    Private cMailSenha  := NIL
	//Paramentros para autenticação do e-mail
    cMailConta  := Alltrim("suporte@ortosintese.com.br") //If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta))           //Conta utilizada para envio do email
    cMailServer := Alltrim(If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)) //Servidor SMTP
    cMailSenha  := Alltrim("Lynce478")//If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha))            //Senha da conta de e-mail utilizada para envio
    oMessage:= TMailMessage():New()
    oMessage:Clear()
    oMessage:cDate      := cValToChar( Date() )
    oMessage:cFrom      := cMailConta
    oMessage:cTo        := Alltrim(cPara)
    oMessage:cSubject   := cAssunto
    oMessage:cBody      := cMensagem
    oServer := tMailManager():New()
    oServer:SetUseTLS( .T. ) //Indica se será utilizará a comunicação segura através de SSL/TLS (.T.) ou não (.F.)
   
    xRet := oServer:Init( "", cMailServer, cMailConta, cMailSenha, 0)//,nPorta)//nPorta ) //inicilizar o servidor
    if xRet != 0
        alert("O servidor SMTP não foi inicializado: " + oServer:GetErrorString( xRet ) )
        return
    endif
   
    xRet := oServer:SetSMTPTimeout(60) //Indica o tempo de espera em segundos.
    if xRet != 0
        alert("Não foi possível definir " + cProtocol + " tempo limite para " + cValToChar( nTimeout ))
    endif
   
    xRet := oServer:SMTPConnect()
    if xRet <> 0
        alert("Não foi possível conectar ao servidor SMTP: " + oServer:GetErrorString(xRet))
        return
    endif
   
    if lMailAuth
        //O método SMTPAuth ao tentar realizar a autenticação do 
        //usuário no servidor de e-mail, verifica a configuração 
        //da chave AuthSmtp, na seção [Mail], no arquivo de 
        //configuração (INI) do TOTVS Application Server, para determinar o valor.
        xRet := oServer:SmtpAuth(cMailConta,cMailSenha)
        if xRet <> 0
            cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString(xRet)
            alert( cMsg )
            oServer:SMTPDisconnect()
            return
        endif
    Endif
	
    xRet := oMessage:Send(oServer)
    if xRet <> 0
        alert("Não foi possível enviar mensagem: " + oServer:GetErrorString( xRet ))
	Endif

    xRet := oServer:SMTPDisconnect()
    if xRet <> 0
        alert("Não foi possível desconectar o servidor SMTP: " + oServer:GetErrorString( xRet ))
    endif

return

