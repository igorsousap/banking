defmodule ObjBakingWeb.AccountController do
  use ObjBakingWeb, :controller
  alias ObjBaking.Persistence.Accounts

  plug :accepts, ~w(json ...)

  @spec get_account(Plug.Conn.t(), %{:id => Integer.t()}) :: Plug.Conn.t()
  def get_account(conn, params) do
    case Accounts.get_account(params["id"]) do
      {:error, error} ->
        conn
        |> put_status(404)
        |> render(:index, error: error)

      {:ok, body} ->
        conta = build_conta(body)

        conn
        |> put_status(200)
        |> render(:index, conta: Jason.encode(conta))
    end
  end

  @spec create_account(Plug.Conn.t(), %{:conta_id => Integer.t(), :saldo => Integer.t()}) ::
          Plug.Conn.t()
  def create_account(conn, params) do
    case Accounts.create_account(params) do
      {:error, error} ->
        conn
        |> put_status(404)
        |> render(:index, error: error)

      {:ok, body} ->
        conta = build_conta(body)

        conn
        |> put_status(201)
        |> render(:index, conta: Jason.encode(conta))
    end
  end

  defp build_conta(%ObjBaking.Persistence.Accounts.Account{conta_id: conta_id, saldo: saldo}) do
    %{"conta_id" => conta_id, "saldo" => saldo}
  end
end
