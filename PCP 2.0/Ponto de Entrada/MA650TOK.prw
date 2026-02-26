#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"  
#Include "Totvs.ch"

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Rotina    | MA650TOK   |Autor | Samuel Miranda    | Data | 08/08/2025  |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Descricao | Ponto de entrada para validação da Ordem de Produção       |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Uso       | Ortosintese Ind. e Com. Ltda                               |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

User Function MA650TOK

Local lRet 		:= .T.
Local _aArea  	:= GetArea()
Local _aAreaC2	:= SC2->(GetArea())
Local _aAreaB1	:= SB1->(GetArea())
Local cMsg 		:= ""
Local cVRoteiro :=""
Local nCodProd  := ""

_cOPC	    := M->C2_OPC
M->C2_XOPC  := _cOPC

If Inclui
	dbSelectArea("SC2")
	dbSetOrder(12)
		If dbSeek(xFilial("SC2")+M->C2_LOTECTL)
			Aviso("Atenção !","Lote informado já existe na base de dados. Verifique o Lote: "+M->C2_LOTECTL,{"Ok"})
			lRet := .F.
		EndIf
	//Por samuel Miranda dia 09/12/2021
	DbSelectArea("SB1")
	SB1->(dbSetOrder(1)) //B1_FILIAL + B1_COD
	If SB1->(DBSeek(xFilial("SB1")+Alltrim(M->C2_PRODUTO)) .AND. SB1->B1_XDESCEN ="1")
		Alert("Produto descontinudo","A T E N Ç Ã O")
		lRet := .F. 
	EndIf	
	//Inicio da verificação da validade do Roteiro Feito Por -> Samuel Miranda 08/08/2024
	nCodProd := Alltrim(M->C2_PRODUTO)
	cVRoteiro := NROTEIRO(nCodProd)
	If !Empty(cVRoteiro) 
		cMsg := '<b>Codigo   :</b>'+" "+cVRoteiro[1][1]
		cMsg += '<br>'
		cMsg += '<b>Validade :</b>'+" "+cVRoteiro[1][2]
		cMsg += '<br>'
		cMsg += '<b>Operação :</b>'+" "+cVRoteiro[1][3]
		cMsg += '<br>'
		cMsg += '<b>Recurso  :</b>'+" "+cVRoteiro[1][4]
		FWAlertError( cMsg, 'Processo Produtivo Vencido!')
		lRet := .F. 
	EndIF   
	//Fim da verificação da validade do Roteiro Feito Por -> Samuel Miranda 08/08/2024
EndIF

RestArea(_aArea)
RestArea(_aAreaC2)
RestArea(_aAreaB1)

Return(lRet)

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Rotina    | NROTEIRO   |Autor | Samuel Miranda    | Data | 08/08/2025  |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Descricao | Função para verificar a data de validade do Roteiro.       |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Uso       |   Ortosintese Ind. e Com. Ltda                             |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Retorna um Array com as informaçoes do Produto							|±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Static Function NROTEIRO(nCodProd)
Local cQryRot  := ""
Local cMsgRot  := {}
Local cCodPro  := nCodProd
Local dDataV   := dDataBase
//Monta a query sql.
cQryRot	:= "SELECT "+CHR(13)+CHR(10)
cQryRot	+= 	"SG2.G2_PRODUTO AS CODPRO, "+CHR(13)+CHR(10)
cQryRot	+= 	"SG2.G2_DTFIM AS DATAFIM, "+CHR(13)+CHR(10)
cQryRot	+= 	"CONVERT(VARCHAR, CONVERT(DATE,SG2.G2_DTFIM), 103) AS DTVALID,"+CHR(13)+CHR(10)
cQryRot	+= 	"SG2.G2_OPERAC AS OPERACAO, "+CHR(13)+CHR(10)
cQryRot	+= 	"SG2.G2_RECURSO  AS NRECURSO  "+CHR(13)+CHR(10)
cQryRot	+= 	"FROM  "+CHR(13)+CHR(10)
cQryRot	+= 	RetSqlName("SG2")+" SG2 "+CHR(13)+CHR(10)
cQryRot	+= 	"WHERE  "+CHR(13)+CHR(10)
cQryRot	+= 	"SG2.G2_PRODUTO='"+cCodPro+"'  "+CHR(13)+CHR(10)
cQryRot	+= 	"AND SG2.G2_DTFIM <>'' "+CHR(13)+CHR(10)
cQryRot	+= 	"AND D_E_L_E_T_='' ORDER BY 1 "+CHR(13)+CHR(10)
cQryRot := ChangeQuery(cQryRot)
DbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQryRot ), "NQRY" , .T. , .F. )

	DbSelectArea("NQRY")
	NQRY->(DbGoTop())
	//Percorrendo os dados da query
	While !(NQRY->(EoF()))
		iF dDataV >= ctod(NQRY->DTVALID)//dDaTaVenc < Alltrim(NQRY->DTVALID)
			//Adiciona os dados no array
			Aadd(cMsgRot,{Alltrim(NQRY->CODPRO),Alltrim(NQRY->DTVALID),Alltrim(NQRY->OPERACAO),Alltrim(	NQRY->NRECURSO)})
		EndIf
	    NQRY->(DbSkip())
	EndDo
	NQRY->(DbCloseArea())

Return(cMsgRot)
