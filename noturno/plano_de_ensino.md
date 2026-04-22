## Objetivo
Apresentar os conceitos essenciais de Linux e de sistemas operacionais, desenvolvendo uma base teórica e prática para utilizar o sistema com mais segurança, autonomia e compreensão.

## Metodologia
A oficina será conduzida por meio de:
- Explicações teóricas introdutórias;
- Comparações entre Linux e outros sistemas operacionais;
- Demonstrações práticas no terminal;
- Exemplos de organização de arquivos e permissões;
- Exercícios simples de navegação e administração básica;
- Discussão de boas práticas de uso e segurança;

## Conteúdo Programático
### Ciclo I
1. O que é um sistema operacional?
- Definição de SO;
- O papel do SO na comunicação entre hardware e software;
- As principais funções de um sistema operacional.

2. Windows vs. Linux
- As diferenças conceituais e práticas;
- Software proprietário e software livre;
- Os principais usos do Linux e do Windows;
- As vantagens e limitações de cada abordagem.

3. BIOS/UEFI
- O que é BIOS?
- O processo de inicialização do computador;
- A diferença entre firmware e sistema operacional;
- Noção básica de UEFI.

4. Interface Gráfica
- O conceito de GUI;
- A diferença entre interface gráfico e sistema operacional;
- Exemplos de ambientes gráficos no Linux.

5. Terminal
- O que é o terminal?
- A importância da linha de comando no Linux;
- Os comandos básicos de navegação e manipulação de arquivos;
- Introdução à lógica de uso do shell.

6. Filesystem
- O que é o terminal?
- A estrutura em árvore no Linux;
- Diretórios importantes, `/home`, `/etc`, `/var`, `/mnt`, `/root`;
- A diferença entre a organização do Linux e do Windows.

7. Rotas Absolutas e Relativas
- Caminhos absolutos;
- Caminhos relativos;
- A importância desses conceitos na navegação e administração do sistema.

8. Usuários, Grupos e Permissões
- O conceito de um sistema multiusuário;
- Usuário comum e superusuário;
- Grupos;
- Permissões de leitura, escrita e execução;
- Segurança e controle de acesso.

9. `sudo`
- O papel do `sudo`;
- Os privilégios administrativos.

10. O Que São Processos, IPC e Sinais?
- Definição de processo;
- A diferença entre programa e processo;
- Introdução à comunicação entre processos;
- Os sinais e controle de execução.

11. Package Managers
- O que são gerenciadores de pacotes?
- Instalação, atualização e remoção de programas;
- Dependências;
- Exemplos como `apt`, `dnf` e `pacman`.

12. Pontos de Montagem
- O conceito de montagem dos dispositivos;
- A integração de discos e mídias ao sistema de arquivos;
- Diretórios como/mnt e /media;
- Noção básica de /etc/fstab.

13. Máquinas Virtuais
- O que são máquinas virtuais?
- O uso de Linux em ambiente virtualizado;
- As vantagens para estudo, testes e segurança.

14. Dual Boot
- Definição de dual boot;
- O uso de Linux e Windows na mesma máquina;
- As vantagens, limitações e cuidados.

15. Segurança em Linux
- O princípio do menor privilégio;
- A importância das permissões;
- Atualizações e gerenciamento de pacotes;
- Noções introdutórias de boas práticas de segurança.

### Ciclo II
16. Shell
- Shell como interpretador e ambiente;
- Variáveis de ambiente;
- `PATH`, expansão, quoting e substituição de comandos;
- `stdin`, `stdout`, `stderr`;
- Pipes e redirecionamentos.

17. Ferramentas de Texto e Scripts
- Leitura e edição de arquivos de texto;
- Ferramentas de processamento como `cat`, `less`, `grep`, `head`, `tail`, `wc`, `sort`, `cut`;
- O que é um script?
- Shebang, permissões e execução;
- Parâmetros, variáveis e fluxo básico em Bash.

18. Edição de Arquivos de Texto

19. Estrutura do Linux
- Hierarquia do sistema de arquivos;
- Diretórios como `/bin`, `/usr`, `/etc`, `/lib`, `/boot`, `/dev`, `/proc`, `/sys`, `/run`, `/tmp`, `var`;
- O que é essencial em um sistema funcional?
- A diferença entre arquivos comuns, pseudoarquivos e device nodes.

