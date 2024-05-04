defmodule ObjBaking.Transactions.Transaction do
  require Logger

  alias ObjBaking.Persistence.Contas

  @doc """
  Receive a account id to be updated on database
  ## Examples

      iex>  ObjBaking.Transactions.Transaction.transaction(%{
          "conta_id" => 10,
          "valor" => 10,
          "forma_pagamento" => "D"
        })

  """
  @spec transaction(%{
          :forma_pagamento => String.t(),
          :valor => Integer.t(),
          :conta_id => Integer.t()
        }) :: {:ok, map()} | {:error, :not_found_payment}
  def transaction(%{"forma_pagamento" => forma_pagamento} = args) do
    case Contas.get_conta(args["conta_id"]) do
      {:error, :account_not_found} ->
        {:error, :account_not_found}

      account ->
        Logger.info("Iniciando a transacao")
        define_payment(forma_pagamento, account, args["valor"])
    end
  end

  defp define_payment(forma_pagamento, account, valor) do
    case forma_pagamento do
      "D" -> debito(account, valor)
      "C" -> credito(account, valor)
      "P" -> pix(account, valor)
    end
  end

  defp debito(
         %ObjBaking.Persistence.Contas.Conta{conta_id: conta_id, saldo: saldo},
         valor
       ) do
    Logger.info("Pagamento no debito no valor de #{valor} reais")
    new_saldo = saldo - valor * 1.03
    Contas.update_saldo(%{"conta_id" => conta_id, "saldo" => new_saldo})

    {:ok,
     %{
       "conta_id" => conta_id,
       "saldo" => new_saldo
     }}
  end

  defp credito(
         %ObjBaking.Persistence.Contas.Conta{conta_id: conta_id, saldo: saldo},
         valor
       ) do
    Logger.info("Pagamento no debito no Credito no valor de #{valor} reais")
    new_saldo = saldo - valor * 1.05

    Contas.update_saldo(%{"conta_id" => conta_id, "saldo" => new_saldo})

    {:ok,
     %{
       "conta_id" => conta_id,
       "saldo" => new_saldo
     }}
  end

  defp pix(
         %ObjBaking.Persistence.Contas.Conta{conta_id: conta_id, saldo: saldo},
         valor
       ) do
    Logger.info("Pagamento no debito no Pix no valor de #{valor} reais")
    new_saldo = saldo - valor

    Contas.update_saldo(%{"conta_id" => conta_id, "saldo" => new_saldo})

    {:ok,
     %{
       "conta_id" => conta_id,
       "saldo" => new_saldo
     }}
  end
end
