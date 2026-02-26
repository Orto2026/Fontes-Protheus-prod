#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMRPREL04   บAutor  ณEduardo Barbosa     บ Data ณ  22/08/22   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar Planilha Excel do Relat๓rio Ocorr๊ncias MRP MRP       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO ( PROCESSAMENTO MRP)	                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

User Function MRPRLOG(_lAuto,_cNumTick,_cDirArq)


//HW1 - Parโmetros utilizados no cแlculo do MRP
//HW3 - Processamento do MRP

Local _aRet := {" "}
Local _lRet := {}

Private _aPergs		:= {}
Private cTicket     := Space(6)      
Private _aTitCol    := {}
Private _oTableHWM  := ' '
Private _cAliasHWM  := ' '
Private _cNameHWM   := ' '

Private _oTableHWC  := ' '
Private _cAliasHWC  := ' '
Private _cNameHWMC  := ' '

Private _cDir       := " "

DEFAULT _lAuto      := .F.
DEFAULT _cNumTick   := " "
DEFAULT _cDirArq    := "C:\TEMP\ "


AADD(_aPergs, {1, "Ticket MRP       ", Space(TamSX3('HW3_TICKET')[01]), "", ".T.", "HW3", ".T.", 80,  .F.})

// Parametros da fun็ใo Parambox()
// -------------------------------
// 1 - < aParametros > - Vetor com as configura็๕es
// 2 - < cTitle >      - Tํtulo da janela
// 3 - < aRet >        - Vetor passador por referencia que cont้m o retorno dos parโmetros
// 4 - < bOk >         - Code block para validar o botใo Ok
// 5 - < aButtons >    - Vetor com mais bot๕es al้m dos bot๕es de Ok e Cancel
// 6 - < lCentered >   - Centralizar a janela
// 7 - < nPosX >       - Se nใo centralizar janela coordenada X para inํcio
// 8 - < nPosY >       - Se nใo centralizar janela coordenada Y para inํcio
// 9 - < oDlgWizard >  - Utiliza o objeto da janela ativa
//10 - < cLoad >       - Nome do perfil se caso for carregar
//11 - < lCanSave >    - Salvar os dados informados nos parโmetros por perfil
//12 - < lUserSave >   - Configura็ใo por usuแrio

// Caso alguns parโmetros para a fun็ใo nใo seja passada serแ considerado DEFAULT as seguintes abaixo:
// DEFAULT bOk   := {|| (.T.)}
// DEFAULT aButtons := {}
// DEFAULT lCentered := .T.
// DEFAULT nPosX  := 0
// DEFAULT nPosY  := 0
// DEFAULT cLoad     := ProcName(1)
// DEFAULT lCanSave := .T.
// DEFAULT lUserSave := .F.

//_lRet := PARAMBOX(_aPergs, "Informe os parโmetros", _aRet)
If ! _lAuto
    _lRet := PARAMBOX(_aPergs, "Informe os parโmetros", _aRet, , , , , , , ,.T.,.T.)
Else
  _lRet := .T.
  _aRet[01] := _cNumTick
  _cDir := _cDirArq
Endif
If _lRet
    _cTicket := _aRet[01]
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
    
    If ValType(_oTableHWM) == "O"
    	_oTableHWM:Delete()
    	_oTableHWM := Nil
    EndIf
    
    If ValType(_oTableHWC) == "O"
    	_oTableHWC:Delete()
    	_oTableHWC := Nil
    EndIf


Endif

Return


//********************************************
Static Function CriaTRB()                     
//*******************************************


Private _cTMPHWB	:= GetNextAlias()    // HWB - Resultados do MRP - Sumarizados;
Private _aFieldsHWB := {}

Private _cTMPHWM	:= GetNextAlias()    // HWM - LOG de Eventos MRP;
Private _aFieldsHWM := {}

Private _cTMPHWC	:= GetNextAlias()    // HWB - Resultados do MRP - Sumarizados;
Private _aFieldHWC := {}



//********************************************************************************
//  I N I C I O  G E R A ว ร O  T E M P O R A R I O   LOG DE EVENTOS 
//*********************************************************************************

