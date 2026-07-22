# Bootloader e Inicialização Customizada

Nós temos o Kernel  (`bzImage`). Nós temos o Root Filesystem (pasta da distribuição). Eles são arquivos jogados em uma pasta do seu computador. Se você colocar esses arquivos em um pen-drive e colocar em um computador, nada vai acontecer. O computador não sabe o que fazer com eles.

**Sequência de Boot:**
1. Energia: A eletricidade flui da fonte para a Placa-Mãe
2. BIOS/UEFI: Um chip de memória na Placa-Mãe (ROM) acorda. Ele contém um programa primitivo (BIOS/UEFI). A BIOS faz o POST (Power-On Self Test) para ver se a memória RAM e a CPU estão vivas.
3. Buscar o Bootloader:A BIOS é boba. Ela não entende o que é um Kernel Linux ou um Windows. Ela só sabe fazer uma coisa: procurar o primeiro setor do primeiro disco rígido ou pen-drive, ler os primeiros 512 bytes de dados (MBR - Master Boot Record) e executar o que estiver lá.
4. Bootloader: Nesses 512 bytes, instalamos um programa chamado Bootloader (GRUB). O trabalho do Bootloader é entender o sistema de arquivos do disco, achar o arquivo `bzImage`, copiar ele do disco para a memória RAM e dizer: "YOOOO CPU!!!! O Kernel tá na RAM, executa ele."
5. Kernel: O Kernel assume o controle absoluto, ele detecta os mouses, teclados, placas de rede.
6. RootFS: O Kernel precisa da pasta `/sbin/init` para passar o controle para o usuário. Esta pasta está no disco rígido.

...

Tá no disco rídigo. O Kernel precisa do driver SATA (`ahci.ko`) ou do driver USB (`usb-storage.ko`) para ler o disco rígido. Eles tão dentro da pasta `/lib/modules/`
... que tá dentro do disco rídigo.

É o paradoxo do ovo e da galinha. Mas! A solução para esse paradoxo é a invenção mais engenhosa do processo de boot do Linux: Initramfs (Initial RAM Filesystem).

## InitramFS

O Initramfs é um Root Filesystem minúsculo, temporário e descartável. Ele contém apenas o mínimo para sobreviver: o BusyBox, o script `init` e os módulos `.ko` dos drivers de disco.

Em vez de ser gravado no disco rídigo, o Initramfs é compactado em um arquivo `.cpio.gz`.
Quando o Bootloader (GRUB) copia o Kernel para a RAM, ele também copia o arquivo do Initramfs para a RAM.




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

4. O que é o parâmetro `quiet` na linha do Kernel no GRUB?

- O Kernel é tagarela. Durante o boot, ele imprime centenas de linhas de log técnico sobre cada chip de hardware que ele encontra. A flag `quiet` diz ao Kernel: Lil'bro, só mostre mensagens se houver um erro fatal. Deixa o boot mais limpo visualmente, que nem o boot do Windows ou do macOS que escondem o texto atrás da logo. Se o sistema não estiver ligando, a primeira coisa a fazer é tirar o `quiet` do `grub.cfg` para ver onde o Kernel está travando.

5. Por que `exec switch_root` em vez de chamar o `/sbin/init` diretamente?

- Se o script `/init` do Initramfs chamasse `/mnt/real_root/sbin/init`, o novo `init` rodaria como um "filho" do script atual (PID 2 ou 3). O script do Initramfs continuaria rodando na memória RAM como PID 1 para sempre e toda a memória RAM ocupada pelo Initramfs ficaria bloqueada e desperdiçada.
O comando `exec` (Execute and Replace) é magia. Ele substitui a alma do processo atual pela alma do novo programa. O `switch_root` faz a faxina (apaga o Initramfs da RAM) e então usa o `exec` para que o `/sbin/init` real assuma o PID 1, sem deixar rastros. É a transição perfeita.
