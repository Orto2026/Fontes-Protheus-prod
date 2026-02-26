#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFRMACLI  ºAutor  ³Claudio Ferreira    º Data ³  04/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia workflow aos Clientes com os Titulos em atraso        º±±
±±º          ³								                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico Ortosintese                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                                     
User Function WFRMACLI()

Local cFrom		:= "cob@ortosintese.com.br"
Local cSubject	:= "Titulos com atraso"
Local _cMensa	:= ""
//Local cTo		:= "claudiofek@gmail.com"//apenas para teste
Local cTo		:=	""
Local cCC		:= ""
Local cQuery	:= ""
Local _aMensa	:= {}
Local _n := 0 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt      	:= Space(10)
CbCont     	:= 0
tamanho    	:= "G"
li         	:= 132
nCnt       	:= 1
nTipo      	:= 15
limite     	:= 220
titulo     	:= PADC("Geracao de titulos em aberto por Clientes",74)
cDesc1     	:= PADC("Este relatorio apresentara por Cliente,",74)
cDesc2     	:= PADC("os titulos em atrasos no periodo solicitado",74)
cDesc3     	:= PADC("Relatorio de Titulos em Atraso por Clientes ",74)
aReturn    	:= { "Especial", 1,"Administracao", 1, 2, 1," ",1 }
nLastKey   	:= 0
lContinua  	:= .T.
m_pag      	:= 1
nomeprog   	:= "WFRMACLI"
cString    	:= "SE1"
aRegs 		:= {}
cPerg		:= "WFRMA1"

