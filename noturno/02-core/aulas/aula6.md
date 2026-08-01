20. Usuários, Grupos e Permissões

Linux foi projetado como um sistema multiusuário. A segurança e o isolamento entre os processos e os dados de diferentes usuários dependem de um sistema robusto de controle de acesso.

Linux não reconhece nomes de usuários, o kernel opera exclusivamente com números inteiros chamados UID (User ID) e GID (Group ID). A tradução entre nomes amigáveis e esses números é feita por arquivos de texto no diretório `/etc`.

O arquivo `/etc/passwd` armazenava todas as informações do usuário, incluindo a senha criptografada (hash). Como este arquivo precisa ser legível por todos os usuários (para que comandos como `ls -l` possam trauzir UIDs em nomes), os hashes das senhas ficavam expostos a ataques de força bruta.

Hierarquia:
1. `/etc/passwd`: Contém as informações públicas da conta. É legível por todos. Cada linha representa um usuário, com sete campos separados por dois ponto (`:`).

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