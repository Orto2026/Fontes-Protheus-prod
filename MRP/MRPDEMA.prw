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
±±ºDesc.     ³ Gerar Planilha Excel do Relatório das Demandas             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO ( PROCESSAMENTO MRP)	                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß  
*/

User Function MRPDEMA(_lAuto,_cNumTick,_cDirArq)

Private _aPergs		:= {}
Private _aRet       := {" "," "," "," "," "," ",}
Private cTicket     := Space(6)      
Private _aTitCol    := {}
Private _aPeriodos  := {}

Private _oTableHWB  := ' '
Private _cAliasHWB  := ' '
Private _cNameHWB   := ' '

Private _oTableSMV  := ' '
Private _cAliasSMV  := ' '
Private _cNameSMV   := ' '

Private _cDir       := " "

DEFAULT _lAuto      := .F.
DEFAULT _cNumTick   := " "
DEFAULT _cDirArq    := "C:\TEMP\ "



AADD(_aPergs, {1, "Ticket MRP       ", Space(TamSX3('HW3_TICKET')[01]), "", ".T.", "HW3", ".T.", 80,  .F.})


If ! _lAuto
    _lRet := PARAMBOX(_aPergs, "Informe os parâmetros", _aRet, , , , , , , ,.T.,.T.)
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
        MsAguarde({|| FGerExDem(_cTicket)},OemtoAnsi("Gerando Planilha Excel Demandas"))
    Else
        FGerExDem(_cTicket)
    Endif
    // Apaga Tabelas temporarias 
    If ValType(_oTableHWB) == "O"
    	_oTableHWB:Delete()
    	_oTableHWB := Nil
    EndIf

  
Endif

Return


//********************************************
Static Function CriaTRB()                     
//*******************************************


Local _nElemPer := 0
Local _cCpoPer  := ' '
Local cQuery    := ' '
Local cTmpAlias := GetNextAlias()

Private _cTMPHWB	:= GetNextAlias()    // HWB - Resultados do MRP - Sumarizados;
Private _aFieldsHWB := {}

Private _cTMPSMV	:= GetNextAlias()    // SMV - Documentos Considerados Pelo MRP;
Private _aFieldsSMV := {}


//********************************************************************************
//  I N I C I O  G E R A Ç Ã O  T E M P O R A R I O    DEMANDAS SUMARIZADAS
//*********************************************************************************

//  // Criar Query Para Periodos
cQuery := "	SELECT HWB_DATA AS CAMPO FROM "+ RetSqlName("HWB")  + CRLF 
cQuery += "	WHERE HWB_FILIAL='"+xFilial("HWB") +"'" + CRLF 
cQuery += "	AND HWB_TICKET='"+_cTicket +"'" + CRLF 
cQuery += "	AND HWB_NIVEL='01' " + CRLF    // NIVEL DA ORIGEM DA DEMANDA 
cQuery += "	AND D_E_L_E_T_=' ' " + CRLF 
cQuery += "	GROUP BY HWB_DATA " + CRLF 

If !(Empty(cTmpAlias)) .And. (Select(cTmpAlias) > 0)
	(cTmpAlias)->(DbCloseArea())
EndIf

MpSysOpenQuery(cQuery, cTmpAlias)

While !(cTmpAlias)->(Eof())
    AADD(_aPeriodos,(cTmpAlias)->CAMPO)
    (cTmpAlias)->(DbSkip())
Enddo
If !(Empty(cTmpAlias)) .And. (Select(cTmpAlias) > 0)
	(cTmpAlias)->(DbCloseArea())
EndIf

// Campos da Tabela de Dados Sumarizados
Aadd(_aFieldsHWB, {"HWB_FILIAL" ,"C" ,TamSX3('HWB_FILIAL')[01], 0})
Aadd(_aFieldsHWB, {"HWB_PRODUT" ,"C" ,TamSX3('B1_COD')[01], 0})
Aadd(_aFieldsHWB, {"B1_DESC"   ,"C" ,TamSX3('B1_DESC')[01], 0})
Aadd(_aFieldsHWB, {"B1_TIPO"   ,"C" ,TamSX3('B1_TIPO')[01], 0})
Aadd(_aFieldsHWB, {"X5_DESCRI" ,"C" ,50, 0})
Aadd(_aFieldsHWB, {"B1_GRUPO"  ,"C" ,TamSX3('B1_GRUPO')[01], 0})
Aadd(_aFieldsHWB, {"BM_DESC"   ,"C" ,TamSX3('BM_DESC')[01], 0})


