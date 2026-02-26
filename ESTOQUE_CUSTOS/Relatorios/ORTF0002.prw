#INCLUDE "PROTHEUS.CH"
#Include "rwmake.Ch"
/*/{Protheus.doc} ORTF0001
//TODO Fun็ใo utilizada para alterar os campos E5_XUNID e E5_CCUSTO.
@author Pirolo
@since 02/04/2019
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function ORTF0002()

Private  cFilter  := ""
Private cCadastro := "Amarra็ใo Etiquetas Filhas"
Private aRotina   := { 	{"Pesquisar"			,"AxPesqui"			,0,1	},;
						{"Visualizar"			,"U_TELASZQ"		,0,2  	},;
      					{"Incluir"				,"U_TELASZQ"		,0,3	},;
             			{"Alterar"				,"U_TELASZQ"		,0,4	},;
            			{"Excluir"				,"U_TELASZQ"		,0,5	}}

Private cDelFunc  := ".T." 
Private oGDItens
Private cString   := "SZQ"
 
dbSelectArea("SZQ")
dbSetOrder(1)
dbSelectArea(cString)
mBrowse( 6, 1,22,75,"SZQ",,,,,, )

Return

/*/{Protheus.doc} TELASZQ
//TODO Monta a tela da amarra็ใo de produtos pais e filhos
@author Pirolo
@since 02/04/2019
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function TELASZQ(cAlias,nReg,nOpc)

Local bOk    	 := {||IIF( AtuSZQ(nOpc),oDlg:End(), )}
Local bCancel	 := {||(nOpca:=2,RollBackSX8()),oDlg:End()}
Local aExibe	 := {}
Local cAlias	 := "SZQ"
Local aButtons 	 := {}
Local nRecno	 := SZQ->(Recno())
Private nOpca	 := 0
Private oDlg
Private oFolder
Private oGDItens
Private aObjects := {}
Private aInfo    := {}
Private aPosGet  := {}
Private aPosObj  := {}

	RegToMemory(cAlias, nOpc = 3)

	If  nOpc == 2 //tratamento no ok da libera็ใo
		bOk := {||oDlg:End()}
		bCancel	:= {||oDlg:End()}    
	EndIf

	dbSelectArea("SX3")
	SX3->(DBSETORDER(1))
	SX3->(DBSEEK("SZQ", .T. ))
	DO WHILE !SX3->(EOF()) .AND. ( SX3->X3_ARQUIVO = "SZQ")
		IF SX3->X3_CONTEXT <> "V"  .AND. AllTrim(SX3->X3_CAMPO) $ "ZQ_FILIAL|ZQ_PRODPAI||"
		   AADD(aExibe,SX3->X3_CAMPO)
		ENDIF
		SX3->(DBSKIP())
	ENDDO

	AADD(aExibe,"NOUSER")		
	                     
	aSizeAut 	 := MsAdvSize()
	
	aAdd(aObjects,{100,60,.T.,.F.})
	aAdd(aObjects,{100,001,.T.,.F.})
	aAdd(aObjects,{100,100,.T.,.T.})
	
	aInfo 	:= {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
	aPosObj := MsObjSize(aInfo,aObjects)
	aPosGet := MsObjGetPos((aSizeAut[3]-aSizeAut[1]),315,{{004,024,240,270}} )
	
	Define MsDialog oDlg From aSizeAut[7],aSizeAut[1] TO aSizeAut[6],aSizeAut[5] Title OemToAnsi('Amarra็ใo Etiquetas Filhas') Of oMainWnd Pixel
	
	EnChoice(cAlias,nRecno,nOpc, , , ,aExibe,aPosObj[1],,2)
	oFolder := TFolder():New(aPosObj[3,1],aPosObj[3,2],{"METAS"},{"HEADER"},oDlg,,,,.T.,.F.,aPosObj[3,4]-aPosObj[3,2],aPosObj[3,3]-aPosObj[3,1])
	
	fItens(1,nOpc)
	
	Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel,,aButtons) Centered
	     
	//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
	//บVerifica se foi clicado em Cancelar e Libera a Numera็ao                 บ
	//ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
		
	If nOpca == 2            
	   RollBackSX8() 
	Endif

