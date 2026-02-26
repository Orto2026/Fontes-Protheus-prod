#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TbiConn.ch"  
#INCLUDE "TOTVS.ch"
#INCLUDE "topconn.ch"
#INCLUDE "ap5mail.ch" 
#INCLUDE "fileio.ch"
#DEFINE CRLF chr(13) + chr(10) 

// Programa WFRCOB02
// Autor : Samuel Mirada 03/12/2019
// Envio de aviso de titulos vencidos

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Rotina    | WFRCOB02    º Samuel Mirada            | Data | 03/12/2019 |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Descricao | Rotina para o envio de e-mail com							|±±
//                   informação dos tituloS a vencidos             			|±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±± Uso       | Especifico Ortosintese                                     |±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
////Crescenta o 0 ao nosso numero no final Solicitado pela Joice 14/11/2024 |±±  
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
                                  
User Function WFRCOB02(aParam)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpc 	   	:= 1  

default aParam	:= {"01", "01"}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verificacao de ambiente para rodar em JOB                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_lAgend := .F.
If Type('__LocalDriver') == "U"
	_lAgend := .T.
	RpcSetType(3)
	RpcSetEnv(aParam[1], aParam[2])
	//Prepare Environment Empresa aParam[1] Filial aParam[2] FUNNAME "WFRCOB02"
	CONOUT("Iniciando Processo Agendado - WFRCOB02")
	cParam := aParam[2]
EndIf             

CONOUT("PARAMETRO 1 "+aParam[1] + "PARAMETRO 2 "+aParam[2])
	//Faz a chamanda da função para montar o e-mail
	If nOpc == 1
		U_WfrEmail()
	Endif
CONOUT("Fim do Processo Agendado - WFRCOB02")

Return()

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±± Função   | WfrEmail  | Samuel Miranda            | Data | 03/12/2019   º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±± Descricao | Função para montar o e-mail								º±±//
//                              											º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
User Function WfrEmail()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
//³ Define Variaveis Ambientais                                  //
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
Local cSubject   :="Ortosintese: Aviso de Título(s) Vencido(s)" //Titulo da Mensagem   
Local cFrom	     :="Ortosintese Ind. e Com. Ltda."
Local cNomCli	 := ""
Local _n
Local _cMensa	:= ""
Local cQuery := ""
Local _aMensa	:= {} 
Local nDias		:= 0
Local dDataBase := Date()

Local  cCliDe 			:= " "
Local  cCliAte			:= "ZZZZZZ"
Local  cTitDe			:= " "
Local  cTitAte			:= "ZZZZZZZZZ"
Local  cPrefDe			:= " "
Local  cPrefAte			:= "ZZ"
Local  dEmiDe			:= "20140101"
Local  dEmiAte			:= "20490101"
Local  dVcmtReal		:= dDataBase - 5
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//              PARAMETROS                   ³
//³ mv_par01 - Cliente De                    ³
//³ mv_par02 - Cliente Ate                   ³
//³ mv_par03 - Titulo De                     ³
//³ mv_par04 - Titulo Ate                    ³
//³ mv_par05 - Prefixo De                    ³
//³ mv_par06 - Prefixo Ate                   ³
//³ mv_par07 - Emissao De                    ³
//³ mv_par08 - Emissao Ate                   ³
//³ mv_par09 - Vencrea                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

