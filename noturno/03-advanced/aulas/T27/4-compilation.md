# Compilação: `make`, `make modules`, `make modules_install`

Após a configuração do arquivo `.config`, a próxima etapa é a fase de compilação (build phase). É a fase de esforço computacional massivo, traduzindo dezenas de milhões de linhas de código em linguagem C e Assembly em intruções de máquina binárias que são compreensivas pelo processador.
O sistema de compilação do kernel, Kbuild, é uma obra de engenharia de software complexa que orquestra a execução do compilador (GCC), do montados (Assembler) e do ligador (Linker) através de uma hierarquia de arquivos `Makefile`.

## A Mecânica do Kbuild e a Ferramenta `make`

O `make` não é um compilador, ele é um utilitário de automação de construção (build automation tool). A sua função é ler arquivos chamados `Makefiles`, que contém regras especificando como derivar um arquivo de destino (target), como um arquivo objeto `.o`, a partir de arquivos de origem, como arquivos `.c` e `.h`. O Kbuild é uma vasta coleção de `Makefiles` distribuídos por todos os subdiretórios do código-fonte do kernel.

Quando o `make` é invocado na raiz do diretório do kernel, uma sequência complexa de eventos é desecadeada:

1. Leitura da Configuração: O Kbuild lê o arquivo `.config` gerado e exporta as variáveis (ex: `CONFIG_EXT4_FS=y`) para o ambiente do `make`.
2. Travessia Recursiva: O `make` invoca instâncias filhas de si mesmo para entrar recursivamente nos subdiretórios principais


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

A partir da série 2.6 do kernel, o sistema Kbuild foi reestruturado. 
