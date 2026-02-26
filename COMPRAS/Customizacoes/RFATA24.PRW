#include "rwmake.ch"'
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RFATA24  บ Autor ณMauricio Prado		  บ Data ณ 14/11/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Browse consulta itens de nota fiscal		                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ortosintese                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RFATA24()

cCadastro 	:= "Consulta Recebimento"
aRotina 		:= {{ "Pesquisa","AxPesqui", 0 , 1}}
aFixe			:= {;
				 	{"Codigo" 			,"D1_COD" 		} ,;
				 	{"Descricao" 			,"D1_XDESC" 		} ,;
				 	{"Nota"      	 		,"D1_DOC" 	} ,;
				 	{"Dt Entrada"			,"D1_DTDIGIT" 	} ,;
				 	{"Fornecedor"		,"D1_FORNECE"	} ,;
				 	{"Loja" 			,"D1_LOJA"		} ,;
				  	{"Pedido"     ,"D1_PEDIDO"  		} ,;
				 	{"Qtd"	,"D1_QUANT"		} }
				 	

dbSelectArea("SD1")
dbSetOrder(2)

Set Filter to AllTrim(D1_CF) $ '1101/2101/3101/3127' 

mBrowse(,,,,"SD1",aFixe,,,)

Set Filter to
Return