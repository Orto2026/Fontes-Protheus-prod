#include "protheus.ch"
 
 
User Function MBrw2Sx5()
 
Local cAlias 		:= "SX5"
 
Private cCadDil		:= "Arquivo de Tabelas"
Private aRotina 	:= {}
Private cDelFunc	:= ".T." // Validacao para a exclusao. Pode-se //utilizar ExecBlock
Private aReg       	:= {}
AADD(aRotina,{"Pesquisar"   ,"AxPesqui"  ,0,1})
AADD(aRotina,{"Visualizar"  ,"U_SX52AEV" ,0,2})
AADD(aRotina,{"Incluir"		,"U_SX52Inc" ,0,3})
AADD(aRotina,{"Alterar"		,"U_SX52AEV" ,0,4})
AADD(aRotina,{"Excluir"		,"U_SX52AEV" ,0,5})
 
dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse( 6,1,22,75,cAlias)
 
Return
 
 
User Function SX52INC(cAlias,nReg,nOpc)
 
Local oDlg
Local oTPan01
Local oTPan02                    
Local nOpca        	:= 0
Local aCpoEncho	   	:= {"NOUSER","X5_TABELA"}
Local aArea        	:= GetArea()
Local nX 			:=0
 
Private aHeader    	:= {}
Private aCols      	:= {}
Private aReg       	:= {}
Private oGet
 
Private aSvAtela	:= {{}} 
Private aSvAGets	:= {{}}  
Private aTela		:= {}
Private aGets		:= {}
Private nOpx := 3
 
U_C05HEADER(cAlias,{"X5_TABELA"})  
U_C05COLS(cAlias, nReg, nOpc)
 
DEFINE MSDIALOG oDlg TITLE cCadDil From 8,0 To 32,85 OF oMainWnd
   	aTela := {}
	aGets := {}
	RegToMemory("SX5") 
	For nx:= 1 to SX5->(FCOUNT())
		CCAMPO := SX5->(FIELDNAME(NX))
&("M->"+ CCAMPO) := SPACE(TAMSX3(CCAMPO)[1]) 
	Next
	MsMGet():New("SX5" ,,3,,,,aCpoEncho,{20, 0, 90, 400},,,,,,oDlg,,,.F.,,.T.)
	oGet :=	MsNewGetDados():New(90,0,178,340,nOpc,"U_C05OK()", "AllWaysTrue()",,,,,,,,oDlg,aHeader,@aCols,,) 
	oGet:lDelete  := Iif(nOpc==3,.T.,oGet:lDelete) //Criado essa função, pois nao estava permitindo alterar os itens.
	ACTIVATE MSDIALOG oDlg ;
	ON INIT EnchoiceBar(oDlg,{||nOpc:=3,; 
									If(U_C05TOK(nOpc), ; 
										If (!U_C05IGRV(),; 
											nOpca:=0,;
											oDlg:End()),;
										nOpca:=0)},;
									{||nOpca:=0,oDlg:End()}) CENTERED    
 
RestArea(aArea)  
Return
 
 
User Function SX52AEV(cAlias,nReg,nOpc)
 
Local oDlg
Local oTPan01
Local oTPan02                    
Local nOpca        := 0  
Local cProd        := ""
Local aCpoEncho	   := {"NOUSER","X5_TABELA"}
Local aArea        := GetArea()
 
Private aHeader    := {}
Private aCols      := {}
Private aReg       := {}  
Private nOpx       := 2
Private oGet       
 
SX5->(dbGoTo( nReg ))
 
U_C05HEADER(cAlias,{"X5_TABELA"})
U_C05COLS(cAlias, nReg, nOpc)
 
DEFINE MSDIALOG oDlg TITLE cCadDil From 8,0 To 32,85 OF oMainWnd
 
RegToMemory("SX5")
 
MsMGet():New("SX5" ,,3,,,,aCpoEncho,{12, 0, 90, 400},,,,,,oDlg,,,.F.,,.T.)
 
If nOpc == 4
	oGet :=	MsNewGetDados():New(90,0,178,340,nOpc,"U_C05OK()", "AllWaysTrue()",,,,,,,,oDlg,aHeader,@aCols,,)
	oGet:lUpdate  := Iif(nOpc==4,.T.,oGet:lUpdate) //Criado essa função, pois nao estava permitindo alterar os itens.
	oGet:lInsert  := Iif(nOpc==4,.T.,oGet:lUpdate) //Criado essa função, pois nao estava permitindo alterar os itens.
Else
	oGet :=	MsNewGetDados():New(90,0,178,340,nOpc,"U_C05OK()", "AllWaysTrue()",,,,,,,,oDlg,aHeader,@aCols,,)
EndIf                          
 
If nOpc == 4
 
	ACTIVATE MSDIALOG oDlg ;
	ON INIT EnchoiceBar(oDlg,{||nOpc:=4,; 
									If(U_C05TOK(nOpc), ;
										If (!U_C05AGRV(),;
											nOpca:=0,;
											oDlg:End()),;
										nOpca:=0)},;
									{||nOpca:=0,oDlg:End()}) CENTERED    
Else   
	ACTIVATE MSDIALOG oDlg ON INIT ;
	EnchoiceBar(oDlg,{|| (Iif(nOpc==4, C05AGRV(),; 
	Iif (nOpc==5, U_C05EGRV(), oDlg:End())),oDlg:End())},;  
	{|| oDlg:End()}) CENTERED  
 