//Monta a query SQL                                      
cQuery := "SELECT  "+CHR(13)+CHR(10)
cQuery += "SE1.E1_PREFIXO,"+CHR(13)+CHR(10)
cQuery += "SE1.E1_NUM, "+CHR(13)+CHR(10)
cQuery += "SE1.E1_PORTADO AS NBANCO,"+CHR(13)+CHR(10)
cQuery += "SE1.E1_PARCELA,"+CHR(13)+CHR(10)
cQuery += "SE1.E1_TIPO, "+CHR(13)+CHR(10)
cQuery += "SE1.E1_CLIENTE, "+CHR(13)+CHR(10)
cQuery += "SE1.E1_LOJA, "+CHR(13)+CHR(10)
cQuery += "SE1.E1_NOMCLI, "+CHR(13)+CHR(10)
cQuery += "SE1.E1_EMISSAO AS E1_EMISSAO, "+CHR(13)+CHR(10)
cQuery += "SE1.E1_VENCREA AS E1_VENCREA, "+CHR(13)+CHR(10)
cQuery += "SE1.E1_VALOR AS E1_VALOR,"+CHR(13)+CHR(10)
cQuery += "SE1.E1_NUMBCO AS NOSSONUM, "+CHR(13)+CHR(10)
cQuery += "SE1.E1_BAIXA, "+CHR(13)+CHR(10)
cQuery += "SE1.E1_SALDO,"+CHR(13)+CHR(10)
cQuery += "SA1.A1_EMAIL, "+CHR(13)+CHR(10)
cQuery += "SA1.A1_XMAILCB "+CHR(13)+CHR(10)
cQuery += " FROM " 
cQuery += RetSqlName( 'SE1' ) + " SE1 " +CHR(13)+CHR(10)
cQuery += " INNER JOIN SA1010 SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"'  AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA AND SA1.D_E_L_E_T_ = '' " +CHR(13)+CHR(10) 
cQuery += " WHERE " +CHR(13)+CHR(10) 
cQuery += " SE1.E1_FILIAL = '"+xFilial("SE1")+"' " +CHR(13)+CHR(10) 
cQuery += " AND SE1.E1_NUMBCO <>'' " +CHR(13)+CHR(10) 
//cQuery += " AND SE1.E1_CLIENTE BETWEEN '000003' AND '000040' "  +CHR(13)+CHR(10)  // Pra teste 
cQuery += " AND SE1.E1_CLIENTE BETWEEN '" + cCliDe + "' AND '" + cCliAte  + "' " +CHR(13)+CHR(10) 
cQuery += " AND SE1.E1_NUM BETWEEN '" + cTitDe + "' AND '" + cTitAte  + "' " +CHR(13)+CHR(10) 
cQuery += " AND SE1.E1_PREFIXO BETWEEN '" + cPrefDe + "' AND '" + cPrefAte  + "' " +CHR(13)+CHR(10) 
cQuery += " AND SE1.E1_EMISSAO BETWEEN '"+ dEmiDe +"' AND '"+ dEmiAte +"'  "   +CHR(13)+CHR(10) 
cQuery += " AND SE1.E1_VENCREA < '"+(DTOS( dVcmtReal)) +"' "  +CHR(13)+CHR(10)   //AND E1_VENCREA =  '20190603'  AND 
cQuery += " AND SE1.E1_SALDO <> 0  " +CHR(13)+CHR(10)  
cQuery += " AND SE1.E1_TIPO NOT IN ('NCC','RA')  " +CHR(13)+CHR(10)  
cQuery += " AND SA1.A1_XENVMAI='1' " +CHR(13)+CHR(10)  
cQuery += " AND SE1.D_E_L_E_T_ = '' " +CHR(13)+CHR(10)  
cQuery += " ORDER BY SE1.E1_CLIENTE " +CHR(13)+CHR(10)  
//cQuery += " ORDER BY E1_NUM " 
//Grava o resultado da query
MEMOWRIT( "WRFCOB02.SQL", cQuery )                      
cQuery:= ChangeQuery(cQuery)
//TcQuery cQuery New Alias "TRB"
If Select ("TRB") > 0
	TRB->(DbCloseArea())
