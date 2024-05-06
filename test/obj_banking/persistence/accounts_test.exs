defmodule ObjBanking.Persistence.AccountsTest do
  use ExUnit.Case, async: true

  alias ObjBanking.Persistence.Accounts

  describe "create_account/1" do
    test "should create a account as givin the righ params" do
      params = %{"conta_id" => 6, "saldo" => 500.0}

      assert {:ok, %ObjBanking.Persistence.Accounts.Account{conta_id: 6, saldo: 500.0}} =
               Accounts.create_account(params)
    end

    test "should return {:error, :conta_id_alredy_exists} when passed a conta_id repited" do
      params = %{"conta_id" => 7, "saldo" => 500.0}

      assert {:ok, %ObjBanking.Persistence.Accounts.Account{conta_id: 7, saldo: 500.0}} =
               Accounts.create_account(params)

      assert {:error, :account_alredy_exists} = Accounts.create_account(params)
    end

    test "should return {:error, :balance_under_zero} when passed a value under zero" do
      params = %{"conta_id" => 8, "saldo" => -1.0}

      assert {:error, :balance_under_zero} =
               Accounts.create_account(params)
    end
  end

  describe "get_account/1" do
    test "should get a account as givin the id" do
      Accounts.create_account(%{"conta_id" => 9, "saldo" => 500.0})
      id = 9

      assert {:ok, %ObjBanking.Persistence.Accounts.Account{conta_id: 9, saldo: 500.0}} =
               Accounts.get_account(id)
    end

    test "should {:error, :account_not_found} when passed a non existing account_id" do
      id = 500

      assert {:error, :account_not_found} = Accounts.get_account(id)
    end
  end

  describe "update_account/1" do
    test "should update a account balance when passed a new value" do
      Accounts.create_account(%{"conta_id" => 10, "saldo" => 500.0})

      new_value = %{"conta_id" => 10, "saldo" => 550.0}

      assert {:ok, %ObjBanking.Persistence.Accounts.Account{conta_id: 10, saldo: 550.0}} =
               Accounts.update_account(new_value)
    end

    test "should {:error, :account_no_balance} when passed a new value under 0" do
      Accounts.create_account(%{"conta_id" => 1234, "saldo" => 500.0})
      new_value = %{"conta_id" => 1234, "saldo" => -1}

      assert {:error, :account_no_balance} = Accounts.update_account(new_value)
    end

    test "should {:error, :account_not_fount} when passed id id no exist" do
      new_value = %{"conta_id" => 500, "saldo" => -1}

      assert {:error, :account_not_fount} = Accounts.update_account(new_value)
    end
  end
end
