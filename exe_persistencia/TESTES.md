## TESTES ##

Teste 1. Escolher tema escuro e fonte 24, salvar, reabrir e conferir as duas
escolhas: Depois de recarregar a página, a interface permanece com o tema escuro e fonte 24.

Teste 2. Alterar apenas a prévia para fonte 28 sem salvar, reabrir e conferir que o
tamanho salvo continua sendo 24: Depois de recarregar a página, a interface descarta a alteração não salva de fonte 28. Permanece fonte 24.

Teste 3. Restaurar o padrão, reabrir e conferir tema claro e fonte 18: Depois de recarregar a página, a interface reestabelece o padrão com o tema claro e fonte 18.

## EXPLICAÇÃO ##

Alterar a prévia modifica o tema e o tamanho da fonte apenas na memória, atualizando a tela com setState(). 
Salvar grava essas escolhas nas chaves leitura.temaEscuro e leitura.tamanhoFonte, permitindo recuperá-las ao reabrir o aplicativo. 
Remover uma preferência apaga o valor salvo da chave correspondente. 
Ao restaurar o padrão, as duas chaves são removidas e o aplicativo volta ao tema claro e à fonte 18.