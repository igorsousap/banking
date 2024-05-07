defmodule ObjBanking.Transactions.TransactionSchedule do
  require Logger

  @doc """
  Receive the operation need to be schedule
  ## Examples

      iex>  ObjBanking.Transactions.TransactionEschedule.operation_schedule(%{
          "conta_id" => 10,
          "valor" => 10,
          "forma_pagamento" => "D",
          "schedule_at" => "2024-05-06"
        })

  """

  @spec operation_schedule(%{
          :valor => Float.t(),
          :forma_pagamento => String.t(),
          :conta_id => Integer.t(),
          schedule_at: DateTime.t()
        }) ::
          [Oban.Job.t()]
  def operation_schedule(args) do
    Logger.info("Message was been schedule at: #{args["schedule_at"]}")

    schedule_at =
      args["schedule_at"]
      |> Date.from_iso8601!()
      |> DateTime.new!(~T[00:00:01Z])

    args
    |> ObjBanking.Transaction.WorkerTransaction.new(scheduled_at: schedule_at)
    |> Oban.insert()

    {:ok, :transaction_schedule}
  end
end
