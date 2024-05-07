defmodule ObjBanking.Transactions.TransactionTest do
  use ExUnit.Case

  alias ObjBanking.Transactions.Transaction
  alias ObjBanking.Persistence.Accounts

  setup_all do
    Accounts.create_account(%{"conta_id" => 1, "saldo" => 500.0})
    Accounts.create_account(%{"conta_id" => 2, "saldo" => 500.0})
    Accounts.create_account(%{"conta_id" => 3, "saldo" => 500.0})
    Accounts.create_account(%{"conta_id" => 4, "saldo" => 500.0})
    :ok
  end

  describe "operation/1" do
    test "should make a transaction in debit with the righ params" do
      transaction = %{"conta_id" => 1, "valor" => 10, "forma_pagamento" => "D"}
      assert {:ok, %{"conta_id" => 1, "saldo" => 489.7}} == Transaction.operation(transaction)
    end

    test "should make a transaction in credit with the righ params" do
      transaction = %{"conta_id" => 2, "valor" => 10, "forma_pagamento" => "C"}
      assert {:ok, %{"conta_id" => 2, "saldo" => 489.5}} == Transaction.operation(transaction)
    end

    test "should make a transaction in pix with the righ params" do
      transaction = %{"conta_id" => 3, "valor" => 10, "forma_pagamento" => "P"}
      assert {:ok, %{"conta_id" => 3, "saldo" => 490.0}} == Transaction.operation(transaction)
    end

    test "should make a update given the righ params" do
      transaction = %{"conta_id" => 4, "valor" => 10, "forma_pagamento" => "U"}
      assert {:ok, %{"conta_id" => 4, "saldo" => 510.0}} == Transaction.operation(transaction)
    end

    test "should given {:error, :invalid_payment} when passed wrong paymente method" do
      transaction = %{"conta_id" => 4, "valor" => 10, "forma_pagamento" => "X"}
      assert {:error, :invalid_payment} == Transaction.operation(transaction)
    end

    test "should given {:error, :account_not_found} when passed a non existing account_id" do
      transaction = %{"conta_id" => 5, "valor" => 10, "forma_pagamento" => "C"}
      assert {:error, :account_not_found} == Transaction.operation(transaction)
    end

    test "should given {:error, :account_no_balance} when passed a value from account" do
      transaction = %{"conta_id" => 4, "valor" => 500, "forma_pagamento" => "C"}
      assert {:error, :account_no_balance} == Transaction.operation(transaction)
    end

    test "should given {:error, :value_under_zero} when passed a value negative" do
      transaction = %{"conta_id" => 4, "valor" => -500.0, "forma_pagamento" => "C"}
      assert {:error, :value_under_zero} == Transaction.operation(transaction)
    end
  end
end
