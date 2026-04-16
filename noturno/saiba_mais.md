## Fundamentos de Sistemas Operacionais

### Todo sistema operacional é software?

Sim. Um sistema operacional é software. Ele não é hardware porque não é uma peça física, é um conjunto de instruções e programas armazenados em algum meio (SSDs, HDs, até pen-drives!) e carregados para a memória quando o computador inicia.
Mas ele não é um programa qualquer. Ele é um software de sistema, ou seja, um software responsável por criar o ambiente em que os outros programas funcionam.

### Ele é um programa ou um conjunto de programas?

Na prática, um sistema operacional não costuma ser um único programa isolado, ele é formado por várias partes com funções diferentes, como: gerenciamento de processos, gerenciamento de arquivos, interface gráfica, gerenciamento de memória, alocação de recursos, segurança, gerenciamento de dispositivos, etc.

### Qual é a diferença entre software comum e software de sistema?

O software de sistema disponibiliza uma interface cujo, através dessa interface, os softwares comuns (os aplicativos) irão funcionar. Ele fica entre o kernel (E consequentemente o hardware) e os softwares comuns.

### Se o SO é software, como ele controla o hardware?

Através do kernel, o "coração" do sistema operacional, que com o uso de drivers de dispositivos (softwares especializados que atuam no nível de kernel) faz com que os componentes de hardware funcionem e possam ser controlados pelo software (tanto o SO quanto softwares comuns).

### O kernel é o sistema operacional inteiro?

Não! Porém ele é parte mais importante do sistema operacional, ele é o alicerce do sistema operacional. No caso do Linux, o Linux é o próprio kernel, que devido a sua natureza "open-source", diversos desenvolvedores ao redor do mundo utilizam esse kernel e criam suas próprias distribuições do Linux.

### Qual é a diferença entre kernel, sistema operacional e distribuição?

Kernel é o coração de um sistema operacional, o sistema operacional é o conjunto de softwares que juntos faz com que o usuário possa interagir com o computador e as distribuições são os diferentes "sabores" de Linux, cada um com suas peculiaridades, sejam eles diferentes gerenciadores de pacotes, gerenciadores de sistemas, funcionalidades, entre outros.

### O processador executa o SO da mesma forma que executa qualquer outro programa?

A CPU executa instruções, então nesse sentido, o sistema operacional também é executado como código de máquina. Mas SOs executam partes críticas em modo privilegiado, com acesso maior ao hardware e a recursos protegidos, enquanto aplicativos comunds executam em modo usuário, com restrições.
Isso existe para segurança e estabilidade. Se qualquer aplicativo pudesse acessar diretamente tudo no hardware, o sistema seria muito mais fácil de quebrar.

### O SO fica rodando o tempo todo? Onde?

Sim! Enquanto o computador está em funcionamento, partes do SO ficam carregadas e ativas o tempo todo. Ele fica armazenado de forma persistente no disco e executando a partir da memória RAM depois de ser carregado no boot.
    - No armanezamento, ele está "guardado";
    - Na RAM, ele está "em uso";
    - Na CPU, suas instruções estão sendo efetivamente executadas.

## O computador

### O que acontece quando apertamos o botão de ligar?

O computador começa a receber e estabilizar energia nos componentes. A placa-mãe, a fonte e outros circuitos entram em funcionamento, e a CPU passa a procurar sua instrução inicial de execução.

- O que liga primeiro?
    - A energia é estabilizada;
    - A CPU começa a executar;
    - O firmware testa e identifica componentes;
    - Ela procura um dispositivo de boot;
    - O bootloader carrega;
    - O bootloader carrega o kernel;
    - O kernel assume e sobe o sistema.

### Qual é a diferença entre ligar o computador e iniciar o SO?
Alguém precisa:
    - Inicializar minimamente o hardware;
    - Verificar se há memória e dispositivos básicos;
    - Localizar de onde virá o sistema operacional;
    - Transferir esse sistema para a memória.
Quem faz esse papel inicial é o firmware, junto com o processo de boot.

Ligar o computador é fornecer energia e iniciar os circuitos básicos. Iniciar o SO é uma etapa posterior, quando o firmware e o processo de boot já localizaram e carregam o sistema.

### Por que o SO não é a primeira coisa a ser executada?

Pois o firmware e a bios precisam inicializar, testar e configurar os componentes de hardware para assim então conseguir ler o dispositivo de boot e inicializar o SO.

### O que é firmware?

Firmware é um software de baixo nível gravado em um hardware (chip físico), geralmente em memória ROM ou flash. Ele é responsável por controlar funções básicas do dispositivo, como inicialização do hardware e comunicação com outros componentes e softwares do sistema, o software em questão sendo a BIOS/UEFI.

