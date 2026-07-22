# Configuração do Kernel

O processo de compilação do kernel Linux não é monolítico. Compilar 30 milhões de linhas de código com suporte para milhares de dispositivos de hardware e protocolos de software resultaria em um binário de proporções absurdas, ineficiente em consumo de memória e com uma inicialização intolerável de lenta. O engenho do sistema de build do Linux (Kbuild) está na sua modularidade e na capacidade de adaptação granular através do processo de configuração. A configuração do kernel é definir exatamente quais subsistemas, drivers e recursos serão incluídos no binário final e de que forma serão integrados.

## `.config`

O coração do processo de configuração é umm arquivo de texto chamado `.config`, localizado na raiz do diretório do código-fonte do kernel. Ele atua como o manual de instruções para o compilador GCC e para o linker. Ele não tem código, é uma lista imensa de variáveis de ambiente e diretivas de configuração (chamadas de Kconfig symbols ou config options).

Cada linha neste arquivo segue um formato rígido:
`CONFIG_NOME_DA_OPCAO=valor`

O número de opções disponíveis aumenta a cada versão nova do kernel, ultrapassando ~15.000 diretivas. A complexidade do arquivo não está apenas no volume de opções mas na intrincada rede de dependências cruzadas entre elas. Por exemplo, é impossível habilitar o suporte para o sistema de arquivos de rede NFS (`CONFIG_NFS_FS`) sem habilitar o suporte à pilha de rede TCP/IP (`CONFIG_INET`) antes. O sistema de Kbuild é projetado para gerenciar e impôr essas dependências, impedindo que o usuário faça configurações que são logicamente impossíveis, resultando em falhas catastróficas de compilação.

## A Trindade: `y`, `m` e `n`

A maioria das opções no `.config` refere-se à inclusão de código (drivers, sistemas de arquivos, algoritmos). Para lidar com a inclusão destas opções, o Kbuild oferece um modelo de decisão triplo.

### `y` (Yes / Built-In)

Quando uma diretiva é configurada com o valor `y`, o sistema de build orienta o compilador para traduzir o código-fonte correspondente e orienta o linker para colar o arquivo objeto resultante (`.o`) dentro do binário executável final do kernel (a imagem `vmlinux` que será compactada em `bzImage`).

A característica principal do código embutido (built-in) é a disponibilidade imediata. Assim que o bootloader transfere o controle da execução para o kernel e é carregado na memória RAM, todo o código que foi marcado como `y` já está presente e funcional. Não há atrasos, não há necessidade de ler arquivos adicionais do disco. Esta abordagem é obrigatória para componentes críticos da infraestrutura como o agendador de processos, o subsistema de gerenciamento de memória e os drivers necessários para montar o sistema de arquivos raiz inicial.
A desvantagem de abusar da opção `y` é o aumento do tamanho da imagem estática do kernel (bloat), o que consome mais RAM de forma permanente (já que o kernel não pode ser paginado para o swap) e aumenta o tempo de descompactação durante o boot.

### `m` (Module)

A modularidade é a solução do Linux para o crescimento descontrolado do kernel monolítico. Quando uma diretiva é configurada com o valor `m`, o código-fonte é compilado mas o linker não anexa ele para o binário principal do kernel. Em vez disso, ele gera um arquivo executável separado, com a extensão `.ko` (Kernel Object).

Estes arquivos `.ko` são armazenados no sistema de arquivos do disco rígido, `/lib/modules/$(uname -r)/` (tradicionalmente). O kernel inicializa sem este código na memória. A mágica da modularidade ocorre em tempo de execução: se o kernel detectar que um novo hardware foi conectado (ex: um pen-drive USB) ou se um programa no espaço de usuário solicitar um recurso específico (ex: montar uma partição NTFS), o kernel pode ler o arquivo `.ko` correspondente do disco e injetar ele no espaço de memória do kernel em tempo real. Uma vez que o módulo é carregado, ele tem os mesmos privilégios e opera com a mesma velocidade que o código embutido (`y`).

A vantagem da opção `m` é a flexibilidade extrema e a economia de memória RAM. O kernel base continua enxuto e rápido, carregando apenas o código necessário para o hardware presente no momento.
A desvantagem é o problema do "ovo e a galinha" durante o boot: o kernel não pode carregar um módulo que está armazenado no disco rígido se ele não possui o driver embutido (`y`) necessário para ler o próprio disco rígido.

### `n` (No / Desativado)

Se uma opção for configurada como `n`, o código-fonte é ignorado pelo compilador. Ele não será incluído no kernel base nem terá um módulo carregável gerado. Esta é a ferramenta primária para a otimização e o hardening (fortalecimento da segurança) do sistema. Se um servidor não possui hardware de Bluetooth e não precisa de suporte para protocolos de rádio amador, desativas essas opção reduz o tempo de compilação, economiza espaço em disco e elimina vetores dde ataques potenciais, reduzindo a superfície de ataque do sistema operacional.

