# Comandos

> Este arquivo é um mapa operacional: ele reúne os comandos utilizados, na ordem em que a distribuição é construída. Ele não substitui as aulas, que explicam o porquê de cada decisão. Antes de executar um bloco, leiam a seção correspondente da aula.

## 0. Convenções, Variáveis e Segurança

Há três lugares diferentes envolvidos no processo. O **host** é o seu ambiente, onde se compila, o **rootfs** é a pasta que vai virar a distribuição e o **disco virtual** é a imagem que o QEMU usa para bootar.

```
export WORKDIR="$HOME/distro"
export ROOTFS="$WORKDIR/rootfs"
export KERNEL_VERSION="6.18.38"
export KERNEL_SRC="$WORKDIR/linux-$KERNEL_VERSION"
export BUSYBOX_VERSION="1.37.0"
export DISK_IMAGE="$WORKDIR/disk.img"
export MOUNT_POINT="/mnt/distro"

mkdir -p "$WORKDIR" "$ROOTFS"
```

Se o seu rootfs estiver em `~/distro` e não em `~/distro/rootfs`.. não recomendo, mas então use `export ROOTFS="$WORKDIR"`.

## 1. Kernel

### 1.1 Obtenção do Código-Fonte

```
cd "$WORKDIR"
wget "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz"
tar -xvf "linux-${KERNEL_VERSION}.tar.xz"
cd "$KERNEL_SRC"
```

### 1.2 Configurações do Kernel

```
cd "$HOME/distro/sources/
make defconfig
```

### 1.3 Revisão das Configurações do Kernel

```
make menuconfig
```

### 1.4 Compilação do Kernel

```
make -j$(nproc)
```

### 1.5 Usar `~/distro` como o diretório raiz (/)
```
make INSTALL_MOD_PATH=~/distro modules_install
```

### 1.6 Criar `/boot` na estrutura da distribuição

```
mkdir -p ~/distro/boot
```

### 1.7 Copiar a imagem do kernel para o diretório

```
cp arch/x86/boot/bzImage ~/distro/boot/vmlinuz-6.1.70-distro
```

### 8. Copiar o mapa de símbolos para o diretório

```
cp System.map ~/distro/boot/System.map-6.1.70-distro
```

### 9. Copiar do arquivo de configuração para o diretório

```
cp .config ~/distro/boot/config-6.1.70-distro
```

### 10. Instalar os cabeçalhos limpos

```
make INSTALL_HDR_PATH=~/distro/usr headers_install
```

### 11. Variável que aponta para o diretório do código-fonte do kernel ou para o diretório de cabeçalhos configurados

```
KDIR ?= /caminho/absoluto/para/o/codigo/fonte/linux-6.1.70

all:
    make -C $(KDIR) M=$(PWD) modules

clean:
    make -C $(KDIR) M=$(PWD) clean
```

## Bootloader (Tópico 29)

### Pré-Requisitos

```
sudo apt install qemu-system-x86 grub-pc-bin e2fsprogs parted
```

## miau

```
cd ~/distro
```

### 1. Criar disco virtual

```
qemu-img create -f raw disk.img 256M
```

### 2. Particionar

```
printf 'o\nn\np\n1\n\n\na\nw\n' | fdisk disk.img
```

### 3. Montar loop device

```
sudo losetup --find --show --partscan disk.img
```

Vai retornar algo como `/dev/loop0`. Use o retorno como referência para os próximos passos.
Ex.: Se retornar `/dev/loop8`, substitua `loop0` dos próximos comandos para `loop8`.

### 4. Formatar e montar

```
sudo mkfs.ext4 /dev/loop0p1
sudo mkdir -p /mnt/distro
sudo mount /dev/loop0p1 /mnt/distro
```

### 5. Copiar sistema pro disco

```
sudo cp -a rootfs/* /mnt/distro/
sudo mkdir -p /mnt/distro/boot
sudo cp linux-*/arch/x86/boot/bzImage /mnt/distro/boot/vmlinuz
```

### 6. Instalar GRUB

```
sudo grub-install --target=1386-pc --boot-directory=/mnt/distro/boot /dev/loop0
```

### 7. Escrever grub.cfg

```
sudo mkdir -p /mnt/distro/boot/grub
sudo tee /mnt/distro/boot/grub/grub.cfg << 'EOF'
set timeout=5
set default=0

menuentry "Minha Distro" {
    set root=(hd0,msdos1)
    linux /boot/vmlinuz root=/dev/sda1 rw console=ttyS0 panic=5
}

menuentry "Minha Distro (emergency shell)" {
    set root=(hd0,msdos1)
    linux /boot/vmlinuz root=/dev/sda1 rw console=ttyS0 init=/bin/sh
}
EOF
```

### 8. Desmontar

```
sudo umount /mnt/distro
sudo losetup -d /dev/loop0
```

### 9. Bootar

```
qemu-system-x86_64 -drive file=disk.img,format=raw -nographic
```

### 10. Sair do QEMU

`Ctrl + A`, depois `X`.

Se não funcionar: `Ctrl + A`, depois `C` (abre monitor QEMU), digita `quit`, `Enter`.

### Se precisar alterar algo:

```
sudo losetup --find --show --partscan disk.img
sudo mount /dev/loop0p1 /mnt/distro

# edita o que você precisa
sudo vim /mnt/distro/boot/grub/grub.cfg
sudo vim /mnt/distro/etc/init.d/rcS

sudo umount /mnt/distro
sudo losetup -d /dev/loop0
```
