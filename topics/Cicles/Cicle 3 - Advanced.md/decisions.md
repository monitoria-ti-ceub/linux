# Mapa de Decisões e Ferramentas do Ciclo III

## Visão Geral

| Camada | Ferramenta | Alternativas que NÃO usaremos | Motivo da Escolha |
| :--- | :--- | :--- | :--- |
| Kernel | Vanilla Kernel (kernel.org) | Kernel do Ubuntu, Kernel Zen | Sem patches de terceiros |
| Utilitários de Usuário | BusyBox (estático) | GNU Coreutils + Bash | Um único binário, sem dependências |
| Biblioteca C | Nenhuma (BusyBox estático) | glibc, musl | BusyBox estático não precisa de libc externa |
| Sistema de Init (PID 1) | BusyBox init | systemd, OpenRC, runit, SysVinit | Configuração em 1 arquivo texto, sem dependências |
| Bootloader | GRUB 2 | Syslinux/ISOLINUX, systemd-boot, LILO | Suporta BIOS + UEFI, padrão da indústria |
| Initramfs | Script manual + cpio | dracut, mkinitcpio, mkinitramfs | Didático |
| Rede (DHCP) | udhcpc (BusyBox) | dhclient, dhcpcd, NetworkManager | Já vem no BusyBox |
| Rede (Configuração) | iproute2 (comando `ip`) | net-tools (ifconfig), NetworkManager | Padrão moderno do kernel |
| DNS | /etc/resolv.conf (manual) | systemd-resolved, dnsmasq, unbound | Arquivo de texto, sem daemon |
| Servidor SSH | Dropbear | OpenSSH | Minúsculo, feito para sistemas embarcados |
| Gerenciador de Pacotes | Script shell customizado (`mypkg`) | apt/dpkg, rpm/dnf, pacman, apk | Didático |
| Filesystem da ISO | SquashFS | erofs, ISO 9660 puro | Compressão extrema, padrão de Live CDs |
| Overlay (Live CD) | OverlayFS (kernel) | AUFS, UnionFS | Nativo do kernel, sem patches |
| Geração da ISO | grub-mkrescue + xorriso | genisoimage, mkisofs | Gera ISO híbrida (BIOS+UEFI) automaticamente |
| Virtualização (Testes) | QEMU | VirtualBox, VMware | Leve, CLI, não precisa de GUI, gratuito |
| Firewall | iptables | nftables, ufw | Mais documentação disponível, sintaxe clássica |
| Editor de Texto (na distro) | vi (BusyBox) | nano, vim | Já vem no BusyBox |
| Compressão | xz, gzip (BusyBox) | zstd, bzip2, lz4 | Já vem no BusyBox |

## Ferramentas que os Alunos Precisam TER INSTALADAS no Ubuntu do Laboratório

```bash
sudo apt update && sudo apt install -y \
    build-essential \
    libncurses-dev \
    bison \
    flex \
    libssl-dev \
    libelf-dev \
    bc \
    cpio \
    wget \
    xorriso \
    grub-pc-bin \
    grub-efi-amd64-bin \
    grub-common \
    mtools \
    squashfs-tools \
    qemu-system-x86
```

| Pacote | Propósito | Tópico |
| :--- | :--- | :--- |
| `build-essential` | GCC (compilador C), make, binutils | 27, 30 |
| `libncurses-dev` | Desenha a tela azul do `menuconfig` | 27 |
| `bison` | Parser generator exigido pelo build do kernel | 27 |
| `flex` | Lexer generator exigido pelo build do kernel | 27 |
| `libssl-dev` | Criptografia para assinatura de módulos do kernel | 27 |
| `libelf-dev` | Manipulação de binários ELF | 27 |
| `bc` | Calculadora usada pelo Makefile do kernel | 27 |
| `cpio` | Empacota o initramfs no formato do kernel | 29 |
| `wget` | Baixa arquivos da internet (código-fonte, BusyBox) | 27, 28, 30 |
| `xorriso` | Gera a imagem ISO bootável | 34 |
| `grub-pc-bin` | Binários do GRUB para boot BIOS (Legacy/MBR) | 29, 34 |
| `grub-efi-amd64-bin` | Binários do GRUB para boot UEFI | 29, 34 |
| `grub-common` | Ferramentas compartilhadas do GRUB (grub-mkrescue) | 29, 34 |
| `mtools` | Manipula imagens FAT (necessário para ISO UEFI) | 34 |
| `squashfs-tools` | Cria o filesystem compactado SquashFS (mksquashfs) | 34 |
| `qemu-system-x86` | Emulador de PC completo para testar a ISO sem reiniciar | 28, 29, 34 |

