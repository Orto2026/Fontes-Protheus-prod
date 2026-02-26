#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR023 ºAutor  ³Samuel Miranda      º Data ³  26/09/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de impressao de etiquetas de identificacao          º±±
±±º          ³ de Enderecos de Produtos do Almoxarifado                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese  (Almoxarifado)                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTR023()

Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo 	:= "Impressão de etiqueta de Identificacao de Enderecos."

Private cDesc1 	:= "Este programa irá imprimir as etiquetas de "
Private cDesc2 	:= "Identificacao de Produto do Almoxarifado, em impressora térmica Zebra, "
Private cDesc3 	:= "conforme os parâmetros definidos pelo usuário."
Private cDesc4 	:= ""
Private cDesc5 	:= "By TI   Ortosintese"
Private cPerg  	:= Padr("RESTR023",10)
Private lEnd 	:= .F.

ValidPerg()

If !Pergunte(cPerg,.T.)
	Return()
Endif	

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )

aAdd( aButton, { 5, .T., { || Pergunte( cPerg, .T. )  } } )
aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch()            } } )

FormBatch( cTitulo, aSay, aButton )

If nOpc == 1
	RptStatus({|lEnd| RESTR023Imp(@lEnd)},"Imprimindo, aguarde...")
Endif	

Return()


Static Function RESTR023Imp(lEnd)

Local nCopias 		:= mv_par03
Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local cTpFonte 		:= "0"
Local cFonte1 		:= "020,020"
Local cFonte2 		:= "017,017"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "015,015"
Local cFonte5 		:= "028,028"
Local cFonte6 		:= "032,032"
    
SetRegua(1)
SBE->(dbSetOrder(1))
If SBE->(!dbSeek(xFilial("SBE")+mv_par01+mv_par02))
	APMsgAlert("Endereco não localizado no cadastro, verifique.")
	Return()
Endif
IncRegua()
	
MSCBPRINTER(cImpressora,cPorta)	 
MSCBCHKStatus(.F.)
  
MSCBBEGIN(nCopias,4) 

MSCBBOX(02,01,85,30,3)  // Box da Borda

MSCBSAY(04,02,"ETIQUETA DE IDENTIFICACAO DE ENDERECO"						,"N",cTpFonte,cFonte5) 
MSCBSAY(04,07,"LOCAL: "			+Alltrim(mv_par01)							,"N",cTpFonte,cFonte5)
MSCBSAY(20,07,"ENDERECO: "		+Alltrim((mv_par02))						,"N",cTpFonte,cFonte5)  	                                          
MSCBSAY(04,11,"DESCRICAO: "	  	+Alltrim(Substr(SBE->BE_DESCRIC,1,35))		,"N",cTpFonte,cFonte5)														   
MSCBSAY(04,14 					,Alltrim(Substr(SBE->BE_DESCRIC,36,70))		,"N",cTpFonte,cFonte5)
MSCBSAYBAR(04,17,Alltrim(Upper(mv_par01))+Alltrim(Upper(mv_par02)) ,"N","MB07",8,.F.,.T.,.F.,,3,2,.F.) 
		
MSCBEND() 
MSCBCLOSEPRINTER()	
MS_FLUSH()             

Return()

Static Function ValidPerg()
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i,j
Local nTamSX1	:= Len(SX1->X1_GRUPO)
Local aHelp := {}
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("RESTR023",nTamSX1)

Aadd(aRegs,{cPerg,"01","Local.....? ","Local ?","Local ? "											,"mv_cha","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Endereco.....? ","Endereco ?","Endereco ? "									,"mv_chb","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SBE","","","","",""})
Aadd(aRegs,{cPerg,"03","Quantidade Copias.....? ","Quantidade Copias ?","Quantidade Copias ? "		,"mv_chc","N",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
		
                
	Endif
Next i

dbSelectArea(_sAlias)

Return()

