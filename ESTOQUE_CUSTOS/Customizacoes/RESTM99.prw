#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK			2   
#define CMD_ACTIVEWORKSHEET		3    
#define CMD_READCELL				4
#include "protheus.ch"
#include "topconn.ch"
#DEFINE GD_INSERT	1
#DEFINE GD_DELETE	4	
#DEFINE GD_UPDATE	2
#DEFINE c_BR CHR(13)+CHR(10)

Static lProcess := .F.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RESTM01  ºAutor  ³Raphael Camillo     º Data ³  21/02/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao de Movimento Interno via excel                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ThinkFast                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTM99()

Local cType			:=	"Arquivos XLS|*.XLS|Todos os Arquivos|*.*"
Local aRegs			:= {}
Local cPerg			:= Padr("RESTM99",Len(SX1->X1_GRUPO))

Private cArq		:= ""
Private oProcess  := MsNewProcess():New({|lEnd| CarrXLS()(lEnd)},"Carregando dados","Carregando...",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona o arquivo                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArq := cGetFile(cType, OemToAnsi("Selecione a planilha excel com as informações da Movimentação Interna."),0,"",.F.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)

If Empty(cArq)
	Aviso("Inconsistência","Selecione a planilha excel com as informações da Movimentação Interna.",{"Ok"},,"Atenção:")
	Return()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria os parametros da rotina                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aRegs,{cPerg,"01","Folder Planilha ?"	,"","","mv_ch1","C",30,0,0,"G","NaoVazio()"					   		,"MV_PAR01","","","","",	"","","","","","","","","","","","","","","","","","","","","","","","","" })
Aadd(aRegs,{cPerg,"02","Linha Inicial  ?"		,"","","mv_ch2","N",05,0,0,"G","NaoVazio() .and. Entre(2,65536)"	,"MV_PAR02","","","","",	"","","","","","","","","","","","","","","","","","","","","","","","","" })
Aadd(aRegs,{cPerg,"03","Linha Final  ?"		,"","","mv_ch3","N",05,0,0,"G","NaoVazio() .and. Entre(2,65536)"	,"MV_PAR03","","","","",	"","","","","","","","","","","","","","","","","","","","","","","","","" })

CriaSx1(aRegs)                  

If !Pergunte(cPerg,.T.)
	Return
Endif           

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ativa o processo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !lProcess
	oProcess:Activate()
EndDo

Return                                                    
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CarrXLS   ºAutor  ³Vinícius Gregório   º Data ³  21/02/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                
Static Function CarrXLS()
Local nLoopDad		:= 0
Local aDados		:= {}
Local nVlr			:= 0
Local aPosObj    	:= {} 
Local oDlgMain		:= Nil
Local nOpcA			:= 0
Local aObjects		:= {}  
Local aSize      	:= MsAdvSize() 
Local aCampos		:= {}
Local cErro			:= ""//Posição para guardar ql o erro de validação dakla posição
Local nTM			:= 1
Local nPROD			:= 2 
Local nQTDE  			:= 3
Local nCUSTO			:= 4
Local nLOCAL			:= 5
Local nLOTECTL			:= 6
Local nX, i

Private aColsVar 		:= {} 
Private oGetDad		:= Nil
Private aHeaderVar	:= {} 
Private nColsArquiv	:= 0

//inicia o processo
lProcess	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a interface com o excel                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ               
aDados := GetExcel(cArq,Alltrim(MV_PAR01),Padr("A",2)+Alltrim(Str(MV_PAR02)),Padr("N",2)+Alltrim(Str(MV_PAR03)))
If Len(aDados) == 0                                         
	Aviso("Inconsistência","Não foi localizado um retorno para a planilha informada.",{"Ok"},,"Atenção:")
	Return()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os campos a serem exibidos                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCampos,{"A1_OBSERV"		,"V","Arquivo"})//posição para o nome do arquivo
