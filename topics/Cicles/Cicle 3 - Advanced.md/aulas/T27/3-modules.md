# Drivers e Módulos Essenciais

A seleção de drivers e módulos no `menuconfig` é o ponto de falha mais comum. Um erro na seleção não resultará em um erro de compilação, o kernel compilará. O erro vai ser manifestado durante o processo de inicialização (boot).

## O Ovo e a Galinha

O kernel inicializa a CPU, configura a memória virtual e detecta os barramentos de hardware básicos (como o barramento PCI). O objetivo desta fase de inicialização do kernel é montar o sistema de arquivos raiz (root filesystem). O sistema de arquivos raiz (montado no diretório `/`) contém os binários do espaço de usuário (como o `/sbin/init` ou o shell do BusyBox) que o kernel precisa executar para dar continuidade ao processo de boot.

Mas é aqui que surge o paradoxo arquitetural:

1. Para ler o sistema de arquivos raiz, o kernel precisa saber como se comunicar com a controladora de disco (ex: uma controladora SATA AHCI ou um controlador NVMe).
2. Para entender a estrutura lógica dos dados no disco, o kernel precisa conhecer o formato do sistema de arquivos (ex: `ext4`).
3. Se o driver da controladora de disco ou o driver do sistema de arquivos foram compilados como módulos (`m`), eles estão no disco rígido, dentro do próprio sistema de arquivos raiz.
4. O kernel não consegue ler o disco para carregar o módulo que ensinar ele a ler o disco.

É o problema do ovo e da galinha, que resulta em uma falha fatal de inicialização. A mensagem de erro será:
`Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)`

**Regra de Ouro do Boot**: Todo o código, drivers e subsistemas que são necessários para o kernel acessar o disco físico e montar o sistema de arquivos raiz primário **PRECISAM SER COMPILADOS ESTATICAMENTE DENTRO DO KERNEL (opção `y`/Built-In)**. Eles não podem ser compilados como módulos (`m`), a menos que uma infraestrutura de `initramfs` (Initial RAM Filesystem) seja utilizada.

## Drivers Essenciais no `menuconfig`

É obrigatório fazer a verificação manual para garantir que as opções específicas estejam configuradas com um asterisco (`*` ou `y`) e não com `m`.

### Filesystems

O kernel precisa entender a formatação lógica do disco onde a distribuição residirá.

- **`CONFIG_EXT4_FS=y`**
    - Caminho: `File systems ---> <*> The Extended 4 (ext4) filesystem`
    - O `ext4` é o sistema de arquivos padrão no ecossistema Linux. É muito provável que a partição raiz da nova distribuição seja formatada em `ext4`. Se a opção for omitida ou modularizada, o kernel não conseguirá interpretar a estrutura de diretórios da partição.

- **`CONFIG_SQUASHFS=y`**
    - Caminho: `File systems ---> Miscellaneous filesystems ---> <*> SquashFS 4.0 - Squashed file system support`
    - O SquashFS é um sistema de arquivos compactado e read-only. Ele é fundamental para criar imagens Live CD/USB (como o instalador do Ubuntu). O sistema de arquivos inteiro da sua distribuição será compactado em um único arquivo SquashFS para caber na imagem ISO. O kernel precisa saber ler esse formato nativamente durante o boot do Live CD.

- **`CONFIG_OVERLAY_FS=y`**
    - Caminho: `File systems ---> <*> Overlay filesystem support`
    - Trabalha em conjunto com o SquashFS. Como o SquashFS é read-only, o sistema não conseguiria operar pois processos precisam escrever arquivos temporários e logs). O OverlayFS resolve isso criando uma camada transparente de escrita (na memória RAM via `tmpfs`) sobreposta à camada de leitura do SquashFS.

- **`CONFIG_FAT_FS=y` e `CONFIG_VFAT_FS=y`**
    - Caminho: `File systems ---> DOS/FAT/NT Filesystems ---> <*> VFAT (Windows-95) fs support`
    - Em sistemas baseados em UEFI, o bootloader (GRUB) e o próprio kernel residem em uma partição especial chamada EFI System Partition (ESP). O padrão UEFI exige que esta partição seja formatada em FAT32. O kernel precisa de suporte para VFAT para ler e interagir com esta partição.

### Controladoras de Armazenamento e Dispositivos de Bloco

O kernel precisa saber como se comunicar eletricamente com os barramentos em que os discos estão conectados.

- **`CONFIG_BLK_DEV_SD=y`
	- Caminho: `Device Drivers ---> SCSI device support ---> <*> SCSI disk support`
	- No Linux, quase todos os dispositivos de armazenamento em bloco (discos rígidos SATA, pen-drives USB, discos virtuais em QEMU) são tratados através da camada de abstração SCSI. O driver genérico de disco SCSI (`sd`) é responsável por expor esses dispositivos como nós no diretório `/dev/`. Sem essa opção, nenhum disco aparece no sistema.
