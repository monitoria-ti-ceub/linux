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
