# Revisão Suprema: Sistemas Operacionais e Linux

## PARTE 1: FUNDAMENTOS DE SISTEMAS OPERACIONAIS

## 1.1 O que é um Sistema Operacional?

Um Sistema Operacional é um software que atua como intermediário entre o usuário/aplicações e o hardware do computador. Ele gerencia recursos escassos (CPU, memória, disco, rede) e fornece abstrações que facilitam a programação.

### Responsabilidades Principais do SO

1. Gerenciamento de Processos: Qual programa está rodando, em qual ordem, por quanto tempo

2. Gerenciamento de Memória: Quem tem acesso a qual região de RAM

3. Gerenciamento de Armazenamento: Organizar arquivos no disco, controlar acesso

4. Gerenciamento de Entrada/Saída (I/O): Comunicação com teclado, mouse, monitor, rede

5. Segurança: Impedir que um programa acesse dados de outro, que um usuário acesse dados de outro

6. Interface com o Usuário: Shell, GUI, APIs para programas

## 1.2 Arquitetura Básica do SO

### Camadas de Abstração

```
┌─────────────────────────────────┐
│      Aplicações do Usuário      │  (Firefox, VS Code, Terminal)
├─────────────────────────────────┤
│      Bibliotecas (libc, etc)    │  (Funções padrão do C)
├─────────────────────────────────┤
│      System Calls (Interface)   │  (open, read, write, fork, exec)
├─────────────────────────────────┤
│      Kernel (Núcleo do SO)      │  (Gerencia tudo)
├─────────────────────────────────┤
│      Drivers e Firmware         │  (Comunicação com hardware)
├─────────────────────────────────┤
│      Hardware                   │  (CPU, RAM, Disco, Rede)
└─────────────────────────────────┘
```

Cada camada oferece serviços:

- Hardware oferece transistores, circuitos

- Kernel oferece abstrações (arquivos, processos, memória)

- Bibliotecas oferecem funções convenientes (printf, malloc)

- Aplicações usam tudo para fazer algo útil

### Modo Usuário vs. Modo Kernel

O processador tem dois modos de execução:

Modo Kernel (Supervisor):

- Acesso total ao hardware

- Pode executar qualquer instrução

- Pode acessar qualquer endereço de memória

- Usado apenas pelo kernel

Modo Usuário:

- Acesso limitado ao hardware

- Não pode executar instruções privilegiadas

- Acesso apenas à sua própria memória

- Usado por todas as aplicações

Por que dois modos? Proteção. Se um programa bugado rodasse em modo kernel, poderia corromper o SO inteiro ou acessar dados de outros programas. Com dois modos, o kernel garante isolamento.

Como um programa acessa o hardware? System Calls. Quando um programa quer fazer algo privilegiado (abrir um arquivo, alocar memória, enviar pacote de rede), ele faz uma chamada de sistema. O kernel valida se é permitido e executa em modo kernel.

Exemplo em C:

```
// Modo usuário: o programa quer abrir um arquivo
int fd = open("/etc/passwd", O_RDONLY);

// O que acontece internamente:
// 1. Programa chama a função open() da libc
// 2. libc prepara os argumentos
// 3. libc executa a instrução SYSCALL (trap)
// 4. CPU muda para modo kernel
// 5. Kernel executa a syscall open()
// 6. Kernel valida: "Esse usuário pode ler /etc/passwd? Sim."
// 7. Kernel abre o arquivo
// 8. Kernel retorna um file descriptor (número)
// 9. CPU volta para modo usuário
// 10. Programa recebe o fd e continua
```

## 1.3 Conceitos Fundamentais

### Processo

Um processo é uma instância de um programa em execução. Cada processo tem:

- PID (Process ID): Um número único que o identifica

- Memória: Uma área de RAM isolada (não pode acessar a memória de outro processo)

- Registradores: Estado da CPU (PC, SP, etc.)

- Descritores de Arquivo: Quais arquivos/sockets estão abertos

- Variáveis de Ambiente: Configurações (PATH, HOME, etc.)

- Sinais: Formas de comunicação entre processos

Exemplo: Se você abrir o Firefox duas vezes, são dois processos diferentes, cada um com seu PID, sua memória, seus arquivos abertos.

### Arquivo

Um arquivo é uma abstração para dados persistentes. Pode ser:

- Arquivo regular: Dados no disco (texto, binário, imagem)

- Diretório: Lista de arquivos (é um tipo especial de arquivo)

- Device node: Representa um dispositivo (disco, terminal, rede)

- Socket: Comunicação entre processos ou pela rede

- Pipe: Comunicação entre processos (unidirecional)