### Qual é a diferença entre BIOS e UEFI?

UEFI (Unified Extensible Firmware Interface) é o firmware moderno que substitui a BIOS tradicional, oferecendo uma interface gráfica mais amigável, opções de segurança (como o Secure Boot) e inicialização mais rápida. Enquanto a BIOS é limitada a 16 bits e a discos de até 2 TB, a UEFI opera em 32 ou 64 bits e oferece suporte a discos com mais de 2 TB.

### O que é POST?

POST é uma sigla que significa "Power-On Self-Test", é a primeira etapa da inicialização do computador feita pelo firmware onde o mesmo verifica o funcionamento dos componentes essenciais de hardware, essa é uma etapa feita não pela imagem do monitor mas por luzes e sons vindos da própria placa-mãe.

### O que o computador testa quando liga?

Processador, Memoria RAM, placa de vídeo, discos e a própria placa-mãe.

### Por que o computador procura um dispositivo de boot?

Pois é nele onde está localizado o sistema operacional do seu computador.

### O que faz um disco ser bootável?

Ter um sistema operacional instalado no disco, SSD ou ate mesmo pen-drive.

### O que acontece se não houver dispositivo de boot?

A BIOS/UEFI aciona uma mensagem de erro informando que não foi possivel encontrar um dispositivo de boot, outras situações que podem ocorrer são: uma tela preta após a tela de BIOS, o computador pode ficar preso na tela de BIOS ou o computador pode entrar em um loop de busca por um dispositivo bootavel.

### O que é bootloader?

Bootloader é o software que inicializa o kernel e por sua vez, o sistema operacional de sua máquina, em Linux é comum a utilização do GRUB, que é um sistema unificado de boot, como seu bootloader, o GRUB é especialmente util pois ele facilita situações de dual-boot ou para a escolha de versões de Linux quando há mais de uma versão do mesmo SO Linux no computador.

### Quando o kernel entra em execução e o que acontece quando ele carrega?

Logo após a BIOS/UEFI detectar o drive bootavel e inicia-lo. Quando o kernel do SO é inicializado ele inicia os serviços do sistema operacional, como gerenciamento de memória, detecção de hardware e inicialização do sistema de gerenciamento de arquivos.

### Como a interface gráfica aparece depois da inicialização?

É nesse momento em que o sistema operacional de sua escolha aparece em seu monitor da maneira que você está acostumado!

## Unix

### Por que Unix foi tão influente?

O Unix foi criado para ser um sistema operacional unificado, ou seja, que consegue rodar em qualquer máquina independente de hardware, essa padronização feita pelo o Unix permitiu que o desenvolvimento de programas fosse o mesmo para todos os sistemas, o Unix é a base em que sistemas operacionais tais como o Linux e o iOS foram desenvolvidos.

### O Linux é Unix?

O Linux na verdade foi feito na base do Minix, uma versão modificada do Unix feita para fins educativos. O Linux pode sim ser considerado Unix mas ele acabou virando muito mais que isso com o passar do tempo!

### O que significa Unix-like?

Unix-like significa que o sistema operacional em questão foi feito sob a base do Unix ou suas variações. Isso significa que o SO em questão possuir um sistema de arquivos estruturado de forma hierarquica, uma interface de linha de comando - CLI (Que permite a interação do usuário com o SO e qualquer programa instalado nele através de texto), capacidade de gerenciamento de multiplos usuários além de seguir a ideia de que "tudo é um arquivo".

### O que significa a filosofia Unix?

A filosofia Unix segue a linha de que todo programa precisa ser feito para ser pequeno, modular e servir uma única funcionalidade e que funciona com outros programas desenvolvidos da mesma maneira, unidos através de linhas de texto.

## Windows

### O que muda entre Windows e Linux se ambos fazem o papel de SO?

O Windows já vem com uma serie de programas escolhidos pela Microsoft ao instalar o sistema operacional (Pense em algo como a Interface Gráfica, Windows Media Player, Exibidor de imagens, Windows Defender, Copilot), enquanto sistemas Linux vem apenas com o Kernel e o sistema operacional, sendo que qualquer outro programa adicional deve ser instalado pelo próprio usuário, ou seja, o sistema operacional pode ser customizado para ser da forma que você quiser. 
Outra diferença é a capacidade de analisar e modificar o código do kernel e dos proprios sistemas operacionais, por ser um SO proprietário o Windows não dá essa liberdade ao usuário enquanto o Linux, por ser um kernel que utiliza a licensa GNU, dá essa liberdade.

### O Windows tem kernel?