// Criação dos Campos de Periodo
 For _nElemPer := 1 To Len(_aPeriodos)
     _cCpoPer := "A_"+Alltrim(_aPeriodos[_nElemPer])  //D20220501, E20220501,S20220501,C20220501 
     Aadd(_aFieldsHWB, {_cCpoPer,"N",14, 4})  
Next _nElemPer

Aadd(_aFieldsHWB, {"TOTSAIDA"   ,"N" ,TamSX3('B2_QATU')[01], 4}) // TOTAL DEMANDAS

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
// F I N A L   G E R A Ç Ã O  T E M P O R A R I O    DEMANDAS SUMARIZADAS
//*********************************************************************************

//********************************************************************************
//  I N I C I O  G E R A Ç Ã O  T E M P O R A R I O   DETALHAMENTO DAS DEMANDAS
//*********************************************************************************


Aadd(_aFieldsSMV, {"MV_FILIAL"  ,"C" ,TamSX3('MV_FILIAL')[01], 0})
Aadd(_aFieldsSMV, {"MV_PRODUT"  ,"C" ,TamSX3('B1_COD')[01], 0})
Aadd(_aFieldsSMV, {"B1_DESC"    ,"C" ,TamSX3('B1_DESC')[01], 0})
Aadd(_aFieldsSMV, {"B1_TIPO"    ,"C" ,TamSX3('B1_TIPO')[01], 0})
Aadd(_aFieldsSMV, {"X5_DESCRI"  ,"C" ,50, 0})
Aadd(_aFieldsSMV, {"B1_GRUPO"   ,"C" ,TamSX3('B1_GRUPO')[01], 0})
Aadd(_aFieldsSMV, {"BM_DESC"    ,"C" ,TamSX3('BM_DESC')[01], 0})
Aadd(_aFieldsSMV, {"MV_DOCUM"   ,"C" ,TamSX3('MV_DOCUM')[01], 0})
Aadd(_aFieldsSMV, {"MV_DATAMRP" ,"D" ,8, 0})
Aadd(_aFieldsSMV, {"MV_QUANT"   ,"N" ,TamSX3('MV_QUANT')[01], 0})
Aadd(_aFieldsSMV, {"T4J_ORIGEM" ,"C" ,40, 0})
Aadd(_aFieldsSMV, {"T4J_DOC"    ,"C" ,TamSX3('T4J_DOC')[01], 0})
Aadd(_aFieldsSMV, {"T4J_DATA"   ,"D" ,8, 0})
Aadd(_aFieldsSMV, {"T4J_CODE"   ,"C" ,TamSX3('T4J_CODE')[01], 0})

// Criação da Tabela do Detalhamento das Demandas

_oTableSMV := FWTemporaryTable():New(_cTmpSMV, _aFieldsSMV)

// Criação de Indices de Dados Sumarizados
_oTableSMV:AddIndex("01", {"MV_PRODUT"} )
_oTableSMV:Create()
	
//Pega o alias das tabelas temporárias de Dados Sumarizados
_cAliasSMV := _oTableSMV:GetAlias()

// Pega o Nome Real das Tabelas de Dados Sumarizados
_cNameSMV  :=_oTableSMV:GetRealName()

//********************************************************************************
//  F I N A L   G E R A Ç Ã O  T E M P O R A R I O   DETALHAMENTO DAS DEMANDAS
//********************************************************************************


Return


//********************************************
Static Function GravaTRB()                     
//*******************************************
// Gravação do Temporario da Lista Critica
Private _aProdDem := {}  // Array utilizados nas funcoes executadas abaixo
GrvDetDem()
GrvDemanda()

Return

//********************************************
Static Function GrvDemanda()
//*******************************************

Local cQuery     := ' '
Local cTmpAlias  := GetNextAlias()
Local _aStruQry  := ' '
Local _nElemQry  := 0
Local _cCodProd  :=' '
Local _lDem      := .F.