Return

/*/{Protheus.doc} function_method_class_name
//TODO Cria็ใo da parte inferior da tela
@author author
@since 02/04/2019
@version version
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
STATIC FUNCTION  fItens(nFolder,nOpc)

Local nSuperior    	:= 002           	// Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda    	:= 003           	// Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nLInf			:= aPosObj[3,3]-(aPosObj[3,1]+20)	// Distancia entre os totalizadores e a extremidade inferior do objeto
Local nInferior    	:= aPosObj[3,3]-(aPosObj[3,1]+30)	//+15 Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita     	:= aPosObj[3,4]-(aPosObj[3,2]+04) // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem

Local cLinhaOk     	:= "u_LinhaSZQ()" //Nil// Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= nIL // ".T."		// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= "+SZQ_ITEM"		// Nome dos campos do tipo caracter que utilizarao incremento automatico.Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do segundo campo>+..."                                                               
Local nFreeze      	:= Nil				// Campos estaticos na GetDados.                                                               
Local nMax         	:= 999				// Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "u_FIELDSZQ()"	// Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= Nil				// Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "u_ApgOkSZQ()"	// Funcao executada para validar a exclusao de uma linha do aCols                   
Local aHead        	:= {}				// Array a ser tratado internamente na MsNewGetDados como aHeader                    
Local aCol         	:= {}				// Array a ser tratado internamente na MsNewGetDados como aCols                        
Local aAlterGDa 	:= {"ZQ_PRODPAI","ZQ_PRODFIL","ZQ_ATIVO",'ZQ_QTDE' } 
Local nRecno := 0
	
	aCamposSim := {}
	AAdd(aCamposSim,{"ZQ_PRODFIL"	  ,""})
	//AAdd(aCamposSim,{"SZQ_TIPO" ,""})
	AAdd(aCamposSim,{"ZQ_QTDE"   ,""})
	AAdd(aCamposSim,{"ZQ_ATIVO" 	  ,""})

	If nOpc <> 2
		nOpc := GD_INSERT+GD_UPDATE // GD_INSERT+GD_DELETE+GD_UPDATE                                                                            
	else // caso contrario nao podera alterar campos nem apagar linhas
		nopc := 2
		cApagaOk := ""
		aAlterGDa := {}
	EndIf	                                	
	
	nRecno := SZQ->(RECNO())
	aHead	  := fHeader(aCamposSim)
	cChave    := xFilial("SZQ")+M->ZQ_PRODPAI
	cCondicao := "ZQ_FILIAL + ZQ_PRODPAI  == '"+cChave+"'"
	cFiltro   := ".T."
	aCol      := fCols(aHead,"SZQ",1,cChave,cCondicao,cFiltro)
	SZQ->(dbgoto(nRecno))
	oGDItens:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc+GD_DELETE,cLinhaOk,cTudoOk,cIniCpos,aAlterGDa,nFreeze,nMax,cCampoOk,cApagaOk,cApagaOk,oFolder:aDialogs[nFolder],aHead,aCol)                                   
	oGDItens:oBrowse:refresh()	

Return

/*/{Protheus.doc} fHeader
//TODO Monta o aHeader.
@author Pirolo
@since 02/04/2019
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function fHeader(aCamposSim)

Local nPos,aTabAux,aHeader:={}

