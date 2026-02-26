//Bibliotecas ADVPL
#Include "Protheus.Ch"
#Include "rwmake.Ch"
#INCLUDE "TOPCONN.CH"  

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºRotina    ³  APONT001       ºAuto ³  Think Fast   º Data ³ 03/05/2023  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDescricao ³ Tela de apontamento usando a função paradrão ExecAuto      º±±
±±º            MATA361                                                    º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function APONT001()
//Definimos a fontes padrão a ser usada na tela.
DEFINE Font oBold Name "Arial" Size 0, -24 Bold
oFont20An	:= TFont():New("Arial",,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont40An	:= TFont():New("Arial",,40,.T.,.T.,5,.T.,5,.T.,.F.)
//CLR_BLACK - Preto
//CLR_RED   - Vermelho

//Variaveis local
Local bConfirm  //Objeto do Botão Confirmar
Local bSair     //Objeto do Botão Saoir
Local oDialog   //Objeto da Tela
//Variaveis Private
Private _cNumOP    := "" // 01- Número da OP
Private _nOPUser   := "" // 02- Codigo do Operador
Private _cNameUser := "" // 03- Nome do Operador
Private _nObsOP    := "" // 04- Obseração
Private _nOPeracao := 0  // 05- Número da Operação
Private _nHInicial := 0  // 06- Hora inicial
Private _nHFinal   := 0  // 07- Hora Final
Private _nQtde     := 0  // 08- Quantidade

//Cofirma o empenho
bConfirm := {|| ValidTela(_cNumOP,_nOPUser,_cNameUser,_nObsOP,_nOPeracao,_nHInicial,_nHFinal,_nQtde)  }
//bConfirm := {|| LCAMPOS()  }
//Fecha a tela
bSair    := {|| Iif(MsgYesNo( 'Você tem certeza que deseja fechar a tela? ','Fechar Tela'),(oDialog:DeActivate()),NIL) }

// Método responsável por criar a janela e montar os paineis.
oDialog := FWDialogModal():New()
// Métodos para configurar o uso da classe.
oDialog:SetBackground(.T.) 
oDialog:SetTitle('ORTOSINTESE - DIVISÃO EQUIPAMENTOS')
oDialog:SetSize(240,400)
oDialog:EnableFormBar(.T.)
oDialog:SetCloseButton(.T.)// habilita fechar pelo X da tela
oDialog:SetEscClose(.F.) // Habilita a tecla Esc pra fechar a tela
oDialog:CreateDialog()
oDialog:CreateFormBar()
oDialog:AddButton('Confirmar',bConfirm,'Confirmar',,.T.,.F.,.T.,)
//oDialog:AddButton('Sair',bSair, 'Sair',,.T.,.F.,.T.,)

// Capturar o objeto do FwDialogModal para alocar outros objetos se necessário.
oPanel := oDialog:GetPanelMain()
_cNumOP    := Space(11)
_nOPUser   := Space(06)
_cNameUser := Space(30)
_nObsOP    := Space(30)
_nOPeracao := 0
_nHInicial := 0
_nHFinal   := 0
_nQtde     := 0

//Label com o nome da tela
oSay1:= TSay():New(005,105,{||'TELA DE APONTAMENTO'},oPanel,,oFont40An,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
//Ordem de Produção
oSay1:= TSay():New(035,010,{||'ORDEM DE PRODUÇÃO'},oPanel,,oFont20An,,,,.T.,CLR_RED,CLR_WHITE,200,20)
@ 045,010 MSGET oGet01	VAR _cNumOP  F3 "SC2" PICTURE "@!"  SIZE 100,20  Font oBold OF oPanel  PIXEL VALID !Empty(cValidOP(_cNumOP))

//Operação
oSay1:= TSay():New(035,125,{||'OPERAÇÃO'},oPanel,,oFont20An,,,,.T.,CLR_RED,CLR_WHITE,200,20)
@ 045, 130 MSGET oGet02	VAR _nOPeracao   PICTURE "99"  SIZE 40,20   Font oBold OF oPanel  PIXEL
//Hora inicial
    //oSay1:= TSay():New(035,187,{||'HORA INICIAL'},oPanel,,oFont20An,,,,.T.,CLR_RED,CLR_WHITE,200,20)
    //@ 045,192 MSGET oGet03	VAR _nHInicial   PICTURE "99:99"  SIZE 40,20  Font oBold OF oPanel  PIXEL
    ////Hora Final
    //oSay1:= TSay():New(035,256,{||'HORA FINAL'},oPanel,,oFont20An,,,,.T.,CLR_RED,CLR_WHITE,200,20)
    //@ 045,257 MSGET oGet04	VAR _nHFinal   PICTURE "99:99"  SIZE 40,20  Font oBold OF oPanel  PIXEL
    ////Quantidade
    //oSay1:= TSay():New(035,340,{||'QTDE'},oPanel,,oFont20An,,,,.T.,CLR_RED,CLR_WHITE,200,20)
    //@ 045,322 MSGET oGet05	VAR _nQtde   PICTURE "@E 999.99" SIZE 20,20  Font oBold OF oPanel  PIXEL
//Codigo do Operador
oSay1:= TSay():New(080,010,{||'OPERADOR'},oPanel,,oFont20An,,,,.T.,CLR_RED,CLR_WHITE,200,20)
@ 090,010 MSGET oGet06	VAR _nOPUser  F3 "CB1" PICTURE "@!"  SIZE 050,20  Font oBold OF oPanel  PIXEL VALID !Empty(FUserName(_nOPUser))
//Nomer do operador
oSay1:= TSay():New(080,090,{||'NOME DO OPERADOR'},oPanel,,oFont20An,,,,.T.,CLR_RED,CLR_WHITE,200,20)
@ 090,090 MSGET oGet07 VAR _cNameUser  PICTURE "@!" SIZE 295, 20  Font oBold OF oPanel PIXEL 
oGet07:lActive := .F. //Disabilita a escrita no campo

//Campo Observação
//oSay1:= TSay():New(125,010,{||'OBSERVAÇÃO'},oPanel,,oFont20An,,,,.T.,CLR_RED,CLR_WHITE,200,20)
//@ 135,010 MSGET oGet08 VAR _nObsOP    PICTURE "@!" SIZE 375, 20 Font oBold OF oPanel PIXEL 

oSay1:= TSay():New(125,187,{||'HORA INICIAL'},oPanel,,oFont20An,,,,.T.,CLR_RED,CLR_WHITE,200,20)
@ 135,192 MSGET oGet03	VAR _nHInicial  PICTURE "99:99"  SIZE 40,20  Font oBold OF oPanel  PIXEL  VALID cValidTime(_nHInicial,1)
//Hora Final
oSay1:= TSay():New(125,256,{||'HORA FINAL'},oPanel,,oFont20An,,,,.T.,CLR_RED,CLR_WHITE,200,20)
@ 135,257 MSGET oGet04	VAR _nHFinal  PICTURE "99:99"  SIZE 40,20  Font oBold OF oPanel  PIXEL VALID cValidTime(_nHFinal,2)
//Quantidade
oSay1:= TSay():New(125,340,{||'QTDE'},oPanel,,oFont20An,,,,.T.,CLR_RED,CLR_WHITE,200,20)
@ 135,322 MSGET oGet05	VAR _nQtde  PICTURE "@E 999.99" SIZE 20,20  Font oBold OF oPanel  PIXEL

//Ativação da Tela
oDialog:Activate()

Return

/*---------------------------------------------------------------------*
 | Func:  cValidTela                                                   |
 | Autor: Think Fast                                                   |
 | Data:  03/05/2023                                                   |
 | Desc:  Função valida as variaveis e executa o MSExecauto.           |
 | Parametros:                                                         |
 | //01- Número da OP                                                  |
 | //02- Codigo do Operador                                            |
 | //03- Nome do Operador                                              |
 | //04- Obseração                                                     |
 | //05- Número da Operação                                            |
 | //06- Hora inicial                                                  |
 | //07- Hora Final                                                    |
 | //08- Quantidade                                                    |
 *---------------------------------------------------------------------*/
Static Function ValidTela(_cNumOP,_nOPUser,_cNameUser,_nObsOP,_nOPeracao,_nHInicial,_nHFinal,_nQtde)
//Setando o valor nas variaveis
Local xNumOP      := _cNumOP                        // Número da OP                 
Local xHInicial   := PADL(Alltrim(Transform(_nHInicial,"99:99")),5,"0" ) // Hora Inicial
Local xHFinal     := PADL(Alltrim(Transform(_nHFinal,"99:99")),5,"0")  // Hora Final
Local xCNQtde     := _nQtde                         // Quantidade 
Local xNOPUser    := PADL(Alltrim(_nOPUser),6,"0")  // Codigo do Usúario
Local xCNameUser  := Alltrim(_cNameUser)            // Nome do Operador
Local xNObsO      := _nObsOP                        // Observação da OP
Local xCProdOP    := ""                             // Codigo do Produto
Local xCRoteiro   := ""                             // Roteiro
Local xCOperacao  := PADL(_nOPeracao,2,"0")         // Operação
Local xCRecurso   := ""                             // Recurso
Local xCLocal     := ""                             // local
//Variaveis para dismenbrar o número da ordem de Produção.
Local _cXNumOP    := (SubStr(_cNumOP,1,6)) // Numero da OP
Local _cXItem     := (SubStr(_cNumOP,7,2)) // Item OP
Local _cXSeque    := (SubStr(_cNumOP,9,3)) // Sequencia OP
Local cMsg        := ""     //Variavel para montar a mensagem de erro
//Local nItensEmp   := {}   //Array para os codigo da SC2
Local _aAutoSH6   := {}     //Array com os dados a serem apontados.
Local nLogEmp     := ""     //Variavél para montar as informaçoes de Log. /LOGS_PROGRAMAS/MsExeAuto/MATA681
Local _cPath      := "LOGS_PROGRAMAS\MsExecAuto\MATA681\"
Local _cNome      := "LOG DE ERRO - TELA DE APONTAMENTO ---" +  xCNameUser  + "_D_" + DToS(dDataBase) + "_H_" + Strtran(SubStr(Time(),1,5),":","")+".txt"
//Local aAllusers  := FWSFALLUSERS()

//Variavél para montar a mensagem de erro
Private _cMsgErro := ""

//Verifica se o campo ordem de Produção foi preenchido
If Alltrim(_cNumOP) = ""
    MsgAlert("Por favor informe o número da Ordem de Produção !", "A N T E Ç Ã O")
    oGet01:Setfocus()
    Return(.F.)
EndIf

///Verifica se o campo operação foi preenchido
If _nOPeracao = 0
    MsgAlert("Por favor informe a operação !", "A N T E Ç Ã O")
    oGet02:Setfocus()
    Return(.F.)
EndIf

//Verifica se o campo codigo do operador foi preenchido
If Alltrim(_nOPUser) = ""
    MsgAlert("Por favor informe a o codigo do Operador!", "A N T E Ç Ã O")
    oGet06:Setfocus()
    Return(.F.)
EndIf

//Verifica se o campo hora inical foi preenchido
If _nHInicial = 0
    MsgAlert("Por favor informe a Hora Inicial !", "A N T E Ç Ã O")
    oGet03:Setfocus()
    Return(.F.)
EndIf

//Verifica se o campo hora foi preenchido
If _nHFinal = 0
    MsgAlert("Por favor informe a Hora Final !", "A N T E Ç Ã O")
    oGet04:Setfocus()
    Return(.F.)
EndIf

//Verifica se o campo quantidade foi preenchido
//If _nQtde = 0
//    MsgAlert("Por favor informe a Quantidade !", "A N T E Ç Ã O")
//     oGet05:Setfocus()
//    Return(.F.)
//EndIf

//Valida o tempo do empenho - A hora inical não pode ser maior que a hora final
If xHFinal < xHInicial
    MsgAlert("A hora final não pode ser menor que a hora inicial !", "A N T E Ç Ã O")
     oGet04:Setfocus()//Hora Final
    Return(.F.)
EndIf

//Valida o tempo do empenho - A hora inical não pode ser maior que a hora final
If xHFinal = xHInicial
    MsgAlert("A hora final não pode ser igual a hora inicial !", "A N T E Ç Ã O")
    oGet04:Setfocus()//Hora Final
    Return(.F.)
EndIf

//Seta o Alias das ordens de produção. (SC2)
dbSelectArea("SC2")
dbSetOrder(1)
If MsSeek(xFilial("SC2")+ _cXNumOP + _cXItem + _cXSeque)
    xCProdOP  := AllTrim(SC2->C2_PRODUTO) //Produto
    xCLocal   := AllTrim(SC2->C2_LOCAL)   //Armazém
    xCRoteiro := Alltrim(SC2->C2_ROTEIRO) //Roteiro
    //aadd(nItensEmp,[xNumOP,xCProdOP,xCLocal])
EndIf
// ROTEIRO DE OPERACOES
DbSelectArea("SG2")		
SG2->(DbSelectArea(1)) // G2_FILIAL+G2_PRODUTO+G2_CODIGO+G2_OPERAC
If MsSeek(xfilial("SG2")+xCProdOP+xCRoteiro+xCOperacao )
    xCRecurso :=    SG2->G2_RECURSO 
EndIf
//Força o condigo do recurso via query SQL.
IF Empty(xCRecurso)
    xCRecurso := NRECUSO(xCProdOP,xCRoteiro)// "000029"
EndIf

//Monta a mensagem de log
nLogEmp := "DATA     :"+DTOC(dDatabase)+ CRLF
nLogEmp += "HORA     :"+Time()+ CRLF
nLogEmp += "OPERADOR   :"+xNOPUser + CRLF
nLogEmp += "NOME     :"+xCNameUser + CRLF
nLogEmp += "**Tela de Apontamento** "+ CRLF

//Se a Observação estiver em branco 
If Empty(xNObsO)
    xNObsO := "Tela de Apontamento"
EndIf

//Força o codigo do usuario no sistema
DbSelectArea("CB1")
DbSetOrder(1) //CB1_FILIAL + CB1_CODOPE
If MsSeek(xFilial("CB1")+Alltrim(xNOPUser))
    iF CB1->CB1_CODOPE <> CB1->CB1_CODUSR
         xNOPUser  :=  CB1->CB1_CODUSR   //Posicione("SYS_USR",1,xFilial("SYS_USR")+nCodOper,"USR_NOME")
    EndIf
EndIf

//Monta o array com os dados do apontamento.
_aAutoSH6 := {}
aadd(_aAutoSH6, {"H6_OP"     , xNumOP    , NIL}) // 01 - Número da OP
aadd(_aAutoSH6, {"H6_PRODUTO", xCProdOP  , NIL}) // 02 - Codigo do Produto da OP
aadd(_aAutoSH6, {"H6_OPERAC" , xCOperacao, NIL}) // 03 - Número da Operação
aadd(_aAutoSH6, {"H6_RECURSO", xCRecurso , NIL}) // 04 - Número da Operação
aadd(_aAutoSH6, {"H6_DTAPONT", dDataBase , NIL}) // 05 - Data do Apontameto
aadd(_aAutoSH6, {"H6_DATAINI", dDataBase , NIL}) // 06 - Data inicial
aadd(_aAutoSH6, {"H6_HORAINI", xHInicial , NIL}) // 07 - Hora Inicial
aadd(_aAutoSH6, {"H6_DATAFIN", dDataBase , NIL}) // 08 - Data Fim
aadd(_aAutoSH6, {"H6_HORAFIN", xHFinal   , NIL}) // 09 - Hora Final
aadd(_aAutoSH6, {"H6_QTDPROD", xCNQtde   , NIL}) // 10 - Quantidade da OP
aadd(_aAutoSH6, {"H6_OPERADO", xNOPUser  , NIL}) // 11 - Codigo do Operador
aadd(_aAutoSH6, {"H6_LOCAL"  , xCLocal   , NIL}) // 12 - Armazém do Produto da OP
aadd(_aAutoSH6, {"H6_XLOG"   , nLogEmp   , NIL}) // 13 - Grava o log da rotina
aadd(_aAutoSH6, {"H6_OBSERVA", xNObsO    , NIL}) // 14 - Campo de Observação

//Seta a variavel erro.
lMSErroAuto := .F.
//Executa o MsExecAuto da rotina de apotamento
MsExecAuto({|x,y|MATA681(x,y)},_aAutoSH6,3)
//Verifica se ocorreu erro na execução, se sim grava o log de erro
If lMsErroAuto
    lRet:=.F.
    MostraErro(_cPath,_cNome)
    //Grava o erro na pasta informada
    _cMsgErro := MemoRead(_cPath + _cNome)
    DisarmTransaction()
    cMsg := '<b>Apontamento não realizado!</b>'
    cMsg += '<br>'
    cMsg += '<b>Foi envido log de erro.</b>'
    FWAlertError( cMsg, 'A T E N Ç Ã O')
  Else 
    cMsg := '<b>Apontamento realizado com sucesso!</b>'
    FWAlertSuccess( cMsg, 'A T E N Ç Ã O' )
Endif
//Chama a função pra limpar os campos da tela
LCAMPOS() 
//Setfocus no campo ordem d eprodução, desabilitado devido a validação do campo.
//oGet01:SetFocus()
Return()

/*---------------------------------------------------------------------*
 | Func:  LCAMPOS                                                      |
 | Autor: Think Fast                                                   |
 | Data:  03/05/2023                                                   |
 | Desc:  Função para limpar os campos da tela                         |
 *---------------------------------------------------------------------*/
Static Function LCAMPOS()
    //Limpando as variaveis
    _cNumOP    := ""
    _cNumOP    := Space(11)
    _nOPUser   := ""
    _nOPUser   := Space(06)
    _cNameUser := ""
    _cNameUser := Space(30)
    _nObsOP    := ""
    _nObsOP    := Space(30)
    _nOPeracao := 0
    _nHInicial := 0
    _nHFinal   := 0
    _nQtde     := 0
Return()

/*---------------------------------------------------------------------*
 | Func:  FUserName                                                    |
 | Autor: Think Fast                                                   |
 | Data:  03/05/2023                                                    |
 | Desc:  Função para posicionar o codigo do usuraio.                  |
 | Parametros:                                                         |
 | //01- Codigo do operador                                            |
 *---------------------------------------------------------------------*/
Static Function FUserName(_nOPUser)
Local nCodOper  := PADL(Alltrim(_nOPUser),6,"0") //Adiciona zeros a esquerda  //  _nOPUser
local nNomeOPer := ""
//Selecionando o alias (cadastro de operadores)
DbSelectArea("CB1")
DbSetOrder(1) //CB1_FILIAL + CB1_CODOPE
If MsSeek(xFilial("CB1")+Alltrim(nCodOper))
    nNomeOPer := Posicione("CB1",1,xFilial("CB1")+nCodOper,"CB1_NOME")
Else
    Alert("Operador não cadastrado...")
    //Return(.F.)
EndIf
    //Atribui o nome no operador a variavel.
    _cNameUser  := nNomeOPer
Return(_cNameUser)

/*---------------------------------------------------------------------*
 | Func:  cValidOP                                                     |
 | Autor: Think Fast                                                   |
 | Data:  03/05/2023                                                   |
 | Desc:  Função para valida se a op exite.                            |
 | Parametros:                                                         |
 | //01- Número da OP                                                  |
 *---------------------------------------------------------------------*/
Static Function cValidOP(_cNumOP)
    //Setando o valor nas variaveis
    Local _xNumOP := (SubStr(_cNumOP,1,6))//Número da OP
    Local _xItem  := (SubStr(_cNumOP,7,2))//Item
    Local _xSeque := (SubStr(_cNumOP,9,3))//Sequencia
    //Se o campo estiver vazio não faz nada
    If Alltrim(_cNumOP) <>""
        //Seta o Alias 
        dbSelectArea("SC2")
        dbSetOrder(1)
        If !MsSeek(xFilial("SC2")+_xNumOP+_xItem+_xSeque)
            Alert("Ordem de Produçao nao Encontrada...")
            Return(.F.)
        EndIf
    EndIf
Return(.T.)

/*---------------------------------------------------------------------*
 | Func:  NRECUSO                                                      |
 | Autor: Think Fast                                                   |
 | Data:  03/05/2023                                                   |
 | Desc:  Função força o posicionamento do codigo do recuso.           |
 | Parametros:                                                         |
 | //01- Codigo do Produto da OP                                       |
 | //02- Roteido                                                       |
 *---------------------------------------------------------------------*/
Static function NRECUSO(xCProdOP,xCRoteiro)
Local cQuery		:= ""
Local RECSG2    := ""
    //SELECT G2_RECURSO  FROM SG2010 WHERE G2_PRODUTO=''AND G2_OPERAC='' AND D_E_L_E_T_=''
    cQuery	:= "SELECT "+CHR(13)+CHR(10)
	cQuery	+= " G2_RECURSO AS RECURSO " +CHR(13)+CHR(10)
	cQuery	+= "FROM  "+CHR(13)+CHR(10)
	cQuery	+= 		RetSqlName("SG2")+" SG2 "+CHR(13)+CHR(10)
	cQuery	+= "WHERE  "+CHR(13)+CHR(10)
	cQuery	+= 		"SG2.D_E_L_E_T_ = ' ' AND "+CHR(13)+CHR(10)
	cQuery	+= 		"SG2.G2_PRODUTO = '"+xCProdOP+"' AND "+CHR(13)+CHR(10)
	cQuery	+= 		"SG2.G2_OPERAC  ='"+xCRoteiro+"' "+CHR(13)+CHR(10)
	cQuery  := ChangeQuery(cQuery)
	MemoWrite("TELAEMP.SQL", cQuery)
	dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery ), "NQRY" , .T. , .F. )	
	dbSelectArea( "NQRY" )
	dbGotop()
	  RECSG2 := alltrim(NQRY->RECURSO)
    NQRY->(DbCloseArea())
