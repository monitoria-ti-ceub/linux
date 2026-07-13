# Configurações de rede

## 1. Modelo OSI
    
Antes de gerenciar os arquivos de rede de nossa distro, primeiro temos que entender alguns conceitos essenciais de redes. Começando com os modelos de rede, que nada mais são a forma em que dados são transferidos de uma máquina para outra e as etapas em que uma informação percorre antes de ocorrer a transferência de dados

O modelo OSI é um modelo teórico amplamente utilizado para demonstrar e estudar as diferentes eventos que ocorrem em uma transferência de pacotes de dados e onde esses eventos ocorrem. O modelo é dividido em 7 camadas, essas são:

- Camada Fisica: A parte fisica na transferência de dados, são os cabos que transferem dados para dentro e para fora do hardware através de pulsos elétricos ou de luz.
- Camada de Enlace: A parte que detecta erros da camada física e estabelece o protocolo de comunicação entre dois sistemas diretamente conectados.
- Camada de Rede: É a camada onde ocorrem os “saltos” entre um roteador e outro, basicamente traçando o trajeto que um pacote irá viajar até atingir seu destino. Além disso ele transforma os segmentos de dados nos pacotes que realmente serão enviados por rede.
- Camada de Transporte: A camada de transporte é responsável por transformar os dados em processo de transferência em pacotes e o contrário no caso do receptor dos dados. Esses pacotes existem para segmentar os dados sendo transferidos, isso ocorre com fins de:
    - Evitar o congestionamento de rede: Os dados que estão sendo transferidos podem possuir diversos GB de tamanho e a transferência continua desses dados iria impedir a ocorrência de outras comunicações que a sua máquina realiza. Por isso eles são divididos em pacotes menores para que eles possam ser transferidos mais rapidamente sem congestionar a banda.
    - Seguir rotas diferentes: as vezes, na camada de rede, o mesmo trajeto que um pacote anterior percorreu pode não ser o trajeto mais eficiente para o próximo pacote. Imagine um caso de uma malha rodoviária, as vezes o trajeto que é normalmente é mais rápido pode estar congestionado, fazendo com que outra via fique mais rápida, ou a via mais rápida pode descongestionar, fazendo com que as outras vias sejam menos eficientes, lembrando que o processo de escolher a melhor rota é feita na camada de rede.
    - Melhor correção de erros: caso um pacote seja corrompido ou tenha a sua transferência interrompida, por se tratar de um pacote menor é mais fácil reenviar o pacote, não precisamos enviar o arquivo inteiro, este processo de verificação de erros é feita na própria camada de transporte.
- Camada de Sessão: é a camada onde ocorre a comunicação inicial que conecta dois hosts.
- Camada de Apresentação: esta camada é a responsável por traduzir o formato dos dados originais enviados no formato padronizado utilizado para transferência de dados.
- Camada de Aplicação: é onde ocorre a interação entre o usuário e a máquina.

## 2. Modelo TCP/IP

O modelo OSI é um modelo utilizado estritamente para fins educativos e acadêmicos. Para entender como essa estrutura é realmente implementada nos precisamos entender o modelo TCP/IP.

O modelo TCP/IP é um modelo prático e descritivo de 4 camadas, criado pelo Departamento de Defesa dos EUA (DoD) para a ARPANET (a precursora da internet). Ele foi desenvolvido ao redor de protocolos que já estavam funcionando (TCP e IP) e ele não se preocupa tanto com fronteiras rígidas (Como as do modelo OSI), mas sim com a eficiência e em fazer a comunicação acontecer.

As camadas do modelo TCP/IP executam as mesmas tarefas que as camadas do modelo OSI, porém sua representação indica quais serviços estão sendo de fato executados durante a transferência de dados:
- Camada de acesso a rede (Ou enlace): engloba as camadas física e de enlace do modelo OSI.
- Camada de Internet: engloba a camada de rede do modelo OSI.
- Camada de transporte: engloba a camada de transporte do modelo OSI.
- Camada de aplicação: engloba as camadas de sessão, apresentação e aplicação do modelo OSI.

## 3. Arquivos de configuração

- /etc/sysconfig/ifconfig.eth0: É o principal arquivo lido pelo script de rede que iremos fazer, eth0 é o nome da interface de rede que estamos lidando (Nossa placa de rede principal para o sistema)
- Hostname: Já configuramos o hostname anteriormente, é importante para estabelecermos nosso IP de forma estática
- Host: Estabelece as principais IPs do nosso sistema, elas sendo de
    -   Loopback: IP que faz com que o SO envie dados para a própria maquina, quando estabelecemos uma conexão com o localhost estamos fazendo através do ip de loopback.
    - Gateway: IP de gateway geralmente se refere a interface de rede que conecta diretamente ao nosso ISP para comunicar com a internet. É como se fosse a “porteira” da nossa rede.
    - Broadcast: IP de Broadcast é o IP que é utilizado para enviar dados para todos os dispositivos da rede.
- /etc/resolv.conf: é o arquivo que indica os IPs dos servidores de domain name service (DNS), para que, ao digital uma url, o sistema se refira ao servidor indicado neste arquivo e te transfira para o endereço de ip correspondente aquela url.

