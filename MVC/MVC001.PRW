#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "RwMake.ch"
#Include "Totvs.ch"
#INCLUDE "TOPCONN.CH" 

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºFunção   ³ MVC001       ºAuto ³Samuel Miranda     º Data ³ 18/05/2021  º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±ºDescricao ³ Tela em MVC, Controle de Objetos despachados na expediçao  º±±//
//±±º      Especifico Ortosintese                                           º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//

User Function MVC001()

    Local aArea   := GetArea()
    Local oBrowse 
    //Instancia o Objeto oBrowse
    oBrowse := FWMBrowse():New()
    //Setenado o Alias
    oBrowse:SetAlias("ZWN")
    //Setando a descrição da Tela.
    oBrowse:SetDescription("Controle de Objetos Despachados - Expedição - Filial")
    //Legenda
    oBrowse:AddLegend("ZWN_STATUS=='1' ","RED","Retirado")
    oBrowse:AddLegend("ZWN_STATUS=='2' ","YELLOW","Aguardando Coleta")
    oBrowse:AddLegend("ZWN_STATUS=='3' ","BLUE","NF Entrada")
    
    //Inicia a Menu
    oBrowse:SetMenuDef("MVC001")
    oBrowse:Activate()

    RestArea(aArea)
Return


/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
Static Function MenuDef()
    //Local _aRotina := FWMvcMenu("MVC001")
    //Variavel com as rotinas do menu.
    Local _aRotina   := {}
    Private cCodUser := RetCodUsr() //Retorna o Codigo do Usuario 
    Private cNamUser := UsrRetName(cCodUser) //Retorna o nome do Usuario 
    
    Add OPTION _aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC001' OPERATION 2 ACCESS 0
    //Controle de Acesso por Usuários MV_TELNOTA
    If cCodUser $ Alltrim(SuperGetMv("MV_CADNF")) // "000000/000019/000096/000414/000591/000114/000152/000037/000416/000694" //Da pra fazer por parametro - Samuel
        //Add OPTION _aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC001' OPERATION 3 ACCESS 0
        Add OPTION _aRotina TITLE 'Incluir'    ACTION 'U_nIncluiSf2'    OPERATION 3 ACCESS 0
        Add OPTION _aRotina TITLE 'Alterar'    ACTION 'U_nAlterarSf2'   OPERATION 4 ACCESS 0
        Add OPTION _aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC001'  OPERATION 5 ACCESS 0
        ADD OPTION _aRotina TITLE 'Conhecimento' ACTION 'MsDocument' OPERATION MODEL_OPERATION_VIEW ACCESS 0
        // Add OPTION _aRotina TITLE 'Conhecimento'    ACTION {|| }  OPERATION 5 ACCESS 0
        //aAdd(_aRotina, {"Conhecimento", "MsDocument('ZWN', ZWN->(RecNo()), 4)", 0, 4, 0, Nil}) MODEL_OPERATION_VIEW
        //Add OPTION _aRotina TITLE 'Monitor NF' ACTION 'U_MBNOTAS'       OPERATION 7 ACCESS 0
    EndIf
    Add OPTION _aRotina TITLE 'Legenda'    ACTION 'U_nLegenda '    OPERATION 6 ACCESS 0
    // aAdd(aRotina, {"Conhecimento", "MsDocument('ALIAS', ALIAS->(RecNo()), 4)", 0, 4, 0, Nil})
    //Inclusão - Inclusão de itens
    // FWExecView( 'INCLUI', 'VIEWDEF.MVC001', MODEL_OPERATION_INSERT, /*oDlg*/ , {||.T.}, /*bOk*/ , /*nPercReducao*/ ,/*aButtons*/)
    /*
    1-Pesquisar,2-Visuaçizar,3-Incluir ,4-Alterar, 5-Excluir, 7-Copiar
    000000 = Administrador
    000096 = regiane
    000414 = lourdes
    000114 = samuel
    000416 = juciene
    000037 = fabiane
    000152 = Fernanda Borges
    000700 = Cátia Gonçalvez
    000168 = Livia Tritiack
    000690 = Vitor 
    000694 = Greice
     "000000";"000096";"000414";"000114";"000416";"000037";"000152";"000700";"000168";"000690";"000694"   

    */
