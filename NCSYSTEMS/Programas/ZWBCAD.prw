#include "Protheus.ch"

//FÁBIO A. MICHELON - MICROTRUST
//OBJETIVO:	EXPORTA E ATUALIZA DADOS DA TABELA DE INTERFACE DO PROTHEUS PARA O NC-SYSTEMS

User Function ZWBCAD()

Private	cCadastro	:= "Apontamentos gerado pelo NC-MES"
Private cDelFunc 	:= "IIF(ZWB->ZWB_STATUS=='0', .T., .F.)"
//Private	aCores 		:= { {"(ZWB_STATUS=='0').and.(ZWB_ERRO<>'S')", 'BR_BRANCO'}, {"(ZWB_STATUS=='0').and.(ZWB_ERRO=='S')", 'BR_VERMELHO'}, {"ZWB_STATUS=='1'",'BR_AZUL'} }
Private	aCores 		:= { {"(ZWB_STATUS=='0').and.(ZWB_ERRO<>'S')", 'BR_BRANCO'}, {"(ZWB_ERRO=='S')", 'BR_VERMELHO'}, {"ZWB_STATUS=='1'",'BR_AZUL'} }
Private aRotina 	:= { {"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Gerar Apontamentos","u_NUMXMP1()",0,3},;
{"Incluir","AxInclui",0,3},;
{"Alterar","AxAltera",0,4},;
{"Excluir","AxDeleta",0,5},;
{"Resumo da Ordem","U_ZWBCADRES(ZWB->ZWB_FILIAL, ZWB->ZWB_OP, ZWB->ZWB_OPER)",0,2},;
{"Rel.Diverg.","U_ZWBDIV()",0,2},;
{"Legenda","U_ZWBCADLEG()", 0, 1} }
//
dbSelectArea("ZWB")
dbSetOrder(1)
mBrowse(6,1,22,75,"ZWB",,,,,,aCores)

Return
//
User Function ZWBCADLEG()

Local aLegenda := 	{ {"BR_BRANCO", "Não Processado" }, {"BR_VERMELHO", "Processado c/ Erro" }, {"BR_AZUL", "Processado c/ Sucesso" } }
BrwLegenda(cCadastro, "Legenda", aLegenda)

Return
//