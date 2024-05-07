defmodule ObjBankingWeb.AccountControllerTest do
  use ObjBankingWeb.ConnCase, async: true

  alias ObjBanking.Persistence
  alias Persistence.Accounts

  setup_all do
    Accounts.create_account(%{"conta_id" => 12, "saldo" => 500.0})
    :ok
  end

  describe "get_account/2" do
    test "return a json format account", %{conn: conn} do
      conn = get(conn, ~p"/api/conta/?id=12")

      assert "{\"conta_id\":12,\"saldo\":500.0}" = json_response(conn, 200)
    end

    test "return a {:error, :account_not_fount}", %{conn: conn} do
      conn = get(conn, ~p"/api/conta/?id=500")

      assert "account_not_found" = json_response(conn, 404)
    end
  end

  describe "create_account/2" do
    test "return a json format account created", %{conn: conn} do
      conn =
        post(conn, ~p"/api/conta", %{
          conta_id: 13,
          saldo: 500
        })

      assert "{\"conta_id\":13,\"saldo\":500.0}" = json_response(conn, 201)
    end
  end
end
