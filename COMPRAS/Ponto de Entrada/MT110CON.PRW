/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT110CON   ¦ Autor ¦ Samuel Miranda    ¦ Data ¦ 28/05/2025 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Ponto de entrada para validar o comprador.                 ¦¦¦
¦¦¦Retorna   ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/ 
User Function MT110CON()
Local lGrava  := .T.
Local cMsg := ""
//Local nPosComp   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_CODCOMP'})
//Local Paramixb[1] //= Numero da SC
//Local Paramixb[2] //= Solicitante
//Local Paramixb[3] //= Data da SC
//Local Paramixb[4] //= Centro de Custo
//Local Paramixb[5] //= Unidade Requisitante
//Local Paramixb[6] //= Codigo do Comprador

//If  Empty(PARAMIXB[5])   //Verifica a Unidade Requisitante   
//    FWAlertError("O comprador é campo Obrigatório, por favor verificar.", "A T E N Ç Ã O")
//	lGrava := .F.
//Endif

If  Empty(PARAMIXB[5]) .or. Empty(PARAMIXB[6])   // Verifica o Codigo do Comprador  
    cMsg := '<b>A Unid. Requis. e Cod. Comprador  são campos Obrigatórios, por favor verificar. </b>'
    cMsg += '<br>'
    cMsg += '<br>'
    cMsg += '<b>Não foi possivel salvar a solcitação. </b>  '
    FWAlertError(cMsg, "A T E N Ç Ã O !")
	lGrava := .F.
Endif

Return ( lGrava ) 