//  // Criar Query Para Buscar Produtos e Periodos
cQuery := "	SELECT HWB.HWB_FILIAL,HWB.HWB_PRODUT,HWB_DATA,SUM(HWB.HWB_QTSAID) AS HWB_QTSAID  "
cQuery += "	FROM "+ RetSqlName("HWB") +" HWB, "  + CRLF
cQuery += " "+RetSqlName("SB1") +" SB1 "  + CRLF
cQuery += "	WHERE HWB_FILIAL='"+xFilial("HWB") +"'" + CRLF 
cQuery += "	AND HWB_TICKET='"+_cTicket +"'" + CRLF 
cQuery += "	AND HWB_NIVEL='01' " + CRLF  // NIVEL DAS MATERIAS PRIMAS
cQuery += "	AND HWB_PRODUT=B1_COD " + CRLF  
cQuery += "	AND HWB.D_E_L_E_T_=' ' " + CRLF
cQuery += "	AND SB1.D_E_L_E_T_=' ' " + CRLF
cQuery += "	GROUP BY  HWB.HWB_FILIAL,HWB.HWB_PRODUT,HWB_DATA  " + CRLF
cQuery += "	ORDER BY HWB_PRODUT,HWB_DATA" + CRLF 

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
    // Valida se Produto Esta sendo considerado como Demanda
    _lDem := VldDeman(Alltrim((cTmpAlias)->HWB_PRODUT),_cTicket)
    If _lDem
        If ASCAN(_aProdDem,Alltrim((cTmpAlias)->HWB_PRODUT)) > 0
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

                // Cadastro de Fornecedores
                DbSelectArea("SA2")
                DbSetOrder(1)
                DbSeek(xFilial("SA2")+SB1->B1_PROC,.F.)
                
                // Seleciona Tabela Temporaria Para Gravar Dados
                DbSelectArea(_cAliasHWB)
            
                _cCodProd := (cTmpAlias)->HWB_PRODUT
                RecLock(_cAliasHWB,.T.)
                (_cAliasHWB)->HWB_FILIAL := (cTmpAlias)->HWB_FILIAL 
                (_cAliasHWB)->HWB_PRODUT := (cTmpAlias)->HWB_PRODUT
                (_cAliasHWB)->B1_DESC    := SB1->B1_DESC
                (_cAliasHWB)->B1_TIPO    := SB1->B1_TIPO
                (_cAliasHWB)->X5_DESCRI  := TABELA("02",SB1->B1_TIPO,.F.)
                (_cAliasHWB)->B1_GRUPO   := SB1->B1_GRUPO
                (_cAliasHWB)->BM_DESC    := SBM->BM_DESC
                MsUnlock() 
            Endif
            //
            RecLock(_cAliasHWB,.F.)
                Replace &("A_"+(cTmpAlias)->HWB_DATA) WITH (cTmpAlias)->HWB_QTSAID 
                //Atualização dos Campos de totais das demandas e entradas
                (_cAliasHWB)->TOTSAIDA := (_cAliasHWB)->TOTSAIDA + (cTmpAlias)->HWB_QTSAID 
            MsUnlock()
        Endif
    Endif
    (cTmpAlias)->(DbSkip())
Enddo
If !(Empty(cTmpAlias)) .And. (Select(cTmpAlias) > 0)
	(cTmpAlias)->(DbCloseArea())
EndIf

Return

//********************************************
Static Function GrvDetDem()
//*******************************************

Local cQuery     := ' '
Local cTmpAlias  := GetNextAlias()

//  // Criar Query Para Buscar Produtos e Periodos
cQuery := "	SELECT  "  + CRLF
cQuery += "	    MV_FILIAL, "  + CRLF
cQuery += "		MV_PRODUT, "  + CRLF
cQuery += "		MV_DATAMRP, "  + CRLF
cQuery += "		T4J_DATA, "  + CRLF
cQuery += "		MV_DOCUM, "  + CRLF
cQuery += "		MV_QUANT, "  + CRLF
cQuery += "		CASE "  + CRLF
cQuery += "			WHEN T4J_ORIGEM ='1' THEN 'Plano Mestre'  "  + CRLF 
cQuery += "			WHEN T4J_ORIGEM ='2' THEN 'Previsao Vendas'  "  + CRLF
cQuery += "			WHEN T4J_ORIGEM ='3' THEN 'Pedido de Vendas'  "  + CRLF
cQuery += "			WHEN T4J_ORIGEM ='4' THEN 'Empenho Projetos'  "  + CRLF
cQuery += "			WHEN T4J_ORIGEM ='5' THEN 'Arquivo'  "  + CRLF
cQuery += "			WHEN T4J_ORIGEM ='9' THEN 'Manual'  "  + CRLF
cQuery += "		ELSE ' ' "  + CRLF
cQuery += "		END AS T4J_ORIGEM, "  + CRLF
cQuery += "		T4J_DOC, "  + CRLF
cQuery += "		T4J_CODE  "  + CRLF
cQuery += "	FROM "+ RetSqlName("SMV") +" SMV "  + CRLF
cQuery += "	LEFT JOIN "+RetSqlName("T4J")+ " T4J ON ( "  + CRLF 
cQuery += "	    MV_FILIAL=T4J_FILIAL "  + CRLF
cQuery += "	    AND MV_PRODUT=T4J_PROD "  + CRLF
cQuery += "	    AND MV_DOCUM=T4J_IDREG "  + CRLF
cQuery += "	    AND MV_TICKET=T4J_NRMRP "  + CRLF
cQuery += "	    AND T4J.D_E_L_E_T_=' ' ) "  + CRLF
cQuery += "	WHERE SMV.D_E_L_E_T_=' ' "  + CRLF
cQuery += "	    AND MV_TICKET ='"+_cTicket +"'" + CRLF 
cQuery += "	    AND MV_TIPDOC='5' "  + CRLF
cQuery += "	ORDER BY MV_FILIAL,MV_PRODUT,MV_DATAMRP  "  + CRLF

