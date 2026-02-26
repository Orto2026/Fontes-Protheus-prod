#include "rwmake.ch"                                         
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#include 'topconn.ch'
#Include "TBIConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XMLNFE    ºAutor  ³Pearson/ Dema       º Data ³ 03/01/12    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao das notas Fiscais Eletronicas em XML para       º±±
±±º          ³ Alimentacao da PRE-NOTA DE ENTRADA (MOD.COMPRAS)           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAtualiza  ³ 22.03.12 - Escopo.2 - COnf. email.dia:29.02.12.Raphael     ¹±±
±±º          ³ -em anexo: .DOc.                                           º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XMLNFE(aParam)
/*
ABA- HELP.:
1= Ok.Já Gerado a Pre-Nota = Finalizado; = VERMELHO 
2= Sem P.C= Quando informado "000000". Neste caso prever workflow de envio de e-mail para o usuário que digitalizou o documento. = Verde
3= Documento com PC Inexistente - Quando informado, mas Nao Encontrado na tabela de pedidos (SC7). = AZUL
4= Documento com PC Inválido - Quando informado, mas não atende um ou mais dos critérios do item 1, no caso de devolução ao digitalizador, permitir a informação do motivo.
5= Ok.Nao Gerado a Pre-Nota = Finalizado; = MARROM 
Local aLegenda	:=	{{"BR_VERMELHO" 	,"NFe= Pre.Nota-Fiscal Gerada"}						,;
                     {"BR_AMARELO"   	,"Informado P.C= 000000-> Sem P.C."		}   ,;
                     {"BR_PRETO"     	,"Nao Encontrado, P.C.= Inexistente"	}		,;
                     {"BR_CINZA"     	,"PC Invalido = Bloqueado/ Ja Entregue"	} }

*/

Local aCores		:= {	;
							{ 'ZO_JAEXP == "1"'  ,"BR_VERMELHO"		},;		// Classificado  - GERADO A PRE-NOTA.FISCAL
							{ 'ZO_JAEXP == "2"'  ,"BR_AMARELO"		},;	 	// A Classificar- Quando Informado P.C= 000000-> Sem P.C.
							{ 'ZO_JAEXP == "3"'  ,"BR_PRETO"		},;	 	// A Classificar- Quando NAO ENCONTRADO o P.C.= Inexistente.SC7 
							{ 'ZO_JAEXP == "4"'  ,"BR_CINZA"		},;	 	// A Classificar- Quando NAO ENCONTRADO o P.C.= Inexistente.SC7 
							{ 'ZO_JAEXP == "5"'  ,"BR_MARROM"		}}	 	// A Classificar- Erro ao Gerar Pre - Nota

Private cCadastro 	:= "Importacao da NFe- ENTRADA."
Private cAlias	 	:= "SZO"
Private aRotina 	:= MenuDef()

_lAgend := .F.

If Type('__LocalDriver') == "U" .Or. _lAgend
	If !_lAgend
		Prepare Environment Empresa aParam[1] Filial aParam[2] FUNNAME "XMLNFE" 
		_lAgend := .T.
	EndIf
	CONOUT("Iniciando Processo Agendado - XMLNFE")
	U_XMLNFE1()
	CONOUT("Fim do Processo Agendado - XMLNFE")
Else
	dbSelectArea(cAlias)
	dbSetOrder(1)
	mBrowse( 6,1,22,75,cAlias,,,,,,aCores)
	
	dbSelectArea(cAlias)
	dbSetOrder(1)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XMLNFE1   ºAutor  ³Pearson             º Data ³ 03/01/12    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao das notas Fiscais Eletronicas em XML para       º±±
±±º          ³ Alimentacao da PRE-NOTA DE ENTRADA (MOD.COMPRAS)           º±±
±±º          ³ Preparado para Outros Modelos de XML (Privado)             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XMLNFE1()
Local I
cError 		:= ""
cWarning 	:= ""

oNF 			:= NIL
cFile 		:= ""
xResult 		:= ''
_cMens		:= ''
_cXml			:= 'NFE' //TIPO DE LEIAUTE DA NFe = 'NFE=DA RECEITA-FEDERAL.SECRET. DA FAZENDA; READSOFT= DA EMPRESA READSOFT'
_aArea		:= GetArea()
_cEmpAnt		:= cEmpAnt
_cFilAnt		:= cFilAnt
cDrive3		:=''
cDir3			:=''
cFile3		:=''
cExten3		:=''
_lErroFor 	:=.F.
_lEmProces 	:=.F.

_cPath		:= ""
_cImgTif		:= ""
_cImgTif1	:= ""

dbSelectArea("SX6")
dbSetOrder(1)	
If !MsSeek('  '+'MV_XMLSB1')
	RecLock("SX6",.T.) 	/// SE O PARÂMETRO NÃO EXISTE - CRIA O COD,.PRODUTO-PADRAO P/ COMPRAS 
	Field->X6_FIL		:= "  "                                   
	Field->X6_VAR		:= 'MV_XMLSB1'
	Field->X6_TIPO		:= "C"
	Field->X6_DESCRIC	:= "Codigo do Produto.Padrao, p/Compras "
	Field->X6_DSCSPA	:= "Codigo do Produto.Padrao, p/Compras"
	Field->X6_DSCENG	:= "Codigo do Produto.Padrao, p/Compras"
	Field->X6_CONTEUD	:= 'PADRAO_CP'
	Field->X6_CONTSPA	:= 'PADRAO_CP'
	Field->X6_CONTENG	:= 'PADRAO_CP'
	MsUnlock()
EndIf

