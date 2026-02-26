#include "Protheus.ch"

//FÁBIO A. MICHELON - MICROTRUST - 20/09/2014
//OBJETIVO:	EXPORTA E ATUALIZA DADOS DA TABELA DE INTERFACE DO PROTHEUS PARA O NC-SYSTEMS

User Function ZWACAD()

Private	cCadastro	:= "OP's geradas p/ NC-MES"
Private cDelFunc 	:= ".F."
Private aRotina 	:= { {"Pesquisar","AxPesqui",0,1} , {"Visualizar","AxVisual",0,2}, {"Legenda","U_ZWACADLEG()", 0, 1} }
Private	aCores 		:= { {"ZWA_STATUS=='0'", 'BR_BRANCO'}, {"ZWA_STATUS=='1'",'BR_AZUL'} }
//
dbSelectArea("ZWA")
dbSetOrder(1)
mBrowse(6,1,22,75,"ZWA",,,,,,aCores)

Return
//
User Function ZWACADLEG()

Local aLegenda := 	{ {"BR_BRANCO", "Não Processado" }, {"BR_AZUL", "Processado" } }
BrwLegenda(cCadastro, "Legenda", aLegenda)

Return
