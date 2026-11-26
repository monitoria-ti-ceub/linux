## **31. Configuração de Rede e Serviços Básicos**

Até este ponto, a sua distribuição Linux é um universo fechado. Você compilou o kernel, montou o sistema de arquivos raiz, configurou o boot e instalou ferramentas essenciais. O sistema liga, você faz login, mas ele não consegue falar com ninguém. Ele não pode baixar novos softwares, não pode servir páginas web e não pode ser acessado remotamente.
Para transformar esse sistema isolado em um servidor ou desktop funcional, precisamos configurar a pilha de rede e iniciar os serviços (daemons) que ficarão escutando por conexões.

O kernel Linux possui uma das pilhas de rede (TCP/IP) mais robustas do mundo. Ele é capaz de rotear pacotes, fazer NAT (Network Address Translation) e filtrar tráfego (firewall) em altíssima velocidade.

Porém, o kernel não toma decisões sozinho. Ele expõe as placas de rede físicas (NICs) como interfaces lógicas (ex: `eth0`, `enp3s0`, `wlan0`), mas cabe aos programas no espaço de usuário (user space) dizer ao kernel quais endereços IP atribuir a essas interfaces e quais rotas usar.

O pacote `net-tools` fornecia os comandos clássicos: `ifconfig` (para ver IPs), `route` (para tabelas de roteamento) e `netstat` (para ver portas abertas).

Essas ferramentas são obsoletas há mais de uma década. Elas não suportam recursos modernos do kernel (como namespaces de rede ou túneis complexos). O padrão absoluto é o pacote `iproute2`, que centraliza quase todas as operações de rede no poderoso comando `ip`.

Antes de automatizar a rede com gerenciadores complexos (NetworkManager), você precisa entender como configurá-la manualmente.

1. Identificando as Interfaces

Vamos ver o que o kernel detectou.

```bash
ip link show
```

Você verá a interface de loopback (`Io`), que é virtual e usada para comunicação interna (`127.0.0.1`), e as suas placas física (ex: `enp0s3` para cabo, `wlp2s0` para Wi-Fi).

Por padrão, a placa física estará com o estado `DOWN` (desligada).

```bash
ip link set enp0s3 up
```

2. Atribuindo um Endereço IP (Estático)

Se você estiver configurando um servidor, ele precisa de um IP fixo (estático). O comando `ip addr` lida com isso. Você deve fornecer o IP e a máscara de sub-rede na notação CIDR (ex: `/24` equivale a `255.255.255.0`).

```bash

# adiciona o IP 192.168.1.100 à interface enp0s3
ip addr add 192.168.1.100/24 dev enp0s3
```

Agora, você consegue "pingar" outras máquinas na mesma rede local, mas você não consegue acessar a internet.

3. O Roteamento (Gateway)

A sua máquina não sabe como chegar a IPs que não estão na sua rede local (192.168.1.x). Ela precisa de uma "rota padrão" (defaut gateway), que é o endereço IP do seu roteador. O roteador é a porta de saída para a internet.

```bash

# "se você não sabe para onde enviar o pacote, envie para 192.168.1.1"
ip route add default via 192.168.1.1
```

Agora, você consegue pingar IPs na internet, mas ainda não consegue acessar sites pelo nome.

4. Resolução de Nomes (DNS)

O kernel lida com IPs mas humanos lidam com nomes de domínio. A tradução é feita pelo DNS (Domain Name System).

A configuração mais básica (e universal) do DNS no Linux é um arquivo de texto: `/etc/resolv.conf`

Crue este arquivo e adicione os IPs dos servidores DNS que você confia (ex: Google ou Cloudfare):

```text
nameserver 8.8.8.8
nameserver 1.1.1.1
```

A rede manual está configurada.

--------

Configurar IPs manualmente em um notebook que muda de rede toda hora é inviável. É para isso que serve o DHCP (Dynamic Host Configuration Protocol).

Quando você conecta o cabo de rede, um "cliente DHCP" (um daemon rodando em background na sua máquina) grita na rede (via broadcast): "Alguém tem um IP para me emprestar?". O servidor DHCP (roteador), responde oferecendo um IP, a máscara, o gateway e os servidores DNS.

O cliente DHCP executa automaticamente os comandos `ip addr`, `ip route` e reescreve o `/etc/resolv.conf` para você.

Se você usar o BusyBox, ele inclui um cliente DHCP minúsculo e excelente chamado `udhcpc`.

```bash

# inicia o cliente DHCP na interface enp0s3
udhcpc -i enp0s3
```

