User Function MTA010NC()    

// Descrição: Relaciona campos que não devem ser copiados na inclusão
// Localização: Function A010LEREG - Função chamada na inclusão do Produto, quando ativado o botão cópia.
// Em que ponto: No início da Função, antes do processamento dos campos a serem copiados, deve ser utilizado para relacionar os campos que NÃO DEVEM SER COPIADOS na inclusão...
// (acionando o botão CÓPIA), através do retorno de um array contendo a lista dos campos que não devem ser copiados do produto posicionado.
// https://tdn.totvs.com/pages/releaseview.action?pageId=6087788

Local aCpoNC := {}

AAdd( aCpoNC, 'B1_EMIN'     )
AAdd( aCpoNC, 'B1_ESTSEG'   )
AAdd( aCpoNC, 'B1_LE'       )
AAdd( aCpoNC, 'B1_LM'       )
AAdd( aCpoNC, 'B1_EMAX'     )  
AAdd( aCpoNC, 'B1_XMIN'     )
AAdd( aCpoNC, 'B1_XEF'      )        
AAdd( aCpoNC, 'B1_XRESP'    )
AAdd( aCpoNC, 'B1_PE'       )
AAdd( aCpoNC, 'B1_CODBAR'   )
AAdd( aCpoNC, 'B1_LOTECTL'  )
AAdd( aCpoNC, 'B1_LOCALIZ'  )
AAdd( aCpoNC, 'B1_XANVEMP'  )
AAdd( aCpoNC, 'B1_XANVISA'  )

Return (aCpoNC)
