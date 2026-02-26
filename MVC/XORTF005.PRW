#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "Totvs.ch"
#INCLUDE "TOPCONN.CH"  

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºRotina    ³ XORTF003   ºAuto ³Samuel Miranda     º Data ³ 26/11/2020   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDescricao ³ Função auxiliar para o preenchimento das informações       º±±
±±º            da Nota Fiscal                                             º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso       ³ Especifico Ortosintese                                     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function XORTF005()
    //Variavel
    Local _aArea      := GetArea()
    LOCAL aAreaSA4    := SA4->( GetArea() )
    Local _cNameUser  := ""
    Local cQuery      := "" 
    Local lRet        := .T.
    Local oModel      := FWModelActive()
    Local cCodCli     := oModel:GetValue( 'FORMZWN' , 'ZWN_CODCLI' )
    Local cNomeCli    := oModel:GetValue( 'FORMZWN' , 'ZWN_CLIENT' )
    Local cNotas      := oModel:GetValue( 'FORMZWN' , 'ZWN_NFS' )
    Local cTransp     := oModel:GetValue( 'FORMZWN' , 'ZWN_TRANSP' )
    Local cNchaves    := oModel:GetValue( 'FORMZWN' , 'ZWN_CHVS' )
    Local cQtdeNotas  := oModel:GetValue( 'FORMZWN' , 'ZWN_QTDENF' )
    Local dDatEmissao := ""
    Local _aItens     := {}

    aadd(_aItens, {cNotas, cNchaves})
    
   // Public  _cNFs     := _aItens
    Private cCodUser  := RetCodUsr()
    Private cNamUser  := UsrRetName(cCodUser) //Retorna o nome do us        
    _cNameUser        := cNamUser
    _nChave           := oModel:GetValue( 'FORMZWN' , 'ZWN_CHAVNF' )

    //Seleciona a tabela ZWN e verifica se a Nota ja foi Coletada
    dbSelectArea("ZWN")
    ZWN->(dbSetOrder(2))
    If ZWN->(dbSeek(xFilial("ZWN")+Alltrim(_nChave)))
        MsgAlert('<br>Nota já foi Lançada ID:<font color="#FF0000">' + ZWN_ID + '</b></font>', "Atenção")
        //Limpa o campo da chave da Nota Fiscal
        oModel:ClearField('FORMZWN','ZWN_CHAVNF')
        GETDREFRESH()
        DbClosearea()
        Return()
    Endif
    //Query SQL para coletar os dados da Nota Fiscal
    cQuery	:="SELECT "+CHR(13)+CHR(10)
    cQuery  +="SF2.F2_DOC AS NDOC,"+CHR(13)+CHR(10)
    cQuery  +="SF2.F2_CHVNFE AS NCHVNFE,"+CHR(13)+CHR(10)
    cQuery  +="SF2.F2_EMISSAO AS DTEMISSAO,"+CHR(13)+CHR(10)
    cQuery  +="SF2.F2_TRANSP AS CODTRANSP,"+CHR(13)+CHR(10)
    cQuery  +="SA1.A1_COD AS CODCLI,"+CHR(13)+CHR(10)
    cQuery  +="SA1.A1_NREDUZ AS NOMECLI"+CHR(13)+CHR(10)
    //cQuery  +="SA4.A4_NOME AS NTRANSP "+CHR(13)+CHR(10)
    cQuery 	+="FROM "+CHR(13)+CHR(10)
    cQuery 	+=RetSqlName("SF2")+" SF2 "+CHR(13)+CHR(10)
    cQuery 	+="INNER JOIN SA1010 SA1 ON SA1.A1_FILIAL =' ' AND SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA "+CHR(13)+CHR(10)
    //cQuery 	+="INNER JOIN SA4010 SA4 ON SA4.A4_FILIAL=' ' AND SA4.A4_COD = SF2.F2_TRANSP "+CHR(13)+CHR(10)
    cQuery 	+="WHERE  "+CHR(13)+CHR(10)
    cQuery 	+="SF2.F2_FILIAL ='01' AND "+CHR(13)+CHR(10)
    cQuery 	+="SF2.D_E_L_E_T_ =' ' AND "+CHR(13)+CHR(10)
    cQuery 	+="SF2.F2_CHVNFE = "+"'"+ Alltrim(_nChave)+"' "+CHR(13)+CHR(10)
    cQuery  := ChangeQuery(cQuery)
    //Grava o resultado da Query
   	MEMOWRIT( "XORT005.SQL", cQuery ) 
	//Executa a Query
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"QRY",.T.,.F. )	
    //Variavel 
    nRec	:= 0
    //Seleciona o Alias resultante da query e conta os registros.
	dbSelectArea( "QRY" )
	dbGotop()
	QRY->(dbEval({ ||nRec++},,{||!Eof()} ))
	dbGoTop()
	
	If nRec == 0
		dbSelectArea("QRY")
		dbCloseArea()
		Alert("Nota não encontrada." ,"Verifique !")
        Return lRet
	Else
        dbSelectArea( "QRY" )
        dbGotop()
        //Seta os valores nas variveis
        cCodCli     := QRY->CODCLI
        cNomeCli    := QRY->NOMECLI
        dDatEmissao := STOD(QRY->DTEMISSAO)
        cNotas      := QRY->NDOC 
        cNchaves    := QRY->NCHVNFE +"   | Data | "+DTOC(dDatEmissao)     
        IF !Empty(QRY->CODTRANSP)
            cTransp := Posicione("SA4",1,xFilial("SA4")+QRY->CODTRANSP,"SA4->A4_NOME")
        Else
            Alert("Transportadora em branco na Nota Fiscal" ,"Verifique !")
        EndIf
        cNameUser   := UPPER(_cNameUser)
        //Seta a variavel cQtdeNotas
        If Empty(cQtdeNotas)  
            cQtdeNotas := 1
        EndIf      
        //Salta pro proximo registro
        QRY->(DbClosearea()) 
    EndIf
    //Seta os valores nos campos do Forme
    oModel:SetValue('FORMZWN','ZWN_CODCLI',cCodCli)
    oModel:SetValue('FORMZWN','ZWN_CLIENT',cNomeCli)
    oModel:SetValue('FORMZWN','ZWN_NFS',cNotas )
    oModel:SetValue('FORMZWN','ZWN_TRANSP',cTransp)
    oModel:SetValue('FORMZWN','ZWN_USER',cNameUser)
    oModel:SetValue('FORMZWN','ZWN_DATA',dDatEmissao)
    oModel:SetValue('FORMZWN','ZWN_CHVS',cNchaves)
    oModel:SetValue('FORMZWN','ZWN_QTDENF',Alltrim(CVALTOCHAR(cQtdeNotas)))
    //Seta os valores nos campos com o resultado do Array _aItens
    If !Empty(_aItens[1,1])
        cQtdeNotas  := Val((oModel:GetValue('FORMZWN','ZWN_QTDENF'))) +1
        oModel:SetValue('FORMZWN','ZWN_NFS',Alltrim(cNotas) +" / "+Alltrim(_aItens[1,1]))
        oModel:SetValue('FORMZWN','ZWN_CHVS',cNchaves + CRLF +_aItens[1,2] )
        oModel:SetValue('FORMZWN','ZWN_QTDENF',Alltrim(CVALTOCHAR(cQtdeNotas)))
    EndIf
    RestArea(_aArea)
    RestArea(aAreaSA4)
Return lRet
