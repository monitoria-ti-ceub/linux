## **16. Shell**

O shell não é apenas para digitar comandos, ele é o programa que interpreta o que escrevemos e organiza o ambiente no qual esses comandos serão executados. No dia a dia, tratamos o shell e o terminal como se fossem a mesma coisa, mas eles cumprem papéis diferentes. O terminal é a interface textual, o shell é o interpretador.

O shell também é um ambiente. Ele guarda variáveis, conhece o diretório atual, sabe em quais diretórios procurar executáveis, entende operadores de redirecionamento, consegue substituir expressões, expandir padrões e combinar instruções. O shell não é apenas uma forma alternativa de usar o computador, ele é um ambiente programável de interação com o sistema.

Quando digitamos um comando como `ls`, não informamos o caminho completo até o executável. O shell consegue encontrar esse comando porque consulta os diret´rios listados em `PATH`. `PATH` informa ao shell onde ele deve procurar programas. É por isso que conseguimos executar vários comandos sem escrever algo como `usr/bin/ls` toda vez.

Muitos programas recebem entrada, produzem saída normal e também podem produzir mensagens de erro. Esses fluxos costumam ser chamados de `stdin`, `stdout`, `stderr`. Quando usamos operadores como `>`, `>>`, `|`, estamos redirecionando ou conectando esses fluxos. Em vez de criar ferramentas gigantes que fazem tudo, o sistema valoriza programas pequenos, especializados e combináveis.

Quando fazemos algo como `comando1 | comando2`, a saída do primeiro comando deixa de ir direto para a tela e passa a ser usada como entrada do segundo. Essa lógica permite construir operações mais sofisticadas sem precisar de uma ferramenta única que resolva tudo.

## **17. Ferramentas de Texto e Scripts**

O Linux dá importância ao texto. Não quer dizer que o sistema "gosta de terminal". Quer dizer que o texto ocupa um lugar central na forma como o sistema é configurado, documentado, automatizado e inspecionado. Arquivos de configuração costumam ser texto. Logs costumam ser texto. Scripts são texto. Saídas de comando, em grande parte, são texto. Até muitas interfaces do próprio sistema se apresentam ao usuário de forma textual.

Ferramentas como `cat`, `less`, `head`, `tail`, `grep`, `wc`, `sort`, `cut`, não são importantes só porque ajudam a "ver arquivos", elas ajudam o usuário a ler, filtrar, localizar, resumir e reorganizar informação.

- `cat`: mostra o conteúdo de um arquivo.
- `less`: permite navegar por um arquivo longo.
- `head`: mostra o começo de um arquivo.
- `tail`: mostra o final de um arquivo.
- `grep`: localiza padrões de texto
- `wc`: conta linhas, palavras e caracteres.
- `sort`: ordena partes de linhas estruturadas.
- `cut`: extrai partes de linhas estruturadas.

Um script é um arquivo de texto que contém uma sequência de instruções que podem ser executadas por um interpretador, como o Bash. Em vez de repetir manualmente uma série de comandos, o usuário pode registrá-los de uma vez. O script é um passo na direção da automação, da reprodutibilidade e da documentação de procedimentos.