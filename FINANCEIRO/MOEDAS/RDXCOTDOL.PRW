#Include 'Protheus.ch'
#Include 'TbiConn.ch' 
#Include 'Totvs.ch'
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RDXCOTDOL    ³ Autor ³ Flavio Valentin       ³ Data ³ 29/06/22 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Obtem a cotação do dólar.                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ortosintese.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RDXCOTDOL(__dDtMoed, __lJob)

Local __cBCApi    := 'https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata'
Local __cBCRec    := ''
Local __cGetParm  := ''
Local __nTimeOut  := 200
Local __aHeadStr  := {'Content-Type: application/json'}
Local __cHeadGet  := ''
Local __cRetorno  := ''
Local __cIdMoeda  := 'USD'
Local __cDtCot    := '' //MM-DD-AAAA
Local __oJsObj    := JsonObject():New()
Local __cJsonRt   := ''
Local __cMsg      := ''
Local __lGrava    := .F.
Local __aFiliais  := {}
Local __nIni      := 0
Local __dDtCons   := CtoD('/ /')
Local __cMoeda    := 'US$'
Local __cMoedFin  := '2'
Default __dDtMoed := CtoD('/ /')
Default __lJob    := .F.

If ( __lJob )
    ConOut('RDXJOBDOL - Inicio Execucao - Data/Hora: ' +  DtoC(dDataBase) + '/' + AllTrim(Time()))
EndIf

__dDtCons := Iif(!Empty(__dDtMoed), __dDtMoed, dDataBase)
__cDtCot  := DToS(__dDtCons)
__cDtCot  := SubStr(__cDtCot,5,2) + '-' + SubStr(__cDtCot,7,2) + '-' + SubStr(__cDtCot,1,4)
  
__cBCRec += __cBCApi
__cBCRec += "/CotacaoMoedaPeriodoFechamento(codigoMoeda=@idMD,dataInicialCotacao=@dtIniCt,dataFinalCotacao=@dtFinCt)"
__cBCRec += "?@idMD='" + __cIdMoeda + "'&@dtIniCt='" + __cDtCot + "'&@dtFinCt='" + __cDtCot
__cBCRec += "'&$format=json&$select=cotacaoCompra,cotacaoVenda,dataHoraCotacao,tipoBoletim"

__cRetorno := HTTPGet( __cBCRec , __cGetParm, __nTimeOut, __aHeadStr, @__cHeadGet )
__cJsonRt  := __oJsObj:FromJson(__cRetorno)

If ValType(__cJsonRt) == 'U' 
    If Len(__oJsObj["value"]) > 0

        __cMsg  += "<b>Data:</b> " + DToC(SToD(StrTran(SubStr(__oJsObj["value"][1]["dataHoraCotacao"],1,10),'-','')))
        __cMsg  += " - " + SubStr(__oJsObj["value"][1]["dataHoraCotacao"],12,5) + "h<br>"
        __cMsg  += "<b>Moeda: </b> " + __cIdMoeda + "<br>"
        __cMsg  += "<b>Cotação de Compra:</b> " + cValToChar(__oJsObj["value"][1]["cotacaoCompra"]) + "<br>"
        __cMsg  += "<b>Cotação de Venda:</b> " + cValToChar(__oJsObj["value"][1]["cotacaoVenda"]) + "<br>"
   
        __aFiliais := fxGetEmp()

        If !Empty(__aFiliais)
            For __nIni := 1 To Len(__aFiliais)
                __cFilSye := ''
                __cFilSye := AllTrim(__aFiliais[__nIni])
                // Grava a cotação
                dbSelectArea('SYE')
                dbSetOrder(1) //YE_FILIAL, YE_DATA, YE_MOEDA, R_E_C_N_O_, D_E_L_E_T_
                If SYE->(dbSeek(AvKey(__cFilSye, 'YE_FILIAL') + DToS(__dDtCons) + AvKey(__cMoeda, 'YE_MOEDA')))
                    If Round(SYE->YE_VLCON_C,4) <> Round(__oJsObj["value"][1]["cotacaoVenda"],4)
                        SYE->(RecLock('SYE', .F.))
                        SYE->YE_VLCON_C := __oJsObj["value"][1]["cotacaoVenda"]
                        SYE->YE_VLFISCA := __oJsObj["value"][1]["cotacaoVenda"]
                        SYE->YE_TX_COMP := __oJsObj["value"][1]["cotacaoCompra"]
                        __lGrava := .T.
                        SYE->(MsUnlock())
                    EndIf
                Else
                    __aInfMoed := FxInfMoed(__cFilSye, __cMoeda)
                    SYE->(RecLock('SYE', .T.))
                    SYE->YE_FILIAL  := AvKey(__cFilSye, 'YE_FILIAL')
                    SYE->YE_MOE_FIN :=  Iif(!Empty(__aInfMoed[1]), StR(__aInfMoed[1],AVSX3('YE_MOE_FIN',3)), AvKey(__cMoedFin, 'YE_MOE_FIN'))
                    SYE->YE_DATA    := __dDtCons
                    SYE->YE_MOEDA   := AvKey(__cMoeda, 'YE_MOEDA')
                    SYE->YE_VLCON_C := __oJsObj["value"][1]["cotacaoVenda"]
                    SYE->YE_VLFISCA := __oJsObj["value"][1]["cotacaoVenda"]
                    SYE->YE_TX_COMP := __oJsObj["value"][1]["cotacaoCompra"]
                    __lGrava := .T.
                    SYE->(MsUnlock())
                EndIf
            Next __nIni
        EndIf
        dbSelectArea('SM2')
        dbSetOrder(1) //M2_DATA, R_E_C_N_O_, D_E_L_E_T_
        If SM2->(dbSeek(DToS(__dDtCons)))
            If Round(SM2->M2_MOEDA2,4) <> Round(__oJsObj["value"][1]["cotacaoVenda"],4)
                SM2->(RecLock('SM2', .F.))
                SM2->M2_MOEDA2 := __oJsObj["value"][1]["cotacaoVenda"]
                __lGrava := .T.
                SM2->(MsUnlock())
            EndIf
        Else
            SM2->(RecLock('SM2', .T.))
            SM2->M2_DATA    := __dDtCons  
            SM2->M2_MOEDA2  := __oJsObj["value"][1]["cotacaoVenda"]
            __lGrava := .T.
            SM2->(MsUnlock())  
        EndIf
    Else
        If ( __lJob )
            ConOut('RDXJOBDOL - Nao existe cotacao para a data informada!')
        Else
            ApMsgStop('Nao existe cotacao para a data informada!')
        EndIf
    EndIf
    FreeObj(__oJsObj)
