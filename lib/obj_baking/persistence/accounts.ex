defmodule ObjBaking.Persistence.Accounts do
  @moduledoc """
  Module for register account on database
  """
  require Logger

  alias ObjBaking.Repo
  alias ObjBaking.Persistence.Accounts.Account

  @doc """
  Receive a map to be inserted on database
  ## Examples

      iex> ObjBaking.Persistence.Accounts.create_conta(%{
         "conta_id" => 2,
          "saldo" => 500.0
        })

  """
  @spec create_conta(%{:conta_id => Integer.t(), :saldo => Float.t()}) ::
          {:ok, %ObjBaking.Persistence.Accounts.Account{}} | {:error, :conta_id_alredy_exists}
  def create_conta(params) do
    account =
      params
      |> build_changeset()
      |> Account.changeset()

    case Repo.insert(account) do
      {:error, _changeset} ->
        Logger.error("Account alredy created")
        {:error, :account_alredy_exists}

      {:ok, changeset} ->
        Logger.info("Account created")
        {:ok, changeset}
    end
  end

  @doc """
  Receive a id and return an account
  ## Examples

      iex> ObjBaking.Persistence.Accounts.get_conta(10)

  """
  @spec get_conta(Integer.t()) ::
          {:ok, %ObjBaking.Persistence.Accounts.Account{}} | {:error, :account_not_found}
  def get_conta(conta_id) do
    account =
      conta_id
      |> Account.query_account_id()
      |> Repo.all()

    case account do
      [] ->
        {:error, :account_not_found}

      [account | _tail] ->
        {:ok, account}
    end
  end

  @doc """
  Receive a account id to be updated on database
  ## Examples

      iex> ObjBaking.Persistence.Accounts.update_saldo(%{
          "conta_id" => 10,
          "saldo" => 100
        })

  """
  @spec update_transaction(%{
          :conta_id => Integer.t(),
          :saldo => Float.t()
        }) ::
          {:ok, %ObjBaking.Persistence.Accounts.Account{}}
          | {:error, :account_not_found}
          | {:error, :account_no_balance}
  def update_transaction(params) do
    case Account.query_account_id(params["conta_id"]) |> Repo.all() do
      [] ->
        {:error, :account_not_fount}

      account ->
        with account_for_update <- List.first(account),
             %Ecto.Changeset{valid?: true} = changeset <-
               Account.changeset(account_for_update, params),
             account_updated <- Repo.update(changeset) do
          account_updated
        else
          %Ecto.Changeset{valid?: false, errors: _errors} ->
            {:error, :account_no_balance}
        end
    end
  end

  @spec update_saldo(%{
          :conta_id => Integer.t(),
          :saldo => Float.t()
        }) ::
          {:ok, %ObjBaking.Persistence.Accounts.Account{}}
          | {:error, :account_not_found}
  def update_saldo(params) do
    case Account.query_account_id(params["conta_id"]) |> Repo.all() do
      [] ->
        {:error, :account_not_fount}

      account ->
        with account_for_update <- List.first(account),
             new_saldo <- account_for_update.saldo + params["saldo"],
             %Ecto.Changeset{valid?: true} = changeset <-
               Account.changeset(account_for_update, %{"saldo" => new_saldo}),
             account_updated <- Repo.update(changeset) do
          account_updated
        end
    end
  end

  defp build_changeset(%{"saldo" => saldo, "conta_id" => conta_id}) do
    %{
      conta_id: conta_id,
      saldo: saldo
    }
  end
end
