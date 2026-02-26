#Include 'Protheus.ch'
#Include 'TbiConn.ch' 
#Include 'Totvs.ch'
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RDXJOBEUR    ³ Autor ³ Flavio Valentin       ³ Data ³ 09/12/22 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Job p/ obter a cotação do dólar.                               ³±±
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
User Function RDXJOBEUR()

Local __dDtMoed := CtoD('/ /')
Local __dDDtIni := CtoD('/ /')
Local __aDtMoed := {}
Local __nIni    := 0

RpcSetType(3)
RpcSetEnv('01', '0101',,, 'FIN') 

__dDtMoed := dDataBase

If ( Dow(__dDtMoed) == 1 .Or. Dow(__dDtMoed) == 7 )
    ConOut('RDXJOBEUR - Não há cotação de moeda, pois é um ' + CDow(__dDtMoed))
    Return
EndIf

If Dow(__dDtMoed) == 6
    __dDDtIni := DaySub(__dDtMoed, 4)
ElseIf Dow(__dDtMoed) == 2
    __dDDtIni := DaySub(__dDtMoed, 3)
Else
    __dDDtIni := DaySub(__dDtMoed, 1)
EndIf

While Dtos(__dDDtIni) < Dtos(__dDtMoed)
    If !( Dow(__dDDtIni) == 1 .Or. Dow(__dDDtIni) == 7 ) // Não considera sabado e domingo e feriado
        __dDDtIni := DataValida(__dDDtIni, .T.)
        If DtoS(__dDDtIni) <= DtoS(__dDtMoed)
            aAdd(__aDtMoed, __dDDtIni)
        EndIf
    EndIf
    __dDDtIni := DaySum(__dDDtIni, 1)
EndDo

If !Empty(__dDtMoed)
    If aScan(__aDtMoed, {|x| DtoS(x) == DtoS(__dDtMoed)}) <= 0
        aAdd(__aDtMoed, __dDtMoed)
    EndIf
    For __nIni := 1 To Len(__aDtMoed)
        u_RDXCOTEUR(__aDtMoed[__nIni], .T.)
    Next __nIni
EndIf

RpcClearEnv()

Return
