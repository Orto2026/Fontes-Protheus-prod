#include "protheus.ch"
#include "parmtype.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ A010TOK  ºAutor  ³SAMUEL MIRNDA       º Data ³  05/07/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descrição |Ponto de Entrada Verifica se controla Lote e Endereço		  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ?Especifico para ORTOSINTESE                                 º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A010TOK()

Local _cAlias   	:= GetArea()
Local _aAreaSB1 	:= SB1->(GetArea())
Local _aAreaSB2 	:= SB2->(GetArea())

Local lRet      	:= .T.
Local cB1_TIPO  	:= M->B1_TIPO
Local cB1_COD   	:= M->B1_COD
Local cB1_SEGUM 	:= M->B1_SEGUM
Local cB1_CONV  	:= M->B1_CONV
Local cB1_LOCPAD 	:= M->B1_LOCPAD
     
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
    //Verifica o tipo do produto
    If cB1_TIPO $ "PA,SA,MP,CC" .and. cB1_LOCPAD <>'12'
    	
    	//Verifica se o produto controla ou não endereço.
    	If B1_LOCALIZ <> "S"
    	Aviso("Atencao!","O Produto: "+Alltrim(cB1_COD)+"  Controla  Endereço !",{"OK"},1," ")
    	lRet := .F.	
    	endIf
    	 
    	//Verifica se o produto controla ou não Loto.   
    	If B1_RASTRO <> "L"
    	Aviso("Atencao!","O Produto: "+Alltrim(cB1_COD)+"  Controla  Lote !",{"OK"},1," ")
    	lRet := .F.	
    	endIf 
    	  
    EndIf

	If cB1_TIPO $ "IF" 
    	
    	//Verifica se o produto controla ou não endereço.
    	If B1_LOCALIZ <> "S"
    	Aviso("Atencao!","O Produto: "+Alltrim(cB1_COD)+"  Controla  Endereço !",{"OK"},1," ")
    	lRet := .F.	
    	endIf
    	 
    	//Verifica se o produto controla ou não Loto.   
    	If B1_RASTRO == "L"
    	Aviso("Atencao!","O Produto: "+Alltrim(cB1_COD)+"  Não Controla  Lote !",{"OK"},1," ")
    	lRet := .F.	
    	endIf 
    	  
    EndIf

	If cB1_TIPO $ "PI" 
    	
    	//Verifica se o produto controla ou não endereço.
    	If B1_LOCALIZ == "S"
    	Aviso("Atencao!","O Produto: "+Alltrim(cB1_COD)+"  Não Controla  Endereço !",{"OK"},1," ")
    	lRet := .F.	
    	endIf
    	 
    	//Verifica se o produto controla ou não Loto.   
    	If B1_RASTRO <> "L"
    	Aviso("Atencao!","O Produto: "+Alltrim(cB1_COD)+"  Controla  Lote !",{"OK"},1," ")
    	lRet := .F.	
    	endIf 
    	  
    EndIf

	If cB1_TIPO $ "BN/CD" 
    	
    	//Verifica se o produto controla ou não endereço.
    	If B1_LOCALIZ == "S"
    	Aviso("Atencao!","O Produto: "+Alltrim(cB1_COD)+"  Não Controla  Endereço !",{"OK"},1," ")
    	lRet := .F.	
    	endIf
    	 
    	//Verifica se o produto controla ou não Loto.   
    	If B1_RASTRO == "L"
    	Aviso("Atencao!","O Produto: "+Alltrim(cB1_COD)+"  Não Controla  Lote !",{"OK"},1," ")
    	lRet := .F.	
    	endIf 
    	  
    EndIf

	
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//


	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
	//Adicionado por Samuel Miranda dia 06/03/2020 a pedido do Sr. Luiz Silveira.
	//verifica se o fator de conversão da segunda unidade está preenchido
	If !Empty(cB1_SEGUM) 

		If Empty(cB1_CONV)
			Aviso("Atencao!","O fator de convesão do produto: "+Alltrim(cB1_COD)+" é obrigatório!",{"OK"},1," ")
			lRet := .F.	
		EndIf
	
	EndIf
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//



   //±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
	//Adicionado por Samuel Miranda dia 06/10/2020
	//Seleciona Tabela de Pordutos e posiciona no produto que está sendo alterado.
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1") + AllTrim(cB1_COD)))

	If ALTERA  
		If M->B1_RASTRO <> B1_RASTRO .or. M->B1_LOCALIZ <> B1_LOCALIZ
				//Seleciona Tabela de saldos e posiciona no produto que está sendo alterado.
				DbSelectArea("SB2")
				SB2->(DbSetOrder(1))
				SB2->(dbSeek(xFilial("SB2") + AllTrim(cB1_COD)))
				If B2_QATU <> 0 .or. B2_QEMP <> 0 .or. B2_QTNP <> 0 .or. B2_QNPT <> 0 .or. B2_QTER <> 0 .or. B2_QEMPSA <> 0
					Aviso("Atencao!","O produto possui saldo, antes de alterar é necessário zerar todos os saldos.",{"OK"},1," ")
					lRet := .F.	
				EndIf
		EndIf
	EndIf
    //±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±// 
    RestArea(_aAreaSB1)
    RestArea(_aAreaSB2)   
	RestArea(_cAlias)

Return lRet
