#INCLUDE "Acda100.ch" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "DBTREE.CH"
#INCLUDE "PRTOPDEF.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Função  |ACD01ORTO  | Autor | Samuel Miranda      | Data | 05/003/2025 |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Descrição | Rotina customizada apartir do fonte padrão ACDA100 para    |±±
±±| geracao das ordens de separacao.					                  |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Uso |Modulo -> SIGAACD (Especifico Ortosintese)                        |±±
±±|@since 05/003/2025													  |±±
±±|@version 1.0 														  |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function ACD01ORTO()
Local aRotBack  := {}
Local cCondicao := ""
Local aNewFil   := {}
Local cFilSC9   := ".T."
Local cFilSD2   := ".T."
Local cFilSC2   := ".T."
//Local cSerie	:= ""

Local lRet      := .T.
Local aArea     := GetArea()
Local aAreaCB7  := CB7->(GetArea())

Local cGetMark  := Nil
Local cBrwAlias	:= Nil
Local cBrwCpMark:= Nil
Local cBrwDesc	:= Nil
Local oBrwMrk   := Nil

Local aLegend 	:= {}
Local aBrwButt	:= {}
Local bMark2	:= { ||}
Local bBrwLeg	:= { || oFWLegend:View() }
Local bBrwMark	:= { || a100Mark( oBrwMrk, 1, cGetMark, bMark2, cBrwAlias, cBrwCpMark ) }
Local bBrwMakAll:= { || FWMsgRun(, {|| a100Mark( oBrwMrk, 2, cGetMark, bMark2, cBrwAlias, cBrwCpMark ) }, STR0196, STR0197 ) }
Local bBrwGrava	:= { || ( ACDGRAVAR( cBrwAlias, Nil, Nil, cGetMark, Nil, Nil, oBrwMrk ), oBrwMrk:SetFilterDefault( cCondicao ) )  }

Private oFwLegend := NIl

Private nGroupLoc	:= 0
PRIVATE nOrigExp   	:= ""
PRIVATE cSeparador 	:= Space(6)	//variavel utilizada para armazenar o separador da pergunte AIA102, pois o mesmo estava sendo sobreposto por outra pergunte, ao precionar F12 na tela de geracao

//configuração das perguntas
STATIC aPerg100	:= {}

Aadd( aBrwButt, { STR0005	, bBrwGrava	, Nil, 1 } )
Aadd( aBrwButt, { STR0190	, bBrwMakAll, Nil, 1 } )
Aadd( aBrwButt, { STR0189	, bBrwLeg	, Nil, 1 } )

If !Pergunte("AIA101",.T.)
	Return
EndIf
nOrigExp := MV_PAR01
If nOrigExp <> 1
	FWAlertWarning( "Selecione a opção Pedido.", '	A T E N Ç Ã O' )
	Return
EndIf
AtivaF12(nOrigExp) // carrega os valores das perguntes relacionados a configuracoes
If	ExistBlock("ACD100FI")
	aNewFil := ExecBlock("ACD100FI",.F.,.F.,{nOrigExp})
	If	ValType(aNewFil) == "A"
		If	aNewFil[1] == 1
			cFilSC9 := aNewFil[2]
		ElseIf	aNewFil[1] == 2
			cFilSD2 := aNewFil[2]
		ElseIf	aNewFil[1] == 3
			cFilSC2 := aNewFil[2]
		EndIf
	EndIf
EndIf

aRotBack := aClone( aRotina )
aRotina  := {{STR0005,"ACDGRAVAR",0,1} } //"Gerar"
//--- P.E. utilizado para adicionar itens no Menu da MarkBrowse
If	ExistBlock("ACD100MNU")
	ExecBlock("ACD100MNU",.f.,.f.,{nOrigExp})
EndIf
If	nOrigExp == 1
	If  !( Pergunte("AIA102",.T.) )
		lRet := .F.
	Else
		Aadd(aPerg100,ACD100Perg("AIA102"))
		cSeparador := MV_PAR01
		nPreSep := MV_PAR10

		dbSelectArea("SC9")
		dbSetOrder(1)		

		cCondicao := 'C9_PEDIDO  >="'+mv_par02+'".And.C9_PEDIDO <="'+mv_par03+'".And.'
		cCondicao += 'C9_CLIENTE >="'+mv_par04+'".And.C9_CLIENTE<="'+mv_par06+'".And.'
		cCondicao += 'C9_LOJA    >="'+mv_par05+'".And.C9_LOJA   <="'+mv_par07+'".And.'
		cCondicao += 'DTOS(C9_DATALIB)>="'+DTOS(mv_par08)+'".And.DTOS(C9_DATALIB)<="'+DTOS(mv_par09)+'".And.'
		cCondicao += 'Empty(C9_ORDSEP) .And.'
		cCondicao += ' C9_FILIAL = xFilial("SC9") .And. '
		cCondicao += cFilSC9
		
		cBrwAlias	:= 'SC9' //_cAlias
		cBrwCpMark	:= 'C9_OK'
		bMark2		:= { || Empty( C9_BLEST + C9_BLCRED ) }
		cGetMark  	:= GetMark( .T., cBrwAlias, cBrwCpMark )
		cBrwDesc	:= OemToAnsi("Gerar Ordem de Separacao - Pedido de Venda - 1.0  - Ortosintese")//( STR0191 )

		Aadd( aLegend,{ "Empty( C9_BLEST + C9_BLCRED )"	, "ENABLE"		, STR0194 } )
		Aadd( aLegend,{ "!Empty( C9_BLEST + C9_BLCRED )", "BR_VERMELHO"	, STR0195 } )
		oFwLegend := a1002Leg( aLegend )
	EndIf
EndIf

If lRet
	oBrwMrk := FwMarkBrowse():New()      
	oBrwMrk:SetAlias( cBrwAlias ) 		  
	oBrwMrk:SetFieldMark( cBrwCpMark ) 
	oBrwMrk:SetDescription( cBrwDesc ) 
	oBrwMrk:SetFilterDefault( cCondicao )
	oBrwMrk:SetAllMark(bBrwMakAll)
	oBrwMrk:SetCustomMarkRec(bBrwMark)
	oBrwMrk:SetMark( cGetMark, cBrwAlias, cBrwCpMark )

	AEval( aLegend ,{ | x | oBrwMrk:AddLegend( x[ 1 ], x[ 2 ], x[ 3 ] ) } )
	AEval( aBrwButt,{ | x | oBrwMrk:AddButton( x[ 1 ], x[ 2 ], x[ 3 ], x[ 4 ] ) } )

	oBrwMrk:Activate()

	FreeObj( oBrwMrk )
	oBrwMrk := Nil
	aAreaCB7 := CB7->(GetArea())
EndIf

aRotina := aClone( aRotBack )
RestArea( aArea )
RestArea( aAreaCB7 )
Return( lRet )

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Função  |ACD100PERG | Autor | Samuel Miranda       | Data | 05/003/2025|±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Descrição | Guarda configuração do Pergunte utilizado				  |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function ACD100Perg(cPerg)
Local aRet		:= {}
Local nX		:= 0
Local nY		:= 0
Local oObj
Local dLibVers  := ACDVERSION()
Local aRetSX1	:= {}
Local aPergunt	:= {}

// se existe a classe FWSX1Util e o metodo GetAllFields não se encontra disponivel
// na versao da lib 20180615
If (dLibVers >= "20180820" ) 
	oObj := FWSX1Util():New()	
	
	// faz o tratamento buscando direto na tabela SX1
	// Caso gere issue na ferramenta SONARQUBE deve ser
	// classificado como falso positivo.
 else
	aRetSX1	:= SX1->(GetArea())
	
Endif

//Define quantidade de perguntas
If cPerg == "AIA106"
	If cPaisLoc == "BRA"
		nY := 9
	Else
		nY := 7
	EndIf