- Link simbólico: Atalho para outro arquivo

Tudo é arquivo no Linux. Essa é uma filosofia central. Até dispositivos de hardware são acessados como arquivos em `/dev/`.

### Usuário e Permissões

Cada arquivo tem um proprietário (usuário) e um grupo. Cada arquivo tem permissões que definem quem pode ler, escrever e executar.

```
-rw-r--r-- 1 ubuntu ubuntu 1234 Jan 15 10:30 arquivo.txt
│││││││││ │ │      │      │    │  │  │    │
│││││││││ │ │      │      │    │  │  │    └─ Nome do arquivo
│││││││││ │ │      │      │    │  │  └────── Hora
│││││││││ │ │      │      │    │  └───────── Data
│││││││││ │ │      │      │    └──────────── Tamanho (bytes)
│││││││││ │ │      │      └────────────────── Grupo
│││││││││ │ │      └───────────────────────── Proprietário
│││││││││ │ └──────────────────────────────── Número de links
│││││││││ └────────────────────────────────── Tipo de arquivo (- = regular)
││││││││└─ Permissões de outros (r--)
│││││││└── Permissões de grupo (r--)
││││││└─── Permissões de grupo (r)
│││││└──── Permissões de grupo (w)
││││└───── Permissões de grupo (x)
│││└────── Permissões do proprietário (r)
││└─────── Permissões do proprietário (w)
│└──────── Permissões do proprietário (r)
└───────── Tipo de arquivo
```

Permissões em octal:

- `r` (read) = 4

- `w` (write) = 2

- `x` (execute) = 1

`-rw-r--r--` = `644` em octal (proprietário: 6=rw, grupo: 4=r, outros: 4=r)

## 1.4 Interrupções e Exceções

O processador não executa o kernel continuamente. Ele alterna entre executar programas de usuário e executar o kernel. Como o kernel consegue retomar o controle?

### Interrupções

Uma interrupção é um sinal externo que faz o processador parar o que está fazendo e executar uma rotina especial.

Exemplos:

- Você pressiona uma tecla → Teclado envia uma interrupção

- Um pacote chega pela rede → Placa de rede envia uma interrupção

- Um timer expira → Timer envia uma interrupção

O que acontece:

1. CPU está executando um programa de usuário

2. Hardware (teclado, rede, timer) envia uma interrupção

3. CPU termina a instrução atual

4. CPU muda para modo kernel

5. CPU salta para o endereço da rotina de interrupção (no kernel)

6. Kernel trata a interrupção (ex: lê o caractere do teclado)

7. Kernel retorna ao programa de usuário

8. CPU muda para modo usuário

9. Programa continua

### Exceções

Uma exceção é um evento anormal causado por uma instrução. Diferente de interrupções (externas), exceções são internas.

Exemplos:

- Divisão por zero

- Acesso a endereço de memória inválido (segmentation fault)

- Instrução ilegal

- System call (SYSCALL é uma exceção intencional)

O que acontece: Similar a interrupção, mas causada pelo programa.

### Timer (Preempção)

O kernel usa um timer para garantir que nenhum programa monopolize a CPU. A cada intervalo (ex: 10ms), o timer envia uma interrupção. O kernel então:

1. Salva o estado do programa atual

2. Escolhe outro programa para rodar

3. Restaura o estado do novo programa

4. Retorna ao modo usuário

Isso é preempção ou time-slicing. Permite que múltiplos programas rodem "simultaneamente" em uma CPU com um único core.

## 1.5 Gerenciamento de Memória

### Espaço de Endereçamento Virtual

Cada processo acredita que tem acesso a toda a memória do computador (ex: 4GB). Na verdade, o kernel usa paginação para mapear endereços virtuais para endereços físicos.

```
Processo A                    Processo B
Virtual:                      Virtual:
0x00000000 ─┐                0x00000000 ─┐
            │                            │
0x7FFFFFFF ─┤                0x7FFFFFFF ─┤
            │                            │
            └─ Mapeado para ─┘           │
                             │           │
                    RAM Física:          │
                    ┌─────────┐          │
                    │ Proc A  │          │
                    ├─────────┤          │
                    │ Proc B  │◄─────────┘
                    ├─────────┤
                    │ Kernel  │
                    ├─────────┤
                    │ Livre   │
                    └─────────┘
```

Vantagens:

- Isolamento: Um processo não consegue acessar a memória de outro

- Flexibilidade: O kernel pode mover processos na RAM sem que eles saibam

- Proteção: O kernel valida cada acesso

### Paginação

A memória é dividida em páginas (ex: 4KB cada). O kernel mantém uma tabela de páginas que mapeia:

```
Endereço Virtual → Endereço Físico
0x00000000 → 0x10000000
0x00001000 → 0x20000000
0x00002000 → 0x30000000
...
```

Quando um programa acessa um endereço virtual, o MMU (Memory Management Unit) do processador consulta a tabela de páginas e traduz para físico.

Page Fault: Se um programa tenta acessar uma página que não está mapeada (ex: foi movida para disco), o MMU gera uma exceção. O kernel trata trazendo a página de volta para RAM.

### Segmentação

Sistemas operacionais antigos (DOS, Windows 3.1) usavam segmentação em vez de paginação. Cada programa tinha um "segmento" de memória contígua. Isso causava fragmentação e desperdício. A paginação é superior.

## 1.6 Gerenciamento de I/O

### Operações Síncronas vs. Assíncronas

Síncrono: O programa faz uma requisição e espera até que termine.

```
int fd = open("/arquivo.txt", O_RDONLY);  // bloqueia até abrir
char buffer[1024];
read(fd, buffer, 1024);  // bloqueia até ler
```

Assíncrono: O programa faz uma requisição e continua. O kernel notifica quando termina.

```
aio_read(&aiocb);  // retorna imediatamente
// fazer outras coisas
// kernel notifica quando leitura termina
```

### DMA (Direct Memory Access)

Quando você lê um arquivo do disco, o kernel não copia byte-a-byte. Ele configura o DMA do disco para copiar diretamente para a RAM, enquanto a CPU faz outras coisas. Muito mais eficiente.

# PARTE 2: LINUX ESPECIFICAMENTE

## 2.1 História e Filosofia

### Origem

- 1969: Unix criado no Bell Labs (AT&T)