Aadd(aCampos,{"D3_TM"			,"V",OemToAnsi("Tipo da Movimentacao")})
Aadd(aCampos,{"D3_COD"			,"V",OemToAnsi("Produto")})
Aadd(aCampos,{"D3_CUSTO1"		,"V",OemToAnsi("Valor")})
Aadd(aCampos,{"D3_QUANT"		,"V",OemToAnsi("Quantidade")})
Aadd(aCampos,{"D3_LOCAL"		,"V",OemToAnsi("Armazem")})
Aadd(aCampos,{"D3_LOTECTL"		,"V",OemToAnsi("Lote")})
Aadd(aCampos,{"AH1_OBSERV"		,"V",OemToAnsi("Observação")})//posição para a descrição do problema

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o aHeader da tabela de Medicoes                						     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeadVar := {}
For nX := 1 to Len(aCampos)
	DbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	If SX3->(DbSeek(aCampos[nX,1],.F.))
		Aadd(aHeaderVar,{	aCampos[nX,3],;
						aCampos[nX,1],; 
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_F3,;
						SX3->X3_CONTEXT,;
						SX3->X3_CBOX,;
						"",;
						SX3->X3_WHEN,;
						aCampos[nX,2],;
						SX3->X3_VLDUSER,;
						SX3->X3_PICTVAR,;
						SX3->X3_OBRIGAT})
	Endif	
Next nX                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as variáveis de posições do aColsVar³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nColsArquiv	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "A1_OBSERV"	})
nColsTM		:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "D3_TM"		})
nColsPROD	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "D3_COD"		})
nColsCUSTO	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "D3_CUSTO1"  	})
nColsQTDE	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "D3_QUANT"		})
nColsLOCAL	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "D3_LOCAL"		})
nColsLOTECTL	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "D3_LOTECTL"	})
nColsObs		:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "AH1_OBSERV" })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o aColsVar                                       					    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                
oProcess:SetRegua1(len(aDados))
For nX	:= 1 to len(aDados)

	oProcess:IncRegua1("Processando linha: "+Alltrim(STR(nX))+" ...")
	cErro		:= ""                   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe algo carregado³
	//³para essa coluna.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If Empty(Alltrim(aDados[nX][3]))
		Loop
	Endif
	
	Aadd(aColsVar,Array(Len(aHeaderVar)+1))
	For i := 1 To Len(aHeaderVar)
		aColsVar[Len(aColsVar)][i]	:= CriaVar(aHeaderVar[i,2],.F.)
	Next i	                                          

	aColsVar[Len(aColsVar)][nColsArquiv]			:= cArq//nome do arquivo		
	aColsVar[Len(aColsVar)][Len(aHeaderVar)+1] 	:= .F.//seta o Deleted como .F.
	_lSF5 := .F.
	_cVal := "" // Movto Valorizado
	_cZer	:= "" // Movto Zerado

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³valida as posições do aDados e adiciona no aColsVar³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nLoopDad := 1 to Len(aDados[nX])                         
      
		If nLoopDad==nTM
			aColsVar[Len(aColsVar)][nColsTM]	:= Alltrim(aDados[nX][nTM])
			
			DbSelectArea("SF5")
			DbSetOrder(1)
			If !MsSeek(xFilial("SF5")+Alltrim(aDados[nX][nTM]))
				cErro += OemToAnsi("Tipo de Movimento Nao Cadastrado."+Alltrim(aDados[nX][nTM]))
			Else
				_lSF5 := .T.
				_cVal := SF5->F5_VAL 		// Movto Valorizado  S=SIm / N=Nao // String
				_cZer	:= SF5->F5_QTDZERO 	// Movto Zerado		1=Sim / 2=Nao // String
			EndIf	
			
		ElseIf nLoopDad==nPROD
			aColsVar[Len(aColsVar)][nColsPROD]	:= Alltrim(aDados[nX][nPROD])

			DbSelectArea("SB1")
			DbSetOrder(1)
			If !MsSeek(xFilial("SB1")+Alltrim(aDados[nX][nPROD]))
				cErro += OemToAnsi("Produto Nao Cadastrado."+Alltrim(aDados[nX][nPROD]))
			Else
				If SB1->B1_MSBLQL == '1'
					cErro += OemToAnsi("Produto Bloqueado."+Alltrim(aDados[nX][nPROD]))
				EndIf
			EndIf	

		ElseIf nLoopDad==nQTDE

			nVlr :=Val(STRTRAN(STRTRAN(STRTRAN(aDados[nX][nQTDE],".",""),",","."),chr(160),""))
			aColsVar[Len(aColsVar)][nColsQTDE]	:= nVlr
			If _lSF5 
				If _cZer <> "1" .And. nVlr == 0
					cErro += OemToAnsi("Qtde nao informado para TM com Quantidade.")
				EndIf
			EndIf

		ElseIf nLoopDad==nCUSTO

			nVlr :=Val(STRTRAN(STRTRAN(STRTRAN(aDados[nX][nCUSTO],".",""),",","."),chr(160),""))              
			aColsVar[Len(aColsVar)][nColsCUSTO]	:= nVlr

			If _lSF5 
				If _cVal == "S" .And. nVlr == 0
					cErro += OemToAnsi("Valor do Custo nao informado para TM Valorizado.")
				EndIf
			EndIf
		
		ElseIf nLoopDad==nLOCAL
			aColsVar[Len(aColsVar)][nColsLOCAL]	:= Alltrim(aDados[nX][nLOCAL])

			
		
		ElseIf nLoopDad==nLOTECTL
			aColsVar[Len(aColsVar)][nColsLOTECTL]	:= Alltrim(aDados[nX][nLOTECTL])

		EndIf 

	Next nLoopDad
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se cErro estiver preenchido³
	//³joga o valor na Observação ³
	//³e marca a posição do array ³
	//³como deletado.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(Alltrim(cErro))
		aColsVar[Len(aColsVar)][nColsObs]				:= cErro
		aColsVar[Len(aColsVar)][Len(aHeaderVar)+1]	:= .T.//seta o Deleted como .F.			
	Endif	

Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a tela de exibicao do resultado da importacao                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDlgMain := TDialog():New(aSize[7],00,aSize[6],aSize[5],"Mocimentos Internos a importar",,,,,,,,oMainWnd,.T.)

