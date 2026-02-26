#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"  

/*
Padrao Zebra
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Programa  |³IMG05    |Autor  |Samuel Mirdamda     | Data |  10/03/25   |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Desc.     |Ponto de entrada referente a imagem de identificacao do     |±±
±±|          |volume temporario                                    |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Uso       |AP5   (Progrma Padrão )                                     |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function Img05   // imagem de etiqueta de volume temporaria
Local cVolume := paramixb[1]
Local cPedido := paramixb[2]
Local cNota   := IF(len(paramixb)>=3,paramixb[3],nil)
Local cSerie  := IF(len(paramixb)>=4,paramixb[4],nil)
//Local cID := CBGrvEti('05',{cVolume,cPedido,cNota,cSerie})
Local sConteudo
Local cCodUser 		:= RetCodUsr()
Local cNamUser 		:= UsrRetName( cCodUser )//Retorna o nome do us

MSCBLOADGRF("SIGA.GRF")
MSCBBEGIN(1,6)

MSCBBOX(02,12.7,76,12.7)
//MSCBBOX(02,21,76,21)
MSCBBOX(30,01,30,12.7,3)

MSCBSAY(33,02,"VOLUME","N","0","025,035")
MSCBSAY(33,06,"CODIGO","N","A","012,008")
MSCBSAY(33,08, cVolume, "N", "0", "032,035")
If cNota==NIL
	MSCBSAY(05,14,"PEDIDO","N","A","012,008")
	MSCBSAY(05,17,cPedido,"N", "0", "020,030")
Else
	MSCBSAY(05,14,"NOTA","N","A","012,008")
	MSCBSAY(05,17,cNota+' '+cSerie,"N", "0", "020,030")
EndIf
//MSCBSAYBAR(23,25,cId,"N","MB07",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.) 
// ERRO NA IMPRESSAO. IMPRIMINDO UMA LETRA
MSCBSAYBAR(23,25,cVolume,"N","MB07",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.F.)

MSCBSAY(04,42,"OPERADOR : "+UPPER(cValToChar(cNamUser)) ,"N","0","025,035")//Nome d Usuario
MSCBInfoEti("Volume Temp.","30X100")

sConteudo:=MSCBEND()
Return sConteudo

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Programa  |IMG05OFI  |Autor  |Samuel Mirdamda     | Data |  10/03/25   |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Desc.     |Ponto de entrada referente a imagem de identificacao do     |±±
±±|          |volume permanente."Oficial"                                 |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±|Uso       |AP5   (Progrma Padrão )                                     |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Para as impressões d embalagens usar o local de impressão 000002 - (Em)
Prgramação Nativa = ZPL
Impressora  	  = ZEBRA
Fila       		  = EMBALAGEM (000002)
Porta 			  = LPT1
Tamanho 		  = 30X100
*/
User Function Img05OFI // imagem de etiqueta de volume permanente (OFICIAL)
//Local cId     := CBGrvEti('05',{CB6->CB6_VOLUME,CB6->CB6_PEDIDO})
Local nTotEti  := paramixb[1]
Local nAtu     := paramixb[2]

//±±±±±±±±±±± Variaveis do sistema  ±±±±±±±±±±±±±±±±±±±±±//
Local cCodUser 	:= RetCodUsr()
//Local cNamUser 	:= UsrRetName( cCodUser )//Retorna o nome do us

//±±±±±±±±±±± Forma da Fonte ±±±±±±±±±±±±±±±±±±±±±//
Local cTpFonte 	:= "0" 

