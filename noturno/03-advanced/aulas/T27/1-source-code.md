# Compilação do Kernel

O kernel Linux é o núcleo do sistema operacional, atuando como o intermediário primário entre o hardware físico do computador e os processos de software em execução (espaço de usuário).

## O Vanilla Kernel

"Vanilla Kernel" refere-se ao código-fonte original, inalterado e oficial do kernel Linux, mantido por Linus Torvalds e pela comunidade de desenvolvedores. Este código é hospedado e distribuído atráves de `kernel.org`. A importância de utilizar o Vanilla Kernel reside na sua pureza. Distribuições comerciais como Ubuntu, Red Hat Enterprise Linux (RHEL) ou SUSE aplicam um zilhão de patches (modificações) ao código original.

Compilar o Vanilla Kernel é ter a garantia de estar trabalhando com o código base universal, sem as idiossincracias ou dependências ou dependências ocultas.

```bash
# obtenção do código-fonte
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.1.70.tar.xz
tar -xvf linux-6.1.70.tar.xz
cd linux-6.1.70
```

A escolha da versão é crítica. O ciclo de desenvolvimento do kernel adota um modelo de lançamentos frequentes. As versões "Mainline" representam o estado do desenvolvimento com os recursos mais recentes mas com um risco inerente de instabilidade.
Para a construição de uma distribuição estável, a recomendação é usar uma versão LTS (Long Term Support). As versões LTS são selecionadas anualmente e recebem backports de correções de segurança e bugs críticos por um período que varia de dois a seis anos, providenciando uma base sólida e previsível para o sistema operacional.

### Anatomia do Código

O repositório do kernel Linux é um dos projetos de software colaborativo mais complexos da história da computação. São mais de 30 milhões de linhas de código, a maioria sendo escritas em C, com segmentos críticos de otimização e inicialização de baixo nível escritos em Assembly. A organização é modular e hierárquica.

Ao extrair o tarball, o diretório raiz apresenta uma série de subdiretórios, cada um responsável por um subsistema lógico do kernel.

#### `arch/` (Arquitetura)
O Linux é renomado por sua portabilidade, sendo capaz de operar em várias arquiteturas de processadores, desde microcontroladores embarcados até supercomputadores de arquitetura mainframe. O diretório `arch/` contém o código que depende da arquitetura de hardware subjacente. Todo o código genérico do kernel, agnóstico em relação à CPU, está fora deste diretório. Dentro de `arch/`, encontram-se subdiretórios para cada arquitetura suportada, como `x86/`, `arm/` e `arm64/`, etc.

O código dentro de `arch/x86/`, por exemplo, contém as instruções específicas para lidar com a inibialização do processador em modo real e a transição para o modo protegido, a configuração das tabelas de paginação da unidade de gerenciamento de memória (MMU) específicas da arquitetura x86 e o tratamento de interrupções de hardware (IRQs) através do Advanced Programmable Interrupt Controller (APIC). Quando a compilação do kernel é iniciada, o sistema de build (Kbuild) seleciona o subdiretório correspondente à arquitetura alvo, ignorando os demais.

#### `drivers/`
É o maior diretório em termos de volume de código e número de arquivos. Ele contém os device drivers, são os módulos de software responsáveis por instruir o kernel sobre como interagir e controlar o hardware físico. O ecossistema de hardware de computadores é vasto e fragmentado, com milhares de fabricantes produzindo placas de vídeo, controladores de rede, interfaces USB, dispositivos de armazenamento e periféricos de entrada. O kernel Linux adota uma arquitetura monolítica, ou seja, a maioria desses drivers é compilada diretamente no kernel ou fornecida como módulos carregáveis dinamicamente, em vez de operar no espaço de usuário (como em arquiteturas de microkernel).

Dentro de `drivers/`, a organização é categorizada pelo tipo de dispositivo.

- `drivers/gpu/`: Contém os drivers do Direct Rendering Manager (DRM) para placas de vídeo AMD, Intel e Nvidia.
- `drivers/net/`: Abriga os drivers para interfaces de rede Ethernet e sem fio (Wi-Fi).
- `drivers/usb/`: Contém o código do subsistema USB e drivers para controladores de host e dispositivos USB específicos.
- `drivers/block/` e `drivers/scsi/`: Gerenciam dispositivos de armazenamento em bloco, como discos rígidos SATA e SSDs NVMe.

#### `fs/`
O kernel Linux não interage com o armazenamento de dados através de blocos brutos em sua operação normal: ele utiliza o conceito de Filesystems para organizar, armazenar e recuperar dados de forma estruturada. Este diretório contém as implementações lógicas de dezenas de sistemas de arquivos diferentes.