dbSelectArea("SX3")
dbSetOrder(2)
For nPos:=1 to Len(aCamposSim)
	If SX3->(dbSeek(PadR(AllTrim(aCamposSim[nPos,1]),Len(X3_CAMPO))))
		aTabAux:={}
		AAdd(aTabAux,TRIM(x3Titulo()))
		AAdd(aTabAux,x3_campo        )
		AAdd(aTabAux,x3_picture      )
		AAdd(aTabAux,x3_tamanho      )
		AAdd(aTabAux,x3_decimal      )
		AAdd(aTabAux,""              ) 
		AAdd(aTabAux,x3_usado        )
		AAdd(aTabAux,x3_tipo         )
		AAdd(aTabAux,x3_f3           )
		AAdd(aTabAux,x3_context      )
		AAdd(aTabAux,x3_cbox         )
		AAdd(aTabAux,x3_relacao      )
 		AAdd(aTabAux,x3_when         )
		AAdd(aTabAux,x3_visual       )
		AAdd(aTabAux,X3_VLDUSER      )
		AAdd(aTabAux,X3_PICTVAR      )
		AAdd(aTabAux,X3_OBRIGAT      )
		AAdd(aHeader,aTabAux         )
	EndIf
Next

dbSetOrder(1)

Return(AClone(aHeader))

