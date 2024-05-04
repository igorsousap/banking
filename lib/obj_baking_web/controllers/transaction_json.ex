defmodule ObjBakingWeb.TransactionJSON do
  def index(_assigns = %{transaction: {:ok, data}}) do
    data
  end

  def index(_assigns) do
    %{error: :account_not_found}
  end
end
