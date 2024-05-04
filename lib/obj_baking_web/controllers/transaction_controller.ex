defmodule ObjBakingWeb.TransactionController do
  use ObjBakingWeb, :controller
  alias ObjBaking.Transactions.Transaction

  plug :accepts, ~w(json ...)

  def register_transaction(conn, params) do
    case Transaction.transaction(params) do
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