aObjects 	:= {} 
AAdd( aObjects, { 100, 100, .T., .T. } )

aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj 	:= MsObjSize( aInfo, aObjects ) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a GetDados de variaveis                        						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetDad := MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],(aPosObj[1,3]-aPosObj[1,1])+25,(aPosObj[1,4]-aPosObj[1,2]),GD_UPDATE+GD_DELETE,,,,,,9999,,,,oDlgMain,@aHeaderVar,@aColsVar)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tela de resumo da importação³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDlgMain:Activate(,,,,,,{||EnchoiceBar(oDlgMain,{||(nOpcA := 1, aColsVar := oGetDad:aCols, oDlgMain:End())},{||(nOpcA := 0, oDlgMain:End())},,)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava as informacoes                                 						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcA == 1
	Processa({|lEnd| GeraTM() },"Gerando Movimentos...")
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GravaDA1 ºAutor  ³Raphael Camillo     º Data ³  21/02/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava os registros da SD3 via EXECAUTO                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraTM()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaração de variáveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nX		:= 0

Local nProcess  	:= 0
Local aCab   := {}
Local aItens := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas no lancamento padrao                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oProcess:SetRegua1(len(aColsVar))
For nX := 1 to len(aColsVar)     

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pula se estiver "deletado"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aColsVar[nX][Len(aHeaderVar)+1]
		Loop
	Endif 

	oProcess:IncRegua1("Importando registro: ")	                   
	nProcess++

	If (Len(aCab) == 0)
		aCab:= {;
		{"D3_TM"			, AllTrim(aColsVar[nX][nColsTM]) 	,NIL},;
		{"D3_EMISSAO"	,	dDataBase								,NIL},;
		{"D3_CC"		 	,	""											,NIL}}
	EndIf
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+AllTrim(aColsVar[nX][nColsPROD]) )
	
	aAdd(aItens,{ 	;
	{"D3_COD"    , SB1->B1_COD										,NIL},;
	{"D3_UM"     , SB1->B1_UM										,NIL},;
	{"D3_LOCAL"  , aColsVar[nX][nColsLOCAL]							,NIL},;
	{"D3_LOTECTL"  , aColsVar[nX][nColsLOTECTL]						,NIL},;
	{"D3_LOCALIZ"  , "AJUSTE"										,NIL},;
	{"D3_QUANT"  , aColsVar[nX][nColsQTDE]							,NIL},;
	{"D3_CUSTO1" , aColsVar[nX][nColsCUSTO]							,Nil}})


Next nX        

lMsErroAuto := .F.

If (Len(aItens) > 0)

	MSExecAuto({|x,y,z| mata241(x,y,z)},aCab,aItens,3) //Inclusao
	
	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
		Return
	Else
		Aviso("Atencao","Gerado a Movimento Interno. Doc "+SD3->D3_DOC,{"Ok"})
	EndIf
EndIf

				
Return .T.
                          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma   ³GetExcel  º Autor ³ Jaime Wikanski            ºData³04.11.2002º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao  ³Funcao para leitura e retorno em um array do conteudo         º±±
±±º           ³de uma planilha excel                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetExcel(cArqPlan,cPlan,cCelIni,cCelFim)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                             		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aReturn		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa a interface de leitura da planilha excel                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| aReturn := LeExcel(cArqPlan,cPlan,cCelIni,cCelFim)} ,"Planilha Excel")
Return(aReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma   ³LeExcel   º Autor ³ Jaime Wikanski            ºData³04.11.2002º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao  ³Funcao para leitura e retorno em um array do conteudo         º±±
±±º           ³de uma planilha excel                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LeExcel(cArqPlan,cPlan,cCelIni,cCelFim)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                             		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aReturn		:= {}
Local nLin			:= 0
Local nCol			:= 0
Local nLinIni		:= 0
Local nLinFim		:= 0
Local nColIni		:= 0
Local nColFim		:= 0
Local nMaxLin		:= 0
Local nMaxCol		:= 0
Local cDigCol1		:= ""
Local cDigCol2		:= ""
Local nHdl 			:= 0
Local cBuffer		:= "'
Local cCell 		:= ""     
Local cFile			:= ""
Local nPosIni		:= 0
Local aNumbers		:= {"0","1","2","3","4","5","6","7","8","9"}
Local nX			:= 0
Local nColArr		:= 0
Default cArqPlan	:= ""
Default cPlan		:= ""
Default cCelIni		:= ""
Default cCelFim		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida os parametros informados pelo usuario        		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cArqPlan)
	Aviso("Inconsistência","Informe o diretório e o nome da planilha a ser processada.",{"Sair"},,"Atenção:")
	Return(aReturn)
