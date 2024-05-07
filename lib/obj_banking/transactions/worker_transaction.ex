defmodule ObjBanking.Transaction.WorkerTransaction do
  use Oban.Worker, queue: :schedule, max_attempts: 1
  require Logger

  alias ObjBanking.Transactions.Transaction

  @impl Oban.Worker
  @spec perform(Oban.Job.t()) ::
          {:ok, %{:conta_id => Integer.t(), :saldo => Integer.t()}}
          | {:error, :invalid_payment}
          | {:error, :account_not_found}
          | {:error, :account_no_balance}
          | {:error, :value_under_zero}
  def perform(%Oban.Job{args: args}) do
    with {:ok, _} <-
           Transaction.operation(%{
             "forma_pagamento" => args.forma_pagamento,
             "valor" => args.valor,
             "conta_id" => args.conta_id
           }) do
      Logger.info("Success making the transaction ")

      {:ok,
       %{
         "forma_pagamento" => args.forma_pagamento,
         "valor" => args.valor,
         "conta_id" => args.conta_id
       }}
    end
  end
end
