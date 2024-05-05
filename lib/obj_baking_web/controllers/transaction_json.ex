defmodule ObjBakingWeb.TransactionJSON do
  def index(_assigns = %{transaction: {:ok, data}}) do
    data
  end

  def index(_assigns = %{error: error}) do
    %{error: error}
  end
end
