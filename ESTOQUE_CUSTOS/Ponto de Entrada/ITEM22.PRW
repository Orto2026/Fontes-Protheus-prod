// BIBLIOTECAS UTILIZADAS
#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
#Include "ap5mail.ch" 

#define POS_OBJETO       1
#define POS_PONTO        2
#define POS_ID_MODEL     3

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºRotina    |  ITEM         | Samuel  Miranda    | Data |    22/03/2024  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDescricao ³ Ponto de entrada em MVC do cadastro de produtos.           º±±
±± Realiza a validação se o usuário poderá efetuar a alteração do         º±±
±± cadasto do produto para alguns campos contidos no parâmetro.           º±±                                     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Parametros
- MV_USBLQCP - Parâmetro que contenha o código do usuário que 
               não será permitido alterar o cadastro.
- MV_CPSLBCP - Campos liberados para alteração no cadastro 
               de produtos.
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360040694374-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-ADVPL-Bloquear-campos-por-ponto-MVC

±±ºUso       ³ Especifico Ortosintese                                     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

// EXEMPLO COM O PE MVC DA MATA010
User Function ITEM()
  Local aParam     := PARAMIXB // PARÂMETROS PASSADOS PARA O PONTO
  Local xRet       := .T. // RETORNO LÓGICO PARA PROSSEGUIMENTO DA ROTINA
  Local oObj       := NIL // OBJETO QUE ARMAZENARÁ O MODELO TOTAL
  Local cIdPonto   := Space(0) // ID DO MOMENTO DA CHAMADA DO PONTO
  local cUserLib   := SuperGetMv("MV_USBLIBE",.f.,"") // Parâmetro com código do usuário que será permitido alterar o cadastro.
  local cMvFolders := SuperGetMv("MV_FOLDERS",.f.,"") // Parametro com o número da pasta (aba) do cadastro de produtos.
  local cCampLiber := SuperGetMv("MV_CPLIBE",.f.,"")  // 
  local cUsuario   := RetCodUsr()
  local cCposLib   := ""  // Campos liberados para alteração no cadastro de produtos.
  local aCamposSB1 := FWSX3Util():getAllFields("SB1",.f.)
  local NX         := 0
  Local _nCampo    := ""
  Local _cVerific  := .T.
  //Variaveis para validar o cadastro
  Local _cAlias   	:= GetArea()
  Local _aAreaSB1 	:= SB1->(GetArea())
  Local _aAreaSB2 	:= SB2->(GetArea())
  
 
  If (!aParam == NIL)
    oObj     := aParam[POS_OBJETO]  //1
    cIdPonto := aParam[POS_PONTO]   //2
    cIdModel := aParam[POS_ID_MODEL]//3
    
    // VALIDAÇÃO ANTES DA ATIVAÇÃO DO MODELO
    If (cIdPonto == "MODELVLDACTIVE")
        cCposLib := NFOLDER(cMvFolders)
      If !(cUsuario $ cUserLib) // !(cUsuario $ cUserLib)
        for NX := 3 to  len(aCamposSB1)
          _nCampo := aCamposSB1[nX]
          _cVerific := VERCAMPO(_nCampo)
          if  _cVerific = .T.
            _nCampo := aCamposSB1[NX]
            
            iF (_nCampo $ cCposLib) //.and. !(cUsuario $ cUserLib)  //iF !(_nCampo $ cCposLib)
              If !(_nCampo $ cCampLiber)
                // MODELO -> SUBMODELO -> ESTRUTURA -> PROPRIEDADE -> BLOCO DE CÓDIGO -> X3_WHEN := .F.
                oObj:GetModel("SB1MASTER"):GetStruct():SetProperty(_nCampo,MODEL_FIELD_WHEN,FwBuildFeature(STRUCT_FEATURE_WHEN ,".F."))
                
                //Desabilita a aba  //MVC_VIEW_FOLDER_NUMBER 
                //oObj:GetModel("SB1MASTER"):GetStruct():SetProperty("",MVC_VIEW_FOLDER_NUMBER,FwBuildFeature(STRUCT_FEATURE_WHEN ,".F."))

                //oObj:GetModel("SB1MASTER"):GetStruct():SetProperty("B1_POSIPI",MODEL_FIELD_WHEN,FwBuildFeature(STRUCT_FEATURE_WHEN ,".T."))
                //Desabilita a obrigatoriedade do campo no Load da Tela
                //oObj:GetModel("SB1MASTER"):GetStruct():SetProperty("B1_POSIPI",MODEL_FIELD_OBRIGAT,.F.)
              EndIf
            Endif
          EndIf
        Next NX
      Endif          
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
			//If Empty(M->A6_CONTATO)
			//	Aviso('Atenção', 'Por favor, informe um Contato!', {'OK'}, 03)
			//	xRet := .F.
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
            //EnviaMail(M->A1_COD,nOper,M->A1_NREDUZ) //M->A1_NREDUZ
            //Aviso('Atenção', 'Banco criado com sucesso!', {'OK'}, 03)
      EndIf
      //Se for Alteração
      If nOper == 4
        //Rotina para enviar o e-mail	
        //EnviaMail(M->A1_COD,nOper,M->A1_NREDUZ) //M->A1_NREDUZ
        //_cTexto1 += "E-mail enviado para: "+ CHR(13)+CHR(10)
        //_cTexto2 += "Assuntos regulatorios, "+ CHR(13)+CHR(10)
        //_cTexto3 += "Para o preenchimento da aba ANVISA. "
        //Aviso('Atenção', 'Banco criado com sucesso!', {'OK'}, 03)
      EndIf
      //nOperation == 5 Exclusao
      //Se for Exclusao
      If nOper == 5
          //Rotina para enviar o e-mail	
        //Aviso('Atenção', 'Banco criado com sucesso!', {'OK'}, 03)
      EndIf
		EndIf

  EndIf
  //±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±// 
  RestArea(_aAreaSB1)
  RestArea(_aAreaSB2)   
	RestArea(_cAlias)
  
