#Include 'Protheus.ch'
 
User Function A460RLOC()
 
// Observe que o comprimento das duas Strings deve ser igual.
// Caso o comprimento seja diferente, o ponto de entrada será
// ignorado e o range de armazéns definido nas perguntas SX1
// do relatório prevalecerá. Portanto, uma forma de inutilizar
// o ponto de entrada é configurar as Stings em comprimentos diferentes
 
//Local cArmDe  := "01|10|11|12|96|97"
//Local cArmAte := "01|10|11|12|96|97"           //"01|10|11|14"
 
Local cArmDe  := "01|05|10|11|12|96|97"
Local cArmAte := "01|05|10|11|12|96|97"


// Retorno: Array com 2 posições, sendo na primeira os locais "DE",
// e na segunda os locais "ATÉ".
 
Return {cArmDe,cArmAte} 
