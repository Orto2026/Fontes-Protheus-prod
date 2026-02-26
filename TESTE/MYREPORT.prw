#include 'totvs.ch'
User Function MYREPORT()
     local oReport 
         oReport := ReportDef()
         oReport:PrintDialog()
return         
static function ReportDef()
    local oSection1
    //local oBreak
    // local oFunction
    oReport :=TReport():New('Relatori','Cadastro de Cliente',/**/,{|oReport| ReportPrint(oReport)},'Descric relato')
    oReport:SetPortrait()
    oReport:SetTotalInLine(.F.)
 
    //SESSOES
	oSection1 := TRSection():New( oReport,"Clientes",{"SB1"})
    TRCell():new(oSection1,'A1_COD'     ,'SA1','Codigo'     ,'@!',tamSX3('A1_COD')[1])
    TRCell():new(oSection1,'A1_LOJA'    ,'SA1','Loja'       ,'@!',2)
    TRCell():new(oSection1,'A1_NOME'    ,'SA1','Nome'       ,'@!',30)
    TRCell():new(oSection1,'A1_END'     ,'SA1','Endereço'   ,'@!',30)
    TRCell():new(oSection1,'A1_BAIRRO'  ,'SA1','Bairro'     ,'@!',20)
    TRCell():new(oSection1,'A1_MUN'     ,'SA1','Cidade'     ,'@!',20)
    //Colunas do relatorio
    TRFunction():New(oSection1:Cell('A1_COD'),,'COUNT',,,,,,.F.,.T.)
return (oReport)    
Static Function ReportPrint(oReport)
  local oSection1 := oReport:Section(1)
  local cAlias    := getnextalias()
 
  beginSql alias cAlias
    SELECT 
    SA1.A1_COD,
    SA1.A1_LOJA,
    SA1.A1_NOME,
    SA1.A1_END,
    SA1.A1_BAIRRO,
    SA1.A1_MUN
    FROM %Table:SA1% SA1  WHERE  SA1.A1_FILIAL = %xFilial:SA1%
    AND SA1.%Notdel%
  EndSql
  dbselectarea(cAlias)
  (cAlias)->(dbGoTop())
  oReport:SetMeter((cAlias)->(lastRec()))
  while !(cAlias)->(eof())
     oReport:IncMeter()
     incproc('Imprimindo cliente: '+alltrim((cAlias)->(A1_NOME)))
     if oReport:cancel()
        exit
    endif 
    oSection1:init()
    oSection1:Cell('A1_COD'):Setvalue((cAlias)->(A1_COD))
    oSection1:Cell('A1_LOJA'):Setvalue((cAlias)->(A1_LOJA))
    oSection1:Cell('A1_NOME'):Setvalue((cAlias)->(A1_NOME))
    oSection1:Cell('A1_END'):Setvalue((cAlias)->(A1_END))
    oSection1:Cell('A1_BAIRRO'):Setvalue((cAlias)->(A1_BAIRRO))
    oSection1:Cell('A1_MUN'):Setvalue((cAlias)->(A1_MUN))

 
    (cAlias)->(dbSkip())
    //oReport:ThinLine()
 
    //Imprimindo a linha atual
	oSection1:PrintLine()
  end
  (cAlias)->(dbclosearea())
return()