Endif
If Empty(cPlan)
	Aviso("Inconsistência","Informe nome do Folder da planilha a ser processada.",{"Sair"},,"Atenção:")
	Return(aReturn)
Endif
If Empty(cCelIni)
	Aviso("Inconsistência","Informe a referência da célula inicial a ser processada.",{"Sair"},,"Atenção:")
	Return(aReturn)
Endif
If Empty(cCelFim)
	Aviso("Inconsistência","Informe a referência da célula final a ser processada.",{"Sair"},,"Atenção:")
	Return(aReturn)
Endif
If !File(cArqPlan)
	Aviso("Inconsistência","Não foi possível localizar a planilha "+Alltrim(cArqPlan)+" especificada.",{"Sair"},,"Atenção:")
	Return(aReturn)
Else
	cFile := Alltrim(cArqPlan)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Copia a DLL de interface com o excel                		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !CpDllXls()
	Return(aReturn)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa a coordenada inicial da celula             		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosIni	:= 0
For nX := 1 to Len(Alltrim(cCelIni))
	If aScan(aNumbers, Substr(cCelIni,nX,1)) > 0
		nPosIni	:= nX
		Exit
	Endif
Next nX
If nPosIni == 0
	Aviso("Inconsistência","Não foi possivel determinar a referência numérica da linha inicial a ser processada. Verifique a referência da célula inicial informada.",{"Sair"},,"Atenção:")
	Return(aReturn)
