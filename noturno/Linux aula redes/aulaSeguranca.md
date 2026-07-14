# Segurança do sistema

Construir um sistema Linux From Scratch garante controle absoluto, mas também significa que o sistema não possui as redes de segurança pré-configuradas encontradas em sistemas operacionais comuns. A segurança no LFS é uma arquitetura que você deve erguer bloco por bloco.

Para garantir a segurança de nosso sistema e de nossos arquivos, existem algumas medidas que podemos tomar

## 1. Desabilitar o Login de Root (SSH)

O usuário root é o alvo principal de ataques automatizados de força bruta na internet. Permitir que esse usuário faça login diretamente pela rede é uma vulnerabilidade crítica, pois metade do trabalho de um invasor (descobrir o nome de usuário) já está feita.

Acesse o arquivo de configuração do daemon do SSH em `/etc/ssh/sshd_config` e faça as seguintes alterações:

- Bloqueio de Root: Altere a linha `PermitRootLogin` para `no`. Isso força qualquer administrador a logar como um usuário comum (sem privilégios) e, em seguida, elevar seus privilégios usando `su` ou `sudo`. Isso cria um log de acessos, basicamente, você sabe quem virou root, deixando possível o accountability em um sistema com multiplos usuários.
- Desativar Senhas: Opcional, mas recomendado. Se você já configurou chaves criptográficas (`ssh-keygen`), altere `PasswordAuthentication no`. Isso torna o seu servidor imune a ataques de força bruta baseados em dicionário.

Após as alterações, utilize o comando do systemctl (Lembrando que o systemctl nos permite controlar os serviços do systemd): `systemctl restart sshd`.

## 2. Estabelecer Permissões de Arquivo Apropriadas

No LFS, se você cometer um erro ao empacotar ou instalar um software, pode acabar deixando arquivos sensíveis legíveis para qualquer usuário do sistema. O princípio básico aqui é o do **Menor Privilégio**.

- Princípio do Menor Privilégio: é um conceito que determina que usuários, contas, sistemas e aplicativos recebam apenas as permissões mínimas essenciais para realizar suas tarefas, e nada mais.

Lembremos da notação numérica do chmod:

- **Read = 4**
- **Write = 2**
- **Execute = 1**

Escrevemos 3 dígitos ao executar o comando chmod, a posição de cada dígito representa as permissões de RWX de uma entidade específica:

- **Centena = Usuário**
- **Dezena = Grupo**
- **Unidade = Outros**

**Arquivos Críticos:**

- `/etc/shadow`: Contém os hashes das senhas. Deve ter permissão absoluta apenas para o root. Execute `chmod 600 /etc/shadow` (ou `chmod 000` se o seu sistema for configurado para ler esse arquivo através de um grupo específico, como o `shadow`).
- `/etc/passwd`: Deve ser legível por todos, mas gravável apenas pelo root: `chmod 644 /etc/passwd`.
- Diretórios Home: Por padrão, muitos sistemas criam diretórios de usuário com permissão `755`. Mude isso para `700` (`chmod 700 /home/usuario`), garantindo privacidade estrita entre usuários.

**Controle Global (Umask):**
O `umask` define a permissão padrão com a qual novos arquivos são criados. Edite o `/etc/profile` e altere o umask padrão de `022` para `027` ou `077`. Isso garante que qualquer novo arquivo criado não seja legível ou acessível por usuários que não sejam o dono (e possivelmente o grupo).

## 3. Controle de SUID / SGID

Os bits SUID (Set-User-ID) e SGID (Set-Group-ID) permitem que um programa seja executado com os privilégios do "dono" do arquivo (geralmente o root) ou do grupo, e não com os privilégios de quem executou o comando. Ferramentas como o `passwd` ou `sudo` precisam disso para funcionar, mas binários vulneráveis com SUID são a principal porta de escalonamento de privilégios.

**Como mitigar:**
Você deve mapear regularmente todos os arquivos com esses bits ativados no seu sistema usando o comando:

`find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -l {} \;`

- **Tradução do comando**: Comece na raiz do sistema (`/`), encontre apenas arquivos (`-type f`) que tenham o bit SUID ativo (`-perm -4000`) OU o bit SGID ativo (`-perm -2000`), e para cada arquivo que você achar, rode um `ls` `-l` nele para me mostrar os detalhes.

- **Análise:** Verifique a lista gerada. Você realmente precisa que ferramentas obscuras de rede tenham privilégios de root?
- **Remoção:** Se encontrar um binário que não deveria ter SUID (ou que não é estritamente necessário para usuários comuns), remova o bit com o comando `chmod a-s /caminho/para/o/arquivo`.

    - **a**: All users
    - **"-"**: Remover
    - **s**: Sinalizador especial

- **Prevenção no Disco:** Para partições onde os usuários comuns escrevem dados (como `/home`, `/tmp` ou `/var`), edite o `/etc/fstab` e adicione a opção de montagem `nosuid`. Isso instrui o kernel a ignorar completamente os bits SUID/SGID em qualquer arquivo contido nessas partições.

## 4. Utilização do systemctl para Sandboxing de Serviços

Relembrando: O systemd é o sistema de inicialização do Linux (Também chamado de init em sistemas mais antigos) e o primeiro processo a ser executado no nosso sistema operacional (Recebendo o id de processo PID 1), além de iniciar nosso sistema ele também é responsável por gerencias nossos processos de segundo plano. Nós podemos gerenciar o systemd e seus processos utilizando o comando systemctl.

O `systemd` não é apenas um gerenciador de inicialização e de processos de fundo; é uma das ferramentas de isolamento de segurança (sandboxing) mais poderosas do ecossistema Linux moderno. Você pode confinar serviços para que, mesmo que sejam hackeados, o invasor não consiga acessar o resto do sistema.

Edite o arquivo de unidade (unit file) de um serviço em `/etc/systemd/system/exemplo.service` e adicione as seguintes diretivas na seção `[Service]`:

* `ProtectSystem=strict`: Torna toda a hierarquia de diretórios (como `/usr`, `/boot` e `/etc`) estritamente de leitura (read-only) para aquele serviço. Ele não poderá modificar os arquivos do sistema.
* `ProtectHome=yes`: Torna os diretórios `/home`, `/root` e `/run/user` invisíveis e inacessíveis para o serviço.
* `PrivateTmp=yes`: Cria um diretório `/tmp` isolado apenas para aquele serviço. Ele não conseguirá ver arquivos temporários deixados por outros processos ou pelo root.
* `NoNewPrivileges=yes`: Garante que o serviço (e seus processos filhos) não consiga elevar seus privilégios, impedindo efetivamente que o serviço execute binários SUID com sucesso.
