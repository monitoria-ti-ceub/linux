## **27. Compilação do Kernel Linux**

O kernel é a única parte do sistema operacional que tem acesso direto e irrestrito ao hardware. Ele gerencia a memória, escalona os processos na CPU, controla a rede e fala com os discos rígidos. Todo o resto (shell, comandos, interface gráfica) são apenas "espaço de usuário" (user space) pedindo favores ao kernel atráves de chamadas de sistema (syscalls).

Usar um kernel pré-compilado de outra distribuição (como Ubuntu) carrega consigo milhares de drivers e configurações que você não precisa, aumentando o tempo de boot, o consumo de memória e a superfície de ataque para falhas de segurança.

O código-fonte oficial (vanilla kernel) reside em kernel.org. Linux Torvalds e milhares de desenvolvedores ao redor do mundo mantêm esse repositório com mais de 30 milhões de linhas de código.

Ao baixar o tarball e extraí-lo, temos uma estrutura complexa mas lógica.

- `arch/`: O Linux roda em dezenas de arquiteturas (x86, ARM, RISC-V, PowerPC). Esta pasta contém o código específico que interage com a CPU. Se você está em um PC "comum", seu foco é `arch/x86/`.
- `drivers/`: Esta é a maior pasta. Contém o código para fazer placas de vídeo, placas de rede, controladores USB e teclados funcionarem.
- `fs/`: Implementações de sistemas de arquivos (ext4, btrfs, fat, ntfs). O kernel precisa saber ler os dados do disco.
- `kernel/`: O núcleo, onde agendamentos de processos (scheduler), sinais e gerenciamento de tempo são implementados.
- `mm/`: Gerenciamento de memória (Memory Management). Como a RAM física é mapeada para memória virtual dos processos.
- `net/`: A pilha de rede. Como os pacotes TCP/IP são montados e desmonstados.

Não podemos rodar `make` e compilar tudo. O kernel suporta milhares de hardwares diferentes. Se você compilasse todos os drivers disponíveis, o arquivo resultante teria gigabytes de tamanho e levaria horas para carregas na RAM.

A compilação é guiadapor um arquivo oculto chamado `.config`, localizado na raiz do código-fonte. Este arquivo contém milhares de diretrizes no formato `CONFIG_NOME_DO_RECURSO=valor`.

Para cada recurso, driver ou subsistema, você tem três opções:

1. `y` (Yes/Built-in): O código será compilado diretamente para dentro do arquivo executável final do kernel (`vmlinuz`). O recurso estará disponível no exato milissegundo em que o kernel for carregado na RAM pelo bootloader

2. `m` (Module): O código será compilado com um arquivo separado, com extensão `.ko` (Kernel Object). Esses arquivos ficarão armazenados no seu disco rígido. O kernel só carregará esse módulo na RAM se detectar o hardware correspondente

3. `n` (No): O código é ignorado pelo compilador.

Criar um `.config` do zero é loucura. O kernel fornece ferramentas integradas (o sistema Kconfig) para gerar e editar essa configuração de forma segura.

- `make defconfig`: O ponto de partida. Gera uma configuração padrão razoável baseada na arquitetura do seu processador. É um kernel genérico, similar ao que distribuições comerciais usam, projetado para rodar em "quase qualquer coisa".
- `make localmodconfig`: A ferramenta secreta dos construtores de distribuições otimizadas. Ela analisa os módulos que estão carregados neste exato momento na máquina onde você está rodando o comando. Em seguida, ela desativa (`n`) todos os drivers no `.config` que não correspondem ao hardware detectado. O resultado é um kernel talhado sob medida para a sua máquina física.
- `make menuconfig`: A interface de edição. Usa a biblioteca `ncurses` para desenhar menus interativos no terminal. É aqui que você passa horas navegando, ativando (`y`), modularizando (`m`) ou desativando (`n`) recursos.

Com o `.config` pronto, precisamos traduzir o código C em código de máquina.

1. Limpeza: Se você errou em uma compilação anterior e quer garantir que nenhum arquivo objeto antigo (`.o`) interfira, executa `make mrproper`. Cuidado: isso apaga o seu `.config`. Se quiser apenas limpar os binários mantendo a configuração, use `make clean`.
2. Compilação: O comando é `make`. No entanto, compilar o kernel é uma das tarefas mais pesadas que um PC pode fazer. Para usar todos os núcleos do seu processador e acelerar o processo, use a flag `-j` (jobs).

```bash
# nproc retorn o número de threads da sua CPU
make -j$(nproc)
```