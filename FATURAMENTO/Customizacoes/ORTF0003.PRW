#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'TOPCONN.CH'
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADMETA   บAutor  ณAlex Miranda        บ Data ณ  25/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMbrowse do cadastro de metas          					  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                           
User Function ORTF0003()

Private  cFilter  := ""
Private cCadastro := "Cadastro de Metas"
Private aRotina   := { 	{"Pesquisar"			,"AxPesqui"			,0,1	},;
						{"Visualizar"			,"U_TELAMETA"		,0,2  	},;
      					{"Incluir"				,"U_TELAMETA"		,0,3	},;
             			{"Alterar"				,"U_TELAMETA"		,0,4	},;
            			{"Excluir"				,"U_TELAMETA"		,0,5	}}

Private cDelFunc  := ".T." 
Private oGDItens
Private cString   := "SZR"
 
dbSelectArea("SZR")
dbSetOrder(1)
dbSelectArea(cString)
mBrowse( 6, 1,22,75,"SZR",,,,,, )

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTELAMETA  บAutor  ณAlex Miranda        บ Data ณ  25/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo de criacao da tela de cadastro de metas              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TELAMETA(cAlias,nReg,nOpc)

Local bOk    	 := {||IIF( AtuSZR(nOpc),oDlg:End(), )}
Local bCancel	 := {||(nOpca:=2,RollBackSX8()),oDlg:End()}
Local aExibe	 := {}
Local cAlias	 := "SZR"
Local aButtons 	 := {}
Local nRecno	 := SZR->(Recno())
Private nOpcx	 := nOpc

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
	SX3->(DBSEEK("SZR", .T. ))
	DO WHILE !SX3->(EOF()) .AND. ( SX3->X3_ARQUIVO = "SZR" )
		IF SX3->X3_CONTEXT <> "V" .AND. (ALLTRIM(SX3->X3_CAMPO) $ "ZR_FILIAL|ZR_DEPARTA")
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
	
	Define MsDialog oDlg From aSizeAut[7],aSizeAut[1] TO aSizeAut[6],aSizeAut[5] Title OemToAnsi('Cadastro de Metas') Of oMainWnd Pixel
	
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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfItens    บAutor  ณAlex Miranda        บ Data ณ  25/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria็ใo da parte inferior da tela (getdados)				  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION  fItens(nFolder,nOpc)

Local nSuperior    	:= 002           	// Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda    	:= 003           	// Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nLInf			:= aPosObj[3,3]-(aPosObj[3,1]+20)	// Distancia entre os totalizadores e a extremidade inferior do objeto
Local nInferior    	:= aPosObj[3,3]-(aPosObj[3,1]+30)	//+15 Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita     	:= aPosObj[3,4]-(aPosObj[3,2]+04) // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem

Local cLinhaOk     	:= "u_LinhaSZR()" //Nil// Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= nIL // ".T."		// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= "+ZR_ITEM"		// Nome dos campos do tipo caracter que utilizarao incremento automatico.Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do segundo campo>+..."                                                               
Local nFreeze      	:= Nil				// Campos estaticos na GetDados.                                                               
Local nMax         	:= 999				// Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "u_FIELDSZR()"	// Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= Nil				// Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "u_ApgOkSZR()"	// Funcao executada para validar a exclusao de uma linha do aCols                   
Local aHead        	:= {}				// Array a ser tratado internamente na MsNewGetDados como aHeader                    
Local aCol         	:= {}				// Array a ser tratado internamente na MsNewGetDados como aCols                        
Local aAlterGDa 	:= {"ZR_DATA","ZR_META","ZR_REALIZ","ZR_RECALC","ZR_OBS", "ZR_TIPO" } 
Local nRecno := 0
	
	aCamposSim := {}
	AAdd(aCamposSim,{"ZR_DATA"	  ,""})
	AAdd(aCamposSim,{"ZR_TIPO" ,""})
	AAdd(aCamposSim,{"ZR_META"   ,""})
	AAdd(aCamposSim,{"ZR_REALIZ" 	  ,""})
	AAdd(aCamposSim,{"ZR_RECALC" 	  ,""})
	AAdd(aCamposSim,{"ZR_OBS" ,""})

	If nOpc <> 2
		nOpc := GD_INSERT+GD_UPDATE // GD_INSERT+GD_DELETE+GD_UPDATE                                                                            
	else // caso contrario nao podera alterar campos nem apagar linhas
		nopc := 2
		cApagaOk := ""
		aAlterGDa := {}
	EndIf	                                	
	
	nRecno := SZR->(RECNO())
	aHead	  := fHeader(aCamposSim)
	cChave    := xFilial("SZR")+M->ZR_DEPARTA 
	cCondicao := "ZR_FILIAL + ZR_DEPARTA  == '"+cChave+"'"
	cFiltro   := ".T."
	aCol      := fCols(aHead,"SZR",1,cChave,cCondicao,cFiltro)
	SZR->(dbgoto(nRecno))
	oGDItens:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc+GD_DELETE,cLinhaOk,cTudoOk,cIniCpos,aAlterGDa,nFreeze,nMax,cCampoOk,cApagaOk,cApagaOk,oFolder:aDialogs[nFolder],aHead,aCol)                                   
	oGDItens:oBrowse:refresh()	

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfHeader   บAutor  ณAlex Miranda        บ Data ณ  25/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o aHeader para montagem do GetDados					  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCols     บAutor  ณAlex Miranda        บ Data ณ  25/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta as linhas da GetDados								  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
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
		if alltrim(aHeader[nPos,2]) == "ZR_ITEM"
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
ฑฑบPrograma  ณFIELDSZR  บAutor  ณAlex Miranda        บ Data ณ  25/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEfetua a valida็ใo dos campos no momento em que se preenche บฑฑ
ฑฑบ          ณos mesmos na getdados										  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FIELDSZR()
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณApgOkSZR  บAutor  ณAlex Miranda        บ Data ณ  25/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo que inverte a marca็ใo da linha do getdados          บฑฑ
ฑฑบ          ณ(Deletado/Ativo)											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ApgOkSZR()
	aCols[N][Len(aCols[N])] := !aCols[N][Len(aCols[N])]	
	oGDItens:oBrowse:refresh()	

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLinhaSZR  บAutor  ณAlex Miranda        บ Data ณ  25/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEfetua a valida็ใo da linha no momento em que se preenche   บฑฑ
ฑฑบ          ณos mesmos na getdados										  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                      
User Function LinhaSZR()