// Campos da Tabela de Log de Eventos MRP
_aFieldsHWM := {}
Aadd(_aFieldsHWM, {"HWM_FILIAL" ,"C" ,TamSX3('HWM_FILIAL')[01], 0})
Aadd(_aFieldsHWM, {"HWM_PRODUT" ,"C" ,TamSX3('B1_COD')[01], 0})
Aadd(_aFieldsHWM, {"B1_DESC"    ,"C" ,TamSX3('B1_DESC')[01], 0})
Aadd(_aFieldsHWM, {"B1_TIPO"    ,"C" ,TamSX3('B1_TIPO')[01], 0})
Aadd(_aFieldsHWM, {"X5_DESCRI"  ,"C" ,50, 0})
Aadd(_aFieldsHWM, {"B1_GRUPO"   ,"C" ,TamSX3('B1_GRUPO')[01], 0})
Aadd(_aFieldsHWM, {"BM_DESC"    ,"C" ,TamSX3('BM_DESC')[01], 0})
Aadd(_aFieldsHWM, {"COMPRADOR"  ,"C" ,50, 0})
Aadd(_aFieldsHWM, {"FORNECEDOR" ,"C" ,50, 0})
Aadd(_aFieldsHWM, {"HWM_EVENTO" ,"C" ,TamSX3('HWM_EVENTO')[01], 0})
Aadd(_aFieldsHWM, {"HWM_LOGMRP" ,"C" ,TamSX3('HWM_LOGMRP')[01], 0})
Aadd(_aFieldsHWM, {"HWM_ALIAS"  ,"C" ,30, 0})
Aadd(_aFieldsHWM, {"HWM_DOC"    ,"C" ,TamSX3('HWM_DOC')[01], 0})
Aadd(_aFieldsHWM, {"HWM_ITEM"   ,"C" ,TamSX3('HWM_ITEM')[01], 0})
Aadd(_aFieldsHWM, {"HWM_PRDORI" ,"C" ,TamSX3('HWM_PRDORI')[01], 0})

// Cria็ใo da Tabela de Dados Sumarizados
_oTableHWM := FWTemporaryTable():New(_cTmpHWM, _aFieldsHWM)

// Cria็ใo de Indices de Dados Sumarizados
_oTableHWM:AddIndex("01", {"HWM_PRODUT"} )
_oTableHWM:Create()
	
//Pega o alias das tabelas temporแrias de Dados Sumarizados
_cAliasHWM := _oTableHWM:GetAlias()

// Pega o Nome Real das Tabelas de Dados Sumarizados
_cNameHWM  :=_oTableHWM:GetRealName()

//********************************************************************************
// F I N A L   G E R A ว ร O  T E M P O R A R I O    LOG DE EVENTOS
//*********************************************************************************


//********************************************************************************
//  I N I C I O  G E R A ว ร O  T E M P O R A R I O   SUBSTITUIวีES 
//*********************************************************************************

// Campos da Tabela de Log de Eventos MRP
_aFieldHWC := {}
Aadd(_aFieldHWC, {"HWC_FILIAL" ,"C" ,TamSX3('HWC_FILIAL')[01], 0})
Aadd(_aFieldHWC, {"B1_COD"     ,"C" ,TamSX3('B1_COD')[01], 0})
Aadd(_aFieldHWC, {"B1_DESC"    ,"C" ,TamSX3('B1_DESC')[01], 0})
Aadd(_aFieldHWC, {"HWC_PRODUT" ,"C" ,TamSX3('B1_COD')[01], 0})
Aadd(_aFieldHWC, {"DESCALT"    ,"C" ,TamSX3('B1_DESC')[01], 0})
Aadd(_aFieldHWC, {"B1_TIPO"    ,"C" ,TamSX3('B1_TIPO')[01], 0})
Aadd(_aFieldHWC, {"X5_DESCRI"  ,"C" ,50, 0})
Aadd(_aFieldHWC, {"B1_GRUPO"   ,"C" ,TamSX3('B1_GRUPO')[01], 0})
Aadd(_aFieldHWC, {"BM_DESC"    ,"C" ,TamSX3('BM_DESC')[01], 0})
Aadd(_aFieldHWC, {"HWC_DATA"   ,"D" ,TamSX3('HWC_DATA')[01], 0})
Aadd(_aFieldHWC, {"HWC_QTSUBS" ,"N" ,TamSX3('HWC_QTSUBS')[01], 4})

