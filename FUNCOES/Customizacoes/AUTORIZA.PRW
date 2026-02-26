#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} fAutoriza
    (long_description)
    @type  Function
    @author user
    @since 10/01/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references) Private oDlg1, oOP, oLang, oQtde, oSair
    /*/


User Function fAutoriza()
/*
	Local lAutoriza := .F.
	Local nOpca     := 0


    PRIVATE cSenha,cCodigo
    
	cCodigo   := Space(6)
	cSenha    := Space(30)
	

	DEFINE MSDIALOG oDlgSenha TITLE "Autorização" From 001,001 to 125,300 Pixel STYLE DS_MODALFRAME

	oSaySenha := tSay():New(012,010,{|| "Usuário:"   },oDlgSenha,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
	oGetSenha := tGet():New(010,050,{|u| if(PCount()>0,cCodigo:=u,cCodigo)}, oDlgSenha,080,9,"@A",{ ||  },,,,,,.T.,,, { || .T. } ,,,,.F.,,,'cCodigo')

	oSaySenha := tSay():New(022,010,{|| "Digite a senha:"   },oDlgSenha,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
	oGetSenha := tGet():New(020,050,{|u| if(PCount()>0,cSenha:=u,cSenha)}, oDlgSenha,080,9,"@A",{ ||  },,,,,,.T.,,, { || .T. } ,,,,.F.,.T.,,'cSenha')

	oBtnOk := tButton():New(040,035,"Ok"  , oDlgSenha, {|| nOpca := 1, ::End() },40,12,,,,.T.,,,, { ||  },,)
	oBtnNo := tButton():New(040,080,"Cancelar"  , oDlgSenha, {|| ::End() },40,12,,,,.T.,,,, { ||  },,)

	ACTIVATE MSDIALOG oDlgSenha CENTERED
	
	If nOpca == 1
		dbSelectArea("Z99")
		Z99->(dbSetOrder(1))
		Z99->(dbGoTop())
		If SRA->(dbSeek(xFilial("Z99")+cCodigo))
			
			PswOrder(1)
			If PswSeek(SRA->RA_ZUSER)
				lAutoriza := PswName(cSenha)
			EndIf
		EndIf
	Endif

	If !lAutoriza .And. nOpca == 1
		MsgStop("Usuário e/ou senha inválidos!","SEM PERMISSÃO")
	EndIf
*/
Return lAutoriza