EndIf
 
RestArea(aArea)  
 
Return
 
 
User Function C05HEADER(cAlias,aCmpUse)
 
Local aArea := GetArea()
 
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)
 
While !Eof() .AND. X3_ARQUIVO = cAlias
	  If (aScan(aCmpUse,AllTrim(SX3->X3_CAMPO)) == 0) .AND. X3Uso(X3_USADO) .AND. cNivel >= X3_NIVEL
	  		AADD(aHeader, {Trim(X3Titulo()),;
	  		X3_CAMPO,;    
	  		X3_PICTURE,;
	  		X3_TAMANHO,;
	  		X3_DECIMAL,;
	  		X3_VALID,;
	  		X3_USADO,;
	  		X3_TIPO,;
	  		X3_F3,;
	  		X3_CONTEXT,;
	  		X3_CBOX,;
	  		X3_RELACAO,;
	  		X3_WHEN,;
	  		X3_VISUAL,;
	  		X3_VLDUSER,;
	  		X3_PICTVAR,;
	  		X3_OBRIGAT})
	  EndIf
	  SX3->(dbSkip())
EndDo         
 
RestArea(aArea)
 
Return
 
 
User Function C05COLS(cAlias, nReg, nOpc)
 
Local aArea    := GetArea()  
Local cChv     := SX5->X5_TABELA
Local nI       := 0
 
If nOpc <> 3
	SX5->(dbSetOrder(1)) 		
	SX5->(dbSeek(xFilial(cAlias)+cChv)) 
	While !SX5->(Eof()) .AND. ;
	SX5->(X5_FILIAL+X5_TABELA) == xFilial(cAlias) + cChv
		 aAdd(aReg , SX5->(RecNo()))
		 aAdd(aCols, Array(Len(aHeader) + 1 ) )
		 For nI := 1 to Len(aHeader)
		 	If aHeader[nI,10] == "V"
		 		aCols[Len(aCols),nI] := CriaVar(aHeader[nI,2],.T.)
		 	Else
		 		aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
		 	EndIf
		 Next nI 
		 aCols[Len(aCols),Len(aHeader)+1] := .F.
		 SX5->(dbSkip())        
	EndDo
Else 
	aAdd(aCols,Array(Len(aHeader) + 1))
	For nI := 1 to Len(aHeader)
			aCols[1,nI] := CriaVar(aHeader[nI,2], .T.)   
	Next nI   
		aCols[1, Len( aHeader )+1 ]        := .F.
 
EndIf
 
RestArea(aArea)
 
Return
 
 
User Function C05OK()
 
Local lRet   	:= .T.
Local cMens  	:= "Não será permitido o cadastro sem a Tabela."  
Local cCadDil 	:= "Tabela Generica."
 
If !aCols[n,Len(aHeader)+1]
	If Empty(M->X5_TABELA)
		MsgAlert(cMens,cCadDil)
		lRet := .F.
	EndIf  
EndIf  
 
Return(lRet)
 
 
User Function C05TOK(nOpc)
 
Local lRet  := .T. 
Local cProd := ""
Local aArea    := GetArea()
 
If Empty(M->X5_TABELA) 
	ShowHelpDlg("Campos obrigatorios",{"Campos obrigatórios não preenchidos.",},5,;
                                  {"Preencha os campos obrigatorios"},5)    
	lRet :=  .F.	
EndIf
RestArea(aArea)
 
Return lRet
 
 
User Function C05IGRV()
 
Local aArea    := GetArea()
Local nI       := 0
Local nX       := 0   
Local cDiv     := .F.
 
aCols := aClone(oGet:aCols)
 
SX5->(dbSetOrder(1)) 
For nI := 1 to Len(aCols) 
	If !aCols[nI,Len(aHeader)+1] 
		RecLock ("SX5",.T.)
			SX5->X5_FILIAL   := xFilial("SX5")
			SX5->X5_TABELA  := M->X5_TABELA
			For nX := 1 to Len(aHeader)
				FieldPut(FieldPos(aHeader[nX,2]),aCols[nI,nX])
			Next nX
		MsUnLock()
	EndIf
Next nI
 
RestArea(aArea)
 
Return .T.
 
 
User Function C05AGRV()
 
Local aArea  := GetArea()
Local nI     := 0
Local nX     := 0
 
aCols := aClone(oGet:aCols)
 
For nI := 1 to Len(aCols)
	If nI <= Len(aReg)
		SX5->(dbGoTo(aReg[nI]))
		RecLock ("SX5",.F.)
			If aCols[nI,Len(aHeader)+1]
				dbDelete()
			EndIf
	Else
		RecLock ("SX5",.T.)        
	EndIf
	If !aCols[nI,Len(aHeader)+1]
		SX5->X5_FILIAL  := xFilial("SX5")
		SX5->X5_TABELA := M->X5_TABELA
		For nX:=1 to Len(aHeader)
			FieldPut(FieldPos(aHeader[nX,2]),aCols[nI,nX])
		Next nX
	EndIf
	MsUnLock()
Next nI
 
RestArea(aArea)		
 
Return .T.
 
 
 
User Function C05EGRV()
 
Local nI := 0
 
For nI := 1 to Len(aCols)
	SX5->(dbGoTo(aReg[nI]))
	RecLock("SX5",.F.)
		dbDelete()
	MsUnLock()
Next nI
 
Return
