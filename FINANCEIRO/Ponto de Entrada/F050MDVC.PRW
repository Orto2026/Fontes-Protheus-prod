#INCLUDE "rwmake.ch"

User function F050MDVC()
Local dNextDay := ParamIxb[1] //data calculada pelo sistema
Local cIMposto := ParamIxb[2]
Local dEmissao := ParamIxb[3]
Local dEmis1   := ParamIxb[4]
Local dVencRea := ParamIxb[5]
Local nNextMes := Month(dVencRea)+1

If At(cImposto,"PIS,CSLL,COFINS") > 0
    dNextDay := STOD(StrZero(Iif(nNextMes==13,Year(dVencRea)+1,Year(dVencRea)),4)+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"20")//Acho o ultimo dia util do periodo desejado
    dNextday := DataValida(dNextday,.F.)
Endif

Return dNextDay