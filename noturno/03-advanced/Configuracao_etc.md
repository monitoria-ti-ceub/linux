# Configuração de Arquivos Essenciais no Linux From Scratch (LFS)

Seguindo a filosofia **Linux From Scratch (LFS)**, a configuração do sistema é feita manualmente, editando arquivos de texto simples. No contexto de um sistema minimalista com **BusyBox**, esses arquivos definem a identidade do sistema, o controle de acesso e a organização do armazenamento.

---

## 1. `/etc/passwd` - Identidade de Usuários

O arquivo `/etc/passwd` é o banco de dados fundamental de usuários. No LFS, começamos criando apenas o usuário `root` e os usuários de sistema necessários.

**Formato:** `usuário:senha:UID:GID:descrição:home:shell`

**Exemplo LFS Minimalista:**
```text
root:x:0:0:root:/root:/bin/sh
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/bin/false
nobody:x:65534:65534:Unprivileged User:/dev/null:/bin/false
```

*   **x**: Indica que a senha criptografada está no arquivo `/etc/shadow`.
*   **UID/GID 0**: Identificam o superusuário (root).
*   **Shell**: No BusyBox, geralmente usamos `/bin/sh`.

---

## 2. `/etc/group` - Definição de Grupos

Este arquivo define os grupos e quais usuários pertencem a eles. É crucial para permissões de hardware (ex: áudio, disco).

**Formato:** `grupo:senha:GID:lista_de_usuários`

**Exemplo LFS Comum:**
```text
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
wheel:x:97:
nogroup:x:65533:
nobody:x:65534:
```

> **Dica LFS:** O grupo `wheel` é frequentemente usado para permitir que usuários comuns usem `su` ou `sudo`.

---

## 3. `/etc/hostname` - Nome da Máquina

Este é o arquivo mais simples. Ele contém apenas o nome curto da máquina, sem o domínio.

**Configuração:**
```bash
echo "my-distro" > /etc/hostname
```

*   O nome deve ser simples e sem espaços.
*   Para configurar o nome completo (FQDN), utiliza-se o arquivo `/etc/hosts` em conjunto com este.

---

## 4. `/etc/fstab` - Tabela de Sistemas de Arquivos

O `fstab` (File System Table) diz ao kernel quais partições montar e onde. No LFS, isso é crítico para que o sistema saiba onde está a partição `/` e as partições virtuais.

**Campos:** `dispositivo | ponto_de_montagem | tipo | opções | dump | fsck`

**Exemplo LFS para BusyBox:**
```text
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
/dev/sda1       /               ext4    defaults        1       1
proc            /proc           proc    nosuid,noexec   0       0
sysfs           /sys            sysfs   nosuid,noexec   0       0
devpts          /dev/pts        devpts  gid=5,mode=620  0       0
tmpfs           /run            tmpfs   defaults        0       0
devtmpfs        /dev            devtmpfs mode=0755,nosuid 0     0
```

### Explicação dos Campos:
1.  **Dispositivo**: Pode ser o caminho (`/dev/sda1`), o UUID ou o LABEL.
2.  **Ponto de Montagem**: Onde o diretório será acessível.
3.  **Tipo**: `ext4`, `xfs`, `vfat`, ou sistemas virtuais como `proc` e `sysfs`.
4.  **Opções**: `defaults` (rw, suid, dev, exec, auto, nouser, async).
5.  **Dump**: Usado pelo utilitário `dump` para backup (geralmente 0 ou 1).
6.  **Pass**: Ordem em que o `fsck` verifica o disco no boot (1 para `/`, 2 para outros, 0 para ignorar).

---

## Resumo da Filosofia LFS
A configuração desses arquivos segue o princípio da **transparência**. Ao criá-los manualmente:
*   Você entende exatamente quem tem acesso ao sistema (`passwd/group`).
*   Você controla como a rede identifica a máquina (`hostname`).
*   Você define a estrutura de armazenamento de forma explícita (`fstab`).