Sim, o Windows possui um kernel, o Windows NT, ele é um kernel proprietário da Microsoft e não foi construido tendo o Unix como base, ou seja, não utiliza de seu kernel ou de sua filosofia.

### O Windows usa terminal também?

De certa forma sim, o Windows possui um emulador de terminal com o nome "Windows Terminal" e nele você pode usar o prompt de commando e o Windows Powershell, que não são exatamente terminais mas são interpretadores de linhas de comando.

### Por que a maioria dos programas comerciais são feitos primeiro para Windows?

O Windows é considerado padrão pelo mercado consumidor e é o sistema operacional mais utilizado do mundo, tendo isso em mente é comum que aplicações comerciais são desenvolvidas primeiro para Windows.

### O que o Windows esconde do usuário que o Linux costuma expôr mais?

O Windows, principalmente o Windows 11, é conhecido por instalar programas que por muitos podem ser considerados indesejados ou desnecessários, também chamados de bloatware, também há receios por parte de alguns usuários quanto a questão de privacidade e segurança de dados no Windows, principalmente com o maior foco da Microsoft em inteligência artificial através do Co-pilot, que utiliza dados de uso e navegação do Windows de seus usuários para treinar o Co-pilot.

## Linux

### Linux é sistema operacional ou kernel?

O sistema operacional GNU/Linux é comumente referido apenas como Linux. No entanto, Linux é apenas o kernel (núcleo) do sistema operacional, responsável por atuar como intermediário entre o hardware e os softwares. O sistema completo normalmente inclui ferramentas do projeto GNU, por isso o nome GNU/Linux.

### O que é uma distribuição Linux?

Distribuição Linux, ou “distro”, é um sistema operacional completo construído com ferramentas do projeto GNU e utilizando o kernel Linux como núcleo.

### Por que existem tantas distribuições?

O motivo de existirem tantas distribuições é que o GNU oferece um vasto conjunto de softwares livres e de código aberto, permitindo que diferentes pessoas criem seus próprios sistemas operacionais conforme suas necessidades.

### O que muda de uma distro para outra?

As diferenças entre as distribuições Linux vêm das escolhas de softwares e ferramentas do projeto GNU, o que pode influenciar até mesmo a filosofia da distribuição. Entre os principais pontos que diferenciam uma distro da outra estão: o gerenciador de pacotes (como os softwares são instalados e atualizados), os repositórios (quantidade e versão dos programas disponíveis) e as ferramentas de configuração que já vêm pré-instaladas.

### O Linux precisa de interface gráfica?

Não, o Linux não precisa de interface gráfica (GUI) para funcionar. A base do sistema é operada via linha de comando (terminal)

### Dá pra usar Linux só pelo terminal?

Sim, é perfeitamente possível utilizar o Linux exclusivamente pelo terminal (CLI - Command Line Interface), sendo esta uma prática comum em servidores e por usuários avançados. O terminal oferece controle total, automação e rapidez, permitindo gerenciar arquivos, instalar softwares e configurar o sistema sem interface gráfica. 

### Linux é mais difícil ou só dá mais controle ao usuário?

O Linux oferece muito mais controle e customização ao usuário, mas isso vem com o preço de uma curva de aprendizado mais íngreme.

### Como Linux é seguro?

Por ser um sistema de código aberto, o Linux tem seu código constantemente revisado por muitos desenvolvedores. Isso permite que falhas de segurança sejam rapidamente identificadas e corrigidas, tornando-o mais seguro do que o Windows, por exemplo.

### Qual é a diferença entre software livre e open-source?

Software livre é baseado na ética e na filosofia das quatro liberdades: executar o programa livremente, estudar e modificar seu código-fonte, redistribuir o software e distribuir versões modificadas. Para ser considerado livre, um software deve ser de código aberto (open source), garantindo que essas liberdades sejam efetivamente possíveis.

## Dual Boot

### Como dois SOs podem coexistir no mesmo computador?

Dois sistemas operacionais podem coexistir em um mesmo computador ao particionar um disco rígido (HD ou SSD, por exemplo) e instalar cada sistema operacional em uma partição separada.

### Eles rodam ao mesmo tempo?

Pelo método de partições, dois sistemas operacionais não rodam simultaneamente; porém, é possível executá-los ao mesmo tempo através de técnicas de virtualização (ambientes virtuais), permitindo, por exemplo, criar uma máquina virtual Linux dentro do Windows usando o VirtualBox.
  
### Como o computador sabe qual sistema iniciar?