If !_lAgend
	_cEmpXml := "" //Variavel para Saber de Qual Empresa/Filial Pertence o XML para Mover o Arquivo para a Pasta Correta - Sera Atualizada na Funcao XMLNFE2
	aRegs :={}
	cPerg := PADR("RXMLNFE",Len(SX1->X1_GRUPO))

	Aadd(aRegs,{cPerg,"01","Informe o Diretorio ?", "" , "" ,"mv_ch1","C",30,0,0,"G","","mv_par01","","","","","","","","","","","" ,"","","","","","","","","","","","","","","","","" } )

   ValidPerg( aRegs, cPerg)
   
   If Pergunte(cPerg, .T.)
 	  	xMv_Par01 := AllTrim(Mv_Par01)
   	If Right(AllTrim(xMv_Par01),1)<>"\"
   		xMv_Par01 := AllTrim(xMv_Par01)+"\"
   	EndIf
		aFiles := Directory(AllTrim(xMv_Par01)+"*.XML")
   Else
   	Return()
   EndIf

	For _xnI := 1 to Len(aFiles)
		cFile 	:= AllTrim(xMv_Par01)+aFiles[_xnI,1]
		cFile2 	:= AllTrim(xMv_Par01)+aFiles[_xnI,1]
		_cMens	:= ""

		If empty(cFile)
			Return()
		Else
			If SubStr(cFile,2,1)==":"
				nHdl 	:=	FOpen(cFile)
				nTam	:=	Int(FSeek(nHdl,0,2))
				xBuffer:=Space(nTam)
				FSEEK(nHdl,0,0)
				FREAD(nHdl,@xBuffer,nTam)
			
				SplitPath( cFile, @cDrive3, @cDir3, @cFile3, @cExten3 )
				cFile := "\neogrid\NFe\"+cFile3+cExten3
				MEMOWRITE( cFile , xBuffer)
				FCLOSE(nHdl)
			EndIf
		Endif
	
		SplitPath( cFile, @cDrive3, @cDir3, @cFile3, @cExten3 )
		MAKEDIR(cDir3+ 'ERRO') // Cria o diretorio no servidor Advanced protheus
		_cPath	:= cDir3
			
		cFileAux := SubStr(cFile,At("\NFe\",Lower(cFile))+5,Len(cFile))
		oXml := XmlParserFile(cFile, "_", @cError, @cWarning )
		If !empty(cError)
			alert('Erro No Arquivo (FORA DE LEIAUTE) .:'+ chr(13)+chr(10)+;
			'-'+ cError )
			_cMens	+= '-> Nao Foi Possivel Importar o Arqvuivo.Tipo->.XML  - Erro de Leitura...' + Chr(13)+chr(10)
			_cMens	+= '   Mensagem de Erro.: '+ alltrim(cError) + chr(13)+chr(10)
			_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
			_cMens	+= '   Local.: \SERVIDOR'+ cFile
			GeraTxt(_cMens)
			__Copyfile(cFile,_cPath+"ERRO\"+cFileAux)
			Ferase(cFile)
			return()
		Endif
		If XmlChildEx(oXml, "_NFEPROC") <> NIL
			_cPath 	:= "\neogrid\NFe\"
			XMLNFE2()	 			// LAYOUT : NFe- DA SECRETARIA DA FAZENDA.SEFAZ (RECEITA FEDERAL)
		Elseif XmlChildEx(oXml, "_DOCUMENTS") <> NIL
			_cPath 	:= "\ReadSoft\NFe\"
			XMLNFE3()		// LAYOUT : NFe- DA EMPRESA READSOFT
		Else
			Alert("1- Arquivo.XML Incompativel> NFe- Eletronica.Versao 2.0;" +CHR(13)+CHR(10)+;
			"2- Arquivo.XML Incompativel> READSOFT - Versao 1.0" )
			_cMens	+= '-> Arquivo Incompativel-Leiaute com a NFe-Eletronica.Versao 2.0 Ou READSOFT.V1.0'  + Chr(13)+chr(10)
			_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
			_cMens	+= '   Local.: \SERVIDOR'+ cFile
			GeraTxt(_cMens)
		EndIf
		If _lErroFor 
			_cEmpXml := "Erro"
			_lErroFor := .F.
		EndIf
		If Empty(_cMens)
			__Copyfile(cFile2,cFile2+"_.PROC")
			Ferase(cFile2)
		EndIf
		
		If _lErroFor 
			_cEmpXml := "Erro\"
			_lErroFor := .F.
		EndIf

		MAKEDIR(_cPath + _cEmpXml)  // Cria o diretorio no servidor Advanced protheus
		__Copyfile(cFile,_cPath+_cEmpXml+cFileAux)
		Ferase(cFile)
		__Copyfile(_cImgTif1,_cPath+_cEmpXml+_cImgTif)
		Ferase(_cImgTif1)
	
	Next _xnI
	
Else
	_cEmpXml := "" //Variavel para Saber de Qual Empresa/Filial Pertence o XML para Mover o Arquivo para a Pasta Correta - Sera Atualizada na Funcao XMLNFE2
	MAKEDIR("\neogrid\")  	// Cria o diretorio no servidor Advanced protheus
	_cPath 	:= "\neogrid\NFe\"
	MAKEDIR(_cPath)  // Cria o diretorio no servidor Advanced protheus
	aFiles	:= Directory(_cPath+"*.XML")
	
	For I := 1 to Len(aFiles)
		conout("PROCESSANDO ARQUIVO " + aFiles[I,1])
		
		cFile	:= _cPath+aFiles[I,1]
		SplitPath( cFile, @cDrive3, @cDir3, @cFile3, @cExten3 )
		oXml	:= XmlParserFile(cFile, "_", @cError, @cWarning )
		

		If Type('oXml') <> "U" .And. XmlChildEx(oXml, "_NFEPROC") <> NIL
			XMLNFE2()	 			// LAYOUT : NFe- DA SECRETARIA DA FAZENDA.SEFAZ (RECEITA FEDERAL)
		Else
			Alert("1- Arquivo.XML Incompativel> NFe- Eletronica.Versao 2.0;" +CHR(13)+CHR(10)+;
			"2- Arquivo.XML Incompativel> READSOFT - Versao 1.0" )
			_cMens	+= '-> Arquivo Incompativel-Leiaute com a NFe-Eletronica.Versao 2.0 Ou READSOFT.V1.0'  + Chr(13)+chr(10)
			_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
			_cMens	+= '   Local.: \SERVIDOR'+ cFile
			GeraTxt(_cMens)
		EndIf

/*
		If XmlChildEx(oXml, "_NFEPROC") <> NIL
			XMLNFE2()
		else
			Conout("Arquivo Incompativel.:"+aFiles[I,1]+" com a NFe-Eletronica.Versao 2.0 Ou READSOFT.V1.0")
			_cMens	+= '-> Arquivo Incompativel-Leiaute.:'+alltrim(aFiles[I,1]) +'-> com a NFe-Eletronica.Versao 2.0 Ou READSOFT.V1.0'  + Chr(13)+chr(10)
			_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
			_cMens	+= '   Local.: \SERVIDOR'+ cFile
			GeraTxt(_cMens)
		ENDIF
*/
		If _lErroFor
			_cEmpXml := "Erro\"
			_lErroFor := .F.
		EndIf
		MAKEDIR(_cPath + _cEmpXml)  // Cria o diretorio no servidor Advanced protheus
		__Copyfile(_cPath+aFiles[I,1],_cPath+_cEmpXml +aFiles[I,1])
		Ferase(_cPath+aFiles[I,1])
	Next
	
	For I := 1 to Len(aFiles)
		conout("PROCESSANDO ARQUIVO " + aFiles[I,1])
		
		cFile	:= _cPath+aFiles[I,1]
		SplitPath( cFile, @cDrive3, @cDir3, @cFile3, @cExten3 )
		oXml	:= XmlParserFile(cFile, "_", @cError, @cWarning )
		
		__Copyfile(_cPath+aFiles[I,1],_cPath+"Proc\"+ aFiles[I,1])		
		Ferase(_cPath+aFiles[I,1])		
		
		If XmlChildEx(oXml, "_NFEPROC") <> NIL
			XMLNFE2()
		else
			Conout("Arquivo Incompativel.:"+aFiles[I,1]+" com a NFe-Eletronica.Versao 2.0 Ou READSOFT.V1.0")
		ENDIF
		
		__Copyfile(_cPath+"Proc\"+aFiles[I,1],_cPath+ aFiles[I,1])		

		If _lErroFor
			_cEmpXml := "Erro\"
			_lErroFor := .F.
		EndIf
		MAKEDIR(_cPath + _cEmpXml)  // Cria o diretorio no servidor Advanced protheus
		__Copyfile(_cPath+aFiles[I,1],_cPath+_cEmpXml+ aFiles[I,1])
		Ferase(_cPath+aFiles[I,1])
		__Copyfile(_cImgTif1,_cPath+_cEmpXml+_cImgTif)
		Ferase(_cImgTif1)
	Next
EndIf

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XMLNFE2   ºAutor  ³Pearson             º Data ³ 03/01/12    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao das notas Fiscais Eletronicas em XML para       º±±
±±º          ³ Alimentacao da PRE-NOTA DE ENTRADA (MOD.COMPRAS)           º±±
±±º          ³ Preparado para NFe-V2.0 (Secr.da Fazenda.SP e Federeal)    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ NFe-V2.0 - SEFAZ                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras                                                    º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XMLNFE2()
Local I
Local nX
Private oNF 		:= oXml:_NFeProc:_NFe
Private oInf  		:= oNF:_InfNfe
Private oEmit  	:= oNF:_InfNfe:_Emit
Private oEmit1		:= oNF:_InfNfe:_Emit:_enderEmit
Private oIde  		:= oNF:_InfNfe:_ide
Private oDest  	:= oNF:_InfNfe:_dest
Private oTot  		:= oNF:_InfNfe:_Total
Private oDet   	:= Iif( XmlChildEx(oNF:_InfNfe,'_DET') 		  			<> Nil 	, oNF:_InfNfe:_det		, Nil)
Private oTrans 	:= Iif( XmlChildEx(oNF:_InfNfe, "_TRANSP" )				<> Nil 	, oNF:_InfNfe:_TRANSP	, Nil)
Private oTransA	:= Iif( XmlChildEx(oTrans	  , "_TRANSPORTA")			<> Nil 	, oTrans:_TRANSPORTA		, Nil)
Private oTransB	:= Iif( XmlChildEx(oTrans	  , "_VEICTRANSP")			<> Nil 	, oTrans:_veicTransp		, Nil)
Private oTransC	:= Iif( XmlChildEx(oTrans	  , "_REBOQUE")				<> Nil 	, oTrans:_reboque			, Nil)
Private oTransD	:= Iif( XmlChildEx(oTrans	  , "_VOL" )					<> Nil 	, oTrans:_vol				, Nil)
Private oTicms  	:= Iif( XmlChildEx(oTot,"_ICMSTOT") 						<> Nil	, oTot:_ICMSTot			, Nil)	//-TOTAL (ICMS.IPI.II.PIS.COFINS.OUTRO.FRETE.SEGURO.DESCTO.)
Private oTiss   	:= Iif( XmlChildEx(oTot, "_ISSQNTOT")						<> Nil	, oTot:_ISSQNtot			, Nil) 	//-TOTAL ISS.
Private oTRET   	:= Iif( XmlChildEx(oTot, "_RETTRIB") 						<> Nil	, oTot:_retTrib			, Nil)  //-TOTAL RETENCOES (IR.INSS.PCC)
Private oCompra 	:= Iif( XmlChildEx(oNF:_InfNfe, "_COMPRA") 				<> Nil	, oNF:_InfNfe:_compra	, Nil)	//-INF. DA COMPRA (ORIGEM)
Private oCobr   	:= IIf( XmlChildEx(oNF:_InfNfe, "_COBR") 					<> Nil	, oNF:_InfNfe:_Cobr 		, Nil)  //-Grupo de Cobrança G A01 0-1
Private oFat 		:= IIf( oCobr <> Nil .And. XmlChildEx(oCobr, "_FAT") <> Nil	, oCobr:_fat 				, Nil)  //-Grupo da Fatura G Y01 0-111
Private oDup 		:= IIf( oCobr <> Nil .And. XmlChildEx(oCobr, "_DUP") <> Nil	, oCobr:_dup 				, Nil)  //-Grupo da Fatura G Y01 0-1
Private oinfAdic	:= IIf( XmlChildEx(oNF:_InfNfe, "_INFADIC") 				<> Nil	, oNF:_InfNfe:_infAdic 	, Nil)  //-Grupo de Informações Adicionais G A01 0-1
Private oinf2		:= Nil //IIf( XmlChildEx(oNF:_InfNfe:_infAdic,"_OBSCONT")<>Nil, oNF:_InfNfe:_infAdic:_obsCont 	, Nil)  //-Grupo do campo de uso livr1e do contribuinte G Z01 0-10 Campo de uso livre do contribuinte, informar o nome do campo no atributo xCampo e o conteúdo do campo no xTexto
Private oDet 		:= IIf(ValType(oDet)=="O",{oDet},oDet)

_cCGC					:= Iif( XmlChildEx(oEmit,'_CNPJ') <> Nil, oEmit:_cnpj:Text, Nil)
_cCGCDest			:= Iif( XmlChildEx(oDest,'_CNPJ') <> Nil, oDest:_cnpj:Text, Nil)

// A - Dados da Nota Fiscal eletrônica
//              A01 infNFe Grupo das informações da NFe G Raiz - 1-1 - Grupo que contém as informações da NF-e
// BLOCO-A: 	oInf
//				oInf:= oNF:_InfNFe
//				oNF := oXml:_NFeProc:_NFe
_FILIAL 	:= xFilial('SZO')
_VERSAO	:= Iif( XmlChildEx(oInf, "_VERSAO" )<> Nil 	, oInf:_versao:Text	, '')
_Nfe		:= substr(alltrim(oInf:_ID:Text),4)
_NFEID	:= _Nfe

// B - Identificação da Nota Fiscal eletrônica
//              B01 ide Grupo das informações de identificação da NF-e G A01 1-1
// BLOCO-B: 	oIde
//				oIde := oNF:_InfNfe:_ide
//				oNF  := oXml:_NFeProc:_NFe
_CUF		:= Iif( XmlChildEx(oIde,'_CUF')	 		<> Nil 	, oIde:_cUF:Text	, '') // Código da UF do emitente do Documento Fiscal E B01 N 1-1 2 Código da UF do emitente do Documento Fiscal. Utilizar a Tabela do IBGE de código de unidades da federação (Anexo IV - Tabela de UF, Município e País).
_CNF		:= Iif( XmlChildEx(oIde,'_CNF')	 		<> Nil 	, oIde:_cNF:Text	, '') // Código Numérico que compõe a Chave de Acesso E B01 N 1-1 8 Código numérico que compõe a Chave de Acesso. Número aleatório gerado pelo emitente para cada NF-e para evitar acessos indevidos da NF-e. (v2.0)
_NATUREZ	:= Iif( XmlChildEx(oIde,'_NATOP') 		<> Nil 	, oIde:_natOp:Text	, '') // Descrição da Natureza da Operação E B01 C 1-1 1-60 Informar a natureza da operação de que decorrer a saída ou a entrada, tais como: venda, compra, transferência,
_INDPAG	:= Iif( XmlChildEx(oIde,'_INDPAG') 		<> Nil 	, oIde:_indPag:Text	, '') // Indicador da forma de pagamento E B01 N 1-1 1 0 – pagamento à vista; 1 – pagamento à prazo; 2 - outros.
_MOD		:= Iif( XmlChildEx(oIde,'_MOD')	 		<> Nil 	, oIde:_mod:Text	, '') // Código do Modelo do Documento Fiscal E B01 C 1-1 2 Utilizar o código 55 para identificação da NF-e, emitida em substituição ao modelo 1 ou 1A.
_SERIE	:= Iif( XmlChildEx(oIde,'_SERIE')		<> Nil 	, oIde:_serie:Text	, '') // Série do Documento Fiscal E B01 N 1-1 1-3 Série do Documento Fiscal, preencher com zeros na hipótese de a NF-e não possuir série. (v2.0) Série 890-899 de uso exclusivo para emissão de NF-e avulsa,pelo contribuinte com seu certificado digital, através do site do Fisco (procEmi=2). (v2.0) Serie 900-999 – uso exclusivo de NF-e emitidas no SCAN.(v2.0)
_DOC		:= Iif( XmlChildEx(oIde,'_NNF')			<> Nil 	, STRZERO(VAL(oIde:_nNF:Text), TAMSX3('F1_DOC')[1])	, '') //Número do Documento Fiscal E B01 N 1-1 1-9 Número do Documento Fiscal.
If _VERSAO <= "2.00"
	_EMISSAO	:= Iif( XmlChildEx(oIde,'_DEMI')			<> Nil  , Ctod(SubStr(oIde:_dEmi:Text,9,2)+"/"+SubStr(oIde:_dEmi:Text,6,2)+"/"+SubStr(oIde:_dEmi:Text,1,4)) , ctod('') ) // Data de emissão do Documento Fiscal E B01 D 1-1 Formato “AAAA-MM-DD”
	_DTSE		:= Iif( XmlChildEx(oIde,'_DSAIENT') 	<> Nil  , Ctod(SubStr(oIde:_dSaiEnt:Text,9,2)+"/"+SubStr(oIde:_dSaiEnt:Text,6,2)+"/"+SubStr(oIde:_dSaiEnt:Text,1,4)) , ctod('') )  //Data de Saída ou da Entrada da Mercadoria/Produto E B01 D 0-1 Formato “AAAA-MM-DD”
Else
	_EMISSAO	:= Iif( XmlChildEx(oIde,'_DHEMI')		<> Nil  , Ctod(SubStr(oIde:_dhEmi:Text,9,2)+"/"+SubStr(oIde:_dhEmi:Text,6,2)+"/"+SubStr(oIde:_dhEmi:Text,1,4)) , ctod('') ) // Data de emissão do Documento Fiscal E B01 D 1-1 Formato “AAAA-MM-DD”
	_DTSE		:= Iif( XmlChildEx(oIde,'_DHSAIENT') 	<> Nil  , Ctod(SubStr(oIde:_dhSaiEnt:Text,9,2)+"/"+SubStr(oIde:_dhSaiEnt:Text,6,2)+"/"+SubStr(oIde:_dhSaiEnt:Text,1,4)) , ctod('') )  //Data de Saída ou da Entrada da Mercadoria/Produto E B01 D 0-1 Formato “AAAA-MM-DD”
EndIf
//_EMISSAO	:= Iif( XmlChildEx(oIde,'_DEMI')			<> Nil 	, Ctod(SubStr(oIde:_dEmi:Text,9,2)+"/"+SubStr(oIde:_dEmi:Text,6,2)+"/"+SubStr(oIde:_dEmi:Text,1,4)) , ctod('') ) // Data de emissão do Documento Fiscal E B01 D 1-1 Formato “AAAA-MM-DD”
//_DTSE		:= Iif( XmlChildEx(oIde,'_DSAIENT') 	<> Nil	, Ctod(SubStr(oIde:_dSaiEnt:Text,9,2)+"/"+SubStr(oIde:_dSaiEnt:Text,6,2)+"/"+SubStr(oIde:_dSaiEnt:Text,1,4)) , ctod('') )  //Data de Saída ou da Entrada da Mercadoria/Produto E B01 D 0-1 Formato “AAAA-MM-DD”
_CNUMFG	:= Iif( XmlChildEx(oIde,'_CMUNFG')  	<> Nil 	, oIde:_cMunFG:Text	, '') // Código do Município de E B01 N 1-1 7 Informar o município de ocorrência do fato gerador do ICMS. Utilizar a Tabela do IBGE (Anexo VII - Tabela de UF, Município e País)
_TPEMIS	:= Iif( XmlChildEx(oIde,'_TPEMIS')  	<> Nil  , oIde:_tpEmis:Text	, '') // Tipo de Emissão da NF-e E B01 N 1-1 1 1 – Normal – emissão normal;2 – Contingência FS – emissão em contingência com impressão do DANFE Segurança; 3 – Contingência SCAN – emissão em contingência no Sistema de Contingência do Ambiente Nacional – SCAN; 4 – Contingência DPEC - emissão em contingência com envio da Declaração Prévia de Emissão em Contingência – DPEC; 5 – Contingência FS-DA - emissão em contingência com impressão do DANFE em Formulário de Segurança para Impressão de Documento Auxiliar de Documento Fiscal Eletrônico (FS-DA).
_TPAMB	:= Iif( XmlChildEx(oIde,'_TPAMB')		<> Nil  , oIde:_tpAmb:Text	, '')  	  // Identificação do Ambiente E B01 N 1-1 1 1-Produção/ 2-Homologação
_FINNFE	:= Iif( XmlChildEx(oIde,'_FINNFE')  	<> Nil  , oIde:_finNFe:Text	, '') // Finalidade de emissão da NFe E B01 N 1-1 1 1- NF-e normal/ 2-NF-e complementar / 3 – NF-e de ajuste

// C - Identificação do Emitente da Nota Fiscal eletrônica
//              C01 emit Grupo de identificação do emitente da NF-e G A01 1-1
// BLOCO-C: 	oEmit
//				oEmit := oNF:_InfNfe:_Emit
//				oNF   := oXml:_NFeProc:_NFe
_XNOME	:= Iif( XmlChildEx(oEmit,'_XNOME' ) <> Nil  , oEmit:_xNome:Text	, '') // Razão Social ou Nome do emitente E C01 C 1-1 2-60
_XFANT	:= Iif( XmlChildEx(oEmit,'_XFANT' ) <> Nil  , oEmit:_xFant:Text	, '') // Nome fantasia E C01 C 0-1 1-60

// C - Identificação do Emitente da Nota Fiscal eletrônica
//              C05 enderEmit Grupo do Endereço do emitente G C01 1-1
// BLOCO-C05: 	oEmit1
//				oEmit1  := oNF:_InfNfe:_Emit:_enderEmit
//				oNF    := oXml:_NFeProc:_NFe
_XLGR		:= Iif( XmlChildEx(oEmit1,'_XLGR' )		<> Nil  , oEmit1:_xLgr:Text	, '') // Logradouro E C05 C 1-1 2-60
_NRO 		:= Iif( XmlChildEx(oEmit1,'_NRO' )	 	<> Nil  , oEmit1:_nro:Text	, '') // Número E C05 C 1-1 1-60
_XCPL		:= Iif( XmlChildEx(OEMIT1, "_XCPL")		<> Nil 	, oEmit1:_xCpl:Text	, '') // Complemento E C05 C 0-1 1-60
_XBAIRRO	:= Iif( XmlChildEx(oEmit1,'_XBAIRRO')	<> Nil  , oEmit1:_xBairro:Text,'')// Bairro E C05 C 1-1 2-60
_CMUN		:= Iif( XmlChildEx(oEmit1,'_CMUN' ) 	<> Nil  , oEmit1:_cMun:Text	, '') // Código do município E C05 N 1-1 7 Utilizar a Tabela do IBGE (Anexo VII - Tabela de UF, Município e País).	ZO_XMUN
_XMUN		:= Iif( XmlChildEx(oEmit1,'_XMUN' ) 	<> Nil  , oEmit1:_xMun:Text	, '') // Nome do município E C05 C 1-1 2-60
_UF		:= Iif( XmlChildEx(oEmit1,'_UF' ) 		<> Nil  , oEmit1:_UF:Text	, '') // Sigla da UF E C05 C 1-1 2
_CEP		:= Iif( XmlChildEx(oEmit1,'_CEP'  ) 	<> Nil  , oEmit1:_CEP:Text	, '') // Sigla DO CEP.E C05 N 0-1 8 Informar os zeros não significativos.
_CPAIS	:= Iif( XmlChildEx(oEmit1,'_CPAIS' ) 	<> Nil  , oEmit1:_cPais:Text, '') // Código do País E C05 N 0-1 4 1058 - Brasil
_XPAIS	:= Iif( XmlChildEx(oEmit1,'_XPAIS' ) 	<> Nil  , oEmit1:_xPais:Text, '') // Nome do País E C05 N 0-1 60 1058 - Brasil
_FONE		:= Iif( XmlChildEx(oEmit1,'_FONE' ) 	<> Nil  , oEmit1:_fone:Text,  '') // Telefone E C05 N 0-1 6-14 Preencher com o Código DDD + número do telefone. Nas operações com exterior é permitido informar o código do país + código da localidade + número do telefone (v.2.0)

// C - Identificação do Emitente da Nota Fiscal eletrônica -
//              C01 emit Grupo de identificação do emitente da NF-e G A01 1-1
// BLOCO-C: 	oEmit
//				oEmit := oNF:_InfNfe:_Emit
//				oNF   := oXml:_NFeProc:_NFe
_IE		:= Iif( XmlChildEx(oEmit,'_IE' ) 	<> Nil  , oEmit:_IE:Text,  '')  	// IE E C01 C 1-1 0-14 Campo de informação obrigatória nos casos de emissão própria (procEmi = 0,
_CRT		:= Iif( XmlChildEx(oEmit,'_CRT' ) 	<> Nil  , oEmit:_CRT:Text,  '')  	// Código de Regime Tributário E C01 N 1-1 1 Este campo será obrigatoriamente preenchido com:1 – Simples Nacional; 2 – Simples Nacional – excesso de sublimite de receita bruta; 3 – Regime Normal. (v2.0).

// D - Identificação do Fisco Emitente da NF-e - EXCLUSIVO DO FISCO - NAO SERA IMPORTADO ( FACULTATIVO )
// E - Identificação do Destinatário da Nota Fiscal eletrônica -  E01- SOMENTE O CAMPO: _CNPJ (_cCGC)   // - NAO SERA IMPORTADO ( FACULTATIVO )
// F - Identificação do Local de Retirada // - NAO SERA IMPORTADO ( FACULTATIVO )
// G - Identificação do Local de Entrega  // - NAO SERA IMPORTADO ( FACULTATIVO )
// H - Detalhamento de Produtos e Serviços da NF-e  ATE  ( U )

// W - Valores Totais da NF-e
// W01 total Grupo de Valores Totais da NF-e G A01 1-1
// W02- ICMSTot Grupo de Valores Totais referentes ao ICMS G W01 1-1
// BLOCO-W02:   oTicms
// 				oTicms:= oTot:_ICMSTot
//				oTot  := oNF:_InfNfe:_Total
//				oNF   := oXml:_NFeProc:_NFe
If TYPE('OTICMS')<> 'U'
	_VBCICM	:= Iif( XmlChildEx(oTicms,'_VBC' ) 		<> Nil  , VAL(oTicms:_vBC:Text)		,  0)  	// Base de Cálculo do ICMS E W02 N 1-1 15 2
	_VICM		:= Iif( XmlChildEx(oTicms,'_VICMS') 	<> Nil  , VAL(oTicms:_vICMS:Text)	,  0)  	// Valor Total do ICMS E W02 N 1-1 15 2
	_BCICMST	:= Iif( XmlChildEx(oTicms,'_VBCST') 	<> Nil  , VAL(oTicms:_vBCST:Text)	,  0)  	// Base de Cálculo do ICMS ST E W02 N 1-1 15 2
	_VICMST	:= Iif( XmlChildEx(oTicms,',_VST') 		<> Nil  , VAL(oTicms:_vST:Text)		,  0)  	// Valor Total do ICMS ST E W02 N 1-1 15 2
	_VPROD	:= Iif( XmlChildEx(oTicms,'_VPROD') 	<> Nil  , VAL(oTicms:_vProd:Text)	,  0)  	// Valor Total dos produtos e serviços E W02 N 1-1 15 2
	_VFRETE	:= Iif( XmlChildEx(oTicms,'_VFRETE') 	<> Nil  , VAL(oTicms:_vFrete:Text)	,  0)  	// Valor Total do Frete E W02 N 1-1 15 2
	_VSEG		:= Iif( XmlChildEx(oTicms,'_VSEG')	 	<> Nil  , VAL(oTicms:_vSeg:Text)		,  0)  	// Valor Total do Seguro E W02 N 1-1 15 2
	_VDESC	:= Iif( XmlChildEx(oTicms,'_VDESC') 	<> Nil  , VAL(oTicms:_vDesc:Text)	,  0)  	// Valor Total do Desconto E W02 N 1-1 15 2
	_VII		:= Iif( XmlChildEx(oTicms,'_VII') 		<> Nil  , VAL(oTicms:_vII:Text)		,  0)  	// Valor Total do II E W02 N 1-1 15 2
	_VIPI		:= Iif( XmlChildEx(oTicms,'_VIPI') 		<> Nil  , VAL(oTicms:_vIPI:Text)		,  0)  	// Valor Total do IPI E W02 N 1-1 15 2
	_VPIS		:= Iif( XmlChildEx(oTicms,'_VPIS') 		<> Nil  , VAL(oTicms:_vPIS:Text)		,  0)  	// Valor do PIS - APURACAO  E W02 N 1-1 15 2
	_VCOF		:= Iif( XmlChildEx(oTicms,'_VCOFINS')	<> Nil  , VAL(oTicms:_vCOFINS:Text)	,  0)  	// Valor do COFINS - APURACAO  E W02 N 1-1 15 2
	_VOUTRO	:= Iif( XmlChildEx(oTicms,'_VOUTRO')	<> Nil  , VAL(oTicms:_vOutro:Text)	,  0)  	// Outras Despesas acessórias E W02 N 1-1 15 2
	_VNF		:= Iif( XmlChildEx(oTicms,'_VNF')		<> Nil  , VAL(oTicms:_vNF:Text)		,  0)  	// Valor Total da NF-e E W02 N 1-1 15 2
Else
	_VBCICM	:= 0
	_VICM		:= 0
	_BCICMST	:= 0
	_VICMST	:= 0
	_VPROD	:= 0
	_VFRETE	:= 0
	_VSEG		:= 0
	_VDESC	:= 0
	_VII		:= 0
	_VIPI		:= 0
	_VPIS		:= 0
	_VCOF		:= 0
	_VOUTRO	:= 0
	_VNF		:= 0
Endif

// W - Valores Totais da NF-e
// W01 total Grupo de Valores Totais da NF-e G A01 1-1
// W17- ISSQNtot Grupo de Valores Totais referentes ao ISSQN G W01 0-1
// BLOCO-W17:   oTiss
// 				oTiss := oTot:_ISSQNtot
//				oTot  := oNF:_InfNfe:_Total
//				oNF   := oXml:_NFeProc:_NFe
IF TYPE('OTISS')<> 'U'
	_VSERV		:= Iif( XmlChildEx(oTiss,'_VSERV')		<> Nil  , VAL(oTiss:_vServ:Text)		,  0)  	// Valor Total dos Serviços sob não-incidência ou não tributados pelo ICMS E W17 N 0-1 15 2
	_BCISS		:= Iif( XmlChildEx(oTiss,',_VBC')		<> Nil  , VAL(oTiss:_vBC:Text)		,  0)  	// Base de Cálculo do ISS E W17 N 0-1 15 2
	_VISS			:= Iif( XmlChildEx(oTiss,'_VISS')		<> Nil  , VAL(oTiss:_vISS:Text)		,  0)  	// Valor Total do ISS E W17 N 0-1 15 2
	_SEVPIS		:= Iif( XmlChildEx(oTiss,'_VPIS')		<> Nil  , VAL(oTiss:_vPIS:Text)		,  0)  	// Valor Total do PIS    -APURACAO  E W17 N 0-1 15 2
	_SERVCOF		:= Iif( XmlChildEx(oTiss,'_VCOFINS')	<> Nil  , VAL(oTiss:_vCOFINS:Text)	,  0)  	// Valor Total do COFINS -APURACAO  E W17 N 0-1 15 2
Else
	_VSERV		:= 0
	_BCISS		:= 0
	_VISS			:= 0
	_SEVPIS		:= 0
	_SERVCOF		:= 0
Endif
// BLOCO-W23:   oTRET  - Grupo de Retenções de Tributos G W01 0-1
// 				oTRET := oTot:_retTrib
//				oTot  := oNF:_InfNfe:_Total
//				oNF   := oXml:_NFeProc:_NFe
//-TOTAL RETENCOES (IR.INSS.PCC) - OBS.: NAO TEM-SE O ISS(RETIDO) ????
IF TYPE('OTRET')<> 'U'
	_VRETPIS		:= Iif( XmlChildEx(oTRET,'_VRETPIS' )		<> Nil  , VAL(oTRET:_vRetPIS:Text)		,  0)  	// Valor Retido de PIS     E W23 N 0-1 15 2
	_VRETCOF		:= Iif( XmlChildEx(oTRET,'_VRETCOFINS' )	<> Nil  , VAL(oTRET:_vRetCOFINS:Text)	,  0)  	// Valor Retido de COFINS  E W23 N 0-1 15 2
	_VRETCSL		:= Iif( XmlChildEx(oTRET,'_VRETCSLL' )		<> Nil  , VAL(oTRET:_vRetCSLL:Text)		,  0)  	// Valor Retido de CSLL    E W23 N 0-1 15 2
	_BCIRRF		:= Iif( XmlChildEx(oTRET,'_VBCIRRF' )		<> Nil  , VAL(oTRET:_vBCIRRF:Text)		,  0)  	// Base de Cálculo do IRRF E W23 N 0-1 15 2
	_VIRRF		:= Iif( XmlChildEx(oTRET,'_VIRRF' )			<> Nil  , VAL(oTRET:_vIRRF:Text)			,  0)  	// Valor Retido do IRRF    E W23 N 0-1 15 2
	_VINSS		:= Iif( XmlChildEx(oTRET,'_VRETPREV' )		<> Nil  , VAL(oTRET:_vRetPrev:Text)		,  0)  	// Valor Retido do INSS    E W23 N 0-1 15 2
else
	_VRETPIS		:= 0
	_VRETCOF		:= 0
	_VRETCSL		:= 0
	_BCIRRF		:= 0
	_VIRRF		:= 0
	_VINSS		:= 0
ENDIF

// X - Informações do Transporte da NF-e
// X01 transp Grupo de Informações do Transporte da NF-e G A01 1-1
// BLOCO-X01:   oTrans
//				oTrans:= oNF:_InfNfe:_TRANSP
//				oNF   := oXml:_NFeProc:_NFe
IF TYPE('OTRANS')<> 'U'
	_MDFRET		:= Iif( XmlChildEx(oTrans,'_MODFRETE' )	<> Nil  , oTrans:_modFrete:Text	,  '')  	// Modalidade do frete E X01 N 1-1 1 0- Por conta do emitente; 1- Por conta do destinatário/remetente; 2- Por conta de terceiros; 9- Sem frete. (V2.0)
else
	_MDFRET		:= ''
ENDIF
// X 	- Informações do Transporte da NF-e
// X03 	- Grupo Transportador G X01 0-1
// BLOCO-X03:   oTransA
//				oTransA	:= oTrans:_TRANSPORTA
//				oTrans  := oNF:_InfNfe:_TRANSP
//				oNF     := oXml:_NFeProc:_NFe
IF TYPE('OTRANSA')<> 'U'
	_FRCGC		:= Iif( XmlChildEx(oTransA,'_CNPJ' )	<> Nil  , oTransA:_CNPJ:Text		,  '')  	// CNPJ CE X03 C 0-1 14 Informar o CNPJ ou o CPF do Transportador, preenchendo os zeros não significativos.
	_FRNOME		:= Iif( XmlChildEx(oTransA,'_XNOME' )	<> Nil  , oTransA:_xNome:Text		,  '')  	// Razão Social ou nome E X03 C 0-1 1-60
	_FRIE   		:= Iif( XmlChildEx(oTransA,'_IE' )		<> Nil  , oTransA:_IE:Text			,  '')  	// Inscrição Estadual E X03 C 0-1 0,2-14
	_FREND		:= Iif( XmlChildEx(oTransA,'_XENDER' )	<> Nil  , oTransA:_xEnder:Text	,  '')  	// Endereço Completo E X03 C 0-1 1-60
	_FRXMUN		:= Iif( XmlChildEx(oTransA,'_XMUN' )	<> Nil  , oTransA:_xMun:Text		,  '')  	// Nome do município E X03 C 0-1 1-60
	_FRUF			:= Iif( XmlChildEx(oTransA,'_UF' )		<> Nil  , oTransA:_UF:Text			,  '')  	// Sigla da UF E X03 C 0-1 2 A UF deve ser informada se informado uma IE. (v2.0)
else
	_FRCGC		:= ''
	_FRNOME		:= ''
	_FRIE   		:= ''
	_FREND		:= ''
	_FRXMUN		:= ''
	_FRUF			:= ''
ENDIF
// X 	- Informações do Transporte da NF-e
// X03 	- Grupo Transportador G X01 0-1
// X18	- veicTransp Grupo Veículo GE X01 0-1 Informar o veículo trator (v2.0)
// BLOCO-X18:   oTransB
//				oTransB	:= oTrans:_veicTransp
//				oTrans  := oNF:_InfNfe:_TRANSP
//				oNF     := oXml:_NFeProc:_NFe
IF TYPE('OTRANSB')<> 'U'
	_PLACA1		:= Iif( XmlChildEx(oTransB,'_PLACA')	<> Nil  , oTransB:_placa:Text	,  '')  	// Placa do Veículo E X18 C 1-1 1-8
	_RNTC1		:= Iif( XmlChildEx(oTransB,'_RNTC')		<> Nil  , oTransB:_RNTC:Text	,  '')  	// Registro Nacional de Transportador de Carga (ANTT)E X18 C 0-1 1-20
else
	_PLACA1		:= ''
	_RNTC1		:= ''
ENDIF
// X 	- Informações do Transporte da NF-e
// X03 	- Grupo Transportador G X01 0-1
// X22	- reboque Grupo Reboque G X01 0-5 Informar os reboques/Dolly (v2.0)
// BLOCO-X22:   oTransC
//				oTransC	:= oTrans:_reboque
//				oTrans  := oNF:_InfNfe:_TRANSP
//				oNF     := oXml:_NFeProc:_NFe
IF TYPE('OTRANSC')<> 'U'
	_PLACA2		:= Iif( XmlChildEx(oTransC,'_PLACA')	<> Nil  , oTransC:_placa:Text	, '')  	// Placa do Veículo E X22 C 1-1 1-8
	_PLUF2		:= Iif( XmlChildEx(oTransC,'_UF' )		<> Nil  , oTransC:_UF:Text		, '')   // Placa do Veículo - UF  E X22 C 1-1 1-2
	_RNTC2		:= Iif( XmlChildEx(oTransC,'_RNTC')		<> Nil  , oTransC:_RNTC:Text	, '')  	// Registro Nacional de Transportador de Carga (ANTT)E X22 C 0-1 1-20
else
	_PLACA2		:= ''
	_PLUF2		:= ''
	_RNTC2		:= ''
ENDIF
// X 	- Informações do Transporte da NF-e
// X03 	- Grupo Transportador G X01 0-1
// X26	- vol Grupo Volumes G X01 0-N
// BLOCO-X26:   oTransD
//				oTransD	:= oTrans:_VOL
//				oTrans  := oNF:_InfNfe:_TRANSP
//				oNF     := oXml:_NFeProc:_NFe
IF TYPE('OTRANSD')<> 'U'
	If TYPE('OTRANSD')== "O"
		_QVOL		:= Iif( XmlChildEx(oTransD,'_QVOL' )<> Nil  , VAL(oTransD:_qvol:Text)	,  0 )  	// Quantidade de volumes transportados E X26 N 0-1 1-15
		_ESP		:= Iif( XmlChildEx(oTransD,'_ESP')	<> Nil  , oTransD:_esp:Text			,  '')  	// Espécie dos volumes transportados E X26 C 0-1 1-60
		_MARCA	:= Iif( XmlChildEx(oTransD,'_MARCA')<> Nil  , oTransD:_marca:Text		,  '')  	// Marca dos volumes transportados  E X26 C 0-1 1-60
		_NVOL		:= Iif( XmlChildEx(oTransD,'_NVOL' )<> Nil  , oTransD:_nVol:Text			,  '')  		// Numeração dos volumes transportados E X26 C 0-1 1-60
		_PESOL	:= Iif( XmlChildEx(oTransD,'_PESOL')<> Nil  , VAL(oTransD:_pesoL:Text)	,  0)  	// Peso Líquido (em kg) E X26 N 0-1 15 3
		_PESOB	:= Iif( XmlChildEx(oTransD,'_PESOB')<> Nil  , VAL(oTransD:_pesoB:Text)	,  0)  	// Peso BRUTO   (em kg) E X26 N 0-1 15 3
	ElseIf TYPE('OTRANSD')== "A"
		_QVOL		:= Iif( XmlChildEx(oTransD[1],'_QVOL' )<> Nil  , VAL(oTransD[1]:_qvol:Text)	,  0 )  	// Quantidade de volumes transportados E X26 N 0-1 1-15
		_ESP		:= Iif( XmlChildEx(oTransD[1],'_ESP')	<> Nil   , oTransD[1]:_esp:Text			,  '')  	// Espécie dos volumes transportados E X26 C 0-1 1-60
		_MARCA	:= Iif( XmlChildEx(oTransD[1],'_MARCA')<> Nil  , oTransD[1]:_marca:Text		,  '')  	// Marca dos volumes transportados  E X26 C 0-1 1-60
		_NVOL		:= Iif( XmlChildEx(oTransD[1],'_NVOL' )<> Nil  , oTransD[1]:_nVol:Text			,  '')  		// Numeração dos volumes transportados E X26 C 0-1 1-60
		_PESOL	:= Iif( XmlChildEx(oTransD[1],'_PESOL')<> Nil  , VAL(oTransD[1]:_pesoL:Text)	,  0)  	// Peso Líquido (em kg) E X26 N 0-1 15 3
		_PESOB	:= Iif( XmlChildEx(oTransD[1],'_PESOB')<> Nil  , VAL(oTransD[1]:_pesoB:Text)	,  0)  	// Peso BRUTO   (em kg) E X26 N 0-1 15 3
	EndIf
else
	_QVOL		:= 0
	_ESP		:= ''
	_MARCA	:= ''
	_NVOL		:= ''
	_PESOL	:= 0
	_PESOB	:= 0
ENDIF

// Y – Dados da Cobrança
// Y01 cobr Grupo de Cobrança G A01 0-1
// Y02 fat Grupo da Fatura	  G Y01 0-1
// BLOCO-Y02:   oFat
// 				oFat  := oCobr:_fat 			//-Grupo da Fatura G Y01 0-1
//				oCobr := oNF:_InfNfe:_Cobr
//				oNF   := oXml:_NFeProc:_NFe
IF TYPE('oFat')<> 'U'
	_NFAT		:= Iif( XmlChildEx(oFat,'_NFAT') <> Nil  	, oFat:_nFat:Text			,  '')  	// Número da Fatura E Y02 C 0-1 1-60
	_VORIG	:= Iif( XmlChildEx(oFat,'_VORIG')<> Nil  	, VAL(oFat:_vOrig:Text)	,  0 )  	// Valor Original da Fatura E Y02 N 0-1 15 2
	_FATDESC	:= Iif( XmlChildEx(oFat,'_VDESC')<> Nil  	, VAL(oFat:_vDesc:Text)	,  0 )  	// Valor do desconto E Y02 N 0-1 15 2
	_VLIQ		:= Iif( XmlChildEx(oFat,'_VLIQ') <> Nil  	, VAL(oFat:_vLiq:Text)	,  0 )  	// Valor Líquido da Fatura E Y02 N 0-1 15 2
else
	_NFAT		:= ''
	_VORIG	:= 0
	_FATDESC	= 0
	_VLIQ		:= 0
endif

// BLOCO-Y07:   oDup - Grupo da Duplicata G Y01 0-N
// 				oDup :=  oCobr:_dup
//				oCobr := oNF:_InfNfe:_Cobr
//				oNF   := oXml:_NFeProc:_NFe
/*
IF TYPE('oDup')<> 'U'
	_NDUP		:= Iif( XmlChildEx(oDup[1],'_NDUP')  <> Nil  	, oDup[1]:_nDup:Text		,  ''  )  	// Número da Duplicata E Y07 C 0-1 1-60
	_DVENC	:= Iif( XmlChildEx(oDup[1],'_DVENC') <> Nil  	, Ctod(SubStr(oDup[1]:_dVenc:Text,9,2)+"/"+SubStr(oDup[1]:_dVenc:Text,6,2)+"/"+SubStr(oDup[1]:_dVenc:Text,1,4)) , ctod('') ) // Data de emissão do Documento Fiscal E B01 D 1-1 Formato “AAAA-MM-DD” 		,  ctod('')  )  	// Número da Duplicata E Y07 C 0-1 1-60
	_VDUP		:= Iif( XmlChildEx(oDup[1],'_VDUP')  <> Nil  	, VAL(oDup[1]:_vDup:Text)	,  0   )  	// Valor da duplicata E Y07 N 0-1 15 2
ELSE
*/
	_NDUP		:= ''
	_DVENC	:= ctod('')
	_VDUP		:= 0
//ENDIF

// BLOCO- Z01 infAdic Grupo de Informações Adicionais G A01 0-1
// 				oinfAdic
//				oinfAdic := oNF:_InfNfe:_infAdic
//				oNF   	:= oXml:_NFeProc:_NFe
IF TYPE('oinfAdic')<> 'U'
	_INFADFI	:= Iif( XmlChildEx(oinfAdic,'_INFADFISCO')	<> Nil	, oinfAdic:_infAdFisco:Text	,  ''  ) // Informações Adicionais de Interesse do Fisco E Z01 C 0-1 1-2000 (v2.0)
	_INFCPL	:= Iif( XmlChildEx(oinfAdic,'_INFCPL')			<> Nil	, oinfAdic:_infCpl:Text 		,  ''  ) // Informações Complementares de interesse do Contribuinte E Z01 C 0-1 1- 5000
ELSE
	_INFADFI	:= ''
	_INFCPL	:= _NATUREZ
ENDIF

// BLOCO- Z04 obsCont Grupo do campo de uso livre do contribuinte G Z01 0-10
// Campo de uso livre do contribuinte, informar o nome do campo no atributo xCampo e o conteúdo do campo no xTexto
//				oinf2
// 				oinf2		:= oinfAdic:_obsCont
//				oinfAdic 	:= oNF:_InfNfe:_infAdic
//				oNF   		:= oXml:_NFeProc:_NFe
IF TYPE('oinf2')<> 'U'
	_XCAMPO	:= Iif( XmlChildEx(oinf2,'_XCAMPO')  <> Nil	, oinf2:_xCampo:Text 	,  ''  ) // Identificação do campo A Z04 C 1-1 1-20 Identificação do campo
	//		_XTEXTO		:= Iif( XmlChildEx(oinf2,'_XTEXTO')  <> Nil	, oinf2:_xTexto:Text	,  cfile  ) // Conteúdo do campo E Z04 C 1-1 1-60 Conteúdo do campo
	_XTEXTO	:= cFile
ELSE
	_XCAMPO	:= ''
	_XTEXTO	:= cFile
ENDIF

// ZB - Informações de Compras
// BLOCO- ZB01 compra Grupo de Compra G A01 0-1 Informação adicional de compra
//	oCompra
//	oCompra := oNF:_InfNfe:_compra		//-INF. DA COMPRA (ORIGEM)
//	oNF   	:= oXml:_NFeProc:_NFe
IF TYPE('oCompra')<> 'U'
	_XNEMP 	:= Iif( XmlChildEx(oCompra,'_XNEMP') <> Nil	, oCompra:_xNEmp:Text 	,  ''  ) // Nota de Empenho E ZB01 C 0-1 1-17 Informar a identificação da Nota de Empenho, quando se tratar de compras públicas
	_XPED		:= Iif( XmlChildEx(oCompra,'_XPED')  <> Nil	, oCompra:_xPed:Text 	,  ''  ) // Pedido E ZB01 C 0-1 1-60 Informar o pedido.
	_XCONTR 	:= Iif( XmlChildEx(oCompra,'_XCONT') <> Nil , oCompra:_xCont:Text 	,  ''  ) // Contrato E ZB01 C 0-1 1-60 Informar o contrato de compra
ELSE
	_XNEMP 	:= ''
	_XPED		:= ''
	_XCONTR 	:= ''
ENDIF
//
// DETALHES DA nfE.
//
	_aNITEM := {}
	_aB1COD := {}
	_aCPROD := {}
	_aXPROD := {}
	_aNCM   := {}
	_aCFOP  := {}
	_aUCOM  := {}
	_aQCOM  := {}
	_aVUNCOM:= {}
	_aVPROD := {}
	_aPC    := {}
	_aPCITEM:= {}       
	
	_aDescont	:= {}
	_aDespesa	:= {}
	_aCST			:= {}
	_aInfIPI		:= {}
	_aInfICM		:= {}
	nLenDet := Len(oDet)

If TYPE('oDet')<> 'U'
	For nX := 1 to nLenDet
		aAdd(_aNITEM	, strzero(nX,3)  		)
		aAdd(_aB1COD	, '' 					)
		aAdd(_aCPROD 	, Iif( XmlChildEx(oDet[nx]:_Prod,'_CPROD' ) <> Nil , oDet[nx]:_Prod:_cProd:text 			, '' ) )
		aAdd(_aXPROD 	, Iif( XmlChildEx(oDet[nx]:_Prod,'_XPROD' ) <> Nil , oDet[nx]:_Prod:_xProd:text 			, '' ) )
		aAdd(_aNCM		, Iif( XmlChildEx(oDet[nx]:_Prod,'_NCM'   ) <> Nil , oDet[nx]:_Prod:_NCM:text 			, '' ) )
		aAdd(_aCFOP		, Iif( XmlChildEx(oDet[nx]:_Prod,'_CFOP'  ) <> Nil , oDet[nx]:_Prod:_CFOP:text 			, '' ) )
		aAdd(_aUCOM 	, Iif( XmlChildEx(oDet[nx]:_Prod,'_UCOM'  ) <> Nil , oDet[nx]:_Prod:_uCom:text 			, '' ) )
		aAdd(_aQCOM		, Iif( XmlChildEx(oDet[nx]:_Prod,'_QCOM'  ) <> Nil , val(oDet[nx]:_Prod:_qCom:text)		,  0 ) )
		aAdd(_aVUNCOM	, Iif( XmlChildEx(oDet[nx]:_Prod,'_VUNCOM') <> Nil , val(oDet[nx]:_Prod:_vUnCom:text)	,  0 ) )
		aAdd(_aVPROD	, Iif( XmlChildEx(oDet[nx]:_Prod,'_VPROD' ) <> Nil , val(oDet[nx]:_Prod:_vProd:text)	,  0 ) )

		//	Pega Impostos (ICMS/IPI) e Outras Despesas
		If Type("oDet[nX]:_Prod:_vDesc")<> "U"
			aAdd( _aDescont,Val(oDet[nX]:_Prod:_vDesc:TEXT))
		Else
			aAdd( _aDescont, 0 )
		EndIf

		If Type("oDet[nX]:_Imposto:_IPI:_IPITrib:_vIPI") <> "U"
			aAdd( _aInfIPI, {	If(Type("oDet[nX]:_Imposto:_IPI:_IPITrib:_vBC")<>"U", Val(oDet[nX]:_Imposto:_IPI:_IPITrib:_vBC:TEXT),0),;
								   If(Type("oDet[nX]:_Imposto:_IPI:_IPITrib:_pIPI")<>"U", Val(oDet[nX]:_Imposto:_IPI:_IPITrib:_pIPI:TEXT),0),;
								Val(oDet[nX]:_Imposto:_IPI:_IPITrib:_vIPI:TEXT)})
		Else
			aAdd( _aInfIPI, {0,0,0})
		EndIf

		Do Case
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS00")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS00
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS10")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS10
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS20")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS20
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS30")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS30
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS40")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS40
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS51")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS51
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS60")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS60
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS70")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS70
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS90")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS90
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN101")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN101
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN102")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN102
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN201")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN201
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN202")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN202
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN500")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN500
			Case Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN900")<> "U"
				oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN900
		End Case

		If ( Type( 'oICM:_CST:TEXT' ) ) <> 'U'
			aAdd( _aCST, Alltrim(oICM:_orig:TEXT)+Alltrim( oICM:_CST:TEXT))
		Else
			aAdd( _aCST, Space(3) )
		EndIf

		If Type("oICM:_vICMS") <> "U"
			_VBCICM	:= Iif( Type("oICM:_vBC") 		<> "U", Val(oICM:_vBC:Text)	, 0)
			_PCICM	:= Iif( Type("oICM:_pIcms") 	<> "U", Val(oICM:_pIcms:TEXT)	, 0)
			_VICMS	:= Iif( Type("oICM:_vICMS")  	<> "U", Val(oICM:_vIcms:TEXT)	, 0)
			aAdd( _aInfICM, {_VBCICM,_PCICM,_VICMS})
		ElseIf Type("oICM:_vCredICMSSN") <> "U"
			aAdd( _aInfICM, {	Val(oDet[nX]:_Prod:_vProd:TEXT),;
								Val(oICM:_pCredSN:TEXT),;
								Val(oICM:_vCredICMSSN:TEXT)})
		Else
			aAdd( _aInfICM, { 0, 0, 0 } )
		EndIf

		If Type("oDet[nX]:_Prod:_vOutro:TEXT") <> "U"
			aAdd( _aDespesa, Val( oDet[nX]:_Prod:_vOutro:TEXT))
		Else
			aAdd( _aDespesa, 0 )
		EndIf

	Next nX
Else
	nLenDet := 1
	aAdd(_aNITEM	, '001'  		)
	aAdd(_aB1COD	, getmv('XMLSB1',.F.,'PADRAO_CP') 	) //PRODUTO-PADRAO
	aAdd(_aCPROD 	, ' '  			)  
		
	DbSelectArea('SB1')
	DbSetOrder(1)
	If !DbSeek(XFilial('SB1')+ _aB1COD[1] ) 
		RecLock('SB1',.T.)                
		SB1->B1_FILIAL	:= xFilial('SB1')
		SB1->B1_COD		:='PADRAO_CP'
		SB1->B1_DESC	:='PADRAO.PRODUTO PARA COMPRAS' 
		SB1->B1_TIPO	:='PA'
		SB1->B1_UM		:='UN'
		SB1->B1_LOCPAD :='01'
		MsUnLock()
	EndIf
	aAdd(_aXPROD 	, SB1->B1_DESC )
	aAdd(_aNCM		, ''    			)
	aAdd(_aCFOP		, '' 		    	)
	aAdd(_aUCOM 	, '' 				)
	aAdd(_aQCOM		, 1  				)
	aAdd(_aVUNCOM	, _VORIG   		)
	aAdd(_aVPROD	, _VORIG   		)

EndIf

// GRAVAR OS DADOS- PARA AS TABELAS: SZO E SZP
GRAVAXML('NFE')

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GRAVAXML º Autor ³Pearson             º Data ³ 09/01/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Rotina de GRAVACAO do Cabecalho e Itens da NFe= SZO, SZP   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CR Almeida                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GRAVAXML(_cXml)
Local I
_cEmpOr		:= SM0->M0_NOME
_cFilOr		:= SM0->M0_FILIAL
_lErroFor   := .F.
_STATUS		:= '' //STATUS DA IMPORTACAO DO ARQUIVO.XML 
_HIST			:= '' //HISTORICO DA IMPORTACAO - MEMO = ZO_HIST 
_lErroFor	:= .F.

IF  _cXml=='NFE' // Nfe-Da Sercretaria da Fazenda-Receita.Federal
	// VERIFICA A EMPRESA.FILIAL DO SISTEMA = EMPRESA.FILIAL DA NFE. (PELO CNPJ)
	IF ALLTRIM(SM0->M0_CGC ) <> _cCGCDest
		_lOk:=.F.
		DbSelectArea("SM0")
		DbGoTop()
		While !eof()
			IF ALLTRIM(SM0->M0_CGC) = _cCGCDest
				_lOk:= .T.
				exit
			Endif
			DbSkip()
		Enddo
		If _lOk
			_cEmpDest := SM0->M0_NOME
			_cFilDest := SM0->M0_FILIAL
			MsgAlert('NFe-Entrada- Pertence a Outra Empresa.Filial do Sistema - Trocando !' + chr(13)+ chr(10)+ chr(13)+chr(10)+;
			'-De Origem.   EMPRESA-FILIAL : ' + _cEmpOr      + '-'+ _cFilOr  + chr(13)+chr(10)+ ;
			'-Para Destino.EMPRESA-FILIAL.: ' + SM0->M0_NOME + '-'+ SM0->M0_FILIAL )
			XMLGetEmpr(SM0->M0_CODIGO+SM0->M0_CODFIL)	// Trocar de Empresa.Filial - Conf. Rodape do Sistema
		ELSE
			alert('NFe-Entrada-> NAO ENCONTRADO A EMPRESA DO SISTEMA !' + chr(13)+chr(10)+;
			'-> Favor verificar o Cad. de Empresas - Pelo Configurador do Protheus ' )
			Conout('Data do Erro.:'+ dtoc(dDatabase) + ' -NFe-Entrada-> NAO ENCONTRADO A EMPRESA DO SISTEMA !' + chr(13)+chr(10)+;
			'- Arquivo.:' + cFile  )
			_cMens	+= '-> NAO ENCONTRADO A EMPRESA DO SISTEMA - CNPJ '// + _cCGCDest  + chr(13)+chr(10)
			_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
			_cMens	+= '   Local.: \SERVIDOR'+ cFile
			GeraTxt(_cMens)
			_lErroFor	:= .T.
			return()
		endif
	EndIf
ELSE        			
	_lErroFor	:= .T.
	Conout( 'Data do Erro.:'+ dtoc(dDatabase) + ' -NAO ENCONTRADO O LAYOUT (MODELO) DA NFe. !' + CHR(13)+CHR(10)+;
	'Arquivo.:' + cFile  )
	_cMens	+= '-> NAO ENCONTRADO O LAYOUT (MODELO: XML) DA NFe. (NFe ou ReadSoft)  !' + chr(13)+chr(10)
	_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
	_cMens	+= '   Local.: \SERVIDOR'+ cFile
	GeraTxt(_cMens)
	Return()
ENDIF

_cEmpXml := Alltrim(SM0->M0_CODIGO)+AllTrim(SM0->M0_CODFIL)+"\"
ChkFile("SZO")
ChkFile("SZP")
_FILIAL 	:= xFilial("SZO")
// VERIFICA O FORNECEDOR

If !SA2->(dbSetOrder(3), dbSeek(xFilial("SA2")+ _cCgc))
	MsgAlert(" CNPJ-FONECEDOR-> Nao Localizado - Verifique ! " + CHR(13)+CHR(10)+ ;
	'-CNPJ.: '+ TRANSFORM(_cCgc, '@R 99.999.999/9999-99') )
	_lErroFor := .T.
	_cMens	+= '-> NAO ENCONTRADO O FORNECEDOR (Emitente da NFe.ou ReadSoft) NO CAD. DE FORNECEDORES !' + chr(13)+chr(10)
	_cMens	+= '   FORNECEDOR.:'+ _XNOME
	_cMens	+= '   CNPJ.: '+ TRANSFORM(_cCgc, '@R 99.999.999/9999-99')
	_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
	_cMens	+= '   Local.: \SERVIDOR'+ cFile
	GeraTxt(_cMens)
	
	XMLGetEmpr(_cEmpAnt+_cFilAnt)
	//RestArea(_aArea)
	Return()
Endif

DbSelectArea("SZO")
DbSetOrder(1) //ZO_FILIAL + ZO_NFEID
If DbSeek(xFilial('SZO')+Padr(_Nfe,Len(SZO->ZO_NFEID)))
	If SZO->ZO_JAEXP == '1'
		Alert('NF-e - Ja Foi Importada...Abortando a Operacao !')
		_lErroFor := .T.
		_cMens	+= '-> NF-e - Ja Foi Importada...Abortando a Operacao ! ' + chr(13)+chr(10)
		_cMens	+= '   NFe- Numero.:'+ _Nfe + chr(13)+chr(10)
		_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
		_cMens	+= '   Local.: \SERVIDOR'+ cFile
		GeraTxt(_cMens)
		RecLock("SZO",.F.)
		SZO->ZO_IMAGEM	:= _cImgTif
		MsUnlock()
		
		XMLGetEmpr(_cEmpAnt+_cFilAnt)
		Return()
	Else
		RecLock("SZO",.F.)
		SZO->ZO_SEQ		:= SZO->ZO_SEQ + 1
		SZO->ZO_IMAGEM	:= _cImgTif
	Endif
Else
	RecLock("SZO",.T.)	             
	SZO->ZO_SEQ		:= 1 
	SZO->ZO_IMAGEM	:= _cImgTif
	SZO->ZO_NFEID	:= _Nfe
Endif
/*
For X1 := 1 to nLenDet   
	 MAURICIO - PARA ENTRADA DE NOTAS COM 4 CASAS DECIMAIS NA QUANTIDADE
	If NoRound(_aQCOM[X1] * _aVUNCOM[X1],4) <> Round(_aVPROD[X1],2) .And. NoRound(_aQCOM[X1] * _aVUNCOM[X1],4) <> Round(_aVPROD[X1],2)
		Alert('Total do Item Não Confere !')
		_lErroFor := .T.
		_cMens	+= '-> Valor Total do Item '+StrZero(X1,3)+' nao Confere com Calculo'+ chr(13)+chr(10)    // MAURICIO	_cMens	+= '-> Valor Total do Item ' + StrZero(I,4) + ' nao Confere com Calculo'+ chr(13)+chr(10)
		_cMens	+= '   NFe- Numero.:'+ _Nfe + chr(13)+chr(10)
		_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
		_cMens	+= '   Local.: \SERVIDOR'+ cFile
		GeraTxt(_cMens)
	
		XMLGetEmpr(_cEmpAnt+_cFilAnt)
		RestArea(_aArea)
		Return()
	EndIf  

Next
	*/
_HIST		:= '-> Data da Importacao:' + dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
_HIST		+= 'No. da Rodada.:' + strzero(ZO_SEQ,3) + CHR(13)+ CHR(10)

VldXml()

DbSelectArea("SZO")
DbSetOrder(1) //ZO_FILIAL + ZO_NFEID
RecLock("SZO",.F.)
ZO_FILIAL 	:= _FILIAL
ZO_VERSAO	:= _VERSAO
ZO_NFEID		:= _Nfe
ZO_CUF		:= IIF(EMPTY(_CUF), SA2->A2_EST , _CUF )
ZO_CNF		:= _CNF
If _cXml=='NFE'
	ZO_NATUREZ	:= "SPED"
Else
	ZO_NATUREZ	:= IIF(EMPTY(_NATUREZ),'NFE', _NATUREZ)
EndIf
ZO_INDPAG	:= _INDPAG
ZO_MOD		:= _MOD
ZO_SERIE		:= _SERIE
ZO_DOC		:= _DOC
ZO_EMISSAO	:= _EMISSAO
ZO_DTSE		:= _DTSE
ZO_CNUMFG	:= _CNUMFG
ZO_TPEMIS	:= _TPEMIS
ZO_TPAMB		:= _TPAMB
ZO_FINNFE	:= _FINNFE
ZO_CGC		:= _cCGC
ZO_FORNEC	:= Posicione("SA2",3,xFilial("SA2")+_cCGC,"A2_COD")
ZO_LOJA		:= Posicione("SA2",3,xFilial("SA2")+_cCGC,"A2_LOJA")
ZO_XNOME		:= _XNOME
ZO_XFANT		:= _XFANT
ZO_XLGR		:= _XLGR
ZO_NRO 		:= _NRO
ZO_XCPL		:= _XCPL
ZO_XBAIRRO	:= _XBAIRRO
ZO_CMUN		:= _CMUN
ZO_XMUN		:= _XMUN
ZO_UF			:= _UF
ZO_CEP		:= _CEP
ZO_CPAIS		:= _CPAIS
ZO_XPAIS		:= _XPAIS
ZO_FONE		:= _FONE
ZO_IE			:= _IE
ZO_CRT		:= _CRT
ZO_VBCICM	:= _VBCICM
ZO_VICM		:= _VICM
ZO_BCICMST	:= _BCICMST
ZO_VICMST	:= _VICMST
ZO_VPROD		:= _VPROD
ZO_VFRETE	:= _VFRETE
ZO_VSEG		:= _VSEG
ZO_VDESC		:= _VDESC
ZO_VII		:= _VII
ZO_VIPI		:= _VIPI
ZO_VPIS		:= _VPIS
ZO_VCOF		:= _VCOF
ZO_VOUTRO	:= _VOUTRO
ZO_VNF		:= _VNF
ZO_VSERV 	:= _VSERV
ZO_BCISS 	:= _BCISS
ZO_VISS 		:= _VISS
ZO_SEVPIS	:= _SEVPIS
ZO_SERVCOF 	:= _SERVCOF
ZO_VRETPIS 	:= _VRETPIS
ZO_VRETCOF 	:= _VRETCOF
ZO_VRETCSL 	:= _VRETCSL
ZO_BCIRRF	:= _BCIRRF
ZO_VIRRF 	:= _VIRRF
ZO_VINSS		:= _VINSS
ZO_MDFRET  	:= _MDFRET
ZO_FRCGC 	:= _FRCGC
ZO_FRNOME 	:= _FRNOME
ZO_FRIE 		:= _FRIE
ZO_FREND 	:= _FREND
ZO_FRXMUN 	:= _FRXMUN
ZO_FRUF 		:= _FRUF
ZO_PLACA1 	:= _PLACA1
ZO_RNTC1 	:= _RNTC1
ZO_PLACA2 	:= _PLACA2
ZO_PLUF2 	:= _PLUF2
ZO_RNTC2 	:= _RNTC2
ZO_QVOL 		:= _QVOL
ZO_ESP 		:= _ESP
ZO_MARCA 	:= _MARCA
ZO_NVOL 		:= _NVOL
ZO_PESOL 	:= _PESOL
ZO_PESOB		:= _PESOB
ZO_NFAT		:= _NFAT
ZO_VORIG  	:= _VORIG
ZO_FATDESC 	:= _FATDESC
ZO_VLIQ 		:= IIF(_VLIQ = 0, _VORIG, _VLIQ)
ZO_NDUP 		:= _NDUP
ZO_DVENC		:= _DVENC
ZO_VDUP		:= _VDUP
ZO_INFADFI 	:= _INFADFI
ZO_INFCPL  	:= _INFCPL
ZO_XCAMPO 	:= _XCAMPO
ZO_XTEXTO	:= _XTEXTO
ZO_XNEMP		:= _XNEMP
ZO_XPED 		:= _XPED
ZO_XCONTR 	:= _XCONTR
ZO_HIST		:= CHR(13)+CHR(10)+ _HIST 
ZO_JAEXP		:= _STATUS
ZO_IMAGE		:= _cImgTif
MsUnLock()

//
//INICIO DA GRAVACAO DAS NF´S - ITENS
//
DbSelectArea("SZP")
DbSetOrder(1)
If !dbSeek(SZO->ZO_FILIAL+SZO->ZO_NFEID)
	For I := 1 to nLenDet
		RecLock("SZP",.T.)
		ZP_FILIAL 	:= _FILIAL
		ZP_NFEID		:= _Nfe
		ZP_NITEM		:= _aNITEM[I]
		ZP_B1COD 	:= _aB1COD[I]
		ZP_CPROD		:= _aCPROD[I]
		ZP_XPROD		:= _aXPROD[I]
		ZP_NCM		:= _aNCM[I]
		ZP_CFOP		:= _aCFOP[I]
		ZP_UCOM		:= _aUCOM[I]
		ZP_QCOM		:= _aQCOM[I]
		ZP_VUNCOM	:= _aVUNCOM[I]
		ZP_VPROD		:= _aVPROD[I]
		ZP_EMISSAO	:= _EMISSAO
		ZP_DOC		:= _DOC
		ZP_SERIE		:= SZO->ZO_SERIE
		ZP_CGC		:= _cCGC
		ZP_PC			:= _XPED
		ZP_PCITEM   := ''
		
		ZP_BASEICM	:= _aInfICM[I,1]
		ZP_PICM		:= _aInfICM[I,2]
		ZP_VALICM	:= _aInfICM[I,3]
		ZP_BASEIPI	:= _aInfIPI[i,1]
		ZP_PIPI		:= _aInfIPI[i,2]
		ZP_VALIPI	:= _aInfIPI[i,3]
		ZP_DESPESA	:= _aDespesa[I]
		ZP_DESCONT	:= _aDescont[I]
		ZP_CST		:= _aCST[I]
		MsUnLock()
	Next I
EndIf

/*
IF _STATUS == '1' 
	lMsErroAuto := .F.

	// Cabecalho da nota fiscal de entrada
	aCabec   := {}
	aadd(aCabec,{"F1_TIPO"   	,"N"					})
	aadd(aCabec,{"F1_FORMUL" 	,"N"					})
	aadd(aCabec,{"F1_DOC"    	,SZO->ZO_DOC		})
	aadd(aCabec,{"F1_SERIE"  	,SZO->ZO_SERIE		})
	aadd(aCabec,{"F1_EMISSAO"	,SZO->ZO_EMISSAO	})
	aadd(aCabec,{"F1_FORNECE"	,SA2->A2_COD		})
	aadd(aCabec,{"F1_LOJA"   	,SA2->A2_LOJA		})
	aadd(aCabec,{"F1_ESPECIE"	,SZO->ZO_NATUREZ 	})
	aadd(aCabec,{"F1_EST"		,SA2->A2_EST		})
	aadd(aCabec,{"F1_COND"		,"001"				})
	
	// Itens da nota fiscal de entrada
	aItens   := {}
	aLinha   := {}

	For I := 1 to nLenDet
		aadd(aLinha,{"D1_ITEM"		, Strzero( I,TamSx3("D1_ITEM")[1] )	, Nil})
		aadd(aLinha,{"D1_COD"		, _aB1COD[I]							, Nil})
		aadd(aLinha,{"D1_UM"			, 'UN'									, Nil})
		aadd(aLinha,{"D1_QUANT"		, _aQCOM[I]								, Nil})
		aadd(aLinha,{"D1_VUNIT"		, _aVUNCOM[I]							, Nil})
		aadd(aLinha,{"D1_TOTAL"	 	, _aVUNCOM[I]							, Nil})
		aadd(aLinha,{"D1_LOCAL"	 	, "01"									, Nil})
		aadd(aLinha,{"D1_FORNECE"	,SA2->A2_COD							, Nil})	
		aadd(aLinha,{"D1_LOJA"	  	,SA2->A2_LOJA							, Nil})
		aadd(aLinha,{"D1_SEGUM"		,Space(Len(SD1->D1_SEGUM))			, Nil})
		aadd(aLinha,{"D1_QTSEGUM"	,0											, Nil})
	Next I
		
	aadd(aItens,aLinha)	
	// Inclui pre-nota
	If MaFisFound()
		MaFisEnd()
	Endif

	MsExecAuto( {|x,y,z|mata140(x,y,z)}, aCabec,aItens,3 ) 
	If lMsErroAuto
		lMostraErro	:=.T.
		MostraErro(_cPath+"ERRO\", "Erro_XMLNFE.LOG")
		lMostraErro	:= .F.
		lMsErroAuto := .F.
		lContinua := .F.

		_HIST	:= "...ERRO - NAO FOI POSSIVEL GERAR A PRE.NOTA- MOTIVO:" + CHR(13)+ CHR(10) 
		_HIST	+= "....................................................................." + CHR(13)+CHR(10) 
		_HIST	+= "-> Realizar Classificacao.PC. -> Via Menu-> Classifica..............." + CHR(13)+ CHR(10)
		_STATUS := '5'  //4= Documento com PC Inválido - Quando informado, mas não atende um ou mais dos critérios do item 1, no caso de devolução ao digitalizador, permitir a informação do motivo.

		_lErroFor := .T.

		_cMens	:= '   NFe- Numero.: '+ _Nfe + chr(13)+chr(10)
		_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
		_cMens	+= '   Local.: \SERVIDOR'+ cFile + CHR(13)+ CHR(10)
		_cMens	+= _HIST 

		dbSelectArea("SZO")
		RecLock("SZO",.F.)
		SZO->ZO_HIST	:= _HIST
		SZO->ZO_SEQ		:= SZO->ZO_SEQ + 1 			
		SZO->ZO_JAEXP	:= '5'
		MsUnlock()

		GeraTxt(_cMens)
	Else
		dbSelectArea("SZO")
		RecLock("SZO",.F.)
		SZO->ZO_JAEXP	:= '1'
		MsUnlock()
	EndIf
ENDIF	
*/

Return()

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ XMLNFE5    ¦ Autor ¦ Pearson              ¦ Data ¦ 11/01/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Excluir dados                                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function XMLNFE5(cAlias, nRecNo, nOpcX )
Local I
DbSelectArea(cAlias)
DbGoTo(nRecNo)
_lErroFor	:= .F.
If SZO->ZO_JAEXP == "1"
	Alert("Xml Já Classificado. Nao Sera Possivel Excluir...!!!")
	Return
EndIf

If !eof() .or. !bof()
	_Nfe:= (cAlias)->ZO_NFEID
	RecLock(cAlias,.F.)
	dbDelete()
	MsUnLock(cAlias)
	DbSelectArea("SZP")
	DbSetOrder(1)
	If DbSeek(xFilial('SZP')+_Nfe)
		While !eof() .and. SZP->ZP_NFEID = _Nfe
			RecLock('SZP',.F.)
			dbDelete()
			MsUnLock('SZP')
			DbSkip()
		enddo
	endif
endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ XMLNFE_C º Autor ³Raphael Camillo-Demaº Data ³ 12/01/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Rotina de Geracao da Pre Nota dos XML                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CR Almeida                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function XMLNFE_C(nOpcx)
Local I
Local _ni
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcoes de acesso para a Modelo 3                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aArea := GetArea()
Private Inclui := .F.
Private Altera := .F.
Private nOpcE:=3
Private nOpcG:=3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory("SZO",(nOpcx == 3))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria aHeader e aCols da GetDados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado   := 0
aHeader  := {}
aColsDel := {}

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZO")
aCpoEnchoice:={} 

While ! Eof() .and. X3_ARQUIVO == "SZO"
	If X3USO(x3_usado) .and. cNivel >= X3_NIVEL
		Aadd(aCpoEnchoice,x3_campo)
	EndIf
	DbSkip()
EndDo

dbSelectArea("SX3")
dbSeek("SZP")
While !Eof().And.(x3_arquivo=="SZP")
	If (X3USO(x3_usado).And.cNivel>=x3_nivel) .Or. AllTrim(X3_CAMPO) == "ZP_FILIAL"
		nUsado:=nUsado+1
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,"AllwaysTrue()",;
		x3_usado, x3_tipo, x3_arquivo, x3_context, x3_obrigat, x3_vlduser } )
	Endif
	dbSkip()
EndDo

If SZO->ZO_JAEXP == "1"
	Alert("Xml Já Classificado. Nao Sera Possivel Continuar...!!!")
	Return()
EndIf
_lEntrei := .f.
aCols    := {}
SA2->(dbSetOrder(3), dbSeek(xFilial("SA2")+ SZO->ZO_CGC))

DbSelectArea("SZP")
DbSetOrder(1)
DbSeek(SZO->ZO_FILIAL+SZO->ZO_NFEID,.t.)
While !Eof()  .and. SZP->ZP_FILIAL == SZO->ZO_FILIAL .And. SZP->ZP_NFEID == SZO->ZO_NFEID
	
	_lEntrei := .t.
	
	Aadd(aCols, Array(nUsado + 1))
	For _ni := 1 to nUsado
		aCols[Len(aCols), _ni] := FieldGet(FieldPos(aHeader[_ni,2]))
	Next
	aCols[Len(aCols), nUsado + 1] := .f.
	DbSkip()
	
EndDo

If !_lEntrei
	
	aCols  := { Array(nUsado + 1) }
	aCols[1,nUsado + 1] := .f.
	
	For _ni := 1 to nUsado
		aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next
	
EndIf

aColsDel := aClone(aCols)

If Len(aCols) > 0
	
	cTitulo        := "Classifica XML "
	cAliasEnchoice := "SZO"
	cAliasGetD     := "SZP"
	cLinOk         := "AllWaysTrue()"
	cTudOk         := "U_XMLNFETOK()"
	cFieldOk       := "AllwaysTrue()"
	_lRet          := .t.
	
	PRIVATE aTELA[0][0],aGETS[0]
	Private aCpos2         := aClone(aCpoEnchoice)
	Private aCpos1         := aClone(aCols)
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
	{{003,033,160,200,240,265}} )
	
	oSAY1:=Space(40)
	oSAY2:=0
	oSAY3:=0
	oSAY4:=0
	
	nOpca := 0
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	EnChoice( "SZO", SZO->(Recno()),nOpcx,,,,,aPosObj[1],aCpos2,3,,,cTudOk,oDlg)
	nGetLin := aPosObj[3,1]
	
	oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,cLinOk,cTudOk,,.T.,,1,,Len(aCols))
	
	Private oGetDad:=oGetd
	
	ACTIVATE MSDIALOG oDlg ON INIT FMa410Bar(oDlg,{||nOpcA:=1,if(oGetd:TudoOk(),If(!obrigatorio(aGets,aTela),nOpcA := 0,oDlg:End()),nOpcA := 0)},{||oDlg:End()},nOpcx)
	
	If nOpca == 0 // Abandonou
		Return
	EndIf
	
	LjMsgRun("Gerando Pré-Nota...","",GERAPRENOTA())
	
Endif

dbCommitAll()
RestArea(_aArea)
nOpcx := 4

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FMa410Bar ³ Autor ³ Joao Carlos A.Neto    ³ Data ³ Mar/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta os botoes na tela principal.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ortosintese                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FMa410Bar(oDlg,bOk,bCancel,nOpc)
Local I
Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ChkPcXml ³ Autor ³ Raphael Camillo - Dema³ Data ³ Jan/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida Pedido de Compras no XML                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Cr Almeida                                                 ³±± 
±±³ Alterado ³ Data: Marco.2012-Pearson. Conf.escopo via.email            ³±± 
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CHKPCXML()
Local I
/* DESCONTUADO - MARCO.2012
Local _aArea:= GetArea()  	
                                
	If !Empty(M->ZP_PC)
		dbSelectArea("SC7")
		dbSetOrder(1)
		If !dbSeek(GDFIELDGET('ZP_FILIAL')+M->ZP_PC)
			Aviso("Atencao...","Pedido nao Encontrado",{"OK"})
			RestArea(_aArea)
			Return(.F.)
		Else
			If !Empty(GDFIELDGET('ZP_B1COD'))
				dbSetOrder(4)
				If !dbSeek(GDFIELDGET('ZP_FILIAL')+Padr(GDFIELDGET('ZP_B1COD'),Len(SB1->B1_COD))+M->ZP_PC)
					Aviso("Atencao...","Pedido + Produto nao Encontrado",{"OK"})
					RestArea(_aArea)
					Return(.F.)
				EndIf
			EndIf
		EndIf
		If SC7->C7_CONAPRO == "B"
			Aviso("Atencao...","Pedido Bloqueado",{"OK"})
			RestArea(_aArea)
			Return(.F.)
		EndIf		
	EndIf
	
RestArea(_aArea)
*/

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ VldXml   ³ Autor ³ Pearson - Dema        ³ Data  Marco/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida NFe-Importacao conf. o Pedido de Compras no XML     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Cr Almeida                                                 ³±± 
±±³          ³                                                            ³±± 
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ZO_JAEXP = NFe. Status da Classficacao=
ABA- HELP.:
1= Ok.Já Gerado a Pre-Nota = Finalizado; 
2= Sem P.C= Quando informado "000000". Neste caso prever workflow de envio de e-mail para o usuário que digitalizou o documento. 
3= Documento com PC Inexistente - Quando informado, mas não encontrado na tabela de pedidos (SC7).
4= Documento com PC Inválido - Quando informado, mas não atende um ou mais dos critérios do item 1, no caso de devolução ao digitalizador, permitir a informação do motivo.
5= Documento Classificado= Nfe. Classificada, Liberado para Pre-Nota(Gerar);
/*/

Static Function VldXml()
_aArea:= GetArea()  	
Do Case
	Case _cXML == "NFE" .And. 1 = 2
		_HIST	+= "1= Ok. Documento Classificado ->Gerado a Pre-Nota = Finalizado"+ _XPED +CHR(13)+CHR(10)
		_HIST	+= "....................................................................." + CHR(13)+CHR(10) 
		_STATUS	:= '5'  // 5= Ok. Em Processo --> quando gerar pre nota coloca 1 se der erro coloca 5
		_lErroFor := .F.
	Case !empty(_XPED) .and. _XPED<>'000000'
		dbSelectArea("SC7")
		dbSetOrder(1)
		If !dbSeek(xFilial('SC7') + _XPED )
			_HIST	+= "...ERRO - PC. INEXISTENTE ->  NA NFE. - MOTIVO:" + CHR(13)+ CHR(10) 
			_HIST	+= "...Pedido de Compra Nao Encontrado - No.Pedido.Xml.: "+ _XPED + CHR(13)+CHR(10) 
			_HIST	+= "....................................................................." + CHR(13)+CHR(10) 
			_HIST	+= "-> Realizar Classificacao.PC. -> Via Menu-> Classifica..............." + CHR(13)+ CHR(10)
			_STATUS	:= '3'  //3= Documento com PC Inexistente - Quando informado, mas não encontrado na tabela de pedidos (SC7).
			_lErroFor := .F.
			_cMens	+= '   NFe- Numero.:'+ _Nfe + chr(13)+chr(10)
			_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
			_cMens	+= '   Local.: \SERVIDOR'+ cFile + CHR(13)+ CHR(10)
			_cMens	+= _HIST 
			GeraTxt(_cMens)
		ElseIf SC7->C7_CONAPRO == "B"
			_HIST	+= "...ERRO - PC. INVALIDO -> NA NFE. - MOTIVO:" + CHR(13)+ CHR(10) 
			_HIST	+= "...Pedido de Compra Bloqueado/ Nao Liberado - No.Pedido.Xml.: "+ _XPED +CHR(13)+CHR(10) 
			_HIST	+= "....................................................................." + CHR(13)+CHR(10) 
			_HIST	+= "-> Realizar Classificacao.PC. -> Via Menu-> Classifica..............." + CHR(13)+ CHR(10)
			_STATUS	:= '4'  //4= Documento com PC Inválido - Quando informado, mas não atende um ou mais dos critérios do item 1, no caso de devolução ao digitalizador, permitir a informação do motivo.
			_lErroFor := .F.
			_cMens	+= '   NFe- Numero.:'+ _Nfe + chr(13)+chr(10)
			_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
			_cMens	+= '   Local.: \SERVIDOR'+ cFile + CHR(13)+ CHR(10)
			_cMens	+= _HIST 
			GeraTxt(_cMens)
 		ElseIf SC7->C7_QUJE >= SC7->C7_QUANT                                           
			_HIST	+= "...ERRO - PC. INVALIDO -> NA NFE. - MOTIVO:" + CHR(13)+ CHR(10) 			
			_HIST	+= "...Pedido de Compra Ja Entregue.TOTALMENTE.(NF) - No.Pedido.Xml.: "+ _XPED +CHR(13)+CHR(10)
			_HIST	+= "....................................................................." + CHR(13)+CHR(10) 
			_HIST	+= "-> Realizar Classificacao.PC. -> Via Menu-> Classifica..............." + CHR(13)+ CHR(10)
			_STATUS	:= '4'  //4= Documento com PC Inválido - Quando informado, mas não atende um ou mais dos critérios do item 1, no caso de devolução ao digitalizador, permitir a informação do motivo.
			_lErroFor := .F.
			_cMens	+= '   NFe- Numero.:'+ _Nfe + chr(13)+chr(10)
			_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
			_cMens	+= '   Local.: \SERVIDOR'+ cFile + CHR(13)+ CHR(10)
			_cMens	+= _HIST 
			GeraTxt(_cMens)
 		ElseIf SC7->C7_FORNECE <> SA2->A2_COD
			_HIST	+= "...ERRO - PC. INEXISTENTE ->  NA NFE. - MOTIVO:" + CHR(13)+ CHR(10) 
			_HIST	+= "...Pedido de Compra Nao Pertence a esse Fornecedor - No.Pedido.Xml.: "+ _XPED + CHR(13)+CHR(10) 
			_HIST	+= "....................................................................." + CHR(13)+CHR(10) 
			_HIST	+= "-> Realizar Classificacao.PC. -> Via Menu-> Classifica..............." + CHR(13)+ CHR(10)
			_STATUS	:= '3'  //3= Documento com PC Inexistente - Quando informado, mas não encontrado na tabela de pedidos (SC7).
			_lErroFor := .F.
			_cMens	+= '   NFe- Numero.:'+ _Nfe + chr(13)+chr(10)
			_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
			_cMens	+= '   Local.: \SERVIDOR'+ cFile + CHR(13)+ CHR(10)
			_cMens	+= _HIST 
			GeraTxt(_cMens)
 		Else
			_HIST	+= "1= Ok. Documento Classificado ->Gerado a Pre-Nota = Finalizado"+ _XPED +CHR(13)+CHR(10)
			_HIST	+= "....................................................................." + CHR(13)+CHR(10) 
			_STATUS	:= '5'  // 5= Ok. Em Processo --> quando gerar pre nota coloca 1 se der erro coloca 5
			_lErroFor := .F.
		EndIf		
	Case empty(_XPED) 
			_HIST	+= "...ERRO - P.C. ESTA VAZIO ->  NA NFE. - MOTIVO:" + CHR(13)+ CHR(10) 
			_HIST	+= "...NFe. NAO CONTEM - NADA - NO CAMPO: P.C. (VAZIO)  "  +CHR(13) +CHR(10) 
			_HIST	+= "....................................................................." + CHR(13)+CHR(10) 
			_HIST	+= "-> Realizar Classificacao.PC. -> Via Menu-> Classifica..............." + CHR(13)+ CHR(10)
			_STATUS	:= '4'  //4= Documento com PC Inválido - Quando informado, mas não atende um ou mais dos critérios do item 1, no caso de devolução ao digitalizador, permitir a informação do motivo.
			_lErroFor := .F.
			_cMens	+= '   NFe- Numero.:'+ _Nfe + chr(13)+chr(10)
			_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
			_cMens	+= '   Local.: \SERVIDOR'+ cFile + CHR(13)+ CHR(10)
			_cMens	+= _HIST 
			GeraTxt(_cMens)
	Case _XPED=='000000' 
			_HIST	+= "...ERRO - Sem P.C= Quando informado 000000 -> NA NFE. - MOTIVO:" + CHR(13)+ CHR(10) 
			_HIST	+= "...NFe. Sem Pedido de Compra = 000000/ Realizar Classificacao Manualmente,"  +CHR(13) +CHR(10) 
			_HIST	+= "....................................................................." + CHR(13)+CHR(10) 
			_HIST	+= "-> Realizar Classificacao.PC. -> Via Menu-> Classifica..............." + CHR(13)+ CHR(10)
			_STATUS	:= '2'  // Sem P.C= Quando informado "000000". Neste caso prever workflow de envio de e-mail para o usuário que digitalizou o documento. 
			_lErroFor := .F.
			_cMens	+= '   NFe- Numero.:'+ _Nfe + chr(13)+chr(10)
			_cMens	+= '   Data..: '+ dtoc(dDataBase)+ ' - Hora.:'+ time() + chr(13)+chr(10)
			_cMens	+= '   Local.: \SERVIDOR'+ cFile + CHR(13)+ CHR(10)
			_cMens	+= _HIST 
			GeraTxt(_cMens)
   EndCase 			
RestArea(_aArea) 
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CHKB1XML ³ Autor ³ Raphael Camillo - Dema³ Data ³ Jan/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida Produto no XML                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Cr Almeida                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                     
User Function CHKB1XML()

Local _aArea 	:= GetArea()

dbSelectArea("SB1")
dbSetOrder(1)
If !dbSeek(xFilial("SB1")+M->ZP_B1COD)
	Aviso("Atencao...","Produto nao Encontrado",{"OK"})
	RestArea(_aArea)
	Return(.F.)
EndIf

If !Empty(GDFIELDGET('ZP_PC'))
	dbSelectArea("SC7")
	dbSetOrder(1)
	If !dbSeek(GDFIELDGET('ZP_FILIAL')+GDFIELDGET('ZP_PC'))
		Aviso("Atencao...","Pedido nao Encontrado",{"OK"})
		RestArea(_aArea)
		Return(.F.)
	Else
		dbSetOrder(4)
		If !dbSeek(GDFIELDGET('ZP_FILIAL')+Padr(M->ZP_B1COD,Len(SB1->B1_COD))+GDFIELDGET('ZP_PC'))
			Aviso("Atencao...","Pedido + Produto nao Encontrado",{"OK"})
			RestArea(_aArea)
			Return(.F.)
		EndIf
	EndIf
	If SC7->C7_CONAPRO == "B"
		Aviso("Atencao...","Pedido Bloqueado",{"OK"})
		RestArea(_aArea)
		Return(.F.)
	EndIf                          
	
EndIf
RestArea(_aArea)

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³XMLNFETOK ³ Autor ³ Raphael Camillo - Dema³ Data ³ Jan/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida Botao Confirmar                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Cr Almeida                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function XMLNFETOK()
Local I
Local _aArea 	:= GetArea()
DbSelectArea("SB1")
Set Filter To
dbSetOrder(1)

For I := 1 To Len(aCols)
	If Empty(GDFIELDGET('ZP_B1COD',I))
		Aviso("Atencao...","Produto nao Informado na Linha "+StrZero(I,4),{"OK"})
		RestArea(_aArea)
		Return(.F.)
	EndIf
	
	dbSelectArea("SB1")
	If !dbSeek(xFilial("SB1")+GDFIELDGET("ZP_B1COD",I))
		Aviso("Atencao...","Produto nao Encontrado",{"OK"})
		RestArea(_aArea)
		Return(.F.)
	EndIf
	
	/*
	If Empty(GDFIELDGET('ZP_TES',I))
		Aviso("Atencao...","TES Nao Informado, Informe o TES para o Produto "+SB1->B1_COD,{"OK"})
		RestArea(_aArea)
		Return(.F.)
	// DESCONTINUADO POIS O LOTE / VALIDADE TEM GATILHO
	Else
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4")+GDFIELDGET('ZP_TES',I))
		If SF4->F4_ESTOQUE == "S" .And. Rastro(SB1->B1_COD,"L")
			If Empty(GDFIELDGET('ZP_LOTECTL',I))
				Aviso("Atencao...","Lote nao Informado para o Produto "+SB1->B1_COD,{"OK"})
				RestArea(_aArea)
				Return(.F.)
			EndIf
			
			If Empty(GDFIELDGET('ZP_DTVALID',I))
				Aviso("Atencao...","Validade do Lote nao Informada para o Produto "+SB1->B1_COD,{"OK"})
				RestArea(_aArea)
				Return(.F.)
			EndIf
		EndIf
	EndIf	
*/
	If !Empty(GDFIELDGET('ZP_PC'),I)
		dbSelectArea("SC7")
		dbSetOrder(1)
		If !dbSeek(GDFIELDGET('ZP_FILIAL',I)+GDFIELDGET('ZP_PC',I))
			Aviso("Atencao...","Pedido nao Encontrado",{"OK"})
			RestArea(_aArea)
			Return(.F.)
		Else
		/* DESCONTINUADO
			If !Empty(GDFIELDGET('ZP_B1COD',I))
				dbSetOrder(4)
				If !dbSeek(GDFIELDGET('ZP_FILIAL',I)+Padr(GDFIELDGET('ZP_B1COD',I),Len(SB1->B1_COD))+GDFIELDGET('ZP_PC',I))
					Aviso("Atencao...","Pedido + Produto nao Encontrado",{"OK"})
					RestArea(_aArea)
					Return(.F.)
				EndIf
			EndIf
		*/
		EndIf
		If SC7->C7_CONAPRO == "B"
			Aviso("Atencao...","Pedido Bloqueado",{"OK"})
			RestArea(_aArea)
			Return(.F.)
		EndIf
	EndIf
Next I

IF EMPTY(M->ZO_SERIE)
	Aviso("Atencao...","Falta Classificar a SERIE do Documento! "+CHR(13)+CHR(10)+;
	"- Tela-Cabecalho -> Campo.: ZO_SERIE"  ,{"OK"})
	RestArea(_aArea)
	Return(.F.)
ENDIF

RestArea(_aArea)

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GeraPreNota³ Autor ³ Raphael Camillo - Dema³ Data ³ Jan/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera Pre Nota - SF1/SD1                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Cr Almeida                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraPreNota()

Local _nPosProd 	:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_B1COD" })
Local _nPosUCom		:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_UCOM"  })
Local _nPosQtde 	:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_QCOM"  })
Local _nPosPrc 	:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_VUNCOM"})
Local _nPosVTot 	:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_VPROD" })
Local _nPosPC 		:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_PC"    })
Local _nPosItPC	:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_PCITEM"})
Local _nPosFil		:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_FILIAL"})

Local _nPBsICM		:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_BASEICM"	})
Local _nPPICM 		:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_PICM"		})
Local _nPValIcm	:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_VALICM"	})
Local _nPBsIPI		:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_BASEIPI"	})
Local _nPPIPI 		:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_PIPI"		})
Local _nPValIPI	:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_VALIPI"	})
Local _nPVDesp		:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_DESPESA"	})
Local _nPVDesc		:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_DESCONT"	})
Local _nPCST  		:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_CST"		})

Local _nPNCM  		:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_NCM"		})

Local _nPTES  		:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_TES"		})
Local _nPLOTE  	:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_LOTECTL"	})
Local _nPDTVALID	:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_DTVALID"	})

Local _nPIcmRet	:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_BRICMS"	})
Local _nPIcmSt 	:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_ICMSRET"	})
Local _nPCC 		:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_CC"})
Local _nLoteOF		:="SEM LOTE"
Local _nLoteOF		:= aScan(aHeader,{|x|Alltrim(x[2])=="ZP_LOTEOF"})

Local _aArea		:= GetArea()
Local lMostraErro	:= .F.
Local aCabec		:= {}
Local aItens		:= {}
Local aLinha		:= {}
Local I
Local _xx
Local _nQtd := 0

Local _xUnidade 	:= ""      		// teste
_xUnidade 			:= M->ZO_XUNID	// teste

Private lMsErroAuto := .F.

nItem    	:= 0
nItGrd   	:= 0


dbSelectArea("SZO")
RecLock("SZO",.F.)
SZO->ZO_DOC			:= M->ZO_DOC
SZO->ZO_SERIE 		:= M->ZO_SERIE
SZO->ZO_NATUREZ 	:= M->ZO_NATUREZ
SZO->ZO_XUNID 		:= _xUnidade
MsUnlock()

dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial("SA2")+M->ZO_FORNEC+M->ZO_LOJA)

_cSeekNF	:= xFilial("SF1")+M->ZO_DOC+M->ZO_SERIE+SA2->A2_COD+SA2->A2_LOJA
// Cabecalho da nota fiscal de entrada
aCabec   := {}
aadd(aCabec,{"F1_TIPO"   	,"N"})
aadd(aCabec,{"F1_FORMUL" 	,"N"})
aadd(aCabec,{"F1_DOC"    	,M->ZO_DOC})
aadd(aCabec,{"F1_SERIE"  	,M->ZO_SERIE})
aadd(aCabec,{"F1_EMISSAO"	,M->ZO_EMISSAO})
aadd(aCabec,{"F1_FORNECE"	,SA2->A2_COD})
aadd(aCabec,{"F1_LOJA"   	,SA2->A2_LOJA})
aadd(aCabec,{"F1_ESPECIE"	,M->ZO_NATUREZ })
aadd(aCabec,{"F1_EST"		,SA2->A2_EST} )
aadd(aCabec,{"F1_CHVNFE"	,AllTrim(M->ZO_NFEID)} )
aadd(aCabec,{"F1_COND"		,"001"})
aadd(aCabec,{"F1_XUNID"		,_xUnidade})

// Itens da nota fiscal de entrada
aItens   := {}

For I := 1 To Len(aCols)
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+ aCols[I,_nPosProd])

	cGrade   := "N"
	aLinha   := {}
	nItem++
	aadd(aLinha,{"D1_ITEM"		, Strzero(nItem,Len(SD1->D1_ITEM))												, Nil })
	aadd(aLinha,{"D1_COD"		, aCols[I,_nPosProd]	, Nil })
	aadd(aLinha,{"D1_UM"		, SB1->B1_UM	, Nil })
	If AllTrim(SB1->B1_SEGUM) == AllTrim(aCols[I,_nPosUCom])
		If SB1->B1_TIPCONV == "D"
			_nQtd := aCols[I,_nPosQtde] * SB1->B1_CONV
		Else
			_nQtd := aCols[I,_nPosQtde] / SB1->B1_CONV
		EndIf
		aadd(aLinha,{"D1_QUANT"		, _nQtd																	, Nil })
		aadd(aLinha,{"D1_VUNIT"		, Round(aCols[I,_nPosVTot]/_nQtd,4)							, Nil }) 
		aadd(aLinha,{"D1_SEGUM"		, SB1->B1_SEGUM	, Nil })
	Else
		aadd(aLinha,{"D1_QUANT"		, aCols[I,_nPosQtde]																	, Nil })
		aadd(aLinha,{"D1_VUNIT"		, Round(aCols[I,_nPosVTot]/aCols[I,_nPosQtde],4)							, Nil }) 
	EndIf
	aadd(aLinha,{"D1_TOTAL"	 	, aCols[I,_nPosVTot]																	, Nil })
	aadd(aLinha,{"D1_LOCAL"	 	, Posicione("SB1",1,xFilial("SB1")+aCols[I,_nPosProd],"B1_LOCPAD")	, Nil })
	aadd(aLinha,{"D1_BASEICM"	, aCols[I,_nPBsICM	]																, Nil })
	aadd(aLinha,{"D1_PICM" 	 	, aCols[I,_nPPICM		]																, Nil })
	aadd(aLinha,{"D1_VALICM" 	, aCols[I,_nPValIcm	]																, Nil })
	aadd(aLinha,{"D1_BASEIPI"	, aCols[I,_nPBsIPI	]																, Nil })
	aadd(aLinha,{"D1_IPI" 	 	, aCols[I,_nPPIPI		]																, Nil })
	aadd(aLinha,{"D1_VALIPI" 	, aCols[I,_nPValIPI	]																, Nil })
	aadd(aLinha,{"D1_DESPESA"	, aCols[I,_nPVDesp	]																, Nil })
	aadd(aLinha,{"D1_VALDESC"	, aCols[I,_nPVDesc	]																, Nil })
	aadd(aLinha,{"D1_CLASFIS"	, aCols[I,_nPCST		]																, Nil })
	If Empty(Posicione("SB1",1,xFilial("SB1")+aCols[I,_nPosProd],"B1_TE"))
		aadd(aLinha,{"D1_TES", "070", Nil })
	Else
		aadd(aLinha,{"D1_TES"  	 	, Posicione("SB1",1,xFilial("SB1")+aCols[I,_nPosProd],"B1_TE")	, Nil })
	EndIf	
	aadd(aLinha,{"D1_XPOSIPI"		, aCols[I,_nPNCM		]															, Nil })
	
	If Rastro(aCols[I,_nPosProd],"L")
		aadd(aLinha,{"D1_LOTECTL" 	, aCols[I,_nPLOTE] 		, Nil })
		aadd(aLinha,{"D1_DTVALID"	, Ctod("31/12/49")		, Nil })
   	Else
		aadd(aLinha,{"D1_LOTECTL" 	, Space(Len(SD1->D1_LOTECTL))	, Nil })
		aadd(aLinha,{"D1_DTVALID"	, Ctod("  /  /  ")		, Nil })
   	EndIf

	aadd(aLinha,{"D1_BRICMS"	, aCols[I,_nPIcmRet	]																, Nil })
	aadd(aLinha,{"D1_ICMSRET"	, aCols[I,_nPIcmSt	]																, Nil })

	If !Empty(aCols[I,_nPosPC])
		aadd(aLinha,{"D1_PEDIDO"	, aCols[I,_nPosPC]																, Nil })
		aadd(aLinha,{"D1_ITEMPC"	, aCols[I,_nPosItPC]																, Nil })
	EndIf
	aadd(aLinha,{"D1_CC"			, aCols[I,_nPCC]																	, Nil })
	aadd(aLinha,{"D1_XLOTEOF"		, aCols[I,_nLoteOF]																, Nil })
	// ADICIONADO PARA GRAVAR VALIDADE DE LOTE MAURICIO 19/04/22 - CHAMADO ECIR
	aadd(aLinha,{"D1_LOTECTL" 	, aCols[I,_nPLOTE] 																	, Nil })
	aadd(aLinha,{"D1_DTVALID"	, Ctod("31/12/49")																	, Nil })

