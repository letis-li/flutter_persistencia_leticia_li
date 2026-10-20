# Atividade de Flutter - Persistência

Nome: Leticia Li

Disciplina: Programação de Dispositivos Móveis

Atividade: Crie uma tela com um pequeno texto, um interruptor de tema e um
controle deslizante para ajustar o tamanho da fonte. Use o exemplo do tema
como ponto de partida.
Requisitos:
• Permitir tema claro ou escuro.
• Permitir tamanho de fonte entre 14 e 28, em passos de 2.
• Atualizar a prévia do texto quando os controles forem alterados.
• Ter um botão Salvar preferências. Neste exercício, apenas esse botão grava
as escolhas; os controles alteram a prévia em memória.
• Gravar o tema na chave 'leitura.temaEscuro', usando setBool().
• Gravar o tamanho na chave 'leitura.tamanhoFonte', usando setDouble().
• Recuperar os dois valores ao abrir, usando getBool() e getDouble().
• Usar tema claro e tamanho 18 quando ainda não houver valores salvos.
• Ter um botão Restaurar padrão que remova apenas essas duas chaves e
atualize a tela para os valores iniciais. Não apague outras preferências do
projeto.
