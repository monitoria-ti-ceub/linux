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