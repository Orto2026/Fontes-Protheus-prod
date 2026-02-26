
/*/{Protheus.doc} MTDTLOT
//TODO Ponto de Entrada para alteração na condição de bloqueio de lotes na rotina PROCLOTE
@author Pirolo
@since 09/05/2019
@version undefined
@return return, return_description
@see http://tdn.totvs.com/pages/releaseview.action?pageId=6087831
/*/
User Function MTDTLOT()
Local  cRet := ""

cRet := ParamIxb +" .AND. B8_LOCAL $ '"+SuperGetMV("ES_LOCPRCL", .F., "01")+"' "

Return cRet
