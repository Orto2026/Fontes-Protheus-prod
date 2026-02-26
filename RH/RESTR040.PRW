#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RESTR040 ºAutor  ³Samuel Miranda      º Data ³  04/02/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de impressao de etiquetas de indentificação 		  º±±
±±º          ³ no cartão de Ponto					                   	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ortosintese  Etiqueta 80 X 40 mm                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESTR040()

Local aSay 		:= {}
Local aButton 	:= {}
Local nOpc 		:= 0
Local cTitulo 	:= "Impressão de etiqueta RH "

Private cDesc1 	:= "Este programa irá imprimir as etiquetas do "
Private cDesc2 	:= "cartão de ponto em impressora térmica Zebra, "
Private cDesc3 	:= "conforme os parâmetros definidos pelo usuário."
Private cDesc4 	:= ""
Private cDesc5 	:= ""
Private cDesc6 	:= "By TI Ortosintese"
Private cPerg  	:= Padr("RESTR040",10)
Private lEnd 	:= .F.

ValidPerg()

//If !Pergunte(cPerg,.T.)
	//Return()
//Endif

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )
aAdd( aSay, cDesc6 )

aAdd( aButton, { 5, .T., { || Pergunte( cPerg, .T. )  } } )
aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch()            } } )

FormBatch( cTitulo, aSay, aButton )

If nOpc == 1
	RptStatus({|lEnd| U_RESTR40Imp(@lEnd)},"Imprimindo, aguarde...")
Endif

Return()


User Function RESTR40Imp(lEnd)

Local nCopias 		:= 1
Local cImpressora 	:= "ZEBRA"
Local cPorta 		:= "LPT1"
Local nRec			:= 0
Local cTpFonte 		:= "0"
Local cFonte1 		:= "020,020"
Local cFonte2 		:= "020,020"
Local cFonte3 		:= "024,024"
Local cFonte4 		:= "030,030"
Local cFonte5 		:= "050,050"
Local cFonte6 		:= "080,080"
Local cLoja 		:= ""

xCol := 04 //Valor da Coluna
yLin := 05 //Valor da Linha

cLoja := IIf(MV_PAR05 = 1,"01","02")

SetRegua(1)
	cQuery := "SELECT DISTINCT " + CHR(13)+CHR(10)
	cQuery += "RA_FILIAL AS FILIAL," + CHR(13)+CHR(10)
	cQuery += "RA_MAT AS MATRICULA," + CHR(13)+CHR(10)	 
	cQuery += "RA_NOME AS NOME," + CHR(13)+CHR(10)	 
	cQuery += "RA_DEMISSA AS DMISSAO," + CHR(13)+CHR(10)
	cQuery += "RA_NUMCP+'/'+RA_SERCP+'/'+RA_UFCP AS CT," + CHR(13)+CHR(10)	 	 
	cQuery += "RJ_DESC AS FUNCAO," + CHR(13)+CHR(10)
	cQuery += " CASE WHEN (SELECT PF_TURNOPA FROM SPF010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM SPF010  WHERE PF_MAT=RA_MAT AND D_E_L_E_T_='')) = '001' THEN '07:00 AS 17:00  / 12:00 - 13:00' " + CHR(13)+CHR(10)
	cQuery += "WHEN (SELECT PF_TURNOPA FROM SPF010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM SPF010  WHERE PF_MAT=RA_MAT AND D_E_L_E_T_='')) = '002' THEN '08:00 AS 18:00  / 12:00 - 13:00' " + CHR(13)+CHR(10)
	cQuery += "WHEN (SELECT PF_TURNOPA FROM SPF010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM SPF010  WHERE PF_MAT=RA_MAT AND D_E_L_E_T_='')) = '003' THEN '07:00 AS 17:00  / 12:00 - 13:00' " + CHR(13)+CHR(10)
	cQuery += "WHEN (SELECT PF_TURNOPA FROM SPF010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM SPF010  WHERE PF_MAT=RA_MAT AND D_E_L_E_T_='')) = '007' THEN '21:00 AS 06:00  / 01:30 - 02:30' " + CHR(13)+CHR(10)
	cQuery += "WHEN (SELECT PF_TURNOPA FROM SPF010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM SPF010  WHERE PF_MAT=RA_MAT AND D_E_L_E_T_='')) = '010' THEN '22:00 AS 06:00  / 01:30 - 02:30' " + CHR(13)+CHR(10)
	cQuery += "WHEN (SELECT PF_TURNOPA FROM SPF010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM SPF010  WHERE PF_MAT=RA_MAT AND D_E_L_E_T_='')) = '009' THEN '14:00 AS 22:00  / 19:00 - 20:00' " + CHR(13)+CHR(10)
	cQuery += "WHEN (SELECT PF_TURNOPA FROM SPF010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM SPF010  WHERE PF_MAT=RA_MAT AND D_E_L_E_T_='')) = '006' THEN '07:00 AS 13:00 ' " + CHR(13)+CHR(10)
	cQuery += "WHEN (SELECT PF_TURNOPA FROM SPF010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM SPF010  WHERE PF_MAT=RA_MAT AND D_E_L_E_T_='')) = '005' THEN '07:00 AS 11:00 ' " + CHR(13)+CHR(10)
	cQuery += "WHEN (SELECT PF_TURNOPA FROM SPF010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM SPF010  WHERE PF_MAT=RA_MAT AND D_E_L_E_T_='')) = '008' THEN '06:00 AS 14:00 ' " + CHR(13)+CHR(10)
	cQuery += "WHEN (SELECT PF_TURNOPA FROM SPF010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM SPF010  WHERE PF_MAT=RA_MAT AND D_E_L_E_T_='')) = '004' THEN '12:00 AS 18:00 ' " + CHR(13)+CHR(10)
	cQuery += "WHEN (SELECT PF_TURNOPA FROM SPF010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM SPF010  WHERE PF_MAT=RA_MAT AND D_E_L_E_T_='')) = '006' THEN '13:00 AS 17:00 ' " + CHR(13)+CHR(10)
	cQuery += "ELSE '' END AS HORARIO" + CHR(13)+CHR(10)
	cQuery += "FROM " + CHR(13)+CHR(10)
	cQuery += RetSqlName('SRA010 ') + " SRA " + CHR(13)+CHR(10) 
	cQuery += " INNER JOIN SRJ010 SRJ ON RA_CODFUNC = RJ_FUNCAO  " + CHR(13)+CHR(10)
	cQuery += " WHERE  " + CHR(13)+CHR(10)	
	cQuery += "RA_MAT BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04+"' AND " + CHR(13)+CHR(10)	 
	cQuery += "RA_FILIAL = '"+ cLoja +"'  AND" + CHR(13)+CHR(10)	 
	cQuery += "RA_DEMISSA ='' AND" + CHR(13)+CHR(10)	
	cQuery += "SRJ.D_E_L_E_T_='' AND" + CHR(13)+CHR(10)	 
	cQuery += "SRA.D_E_L_E_T_=''" + CHR(13)+CHR(10)	 
	cQuery += " ORDER BY RA_MAT " + CHR(13)+CHR(10)	 
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("RESTR040.SQL", cQuery )	
	dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery ), "QRY" , .T. , .F. )	
	dbSelectArea( "QRY" )
	dbGotop()
		QRY->(dbEval({ || nRec++ },,{||!Eof()} ))
	dbGoTop()
			 
