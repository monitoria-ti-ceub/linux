# Atividade Prática

## Orientações

- Execute os comandos com atenção.
- Leia o resultado de cada comando antes de continuar.

## Tarefa I

Crie uma pasta chamada "oficina-linux" na sua pasta pessoal, com três subpastas:
- "anotações"
- "scripts"
- "testes"

1. Entre na pasta "oficina-linux"
2. Liste o conteúdo dela
3. Descubra em que diretório você está

Comandos:
- mkdir
- cd
- ls
- pwd

Responda:
- O que `mkdir` faz?
- O que a opção `-p` faz?
- O que as chaves `{}` fazem no mkdir?
- O que `pwd` mostra?

## Tarefa II

Dentro da pasta `anotações`, crie os arquivos:
- `aula.txt`
- `duvidas.txt`
- `comandos.txt`

1. Escreva uma frase dentro de aula.txt
2. Mostre o conteúdo do arquivo no terminal
3. Copie `aula.txt` para a pasta `testes`
4. renomeia a copia para copia aula 1

Comandos:
- echo
- cat
- cp
- mv

Responda:
- Qual é a diferença entre `touch`, `echo`, `cp`, e `mv`?
- O que `>` faz?
- O que aconteceu com o arquivo copiado?

## Tarefa III

Acesse a pasta `scripts` e:
1. Liste o conteúdo da pasta `anotações` usando caminho relativo
2. Mostre o conteúdo de `aula1.txt` usando caminho relativo
3. Mostre o mesmo conteúdo usando caminho absoluto

Comandos:
- cd
- ls
- cat

Responda:
- Qual é a diferença entre caminho absoluto e relativo?
- O que `..` significa?
- Por que `/home/...` e `home/...` não são a mesma coisa?

## Tarefa IV

Crie um arquivo chamado `saudacao.sh` dentro da pasta `scripts`.

Conteúdo do script:
```bash
#!/bin/bash
echo "olá!"
echo "usuário atual: $(whoami)"
echo "diretório atual: $(pwd)"
echo "data e hora: $(date)"
```

1. Salve o arquivo
2. Tente executá-lo
3. Observe o que acontece
4. Dê permissão de execução
5. Execute novamente

Comandos:
- chmod +x

Responda:
- O que é um script?
- Para que serve a linha `#!/bin/bash`?
- Por que o script não executa sem permissão adequada?
- O que `chmod +x` faz?

## Tarefa V

1. Descubra qual é seu usuário atual
2. Veja os grupos dos quais você faz parte
3. Liste as permissões do script criado
4. Crie um arquivo chamado `segredo.txt`
5. Dê permissão do arquivo apenas para o dono

Comandos:
- whoami
- id
- groups
- ls -l
- touch
- chmod 600
- ls -l

Responda:
- O que significa `600`?
- Quem pode ler ou alterar esse arquivo agora?
- Qual é a diferença entre permissões de leitura, escrita e execução?

## Tarefa VI

Tente listar o conteúdo do diretório `/root` sem `sudo` e depois com `sudo`.

Comandos:
- ls
- sudo ls

Responda:
- O que aconteceu sem `sudo`?
- O que mudou com `sudo`?
- O `sudo` te transforma em root permanentemente?

## Tarefa VII

1. Inicie um processo simples com `sleep`
2. Encontre esse processo
3. Encerre o processo

Comandos:
- sleep 300
- ps aux | grep sleep
- kill

Responda:
- O que é um processo?
- Qual é a diferença entre programa e processo?
- O que o comando `kill` faz?

## Tarefa VIII

1. Atualize a lista de pacotes
2. Pesquise o pacote `tree`
3. Instale o `tree`
4. Use o `tree` para mostrar a estrutura da pasta `oficina-linux`

Comandos:
- sudo apt update
- apt search tree
- sudo apt install tree
- tree

Responda:
- O que é um gerenciador de pacotes?
- O que é um pacote?
- O que `apt update` faz?
- O que `tree` mostrou sobre sua estrutura de diretórios?