Aadd(aRegs,{cPerg,"01","Cliente De  ?","","","mv_ch1","C",06,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Cliente Ate ?","","","mv_ch2","C",06,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Titulo De   ?","","","mv_ch3","C",09,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Titulo Ate  ?","","","mv_ch4","C",09,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Prefixo De  ?","","","mv_ch5","C",02,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Prefixo Ate ?","","","mv_ch6","C",02,0,0,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
Aadd(aRegs,{cPerg,"07","Emissao De  ?","","","mv_ch7","D",08,0,0,"G","","Mv_Par07","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Emissao Ate ?","","","mv_ch8","D",08,0,0,"G","","Mv_Par08","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"09","Vencrea De  ?","","","mv_ch9","D",08,0,0,"G","","Mv_Par09","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"10","Vencrea Ate ?","","","mv_cha","D",08,0,0,"G","","Mv_Par10","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,cPerg)       


Pergunte(cPerg,.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Cliente De                    ³
//³ mv_par02 - Cliente Ate                   ³
//³ mv_par03 - Titulo De                     ³
//³ mv_par04 - Titulo Ate                    ³
//³ mv_par05 - Prefixo De                    ³
//³ mv_par06 - Prefixo Ate                   ³
//³ mv_par07 - Emissao De                    ³
//³ mv_par08 - Emissao Ate                   ³
//³ mv_par09 - Vencrea De                    ³
//³ mv_par10 - Vencrea Ate                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

//³ Envia controle para a funcao SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "WFRMACLI"
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)


If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
EndIf
                                         

cQuery := "SELECT  "
cQuery += " E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, "
cQuery += " E1_EMISSAO AS E1_EMISSAO, E1_VENCREA AS E1_VENCREA, E1_VALOR AS E1_VALOR, E1_BAIXA , E1_SALDO ,A1_EMAIL "
cQuery += " FROM " 
cQuery += RetSqlName( 'SE1' ) + " SE1 "
cQuery += " INNER JOIN SA1010 SA1 ON A1_FILIAL = '"+xFilial("SA1")+"'  AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = '' "   
cQuery += " WHERE " 
cQuery += "  E1_FILIAL = '"+xFilial("SE1")+"' "
cQuery += " AND E1_CLIENTE BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02  + "' "
cQuery += " AND E1_NUM BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04  + "' "
cQuery += " AND E1_PREFIXO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06  + "' "
cQuery += " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"'  "  
cQuery += " AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"'  " 
cQuery += " AND E1_BAIXA = '' "
cQuery += " AND SE1.D_E_L_E_T_ = '' "
cQuery += " ORDER BY E1_NUM " 

//cQuery += "  E1_FILIAL = '"+xFilial("SE1")+"' "
//cQuery += " AND E1_CLIENTE BETWEEN '000190' AND '000190' "
//cQuery += " AND E1_NUM BETWEEN '         ' AND 'ZZZZZZZZZ' "
//cQuery += " AND E1_EMISSAO BETWEEN '20140129' AND '20140129'  "  
//cQuery += " AND E1_PREFIXO BETWEEN '  ' AND 'ZZ' " 
//cQuery += " AND E1_VENCREA BETWEEN '20140331' AND '20140331'  " 
//cQuery += " AND E1_BAIXA = '' "
//cQuery += " AND SE1.D_E_L_E_T_ = '' "
//cQuery += " ORDER BY E1_NUM "                             
cQuery:= ChangeQuery(cQuery)

If Select ("TRB") > 0
	TRB->(DbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)

TcSetField("TRB","E1_EMISSAO"		,"D",08,0)
TcSetField("TRB","E1_VENCREA"		,"D",08,0)
TcSetField("TRB","E1_VALOR"  	   ,"N",14,2)

DbSelectArea("SA1")
SA1->(DbSetOrder(1))

While ! TRB->(Eof())
	_cCodCli := TRB->E1_CLIENTE
	cTo := ""
	
	If SA1->(DbSeek(xFilial("SA1")+_cCodCli))
		_aMensa	:= {}
		cTo := Alltrim(SA1->A1_XMAILCB) //e-mail do Cliente
		If Empty(cTo)
			TRB->(DbSkip())
			Loop
		EndIf	
		While ! TRB->(Eof()) .And. _cCodCli == TRB->E1_CLIENTE
			AADD(_aMensa, {TRB->E1_PREFIXO,TRB->E1_NUM,TRB->E1_PARCELA,TRB->E1_TIPO,TRB->E1_CLIENTE,TRB->E1_LOJA,TRB->E1_NOMCLI,DTOC(TRB->E1_EMISSAO),DTOC(TRB->E1_VENCREA),TRB->E1_VALOR} ) 
			TRB->(DbSkip())
		End
		_cMensa	:= ""
		_cMensa += "<p><span style='font-size:12.0pt;font-family:Arial'><b>Ortosintese - Mensagem automatica, favor nao responder este email. </b></span></p>"
		_cMensa += "<p><span style='font-size:12.0pt;font-family:Arial'>Caro(a) Cliente <b>"+SA1->A1_NOME+"</b></span></p>"
		_cMensa += "<p><span style='font-size:12.0pt;font-family:Arial'>Acusamos em nossos registros o(s) titulo(s) em aberto e solicitamos providências para quitação do mesmo . Em caso de duvidas favor entrar em contato atraves do email cob@ortosintese.com.br</span></p>"
		_cMensa += "<p><span style='font-size:12.0pt;font-family:Arial'>Caso já quitado(s), favor desconsiderar esse comunicado.</span></p>" 
		_cMensa += "<p><span style='font-size:12.0pt;font-family:Arial'>Sendo só e à disposição..</span></p>"
		_cMensa += "<p><span style='font-size:12.0pt;font-family:Arial'>Segue listagem do(s) Titulos(s) em atraso:</span></p>"
		_cMensa += "<table border='0' cellpadding='2' cellspacing='1' width='100%'>"
		_cMensa += " <tr>"
		_cMensa += "   <td width='40' bgcolor='#AAC8FF' height='19'>"
		_cMensa += "     <p align='left'><font face='Arial' size='2'><b>Prefixo</b></font></p>"
		_cMensa += "   </td>"
		_cMensa += "   <td width='60' bgcolor='#AAC8FF' height='19'>"
		_cMensa += "     <p align='left'><font face='Arial' size='2'><b>Numero</b></font></p>"
		_cMensa += "   </td>"
		_cMensa += "   <td width='40' bgcolor='#AAC8FF' height='19'>"
		_cMensa += "     <p align='left'><font face='Arial' size='2'><b>parcela</b></font></p>"
		_cMensa += "   </td>"
		_cMensa += "   <td width='40' bgcolor='#AAC8FF' height='19'>"
		_cMensa += "     <p align='left'><font face='Arial' size='2'><b>Tipo</b></font></p>"
		_cMensa += "   </td>"
		_cMensa += "   <td width='40' bgcolor='#AAC8FF' height='19'>"
		_cMensa += "     <p align='left'><font face='Arial' size='2'><b>Cliente</b></font></p>"
		_cMensa += "   </td>"
		_cMensa += "   <td width='40' bgcolor='#AAC8FF' height='19'>"
		_cMensa += "     <p align='left'><font face='Arial' size='2'><b>Loja</b></font></p>"
		_cMensa += "   </td>"
		_cMensa += "   <td width='160' bgcolor='#AAC8FF' height='19'>"
		_cMensa += "     <p align='left'><font face='Arial' size='2'><b>Nome</b></font></p>"
		_cMensa += "   </td>"
		_cMensa += "   <td width='80' bgcolor='#AAC8FF' height='19'>"
		_cMensa += "     <p align='left'><font face='Arial' size='2'><b>Emissao</b></font></p>"
		_cMensa += "   </td>"
		_cMensa += "   <td width='80' bgcolor='#AAC8FF' height='19'>"
		_cMensa += "     <p align='left'><font face='Arial' size='2'><b>Vencto</b></font></p>"
		_cMensa += "   </td>"
		_cMensa += "   <td width='80' bgcolor='#AAC8FF' height='19'>"
		_cMensa += "     <p align='left'><font face='Arial' size='2'><b>Valor</b></font></p>"
		_cMensa += "   </td>"
		_cMensa += " </tr>"
		cCor	:=	"DFEFFF"
		For _n := 1 To Len(_aMensa)
			
			_cMensa += " <tr>"
			_cMensa += "   <td width='40' bgcolor='#"+cCor+"' height='19'>"
			_cMensa += "     <p align='left'><font face='Arial' size='2'>"+_aMensa[_n,1]+"</font></p>" //Prefixo
			_cMensa += "   </td>"
			_cMensa += "   <td width='60' bgcolor='#"+cCor+"' height='19'>"
			_cMensa += "     <p align='left'><font face='Arial' size='2'>"+_aMensa[_n,2]+"</font></p>" //Numero
			_cMensa += "   </td>"
			_cMensa += "   <td width='40' bgcolor='#"+cCor+"' height='19'>"
			_cMensa += "     <p align='left'><font face='Arial' size='2'>"+_aMensa[_n,3]+"</font></p>" //parcela
			_cMensa += "   </td>"
			_cMensa += "   <td width='40' bgcolor='#"+cCor+"' height='19'>"
			_cMensa += "     <p align='left'><font face='Arial' size='2'>"+_aMensa[_n,4]+"</font></p>" //tipo
			_cMensa += "   </td>"
			_cMensa += "   <td width='40' bgcolor='#"+cCor+"' height='19'>"
			_cMensa += "     <p align='left'><font face='Arial' size='2'>"+_aMensa[_n,5]+"</font></p>" // Cliente
			_cMensa += "   </td>"
			_cMensa += "   <td width='40' bgcolor='#"+cCor+"' height='19'>"
			_cMensa += "     <p align='left'><font face='Arial' size='2'>"+_aMensa[_n,6]+"</font></p>" // loja
			_cMensa += "   </td>"
			_cMensa += "   <td width='160' bgcolor='#"+cCor+"' height='19'>"
			_cMensa += "     <p align='left'><font face='Arial' size='2'>"+_aMensa[_n,7]+"</font></p>" // Nome
			_cMensa += "   </td>"
		  	_cMensa += "   <td width='80' bgcolor='#"+cCor+"' height='19'>"
			_cMensa += "     <p align='left'><font face='Arial' size='2'>"+_aMensa[_n,8]+"</font></p>" // Emissao
			_cMensa += "   </td>"
			_cMensa += "   <td width='80' bgcolor='#"+cCor+"' height='19'>"
			_cMensa += "     <p align='left'><font face='Arial' size='2'>"+_aMensa[_n,9]+"</font></p>" // Vencto
			_cMensa += "   </td>"
			_cMensa += "   <td width='80' bgcolor='#"+cCor+"' height='19'>"
			_cMensa += "     <p align='left'><font face='Arial' size='2'>"+AllTrim(Transform(_aMensa[_n,10],"@E 9,999,999.99"))+"</font></p>" // valor   
			_cMensa += "   </td>"
			_cMensa += " </tr>"
			If cCor == "DFEFFF" //Tratamento de cores nas linhas     
				cCor := "FFFFFF"
			Else
				cCor := "DFEFFF"
			EndIf					
		Next _n
		_cMensa += "</table>"
		_cMensa += "&nbsp"
		
		U_Mail001( cFrom, cSubject, _cMensa,cTo )

	EndIf
End

Return