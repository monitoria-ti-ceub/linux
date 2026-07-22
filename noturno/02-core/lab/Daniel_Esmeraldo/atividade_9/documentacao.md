# Gerenciador de Arquivos

Script de gerenciamento de arquivos e diretórios desenvolvido em Bash. Oferece uma interface interativa no terminal com menus de navegação, permitindo realizar operações comuns do sistema de arquivos sem precisar memorizar comandos manualmente.

---

## Requisitos

- Sistema operacional Linux ou macOS
- Bash 4.0 ou superior
- Permissões adequadas para executar operações de `chmod` e `chown` (algumas funções podem exigir `sudo`)

---

## Como executar

```bash
# Dê permissão de execução ao script
chmod +x gerenciador.sh

# Execute o script
./gerenciador.sh
```

---

## Estrutura do Menu

```
GERENCIADOR DE ARQUIVOS
|
|-- Arquivo
|   |-- Adicionar arquivo
|   |-- Buscar arquivo
|   |-- Visualizar conteudo
|   |   |-- Visualizar todo o conteudo
|   |   |-- Visualizar as N primeiras linhas
|   |   |-- Visualizar as N ultimas linhas
|   |   `-- Buscar por uma palavra
|   `-- Deletar arquivo
|
|-- Diretorio
|   |-- Adicionar diretorio
|   |-- Buscar diretorio
|   `-- Deletar diretorio
|
|-- Copiar item
|-- Mover/renomear item
|-- Listar
|-- Gerenciar permissoes
|-- Gerenciar proprietarios
|-- Compactar
|-- Descompactar
|-- Navegar
|-- Backup
|-- Gerar relatorio
|-- Ajuda
`-- Sair
```

---

## Funcoes

### `adicionar_arquivo`

Cria um novo arquivo vazio no diretorio atual.

- Solicita o nome do arquivo ao usuario
- Verifica se ja existe um arquivo ou diretorio com o mesmo nome
- Cria o arquivo com `touch` caso o nome esteja disponivel
- Registra a operacao no `log.txt`

---

### `buscar_arquivo`

Busca um arquivo pelo nome a partir do diretorio atual.

- Solicita o nome do arquivo ao usuario
- Utiliza `find` para localizar arquivos recursivamente
- Exibe o caminho completo caso encontrado
- Registra a operacao no `log.txt`

---

### `deletar_arquivo`

Remove um arquivo do sistema.

- Solicita o nome do arquivo ao usuario
- Verifica se o arquivo existe
- Pede confirmacao antes de deletar (`s/n`)
- Remove o arquivo com `rm` apos confirmacao
- Registra a operacao no `log.txt`

---

### `visualizar_conteudo`

Exibe o conteudo de um arquivo com diferentes modos de visualizacao.

- Solicita o nome do arquivo ao usuario
- Exibe um submenu com as opcoes abaixo:

| Opcao                        | Descricao                                              |
|------------------------------|--------------------------------------------------------|
| Visualizar todo o conteudo   | Exibe o arquivo completo com `cat`                    |
| N primeiras linhas           | Exibe as N primeiras linhas com `head`                |
| N ultimas linhas             | Exibe as N ultimas linhas com `tail`                  |
| Buscar por uma palavra       | Busca um padrao no arquivo com `grep`                 |

**Funcoes auxiliares de visualizacao:**

- `visualizar_head [arquivo]`: usa `head -n N` para exibir as primeiras linhas. Padrao: 10 linhas.
- `visualizar_tail [arquivo]`: usa `tail -n N` para exibir as ultimas linhas. Padrao: 10 linhas.
- `visualizar_grep [arquivo]`: usa `grep -i -n --color=always` para busca case-insensitive com numeracao de linhas.

---

### `adicionar_diretorio`

Cria um novo diretorio no local atual.

- Solicita o nome do diretorio ao usuario
- Verifica se ja existe algum item com o mesmo nome
- Cria o diretorio com `mkdir`
- Registra a operacao no `log.txt`

---

### `buscar_diretorio`

Busca um diretorio pelo nome a partir do diretorio atual.

- Solicita o nome do diretorio ao usuario
- Utiliza `find -type d` para localizar diretorios recursivamente
- Exibe o caminho completo caso encontrado
- Registra a operacao no `log.txt`

---

### `deletar_diretorio`

Remove um diretorio e todo o seu conteudo.

- Solicita o nome do diretorio ao usuario
- Exibe um aviso sobre a remocao permanente de todo o conteudo interno
- Pede confirmacao antes de deletar (`s/n`)
- Remove o diretorio com `rm -r` apos confirmacao
- Registra a operacao no `log.txt`

---

### `listar`

Lista todos os arquivos e diretorios do diretorio atual.

- Executa `ls -la` para exibir permissoes, proprietarios, tamanho e data
- Registra a operacao no `log.txt`

---

### `gerenciar_permissoes`

Altera as permissoes de um arquivo ou diretorio.