ElseIf cPerg == "AIA102"
	nY := 10
ElseIf cPerg == "AIA107"
	nY := 5
ElseIf cPerg == "AIA103"
	nY := 11
ElseIf cPerg == "AIA108"
	nY := 2
ElseIf cPerg == "AIA104"
	nY := 6
EndIf

Aadd(aRet,cPerg)
Aadd(aRet,{})

// se existe a classe FWSX1Util e o metodo GetAllFields não se encontra disponivel
// na versao da lib 20180615
If (dLibVers >= "20180820" ) 

	oObj:AddGroup(cPerg)
	oObj:SearchGroup()

	aPergunt := oObj:GetGroup(cPerg)
	//Pega Perguntas e valores configurados
	For nX := 1 To nY
		Aadd(aRet[2],{aPergunt[2][nx]:CX1_PERGUNT,&("MV_PAR" + StrZero(nX,2))})
	Next nX
	
	// faz o tratamento buscando direto na tabela SX1
	// Caso gere issue na ferramenta SONARQUBE deve ser
	// classificado como falso positivo.
Else	
	For nX := 1 To nY
		SX1->(DbSetOrder(1))
		SX1->(DbSeek(PADR(cPerg,Len(SX1->X1_GRUPO)) + StrZero(nX,2)))
		Aadd(aRet[2],{X1Pergunt(),&("MV_PAR" + StrZero(nX,2))})
	Next nX
	RestArea(aRetSX1)
	
Endif

Return aRet


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Função  | ATIVAF12  | Autor | Samuel Miranda      | Data | 05/003/2025 |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Descrição | Executa a Funcao da Pergunte   				 		      |±±
±±| Função ajustada para somente gerar ordem por pedido.	 		      |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function AtivaF12(nOrigExp)
Local lPerg := .F.
Local lRet  := .T.
If	nOrigExp == NIL
	lPerg := .T.
	If	(lRet:=Pergunte("AIA101",.t.))
		nOrigExp := MV_PAR01
	EndIf
EndIf
If	lRet
	If	nOrigExp == 1  //Origem: Pedidos de Venda
		If	Pergunte("AIA106",lPerg) .Or. !lPerg
			Aadd(aPerg100,ACD100Perg("AIA106"))
			nConfLote	:= MV_PAR01
			nEmbSimul	:= MV_PAR02
			nEmbalagem	:= MV_PAR03
			If cPaisLoc == "BRA"
				nGeraNota	:= MV_PAR04
				nImpNota	:= MV_PAR05
				nImpEtVol	:= MV_PAR06
				nEmbarque	:= MV_PAR07
				nAglutPed	:= MV_PAR08
				nAglutArm	:= MV_PAR09 
			Else
				nImpEtVol	:= MV_PAR04
				nEmbarque	:= MV_PAR05
				nAglutPed	:= MV_PAR06
				nAglutArm	:= MV_PAR07
			EndIf		
		EndIf
	 ElseIf	nOrigExp == 2  //Origem: Notas Fiscais
		If	Pergunte("AIA107",lPerg) .Or. !lPerg
			nEmbSimuNF := MV_PAR01
			nEmbalagNF := MV_PAR02
			nEmbalagem := MV_PAR02
			nImpNotaNF := MV_PAR03
			nImpVolNF  := MV_PAR04
			nEmbarqNF  := MV_PAR05
		EndIf
	 Else  //Origem: Ordens de Producao
		If	Pergunte("AIA108",lPerg) .Or. !lPerg
			nReqMatOP   := MV_PAR01
			nAglutArmOP := MV_PAR02
		EndIf
	EndIf
EndIf
Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Função  | A100MARK   | Autor | Samuel Miranda      | Data | 05/003/2025   |±±								    |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Descrição|Func. Responsavel por Marcar / Desmarcar Registros no Browser   										|±±
±±|Param oBrwMrk, Object  , Objeto do Browser 																    	|±±
±±|Param nOpcx	, Numeric , Opcao para Processamento 1= Atualiza Registro / 2=Atualiza Todos                        |±±
±±|Param cGetMark, Caracter, Marca Utilizada no Browser 														    |±±
±±|Param bMark2	, Block	  , Bloco de Codigo Utilizado para Identificar se o Registro deve ser Marcado ou Não        |±±
±±|Param uAlias	, Caracter, Alias da Tabela em Uso 																	|±±
±±|Param cCpoMark	, Caracter, Campo Utilizado para Marcar/Desmarcar 												|±±
±±|Peturn lRet	, Boolean , Informa se foi possivel Atualizar o Registro 											|±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function a100Mark( oBrwMrk, nOpcx, cGetMark, bMark2, uAlias, cCpoMark )
	Local lRet		:= .T.
	Local bMarkRec	:= { || IIf( Eval( bMark2 ) , IIf( AllTrim( &( ( uAlias )->( cCpoMark ) ) ) == AllTrim( cGetMark ), CriaVar( cCpoMark, .F.), AllTrim( cGetMark ) ) , CriaVar( cCpoMark, .F.) ) }

	Default nOpcx := 1

	If nOpcx == 1
		If !Empty(Eval( bMarkRec )) .OR. AllTrim( &( ( uAlias )->( cCpoMark ) ) ) == AllTrim( cGetMark )
		RecLock( uAlias, .F. )
		( uAlias )->( FieldPut( FieldPos( cCpoMark ) , Eval( bMarkRec ) ) )
		( uAlias )->( MsUnLock() )
		Endif
	Else
		( uAlias )->( dbGoTop() )
		While !( uAlias )->( Eof() )
			If !Empty(Eval( bMarkRec )) .OR. AllTrim( &( ( uAlias )->( cCpoMark ) ) ) == AllTrim( cGetMark )
				RecLock( uAlias, .F. )
				( uAlias )->( FieldPut( FieldPos( cCpoMark ) , Eval( bMarkRec ) ) )
				( uAlias )->( MsUnLock() )
			Endif
			( uAlias )->( dbSkip() )
		EndDo
		//Vai para o inicio do Alias
		oBrwMrk:GoTop()
	EndIf
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Função  | ACDVERSION  | Autor | Samuel Miranda    | Data | 05/003/2025 |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Descrição | Encapsulamento da funcao do frame que                      |±±
±±|	retorna a versão da lib do repositorio   				 		      |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function ACDVERSION()
	Local cVersao := ""
	/*
	 * A chamada da funcao __FWLibVersion esta sendo utilizada, conforme acordado com o framework.
	 * Pois se trata de uma funcao "interna" do framework.
	 * A função vai estar liberada com o nome de FWLibVersion() na proxima lib
	 * com versão superior a 20190111
	 */
	If FindFunction("__FWLibVersion")
		cVersao := __FWLibVersion()
	Else
		If FindFunction("FWLibVersion")
			cVersao := FWLibVersion()
		EndIf
	EndIf

Return cVersao


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Função  | A1002LEG | Autor | Samuel Miranda       | Data | 05/003/2025 |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Descrição | Funcao Responsavel Montar a Legenda do Browser             |±±
±±|	retorna a versão da lib do repositorio   				 		      |±±
±±|Param aLegend,Array, Vetor com as Informacoes para Montagem da Legenda |±±
±±|return oFWLegend, Object , Objeto FwLegend Criado                      |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function a1002Leg( aLegend )
Default aLegend := {}
oFWLegend := IIf( Type( "oFWLegend" ) == "U", Nil, oFWLegend )
	If Len( aLegend ) > 0
		oFWLegend := FWLegend():New()
		AEval( aLegend,{ | x | oFWLegend:Add( x[1], x[2], x[3] ) } )
		oFWLegend:Activate()
	EndIf
