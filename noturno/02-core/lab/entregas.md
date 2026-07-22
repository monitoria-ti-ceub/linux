# Entrega | Ciclo II

## Orientações

- Execute tudo no terminal
- Leia a saída de cada comando
- Teste variações
- Use `man` ou `--help` quando necessário

## Atividade I | Processamento de Texto com `grep`

Crie um script que:

1. Crie um arquivo "dados.txt" com 20 linhas de dados (nomes, idades, e-mails)
2. Use `grep` para:
    - Encontrar todas as linhas com "gmail.com"
    - Encontrar linhas que não contêm números
    - Contar quantas linhas contêm a letra "a"
    - Encontrar linhas que começam com "A"
3. Salve os resultados em arquivos separados

Comandos:
- `grep`
- `grep -v`
- `grep -c`
- `grep ^`
- `echo`
- `>`

Perguntas:
- Qual é a diferença entre `grep "padrão"` e `grep -E "padrão"`?
- Como usar regex para encontrar e-mails?
- O que `grep -i` faz?

## Atividade II | Processamento com `sed`

Crie um script que:

1. Crie um arquivo "config.txt" com configurações (ex: SERVIDOR=localhost)
2. Use `sed` para:
    - Substituir "localhost" por "192.168.1.1"
    - Deletar linhas que começam com "#"
    - Mostrar apenas linhas 5-10
    - Adicionar um prefixo em cada linha
3. Mostre o resultado sem modificar o arquivo original

Comandos:
- `sed`
- `sed 's/old/new/g'`
- `sed '/^#/d'`
- `sed -n '5,10p'`

Perguntas:
- Por que usar `sed` em vez de editar o arquivo manualmente?
- Qual é a diferença entre `sed 's/old/new/'` e `sed 's/old/new/g'`?
- Como usar `sed` para fazer backup antes de modificar?

## Atividade III | Processamento com `awk`

Crie um script que:

1. Crie um arquivo "vendas.txt" com dados estruturados:
    produto:preco:quantidade
    notebook:3000:5
    mouse:50:20
    teclado:150:10
2. Use `awk` para:
    - Mostrar apenas produtos com preço > 100
    - Calcular o total (preço * quantidade) para cada linha
    - Somar o total geral
    - Contar quantos produtos existem

Comandos:
- `awk -F:`
- `awk '{print $1}'`
- `awk '{sum += $2} END {print sum}'`

Perguntas:
- Por que usar `awk` em vez de `cut` ou `grep`?
- Como usar `awk` para processar arquivos CSV?
- Qual é a diferença entre `awk` e `sed`?

## Atividade IV | Pipes e Redirecionamento

Crie um script que:

1. Processe um arquivo de log (crie um arquivo de log simulado)
2. Use pipes para:
    - Encontrar linhas com "ERROR"
    - Contar quantas vezes cada tipo de erro aparece
    - Mostrar os 5 erros mais frequentes
    - Salvar um relatório em "relatorio_erros.txt"

Comandos:
- `cat`
- `grep`
- `cut`
- `sort`
- `uniq`
- `head`
- `tail`
- `wc`

Perguntas:
- Como o kernel gerencia o buffer entre pipes?
- Por que `sort|uniq` é mais eficiente que `uniq`?
- Como redirecionar stderr e stdout para arquivos diferentes?

## Atividade V | Editando com nano e vim

1. Crie um arquivo "config.sh" usando nano
    - Adicione comentários explicando cada linha
    - Salve e saia
2. Abra o arquivo em vim
    - Navegue até a linha 5
    - Substitua uma palavra
    - Salve e saia
3. Use `sed` para fazer a mesma substituição
4. Documente em "editor_exercicios.md":
    - Diferenças entre nano e vim
    - Quando usar cada um
    - Atalhos mais úteis

Perguntas:
- Qual editor é melhor para editar configs do sistema?
- Como usar vim em modo não-interativo (via `sed`)?
- Por que `visudo` é importante?

## Atividade VI | Gerenciando Usuários e Permissões

Crie um script que:

1. Crie 3 usuários de teste (pode usar um container/VM)
2. Crie 3 grupos
3. Adicione usuários aos grupos
4. Crie arquivos com diferentes permissões:
    - 644 (rw-r--r--)
    - 755 (rwxr-xr-x)
    - 600 (rw-------)
    - 700 (rwx------)
5. Teste acesso com cada usuário
6. Documente o que cada permissão significa

Comandos:
- `useradd`
- `groupadd`
- `usermod`
- `chmod`
- `chown`
- `chgrp`
- `ls -l`

Perguntas:
- Qual é a diferença entre permissões de arquivo e permissões de diretório?
- O que é setuid, setgid e sticky bit?
- Como o umask afeta as permissões padrão?
- Por que não usar 777 em produção?

## Atividade VII | Análise de Segurança

Crie um script que:

1. Encontre todos os arquivos com permissão 777 no /home
2. Encontre todos os arquivos com setuid ativo
3. Encontre todos os usuários com UID 0 (root)
4. Gere um relatório de segurança

Comandos:
- `find`
- `find -perm`
- `ls -l`
- `grep`
- `awk`

## Atividade VIII | Trabalhando com Filesystems

Crie um script que:

1. Liste todos os filesystems montados
2. Mostre o uso de disco de cada um
3. Crie um arquivo de imagem (arquivo que funciona como disco)
4. Formate como ext4
5. Monte em um diretório
6. Copie arquivos para ele
7. Desmonte

Comandos:
- `mount`
- `umount`
- `df`
- `du`
- `dd`
- `mkfs`
- `losetup`
- `/etc/fstab`

Perguntas:
- Qual é a diferença entre ext4, btrfs e xfs?
- Como funciona um loop device?
- O que é /etc/fstab e por que é importante?

## Atividade IX | Sistema de Gerenciamento de Arquivos

Crie um sistema de gerenciamento de arquivos que:

1. Permite criar, listar, buscar e deletar arquivos
2. Gerencia permissões e proprietários
3. Processa logs de operações
4. Gera relatórios
5. Tem tratamento de erros robusto
6. Usa funções e modularização

Requisitos:
- Mínimo de 500 linhas de código
- Documentação completa
- Exemplo de uso
- Testes automatizados
