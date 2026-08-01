23. Software, Dependências e Pacotes

Quando você instala um programa, ele (geralmente) depende de bibliotecas. Sem um gerenciador de pacotes, você teria que descobrir e instalar cada dependência manualmente, na ordem correta, evitando conflitos de versão. É o "inferno das dependências".

Um pacote é um arquivo compactado que contém:
- Binários compilados
- Arquivos de configuração
- Scripts de instalação/desinstalação
- Metadados

| Formato | Distribuição | Extensão |
| ------- | ------------ | -------- |
| DEB | Debian, Ubuntu | `.deb` |
| RPM | Fedora, RHEL, CentOS | `.rpm` |
| PKG | Arch Linux | `.pkg.tar.zst` |
| APK | Alpine Linux | `.apk` |

```bash
# um .dev é um arquivo ar (similar a tar)

$ ar x pacote.dev
$ ls
control.tar.gz
data.tar.gz
debian-binary

# control.tar.gz contém metadados
$ tar -xzf control.tar.gz
$ cat control
Package: nginx
Version: 1.18.0-6ubuntu14
Depends: libc6 (>= 2.14), libpcre3, zlib1g
Maintainer: Ubuntu Developers
Description: A high performance web server

# data.tar.gz contém os arquivos a instalar
$ tar -xzf data.tar.gz
$ find . -type f
./usr/sbin/nginx
./etc/nginx/nginx.conf
./var/www/html/index.html
```