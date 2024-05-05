defmodule ObjBakingWeb.ContaController do
  use ObjBakingWeb, :controller
  alias ObjBaking.Persistence.Accounts

  plug :accepts, ~w(json ...)

  def get_conta(conn, params) do
    case Accounts.get_conta(params["id"]) do
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

  def create_conta(conn, params) do
    case Accounts.create_conta(params) do
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

  def update_conta(conn, %{"valor" => valor} = params) do
    case Accounts.update_saldo(%{"saldo" => valor, "conta_id" => params["conta_id"]}) do
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