Ao ligar o PC, a BIOS/UEFI realiza um teste de verificação chamado POST (Power-On Self-Test) e procura o dispositivo de armazenamento (SSD ou HD) que contém as instruções de inicialização. Em seguida, a BIOS/UEFI transfere o controle para um bootloader (como o GRUB no Linux), que é um software responsável por carregar o sistema operacional. No caso de existir dois sistemas operacionais (dual boot), o bootloader oferece a opção de escolha para o usuário.

### O que é partição?

Uma partição é a divisão lógica de um disco rígido físico (HD ou SSD) em segmentos menores e independentes

### O que pode dar errado instalando dual boot?

O dual boot é uma prática comum, mas é altamente recomendável fazer backup dos arquivos antes, já que a criação de partições envolve risco de perda de dados. Um erro clássico é particionar o disco de forma incorreta e acabar formatando acidentalmente uma partição com arquivos importantes.

### O que é GRUB?

O GNU GRUB (GRand Unified Bootloader) é o gerenciador de inicialização padrão da maioria das distribuições Linux.

### O que acontece se o bootloader for sobrescrito?

Voçê perde acesso ao sistema operacional, pois não consegue inicializa-lo.

### Dual boot é melhor do que máquina virtual?

A escolha entre dual boot e máquina virtual (VM) depende do seu objetivo e hardware. Use dual boot para desempenho máximo e uso nativo. Escolha máquina virtual para testes seguros, conveniência de rodar dois sistemas simultaneamente e facilidade de uso sem alterar partições.

## BIOS/UEFI e Secure Boot

### O que é UEFI e por que substituiu a BIOS tradicional?

A UEFI (Unified Extensible Firmware Interface) é um firmware moderno que desempenha as mesmas funções da BIOS, mas oferece uma alternativa mais rápida, segura e compatível com sistemas atuais.

### O que é firmware?

É um software gravado em um hardware(chip físico).

### BIOS/UEFI fica no disco?

Não, a BIOS/UEFI fica gravada no chip de memória não volátil na placa-mãe.

### O que é Secure Boot?

Secure Boot é um recurso de inicialização que garante que o sistema operacional só carregue softwares confiáveis, devidamente assinados pelo fabricante.

### O Secure Boot impede Linux?

O secure boot não impede o linux por si, só se o sistema for inicializado com softwares que não foram devidamente assinados.

### Por que alguns sistemas são aceitos e outros não?

Os sistemas aceitos possuem uma trusted key que permitem a inicialização com secure boot

### O que significa uma chave confiável no processo de boot?

Uma chave confiável (ou trusted key) no processo de boot, especificamente no contexto do Secure Boot (Inicialização Segura) UEFI, é uma assinatura digital criptográfica armazenada no firmware do computador (BIOS/UEFI) que atua como um "selo de aprovação" para softwares

## Interface Gráfica

### Linux tem "área de trabalho" igual ao Windows?

Muitas distribuições Linux oferecem área de trabalho com janelas, painel, menu de aplicativos, pastas e ícones. A diferença é que no Linux, existem vários ambientes gráficos, então a aparência e a organização podem variar mais.

### Se Linux tem interface gráfica, por que falam tanto do terminal?

No Linux, o terminal tem um papel muito importante para administração, automação, aprendizado e controle do sistema. A interface existe e é útil mas o terminal permite fazer muita coisa de forma mais precisa e poderosa.

### Interfaces gráficas são programas?

Sim, elas são conjuntos de programas que formam o ambiente visual do sistema.

### Posso trocar a interface gráfica sem trocar o Linux?

Pode! Você pode manter a mesma distribuição Linux e trocar o ambiente gráfico.

### Quando eu clico em um ícone, o que realmente acontece por trás?

O clique gera um evento. A interface gráfica interpreta esse evento, identifica o que deve ser feito e então pede ao sistema para executar a ação, como abrir um programa ou mover um arquivo.

### Por que servidores não costumam usar interface gráfica?

Porque economiza recursos, reduz complexidade e geralmente não é necessário. Em servidores, costuma ser mais eficiente administrar tudo por terminal.

### A interface gráfica do Linux é instalada separadamente?

Em muitas distribuições, sim. Algumas já vêm com interface gráfica ponta, outras permitem instalar depois.

### O mouse e as janelas fazem parte do sistema operacional ou da interface gráfica?

Eles fazem parte da experiência fornecida principalmente pela interface gráfica, embora dependam do sistema operacional e dos drivers para funcionar.

### O que acontece se a interface gráfica travar? O sistema inteiro trava junto?

Não necessariamente. Às vezes, só o ambiente gráfico trava, e o restante do sistema continua funcionando.

### O login visual faz parte da interface gráfica?