- 1983: Richard Stallman funda GNU (GNU's Not Unix) — software livre

- 1991: Linus Torvalds cria o Kernel Linux (inicialmente para seu 386)

- 1992: Linux é licenciado sob GPL (General Public License) — torna-se livre

- Hoje: Linux roda em tudo (servidores, smartphones, IoT, supercalculadores)

### Filosofia Unix/Linux

1. Faça uma coisa e faça bem: Cada programa tem um propósito específico

2. Tudo é arquivo: Dados, dispositivos, processos — tudo é acessado como arquivo

3. Componibilidade: Programas podem ser combinados via pipes

4. Transparência: Código-fonte aberto, sem segredos

5. Permissões: Segurança baseada em usuários e grupos

## 2.2 Arquitetura do Kernel Linux

### Monolítico vs. Modular

O kernel Linux é monolítico, mas com suporte a módulos:

- Monolítico: Todo o código do kernel (drivers, filesystems, rede) é compilado em um único binário (`vmlinuz`)

- Modular: Partes podem ser compiladas como módulos (`.ko`) e carregadas dinamicamente

Vantagem do monolítico: Performance (sem overhead de chamadas entre módulos)
Vantagem do modular: Flexibilidade (carrega apenas o que precisa)

Linux combina os dois: kernel monolítico com suporte a módulos.

### Estrutura de Diretórios do Código-Fonte

```
linux-6.6.87/
├── arch/          # código específico de arquitetura (x86, ARM, etc)
├── drivers/       # drivers de hardware (disco, rede, USB, etc.)
├── fs/            # filesystems (ext4, NTFS, FAT, etc.)
├── kernel/        # núcleo do kernel (processos, memória, sinais)
├── mm/            # gerenciamento de memória (paginação, cache)
├── net/           # pilha de rede (TCP/IP, sockets)
├── security/      # módulos de segurança (SELinux, AppArmor)
├── sound/         # drivers de áudio
├── include/       # headers (definições de estruturas)
├── scripts/       # scripts de compilação
├── Makefile       # instruções de compilação
└── Kconfig        # opções de configuração
```

### Subsistemas Principais

Gerenciamento de Processos:

- `fork()`: Cria um novo processo (cópia do atual)

- `exec()`: Substitui o processo atual por um novo programa

- `wait()`: Aguarda um processo filho terminar

- Scheduler: Decide qual processo roda em qual momento

Gerenciamento de Memória:

- Paginação: Tradução virtual → física

- Swapping: Move páginas para disco quando RAM está cheia

- Cache: Mantém dados frequentes em RAM

Filesystems:

- VFS (Virtual File System): Interface comum para todos os filesystems

- Inode: Estrutura que representa um arquivo

- Dentry: Cache de nomes de arquivos

Rede:

- TCP/IP stack: Protocolo de rede

- Sockets: Interface para comunicação

- Drivers de rede: Comunicação com placa de rede

## 2.3 Inicialização do Linux (Boot)

### Sequência de Boot

```
1. Ligar o computador
   ↓
2. BIOS/UEFI executa (firmware)
   ├─ POST (Power-On Self Test)
   ├─ Detecta hardware
   └─ Procura por bootloader
   ↓
3. Bootloader (GRUB) executa
   ├─ Mostra menu de boot
   ├─ Carrega kernel na memória
   ├─ Carrega initramfs na memória
   └─ Passa controle para kernel
   ↓
4. Kernel Linux inicia
   ├─ Descompacta a imagem (bzImage)
   ├─ Inicializa hardware (drivers)
   ├─ Monta o initramfs como rootfs temporário
   ├─ Executa `/init` do initramfs
   └─ initramfs carrega drivers de disco
   ↓
5. initramfs monta o rootfs real
   ├─ Encontra o disco/partição
   ├─ Carrega driver do filesystem
   ├─ Monta em /
   └─ Executa `/sbin/init` (PID 1)
   ↓
6. Init (systemd) inicia
   ├─ Lê `/etc/systemd/system/default.target`
   ├─ Inicia serviços (SSH, rede, etc.)
   ├─ Monta filesystems adicionais (/proc, /sys, /dev)
   └─ Apresenta prompt de login
   ↓
7. Login shell
   ├─ Usuário faz login
   ├─ Shell é executado
   └─ Usuário pode rodar comandos
```

### BIOS vs. UEFI

BIOS (Basic Input/Output System):

- Firmware antigo (1980s)

- Suporta apenas MBR (Master Boot Record) — máximo 2TB

- 16-bit, lento

- Praticamente obsoleto

UEFI (Unified Extensible Firmware Interface):

- Firmware moderno (2000s+)

- Suporta GPT (GUID Partition Table) — sem limite de tamanho

- 32/64-bit, rápido

- Padrão em computadores novos

### Bootloader (GRUB)

O GRUB (GRand Unified Bootloader) é o programa que carrega o kernel. Ele:

1. Lê a configuração em `/boot/grub/grub.cfg`

2. Mostra um menu com opções de boot

3. Carrega o kernel (`vmlinuz`) na memória

4. Carrega o initramfs na memória

5. Passa controle para o kernel

Configuração típica:

```bash
menuentry 'Oficina Linux' {
    search --set=root --label OFICINA
    linux /vmlinuz root=/dev/sda1 ro
    initrd /initramfs.cpio.gz
}
```

### initramfs (Initial RAM Filesystem)

O initramfs é um filesystem temporário em RAM que o kernel monta antes de montar o rootfs real. Serve para:

1. Carregar drivers de disco (sem drivers, kernel não consegue acessar disco)

2. Detectar hardware

3. Montar o rootfs real

4. Passar controle para `/sbin/init`

É um arquivo comprimido (`.cpio.gz` ou `.tar.gz`) que contém:

- `/init` (script que executa a inicialização)

- Drivers essenciais (`.ko`)

- Ferramentas (BusyBox)

- Bibliotecas

## 2.4 Filesystems

### Conceito

Um filesystem é a forma como dados são organizados no disco. Define:

- Como arquivos são nomeados

- Como metadados são armazenados (permissões, timestamps)

- Como espaço livre é rastreado

- Como recuperar dados corrompidos

### Filesystems Comuns

| Filesystem | Uso | Características |
| --- | --- | --- |
| ext4 | Linux padrão | Confiável, maduro, journaling |
| NTFS | Windows | Proprietário, suporte em Linux é limitado |
| FAT32 | Pendrive, câmera | Simples, compatível, sem permissões |
| BTRFS | Servidor Linux | Moderno, copy-on-write, snapshots |
| XFS | Alto desempenho | Rápido, bom para arquivos grandes |
| SquashFS | Live CD/USB | Comprimido, read-only (perfeito para ISO) |
| tmpfs | /tmp, /dev/shm | Em RAM, rápido, desaparece no reboot |

### Inode

Um inode é uma estrutura que armazena metadados de um arquivo:

```
Inode #12345
├─ Tipo: regular file
├─ Proprietário: ubuntu (UID 1000)
├─ Grupo: ubuntu (GID 1000)
├─ Permissões: 644 (rw-r--r--)
├─ Tamanho: 1234 bytes
├─ Timestamps:
│  ├─ Acesso: 2024-01-15 10:30:00
│  ├─ Modificação: 2024-01-15 10:25:00
│  └─ Mudança de inode: 2024-01-15 10:25:00
├─ Links: 1
├─ Blocos de dados: [1024, 1025, 1026, ...]
└─ Permissões especiais: (none)
```

O número do inode é o identificador único do arquivo no filesystem. O nome do arquivo é apenas um link para o inode.

### Diretório

Um diretório é um arquivo especial que contém uma lista de nomes e seus inodes:

```
Diretório /home/ubuntu/
├─ "." → inode 12340 (o próprio diretório)
├─ ".." → inode 12339 (diretório pai)
├─ "arquivo.txt" → inode 12345
├─ "pasta/" → inode 12346
└─ ".bashrc" → inode 12347
```

Quando você faz `ls`, o kernel lê o inode do diretório e mostra a lista.

### Hard Link vs. Symbolic Link

Hard Link:

```bash
ln arquivo.txt link_duro
```

Cria outro nome que aponta para o mesmo inode. Ambos são equivalentes.

```
arquivo.txt → inode 12345
link_duro → inode 12345
```

Se você deletar um, o outro continua (o inode só é deletado quando o último link é removido).

Symbolic Link (Atalho):

```bash
ln -s arquivo.txt link_simbolico
```

Cria um arquivo especial que contém o caminho para outro arquivo.

```
link_simbolico → (arquivo especial) → "arquivo.txt"
```

Se você deletar o original, o link simbólico fica quebrado.

## 2.5 Permissões em Profundidade

### Bits de Permissão

```
-rw-r--r--
 │││││││││
 ││││││││└─ Outros: execute (x)
 │││││││└── Outros: write (w)
 ││││││└─── Outros: read (r)
 │││││└──── Grupo: execute (x)
 ││││└───── Grupo: write (w)
 │││└────── Grupo: read (r)
 ││└─────── Proprietário: execute (x)
 │└──────── Proprietário: write (w)
 └───────── Proprietário: read (r)
```

Para um arquivo regular:

- `r` (read): Pode ler o conteúdo

- `w` (write): Pode modificar o conteúdo

- `x` (execute): Pode executar como programa

Para diretório:

- `r` (read): Pode listar arquivos (`ls`)

- `w` (write): Pode criar/deletar arquivos

- `x` (execute): Pode entrar no diretório (`cd`)

### Permissões Especiais

setuid (Set User ID):

```bash
-rwsr-xr-x
   ↑
```

Quando executado, o programa roda com permissões do proprietário, não do usuário que executou.

Exemplo: `/usr/bin/passwd` tem setuid. Quando você roda `passwd`, ele roda como root (mesmo que você seja um usuário comum), permitindo que você mude sua senha.

setgid (Set Group ID):

```bash
-rwxr-sr-x
      ↑
```

Quando executado, o programa roda com permissões do grupo, não do usuário.

sticky bit:

```bash
drwxrwxrwt
       ↑
```

Em diretórios, apenas o proprietário do arquivo (ou root) pode deletar. Usado em `/tmp` para evitar que um usuário delete arquivos de outro.

### umask

O umask define as permissões padrão para novos arquivos/diretórios.

```bash
umask 0022
# Remova 022 das permissões padrão
# Arquivo padrão: 666 → 666 - 022 = 644 (rw-r--r--)
# Diretório padrão: 777 → 777 - 022 = 755 (rwxr-xr-x)
```

## 2.6 Usuários e Grupos

### /etc/passwd

Arquivo que lista todos os usuários do sistema:

```
root:x:0:0:root:/root:/bin/bash
ubuntu:x:1000:1000:Ubuntu User:/home/ubuntu:/bin/bash
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
```

Campos:

1. Nome de usuário: `root`, `ubuntu`

2. Senha: `x` (significa que está em `/etc/shadow`)

3. UID: ID numérico do usuário (0 = root)

4. GID: ID do grupo primário

5. GECOS: Comentário (nome completo)

6. Home: Diretório home do usuário

7. Shell: Shell padrão do usuário

### /etc/shadow

Arquivo que armazena senhas (criptografadas):

```
root:!:18000:0:99999:7:::
ubuntu:$6$rounds=656000$abcd...:18000:0:99999:7:::
```

Apenas root pode ler. Senhas são criptografadas com bcrypt/sha512.

### /etc/group

Arquivo que lista grupos:

```
root:x:0:
ubuntu:x:1000:
sudo:x:27:ubuntu,root
docker:x:999:ubuntu
```

Campos:

1. Nome do grupo

2. Senha do grupo (raro, geralmente `x`)

3. GID: ID numérico do grupo

4. Membros: Lista de usuários que pertencem ao grupo

### UID/GID

- UID 0: root (super-usuário, acesso total)

- UID 1-999: Usuários de sistema (daemons, serviços)

- UID 1000+: Usuários normais

Mesmo conceito para GID.

## 2.7 Variáveis de Ambiente

Variáveis de ambiente são configurações que afetam o comportamento de programas.

### Variáveis Importantes

| Variável | Significado | Exemplo |
| --- | --- | --- |
| PATH | Diretórios de onde buscar programas | `/usr/local/bin:/usr/bin:/bin` |
| HOME | Diretório home do usuário | `/home/ubuntu` |
| USER | Nome do usuário atual | `ubuntu` |
| SHELL | Shell padrão | `/bin/bash` |
| LANG | Idioma/locale | `pt_BR.UTF-8` |
| PWD | Diretório atual | `/home/ubuntu/distro` |
| TERM | Tipo de terminal | `xterm-256color` |
| EDITOR | Editor padrão | `nano` |
| LD_LIBRARY_PATH | Diretórios de bibliotecas | `/usr/local/lib:/usr/lib` |

### Como Usar

```bash
# ver uma variável
echo $PATH

# definir uma variável (apenas nesta sessão)
export MINHA_VAR="valor"

# definir permanentemente (adicionar ao ~/.bashrc)
echo 'export MINHA_VAR="valor"' >> ~/.bashrc
source ~/.bashrc
```

## 2.8 Pipes e Redirecionamentos

### stdin, stdout, stderr

Cada processo tem três streams padrão:

- stdin (0): Entrada padrão (teclado)

- stdout (1): Saída padrão (tela)

- stderr (2): Saída de erro (tela)

### Redirecionamentos

```bash
# redirecionar stdout para arquivo
command > arquivo.txt

# redirecionar stderr para arquivo
command 2> erro.txt

# redirecionar ambos
command > saida.txt 2>&1

# redirecionar stdin de arquivo
command < entrada.txt

# append (não sobrescreve)
command >> arquivo.txt
```

### Pipes

```bash
# conectar stdout de um comando ao stdin de outro
cat arquivo.txt | grep "palavra"

# múltiplos pipes
cat arquivo.txt | grep "palavra" | wc -l
```

## 2.9 Processos em Profundidade

### Criação de Processo (fork/exec)

```
// pseudocódigo
pid_t child = fork();

if (child == 0) {
    // código do filho
    exec("/bin/bash");  // substitui o processo por /bin/bash
} else {
    // código do pai
    wait(child);  // aguarda o filho terminar
}
```

fork(): Cria uma cópia exata do processo atual (mesma memória, mesmos arquivos abertos). O kernel copia a tabela de páginas (copy-on-write: apenas copia quando alguém escreve).

exec(): Substitui o código do processo atual por um novo programa. Mantém o PID, stdin/stdout/stderr, variáveis de ambiente.

### Estados de Processo

```
RUNNING (rodando na CPU)
    ↑ ↓
RUNNABLE (pronto, aguardando CPU)
    ↑ ↓
BLOCKED (aguardando I/O)
    ↑ ↓
ZOMBIE (terminou, aguardando wait())
    ↓
TERMINATED (removido da memória)
```

Processo Zumbi: Um processo que terminou mas seu pai não chamou `wait()`. Ocupa uma entrada na tabela de processos mas não usa memória. Se muitos zumbis se acumularem, a tabela fica cheia e ninguém mais consegue criar processos.

### Sinais

Sinais são formas de comunicação entre processos. Alguns importantes:

| Sinal | Número | Significado | Padrão |
| --- | --- | --- | --- |
| SIGTERM | 15 | Terminar (gracefully) | Termina |
| SIGKILL | 9 | Matar (força) | Termina (não pode ser ignorado) |
| SIGINT | 2 | Interrupção (Ctrl+C) | Termina |
| SIGSTOP | 19 | Parar (não pode ser ignorado) | Para |
| SIGCONT | 18 | Continuar | Continua |
| SIGHUP | 1 | Hangup (terminal desconectou) | Termina |
| SIGUSR1 | 10 | Definido pelo usuário | Termina |
| SIGUSR2 | 12 | Definido pelo usuário | Termina |

```bash
# enviar SIGTERM (graceful)
kill -TERM <PID>

# enviar SIGKILL (força)
kill -KILL <PID>

# enviar SIGSTOP (parar)
kill -STOP <PID>

# enviar SIGCONT (continuar)
kill -CONT <PID>
```

## 2.10 Gerenciamento de Pacotes

### Conceito

Um pacote é um arquivo que contém:

- Binários (programas compilados)

- Bibliotecas

- Arquivos de configuração

- Metadados (nome, versão, dependências, autor)

### Gerenciadores

apt (Debian/Ubuntu):

```bash
apt update                # atualiza lista de pacotes
apt install <pacote>      # instala pacote
apt remove <pacote>       # remove pacote
apt upgrade               # atualiza todos os pacotes
apt search <termo>        # procura pacote
```

dnf (Fedora/RHEL):

```bash
dnf install <pacote>
dnf remove <pacote>
dnf update
dnf search <termo>
```

pacman (Arch):

```bash
pacman -S <pacote>       # instala
pacman -R <pacote>       # remove
pacman -Syu              # atualiza
pacman -Ss <termo>       # procura
```

### Dependências

Um pacote pode depender de outros pacotes. O gerenciador resolve automaticamente.

```bash
# exemplo: Firefox depende de GTK3, libX11, etc.
apt install firefox
# gerenciador instala firefox + todas as dependências
```

### Repositórios

Um repositório é um servidor que armazena pacotes. O gerenciador baixa de lá.

```bash
# ver repositórios configurados (Ubuntu)
cat /etc/apt/sources.list
# deb http://archive.ubuntu.com/ubuntu/ jammy main universe
# deb http://security.ubuntu.com/ubuntu/ jammy-security main
```

# PARTE 3: CONCEITOS AVANÇADOS

## 3.1 Compilação de Software

### Processo de Compilação

```
Código-fonte (.c )
    ↓
Pré-processador (cpp)
    ├─ Expande macros (#define)
    ├─ Inclui headers (#include)
    └─ Gera código C expandido
    ↓
Compilador (gcc)
    ├─ Analisa sintaxe
    ├─ Gera código assembly
    └─ Gera arquivo objeto (.o)
    ↓
Linker (ld)
    ├─ Combina múltiplos .o
    ├─ Resolve símbolos
    ├─ Linka bibliotecas (.a, .so)
    └─ Gera executável
    ↓
Executável (ELF)
```

### Compilação Manual

```bash
# compilar um arquivo
gcc -c arquivo.c -o arquivo.o

# linkar múltiplos objetos
gcc arquivo1.o arquivo2.o -o programa

# tudo em um comando
gcc arquivo.c -o programa

# com otimização
gcc -O2 arquivo.c -o programa

# com debug info
gcc -g arquivo.c -o programa

# com warnings
gcc -Wall -Wextra arquivo.c -o programa
```

### Makefile

Um Makefile automatiza a compilação:

```
CC = gcc
CFLAGS = -Wall -O2
SOURCES = main.c utils.c
OBJECTS = $(SOURCES:.c=.o)
TARGET = programa

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -o $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)

.PHONY: clean
```

```bash
make           # compila
make clean     # remove objetos
```

### Linking Estático vs. Dinâmico

Linking Estático:

```bash
gcc -static programa.c -o programa
```

Copia todas as bibliotecas dentro do executável. Resultado: arquivo grande (~10MB) mas funciona em qualquer máquina.

Linking Dinâmico:

```bash
gcc programa.c -o programa
```

Apenas referencia as bibliotecas. Resultado: arquivo pequeno (~50KB) mas precisa que as bibliotecas estejam instaladas na máquina.

## 3.2 Bibliotecas Compartilhadas

### O que é uma Biblioteca Compartilhada

Uma biblioteca compartilhada (`.so` no Linux, `.dll` no Windows) é código compilado que múltiplos programas podem usar.

Exemplo: `libc.so.6` é a biblioteca C padrão. Quase todo programa Linux depende dela.

### Localizando Bibliotecas

```bash
# ver quais bibliotecas um programa precisa
ldd /bin/bash
# linux-vdso.so.1 (0x00007fff...)
# libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6
# /lib64/ld-linux-x86-64.so.2

# procurar por uma biblioteca
find /usr -name "libssl.so*"

# ver o caminho de busca
echo $LD_LIBRARY_PATH
```

### LD_LIBRARY_PATH

```bash
# adicionar um diretório ao caminho de busca
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# executar um programa com caminho customizado
LD_LIBRARY_PATH=/minha/lib ./programa
```

## 3.3 Compatibilidade Windows vs. Linux

### Diferenças Fundamentais

| Aspecto | Windows | Linux |
| --- | --- | --- |
| Licença | Proprietária | Livre (GPL) |
| Código-fonte | Fechado | Aberto |
| Kernel | Monolítico com drivers em userspace | Monolítico com drivers no kernel |
| Filesystems | NTFS, FAT32 | ext4, btrfs, XFS |
| Permissões | ACLs (complexas) | rwx (simples) |
| Linha de comando | PowerShell, cmd.exe | Bash, sh, zsh |
| Pacotes | .exe, .msi | .deb, .rpm, .tar.gz |
| Caminhos | `C:\Users\...` | `/home/...` |
| Separador | `\` | `/` |
| Case-sensitive | Não | Sim |
| Linha de arquivo | CRLF (\r\n) | LF (\n) |

### Executáveis

Windows (.exe):

- Formato PE (Portable Executable)

- Não funciona em Linux (diferente arquitetura de SO)

Linux (ELF):

- Formato ELF (Executable and Linkable Format)

- Não funciona em Windows (diferente arquitetura de SO)

Compatibilidade:

- Wine: Executa .exe no Linux (emulação)

- WSL2: Executa Linux no Windows (VM)

- Compilar para ambos: Código-fonte multiplataforma

### Caminhos

```bash
# windows
C:\Users\ubuntu\Desktop\arquivo.txt

# linux
/home/ubuntu/Desktop/arquivo.txt

# WSL2 (acesso ao Windows do Linux)
/mnt/c/Users/ubuntu/Desktop/arquivo.txt
```

### Quebras de Linha

Windows (CRLF):

```
Linha 1\r\n
Linha 2\r\n
```

Linux (LF):

```
Linha 1\n
Linha 2\n
```

Se você criar um arquivo no Windows e tentar usar no Linux, pode ter problemas:

```bash
# ver quebras de linha
cat -A arquivo.txt
# Linha 1^M$
# Linha 2^M$
# (^M = \r)

# converter para LF
dos2unix arquivo.txt

# ou com sed
sed -i 's/\r$//' arquivo.txt
```

## 3.4 Virtualização

### Tipos de Virtualização

Virtualização Completa (Full Virtualization):

- VM emula todo o hardware

- Sistema operacional não sabe que está virtualizado

- Mais lento, mais compatível

- Exemplos: VirtualBox, QEMU

Paravirtualização:

- VM fornece uma interface modificada

- Sistema operacional sabe que está virtualizado

- Mais rápido, menos compatível

- Exemplos: Xen, Hyper-V

Virtualização de Containers:

- Compartilha o kernel do hospedeiro

- Isolamento de processos/filesystems

- Muito rápido, menos isolado

- Exemplos: Docker, LXC

### WSL2

WSL2 é uma VM leve que roda Linux no Windows:

- Usa Hyper-V (paravirtualização)

- Compartilha recursos com Windows

- Acesso aos arquivos do Windows via `/mnt/c/`

- Muito mais rápido que VirtualBox

## 3.5 Segurança

### Princípio do Menor Privilégio

Sempre rode programas com o menor privilégio necessário.

```bash
# ruim: rodar tudo como root
sudo ./programa

# bom: criar um usuário específico
useradd -r -s /bin/false www
sudo -u www ./programa
```

### Firewall

Um firewall controla quais conexões de rede são permitidas.

```bash
# ver regras (UFW no Ubuntu)
sudo ufw status

# permitir porta 22 (SSH)
sudo ufw allow 22

# negar porta 80 (HTTP)
sudo ufw deny 80

# ativar firewall
sudo ufw enable
```

### Criptografia

Senhas:

```bash
# gerar hash de senha
openssl passwd -6
# $6$rounds=656000$...
```

Certificados SSL:

```bash
# gerar chave privada
openssl genrsa -out chave.key 2048

# gerar certificado auto-assinado
openssl req -new -x509 -key chave.key -out cert.crt -days 365
```

## 3.6 Performance e Otimização

### Profiling

```bash
# ver uso de CPU/memória
top

# ver I/O de disco
iostat

# ver uso de rede
iftop

# profile de um programa
perf record ./programa
perf report
```

### Otimizações Comuns

1. Compilação: Usar `-O2` ou `-O3` para otimização

2. Stripping: Remover símbolos de debug (`strip programa`)

3. Caching: Manter dados frequentes em RAM

4. Parallelização: Usar múltiplos cores (`make -j$(nproc)`)

5. Algoritmos: Escolher algoritmos eficientes

# PARTE 4: PRÁTICO PARA O CICLO 3

## 4.1 Checklist

- [ ] O que é um processo, PID, PPID

- [ ] Como funciona fork/exec

- [ ] O que é um sinal e como enviar

- [ ] Como redirecionar stdin/stdout/stderr

- [ ] Como usar pipes

- [ ] Como compilar um programa C

- [ ] O que é uma biblioteca compartilhada

- [ ] Como funciona o boot (BIOS → GRUB → Kernel → Init)

- [ ] O que é um filesystem e inode

- [ ] Como funcionam permissões (rwx)

- [ ] O que é um usuário/grupo

- [ ] Como usar apt/dnf/pacman

- [ ] O que é uma variável de ambiente

- [ ] Como usar grep, sed, awk

- [ ] Como editar arquivos com nano/vim
