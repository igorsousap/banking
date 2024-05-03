defmodule ObjBaking.Persistence.Contas do
  @moduledoc """
  Module for register account on database
  """
  alias Logger.Backends.Internal
  alias ObjBaking.Repo
  alias ObjBaking.Persistence.Contas.Conta

  @doc """
  Receive a map to be inserted on database
  ## Examples

      iex> ObjBaking.Persistence.Contas.create_conta(%{
          "saldo" => 500.0
        })

  """
  @spec create_conta(%{:saldo => Float.t()}) :: {:ok, %ObjBaking.Persistence.Contas.Conta{}}
  def create_conta(parametros) do
    parametros
    |> build_changeset()
    |> Conta.changeset()
    |> Repo.insert()
  end

  @doc """
  Receive a id and return an account
  ## Examples

      iex> ObjBaking.Persistence.Contas.get_conta(%{
          "id" => 1
        })

  """
  @spec get_conta(%{:id => Integer.t()}) ::
          Ecto.Schema.t() | {:error, :not_found}
  def get_conta(parametros) do
    account =
      parametros
      |> Conta.query()
      |> Repo.all()

    case account do
      [] ->
        {:error, :account_not_fount}

      [account | _tail] ->
        account
    end
  end

  @doc """
  Receive a account id to be updated on database
  ## Examples

      iex> ObjBaking.Persistence.Contas.update_saldo(%{
          "id" => 1,
          "saldo" => 100,
          "saldo_anterior" => 120
        })

  """

  @spec update_saldo(%{:id => Integer.t(), :saldo => Internal.t(), :saldo_anterior => Integer.t()}) ::
          {:ok, %ObjBaking.Persistence.Contas.Conta{}} | {:error, :not_found}
  def update_saldo(parametros) do
    account = Conta.query(%{"id" => parametros["id"]}) |> Repo.all()

    case account do
      [] ->
        {:error, :account_not_fount}

      account ->
        account
        |> List.first()
        |> Conta.changeset(parametros)
        |> Repo.update()
    end
  end

  defp build_changeset(%{"saldo" => saldo}) do
    %{
      saldo: saldo
    }
  end
end
