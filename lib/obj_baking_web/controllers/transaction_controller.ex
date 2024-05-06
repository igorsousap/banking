defmodule ObjBakingWeb.TransactionController do
  use ObjBakingWeb, :controller
  alias ObjBaking.Transactions.Transaction

  plug :accepts, ~w(json ...)

  @spec register_transaction(Plug.Conn.t(), %{
          conta_id: Integer.t(),
          forma_pagamento: String.t(),
          valor: Integer.t()
        }) :: Plug.Conn.t()
  def register_transaction(conn, params) do
    case Transaction.operation(params) do
      {:error, :account_not_found} ->
        conn
        |> put_status(404)
        |> render(:index, error: :account_not_found)

      {:error, error} ->
        conn
        |> put_status(405)
        |> render(:index, error: error)

      {:ok, body} ->
        conn
        |> put_status(201)
        |> render(:index, transaction: Jason.encode(body))
    end
  end

  @spec update_balance(Plug.Conn.t(), %{:conta_id => Integer.t(), :valor => Integer.t()}) ::
          Plug.Conn.t()
  def update_balance(conn, params) do
    case Transaction.operation(%{
           "forma_pagamento" => "U",
           "conta_id" => params["conta_id"],
           "valor" => params["valor"]
         }) do
      {:error, error} ->
        conn
        |> put_status(404)
        |> render(:index, error: error)

      {:ok, body} ->
        conn
        |> put_status(201)
        |> render(:index, transaction: Jason.encode(body))
    end
  end
end