/*
	If !Empty(aCols[I,_nPosPC])
		dbSelectArea("SC7")
		dbSetOrder(4)
		dbSeek(xFilial("SC7")+Padr(aCols[I,_nPosProd],Len(SB1->B1_COD))+aCols[I,_nPosPC])
		
		aCols[I,_nPosItPC] 	:= SC7->C7_ITEM // Grava o Item do PV para Utilizar na Gravacao do SD1

		aadd(aLinha,{"D1_PEDIDO"	, aCols[I,_nPosPC]		, Nil })
		aadd(aLinha,{"D1_ITEMPC"	, aCols[I,_nPosItPC]	, Nil })
	EndIf
*/
	
	dbSelectArea("SZP")
	dbSetOrder(1)
	If dbSeek(SZO->ZO_FILIAL+SZO->ZO_NFEID+GDFIELDGET("ZP_NITEM",I))
		RecLock("SZP",.F.)
		SZP->ZP_B1COD		:= aCols[I,_nPosProd]
		SZP->ZP_PC			:= aCols[I,_nPosPC]
		SZP->ZP_PCITEM  	:= aCols[I,_nPosItPC]
		SZP->ZP_TES			:= aCols[I,_nPTES]
		SZP->ZP_LOTECTL	:= aCols[I,_nPLOTE]
		SZP->ZP_DTVALID	:= aCols[I,_nPDTVALID]
		SZP->ZP_CC			:= aCols[I,_nPCC]
		SZP->ZP_LOTEOF		:= aCols[I,_nLoteOF]
		MsUnlock()
	EndIf
	
	aadd(aItens,aLinha)
