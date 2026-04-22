# A Entrega das Atividades

Repositório para envio das atividades práticas da oficina de Linux. O objetivo desde arquivo é entender o básico de como o Git funciona.

## O que é Git?

Git é um sistema de controle de versão.

Ele permite:
- salvar versões do seu trabalho ao longo do tempo;
- acompanhar mudanças;
- colaborar com outras pessoas sem sobrescrever arquivos.

É um histórico inteligente dos seus arquivos.

## O que é GitHub?

GitHub é um serviço online onde podemos armazenar repositórios Git.

Ele permite:
- guardar seus projetos na nuvem;
- compartilhar com outras pessoas;
- colaborar através de Pull Requests

## Conceitos

### Repositório

É a pasta do projeto com controle de versão.

### Commit

É um "ponto de salvamento" no histórico.

### Push

Envia seus commits para o GitHub.

### Pull Request (PR)

É um pedido para que suas alterações sejam incluídas no repositório central.

## Como enviar a sua atividade:

1. Fazer Fork.

Na página do repositório, clique em **Fork**. Isso cria uma cópia do repositório na sua conta.

2. Clonar o seu repositório.

Copie a URL do seu fork e execute:

```bash
git clone <url-do-seu-fork>
cd <nome-do-repositorio>
```

Isso baixa os arquivos para o seu computador.

3. Criar sua pasta.

Crie uma pasta com seu nome dentro de `lab/`:

```bash
cd noturno/lab
mkdir seu-nome
```

Coloque seus arquivos lá.

4. Adicionar arquivos.

```bash
git add .
```

Este comando prepara seus arquivos para serem salvos.

5. Fazer commit.

```bash
git commit -m "entrega: atividade x"
```

Isso cria um ponto no histórico com suas alterações.

6. Enviar para o GitHub.

```bash
git push
```

Isso envia seus commits para o seu repositório no GitHub.

7. Abrir um Pull Request.

No GitHub:
- vá até seu repositório
- clique em **Compare & pull request**
- confirme o envio

## Problemas Comuns

### "git não funciona"

Instale o Git: [https://git-scm.com/](https://git-scm.com)

### "permission denied"

Verifique se você está usando o repositório correto (seu fork).

### "nothing to commit"

Você não fez alterações ou já adicionou tudo.

### "rejected"

Você pode precisar fazer:

```bash
git pull
```