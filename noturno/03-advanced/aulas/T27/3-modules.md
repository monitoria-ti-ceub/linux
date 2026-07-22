# Drivers e Módulos Essenciais

A seleção de drivers e módulos no `menuconfig` é o ponto de falha mais comum. Um erro na seleção não resultará em um erro de compilação, o kernel compilará. O erro vai ser manifestado durante o processo de inicialização (boot).

## O Ovo e a Galinha

O kernel inicializa a CPU, configura a memória virtual e detecta os barramentos de hardware básicos (como o barramento PCI). O objetivo desta fase de inicialização do kernel é montar o sistema de arquivos raiz (root filesystem). O sistema de arquivos raiz (montado no diretório `/`) contém os binários do espaço de usuário (como o `/sbin/init` ou o shell do BusyBox) que o kernel precisa executar para dar continuidade ao processo de boot.

Mas é aqui que surge o paradoxo arquitetural:

1. Para ler o sistema de arquivos raiz, o kernel precisa saber como se comunicar com a controladora de disco (ex: uma controladora SATA AHCI ou um controlador NVMe).
2. Para entender a estrutura lógica dos dados no disco, o kernel precisa conhecer o formato do sistema de arquivos (ex: `ext4`).
3. Se o driver da controladora de disco ou o driver do sistema de arquivos foram compilados como módulos (`m`), eles estão no disco rígido, dentro do próprio sistema de arquivos raiz.
4. O kernel não consegue ler o disco para carregar o módulo que ensinar ele a ler o disco.
