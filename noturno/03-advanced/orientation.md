# Guia de Orientação

## Setup WSL2

### 1. Configuração Inicial

#### 1.1 Pré-Requisitos

Seu computador precisa de:

- Windows 10 ou Windows 11
- Virtualização na BIOS (sem a virtualização, o WSL2 não consegue criar um ambiente Linux isolado dentro do Windows)
- ~50GB de Espaço Livre no Disco
- Conexão com a Internet

Como verficiar a versão do Windows?

Abra o PowerShell e rode o comando:
```plain text
[Environment]::OSVersion.Version
```

Como verificar se a virtualização está habilitada?

Abra o Gerenciador de Tarefas (Ctrl + Shift + Esc) -> Abra "Performance" -> "CPU". Se disse "Virtualização: Ativada", oba!. Se disser "Virtualização: Desativa", reinicie o computador, entre na BIOS (F2, Del ou F12 durante o boot) e procure por "Virtualization Technology". Ative e salve.

Deve retornar algo como `10.0.19045` (Windows 10) ou `10.0.22xxx` (Windows 11). Se for menor que `10.0.2004`, atualize!

#### 1.2 Instalar WSL2

Abra o PowerShell como Administrador e rode o comando:

```plain text
wsl --install -d  Ubuntu-22.04
```

O Windows vai:

1. Baixar o WSL2
2. Baixar a imagem do Ubuntu 22.04
3. Instalar ambos

O PowerShell vai pedir para você criar um nome de usuário e senha para o Ubuntu. Escolha algo simples..

#### 1.3 Verificação da Instalação

Abra o PowerShell e rode o comando:

```plain text
wsl --list --verbose
```

Deve retornar algo como:

```plain text
NAME                 STATE                 VERSION
Ubuntu-22.04         Running               2
```

Se disser `VERSION 2`, perfeito. Se disser `VERSION 1`, rode o comando:

```plain text
wsl --set-version Ubuntu-22.04 2
```

#### 1.4 O Terminal Ubuntu

- Opção 1: Procure por "Ubuntu" no menu
- Opção 2: Abra o PowerShell e rode o comando: `wsl`
- Opção 3: Abra o Windows Terminal e selecione "Ubuntu"

#### 1.5 Atualização do Sistema

Dentro do Ubuntu, rode o comando:

```Bash
sudo apt update
sudo apt upgrade -y
```

## 2. Estrutura de Pastas

A sua distribuição será construída em um diretório específico.

### 2.1 Criação da Estrutura Base

Dentro do Ubuntu, rode o comando:

```Bash
# criar o diretório raiz da distribuição
mkdir -p ~/distro

# criar os subdiretórios para cada tópico
mkdir -p ~/distro/kernel
mkdir -p ~/distro/rootfs
mkdir -p ~/distro/boot
mkdir -p ~/distro/tools
mkdir -p ~/distro/network
mkdir -p ~/distro/packages
mkdir -p ~/distro/iso
mkdir -p ~/distro/docs

# visualizar a estrutura
tree ~/distro
```

## 2.2 Repositório Git

```Bash
cd ~/distro
git init
git config user.name "nome"
git config user.email "nome@email.com"

# criar um .gitignore para não versionar arquivos desnecessários
cat  << 'EOF' > .gitignore
*.o
*.ko
*.a
*.so
*.iso
*.tar
*.tar.gz
*.tar.xz
.config
vmlinuz
System.map
/kernel/linux-*/
/rootfs/lib/modules/
EOF

git add .
git commit -m "init: estrutura da distro"
```

## 3. Fluxo da Oficina

### 3.1 Antes da Aula

- Leia o material teórico do tópico
- Prepare o WSL2
- Tenha espaço livre no disco

### 3.2 Durante a Aula

- Explicação teórica do tópico
- Dúvidas
- Demonstração passo-a-passo
- Verificação do check-list de saída

### 3.3 Depois da Aula

- Backup do ~/distro
- Commit no Git







```
                 .88888888:.
                88888888.88888.
              .8888888888888888.
              888888888888888888
              88' _`88'_  `88888
              88 88 88 88  88888
              88_88_::_88_:88888
              88:::,::,:::::8888
              88`:::::::::'`8888
             .88  `::::'    8:88.
            8888            `8:888.
          .8888'             `888888.
         .8888:..  .::.  ...:'8888888:.
        .8888.'     :'     `'::`88:88888
       .8888        '         `.888:8888.
      888:8         .           888:88888
    .888:88        .:           888:88888:
    8888888.       ::           88:888888
    `.::.888.      ::          .88888888
   .::::::.888.    ::         :::`8888'.:.
  ::::::::::.888   '         .::::::::::::
  ::::::::::::.8    '      .:8::::::::::::.
 .::::::::::::::.        .:888:::::::::::::
 :::::::::::::::88:.__..:88888:::::::::::'
  `'.:::::::::::88888888888.88:::::::::'
        `':::_:' -- '' -'-' `':_::::'`
 ```
