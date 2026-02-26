#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MRPREL01   ºAutor  ³Eduardo Barbosa     º Data ³  22/08/22   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gerar Planilha Excel do Relatório de Lista Critica         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO ( PRCOESSAMENTO MRP)	                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß  
*/

User Function MRPITCTR(_lAuto,_cNumTick,_cDirArq,_lTipArq,_lFilPrd,_lFilDem)


//HW1 - Parâmetros utilizados no cálculo do MRP
//HW3 - Processamento do MRP

Private _aPergs		:= {}
Private _aRet       := {" "," "," "," "," "," ",}
Private cTicket     := Space(6)      
Private _aTitCol    := {}
Private _cCodBase   := " "
Private _aPeriodos  := {}
Private _aPrefPer   := {  "A"  ,    "B"     ,     "C"         ,   "D"    ,      "S"     ,     "E"       ,    "F"         ,    "G"          ,"H"        ,  "I"} 
Private _aTituPer   := {"Saida","Sol.Compra","Ped.Compra/O.P.","Transito","Substituicao","Total Entradas","Saida Estrutura","Saldo Estoque","Necessidade","Comentario"}
Private _oTableHWB  := ' '
Private _cAliasHWB  := ' '
Private _cNameHWB   := ' '
Private _oTableHWM  := ' '
Private _cAliasHWM  := ' '
Private _cNameHWM   := ' '

Private nEstru      := 0 // Variavel utilizada na chamada da funcão de explosao da estrutura
Private aEstrutura  := {} // Variavel utilizada na chamada da funcão de explosao da estrutura
Private _cCodPrin   := ' '
Private _cCodComp   := ' '
Private _nQtdComp   := 0
Private _nPerComp   := 0
Private _nTotComp   := 0
Private _cGrpOpc    := ' '
Private _cDir       := ' '
Private _lTipXml    := .T.
Private _lFilProd   := .F.
Private _lSemDem    := .F.
Private _cPrimPer   := ' '

DEFAULT _lAuto      := .F.
DEFAULT _cNumTick   := " "
DEFAULT _cDirArq    := "C:\TEMP\"
DEFAULT _lTipArq    := "2"
DEFAULT _lFilPrd    := "1"
DEFAULT _lFilDem    := '1'