- Solicita o nome do item e o codigo de permissao (ex: `755`, `644`)
- Valida se o codigo esta no formato octal correto (3 ou 4 digitos de 0 a 7)
- Aplica a permissao com `chmod`
- Registra a operacao no `log.txt`

**Exemplos de permissoes comuns:**

| Codigo | Significado              |
|--------|--------------------------|
| 644    | rw-r--r-- (arquivo padrao) |
| 755    | rwxr-xr-x (executavel)  |
| 600    | rw------- (privado)      |
| 700    | rwx------ (diretorio privado) |

---

### `gerenciar_proprietarios`

Altera o proprietario e/ou grupo de um arquivo ou diretorio.

- Solicita o nome do item, o novo usuario e opcionalmente o novo grupo
- Valida se o usuario existe com `id`
- Valida se o grupo existe com `getent group` (quando informado)
- Aplica a alteracao com `chown`
- Registra a operacao no `log.txt`

---

### `copiar_item`

Copia um arquivo ou diretorio para um destino especificado.

- Solicita a origem e o destino
- Detecta se a origem e arquivo (`cp -i`) ou diretorio (`cp -r -i`)
- O parametro `-i` solicita confirmacao em caso de sobrescrita
- Registra a operacao no `log.txt`

---

### `mover_renomear_item`

Move ou renomeia um arquivo ou diretorio.

- Solicita a origem e o caminho/nome de destino
- Utiliza `mv -i` para evitar sobrescrita acidental
- Serve tanto para mover (caminho diferente) quanto para renomear (mesmo diretorio, nome diferente)
- Registra a operacao no `log.txt`

---

### `compactar`

Compacta um arquivo ou diretorio no formato `.tar.gz`.

- Solicita o nome do item a compactar e o nome do arquivo de saida (sem extensao)
- Gera um arquivo `<saida>.tar.gz` com `tar -czf`
- Registra a operacao no `log.txt`

---

### `descompactar`

Extrai o conteudo de um arquivo `.tar.gz`.

- Solicita o nome do arquivo (sem a extensao `.tar.gz`)
- Verifica se o arquivo existe e possui a extensao correta
- Solicita o diretorio de destino (Enter para o diretorio atual)
- Extrai com `tar -xzf`
- Registra a operacao no `log.txt`

---

### `navegar`

Muda o diretorio de trabalho atual do script.

- Solicita o caminho do diretorio ao usuario
- Verifica se o diretorio existe
- Executa `cd` e exibe o novo caminho com `pwd`
- Registra a operacao no `log.txt`

> **Observacao:** a navegacao afeta apenas o processo do script. O diretorio do terminal de onde o script foi chamado nao e alterado.

---

### `backup`

Cria uma copia de segurança de um arquivo ou diretorio com timestamp.

- Solicita o nome do item a fazer backup
- Cria o diretorio `backup/` no local atual, se nao existir
- Gera a copia com nome no formato `<nome>_YYYYMMDD_HHMMSS`
- Registra a operacao no `log.txt`

---

### `gerar_relatorio`

Exibe um relatorio completo sobre o diretorio atual.

O relatorio inclui:

- Quantidade de arquivos
- Quantidade de diretorios
- Espaco total utilizado (`du -sh`)
- Listagem detalhada com permissoes (`ls -la`)
- Historico completo de operacoes do `log.txt`

---

### `ajuda`

Exibe uma tela de ajuda com o resumo de todas as funcionalidades e instrucoes de uso.

---

### `sair`

Encerra o programa.

- Registra o encerramento no `log.txt`
- Executa `exit 0`

---

## Log de Operacoes

Todas as acoes realizadas sao registradas automaticamente no arquivo `log.txt`, no diretorio de trabalho atual do script.

**Formato de cada entrada:**

```
YYYY-MM-DD HH:MM:SS - <usuario> <descricao da acao>
```

**Exemplo:**

```
2025-05-03 14:32:10 - daniel criou arquivo relatorio.txt
2025-05-03 14:33:05 - daniel procurou por arquivo config.sh
2025-05-03 14:35:22 - daniel removeu o arquivo relatorio.txt
```

O inicio e o encerramento do programa tambem sao registrados com uma linha separadora para facilitar a leitura do historico.

---

## Variaveis Globais

| Variavel  | Descricao                                                             |
|-----------|-----------------------------------------------------------------------|
| `USUARIO` | Nome do usuario atual. Obtido via `$USER` ou `whoami` como fallback  |

---

## Observacoes

- O script utiliza o comando `select` do Bash para gerar os menus interativos, o que garante compatibilidade com terminais padrao.
- Operacoes de `chown` e alteracoes de permissoes em arquivos de sistema podem exigir privilegios de superusuario (`sudo`).
- A funcao `navegar` altera o diretorio apenas dentro do contexto de execucao do script.
- O arquivo `log.txt` e criado automaticamente na primeira operacao realizada, no diretorio de onde o script for executado.