20. Usuários, Grupos e Permissões

21. Montagem de Sistemas de Arquivos e Particionamento

22. Executáveis, Bibliotecas e Configuração
- O que é um binário?
- O que é uma biblioteca compartilhada?
- Dependências e linking;
- Arquivos de configuração;
- Programas, bibliotecas e arquivos em `/etc`.

23. Boot e Inicialização do Sistema
- Firmware, bootloader, kernel, initramfs e init;
- `systemd`;
- O que é o processo 1?
- Alvos, unidades e serviços;
- A sequência que leva o sistema até um ambiente utilizável.

24. Serviços, Logs e Observabilidade
- O que são daemons e serviços?
- Como inspecionar o estado do sistema;
- Leitura de logs;
- Uso de `systemctl` e `journalctl`;
- Diagnóstico inicial de falhas.

25. Processos, Sinais e Controle de Execução
- Processos;
- Foreground, background e jobs;
- PID, processo pai e processo filho;
- Sinais e encerramento;
- Controle de execução e observação com `ps`, `top`, `jobs`, `kill` e afins.

26. Software, Dependências, Pacotes e Laboratório em Máquina Virtual
- Pacotes e repositórios;
- Dependências e integração com a distro;
- A diferença entre instalar, extrair e compilar;
- Uso da máquina virtual como laboratório;
- Ambiente para experimentação estrutural.

### Ciclo III
27. Compilação do Kernel Linux
- Código-fonte;
- Configuração do Kernel;
- Selecionando drivers e módulos essenciais;
- Compilação: `make`, `make modules`, `make modules_install`;
- Instalação: `vmlinuz`, `System.map`, `/boot`;
- Criando módulos compiláveis;
- Debugging de problemas de compilação;
- Otimização.

28. Criação de um Sistema de Arquivos Raiz
- Diretórios e binários essenciais
- Dependências
- Bibliotecas compartilhadas necessárias
- Criação de device nodes com `mknod`
- Configuração mínima: `/etc/passwd`, `/etc/group`, `/etc/hostname`, `/etc/fstab`;
- Criação do arquivo de configuração do shell: `/etc/profile`, `.bashrc`
- `chroot`
- `tar`, `cpio`

29. Bootloader e Inicialização Customizada
- GRUB
- Entradas de boot customizadas
- Parâmetros de kernel
- initramfs customizado
- Scripts de inicialização
- Ordem de boot
- Troubleshooting de boot
- U-Boot

30. Integração de Ferramentas Essenciais
- Compilando ferramentas: `busybox`
- Compilando shells alternativos: `dash`, `zsh`
- Compilando editores: `nano`, `vim`
- Compilando ferramentas de rede: `iproute2`, `openssh`, `curl`, `wget`
- Compilando ferramentas de sistema: `htop`, `tmux`, `screen`
- Compilando ferramentas de desenvolvimento: `gcc`, `make`, `git`
- Gerenciando dependências entre ferramentas
- Otimização
- Criando symlinks para compatibilidade

31. Configuração de Rede e Serviços Básicos
- Configuração de rede: interfaces, IP, DNS, gateway
- Arquivos de configuração
- Ferramentas de rede
- DHCP vs. IP estático
- Configuração de SSH
- Firewall básico
- Serviços essenciais
- Sincronização de tempo
- DNS local

32. Gerenciamento de Pacotes Customizado
- Escolhendo um gerenciador
- Como organizar pacotes
- Criando pacotes
- Assinando pacotes
- Repositório local
- Configurando o gerenciador de pacotes na distribuição
- Automatizando builds
- Versionamento e dependências
- Atualizações

33. Otimização, Segurança e Finalização
- Auditoria de segurança
- Hardening
- Otimização de performance
- Redução de tamanho
- Testes
- Documentação
- Instaladores
- Imagens
- Versionamento

34. Distribuição e Deployment
- Hospedando a distribuição
- Criando checksums e assinaturas
- Documentação
- Comunidade
- Feedback e iteração
- Contribuições
- Licença
- Marketing
- Sustentabilidade

