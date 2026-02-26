//Bibliotecas
#Include "TOTVS.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE "GPEWORD.CH"
#Include "TopConn.ch"
#INCLUDE "PRTOPDEF.CH"

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Rotina    |  INTWORD        | Samuel  Miranda     |  Data | 22/02/2025 |±± 
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Descricao | Integração do Microsoft Word com o modulo gestao de pessoal|±± 
//±± 											                            |±± 
//±± @version 1.0                                                           |±±                                     
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

User Function INTWORD()
	//Variaveis local
    Local aArea      := FWGetArea()
    Local aPergs     := {}
    Local cFilialDe  := Space(02)
    Local cFilialAte := Space(02)
    Local cMatDe     := Space(TamSX3('RA_MAT')[1])/// 
    Local cMatAte    := Space(TamSX3('RA_MAT')[1])
    local aGeraPdf   := {"1=Sim","2=Não"}
    //Variaveis Private
    Private nValPar     := {}
    Private cPathLoc    := "C:\Temp\"
    Private cArquivo	:= ""  
	Private oNewProess as object
    //Adicionando os parametros do ParamBox
    aAdd(aPergs,{1,"Filial De"	  ,cFilialDe ,""  ,".T.","XM0"   ,".T.",02,.F.})// MV_PAR01
    aAdd(aPergs,{1,"Filial Até"	  ,cFilialAte,""  ,".T.","XM0"   ,".T.",02,.F.})// MV_PAR02
    aAdd(aPergs,{1,"Matrícula De" ,cMatDe	 ,"@!",".T.","SRA02A",".T.",30,.F.})// MV_PAR03
    aAdd(aPergs,{1,"Matrícula Até",cMatAte	 ,"@!",".T.","SRA02A",".T.",30,.F.})// MV_PAR04
    aAdd(aPergs,{6,"Arquivo .doc:",cArquivo	 ,"@!",".T.",".T.",80  ,.T.,"Arquivos DOC (*.DOC) | *.DOC","C:\"}) // MV_PAR05
	aAdd(aPergs,{1,"Matriculas Sep. 'XXXXXX',"   , Upper(Space(100)),"","","","",110,.F.}) // MV_PAR06
	aAdd(aPergs,{2,"Gerar PDF:"   ,02,aGeraPdf,40,"",.T.})// MV_PAR07
	aAdd(aPergs,{5,"Matricolas Individuais"                ,.F.,90,"",.F.})// MV_PAR08
	
    //Se a pergunta for confirma, cria as definicoes do relatorio
    If ParamBox(aPergs, "Informe os parâmetros", , , , , , , , , .F., .F.)
		//INTMSWOD()
        Processa({|| INTMSWOD()}, "Processando a integração...","Aguarde...")
		//Processa({|| fExemplo5()}, "Filtrando...", , , , )
    EndIf
    //Restaura a Are 
    FWRestArea(aArea)
Return
 
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Rotina    |  INTMSWOD      | Samuel  Miranda     |  Data | 22/02/2025 |±± 
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Descricao | Monta a Integração do arquivo com o Protheus				|±± 
//±± 											                            |±± 
//±± @version 1.0                                                           |±±                                     
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

Static Function INTMSWOD()
    Local nHandWord  := 0
    Local cPastaTmp  := cPathLoc //GetTempPath()
    Local cArqOrigi  := Alltrim(MV_PAR05) // "\x_dots\produto.dotx"
    Local cArqLocal  := ""//Alltrim(MV_PAR05) //+ "produtos.dotx"
    Local cQuery     := ""
    Local nRegTot    := 0
	Local cIndice    := ""
	Local cTimer     := Strtran(SubStr(Time(),1,5),":","") 
	Local nCont 	 := 0
	Local cPDesc   	 := cPastaTmp+"DOC_"+DToS(dDataBase)+"_"+cTimer+"\"
	Local cTempArq   := {}
	Local cPDell     := 0
	Local cVerifc    := ""
	Local cTransfPDF := {}
	Local cMsg		 := ""
	
    //Verifica se a pasta de destino existe
	If !ExistDir(cPDesc)
		MakeDir(cPDesc)
		cMsg := '<b> Pasta de destino : '+cPDesc+'</b>'
		cMsg += '<br>'
		cMsg += '<b> Criada com sucesso!</b>' 
		cMsg += '<br>'
		cMsg += '<b> </b>'
		cMsg += '<br>'
		FWAlertSuccess(cMsg ,"A T E N Ç Ã O!")
	Else
		DirRemove(cPasta)
		cMsg := '<b> Pasta de destino : '+cPDesc+'</b>'
		cMsg += '<br>'
		cMsg += '<b> </b>'
		cMsg += '<br>'
		FWAlertInfo(cMsg,"A T E N Ç Ã O!")
		MakeDir(cPDesc)
	EndIf
	//Monta a consulta em SQL  
    cQuery :="SELECT  "+ CHR(13)+CHR(10)
    cQuery +="SRA.RA_FILIAL AS FILIAL,"+ CHR(13)+CHR(10)
    cQuery +="SRA.RA_MAT AS MATRICULA"+ CHR(13)+CHR(10)
    cQuery += "FROM "+ CHR(13)+CHR(10)
	cQuery += "    " + RetSQLName("SRA") + " SRA "+ CRLF
    cQuery +="WHERE "+CHR(13)+CHR(10)
	cQuery +="SRA.RA_FILIAL BETWEEN '"+AllTrim(MV_PAR01)+"' AND '"+AllTrim(MV_PAR02)+"' AND "+CHR(13)+CHR(10)
	//Verifa se a impressão 
	IF MV_PAR08 == .T.
		cQuery +="SRA.RA_MAT IN ("+AllTrim(MV_PAR06)+") AND "+CHR(13)+CHR(10)
	 Else
		cQuery +="SRA.RA_MAT BETWEEN '"+AllTrim(MV_PAR03)+"' AND '"+AllTrim(mv_par04)+"' AND "+CHR(13)+CHR(10)
	EndIf
    cQuery +="SRA.D_E_L_E_T_='' "+CHR(13)+CHR(10)
	cQuery +="AND SRA.RA_DEMISSA='' "+CHR(13)+CHR(10)
    cQuery +="ORDER BY RA_MAT "+CHR(13)+CHR(10)
    MemoWrite("intword.sql", cQuery)//Salva o resultado da query
    //Executando consulta e setando o total da regua
	PlsQuery(cQuery, "QRYSRA")
	DbSelectArea("QRYSRA")
	Count To nRegTot
    ProcRegua(nRegTot)
    QRYSRA->(DbGoTop())
	If nRegTot < 0
		FWAlertWarning("Registro não encontrado, Favor verificar...")
		ProcessMessages()
		Return()
	EndIf
	//Inicializa a integração com Microsoft Office, para permitir execução de macros internas
    BeginMsOle()
    //Somente se tiver dados
    While !QRYSRA->(EoF())
		nCont       += 1	
		cTimer   	:= Strtran(SubStr(Time(),1,5),":","") 
		cIndice   	:= Alltrim(QRYSRA->FILIAL)+Alltrim(QRYSRA->MATRICULA)
		nValPar 	:= NVARWORD( nValPar,cIndice)//Chama a função das variaveis do sistema
		cArqLocal  	:= "c:\temp\"+Alltrim(QRYSRA->MATRICULA)+".doc"//Caminho do Arquivo temporario Word
		
		//Exibe o status somente do Word
		If cValtochar(MV_PAR07) == "2"
			IncProc("Gerando o 	WORD " + cValToChar(nCont) + " de " + cValToChar(nRegTot) + ", aguarde.")
	    EndIf
		//Forço a copia do arquivo para a máquina local
        __CopyFile(cArqOrigi, cArqLocal)
		Aadd(cTempArq,{cArqLocal})
        //Inicializa o Ole com o MS-Word 97 ( 8.0 )
        nHandWord := OLE_CreateLink(); OLE_NewFile(nHandWord, cArqLocal)
      
		// Ajustando as Variaveis do Documento
		Aeval(	nValPar																								,;
				{ |x| OLE_SetDocumentVar( nHandWord, x[1]  															,;
											IF( Subst( AllTrim( x[3] ) , 4 , 2 )  == "->"          					,;
												Transform( x[2] , PesqPict( Subst( AllTrim( x[3] ) , 1 , 3 )		,;
																			Subst( AllTrim( x[3] )  				,;
										        			         			  - ( Len( AllTrim( x[3] ) ) - 5 )	 ;
										          								 )	  	 							 ;
																	      )                                          ;
												         )															,;
												Transform( x[2] , x[3] )                                     		 ;
				  	 						  ) 														 	 		 ;
										)																			 ;
				}     																 							 	 ;
			 )

        //Atualizando campos
        OLE_UpdateFields(nHandWord)
        //Salva o arqivo em WORD 
        OLE_SetPropertie(nHandWord, .F.)
        OLE_SetProperty(nHandWord, oleWdVisible, .F.)
		OLE_SaveAsFile(nHandWord,cPDesc+cValtochar(nCont)+"-"+Alltrim(QRYSRA->MATRICULA)+".doc")//Gera o Arquivo Word
        Aadd(cTransfPDF,{cPDesc+cValtochar(nCont)+"-"+Alltrim(QRYSRA->MATRICULA)+".doc"})   
		//Fecha o arquivo, aguarda 1 segundo para a geração do pdf e encerra o ponteiro em memória
		OLE_CloseFile(nHandWord)
		//Tempo de espera para o proximo arquivo
		Sleep(1000)
		//Exclui o arquivo temporario
		fErase(cArqLocal)
	  	//Passa pro proxim registro
		QRYSRA->(DbSkip()) 
		//Inicializa o array
		nValPar     := {}
    EndDo

	//Gera PDF = Sim
	If cValtochar(MV_PAR07) == "1"
		//Entra no laço
		For cPDell :=1 to Len(cTransfPDF)
			//Exibe o status somente do PDF
			IncProc("Salvando PDF " + cValToChar(cPDell) + " de " + cValToChar(Len(cTransfPDF)) + ", aguarde.")
			ProcessMessages()
			//PROCESSMESSAGES()
			OLE_SetPropertie(nHandWord, .F.)
			OLE_SetProperty(nHandWord, oleWdVisible, .F.)
			OLE_OpenFile(nHandWord, cTransfPDF[cPDell][1])
			//Gera o PDF do documento
			OLE_SetProperty(nHandWord,'208',.F.)
			OLE_SaveAsFile(nHandWord,StrTran(cTransfPDF[cPDell][1], ".doc", ".pdf") , , , .F., 17 )//Gera o Arquivo PDF   //OLE_SaveAsFile( nHandWord, cPastaDest + cArquiDest, , , .F., 17 )
			
			//Fecha o arquivo, aguarda 1 segundo para a geração do pdf e encerra o ponteiro em memória
			OLE_CloseFile(nHandWord)
			Sleep(1000)
		Next cPDell
	ENDiF
	//Fecha o link  
	OLE_CloseLink(nHandWord )

	//Força a exclusão do arquivo
	For cPDell  := 1 to len(cTempArq)
		cVerifc := cTempArq[cPDell][1]
		// Se encontrar o registro
		If File(cVerifc)
			//Força a exclusão do arquivo
			FErase(cVerifc) 
		EndIf
	Next cNext
	//Força a exclusão do arquivo
	If cValtochar(MV_PAR07) == "1"
		For cPDell  := 1 to len(cTransfPDF)
			cVerifc := cTransfPDF[cPDell][1]
			// Se encontrar o registro
			If File(cVerifc)
				//Força a exclusão do arquivo
				FErase(cVerifc) 
			EndIf
		Next cNext
	EndIf	
	//Encerra a integração com Microsoft Office
    EndMsOle()
	//Abre a Pasta
	ShellExecute("OPEN", "", "", cPDesc, 1 )
Return

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Rotina    |  NVARWORD      | Samuel  Miranda      |  Data | 22/02/2025 |±± 
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Descricao | Retorna Array com as Variaveis Disponiveis para Impressao.	|±± 
//±± 			 para serem impressa no documento							|±± 
//±± @version 1.0   (Obs. Espelho do Programa Padrão)                       |±±                                     
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//|          ³ aExp[x,1] - Variavel Para utilizacao no Word (Tam Max. 30)   |±± 
//|          ³ aExp[x,2] - Conteudo do Campo                (Tam Max. 49)   |±± 
//|          ³ aExp[x,3] - Campo para Pesquisa da Picture no X3 ou Picture  |±± 
//|          ³ aExp[x,4] - Descricao da Variaval                            |±± 
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

Static Function NVARWORD(nValPar,cIndice)
Local aExp			:= {}
Local cTexto_01		:= ""//AllTrim( mv_par19 )
Local cTexto_02		:= ""//AllTrim( mv_par20 )
Local cTexto_03		:= ""//AllTrim( mv_par21 )
Local cTexto_04		:= ""//AllTrim( mv_par22 )
Local cEstCiv		:= "" //Estado Civil para DCN/DMN - PIS
Local cTipCertd		:= "" //Tipo de Certidao Civil para DCN/DMN - PIS
Local cGrauInstr	:= "" //Grau de Instrucao conforme DCN/DMN - PIS
Local cTipNIS		:= "0" //Pergunte exclusivo do Brasil // Tipo PIS - DCN/DMN
Local cCodAtiv		:= ""
Local _cFilial    	:= ""
Local _cMatricula 	:= ""
Private aInfo		:= {}

    cFilialAnt := Space(FWGETTAMFILIAL)
    // Carregando Informacoes da Empresa
	If !fInfo(@aInfo,xFilial("SRA"))
		Return( Nil )
	EndIf

	DbSelectArea("SRA")
	DbSetOrder(1)
	IF DbSeek(SRA->(cIndice))//DbSeek(cIndice) .F.

		aAdd( aExp, {'GPE_FILIAL'			   		,	SRA->RA_FILIAL 										  	, "SRA->RA_FILIAL"			,STR0013	} )
		aAdd( aExp, {'GPE_MATRICULA'		   		,	PadR(SRA->RA_MAT,6,"0")									, "SRA->RA_MAT"				,STR0014	} )
		aAdd( aExp, {'GPE_CENTRO_CUSTO'		   		,	SRA->RA_CC												, "SRA->RA_CC"				,STR0015	} )
		aAdd( aExp, {'GPE_DESC_CCUSTO'		   		,	fDesc("CTT",SRA->RA_CC,"CTT_DESC01")		 			, "@!"					    ,STR0016	} )
		aAdd( aExp, {'GPE_NOME'		   		   		,	SRA->RA_NOME											, "SRA->RA_NOME"			,STR0017	} )
		aAdd( aExp, {'GPE_NOMECMP'           		,   SRA->RA_NOMECMP											, "@!"           			,STR0017 	} )
		aAdd( aExp, {'GPE_CPF'		   				,	SRA->RA_CIC												, "SRA->RA_CIC"				,STR0018	} )
		aAdd( aExp, {'GPE_PIS'		   				,	SRA->RA_PIS												, "SRA->RA_PIS"				,STR0019	} )
		aAdd( aExp, {'GPE_RG'		   		   		,	SRA->RA_RG												, "SRA->RA_RG"				,STR0020	} )
		aAdd( aExp, {'GPE_RG_ORG'	   		   		,	SRA->RA_RGORG											, "@!"						,STR0152	} )
		aAdd( aExp, {'GPE_RG_ORGUF'	   		   		,	SRA->RA_RGUF											, "@!"						,STR0241	} )
		aAdd( aExp, {'GPE_CTPS'				   		,	SRA->RA_NUMCP							 				, "SRA->RA_NUMCP"			,STR0021	} )
		aAdd( aExp, {'GPE_SERIE_CTPS'				,	SRA->RA_SERCP							 				, "SRA->RA_SERCP"			,STR0022	} )
		aAdd( aExp, {'GPE_UF_CTPS'			   		,	SRA->RA_UFCP							 				, "SRA->RA_UFCP"			,STR0023	} )
		aAdd( aExp, {'GPE_CNH'   	  		   		,	SRA->RA_HABILIT							 				, "SRA->RA_HABILIT"			,STR0024	} )
		aAdd( aExp, {'GPE_RESERVISTA'		   		,	SRA->RA_RESERVI							 				, "SRA->RA_RESERVI"			,STR0025	} )
		aAdd( aExp, {'GPE_TIT_ELEITOR' 		   		,	SRA->RA_TITULOE							 				, "SRA->RA_TITULOE"			,STR0026	} )
		aAdd( aExp, {'GPE_ZONA_SECAO'  		   		,	SRA->RA_ZONASEC							 				, "SRA->RA_ZONASEC"			,STR0027	} )
		aAdd( aExp, {'GPE_ENDERECO'			   		,	SRA->RA_ENDEREC							 				, "SRA->RA_ENDEREC"			,STR0028	} )
		aAdd( aExp, {'GPE_COMP_ENDER'		   		,	SRA->RA_COMPLEM							 				, "SRA->RA_COMPLEM"			,STR0029	} )
		aAdd( aExp, {'GPE_BAIRRO'					,	SRA->RA_BAIRRO							 				, "SRA->RA_BAIRRO"			,STR0030	} )
		aAdd( aExp, {'GPE_MUNICIPIO'				,	SRA->RA_MUNICIP							 				, "SRA->RA_MUNICIP"			,STR0031	} )
		aAdd( aExp, {'GPE_ESTADO'					,	SRA->RA_ESTADO											, "SRA->RA_ESTADO"			,STR0032	} )
		aAdd( aExp, {'GPE_DESC_ESTADO'				,	fDesc("SX5","12"+SRA->RA_ESTADO,"X5_DESCRI")			, "@!"						,STR0033	} )
		
		//aAdd( aExp, {'GPE_RA_DESCTUR '				,	SRA->RA_DESCTUR 										, "SRA->RA_DESCTUR "		,"RA_DESCTUR "	} )
		aAdd( aExp, {'GPE_CEP'		   				,	SRA->RA_CEP												, "SRA->RA_CEP"				,STR0034	} )
		aAdd( aExp, {'GPE_TELEFONE'	   				,	SRA->RA_TELEFON										   	, "SRA->RA_TELEFON"			,STR0035	} )
		aAdd( aExp, {'GPE_NOME_PAI'	   		   		,	SRA->RA_PAI												, "SRA->RA_PAI"				,STR0036	} )
		aAdd( aExp, {'GPE_NOME_MAE'	   		   		,	SRA->RA_MAE											   	, "SRA->RA_MAE"				,STR0037	} )
		aAdd( aExp, {'GPE_COD_SEXO'	   				,	SRA->RA_SEXO											, "SRA->RA_SEXO"			,STR0038	} )
	    // aAdd( aExp, {'GPE_DESC_SEXO'   		   		,	SRA->(IF(RA_SEXO ="M","Masculino","Feminino"))			, "@!"						,STR0039	} )
		aAdd( aExp, {'GPE_EST_CIVIL'  				,	SRA->RA_ESTCIVI											, "SRA->RA_ESTCIVI"			,STR0040	} )
	
		aAdd( aExp, {'GPE_COD_NATURALIDADE'	   		,	If(SRA->RA_NATURAL # " ",SRA->RA_NATURAL," ")	    	, "SRA->RA_NATURAL"			,STR0041	} )
		aAdd( aExp, {'GPE_DESC_NATURALIDADE'		,	fDesc("SX5","12"+SRA->RA_NATURAL,"X5_DESCRI")			, "@!"						,STR0042	} )
		aAdd( aExp, {'GPE_COD_NACIONALIDADE'		,	SRA->RA_NACIONA											, "SRA->RA_NACIONA"			,STR0043	} )
		aAdd( aExp, {'GPE_DESC_NACIONALIDADE'  		,	fDesc("SX5","34"+SRA->RA_NACIONA,"X5_DESCRI")			, "@!"						,STR0044	} )

		If cPaisLoc <> "EQU"
			aAdd( aExp, {'GPE_ANO_CHEGADA' 			,	SRA->RA_ANOCHEG											, "SRA->RA_ANOCHEG"			,STR0045	} )
		EndIf

		aAdd( aExp, {'GPE_DEP_IR'   				,	SRA->RA_DEPIR										 	, "SRA->RA_DEPIR"			,STR0046	} )

		aAdd( aExp, {'GPE_DATA_NASC'  		   		,	SRA->RA_NASC											, "SRA->RA_NASC"			,STR0048	} )
		aAdd( aExp, {'GPE_DATA_ADMISSAO'			,	SRA->RA_ADMISSA											, "SRA->RA_ADMISSA"			,STR0049	} )
		aAdd( aExp, {'GPE_DIA_ADMISSAO' 	   		,	StrZero( Day( SRA->RA_ADMISSA ) , 2 )					, "@!"						,STR0050	} )
		aAdd( aExp, {'GPE_MES_ADMISSAO'		   		,	StrZero( Month( SRA->RA_ADMISSA ) , 2 )					, "@!"						,STR0051 	} )
		aAdd( aExp, {'GPE_ANO_ADMISSAO'				,	StrZero( Year( SRA->RA_ADMISSA ) , 4 )					, "@!"						,STR0052	} )
		aAdd( aExp, {'GPE_DT_OP_FGTS'  				,	SRA->RA_OPCAO											, "SRA->RA_OPCAO"			,STR0053	} )
		aAdd( aExp, {'GPE_DATA_DEMISSAO'	   		,	SRA->RA_DEMISSA											, "SRA->RA_DEMISSA"			,STR0054	} )

		If cPaisLoc <> "EQU"
			aAdd( aExp, {'GPE_DATA_EXPERIENCIA'		,	SRA->RA_VCTOEXP											, "SRA->RA_VCTOEXP"			,STR0055	} )
			aAdd( aExp, {'GPE_DIA_EXPERIENCIA' 		,	StrZero( Day( SRA->RA_VCTOEXP ) , 2 )					, "@!"						,STR0056	} )
			aAdd( aExp, {'GPE_MES_EXPERIENCIA'		,	StrZero( Month( SRA->RA_VCTOEXP ) , 2 )					, "@!"						,STR0057	} )
			aAdd( aExp, {'GPE_ANO_EXPERIENCIA'		,	StrZero( Year( SRA->RA_VCTOEXP ) , 4 ) 					, "@!"						,STR0058	} )
			aAdd( aExp, {'GPE_DIAS_EXPERIENCIA'		,	StrZero(SRA->(RA_VCTOEXP-RA_ADMISSA)+1,03)				, "@!"						,STR0059	} )
			aAdd( aExp, {'GPE_DATA_EXPERIENCIA2'	,	SRA->RA_VCTEXP2											, "SRA->RA_VCTEXP2"			,STR0245	} )
			aAdd( aExp, {'GPE_DIA_EXPERIENCIA2' 	,	StrZero( Day( SRA->RA_VCTEXP2 ) , 2 )					, "@!"						,STR0246	} )
			aAdd( aExp, {'GPE_MES_EXPERIENCIA2'		,	StrZero( Month( SRA->RA_VCTEXP2 ) , 2 )					, "@!"						,STR0247	} )
			aAdd( aExp, {'GPE_ANO_EXPERIENCIA2'		,	StrZero( Year( SRA->RA_VCTEXP2 ) , 4 ) 					, "@!"						,STR0248	} )
			aAdd( aExp, {'GPE_DIAS_EXPERIENCIA2'	,	StrZero(SRA->(RA_VCTEXP2-RA_ADMISSA)+1,03)				, "@!"						,STR0249	} )
			aAdd( aExp, {'GPE_DATA_EX_MEDIC'		,	SRA->RA_EXAMEDI											, "SRA->RA_EXAMEDI"			,STR0060	} )
		EndIf

		aAdd( aExp, {'GPE_BCO_AG_DEP_SAL'	   		, 	SRA->RA_BCDEPSA											, "SRA->RA_BCDEPSA"			,STR0061	} )
		aAdd( aExp, {'GPE_DESC_BCO_SAL'		   		, 	fDesc("SA6",SRA->RA_BCDEPSA,"A6_NOME")					, "@!"						,STR0062	} )
		aAdd( aExp, {'GPE_DESC_AGE_SAL'		   		, 	fDesc("SA6",SRA->RA_BCDEPSA,"A6_NOMEAGE")				, "@!"						,STR0063	} )
		aAdd( aExp, {'GPE_CTA_DEP_SAL'		   		,	SRA->RA_CTDEPSA											, "SRA->RA_CTDEPSA"			,STR0064	} )
		aAdd( aExp, {'GPE_BCO_AG_FGTS'				,	SRA->RA_BCDPFGT											, "SRA->RA_BCDPFGT"			,STR0065	} )
		aAdd( aExp, {'GPE_DESC_BCO_FGTS'	   		, 	fDesc("SA6",SRA->RA_BCDPFGT,"A6_NOME")					, "@!"						,STR0066	} )
		aAdd( aExp, {'GPE_DESC_AGE_FGTS'	   		, 	fDesc("SA6",SRA->RA_BCDPFGT,"A6_NOMEAGE")				, "@!"						,STR0067	} )
		aAdd( aExp, {'GPE_CTA_Dep_FGTS'		   		,	SRA->RA_CTDPFGT											, "SRA->RA_CTDPFGT"			,STR0068	} )
		aAdd( aExp, {'GPE_SIT_FOLHA'	  	   		,	SRA->RA_SITFOLH											, "SRA->RA_SITFOLH"			,STR0069	} )
		aAdd( aExp, {'GPE_DESC_SIT_FOLHA'  			,	fDesc("SX5","30"+SRA->RA_SITFOLH,"X5_DESCRI")			, "@!"						,STR0070	} )
		aAdd( aExp, {'GPE_HRS_MENSAIS'		   		,	SRA->RA_HRSMES											, "SRA->RA_HRSMES"			,STR0071	} )
		aAdd( aExp, {'GPE_HRS_SEMANAIS'				,	SRA->RA_HRSEMAN											, "SRA->RA_HRSEMAN"			,STR0072	} )
		aAdd( aExp, {'GPE_CHAPA'		  	   		,	Padr(SRA->RA_CHAPA,6,"0")										, "SRA->RA_CHAPA"			,STR0073	} )
		aAdd( aExp, {'GPE_TURNO_TRAB'	 	   		,	SRA->RA_TNOTRAB											, "SRA->RA_TNOTRAB"			,STR0074	} )
		aAdd( aExp, {'GPE_DESC_TURNO'	  			,	fDesc('SR6',SRA->RA_TNOTRAB,'R6_DESC',,SRA->RA_FILIAL)	, "@!"						,STR0075	} )
		aAdd( aExp, {'GPE_COD_FUNCAO'	 			,	SRA->RA_CODFUNC											, "SRA->RA_CODFUNC"			,STR0076 	} )
		aAdd( aExp, {'GPE_DESC_FUNCAO'				,	fDesc('SRJ',SRA->RA_CODfUNC,'RJ_DESC',,SRA->RA_FILIAL)	, "@!"						,STR0077	} )
		aAdd( aExp, {'GPE_CBO'			   	   		,	fCodCBO(SRA->RA_FILIAL,SRA->RA_CODFUNC,dDataBase)		, "@!"				        ,STR0078	} )
		aAdd( aExp, {'GPE_CONT_SINDIC'		   		,	SRA->RA_PGCTSIN											, "SRA->RA_PGCTSIN"			,STR0079	} )
		aAdd( aExp, {'GPE_COD_SINDICATO'			,	SRA->RA_SINDICA											, "SRA->RA_SINDICA"			,STR0080	} )
		aAdd( aExp, {'GPE_DESC_SINDICATPO'	   		,	AllTrim( fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",40) ), "@!"						,STR0081	} )
		aAdd( aExp, {'GPE_COD_ASS_MEDICA'			,	SRA->RA_ASMEDIC											, "SRA->RA_ASMEDIC"			,STR0082	} )
		aAdd( aExp, {'GPE_DEP_ASS_MEDICA'			,	SRA->RA_DPASSME											, "SRA->RA_DPASSME"			,STR0083	} )
		aAdd( aExp, {'GPE_ADIC_TEMP_SERVIC'			,	SRA->RA_ADTPOSE											, "SRA->RA_ADTPOSE"			,STR0084	} )
		aAdd( aExp, {'GPE_COD_CESTA_BASICA'			,	SRA->RA_CESTAB											, "SRA->RA_CESTAB"			,STR0085	} )
		aAdd( aExp, {'GPE_COD_VALE_REF' 			,	SRA->RA_VALEREF											, "SRA->RA_VALEREF"			,STR0086	} )

		If cPaisLoc $ ("ANG/ARG/BOL/BRA/CHI/COL/EQU/MEX/PER")
			aAdd( aExp, {'GPE_COD_SEG_VIDA' 		,	SRA->RA_SEGUROV											, "SRA->RA_SEGUROV"			,STR0087	} )
		EndIf

		aAdd( aExp, {'GPE_%ADIANTAM'	 			,	SRA->RA_PERCADT											, "SRA->RA_PERCADT"			,STR0089	} )
		aAdd( aExp, {'GPE_CATEG_FUNC'	  	   		,	SRA->RA_CATFUNC											, "SRA->RA_CATFUNC"			,STR0090	} )
		aAdd( aExp, {'GPE_DESC_CATEG_FUNC'			,	fDesc("SX5","28"+SRA->RA_CATFUNC,"X5_DESCRI")			, "@!"						,STR0091	} )
		aAdd( aExp, {'GPE_POR_MES_HORA'		   		,	SRA->(IF(RA_CATFUNC$"H","P/Hora",IF(RA_CATFUNC$"J","P/Aula","P/Mes"))) 			, "@!"						,STR0092	} )
		aAdd( aExp, {'GPE_TIPO_PAGTO'  				,	SRA->RA_TIPOPGT								 			, "SRA->RA_TIPOPGT"			,STR0093	} )
		aAdd( aExp, {'GPE_DESC_TIPO_PAGTO'  		,	fDesc("SX5","40"+SRA->RA_TIPOPGT,"X5_DESCRI")			, "@!"						,STR0094	} )
		aAdd( aExp, {'GPE_SALARIO'		   	   		,	SRA->RA_SALARIO											, "SRA->RA_SALARIO"			,STR0095	} )

		If cPaisLoc <> "EQU"
			aAdd( aExp, {'GPE_SAL_BAS_DISS'			,	SRA->RA_ANTEAUM											, "SRA->RA_ANTEAUM"			,STR0096	} )
		EndIf

		aAdd( aExp, {'GPE_HRS_PERICULO'  			,	SRA->RA_PERICUL											, "SRA->RA_PERICUL"			,STR0099	} )
		aAdd( aExp, {'GPE_HRS_INS_MINIMA'			,	SRA->RA_INSMIN											, "SRA->RA_INSMIN"			,STR0100	} )
		aAdd( aExp, {'GPE_HRS_INS_MEDIA'			,	SRA->RA_INSMED											, "@!"						,STR0101	} )
		aAdd( aExp, {'GPE_HRS_INS_MAXIMA'			,	SRA->RA_INSMAX											, "SRA->RA_INSMAX"			,STR0102	} )
		aAdd( aExp, {'GPE_TIPO_ADMISSAO'			,	SRA->RA_TIPOADM											, "SRA->RA_TIPOADM"			,STR0103	} )
		aAdd( aExp, {'GPE_DESC_TP_ADMISSAO'			,	fDesc("SX5","38"+SRA->RA_TIPOADM,"X5_DESCRI")			, "@!"						,STR0104	} )
		aAdd( aExp, {'GPE_COD_AFA_FGTS'		   		,	SRA->RA_AFASFGT											, "SRA->RA_AFASFGT"			,STR0105	} )
		aAdd( aExp, {'GPE_DESC_AFA_FGTS'	   		,	fDesc("SX5","30"+SRA->RA_AFASFGT,"X5_DESCRI")			, "@!"						,STR0106	} )

		If cPaisLoc <> "PER"
			aAdd( aExp, {'GPE_VIN_EMP_RAIS'			,	SRA->RA_VIEMRAI											, "SRA->RA_VIEMRAI"			,STR0107	} )
			aAdd( aExp, {'GPE_DESC_VIN_EMP_RAIS'	,	fDesc("SX5","25"+SRA->RA_VIEMRAI,"X5_DESCRI")			, "@!"						,STR0108	} )
		EndIf

		aAdd( aExp, {'GPE_COD_INST_RAIS'			,	SRA->RA_GRINRAI											, "SRA->RA_GRINRAI"			,STR0109	} )
		aAdd( aExp, {'GPE_DESC_GRAU_INST'			,	fDesc("SX5","26"+SRA->RA_GRINRAI,"X5_DESCRI")			, "@!"						,STR0110	} )
		aAdd( aExp, {'GPE_COD_RESC_RAIS'	   		,	SRA->RA_RESCRAI											, "SRA->RA_RESCRAI"			,STR0111	} )
		aAdd( aExp, {'GPE_CRACHA'		  	   		,	SRA->RA_CRACHA											, "SRA->RA_CRACHA"			,STR0112	} )
		aAdd( aExp, {'GPE_REGRA_APONTA'		   		,	SRA->RA_REGRA											, "SRA->RA_REGRA"			,STR0113	} )
		aAdd( aExp, {'GPE_NO_REGISTRO'	 	   		,	SRA->RA_REGISTR											, "SRA->RA_REGISTR"			,STR0115	} )
		aAdd( aExp, {'GPE_NO_FICHA'	    	   		,	SRA->RA_FICHA											, "SRA->RA_FICHA"			,STR0116	} )
		aAdd( aExp, {'GPE_TP_CONT_TRAB'		   		,	SRA->RA_TPCONTR											, "SRA->RA_TPCONTR"			,STR0117	} )
		aAdd( aExp, {'GPE_DESC_TP_CONT_TRAB'		,	SRA->(IF(RA_TPCONTR="1","Indeterminado","Determinado")), "@!"						,STR0118	} )
		aAdd( aExp, {'GPE_APELIDO'		   			,	SRA->RA_APELIDO											, "SRA->RA_APELIDO"			,STR0119	} )
		aAdd( aExp, {'GPE_E-MAIL'		 			,	SRA->RA_EMAIL											, "SRA->RA_EMAIL"			,STR0120	} )
		aAdd( aExp, {'GPE_TEXTO_01'			   		,	cTexto_01								   				, "@!"						,STR0121	} )
		aAdd( aExp, {'GPE_TEXTO_02'					,	cTexto_02												, "@!"						,STR0122	} )
		aAdd( aExp, {'GPE_TEXTO_03'					,	cTexto_03												, "@!"						,STR0123	} )
		aAdd( aExp, {'GPE_TEXTO_04'					,	cTexto_04												, "@!"						,STR0124	} )
		aAdd( aExp, {'GPE_EXTENSO_SAL'		   		,	Extenso( SRA->RA_SALARIO , .F. , 1 )					, "@!"						,STR0125 	} )
		aAdd( aExp, {'GPE_DDATABASE'				,	dDataBase                    	        				, "" 						,STR0126	} )
		aAdd( aExp, {'GPE_DIA_DDATABASE'			,	StrZero( Day( dDataBase ) , 2 )            				, "@!"						,STR0127	} )
		aAdd( aExp, {'GPE_MES_DDATABASE'			,	MesExtenso( dDataBase ) 								, "@!"						,STR0128	} )
		aAdd( aExp, {'GPE_ANO_DDATABASE'			,	StrZero( Year( dDataBase ) , 4 )            			, "@!"						,STR0129	} )
		aAdd( aExp, {'GPE_NOME_EMPRESA' 			,	aInfo[03]                              					, "@!"						,STR0130	} )
		//aAdd( aExp, {'GPE_END_EMPRESA'				,	aInfo[04]                              					, "@!"						,STR0131	} )
		aAdd( aExp, {'GPE_END_EMPRESA'				,	IIf(SRA->RA_FILIAL="01","RUA PROFº. ALFONSO JOSÉ FIORAVANTI, 63",IIf(SRA->RA_FILIAL="02","AV. NELSON PALMA TRAVASSOS 651","")) , "@!",STR0131	} )
		
		 	
		aAdd( aExp, {'GPE_CID_EMPRESA'		   		,	aInfo[05]                              					, "@!"						,STR0132	} )
		aAdd( aExp, {'GPE_CEP_EMPRESA'         		,   aInfo[07]                                              	, "!@R #####-###"          	,STR0034 	} )
		aAdd( aExp, {'GPE_EST_EMPRESA'         		,   aInfo[06]												, "@!"						,STR0032 	} )
		//aAdd( aExp, {'GPE_CGC_EMPRESA' 		   		,	aInfo[08]             								, "@R ##.###.###/####-##"	,STR0134	} )
		aAdd( aExp, {'GPE_CGC_EMPRESA' 		   		,	IIf(SRA->RA_FILIAL="01","48.240.709/0001-90",IIf(SRA->RA_FILIAL="02","48.240.709/0003-52","")) 	, ""	,STR0134	} )
		
		
		aAdd( aExp, {'GPE_INSC_EMPRESA' 	   		,	aInfo[09]                              					, "@!" 						,STR0135	} )
		aAdd( aExp, {'GPE_TEL_EMPRESA'	 			,	aInfo[10]                              					, "@!" 						,STR0136	} )
		aAdd( aExp, {'GPE_FAX_EMPRESA'         		,   If(aInfo[11]#nil ,aInfo[11], "        ")              	, "@!"                     	,STR0136 	} )
		aAdd( aExp, {'GPE_BAI_EMPRESA'				,	aInfo[13]                              					, "@!" 						,STR0137	} )
		aAdd( aExp, {'GPE_DESC_RESC_RAIS'			,	fDesc("SX5","31"+SRA->RA_RESCRAI,"X5_DESCRI")			, "@!" 						,STR0138	} )
		aAdd( aExp, {'GPE_DIA_DEMISSAO'		   		,	StrZero( Day( SRA->RA_DEMISSA ) , 2 )					, "@!" 						,STR0139	} )
		aAdd( aExp, {'GPE_MES_DEMISSAO'				,	StrZero( Month( SRA->RA_DEMISSA ) , 2 )					, "@!" 						,STR0140 	} )
		aAdd( aExp, {'GPE_ANO_DEMISSAO'				,	StrZero( Year( SRA->RA_DEMISSA ) , 4 )					, "@!" 						,STR0141 	} )

		If cPaisLoc == "BRA"
			aAdd( aExp, {'GPE_MES_ADEXT'		    ,	MesExtenso( Month( SRA->RA_ADMISSA ) )					, "@!"						,STR0155	} )
			aAdd( aExp, {'GPE_RG_EMISSAO'			,	SRA->RA_DTRGEXP											, "SRA->RA_DTRGEXP"       	,STR0242	} )
			aAdd( aExp, {'GPE_CTPS_EMISSAO'			,	SRA->RA_DTCPEXP											, "SRA->RA_DTCPEXP"       	,STR0243	} )
			aAdd( aExp, {'GPE_FECREI'				, 	SRA->RA_FECREI											, "SRA->RA_FECREI" 			,STR0178	} )
			aAdd( aExp, {'GPE_HRDIA'				,	SRA->RA_HRSDIA											, "SRA->RA_HRSDIA"			,STR0218	} )
		EndIf

		aAdd( aExp, {'GPE_FUNC_COR'					,	If( SRA->RA_RACACOR == "1" , "Indígena" , ( If( SRA->RA_RACACOR == "2" , "Branca" , ( If( SRA->RA_RACACOR == "4" , "Negra" , ( If( SRA->RA_RACACOR == "6" , "Amarela" , ( If( SRA->RA_RACACOR == "8" , "Parda" , "Não informado" ) ) ) ) ) ) ) ) ) 											, "@!"       	,STR0244	} )

		If SRA->(FieldPos("RA_POSTO"  )) # 0
			aAdd( aExp, {'GPE_POSTO'	,	SRA->RA_POSTO  ,	"SRA->RA_POSTO"		,STR0182 	} )	//Codigo do Posto
		EndIf

		aAdd( aExp, {'GPE_DESC_EST_CIV'  ,	fDesc("SX5","33"+SRA->RA_ESTCIVI,"X5DESCRI()")	, "SRA->RA_ESTCIVI"	,STR0194	} ) //Descricao do Estado Civil

		If cPaisLoc == "BRA"

			//Variaveis criadas para utilizacao no DCN/DMN Documento de Cadastro/Manutencao do NIS - PIS
			cEstCiv :=SRA->RA_ESTCIVI  					//Adequacao do estado civil conforme o leiaute do DCN/DMN - PIS
			Do Case
				Case cEstCiv$"C|M"
					cEstCiv :="CASADO(A)
				Case cEstCiv$"D"
					cEstCiv :="DIVORCIADO(A)
				Case cEstCiv$"Q"
					cEstCiv :="SEPARADO(A)
				Case cEstCiv$"S"
					cEstCiv :="SOLTEIRO(A)
				Case cEstCiv$"V"
					cEstCiv :="VIUVO(A)
			EndCase

			cTipCertd := SRA->RA_TIPCERT 				//Adequacao da descricao do certificado civil conforme o leiaute do DCN/DMN - PIS
			Do Case
				Case cTipCertd == "1"
					cTipCertd :=OemToAnsi(STR0317)
				Case cTipCertd == "2"
					cTipCertd :=OemToAnsi(STR0318)
				Case cTipCertd == "3"
					cTipCertd :=OemToAnsi(STR0317)
				Case cTipCertd == "4"
					cTipCertd :=OemToAnsi(STR0320)
			EndCase

			cGrauInstr :=SRA->RA_GRINRAI
			Do Case										//Adequacao da descricao do grau de instrucao conforme o leiaute do DCN/DMN - PIS
				Case cGrauInstr == "10"
					cGrauInstr := OemToAnsi(STR0295)
				Case cGrauInstr == "20"
					cGrauInstr := OemToAnsi(STR0296)
				Case cGrauInstr == "25"
					cGrauInstr := OemToAnsi(STR0297)
				Case cGrauInstr == "30"
					cGrauInstr := OemToAnsi(STR0298)
				Case cGrauInstr == "35"
					cGrauInstr := OemToAnsi(STR0299)
				Case cGrauInstr == "40"
					cGrauInstr := OemToAnsi(STR0300)
				Case cGrauInstr == "45"
					cGrauInstr := OemToAnsi(STR0301)
				Case cGrauInstr == "50"
					cGrauInstr := OemToAnsi(STR0302)
				Case cGrauInstr == "55"
					cGrauInstr := OemToAnsi(STR0303)
				Case cGrauInstr == "65"
					cGrauInstr := OemToAnsi(STR0304)
				Case cGrauInstr == "75"
					cGrauInstr := OemToAnsi(STR0305)
				Case cGrauInstr == "85"
					cGrauInstr := OemToAnsi(STR0306)
				Case cGrauInstr == "95"
					cGrauInstr := OemToAnsi(STR0307)
			EndCase
			//
			aAdd( aExp, {'GPE_NACION_BRASILEIRA'	,SRA->(IF(RA_BRNASEX$"1","",(IF(RA_NACIONA$"10","x",""))))						 	 		,"SRA->RA_BRNASEX"	, STR0250   } ) // "Marca 'x' se Nacionalidade Brasileira"
			aAdd( aExp, {'GPE_NACION_ESTRANGEIRA'	,SRA->(IF(RA_BRNASEX$"1","",(IF(RA_NACIONA$"10","",(IF(RA_NACIONA$"20","","x"))))))			,"SRA->RA_BRNASEX"	, STR0251   } ) // "Marca 'x' se Nacionalidade Extrangeira"
			aAdd( aExp, {'GPE_NACION_BRA_NATURA'	,SRA->(IF(RA_BRNASEX$"1","",(IF(RA_NACIONA$"10","",(IF(RA_NACIONA$"20","x",""))))))			,"SRA->RA_BRNASEX"	, STR0252   } ) // "Marca 'x' se Nacionalidade Brasileira Naturalizada"
			aAdd( aExp, {'GPE_NACION_BRA_NASC_EXTE'	,SRA->(IF(RA_BRNASEX$"1","x",""))			 													,"SRA->RA_BRNASEX"	, STR0253   } ) // "Marca 'x' se Nacionalidade Brasileiro Nascido no Exterior"
			aAdd( aExp, {'GPE_EST_CIVIL_DCN'  		,cEstCiv																						,"SRA->RA_ESTCIVI"	, STR0254	} ) // "Estado civil de acordo com o NIS/PIS"
			aAdd( aExp, {'GPE_NOME_PAI_DCN'	   		,SRA->(IF(Empty (SRA->RA_PAI),"IGNORADO",SRA->RA_PAI))											,"SRA->RA_PAI"		, STR0255	} ) // "Nome do Pai, informa IGNORADO caso esteja em branco"
			aAdd( aExp, {'GPE_NOME_MAE_DCN'	   		,SRA->(IF(Empty (SRA->RA_MAE),"IGNORADA",SRA->RA_MAE))											,"SRA->RA_MAE"		, STR0256	} ) // "Nome da Mae, informa IGNORADO caso esteja em branco"
			aAdd( aExp, {'GPE_COMPLEM_RG'			,SRA->RA_COMPLRG																				,"SRA->RA_COMPLRG"	, STR0257   } ) // "Complemento do RG"
			aAdd( aExp, {'GPE_TIP_CERTID'			,cTipCertd																						,"SRA->RA_TIPCERT"	, STR0258   } ) // "Tipo de Certidao Civil"
			aAdd( aExp, {'GPE_EMIS_CERTID'			,SRA->RA_EMICERT																				,"SRA->RA_EMICERT"	, STR0259   } ) // "Data de Emissao da Certidao Civil"
			aAdd( aExp, {'GPE_MAT_CERTID'			,SRA->RA_MATCERT																				,"SRA->RA_MATCERT"	, STR0260   } ) // "Termo/Matricula da Certidao Civil"
			aAdd( aExp, {'GPE_LIVRO_CERT'			,SRA->RA_LIVCERT																				,"SRA->RA_LIVCERT"	, STR0261   } ) // "Livro da Certidao Civil"
			aAdd( aExp, {'GPE_FOLHA_CERT'			,SRA->RA_FOLCERT																				,"SRA->RA_FOLCERT"	, STR0262   } ) // "Folha da Certidao Civil"
			aAdd( aExp, {'GPE_CART_CERTID'			,SRA->RA_CARCERT																				,"SRA->RA_CARCERT"	, STR0263   } ) // "Cartorio da Certidao Civil"
			aAdd( aExp, {'GPE_UF_CERTIDAO'			,SRA->RA_UFCERT			 																		,"SRA->RA_UFCERT"	, STR0264   } ) // "UF da Certidao Civil"
			aAdd( aExp, {'GPE_MUN_CERTIDAO'			,fDesc("CC2",SRA->RA_UFCERT+SRA->RA_CDMUCER,"CC2_MUN")											,"SRA->RA_MUNCERT"	, STR0265   } ) // "Municipio da Certidao Civil"
			aAdd( aExp, {'GPE_NUM_PASSAPOR'			,SRA->RA_NUMEPAS																				,"SRA->RA_NUMEPAS"	, STR0266   } ) // "Numero do Passaporte"
			aAdd( aExp, {'GPE_EMIS_PASSAPOR'		,SRA->RA_EMISPAS																				,"SRA->RA_EMISPAS"	, STR0267   } ) // "Orgao Emissor do Passaporte"
			aAdd( aExp, {'GPE_UF_PASSAPORTE'		,SRA->RA_UFPAS  																				,"SRA->RA_UFPAS"	, STR0268   } ) // "UF do Passaporte"
			aAdd( aExp, {'GPE_DT_EMIS_PAS'			,SRA->RA_DEMIPAS																				,"SRA->RA_DEMIPAS"	, STR0269   } ) // "Data Emissao Passaporte"
			aAdd( aExp, {'GPE_DT_VALID_PAS'			,SRA->RA_DVALPAS																				,"SRA->RA_DVALPAS"	, STR0270   } ) // "Data Validade Passaporte"
			aAdd( aExp, {'GPE_PAIS_PASSAPOR'		,fDesc("CCH",SRA->RA_CODPAIS,"CCH_PAIS")														,"SRA->RA_PAISPAS"	, STR0271   } ) // "Pais de Emissao Passaporte"
			aAdd( aExp, {'GPE_NUM_NATURALIZ'		,SRA->RA_NUMNATU																				,"SRA->RA_NUMNATU"	, STR0272   } ) // "Numero de Naturalizacao"
			aAdd( aExp, {'GPE_DATA_NATURALIZ'		,SRA->RA_DATNATU																				,"SRA->RA_DATNATU"	, STR0273   } ) // "Data de Naturalizacao"
			aAdd( aExp, {'GPE_NUMERO_RIC'			,SRA->RA_NUMRIC 																				,"SRA->RA_NUMRIC" 	, STR0274   } ) // "Numero do RIC"
			aAdd( aExp, {'GPE_EMISSAO_RIC'			,SRA->RA_EMISRIC																				,"SRA->RA_EMISRIC"	, STR0275   } ) // "Orgao Emissor do RIC"
			aAdd( aExp, {'GPE_UF_RIC'				,SRA->RA_UFRIC  																				,"SRA->RA_UFRIC"  	, STR0276   } ) // "UF do RIC"
			aAdd( aExp, {'GPE_MUNICIPIO_RIC'		,fDesc("CC2",SRA->RA_UFRIC+SRA->RA_CDMURIC,"CC2_MUN")											,"SRA->RA_MUNIRIC"	, STR0277   } ) // "Municipio do RIC"
			aAdd( aExp, {'GPE_DATA_EXP_RIC'			,SRA->RA_DEXPRIC																				,"SRA->RA_DEXPRIC"	, STR0278   } ) // "Data de Expedicao do RIC"
			aAdd( aExp, {'GPE_TIPO_ENDERECO_COM'	,SRA->(IF(RA_TIPENDE$"1","x" ,""))																,"SRA->RA_TIPENDE"	, STR0279   } ) // "Marca 'x' se Endereco for Comercial"
			aAdd( aExp, {'GPE_TIPO_ENDERECO_RES'	,SRA->(IF(RA_TIPENDE$"2","x" ,""))																,"SRA->RA_TIPENDE"	, STR0280   } ) // "Marca 'x' se Endereco for Residencial"
			aAdd( aExp, {'GPE_NUM_ENDERECO'			,SRA->RA_NUMENDE																				,"SRA->RA_NUMENDE"	, STR0281   } ) // "Numero do Endereco"
			aAdd( aExp, {'GPE_CAIXA_POSTAL'			,SRA->RA_CPOSTAL																				,"SRA->RA_CPOSTAL"	, STR0282  	} ) // "Caixa Postal"
			aAdd( aExp, {'GPE_CEP_CAIXA_POSTAL'		,SRA->RA_CEPCXPO																				,"SRA->RA_CEPCXPO"	, STR0283	} ) // "CEP da Caixa Postal"
			aAdd( aExp, {'GPE_DDD_TELEFONE'			,SRA->RA_DDDFONE																				,"SRA->RA_DDDFONE"	, STR0284   } ) // "DDD do Telefone"
			aAdd( aExp, {'GPE_DDD_CELULAR'			,SRA->RA_DDDCELU																				,"SRA->RA_DDDCELU"	, STR0285   } ) // "DDD do Celular"
			aAdd( aExp, {'GPE_NUM_CELULAR'			,SRA->RA_NUMCELU																				,"SRA->RA_NUMCELU"	, STR0286   } ) // "Numero do Celular"
			aAdd( aExp, {'GPE_EMPRESA_TIPO_CNPJ'	,IF(aInfo[15]==2,"x","")																		,"@!"				, STR0287	} ) // "Marca 'x' se Empresa por CNPJ"
			aAdd( aExp, {'GPE_EMPRESA_TIPO_CEI'		,IF(aInfo[15]==1,"x","")																		,"@!"				, STR0288	} ) // "Marca 'x' se Empresa por CEI"
			aAdd( aExp, {'GPE_DATA_CHEGADA'			,SRA->RA_DATCHEG																				,"SRA->RA_DATCHEG"	, STR0289   } ) // "Data de Expedicao do RIC"
			aAdd( aExp, {'GPE_SECAO'				,SRA->RA_SECAO												  									,"SRA->RA_SECAO"	, STR0290  	} ) // "Secao Eleitoral"
			aAdd( aExp, {'GPE_INST_DCN'				,cGrauInstr																						,"@!"				, STR0291	} ) // "Grau de Instrucao conforme NIS/PIS"
			aAdd( aExp, {'GPE_PAIS_ORIGEM_PIS'		,SRA->(IF(RA_NACIONA<>"10" .OR. RA_BRNASEX=="1",fDesc("CCH",SRA->RA_CPAISOR,"CCH_PAIS"),""))	,"SRA->RA_PAISORI"	, STR0292   } ) // "Pais de Origem para o DCN/DMN"
			aAdd( aExp, {'GPE_COD_UF_NASCTO_PIS'	,SRA->(IF(RA_NACIONA=="10" .AND. RA_BRNASEX<>"1",SRA->RA_NATURAL,""))	    					,"SRA->RA_NATURAL"	, STR0308   } ) // "Estado de Nascimento NIS/PIS"
			aAdd( aExp, {'GPE_MUNICIPIO_NASCTO_PIS'	,SRA->(IF(RA_NACIONA=="10" .AND. RA_BRNASEX<>"1",SRA->RA_MUNNASC,""))							,"SRA->RA_MUNNASC"	, STR0309	} ) // "Municipio de Nascimento NIS/PIS"
			aAdd( aExp, {'GPE_TIPO_MANUT_NIS_ALTER'	,IF(cTipNIS=="1","x","")																		,"@!"				, STR0310	} )	// "Marca 'x' para tipo de DMN - Alteracao"
			aAdd( aExp, {'GPE_TIPO_MANUT_NIS_CADAS'	,IF(cTipNIS=="2","x","")																		,"@!"				, STR0311	} )	// "Marca 'x' para tipo de DMN - Cadastro Retroativo"
			aAdd( aExp, {'GPE_TIPO_MANUT_NIS_CANCE'	,IF(cTipNIS=="3","x","")																		,"@!"				, STR0312	} )	// "Marca 'x' para tipo de DMN - Cancelamento"
			aAdd( aExp, {'GPE_TIPO_MANUT_NIS_REATI'	,IF(cTipNIS=="4","x","")																		,"@!"				, STR0313	} )	// "Marca 'x' para tipo de DMN - Reativacao"
			aAdd( aExp, {'GPE_TIPO_MANUT_NIS_RETRO'	,IF(cTipNIS=="5","x","")																		,"@!"				, STR0314	} )	// "Marca 'x' para tipo de DMN - Retroacao Cadastral"
			aAdd( aExp, {'GPE_COD_SEXO_MASCULINO'	,SRA->(IF(RA_SEXO=="M","x",""))																    , "SRA->RA_SEXO"	, STR0315	} )	// "Marca 'x' se sexo for Masculino"
			aAdd( aExp, {'GPE_COD_SEXO_FEMININO'	,SRA->(IF(RA_SEXO=="F","x",""))																    , "SRA->RA_SEXO"	, STR0316	} )	// "Marca 'x' se sexo for Feminino"
			aAdd( aExp, {'GPE_COD_SERVENTIA'		,SRA->RA_SERVENT 																				, "SRA->RA_SERVENT"	, STR0336	} )	// Codigo da Serventia
			aAdd( aExp, {'GPE_COD_ACERVO'			,SRA->RA_CODACER 																				, "SRA->RA_CODACER"	, STR0337	} )	// Codigo do Acervo
			aAdd( aExp, {'GPE_REG_CIVIL'			,SRA->RA_REGCIVI 																				, "SRA->RA_REGCIVI"	, STR0338	} )	// Registro Civil
			aAdd( aExp, {'GPE_TIPO_LIVRO'			,SRA->RA_TPLIVRO																				, "SRA->RA_TPLIVRO"	, STR0339	} )	// Tipo do Livro Reg.

			cCodAtiv := POSICIONE("SQ3",1,XFILIAL("SQ3")+SRA->RA_CARGO,"Q3_DESCDET")
			dbSelectArea("SQ3")
			//aAdd( aExp, {'GPE_CARGO_ATIVIDADE'			,MSMM(cCodAtiv,80)																			, "@!"	, STR0390	} )	// "Descrição da atividade da função"
		EndIf
	EndIf
Return(aExp)
