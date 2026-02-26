#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    PACKLT01		 ºAutor  ³SAMUEL MIRNDA   º Data ³ 12/08/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±            Relatorio PACKLIST Tabela SC9				                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User function RELPKLIST()
Local oReport
Local cAlias := GetNextAlias()
Private cPerg := "PACKLIST"

ValidPerg()

Pergunte(cPerg,.F.)

oReport := RptStruct(cAlias)

oReport:PrintDialog()
Return()

Static Function Rprint(oReport,cAlias)

Local oSecao1   := oReport:Section(1)

Local nIdioma   := ""
If MV_PAR05=1
    nIdioma := '%SB1.B1_DESC AS DESCROCAO%'
EndIf
If MV_PAR05=2
    nIdioma := '%SB1.B1_XDMCI AS DESCROCAO%'
EndIf
If MV_PAR05=3
    nIdioma := '%SB1.B1_XDMCE AS DESCROCAO%'
EndIf

oSecao1:BeginQuery()
    BeginSql alias cAlias

        COLUMN VALIDADE AS DATE         
        SELECT
        SC9.C9_PEDIDO AS PEDIDO,
        SC9.C9_ITEM AS ITEMPD,
        SC9.C9_QTDLIB AS QTDE,
        SC9.C9_PRODUTO AS PRODUTO,
        SC9.C9_LOTECTL AS LOTE,
        SC9.C9_DTVALID AS VALIDADE,
        %Exp:nIdioma%       
        FROM %Table:SC9%  SC9 
        INNER JOIN %Table:SB1% SB1 ON SB1.B1_COD = SC9.C9_PRODUTO AND SB1.D_E_L_E_T_='' 
        WHERE
        SC9.C9_PEDIDO >=%Exp:MV_PAR01% AND
        SC9.C9_PEDIDO <= %Exp:MV_PAR02% AND 
        SC9.C9_CLIENTE >= %Exp:MV_PAR03% AND 
        SC9.C9_CLIENTE <= %Exp:MV_PAR04% AND
        SC9.D_E_L_E_T_='' 
        ORDER BY 2 

    EndSql
MemoWrite("\Querys\RELPKLIST.sql",GetLastQuery()[2])
oSecao1:EndQuery()
oReport:setMeter((cAlias)->(RecCount()))
oSecao1:Print()

Return()

Static Function RptStruct(cAlias)
Local cTitulo := "RELATORIO PACKLIST  "
Local cHelp   := "Relatorio de separação Packlist!"
Local oReport
Local oSection1

//Instanciando a classe Trepost
oReport := TReport():New('PACKLIST',cTitulo,cPerg,{|oReport|Rprint(oReport,cAlias)},cHelp)

//Seção do Relatório
oSection1 := TRSection():New(oReport,"Produtos",{cAlias})
    
    TRCell():New(oSection1,"QTDE"      ,cAlias,"QUATIDADE" ,/**/,04)
    TRCell():New(oSection1,"PRODUTO"   ,cAlias,"CODIGO"    ,/**/,15)
    TRCell():New(oSection1,"DESCROCAO" ,cAlias,"DESCROCAO" ,/**/,70)  
    TRCell():New(oSection1,"LOTE"      ,cAlias,"LOTE"      ,/**/,20)
    TRCell():New(oSection1,"VALIDADE"  ,cAlias,"VENCIMENTO",/**/,15)   
    //New ( < oParent>,   < cName>,    [ cAlias],[ cTitle], [ cPicture], [ nSize], [ lPixel], [ bBlock] ) --> TRCell
Return(oReport)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³VALIDPERG ºAutor  ³SAMUEL MIRNDA     	º Data ³ 12/08/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±              Criar as Perguntas caso elas não existam.                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs   := {}
Local i,j
Local nTamSX1 := Len(SX1->X1_GRUPO)
//Local aHelp 	:= {}
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("PACKLIST",nTamSX1)

Aadd(aRegs,{cPerg,"01","Pedido De......?","Pedido De......?","Pedido De......?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Pedido Até.....?","Pedido Até.....?","Pedido Até.....?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Cliente De.....?","Cliente De.....?","Cliente De.....?","mv_ch3","C",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Cliente Até....?","Cliente Até....?","Cliente Até....?","mv_ch4","C",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Idioma.........?","Idioma.........?","Idioma.........?","mv_ch5","N",01,0,1,"C","","mv_par05","Portugues","Portugues","Portugues","","","Ingles","Ingles","Ingles","","","Espanhol","Espanhol","Espanhol","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()               
	Endif
Next i

dbSelectArea(_sAlias)

Return()
  