## Tarefa IX

Crie um script chamado "hello.sh" dentro da pasta "scripts".

Conteúdo:
```bash
#!/usr/bin/env bash

echo "ooiiii"
echo "user: $(whoami)"
echo "directory: $(pwd)"
echo "date: $(date)"
```

1. Salve o arquivo
2. Dê permissão de execução
3. Execute o script

Comandos:
- chmod +x
- ./hello.sh

## Tarefa X

Crie um script chamado "variaveis.sh".

1. Crie uma variável chamada "nome"
2. Atribua seu nome a ela
3. Crie outra variável com a data atual
4. Imprima uma frase usando essas variáveis

Comandos:
- echo
- date

## Tarefa XI

Crie um script chamada "entrada.sh"

1. Peça ao usuário para digitar o nome
2. Peça a idade
3. Mostre uma mensagem com essas informações

Comandos:
- read
- echo

# Tarefa XII

Crie um script chamado "argumentos.sh"

1. Faça o script receber um nome como argumento
2. Mostre uma saudação usando esses nome

## Tarefa XIII

Crie um script chamado "condicao.sh"

1. Verifique se o usuário atual é "root"
2. Mostre uma mensagem diferente para cada caso

Comandos:
- whoami
- if

## Tarefa XIV

Crie um script chamado arquivos.sh

1. Receba o nome de um arquivo como argumento
2. Verifique se o arquivo existe. Caso sim, ele pode ser lido?
3. Mostre mensagens apropriadas

Comandos:
- if
- test(-f, -r)

## Tarefa XV

Crie um script chamado "loop.sh"

1. Liste todos os arquivos ".txt" da pasta "anotacoes"
2. Mostre o nome de cada um

Comandos:
- for
- ls

## Tarefa XVI

Modifique o script anterior para:
- Contar quantos arquivos ".txt" existem
- Mostrar o total ao final

## Tarefa XVII

Crie um script chamado "backup.sh"

1. Crie uma pasta chamada "backup-<data>"
2. Copie todos os ".txt" para essa pasta

Comandos:
- mkdir
- cp
- date

## Tarefa XVIII

Crie um script chamado "erro.sh"

1. Tente copiar um arquivo que não existe
2. Verifique se o comando funcionou
3. Mostre mensagem de sucesso ou erro

Comandos:
- cp
- echo $/w

## Tarefa XIX

Crie um script chamado "relatorio.sh"

O script deve:

1. Mostrar:
    - Usuário atual
    - Diretório atual
    - Data
    - Quantidade de arquivos na pasta atual

2. Salvar tudo em um arquivo chamado "relatorio.txt"

Comandos:
- whoami
- pwd
- date
- ls


## Tarefa XX [DESAFIO]

Crie um gerenciador de tarefas no terminal chamado "todo.sh"

Desenvolva um script que permita adicionar, listar, concluir e remover tarefas usando o terminal.

O script deve funcionar com os seguintes comandos:

1. Adicionar uma tarefa:
    - ./todo.sh add "estudar linux"

2. Listar tarefas:
    - ./todo.sh list

3. Marcar tarefa como concluída:
    - ./todo.sh done 1

4. Remover uma tarefa:
    - ./todo.sh remove 1

Regras:
- As tarefas devem ser armazenadas em um arquivo `todo.txt`
- Cada tarefa deve ter um número identificador
- Tarefas concluídas devem ser exibidas de forma diferente
- O script deve funcionar mesmo após ser fechado
- Tratar erros básicos
    - tarefa inexistente
    - argumentos ausentes
    - comandos inválidos

Dicas:
- Use "$1", "$2", etc. para capturar argumentos
- Use "case" ou "if" para decidir o comportamento do script
- Use "echo" e redirecionamento (`>>`) para salvar tarefas
- Use `cat`, `nl` ou `awk` para listar tarefas com número
- Use loops para percorrer o arquivo
- Use `sed` ou manipulação de texto para editar/remover linhas