# Gerenciador de Arquivos - Atividade IX
**Autor:** Daniel Esmeraldo  
**Data:** 01/05/2025  
**Versão:** 1.0  
**Descrição:** Sistema de gerenciamento de arquivos no terminal com logs e relatórios.

## Pré-requisitos
- Sistema operacional Linux (ou WSL/container Docker)
- Bash 4.0 ou superior
- Permissão de leitura/escrita no diretório de trabalho

## Funcionalidades
- Adicionar arquivo
- Listar arquivos
- Buscar arquivo (em todo o sistema)
- Deletar arquivo (com confirmação)
- Gerenciar permissões (chmod)
- Gerenciar proprietários (chown)
- Gerar relatório completo
- Log de todas as operações

## Estrutura do Código
O script é organizado nas seguintes funções:
- `adicionar_arquivo()` - Cria um novo arquivo vazio
- `listar_arquivos()` - Lista todos os arquivos do diretório
- `buscar_arquivo()` - Busca arquivos em todo o sistema
- `deletar_arquivo()` - Remove arquivos com confirmação
- `gerenciar_permissoes()` - Altera permissões (chmod)
- `gerenciar_proprietarios()` - Altera dono/grupo (chown)
- `gerar_relatorio()` - Exibe estatísticas e log
- `sair()` - Encerra o programa registrando saída

## Log de Operações
Todas as ações são registradas em `log.txt` no formato:
AAAA-MM-DD HH:MM:SS - usuário - ação

## Exemplo de Uso
```bash
$ ./gerenciador.sh

----------------------GERENCIADOR DE ARQUIVOS----------------------
1) Adicionar arquivo
2) Listar arquivos
...
Escolha uma opção: 1
Informe o nome do arquivo a adicionar: relatorio.txt
Arquivo relatorio.txt criado com êxito.

Escolha uma opção: 7
================================RELATÓRIO================================
Quantidade de arquivos: 1
Quantidade de diretórios: 0
Espaço total usado: 4.0K
...

## Troubleshooting
| Erro | Possível causa | Solução |
|------|----------------|---------|
| `Usuário X não existe!` | Usuário inválido no chown | Verifique com `id usuario` |
| `Grupo Y não existe!` | Grupo inválido | Verifique com `getent group grupo` |
| `Arquivo não encontrado` | Arquivo não existe | Use `ls -la` para listar arquivos |

## Como executar
```bash
chmod +x script.sh
./script.sh

## Licença
Este projeto é de uso acadêmico para a Oficina de Linux.
