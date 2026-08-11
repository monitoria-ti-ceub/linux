# Compilação (Tópico 27)

## Obtenção do Código-Fonte
```
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.1.70.tar.xz
tar -xvf linux-6.1.70.tar.xz
cd linux-6.1.70
```

## Configurações do Kernel

```
make defconfig
```

## Revisão das Configurações do Kernel

```
make menuconfig
```

## Compilação do Kernel

```
make -j$(nproc)
```


```
make INSTALL_MOD_PATH=~/minha_distro modules_install
```


```
mkdir -p ~/minha_distro/boot
```


```
cp arch/x86/boot/bzImage ~/minha_distro/boot/vmlinuz-6.1.70-minhadistro
```


```
cp System.map ~/minha_distro/boot/System.map-6.1.70-minhadistro
```


```
cp .config ~/minha_distro/boot/config-6.1.70-minhadistro
```

```
make INSTALL_HDR_PATH=~/minha_distro/usr headers_install
```

```
KDIR ?= /caminho/absoluto/para/o/codigo/fonte/linux-6.1.70

all:
    make -C $(KDIR) M=$(PWD) modules

clean:
    make -C $(KDIR) M=$(PWD) clean
```