O Linux têm uma camada de abstração chamada Virtual File System (VFS). O VFS fornece uma interface unificada, com chamadas de sistema como `open()`, `read()`, `write()`, para os programas no espaço de usuário, independentemente do arquivo estar armazenado em um disco formatado em `ext4`, em um pen-drive formatado em `FAT32` ou em um servidor remoto acessado via `NFS`.

As implementações específicas:

- `fs/ext4/`: O sistema de arquivos padrão e mais utilizado em distribuições.
- `fs/btrfs/`: Um sistema de arquivos avançado com suporte para snapshots e copy-on-write.
- `fs/fat/`: Suporte para sistemas de arquivos da Microsoft, crucial para a leitura da partição EFI (ESP) durante o boot em sistemas UEFI.
- `fs/proc/` e `fs/sysfs/`: Implementações de pseudo-sistemas de arquivos que não existem em disco mas residem na memória RAM, expondo informações internas do kernel e do hardware para o espaço de usuário.

#### `kernel/`
Este diretório tem o núcleo fundamental do sistema operacional. O cérebro do kernel. Aqui, há implementações dos mecanismos centrais que definem um sistema operacional mmultitarefa e preemptivo. O código é agnóstico em relação à arquitetura de hardware, lidando com abstrações de alto nível.

Componentes críticos:
- Scheduler: Agendados de Processos. O código responsável por decidir qual processo no espaço de usuário recebe tempo de execução na CPU, implementando algoritmos como o Completely Fair Scheduler (CFS).
- Signals: Gerenciamento de Sinais. O mecanismo de comunicação interprocessos (IPC) que permite o envio de notificações assíncronas (como SIGKILL ou SIGTERM) para processos.
- Timers: Gerenciamento de Tempo. A infraestrutura para contagem de tempo, alarmes e eventos agendados de alta precisão.
- Locking: Sincronização e Bloqueio. Implementações de mutexes, spinlocks e semáforos, essenciais para evitar race conditions (condições de corrida) em um kernel concorrente e multiprocessado (SMP).

#### `mm/`
O subsistema de gerenciamento de memória (Memory Management) é um dos componentes mais complexos do kernel. Este diretório contém o código independente de arquitetura que gerencia a alocação e liberação da memória RAM física e a implementação da memória virtual.

O kernel Linux não permite que processos de um usuário acessem a memória física diretamente. Em vez disso, cada processo opera em seu próprio espaço de endereçamento virtual isolado. O código neste diretório gerencia a tradução desses endereços virtuais em endereços físicos através de tabelas de paginação. Além disso, ele implementa mecanismos como:

- Demand Paging: A alocação de memória física apenas no momento exato em que o processo tenta acessar ela.
- Swapping: A movimentação de páginas de memória inativas da RAM para o disco rígido quando o sistema enfrenta pressão de memória.
- Page Cache: A utilização agressiva da RAM livre para armazenar dados lidos recentemente do disco em cache, acelerando as operações de I/O.

#### `net/`
O Linux é o sistema operacional dominante na infraestrutura de servidores e roteadores globais devido (em grande parte) à robustez e eficiência de sua pilha de rede. Este diretório contém a implementação dos protocolos de comunicação de rede.

Ao contrário dos drivers de placas de rede (que estão em `drivers/net/` e lidam com a transmissão de sinais elétricos ou de rádio), o diretório `net/` lida com a lógica de software dos protocolos. Há implementações completas das pilhas IPv4 e IPv6, o controle de congestionamento e montagem de pacotes do protocolo TCP, a transmissão datagrama do UDP e funcionalidades avançadas de roteamento, filtragem de pacotes (Netfilter/iptables) e qualidade de serviço (QoS).

#### Outros Diretórios Importantes

`include/`: Contém os arquivos de cabeçalho (headers) de C (arquivos `.h`. Estes arquivos definem as estruturas de dados, macros e protótipos de funções que são compartilhados entre os diferentes subsistemas do kernel. Uma subpasta crítica é `include/uapi/`, que contém os cabeçalhos que definem a interface de chamadas de sistema (syscalls) exportada para o espaço de usuário. Estes são os arquivos que a biblioteca C (como glibc ou msl) utiliza para interagir com o kernel).

`scripts/`: Contém scripts utilitários em Bash, Perl e Python utilizados pelo sistema de build (Kbuild) durante o processo de configuração e compilação do kernel.

- `lib/`: Contém implementações de funções de biblioteca genéricas (como manipulação de strings, compressão zlib, cálculos de CRC) que o kernel utiliza internamente, uma vez que o kernel não pode depender da biblioteca C padrão do espaço de usuário.

## FAQ

