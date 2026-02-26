#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TbiConn.ch"  
#INCLUDE "TOTVS.ch"
#INCLUDE "topconn.ch"
#INCLUDE "ap5mail.ch" 
#INCLUDE "fileio.ch"
#DEFINE CRLF chr(13) + chr(10)

// Programa: WFQUALI01
// Autor: Samuel Miranda 
// Objetivo: Envio de e-mail clientes com licença de funcionamento próximas ao vencimento
                            
User Function WFQUALI01(aParam)  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cMensa   := ""
Local cTo       := "" 
Local cFrom     := "Ortosintese Ind. e Com. Ltda."
Local cCC       := ""
Local cQuery    := ""
Local _aMensa   := {}
Local nOpc      := 1
Local dDataBase := Date()
Local nDias     := 0
Default aParam  := {"01", "01"}

cCliDe 			:= " "
cCleAte			:= "ZZZZZZ"
cTitDe			:= " "
cTitAte			:= "ZZZZZZZZZ"
cPrefDe			:= " "
cPrefAte		:= "ZZ"
dEmiDe			:= "20140101"
dEmiAte			:= "20490101"
dVcmtReal		:= dDataBase 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verificacao de ambiente para rodar em JOB                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_lAgend := .F.

If Type('__LocalDriver') == "U"
	_lAgend := .T.
	RpcSetType(3)
	RpcSetEnv(aParam[1], aParam[2])
	//Prepare Environment Empresa aParam[1] Filial aParam[2] FUNNAME "WFRCOB02"
	CONOUT("Iniciando Processo Agendado - WFQUALI01")
	cParam := aParam[2]
EndIf             

CONOUT("PARAMETRO 1 "+aParam[1] + "PARAMETRO 2 "+aParam[2])

	//Faz a chamanda da função para montar o e-mail
	If nOpc == 1
		U_EmailQuali(cCliDe,cCleAte,cTitDe,cTitAte,cPrefDe,cPrefAte,dEmiDe,dEmiAte,dVcmtReal)
	Endif
CONOUT("Fim do Processo Agendado - WFQUALI01")

Return()

User Function EmailQuali(cCliDe,cCleAte,cTitDe,cTitAte,cPrefDe,cPrefAte,dEmiDe,dEmiAte,dVcmtReal)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
//³ Define Variaveis Ambientais                                  //
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//

Local cSubject   :="Ortosintese: Documentos da Qualidade" 
Local cFrom	     :="Ortosintese Industria e Comércio Ltda."
Local cNomCli	 := ""
Local _n 		 := 0
Local _n2		 := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ 			  PARAMENTROS                ³
//³ mv_par01 - Cliente De                    ³
//³ mv_par02 - Cliente Ate                   ³
//³ mv_par03 - Titulo De                     ³
//³ mv_par04 - Titulo Ate                    ³
//³ mv_par05 - Prefixo De                    ³
//³ mv_par06 - Prefixo Ate                   ³
//³ mv_par07 - Emissao De                    ³
//³ mv_par08 - Emissao Ate                   ³
//³ mv_par09 - Vencrea                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

//Monta a query SQL                                      
cQuery := "SELECT SA1.A1_COD AS CODCLI,SA1.A1_XDTLICF ,SA1.A1_NREDUZ AS NOMECLI "
cQuery += " FROM " 
cQuery += RetSqlName( 'SA1' ) + " SA1 "
cQuery += " WHERE SA1.A1_XQUALIF = '1' AND D_E_L_E_T_ = '' AND "
cQuery += " (SA1.A1_XDTLICF - 60) <= '"+(DTOS( dVcmtReal)) +"' "


MEMOWRIT( "WFQUALI01.SQL", cQuery ) 
                        
cQuery:= ChangeQuery(cQuery)
//TcQuery cQuery New Alias "TRB"
If Select ("TRB") > 0
	TRB->(DbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)

TcSetField("TRB","A1_XDTLICF"	,"D",08,0)


