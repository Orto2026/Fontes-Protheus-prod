#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"      

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    PACKLT01		 ºAutor  ³SAMUEL MIRNDA   º Data ³ 12/08/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±            Relatorio PACKLIST Tabela SC9				                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function PACKLT01()

Local cPerg	:= "PACKLIST"

Private cDrvArq  := ""
Private cQryPlan1:= "QRYPLAN1"

ValidPerg()


If !Pergunte(cPerg,.T.)
	Return()
EndIf

MsAguarde({|| MontaQry() },"Aguarde","Selecionando Dados...",.F.)

//Cria XML e abre EXCEL
MsAguarde({|| GeraXml() },"Aguarde","Transferindo dados para o EXCEL",.T.)

Return

Static Function MontaQry()

Local cQuery     := ""

cQuery := "SELECT" +CHR(13)+CHR(10)
cQuery +="C9_PEDIDO AS PEDIDO,"+CHR(13)+CHR(10)
cQuery +="C9_ITEM AS ITEMPD,"+CHR(13)+CHR(10)
cQuery +="C9_QTDLIB AS QTDE,"+CHR(13)+CHR(10)
cQuery +="C9_PRODUTO AS PRODUTO,"+CHR(13)+CHR(10)
cQuery +="C9_LOTECTL AS LOTE,"+CHR(13)+CHR(10)
cQuery +="C9_DTVALID AS VALIDADE,"+CHR(13)+CHR(10)
If mv_par02 = 1
	cQuery +="B1_DESC AS DESCRICAO"+CHR(13)+CHR(10)
Elseif mv_par02 = 2
	cQuery +="B1_XDMCI AS DESCRICAO"+CHR(13)+CHR(10)
Elseif mv_par02 = 3
	cQuery +="B1_XDMCE AS DESCRICAO"+CHR(13)+CHR(10)
EndIF
cQuery +="FROM"+CHR(13)+CHR(10)
cQuery += RetSqlName("SC9")+" SC9 "+CHR(13)+CHR(10)
cQuery += "INNER JOIN " +RetSqlName("SB1")+ " SB1 ON SB1.B1_COD = SC9.C9_PRODUTO AND SB1.D_E_L_E_T_='' " + CHR(13)+CHR(10)
cQuery +="WHERE"+CHR(13)+CHR(10)
cQuery +="SC9.C9_PEDIDO= '"+mv_par01+"' "+CHR(13)+CHR(10)
cQuery +="AND SC9.D_E_L_E_T_='' ORDER BY 2 "+CHR(13)+CHR(10)

MEMOWRITE( "PACKLIST01.SQL", cQuery )

dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery ), "QUERY" , .T. , .F. )

TCSetField("QUERY","VALIDADE","D",8,0)

Return()

Static Function GeraXml()

Local cArquivo   := "PACKLIST.xml"
Local cDirDocs   := MsDocPath()
Local oExcelApp  := Nil
Local cPath      := AllTrim(GetTempPath())
Local oExcel     := FWMSEXCEL():New()
Local cPlan1, cTab11

cPlan1 := "PACKLIST PEDIDO "+ QUERY->PEDIDO
cTab11 := cPlan1

oExcel:SetHeaderBold(.T.) 
oExcel:SetFrColorHeader("#363636")
oExcel:SetBgColorHeader("#EE9572")
oExcel:SetLineFrColor("#000000")
oExcel:Set2LineFrColor("#000000")
oExcel:SetLineBgColor("#FFFFFF")
oExcel:Set2LineBgColor("#FFFFFF")


/*
//Configuração das fontes
oFont1 := AppExcFont():NEW("Arial","16","#363636")    
oFont1:SetBold(.T.)                  
                      

//personalização das celulas              
oCell1:SetBorderTop(.T.)                                                                     
oCell2:SetAllBorders(.T.)      
oCell2:SetCellColor("#0000CD")                   
oCell3:SetFont( oFont1 )    

*/


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Sheet Compras          	                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oExcel:AddWorkSheet(cPlan1)
oExcel:AddTable(cPlan1,cTab11)

If Select("QUERY") > 0
				//cWorkSheet    ,cTable ,cColumm	   ,nAlign	,nFormat	,lTotal
	oExcel:AddColumn(cPlan1		,cTab11	,"Quatidade"	,1	,1	,.F.) //01
	oExcel:AddColumn(cPlan1		,cTab11	,"Referência"   ,1	,1	,.F.) //02
	oExcel:AddColumn(cPlan1		,cTab11	,"Descrição"  	,1	,1	,.F.) //03
	oExcel:AddColumn(cPlan1		,cTab11	,"Lote"		    ,1	,1	,.F.) //04
	oExcel:AddColumn(cPlan1		,cTab11	,"Vencimento"	,1	,1	,.F.) //05
EndIf

dbSelectArea("QUERY")
DbGoTop()
While !Eof()

	QUERY->(oExcel:AddRow(cPlan1,cTab11,{QUERY->QTDE,;
    QUERY->PRODUTO,;
    QUERY->DESCRICAO,;
    QUERY->LOTE,;
    QUERY->VALIDADE}))
	
	dbSkip()
EndDo
dbCloseArea()

If !Empty(oExcel:aWorkSheet)
	oExcel:Activate()
	oExcel:GetXMLFile(cDirDocs+"\"+cArquivo)
	
	CpyS2T(cDirDocs+"\"+cArquivo,cPath)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()
Else
	MsgAlert("Não existem dados a serem exibidos.")
EndIf

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³VALIDPERG ºAutor  ³SAMUEL MIRNDA     	º Data ³ 12/08/2020  º±±
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

Aadd(aRegs,{cPerg,"01","Pedido.....?","Pedido.....?","Pedido.....?","mv_ch1","C",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Idioma.....?","Idioma.....?","Idioma.....?","mv_ch2","N",01,0,1,"C","","mv_par02","Portugues","Portugues","Portugues","","","Ingles","Ingles","Ingles","","","Espanhol","Espanhol","Espanhol","","","","","","","","","","","","","","","","",""})

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
