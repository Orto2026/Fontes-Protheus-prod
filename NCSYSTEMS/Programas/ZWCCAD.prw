#include "Protheus.ch"

//FÁBIO A. MICHELON - MICROTRUST
//OBJETIVO:	EXPORTA E ATUALIZA DADOS DA TABELA DE INTERFACE DO PROTHEUS PARA O NC-SYSTEMS

User Function ZWCCAD()

Private	cCadastro	:= "Eventos gerado pelo NC-MES"
Private 	cDelFunc 	:= ".T."
Private	aCores 	:= {}
Private aRotina 	:= { {"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2}}
//
dbSelectArea("ZWC")
dbSetOrder(1)
mBrowse(6,1,22,75,"ZWC",,,,,,aCores)

Return
//