Return(RECSG2)

/*---------------------------------------------------------------------*
 | Func:  cValidTime                                                   |
 | Autor: Think Fast                                                   |
 | Data:  03/05/2023                                                   |
 | Desc:  Função para validar a hora didigata.                         |
 | Parametros:                                                         |
 | //01- Hora digitada                                                 |
 | //02- Campo                                                         |
 *---------------------------------------------------------------------*/
Static Function cValidTime(pHora,nCmpo)
	Local nTime := PADL(Alltrim(Transform(pHora,"99:99")),5,"0" ) //Formata a variavel Hora inicial
	Local cH    := SubStr(cValtoChar(nTime),1,2) // Varial Hora
	Local cM    := SubStr(cValtoChar(nTime),4,2) // Varial minuto
	Local cCmpo := nCmpo

    // Valida o campo Hora	
    If (Val(cH) >= 25) 
        cMsg := 'O Tempo máximo permitido é:'
        cMsg += '<br>'
        cMsg += '24 para hora, e 59 para minutos hora normal.'
        FWAlertHelp( 'Hora digitada Invalida.',cMsg)
        If cCmpo = 1
            oGet03:Setfocus()//Hora Inicial 
        Else
            oGet04:Setfocus()//Hora Final
        EndIf
		Return .F.
	EndIf 
	// Valida a Hora e minutos	
    If (Val(cH) >= 24) .and. (Val(cM) > 0)
        cMsg := 'O Tempo máximo permitido é:'
        cMsg += '<br>'
        cMsg += '24 para hora, e 59 para minutos hora normal.'
        FWAlertHelp( 'Hora digitada Invalida.',cMsg)
        If cCmpo = 1
            oGet03:Setfocus()//Hora Inicial 
        Else
            oGet04:Setfocus()//Hora Final
        EndIf
		Return .F.
	EndIf 
    //Valida os minutos
	If Val(cM) > 59
        cMsg := 'O Tempo máximo permitido é:'
        cMsg += '<br>'
        cMsg += '24 para hora, e 59 para minutos hora normal.'
        FWAlertHelp('Hora digitada Invalida.',cMsg)
       If cCmpo = 1
            oGet03:Setfocus()//Hora Inicial
        Else
            oGet04:Setfocus()//Hora Final
        EndIf
		Return .F.
	EndIf
Return

