defmodule ObjBaking.Persistence.Contas.Conta do
  @moduledoc """
  Ecto changeset for validation the struct to be sabed and query for get and update
  """
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  schema "conta" do
    field(:saldo, :float)
    field(:saldo_anterior, :float, default: 0.0)

    timestamps()
  end

  @fields [:saldo, :saldo_anterior]

  @doc """
  Can receive a struct for update a data or nothing and return a empyt struct to be created on database
  ## Examples
    case for a update a existing data
      iex> ObjBaking.Persistence.Contas.Conta.changeset(
         %ObjBaking.Persistence.Contas.Conta{
                   saldo: 10.0,
                   saldo_anterior: 20.0
                 },
          %{
          saldo: 60.0,
          saldo_anterior: 10.0,
          })
  Case for a insert a new data
      iex> ObjBaking.Persistence.Contas.Conta.changeset(
        %{
          saldo: 500.0,
          saldo_anterior: 0.0,
        })

  """
  @spec changeset(%{optional(:__struct__) => none(), optional(atom() | binary()) => any()}) ::
          Ecto.Changeset.t()
  def changeset(conta \\ %__MODULE__{}, params) do
    conta
    |> cast(params, @fields)
    |> validate_required([:saldo])
    |> validate_number(:saldo, greater_than_or_equal_to: 0)
    |> validate_number(:saldo_anterior, greater_than_or_equal_to: 0)
  end

  @spec query(%{:id => Integer.t()}) :: Ecto.Query.t()
  def query(%{"id" => id} = _parametros) do
    query =
      from(c in __MODULE__,
        where: c.id == ^id
      )

    query
  end
end