Return _aRotina

/*---------------------------------------------------------------------*
 | Func:  nIncluiSf2                                                   |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:  Função para atualizar a SF2 quando fou inclusão.             |
 *---------------------------------------------------------------------*/
User Function nIncluiSf2()
     FWExecView( 'INCLUI', 'VIEWDEF.MVC001', MODEL_OPERATION_INSERT, /*oDlg*/ , {||.T.,U_ATALIZASF2()}, /*bOk*/ , /*nPercReducao*/ ,/*aButtons*/)
Return()

/*---------------------------------------------------------------------*
 | Func:  nIncluiSf2                                                   |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:  Função para atualizar a SF2 quando fou inclusão.             |
 *---------------------------------------------------------------------*/
User Function CANHOT()
    FWExecView( 'INCLUI', 'VIEWDEF.MVC001', MODEL_OPERATION_VIEW, /*oDlg*/ , {"Conhecimento", "MsDocument('ZWN', ZWN->(RecNo()), 4)", 0, 4, 0, Nil}, /*bOk*/ , /*nPercReducao*/ ,/*aButtons*/)
     //aAdd(aRotina, {"Conhecimento", "MsDocument('ALIAS', ALIAS->(RecNo()), 4)", 0, 4, 0, Nil})
Return()


/*---------------------------------------------------------------------*
 | Func:  nAlterarSf2                                                  |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:    Função para atualizar a SF2 quando fou Ateração.           |
 *---------------------------------------------------------------------*/
User Function nAlterarSf2()
    FWExecView( 'INCLUI', 'VIEWDEF.MVC001',MODEL_OPERATION_UPDATE, /*oDlg*/ , {||.T.,U_ATALIZASF2()}, /*bOk*/ , /*nPercReducao*/ ,/*aButtons*/)
Return()

/*---------------------------------------------------------------------*
 | Func:  ATALIZASF2                                                   |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:  Função para atualizar a SF2 quando a NF for despachada       |
 *---------------------------------------------------------------------*/
User Function ATALIZASF2()
//Pega o model que está ativo.
Local oModel    := FWModelActive()
//Variaveis 
Local cNotasFN  := oModel:GetValue( 'FORMZWN' , 'ZWN_NFS' )  //Atribui as notas fiscais a variavel
Local cStatusNf := oModel:GetValue( 'FORMZWN' , 'ZWN_STATUS' ) //Atruibui o status
Local _aArea  	:= GetArea()
Local _aAreaF2	:= SF2->(GetArea())
Local i         := 0

iF !Empty(cNotasFN) 
    cString := AllTrim(cNotasFN)
    cString := strtokarr (cString, "/")

    dbSelectArea("SF2")
    dbSetOrder(1)
    For i = 1 to len(cString) 
        DbSelectArea("SF2")
		SF2->(DbSetOrder(1))
		SF2->(DbGotop())
        If DBSeek(xFilial("SF2")+ Alltrim(cString[i] ))   
            RecLock("SF2",.F.)
                //SF2->F2_XEXPED	:= "S" //cStatusNf
                SF2->F2_XEXPED	:= cStatusNf
            MsUnlock()         
        Endif
 
    Next i
      
EndIf
RestArea(_aArea)
RestArea(_aAreaF2)
			
