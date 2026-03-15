## Fundamentos de Sistemas Operacionais

- Todo sistema operacional é software?

Sim. Um sistema operacional é software. Ele não é hardware porque não é uma peça física, é um conjunto de instruções e programas armazenados em algum meio (SSDs, HDs, até pen-drives!) e carregados para a memória quando o computador inicia.
Mas ele não é um programa qualquer. Ele é um software de sistema, ou seja, um software responsável por criar o ambiente em que os outros programas funcionam.

- Ele é um programa ou um conjunto de programas?

Na prática, um sistema operacional não costuma ser um único programa isolado, ele é formado por várias partes com funções diferentes, como: gerenciamento de processos, gerenciamento de arquivos, interface gráfica, gerenciamento de memória, alocação de recursos, segurança, gerenciamento de dispositivos, etc.

- Qual é a diferença entre software comum e software de sistema?

O software de sistema disponibiliza uma interface cujo, através dessa interface, os softwares comuns (os aplicativos) irão funcionar. Ele fica entre o kernel (E consequentemente o hardware) e os softwares comuns.

- Se o SO é software, como ele controla o hardware?

Através do kernel, o "coração" do sistema operacional, que com o uso de drivers de dispositivos (softwares especializados que atuam no nível de kernel) faz com que os componentes de hardware funcionem e possam ser controlados pelo software (tanto o SO quanto softwares comuns).

- O kernel é o sistema operacional inteiro?

Não! Porém ele é parte mais importante do sistema operacional, ele é o alicerce do sistema operacional. No caso do Linux, o Linux é o próprio kernel, que devido a sua natureza "open-source", diversos desenvolvedores ao redor do mundo utilizam esse kernel e criam suas próprias distribuições do Linux.

- Qual é a diferença entre kernel, sistema operacional e distribuição?

Kernel é o coração de um sistema operacional, o sistema operacional é o conjunto de softwares que juntos faz com que o usuário possa interagir com o computador e as distribuições são os diferentes "sabores" de Linux, cada um com suas peculiaridades, sejam eles diferentes gerenciadores de pacotes, gerenciadores de sistemas, funcionalidades, entre outros.

- O processador executa o SO da mesma forma que executa qualquer outro programa?

A CPU executa instruções, então nesse sentido, o sistema operacional também é executado como código de máquina. Mas SOs executam partes críticas em modo privilegiado, com acesso maior ao hardware e a recursos protegidos, enquanto aplicativos comunds executam em modo usuário, com restrições.
Isso existe para segurança e estabilidade. Se qualquer aplicativo pudesse acessar diretamente tudo no hardware, o sistema seria muito mais fácil de quebrar.

- O SO fica rodando o tempo todo? Onde?

Sim! Enquanto o computador está em funcionamento, partes do SO ficam carregadas e ativas o tempo todo. Ele fica armazenado de forma persistente no disco e executando a partir da memória RAM depois de ser carregado no boot.
    - No armanezamento, ele está "guardado";
    - Na RAM, ele está "em uso";
    - Na CPU, suas instruções estão sendo efetivamente executadas.

## O computador

- O que acontece quando apertamos o botão de ligar?

O computador começa a receber e estabilizar energia nos componentes. A placa-mãe, a fonte e outros circuitos entram em funcionamento, e a CPU passa a procurar sua instrução inicial de execução.

- O que liga primeiro?
    - A energia é estabilizada;
    - A CPU começa a executar;
    - O firmware testa e identifica componentes;
    - Ela procura um dispositivo de boot;
    - O bootloader carrega;
    - O bootloader carrega o kernel;
    - O kernel assume e sobe o sistema.

- Qual é a diferença entre ligar o computador e iniciar o SO?
Alguém precisa:
    - Inicializar minimamente o hardware;
    - Verificar se há memória e dispositivos básicos;
    - Localizar de onde virá o sistema operacional;
    - Transferir esse sistema para a memória.
Quem faz esse papel inicial é o firmware, junto com o processo de boot.

Ligar o computador é fornecer energia e iniciar os circuitos básicos. Iniciar o SO é uma etapa posterior, quando o firmware e o processo de boot já localizaram e carregam o sistema.

