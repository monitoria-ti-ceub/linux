# Ciclo III - Advanced

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
- Diretórios e binários essenciais;
- Dependências;
- Bibliotecas compartilhadas necessárias;
- Criação de device nodes com `mknod`;
- Configuração mínima: `/etc/passwd`, `/etc/group`, `/etc/hostname`, `/etc/fstab`;
- Criação do arquivo de configuração do shell: `/etc/profile`, `.bashrc`;
- `chroot`;
- `tar`, `cpio`.

29. Bootloader e Inicialização Customizada
- GRUB;
- Entradas de boot customizadas;
- Parâmetros de kernel;
- initramfs customizado;
- Scripts de inicialização;
- Ordem de boot;
- Troubleshooting de boot;
- U-Boot.

30. Integração de Ferramentas Essenciais
- Compilando ferramentas: `busybox`;
- Compilando shells alternativos: `dash`, `zsh`;
- Compilando editores: `nano`, `vim`;
- Compilando ferramentas de rede: `iproute2`, `openssh`, `curl`, `wget`;
- Compilando ferramentas de sistema: `htop`, `tmux`, `screen`;
- Compilando ferramentas de desenvolvimento: `gcc`, `make`, `git`;
- Gerenciando dependências entre ferramentas;
- Otimização;
- Criando symlinks para compatibilidade.

31. Configuração de Rede e Serviços Básicos
- Configuração de rede: interfaces, IP, DNS, gateway;
- Arquivos de configuração;
- Ferramentas de rede;
- DHCP vs. IP estático;
- Configuração de SSH;
- Firewall básico;
- Serviços essenciais;
- Sincronização de tempo;
- DNS local.

32. Gerenciamento de Pacotes Customizado
- Escolhendo um gerenciador;
- Como organizar pacotes;
- Criando pacotes;
- Assinando pacotes;
- Repositório local;
- Configurando o gerenciador de pacotes na distribuição;
- Automatizando builds;
- Versionamento e dependências;
- Atualizações.

33. Otimização, Segurança e Finalização
- Auditoria de segurança;
- Hardening;
- Otimização de performance;
- Redução de tamanho;
- Testes;
- Documentação;
- Instaladores;
- Imagens;
- Versionamento.

34. Distribuição e Deployment
- Hospedando a distribuição;
- Criando checksums e assinaturas;
- Documentação;
- Comunidade;
- Feedback e iteração;
- Contribuições;
- Licença;
- Marketing;
- Sustentabilidade.