## 4. Ferramentas de rede
- Net-tools: é o pacote do linux que contém os comandos de linha de comando utilizados para definir configurações de rede:
    - Ifconfig: ver e configurar interfaces de rede (Agora ip addr ou ip link no iproute2)
    - Netstat: exibe as conexões ativas e tabelas de roteamento (Agora ss no iproute2)
    - Route : gerencia tabelas de roteamento (Agora ip route no iproute2)

    Essas ferramentas usam chamadas de sistema chamadas ioctl (Input/Output Control). Essa é uma interface antiga, síncrona e engessada. Ela não foi projetada para lidar com configurações de rede complexas, como múltiplos endereços IP na mesma interface (exigindo "apelidos" virtuais como eth0:1), roteamento baseado em políticas ou namespaces.

- Iproute2: O que vamos utilizar para nosso sistema. É o pacote que possui suporte ativo (net-tools caiu em desuso) e é muito mais robusto e eficiente que o net-tools. 

    O Iproute2 utiliza a API Netlink, um protocolo projetado especificamente para a comunicação entre o kernel e o espaço do usuário no no âmbito de redes. O Netlink é muito mais rápido, assíncrono e flexível. Ele permite que o iproute2 veja e modifique recursos avançados da rede que o net-tools sequer sabe que existem.

Uma diferença interessante dele para o Net-tools é que, por conta dessa mudança de API entre os dois, o ifconfig do Net-tools pode literalmente mentir para você hoje em dia. Se você adicionar múltiplos IPs a uma interface usando o iproute2, o ifconfig pode mostrar apenas o IP principal e ocultar os outros, pois a API ioctl não consegue enxergar as estruturas de dados modernas

## 5. Atribuição de IP
- IP Estático: Atribuição estática de IP é basicamente você mesmo atribuir seu próprio IP e máscara de rede. É recomendável para servidores. Oferece boot mais rápido e garantia de estabilidade para regras de firewall, porem é mais propricio a erros e exige constante manutenção e acompanhamento.
- DHCP (Dynamic Host Configurarion Protocol): Protocolo de rede que atribui seu IP e máscara automaticamente. Dependendo da sua situação o DHCP é feito pelo próprio roteador em casos residenciais, ambiente corporativos geralmente possuem seus próprios servidores DHCP dedicados. Utilizaremos esse protocolo para estabelecer o endereço de IP da nossa máquina.

## 6. SSH (Secure shell)
- O que é um secure shell: Secure shell é um protocolo de rede que permite estabelecer uma conexão remota com uma máquina. É um protocolo essencial para administrar servidores.
- OpenSSH: é o conjunto de utilitários que fazem possível estabelecer um servidor SSH criptografado e seguro.
    - Sshd_config: é o principal arquivo de configuração para o OpenSSH. Ele determina como o servidor de SSH irá tratar acessos remotos, metodos de autenticação e segurança de rede na porta SSH.
- Dropbear: é u

## 7. Firewall
- Netfilter: o netfilter é o “motor” de firewall para sistemas Linux, ele que decide quais pacotes de dados entram ou saem da sua máquina.
- iptable/nftables: são as interfaces utilizadas para o usuário poder controlar o Netfilter:
    - iptables (Fragmentado): no passado, o Linux exigia uma ferramenta de linha de comando diferente para cada protocolo de rede. Se você quisesse configurar regras para um endereço IPv4, usava o iptables. Para um endereço IPv6, usava o ip6tables. Para ARP (Protocolo que liga um IP a um endereço MAC), arptables, e para pontes Ethernet (bridges), o ebtables. Isso gerava redundância no aprendizado e na manutenção de scripts.
    Algo importante de mencionar é que o iptables avalia as regras de forma estritamente linear. Se você tiver uma lista de regras para bloquear 10.000 IPs maliciosos, o kernel precisará testar o pacote que chega contra a regra 1, depois a regra 2, até a regra 10.000, criando um gargalo de processamento e de latência.
    - nftables (Unificado): o nftables troca todas essas ferramentas por um único utilitário de linha de comando, o nft. Com ele, você pode gerenciar IPv4, IPv6, ARP e bridges em um só lugar, permitindo, por exemplo, criar regras unificadas (família inet) que aplicam as mesmas políticas simultaneamente para IPv4 e IPv6.
    Para o nftables, ele introduz o suporte nativo a Sets (conjuntos) e Maps (mapas/dicionários) diretamente no kernel. Em vez de criar 10.000 regras, você cria uma regra que aponta para um conjunto de regras contendo os 10.000 IPs. A busca nesse conjunto é feita através de estruturas de dados de altíssimo desempenho (como tabelas hash), o que significa que avaliar 1 IP ou 10.000 IPs leva praticamente o mesmo tempo.
- Regras de Firewall: firewalls geralmente tem regras para a saída e entrada de dados, porém, o administrador do sistema pode impor mais regras dentro desses fluxos, ele pode impor regras de quais portas podem ser utilizadas em um determinado sistema (por exemplo, podemos impedir qualquer tipo de conexão pela porta 22 - SSH para impedir acesso remoto à nossa máquina), impedir certos IPs de enviarem pacotes ou receberem pacotes da máquina, entre outros exemplos.

## 8. DNS
- O que é DNS: Domain name service é um dos serviços essenciais da internet, é este serviço que associa um endereço web (uma url) com um IP específico. Ex: quando escrevemos google.com o DNS “traduz” a url para um endereço de IP que possamos nos conectar, neste caso, o IP 8.8.8.8
- Resolv.conf: repetindo, é o arquivo que refere aos IPs dos servidores DNS.
- Stub_resolver: é o componente que de fato executa o serviço DNS, ele que faz a tradução, comunicando com um servidor DNS