Local lRet 		 := .T.
Local cNomInd	 := ""
Local cDesc 	 := ""
Local cTipo 	 := ""
Local dData      := ctod("  /  /  ")
Local nMeta      := 0

//Local nPosTipo   := aScan(oGDItens:aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_TIPO"})
Local nPosData   := aScan(oGDItens:aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_DATA"})
Local nPosMeta   := aScan(oGDItens:aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_META"})

//cTipo 	:= oGDItens:aCols[oGDItens:nAt][nPosTipo]
dData 	:= oGDItens:aCols[oGDItens:nAt][nPosData]
nMeta 	:= oGDItens:aCols[oGDItens:nAt][nPosMeta]

//If Empty(cTipo)
	//lRet := .F.
	//Alert("Informe o tipo da meta.")
//EndIf

If Empty(dData) .And. M->ZR_TIPO <> 'M'
	lRet := .F.
	Alert("Informe a data da meta.")
EndIf

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuSZR    บAutor  ณAlex Miranda        บ Data ณ  25/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina que efetua a gera็ใo dos registros da tabela PDL	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION AtuSZR(nOpc)
Local 	lRet	:= .F.
Local 	nPos	:= 0
Loca	cDepart	:= ""
/*
If nOpc <> 5
	
	aCols := aclone(oGDItens:aCols)    			
	aHeader := aclone(oGDItens:aHeader)

	For nPos:=1 to Len(oGDItens:aCols)                        
		If oGDItens:aCols[nPos][len(oGDItens:aCols[nPos])]
			If 
		EndIf
	Next nPos
EndIf
                  
	If nOpc <> 5
		If Empty(M->ZR_NOMIND) .Or. Empty(M->ZR_DESC)
			Alert("Codigo do Indicador ou descri็ใo nใo informado. Informe.")
			Return lRet
		EndIf
	EndIf
*/
	Begin Transaction
		If nOpc == 3 .or. nOpc ==  4 .or. nOpc ==  5
			
			cDepart := Iif(nOpc == 4, SZR->ZR_DEPARTA, M->ZR_DEPARTA)
			
			dbSelectArea("SZR")
			SZR->(dbSetOrder(1))
			If SZR->(dbSeek(xFilial("SZR") + cDepart)) 
				DO WHILE !SZR->(EOF()) .AND. (ALLTRIM(SZR->ZR_FILIAL+SZR->ZR_DEPARTA) == ALLTRIM(XFILIAL("SZR")+cDepart))
				    RECLOCK("SZR",.F.)
				    	SZR->(DBDELETE())
				    SZR->(MSUNLOCK())
					SZR->(DBSKIP())  
					lRet := .T.
				ENDDO
			EndIf
			If nopc <> 5
				aCols := aclone(oGDItens:aCols)    			
				aHeader := aclone(oGDItens:aHeader)
				For nPos:=1 to Len(aCols)                        
					If !aCols[nPos,Len(aHeader)+1]
						SZR->(RecLock("SZR",.T.))
						SX3->(DBSETORDER(1))
						SX3->(DBSEEK("SZR", .T. ))
						DO WHILE !SX3->(EOF()) .AND. ( SX3->X3_ARQUIVO = "SZR" )
							IF SX3->X3_CONTEXT <> "V"
							    cCampo    := "SZR->"+SX3->X3_CAMPO
							    cConteudo := "M->"+SX3->X3_CAMPO
					 			&cCampo   := &cConteudo
							ENDIF
							SX3->(DBSKIP())
						ENDDO					
						SZR->ZR_FILIAL := xFILIAL("SZR")
						lRet := fGravaTudo("SZR",aHeader,aCols[nPos])
						SZR->(MsUnLock())
				     EndIf
				Next     
			EndIf		
			//ConfirmSX8()
	
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

User Function VlzSRZDp(cCampo)
Local lRet 		:= .T.
Local aAreaSZR	:= SZR->(GetArea())
If cCampo == "ZR_DEPARTA"

	If nOpcx == 3 //Incluir
		DbSelectArea("SZR")
		DbSetOrder(1)
		If SZR->(DbSeek(xFilial("SZR")+M->ZR_DEPARTA))
			Alert("Departamento informado jแ existe, por favor verifique.")
			lRet := .F.
		EndIf
	ElseIf nOpcx == 4 //Alterar
	
	EndIf
	
EndIf

Return lRet