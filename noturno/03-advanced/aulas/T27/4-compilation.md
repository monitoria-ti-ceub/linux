# Compilação: `make`, `make modules`, `make modules_install`

Após a configuração do arquivo `.config`, a próxima etapa é a fase de compilação (build phase). É a fase de esforço computacional massivo, traduzindo dezenas de milhões de linhas de código em linguagem C e Assembly em intruções de máquina binárias que são compreensivas pelo processador.
O sistema de compilação do kernel, Kbuild, é uma obra de engenharia de software complexa que orquestra a execução do compilador (GCC), do montados (Assembler) e do ligador (Linker) através de uma hierarquia de arquivos `Makefile`.

## A Mecânica do Kbuild e a Ferramenta `make`

O `make` não é um compilador, ele é um utilitário de automação de construção (build automation tool). A sua função é ler arquivos chamados `Makefiles`, que contém regras especificando como derivar um arquivo de destino (target), como um arquivo objeto `.o`, a partir de arquivos de origem, como arquivos `.c` e `.h`. O Kbuild é uma vasta coleção de `Makefiles` distribuídos por todos os subdiretórios do código-fonte do kernel.

Quando o `make` é invocado na raiz do diretório do kernel, uma sequência complexa de eventos é desecadeada:

1. Leitura da Configuração: O Kbuild lê o arquivo `.config` gerado e exporta as variáveis (ex: `CONFIG_EXT4_FS=y`) para o ambiente do `make`.
2. Travessia Recursiva: O `make` invoca instâncias filhas de si mesmo para entrar recursivamente nos subdiretórios principais
3. Compilação: Para cada arquivo em C,o Kbuild chama o GNU Compiler Collection (GCC). O GCC faz a análise léxica, sintática, otimização e geração de código Assembly, que é passado para o montador (GNU Assembler, `as`) para gerar um arquivo objeto relocável (`.o`). Este arquivo contém código de máquina mas ainda não está pronto para ser executado pois as referências de funções em outros arquivos (símbolos externos) ainda não foram resolvidas.
4. Ligação: Após gerar milhares de arquivos `.o`, o Kbuild chama o GNU Linker (`ld`). O linker é responsável por pegar todos os arquivos `.o` que correspondem às opções marcadas como `y` (built-in) e "cola" eles, resolvendo as referências cruzadas entre eles. O resultado deste processo massivo de ligação é um único e imenso arquivo executável, não compactado, chamado `vmlinux`, que reside na raiz do diretório de compilação.
5. Compressão e Geração da Imagem: O arquivo `vmlinux` contém o código do kernel mas também contém muitas informações de depuração (debug symbols) e seções (não-essenciais) para a execução. O Kbuild executa um processo de stripping (usando o utilitário `strip`) para remover essas informações, reduzindo o tamanho do binário. O binário stripped é compactado utilizando o algoritmo escolhido na configuração (usually, GZIP, lZMA ou LZ4) e um pequeno código de descompactação (o bootstrap code) é anexado no início do arquivo compactado. O produto final é o arquivo `bzImage` (Big Zlib Image), que é a imagem do kernel que será carregada pelo bootloader. Este arquivo é depositado no diretório específico da arquitetura, como `arch/x86/boot/bzImage`.

## Paralelismo

Se o processo for executado em um único núcleo de processamento, vai levar horas dependendo do volume de drivers selecionados e da velocidade do disco de armazenamento. A compilação do kernel é um problema "Embarrassingly Parallel" (embaraçosamente paralelo), o que significa que a compilação de `driver_A.c` é 100% independente da compilação de `driver_B.c`.

Para explorar essa característica e reduzir o tempo de compilação para uma fração do tempo original, utiliza-se a flag `-j` (jobs) do comando `make`. Esta flag orienta o `make` a lançar múltiplos processos de compilação simultaneamente. A prática padrão é definir o número de jobs como igual ou um tico superior ao número de núcleos lógicos (threads) disponíveis no processador hospedeiro.

```bash
# nproc retorna o número de threads disponíveis
# em um processador com 8 núcleos físicos e hyper-threading (16 threads lógicas), o comando vai executar: make -j16
make -j$(nproc)
```

A execução satura o uso da CPU (atingindo 100% em todos os núcleos) e impõe uma carga significativa no subsistema de I/O do disco e na memória RAM.

## `make modules`

Nas séries mais antigas do kernel Linux (2.4 <=), o processo de compilação era dividido em duas etapas, exigindo a execução de dois comandos separados:

1. `make bzImage`: Esse comando orientava o Kbuild a compilar APENAS o código marcao como `y` (built-in) e gerar a imagem compactada do kernel. Ele ignorava qualquer código marcado como `m` (módulo).
2. `make modules`: O Kbuild realizava uma nova travessia pela árvore de diretórios, compilando os arquivos marcados como `m` e gerando os arquivos Kernel Object (`.ko`).

Era uma confusão pois era fácil esquecer de compilar os módulos e se deparar com um sistema sem suporte de rede ou som após a reinicialização.

A partir da série 2.6 do kernel, o sistema Kbuild foi reestruturado. A distinçãoexplícita entre a compilação da imagem e dos módulos foi abolida no fluxo de trabalho padrão.
Ao executar `make` ou `make -j$(nproc)`, o Kbuild executa as duas tarefas de maneira simultânea. Ele compila a imagem do kernel (`bzImage`) e compila todos os módulos carregáveis (`.ko`). A execução de `make modules` é, na maioria dos casos, redundante.

A única execução em que `make modules` ainda é útil, é no cenário de desenvolvimento rápido de um driver específico. Se um desenvolvedor alterar o código de um único módulo e quiser recompilar os módulos (para economizar segundos que o Kbuild levaria verificando se a imagem precisa ser relinkada), ele pode executar `make modules`.

## `make modules_install`

Enquanto o `make` gera os arquivos `.ko`, ele deixa eles espalhados pelos milhares de subdiretórios dentro da árvore de código-fonte. O sistema operacional não consegue carregar módulos que estãodispersos no diretório de código-fonte de um usuário. Eles precisam ser consolidados e instalados em um local padronizado no sistema de arquivos raiz, como `/lib/modules/<versão-do-kernel>/`.

Ao contrário da compilação, a instalação não é um processo intensivo em CPU, é uma operação de cópia de arquivos e geração de índices.