Endif
nLinIni := Val(Substr(cCelIni,nPosIni,(Len(cCelIni)-nPosIni)+1))

cDigCol1 := Alltrim(Substr(cCelIni,1,nPosIni-1))
If Len(cDigCol1) == 2
	cDigCol1 	:= Substr(cCelIni,1,1)
	cDigCol2 	:= Substr(cCelIni,2,1)
	nColIni		:= ((Asc(cDigCol1)-64)*26) + (Asc(cDigCol2)-64) 
Else
	cDigCol1 	:= Substr(cCelIni,1,1)
	cDigCol2 	:= ""
	nColIni		:= Asc(cDigCol1)-64
Endif             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa a coordenada final   da celula             		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosIni	:= 0
For nX := 1 to Len(Alltrim(cCelFim))
	If aScan(aNumbers, Substr(cCelFim,nX,1)) > 0
		nPosIni	:= nX
		Exit
	Endif
Next nX
If nPosIni == 0
	Aviso("Inconsistência","Não foi possivel determinar a referência numérica da linha final a ser processada. Verifique a referência da célula final informada.",{"Sair"},,"Atenção:")
	Return(aReturn)
Endif
nLinFim := Val(Substr(cCelFim,nPosIni,(Len(cCelFim)-nPosIni)+1))

cDigCol1 := Alltrim(Substr(cCelFim,1,nPosIni-1))
If Len(cDigCol1) == 2
	cDigCol1 	:= Substr(cCelFim,1,1)
	cDigCol2 	:= Substr(cCelFim,2,1)
	nColFim		:= ((Asc(cDigCol1)-64)*26) + (Asc(cDigCol2)-64) 
Else
	cDigCol1 	:= Substr(cCelFim,1,1)
	cDigCol2 	:= ""
	nColFim		:= Asc(cDigCol1)-64
Endif             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Determina o total de linhas e colunas               		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMaxLin := nLinFim - nLinIni + 1
nMaxCol := nColFim - nColIni + 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre a DLL de interface excel                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdl := ExecInDLLOpen(Alltrim(GetMv("MV_DRDLLXLS",,"c:\apexcel"))+'\readexcel.dll')

If nHdl < 0
	Aviso("Inconsistência","Não foi possível carregar a DLL de interface com o Excel (readexcel.dll).",{"Sair"},,"Atenção:")
	Return(aReturn)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega o excel e abre o arquivo                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBuffer := cFile+Space(512)
nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida se abriu a planilha corretamente                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nBytes < 0
	Aviso("Inconsistência","Não foi possível abrir a planilha Excel solicitada ("+Alltrim(cFile)+").",{"Sair"},,"Atenção:")
	Return(aReturn)
ElseIf nBytes > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Erro critico na abertura do arquivo com msg de erro						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aviso("Inconsistência","Não foi possível abrir a planilha Excel solicitada ("+Alltrim(cFile)+"). "+Chr(13)+Chr(10)+"Erro interno: "+Subs(cBuffer, 1, nBytes),{"Sair"},,"Atenção:")
	Return(aReturn)
