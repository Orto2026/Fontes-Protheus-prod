#Include "PROTHEUS.Ch"
#define STR0001  "Este programa ir  imprimir o Raz„o Contabil,"
#define STR0002  "de acordo com os parametros solicitados pelo"
#define STR0003  "usu rio."
#define STR0004  "Zebrado"
#define STR0005  "Administracao"
#define STR0006  "Emissao do Razao Contabil"
#define STR0015  "***** CANCELADO PELO OPERADOR *****"
#define STR0016  "CONTA - "
#define STR0017  "Selecionando Registros..."
#define STR0018  "Criando Arquivo Tempor rio..."		

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RCTBR06  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05.02.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o do Raz„o                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBR400()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Copia do CTBR400 Para Geracao de Arquivo XLS               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCTBR06(	cContaIni, cContaFim, dDataIni, dDataFim, cMoeda, cSaldos,;
					cBook, lCusto, cCustoIni, cCustoFim, lItem, cItemIni, cItemFim,;
					lClVl, cClvlIni, cClvlFim)

Local aCtbMoeda	:= {}

Local cDesc1		:= STR0001	//"Este programa ir  imprimir o Raz„o Contabil,"
Local cDesc2		:= STR0002	// "de acordo com os parametros solicitados pelo"
Local cDesc3		:= STR0003	// "usuario."
Local cString		:= "CT2"
Local titulo		:= STR0006 	//"Emissao do Razao Contabil"
Local lAnalitico 	:= .T.
Local lRet			:= .T.
Local lExterno		:= cContaIni <> Nil
Local nTamLinha		:= 220
Local nTamCta		:= Len(CriaVar ("CT1_CONTA"))

Local WnRel			:= "RCTBR06"
DEFAULT lCusto		:= .F.
DEFAULT lItem		:= .F.
DEFAULT lCLVL		:= .F.

Private aReturn	:= { STR0004, 1,STR0005, 2, 2, 1, "", 1 }  //"Zebrado"###"Administracao"

Private cPerg		:= "CTR400    "

Private nomeprog	:= "RCTBR06"
Private nLastKey	:= 0

Private Tamanho 	:= "G"
Private lCodImp		:= .F.

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

lCodImp := AjCodImpX1("CTR400","11",3)			//// AJUSTA O SX1 PARA USAR O CODIGO DE IMPRESSAO DO PLANO DE CONTAS
If ! lExterno
	If ! Pergunte("CTR400", .T.)
		Return
	Endif
Else
	Pergunte("CTR400", .F.)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // da conta                              ³
//³ mv_par02            // ate a conta                           ³
//³ mv_par03            // da data                               ³
//³ mv_par04            // Ate a data                            ³
//³ mv_par05            // Moeda			                     ³   
//³ mv_par06            // Saldos		                         ³   
//³ mv_par07            // Set Of Books                          ³
//³ mv_par08            // Analitico ou Resumido dia (resumo)    ³
//³ mv_par09            // Imprime conta sem movimento?          ³
//³ mv_par10            // Junta Contas com mesmo C.Custo?       ³
//³ mv_par11            // Impr Cod (Normal/Reduzida/Cod.Impress)³ /// VER CT1_CODIMP
//³ mv_par12            // Imprime C.Custo?                      ³
//³ mv_par13            // Do Centro de Custo                    ³
//³ mv_par14            // At‚ o Centro de Custo                 ³
//³ mv_par15            // Imprime Item?	                     ³	
//³ mv_par16            // Do Item                               ³
//³ mv_par17            // Ate Item                              ³
//³ mv_par18            // Imprime Classe de Valor?              ³	
//³ mv_par19            // Da Classe de Valor                    ³
//³ mv_par20            // Ate a Classe de Valor                 ³
//³ mv_par21            // Salto de pagina                       ³
//³ mv_par22            // Pagina Inicial                        ³
//³ mv_par23            // Pagina Final                          ³
//³ mv_par24            // Numero da Pag p/ Reiniciar            ³	   
//³ mv_par25            // Imprime Cod C.Custo(Normal / Reduzido)³
//³ mv_par26            // Imprime Cod Item (Normal / Reduzido)  ³
//³ mv_par27            // Imprime Cod Cl.Valor(Normal /Reduzida)³
//³ mv_par28            // Imprime Total Geral (Sim/Nao)         ³
//³ mv_par29            // So Livro/Livro e Termos/So Termos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lAnalitico	:= Iif(mv_par08 == 1,.T.,.F.)
lCusto 		:= Iif(mv_par12 == 1,.T.,.F.)
lItem		:= Iif(mv_par15 == 1,.T.,.F.)
lCLVL		:= Iif(mv_par18 == 1,.T.,.F.)  
nTamLinha	:= Iif(lAnalitico, 220, 132)

