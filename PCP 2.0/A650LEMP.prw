


//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Rotina    | A650LEMP    |Auto | Samuel Miranda    | Data | 03/12/2019  |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Descricao | Ponto de entrada para o ajuste do armazém do autoempenho   |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±|Uso       | Especifico Ortosintese | Return =  Local                   |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

User Function A650LEMP

Local aLinCol:= aClone(PARAMIXB) //
Local cRetLocal := aLinCol[3]   // 

If (aLinCol[3]=='11')

  cRetLocal := '91'

EndIf

If (aLinCol[3]=='10')

  cRetLocal := '92'

EndIf

Return cRetLocal