// Cria็ใo da Tabela de Dados Sumarizados
_oTableHWC := FWTemporaryTable():New(_cTmpHWC, _aFieldHWC)

// Cria็ใo de Indices de Dados Sumarizados
_oTableHWC:AddIndex("01", {"B1_COD"} )
_oTableHWC:Create()
	
//Pega o alias das tabelas temporแrias de Dados Sumarizados
_cAliasHWC := _oTableHWC:GetAlias()

// Pega o Nome Real das Tabelas de Dados Sumarizados
_cNameHWC  :=_oTableHWC:GetRealName()

//********************************************************************************
// F I N A L   G E R A ว ร O  T E M P O R A R I O    LISTA DE CRITICOS
//*********************************************************************************


Return


//********************************************
Static Function GravaTRB()                     
//*******************************************

// Grava็ใo do Log de Eventos
GrvLogEv()
GrvSubs()


Return

//********************************************
Static Function GrvLogEv()
//*******************************************

Local cQuery     := ' '
Local cTmpAlias  := GetNextAlias()
Local _aStruQry  := ' '
Local _nElemQry  := 0
Local _aTabDoc   := {   "T4Q"  ,   "T4T"    ,    "T4U"   ,  "T4S"   ,   "T4J"     ,    "T4V"   }
Local _aTipDoc   := {"Demandas","Sol Compra","Ped Compra",'Empenhos',"Ordens Prod" ," Estoque" } 
Local _cDescDoc  := " "
Local _nPosDoc   := 0

//  // Criar Query Para Buscar Produtos e Periodos
cQuery := "	SELECT HWM.* "
cQuery += "	FROM "+ RetSqlName("HWM") +" HWM, "  + CRLF
cQuery += " "+RetSqlName("SB1") +" SB1 "  + CRLF
cQuery += "	WHERE HWM_FILIAL='"+xFilial("HWM") +"'" + CRLF 
cQuery += "	AND HWM_TICKET='"+_cTicket +"'" + CRLF 
cQuery += "	AND HWM_PRODUT=B1_COD " + CRLF  
//cQuery += "	AND B1_TIPO  = '01' " + CRLF    /// ATENCAO COLOCAR EM PARAMETROS 
//cQuery += "	AND HWM_PRODUT IN('20B048-0','14B059-1','11B027-1','25B064-1') " + CRLF  // NIVEL DAS MATERIAS PRIMAS
cQuery += "	AND HWM.D_E_L_E_T_=' ' " + CRLF
cQuery += "	AND SB1.D_E_L_E_T_=' ' " + CRLF
cQuery += "	ORDER BY HWM_PRODUT " + CRLF 

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
      
    DbSelectArea(_cAliasHWM)
    // Posiciona nos cadastros para pegar dados
    // Cadastro de Produtos
    DbSelectArea("SB1")
    DbSetOrder(1)
    DbSeek(xFilial("SB1")+(cTmpAlias)->HWM_PRODUT,.F.)
    // Cadastro Grupo de Produtos
    DbSelectArea("SBM")
    DbSetOrder(1)
    DbSeek(xFilial("SBM")+SB1->B1_GRUPO,.F.)
    // Cadastro de Compradores
    DbSelectArea("SY1")
    DbSetOrder(1)
    DbSeek(xFilial("SY1")+SB1->B1_XCOMPR,.F.)

    // Cadastro de Fornecedores
    DbSelectArea("SA2")
    DbSetOrder(1)
    DbSeek(xFilial("SA2")+SB1->B1_PROC,.F.)

    // Seleciona Tabela Temporaria Para Gravar Dados
    DbSelectArea(_cAliasHWM)
    _nPosDoc := aScan(_aTabDoc,Alltrim((cTmpAlias)->HWM_ALIAS))
    If _nPosDoc > 0
        _cDescDoc := _aTipDoc[_nPosDoc]
    Else
        _cDescDoc := (cTmpAlias)->HWM_ALIAS
    Endif

    RecLock(_cAliasHWM,.T.)
        (_cAliasHWM)->HWM_FILIAL := (cTmpAlias)->HWM_FILIAL 
        (_cAliasHWM)->HWM_PRODUT := (cTmpAlias)->HWM_PRODUT
        (_cAliasHWM)->B1_DESC    := SB1->B1_DESC
        (_cAliasHWM)->B1_TIPO    := SB1->B1_TIPO
        (_cAliasHWM)->X5_DESCRI  := TABELA("02",SB1->B1_TIPO,.F.)
        (_cAliasHWM)->B1_GRUPO   := SB1->B1_GRUPO
        (_cAliasHWM)->BM_DESC    := SBM->BM_DESC
        (_cAliasHWM)->COMPRADOR  := SB1->B1_XCOMPR + '-'+SY1->Y1_NOME
        (_cAliasHWM)->FORNECEDOR := SB1->B1_PROC  + '-' + Alltrim(SA2->A2_NOME)
        (_cAliasHWM)->HWM_EVENTO := (cTmpAlias)->HWM_EVENTO
        (_cAliasHWM)->HWM_LOGMRP := (cTmpAlias)->HWM_LOGMRP
        (_cAliasHWM)->HWM_ALIAS  := _cDescDoc
        (_cAliasHWM)->HWM_DOC    := (cTmpAlias)->HWM_DOC
        (_cAliasHWM)->HWM_ITEM   := (cTmpAlias)->HWM_ITEM
        (_cAliasHWM)->HWM_PRDORI := (cTmpAlias)->HWM_PRDORI
    MsUnlock() 
    (cTmpAlias)->(DbSkip())
