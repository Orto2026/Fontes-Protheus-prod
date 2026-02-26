#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"  
#include 'parmtype.ch'
Static sModeloZebra  :="|S500-6|Z105S-6|Z160S-6|S300|S400|S500-8|Z105S-8|Z160S-8|Z140XI|S600|Z90XI|Z170XI|ZEBRA"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Rotina    | REST37A  |Autor  |SAMUEL MIRNDA       | Data |  22/04/2025 |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Descricao | Rotina de impressao de etiquetas de separação		      |±±
±±|          | de Pedidos. Via Spool                                      |±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±|Uso       | Especifico Ortosintese                                     |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function REST37A()
//Variaves
Local aPergs        := {}
Private cCodCliDe   := Space(TamSX3( 'A1_COD' )[01])
Private cCodCliAt   := StrTran(cCodCliDe,' ','Z') //
Private dDataDe     := FirstDate()
Private dDataAt     := LastDate(Date())
Private nOrdemDe    := Space(TamSX3( 'CB7_ORDSEP' )[01])
Private nOrdemAt    := StrTran(nOrdemDe,' ','Z') //
Private nNFDe       := Space(TamSX3( 'CB7_NOTA' )[01])
Private nNFAt       := StrTran(nNFDe,' ','Z') //
Private cSegto      := Space(30)
Private cLocImp     := Space(06) //Local de IMpressão
Private aCombo      := {"1=Reposicao","2=Caixas","3=Equipamentos","4=Exportacao","5=Diversos","6=Pecas Equip","7=Sob Medida " }
//DEFAULT lCanSave    := .T.
//DEFAULT lUserSave   := .T.
//Função pra criar as perguntas.
aadd(aPergs, {01, "Data De"            , dDataDe  , ""    , ".T.", ""   , ""   , 50, .F.})
aadd(aPergs, {01, "Data Até"           , dDataAt  , ""    , ".T.", ""   , ""   , 50, .F.})
aadd(aPergs, {01, "Cliente De"         , cCodCliDe, ""    , ".T.", "SA1", ""   , 50, .F.})
aadd(aPergs, {01, "Cliente Até"        , cCodCliAt, ""    , ".T.", "SA1", ""   , 50, .F.})
aadd(aPergs, {02, "Mercado"            , 01       , aCombo, 50   , ""   , .F.}) //"Tipo 2 - Escolha:",01,aCombo,50,"",.T.})                                  
aadd(aPergs, {01, "Número da Ordem De" , nOrdemDe , ""    , ".T.", "CB7", ""   , 50, .F.})
aadd(aPergs, {01, "Número da Ordem Até", nOrdemAt , ""    , ".T.", "CB7", ""   , 50, .F.})
aadd(aPergs, {01, "Nota Fiscal De."    , nNFDe    , ""    , ".T.", "CB7", ""   , 50, .F.})
aadd(aPergs, {01, "Nota Fiscal Até"    , nNFAt    , ""    , ".T.", "CB7", ""   , 50, .F.})
aadd(aPergs, {01, "Seguimento"         , cSegto   , ""    , ".T.", ""   , ".T.", 50, .F.})
aadd(aPergs, {01, "Local de Impressão" , cLocImp  , ""    , ".T.", "CB5", ""   , 50, .T.})

//If ParamBox(aPergs ,"Informe os parâmetros",aRet,,,,,,,,lCanSave,lUserSave,)
If ParamBox(aPergs, "Informe os parâmetros", , , , , , , , , .F., .F.)
	RptStatus({|lEnd| U_REST37AImp(@lEnd,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08,MV_PAR09,MV_PAR10,MV_PAR11)},"Imprimindo, aguarde...")
EndIf

Return()

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Rotina    | REST37AImp  | Samuel Miranda             Data | 11/04/2024 |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Descricao | Função 													|±±
//                  		            									|±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

User Function REST37AImp(lEnd,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08,MV_PAR09,MV_PAR10,MV_PAR11)

If ! CB5SetImp(alltrim(MV_PAR11),IsTelNet())
	IF ! IsTelNet()
		Alert('Codigo do tipo de impressao invalido')
	Else
		VTAlert('Codigo do tipo de impressao invalido')
	EndIf
	Return .f.
EndIF
//verificar se esta no telnet
If IsTelNet()
	VtMsg('Imprimindo')
EndIf
//Verificar o modelo da impressora
If Alltrim(CB5->CB5_MODELO)+'|' $ sModeloZebra
	cTipoCodBar	:= 'C'
Endif
	//Chama a fução padrão //Data De,Data Até,Cliente De,Cliente Até,Mercado,Número da Ordem De,Número da Ordem Atè,Nota Fiscal De,Nota Fiscal Até,Seguimento,Local de Impressão					
	ExecBlock("Img03A",,,{MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08,MV_PAR09,MV_PAR10,MV_PAR11})				
	//Fecha a conexão do msbprinter
	MSCBCLOSEPRINTER()
Return()


