defmodule ObjBakingWeb.AccountJSON do
  def index(_assings = %{conta: {:ok, data}}) do
    data
  end

  def index(_assigns = %{error: error}) do
    error
  end
end