EndIf        
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
TcSetField("TRB","E1_EMISSAO"	,"D",08,0)
TcSetField("TRB","E1_VENCREA"	,"D",08,0)
TcSetField("TRB","E1_VALOR"  	,"N",14,2)
//Entra no laço
While ! TRB->(Eof())  
		_cCodCli  := TRB->E1_CLIENTE
		cTo       := ""
		_aMensa   := {}
		_xData    := Date()
		cTo       := IIf(Empty(Alltrim(TRB->A1_XMAILCB)),TRB->A1_EMAIL,Alltrim(TRB->A1_XMAILCB)) //e-mail do Cliente
		//cTo     := "samuel.miranda@ortosintese.com.br" //Somente para teste
		//Verifica se o e-mail estiver vazio e busca na tabela.
		If Empty(cTo)
			TRB->(DbSkip())
			Loop
		EndIf	
		//Adicionado os campos NOSSONUM e NBAMCO Por  12/07/2021
         //Adiciona os dados no array
			While ! TRB->(Eof()) .And. _cCodCli == TRB->E1_CLIENTE  //.AND. dDataBase == (TRB->E1_VENCREA+4) 	
				nDias :=0
				nDias := dDataBase - TRB->E1_VENCREA
				AADD(_aMensa, {TRB->E1_NUM,TRB->NOSSONUM,TRB->E1_PARCELA,DTOC(TRB->E1_EMISSAO),DTOC(TRB->E1_VENCREA),nDias,TRB->E1_VALOR,TRB->NBANCO} ) 
						//            01          02              03                  04                    05         06          07           08
				cNomCli  := TRB->E1_NOMCLI
				TRB->(DbSkip())
			EndDo

			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
			//±±anda 15/06/2020  Por Samuel Mirand±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
			//Cria um arquivo txt com a relação dos e-mails eviandos e a data           º±±//
			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
			//Verifica se o arquivo existe,se não ele cria
			//If !File(_xArquivo)
			//	nHandle := FCREATE(_xArquivo)// Cria o arquivo
			//	fclose(nHandle) // Fecha o arquivo para gravação
			//EndIf
			//nHandle := fopen(_xArquivo , FO_READWRITE + FO_SHARED )// Abre o arquivo
			//FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
			//FWrite(nHandle,Dtoc(_xData) + " - "+ _cCodCli+" - "+cNomCli+" - "+cTo +CRLF ) // Insere texto no arquivo
			//fclose(nHandle) // Fecha o arquivo
			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//

			_cMensa	:= ""
			_cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> Prezado Cliente, <b>" +cNomCli+"</b></span></p>"
			_cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> A Ortosintese gostaria de lembra-lo que o(s) título(s) abaixo venceram.  </span></p>"
			_cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> Até a presente data não constam em nossos registros os pagamentos referentes as faturas abaixo. </span></p>"
			_cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> Título(s) vencido(s): </span></p>"
			_cMensa += "<table border='0' cellpadding='2' cellspacing='1' width='100%'>"
			_cMensa += " <tr>"
			_cMensa += "   <td width='60' bgcolor='#AAC8FF' height='19'>"
			_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'>  <b>Número</b> </span> </p>"	 	   //01 ->Numero	
			_cMensa += "   </td>"
			_cMensa += "   <td width='60' bgcolor='#AAC8FF' height='19'>"
			_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'>  <b>Banco</b> </span> </p>"	 	   //02 ->Banco
			_cMensa += "   </td>"
			_cMensa += "   <td width='60' bgcolor='#AAC8FF' height='19'>"
			_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'>  <b>Nosso Número</b> </span> </p>"  //03 -> Nosso Número
			_cMensa += "   </td>"
			_cMensa += "   <td width='40' bgcolor='#AAC8FF' height='19'>"
			_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'>  <b>Parcela</b> </span> </p>"   		//04 -> Parcela
			_cMensa += "   </td>"	
			_cMensa += "   <td width='78' bgcolor='#AAC8FF' height='19'>"
			_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> <b>Emissao</b> </span> </p>"    		//05 -> Emissao
			_cMensa += "   </td>"
			_cMensa += "   <td width='78' bgcolor='#AAC8FF' height='19'>"
			_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> <b>Vencimento</b> </span> </p>" 		//06 -> Vencimento
			_cMensa += "   </td>"
			_cMensa += "   <td width='40' bgcolor='#AAC8FF' height='19'>"
			_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> <b>Atraso (dias)</b> </span> </p>"   //07 -> Dias em Atraso
			_cMensa += "   </td>"
			_cMensa += "   <td width='80' bgcolor='#AAC8FF' height='19'>"
			_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'>  <b>Valor (R$)</b> </span> </p>"    	//08 -> Valor 
			_cMensa += "   </td>"
			_cMensa += " </tr>"
			cCor	:=	"DFEFFF"
			//Entra no laço para montar a tabela com os registros
			For _n := 1 To Len(_aMensa)
				
				_cMensa += " <tr>"
				_cMensa += "   <td width='60' bgcolor='#"+cCor+"' height='19'>"
				_cMensa += "    <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> " +_aMensa[_n,1]+" </span> </p>" 		//Numero			
				_cMensa += "   </td>"
				//Verifica se o banco é o 001 (Banco do Brasil)  12/07/2021
				If _aMensa[_n,8] =="001"
					_cMensa += "   <td width='60' bgcolor='#"+cCor+"' height='19'>"
					_cMensa += "    <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> Brasil </span> </p>" 		//Bano			
					_cMensa += "   </td>"
				EndIf
				//Verifica se o banco é o 341 (Banco itaú)  12/07/2021
				If _aMensa[_n,8] =="341"
					_cMensa += "   <td width='60' bgcolor='#"+cCor+"' height='19'>"
					_cMensa += "    <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> Itaú </span> </p>" 		//Bano			
					_cMensa += "   </td>"
				EndIf
				//Verifica se o banco é o 001 (Banco do Brasil)  12/07/2021
				If _aMensa[_n,8] =='001'
					_cMensa += "   <td width='60' bgcolor='#"+cCor+"' height='19'>"
					_cMensa += "    <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> " +SubStr(_aMensa[_n,2],1,11)+"0"+" </span> </p>" //Nosso Número			
					_cMensa += "   </td>"
				ElseIf _aMensa[_n,8] =='341'
					_cMensa += "   <td width='60' bgcolor='#"+cCor+"' height='19'>"
					_cMensa += "    <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> 0048545438112"+_aMensa[_n,2]+"0"+" </span> </p>" //Nosso Número			
					_cMensa += "   </td>"
				Else	
					_cMensa += "   <td width='60' bgcolor='#"+cCor+"' height='19'>"
					_cMensa += "    <p align='left'> <span style='font-size:9.0pt;font-family:Arial'>           </span> </p>" //Nosso Número			
					_cMensa += "   </td>"
				EndIf
				//--------------------------------------------------------------------------------------------------------
				_cMensa += "   <td width='40' bgcolor='#"+cCor+"' height='19'>"
				_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> "+_aMensa[_n,3]+" </span> </p>" 		//parcela
				_cMensa += "   </td>"	
			  	_cMensa += "   <td width='80' bgcolor='#"+cCor+"' height='19'>"
				_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> "+_aMensa[_n,4]+"</span> </p>" 		// Emissao
				_cMensa += "   </td>"
				_cMensa += "   <td width='80' bgcolor='#"+cCor+"' height='19'>"
				_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'>"+_aMensa[_n,5]+"</span> </p>" 		// Vencimento
				_cMensa += "   </td>"
				_cMensa += "   <td width='40' bgcolor='#"+cCor+"' height='19'>"
				_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> "+cvaltochar(_aMensa[_n,6])+"</span> </p>" //Dias em Atraso
				_cMensa += "   </td>"	
				_cMensa += "   <td width='80' bgcolor='#"+cCor+"' height='19'>"
				_cMensa += "     <p align='left'> <span style='font-size:9.0pt;font-family:Arial'> "+AllTrim(Transform(_aMensa[_n,7],"@E 9,999,999.99"))+"</span> </p>" // Valor   
				_cMensa += "   </td>"
				_cMensa += " </tr>"
				If cCor == "DFEFFF" //Tratamento de cores nas linhas     
					cCor := "FFFFFF"
				Else
					cCor := "DFEFFF"
				EndIf					
			Next _n
			//Codigo das Cores em HTMl
			cAzul 		:= "0000FF"
			cPadrao 	:= "008B8B"
			cCinza 		:= "A9A9A9"
			cTurqueza 	:= "20B2AA"			
			_cMensa += "</table>"
			_cMensa += "</br>"		
			_cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> Assim sendo, solicitamos que entre em contato para maiores esclarecimentos.   </b> </span></p>"
			_cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> <b>Atenção:</b> Após 8 dias corridos do vencimento os título serão enviados para cartório. </span></p>"
			
			_cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> <b>Clique no link abaixo para gerar a 2ª via e/ou atualização do seu boleto de cobrança</b>  </span></p>"
			//_cMensa += "<span style='font-size:9.0pt;font-family:Arial'> Banco do Brasil </br> </span>"
			//_cMensa += "<span style='font-size:9.0pt;font-family:Arial'> https://www63.bb.com.br/portalbb/boleto/boletos/hc21e,802,3322,10343.bbx </span>"
			//_cMensa += "</br>"
			_cMensa += "</br>"
			_cMensa += "<span style='font-size:9.0pt;font-family:Arial'> Banco Itaú </br> </span>"
			_cMensa += "<span style='font-size:9.0pt;font-family:Arial'> https://www.itau.com.br/servicos/boletos/segunda-via </span>"
			//--------------------------------------------------------------------------------------------------------------------------------------------------------------//
			_cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> P.S.: Caso já tenha efetuado o pagamento desconsidere esta mensagem.</b> </span></p>"
			_cMensa += "<p><span style='font-size:9.0pt;font-family:Arial'> <b>***</b> E-mail enviado automaticamente by TI | Ortosintese <b>***</b> </span></p>"
			_cMensa += "</br>"			
			_cMensa += " <p><b> <span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'> Atenciosamente,  	</b>  </span></p>"
			_cMensa += "  <span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'> Joice Pereira			</br> </span>"
			_cMensa += "  <span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'> Departamento de Cobrança	</br> </span>"
			_cMensa += "  <span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'> 55 11 3948-4015  - Direto	</br> </span>"
			_cMensa += "  <span style='font-size:9.0pt;font-family:Arial;  line-height:5px;'> 55 11 3948-4000 	  	    </br> </span>"
			_cMensa += " <span style='font-size:9.0pt;font-family:Arial'> www.ortosintese.com.br 	 	 				</b>  </span>"
			_cMensa += "</br>"				
			//Rotina para enviar o e-mail				
			EnviaMail( cFrom, cSubject, _cMensa,cTo,_cCodCli,cNomCli ) 			