If !(Empty(cTmpAlias)) .And. (Select(cTmpAlias) > 0)
	(cTmpAlias)->(DbCloseArea())
EndIf

MpSysOpenQuery(cQuery, cTmpAlias)

TCSetField(cTmpAlias,"MV_DATAMRP","D",8,0)
TCSetField(cTmpAlias,"T4J_DATA","D",8,0)
TCSetField(cTmpAlias,"MV_QUANT","N",14,2)


While !(cTmpAlias)->(Eof())
      
      DbSelectArea(_cAliasSMV)
      // Posiciona nos cadastros para pegar dados

      // Cadastro de Produtos
      DbSelectArea("SB1")
      DbSetOrder(1)
      DbSeek(xFilial("SB1")+(cTmpAlias)->MV_PRODUT,.F.)

      // Cadastro Grupo de Produtos
      DbSelectArea("SBM")
      DbSetOrder(1)
      DbSeek(xFilial("SBM")+SB1->B1_GRUPO,.F.)
      
      // Seleciona Tabela Temporaria Para Gravar Dados
      DbSelectArea(_cAliasSMV)

        RecLock(_cAliasSMV,.T.)
           (_cAliasSMV)->MV_FILIAL := (cTmpAlias)->MV_FILIAL 
           (_cAliasSMV)->MV_PRODUT := (cTmpAlias)->MV_PRODUT
           (_cAliasSMV)->B1_DESC    := SB1->B1_DESC
           (_cAliasSMV)->B1_TIPO    := SB1->B1_TIPO
           (_cAliasSMV)->X5_DESCRI  := TABELA("02",SB1->B1_TIPO,.F.)
           (_cAliasSMV)->B1_GRUPO   := SB1->B1_GRUPO
           (_cAliasSMV)->BM_DESC    := SBM->BM_DESC
           (_cAliasSMV)->MV_DOCUM   := (cTmpAlias)->MV_DOCUM  
           (_cAliasSMV)->MV_DATAMRP := (cTmpAlias)->MV_DATAMRP
           (_cAliasSMV)->MV_QUANT   := (cTmpAlias)->MV_QUANT
           (_cAliasSMV)->T4J_ORIGEM := (cTmpAlias)->T4J_ORIGEM
           (_cAliasSMV)->T4J_DOC    := (cTmpAlias)->T4J_DOC
           (_cAliasSMV)->T4J_DATA   := (cTmpAlias)->T4J_DATA
           (_cAliasSMV)->T4J_CODE   := (cTmpAlias)->T4J_CODE
        MsUnlock() 
       MsUnlock()
     If ASCAN(_aProdDem,Alltrim((cTmpAlias)->MV_PRODUT)) == 0
        AADD(_aProdDem,Alltrim((cTmpAlias)->MV_PRODUT))
     Endif     
    (cTmpAlias)->(DbSkip())
Enddo
If !(Empty(cTmpAlias)) .And. (Select(cTmpAlias) > 0)
	(cTmpAlias)->(DbCloseArea())
EndIf

Return

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

If !(Empty(cTmpTRA)) .And. (Select(cTmpTRA) > 0)
	(cTmpTRA)->(DbCloseArea())
EndIf

RestArea(_aAreaTRA)

Return _lRet

///******

