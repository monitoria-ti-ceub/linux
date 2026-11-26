# Nano vs Vim

Eu não tenho muita experiência com o nano para compará-lo com o Vim. Mas ele parece ser mais simples para um iniciante utilizando o editor de texto pela primeira vez, pelo menos foi assim que eu me senti quando eu usei pela primeira vez.
Quanto ao Vim, eu uso o hx editor que usa os mesmo atalhos do Vim, o que posso dizer que é que pra quem gosta de navegar o desktop apenas com teclado é uma ótima experiência.

## Atalhos do Vim
Os atalhos mais usados são "i" para inserir antes da seleção e "a" depois da seleção. O "I" insere no começo da linha em que há uma seleção e o "A" no fim da linha.
O "b" e "e" se movem de para a primeira e última letra de um certo grupo de símbolos ou letras, respectivamente. Já o "B" e o "E" servem para ir a primeira letra de uma palavra e a a última letra de uma palavra, a diferença que ele conta para ir para a próxima palavra apenas " ".
O "w" e o "W" funcionam de maneira similar mas n se prende a última letra mas a palavra em si ele sempre pega o último espaço depois da palavra selecionada caso seja um espaço.
O "c" apaga a seleção e entra no modo de seleção e o "C" maiúsculo cria um segundo cursor na próxima linha que tem algo escrito abaixo do que você possui selecionado para remover esse outro curso basta apertar ","
O "y" para copiar a seleção. O " y" para copiar o que está selecionado para o clipboard do sistema.
O "p" para colocar.
O "x" para selecionar a linha inteira. O "%" para selecionar o arquivo inteiro.
O "d" para deletar e copiar o deletado.
O "o" para criar uma linha logo abaixo da seleção e o "O" para criar uma linha logo acima.

Em modo default :w para salvar, :wq para salvar e fechar, :q! para fechar independente de alterações, :open para navegar no diretório atual, /search para procurar por algo no texto, enter para confirmar a escolha e "n" para a próxima aparição e "N" para a anterior 

Aqui estão alguns que eu uso diariamente


## comando sed para atualizar palavra na quinta linha
sed '5s/Se/SE/' config.sh

# Perguntas

## Qual editor é melhor para editar configs do sistema?
Eu uso o vim pelas razões explicitadas acima

## Como usar vim em modo não-interativo (via sed)?
sed "s/old/new/g" file.txt > new.txt

## Por que visudo é importante?
Porque ele evita que você salve um arquivo com erros, quando você salva ele verifica se tem algo de errado e gera um prompt perguntando se você quer retornar ao editor de texto ou não. É ótimo para edição de arquivos críticos que pontencialmente podem borkar o sistema caso sejam editadas incorretamente.
