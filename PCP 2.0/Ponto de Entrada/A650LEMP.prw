
#include "rwmake.ch"
#include "totvs.ch"

/*/

北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北矲un嘺o    ?A650LEMP  ?Autor ?Raphael Camillo Proto  ?	Data ?	19/08/04 潮?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北矰escri噮o ?Ponto de entrada   	潮?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北砋so       ?Especifico para ORTOSINTESE                                	潮?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
/*/

User Function A650LEMP()

Local aLinCol:= aClone(PARAMIXB)  //Conte煤do da linha do aCols posicionado
Local cRetLocal := aLinCol[3]// Verifica se o produto 茅 'MP' e o Armaz茅m 茅 '87' altera conte煤do para '20'

If (aLinCol[3]=='11')

  cRetLocal := '91'

EndIf

If (aLinCol[3]=='10')

  cRetLocal := '92'

EndIf


Return cRetLocal