wnrel := SetPrint(cString,wnrel,If(! lExterno, cPerg,),@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
//Verifica se o relatorio foi chamado a partir de outro programa. Ex. CTBC400
If ! lExterno
	lCusto 		:= Iif(mv_par12 == 1,.T.,.F.)
	lItem			:= Iif(mv_par15 == 1,.T.,.F.)
	lCLVL			:= Iif(mv_par18 == 1,.T.,.F.)
Else  //Caso seja externo, atualiza os parametros do relatorio com os dados passados como parametros.
	mv_par01 := cContaIni
	mv_par02 := cContaFim
	mv_par03 := dDataIni
	mv_par04 := dDataFim
	mv_par05 := cMoeda
	mv_par06 := cSaldos
	mv_par07 := cBook
	mv_par12 := If(lCusto =.T.,1,2)
	mv_par13 := cCustoIni
	mv_par14 := cCustoFim
	mv_par15 := If(lItem =.T.,1,2)
	mv_par16 := cItemIni
	mv_par17 := cItemFim
	mv_par18 := If(lClVl =.T.,1,2)
	mv_par19 := cClVlIni
	mv_par20 := cClVlFim
Endif
lAnalitico	:= Iif(mv_par08 == 1,.T.,.F.)

nTamLinha	:= If( lAnalitico, 220, 132)

If nLastKey = 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books -> Conf. da Mascara / Valores   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Ct040Valid(mv_par07)
	lRet := .F.
Else
	aSetOfBook := CTBSetOf(mv_par07)
EndIf

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par05)
   If Empty(aCtbMoeda[1])
      Help(" ",1,"NOMOEDA")
      lRet := .F.
   Endif
Endif

If !lRet	
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR400Imp(@lEnd,wnRel,cString,aSetOfBook,lCusto,lItem,lCLVL,;
	   	lAnalitico,Titulo,nTamlinha,aCtbMoeda, nTamCta)})
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CTR400Imp ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao do Razao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³Ctr400Imp(lEnd,wnRel,cString,aSetOfBook,lCusto,lItem,;      ³±±
±±³           ³          lCLVL,Titulo,nTamLinha,aCtbMoeda)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd       - A‡ao do Codeblock                             ³±±
±±³           ³ wnRel      - Nome do Relatorio                             ³±±
±±³           ³ cString    - Mensagem                                      ³±±
±±³           ³ aSetOfBook - Array de configuracao set of book             ³±±
±±³           ³ lCusto     - Imprime Centro de Custo?                      ³±±
±±³           ³ lItem      - Imprime Item Contabil?                        ³±±
±±³           ³ lCLVL      - Imprime Classe de Valor?                      ³±± 
±±³           ³ Titulo     - Titulo do Relatorio                           ³±±
±±³           ³ nTamLinha  - Tamanho da linha a ser impressa               ³±± 
±±³           ³ aCtbMoeda  - Moeda                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR400Imp(lEnd,WnRel,cString,aSetOfBook,lCusto,lItem,lCLVL,lAnalitico,Titulo,nTamlinha,;
						aCtbMoeda,nTamCta)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aSaldo		:= {}
