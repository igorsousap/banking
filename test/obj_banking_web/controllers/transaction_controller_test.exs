defmodule ObjBankingWeb.TransactionControllerTest do
  use ObjBankingWeb.ConnCase, async: true

  alias ObjBanking.Persistence
  alias Persistence.Accounts

  setup_all do
    Accounts.create_account(%{"conta_id" => 14, "saldo" => 500.0})
    :ok
  end

  describe "register_transaction/2" do
    test "shold return a json with account with a new saldo after debit type transaction", %{
      conn: conn
    } do
      conn =
        post(conn, ~p"/api/transacao", %{
          forma_pagamento: "D",
          conta_id: 14,
          valor: 10
        })

      assert "{\"conta_id\":14,\"saldo\":489.7}" = json_response(conn, 201)
    end

    test "shold return a json with account with a new saldo after credit type transaction", %{
      conn: conn
    } do
      conn =
        post(conn, ~p"/api/transacao", %{
          forma_pagamento: "C",
          conta_id: 14,
          valor: 10
        })

      assert "{\"conta_id\":14,\"saldo\":489.5}" = json_response(conn, 201)
    end

    test "shold return a json with account with a new saldo after PIX type transaction", %{
      conn: conn
    } do
      conn =
        post(conn, ~p"/api/transacao", %{
          forma_pagamento: "P",
          conta_id: 14,
          valor: 10
        })

      assert "{\"conta_id\":14,\"saldo\":490.0}" = json_response(conn, 201)
    end

    test "shold return a json with {:error, :account_not_found}", %{
      conn: conn
    } do
      conn =
        post(conn, ~p"/api/transacao", %{
          forma_pagamento: "P",
          conta_id: 15,
          valor: 10
        })

      assert %{"error" => "account_not_found"} = json_response(conn, 404)
    end

    test "shold return a json with  {:error, :account_no_balance}", %{
      conn: conn
    } do
      conn =
        post(conn, ~p"/api/transacao", %{
          forma_pagamento: "P",
          conta_id: 14,
          valor: 501
        })

      assert %{"error" => "account_no_balance"} = json_response(conn, 405)
    end

    test "return a json format erro with {:error, :invalid_payment}", %{conn: conn} do
      conn =
        post(conn, ~p"/api/transacao", %{
          forma_pagamento: "X",
          conta_id: 14,
          valor: 501
        })

      assert %{"error" => "invalid_payment"} = json_response(conn, 405)
    end
  end

  describe "update_balance/2" do
    test "should return a account with a new balance", %{conn: conn} do
      conn =
        put(conn, ~p"/api/conta", %{
          conta_id: 14,
          valor: 120
        })

      assert "{\"conta_id\":14,\"saldo\":620.0}" = json_response(conn, 201)
    end

    test "should return a {:error, :account_not_found}", %{conn: conn} do
      conn =
        put(conn, ~p"/api/conta", %{
          conta_id: 15,
          valor: 120
        })

      assert %{"error" => "account_not_found"} = json_response(conn, 404)
    end
  end
end
