User Function MT120ISC() 


Local nPTipo    := aScan(aHeader,{|x| AllTrim(x[2])=="C7_XLOTEOF"}) 

//...Código desenvolvido pelo usuario para carregar campos do usuario da SC para o PC 
If nTipoPed ==1 //Variavel que contem o tipo do pedido(1=Sc 2= Contrato de parceria) 
     aCols[n][nPTipo]   := SC1->C1_XLOTEOF 
EndIf       

Return 