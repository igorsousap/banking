# {OBJ_Banking}

Projeto destinado ao test case para squad de Elixir na objective

## Pré-requisitos

Antes de começar, verifique se você possui as seguintes ferramentas instaladas em sua máquina:

- Erlang 25.1.2 or higher
- Elixir 1.16.2-otp-25 or higher
- PostgreSQL or Docker
- ASDF in case of not have elixir or erlang instaled

## Passo 1: Run ASDF

Comece instalando erlang e elixir com:
```bash
asdf install
```
Caso ja possua os dois instalados pular esse passo

## Passo 2: Subir Dcker

Suba o docker com o comando:

```bash
sudo docker compose up
```

Caso use a postgreSQL instalado na maquina pular esse passo

## Passo 3: Iniciando projeto

Apos definir o ambiente iniciaremos o projeto com
```bash
mix deps.get
mix ecto.create
mix ecto.migrate
iex -S mix phx.server
```
Com esses passos instalamos as dependecias necessarias, criamos o banco e definimos as migracoes
Por fim iniciamos o projeto
## Passo 4: Endpoints de comunicacao

PUtilizando o postman ou qualquer software similar chamamos as rotas:

- POST localhost:4000/api/conta body: {"conta_id": 1, "saldo": 500}
    Cria uma conta e define saldo 500
- GET localhost:4000/api/conta/?id=1
    Retorna a conta com ID 1
- PUT localhost:4000/api/conta body: {"conta_id": 2, "valor": 120}
    Soma ao saldo um valor especifico
- POST localhost:4000/api/transacao body: {"forma_pagamento":"C", "conta_id": 2, "valor": 10}
    Realiza as transacoes a depender da forma de pagamento "C" - credito "D" - debito "P" - PIX
- POST localhost:4000/api/transacao/schedule body {"forma_pagamento":"D", "conta_id": 1, "valor": 100, "schedule_at": "2024-06-07"}