Sim, normalmente ele faz parte do ambiente gráfico ou do gerenciador de login gráfico.

### Dá pra abrir programas gráficos pelo terminal?

Dá. Você pode digitar o nome do programa no terminal e ele abrirá a interface gráfica, se o programa for gráfico.

## Terminal

### Terminal e prompt são a mesma coisa?

Não. O terminal é o ambiente onde você digita e executa comandos, enquanto o prompt é o indicador visual em texto que aparece dentro do terminal para sinalizar que ele está pronto para receber um novo comando.

### O que é shell?

Shell é o interpretador de comandos. Quando você digita um comando no terminal, ele o interpreta e aciona o programa ou o kernel correspondente, que é responsável por se comunicar diretamente com o hardware para executar a ação solicitada.

### Terminal e shell são a mesma coisa?

Não. O terminal tem a função de receber os comandos que você digita e exibir os resultados, enquanto o shell tem a função de interpretá-los e executá-los.

### O terminal é uma "linguagem de programação"?

Não exatamente. Você digita comandos, não "programa" necessariamente. Mas shells também podem ser usados para criar scripts, que já entram em algo próximo de programação.

### Tudo no Linux precisa ser feito pelo terminal?

Não! As distribuições vêm com suas próprias interfaces gráficas, como GNOME, KDE e XFCE. No entanto, o uso do terminal é aconselhado para tarefas mais avançadas e administrativas.

### O terminal é mais difícil ou só menos familiar?

O terminal oferece mais controle, eficiência e rapidez, sendo ideal para tarefas administrativas. No entanto, isso vem com um custo: uma curva de aprendizado maior.

### O que acontece quando eu digito um comando?

O terminal recebe o comando, o shell o interpreta e aciona o programa ou o kernel correspondente, que por sua vez interage com o hardware para executar a ação solicitada.
 
### Como o sistema sabe o que significa `ls` ou `cd`?

A shell identifica o comando e sabe lidar com ele apropiadamente.

### Onde os comandos ficam guardados?

Alguns comandos são parte da própria shell, os chamados built-ins, como o cd. Já outros são programas externos — arquivos binários executáveis armazenados em diretórios do sistema, como o ls, que fica em /usr/bin.

### O terminal fala direto com o kernel?

 Não. O terminal apenas recebe a entrada dos comandos. Quem de fato aciona o kernel para executar uma ação é o shell.
 
### Posso quebrar o sistema usando o terminal?

Com certeza! Existem várias formas de fazer isso. Você pode, por exemplo, remover acidentalmente arquivos essenciais para o sistema, como arquivos dentro do diretório /boot, que armazena arquivos essenciais para a inicialização do sistema operacional. Caso esses arquivos sejam comprometidos, você pode perder completamente o acesso ao sistema.

### Por que alguns comandos precisam de `sudo`?

No Linux, cada usuário possui um nível de permissão que define o que ele pode ou não fazer no sistema. Um usuário comum, por padrão, tem permissões limitadas justamente para proteger o sistema de alterações acidentais ou não autorizadas. O sudo funciona como um crachá temporário — ao utilizá-lo antes de um comando, suas permissões são elevadas às de um superusuário, também conhecido como root, que é o usuário com acesso total ao sistema. Isso permite executar ações administrativas que um usuário comum não teria permissão de realizar, como instalar programas, modificar arquivos do sistema ou gerenciar outros usuários.

### O que é Bash?

O Bash é um dos tipos de shell e, na verdade, o mais utilizado. Para facilitar o entendimento, pense no shell como a espécie "cachorro" — existem várias raças, e o Bash seria uma delas. Assim como existem outros shells, como o Zsh e o Fish, o Bash é simplesmente a "raça" mais popular e amplamente adotada, sendo o shell padrão da maioria das distribuições Linux.

### O terminal do Linux e o CMD do Windows são equivalentes?

São parecidos, mas diferentes em filosofia e capacidades. O terminal Linux segue a filosofia de que tudo é um arquivo — programas, processos e até hardware — e isso concede ao usuário um enorme poder e flexibilidade. O Windows, por sua vez, foi desenvolvido com foco na interface gráfica, e o CMD é apenas um complemento dessa experiência, possuindo capacidades bem mais limitadas em comparação ao terminal do Linux.

### O PowerShell é parecido com o terminal do Linux?

O PowerShell foi desenvolvido justamente para superar as limitações do CMD, sendo uma ferramenta muito mais próxima e parecida com o terminal do Linux. No entanto, ainda existem diferenças, sendo a principal delas a filosófica: enquanto no Linux tudo é tratado como um arquivo — programas, processos e até hardware —, no PowerShell tudo é tratado como um objeto.

