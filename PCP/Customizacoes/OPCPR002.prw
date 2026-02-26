#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include "RptDef.ch" 
#Include "TbiConn.ch"
#Include "OPCPA002.ch"

/*/{Protheus.doc} OPCPR002
	(Relatório de processamento do AutoEmpenho)

	@type User Function
	@author Vitor Ribeiro
	@since 02/03/2020

	@return Nil, nulo, não tem retorno.

    Explicação do nome do fonte OPCPA002
        O...: Nome da empresa - Ortosintese
        PCP.: Sigla do modulo - Planej.Contr.Produção
        A...: Atualização
        002.: Numero sequencial
	/*/
User Function OPCPR002(a_DadosSZS,a_DadosEst)

	Local _lContinua := .T.
	
	Local _oTReport := Nil
	
	Private _cPergs := ""
	
    Private _lSimula := .F.

    Default a_DadosSZS := {}
    Default a_DadosEst := {}

    // Se não for simulação
    If Empty(a_DadosSZS)
        _cPergs := "OPCPR002"

        // Realiza a pergunta
        _lContinua := Pergunte(_cPergs,.T.)

        // Busca os dados
        //_lContinua := _fMakeQry(@a_DadosSZS)
    Else
        _lSimula := .T.
    EndIf
	
	If _lContinua
		_oTReport := _ReportDef(a_DadosSZS,a_DadosEst)
		_oTReport:PrintDialog()
	EndIf
		
Return

/*/{Protheus.doc} _ReportDef
	(Relatório de processamento do AutoEmpenho)

	@type Static Function
	@author Vitor Ribeiro
	@since 02/03/2020

	@return Nil, nulo, não tem retorno.
	/*/
Static Function _ReportDef(a_DadosSZS,a_DadosEst)
	
	Local _oTReport := Nil
	Local _oSection1 := Nil
    Local _oSection2 := Nil

    Local _cTitulo := "Relatório de Auto Empenho"

    Default a_DadosSZS := {}
    Default a_DadosEst := {}

    If _lSimula
        _cTitulo += " - SIMULAÇÃO"
    EndIf
	
	_oTReport := TReport():New("OPCPR002",_cTitulo,_cPergs,{|_oTReport| _fPrintRep(_oTReport,a_DadosSZS,a_DadosEst)},_cTitulo)
	_oTReport:lParamPage := .F.     
	
	// Monta a primeira seção
	_oSection1 := TRSection():New(_oTReport,"Dados da OP",{"SZS","SB1"})
    TrCell():New(_oSection1,"ZS_OP","SZS")
	TrCell():New(_oSection1,"ZS_SEQUENC","SZS")
	TrCell():New(_oSection1,"ZS_PROCESS","SZS","Processamento","",36)
	TrCell():New(_oSection1,"ZS_PRODUTO","SZS")
	TrCell():New(_oSection1,"ZS_DESCPRD","SZS",,,30)
	TrCell():New(_oSection1,"ZS_LOTECTL","SZS")
	TrCell():New(_oSection1,"ZS_LOCALIZ","SZS")
	TrCell():New(_oSection1,"B1_UM","SB1")
	TrCell():New(_oSection1,"ZS_QUANT","SZS")
    TrCell():New(_oSection1,"ZS_DOC","SZS")
	
	// Se for simulação
    If _lSimula
        // Monta a segunda seção
        _oSection2 := TRSection():New(_oTReport,"Dados do estoque",{"SB8","SB1","SBF"})
        TrCell():New(_oSection2,"B8_PRODUTO","SB8")
        TrCell():New(_oSection2,"B1_DESC","SB1")
        TrCell():New(_oSection2,"BF_QUANT","SBF")
        TrCell():New(_oSection2,"B8_LOCAL","SB8")
        TrCell():New(_oSection2,"BF_LOCALIZ","SB8")
        TrCell():New(_oSection2,"B8_LOTECTL","SB8")
        TrCell():New(_oSection2,"B8_DATA","SB8")
        TrCell():New(_oSection2,"B8_DTVALID","SB8")
    EndIf
	
Return _oTReport

/*/{Protheus.doc} _ReportDef
	(Função para montar a impressão)

	@type Static Function
	@author Vitor Ribeiro
	@since 02/03/2020

    @param o_TReport, objeto, contém o objeto do TReport
    @param a_DadosSZS, array, contém o array com os dados
    @param a_DadosEst, array, contém os dados do estoque

	@return Nil, nulo, não tem retorno.
	/*/
