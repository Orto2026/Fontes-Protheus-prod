
#Include "Protheus.ch"
#Include "TopConn.ch"
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT110VLD   ¦ Autor ¦ Samuel Miranda    ¦ Data ¦ 28/05/2025 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Ponto de entrada validar o usuario na alteração            ¦¦¦
¦¦¦ ou exclusão da solitação de comprar.                                   ¦¦¦
¦¦¦Retorna   ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/ 
User Function MT110VLD()
Local ExpN1     := Paramixb[1] //3- Inclusão, 4- Alteração, 8- Copia, 6- Exclusão.
Local ExpL1     := .T. 
Local cCodUser 	:= RetCodUsr() 
Local cNamUser 	:= Alltrim(UsrRetName( cCodUser )) //Retorna o nome do usuario
Local cSolitant :="" //Alltrim(cSolic) "000465"
Local cQrySC1 := ""
local cCodSolct := ""
//Validações do Cliente
If ExpN1 <> 6
    cSolitant := Alltrim(cSolic)
    Else
    cSolitant := CA110NUM
    cQrySC1 := "SELECT "+ CRLF
	cQrySC1 +=" DISTINCT(SC1.C1_XSOL) AS SOLICITANTE "+ CRLF
    cQrySC1 +=" FROM "+ CRLF
    cQrySC1 += " "+RetSQLName("SC1 ") + " SC1 "+ CRLF
    cQrySC1 +=" WHERE "+ CRLF
    cQrySC1 +=" SC1.C1_NUM='"+cSolitant+"' AND SC1.D_E_L_E_T_=''"+ CRLF
    PlsQuery(cQrySC1, "CALIASSC1")
	
    DbSelectArea("CALIASSC1")
    CALIASSC1->(DbGoTop())
    cCodSolct := CALIASSC1->SOLICITANTE
    cSolitant :=  Alltrim(UsrRetName(cCodSolct ))
    CALIASSC1->(DbCloseArea())
End 

//Verifica se é alteração
If ExpN1 = 4 .OR. ExpN1 = 6         //"033/353/422"
    //Valida o solicitante
    If cNamUser <> cSolitant
        cMsg := '<b>Não é possivel alterar ou excluir solicitação de outro solicitante !</b>'
        cMsg += '<br>'
        cMsg += '<br>'
        cMsg += '<b>Solitante: </b>  '
        cMsg += UPPER(cSolitant)
        FWAlertError( cMsg, 'A T E N Ç Ã O !')
        cMsg :=""
        ExpL1 := .F.
    EndIf
EndIf
Return ExpL1


