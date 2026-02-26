/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  IMPCT2     ºAutor  XXXXXX               º Data ³  26.11.2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Leitura e Importação de dados de Planilha *.CSV            º±±
±±º          ³ Importacao cadastro de produtos						      	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BIO2                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
Parametros.:	cAlias 	- Alias que será atualizado
nReg			- Registro posicionado no alias
nOpc			- Opção selecionada pelo usuário
*/

User Function IMPCT2()

Private aCampos		:= {}
Private cLinha		:= ""

Private lEnd		:= .F.
Private nPosAtu	:= 0
Private nEof		:= 0
Private aErro		:= {}
Private nLastKey	:= 0

Private aPergs 	:= {}
Private aRet 		:= {}
Private cDelimit 	:= ';'
Private cArquivo	:= ""

aAdd( aPergs ,{6,"Arquivo : ",cArquivo,"@!",'.T.','.T.',80,.T.,"Arquivos CSV (*.CSV) | *.CSV","C:\"})
aAdd( aPergs ,{1,"Caracter Demitador : ",cDelimit,"@!",'.T.',,'.T.',10,.T.})

If !ParamBox(aPergs ,"Parametros ",aRet)
	Return Nil
EndIf

cArquivo	:= aRet[1]
cDelimit	:= aRet[2]

//Validando se existe o arquivo informado
If !File(cArquivo)
	MsgAlert("Inválido! Favor Informar um Arquivo *.CSV válido!")
	Return Nil
EndIf

If MsgYesNo("Confirma a importação do Arquivo?")
	ImpTxt()
Endif

Return


/*
Função ImpTxt Abertura e Leitura do Aquivo .CSV.
*/

Static Function ImpTxt()

Private _cFile := ""
Private _xFile := ""
Private _cType := ""
Private _nTot  := 0

nHdl := fopen(cArquivo,0)
_nTot:= fSeek(nHdl,0,2)
fClose(nHdl)

If _nTot > 0
	Processa({||Importa(),,"Importando registros. Aguarde..."})
EndIf

Return(Nil)

/*
Tratamento dos Dados do Arquivo .CSV e sua posterior Gravação no Banco de Dados.
*/

Static Function Importa()

Local nY 				:= 0
Local nX 				:= 0

Local _cBuffer			:= ""
Local aLinha 			:= {}
Local _cTexto			:= ""
Private aRegistro 		:= {}
Private nTotLinha		:= 0
Private lMSErroAuto		:= .F.
Private aItens			:= {}

Begin Transaction

FT_FUSE(cArquivo)

nTotLinha := FT_FLASTREC()

If nTotLinha < 2
	MsgAlert("Arquivo Incompleto!!! Favor verificar...")
	Return Nil
Endif

FT_FGOTOP()
_cBuffer := FT_FREADLN()    // Tratamento para não adcionar o nome das colunas do arquivo *.CSV
FT_FSKIP()
_cBuffer := FT_FREADLN()
ProcRegua(nTotLinha)
Do While !FT_FEOF()
	IncProc()
	
	aLinha 		:= {}
	
	// Executa leitura da linha em _cBuffer e identifica os campos pelo delimitador ";"
	If Len(_cBuffer) >0
		_cTexto	:= ""
		For nX 	:= 1 to Len(_cBuffer)
			If Substr(_cBuffer,nX,1) == cDelimit //cDelimit Determina o carater delimitador.
				aAdd(aLinha, _cTexto )
				_cTexto := ""
			Else
				_cTexto += Substr(_cBuffer,nX,1)
			Endif
		Next nX
		If !Empty(_cTexto)
			aAdd(aLinha, _cTexto )
		Else
			aAdd(aLinha, " " )
		Endif
	Endif
	
	If Len(aLinha) <= 18 //Padrão definido para 12 Colunas.
		aAdd( aRegistro, { STRZERO(VAL(aLinha[01]),3), aLinha[02], aLinha[03], aLinha[04] ,;
								   Val(aLinha[05]),    aLinha[06], aLinha[07], aLinha[08], ;
								       aLinha[09],     aLinha[10], aLinha[11], aLinha[12], ;
								       aLinha[13],     aLinha[14], aLinha[15], aLinha[16], aLinha[17], aLinha[18] } )
	Else
		MsgAlert("O arquivo não segue o Layout definido!!!")
		Return Nil
	Endif
	
	FT_FSKIP()
	_cBuffer := FT_FREADLN()
Enddo
FT_FUSE()
End Transaction

//Executando a Gravação dos Dados
lNovo		:= .F.

ProcRegua(Len(aRegistro))

If Len(aRegistro)>0
 
dDatabase := CTOD(aRegistro[1,15]) 

	aCab := {;
	{'DDATALANC' 	,dDatabase				,NIL},;
	{'CLOTE' 		,aLinha[16]				,NIL},;
	{'CSUBLOTE' 	,aLinha[17]				,NIL},;
	{'CDOC' 		,aLinha[18]				,NIL},;
	{'CPADRAO' 		,'' 					,NIL},;
	{'NTOTINF' 		,0 						,NIL},;
	{'NTOTINFLOT' 	,0 						,NIL} }
	
	For nY := 1 to Len(aRegistro)
		
		IncProc()
		
		DbSelectArea('CT2')
		DbSetOrder(1)
		//{"CT2_MOEDLC"	,"01"				,NIL},;
		Aadd( aItens, { ;
		{"CT2_FILIAL"	,xFilial("CT2")		,Nil},; 
		{"CT2_LINHA"	,aRegistro[nY,1]	,Nil},;
		{'CT2_MOEDLC' 	,'01' 				,NIL},; 
		{"CT2_DC"		,aRegistro[nY,2]	,Nil},;
		{"CT2_DEBITO"	,aRegistro[nY,3]	,Nil},;
		{"CT2_CREDIT"	,aRegistro[nY,4]	,Nil},;
		{"CT2_VALOR"	,aRegistro[nY,5]	,Nil},;
		{"CT2_CCD"		,aRegistro[nY,6]	,Nil},;
		{"CT2_CCC"		,aRegistro[nY,7]	,Nil},;
		{"CT2_ITEMD"	,aRegistro[nY,8]	,Nil},;
		{"CT2_ITEMC"	,aRegistro[nY,9]	,Nil},;
		{"CT2_CLVLDB"	,aRegistro[nY,10]	,Nil},;
		{"CT2_CLVLCR"	,aRegistro[nY,11]	,Nil},;
		{"CT2_ORIGEM"	,'MSEXECAUT'		,Nil},;
		{"CT2_HP"		,aRegistro[nY,13]	,Nil},;
		{'CT2_CONVER' 	,'11' 				,NIL},;
		{"CT2_HIST"		,aRegistro[nY,14]	,Nil}})

	Next
	/*
	Número da opção a executar
		3 = Incluir
		4 = Alterar
		5 = Excluir
	*/
	MsExecAuto( { |x,y,z| Ctba102( x, y, z ) }, aCab, aItens, 3 )
	//CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC+CT2_SEQIDX	
	If lMsErroAuto
		MostraErro( )
	Endif
Endif

Return()