Return (xRet) // RETORNO LÓGICO PARA PROSSEGUIMENTO


//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ºRotina    |  NFOLDER       | Samuel  Miranda     |  Data | 22/03/2024  º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ºDescricao | Selecionar os campos e abas a serem bloqueados             º±±  
//±± Recebe o numero das pastas (abas) do cadatrado do MV_FOLDERS           º±±  
//±± Retorna um array com os campos a serem bloqueados                      º±±                                     
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Static Function NFOLDER(cMvFolders)
Local cQuery :=""
Local cCamPBloq  := SuperGetMv("MV_CPBLOQ") 
Local cBloq  := cCamPBloq // "B1_CODBAR"

cQuery := "SELECT " +CHR(13)+CHR(10)
cQuery +="SX3.X3_CAMPO AS CAMPO" +CHR(13)+CHR(10)
cQuery +="FROM"+CHR(13)+CHR(10)
cQuery += RetSqlName("SX3")+" SX3 "+CHR(13)+CHR(10)
cQuery +="WHERE" +CHR(13)+CHR(10)
cQuery +=" SX3.X3_ARQUIVO='SB1' AND " +CHR(13)+CHR(10)
cQuery +=" SX3.X3_FOLDER IN ("+cMvFolders +")" +CHR(13)+CHR(10)
cQuery +="AND D_E_L_E_T_='' " +CHR(13)+CHR(10)
MemoWrite("ITEM22.SQL", cQuery )

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"ITEM22", .T., .T. )
	nRec	:= 0
	dbSelectArea( "ITEM22" )
	dbGotop()
  ITEM22->(dbEval({ || nRec++ },,{||!Eof()} ))
	dbGoTop()
  //Adicina os itens em um array
  While !ITEM22->(Eof())
    cBloq +=Alltrim(ITEM22->CAMPO)+"|"
    //Passa pro proximo registro da query
    ITEM22->(DbSkip())
  EndDo
  //Fecha o Alias 
  ITEM22->(DBcloseArea())
Return(cBloq)

/*---------------------------------------------------------------------*
 | Func:  VERCAMPO                                                     |
 | Autor: Samuel Miranda                                               |
 | Data:  22/03/2024                                                   |
 | Desc:  Função para verificar os campos validos                      |
 *---------------------------------------------------------------------*/
Static Function VERCAMPO(_nCampo)
//Local _cVerificar := _nCampo
Local _cVerificar := .T.
//Local cCamposErro := ""
    
If _nCampo == "B1_DCR" .OR. _nCampo == "B1_REQUIS"  .OR. _nCampo == "B1_TALLA" .OR. _nCampo == "B1_OK" .OR. _nCampo == "B1_SELO" .OR. _nCampo == "B1_UMOEC" .OR. _nCampo == "B1_IPPT" .OR. _nCampo == "B1_REGSEQ"  .OR. _nCampo == "B1_CODITE" 
  _cVerificar := .F.
EndIf

If _nCampo == "B1_ATRIB3" .OR. _nCampo == "B1_ATRIB2" .OR. _nCampo == "B1_CLASSVE" .OR. _nCampo == "B1_ATRIB1" .OR. _nCampo == "B1_NICONE" .OR. _nCampo == "B1_ESPECIE" .OR. _nCampo == "B1_CONTCQP"  
  _cVerificar := .F.
EndIf
If _nCampo == "B1_CORSEC" .OR. _nCampo == "B1_CORPRI"  .OR. _nCampo == "B1_IAT"  .OR. _nCampo == "B1_QTDINIC"  .OR. _nCampo == "B1_QTDACUM" .OR. _nCampo == "B1_QTMIDIA" .OR. _nCampo == "B1_MIDIA"  .OR. _nCampo == "B1_TECLA"  
  _cVerificar := .F.
EndIf

If _nCampo == "B1_FLAGSUG" .OR. _nCampo == "B1_GRUDES" .OR. _nCampo == "B1_ALADI"  .OR. _nCampo == "B1_MAT_PRI"  .OR. _nCampo == "B1_ESPECIF" .OR. _nCampo == "B1_CODEMB" .OR. _nCampo == "B1_VLREFUS" .OR. _nCampo == "B1_PRODPAI" 
  _cVerificar := .F.
