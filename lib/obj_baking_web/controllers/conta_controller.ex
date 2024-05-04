defmodule ObjBakingWeb.ContaController do
  use ObjBakingWeb, :controller
  alias ObjBaking.Persistence.Contas

  plug :accepts, ~w(json ...)

  def get_conta(conn, params) do
    case Contas.get_conta(params["id"]) do
      {:error, error} ->
        conn
        |> put_status(404)
        |> render(:index, error: error)

      body ->
        conta = build_conta(body)

        conn
        |> put_status(200)
        |> render(:index, conta: Jason.encode(conta))
    end
  end

  def create_conta(conn, params) do
    case Contas.create_conta(params) do
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

  defp build_conta(%ObjBaking.Persistence.Contas.Conta{conta_id: conta_id, saldo: saldo}) do
    %{"conta_id" => conta_id, "saldo" => saldo}
  end
end
