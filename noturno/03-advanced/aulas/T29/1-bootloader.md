# Bootloader e Inicialização Customizada

Nós temos o Kernel  (`bzImage`). Nós temos o Root Filesystem (pasta da distribuição). Eles são arquivos jogados em uma pasta do seu computador. Se você colocar esses arquivos em um pen-drive e colocar em um computador, nada vai acontecer. O computador não sabe o que fazer com eles.


**Sequência de Boot:**
1. Energia: A eletricidade flui da fonte para a Placa-Mãe
2. BIOS/UEFI: Um chip de memória na Placa-Mãe (ROM) acorda. Ele contém um programa primitivo (BIOS/UEFI). A BIOS faz o POST (Power-On Self Test) para ver se a memória RAM e a CPU estão vivas.
3. Buscar o Bootloader:A BIOS é boba. Ela não entende o que é um Kernel Linux ou um Windows. Ela só sabe fazer uma coisa: procurar o primeiro setor do primeiro disco rígido ou pen-drive, ler os primeiros 512 bytes de dados (MBR - Master Boot Record) e executar o que estiver lá.
4. Bootloader: Nesses 512 bytes, instalamos um programa chamado Bootloader (GRUB). O trabalho do Bootloader é entender o sistema de arquivos do disco, achar o arquivo `bzImage`, copiar ele do disco para a memória RAM e dizer: "YOOOO CPU!!!! O Kernel tá na RAM, executa ele."
5. Kernel: O Kernel assume o controle absoluto, ele detecta os mouses, teclados, placas de rede.
6. RootFS: O Kernel precisa da pasta `/sbin/init` para passar o controle para o usuário.

O GRUB é a ponte entre o firmware bobo e o Kernel inteligente. Sem ele, o firmware não sabe onde o Kernel está, logo, o Kernel nunca "acorda".

Olhem a etapa 6: "O kernel precisa da pasta `/sbin/init` para passar o controle pro espaço de usuário."

Esse `/sbin/init` tá no disco rídigo. O Kernel precisa do driver SATA (`ahci.ko`) ou do driver USB (`usb-storage.ko`) para ler o disco rígido. Eles tão dentro da pasta `/lib/modules/`
... que tá dentro do disco rídigo.

É o paradoxo do ovo e da galinha. Mas! A solução para esse paradoxo é a invenção mais engenhosa do processo de boot do Linux: Initramfs (Initial RAM Filesystem).

## InitramFS

O Initramfs é um Root Filesystem minúsculo, temporário e descartável. Ele contém apenas o mínimo para sobreviver: o BusyBox, o script `init` e os módulos `.ko` dos drivers de disco.

Em vez de ser gravado no disco rídigo, o Initramfs é compactado em um arquivo `.cpio.gz`.
Quando o Bootloader (GRUB) copia o Kernel para a RAM, ele também copia o arquivo do Initramfs para a RAM.

O fluxo:

1. Kernel acorda na RAM.
2. Kernel vê o Initramfs na RAM.
3. Kernel descompacta o cpio direto na memória, criando um filesystem virtual (ramfs).
4. Kernel executa `/init` de dentro da RAM.
5. O script `/init` (usando BusyBox) carrega os módulos `.ko` (também na RAM).
6. Kernel sabe ler o disco de verdade.
7. O script monta o disco real numa pasta temporária.
8. `switch_root`: joga o Initramfs fora da RAM, transofrma o disco de verdade na nova raiz `/`.

Nós compilamos o kernel com `defconfig`, que embute os drivers de disco (virtio, AHCI) e o driver de ext4 diretamente no kernel. Então, o paradoxo não existe no nosso caso, o kernel já sabe ler o disco sem precisar de módulos externos. Então.. não precisa de initramfs para bootar do disco virtual! O kernel monta `/dev/sda1` direto.

## BIOS

A BIOS é limitada:

1. Faz o POST.
2. Procura um dispositivo de boot (disco, pen-drive).
3. Lê os primeiros 512 bytes do disco (MBR - Master Boot Record).
4. Carrega esses 512 bytes pro endereço de memória `0x7C00` e executa.

O problema central é que dos 512 bytes, 64 são reservados pra tabela de partições. Sobram 446 bytes de código executável. Então, não cabe um programa que entende ext4, navega por diretórios e acha um arquivo `vmlinuz` espalhado pelo disco.

O GRUB resolve este problema através de uma arquitetura de múltiplos estágios (Multi-stage Bootloader):

- **Estágio 1 (`boot.img`):** Este é o código minúsculo de 446 bytes que o instalador do GRUB grava no MBR. A sua única função é localizar e carregar o próximo estágio. Ele não entende sistemas de arquivos, ele carrega setores brutos do disco baseados em endereços físicos (LBA - Logical Block Addressing) gravados nele (hardcoded) durante a instalação.
- **Estágio 1.5 (`core.img`):** Este estágio é gravado no "espaço não alocado" (MBR gap) que existe entre o MBR (setor 0) e o início da primeira partição (setor 2048.. usually). Este espaço tem cerca de 1 MB, o que é o suficiente para conter drivers mínimos de sistema de arquivos (ex.: um driver `ext4` minúsculo).
- **Estágio 2 (`/boot/grub/`):** O Estágio 1.5, capaz de ler o sistema de arquivos, navega até a partição `/boot`, lê os arquivos de configuração (`grub.cfg`) e carrega o kernel + `initramfs` na memória.

## UEFI

O UEFI eliminou a restrição do MBR de 512 bytes e estágios complexos e hardcoded. O firmware UEFI é quase que um mini sistema operacional.