- Por que o SO não é a primeira coisa a ser executada?

Pois o firmware e a bios precisam inicializar, testar e configurar os componentes de hardware para assim então conseguir ler o dispositivo de boot e inicializar o SO.

- O que é firmware?

Firmware é um software de baixo nível gravado em um hardware (chip físico), geralmente em memória ROM ou flash. Ele é responsável por controlar funções básicas do dispositivo, como inicialização do hardware e comunicação com outros componentes e softwares do sistema, o software em questão sendo a BIOS/UEFI.

- Qual é a diferença entre BIOS e UEFI?

UEFI (Unified Extensible Firmware Interface) é o firmware moderno que substitui a BIOS tradicional, oferecendo uma interface gráfica mais amigável, opções de segurança (como o Secure Boot) e inicialização mais rápida. Enquanto a BIOS é limitada a 16 bits e a discos de até 2 TB, a UEFI opera em 32 ou 64 bits e oferece suporte a discos com mais de 2 TB.

- O que é POST?

POST é uma sigla que significa "Power-On Self-Test", é a primeira etapa da inicialização do computador feita pelo firmware onde o mesmo verifica o funcionamento dos componentes essenciais de hardware, essa é uma etapa feita não pela imagem do monitor mas por luzes e sons vindos da própria placa-mãe.

- O que o computador testa quando liga?

Processador, Memoria RAM, placa de vídeo, discos e a própria placa-mãe.

- Por que o computador procura um dispositivo de boot?

Pois é nele onde está localizado o sistema operacional do seu computador.

- O que faz um disco ser bootável?

Ter um sistema operacional instalado no disco, SSD ou ate mesmo pen-drive.

- O que acontece se não houver dispositivo de boot?

A BIOS/UEFI aciona uma mensagem de erro informando que não foi possivel encontrar um dispositivo de boot, outras situações que podem ocorrer são: uma tela preta após a tela de BIOS, o computador pode ficar preso na tela de BIOS ou o computador pode entrar em um loop de busca por um dispositivo bootavel.

- O que é bootloader?

Bootloader é o software que inicializa o kernel e por sua vez, o sistema operacional de sua máquina, em Linux é comum a utilização do GRUB, que é um sistema unificado de boot, como seu bootloader, o GRUB é especialmente util pois ele facilita situações de dual-boot ou para a escolha de versões de Linux quando há mais de uma versão do mesmo SO Linux no computador.

- Quando o kernel entra em execução e o que acontece quando ele carrega?

Logo após a BIOS/UEFI detectar o drive bootavel e inicia-lo. Quando o kernel do SO é inicializado ele inicia os serviços do sistema operacional, como gerenciamento de memória, detecção de hardware e inicialização do sistema de gerenciamento de arquivos.

- Como a interface gráfica aparece depois da inicialização?

É nesse momento em que o sistema operacional de sua escolha aparece em seu monitor da maneira que você está acostumado!

## Unix

- Por que Unix foi tão influente?

O Unix foi criado para ser um sistema operacional unificado, ou seja, que consegue rodar em qualquer máquina independente de hardware, essa padronização feita pelo o Unix permitiu que o desenvolvimento de programas fosse o mesmo para todos os sistemas, o Unix é a base em que sistemas operacionais tais como o Linux e o iOS foram desenvolvidos.

- O Linux é Unix?

O Linux na verdade foi feito na base do Minix, uma versão modificada do Unix feita para fins educativos. O Linux pode sim ser considerado Unix mas ele acabou virando muito mais que isso com o passar do tempo!

- O que significa Unix-like?

Unix-like significa que o sistema operacional em questão foi feito sob a base do Unix ou suas variações. Isso significa que o SO em questão possuir um sistema de arquivos estruturado de forma hierarquica, uma interface de linha de comando - CLI (Que permite a interação do usuário com o SO e qualquer programa instalado nele através de texto), capacidade de gerenciamento de multiplos usuários além de seguir a ideia de que "tudo é um arquivo".

- O que significa a filosofia Unix?

A filosofia Unix segue a linha de que todo programa precisa ser feito para ser pequeno, modular e servir uma única funcionalidade e que funciona com outros programas desenvolvidos da mesma maneira, unidos através de linhas de texto.

