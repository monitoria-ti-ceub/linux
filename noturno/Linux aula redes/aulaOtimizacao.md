# Otimização de nossa distro

Ao compilarmos o nosso sistema Linux from Scratch padrão nós estamos priorizando a compatibilidade e o ensino (usando as ferramentas GNU padrão e a Glibc), o que resulta em um sistema completamente funcional, mas não exatamente de ser minimalista.

Para criarmos uma distribuição otimizada no quesito espaço em disco, precisamos trocar a filosofia de compatibilidade universal pela de estrita necessidade para nossos usos.

## 1. Compilador e binários

A forma como você compila o código dita o tamanho final do executável.

- Flags de Otimização (CFLAGS): No seu arquivo de ambiente ou ao rodar o make, mude a tradicional flag de otimização de performance -O2 para -Os (Otimizar para tamanho) ou -Oz (se estiver usando Clang/LLVM). Isso instrui o compilador a ignorar otimizações que aumentariam o tamanho do binário.
- Stripping Agressivo: Por padrão, binários compilados contêm símbolos de depuração (debug symbols) que são inúteis para a execução diária e ocupam muito espaço. Após construir o sistema, passe a "lâmina" em tudo:

```
#Cuidado: execute isso apenas no final, nunca durante a compilação do toolchain

trip --strip-unneeded /bin/* /sbin/* /usr/bin/* /usr/sbin/*
strip --strip-unneeded /lib/* /usr/lib/*
```

## 2. Substituição de Componentes Críticos

Apesar de ser revolucionário, o projeto GNU é massivo. Para sistemas embutidos (embedded) ou micro-distros, você deve considerar os seguintes substitutos:
- Biblioteca C (Glibc -> musl): A Glibc é gigantesca. Mudar para a musl libc (ou uClibc-ng) é o passo que mais economiza espaço no sistema inteiro. Note que isso muda a arquitetura do seu sistema inteiro (você precisará seguir um guia como o musl-LFS), mas a economia de megabytes é massiva.
- As Ferramentas Core (GNU Coreutils -> BusyBox): O BusyBox combina versões minúsculas do `ls`, `cp`, `grep`, `awk`, `sed`, `tar` e até do init do sistema em um único executável de cerca de 1 a 2 MB. O resto do sistema interage com ele via links simbólicos. Ele pode substituir praticamente todo o diretório `/bin` e `/sbin`.
- Shell (Bash -> Almquist/Ash/Dash): O Bash é pesado e cheio de recursos interativos. Para rodar scripts de sistema e interagir de forma básica, o Dash (usado pelo Debian/Ubuntu para o /bin/sh) ou o shell embutido no próprio BusyBox (Ash) são frações do tamanho do Bash.

## 3. Otimizando o Kernel Linux

O Kernel padrão compila milhares de drivers que você nunca usará.
- A Base de Otimização: Em vez de começar com `make defconfig`, comece com `make tinyconfig` (que cria o menor kernel possível, desativando absolutamente tudo) e vá ativando apenas o que o seu hardware específico precisa (drivers de disco, rede e sistema de arquivos).
- Desative Símbolos de Debug: Certifique-se de que `CONFIG_DEBUG_INFO` está desativado no menu de configuração do Kernel (make menuconfig).
- Compressão Máxima: Configure a compressão do kernel (`CONFIG_KERNEL_LZMA` ou `CONFIG_KERNEL_XZ`) em vez das opções de GZIP antigas. O boot demora milissegundos a mais para descompactar, mas o arquivo da imagem (`bzImage`) fica muito menor.

## 4. Arquivos de texto para usuário

Muitas coisas em um sistema Linux são texto puro para consumo humano e não são lidas pelas máquinas.

- Manpages e Documentação: Apague completamente os diretórios de manuais, documentações e informações do GNU.

    `rm -rf /usr/share/man /usr/share/doc /usr/share/info`

- Locales (Idiomas): Se você só vai usar o sistema em inglês ou não se importa com a internacionalização de mensagens de erro, você não precisa de dezenas de megabytes de definições de idioma. Remova tudo no diretório de locales, deixando apenas o locale `C` ou `en_US`.
- Cabeçalhos (Headers): Os arquivos `.h` em `/usr/include` só são necessários se você for compilar novos softwares dentro desse LFS no futuro. Se o sistema for um artefato final (apenas para rodar coisas, não para construí-las), você pode deletar a pasta inteira.