//±±±±±±±±±±±fFontes ±±±±±±±±±±±±±±±±±±±±±//
Local cFonte2 	:= "017,017"
Local cFonte3 	:= "018,018"
Local cFonte5 	:= "028,028"
Local cFonte6 	:= "032,032"
Local cFonte7 	:= "042,042"
Local cFonte8 	:= "060,060"
//±±±±±±±±±±± Fontes ±±±±±±±±±±±±±±±±±±±±±//
Local cQuery :=""     
//±±±±±±±±±±± Faz a Consulta no banco ±±±±±±±±±±±±±±±±±±±±±//
cQuery		:= "SELECT F2_DOC,A1_NREDUZ,A1_ENDENT,A1_CEPE,A1_BAIRROE,A1_MUNE,A1_ESTE,A4_NOME "+CHR(13)+CHR(10)
cQuery 		+= "FROM "+CHR(13)+CHR(10)
cQuery 		+=	RetSqlName('SF2010') + " SF2 " +CHR(13)+CHR(10)
cQuery		+= "INNER JOIN SA1010 SA1 ON A1_FILIAL ='' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA "+CHR(13)+CHR(10)
cQuery		+= "INNER JOIN SA4010 SA4 ON A4_FILIAL=' ' AND A4_COD = F2_TRANSP" +CHR(13)+CHR(10)
cQuery 		+= "WHERE SF2.F2_FILIAL ='01' AND " +CHR(13)+CHR(10)
cQuery		+= "SF2.D_E_L_E_T_ ='' AND "+CHR(13)+CHR(10)
cQuery		+= "SA4.D_E_L_E_T_ ='' AND "+CHR(13)+CHR(10)
cQuery 		+= "SF2.F2_DOC = '"+Alltrim(CB7->(CB7_NOTA))+"'"+CHR(13)+CHR(10) //Pega o numero da nota (Nesse momento já esta posicionado na CB7)
//±±±±±±±±±±±Grava o resultado na pasta system ±±±±±±±±±±±±±±±±±±±±±//
MEMOWRIT( "Img05OFI.SQL", cQuery ) 
cQuery 		:= ChangeQuery(cQuery) 
dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery ), "QRY" , .T. , .F. )	
//Seleciona a Area
dbSelectArea("QRY")
dbGotop()

MSCBBEGIN(1,6)
MSCBBOX(03,03,100,55,4,"B")
MSCBBOX(03,03,100,55,4,"B")
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
MSCBSAY(80,04,"VOLUME"				    ,"N",cTpFonte,cFonte2)//Rotulo do Nome do Cliente
MSCBSAY(75,06,StrZero(nAtu,2)+"/"+StrZero(nTotEti,2),"N","0","070,070")
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
MSCBSAY(04,04,"DESTINATARIO"			,"N",cTpFonte,cFonte3)//Rotulo do Nome do Cliente	
MSCBSAY(04,06,Alltrim(QRY->A1_NREDUZ)	,"N",cTpFonte,cFonte8)//Nome do Cliente	 
MSCBLINEH(03,13,100,003,"B") //Linha horizontal
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
MSCBSAY(04,14,"NOTA FISCAL"				,"N",cTpFonte,cFonte3)//Rotulo do Nome do Cliente	
MSCBSAY(04,16,Alltrim(QRY->F2_DOC)		,"N",cTpFonte,cFonte7)//Nome do Cliente	
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
MSCBSAY(04,21,"ENDERECO DE ENTREGA"		    ,"N",cTpFonte,cFonte3)//Rotulo do Nome do Cliente	
MSCBSAY(04,23,UPPER(Alltrim(QRY->A1_ENDENT)),"N",cTpFonte,cFonte6)//Nome do Cliente	
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
MSCBSAY(04,28,"BAIRRO"	    			,"N",cTpFonte,cFonte3)//Rotulo
MSCBSAY(04,30,UPPER(Alltrim(QRY->A1_BAIRROE))	,"N",cTpFonte,cFonte6)//Bairro de Entrega
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
MSCBSAY(53,28,"CIDADE"	    			,"N",cTpFonte,cFonte3)//Rotulo
MSCBSAY(53,30,Alltrim(QRY->A1_MUNE)	    ,"N",cTpFonte,cFonte6)//Municipio de entrga
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
MSCBSAY(94,28,"UF"	    				,"N",cTpFonte,cFonte3)//rotulo 
MSCBSAY(94,30, Alltrim(QRY->A1_ESTE)	,"N",cTpFonte,cFonte6)//Estado de estrega 
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
MSCBSAY(04,35,"CEP"						,"N",cTpFonte,cFonte3) //Rotulo CEP 
MSCBSAY(04,37, Alltrim(QRY->A1_CEPE)    ,"N",cTpFonte,cFonte6)//Numeros do CEP DO LOCLA DE ENTRAGA 	
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
MSCBSAY(04,42,"TRANSPORTADORA"				,"N",cTpFonte,cFonte3)//Rotulo da Transportadora 
MSCBSAY(04,45,UPPER(Alltrim(QRY->A4_NOME) ) ,"N",cTpFonte,cFonte6)//Nome da transportadora
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
MSCBSAY(04,51,"OPERADOR  : "+cValToChar(cCodUser) ,"N",cTpFonte,cFonte5)//Nome d Usuario
MSCBSAY(50,51,"   " +dToc(dDataBase)	,"N",cTpFonte,cFonte5)//Data base do Sistema 

//MSCBSAYBAR(07,02,AllTrim(cId),"B","MB07",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
MSCBInfoEti("Volume Oficial","30X100")
MSCBEND()
QRY->(DbCloseArea())
Return .f.