Next I

aColsOld := aCols

// Caso tenha itens e cabecalho definidos
If Len(aItens) > 0 .And. Len(aCabec) > 0
	
	_lTrocouFil := .F.
	If cFilAnt <> aCols[1,_nPosFil] // Caso a Filial seja Trocada Na Hora da Classificacao Altera para a Correta
		_cFilAtu := cFilAnt
		cFilAnt	:= aCols[1,_nPosFil]
		_lTrocouFil := .T.
		
		If MaFisFound()
			MaFisEnd()
		endif
	EndIf
	// Alterado por Mauricio em 18/03/2020
	MsExecAuto( {|x,y,z,a|mata103(x,y,z,a)},aCabec,aItens, 3, .T. )
	//MsExecAuto( {|x,y,z,a|mata103(x,y,z,a)},aCabec,aItens, 4, .F. )
	
	If lMsErroAuto
		MostraErro()
	Else
		// Caso Tenha Clicado OK  na Tela do MATA103 muda o Flag do XML
		dbSelectArea("SF1")
		dbSetOrder(1)
		If dbSeek(_cSeekNF)
			dbSelectArea("SZO")
			RecLock("SZO",.F.)
			SZO->ZO_JAEXP		:= "1"
			SZO->ZO_FORNEC 	:= M->ZO_FORNEC
			SZO->ZO_LOJA		:= M->ZO_LOJA
			MsUnlock()
			
			For _xx := 1 To Len(aItens)
				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(xFilial("SB1")+aItens[_xx,2,2])
					RecLock("SB1",.F.)
					SB1->B1_POSIPI := aItens[_xx,18,2]
					MsUnlock()
				EndIf
			Next _xx
			
			_cFile1 := SubStr(SZO->ZO_XTEXTO,1,13)+SM0->M0_CODIGO+SM0->M0_CODFIL+"\"+AllTrim(SubStr(SZO->ZO_XTEXTO,14,100))
			_cFile2 := SubStr(SZO->ZO_XTEXTO,1,13)+SM0->M0_CODIGO+SM0->M0_CODFIL+"\Classificados\"+Alltrim(SubStr(SZO->ZO_XTEXTO,14,100))