Local CbTxt
Local cbcont
Local Cabec1		:= ""
Local Cabec2		:= ""

Local cSaldo		:= mv_par06
Local cContaIni		:= mv_par01
Local cContaFIm		:= mv_par02
Local cCustoIni		:= mv_par13
Local cCustoFim		:= mv_par14
Local cItemIni		:= mv_par16
Local cItemFim		:= mv_par17
Local cCLVLIni		:= mv_par19
Local cCLVLFim		:= mv_par20
Local cContaAnt		:= ""
Local dDataAnt		:= CTOD("  /  /  ")
Local cCodRes		:= ""
Local cResCC		:= ""
Local cResItem		:= ""
Local cResCLVL		:= ""
Local cDescSint		:= ""
Local cMoeda		:= mv_par05
Local cContaSint	:= ""
Local cArqTmp
Local cSayCusto		:= CtbSayApro("CTT")
Local cSayItem		:= CtbSayApro("CTD")
Local cSayClVl		:= CtbSayApro("CTH")
Local cNormal 		:= ""
Local dDataIni		:= mv_par03
Local dDataFim		:= mv_par04
Local lNoMov		:= Iif(mv_par09==1,.T.,.F.)
Local lJunta		:= Iif(mv_par10==1,.T.,.F.)
Local lImpLivro		:=.t.
Local lImpTermos	:=.f.

aCampos := {}
aAdd(aCampos,{"DATAL"    ,"D",08,0})
aAdd(aCampos,{"CONTA"    ,"C",30,0})
aAdd(aCampos,{"DESCRICAO","C",40,0})
aAdd(aCampos,{"DOCUMENTO","C",18,0})
aAdd(aCampos,{"HISTORICO","C",80,0})
aAdd(aCampos,{"C_PARTIDA","C",30,0})
aAdd(aCampos,{"CCUSTO"   ,"C",02,0})
aAdd(aCampos,{"ITEM_CTA" ,"C",20,0})
aAdd(aCampos,{"DEBITO"   ,"N",17,2})
aAdd(aCampos,{"CREDITO"  ,"N",17,2})
aAdd(aCampos,{"SALDO_ATU","N",17,2})

cArqTrab := CriaTrab(aCampos,.T.)
DbUseArea(.T.,__LocalDriver,cArqTrab,"TRB",.F.,.F.)
_cChave := "CONTA+DTOS(DATAL)+DOCUMENTO"
IndRegua("TRB",cArqTrab,_cChave,,," Criando Consulta ... ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao de Termo / Livro                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case mv_par29==1 ; lImpLivro:=.t. ; lImpTermos:=.f.
	Case mv_par29==2 ; lImpLivro:=.t. ; lImpTermos:=.t.
	Case mv_par29==3 ; lImpLivro:=.f. ; lImpTermos:=.t.
EndCase		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80

If lImpLivro
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Arquivo Temporario para Impressao   					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTBGerRaz(oMeter,oText,oDlg,lEnd,@cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
				cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
				aSetOfBook,lNoMov,cSaldo,lJunta,"1",lAnalitico,,,aReturn[7])},;
				STR0018,;		// "Criando Arquivo Tempor rio..."
				STR0006)		// "Emissao do Razao"
    
	dbSelectArea("CT2") 
	If !Empty(dbFilter())
		dbClearFilter()
	Endif
          
	dbSelectArea("cArqTmp")
	SetRegua(RecCount())                                      
	dbGoTop()
Endif

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial 
//nao esta disponivel e sai da rotina.
If lImpLivro
	If cArqTmp->(RecCount()) == 0 .And. !Empty(aSetOfBook[5])                                       
		dbCloseArea("cArqTmp")
		FErase(cArqTmp+GetDBExtension())
		FErase(cArqTmp+OrdBagExt())	
		Return
	Endif
