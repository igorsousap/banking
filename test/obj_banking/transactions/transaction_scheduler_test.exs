defmodule ObjBanking.Transactions.TransactionSchedulerTest do
  use ExUnit.Case, async: true

  alias ObjBanking.Transactions.TransactionSchedule

  describe "operation_schedule/1" do
    test "should return {:ok, :transaction_schedule}" do
      operation = %{
        "conta_id" => 10,
        "valor" => 10,
        "forma_pagamento" => "D",
        "schedule_at" => "2024-05-06"
      }

      assert {:ok, :transaction_schedule} = TransactionSchedule.operation_schedule(operation)
    end
  end
end