While ! TRB->(Eof())
		_cCodCli  := TRB->CODCLI 
		cNomCli   := TRB->NOMECLI
		cTo       := ""
		_aMensa   := {}
		_xData    := Date()
		//cTo       := IIf(Empty(Alltrim(TRB->A1_XMAILCB)),TRB->A1_EMAIL,Alltrim(TRB->A1_XMAILCB))
		cTo     := "samuel@ortosintese.com.br;leonardo@ortosintese.com.br" //Somente para teste
		//_xArquivo := ("\LOGS_PROGRAMAS\WFRCOB01_"+StrTran(AllTrim(Dtoc(_xData)),"/","") +".txt")//Nome do Arquivo de Log
		
		If Empty(cTo)
			TRB->(DbSkip())
			Loop
		EndIf	
		While ! TRB->(Eof()) .And. _cCodCli == TRB->CODCLI  
			_cMensa	:= ""
			_cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> Prezado Cliente, <b>" + cNomCli +"</b></span></p>"
			_cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> A Ortosintese gostaria de lembra-lo que os doucmentos da Qualidade estão vencidos. </b> </span></p>"
			_cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> Documentação a vencer.: </span></p>"
			cCor	:=	"DFEFFF"
		
							
			_cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> <b>***</b> E-mail enviado automaticamente by IT | Ortosintese <b>***</b> </span></p>"
			_cMensa += "</br>"
			_cMensa += " <p><span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'> Atenciosamente,  		  	</b></span></p>"						
			_cMensa += "  <span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'> Flávia 						</br> </span>"
			_cMensa += "  <span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'> Departamento Qualidade 	   	</br> </span>"
			_cMensa += "  <span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'> 55 11 3948-4015  - Direto		</br> </span>"
			_cMensa += "  <span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'> 55 11 3948-4000 	  	        </br> </span>"
			_cMensa += " <span style='font-size:9.0pt;font-family:Arial'> www.ortosintese.com.br 	 	 					</b> </span>"
			_cMensa += "</br>"
			//Rotina para enviar o e-mail	
			EnviaMail( cFrom, cSubject, _cMensa,cTo,cNomCli  )
			TRB->(DbSkip())
	EndDo			
EndDo

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±//
//±±ºDesc.     ³Funcao generica para envio de email                         º±±//
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//

Static Function EnviaMail(cFrom, cSubject, _cMensa,cTo,cNomCli) 
    Local xRet
    Local oServer, oMessage
    Local lMailAuth := SuperGetMv("MV_RELAUTH",,.F.)
    Local cPara     := cTo //Email pra teste
    Local cAssunto  := cSubject
	Local cMensagem := _cMensa
	
	//_xArquivo := ("\LOGS_PROGRAMAS\WFRCOB02_"+StrTran(AllTrim(Dtoc(_xData)),"/","") +".txt")//Nome do Arquivo de Log
	
 
    Private cMailConta  := NIL
    Private cMailServer := NIL
    Private cMailSenha  := NIL
    cMailConta :="cob@ortosintese.com.br"//If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)             //Conta utilizada para envio do email
    cMailServer:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)           //Servidor SMTP
    cMailSenha :="P@ssOrto#20!4998"//If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)             //Senha da conta de e-mail utilizada para envio
    
	oMessage:= TMailMessage():New()
    oMessage:Clear()
   
    oMessage:cDate      := cValToChar( Date() )
    oMessage:cFrom      := cMailConta
    oMessage:cTo        := cPara
    oMessage:cSubject   := cAssunto
    oMessage:cBody      := _cMensa
    
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
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
		//±±±±  Samuel Miranda 15/06/2020  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
		//Cria um arquivo txt com a relação dos e-mails eviandos e a data            º±±//
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
		//Verifica se o arquivo existe,se não ele cria
		//If !File(_xArquivo)
		//	nHandle := FCREATE(_xArquivo)// Cria o arquivo
		//	fclose(nHandle) // Fecha o arquivo para gravação
		//EndIf
		//nHandle := fopen(_xArquivo , FO_READWRITE + FO_SHARED )// Abre o arquivo
		//FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
		//FWrite(nHandle,Dtoc(_xData) + " - Não foi possível enviar mensagem - "+cPara +CRLF ) // Insere texto no arquivo
		//fclose(nHandle) // Fecha o arquivo
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
	Else
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
		//±±±±  Samuel Miranda 15/06/2020  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
		//Cria um arquivo txt com a relação dos e-mails eviandos e a data            º±±//
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
		//Verifica se o arquivo existe,se não ele cria
		//If !File(_xArquivo)
		//	nHandle := FCREATE(_xArquivo)// Cria o arquivo
		//	fclose(nHandle) // Fecha o arquivo para gravação
		//EndIf
		//nHandle := fopen(_xArquivo , FO_READWRITE + FO_SHARED )// Abre o arquivo
		//FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
		//FWrite(nHandle,Dtoc(_xData) + " - "+ _cCodCli+" - "+cNomCli+" - "+cPara +CRLF ) // Insere texto no arquivo
		//fclose(nHandle) // Fecha o arquivo
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
	endif

    xRet := oServer:SMTPDisconnect()
    if xRet <> 0
        alert("Não foi possível desconectar o servidor SMTP: " + oServer:GetErrorString( xRet ))
    endif

return