EndIf

While lImpLivro .And. !Eof()

	IF lEnd
		@Prow()+1,0 PSAY STR0015  //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()
                                                                                     
	aSaldo := SaldoCT7(cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)
	
	If !lNoMov //Se imprime conta sem movimento
		If aSaldo[6] == 0 .And. cArqTmp->LANCDEB ==0 .And. cArqTmp->LANCCRD == 0 
			dbSelectArea("cArqTmp")
			dbSkip()
			Loop
		Endif	
	Endif             
		
	nSaldoAtu := aSaldo[6]                                           
	dbSelectArea("cArqTmp")
	cContaAnt:= cArqTmp->CONTA
	dDataAnt	:= CTOD("  /  /  ")
	While cArqTmp->(!Eof()) .And. cArqTmp->CONTA == cContaAnt
		
		If dDataAnt != cArqTmp->DATAL
			dDataAnt := cArqTmp->DATAL
		EndIf	
		
		If lAnalitico		//Se for relatorio analitico
			nSaldoAtu 	:= nSaldoAtu - cArqTmp->LANCDEB + cArqTmp->LANCCRD
		
			dbSelectArea("CT1")
			dbSetOrder(1)
			MsSeek(xFilial()+cArqTmp->XPARTIDA)
			cCodRes := CT1->CT1_RES
			dbSelectArea("cArqTmp")

			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->CONTA		:= Transform(cArqTmp->CONTA,"@R 9.9.9.99.99999")
			_cBusca := " "
			_cBusca := IIF(!Empty(cArqTmp->ITEM),cArqTmp->ITEM,cArqTmp->CONTA)
			TRB->DESCRICAO	:= Posicione("CT1",1,xFilial("CT1")+_cBusca,"CT1_DESC01")
			TRB->DATAL		:= cArqTmp->DATAL
			TRB->DOCUMENTO	:= cArqTmp->LOTE+cArqTmp->SUBLOTE+cArqTmp->DOC+cArqTmp->LINHA
			TRB->HISTORICO 	:= cArqTmp->HISTORICO
			TRB->C_PARTIDA	:= cArqTmp->XPARTIDA
			TRB->CCUSTO		:= cArqTmp->CCUSTO
			TRB->ITEM_CTA	:= cArqTmp->ITEM
			TRB->DEBITO		:= cArqTmp->LANCDEB
			TRB->CREDITO	:= cArqTmp->LANCCRD
			TRB->SALDO_ATU	:= nSaldoAtu*-1
			MsUnlock()
	
			// Procura pelo complemento de historico
			dbSelectArea("CT2")
			dbSetOrder(10)
			If MsSeek(xFilial()+DTOS(cArqTMP->DATAL)+cArqTmp->LOTE+cArqTmp->SUBLOTE+;
													   cArqTmp->DOC+cArqTmp->SEQLAN)
				dbSkip()         
				If CT2->CT2_DC == "4"			//// TRATAMENTO PARA IMPRESSAO DAS CONTINUACOES DE HISTORICO
					While !Eof() .And. CT2->CT2_FILIAL == xFilial() 			.And.;
										CT2->CT2_LOTE == cArqTMP->LOTE 		.And.;
										CT2->CT2_SBLOTE == cArqTMP->SUBLOTE 	.And.;
										CT2->CT2_DOC == cArqTmp->DOC 			.And.;
										CT2->CT2_SEQLAN == cArqTmp->SEQLAN 	.And.;
										CT2->CT2_DC == "4" 					.And.;
								   DTOS(CT2->CT2_DATA) == DTOS(cArqTmp->DATAL)                        
						dbSelectArea("TRB")
						RecLock("TRB",.F.)
						TRB->HISTORICO 	:= AllTrim(TRB->HISTORICO) + CT2->CT2_HIST
						MsUnlock()
						dbSelectArea("CT2")
						dbSkip()
					EndDo	
				EndIf	
			EndIf	
			dbSelectArea("cArqTmp")
			dbSkip()			
		Endif
		dbSelectArea("cArqTmp")
	EndDo