Enddo
If !(Empty(cTmpAlias)) .And. (Select(cTmpAlias) > 0)
	(cTmpAlias)->(DbCloseArea())
EndIf

Return



//********************************************
Static Function GrvSubs()
//*******************************************

Local cQuery     := ' '
Local cTmpAlias  := GetNextAlias()
Local _nTamSB1   := TamSX3('B1_COD')[01]
Local _cCodPrin := " "


//  Criar Query Para Buscar Dados da Tabela de Detalhes do MRP
cQuery := "	SELECT HWC_FILIAL,HWC_CHVSUB,HWC_PRODUT,B1_DESC AS DESCALT,HWC_DATA,SUM(HWC_QTSUBS) AS HWC_QTSUBS " + CRLF 
cQuery += "	FROM "+ RetSqlName("HWC") +" HWC , "+ RetSqlName("SB1") +" SB1 "  + CRLF 
cQuery += "	WHERE HWC_FILIAL='"+xFilial("HWC") +"'" + CRLF 
cQuery += "	AND HWC_PRODUT=B1_COD " + CRLF 
cQuery += "	AND HWC_TICKET='"+_cTicket +"'" + CRLF 
cQuery += "	AND HWC_QTSUBS < 0  " + CRLF // TIPO 1 -> Ordem de Produ็ใo, TIPO 2-> Solicita็๕es, Tipo 3 ->Pedidos de Compra 
cQuery += "	AND HWC.D_E_L_E_T_=' ' " + CRLF
cQuery += "	AND SB1.D_E_L_E_T_=' ' " + CRLF
cQuery += "	GROUP BY HWC_FILIAL,HWC_CHVSUB,HWC_PRODUT,B1_DESC,HWC_DATA "  + CRLF // TIPO 2-> Solicita็๕es, Tipo 3 ->Pedidos de Compra 


If !(Empty(cTmpAlias)) .And. (Select(cTmpAlias) > 0)
	(cTmpAlias)->(DbCloseArea())
EndIf

MpSysOpenQuery(cQuery, cTmpAlias)


TCSetField(cTmpAlias,"HWC_DATA","D",8,0)
TCSetField(cTmpAlias,"HWC_QTSUBS","N",14,4)