EndDo

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±± Função   | WfrEmail  | Samuel Miranda            | Data | 03/12/2019   º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±± Descricao | Função para enviar o e-mail							    º±±//
//                              											º±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
Static Function EnviaMail( cFrom, cSubject, _cMensa,cTo,_cCodCli,cNomCli)
    Local cMsg      := ""
    Local xRet
    Local oServer, oMessage
    Local lMailAuth := SuperGetMv("MV_RELAUTH",,.F.)
    Local cPara     := cTo
    Local cAssunto  := cSubject
    Local cMensagem := _cMensa
		//Grava o arquivo de log
	   _xArquivo := ("\LOGS_PROGRAMAS\WFRCOB02_"+StrTran(AllTrim(Dtoc(_xData)),"/","") +".txt")//Nome do Arquivo de Log
	
    Private cMailConta  := NIL
    Private cMailServer := NIL
    Private cMailSenha  := NIL
    //Feita a troca do e-mail de autenticação 12/03/2025 - Por Samuel Miranda
    //cMailConta :="joice.pereira@ortosintese.com.br" //Conta utilizada para envio do email
    //cMailServer:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer) //Servidor SMTP
    //cMailSenha := SuperGetMv("MV_SENMAIL")//Senha para autenticação do e-mail 
	//Paramentros para autenticação do e-mail
    cMailConta  := Alltrim("suporte@ortosintese.com.br") //Conta utilizada para envio do email
    cMailServer := Alltrim(If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)) //Servidor SMTP
    cMailSenha  := Alltrim("Lynce478")//Senha da conta de e-mail utilizada para envio
	//cMailSenha  := Alltrim("P@ssOrto#20!4998")//If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha))            //Senha da conta de e-mail utilizada para envio
	oMessage:= TMailMessage():New()
    oMessage:Clear()
    oMessage:cDate      := cValToChar( Date() )
    oMessage:cFrom      := cMailConta
    oMessage:cTo        := Alltrim(cPara)
    oMessage:cSubject   := cAssunto
    oMessage:cBody      := cMensagem
    
    oServer := tMailManager():New()
    oServer:SetUseTLS( .T. ) //Indica se será utilizará a comunicação segura através de SSL/TLS (.T.) ou não (.F.)
   
    xRet := oServer:Init( "", cMailServer, cMailConta, cMailSenha, 0)//,nPorta)//nPorta ) //inicilizar o servidor
    if xRet != 0
        alert("O servidor SMTP não foi inicializado: " + oServer:GetErrorString( xRet ) )
        return
    endif
   
    xRet := oServer:SetSMTPTimeout(60) //Indica o tempo de espera em segundos.
    if xRet != 0
        alert("Não foi possível definir " + cProtocol + " tempo limite para " + cValToChar( nTimeout ))
    endif
   
    xRet := oServer:SMTPConnect()
    if xRet <> 0
        alert("Não foi possível conectar ao servidor SMTP: " + oServer:GetErrorString(xRet))
        return
    endif
   
    if lMailAuth
        //O método SMTPAuth ao tentar realizar a autenticação do 
        //usuário no servidor de e-mail, verifica a configuração 
        //da chave AuthSmtp, na seção [Mail], no arquivo de 
        //configuração (INI) do TOTVS Application Server, para determinar o valor.
        xRet := oServer:SmtpAuth(cMailConta,cMailSenha)
        if xRet <> 0
            cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString(xRet)
            alert( cMsg )
            oServer:SMTPDisconnect()
            return
        endif
    Endif
	
    xRet := oMessage:Send(oServer)
    if xRet <> 0
        alert("Não foi possível enviar mensagem: " + oServer:GetErrorString( xRet ))
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
		//±±anda 15/06/2020 Samuel Miranda  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
		//Cria um arquivo txt com a relação dos e-mails eviandos e a data            º±±//
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± //
		//Verifica se o arquivo existe,se não ele cria
		If !File(_xArquivo)
			nHandle := FCREATE(_xArquivo)// Cria o arquiv0
			fclose(nHandle) // Fecha o arquivo para gravação
		EndIf
		nHandle := fopen(_xArquivo , FO_READWRITE + FO_SHARED )// Abre o arquivo
		FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
		FWrite(nHandle,Dtoc(_xData) + " - Não foi possível enviar mensagem - "+cPara +CRLF ) // Insere texto no arquivo
		fclose(nHandle) // Fecha o arquivo
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
	Else
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
		//±±anda 15/06/2020 Samuel Miranda ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
		//Cria um arquivo txt com a relação dos e-mails eviandos e a data           º±±//
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
		//Verifica se o arquivo existe,se não ele cria
		If !File(_xArquivo)
			nHandle := FCREATE(_xArquivo)// Cria o arquivo
			fclose(nHandle) // Fecha o arquivo para gravação
		EndIf
		nHandle := fopen(_xArquivo , FO_READWRITE + FO_SHARED )// Abre o arquivo
		FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
		FWrite(nHandle,Dtoc(_xData) + " - "+ _cCodCli+" - "+cNomCli+" - "+cPara +CRLF ) // Insere texto no arquivo
		fclose(nHandle) // Fecha o arquivo
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
	endif

    xRet := oServer:SMTPDisconnect()
    if xRet <> 0
        alert("Não foi possível desconectar o servidor SMTP: " + oServer:GetErrorString( xRet ))
    endif

return

