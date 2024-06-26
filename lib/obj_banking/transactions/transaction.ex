defmodule ObjBanking.Transactions.Transaction do
  @moduledoc """
  Module for make a transaction
  """
  require Logger

  alias ObjBanking.Persistence.Accounts

  @doc """
  Receive the call to make a transaction and defines de type of operation
  ## Examples

      iex>  ObjBanking.Transactions.Transaction.operation(%{
          "conta_id" => 10,
          "valor" => 10,
          "forma_pagamento" => "D"
        })

  """
  @spec operation(%{
          :forma_pagamento => String.t(),
          :valor => Integer.t(),
          :conta_id => Integer.t()
        }) ::
          {:ok, %{:conta_id => Integer.t(), :saldo => Integer.t()}}
          | {:error, :invalid_payment}
          | {:error, :account_not_found}
          | {:error, :account_no_balance}
          | {:error, :value_under_zero}
  def operation(%{"forma_pagamento" => forma_pagamento} = args) do
    case Accounts.get_account(args["conta_id"]) do
      {:error, :account_not_found} ->
        {:error, :account_not_found}

      {:ok, account} ->
        Logger.info("Starting Operation")

        with {:ok, value} <- verify_value(args["valor"]),
             {:saldo, new_saldo} <-
               define_type(forma_pagamento, account.saldo, value),
             {:ok, account_updated} <-
               Accounts.update_account(%{"conta_id" => account.conta_id, "saldo" => new_saldo}) do
          {:ok, %{"conta_id" => account_updated.conta_id, "saldo" => account_updated.saldo}}
        end
    end
  end

  defp verify_value(value) when value >= 0 do
    {:ok, value}
  end

  defp verify_value(_value) do
    {:error, :value_under_zero}
  end

  defp define_type("D", saldo, valor) do
    Logger.info("Payment on debit with a value of #{valor} reais")
    saldo_result = saldo - valor * 1.03
    new_saldo = Float.ceil(saldo_result, 2)
    {:saldo, new_saldo}
  end

  defp define_type("C", saldo, valor) do
    Logger.info("Credit payment with a value of #{valor} reais")
    saldo_result = saldo - valor * 1.05
    new_saldo = Float.ceil(saldo_result, 2)
    {:saldo, new_saldo}
  end

  defp define_type("P", saldo, valor) do
    Logger.info("Payment on Pix with a value of #{valor} reais")
    saldo_result = saldo - valor
    new_saldo = Float.ceil(saldo_result, 2)
    {:saldo, new_saldo}
  end

  defp define_type("U", saldo, valor) do
    Logger.info("Update balance with value of #{valor} reais")
    saldo_result = saldo + valor
    new_saldo = Float.ceil(saldo_result, 2)
    {:saldo, new_saldo}
  end

  defp define_type(forma_pagamento, _saldo, _valor) do
    Logger.info("Invalid method of payment #{forma_pagamento} ")
    {:error, :invalid_payment}
  end
end