While !(cTmpAlias)->(Eof())
      
    DbSelectArea(_cAliasHWC)
    _cCodPrin := Left(Alltrim((cTmpAlias)->HWC_CHVSUB),_nTamSB1)
    
    // Posiciona nos cadastros para pegar dados
    // Cadastro de Produtos
    DbSelectArea("SB1")
    DbSetOrder(1)
    DbSeek(xFilial("SB1")+_cCodPrin,.F.)
    // Cadastro Grupo de Produtos
    DbSelectArea("SBM")
    DbSetOrder(1)
    DbSeek(xFilial("SBM")+SB1->B1_GRUPO,.F.)
    
    // Seleciona Tabela Temporaria Para Gravar Dados
    
    RecLock(_cAliasHWC,.T.)
        (_cAliasHWC)->HWC_FILIAL := (cTmpAlias)->HWC_FILIAL 
        (_cAliasHWC)->B1_COD     := (cTmpAlias)->HWC_CHVSUB
        (_cAliasHWC)->B1_DESC    := SB1->B1_DESC
        (_cAliasHWC)->HWC_PRODUT := (cTmpAlias)->HWC_PRODUT
        (_cAliasHWC)->DESCALT    := (cTmpAlias)->DESCALT
        (_cAliasHWC)->B1_TIPO    := SB1->B1_TIPO
        (_cAliasHWC)->X5_DESCRI  := TABELA("02",SB1->B1_TIPO,.F.)
        (_cAliasHWC)->B1_GRUPO   := SB1->B1_GRUPO
        (_cAliasHWC)->BM_DESC    := SBM->BM_DESC
        (_cAliasHWC)->HWC_DATA   := (cTmpAlias)->HWC_DATA
        (_cAliasHWC)->HWC_QTSUBS := (cTmpAlias)->HWC_QTSUBS * (-1)
    MsUnlock() 
    (cTmpAlias)->(DbSkip())
Enddo
If !(Empty(cTmpAlias)) .And. (Select(cTmpAlias) > 0)
	(cTmpAlias)->(DbCloseArea())
EndIf

Return


Static Function FGerExcel(_cArqExcel)

Local oFWMsExcel
Local oExcel
Local cArquivo   := GetTempPath()+"OCORRENCIAS_MRP_TICKET_"+_cArqExcel+".xml"
Local _cWorkLV   := "Log de Eventos "
Local _cTableLV  := "Log de Eventos MRP Ticket -> "+_cTicket

Local _cWorkSB   := "Substituicoes "
Local _cTableSB  := "Substituicoes MRP Ticket -> "+_cTicket

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
Local _cCorFunC  := "#FDF5E6" // Cor de Fundo das Celulas de Mudan็a de Periodo
Local _nTamFonH  := 12        // Tamanho da Fonte do Header
Local _aCabLCIni := {}
Local _aCabLCMei := {}
Local _aCabLCFim := {}
//Local _nQuebraPe := Round(Len(_aPrefPer) / 2 ,0)
Local _nElemPer  := 0 
Local _nPosTit   := 0
Local _aCorQueb  := {}
Local _aCorDif   := {}
Local _nContCol  := 0
Local _nElemCor  := 0
Local _nPosAnt   := 0
//https://www.flextool.com.br/tabela_cores.html  ( Site para escolha de cores)


If !Empty(_cDir)
   cArquivo   := _cDir+"OCORRENCIAS_MRP_TICKET_"+_cArqExcel+".xml"
Endif

// Objeto que irแ gerar o conte๚do do Excel
oFWMsExcel := FWMSExcelEx():New()


//********************************************************************************
//  I N I C I O  G E R A ว ร O  P L A N I L H A   LOG DE EVENTOS
//*********************************************************************************
//Aba 01 - Log de Eventos
 oFWMsExcel:AddworkSheet(_cWorkLV) //Nใo utilizar n๚mero junto com sinal de menos. Ex.: 1-
 //Criando a Tabela
 oFWMsExcel:AddTable(_cWorkLV,_cTableLV)  
 // Array com os Titulos das Colunas fixa do Cabe็alho antes da inclusใo das colunas variaves ( produtos e Periodos)