EndDo	 
         
If lImpLivro
	dbSelectArea("cArqTmp")
	Set Filter To
	dbCloseArea()
	If Select("cArqTmp") == 0
		//FErase(cArqTmp+GetDBExtension())
		//FErase(cArqTmp+OrdBagExt())
	EndIf	
Endif

dbSelectArea("TRB")
Set Filter To
_cArqXls		:= "RAZAO_"+Dtos(dDataBase)+SubStr(Time(),1,2)+SubStr(Time(),4,2)+".XLS"
_cArquivo 	:= __RELDIR+_cArqXls
Copy to &_cArquivo VIA "DBFCDXADS"
dbCloseArea("TRB")
FErase(cArqTrab+GetDBExtension())
FErase(cArqTrab+OrdBagExt())

dbselectArea("CT2")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega o Excel com o Arquivo Criado              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPath      := AllTrim(GetTempPath())
CpyS2T( _cArquivo , cPath, .T. )
	
If ! ApOleClient( 'MsExcel' )
	MsgStop( "MsExcel nao instalado" )
	Return
EndIf
	
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+_cArqXls ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjX1CodImpºAutor  ³Marcos S. Lobo      º Data ³  09/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua o ajuste no grupo de perguntas SX1 caso o campo      º±±
±±º          ³CT1_CODIMP esteja criado e em uso.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 - Relatórios SIGACTB                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³ cPerg= Codigo do Grupo de Perguntas no SX1                 º±±          
±±º          ³ cSeq = Codigo da Sequencia da Pergunta Imprime?(Normal/Red)º±±
±±º          ³ nX1Def=Numero da Seqüencia de DEFINE no ComboBox do SX1    º±±
±±º          ³ cMvPar=Codigo do mv_parXX que será utilizado.			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjCodImpX1(cPerg,cSeq,nX1Def,cMvPar)
Local lUsaCodImp	:= .F.
Local aArea			:= GetArea()
Local cCHAR2CH		:= "123456789abcdefghijklmnopqrstuv"
Local cMVCH			:= cMvPar

If Empty(cPerg) .or. Empty(cSeq)
	Return(lUsaCodImp)
Endif
  
dbSelectArea("SX3")
dbSetOrder(2)
If MsSeek("CT1_CODIMP")	.and. X3Uso(SX3->X3_USADO)				//// SE ENCONTRAR O CODIGO DE IMPRESSAO NO SX3 E ESTIVER EM USO
	lUsaCodImp := .T.											//// USO DO CODIGO DE IMPRESSA ESTARÁ HABILITADO
Else
	lUsaCodImp := .F.											//// USO DO CODIGO DE IMPRESSAO ESTARA DESABILITADO
Endif

If nX1Def > 0										/// SE FOR SOMENTE MANUTENÇÃO DE COMBOBOX
	dbSelectArea("SX1")
	dbSetOrder(1)
	If MsSeek(cPerg+cSeq)
		If lUsaCodImp .and. Empty(&("SX1->X1_DEF"+STRZERO(nX1Def,2)))		/// SE USA E ESTA EM BRANCO
			RecLock("SX1",.F.)
			&("Field->X1_DEF"+STRZERO(nX1Def,2))  		:= SX3->X3_TITULO	/// PREENCHE PARA LIBERAR O USO
			&("Field->X1_DEFSPA"+ALLTRIM(STR(nX1Def)))	:= SX3->X3_TITSPA
			&("Field->X1_DEFENG"+ALLTRIM(STR(nX1Def)))	:= SX3->X3_TITENG
			SX1->(MsUnlock())
		ElseIf !lUsaCodImp .and. !Empty(&("SX1->X1_DEF"+STRZERO(nX1Def,2))) /// SE Ñ USA E NAO ESTÁ VAZIO
			RecLock("SX1",.F.)
			&("Field->X1_DEF"+STRZERO(nX1Def,2))  		:= " "			/// APAGA PARA NAO LIBERAR O USO DO COD.IMPRESSAO
			&("Field->X1_DEFSPA"+ALLTRIM(STR(nX1Def)))	:= " "
			&("Field->X1_DEFENG"+ALLTRIM(STR(nX1Def)))	:= " "
			Field->X1_PRESEL	:= 0
			SX1->(MsUnlock())
		Endif
	Endif
