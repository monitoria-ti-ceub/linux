# Distribuição e Deployment

A execução do script de release gerou o arquivo de carga útil (`rootfs.tar.gz`). O próximo passo é a masterização da Imagem ISO Híbrida (que envolverá a carga útil) e a disponibilização deste arquivo para o público. A engenharia de Deployment (Implantação/Lançamento) é subestimada no CEUB mas foda-se. É o fator determinante entre um projeto que morre no disco rígido do desenvolvedor e um projeto que atinge um zilhão de usuários.

## A Hospedagem de Binários Massivos

O arquivo de código-fonte de um script em Python pode ter 10 Kilobytes. A hospedagem de código-fonte é trivial e gratuita. Mas, uma imagem ISO de um sistema operacional, mesmo que minimalista, varia entre 50 Megabytes e vários Gigabytes.

A hospedagem de artefatos binários massivos impõe dois desafios logísticos severos:

1. Custo de Armanezamento (Storage): Manter versões antigas para fins de rollback ou arquivamento consome espaço.
2. Custo de Transferência de Dados (Bandwidth/Egress): O assassino de projetos. Se a ISO tiver 100MB e 10.000 usuários fizerem o download no dia do lançamento, o servidor precisará transferir 1 Terabyte de dados. A maioria dos provedores de nuvem (AWS, Google Cloud) cobra taxas absurdas pelo tráfego de saída (Egress). Um lançamento bem-sucedido pode resultar em uma fatura de hospedagem devastadora.

### Estratégias de Hospedagem

Para contornar os custos de transferência, os projetos de código aberto (open-source) adotam estratégias específicas de hospedagem.

#### Hospedagem Tradicional (Servidor Web Dedicado)

O administrador aluga um servidor VPS (Virtual Private Server) e configura um servidor web (Nginx ou Apache) para servir os arquivos `.iso` diretamente.

- Vantagens: Controle absoluto sobre o servidor e os logs de acesso.
- Desvantagens: Risco do servidor cair sob a carga de muitos downloads simultâneos (Efeito Slashdot ou Hug of Death). Custos de banda podem ser altos dependendo do provedor.

#### Redes de Distribuição de Conteúdo (CDNs)

A ISO é hospedada em um servidor central (origem) mas os downloads são servidos por uma rede global de servidores em cache (CDN, como Cloudflare ou Fastly).

- Vantagens: O download é rápido para usuários em qualquer parte do mundo pois o arquivo é servido do servidor mais próximo (geograficamente). O servidor de origem fica protegido contra sobrecarga.
- Desvantagens: Configuração complexa. CDNs gratuitas frequentemente impõem limites rígidos no tamanho de arquivos binários (limite de 100MB por arquivo no Cloudflare gratuito) ou proíbem explicitamente o uso da CDN puramente para distribuição de arquivos massivos (violando os Termos de Serviço).

#### GitHub Releases

O GitHub (e o Git Lab) oferece um recurso especificamente desenhado para resolver este problema: o "Releases". Além de hospedar o código-fonte (os scripts de build e os `Pkgfile`), o GitHub permite que o desenvolvedor anexe arquivos binários compilados (Assets) a uma tag de versão (Release).

- Vantagens: É completamente gratuito para projetos de código aberto. O GitHub absorve todos os custos de armanezamento e largura de banda. A infraestrutura deles é global e praticamente imune a quedas por excesso de tráfego. O download fica intrinsicamente ligado ao código-fonte que gerou ele.
- Desvantagens: Limite de 2GB por arquivo individual (o que é mais do que o suficiente para a nossa distribuição).

### A Implementação Prática (GitHub Releases)

Para a oficina, o GitHub Releases é a única escolha arquiteturalmente sensata e financeiramente sustentável.

**Fluxo de Trabalho do Deployment:**

1. O Repositório Central: Todo o código desenvolvido ao longos dos ciclos deve estar versionado em um repositório Git.
2. A Tag de Versão: Quando o script `release-build.sh` gera a versão `1.0.0`, o administrador deve criar uma Tag correspondente no Git.

```bash
git tag -a v1.0.0 -m "Lançamento da Versão 1.0.0 (Lovelace)"
git push origin v1.0.0
```

3. A Criação do Release (Interface Web ou CLI): Not GitHub, o administrador navega até a seção "Releases" e clica em "Draft a new release". Selecionaa tag `v1.0.0`. Preenche o título e as Notas de Lançamento (Release Notes), detalhando as novidades e correções de bugs.