_aCabLCIni := {}
AADD(_aCabLCIni,{"HWM_FILIAL","Filial"})
AADD(_aCabLCIni,{"HWM_PRODUT","Produto"})
AADD(_aCabLCIni,{"B1_DESC","Descri็ใo"})
AADD(_aCabLCIni,{"B1_TIPO","Tipo"})
AADD(_aCabLCIni,{"X5_DESCRI","Desc Tipo"})
AADD(_aCabLCIni,{"B1_GRUPO","Grupo"})
AADD(_aCabLCIni,{"BM_DESC","Desc Grupo"})
AADD(_aCabLCIni,{"COMPRADOR","Comprador"})
AADD(_aCabLCIni,{"FORNECEDOR","Fornecedor"})
AADD(_aCabLCIni,{"HWM_EVENTO","Evento"})
AADD(_aCabLCIni,{"HWM_LOGMRP","Ocorrencia"})
AADD(_aCabLCIni,{"HWM_ALIAS","Tip Documento"})
AADD(_aCabLCIni,{"HWM_DOC","Documento"})
AADD(_aCabLCIni,{"HWM_ITEM","Item"})
AADD(_aCabLCIni,{"HWM_PRDORI","Prod Original"})
 
// Gera็ใo do Cabe็alho 
// Inclui Colunas Vazias 
_aDadosLC:= {}
For _nElemLC := 1 To (Len(_aCabLCIni))
    oFWMsExcel:AddColumn(_cWorkLV,_cTableLV,_aCabLCIni[_nElemLc,02],1,1,.F.,_cPicture) //1 = Alinhamento Esquerdo, 1= General,.F.= Nใo Totaliza Coluna
    AADD(_aDadosLC," ") // Array a ser utilizado se nao possuir dados na tabela de eventos
Next _nElemLC
// Gera็ใo das Linhas com a Descri็ใo da Coluna

// Alinhamento Horizontal e Vertical  do Titulo
oFWMsExcel:SetTitleHAlign(1) 

// Adicionando Cor Para todos os estilos da Planilha ( Geral)
oFWMsExcel:SetBgGeneralColor(_cCorFunG) // Cor de fundo Fonte 

//  Fonte do Header ( Periodos do Processamento do Ticket)
oFWMsExcel:SetFrColorHeader(_cCorFonH)   // Cor da Fonte
oFWMsExcel:SetBgColorHeader(_cCorFunH)   // cor de fundo
oFWMsExcel:SetHeaderSizeFont(_nTamFonH)  // Tamanho da Fonte do Header
// Formata็ใo das cores quando houver mudan็a de periodos  

oFWMsExcel:SetCelBgColor(_cCorFunC)  //Cor de Fundo das colunas das mudan็as de periodo ( amarelo)

// Inclusใo dos dados processados para gera็ใo do Excel
_aStruLC:= (_cAliasHWM)->(dbStruct())
DbSelectArea(_cAliasHWM)
DbSetOrder(1)  // Sequencia
DbGoTop()
If !(_cAliasHWM)->(Eof())
    While !(_cAliasHWM)->(Eof())
       _aDadosLC:= {}
      _nElemDLC := 0
      For _nElemDLC := 1 To Len(_aStruLC)
           _cNameCPO := AllTrim(_aStruLC[_nElemDLC,01])
           _cContCpo := "(_cAliasHWM)->"+_cNameCPO
           _cContCpo := &_cContCpo
           AADD(_aDadosLC,_cContCpo)
      Next _nElemDLC
     oFWMsExcel:AddRow(_cWorkLV,_cTableLV,_aDadosLC)
     (_cAliasHWM)->(DbSkip())
    EndDo
Else
    oFWMsExcel:AddRow(_cWorkLV,_cTableLV,_aDadosLC)
Endif    
//********************************************************************************
//  F I N A L  G E R A ว ร O  P L A N I L H A   LOG DE EVENTOS MRP
//*********************************************************************************

//********************************************************************************
//  I N I C I O  G E R A ว ร O  P L A N I L H A   SUBSTITUICOES
//*********************************************************************************
//Aba 02 - Substitui็๕es
 oFWMsExcel:AddworkSheet(_cWorkSB) //Nใo utilizar n๚mero junto com sinal de menos. Ex.: 1-
 //Criando a Tabela
 oFWMsExcel:AddTable(_cWorkSB,_cTableSB)  
 // Array com os Titulos das Colunas fixa do Cabe็alho antes da inclusใo das colunas variaves ( produtos e Periodos)