Static Function FGerExDem(_cArqExcel)
Local oFWMsExcel
Local oExcel
Local cArquivo   := GetTempPath()+"DEMANDAS_TICKET_"+_cArqExcel+".xml"
Local _cWorkLV   := "Demandas "
Local _cTableLV  := "Demandas MRP Ticket -> "+_cTicket

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
Local _aCabLCFim := {}
//Local _nQuebraPe := Round(Len(_aPrefPer) / 2 ,0)
//Local _nElemPer  := 0 
//Local _nPosTit   := 0
//Local _aCorQueb  := {}
//Local _aCorDif   := {}
//Local _nContCol  := 0
//Local _nElemCor  := 0
//Local _nPosAnt   := 0
//https://www.flextool.com.br/tabela_cores.html  ( Site para escolha de cores)

// Objeto que irá gerar o conteúdo do Excel
If !Empty(_cDir)
     cArquivo   :=_cDir+"DEMANDAS_TICKET_"+_cArqExcel+".xml"
Endif

oFWMsExcel := FWMSExcelEx():New()


//********************************************************************************
//  I N I C I O  G E R A Ç Ã O  P L A N I L H A   DEMANDAS SUMARIZADAS MRP
//*********************************************************************************
//Aba 02 - Log de Eventos
 oFWMsExcel:AddworkSheet(_cWorkLV) //Não utilizar número junto com sinal de menos. Ex.: 1-
 //Criando a Tabela
 oFWMsExcel:AddTable(_cWorkLV,_cTableLV)  
 // Array com os Titulos das Colunas fixa do Cabeçalho antes da inclusão das colunas variaves ( produtos e Periodos)
_aCabLCIni := {}
AADD(_aCabLCIni,{"HWB_FILIAL","Filial"})
AADD(_aCabLCIni,{"HWB_PRODUT","Produto"})
AADD(_aCabLCIni,{"B1_DESC","Descrição"})
AADD(_aCabLCIni,{"B1_TIPO","Tipo"})
AADD(_aCabLCIni,{"X5_DESCRI","Desc Tipo"})
AADD(_aCabLCIni,{"B1_GRUPO","Grupo"})
AADD(_aCabLCIni,{"BM_DESC","Desc Grupo"})

// Geração do Cabeçalho 
// Inclui Colunas Vazias 
_aDadosLC:={}
For _nElemLC := 1 To (Len(_aCabLCIni))
    oFWMsExcel:AddColumn(_cWorkLV,_cTableLV,_aCabLCIni[_nElemLc,02],1,1,.F.,_cPicture) //1 = Alinhamento Esquerdo, 1= General,.F.= Não Totaliza Coluna
    AADD(_aDadosLC," ")  // Inclui Colunas Vazias para quando nao existir dados no arquivo a er gerado
Next _nElemLC

//Inclui Colunas com os Periodo

For _nElemLC := 1 To Len(_aPeriodos)
    oFWMsExcel:AddColumn(_cWorkLV,_cTableLV,+DTOC(STOD(_aPeriodos[_nElemLC])),1,1,.F.,_cPicture)
    AADD(_aDadosLC," ")  // Inclui Colunas Vazias para quando nao existir dados no arquivo a er gerado
Next _nElemC

// Inclui Colunas Totalizadoras ao  dos periodos
AADD(_aCabLCFim,{"TOTSAIDA","Total"})

For _nElemLC := 1 To Len(_aCabLCFim)
     oFWMsExcel:AddColumn(_cWorkLV,_cTableLV,_aCabLCFim[_nElemLc,02],1,1,.F.,_cPicture)
    AADD(_aDadosLC," ")  // Inclui Colunas Vazias para quando nao existir dados no arquivo a er gerado
Next _nElemLC

// Geração das Linhas com a Descrição da Coluna

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

// Inclusão dos dados processados para geração do Excel
_aStruLC:= (_cAliasHWB)->(dbStruct())
DbSelectArea(_cAliasHWB)
DbSetOrder(1)  // Sequencia
DbGoTop()
If !(_cAliasHWB)->(Eof())
    While !(_cAliasHWB)->(Eof())
        _aDadosLC:= {}
        _nElemDLC := 0
        For _nElemDLC := 1 To Len(_aStruLC)
            _cNameCPO := AllTrim(_aStruLC[_nElemDLC,01])
            _cContCpo := "(_cAliasHWB)->"+_cNameCPO
            _cContCpo := &_cContCpo
            AADD(_aDadosLC,_cContCpo)
        Next _nElemDLC
        oFWMsExcel:AddRow(_cWorkLV,_cTableLV,_aDadosLC)
        (_cAliasHWB)->(DbSkip())
    EndDo