EndIf

If _nCampo == "B1_FPCOD" .OR. _nCampo == "B1_DESC_P"  .OR. _nCampo == "B1_DESC_GI" .OR. _nCampo == "B1_DESC_I"   .OR. _nCampo == "B1_CODOBS"  .OR. _nCampo == "B1_NUMCOP" .OR. _nCampo == "B1_CODEMB " .OR._nCampo == "B1_CNATREC" 
  _cVerificar := .F.
EndIf

If _nCampo == "B1_MODELO" .OR. _nCampo == "B1_SETOR"  .OR. _nCampo == "B1_BALANCA" .OR. _nCampo == "B1_GRPTIDC"  .OR. _nCampo == "B1_ADMIN" .OR. _nCampo == "B1_ALADI" .OR. _nCampo == "B1_COEFDCR" .OR. _nCampo == "B1_COLOR" 
  _cVerificar := .F.
EndIf

If _nCampo == "B1_BITMAP" .OR. _nCampo == "B1_CARGAE" .OR. _nCampo == "B1_CLASSE " .OR. _nCampo == "B1_CLASSVE" .OR. _nCampo == "B1_BALANCA" .OR. _nCampo == "B1_BASE2" .OR. _nCampo == "B1_CODOBS" .OR. _nCampo == "B1_DESC_GI" 
  _cVerificar := .F.
EndIf

If _nCampo == "B1_CODITE" .OR. _nCampo == "B1_CODLAN" .OR. _nCampo == "B1_CORSEC" .OR. _nCampo == "B1_CRDEST" .OR. _nCampo == "B1_DCI" .OR. _nCampo == "B1_CONTCQP"  .OR. _nCampo == "B1_DESC_I"  .OR. _nCampo == "B1_DESC_P"  
  _cVerificar := .F.
EndIf

If _nCampo == "B1_DTFIMNT" .OR. _nCampo == "B1_ESPECIE" .OR. _nCampo == "B1_ESPECIF"  .OR. _nCampo == "B1_FLAGSUG"  .OR. _nCampo == "B1_DCRE" .OR. _nCampo == "B1_DCRII" .OR. _nCampo == "B1_GRPNATR" .OR. _nCampo == "B1_GRADE"  .OR. _nCampo == "B1_GDODIF"   
  _cVerificar := .F.
EndIf

If _nCampo == "B1_FPCOD" .OR. _nCampo == "B1_FRETISS"  .OR. _nCampo == "B1_HREXPO"  .OR. _nCampo == "B1_IDHIST" .OR. _nCampo == "B1_INTEG" .OR. _nCampo == "B1_GRUDES"  .OR. _nCampo == "B1_MSEXP"  .OR. _nCampo == "B1_MONO"  
  _cVerificar := .F.
EndIf

If _nCampo == "B1_MIDIA" .OR. _nCampo == "B1_MODELO" .OR. _nCampo == "B1_MTTR" .OR. _nCampo == "B1_NALNCCA" .OR. _nCampo == "B1_NALSH"    .OR. _nCampo == "B1_NICONE"  .OR. _nCampo == "B1_NUMCOP" .OR. _nCampo == "B1_PRODPAI" .OR. _nCampo == "B1_MAT_PRI" 
  _cVerificar := .F.
EndIf

If _nCampo == "B1_MTBF" .OR. _nCampo == "B1_OBS" .OR. _nCampo == "B1_OPC" .OR.  _nCampo == "B1_LOCALIZ" .OR. _nCampo == "B1_QTDSER"  .OR. _nCampo == "B1_QTMIDIA"  .OR. _nCampo == "B1_QUADPRO" .OR. _nCampo == "B1_QB" .OR. _nCampo == "B1_QTDINIC" 
  _cVerificar := .F.
EndIf

If _nCampo == "B1_RASTRO " .OR. _nCampo == "B1_REQUIS" .OR. _nCampo == "B1_SETOR"    .OR. _nCampo == "B1_SITPROD" .OR. _nCampo == "B1_SITPROD" .OR. _nCampo == "B1_USERLGA" .OR. _nCampo == "B1_TIPVEC" .OR. _nCampo == "B1_TPPROD " .OR. _nCampo == "B1_TERUM"  
  _cVerificar := .F.
EndIf

If _nCampo == "B1_USERLGI" .OR. _nCampo == "B1_UVLRC"   .OR. _nCampo == "B1_VLREFUS" .OR. _nCampo == "B1_TECLA"  .OR. _nCampo == "B1_VM_GI" .OR. _nCampo == "B1_VM_I" .OR. _nCampo == "B1_VM_P" 
  _cVerificar := .F.
EndIf
//_nCampo == "B1_X_CUST" .OR. _nCampo == "B1_XBLOQ"  .OR. _nCampo == "B1_MSBLQL"   
Return _cVerificar