EndIf                           
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona a worksheet                                  					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBuffer := Alltrim(cPlan)+Space(512)
nBytes 	:= ExeDLLRun2(nHdl,CMD_ACTIVEWORKSHEET,@cBuffer)   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida se selecionou o worksheet solicitado                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nBytes < 0
	Aviso("Inconsistência","Não foi possível selecionar a WorkSheet solicitada ("+Alltrim(cPlan)+") na planilha Excel ("+Alltrim(cFile)+").",{"Sair"},,"Atenção:")
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
	Return(aReturn)
ElseIf nBytes > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Erro critico na abertura do arquivo com msg de erro						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aviso("Inconsistência","Não foi possível selecionar a WorkSheet solicitada ("+Alltrim(cPlan)+") na planilha Excel ("+Alltrim(cFile)+")."+Chr(13)+Chr(10)+"Erro interno: "+Subs(cBuffer, 1, nBytes),{"Sair"},,"Atenção:")
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
	Return(aReturn)
EndIf                           

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a regua de processamento                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua(nMaxLin*nMaxCol)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o array com todas as coordenadas necessarias   		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLin := nLinIni to nLinFim
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona no array a linha a ser importada                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aReturn, Array(nMaxCol))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processa as colunas da linha atual                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nColArr := 0
	For nCol := nColIni to nColFim
		nColArr++	
		If Int((nCol/26)-0.01) > 0
			cDigCol1 := Chr(Int((nCol/26)-0.01)+64)
		Else
			cDigCol1 := " "
		Endif
		If nCol - (Int((nCol/26)-0.01)*26) > 0
			cDigCol2 := Chr((nCol - (Int((nCol/26)-0.01)*26))+64)
		Else
			cDigCol2 := " "
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Incrementa a regua de processamento                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncProc("Importando planilha...")                                

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Compoe a coordenada da celula a ser importada                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCell := Alltrim(cDigCol1)+Alltrim(cDigCol2)+Alltrim(Str(nLin))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Realiza a leitura da celula no excel                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cBuffer	:= cCell+Space(1024)
		nBytes 	:= ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
		nPos		:= 1
		If nColArr == 4 .And. ASC(Subs(cBuffer,1,1)) = 160
			nPos := 2
		EndIf
		aReturn[Len(aReturn),nColArr] := Subs(cBuffer, nPos, nBytes)
	Next nCol
Next nLin

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha a interface com o excel                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBuffer := Space(512)
ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
ExecInDLLClose(nHdl)

Return(aReturn)
                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CpDllXls  ºAutor  ³Jaime Wikanski      º Data ³  05/17/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para copiar a DLL para a estação do usuario          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CpDllXls()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDirDest	:= Alltrim(GetMv("MV_DRDLLXLS",,"c:\apexcel"))
Local nResult	:= 0
Local lReturn	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o diretorio de destino da DLL na estacao do usuario                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lIsDir(cDirDest)
	nResult := MakeDir(cDirDest)
Endif
If nResult <> 0
	Aviso("Inconistência","Não foi possível criar o diretório "+cDirDest+" para a DLL de leitura da planilha Excel.",{"Sair"},,"Atenção:")
	lReturn := .F.
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Copia a DLL para o diretorio na estacao do usuario                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !File("ReadExcel.dll")
		Aviso("Inconistência","Não foi possível localizar a DLL de leitura da planilha excel (ReadExcel.dll) no diretório SYSTEM ou SIGAADV.",{"Sair"},,"Atenção:")
		lReturn := .F.
	Else		
		If !File(cDirDest+"\ReadExcel.dll")
			COPY FILE ("ReadExcel.dll") TO (cDirDest+"\ReadExcel.dll")
			If !File(cDirDest+"\ReadExcel.dll")
				Aviso("Inconistência","Não foi possível copiar a DLL de leitura da planilha excel para o diretório "+cDirDest+".",{"Sair"},,"Atenção:")
				lReturn := .F.
			Endif
		Endif
	Endif
Endif

Return(lReturn)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RATVM01   ºAutor  ³Microsiga           º Data ³  12/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaSx1(aRegs)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(aRegs[nY,1]+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)