/*/{Protheus.doc} fCols
//TODO Monta linhas do GetDados.
@author Bruno
@since 02/04/2019
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function fCols(aHeader,cAlias,nIndice,cChave,cCondicao,cFiltro)

Local nPos,aCols0,aCols:={}
Local cAliasAnt:=Alias()

dbSelectArea(cAlias)

(cAlias)->(DbSetOrder(nIndice))
(cAlias)->(DbSeek(cChave,.t.))
While (cAlias)->(!Eof() .and. &cCondicao)
	If !(cAlias)->(&cFiltro)
 		(cAlias)->(DbSkip())
  		Loop
 	EndIf
 	aCols0:={}
	For nPos:=1 to Len(aHeader)
		If !aHeader[nPos,10]=="V" 
   			(cAlias)->(AAdd(aCols0,FieldGet(FieldPos(aHeader[nPos,2]))))
  		Else
			(cAlias)->(AAdd(aCols0,CriaVar(aHeader[nPos,2])))
		EndIf
	 Next
 	AAdd(aCols0,.F.  ) 
 	AAdd(aCols,aCols0)
 	(cAlias)->(DbSkip())
End

If Empty(aCols)
	aCols0:={}
	For nPos:=1 to Len(aHeader)
		(cAlias)->(AAdd(aCols0,CriaVar(aHeader[nPos,2])))
		if alltrim(aHeader[nPos,2]) == "SZQ_ITEM"
			aCols0[nPos] := "001"
		Endif

	Next
	AAdd(aCols0,.F.  ) 
	AAdd(aCols,aCols0)
EndIf

aCols0:={}
For nPos:=1 to Len(aHeader)
	(cAlias)->(AAdd(aCols0,CriaVar(aHeader[nPos,2])))
Next
AAdd(aCols0,.F.  )

dbSelectArea(cAliasAnt)

Return(AClone(aCols))
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIELDSZQ  บAutor  ณAlex Miranda        บ Data ณ  25/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEfetua a valida็ใo dos campos no momento em que se preenche บฑฑ
ฑฑบ          ณos mesmos na getdados										  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FIELDSZQ()
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณApgOkSZQ  บAutor  ณAlex Miranda        บ Data ณ  25/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo que inverte a marca็ใo da linha do getdados          บฑฑ
ฑฑบ          ณ(Deletado/Ativo)											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ApgOkSZQ()
	aCols[N][Len(aCols[N])] := !aCols[N][Len(aCols[N])]	
	oGDItens:oBrowse:refresh()	

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLinhaSZQ  บAutor  ณAlex Miranda        บ Data ณ  25/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEfetua a valida็ใo da linha no momento em que se preenche   บฑฑ
ฑฑบ          ณos mesmos na getdados										  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                      
User Function LinhaSZQ()

Local lRet		:= .T.
Local cNomInd	:= ""
Local cDesc		:= ""
Local cTipo		:= ""
Local dData		:= ctod("  /  /  ")
Local nMeta		:= 0
Local cProdFil	:= ""
Local nPosProd  := aScan(oGDItens:aHeader,{|x|UPPER(Alltrim(x[2])) == "ZQ_PRODFIL"})
Local nPosQtde  := aScan(oGDItens:aHeader,{|x|UPPER(Alltrim(x[2])) == "ZQ_QTDE"})
Local nPosAtiv	:= aScan(oGDItens:aHeader,{|x|UPPER(Alltrim(x[2])) == "ZQ_ATIVO"})

cProdFil		:= oGDItens:aCols[oGDItens:nAt][nPosProd]

If Empty(cProdFil)
	lRet := .F.
	Alert("Produto filho nใo preenchido, verifique.")
EndIf

If AllTrim(cProdFil) == AllTrim(M->ZQ_PRODPAI)
	lRet := .F.
	Alert("Produto filho nใo pode ser o mesmo que o pai, verifique.")
EndIf

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuSZQ    บAutor  ณAlex Miranda        บ Data ณ  25/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina que efetua a gera็ใo dos registros da tabela PDL	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION AtuSZQ(nOpc)
Local lRet := .F.
Local nPos	:= 0
	                  
	If nOpc <> 5
		If Empty(M->ZQ_PRODPAI)
			Alert("Codigo do produto pai nใo informado. Verifique.")
			Return lRet
		EndIf
	EndIf

	Begin Transaction
		If nOpc == 4
			DbSelectArea("SZQ")
			SZQ->(DbSetOrder(1))//SZQ_FILIAL+SZQ_COD+SZQ_ITEM
			
			aCols := aclone(oGDItens:aCols)    			
			aHeader := aclone(oGDItens:aHeader)
			
			For nPos:=1 to Len(aCols)                        
				If SZQ->(DbSeek(xFilial("SZQ")+M->SZQ_COD+aCols[nPos,1]))
					SZQ->(RecLock("SZQ",.F.))
				Else
					SZQ->(RecLock("SZQ",.T.))
				EndIf

				SZQ->ZQ_FILIAL  := xFilial("SZQ")
				SZQ->ZQ_PRODPAI	:= M->SZQ_COD
				SZQ->ZQ_PRODFIL	:= aCols[nPos,1]				
				SZQ->ZQ_ATIVO   := M->SZQ_DESC
				SZQ->ZQ_QTDE	:= M->SZQ_TIPO
				
				//Verifica se ้ uma exclusใo						
				If aCols[nPos,Len(aHeader)+1]
					SZQ->(DbDelete())
				EndIf
				
				SZQ->(MsUnLock())
			Next     
			oDlg:End()
		Else
			dbSelectArea("SZQ")
			SZQ->(dbSetOrder(1))
			If SZQ->(dbSeek(xFilial("SZQ") + alltrim(M->ZQ_PRODPAI))) //If SZQ->(dbSeek(xFilial("SZQ") + M->ZQ_PRODPAI))
				DO WHILE !SZQ->(EOF()) .AND. (ALLTRIM(SZQ->ZQ_FILIAL+SZQ->ZQ_PRODPAI) == ALLTRIM(XFILIAL("SZQ")+M->ZQ_PRODPAI))
				    RECLOCK("SZQ",.F.)
				    	SZQ->(DBDELETE())
				    SZQ->(MSUNLOCK())
					SZQ->(DBSKIP())  
					lRet := .T.
				ENDDO
			EndIf
			If nopc <> 5
				aCols := aclone(oGDItens:aCols)    			
				aHeader := aclone(oGDItens:aHeader)
				For nPos:=1 to Len(aCols)                        
					If !aCols[nPos,Len(aHeader)+1]
						SZQ->(RecLock("SZQ",.T.))
						SX3->(DBSETORDER(1))
						SX3->(DBSEEK("SZQ", .T. ))
						DO WHILE !SX3->(EOF()) .AND. ( SX3->X3_ARQUIVO = "SZQ" )
							IF SX3->X3_CONTEXT <> "V"
							    cCampo    := "SZQ->"+SX3->X3_CAMPO
							    cConteudo := "M->"+SX3->X3_CAMPO
					 			 &cCampo   := &cConteudo
							ENDIF
							SX3->(DBSKIP())
						ENDDO					
						SZQ->ZQ_FILIAL := xFILIAL("SZQ")
						lRet := fGravaTudo("SZQ",aHeader,aCols[nPos])
						SZQ->(MsUnLock())
				     EndIf
				Next     
			EndIf		
			ConfirmSX8()
	
		EndIf
	
	End Transaction

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGravaTudoบAutor  ณAlex Miranda        บ Data ณ  25/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina que grava os dados da GetDados						  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGravaTudo(cAlias,aHeader,aCols)

Local nPos,cCampo
Local cRespPad := ""

For nPos:=1 to Len(aHeader)

	cCampo:=aHeader[nPos,2]
	    
	(cAlias)->(&cCampo):=aCols[nPos]
	
Next

Return(.T.)


/*/{Protheus.doc} RFATA25
//TODO Tela para impressใo de etiquetas.
@author Pirolo
@since 02/05/2019
@return return, return_description
/*/
User Function ORTF002A()	
Local _cOP 		:= ""
Local _cLang	:= ""
Local _nQtd 	:= 1
Local _nQtd2 	:= 0
Local _nQtd3	:= 1
Local _aCbx 	:= {"1-Portugu๊s", "2-Ingl๊s", "3-Espanhol"}
Local _dDtFab	:= nil

//RpcSetType(3)
//RpcSetEnv("01", "01")

_dDtFab	:= dDatabase
_cOP 	:= Space(LEN(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))

Private oDlg1, oOP, oLang, oQtde, oSair

DEFINE MSDIALOG oDlg1 TITLE "Impressใo de Etiquetas" FROM 200,70 TO 425,450 PIXEL
@ 003, 4 To 110,187
@ 010, 10 SAY "Ordem de Produ็ใo " 	SIZE 70,50
@ 030, 10 SAY "Idioma " 			SIZE 50,50
@ 050, 10 SAY "Qtde. Etiquetas" 	SIZE 50,50
@ 070, 10 SAY "Data Fabrica็ใo "	SIZE 50,50

@ 010, 060 MSGET 		oOP  	VAR _cOP 	F3 "SC2" PICTURE "@!" VALID ValidOP(_cOP) SIZE 80,7 OF oDlg1 PIXEL
@ 030, 060 MSCOMBOBOX 	oLang 	VAR _cLang  ITEMS _aCbx SIZE 075, 65 OF oDlg1 PIXEL
@ 050, 060 MSGET 		oQtde	VAR _nQtd	PICTURE "999" SIZE 20,7 OF oDlg1 PIXEL
@ 070, 060 MSGET 		oDtFab	VAR _dDtFab	PICTURE "@D" VALID !Empty(_dDtFab) SIZE 60,7 OF oDlg1 PIXEL

@ 090, 050 Button oOK  	Prompt "Imprimir" 	Size 25, 13 Action ChkOpc(_cOP, _cLang, _nQtd2, _dDtFab, _NQTD) OF oDlg1 PIXEL
@ 090, 140 Button oSair	Prompt "Sair" 		Size 25, 13 Action Close(oDlg1) OF oDlg1 PIXEL

ACTIVATE MSDIALOG oDlg1 CENTERED

DlgRefresh(oDlg1)

Return


/*/{Protheus.doc} ChkOpc
//TODO Rotina que dispara a impressใo das etiquetas conforme parametros indicados pelo cliente.
@author Pirolo
@since 02/05/2019
@param _cNumOP, , Numero da OP
@return return, return_description
/*/
Static Function ChkOpc(_cNumOP, _cLang, _nQtd2, _dDtFab, _NQTD)
Local nI := 0

dbSelectArea("SC2")
dbSetOrder(1)
If dbSeek(xFilial("SC2")+(Substr(_cNumOP,1,8)+'001'))

	_nLang := Val(SubStr(_cLang,1,1))
	
	_nQuant := SC2->C2_QUANT
	dbSelectArea("SB1")
	dbSetOrder(1)
/*
	If SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		_nQtdEmb := SB1->B1_XQE
	EndIf
	If FieldPos("B1_XQTETIQ") <> 0
		dbSelectArea("SB5")
		dbSetOrder(1)
		If dbSeek(xFilial("SB5")+SB1->B1_COD)
			_nQtdEmb := SB5->B5_QEI
		Else
			_nQtdEmb := 1
		EndIf
	EndIf

	If _nQtd2 <> 0
		_nQtdEmb := _nQtd2
	EndIf
	*/
	
	DbSelectArea("SZQ")
	SZQ->(DbSetOrder(1))
    
    For nI := 1 to _nQtd
    	//Pega a quantidade de impress๕es necessarias
    	nQtdImp := POSICIONE( "SB1", 1, xFilial("SB1")+SC2->C2_PRODUTO, "B1_XQTETIQ" )
    	
    	//Prote็ใo para o caso de nใo existir o produto cadastrado
    	nQtdImp	:= Iif(ValType(nQtdImp)=="N" .AND. nQtdImp > 0, nQtdImp, 1)
    	
    	//PEGA A QUANTIDADE DE EMBALAGENS
    	_nQtdEmb := POSICIONE( "SB1", 1, xFilial("SB1")+SC2->C2_PRODUTO, "B1_XQE" )
    	_nQtdEmb := Iif(_nQtdEmb == 0, 1, _nQtdEmb)
    	
    	
    	//Imprime o produto pai
    	RptStatus({|lEnd| U_RESTR25Imp(.F.,SC2->C2_PRODUTO,SC2->C2_LOTECTL, _nQtdEmb, "",_dDtFab,dDatabase, nQtdImp/*_nQtd*/,_nLang, .T.)},"Imprimindo, aguarde...")

    	//Verificar se possui produtos filhos e imprime
		If SZQ->(DbSeek(xFilial("SZQ")+SC2->C2_PRODUTO))
			While SZQ->(!Eof() .AND. AllTrim(ZQ_PRODPAI) == AllTrim(SC2->C2_PRODUTO))
				If SZQ->ZQ_ATIVO == "S"
				
			    	//Pega a quantidade de impress๕es necessarias
					nQtdImp := POSICIONE( "SB1", 1, xFilial("SB1")+SZQ->ZQ_PRODFIL, "B1_XQTETIQ" )
					
					//Prote็ใo para o caso de nใo existir o produto cadastrado
					nQtdImp	:= Iif(ValType(nQtdImp)=="N" .AND. nQtdImp > 0, nQtdImp, 1)

			    	//PEGA A QUANTIDADE DE EMBALAGENS
			    	_nQtdEmb := POSICIONE( "SB1", 1, xFilial("SB1")+SZQ->ZQ_PRODFIL, "B1_XQE")
			    	_nQtdEmb := Iif(_nQtdEmb == 0, 1, _nQtdEmb)

					RptStatus({|lEnd| U_RESTR25Imp(.F., SZQ->ZQ_PRODFIL, SC2->C2_LOTECTL, _nQtdEmb, "", _dDtFab, dDatabase, nQtdImp, _nLang)},"Imprimindo etiquetas filhas, aguarde...")
				EndIf
				SZQ->(DbSkip())
			End
		EndIf
    Next nI
EndIf

_cOP 		:= Space(LEN(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
_nLang	:= 1
_nQtd 	:= 1

Return()

Static Function ValidOP(_cNumOP)

If Empty(_cNumOP)
	Return(.T.)
EndIf

dbSelectArea("SC2")
dbSetOrder(1)
If !dbSeek(xFilial("SC2")+(Substr(_cNumOP,1,8)+'001'))
	Alert("Ordem de Produ็ao nao Encontrada...")
	Return(.F.)
EndIf

Return(.T.)