_aCabLCIni := {}
AADD(_aCabLCIni,{"HWC_FILIAL","Filial"})
AADD(_aCabLCIni,{"B1_COD","Principal"})
AADD(_aCabLCIni,{"B1_DESC","Descri็ใo"})
AADD(_aCabLCIni,{"HWC_PRODUT","Alternativo"})
AADD(_aCabLCIni,{"DESCALT","Desc Alternativo"})
AADD(_aCabLCIni,{"B1_TIPO","Tipo"})
AADD(_aCabLCIni,{"X5_DESCRI","Desc Tipo"})
AADD(_aCabLCIni,{"B1_GRUPO","Grupo"})
AADD(_aCabLCIni,{"BM_DESC","Desc Grupo"})
AADD(_aCabLCIni,{"HWC_DATA","Tip Documento"})
AADD(_aCabLCIni,{"HWC_QTSUBS","Qtde Sustituida"})
 
// Gera็ใo do Cabe็alho 
// Inclui Colunas Vazias 
_aDadosLC:= {}
For _nElemLC := 1 To (Len(_aCabLCIni))
    oFWMsExcel:AddColumn(_cWorkSB,_cTableSB,_aCabLCIni[_nElemLc,02],1,1,.F.,_cPicture) //1 = Alinhamento Esquerdo, 1= General,.F.= Nใo Totaliza Coluna
    AADD(_aDadosLC," ") // Array a ser utilizado se nao possuir dados na tabela de eventos
Next _nElemLC
// Gera็ใo das Linhas com a Descri็ใo da Coluna

// Alinhamento Horizontal e Vertical  do Titulo
oFWMsExcel:SetTitleHAlign(1) 

// Adicionando Cor Para todos os estilos da Planilha ( Geral)
oFWMsExcel:SetBgGeneralColor(_cCorFunG) // Cor de fundo Fonte 

//  Fonte do Header ( Periodos do Processamento do Ticket)
oFWMsExcel:SetFrColorHeader(_cCorFonH)   // Cor da Fonte
oFWMsExcel:SetBgColorHeader(_cCorFunH)   // cor de fundo
oFWMsExcel:SetHeaderSizeFont(_nTamFonH)  // Tamanho da Fonte do Header
// Formata็ใo das cores quando houver mudan็a de periodos  

oFWMsExcel:SetCelBgColor(_cCorFunC)  //Cor de Fundo das colunas das mudan็as de periodo ( amarelo)

// Inclusใo dos dados processados para gera็ใo do Excel
_aStruLC:= (_cAliasHWC)->(dbStruct())
DbSelectArea(_cAliasHWC)
DbSetOrder(1)  // Sequencia
DbGoTop()
If !(_cAliasHWC)->(Eof())
    While !(_cAliasHWC)->(Eof())
       _aDadosLC:= {}
      _nElemDLC := 0
      For _nElemDLC := 1 To Len(_aStruLC)
           _cNameCPO := AllTrim(_aStruLC[_nElemDLC,01])
           _cContCpo := "(_cAliasHWC)->"+_cNameCPO
           _cContCpo := &_cContCpo
           AADD(_aDadosLC,_cContCpo)
      Next _nElemDLC
     oFWMsExcel:AddRow(_cWorkSB,_cTableSB,_aDadosLC)
     (_cAliasHWC)->(DbSkip())
    EndDo
Else
    oFWMsExcel:AddRow(_cWorkSB,_cTableSB,_aDadosLC)
Endif    
//********************************************************************************
//  F I N A L  G E R A ว ร O  P L A N I L H A   LOG DE EVENTOS MRP
//*********************************************************************************

//Ativando o arquivo e gerando o xml
oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(cArquivo)
         
//Abrindo o excel e abrindo o arquivo xml
If !Empty(_cDir)
    oExcel := MsExcel():New()           //Abre uma nova conexใo com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)              //Visualiza a planilha
    oExcel:Destroy()                    //Encerra o processo do gerenciador de tarefas
Endif     
Return
