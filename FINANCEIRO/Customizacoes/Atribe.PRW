#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Atribe  º Autor ³ ThinkFast           º Data ³  05/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ CNAB Tributos											  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ThinkFast                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Atribe()

Local cRet := ""

If SEA->EA_MODELO ==  "17" // SEGMENTO N TRIBUTOS SEM COD. BARRAS // GPS POSICAO 018-195
	
	cRet := SE2->E2_XTRIBUT 	 		                   //  01=GPS
	cRet += ALLTRIM(SE2->E2_XCGPS)		                   // EMPRESAS EM GERAL (PADRAO)
	cRet += SE2->E2_XCOMPGP 		                       // MMAAAA COMPETENCIA
	cRet += ALLTRIM(SM0->M0_CGC)	                       // CNPJ
	cRet += STRZERO(SE2->E2_SALDO*100,14)                  // VALOR
	cRet += STRZERO(SE2->E2_ACRESC*100,14) 	               // VALOR OUTRAS ENTIDADES
	cRet += STRZERO(SE2->E2_ACRESC*100,14)                 // ATUALIZACAO MONET
	cRet += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14) // VALOR ARRECADADO
	cRet += GRAVADATA(SE2->E2_VENCTO,.F.,5) 	           // DATA DE ARRECADACAO
	cRet += SPACE(08)
	cRet += SA2->A2_CGC
	cRet += SPACE(36)
	cRet += SUBSTR(SM0->M0_NOME,1,30)

Elseif SEA->EA_MODELO ==  "16" // DARF NORMAL  

	cRet := "02"                                           // DARF NORMAL 
	cRet += SE2->E2_XCDARF                                 // CODIGO DE RETENCAO DA RECETA    	
    cRet += "2"                                            // 1=PESSOA FISICA,2=PESSOA JURIDICA 
	cRet += ALLTRIM(SM0->M0_CGC)			               // CNPJ
	cRet += GRAVADATA(SE2->E2_EMISSAO,.F.,5)               // PERIODO DE APURACAO 
	cRet += Repli("0",17)                                  // numero de referencia 
	cRet += STRZERO(SE2->E2_SALDO*100,14)                  // valor  
	cRet += STRZERO(SE2->E2_ACRESC*100,14)
	cRet += REPL("0",14)                                   // atualizacao monetaria 
    cRet += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14) // valor arrecadado 
    cRet += GRAVADATA(SE2->E2_VENCTO,.F.,5)                // data de arrecadacao                                                       
 	cRet += GRAVADATA(SE2->E2_VENCTO,.F.,5)                // DATA DE PAGTO                                    
 	cRet += space(30)                                      // BRANCOS
 	cRet += SUBSTR(SM0->M0_NOME,1,30)

EndIf

Return (cRet)

