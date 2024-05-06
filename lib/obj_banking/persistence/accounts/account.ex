defmodule ObjBanking.Persistence.Accounts.Account do
  @moduledoc """
  Ecto changeset for validation the struct to be sabed and query for get and update
  """
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:conta_id, :integer, autogenerate: false}
  schema "conta" do
    field(:saldo, :float)

    timestamps()
  end

  @fields [:saldo, :conta_id]

  @doc """
  Can receive a struct for update a data or nothing and return a empty struct to be created on database
  ## Examples
    case for a update a existing data
      iex> ObjBanking.Persistence.Contas.Conta.changeset(
         %ObjBanking.Persistence.Contas.Conta{
                   saldo: 10.0
                 },
          %{
          saldo: 60.0
          })
  Case for a insert a new data
      iex> ObjBanking.Persistence.Contas.Conta.changeset(
        %{
          saldo: 500.0
        })

  """
  @spec changeset(%{optional(:__struct__) => none(), optional(atom() | binary()) => any()}) ::
          Ecto.Changeset.t()
  def changeset(conta \\ %__MODULE__{}, params) do
    conta
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:saldo, greater_than_or_equal_to: 0)
    |> unique_constraint(:conta_id, name: :conta_pkey)
  end

  @spec query_account_id(Integer.t()) :: Ecto.Query.t()
  def query_account_id(conta_id) do
    query =
      from(c in __MODULE__,
        where: c.conta_id == ^conta_id
      )

    query
  end
end