IncRegua()	

	If nRec == 0
		dbSelectArea("QRY")
		dbCloseArea()
		Alert("Registro não encontado nessa Organização!." ,"Verifique !")
		Return()
	Endif
		
	dbSelectArea("QRY")
	dbGotop()

	
	While !QRY->(Eof())
	//cLoja := QRY->FILIAL
	MSCBPRINTER(cImpressora,cPorta)
	MSCBCHKStatus(.F.)
	MSCBBEGIN(1,4)
	
			
		MSCBBOX(003,003,080,040,4)// Box da Borda
		MSCBSAY(xCol	,yLin,	"  ** PERÍODO DE : "+ dToc(MV_PAR01)	+" ATÉ : "	+ dToc(MV_PAR02) +" **"													,"N",cTpFonte,cFonte2)																					
		MSCBSAY(xCol+61,yLin,	cValToChar(val(AllTrim(QRY->MATRICULA) ))										 													,"N",cTpFonte,cFonte5)	
		MSCBSAY(xCol	,yLin+5,"ORTOSINTESE INDUSTRIA E COMÉRCIO LTDA."   				 																			,"N",cTpFonte,cFonte2)
		MSCBSAY(xCol	,yLin+10,IIf(cLoja="01","48.240.709/0001-90",IIf(cLoja="02","48.240.709/0003-52","")) 											,"N",cTpFonte,cFonte2)
		MSCBSAY(xCol	,yLin+15,IIf(cLoja="01","RUA PROF§. ALFONSO JOSÉ FIORAVANTI, 63",IIf(cLoja="02","AV. NELSON PALMA TRAVASSOS 651","")) 	,"N",cTpFonte,cFonte2)	
		MSCBSAY(xCol	,yLin+20,AllTrim(QRY->MATRICULA)+" "+ AllTrim(QRY->NOME)				 											  						,"N",cTpFonte,cFonte2)	
		MSCBSAY(xCol	,yLin+25,"CARGO - " + AllTrim(QRY->FUNCAO)  				 														  							,"N",cTpFonte,cFonte2)	
		MSCBSAY(xCol	,yLin+30,"CT - " + AllTrim(QRY->CT)  				 																  								,"N",cTpFonte,cFonte2)
		MSCBSAY(xCol+30,yLin+30,AllTrim(QRY->HORARIO)					 																	  								,"N",cTpFonte,cFonte2)
			
		MSCBEND()
		MSCBCLOSEPRINTER()
		MS_FLUSH()	
	QRY->(dbskip())
	Enddo
	MSCBEND()
	MSCBCLOSEPRINTER()
	MS_FLUSH()
	dbCloseArea()
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ VALIDPERG | ºAutor  ³SAMUEL MIRNDA    º Data ³  04/02/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±              Criar as Perguntas caso elas não exista.                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg()
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i,j
Local nTamSX1	:= Len(SX1->X1_GRUPO)
Local aHelp := {}
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("RESTR040",nTamSX1)

Aadd(aRegs,{cPerg,"01","Periodo De..............?","Periodo De..............?","Periodo De..............?","mv_cha","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Periodo Até.............?","Periodo Até.............?","Periodo Até.............?","mv_chb","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Funcionário De..........?","Funcionário De..........?","Funcionário De..........?","mv_chc","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","","",""})
Aadd(aRegs,{cPerg,"04","Funcionário Até.........?","Funcionário Até.........?","Funcionário Até.........?","mv_chd","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","","",""})
Aadd(aRegs,{cPerg,"05","Loja....................?","Loja....................?","Loja....................?","mv_che","N",01,0,1,"C","","mv_par05","Matriz","Matriz","Matriz","","","Filial","Filial","Filial","","","","","","","","","","","","","","","","","","","","","",""})

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

