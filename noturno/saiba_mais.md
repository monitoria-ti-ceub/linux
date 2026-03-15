## Fundamentos de Sistemas Operacionais

- Todo sistema operacional é software?

Sim. Um sistema operacional é software. Ele não é hardware porque não é uma peça física, é um conjunto de instruções e programas armazenados em algum meio (SSDs, HDs, até pen-drives!) e carregados para a memória quando o computador inicia.
Mas ele não é um programa qualquer. Ele é um software de sistema, ou seja, um software responsável por criar o ambiente em que os outros programas funcionam.

- Ele é um programa ou um conjunto de programas?

Na prática, um sistema operacional não costuma ser um único programa isolado, ele é formado por várias partes com funções diferentes, como: gerenciamento de processos, gerenciamento de arquivos, interface gráfica, gerenciamento de memória, alocação de recursos, segurança, gerenciamento de dispositivos, etc.

- Qual é a diferença entre software comum e software de sistema?

O software de sistema disponibiliza uma interface cujo, através dessa interface, os softwares comuns (os aplicativos) irão funcionar. Ele fica entre o kernel (E consequentemente o hardware) e os softwares comuns.

- Se o SO é software, como ele controla o hardware?

Através do kernel, o "coração" do sistema operacional, que com o uso de drivers de dispositivos (softwares especializados que atuam no nível de kernel) faz com que os componentes de hardware funcionem e possam ser controlados no nível do sistema operacional.

- Como o hardware "obedece" o software?

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

- O que é firmware?

Firmware é um software de baixo nível gravado em um hardware (chip físico), geralmente em memória ROM ou flash. Ele é responsável por controlar funções básicas do dispositivo, como inicialização do hardware e comunicação com outros componentes do sistema.

- Qual é a diferença entre BIOS e UEFI?

UEFI (Unified Extensible Firmware Interface) é o firmware moderno que substitui a BIOS tradicional, oferecendo uma interface gráfica mais amigável, opções de segurança (como o Secure Boot) e inicialização mais rápida. Enquanto a BIOS é limitada a 16 bits e a discos de até 2 TB, a UEFI opera em 32 ou 64 bits e oferece suporte a discos com mais de 2 TB.

- O que é POST?

- O que o computador testa quando liga?

- Quais dispotivios são verificados na inicialização?

- Por que o computador procura um dispositivo de boot?

- O que faz um disco ser bootável?

- O que acontece se não houver dispositivo de boot?

- O que é bootloader?

- Quando o kernel entra em execução e o que acontece quando ele carrega?

- Como a interface gráfica aparece depois da inicialização?

## Unix

- Por que Unix foi tão influente?

- O Linux é Unix?

- O que significa Unix-like?

- O que significa a filosofia Unix?

## Windows

- O que muda entre Windows e Linux se ambos fazem o papel de SO?

- O Windows tem kernel?

- O Windows usa terminal também?

- Por que a maioria dos programas comerciais são feitos primeiro para Windows?

- O que o Windows esconde do usuário que o Linux costuma expôr mais?

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