else
    oFWMsExcel:AddRow(_cWorkLV,_cTableLV,_aDadosLC)    
Endif
//********************************************************************************
//  F I N A L  G E R A Ç Ã O  P L A N I L H A   DEMANDAS SUMARIZADAS MRP
//*********************************************************************************

//********************************************************************************
//  I N I C I O  G E R A Ç Ã O  P L A N I L H A   DETALHAMENTO DAS DEMANDAS MRP 
//*********************************************************************************
//Aba 02 - Demandas Detalhadas MRP
_cWorkLV   := "Detalhe Demandas "
_cTableLV  := "Demandas Detalhadas MRP Ticket -> "+_cTicket

 oFWMsExcel:AddworkSheet(_cWorkLV) //Não utilizar número junto com sinal de menos. Ex.: 1-
 //Criando a Tabela
 oFWMsExcel:AddTable(_cWorkLV,_cTableLV)  
 // Array com os Titulos das Colunas fixa do Cabeçalho antes da inclusão das colunas variaves ( produtos e Periodos)
_aCabLCIni := {}

AADD(_aCabLCIni,{"MV_FILIAL","Filial"})
AADD(_aCabLCIni,{"MV_PRODUT","Produto"})
AADD(_aCabLCIni,{"B1_DESC","Descrição"})
AADD(_aCabLCIni,{"B1_TIPO","Tipo"})
AADD(_aCabLCIni,{"X5_DESCRI","Desc Tipo"})
AADD(_aCabLCIni,{"B1_GRUPO","Grupo"})
AADD(_aCabLCIni,{"BM_DESC","Desc Grupo"})
AADD(_aCabLCIni,{"MV_DOCUM","Documento MRP"})
AADD(_aCabLCIni,{"MV_DATAMRP","Data MRP"})
AADD(_aCabLCIni,{"MV_QUANT","Quantidade"})
AADD(_aCabLCIni,{"T4J_ORIGEM","Origem Demanda"})
AADD(_aCabLCIni,{"T4J_DOC","Documento Origem"})
AADD(_aCabLCIni,{"T4J_DATA","Data Demanda"})
AADD(_aCabLCIni,{"T4J_CODE","Codigo Demanda"})
       
// Geração do Cabeçalho 
// Inclui Colunas Vazias 
_aDadosLC:={}
For _nElemLC := 1 To (Len(_aCabLCIni))
    oFWMsExcel:AddColumn(_cWorkLV,_cTableLV,_aCabLCIni[_nElemLc,02],1,1,.F.,_cPicture) //1 = Alinhamento Esquerdo, 1= General,.F.= Não Totaliza Coluna
    AADD(_aDadosLC," ")  // Inclui Colunas Vazias para quando nao existir dados no arquivo a er gerado
Next _nElemLC

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

// Inclusão dos dados processados para geração do Excel
_aStruLC:= (_cAliasSMV)->(dbStruct())
DbSelectArea(_cAliasSMV)
DbSetOrder(1)  // Sequencia
DbGoTop()
If !(_cAliasSMV)->(Eof())
    While !(_cAliasSMV)->(Eof())
        _aDadosLC:= {}
        _nElemDLC := 0
        For _nElemDLC := 1 To Len(_aStruLC)
            _cNameCPO := AllTrim(_aStruLC[_nElemDLC,01])
            _cContCpo := "(_cAliasSMV)->"+_cNameCPO
            _cContCpo := &_cContCpo
            AADD(_aDadosLC,_cContCpo)
        Next _nElemDLC
        oFWMsExcel:AddRow(_cWorkLV,_cTableLV,_aDadosLC)
        (_cAliasSMV)->(DbSkip())
    EndDo
else
    oFWMsExcel:AddRow(_cWorkLV,_cTableLV,_aDadosLC)    
Endif
//********************************************************************************
//  F I N A L  G E R A Ç Ã O  P L A N I L H A   DETALHAMENTO DAS DEMANDAS SUMARIZADAS
//*********************************************************************************

//Ativando o arquivo e gerando o xml
oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(cArquivo)
         
//Abrindo o excel e abrindo o arquivo xml
If Empty(_cDir)
    oExcel := MsExcel():New()           //Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)              //Visualiza a planilha
    oExcel:Destroy()                    //Encerra o processo do gerenciador de tarefas
Endif

Return