## Ferramentas que Estarão na Distro

Ferramentas disponíveis quando der boot no sistema.

| Ferramenta | Origem | Função na Distro |
| :--- | :--- | :--- |
| `sh` (ash) | BusyBox | Shell |
| `ls`, `cp`, `mv`, `rm`, `mkdir`, `cat`, `echo` | BusyBox | Utilitários básicos de arquivo |
| `mount`, `umount` | BusyBox | Montar/desmontar discos e partições |
| `vi` | BusyBox | Editor de texto |
| `grep`, `sed`, `awk` | BusyBox | Ferramentas de processamento de texto |
| `wget` | BusyBox | Baixar arquivos da internet |
| `ip` | iproute2 (compilado) | Configuração de rede |
| `udhcpc` | BusyBox | Cliente DHCP (pedir IP ao roteador) |
| `init` | BusyBox | PID 1, gerencia o boot e os serviços |
| `mdev` | BusyBox | Gerenciador de dispositivos (cria /dev/sda, etc.) |
| `switch_root` | BusyBox | Troca a raiz do initramfs para o disco real |
| `dropbear` | Dropbear (compilado) | Servidor SSH (acesso remoto) |
| `iptables` | iptables (compilado) | Firewall |
| `mypkg` | Script shell nosso | Gerenciador de pacotes customizado |

## Decisões por Tópico

### Tópico 27: Compilação do Kernel

**Ferramenta:** Código-fonte do kernel de `kernel.org`

**Versão:** A última versão LTS (Long Term Support).

**Método de configuração:** `make defconfig` seguido de `make menuconfig` para ajustes mínimos.

**O que os alunos DEVEM garantir como `y` (built-in) no menuconfig:**

| Opção | Caminho no menuconfig | Porquê |
| :--- | :--- | :--- |
| Suporte a ext4 | File systems > Ext4 | Nosso rootfs será ext4 |
| Suporte a SquashFS | File systems > Miscellaneous > SquashFS | Para o Live CD ler o filesystem compactado |
| OverlayFS | File systems > Overlay filesystem | Para a camada de escrita do Live CD |
| Suporte a disco SATA/AHCI | Device Drivers > Serial ATA/ATAPI > AHCI | Para ler discos SATA |
| Suporte a NVMe | Device Drivers > NVM Express block device | Para ler SSDs modernos |
| Suporte a USB Storage | Device Drivers > USB > USB Mass Storage | Para ler pendrives |
| Suporte a ISO 9660 | File systems > ISO 9660 | Para o GRUB ler o CD |
| Suporte a FAT/VFAT | File systems > DOS/FAT/VFAT | Para a partição EFI |
| Suporte a loop device | Device Drivers > Block devices > Loopback | Para montar imagens |
| Suporte a tmpfs | File systems > Pseudo filesystems > tmpfs | Para o OverlayFS na RAM |

### Tópico 28: Sistema de Arquivos Raiz

**Ferramenta:** BusyBox

**Versão:** A última estável de `busybox.net` (ex: 1.36.x)

**Método de compilação:** Estático (`make menuconfig` > Settings > Build static binary = YES). Elimina qualquer dependência de bibliotecas externas.

**Ferramenta de teste:** QEMU

O QEMU é um emulador de computador completo. Ele simula um PC inteiro (CPU, RAM, disco, placa de rede) dentro de uma janela do seu Ubuntu. É assim que vocês vão testar a distro sem reiniciar a máquina real.

O comando para testar o kernel + rootfs:
```bash
# cria um disco virtual de 512MB
qemu-img create -f raw disco.img 512M

# formata como ext4 e copia o rootfs para dentro

# dá boot no QEMU usando o kernel compilado e o disco virtual
qemu-system-x86_64 \
    -kernel ~/new_distro/boot/vmlinuz-custom \
    -append "root=/dev/sda rw console=ttyS0" \
    -hda disco.img \
    -nographic
```