Return oFWLegend


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Função  | ACDGRAVAR | Autor | Samuel Miranda       | Data | 05/003/2025  |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Descrição | Gravacao das ordens de separacao.			                |±±
±±| Opção setada somente para aglutinação de pedidos.					    |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function ACDGRAVAR(cAlias,cCampo,nOpcE,cMarca,lInverte,lNoDupl, oBrwMrk )
	If nOrigExp==1
		Processa( { || GerOrdSep( cMarca, lInverte, Nil, oBrwMrk ) } ) 
		Else 
		FWAlertWarning( "Selecione a opção Pedido.", '	A T E N Ç Ã O' )
		Return()
	EndIf	
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Função| GERORDSEP | Autor | Samuel Miranda       | Data | 05/003/2025  |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Descrição |Gera as ordens de separacao a partir dos itens da MarkBrowse|±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Sintaxe   |GeraOrdSep( ExpC1, ExpL1 )                                  |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Parametros| ExpC1 -> Marca da MarkBrowse / ExpL1 -> lInverte MarkBrowse|±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Retorno   | Nil                                                        |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Uso       | PCHA030                                                    |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function GerOrdSep( cMarca, lInverte, cPedidoPar, oBrwMrk )
Local nI 		 := 0
Local cCodOpe    := ""
Local aRecSC9	 := {}
Local aOrdSep	 := {}
Local nNumItens	 := 0
Local cArm		 := Space(Tamsx3("B1_LOCPAD")[1])
Local cPedido	 := Space(Tamsx3("C9_PEDIDO")[1])
Local cCliente	 := Space(Tamsx3("C6_CLI")[1])
Local cLoja		 := Space(Tamsx3("C6_LOJA")[1])
Local cCondPag	 := Space(Tamsx3("C5_CONDPAG")[1])
Local cLojaEnt	 := Space(Tamsx3("C5_LOJAENT")[1])
Local cAgreg	 := Space(Tamsx3("C9_AGREG")[1])
Local cOrdSep	 := Space(Tamsx3("CB7_ORDSEP")[1])
Local cForn		 := ""
Local cLojaForn	 := ""

Local cTipExp	 := ""
Local nPos       := 0
Local nMaxItens	 := GETMV("MV_NUMITEN")			//Numero maximo de itens por nota (neste caso por ordem de separacao)- by Erike
Local lConsNumIt := SuperGetMV("MV_CBCNITE",.F.,.T.) //Parametro que indica se deve ou nao considerar o conteudo do MV_NUMITEN
Local lFilItens	 := ExistBlock("ACDA100I")  //Ponto de Entrada para filtrar o processamento dos itens selecionados
Local lLocOrdSep := .F.
Local lA100CABE  := ExistBlock("A100CABE")
Local lACD100GI  := ExistBlock("ACD100GI")
Local lACDA100F  := ExistBlock("ACDA100F")
Local lACD100G1  := ExistBlock("ACD100G1")
Local aSc9Aux	 := {}
Local aAux		 := {}
Local aItens	 := {}
Local aPvVet	 := {}
Local aAuxUsr	 := {}
Local nInd		 := 0
Local nXnd		 := 0
Local cTransp	 := Nil
Local cCondPg	 := Nil

Local nCondPgto  := ""
Local nTemp 	 := {}
local nStatusCli := "" //Verifica o status do cliente (Bloqueado / Ativo)
local nDocCli    := "" //Verifica o status do cliente (Bloqueado / Ativo)

Private aLogOS	 := {}
Default oBrwMrk	 := Nil
Default cPedidoPar	:= Nil

nMaxItens := If(Empty(nMaxItens),99,nMaxItens)

// analisar a pergunta '00-Separacao,01-Separacao/Embalagem,02-Embalagem,03-Gera Nota,04-Imp.Nota,05-Imp.Volume,06-embarque,07-Aglutina Pedido,08-Aglutina Local,09-Pre-Separacao'
If nEmbSimul == 1 // Separacao com Embalagem Simultanea
	cTipExp := "01*"
Else
	cTipExp := "00*" // Separacao Simples
EndIF
If nEmbalagem == 1 // Embalagem
	cTipExp += "02*"
EndIF
If nGeraNota == 1 // Gera Nota
	cTipExp += "03*"
EndIF
If nImpNota == 1 // Imprime Nota
	cTipExp += "04*"
EndIF
If nImpEtVol == 1 // Imprime Etiquetas Oficiais de Volume
	cTipExp += "05*"
EndIF
If nEmbarque == 1 // Embarque
	cTipExp += "06*"
EndIF
If nAglutPed == 1 // Aglutina pedido
	cTipExp +="11*"
EndIf
If nAglutArm == 1 // Aglutina armazem
	cTipExp +="08*"
EndIf
If nPreSep == 1 // pre-separacao - Trocar MV_PAR10 para nPreSep
	cTipExp +="09*"
EndIf
If nConfLote == 1 // confere lote
	cTipExp +="10*"
EndIf

/*Ponto de entrada, permite que o usuário realize o processamento conforme suas particularidades.*/
If	ExistBlock("ACD100VG")
	If ! ExecBlock("ACD100VG",.F.,.F.,)
		Return
	EndIf		
EndIf

ProcRegua( SC9->( LastRec() ), "oook" )
cCodOpe	 := cSeparador

SC5->(DbSetOrder(1))
SC6->(DbSetOrder(1))
SDC->(DbSetOrder(1))
CB7->(DbSetOrder(2))
CB8->(DbSetOrder(2))

