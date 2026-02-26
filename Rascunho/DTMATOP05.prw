//Bibliotecas
#Include "TOTVS.ch"
 
/*/{Protheus.doc} User Function zExe215
Exemplo de função que cria uma dialog
@type Function
@author Atilio
@since 20/02/2023
@see https://tdn.totvs.com/display/public/framework/FwDialogModal
@obs 
 
    **** Apoie nosso projeto, se inscreva em https://www.youtube.com/TerminalDeInformacao ****
/*/
 
User Function DTMATOP05()
  //User Function APONT001()
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
Private _cIdioma   := "" // 02- Codigo do Operador
Private _nQtdCop   := 1  // 03- Quantidade de Copia
Private _nQtEmb    := 0  // 04- Embalagem
Private _aCbxIdoma := {"1-Português", "2-Inglês", "3-Espanhol"}
Private _dDtFab	  := nil
Private _cLocImp    := Space(06) //Local de IMpressão

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
_cIdioma   := Space(30)
_nQtdCop   := Space(30)
_nQtEmb    := 0
_aCbxIdoma := 0
_dDtFab	   := 0
_cLocImp   := 0

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