AADD(_aPergs, {1, "Ticket MRP                    ", Space(TamSX3('HW3_TICKET')[01]), "", ".T.", "HW3", ".T.", 80,  .F.})
AADD(_aPergs, {6 ,"Pasta para Gravação do arquivo",Space(100),"","","",50,.T.,"C:\",,GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY})
aAdd(_aPergs, {2 ,"Tipo Planilha","1-XML",{'1-Com Formatação','2-Sem Formatação'},80,"",.T.	 })
aAdd(_aPergs, {2 ,"Filtra Prod x Fil Compra","1-Não",{'1-Não','2-Sim'},80,"",.T.	 })
aAdd(_aPergs, {2 ,"Produtos Sem Demanda","1-Sim",{'1-Sim','2-Não'},80,"",.T.	 })


// Parametros da função Parambox()
// -------------------------------
// 1 - < aParametros > - Vetor com as configurações
// 2 - < cTitle >      - Título da janela
// 3 - < aRet >        - Vetor passador por referencia que contém o retorno dos parâmetros
// 4 - < bOk >         - Code block para validar o botão Ok
// 5 - < aButtons >    - Vetor com mais botões além dos botões de Ok e Cancel
// 6 - < lCentered >   - Centralizar a janela
// 7 - < nPosX >       - Se não centralizar janela coordenada X para início
// 8 - < nPosY >       - Se não centralizar janela coordenada Y para início
// 9 - < oDlgWizard >  - Utiliza o objeto da janela ativa
//10 - < cLoad >       - Nome do perfil se caso for carregar
//11 - < lCanSave >    - Salvar os dados informados nos parâmetros por perfil
//12 - < lUserSave >   - Configuração por usuário

// Caso alguns parâmetros para a função não seja passada será considerado DEFAULT as seguintes abaixo:
// DEFAULT bOk   := {|| (.T.)}
// DEFAULT aButtons := {}
// DEFAULT lCentered := .T.
// DEFAULT nPosX  := 0
// DEFAULT nPosY  := 0
// DEFAULT cLoad     := ProcName(1)
// DEFAULT lCanSave := .T.
// DEFAULT lUserSave := .F.

//_lRet := PARAMBOX(_aPergs, "Informe os parâmetros", _aRet)
If ! _lAuto 
    _lRet := PARAMBOX(_aPergs, "Informe os parâmetros", _aRet, , , , , , , ,.T.,.T.)
Else
    _lRet := .T.
    _aRet[01] := _cNumTick
    _aRet[02] := _cDirArq
    _aRet[03] := _lTipArq
    _aRet[04] := _lFilPrd
    _aRet[05] := _lFilDem
Endif
If _lRet
    _cTicket := _aRet[01]
    _cDir     := Alltrim(_aRet[02])
    _lTipXML  := IIF(Left(_aRet[03],1) == "1" ,.T.,.F.) // 1=Xml, 2=XLS
    _lFilProd := IIF(Left(_aRet[04],1) == "2" ,.T.,.F.) // 1=Nao, 2=Sim
    _lSemDem  := IIF(Left(_aRet[05],1) == "1" ,.T.,.F.) // 1=Sim, 2=Nao
    
    // Cria Tabela Temporaria
    If ! _lAuto 
        MsAguarde({|| CRIATRB()},OemtoAnsi("Criando Tabela Temporaria"))
    Else
        CRIATRB()
    Endif
    // Atualiza Tabela Temporaria
    If ! _lAuto 
        MsAguarde({|| GRAVATRB()},OemtoAnsi("Gravando Tabela Temporaria"))
    Else
        GRAVATRB()
    Endif
    // Gera Excel da Tabela Temporaria
    If ! _lAuto 
        MsAguarde({|| FGerExcel(_cTicket)},OemtoAnsi("Gerando Planilha Excel"))
    Else
        FGerExcel(_cTicket)
    Endif
    // Apaga Tabelas temporarias 
    If ValType(_oTableHWB) == "O"
    	_oTableHWB:Delete()
    	_oTableHWB := Nil
    EndIf

    If ValType(_oTableHWM) == "O"
    	_oTableHWM:Delete()
    	_oTableHWM := Nil
    EndIf
  
Endif

Return


//********************************************
Static Function CriaTRB()                     
//*******************************************


Local _nElemPer := 0
Local _nElemPre := 0
Local _cCpoPer  := ' '
Local cQuery    := ' '
Local cTmpAlias := GetNextAlias()

Private _cTMPHWB	:= GetNextAlias()    // HWB - Resultados do MRP - Sumarizados;
Private _aFieldsHWB := {}
Private _cTMPHWM	:= GetNextAlias()    // HWM - LOG de Eventos MRP;
Private _aFieldsHWM := {}


//********************************************************************************
//  I N I C I O  G E R A Ç Ã O  T E M P O R A R I O    LISTA DE CRITICOS
//*********************************************************************************

//  // Criar Query Para Buscar Produtos e Periodos
cQuery += "	SELECT HWB_DATA AS CAMPO FROM "+ RetSqlName("HWB")  + CRLF 
cQuery += "	WHERE HWB_FILIAL='"+xFilial("HWB") +"'" + CRLF 
cQuery += "	AND HWB_TICKET='"+_cTicket +"'" + CRLF 
cQuery += "	AND D_E_L_E_T_=' ' " + CRLF 
cQuery += "	GROUP BY HWB_DATA " + CRLF 

If !(Empty(cTmpAlias)) .And. (Select(cTmpAlias) > 0)
	(cTmpAlias)->(DbCloseArea())
EndIf

MpSysOpenQuery(cQuery, cTmpAlias)

While !(cTmpAlias)->(Eof())
    AADD(_aPeriodos,(cTmpAlias)->CAMPO)
    If Empty(_cPrimPer)
       _cPrimPer := (cTmpAlias)->CAMPO
    Endif
    (cTmpAlias)->(DbSkip())
Enddo
If !(Empty(cTmpAlias)) .And. (Select(cTmpAlias) > 0)
	(cTmpAlias)->(DbCloseArea())
EndIf

// Campos da Tabela de Dados Sumarizados
Aadd(_aFieldsHWB, {"HWB_FILIAL" ,"C" ,TamSX3('HWB_FILIAL')[01], 0})
Aadd(_aFieldsHWB, {"HWB_PRODUT" ,"C" ,TamSX3('B1_COD')[01], 0})
Aadd(_aFieldsHWB, {"B1_DESC"   ,"C" ,TamSX3('B1_DESC')[01], 0})
Aadd(_aFieldsHWB, {"B1_UM"     ,"C" ,TamSX3('B1_UM')[01], 0})
Aadd(_aFieldsHWB, {"G1_GROPC"  ,"C" ,TamSX3('G1_GROPC')[01], 0})
Aadd(_aFieldsHWB, {"B1_TIPO"   ,"C" ,TamSX3('B1_TIPO')[01], 0})
Aadd(_aFieldsHWB, {"X5_DESCRI" ,"C" ,50, 0})
Aadd(_aFieldsHWB, {"B1_GRUPO"  ,"C" ,TamSX3('B1_GRUPO')[01], 0})
Aadd(_aFieldsHWB, {"BM_DESC"   ,"C" ,TamSX3('BM_DESC')[01], 0})
Aadd(_aFieldsHWB, {"COMPRADOR" ,"C" ,50, 0})
Aadd(_aFieldsHWB, {"FORNECEDOR","C" ,50, 0})

Aadd(_aFieldsHWB, {"B1_QE"    ,"N" ,TamSX3('B1_QE')[01], 2})
Aadd(_aFieldsHWB, {"SLDWIP"    ,"N",TamSX3('B2_QATU')[01], 2})
Aadd(_aFieldsHWB, {"B2_QATU"  ,"N" ,TamSX3('B2_QATU')[01], 4})
Aadd(_aFieldsHWB, {"B2_QNPT"  ,"N" ,TamSX3('B2_QNPT')[01], 4})
Aadd(_aFieldsHWB, {"SALEST"   ,"N" ,TamSX3('B2_QNPT')[01], 4})


// Criação dos Campos de Periodo
 For _nElemPer := 1 To Len(_aPeriodos)
     For _nElemPre := 1 To Len(_aPrefPer)
         _cCpoPer := _aPrefPer[_nElemPre]+"_"+Alltrim(_aPeriodos[_nElemPer])  //D20220501, E20220501,S20220501,C20220501 
         Aadd(_aFieldsHWB, {_cCpoPer,"N",18, 6})  
     Next _nElemPer
Next _nElemPer

Aadd(_aFieldsHWB, {"ESTOQUE"   ,"N" ,TamSX3('B2_QATU')[01], 4}) // TOTAL DEMANDAS
Aadd(_aFieldsHWB, {"DEMANDAS"  ,"N" ,TamSX3('B2_QATU')[01], 4}) // TOTAL DEMANDAS
Aadd(_aFieldsHWB, {"ENTRADAS"  ,"N" ,TamSX3('B2_QNPT')[01], 4}) // TOTAL ENTRADAS
Aadd(_aFieldsHWB, {"BALANCE"   ,"N" ,TamSX3('B2_QATU')[01], 4}) // ENTRADAS-SAIDAS


// Criação da Tabela de Dados Sumarizados

_oTableHWB := FWTemporaryTable():New(_cTmpHWB, _aFieldsHWB)

// Criação de Indices de Dados Sumarizados
_oTableHWB:AddIndex("01", {"HWB_PRODUT"} )
_oTableHWB:Create()
	
//Pega o alias das tabelas temporárias de Dados Sumarizados
_cAliasHWB := _oTableHWB:GetAlias()

// Pega o Nome Real das Tabelas de Dados Sumarizados
_cNameHWB  :=_oTableHWB:GetRealName()

//********************************************************************************
// F I N A L   G E R A Ç Ã O  T E M P O R A R I O    LISTA DE CRITICOS
//*********************************************************************************


Return


//********************************************
Static Function GravaTRB()                     
//*******************************************

// Gravação do Temporario da Lista Critica
GrvLista()

Return

//********************************************
Static Function GrvLista()
//*******************************************

Local cQuery     := ' '
Local cTmpAlias  := GetNextAlias()
Local _aStruQry  := ' '
Local _nElemQry  := 0
Local _cCodProd  :=' '

Local _aSaldEst  := {} // Saldos em Estoque
Local _aMovEntr  := {} // Saldo das Entradas
//Local _cArm      := "('01','02','04','09','11','13')"

//  // Criar Query Para Buscar Produtos e Periodos

cQuery := "	SELECT * FROM (  " + CRLF
cQuery += "	SELECT 'MRP' AS TIPO ,HWB_FILIAL,HWB_PRODUT,HWB_DATA,  " + CRLF 
cQuery += "	SUM(HWB_QTSLES) AS HWB_QTSLES ,  " + CRLF
cQuery += "	SUM(HWB_QTENTR) AS HWB_QTENTR ,  " + CRLF
cQuery += "	SUM(HWB_QTSAID) AS HWB_QTSAID ,  " + CRLF
cQuery += "	SUM(HWB_QTSEST) AS HWB_QTSEST ,  " + CRLF
cQuery += "	SUM(HWB_QTSALD) AS HWB_QTSALD ,  " + CRLF
cQuery += "	SUM(HWB_QTNECE) AS HWB_QTNECE   " + CRLF
cQuery += "	FROM "+ RetSqlName("HWB") +" HWB, "  + CRLF
cQuery += " "+RetSqlName("SB1") +" SB1 "  + CRLF
cQuery += "	WHERE HWB_FILIAL='"+xFilial("HWB") +"'" + CRLF 
cQuery += "	AND HWB_TICKET='"+_cTicket +"'" + CRLF 
cQuery += "	AND HWB_PRODUT=B1_COD   " + CRLF
cQuery += "	AND HWB.D_E_L_E_T_=' '  " + CRLF
cQuery += "	AND SB1.D_E_L_E_T_=' '  " + CRLF
cQuery += "	GROUP BY HWB_FILIAL,HWB_PRODUT,HWB_DATA  " + CRLF 

If _lSemDem
    cQuery += "	UNION ALL  " + CRLF
    cQuery += "	SELECT 'EST' AS TIPO,T4V_FILIAL AS HWB_FILIAL,T4V_PROD HWB_PRODUT, " + CRLF
    cQuery += "	'"+_cPrimPer+"' AS HWB_DATA,  " + CRLF
    cQuery += "	SUM(T4V_QTD) AS HWB_QTSLES ,  " + CRLF
    cQuery += "	0 AS HWB_QTENTR , " + CRLF
    cQuery += "	0 AS HWB_QTSAID , " + CRLF
    cQuery += "	0 AS HWB_QTSEST , " + CRLF
    cQuery += "	0 AS HWB_QTSALD , " + CRLF
    cQuery += "	0 AS HWB_QTNECE  " + CRLF
    cQuery += "	FROM "+ RetSqlName("T4V") +" T4V, "  + CRLF
    cQuery += " "+RetSqlName("SB1") +" SB1 "  + CRLF
    cQuery += "	WHERE T4V_FILIAL='"+xFilial("HWB") +"'" + CRLF 
    cQuery += "	AND T4V_PROD = B1_COD   " + CRLF
    cQuery += "	AND T4V.D_E_L_E_T_=' '  " + CRLF
    cQuery += "	AND SB1.D_E_L_E_T_=' '  " + CRLF
    cQuery += "	AND T4V_LOCAL IN ('01','02','04','09','11','13') " + CRLF
    cQuery += "	AND T4V_PROD NOT IN  " + CRLF
    cQuery += "	( " + CRLF
    cQuery += "	SELECT HWB_PRODUT  " + CRLF 
    cQuery += "	FROM "+ RetSqlName("HWB") +" HWB, "  + CRLF
    cQuery += " "+RetSqlName("SB1") +" SB1 "  + CRLF
    cQuery += "	WHERE HWB_FILIAL='"+xFilial("HWB") +"'" + CRLF 
    cQuery += "	AND HWB_TICKET='"+_cTicket +"'" + CRLF 
    cQuery += "	AND HWB_PRODUT=B1_COD   " + CRLF
    cQuery += "	AND HWB.D_E_L_E_T_=' '  " + CRLF
    cQuery += "	AND SB1.D_E_L_E_T_=' '  " + CRLF
    cQuery += "	GROUP BY HWB_PRODUT " + CRLF
    cQuery += "	)  " + CRLF
    cQuery += "	GROUP BY T4V_FILIAL,T4V_PROD   " + CRLF
Endif
cQuery += "	) AS TRB   " + CRLF
cQuery += "	ORDER BY HWB_FILIAL,HWB_PRODUT,HWB_DATA " + CRLF

If !(Empty(cTmpAlias)) .And. (Select(cTmpAlias) > 0)
	(cTmpAlias)->(DbCloseArea())
EndIf

MpSysOpenQuery(cQuery, cTmpAlias)

_aStruQry	:= (cTmpAlias)->(dbStruct())
For _nElemQry := 1 To Len(_aStruQry)
	If _aStruQry[_nElemQry,2] <> "C"
		TCSetField(cTmpAlias,AllTrim(_aStruQry[_nElemQry,1]),_aStruQry[_nElemQry,2],_aStruQry[_nElemQry,3],_aStruQry[_nElemQry,4])
	EndIf
Next _nElemQry
			
While !(cTmpAlias)->(Eof())
      
      DbSelectArea(_cAliasHWB)
      If _cCodProd <> (cTmpAlias)->HWB_PRODUT
         // Posiciona nos cadastros para pegar dados
         // Cadastro de Produtos
         DbSelectArea("SB1")
         DbSetOrder(1)
         DbSeek(xFilial("SB1")+(cTmpAlias)->HWB_PRODUT,.F.)
        
         // Cadastro Grupo de Produtos
         DbSelectArea("SBM")
         DbSetOrder(1)
         DbSeek(xFilial("SBM")+SB1->B1_GRUPO,.F.)
        
        
        // Verifica os saldos de estoque Interno eExterno
        _aSaldEst := U_SalEstMrp(_cTicket,(cTmpAlias)->HWB_PRODUT)  // Retorno : Array com Saldo em Estoque e saldo em Terceiros
        
        // Seleciona Tabela Temporaria Para Gravar Dados
        DbSelectArea(_cAliasHWB)
      
         _cCodProd := (cTmpAlias)->HWB_PRODUT
         RecLock(_cAliasHWB,.T.)
           (_cAliasHWB)->HWB_FILIAL := (cTmpAlias)->HWB_FILIAL 
           (_cAliasHWB)->HWB_PRODUT := (cTmpAlias)->HWB_PRODUT
           (_cAliasHWB)->B1_DESC    := SB1->B1_DESC
           (_cAliasHWB)->B1_UM      := SB1->B1_UM
           (_cAliasHWB)->B1_TIPO    := SB1->B1_TIPO
           (_cAliasHWB)->X5_DESCRI  := TABELA("02",SB1->B1_TIPO,.F.)
           (_cAliasHWB)->B1_GRUPO   := SB1->B1_GRUPO
           (_cAliasHWB)->BM_DESC    := SBM->BM_DESC
           (_cAliasHWB)->COMPRADOR  := "  " // Preencher com regra espacifica de cada cliente
           (_cAliasHWB)->FORNECEDOR := "  " // Preencher com regra espacifica de cada cliente
           (_cAliasHWB)->B1_QE      := SB1->B1_QE 
           (_cAliasHWB)->B2_QATU    := _aSaldEst[01]
           (_cAliasHWB)->B2_QNPT    := _aSaldEst[02]
           (_cAliasHWB)->SLDWIP     := _aSaldEst[03]
           (_cAliasHWB)->SALEST     := (cTmpAlias)->HWB_QTSLES
           (_cAliasHWB)->ESTOQUE    := (cTmpAlias)->HWB_QTSLES
           
           If (cTmpAlias)->HWB_QTSLES == 0 .AND. _aSaldEst[01] > 0
                (_cAliasHWB)->SALEST     := _aSaldEst[01] 
                (_cAliasHWB)->ESTOQUE    := _aSaldEst[01] 
           Endif

        MsUnlock() 
      Endif
      //
      _aMovEntr := U_MovEntMrp(_cTicket,Alltrim((cTmpAlias)->HWB_PRODUT),STOD((cTmpAlias)->HWB_DATA))  // Retorno : Array com Saldo de solicitacçoes de compra,pedido de compra e saldo em terceiro
         // Gravação dos Campos de Periodo
      // _aPrefPer   := {  "A"      ,"B"        ,"C"           ,"D"     ,"E",     "F",                   "G",        "H"             ,"I"  } // Demanda, Entradas, Estoque,Necessidade,Comentario
      // _aTituPer   := {"Saida","Sol.Compra","Ped.Compra","Transito","Entrada","Saida Estrutura","Saldo Estoque","Necessidade","Comentario"}
       RecLock(_cAliasHWB,.F.)
        Replace &("A_"+(cTmpAlias)->HWB_DATA) WITH (cTmpAlias)->HWB_QTSAID 
        Replace &("B_"+(cTmpAlias)->HWB_DATA) WITH _aMovEntr[01] 
        Replace &("C_"+(cTmpAlias)->HWB_DATA) WITH _aMovEntr[02] 
        Replace &("D_"+(cTmpAlias)->HWB_DATA) WITH _aMovEntr[03] 
        Replace &("S_"+(cTmpAlias)->HWB_DATA) WITH _aMovEntr[04] 
        Replace &("E_"+(cTmpAlias)->HWB_DATA) WITH (cTmpAlias)->HWB_QTENTR
        Replace &("F_"+(cTmpAlias)->HWB_DATA) WITH (cTmpAlias)->HWB_QTSEST  //Saidas da estrutura
        Replace &("G_"+(cTmpAlias)->HWB_DATA) WITH (cTmpAlias)->HWB_QTSALD
        Replace &("H_"+(cTmpAlias)->HWB_DATA) WITH (cTmpAlias)->HWB_QTNECE
        //Atualização dos Campos de totais das demandas e entradas
        (_cAliasHWB)->DEMANDAS := (_cAliasHWB)->DEMANDAS + (cTmpAlias)->HWB_QTSAID + (cTmpAlias)->HWB_QTSEST
        (_cAliasHWB)->ENTRADAS := (_cAliasHWB)->ENTRADAS + (cTmpAlias)->HWB_QTENTR
        (_cAliasHWB)->BALANCE  := (_cAliasHWB)->ESTOQUE  + (_cAliasHWB)->ENTRADAS - (_cAliasHWB)->DEMANDAS 
       MsUnlock()
    (cTmpAlias)->(DbSkip())
Enddo
If !(Empty(cTmpAlias)) .And. (Select(cTmpAlias) > 0)
	(cTmpAlias)->(DbCloseArea())
EndIf

Return


///******
User Function SalEstMrp(_cTickCod,_cProdCod)

Local _aRet := {} // Saldo Estoque,Saldo Terceiro
Local cTmpSMV  := GetNextAlias() 
Local cTmpT4V  := GetNextAlias()
Local _nSalEst := 0
Local _nSalTer := 0
Local _nSalWip := 0

//  Criar Query Para Buscar Dados da Tabela de Documentos processados no MRP
cQuery := "	SELECT MV_PRODUT AS PRODUTO,SUBSTRING(MV_DOCUM,10,2) AS ARMAZEM " + CRLF 
cQuery += "	FROM "+ RetSqlName("SMV") +" SMV "  + CRLF 
cQuery += "	WHERE MV_FILIAL='"+xFilial("SMV") +"'" + CRLF 
cQuery += "	AND MV_TICKET='"+_cTickCOD +"'" + CRLF 
cQuery += "	AND MV_PRODUT='"+_cProdCod+"' " + CRLF 
cQuery += "	AND MV_TIPDOC = '6' " + CRLF // TIPO 6-> SALDOS EM ESTOQUE 
cQuery += "	AND SMV.D_E_L_E_T_=' ' " + CRLF
cQuery += "	GROUP BY MV_PRODUT,SUBSTRING(MV_DOCUM,10,2)" + CRLF 

If !(Empty(cTmpSMV)) .And. (Select(cTmpSMV) > 0)
	(cTmpSMV)->(DbCloseArea())
EndIf

MpSysOpenQuery(cQuery, cTmpSMV)
			

While !(cTmpSMV)->(Eof())
    // Criar Query Para Buscar Saldos de Estoque do Produto considerado MRP
    cQuery := " SELECT T4V_PROD,SUM(T4V_QTD-T4V_QTNP)  AS SALEST,SUM(T4V_QNPT) AS SALTER,SUM(T4V_QTNP) AS SALWIP " + CRLF 
    cQuery += "	FROM "+ RetSqlName("T4V") +" T4V "  + CRLF 
    cQuery += "	WHERE T4V_FILIAL='"+xFilial("T4V") +"'" + CRLF 
    cQuery += "	AND T4V_PROD  ='"+(cTmpSMV)->PRODUTO+"' " + CRLF
    cQuery += "	AND T4V_LOCAL ='"+(cTmpSMV)->ARMAZEM+"' " + CRLF
    cQuery += "	AND T4V.D_E_L_E_T_=' ' " + CRLF
    cQuery += "	GROUP BY T4V_PROD,T4V_LOCAL" + CRLF 
       
    If !(Empty(cTmpT4V)) .And. (Select(cTmpT4V) > 0)
         (cTmpT4V)->(DbCloseArea())
    EndIf

    MpSysOpenQuery(cQuery, cTmpT4V)
	
    TCSetField(cTmpT4V,"SALEST","N",14,4)
    TCSetField(cTmpT4V,"SALTER","N",14,4)
    TCSetField(cTmpT4V,"SALWIP","N",14,4)
    If !(cTmpT4V)->(Eof())
        _nSalEst := _nSalEst + (cTmpT4V)->SALEST
        _nSalTer := _nSalTER + (cTmpT4V)->SALTER
        _nSalWip := _nSalWip + (cTmpT4V)->SALWIP
    Endif
    // Fecha a Tabela Temporaria de Saldo em Estoque
    If !(Empty(cTmpT4V)) .And. (Select(cTmpT4V) > 0)
        (cTmpT4V)->(DbCloseArea())
    EndIf
    (cTmpSMV)->(DbSkip())
Enddo

// Fecha a tabela temporaria com dados do produto e armazem Considerado
If !(Empty(cTmpSMV)) .And. (Select(cTmpSMV) > 0)
	(cTmpSMV)->(DbCloseArea())
EndIf
_aRet := {_nSalEst,_nSalTer,_nSalWip}
Return _aRet



///******

User Function MovEntMrp(_cTickCod,_cProdCod,_dDataEnt)

Local _aRet := {} // Saldo Estoque,Saldo Terceiro
Local cTmpSMV  := GetNextAlias() 
Local cTmpHWC  := GetNextAlias() 

Local _nSalSol := 0
Local _nSalPed := 0
Local _nSalTran := 0
Local _nSalSub  := 0
Local _lTran    := .F.

//  Criar Query Para Buscar Dados da Tabela de Documentos processados no MRP
cQuery := "	SELECT MV_TIPDOC,MV_PRODUT,MV_DOCUM,MV_QUANT " + CRLF 
cQuery += "	FROM "+ RetSqlName("SMV") +" SMV "  + CRLF 
cQuery += "	WHERE MV_FILIAL='"+xFilial("SMV") +"'" + CRLF 
cQuery += "	AND MV_TICKET='"+_cTickCOD +"'" + CRLF 
cQuery += "	AND MV_PRODUT='"+_cProdCod+"' " + CRLF 
cQuery += "	AND MV_TIPDOC IN ('1','2','3') " + CRLF // TIPO 1 -> Ordem de Produção, TIPO 2-> Solicitações, Tipo 3 ->Pedidos de Compra 
cQuery += "	AND MV_DATAMRP ='"+DTOS(_dDataEnt)+"' " + CRLF // TIPO 2-> Solicitações, Tipo 3 ->Pedidos de Compra 
cQuery += "	AND SMV.D_E_L_E_T_=' ' " + CRLF

If !(Empty(cTmpSMV)) .And. (Select(cTmpSMV) > 0)
	(cTmpSMV)->(DbCloseArea())
EndIf

MpSysOpenQuery(cQuery, cTmpSMV)
TCSetField(cTmpSMV,"MV_QUANT","N",14,4)			
While !(cTmpSMV)->(Eof())
    
    If (cTmpSMV)->MV_TIPDOC =='1' // Ordem de Produção
        _nSalPed  := _nSalPed + (cTmpSMV)->MV_QUANT
    Endif
    If (cTmpSMV)->MV_TIPDOC =='2' // Slicitação de Compras
        _nSalSol  := _nSalSol + (cTmpSMV)->MV_QUANT
    Endif
    If (cTmpSMV)->MV_TIPDOC =='3' // Pedido de Compra
        _lTran := U_VerTran((cTmpSMV)->MV_PRODUT,(cTmpSMV)->MV_DOCUM)
        If _lTran
            _nSalTran  := _nSalTran + (cTmpSMV)->MV_QUANT
        Else
            _nSalPed  := _nSalPed + (cTmpSMV)->MV_QUANT
        Endif
    Endif
    (cTmpSMV)->(DbSkip())
Enddo

// Fecha a tabela temporaria com dados do produto e armazem Considerado
If !(Empty(cTmpSMV)) .And. (Select(cTmpSMV) > 0)
	(cTmpSMV)->(DbCloseArea())
EndIf


//  Criar Query Para Buscar Dados da Tabela de Detalhes do MRP
cQuery := "	SELECT HWC_DATA,SUM(HWC_QTSUBS) AS HWC_QTSUBS " + CRLF 
cQuery += "	FROM "+ RetSqlName("HWC") +" HWC "  + CRLF 
cQuery += "	WHERE HWC_FILIAL='"+xFilial("HWC") +"'" + CRLF 
cQuery += "	AND HWC_TICKET='"+_cTickCOD +"'" + CRLF 
cQuery += "	AND HWC_PRODUT='"+_cProdCod+"' " + CRLF 
cQuery += "	AND HWC_QTSUBS>0  " + CRLF // TIPO 1 -> Ordem de Produção, TIPO 2-> Solicitações, Tipo 3 ->Pedidos de Compra 
cQuery += "	AND HWC_DATA   ='"+DTOS(_dDataEnt)+"' " + CRLF // TIPO 2-> Solicitações, Tipo 3 ->Pedidos de Compra 
cQuery += "	AND HWC.D_E_L_E_T_=' ' " + CRLF
cQuery += "	GROUP BY HWC_DATA "  + CRLF // TIPO 2-> Solicitações, Tipo 3 ->Pedidos de Compra 


If !(Empty(cTmpHWC)) .And. (Select(cTmpHWC) > 0)
	(cTmpHWC)->(DbCloseArea())
EndIf

MpSysOpenQuery(cQuery, cTmpHWC)
TCSetField(cTmpHWC,"HWC_QTSUBS","N",14,4)			

While !(cTmpHWC)->(Eof())
    _nSalSub  := _nSalSub + (cTmpHWC)->HWC_QTSUBS
    (cTmpHWC)->(DbSkip())
Enddo

// Fecha a tabela temporaria com dados do produto e armazem Considerado
If !(Empty(cTmpHWC)) .And. (Select(cTmpHWC) > 0)
	(cTmpHWC)->(DbCloseArea())
EndIf

_aRet := {_nSalSol,_nSalPed,_nSaltran,_nSalSub}
Return _aRet

///******

User Function VerTran(_cProduto,_cDocumento)

Local _lTransito := .F.
Local _aAreaTRA:= GetArea()

/// Colocar a regra do cliente para identificar o transito

RestArea(_aAreaTRA)

Return _lTransito

///******

Static Function FGerExcel(_cArqExcel)

Local oFWMsExcel
Local oExcel
//Local cArquivo := GetTempPath()+"LISTA_CRITICA_TICKET_"+_cArqExcel+".xml"
Local cArquivo   := _cDir+"FIL_"+cFilAnt+"_LISTA_CRITICA_TKT_"+_cArqExcel
Local _cWorkLc   := "Lista Critica "
Local _cTableLC  := "Lista Critica MRP Ticket -> "+_cTicket

Local _aStruLC   := {}
Local _nElemLC   := 0
Local _cTypeCpo  := ''
Local _cNameCpo  := ''
Local _aDadosLC  := {}
Local _nElemDLC  := 0
Local _cContCpo  := ''
Local _cPicture  := "@E 999,999.99"
Local _cCorFunG  := "#FDF5E6" // Cor de Fundo Para Toda a Planilha
Local _cCorFonH  := "#000000" // Cor da Fonte Header da Coluna
Local _cCorFunH  := "#DCDCDC" // Cor de Fundo do Header da Coluna
Local _cCorFunC  := "#FDF5E6" // Cor de Fundo das Celulas de Mudança de Periodo
Local _nTamFonH  := 12        // Tamanho da Fonte do Header
Local _aCabLCIni := {}
Local _aCabLCMei := {}
Local _aCabLCFim := {}
Local _nQuebraPe := Round(Len(_aPrefPer) / 2 ,0)
Local _nElemPer  := 0 
Local _nPosTit   := 0
Local _aCorQueb  := {}
Local _aCorDif   := {}
Local _nContCol  := 0
Local _nElemCor  := 0
Local _nPosAnt   := 0

//https://www.flextool.com.br/tabela_cores.html  ( Site para escolha de cores)

If _lTipXml
    cArquivo := cArquivo +".xml" 
Else
    cArquivo := cArquivo +".xls"
Endif

// Objeto que irá gerar o conteúdo do Excel
If _lTipXml
   oFWMsExcel := FWMSExcelEx():New()
else
    oFWMsExcel := FWMSExcelXlsx():New()
Endif    
//********************************************************************************
//  I N I C I O  G E R A Ç Ã O  P L A N I L H A   LISTA DE CRITICOS
//*********************************************************************************
//Aba 01 - Lista de Itens Criticos
 oFWMsExcel:AddworkSheet(_cWorkLc) //Não utilizar número junto com sinal de menos. Ex.: 1-
 //Criando a Tabela
 oFWMsExcel:AddTable(_cWorkLc,_cTableLC)
 // Array com os Titulos das Colunas fixa do Cabeçalho antes da inclusão das colunas variaves ( produtos e Periodos)
AADD(_aCabLCIni,{"HWB_FILIAL","Filial"})
AADD(_aCabLCIni,{"HWB_PRODUT","Produto"})
AADD(_aCabLCIni,{"B1_DESC","Descrição"})
AADD(_aCabLCIni,{"B1_UM","UM"})
AADD(_aCabLCIni,{"G1_GROPC","Grp.OPC"})
AADD(_aCabLCIni,{"B1_TIPO","Tipo"})
AADD(_aCabLCIni,{"X5_DESCRI","Desc Tipo"})
AADD(_aCabLCIni,{"B1_GRUPO","Grupo"})
AADD(_aCabLCIni,{"BM_DESC","Desc Grupo"})
AADD(_aCabLCIni,{"COMPRADOR","Comprador"})
AADD(_aCabLCIni,{"FORNECEDOR","Fornecedor"})

// Array com os Titulos das Colunas fixa do Cabeçalho entre as colunas Variavies de Produto e Periodos

AADD(_aCabLCMei,{"B1_QE"   ,"Qtde Embalagem"})
AADD(_aCabLCMei,{"SLDWIP"  ,"Est.WIP"})
AADD(_aCabLCMei,{"B2_QATU" ,"Est.Interno"})
AADD(_aCabLCMei,{"B2_QNPT" ,"Est.Terceiros"})
AADD(_aCabLCMei,{"SALEST"  ,"Saldo Estoque"})

// Array com os Titulos das Colunas fixa do Cabeçalho DEPOS da inclusão das colunas variaves ( produtos e Periodos)
AADD(_aCabLCFim,{"ESTOQUE","Estoque"})
AADD(_aCabLCFim,{"DEMANDAS","Demandas"})
AADD(_aCabLCFim,{"ENTRADAS","Entradas"})
AADD(_aCabLCFim,{"BALANCE","Balance"})


// Geração do Cabeçalho 
// Inclui Colunas Vazias 
For _nElemLC := 1 To (Len(_aCabLCIni)+Len(_aCabLCMei))
    _nContCol++
    oFWMsExcel:AddColumn(_cWorkLC,_cTableLc," ",1,1,.F.,_cPicture) //1 = Alinhamento Esquerdo, 1= General,.F.= Não Totaliza Coluna
Next _nElemLC

//Inclui cabeçalho com o Periodo

For _nElemLC := 1 To Len(_aPeriodos)
    For _nElemPer := 1 To Len(_aPrefPer)
        _nContCol++
        If _nElemPer == _nQuebraPe
            oFWMsExcel:AddColumn(_cWorkLC,_cTableLc,DTOC(STOD(_aPeriodos[_nElemLC])),1,1,.F.,_cPicture)
            AADD(_aCorQueb,_nContCol-_nElemPer)  // Array Para Gravar as Colunas que devem Possuir Cores Diferentes            
        Else
            oFWMsExcel:AddColumn(_cWorkLC,_cTableLc," ",1,1,.F.,_cPicture)
        Endif
    Next _nElemPer
Next _nElemC

// Grava Cores Diferente no periodo para facilitar a Visualização
For _nElemLC := 1 To Len(_aCorQueb)
    If _nElemLC == 1 .OR. (_aCorQueb[_nElemLC] - _nPosAnt) == Len(_aPrefPer) * 2
       For _nElemCor := 1 To Len(_aPrefPer)
           AADD(_aCorDif,_aCorQueb[_nElemLC]+_nElemCor)
       Next _nElemCor
       _nPosAnt := _aCorQueb[_nElemLC]
    Endif    
Next _nElemLc

// Inclui Colunas Vazias Finais após os periodos
For _nElemLC := 1 To Len(_aCabLCFim)
    If _nElemLc == 2
        // inclui coluna com o cabeçalho dos Totais (Entradas - Demandas)
        oFWMsExcel:AddColumn(_cWorkLC,_cTableLc,"TOTAL ",1,1,.F.,_cPicture)
    Else       
        oFWMsExcel:AddColumn(_cWorkLC,_cTableLc," ",1,1,.F.,_cPicture) //1 = Alinhamento Esquerdo, 1= General,.F.= Não Totaliza Coluna
    Endif
Next _nElemLC

// Geração das Linhas com a Descrição da Coluna
_aDadosLC:= {}
_aStruLC:= (_cAliasHWB)->(dbStruct())
For _nElemLC := 1 To Len(_aStruLC)
	_cNameCPO := AllTrim(_aStruLC[_nElemLC,01])
    If Substr(_cNameCpo,2,1) =="_" 
        _nPosTit := Ascan(_aPrefPer,Left(_cNameCpo,1))
        _cNameCpo:= _aTituPer[_nPosTit]
    ElseIf Left(_cNameCpo,1) =="_"
          _cNameCpo:= SubStr(_cNameCpo,2)
    Else
        _nPosTit := AScan(_aCabLCIni, {|x| x[1] == _cNameCpo } )
        If _nPosTit > 0
            _cNameCpo:= _aCabLCIni[_nPosTit][02]
        else
             _nPosTit := AScan( _aCabLCMei, {|x| x[1] == _cNameCpo } )
            If _nPosTit > 0
                _cNameCpo:= _aCabLCMei[_nPosTit][02]
            else
                  _nPosTit := AScan( _aCabLCFim, {|x| x[1] == _cNameCpo } )
                 If _nPosTit > 0
                    _cNameCpo:= _aCabLCFim[_nPosTit][02]
                 Endif
            Endif    
        Endif    
    Endif
    AADD(_aDadosLc,_cNameCpo)
Next _nElemLC

// Adicionando Dados Nas Colunas Criadas
If _lTipXML
    oFWMsExcel:SetCelBgColor(_cCorFunC)  //Cor de Fundo das colunas das mudanças de periodo ( amarelo)
    oFWMsExcel:AddRow(_cWorkLC,_cTableLc,_aDadosLC,_aCorDif)
Else
    oFWMsExcel:AddRow(_cWorkLC,_cTableLc,_aDadosLC)
Endif    

If _lTipXML
    // Alinhamento Horizontal e Vertical  do Titulo
    oFWMsExcel:SetTitleHAlign(1) 

    // Adicionando Cor Para todos os estilos da Planilha ( Geral)
    oFWMsExcel:SetBgGeneralColor(_cCorFunG) // Cor de fundo Fonte 

    //  Fonte do Header ( Periodos do Processamento do Ticket)
    oFWMsExcel:SetFrColorHeader(_cCorFonH)   // Cor da Fonte
    oFWMsExcel:SetBgColorHeader(_cCorFunH)   // cor de fundo
    oFWMsExcel:SetHeaderSizeFont(_nTamFonH)  // Tamanho da Fonte do Header
    // Formatação das cores quando houver mudança de periodos  

    oFWMsExcel:SetCelBgColor(_cCorFunC)  //Cor de Fundo das colunas das mudanças de periodo ( amarelo)

Endif
// Inclusão dos dados processados para geração do Excel
DbSelectArea(_cAliasHWB)
DbSetOrder(1)  // Sequencia
DbGoTop()
While !(_cAliasHWB)->(Eof())
    _aDadosLC:= {}
    _nElemDLC := 0
    For _nElemDLC := 1 To Len(_aStruLC)
        _cNameCPO := AllTrim(_aStruLC[_nElemDLC,01])
        _cContCpo := "(_cAliasHWB)->"+_cNameCPO
        _cContCpo := &_cContCpo
        AADD(_aDadosLC,_cContCpo)
    Next _nElemDLC
    If _lTipXML
        oFWMsExcel:AddRow(_cWorkLC,_cTableLc,_aDadosLC,_aCorDif)
    Else
        oFWMsExcel:AddRow(_cWorkLC,_cTableLc,_aDadosLC)
    Endif     
(_cAliasHWB)->(DbSkip())
EndDo
//********************************************************************************
//  FINAL  G E R A Ç Ã O  P L A N I L H A   LISTA DE CRITICOS
//*********************************************************************************

//Ativando o arquivo e gerando o xml OU Excel
oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(cArquivo)
oFWMsExcel:DeActivate()
If File(cArquivo)
    MsgInfo("Arquivo->"+cArquivo, "Processo Finalizado com Sucesso")
Else
    MsgStop("Verifique se Existe a Pasta ->"+_cDir, "Processo Finalizado com ERRO")
Endif    


//If ! _lTipXML
//    //Abrindo o excel e abrindo o arquivo xlsx
//    oExcel := MsExcel():New()           //Abre uma nova conexão com Excel
//    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
//    oExcel:SetVisible(.T.)              //Visualiza a planilha
//    oExcel:Destroy()                    //Encerra o processo do gerenciador de tarefas
//Endif     

Return


//// Funcao para retirar Caracteres especiais
Static Function ConvCod(_cCodConv)

Local _cCodNew  := ' '
Local _cString  := ' '
Local _nElemStr := 0 

For _nElemStr := 1 to Len(Alltrim(_cCodConv))
    _cString := SubStr(_cCodConv,_nElemStr,1)
    If !(_cString $ "-/")
       If _nElemStr == 1
          If _cString >="0" .AND. _cString <="9" 
            _cCodNew := "_"+_cString
          Else
            _cCodNew := _cString
          Endif  
       Else 
          _cCodNew := _cCodNew + _cString
       Endif
    Endif

Next _nElemStr

Return _cCodNew



//// Funcao para Pegar os armazens do Ticket
User Function VerArm(_cTickAr)

Local _cRet := ' '
Local cTmpTRA  := GetNextAlias() 
Local _aAreaTRA:= GetArea()
Local cQuery := ' '


cQuery := " SELECT CONVERT(VARCHAR(100), HW1_LISTA) AS ARMAZEM " + CRLF
cQuery += " FROM "+ RetSqlName("HW1") + CRLF
cQuery += " WHERE HW1_FILIAL='"+xFilial("HW1")+"'" + CRLF
cQuery += " AND HW1_TICKET ='"+_cTickAr+"'" + CRLF
cQuery += " AND HW1_PARAM ='warehouses'" + CRLF
cQuery += " AND D_E_L_E_T_= ' '" + CRLF

If !(Empty(cTmpTRA)) .And. (Select(cTmpTRA) > 0)
	(cTmpTRA)->(DbCloseArea())
EndIf

MpSysOpenQuery(cQuery, cTmpTRA)


If !(cTmpTRA)->(Eof())
    _cRet := !(cTmpTRA)->(ARMAZEM)
Endif

// Fecha a tabela temporaria com dados do produto e armazem Considerado
If !(Empty(cTmpTRA)) .And. (Select(cTmpTRA) > 0)
	(cTmpTRA)->(DbCloseArea())
EndIf
RestArea(_aAreaTRA)

Return _cRet

//// Funcao para Validar Demandas
Static Function VldDeman(_cProDem,_cTickDem)

Local _lRet := .F.
Local cTmpTRA  := GetNextAlias() 
Local _aAreaTRA:= GetArea()
Local cQuery := ' '

cQuery := " SELECT MV_TICKET " + CRLF
cQuery += " FROM "+ RetSqlName("SMV") + CRLF
cQuery += " WHERE MV_FILIAL='"+xFilial("SMV")+"'" + CRLF
cQuery += " AND MV_TICKET ='"+_cTickDem+"'" + CRLF
cQuery += " AND MV_PRODUT ='"+_cProDem+"'" + CRLF
cQuery += " AND MV_TIPDOC='5'"  + CRLF
cQuery += " AND D_E_L_E_T_= ' '" + CRLF

If !(Empty(cTmpTRA)) .And. (Select(cTmpTRA) > 0)
	(cTmpTRA)->(DbCloseArea())
EndIf

MpSysOpenQuery(cQuery, cTmpTRA)

If !(cTmpTRA)->(Eof())
    _lRet := .T.
Endif

// Fecha a tabela temporaria com dados do produto e armazem Considerado
If !(Empty(cTmpTRA)) .And. (Select(cTmpTRA) > 0)
	(cTmpTRA)->(DbCloseArea())
EndIf

RestArea(_aAreaTRA)

Return _lRet