### Como cancelar um comando que está rodando?

CTRL + C

### O terminal só serve para programadores?

Não! O terminal é para qualquer usuário que deseje ter mais controle sobre o seu sistema. Imagine que você não seja um programador, mas queira customizar o sistema do seu jeito — o terminal é para você. Por exemplo, é possível personalizar graficamente o ambiente de trabalho de formas que interfaces gráficas convencionais não permitem, como ajustar temas, ícones e animações do sistema de maneira mais precisa e granular. Além disso, usuários que rodam videogames no Linux podem utilizar o terminal para otimizar o desempenho do sistema, seja ajustando o escalonador de CPU, configurando o driver de GPU ou gerenciando ferramentas como o GameMode, que aloca mais recursos do sistema para o jogo em execução.

### Existe diferença entre digitar um comando e executar um programa?

Na prática não! No Linux tudo é um arquivo — incluindo os próprios comandos. Quando você digita um comando, você está essencialmente dizendo ao Shell "encontre e execute esse arquivo pra mim."


## Filesystem

### O que significa "tudo é arquivo"?

No Linux, "tudo é um arquivo" não é apenas uma expressão — é a filosofia central do sistema. Literalmente tudo é representado como um arquivo: programas, configurações, processos, dispositivos de hardware como o teclado e o mouse, partições do disco, conexões de rede e até a memória RAM. Cada um desses elementos possui um arquivo correspondente em algum lugar do sistema de arquivos. Isso é poderoso porque significa que você pode interagir, ler e até modificar qualquer componente do sistema da mesma forma — abrindo, lendo ou escrevendo em arquivos, geralmente através do terminal.

### Filesystem é só um monte de pastas?

Não apenas isso! O filesystem é um sistema organizado, elaborado e padronizado que vai muito além de simples pastas. Ele define onde cada componente do sistema, programa e arquivo de configuração deve estar armazenado, permitindo que tanto o sistema quanto o usuário saibam exatamente onde encontrar cada elemento. Uma característica marcante do Linux é que grande parte das configurações do sistema são armazenadas em arquivos de texto simples, o que facilita a edição e personalização diretamente pelo terminal. Tudo isso segue um padrão bem definido, chamado FHS — Filesystem Hierarchy Standard —, que estabelece a estrutura de diretórios adotada pela maioria das distribuições Linux.

### Qual é a diferença entre filesystem e armanezamento?

O filesystem é a camada lógica responsável pela organização e padronização dos arquivos no sistema — ele define a estrutura, a hierarquia e as regras de como os arquivos são armazenados e acessados. Já o armazenamento é o hardware físico onde tudo de fato reside, como um HD ou SSD. Em outras palavras, o filesystem é o como os arquivos são organizados, enquanto o armazenamento é o onde eles ficam guardados.

### O filesystem existe no disco ou no sistema operacional?

Os dois estão profundamente relacionados. O filesystem é gravado fisicamente no disco, mas é o sistema operacional que o interpreta e o torna acessível. Ao mesmo tempo, o próprio sistema operacional reside dentro do filesystem — tornando os dois interdependentes.

### O que significa dizer que tudo começa em `/`?

O / é o diretório raiz do sistema, também chamado de root. Ele é o ponto de origem de todo o filesystem — todos os outros diretórios, arquivos, dispositivos e configurações partem dele. É como o tronco de uma árvore: tudo o mais são galhos que se ramificam a partir desse ponto central.

### Por que Linux não usa `C:` e `D:` como o Windows?

No Windows, cada disco ou partição recebe uma letra — como C: ou D: — o que é uma herança direta do MS-DOS, seu sistema operacional ancestral. No Linux, no entanto, a filosofia é diferente: seguindo o princípio de que tudo é um arquivo, os discos e partições não recebem letras, mas sim pontos de montagem dentro do filesystem. Por exemplo, um disco adicional pode ser montado em /mnt/disco e acessado como qualquer outro diretório. Tudo parte do / e os dispositivos de armazenamento são simplesmente integrados a essa hierarquia, sem a necessidade de identificadores separados.

### O que é a raiz do sistema?

A raiz do sistema é a origem — o ponto a partir do qual partem todas as ramificações do filesystem. Representada pelo /, ela é o diretório mais alto da hierarquia, do qual todos os outros diretórios e arquivos se ramificam.

### `/` e `/root` são a mesma coisa?

Não, e é importante não confundir os dois! O / é a raiz do sistema — o ponto de origem de todo o filesystem, do qual tudo parte. Já o /root é o diretório pessoal do superusuário, o root. Por ser uma conta com acesso total ao sistema, seu diretório fica separado dos diretórios dos usuários comuns, que residem em /home.

