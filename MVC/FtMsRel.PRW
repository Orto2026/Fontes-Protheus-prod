#Include "TOTVS.ch"

/*---------------------------------------------------------------------*
 | Func:  FtMsRel                                                      |
 | Autor: Samuel Miranda                                               |
 | Data:  31 /05/2023                                                  |
 | Desc:  Ponto de entrada para vincular o inidice                     |
 | de uma tabela customizada                                           |
 *---------------------------------------------------------------------*/
User Function FtMsRel()
//Declaração das variaveis 
Local aRet    As Array
Local aChave  As Array
Local bMostra As Block
Local cTabela As Character
Local aFields As Array
 
//Array
aRet := {}
// Tabela do usuario
cTabela := 'ZWN'
// Campos que compoe a chave na ordem. Nao  passar filial (automatico)
aChave  := { 'ZWN_FILIAL','ZWN_ID'} //ZWN_FILIAL+ZWN_ID 
// Bloco de codigo a ser exibido
bMostra := { ||ZWN->ZWN_FILIAL+ ZWN->ZWN_ID}       
//Array com os campos que identificam os campos utilizados na descrição
aFields := {'ZWN_FILIAL','ZWN_ID'}                                
// funcoes do sistema para identificar o registro
AAdd(aRet,{cTabela,aChave,bMostra,aFields})
 

Return aRet