//			__Copyfile(cFile1, cFile2)			
			__Copyfile(_cFile1, _cFile2)			
			
		EndIf
	EndIf
		
	If _lTrocouFil // Restaura Ambiente
		cFilAnt	:= _cFilAtu
		
		If MaFisFound()
			MaFisEnd()
		Endif
	EndIf
EndIf

RestInter()
RestArea(_aArea)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ XMLGetEmpr³ Autor ³ Raphael Camillo - Dema³ Data ³ Jan/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ajusta o Ambiente do Sistema                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Cr Almeida                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function XMLGetEmpr(cEmp)
Local lIsPyme := __lPyme

DEFAULT cEmp := cEmpAnt

cNumEmp := cEmp

If SubStr(cEmpAnt,1,2) != SubStr(cNumEmp,1,2)
	cArqTab := ""
	cEmpAnt := Substr(cNumEmp,1,2)
	cFilAnt := Substr(cNumEmp,3,4)
	DbCloseAll()
	OpenSm0(AllTrim(cNumEmp))
	OpenFile(AllTrim(cNumEmp))
	If lIsPyme != __lPyme
		CursorWait()
		aMenu:={}
		MsgRun(Space(15)+"Aguarde.....O novo ambiente será inicializado!",,{|| AmbInit()})
		CursorArrow()
	EndIf