### O que é `/home`?

O /home é o diretório onde residem as pastas pessoais de cada usuário do sistema. Cada usuário possui seu próprio subdiretório dentro do /home — por exemplo, /home/joao —, onde são armazenados seus arquivos pessoais, como documentos, imagens e downloads. Além disso, é lá que ficam guardadas as configurações pessoais de cada usuário, como preferências de programas e personalizações do ambiente, que variam de usuário para usuário.

### Por que cada pasta do Linux parece ter uma função específica?

Porque cada uma tem mesmo! Isso é resultado do FHS (Filesystem Hierarchy Standard), o padrão que define a função de cada diretório no Linux. Por exemplo, o /bin armazena os programas e comandos essenciais do sistema, o /proc guarda informações sobre os processos em andamento, o /dev é onde o sistema interage com os dispositivos de hardware, e o /home contém os diretórios pessoais dos usuários. Essa padronização garante que qualquer usuário ou programa saiba exatamente onde encontrar cada componente, independentemente da distribuição Linux utilizada.

### Quem decidiu essa organização das pastas?

Essa organização foi definida pela comunidade Linux através do FHS (Filesystem Hierarchy Standard), um padrão criado coletivamente com o objetivo de garantir que as diferentes distribuições Linux organizem seus arquivos de forma consistente. Isso significa que, independentemente de você estar usando Ubuntu, Fedora ou qualquer outra distribuição, a estrutura de diretórios seguirá as mesmas convenções.

### O que acontece se eu apagar alguma pasta importante do sistema?

Você pode quebrar o seu sistema! Apagou /home -> perdeu arquivos pessoais. Apagou /boot -> sistema não vai mais inicializar.

### Um diretório é um arquivo?

Sim, tudo é um arquivo! Mas o diretório é um arquivo especial no qual seus dados são referencias para arquivos e outros diretórios.

### Dispositivos também aparecem como arquivos?

 Sim! O diretório /dev é o diretório onde se encontra todos os dispositivos conectados.
 
### Qual é a diferença entre arquivo, pasta, diretório e partição?

Um arquivo é a unidade de dados, a pasta/diretório é a estrutura organizadoa e a partição é a divisão lógica de um disco.

### Um disco e um filesystem são a mesma coisa?

Não. O disco é o dispositivo, o filesystem é a organização usada dentro dele.

### Posso ter vários filesystems no mesmo computador?

Sim. Você pode ter vários discos, partições e tipos de filesystems.

### O que acontece quando eu salvo um arquivo?

### O arquivo fica "dentro" da pasta mesmo?

### Como o sistema sabe onde o arquivo está no disco?

### O que acontece quando eu deleto um arquivo?

Normalmente, o sistema remove a referência para ele e marca o espaço como disponível, sem apagar imediatamente todos os dados físicos.

### Arquivo apagado some na hora?

Logicamente, sim. Fisicamente, os dados podem continuar até serem sobrescritos.

### O filesystem é igual em todas as distribuições Linux?

A lógica geral é muito parecida, mas podem existir diferenças de organização e do tipo de filesystem usado.

### O Windows também tem filesystem?

Todo sistema operacional precisa de algum sistema de arquivos.

### O Linux reconhece pen-drive e HD externo dentro desse mesmo sistema de pastas?

Sim, eles podem ser montados em algum ponto da árvore do sistema.

### O que significa montar um disco dentro do sistema?

Significa ligar aquele dispositivo ou partição a um diretório da árvore do sistema para torná-lo acessível.

### O que fica em `/etc`?

Arquivos de configuração do sistema.

### O que fica em `/var`?

Dados variáveis, como logs, cache e filas.

### O que fica em `/usr`?

Muitos programas, bibliotecas e recursos usados pelo sistema e pelos usuários.

### O que fica em `/bin`?

Historicamente para guardar executáveis essenciais do sistema.

## Caminhos Absolutos e Relativos

### O que é um caminho?

É a forma de indicar a localização de um arquivo ou diretório na árvore do sistema.

### Por que preciso aprender isso?

Quase tudo no terminal e boa parte da lógica do sistema depende de saber localizar arquivos e diretórios corretamente.

### Qual é a diferença entre caminho absoluto e relativo?

O absoluto começa da raiz `/`. O relativo depende do diretório atual.

### Como sei se um caminho é absoluto ou relativo?

Se começa com `/`, é absoluto. Se não, normalmente é relativo.

### O que é o diretório atual?

É o lugar da árvore em que sua sessão do terminal está naquele momento.

### Como descubro em que diretório estou?

Com o comando `pwd`

