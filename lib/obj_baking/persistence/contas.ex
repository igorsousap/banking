defmodule ObjBaking.Persistence.Contas do
  @moduledoc """
  Module for register account on database
  """
  alias ObjBaking.Repo
  alias ObjBaking.Persistence.Contas.Conta

  @doc """
  Receive a map to be inserted on database
  ## Examples

      iex> ObjBaking.Persistence.Contas.create_conta(%{
         "conta_id" => 2,
          "saldo" => 500.0
        })

  """
  @spec create_conta(%{:conta_id => Integer.t(), :saldo => Float.t()}) ::
          {:ok, %ObjBaking.Persistence.Contas.Conta{}} | {:error, :conta_id_alredy_exists}
  def create_conta(params) do
    params
    |> build_changeset()
    |> Conta.changeset()
    |> Repo.insert()
  end

  @doc """
  Receive a id and return an account
  ## Examples

      iex> ObjBaking.Persistence.Contas.get_conta(10)

  """
  @spec get_conta(Integer.t()) ::
          %ObjBaking.Persistence.Contas.Conta{} | {:error, :not_found}
  def get_conta(conta_id) do
    account =
      conta_id
      |> Conta.query()
      |> Repo.all()

    case account do
      [] ->
        {:error, :account_not_found}

      [account | _tail] ->
        account
    end
  end

  @doc """
  Receive a account id to be updated on database
  ## Examples

      iex> ObjBaking.Persistence.Contas.update_saldo(%{
          "conta_id" => 10,
          "saldo" => 100
        })

  """
  @spec update_saldo(%{
          :conta_id => Integer.t(),
          :saldo => Integer.t()
        }) ::
          {:ok, %ObjBaking.Persistence.Contas.Conta{}} | {:error, :not_found}
  def update_saldo(params) do
    account = Conta.query(params["conta_id"]) |> Repo.all()

    case account do
      [] ->
        {:error, :account_not_fount}

      account ->
        account
        |> List.first()
        |> Conta.changeset(params)
        |> Repo.update()
    end
  end

  defp build_changeset(%{"saldo" => saldo, "conta_id" => conta_id}) do
    %{
      conta_id: conta_id,
      saldo: saldo
    }
  end
end