SC9->(dbGoTop())
While !SC9->(Eof())
	If !( oBrwMrk:IsMark() )
		SC9->( dbSkip() ) ; Loop
		IncProc()
	EndIf

	If !Empty(SC9->(C9_BLEST+C9_BLCRED+C9_BLOQUEI))
		SC9->(DbSkip())
		IncProc()
		Loop
	EndIf
	If lFilItens
		If !ExecBlock("ACDA100I",.F.,.F.)
			SC9->(DbSkip())
			IncProc()
			Loop
		Endif
	Endif
	//pesquisa se este item tem saldo a separar, caso tenha, nao gera ordem de separacao
	If CB8->(DbSeek(xFilial('CB8')+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN+SC9->C9_PRODUTO)) .and. CB8->CB8_SALDOS > 0
		//Grava o historico das geracoes:
		aadd(aLogOS,{"2",STR0041,SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,STR0042,"NAO_GEROU_OS"}) //"Pedido"###"Existe saldo a separar deste item"
		SC9->(DbSkip())
		IncProc()
		Loop
	EndIf

	If ! SC5->(DbSeek(xFilial('SC5')+SC9->C9_PEDIDO))
		// neste caso a base tem sc9 e nao tem sc5, problema de incosistencia de base
		//Grava o historico das geracoes:
		aadd(aLogOS,{"2",STR0041,SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,STR0043,"NAO_GEROU_OS"}) //"Pedido"###"Inconsistencia de base (SC5 x SC9)"
		SC9->(DbSkip())
		IncProc()
		Loop
	EndIf
	If ! SC6->(DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
		// neste caso a base tem sc9,sc5 e nao tem sc6,, problema de incosistencia de base
		//Grava o historico das geracoes:
		aadd(aLogOS,{"2",STR0041,SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,STR0044,"NAO_GEROU_OS"}) //"Pedido"###"Inconsistencia de base (SC6 x SC9)"
		SC9->(DbSkip())
		IncProc()
		Loop
	EndIf

	If !("08*" $ cTipExp)  // gera ordem de separacao por armazem
		cArm :=SC6->C6_LOCAL
	Else  // gera ordem de separa com todos os armazens
		cArm :=Space(Tamsx3("B1_LOCPAD")[1])
	EndIf
	If "11*" $ cTipExp //AGLUTINA TODOS OS PEDIDOS DE UM MESMO CLIENTE
		cPedido := Space(Tamsx3("C9_PEDIDO")[1])
	Else   // Nao AGLUTINA POR PEDIDO
		cPedido := SC9->C9_PEDIDO
	EndIf
	If "09*" $ cTipExp // AGLUTINA PARA PRE-SEPARACAO
		cPedido  := Space(Tamsx3("C9_PEDIDO")[1]) // CASO SEJA PRE-SEPARACAO TEM QUE CONSIDERAR TODOS OS PEDIDOS
		cCliente := Space(Tamsx3("C6_CLI")[1])
		cLoja    := Space(Tamsx3("C6_LOJA")[1])
		cCondPag := Space(Tamsx3("C5_CONDPAG")[1])
		cLojaEnt := Space(Tamsx3("C5_LOJAENT")[1])
		cAgreg   := Space(Tamsx3("C9_AGREG")[1])
		cForn 		:= SC6->C6_CLI
		cLojaForn	:= SC6->C6_LOJA
		cArmazem	:= SC6->C6_LOCAL 
	Else   // NAO AGLUTINA PARA PRE-SEPARACAO
		cCliente 	:= SC6->C6_CLI
		cLoja    	:= SC6->C6_LOJA
		cCondPag 	:= SC5->C5_CONDPAG
		cLojaEnt 	:= SC5->C5_LOJAENT
		cAgreg   	:= SC9->C9_AGREG
		cForn 		:= Space(Tamsx3("C6_CLI")[1])
		cLojaForn	:= Space(Tamsx3("C6_LOJA")[1])
		cArmazem 	:= SC6->C6_LOCAL

	EndIf

	lLocOrdSep := .F.
	If CB7->(DbSeek(xFilial("CB7")+cPedido+cArm+" "+cCliente+cLoja+cCondPag+cLojaEnt+cAgreg))
		While CB7->(!Eof() .and. CB7_FILIAL+CB7_PEDIDO+CB7_LOCAL+CB7_STATUS+CB7_CLIENT+CB7_LOJA+CB7_COND+CB7_LOJENT+CB7_AGREG==;
								xFilial("CB7")+cPedido+cArm+" "+cCliente+cLoja+cCondPag+cLojaEnt+cAgreg)
			If Ascan(aOrdSep, CB7->CB7_ORDSEP) > 0			
				lLocOrdSep := .T.
				Exit
			EndIf
			CB7->(DbSkip())
		EndDo
	EndIf

	If Localiza(SC9->C9_PRODUTO)
		If ! SDC->( dbSeek(xFilial("SDC")+SC9->C9_PRODUTO+SC9->C9_LOCAL+"SC6"+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN))
			// neste caso nao existe composicao de empenho
			//Grava o historico das geracoes:
			aadd(aLogOS,{"2",STR0041,SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,STR0045,"NAO_GEROU_OS"}) //"Pedido"###"Nao existe composicao de empenho (SDC)"
			SC9->(DbSkip())
			IncProc()
			Loop
		EndIf
	EndIf
	
	aPvVet := GetAdvFVal( 'SC5', { 'C5_TRANSP', 'C5_CONDPAG' }, FWxFilial( 'SC5' ) + SC9->C9_PEDIDO, 1 )
	Aadd( aAux,{ 	IIf( "09*" $ cTipExp, cForn, cCliente  ),; 	//01-Cliente/Fornecedor
					IIf( "09*" $ cTipExp, cLojaForn, cLoja ),; 	//02-Loja Cliente/Fornecedor
					cCondPag,; 									//03-Condp Pagto
					cLojaEnt,; 									//04-Loja Entrada
					cAgreg	,; 									//05-Agrega
					cArmazem,; 									//06-Armazem
					SC9->( Recno() ),; 							//07-Recno SC9
					SC9->C9_PEDIDO	,; 							//08-Codigo Ped Venda SC9
					cPedido	,; 									//09-Cod. Ped Venda
					aPvVet[ 01 ],; 								//10-Transportadora Ped venda SC5
					aPvVet[ 02 ]  } )							//11-Cond. Pagto Ped venda SC5

	If lACD100G1
		aAuxUsr := ExecBlock("ACD100G1", .F., .F., aTail(aAux) )
		If ValType(aAuxUsr) == "A"
			aTail(aAux) := aClone(aAuxUsr)
		EndIf
	EndIf
	
	IncProc()
	SC9->( dbSkip() )
EndDo


//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Variavél   nCondPgto							   | Data | 05/003/2025 |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Descrição | Customização criada para validar os itens com 				|±±
//              a mesma condição de pagamento.  	                        |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
nCondPgto := aAux[ 1 ][ 03]
DbSelectArea("SA1")
DbSetOrder(1)
//Entrar no laço para adicionar os itens no array para gerar as ordens de separação. //A1_XQUALIF
For nInd := 1 to Len(aAux)
 nStatusCli  := Posicione("SA1",1,XFILIAL("SA1") +  aAux[nInd][1] + aAux[nInd][2], "A1_MSBLQL")
 nDocCli 	 := Posicione("SA1",1,XFILIAL("SA1") +  aAux[nInd][1] + aAux[nInd][2], "A1_XQUALIF")
	//Verica se o cliente esta com algum bloqueio
	If nStatusCli == "1" .OR. nDocCli == "2"
		//
	 Else
	 	//Se não houver bloqueio, gera a ordem de separação
		If aAux[nInd][3] == nCondPgto 	
			Aadd( nTemp,{ aAux[nInd][1],;  //01-Cliente/Fornecedor
						aAux[nInd][2],;    //02-Loja Cliente/Fornecedor
						aAux[nInd][03],;   //03-Condp Pagto
						aAux[nInd][04],;   //04-Loja Entrada
						aAux[nInd][05],;   //05-Agrega
						aAux[nInd][06],;   //06-Armazem
						aAux[nInd][07],;   //07-Recno SC9
						aAux[nInd][08],;   //08-Codigo Ped Venda SC9
						aAux[nInd][09],;   //09-Cod. Ped Venda
						aAux[nInd][10],;   //10-Transportadora Ped venda SC5
						aAux[nInd][11] } ) //11-Cond. Pagto Ped venda SC5
		EndIf
	EndIf
Next nInd

aItens := A100ItGrp( nTemp, nAglutPed, nAglutArm, nPreSep )

//Inicia a transação
Begin Transaction

For nInd := 1 To Len( aItens )
	nNumItens := 0
	cCliente  := aItens[ nInd ][ 01 ]
	cLoja	  := aItens[ nInd ][ 02 ]
	cArm	  := aItens[ nInd ][ 03 ]	
	cPedido	  := aItens[ nInd ][ 06 ]
	cLojaEnt  := aItens[ nInd ][ 07 ]
	cTransp	  := aItens[ nInd ][ 08 ]
	cCondPg   := aItens[ nInd ][ 09 ]
	cAgreg	  := aItens[ nInd ][ 10 ]	

	aSc9Aux	  := AClone( aItens[ nInd ][ 05 ] )//Seleciona os recnos para gerar as ordens de separação

	For nXnd := 1 To Len( aSc9Aux )
		SC9->( dbGoto( aSc9Aux[ nXnd ] ) )
			If !lLocOrdSep .or. (("03*" $ cTipExp) .and. !("09*" $ cTipExp) .and. lConsNumIt )
				If ( nNumItens == 0 ) .Or. ( nNumItens >= nMaxItens )
					nNumItens	:= 0
					cOrdSep 	:= CB_SXESXF("CB7","CB7_ORDSEP",,1)
					ConfirmSX8()
					//Atribui a condição de pagamento quando for mais de um item no array
					If Len(aSc9Aux) > 1
						cCondPg := nCondPgto
					EndIF
					CB7->(RecLock( "CB7",.T.))
					CB7->CB7_FILIAL := xFilial( "CB7" )
					CB7->CB7_ORDSEP := cOrdSep
					CB7->CB7_PEDIDO := cPedido
					CB7->CB7_CLIENT := cCliente
					CB7->CB7_LOJA   := cLoja
					CB7->CB7_COND   := cCondPg
					CB7->CB7_LOJENT := cLojaEnt
					CB7->CB7_LOCAL  := cArm
					CB7->CB7_DTEMIS := dDataBase
					CB7->CB7_HREMIS := Time()
					CB7->CB7_STATUS := " "
					CB7->CB7_CODOPE := cCodOpe
					CB7->CB7_PRIORI := "1"
					CB7->CB7_ORIGEM := "1"
					CB7->CB7_TIPEXP := cTipExp
					CB7->CB7_TRANSP := cTransp
					CB7->CB7_AGREG  := cAgreg 
					If	lA100CABE
						ExecBlock("A100CABE",.F.,.F.)
					EndIf
					CB7->(MsUnlock())

					aadd(aOrdSep, cOrdSep )
				EndIf
			EndIf
			//Grava o historico das geracoes:
			nPos := Ascan(aLogOS,{|x| x[01]+x[02]+x[03]+x[04]+x[05]+x[10] == ("1"+"Pedido"+SC9->(C9_PEDIDO+C9_CLIENTE+C9_LOJA)+CB7->CB7_ORDSEP)})
			If nPos == 0
				aadd(aLogOS,{"1",STR0041,SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,"","",cArm,"",CB7->CB7_ORDSEP}) //"Pedido"
			Endif

			If Localiza(SC9->C9_PRODUTO)
				SDC->( dbSeek(xFilial("SDC")+SC9->C9_PRODUTO+SC9->C9_LOCAL+"SC6"+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN))
				While SDC->( !Eof() ) .And. SDC->DC_FILIAL == FWxFilial( "SDC" ) .And. SDC->DC_PRODUTO == SC9->C9_PRODUTO .And. SDC->DC_LOCAL == SC9->C9_LOCAL .And. SDC->DC_ORIGEM == 'SC6' .And. SDC->DC_PEDIDO == SC9->C9_PEDIDO .And. SDC->DC_ITEM == SC9->C9_ITEM .And. SDC->DC_SEQ == SC9->C9_SEQUEN
					SB1->(DBSetOrder(1))
					If SB1->(DbSeek(xFilial("SB1")+SDC->DC_PRODUTO)) .And. IsProdMOD(SDC->DC_PRODUTO)
						SDC->(DbSkip())
						Loop
					Endif
					CB7->( dbSetOrder( 1 ) )
					CB7->( dbSeek( xFilial( "CB7" ) + cOrdSep ) )
					CB8->(RecLock("CB8",.T.))
					CB8->CB8_FILIAL := xFilial("CB8")
					CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
					CB8->CB8_ITEM   := SC9->C9_ITEM
					CB8->CB8_PEDIDO := SC9->C9_PEDIDO
					CB8->CB8_PROD   := SDC->DC_PRODUTO
					CB8->CB8_LOCAL  := SDC->DC_LOCAL
					CB8->CB8_QTDORI := SDC->DC_QUANT
					If "09*" $ cTipExp
						CB8->CB8_SLDPRE := SDC->DC_QUANT
					EndIf
					CB8->CB8_SALDOS := SDC->DC_QUANT
					If ! "09*" $ cTipExp .AND. nEmbalagem == 1
						CB8->CB8_SALDOE := SDC->DC_QUANT
					EndIf
					CB8->CB8_LCALIZ := SDC->DC_LOCALIZ
					CB8->CB8_NUMSER := SDC->DC_NUMSERI
					CB8->CB8_SEQUEN := SC9->C9_SEQUEN
					CB8->CB8_LOTECT := SC9->C9_LOTECTL
					CB8->CB8_NUMLOT := SC9->C9_NUMLOTE
					CB8->CB8_CFLOTE := If("10*" $ cTipExp,"1","2")
					CB8->CB8_TIPSEP := If("09*" $ cTipExp,"1"," ")
					If	lACD100GI
						ExecBlock("ACD100GI",.F.,.F.)
					EndIf
					CB8->(MsUnLock())
					//Atualizacao do controle do numero de itens a serem impressos
					nNumItens ++
					RecLock("CB7",.F.)
					CB7->CB7_NUMITE := nNumItens
					CB7->(MsUnLock())
				SDC->( dbSkip() )
			EndDo
		Else
			CB7->( dbSetOrder( 1 ) )
			CB7->( dbSeek( xFilial( "CB7" ) + cOrdSep ) )
			
			CB8->(RecLock("CB8",.T.))
			CB8->CB8_FILIAL := xFilial("CB8")
			CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
			CB8->CB8_ITEM   := SC9->C9_ITEM
			CB8->CB8_PEDIDO := SC9->C9_PEDIDO
			CB8->CB8_PROD   := SC9->C9_PRODUTO
			CB8->CB8_LOCAL  := SC9->C9_LOCAL
			CB8->CB8_QTDORI := SC9->C9_QTDLIB
		
			If "09*" $ cTipExp
				CB8->CB8_SLDPRE := SC9->C9_QTDLIB
			EndIf
		
			CB8->CB8_SALDOS := SC9->C9_QTDLIB
			If ! "09*" $ cTipExp .AND. nEmbalagem == 1
				CB8->CB8_SALDOE := SC9->C9_QTDLIB
			EndIf
		
			CB8->CB8_LCALIZ := ""
			CB8->CB8_NUMSER := SC9->C9_NUMSERI
			CB8->CB8_SEQUEN := SC9->C9_SEQUEN
			CB8->CB8_LOTECT := SC9->C9_LOTECTL
			CB8->CB8_NUMLOT := SC9->C9_NUMLOTE
			CB8->CB8_CFLOTE := If("10*" $ cTipExp,"1","2")
			CB8->CB8_TIPSEP := If("09*" $ cTipExp,"1"," ")
			If	lACD100GI
				ExecBlock("ACD100GI",.F.,.F.)
			EndIf
			CB8->(MsUnLock())

			//Atualizacao do controle do numero de itens a serem impressos
			nNumItens ++
			RecLock("CB7",.F.)
			CB7->CB7_NUMITE := nNumItens
			CB7->(MsUnLock())
		EndIf
		Aadd(aRecSC9,{ SC9->(Recno() ), cOrdSep } )
	Next nXnd
Next nInd

CB7->(DbSetOrder(1))
For nI := 1 to len( aOrdSep )
	CB7->(DbSeek(xFilial("CB7")+aOrdSep[nI]))
	CB7->(RecLock("CB7"))
	CB7->CB7_STATUS := "0"  // nao iniciado
	CB7->(MsUnlock())

	If	lACDA100F
		ExecBlock("ACDA100F",.F.,.F.,{aOrdSep[nI]})
	EndIf
Next

For nI := 1 to len(aRecSC9)
	SC9->(DbGoto(aRecSC9[nI,1]))
	SC9->(RecLock("SC9"))
	SC9->C9_ORDSEP := aRecSC9[nI,2]
	SC9->C9_OK := space(len(SC9->C9_OK))
	SC9->(MsUnlock())
Next

If !Empty(aLogOS)
	LogACDA100()
Endif

End Transaction
Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Fun‡„o    |LOGACDA100 | Autor | Samuel Miranda    | Data | 05/003/2025 |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Descri‡„o | Exibicao do log das geracoes das Ordens de Separacao       |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Retorno   | Nil                                                        |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Uso       | Apos a geracao das OS sao exibidas todas as informacoes que|±±
±±|          | ocorreram durante o processo.                              |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/	
Static Function LogACDA100()
Local i := 0
Local j := 0
Local k := 0
Local cChaveAtu := "" 
Local cPedCli   := ""  
//Local cOPAtual  := "" 

//Cabecalho do Log de processamento:
AutoGRLog(Replicate("=",75))
AutoGRLog(STR0083) //"                         I N F O R M A T I V O"
AutoGRLog(STR0084) //"               H I S T O R I C O   D A S   G E R A C O E S"

//Detalhes do Log de processamento:
AutoGRLog(Replicate("=",75))
AutoGRLog(STR0085) //"I T E N S   P R O C E S S A D O S :"
AutoGRLog(Replicate("=",75))
If aLogOS[1,2] == STR0041 //"Pedido"
	aLogOS := aSort(aLogOS,,,{|x,y| x[01]+x[10]+x[03]+x[04]+x[05]+x[06]+x[07]+x[08]<y[01]+y[10]+y[03]+y[04]+y[05]+y[06]+y[07]+y[08]})
	// Status Ord.Sep(1=Gerou;2=Nao Gerou) + Ordem Separacao + Pedido + Cliente + Loja + Item + Produto + Local
	cChaveAtu := ""
	cPedCli   := ""
	For i:=1 to len(aLogOs)
		If aLogOs[i,10] <> cChaveAtu .OR. (aLogOs[i,03]+aLogOs[i,04] <> cPedCli)
			If !Empty(cChaveAtu)
				AutoGRLog(Replicate("-",75))
			Endif
			j:=0
			k:=i  //Armazena o conteudo do contador do laco logico principal (i) pois o "For" j altera o valor de i;
			cChaveAtu := aLogOs[i,10]
			For j:=k to len(aLogOs)
				If aLogOs[j,10] <> cChaveAtu
					Exit
				Endif
				If Empty(aLogOs[j,08]) //Aglutina Armazem
					AutoGRLog(STR0086+aLogOs[j,03]+STR0087+aLogOs[j,04]+"-"+aLogOs[j,05]) //"Pedido: "###" - Cliente: "
				Else
					AutoGRLog(STR0086+aLogOs[j,03]+STR0087+aLogOs[j,04]+"-"+aLogOs[j,05]+STR0088+aLogOs[j,08]) //"Pedido: "###" - Cliente: "###" - Local: "
				Endif
				cPedCli := aLogOs[j,03]+aLogOs[j,04]
				If aLogOs[j,10] == "NAO_GEROU_OS"
					Exit
				Endif
				i:=j
			Next j
			AutoGRLog(STR0058+If(aLogOs[i,01]=="1",aLogOs[i,10],STR0089)) //"Ordem de Separacao: "###"N A O  G E R A D A"
			If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
				AutoGRLog(STR0090) //"Motivo: "
			Endif
		Endif
		If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
			AutoGRLog(STR0091+aLogOs[i,06]+STR0092+AllTrim(aLogOs[i,07])+STR0088+aLogOs[i,08]+" ---> "+aLogOs[i,09]) //"Item: "###" - Produto: "###" - Local: "
		Endif
	Next i
Endif
MostParam(aLogOS[1,2])
MostraErro()
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Função | MOSTPARAM      | Autor | Samuel Miranda    | Data | 05/003/2025 |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Descrição | Exibicao dos parametros da geracao da Ordem de Separacao     |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Retorno   | Nil                                                          |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function MostParam(cTipGer)
Local cPergParam  := ""
Local cPergConfig := ""
Local cDescTipGer := ""
Local cResp		  := ""
Local nTamSX1     := 0
Local aPerg       := {}
Local aParam      := {}
Local ni          := 0
Local nX		  := 0
Local nPos		  := 0
Local ci          := 0
Local aLogs       := {}
Local oObj
  		
// se existe a classe FWSX1Util e o metodo GetAllFields não se encontra disponivel
// na versao da lib 20180615
If ACDVERSION() >= "20180820"
	oObj := FWSX1Util():New()	
	oObj:AddGroup("AIA102")
    oObj:SearchGroup()
    nTamSX1 := len(oObj:aGrupo[1][1])
    
	// faz o tratamento buscando direto na tabela SX1
	// Caso gere issue na ferramenta SONARQUBE deve ser
	// classificado como falso positivo. 
 Else
	nTamSX1 := Len(SX1->X1_GRUPO)	
Endif
//Ajustado para fazer somente por pedido
If cTipGer == STR0041 //"Pedido"
	cPergParam  := PADR('AIA102',nTamSX1) 
	cPergConfig := PADR('AIA106',nTamSX1)
	cDescTipGer := STR0094 //'PEDIDO DE VENDA'
	aAdd(aParam,nConfLote)
	aAdd(aParam,nEmbSimul)
	aAdd(aParam,nEmbalagem)
	If cPaisLoc == "BRA"
		aAdd(aParam,nGeraNota)
		aAdd(aParam,nImpNota)
	EndIf
	aAdd(aParam,nImpEtVol)
	aAdd(aParam,nEmbarque)
	aAdd(aParam,nAglutPed)
	aAdd(aParam,nAglutArm)
Endif

aAdd(aPerg,{STR0097+cDescTipGer,cPergParam}) //"P A R A M E T R O S : "
aAdd(aPerg,{STR0098+cDescTipGer,cPergConfig}) //"C O N F I G U R A C O E S : "
//-- Carrega parametros SX1
For ni := 1 To Len(aPerg)
	//Posiciona no pergunte dentro do array
	nPos := aScan(aPerg100,{|x| x[1] == AllTrim(aPerg[ni,2])})
	aAdd(aLogs,{aPerg100[nPos,1],{}})
	//Percorre o Array para retornar as perguntas
	For nX := 1 To Len(aPerg100[nPos,2])
		If ValType(aPerg100[nPos,2,nX,2]) == "C"
			cResp := aPerg100[nPos,2,nX,2]
		ElseIf ValType(aPerg100[nPos,2,nX,2]) == "N"
			If aPerg100[nPos,2,nX,2] == 1
				cResp := STR0100 //Sim
			Else
				cResp := STR0101 //Não
			EndIf
		Else
			cResp := ""
		EndIf		
		cTexto := STR0099 + StrZero(nX,2) + ": " + aPerg100[nPos,2,nX,1] + cResp
		aAdd(aLogs[ni,2],cTexto) 
	Next nX	
Next ni

//-- Gera Log
For ni := 1 To Len(aPerg)
	AutoGRLog(Replicate("=",75))
	AutoGRLog(aPerg[ni,1])
	AutoGRLog(Replicate("=",75))
	For ci := 1 To Len(aLogs[ni,2])
		AutoGRLog(aLogs[ni,2,ci])
	Next ci
Next ni
AutoGRLog(Replicate("=",75))
Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Função | A100ITGRP     | Autor | Samuel Miranda              | Data | 05/003/2025   |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Descrição | Funcao Responsavel por Preencher o Vetor de Itens Respeitando 	       |±±
±±| a Configuracao para Aglutinar as Ordens de Separacao   						       |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±| param aAux		, Array	  , Vetor com os Itens para Serem Aglutinados              |±±
±±| param nAglutPed, Integer , Indica Se Devemos Aglutinar Pedido de Venda 1=Sim/2=Nao |±±
±±| param nAglutArm, Integer , Indica Se Devemos Aglutinar Armazem 1=Sim/2=Nao         |±±
±±| peturn aItens	, Array	  , Vetor com os Itens Ordenados e Aglutinados             |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function A100ItGrp( aAux, nAglutPed, nAglutArm, nPreSep )
Local nInd		:= 0
Local nPosSc9	:= 0
Local nAuxVet 	:= 0
Local aItens	:= {}
Local aAuxVet	:= {}
Local aItensUsr	:= {}
Local bAscVet	:= Nil
Local bAuxVet1	:= Nil
Local bAuxVet2	:= Nil
Local bAuxVet3	:= Nil
Local lAglut    := .F.
Local lAglutArm := .F.
Local lACD100G2 := ExistBlock("ACD100G2")
Local lACD100G3 := ExistBlock("ACD100G3")

// O bloco de codigo bAscVet determina a regra para efetuar a quebra das Ordens de Separacao (Por cliente e loja, por cliente, loja e armazem, etc.)
// As regras estao descritas no documento: https://tdn.totvs.com/pages/viewpage.action?pageId=619129430
// Os demais blocos contem os mesmos campos e sao utilizados para efetuar as comparacoes para efeito de aglutinacao de pedidos em uma mesma O.S.

Do Case

Case nAglutPed == 2 .And. nAglutArm == 2
	// Aglutina Pedido = Nao; Aglutina Armazem = Nao
	// Sera gerada uma Ordem de Separacao para cada pedido de vendas
	// Caso um pedido de venda possua itens com armazens diferentes, sera gerada uma Ordem de Separacao diferente para cada item/armazem
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAscVet := { || Ascan( aItens ,{ | x |  AllTrim( x[ 04 ] ) == AllTrim( aAux[ nInd ][ 08 ] ) .And.; // Pedido
											AllTrim( x[ 01 ] ) == AllTrim( aAux[ nInd ][ 01 ] ) .And.; // Cliente
											AllTrim( x[ 02 ] ) == AllTrim( aAux[ nInd ][ 02 ] ) .And.; // Loja
											AllTrim( x[ 03 ] ) == AllTrim( aAux[ nInd ][ 06 ] ) } ) }  // Armazem
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAuxVet1 := { || Aadd( aAuxVet, {		AllTrim( aAux[ nInd ][ 08 ] ),;
											AllTrim( aAux[ nInd ][ 01 ] ),;
											AllTrim( aAux[ nInd ][ 02 ] ),;
											AllTrim( aAux[ nInd ][ 06 ] ),;
											{ AllTrim( aAux[ nInd ][ 08 ] ) },;
											{ AllTrim( aAux[ nInd ][ 06 ] ) } } ) }
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAuxVet2 := { || Ascan( aAuxVet,{ | x | AllTrim( x[ 01 ] ) == AllTrim( aAux[ nInd ][ 08 ] ) .And.;
											AllTrim( x[ 02 ] ) == AllTrim( aAux[ nInd ][ 01 ] ) .And.;
											AllTrim( x[ 03 ] ) == AllTrim( aAux[ nInd ][ 02 ] ) .And.;
											AllTrim( x[ 04 ] ) == AllTrim( aAux[ nInd ][ 06 ] ) } ) }
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAuxVet3 := { || Ascan( aAuxVet,{ | x | AllTrim( x[ 01 ] ) == AllTrim( aItens[ nInd ][ 04 ] ) .And.;
											AllTrim( x[ 02 ] ) == AllTrim( aItens[ nInd ][ 01 ] ) .And.;
											AllTrim( x[ 03 ] ) == AllTrim( aItens[ nInd ][ 02 ] ) .And.;
											AllTrim( x[ 04 ] ) == AllTrim( aItens[ nInd ][ 03 ] ) } ) }

Case nAglutPed == 2 .And. nAglutArm == 1
	// Aglutina Pedido = Nao; Aglutina Armazem = Sim
	// Sera gerada uma Ordem de Separacao para cada pedido de vendas
	// Mesmo que o pedido de venda possua itens com armazens diferentes, todos os itens do pedido serao considerados na mesma Ordem de Separacao
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAscVet := { || Ascan( aItens ,{ | x |  AllTrim( x[ 04 ] ) == AllTrim( aAux[ nInd ][ 08 ] ) .And.; // Pedido
											AllTrim( x[ 01 ] ) == AllTrim( aAux[ nInd ][ 01 ] ) .And.; // Cliente
											AllTrim( x[ 02 ] ) == AllTrim( aAux[ nInd ][ 02 ] ) } ) }  // Loja
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAuxVet1 := { || Aadd( aAuxVet, {		AllTrim( aAux[ nInd ][ 08 ] ),;
											AllTrim( aAux[ nInd ][ 01 ] ),;
											AllTrim( aAux[ nInd ][ 02 ] ),;
											{ AllTrim( aAux[ nInd ][ 08 ] ) },;
											{ AllTrim( aAux[ nInd ][ 06 ] ) } } ) }
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAuxVet2 := { || Ascan( aAuxVet,{ | x | AllTrim( x[ 01 ] ) == AllTrim( aAux[ nInd ][ 08 ] ) .And.;
											AllTrim( x[ 02 ] ) == AllTrim( aAux[ nInd ][ 01 ] ) .And.;
											AllTrim( x[ 03 ] ) == AllTrim( aAux[ nInd ][ 02 ] ) } ) }
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAuxVet3 := { || Ascan( aAuxVet,{ | x | AllTrim( x[ 01 ] ) == AllTrim( aItens[ nInd ][ 04 ] ) .And.;
											AllTrim( x[ 02 ] ) == AllTrim( aItens[ nInd ][ 01 ] ) .And.;
											AllTrim( x[ 03 ] ) == AllTrim( aItens[ nInd ][ 02 ] ) } ) }
//Aglutina Pedido = Sim; Aglutina Armazem = Nao
Case nAglutPed == 1 .And. nAglutArm == 2
	// Aglutina Pedido = Sim; Aglutina Armazem = Nao
	// Pedidos de venda serao aglutinados em uma mesma Ordem de Separacao desde que sejam do mesmo cliente/loja
	// Caso um pedido de venda possua itens com armazens diferentes, sera gerada uma Ordem de Separacao diferente para cada item/armazem
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAscVet := { || Ascan( aItens ,{ | x |  AllTrim( x[ 01 ] ) == AllTrim( aAux[ nInd ][ 01 ] ) .And.; // Cliente
											AllTrim( x[ 02 ] ) == AllTrim( aAux[ nInd ][ 02 ] ) .And.; // Loja
											AllTrim( x[ 03 ] ) == AllTrim( aAux[ nInd ][ 06 ] ) } ) }  // Armazem
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAuxVet1 := { || Aadd( aAuxVet, { 		AllTrim( aAux[ nInd ][ 01 ] ),;
											AllTrim( aAux[ nInd ][ 02 ] ),;
											AllTrim( aAux[ nInd ][ 06 ] ),;
											{ AllTrim( aAux[ nInd ][ 08 ] ) },;
											{ AllTrim( aAux[ nInd ][ 06 ] ) } } ) }
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAuxVet2 := { || Ascan( aAuxVet,{ | x | AllTrim( x[ 01 ] ) == AllTrim( aAux[ nInd ][ 01 ] ) .And.;
											AllTrim( x[ 02 ] ) == AllTrim( aAux[ nInd ][ 02 ] ) .And.;
											AllTrim( x[ 03 ] ) == AllTrim( aAux[ nInd ][ 06 ] ) } ) }
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAuxVet3 := { || Ascan( aAuxVet,{ | x | AllTrim( x[ 01 ] ) == AllTrim( aItens[ nInd ][ 01 ] ) .And.;
											AllTrim( x[ 02 ] ) == AllTrim( aItens[ nInd ][ 02 ] ) .And.;
											AllTrim( x[ 03 ] ) == AllTrim( aItens[ nInd ][ 03 ] ) } ) }

Case nAglutPed == 1 .And. nAglutArm == 1
	// Aglutina Pedido = Sim; Aglutina Armazem = Sim
	// Pedidos de venda serao aglutinados em uma mesma Ordem de Separacao desde que sejam do mesmo cliente/loja
	// Mesmo que o pedido de venda possua itens com armazens diferentes, todos os itens do pedido serao considerados na mesma Ordem de Separacao
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAscVet := { || Ascan( aItens ,{ | x |  AllTrim( x[ 01 ] ) == AllTrim( aAux[ nInd ][ 01 ] ) .And.; // Cliente
											AllTrim( x[ 02 ] ) == AllTrim( aAux[ nInd ][ 02 ] ) } ) }  // Loja
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAuxVet1 := { || Aadd( aAuxVet, { 		AllTrim( aAux[ nInd ][ 01 ] ),;
											AllTrim( aAux[ nInd ][ 02 ] ),;
											{ AllTrim( aAux[ nInd ][ 08 ] ) },;
											{ AllTrim( aAux[ nInd ][ 06 ] ) } } ) }
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAuxVet2 := { || Ascan( aAuxVet,{ | x | AllTrim( x[ 01 ] ) == AllTrim( aAux[ nInd ][ 01 ] ) .And.;
											AllTrim( x[ 02 ] ) == AllTrim( aAux[ nInd ][ 02 ] ) } ) }
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	bAuxVet3 := { || Ascan( aAuxVet,{ | x | AllTrim( x[ 01 ] ) == AllTrim( aItens[ nInd ][ 01 ] ) .And.;
											AllTrim( x[ 02 ] ) == AllTrim( aItens[ nInd ][ 02 ] ) } ) }
EndCase

If lACD100G2
	bAscVet := ExecBlock("ACD100G2", .F., .F., {bAscVet,nAglutPed,nAglutArm} )
EndIf

For nInd := 1 to Len( aAux )
	nPosSc9 := Eval( bAscVet )
	If nPosSc9 == 0
		Aadd( aItens, { AllTrim( aAux[ nInd ][ 01 ] ),; 	//01-Cliente/Fornecedor
						AllTrim( aAux[ nInd ][ 02 ] ),; 	//02-Loja Cliente/Fornecedor
						AllTrim( aAux[ nInd ][ 06 ] ),; 	//03-Armazem
						AllTrim( aAux[ nInd ][ 08 ] ),; 	//04-Codigo Ped Venda SC9
						{ aAux[ nInd ][ 07 ] }		 ,; 	//05-Vetor Recno SC9
						AllTrim( aAux[ nInd ][ 09 ] ),; 	//06-Cod. Ped Venda
						AllTrim( aAux[ nInd ][ 04 ] ),; 	//07-Loja Entrada
						AllTrim( aAux[ nInd ][ 10 ] ),; 	//08-Transportadora Ped venda SC5
						AllTrim( aAux[ nInd ][ 11 ] ),; 	//09-Cond. Pagto Ped venda SC5
						allTrim( aAux[ nInd ][ 05 ] ) } )	//10-Agreg

						Eval( bAuxVet1 )

		If lACD100G3
			aItensUsr := ExecBlock("ACD100G3", .F., .F., {aTail(aItens),aAux[nInd]} )
			If ValType(aItensUsr) == "A"
				aTail(aItens) := aClone(aItensUsr)
			EndIf
		EndIf

	Else
		Aadd( aItens[ nPosSc9 ][ 05 ], aAux[ nInd ][ 07 ] ) //05-Vetor Recno SC9
		nPosAglt := Eval( bAuxVet2 )
		If nPosAglt > 0
			If Ascan( aAuxVet[ nPosAglt ][ Len( aAuxVet[ nPosAglt ] )-1 ], AllTrim( aAux[ nInd ][ 08 ] ) ) == 0
				Aadd( aAuxVet[ nPosAglt ][ Len( aAuxVet[ nPosAglt ] )-1 ], AllTrim( aAux[ nInd ][ 08 ] ) )
			EndIf
			If Ascan( aAuxVet[ nPosAglt ][ Len( aAuxVet[ nPosAglt ] ) ], AllTrim( aAux[ nInd ][ 06 ] ) ) == 0
				Aadd( aAuxVet[ nPosAglt ][ Len( aAuxVet[ nPosAglt ] ) ], AllTrim( aAux[ nInd ][ 06 ] ) )
			EndIf
		EndIf

	EndIf
	
Next nInd

For nInd := 1 To Len( aItens )
	nAuxVet := Eval( bAuxVet3 )
	lAglut	:=   Len( aAuxVet[ nAuxVet ][ Len( aAuxVet[ nAuxVet ] )-1 ] ) > 1
	lAglutArm := Len( aAuxVet[ nAuxVet ][ Len( aAuxVet[ nAuxVet ] ) ] ) > 1

	Do Case
	Case nAglutPed == 2 .And. nAglutArm == 2 // Aglutina Pedido = Nao; Aglutina Armazem = Nao
		aItens[ nInd ][ 06 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_PEDIDO', .F. ), aItens[ nInd ][ 04 ] )
		aItens[ nInd ][ 07 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_LOJENT', .F. ), aItens[ nInd ][ 07 ] )
		aItens[ nInd ][ 08 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_TRANSP', .F. ), aItens[ nInd ][ 08 ] )
		aItens[ nInd ][ 09 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_COND'  , .F. ), aItens[ nInd ][ 09 ] )
		aItens[ nInd ][ 10 ] := IIf( nPreSep == 1, CriaVar( 'CB7_AGREG' , .F. ), aItens[ nInd ][ 10 ] )

	Case nAglutPed == 2 .And. nAglutArm == 1 // Aglutina Pedido = Nao; Aglutina Armazem = Sim
		aItens[ nInd ][ 03 ] := IIf( lAglutArm .Or. nPreSep == 1, CriaVar( 'CB7_LOCAL' , .F. ), aItens[ nInd ][ 03 ] )
		aItens[ nInd ][ 06 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_PEDIDO', .F. ), aItens[ nInd ][ 04 ] )
		aItens[ nInd ][ 07 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_LOJENT', .F. ), aItens[ nInd ][ 07 ] )
		aItens[ nInd ][ 08 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_TRANSP', .F. ), aItens[ nInd ][ 08 ] )
		aItens[ nInd ][ 09 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_COND'  , .F. ), aItens[ nInd ][ 09 ] )
		aItens[ nInd ][ 10 ] := IIf( nPreSep == 1, CriaVar( 'CB7_AGREG' , .F. ), aItens[ nInd ][ 10 ] )

	Case nAglutPed == 1 .And. nAglutArm == 2 // Aglutina Pedido = Sim; Aglutina Armazem = Nao
		aItens[ nInd ][ 06 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_PEDIDO', .F. ), aItens[ nInd ][ 04 ] )
		aItens[ nInd ][ 07 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_LOJENT', .F. ), aItens[ nInd ][ 07 ] )
		aItens[ nInd ][ 08 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_TRANSP', .F. ), aItens[ nInd ][ 08 ] )
		aItens[ nInd ][ 09 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_COND'  , .F. ), aItens[ nInd ][ 09 ] )
		aItens[ nInd ][ 10 ] := IIf( nPreSep == 1, CriaVar( 'CB7_AGREG' , .F. ), aItens[ nInd ][ 10 ] )

	Case nAglutPed == 1 .And. nAglutArm == 1 // Aglutina Pedido = Sim; Aglutina Armazem = Sim
		aItens[ nInd ][ 03 ] := IIf( lAglutArm .Or. nPreSep == 1, CriaVar( 'CB7_LOCAL' , .F. ), aItens[ nInd ][ 03 ] )
		aItens[ nInd ][ 06 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_PEDIDO', .F. ), aItens[ nInd ][ 04 ] )
		aItens[ nInd ][ 07 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_LOJENT', .F. ), aItens[ nInd ][ 07 ] )
		aItens[ nInd ][ 08 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_TRANSP', .F. ), aItens[ nInd ][ 08 ] )
		aItens[ nInd ][ 09 ] := IIf( lAglut .Or. nPreSep == 1, CriaVar( 'CB7_COND'  , .F. ), aItens[ nInd ][ 09 ] )
		aItens[ nInd ][ 10 ] := IIf( nPreSep == 1, CriaVar( 'CB7_AGREG' , .F. ), aItens[ nInd ][ 10 ] )

	EndCase

Next nInd

Return aItens