-  **`CONFIG_SATA_AHCI=y`**
	- Caminho: `Device Drivers ---> Serial ATA and Parallel ATA drivers (libata) ---> <*> AHCI SATA support`
	- O Advanced Host Controller Interface (AHCI) é o padrão de hardware para controladoras de discos SATA. Se o computador tiver um disco rígido tradicional (HDD) ou um SSD SATA de 2.5 polegadas, esse é o driver que faz a comunicação. Se for modularizado, o kernel não enxergará o disco SATA durante o boot.
- **`CONFIG_BLK_DEV_NVME=y`**
	- Caminho: `Device Drivers ---> NVME Support ---> <*> NVM Express block device`
	- Se os commputadores utilizam SSDs do tipo M.2 NVMe, o driver AHCI/SATA não tem efeito. Os SSDs NVMe conectam-se no barramento pCIe e utilizam o protocolo NVM Express. Esse driver é obrigatório para dar boot de um disco NVMe.
- **`CONFIG_USB_STORAGE=y`**
	- Caminho: `Device Drivers ---> USB support ---> <*> USB Mass Storage support`
	- Se o objetivo é criar uma distribuição que possa ser inicializada de um pen-drive USB (Live USB), o kernel precisa ser capaz de tratar dispositivos USB como discos de armazenamento de bloco durante os primeiros segundos do boot.

### Pseudo-Sistemas

Os pseudo-sistemas de arquivos não armazenam dados persistentes em discos. Eles são interfaces virtuais mantidas na memória RAM que expõem estruturas de dados internas do kernel para os programas no espaço de usuário. Sem eles, as ferramentas de administração do sistema são.. cegas.

- **`CONFIG_PROC_FS=y`**
	- Caminho: `File systems ---> Pseudo filesystems ---> <*> /proc file system support`
	- O `/proc/` é o mecanismo  primário de introspecção do kernel. Cada processo em execução no sistema tem um diretório numérico correspondente em `/proc/`. Ferramentas como `ps`, `top`, `htop` e `kkil` leem arquivos dentro desse pseudo-sistema de arquivos para descobrir quais processos estão rodando e quanta memória estão consumindo.
- **`CONFIG_SYSFS=y`**
	- Caminho: `File systems ---> Pseudo filesystems ---> <*> sysfs file system support`
	- O `/sys/` expõe a árvore de hardware detectada pelo kernel. Ele mostra como os parramentos PCI, dispositivos USB e CPUs estão interconectados. Ferramentas de gerenciamento de dispositivos dependem do `sysfs` para saber quando um novo hardware é conectado ou desconectado.
- **`CONFIG_DEVTMPFS=y`**
	- Caminho: `Device Drivers ---> Generic Driver Options ---> <*> Maintain a devtmpfs filesystem to mount at /dev`
	- As distribuições Linux mantinham milhares de arquivos estáticos no `/dev/` para representar todos os hardwares possíveis. O `devtmpfs` modernizou isso. Quando essa opção está ativada. o próprio kernel gerencia um sistema de arquivos temporário na RAM e cria os nós de dispositivo automaticamente no exato momento em que o hardware é detectado, antes mesmo do espaço de usuário ser iniciado. É crucial para sistemas minimalistas.

### Formatos de Executáveis

O  kernel precisa saber como interpretar e executar os programas compilados.

- **`CONFIG_BINFMT_ELF=y`**
	- Caminho: `Executable file formats ---> <*> Kernel support for ELF binaries`
	- O Executable and Linkable Format (ELF) é o formato padrão da indústria para binários executáveis, arquivos objeto e bibliotecas compartilhadas em sistemas Unix-like. Se essa opção for desativada, o kernel não conseguirá executar nenhum programa, nem o `ls`.
- **`CONFIG_BINFMT_SCRIPT=y`**
	- Caminho: `Executable file formats ---> <*> Kernel support for ELF binaries`
	- Permite que o kernel reconheça a shebang na primeira linha de arquivos de texto e execute com o interpretador específico. Sem isso, os scripts de inicialização não funcionarão.

## A Filosofia da Modularização

Se todas essas opções devem ser embutidas (`y`), o que vai ser configurado como módulo (`m`)?

A modularização é reservada para hardware periférico, hardware não-essencial para o boot e recursos de rede avançados. Como:

- Drivers de placas de vídeo proprietárias (Nvidia, AMD)
- Drivers de placas de rede Wi-Fi (como Intel iwlwifi ou Realtek)
- Drivers de Bluetooth e som (ALSA/HDA)
- Suporte para sistemas de arquivos secundários (como NTFS ou Btrfs, desde que não sejam usados para a partição raiz)
- Protocolos de rede obscuros ou filtros de firewall complexos (módulo do iptables)

Tendo esses componentes como módulos, o kernel base (o arquivo `vmlinuz`) é pequeno (entre 8MB e 15MB), carregando rápido na memória enquanto a imensa bibliotec de módulos `.ko` descansa no disco rígido, sendo acionada sob demanda.
