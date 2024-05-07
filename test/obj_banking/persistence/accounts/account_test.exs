defmodule ObjBanking.Persistence.Accounts.AccountTest do
  use ExUnit.Case, async: true

  alias ObjBanking.Persistence.Accounts.Account

  describe "changeset/2" do
    test "should return a valid changeset when given right params" do
      params = %{conta_id: 1, saldo: 500.0}

      assert %Ecto.Changeset{valid?: true} = Account.changeset(params)
    end

    test "should return a invalid changeset when given a balance lower than 0" do
      params = %{conta_id: 1, saldo: -1.0}

      assert %Ecto.Changeset{valid?: false} = Account.changeset(params)
    end
  end

  describe "query_account_id/1" do
    test "should return a query when givin a id" do
      conta_id = 1

      assert %Ecto.Query{} = Account.query_account_id(conta_id)
    end
  end
end
