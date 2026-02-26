/*/
    Descrição: Ponto de Entrada que manipula os dados referentes à "remessa para beneficiamento".
    Programa Fonte: MATA410.PRX
    Sintaxe
    M410REMB - Manipular dados de remessa para beneficiamento ( [ PARAMIXB ] ) --> lRet
    Parâmetros:
    Nome			Tipo			Descrição			Default			Obrigatório			Referência	
    PARAMIXB			Array of Record			Array com somente um elemento, o código do produto posicionado.										
    Retorno
    lRet(logico)
    Retorno lógico indicando se empenha produto.
    fonte: https://tdn.engpro.totvs.com.br/display/public/PROT/M410REMB+-+Manipular+dados+de+remessa+para+beneficiamento
/*/

User Function M410REMB()

Local lRet := .F. // .F. = Não Bloqueia por tipo de produto / .T. = Bloqueia
Local cCodProd := PARAMIXB[1]

Return lRet