O `-nographic` faz o QEMU rodar inteiramente no terminal (sem abrir janela gráfica). O `console=ttyS0` redireciona a saída do kernel para o terminal. Isso é perfeito para laboratórios sem interface gráfica ou via SSH.

### Tópico 29: Bootloader e Initramfs

**Bootloader:** GRUB 2

O GRUB será usado de duas formas:
1. **Na ISO final** (via `grub-mkrescue`): Para que o pendrive/CD dê boot.
2. **No disco instalado** (via `grub-install`): Para quem instalar a distro no HD.

**Initramfs:** Script shell manual + `cpio` + `gzip`

O initramfs é um mini-sistema de arquivos compactado que o kernel descompacta na RAM antes de acessar o disco real. Ele tem:
- O BusyBox (estático)
- Um script `/init` de ~20 linhas
- Os módulos `.ko` necessários para ler o disco (se não foram compilados como built-in)

**Formato:** O kernel exige que o initramfs esteja no formato `newc` do `cpio`, compactado com `gzip`:
```bash
find . -print0 | cpio --null -ov --format=newc | gzip -9 > initramfs.img
```

### Tópico 30: Ferramentas Essenciais

**Decisão:** Adicionar ferramentas que o BusyBox NÃO tem ou que são versões limitadas.

| Ferramenta Extra | Por que adicionar | Como compilar |
| :--- | :--- | :--- |
| Dropbear (SSH) | Acesso remoto à distro | `./configure && make && make install` |
| iproute2 | Comando `ip` completo (o do BusyBox é limitado) | `make && make install` |
| iptables | Firewall | `./configure && make && make install` |
| curl ou wget (real) | Downloads HTTPS (o wget do BusyBox não suporta SSL) | Exige OpenSSL/LibreSSL |

**Método de compilação:** Cross-compilação ou compilação dentro de um `chroot` com BusyBox + musl-gcc (se necessário). Para a oficina, o caminho mais simples é compilar no Ubuntu hospedeiro usando `make DESTDIR=~/new_distro install` para desviar a instalação para o rootfs da distro.

### Tópico 31: Rede e Serviços

**Cliente DHCP:** `udhcpc` (já incluso no BusyBox)

**Configuração de IP:** `ip` (do iproute2 compilado no Tópico 30, ou a versão simplificada do BusyBox)

**DNS:** Arquivo `/etc/resolv.conf` editado manualmente. Sem daemon.

**SSH:** Dropbear

Por que Dropbear e não OpenSSH? O OpenSSH exige a compilação prévia do OpenSSL (que é gigantesco e leva 30+ minutos para compilar) e do zlib. O Dropbear é um servidor SSH completo e seguro que compila em 2 minutos e gera um binário de ~200KB. É o padrão em roteadores e sistemas embarcados.

**Gerenciador de dispositivos:** `mdev` (BusyBox)

O `mdev` é a versão minimalista do `udev` (que o systemd usa). Ele escuta eventos do kernel ("um pendrive foi plugado!") e cria os arquivos em `/dev/` (ex: `/dev/sdb1`) automaticamente. Sem ele, os dispositivos não aparecem.

Para ativar, adicione ao script de boot (`/etc/init.d/rcS`):
```bash
echo /sbin/mdev > /proc/sys/kernel/hotplug
mdev -s
```

### Tópico 32: Gerenciamento de Pacotes

**Ferramenta:** Script shell customizado (escrito pelos alunos)

**Formato do pacote:** `.tar.gz` contendo a árvore de diretórios + arquivo `.PKGINFO` com metadados.

**Banco de dados local:** Diretório `/var/lib/mypkg/` com um arquivo `.list` por pacote instalado (com a lista de arquivos que pertencem àquele pacote).

**Repositório remoto:** Um diretório servido por HTTP (pode ser um GitHub Pages, um servidor Nginx simples, ou até um `python3 -m http.server` rodando no Ubuntu do laboratório).

### Tópico 33: Otimização e Segurança

**Otimização de binários:** `strip` (do Binutils, já instalado com `build-essential`)

**Firewall:** `iptables` (compilado no Tópico 30)