Else
	Connect()
	CheckAut(cNumEmp)
	ResetCtb()
EndIf

//Calculo das Data Validas a serem usadas no sistema
aDataIni := DataInicio()
aDataFim := DataFinal()
aTabela22:= DataTabela()

DbSelectArea("SM0")
DbSeek(cNumEmp)
IF LEN(cNumEmp) >2
	cEmpAnt := SUBSTR(cNumEmp,1,2)
	cFilAnt := SUBSTR(cNumEmp,3,4)
ELSE
	cEmpAnt	:= _cEmp
	cFilAnt	:= _cFil
ENDIF

//PtInternal(1,"Emp :"+cEmpAnt+"/"+cFIlAnt+" Logged :"+Padr(Subs(cUsuario,7,15),15)+Padr(' SIGA'+cModulo,9)+' Obj :Main Window')

Return nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ GeraTxt    ¦ Autor ¦ Pearson              ¦ Data ¦ 19/01/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Gerar Arq. Txt - Log´s de Erros de Importadao                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function GeraTxt(_cMens)
// Verifica o diretorio: de Log´s de Erros
// RootPath\Neogrid\Nfe\Erro
// RootPath\ReadSoft\Nfe\Erro
cDrive2	:=''
cDir2	:=''
cFile2	:=''
cExten2	:=''
cDrive4	:=''
cDir4	:=''
cFile4	:=''
cExten4	:=''

