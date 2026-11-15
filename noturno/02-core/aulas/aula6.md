# 20. Usuários, Grupos e Permissões

Linux foi projetado como um sistema multiusuário. A segurança e o isolamento entre os processos e os dados de diferentes usuários dependem de um sistema robusto de controle de acesso.

## O Banco de Dados de Identidades

Linux não reconhece nomes de usuários, o kernel opera exclusivamente com números inteiros chamados UID (User ID) e GID (Group ID). A tradução entre nomes amigáveis e esses números é feita por arquivos de texto no diretório `/etc`.

O arquivo `/etc/passwd` armazenava todas as informações do usuário, incluindo a senha criptografada (hash). Como este arquivo precisa ser legível por todos os usuários (para que comandos como `ls -l` possam trauzir UIDs em nomes), os hashes das senhas ficavam expostos a ataques de força bruta.

Hierarquia:
1. `/etc/passwd`: Contém as informações públicas da conta. É legível por todos. Cada linha representa um usuário, com sete campos separados por dois pontos (`:`).

`jess:x:1001:1001:Jess Forster:/home/jess:/bin/bash`

jess: Nome de login
x: Indica que a senha está no `/etc/shadow`
1001: UID. O root é sempre 0. Usuários de sistema (daemons) costumam ter UIDs menores que 1000. Usuários comuns começam em 1000.
1001: GID
Jess Forster: Campo GECOS (informações adicionais, nome completo).
/home/jess: Diretório pessoal (home)
/bin/bash: Shell padrão executado no login. (Se for `/sbin/nologin` ou `/bin/false`, o usuário não pode fazer login interativo, comum para serviços).

2. `/etc/shadow`: Contém os hashes das senhas e informações sobre expiração. É legível pelo `root` e pelo grupo `shadow`

`jess:$6$xyz...hash...:19000:0:99999:7:::`

O segundo campo contém o hash da senha (geralmente, SHA-512)

Os grupos organizam permissões coletivas.

1. `/etc/group`: Lista os grupos do sistema, seus GIDs e os usuários que pertencem a eles (como grupos secundários).
2. `/etc/shadow`: Armazena senhas de grupos (pouco usado) e administradores de grupos.

### Gerenciamento de Contas

- `useradd`: Cria um novo usuário (adiciona entradas em passwd, shadow e group. Como opção, pode criar o diretório home com base no esqueleto em `/etc/skel`).
- `usermod`: Modifica propriedades de um usuário.
- `userdel`: Remove um usuário.
- `groupadd`/`groupmod`/`groupdel`: Comandos para gerenciamento de grupos.

## Permissões

Cada arquivos e diretório no Linux tem um UID (proprietário), um GID (grupo proprietário) e um conjunto de permissões (modo) de 9 bits.

O comando `ls -l` exibe essas informações:

> to-do: add command output from linux (i'm on windows ugh)

## Permissões Únicas (Bits Avançados)

Além dos 9 bits, há 3 bits especiais que alteram o comportamento do sistema. Eles são representados por um quarto dígito octal à esquerda.

### SetUID (SUID) / Octal 4000

Quando o bit SUID é ativado em um arquivo executável, o programa roda com os privilégios do proprietário do arquivo, não do usuário que executou. É crucial para comandos como `passwd` ou `sudo`. O executável `/usr/bin/passwd` pertence ao `root` e tem o bit SUID ativo. Quando o usuário executa `passwd` para mudar a sua senha, o processo roda como `root` (temporário), permitindo que ele modifique o arquivo `/etc/shadow`.

### SetGID (SGID) / Octal 2000

### Sticky Bit

Aplicado, no geral, em diretórios. Quando ativado, apenas o proprietário do arquivo (ou o root) pode deletar ou renomear arquivos dentro do diretório, mesmo que o diretório tenha permissões de escrita (`w`) para todos (`777`).
Um exemplo é `/tmp`. Ele tem permissões `drwxrwxrwt` (1777). Qualquer usuário pode criar arquivos no `/tmp` mas o usuário `jess` não pode apagar os arquivos temporários criados pelo `caramez`.