**Tuning do kernel:** `sysctl` (já incluso no BusyBox como `busybox sysctl`)

**Auditoria de permissões:** `find` (BusyBox) para localizar binários SUID

### Tópico 34: Distribuição e Deployment

**Compressão do rootfs:** `mksquashfs` (do pacote `squashfs-tools` no Ubuntu hospedeiro)

**Geração da ISO:** `grub-mkrescue` (do pacote `grub-common`)

**Teste final:** QEMU com boot pela ISO:
```bash
qemu-system-x86_64 -cdrom NewDistro.iso -m 512M
```

**Publicação:** GitHub Releases (upload da ISO + SHA256SUMS)

## Pipeline de Build

```
[Tópico 27] Baixar kernel.org → make defconfig → make menuconfig → make -j$(nproc)
     ↓
     ├── vmlinuz-custom (kernel)
     └── lib/modules/ (módulos .ko)

[Tópico 28] Baixar BusyBox → make menuconfig (static) → make → make install
     ↓
     └── _install/ (bin/, sbin/, usr/ com symlinks)

[Tópico 28] Criar estrutura FHS → Copiar BusyBox → Criar /etc/passwd, /etc/inittab, /etc/init.d/rcS
     ↓
     └── ~/new_distro/ (rootfs completo)

[Tópico 29] Criar pasta initramfs/ → Copiar BusyBox estático → Escrever script /init → Empacotar com cpio+gzip
     ↓
     └── initramfs.img

[Tópico 29] Testar com QEMU: qemu-system-x86_64 -kernel vmlinuz -initrd initramfs.img -append "root=/dev/sda" -hda disco.img
     ↓
     └── (Sistema dá boot? Sim → próximo passo. Não → debugar.)

[Tópico 30] Compilar Dropbear, iproute2, iptables → make DESTDIR=~/new_distro install
     ↓
     └── ~/new_distro/ (rootfs com ferramentas extras)

[Tópico 31] Configurar /etc/resolv.conf, script de rede no rcS, gerar chaves SSH
     ↓
     └── ~/new_distro/ (rootfs com rede funcional)

[Tópico 32] Escrever mypkg.sh (install, remove, list) → Testar empacotando o Dropbear
     ↓
     └── ~/new_distro/usr/bin/mypkg (gerenciador funcional)

[Tópico 33] strip nos binários, configurar iptables no rcS, auditar SUID
     ↓
     └── ~/new_distro/ (rootfs otimizado e seguro)

[Tópico 34] mksquashfs ~/new_distro/ filesystem.squashfs → Montar estrutura ISO → grub-mkrescue → ISO final
     ↓
     └── NewDistro-1.0-x86_64.iso
```

## +Decisões

**Interface Gráfica**
Não é escopo do Ciclo III. Uma GUI exige compilar o servidor X11 (Xorg) ou Wayland, um gerenciador de janelas (como o i3 ou Openbox) e bibliotecas gráficas (GTK, Qt). São dezenas de horas de compilação. Se algum aluno quiser, pode ser um projeto bônus mas não é obrigatório.

**Funcionamento do QEMU no laboratório**
O QEMU precisa de permissões de virtualização (KVM). Se o laboratório não tiver KVM habilitado na BIOS, o QEMU vai rodar em modo de emulação pura (muito mais lento, mas funciona). Alternativa: VirtualBox (mais pesado, mas tem GUI amigável).

**Usar outra distro como hospedeiro (Fedora, Arch)**
Funciona. Os pacotes têm nomes diferentes (`dnf install` em vez de `apt install`) mas as ferramentas são as mesmas. O guia assume Ubuntu porque é o que o laboratório tem.

**Se o kernel não compilar**
99% dos erros de compilação do kernel são por falta de dependências no hospedeiro. O comando `apt install` do início resolve quase tudo. O erro sempre diz qual arquivo `.h` está faltando. Procuraremos qual pacote `-dev` fornece esse arquivo (`apt-file search nome_do_arquivo.h`).

**Duração do Ciclo III**
Se os alunos seguirem o caminho feliz (BusyBox estático, sem compilar glibc, sem GUI), o pipeline completo leva cerca de 2-3 horas de trabalho prático acumulado.
