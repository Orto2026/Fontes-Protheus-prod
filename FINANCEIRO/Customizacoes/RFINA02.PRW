#include "rwmake.ch"'
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RFATA24  บ Autor ณMauricio Pradoบ       Data ณ 03/02/2022  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Browse de consulta financeiro Exporta็ใo                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ORTOSINTESE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RFINA02()

cCadastro 	:= "Monitor NF Exportacao"
aRotina 		:= {{ "Pesquisa","AxPesqui", 0 , 1}}
aFixe			:= {;
					{"Natureza" 			,"E1_NATUREZ" 		} ,;
				 	{"Nr Titulo" 			,"E1_NUM" 			} ,;
					{"Parcela" 				,"E1_PARCELA" 		} ,;
					{"Dt Emissao" 			,"E1_EMISSAO" 		} ,;
				 	{"Vencimento" 			,"E1_VENCTO" 		} ,;
					{"Venc.Real" 			,"E1_VENCREA" 		} ,; 	
				 	{"Valor"				,"E1_VALOR"			} ,;
					{"Pedido"				,"E1_PEDIDO"		} ,;	
				 	{"Obs. Pedido" 			,"E1_XOBSPV "		} }



dbSelectArea("SE1")
dbSetOrder(1)

Set Filter to AllTrim(E1_NATUREZ) $ '5300' .And. Empty(E1_BAIXA) 

mBrowse(,,,,"SE1",aFixe,,,)

Set Filter to
Return