1. O UEFI faz a inicialização do hardware.
2. O UEFI busca por uma partição no disco formatada em FAT32, a **EFI System Partition (ESP)**.
3. O UEFI tem drivers nativos para ler o sistema de arquivos FAT32.
4. O firmware lê as variáveis de configuração interna (armazenadas na NVRAM da placa-mãe) para determinar qual aplicativo EFI (`.efi`) deve executar.
5. O UEFI carrega o aplicativo (no caso do GRUB, é o arquivo `grubx64.efi`) da ESP para a memória e executa ele.

A instalação do GRUB é mais limpa. Não há gravação em setores escondidos do disco. O instalador copia o arquivo `grubx64.efi` para a partição ESP e registra o seu caminho na NVRAM da placa-mãe utilizando a ferramenta `efibootmgr`. O arquivo `grubx64.efi` já tem os drivers de sistema necessários para localizar a partição `/boot` principal e ler o `grub.cfg`.

## A Estrutura do GRUB

Seja o método do boot (BIOS ou UEFI), o principal diretório de operação do GRUB no sistema de arquivos é o `/boot/grub/`. É o diretório com os componentes dinâmicos do bootloader.

- **`grub.cfg`:** O arquivo de configuração principal. Este arquivo tem a lógica do menu, a definição de cores, a ordem de boot e as entradas específicas (menuentries) que definem o caminho para o kernel e seus parâmetros.
- **`grubenv`:** Um pequeno bloco de dados de 1024 bytes utilizado pelo GRUB para armazenar variáveis de estado persistentes entre reinicializações (ex.: qual foi o último sistema operacional que foi selecionado pelo usuário).
- **Subdiretório de Arquitetura (`1386-pc/` (BIOS), `x86_64-efi/` (UEFI)):** O diretório mais importante. Ele contém dezenas de módulos compilados dinamicamente (`.mod`). O GRUB 2 foi projetado com uma arquitetura modular. Em vez de um executável monolítico imenso, o GRUB carrega módulos sob demanda. Se o usuário quiser ler uma partição formatada em Btrfs, o GRUB carrega o módulo `btrfs.mod`. Se quiser exibir uma imagem de fundo em JPEG, carrega o módulo `jpeg.mod`.

## A Instalação do GRUB

A ferramenta utilizada para implantar o bootloader é o comando `grub-install`.

O `grub-install` é um script complexo que orquestra o processo de implantação. Ele não é o bootloader, é a ferramenta que instala ele.



## FAQ

1. Quando eu rodo o QEMU, ele para na tela preta com a mensagem 'VFS: Unable to mount root fs'. O que deu errado?

- É o erro mais comum. Significa que o Kernel acordou mas não conseguiu achar ou ler o Initramfs.
Você digitou errado o nome do arquivo no `grub.cfg`?
O GRUB não encontrou o arquivo porque você não copiou ele para a pasta `iso_staging/boot/`?
Você compilou o Kernel sem suporte a `initramfs`?

2. O boot funciona mas ele trava na mensagem 'Aguardando o pen-drive USB ser detectado' e depois dá erro no `switch_root`. Por que?

- O Initramfs funcionou mas o script `/init` não conseguiu achar a ISO (o CD-ROM virtual do QEMU) para montar o arquivo SquashFS.
O Kernel foi compilado sem o driver de CD-ROM (`CONFIG_BLK_DEV_SR=y` ou `m`) ou sem o driver do sistema de arquivos ISO9660 (`CONFIG_ISO9660_FS=y`)?
O QEMU nomeou o CD-ROM virtual de um jeito diferente? Para debugar, altere o script `/init` para rodar `/bin/sh` antes do comando de `mount` para que você possa olhar a pasta `/dev/` manualmente.

3. Por que usamos SquashFS? Não seria mais fácil colocar os arquivos soltos na ISO?

- Uma ISO normal não é projetada para rodar um sistema operacional inteiro de forma rápida. O SquashFS tem duas vantagens:
Compressão. O Kernel descompacta os blocos do SquashFS diretamente e na memória RAM em tempo real. Ler dados descompactados da RAM é 1000 vezes mais rápido do que ler arquivos soltos de um pen-drive.
OverlayFS. Como o SquashFS é imutável, usaremos o OverlayFS para colocar uma camada de RAM transparente por cima dele. Você poderá instalar programas e modificar arquivos com o sistema rodando. Se fossem arquivos soltos na ISO (que é Read-Only por natureza), o sistema daria erro ao tentar criar um simples arquivo de log.
:
4. O que é o parâmetro `quiet` na linha do Kernel no GRUB?

- O Kernel é tagarela. Durante o boot, ele imprime centenas de linhas de log técnico sobre cada chip de hardware que ele encontra. A flag `quiet` diz ao Kernel: Lil'bro, só mostre mensagens se houver um erro fatal. Deixa o boot mais limpo visualmente, que nem o boot do Windows ou do macOS que escondem o texto atrás da logo. Se o sistema não estiver ligando, a primeira coisa a fazer é tirar o `quiet` do `grub.cfg` para ver onde o Kernel está travando.

5. Por que `exec switch_root` em vez de chamar o `/sbin/init` diretamente?

- Se o script `/init` do Initramfs chamasse `/mnt/real_root/sbin/init`, o novo `init` rodaria como um "filho" do script atual (PID 2 ou 3). O script do Initramfs continuaria rodando na memória RAM como PID 1 para sempre e toda a memória RAM ocupada pelo Initramfs ficaria bloqueada e desperdiçada.
O comando `exec` (Execute and Replace) é magia. Ele substitui a alma do processo atual pela alma do novo programa. O `switch_root` faz a faxina (apaga o Initramfs da RAM) e então usa o `exec` para que o `/sbin/init` real assuma o PID 1, sem deixar rastros. É a transição perfeita.