Else
    If ( __lJob )
        ConOut('RDXJOBDOL - Ocorreu erro no processamento do Json' + CRLF + CRLF + __cJsonRt, ':: Cotação Moeda PTAX - BC API Olinda ::')
    Else
        ApMsgStop("Ocorreu erro no processamento do Json" + CRLF + CRLF + __cJsonRt, ':: Cotação Moeda PTAX - BC API Olinda ::')
    EndIf
EndIf

If ( __lGrava )
    If ( __lJob )
        ConOut('RDXJOBDOL - Cotacao do dia ' + DToC(__dDtCons) + ' realizada com sucesso!')
    Else
        ApMsgInfo('Cotação do dia ' + DToC(__dDtCons) + ' realizada com sucesso!')
    EndIf
EndIf

If ( __lJob )
    ConOut('RDXJOBDOL - Fim Execucao - Data/Hora: ' +  DtoC(dDataBase) + '/' + AllTrim(Time()))
EndIf
      
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ fxGetEmp     ³ Autor ³ Flavio Valentin       ³ Data ³ 09/12/22 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Filiais da Ortosintese.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ortosintese.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fxGetEmp()

Local __aArea    := GetArea()
Local __aRetorno := {}
Local __cFil     := ""

dbSelectArea('SM0')
dbSetOrder(1) // M0_CODIGO + M0_CODFIL
If SM0->(dbSeek(cEmpAnt))
    Do While !SM0->(Eof()) .And. AllTrim(SM0->M0_CODIGO) == AllTrim(cEmpAnt)
        __cFil  := ""
        __cFil := SubStr(AllTrim(SM0->M0_CODFIL),1,2)
        __nPos := 0
        __nPos := aScan( __aRetorno, { |x| AllTrim(x) == AllTrim(__cFil) } )
        If ( __nPos == 0 )
            aAdd(__aRetorno,AllTrim(__cFil))
        EndIf
        SM0->(dbSkip())
    EndDo
EndIf

If !Empty(__aRetorno)
    aSort(__aRetorno)
EndIf

RestArea( __aArea )

Return( __aRetorno )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ FxInfMoed    ³ Autor ³ Flavio Valentin       ³ Data ³ 09/12/22 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Obtem informacoes da moeda.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ortosintese.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FxInfMoed(__cFilSyf, __cMoedSyf)

Local __aArea   := GetArea()
Local __aRetorno:= {}
Local __cCodGi  := '220'
Local __cDescSi := 'DOLAR DOS EUA'
Local __cMoedFat:= 2

dbSelectArea('SYF')
dbSetOrder(1) // YF_FILIAL, YF_MOEDA, R_E_C_N_O_, D_E_L_E_T_
If SYF->(dbSeek(AvKey(__cFilSyf, 'YF_FILIAL') + AvKey(__cMoedSyf, 'YF_MOEDA')))
    aAdd(__aRetorno, SYF->YF_MOEFAT)
Else
    SYF->(RecLock('SYF', .T.))
    SYF->YF_FILIAL  := AvKey(__cFilSyf  , 'YF_FILIAL')
    SYF->YF_MOEDA   := AvKey(__cMoedSyf , 'YF_MOEDA')
    SYF->YF_COD_GI  := AvKey(__cCodGi   , 'YF_COD_GI')
    SYF->YF_DESC_SI := AvKey(__cDescSi  , 'YF_DESC_SI')  
    SYF->YF_DESC_PL := AvKey(__cDescSi  , 'YF_DESC_PL')  
    SYF->YF_MOEFAT  := __cMoedFat//AvKey(__cMoedFat , 'YF_MOEFAT')  
    SYF->(MsUnlock())
EndIf

If Empty(__aRetorno)
    aAdd(__aRetorno,'')
EndIf

RestArea( __aArea )

Return( __aRetorno )
