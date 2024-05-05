defmodule ObjBaking.Transactions.Transaction do
  @moduledoc """
  Module for make a transaction
  """
  require Logger

  alias ObjBaking.Persistence.Accounts

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
        }) ::
          {:ok, map()}
          | {:error, :invalid_payment}
          | {:error, :account_not_found}
          | {:error, :account_no_balance}
  def transaction(%{"forma_pagamento" => forma_pagamento} = args) do
    case Accounts.get_conta(args["conta_id"]) do
      {:error, :account_not_found} ->
        {:error, :account_not_found}

      account ->
        Logger.info("Starting transaction")

        with {:saldo, new_saldo} <-
               define_payment(forma_pagamento, account.saldo, args["valor"]),
             {:ok, account_updated} <-
               Accounts.update_transaction(%{"conta_id" => account.conta_id, "saldo" => new_saldo}) do
          {:ok, %{"conta_id" => account_updated.conta_id, "saldo" => account_updated.saldo}}
        end
    end
  end

  defp define_payment("D", saldo, valor) do
    Logger.info("Payment on debit with a value of #{valor} reais")
    saldo_result = saldo - valor * 1.03
    new_saldo = Float.ceil(saldo_result, 2)
    {:saldo, new_saldo}
  end

  defp define_payment("C", saldo, valor) do
    Logger.info("Credit payment with a value of #{valor} reais")
    saldo_result = saldo - valor * 1.0
    new_saldo = Float.ceil(saldo_result, 2)
    {:saldo, new_saldo}
  end

  defp define_payment("P", saldo, valor) do
    Logger.info("Payment on Pix with a value of #{valor} reais")
    saldo_result = saldo - valor
    new_saldo = Float.ceil(saldo_result, 2)
    {:saldo, new_saldo}
  end

  defp define_payment(forma_pagamento, _saldo, _valor) do
    Logger.info("Invalid method of payment #{forma_pagamento} ")
    {:error, :invalid_payment}
  end
end