Static Function _fPrintRep(o_TReport,a_DadosSZS,a_DadosEst)
	
	Local _nTotal := 0
    Local _nCount := 0
		
	Local _oSection1 := Nil
    Local _oSection2 := Nil

    Local _aComboBox := {}
	
	Default o_TReport := Nil

    Default a_DadosSZS := {}
    Default a_DadosEst := {}
	
	If ValType(o_TReport) == "O"
		_oSection1 := o_TReport:Section(1)

        If _lSimula
            _oSection2 := o_TReport:Section(2)
        EndIf
		
		// Guarda a quantidade de linhas
		_nTotal := Len(a_DadosSZS) + IIf(_lSimula,Len(a_DadosEst),0)

        _aComboBox := Separa(AllTrim(GetSX3Cache("ZS_PROCESS","X3_CBOX")),";")
		
		// Define o total da regua da tela de processamento do relatório
		o_TReport:SetMeter(_nTotal)
		
        For _nCount := 1 To Len(a_DadosSZS)
            // Se foi cancelado
            If o_TReport:Cancel()
                Exit
            EndIf

            o_TReport:IncMeter()
            _oSection1:Init()
            
            //imprimo a primeira seção
            _oSection1:Cell("ZS_OP"):SetValue(a_DadosSZS[_nCount][N1_OP])
            _oSection1:Cell("ZS_SEQUENC"):SetValue(a_DadosSZS[_nCount][N1_SEQUENC])
            _oSection1:Cell("ZS_PROCESS"):SetValue(_aComboBox[Val(a_DadosSZS[_nCount][N1_PROCESS])])
            _oSection1:Cell("ZS_PRODUTO"):SetValue(a_DadosSZS[_nCount][N1_PRODUTO])
            _oSection1:Cell("ZS_DESCPRD"):SetValue(Posicione("SB1",1,xFilial("SB1")+a_DadosSZS[_nCount][N1_PRODUTO],"B1_DESC"))
            _oSection1:Cell("ZS_LOTECTL"):SetValue(a_DadosSZS[_nCount][N1_LOTECTL])		
            _oSection1:Cell("ZS_LOCALIZ"):SetValue(a_DadosSZS[_nCount][N1_LOCALIZ])	
            _oSection1:Cell("B1_UM"):SetValue(Posicione("SB1",1,xFilial("SB1")+a_DadosSZS[_nCount][N1_PRODUTO],"B1_UM"))
            _oSection1:Cell("ZS_QUANT"):SetValue(a_DadosSZS[_nCount][N1_QUANT])
            _oSection1:Cell("ZS_DOC"):SetValue(a_DadosSZS[_nCount][N1_DOC])
            _oSection1:Printline()

            // Se o contador for menor que o array e a proxima sequencia for 1
            If _nCount < Len(a_DadosSZS) .And. Val(a_DadosSZS[_nCount+1][02]) == 1
                o_TReport:SkipLine(2)

                // Encerra a pagina
                _oSection1:Finish()
                o_TReport:EndPage()
            EndIf
        Next

        o_TReport:SkipLine(2)
        _oSection1:Finish()
        o_TReport:EndPage()

        // Se for simulação
        If _lSimula
            // Inicia uma nova
            o_TReport:StartPage()

            _oSection2:Init()

            For _nCount := 1 To Len(a_DadosEst)
                // Se foi cancelado
                If o_TReport:Cancel()
                    Exit
                EndIf

                _oSection1:Init()
                o_TReport:IncMeter()
                
                //imprimo a primeira seção
                _oSection2:Cell("B8_PRODUTO"):SetValue(a_DadosEst[_nCount][N2_PRODUTO])
                _oSection2:Cell("B1_DESC"):SetValue(a_DadosEst[_nCount][N2_DESCRIC])
                _oSection2:Cell("BF_QUANT"):SetValue(a_DadosEst[_nCount][N2_SALDATU])
                _oSection2:Cell("B8_LOCAL"):SetValue(a_DadosEst[_nCount][N2_ARMAZEM])		
                _oSection2:Cell("BF_LOCALIZ"):SetValue(a_DadosEst[_nCount][N2_LOCALIZ])		
                _oSection2:Cell("B8_LOTECTL"):SetValue(a_DadosEst[_nCount][N2_LOTECTL])	
                _oSection2:Cell("B8_DATA"):SetValue(a_DadosEst[_nCount][N2_DATA])
                _oSection2:Cell("B8_DTVALID"):SetValue(a_DadosEst[_nCount][N2_DTVALID])
                _oSection2:Printline()    
            Next

            _oSection2:Finish()

            // Encerra a pagina
            o_TReport:EndPage()
        EndIf
    EndIf
	
Return