### O que significam `.` e `..`?

`.` = diretório atual
`..` = diretório pai

### O que acontece se eu usar um caminho relativo no lugar errado?

O sistema vai procurar no contexto errado e provavelmente dará erro ou encontrará outra coisa.

### Quando é melhor usar um caminho absoluto?

Quando você quer precisão total e não quer depender do diretório atual.

### Quando é melhor usar um caminho relativo?

Quando você está trabalhando dentro de um contexto local e quer praticidade.

### Um comando pode aceitar os dois tipos de caminho?

Sim, muitos comandos aceitam os dois.

### Caminho é a mesma coisa que endereço de arquivo?

Na prática, sim. É uma forma de localizar o arquivo no sistema.

### Um atalho e um caminho são a mesma coisa?

Não. Um atalho ou link aponta para algo, um caminho descreve a localização.

### Por que alguns caminhos só funcionam com permissão de administrador?

Porque o usuário comum pode não ter permissão para acessar certos diretórios ou arquivos.

### Caminho relativo serve para economizar escrita ou tem outra utilidade?

Também serve para trabalhar com contexto local, tornar comando e script mais flexíveis em certas situações.

### Posso misturar `..` com nomes de pastas no mesmo caminho?

Pode! `../aulas/aula1.md`

## Shell, Bashscript, Ferramentas e Comandos

### O que são variáveis de ambiente?

São valores guardados que o sistema e programas utilizam.
Exemplos: $USER, $PATH, $HOME

### Como funcionam os redirecionamentos?

Você redireciona algo de um output para um arquivo.
Exemplos: cat arquivo.txt > arquivo2.txt - Tudo mostrado pelo cat sera sobrescrito em arquivo2.txt.

">" -> para sobrescrever.

">>" -> para adicionar ao arquivo.

"<" -> para sobrescrever esse arquivo com algo de outro arquivo.

"<<" -> para adcionar à esse arquivo algo de outro arquivo.

"2>" -> apra sobrescrever o arquivo com o erro do comando.

"2>>" -> para adcionar ao arquivo o erro do comando.

### O que é o stdin, stdout, stderr?
São como "canais" de comunicação.
Exemplo: Quando você digita o comando "ls" vai para o stdin (0), o resultado de ls vai para o stdout (1) e se der erro vai para o stderr (2).

### Como funciona o grep?

Ele funciona como um filtro, conseguindo ler arquivos somente com a parte do texto que te interesse.
Exemplo: grep a Nomes.txt -> ele vai te da um output de todos os nomes que contenham a letra a

### Como o Pipe funciona?

Ele conecta comandos, o output do primeiro é a entrada do segundo.
Exemplo: cat arquivo.txt | grep a -> o grep vai agir no output do cat arquivo.txt.

### Quais são os comandos comuns que servem de ferramentas de processamento?

Eles são:

`cat`: Ele é utilizado para exibir o conteúdo de um arquivo no terminal e para concatenar dois ou mais arquivos em um só. 

Ex: `cat notas.txt` para exibir ou `cat notas.txt notas2.txt > notasJuntas.txt`

`less`: É utilizado para abrir o arquivo porém de forma interativa, melhor para arquivos longos que podem ocupar grande espaço no terminal. Em um arquivo aberto dessa maneira os comandos mais úteis são `/` para pesquisar dentro do arquivo, as setas do seu teclado para navegar por linha e `q` quando quiser sair. 

Ex: `less log.txt`

`grep`: É utilizado para vasculhar seus arquivos em busca do termo especificado. 

Ex: como discutido acima, um comando como `grep b listaAlunos.txt` vai retornar todos os alunos que contenham "b" no nome, se escrevermos `grep "error" log.txt` teremos o retorno de toda vez que a palavra error ocorrer no nosso log.

`wc`: Serve para contar o número de elementos dentro de seu arquivo.

Ex: `wc redacao.txt` retorna o número de linhas, palavras e bytes do arquivo nessa ordem.

`head`: Mostra as 10 primeiras linhas de um arquivo.

Ex: `head arquivo.txt`

`tail`: Mostra as 10 últimas linha de um arquivo.

Ex: `tail arquivo.txt`

`cut`: É usado para extrair partes especificas do seu arquivo.

Ex: Em `cut -d ":" -f 1 /etc/passwd` você terá retorno da coluna de nomes de usuários da tabela encontrada no arquivo /etc/passwd (`-d` é o delimitador, ou seja, define qual o caractere separador, e -f define qual coluna você quer extrair)

`sort`: Ele ordena as linhas do seu arquivo alfabeticamente ou numericamente.

Ex: `sort arquivo.txt`
