//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"  
#INCLUDE "CRMDEF.CH" 
#INCLUDE "CRMA980.CH" 
#INCLUDE "ap5mail.ch" 
#INCLUDE "fileio.ch"

//-------------------------------------------------------------------------
/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Rotina    |  CRMA980       |Auto| Samuel Miranda   |Data| 28/09/2023   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Descricao | Ponto de entrada em MVC do cadastro de Cleintes.           º±±
±± Realiza a validação se o usuário poderá efetuar a alteração do         º±±
±± cadasto em alguns campos contidos no parâmetro.                        º±±  
±± @version da Build   12.1.17 / Superior                                 º±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Parametros
- MV_USRDOC - Parâmetro que contenha o código do usuário que terar acesso a
              aba ANVISA do cadastro de Clientes.
              
/*/
//---------------------------------------------------------------------------

User Function CRMA980() 
    Local aParam        := PARAMIXB
    Local xRet          := .T.
    Local lIsGrid       := .F.
    Local cIDPonto      := ''
    Local cIDModel      := ''
    Local oObj          := NIL
    local cUserLib   := SuperGetMv("MV_USRDOC",.f.,"") // Parâmetro que contenha o código dos usuários que terão acesso a aterar a aba ANVISA no cadastro de produto.
    local cUsuario   := RetCodUsr()//Pega o código do usúario logado
    If aParam <> NIL
        oObj        := aParam[1]
        cIDPonto    := aParam[2]
        cIDModel    := aParam[3]
        lIsGrid     := (Len(aParam) > 3)
        nOperation := oObj:GetOperation() 
            //nOperation == 3 Inclusao
            //nOperation == 4 Alteracao
            //nOperation == 5 Exclusao
            //Valida a abertura da tela
        If cIDPonto == 'MODELVLDACTIVE'  // Mostra o tipo de Operacao
            //Verifica se o usuário tem permissão //Adicionado por Samuel Miranda 02/10/2023 apedido do Rodnei
           If  !(cUsuario $ cUserLib)
                //Desabilita a Obrigatoriedade do campo, no load da tela 
                oObj:GetModel("SA1MASTER"):GetStruct():SetProperty("A1_XLICFUN",MODEL_FIELD_OBRIGAT,.F.)
                oObj:GetModel("SA1MASTER"):GetStruct():SetProperty("A1_XALVARA",MODEL_FIELD_OBRIGAT,.F.)
                oObj:GetModel("SA1MASTER"):GetStruct():SetProperty("A1_XDTLICF",MODEL_FIELD_OBRIGAT,.F.)
                oObj:GetModel("SA1MASTER"):GetStruct():SetProperty("A1_XTRANSP",MODEL_FIELD_OBRIGAT,.F.)
                oObj:GetModel("SA1MASTER"):GetStruct():SetProperty("A1_XQUALIF",MODEL_FIELD_OBRIGAT,.F.)
                oObj:GetModel("SA1MASTER"):GetStruct():SetProperty("A1_INSCR"  ,MODEL_FIELD_OBRIGAT,.F.)
                // MODELO -> SUBMODELO -> ESTRUTURA -> PROPRIEDADE -> BLOCO DE CÓDIGO -> X3_WHEN := .F.
                oObj:GetModel("SA1MASTER"):GetStruct():SetProperty("A1_XLICFUN", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , ".F."))
                oObj:GetModel("SA1MASTER"):GetStruct():SetProperty("A1_XALVARA", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , ".F."))
                oObj:GetModel("SA1MASTER"):GetStruct():SetProperty("A1_XDTLICF", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , ".F."))
                oObj:GetModel("SA1MASTER"):GetStruct():SetProperty("A1_XTRANSP", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , ".F."))
                oObj:GetModel("SA1MASTER"):GetStruct():SetProperty("A1_XQUALIF", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , ".F."))
                
            EndIf
        EndIf

        //Pré configurações do Modelo de Dados
		If cIdPonto == "MODELPRE"
			//xRet := .T.
		EndIf

		//Pré configurações do Formulário de Dados
		If cIdPonto == "FORMPRE"
		EndIf

		//Adição de opções no Ações Relacionadas dentro da tela
		If cIdPonto == 'BUTTONBAR'
		EndIf

		//Pós configurações do Formulário
		If cIdPonto == 'FORMPOS'
			//xRet := .T.
		EndIF

		//Validação ao clicar no Botão Confirmar
		If cIdPonto == 'MODELPOS'
			//Se o campo de contato estiver em branco, não permite prosseguir
			//If Empty(M->Meu campo)
			//Aviso('Atenção', 'Por favor, informe um oteudo do campo!', {'OK'}, 03)
			//xRet := .F.
			//EndIf
		EndIf

		//Pré validações do Commit
		If cIdPonto == 'FORMCOMMITTTSPRE'
		EndIf

		//Pós validações do Commit
		If cIdPonto == 'FORMCOMMITTTSPOS'
		EndIf

		//Commit das operações (antes da gravação)
		If cIdPonto == 'MODELCOMMITTTS'
		EndIf

		//Commit das operações (após a gravação)
		If cIdPonto == 'MODELCOMMITNTTS'
			nOper := oObj:nOperation
			
			//Se for inclusão, mostra mensagem de sucesso
			If nOper == 3
                EnviaMail(M->A1_COD,nOper,M->A1_NREDUZ) //M->A1_NREDUZ
				Aviso('Atenção', 'E-mail enviado ao setor de Assutos regulatorios!', {'OK'}, 03)
			EndIf
            //Se for Alteração
            If nOper == 4 //nOperation == 4 Alteração
			EndIf
            //Se for Exclusao
            If nOper == 5 //nOperation == 5 Exclusao
                //Rotina para enviar o e-mail	
                EnviaMail(M->A1_COD,nOper,M->A1_NREDUZ) //M->A1_NREDUZ
				Aviso('Atenção', 'E-mail enviado ao setor de Assutos regulatorios!', {'OK'}, 03)
			EndIf
            //Verifica se é 3=Inclusão ou 4=Alteração
            If nOper == 3 .Or. 4 // (oObj:GetOperation() ==  MODEL_OPERATION_UPDATE .Or. oObj:GetOperation() ==  MODEL_OPERATION_INSERT)
                //Atribui o 
                cCodigo := "C"+oObj:GetValue("SA1MASTER","A1_COD")+oObj:GetValue("SA1MASTER","A1_LOJA")    
                dbSelectArea("CTD")
                dbSetOrder(1)
                If !dbSeek(xFilial("CTD")+cCodigo)
                    RecLock("CTD",.T.)
                    CTD->CTD_FILIAL := xFilial("CTD")
                    CTD->CTD_ITEM   := cCodigo
                    CTD->CTD_CLASSE := "2"
                    CTD->CTD_NORMAL := "2"
                    CTD->CTD_ITLP	:= cCodigo
                    CTD->CTD_ITSUP  := "1"
                Else
                    RecLock("CTD",.F.) 
                EndIf 

                CTD->CTD_DESC01 := oObj:GetValue("SA1MASTER","A1_NOME")
                CTD->CTD_BLOQ   := "2"
                CTD->CTD_DTEXIS := CTOD("01/01/1980")
                CTD->(MsUnLock())
		    EndIf
		
		EndIf

    EndIf
Return xRet


//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±//
//±±ºDesc.     ³Funcao generica para envio de email                         º±±//
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//

Static Function EnviaMail(nCodPro,nOper,_nomecli) 
    Local xRet
    Local oServer, oMessage
    Local lMailAuth := SuperGetMv("MV_RELAUTH",,.F.)
    Local cPara     := "samuel.miranda@ortosintese.com.br;regulatorio@ortosintese.com.br;regulatorio02@ortosintese.com.br;regulatorio2@ortosintese.com.br" // cTo 
    Local cAssunto  := nOper
	Local cMensagem := "" 
	Local _xData    := Date()
	_xArquivo := ("\LOGS_PROGRAMAS\CADCLIENTE_"+StrTran(AllTrim(Dtoc(_xData)),"/","") +".txt")//Nome do Arquivo de Log
	iF cAssunto = 3
        cAssunto := "[Inclusão] Novo Cliete"
    ElseIf cAssunto = 4
        cAssunto := "[Alteração] Cadastro de Cliente"
    ElseIf cAssunto = 5
        cAssunto := "[Exclusão] Cadastro de Cliente"
    EndIf
    //Envia o e-mail com dados da operação
    cMensagem := MAENEMAIL(nCodPro,nOper,_nomecli)
    
    Private cMailConta  := NIL
    Private cMailServer := NIL
    Private cMailSenha  := NIL
    cMailConta :="suporte@ortosintese.com.br"//If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)    //Conta utilizada para envio do email
    cMailServer:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)                                //Servidor SMTP
    cMailSenha :="Lynce478"//If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)                      //Senha da conta de e-mail utilizada para envio
  
	oMessage:= TMailMessage():New()
    oMessage:Clear()
   
    oMessage:cDate      := cValToChar( Date() )
    oMessage:cFrom      := cMailConta
    oMessage:cTo        := cPara
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
        //configuração (INI) do TOTVS Application Server, para determinar o valor. a1_xlog
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
	Else
	endif

    xRet := oServer:SMTPDisconnect()
    if xRet <> 0
        alert("Não foi possível desconectar o servidor SMTP: " + oServer:GetErrorString( xRet ))
    endif

return

Static Function MAENEMAIL(nCodPro,nOper,_nomecli)
Local nOperacao := nOper
//Pegar o usuario logado
Local   cNameUser  :=  cUserName 

    iF nOperacao = 3
        nOperacao := "Novo Cliete Código "+nCodPro+ " - "+_nomecli
    ElseIf nOperacao = 4
        nOperacao := "Cadastro de Cliente "+nCodPro+" - "+_nomecli+ "<b> Foi Alterado </b>"
    ElseIf nOperacao = 5
        nOperacao := "[Exclusão] Cadastro de Cliente"+nCodPro+" - "+_nomecli+ "<b> Foi Excluido </b>"
    EndIf
        _cMensa	:= ""
        _cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> "+ nOperacao +" </span></p>"
        _cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'>  </b> </span></p>"
        _cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'>  </span></p>"
        _cMensa += "<table border='0' cellpadding='2' cellspacing='1' width='100%'>"

        _cMensa += "</br>"
        _cMensa += " <span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'>Dados da Operação: 	    </b></span>"						
        _cMensa += " <span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'> Usuário:"+Upper(cNameUser)+"	</br> </span>"
        _cMensa += " <span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'> Data   : "+DTOC(dDatabase)+"</br> </span>"
        _cMensa += " <span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'> 	    e-mail de teste  </br> </span>"
        _cMensa += " <span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'> 	  	                </br> </span>"
        _cMensa += "</br>"
        _cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> <b>***</b> E-mail enviado automaticamente by IT | Ortosintese <b>***</b> </span></p>"

Return(_cMensa)

