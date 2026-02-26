/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ºAutor  ³  Emerson Leal Bruno			  º Data ³  12/05.2009º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de Entrada para o ACD no momento do apontamento	  º±±
±±º          ³  modelo2 coletor para trazer o Lote da order de producao   º±±
±±º          ³  automaticamente        									        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ACD - Apontamento OP modelo 2 - T_ACDV025 - 				     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CBRastro()               

Local aAreaSC2 	:= SC2->(GetArea("SC2"))

LOCAL cProduto 	:= ParamIXB[1]
LOCAL cLote		:= ParamIXB[2]
LOCAL cSubLote 	:= ParamIXB[3]
LOCAL dDataOP 	:= ParamIXB[4]

Local cCode 			:= ""     
Local cRetLote		:= ""   
Local aRetAux		:= {}

iF Alltrim(FunName()) = "ACDV025"  //somente apontatmento modelo 2 trazer o lote da abertura da OP
	cCode := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) 
	SC2->(DbSetOrder(1))                                                               
	SC2->(DBSeek(xFilial("SC2")+cCode)) 	
	cRetLote := SC2->C2_LOTECTL 
	dDataOP := ctod('31/12/2049')     
	
	aRetAux := {cRetLote,cSubLote,dDataOP}

EndIf

RestArea(aAreaSC2)

return(aRetAux)