## Windows

- O que muda entre Windows e Linux se ambos fazem o papel de SO?

O Windows já vem com uma serie de programas escolhidos pela Microsoft ao instalar o sistema operacional (Pense em algo como a Interface Gráfica, Windows Media Player, Exibidor de imagens, Windows Defender, Copilot), enquanto sistemas Linux vem apenas com o Kernel e o sistema operacional, sendo que qualquer outro programa adicional deve ser instalado pelo próprio usuário, ou seja, o sistema operacional pode ser customizado para ser da forma que você quiser.

- O Windows tem kernel?

Sim, o Windows possui um kernel, o Windows NT, ele é um kernel proprietário da Microsoft e não foi construido tendo o Unix como base, ou seja, não utiliza de seu kernel ou de sua filosofia.

- O Windows usa terminal também?

De certa forma sim, o Windows possui um emulador de terminal com o nome "Windows Terminal" e nele você pode usar o prompt de commando e o Windows Powershell, que não são exatamente terminais mas são interpretadores de linhas de comando.

- Por que a maioria dos programas comerciais são feitos primeiro para Windows?

O Windows é considerado padrão pelo mercado consumidor e é o sistema operacional mais utilizado do mundo, tendo isso em mente é comum que aplicações comerciais são desenvolvidas primeiro para Windows.

- O que o Windows esconde do usuário que o Linux costuma expôr mais?

O Windows, principalmente o Windows 11, é conhecido por instalar prog

## Linux

- Linux é sistema operacional ou kernel?

O sistema operacional GNU/Linux é comumente referido apenas como Linux. No entanto, Linux é apenas o kernel (núcleo) do sistema operacional, responsável por atuar como intermediário entre o hardware e os softwares. O sistema completo normalmente inclui ferramentas do projeto GNU, por isso o nome GNU/Linux.

- O que é uma distribuição Linux?

Distribuição Linux, ou “distro”, é um sistema operacional completo construído com ferramentas do projeto GNU e utilizando o kernel Linux como núcleo.

- Por que existem tantas distribuições?

O motivo de existirem tantas distribuições é que o GNU oferece um vasto conjunto de softwares livres e de código aberto, permitindo que diferentes pessoas criem seus próprios sistemas operacionais conforme suas necessidades.

- O que muda de uma distro para outra?

As diferenças entre as distribuições Linux vêm das escolhas de softwares e ferramentas do projeto GNU, o que pode influenciar até mesmo a filosofia da distribuição. Entre os principais pontos que diferenciam uma distro da outra estão: o gerenciador de pacotes (como os softwares são instalados e atualizados), os repositórios (quantidade e versão dos programas disponíveis) e as ferramentas de configuração que já vêm pré-instaladas.

- O Linux precisa de interface gráfica?

Não, o Linux não precisa de interface gráfica (GUI) para funcionar. A base do sistema é operada via linha de comando (terminal)

- Dá pra usar Linux só pelo terminal?

Sim, é perfeitamente possível utilizar o Linux exclusivamente pelo terminal (CLI - Command Line Interface), sendo esta uma prática comum em servidores e por usuários avançados. O terminal oferece controle total, automação e rapidez, permitindo gerenciar arquivos, instalar softwares e configurar o sistema sem interface gráfica. 

- Linux é mais difícil ou só dá mais controle ao usuário?

- Como Linux é seguro?

- Qual é a diferença entre software livre e open-source?

## Dual Boot

- Como dois SOs podem coexistir no mesmo computador?

- Eles rodam ao mesmo tempo?

- Como o computador sabe qual sistema iniciar?

- O que é partição?

- O que pode dar errado instalando dual boot?

- O que é GRUB?

- O que acontece se o bootloader for sobrescrito?

- Dual boot é melhor do que máquina virtual?

## BIOS/UEFI e Secure Boot

- O que é UEFI e por que substituiu a BIOS tradicional?

- O que é firmware?

- BIOS/UEFI fica no disco?

- O que é Secure Boot?

- O Secure Boot impede Linux?

- Por que alguns sistemas são aceitos e outros não?

- O que significa uma chave confiável no processo de boot?