Return Nil

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
Static Function ModelDef()
    Local  oModel    := Nil
    Local  oStZWN    := FWFormStruct(1, "ZWN")

    //Instaciando o modelo de dados
    oModel := MPFormModel():New("ZMVC001M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) //
    oModel:AddFields("FORMZWN",/*cOwner*/,oStZWN)
    oModel:SetPrimaryKey({'ZWN_FILIAL','ZWN_ID'})
    oModel:SetDescription("Controle de Objetos")
    oModel:GetModel("FORMZWN"):SetDescription("Objetos") 
    //oModel:SetVldActivate({|oModel| ValidaOper(oModel)})
Return oModel

/*
Static Function ValidaOper(oModel)
Local _nOperation := oModel:GetOperation()
Local lRet := .T.

If _nPeration == ODEL_OPERATION_UPDATE 
 Help(,,"HELO",, "ACESSO DE UPDATE ACIONADO",1,0)
 lRet := .F.
EndIf

Return lRet
*/
     
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:  Criação da visão MVC                                         |
*---------------------------------------------------------------------*/
Static Function ViewDef()

    //Local aStruZWN := ZWN->(DbStruct())
    Local oModel := FWLoadModel("MVC001")
    Local oStZWN := FWFormStruct(2, "ZWN")
    Local oView  := Nil
    Local _nPeratio := oModel:GetOperation()

    oView := FWFormView():New()

    oView:SetModel(oModel)

    oView:AddField("VIEW_ZWN", oStZWN, "FORMZWN")

    oView:CreateHorizontalBox("TELA",100)

    oView:EnableTitleView("VIEW_ZWN", 'Controle de Objetos despachados')
    oView:SetOwnerView("VIEW_ZWN","TELA")

    oStZWN:RemoveField("ZWN_FILIAL")    //RemoveField("ZWN_FILIAL")

    oView:SetCloseOnOk({||.T.})
  
    oView:EnableControlBar(.T.)
    
   if _nPeratio == 4 
        Help(,,HELP,,"TESTE DE MODO DE OPERAÇÃO ",1,0)
   EndIf
   // oView:SetViewAction('BUTTONOL',{|oView| MsgInfo("Botão Ok Acionado")})
Return oView

/*---------------------------------------------------------------------*
 | Func:  nLegenda                                                     |
 | Autor: Samuel Miranda                                               |
 | Data:  18/05/2021                                                   |
 | Desc:  Informação da legenda                                        |
 *---------------------------------------------------------------------*/
User Function nLegenda()
    Local a_legenda :={}
    //Monta as cores
    AADD(a_legenda,{"BR_VERMELHO","Retirado"})
    AADD(a_legenda,{"BR_AMARELO","Aguardando Coleta"})
    AADD(a_legenda,{"BR_AZUL",	"NF Entrada"})
        
    BrwLegenda("Status do Envio", "Status", a_legenda)
Return

/*

User Function GRAVPROD(_aItens)

Local oModel   := FWModelActive()
//Local cNchaves := oModel:GetValue( 'FORMZWN' , 'ZWN_CHVS' )
Local cNotasFN := oModel:GetValue( 'FORMZWN' , 'ZWN_NFS' )
Local cIDNota  := oModel:GetValue( 'FORMZWN' , 'ZWN_ID' )
Local _cQuery  := ""
Local _cWhere  := "" //"35140648240709000190550010000972561009375112"//cNchaves
Local nRec     := 0
Local _xItem   := 0


iF !Empty(cNotasFN) 
cString := AllTrim(cNotasFN)

cString := Alltrim(StrTran(Alltrim(cString)," ","")) 
    //_nArraynF := strtokarr (cString, "/")
 //FormatIn(cTemp,'/'), 'UniversoADVPL' )
  
        //For _xItem := 1 to Len(_nArraynF)

        _cWhere := FormatIn(cString,'/') // (AllTrim(_nArraynF[_xItem]))
     
        If !(Empty(_cWhere))

            _cQuery  := "SELECT "+CHR(13)+CHR(10)
            _cQuery  += "SD2.D2_DOC AS NUMNOTA,"+CHR(13)+CHR(10)
            _cQuery  += "SD2.D2_FILIAL AS FILIAL,"+CHR(13)+CHR(10)
            _cQuery  += "SD2.D2_ITEM AS ITEM,"+CHR(13)+CHR(10)
            _cQuery  += "SD2.D2_COD AS CODPRO,"+CHR(13)+CHR(10)
            _cQuery  += "SD2.D2_UM AS UNIDADE,"+CHR(13)+CHR(10)
            _cQuery  += "SD2.D2_QUANT AS QTDE,"+CHR(13)+CHR(10)
            _cQuery  += "SD2.D2_PRCVEN AS VALOR,"+CHR(13)+CHR(10)
            _cQuery  += "SD2.D2_TOTAL AS VTOTAL,"+CHR(13)+CHR(10)
            _cQuery  += "SD2.D2_LOTECTL AS LOTE,"+CHR(13)+CHR(10)
            _cQuery  += "SD2.D2_DTVALID AS VALIDADE,"+CHR(13)+CHR(10)
            _cQuery  += "SD2.D2_PEDIDO AS NUMPED,"+CHR(13)+CHR(10)
            _cQuery  += "SD2.D2_CLIENTE AS CODCLI,"+CHR(13)+CHR(10)
            _cQuery  += "SD2.D2_LOJA AS LOJACLI,"+CHR(13)+CHR(10)
            _cQuery  += "SF2.F2_CHVNFE AS CHAVENF"+CHR(13)+CHR(10)
            _cQuery  += "FROM "+CHR(13)+CHR(10)
            _cQuery  += RetSqlName("SD2")+" SD2 "+CHR(13)+CHR(10)
            _cQuery  += "INNER JOIN SF2010 SF2 ON SF2.F2_FILIAL= SD2.D2_FILIAL AND SF2.F2_DUPL = SD2.D2_DOC  AND SF2.F2_CLIENTE =  SD2.D2_CLIENTE AND SF2.D_E_L_E_T_ ='' "+CHR(13)+CHR(10)
            _cQuery  += "WHERE  "+CHR(13)+CHR(10)
            _cQuery  += "SD2.D2_DOC IN "+_cWhere+ " "   // "'"+ Alltrim(_cWhere)+"' "+CHR(13)+CHR(10)
            _cQuery  += "ORDER BY NUMNOTA"
            _cQuery  := ChangeQuery(_cQuery)
            //Grava o resultado da Query
            MEMOWRIT( "GRAPROD.SQL", _cQuery ) 
            //Executa a Query
            dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery),"CQRY",.T.,.F. )

            //Variavel 
            nRec	:= 0
            //Seleciona o Alias resultante da query e conta os registros.
            dbSelectArea( "CQRY" )
            dbGotop()
            CQRY->(dbEval({ ||nRec++},,{||!Eof()} ))
            dbGoTop()
        EndIF	

        iF nRec >= 1
                //Inicia um Transação   //Posicione("SB1",1,xFilial("SB1")+M->ZK_CODPROD,"B1_DESC") _cManifest := GetSX8Num("SZH","ZH_CODIGO")
                Begin Transaction
                    While !CQRY->(Eof())

                        RecLock("ZWM",.T.)
                        ZWM->ZWM_FILIAL     := xFilial("ZWM")
                        ZWM->ZWM_ID         := cIDNota                //GetSX8Num("ZWM","ZWM_ID")
                        ZWM->ZWM_CHVNF      := CQRY->CHAVENF
                        ZWM->ZWM_DOC        := CQRY->NUMNOTA
                        ZWM->ZWM_ITEM       := CQRY-> ITEM
                        ZWM->ZWM_CODPRO     := CQRY->CODPRO
                        ZWM->ZWM_DECPRO     := Posicione("SB1",1,xFilial("SB1")+AllTrim(CQRY->CODPRO),"B1_DESC")
                        ZWM->ZWM_UMPRO      := CVALTOCHAR(CQRY->UNIDADE)
                        ZWM->ZWM_QUANT      := CQRY->QTDE //Transform(CQRY->QTDE,"9999")  //Transform(PRCVEN,"@E 9,999,999.99"),;
                        ZWM->ZWM_PRCVEN     := CVALTOCHAR(CQRY->VALOR)
                        ZWM->ZWM_TOTAL      := CVALTOCHAR(CQRY->VTOTAL)
                        ZWM->ZWM_LOTECTL    := CQRY->LOTE
                        ZWM->ZWM_TDVALID    := CQRY->VALIDADE
                        ZWM->ZWM_PEDIDO     := CQRY->NUMPED
                        ZWM->ZWM_CLIENTE    := CQRY->CODCLI
                        ZWM->ZWM_LOJACLI    := CQRY->LOJACLI

                        ZWM->(MsUnLock())
                        
                        CQRY->(DbSkip())
                    EndDo

                //CQRY->(DbClosearea())
                //Encerra a Transação
                End Transaction
        EndIF        
    
    
    CQRY->(DbClosearea())

EndIF

Return()
 