### Opções Adicionais

Apesar da trindade `y/m/n` dominar o `.config`, o Kbuild suporta outros tipos de variáveis para configurações específicas:

- Strings: Utilizadas para definir nomes ou caminhos, como `CONFIG_LOCALVERSION="-minhadistro"`, que anexa uma string personalizada ao nome da versão do kernel.
- Inteiros e Hexadecimais: Utilizados para definir tamanhos de buffers, limites de memória ou endereços físicos, como `CONFIG_LOG_BUF_SHIFT=18`, que define o tamanho do buffer de log do kernel em bytes (2^18).

## Ferramentas de Geração de Configuração

Editar o `.config` na mão com um editor de texto é um pesadelo. Não é recomendado por ser um trabalho árduo e propenso à desastres dada a complexidade das dependências lógicas (a ativação de uma opção pode exigir a ativação de três outras). Para gerenciar essa complexidade, o kernel fornece ferramentas integradas ao Makefile.

### `make defconfig`

O comando `make defconfig` (Default Configuration) é o método mais seguro e confiável para iniciar o processo de configuração.

O Kbuild examina a arquitetura do sistema hospedeiro (ex: x86_64) e lê um arquivo de configuração padrão daquela arquitetura específica (`arch/x86/configs/x86_64_defconfig`). Este arquivo contém um subconjunto curado de opções que garantem que o kernel resultante será capaz de inicializar na maioria dos computadores baseados naquela arquitetura. Ele ativda suporte para barramentos PCI Express, discos SATA/NVMe genéricos, sistemas de arquivos comuns (ext4) e dispositivos de entrada (teclados e mouses USB). O `defconfig` cria o arquivo `.config` inicial na raiz do diretório, resolvendo todas as dependências complexas e preenchendo as opções com valores padrão seguros automaticamente.

### Configuração Minimalista

Em oposição ao `defconfig`, o comando `make allnoconfig` gera um arquivo `.config` em que todas as opções possíveis são definidas como `n`. O resultado é um kernel minúsculo mas inútil. Incapaz de imprimir texto na tela, ler discos ou se comunicar com a rede. É um comando utilizado por desenvolvedores de sistemas embarcados que querem construir o kernel de baixo para cima, com uma ativação cirúrgica dos recursos necessários para um hardware específico de propósito único (como um roteador minimalista). O `make tinyconfig` é uma variação ainda mais agressiva, focada na redução absoluta do tamanho do binário.

### Configuração Otimizada para o Host

É uma das ferramentas mais poderosas para otimização rápida. O comando `make localmodconfig` analisa o estado do sistema operacional hospedeiro no momento exato de sua execução. Ele lê a lista de módulos do kernel carregados na memória (através da saída do comando `lsmod` ou da leitura de `/proc/modules`) e examina o hardware conectado.

O Kbuild modifica o `.config` desativamento todos os milhares de drivers de hardware e módulos que não estão ativamente em uso na máquina hospedeira. O resultado é uma configuração otimizada que compilará em uma fração do tempo normal e gerará um kernel enxuto. MAS! O kernel gerado por este método é amarrado ao hardware específico onde foi configurado. Se o pen-drive com a distribuição for conectado em um computador diferente (ex: com uma placa de rede diferente), a rede não funcionará pois o driver correspondente foi excluído durante o processo de `localmodconfig`.

## `make menuconfig`

Após gerar a configuração base, o próximo passo obrigatório é a revisão e o ajuste manual. O Kbuild fornece várias interfaces (como `xconfig` para ambientes gráficos Qt e `gconfig` para GTK) mas a ferramenta universal é o `make menuconfig`.

A execução deste comando precisa da biblioteca de desenvolvimento `ncurses` (libncurses-dev` em sistemas Debian/Ubuntu). O `menuconfig` compila um pequeno utilitário em C (`mconf`) e executa, apresentando uma interface de usuário baseada em texto com menus hierárquicos, fundos azuis e caixas de diálogo.

### Navegação e Operação no `menuconfig`

A interface é controlada pelo teclado:

- Setas Direcionais (Cima/Baixo): Navegam pelos itens do menu.
- Enter: Entra em um submenu (itens que terminal com `--->`) ou abre uma caixa de diálogo para opções de string/inteiro.
- `Esc Esc`: Retorna ao menu anterior. Se for executado no menu principal, solicita a confirmação para salvar as alterações e encerrar o programa.
- Barra de Espaço: Altera o estado da opção selecionada. As teclas `y`, `m` e `n` também podem ser pressionadas para forçar um estado específico.
- `?`: Abre a tela de ajuda da opção selecionada. A ajuda descreve o que a opção faz e lista suas dependências lógicas e o nome da variável no arquivo `.config`.