SplitPath( _cPath+ cFile3, @cDrive2, @cDir2, @cFile2, @cExten2 )
MAKEDIR(cDir2+ 'ERRO') // Cria o diretorio no servidor Advanced protheus
nHand1 := MsFCreate(UPPER(cDir2+ 'ERRO\'+cFile2+'.Xml.Erro.txt'  )) // CRIA ARQUIVO TXT.

If nHand1 == -1
	alert('Nao Foi Possivel Gerar o Arquivo.Log de erro...')
ELSE
	FWrite(nHand1, _cMens, 502)
	FClose(nHand1)// Fecha o Arquivo Texto
ENDIF

SplitPath( cFile, @cDrive4, @cDir4, @cFile4, @cExten4 )
If !_lAgend .and. alltrim(cDir4) != alltrim(cDir2)
	MAKEDIR(cDir4+ 'ERRO') // Cria o diretorio no servidor Advanced protheus
	nHand2 := MsFCreate(UPPER(cDir4+ 'ERRO\'+cFile4+'.Xml.Erro.txt'  )) // CRIA ARQUIVO TXT.
	If nHand2 == -1
		alert('Nao Foi Possivel Gerar o Arquivo.Log de erro...')
	Else
		FWrite(nHand2, _cMens, 502)
		FClose(nHand2)// Fecha o Arquivo Texto
		__Copyfile(cFile, @cDir4+'\erro\'+cFile4+ cExten4   )
	Endif
Endif



Return()


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MenuDef    ¦ Autor ¦ Pearson              ¦ Data ¦ 24/09/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Apresentacao/ Adaptacao para o MENU-PROTHEUS 10 (TEMAP10)     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

Static Function MenuDef()
Local aRotina	:= { ;
{"Pesquisar"			,"AxPesqui"			,0,1} ,;
{"XML-IMPORTACAO"		,"U_XMLNFE1" 		,0,3} ,;
{"Visualizar"			,"AxVisual"  		,0,2} ,;
{"Classifica"   		,"U_XMLNFE_C(4)"	,0,4},;
{"Excluir"   			,"U_XMLNFE5('SZO', SZO->(RecNo() ),5)" ,0,5},;
{"Abrir Site-Sefaz"	,"U_XMLWEB() " 	,0,3},;
{"Legenda"				,"U_XMLNFEL()"		,0,7} }
Return(aRotina)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ XMLNFEL   ¦ Autor ¦ Pearson             ¦ Data ¦ 15/01/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Apresentacao/ Adaptacao para o MENU-PROTHEUS 10 (TEMAP10)     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
uSER Function XMLNFEL()
/*
ABA- HELP.:
1= Ok.Já Gerado a Pre-Nota = Finalizado; = VERMELHO 
2= Sem P.C= Quando informado "000000". Neste caso prever workflow de envio de e-mail para o usuário que digitalizou o documento. = Amarelo
3= Documento com PC Inexistente - Quando informado, mas Nao Encontrado na tabela de pedidos (SC7). = MARRON
4= Documento com PC Inválido - Quando informado, mas não atende um ou mais dos critérios do item 1, no caso de devolução ao digitalizador, permitir a informação do motivo.
= PRETO.
*/

Local aLegenda	:=	{{"BR_VERMELHO" 	,"NFe= Pre.Nota-Fiscal Gerada"}						,;
                     {"BR_AMARELO"   	,"Informado P.C= 000000-> Sem P.C."		}   ,;
                     {"BR_PRETO"     	,"Nao Encontrado, P.C.= Inexistente"	}		,;
                     {"BR_CINZA"     	,"PC Invalido = Bloqueado/ Ja Entregue"	} ,;
                     {"BR_MARROM"    	,"Erro ao gerar Pre-Nota"	} }

BrwLegenda(cCadastro, "Legenda", aLegenda) //"Legenda"

return()

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ XMLNFE6   ¦ Autor ¦ Pearson             ¦ Data   ¦ 17/01/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ FILTRAR O SB1-> CADASTRO DE PRODUTOS, CONF. O P.COMPRA,       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦+ ALERADO   + DATA: 26.03.2012                                              +¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function XMLNFE6(_cPC)

/*  DESCONTINUADO . 26.03.2012

Public _cFilter	:='SB1->B1_COD $'
If Empty(_cPC) .Or. !SC7->(DbSeek(xFilial("SC7")+_cPC) )
	Return(.T.)
Endif

dbSelectArea("SB1")
Set Filter To

dbSelectArea("SC7")
dbSetOrder(1)
dbSeek(xFilial("SC7")+_cPC)
While !Eof() .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM= _cPC
	_cFilter += "'"+SC7->C7_PRODUTO +"/'"
	dbSkip()
EndDo

Set Filter to &(_cFilter)

*/
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ XMLWEB   ºAutor  ³Microsiga           º Data ³  12/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Abre IExplorer com link da SEFAZ para baixar XML do        º±±
±±º          ³ Fornecedor                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XMLWEB()
	WinExec('explorer "https://www.nfe.fazenda.gov.br/portal/consulta.aspx?tipoConsulta=completa&tipoConteudo=XbSeqxE8pl8="' )
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CHKZOFOR ºAutor  ³Microsiga           º Data ³  26/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Se a Raiz do CNPJ do XML e Igual ao Rais do CNPJ    º±±
±±º          ³ do Fornecedor Informado na Classificacao                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CHKZOFOR()
Local _aArea 	:= GetArea()
Local _lRet		:= .F.
dbSelectArea("SA2")
dbSetOrder(1)
If dbSeek(xFilial("SA2")+M->ZO_FORNEC+M->ZO_LOJA)
	If SubStr(M->ZO_CGC,1,8) == SubStr(SA2->A2_CGC,1,8)
		_lRet := .T.
	EndIf
EndIf

If !_lRet 
	Alert("Atencao...!!! "+CHR(13)+CHR(10)+"Fornecedor nao compativel com XML.")
EndIf
RestArea(_aArea)

Return(_lRet)