1. O meu Kernel demorou 2 horas para compilar, o do meu colega demorou 15 minutos.. POR QUE?

- A compilação é um processo CPU-Bound (limitado pelo processador) e I/O-Bound (limitado pela velocidade do disco). Se o seu colega tem um processador de 16 núcleos e usou `make -j16`, o trabalho foi dividido em 16 paralelos. Se você tem um processador de 2 núcleos e usou `make-j2`, você tem 8 vezes menos força de trabalho. Além disso, se o colega tem um SSD NVMe e você tem um HDD magnético, a leitura/escrita dos milhões de arquivos gerados atrasa o processo.

2. O que vai acontecer se eu errar no `menuconfig` e esquecer de marcar o supporte para USB como `Y`?

O PC não vai explodir. O processo de compilação vai terminar com sucesso e você terá um `bzImage` perfeito. O problema vai estar no Tópico 29, quando você tentar dar boot na sua ISO. O Kernel vai ligar mas como ele não sabe o que é uma porta USB, ele não vai conseguir ler o pen-drive onde o resto do sistema operacional está gravado. Ele vai parar na tela preta com um erro.. `Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)`. A solução é voltar no `menuconfig`, arrumar a opção e compilar de novo.

3. Um guri na internet compilou o Kernel usando `make bzImage`. Nós usamos `make`. Qual é a diferença?

Antes do Kernel 2.6, o comando `make` compilava a base (apenas) e você precisava digitar `make bzImage` para gerar o arquivo compactado, `make modules` para gerar os arquivos `.ko`. Nos Kernels modernos, os desenvolvedores unificaram tudo. Digitar apenas `make` ou `make -j($nproc)` é um atalho que diz ao sistema de build: "Faz tudo. Gera o bzImage e compile os módulos". O resultado é idêntico.

4. `vmlinux` é a mesma coisa que `vmlinuz`?

Não! O `vmlinux` é o Kernel bruto, descomprimido e cheio de Símbolos de Debug (informações inúteis para o boot mas úteis para encontrar erros no código). Ele é gigante e nunca usamos ele para dar boot no computador. O sistema de build pega essa monstruosidade, limpa os símbolos inúteis, compacta com um algoritmo de compressão pesada e gera o `bzImage` (que será renomeado para `vmlinuz`.

5. Por que não podemos baixar o arquivo `bzImage` pronto em vez de compilar?

A essência é o controle arquitetural. Se você baixa um binário pronto, você é refém das escolhas de quem compilou. Quem garante que o criador ativou o suporte pro OverlayFS que precisamos? Quem garante que ele não colocou um módulo malicioso de backdoor? Compilar o código-fonte é ter soberania sobre o que entra e o que não entra no nosso sistema operacional. É a diferença entre comprar um carro pronto e construir o motor peça por peça.

6. Quais são os riscos de instabilidade ao não escolher uma versão LTS do kernel?

- Bugs em drivers que causam kernel panic
Um driver de dispositivo recebeu código novo na versão mainline que ainda não foi testado em todas as combinações de hardware. No seu hardware específico, esse código novo causa um acesso inválido à memória. O kernel detecta que algo catastrófico aconteceu e para tudo, um kernel panic. A tela congela, o texto de erro aparece e o sistema precisa ser reiniciado na força. É o equivalente da tela azul do Windows.

- Regressões de performance
Uma otimização nova no scheduler (componente que decide qual processo roda em qual CPU) introduziu um bug: em máquinas com mais de 4 cores, o sistema fica 30% mais lento em certas cargas de trabalho. Ninguém percebeu nos testes porque os desenvolvedores testaram em máquinas com 2 cores. Seu sistema funciona mas tá inexplicavelmente lento. É uma regressão, algo que funcionava bem antes e funciona pior agora.

- Incompatibilidade com módulos/software existente
O kernel mudou uma interface interna (API/ABI do kernel). Um módulo que você compilou na versão anterior simplesmente não carrega mais. Dá erro de "symbol not found" ou "version magic mismatch". Seu hardware para de funcionar até alguém atualizar o módulo para a nova API.

- Filesystem corruption
Um bug no código do filesystem pode escrever dados corrompidos no disco. Você não percebe no momento, o sistema parece funcionar. Mas, de repente, os arquivos estão corrompidos, o sistema não boota mais ou dados somem. É raro mas acontece em código novo que não teve meses de teste em produção.

- Comportamento inconsistente entre boots
Um race condition no código de inicialização faz com que, em 1 a cada 10 boots, um serviço não inicie corretamente ou um dispositivo não seja detectado. Funiona na maioria das vezes mas nem sempre e é muito difícil de diagnosticar.