Else                    		/// SE FOR NOVA PERGUNTA NO SX1
	If Empty(cMvPar)
		RestArea(aArea)
		Return(.F.)
	Endif
	dbSelectArea("SX1")
	dbSetOrder(1)
	If !MsSeek(cPerg+cSeq)							/// SE A PERGUNTA NAO EXISTIR
		cMVCH := "mv_ch"+SubStr(cCHAR2CH,val(SubStr(cMvPar,7,Len(cMvPar)-6)),1)		/// DEFINE A SEQUENCIA DO X1_VARIAVL (MV_CHx) UTILIZADO
		RecLock("SX1",.T.)
		Field->X1_GRUPO		:= cPerg
		Field->X1_ORDEM		:= cSeq
		Field->X1_PERGUNT	:= "Impr Cod. Conta    ?"
		Field->X1_PERSPA	:= "¿Impr Cod Cuenta   ?"
		Field->X1_PERENG	:= "Print Account Code ?"
		Field->X1_VARIAVL	:= cMVCH
		Field->X1_TIPO		:= "N"
		Field->X1_TAMANHO	:= 1
		Field->X1_DECIMAL	:= 0
		Field->X1_PRESEL	:= 0
		Field->X1_GSC		:= "C"
		Field->X1_VAR01		:= cMvPar
		Field->X1_DEF01 	:= "Normal"
		Field->X1_DEFSPA1	:= "Normal"
		Field->X1_DEFENG1	:= "Normal"
		Field->X1_DEF02 	:= "Reduzido"
		Field->X1_DEFSPA2	:= "Reducido"
		Field->X1_DEFENG2	:= "Reduced"
		If lUsaCodImp												/// SE CODIGO DE IMPRESSAO ESTIVER EM USO
			Field->X1_DEF03 	:= SX3->X3_TITULO
			Field->X1_DEFSPA3	:= SX3->X3_TITSPA
			Field->X1_DEFENG3	:= SX3->X3_TITENG
		Endif
		SX1->(MsUnlock())
	Else
		If !lUsaCodImp .and. !Empty(SX1->X1_DEF03)	/// SE NÃO USAR O CODIGO DE IMPRESSAO E O MESMO NAO ESTIVER VAZIO
			RecLock("SX1",.F.)
			Field->X1_DEF03 	:= ""				/// LIMPA O DEFINE DO COD.IMPRESSAO PARA NAO UTILIZAR
			Field->X1_DEFSPA3	:= ""
			Field->X1_DEFENG3	:= ""
			Field->X1_PRESEL	:= 0
			SX1->(MsUnlock())
		ElseIf Empty(SX1->X1_DEF03)					/// SE USAR E O CODIGO DE IMPRESSAO ESTIVER VAZIO
			RecLock("SX1",.F.)
			Field->X1_DEF03 	:= SX3->X3_TITULO	/// ADICIONA O DEFINE DO COD. IMPRESSAO PARA UTILIZAR
			Field->X1_DEFSPA3	:= SX3->X3_TITSPA
			Field->X1_DEFENG3	:= SX3->X3_TITENG
			SX1->(MsUnlock())
		Endif
	Endif
Endif

RestArea(aArea)
Return(lUsaCodImp)
